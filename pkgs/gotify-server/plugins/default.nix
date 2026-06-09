{
  # keep-sorted start
  buildGoModule,
  callPackage,
  fetchurl,
  go,
  gotify-server,
  lib,
  stdenvNoCC,
  # keep-sorted end
}: let
  inherit
    (builtins)
    # keep-sorted start
    mapAttrs
    readDir
    removeAttrs
    # keep-sorted end
    ;
  inherit
    (lib)
    # keep-sorted start
    filterAttrs
    optionalString
    pipe
    platforms
    # keep-sorted end
    ;

  root = ./.;

  serverRev = gotify-server.passthru.rev;

  serverGoMod = fetchurl {
    url = "https://raw.githubusercontent.com/gotify/server/${serverRev}/go.mod";
    sha256 = "1ivdda4v694h89g84za33xznzy8540vam54apkmq1m2ddv53rj76";
  };

  mkGotifyPlugin = args @ {
    # keep-sorted start
    meta ? {},
    patchedSourceHash,
    pname,
    src,
    vendorHash,
    version,
    # keep-sorted end
    ...
  }: let
    patchedSrc = stdenvNoCC.mkDerivation {
      name = "${pname}-patched-src";
      inherit src;
      nativeBuildInputs = [go];
      outputHashAlgo = "sha256";
      outputHashMode = "recursive";
      outputHash = patchedSourceHash;

      buildPhase = ''
        export HOME=$TMPDIR
        cp ${serverGoMod} server-go.mod
        go run github.com/gotify/plugin-api/cmd/gomod-cap@v1.0.0 -from server-go.mod -to go.mod
        rm server-go.mod
        go mod tidy
      '';

      installPhase = ''
        mkdir -p $out
        cp -r . $out/
      '';
    };
  in
    buildGoModule (
      (removeAttrs args [
        # keep-sorted start
        "meta"
        "patchedSourceHash"
        # keep-sorted end
      ])
      // {
        pname = "gotify-${pname}";
        src = patchedSrc;
        inherit vendorHash version;

        proxyVendor = true;

        # keep-sorted start
        doCheck = false;
        env.CGO_ENABLED = 1;
        # keep-sorted end

        buildPhase = ''
          runHook preBuild
          go build -a -installsuffix cgo -ldflags "-w -s" -buildmode=plugin -o ${pname}.so .
          runHook postBuild
        '';

        installPhase = ''
          runHook preInstall
          install -Dm755 ${pname}.so $out/${pname}.so
          runHook postInstall
        '';

        meta =
          meta
          // {
            # keep-sorted start
            description = meta.description or "";
            license = meta.license or lib.licenses.unfree;
            platforms = meta.platforms or lib.platforms.linux;
            # keep-sorted end
          };
      }
    );

  call = name: callPackage (root + "/${name}") {inherit mkGotifyPlugin;};
in
  pipe root [
    readDir
    (filterAttrs (_: type: type == "directory"))
    (mapAttrs (name: _: call name))
  ]
  // {
    inherit mkGotifyPlugin;
  }
