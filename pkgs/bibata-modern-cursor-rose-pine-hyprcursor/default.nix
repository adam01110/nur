{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  clickgen,
  cbmp,
  python3,
}:

stdenvNoCC.mkDerivation rec {
  pname = "bibata-cursors-rose-pine";
  version = "2.0.7";

  src = fetchFromGitHub {
    owner = "adam01110";
    repo = "bibata-cursor";
    rev = "v${version}";
    hash = "";
  };

  nativeBuildInputs = [
    clickgen
    cbmp
    python3
  ];

  patchPhase = ''
    runHook prePatch

    # Override render.json
    cp ${./render.json} render.json

    runHook postPatch
  '';

  buildPhase = ''
    runHook preBuild

    # Build bitmaps
    cbmp render.json

    # Build xcursors
    ctgen build.toml -p x11 -d bitmaps/Bibata-Modern-RosePine -n 'Bibata-Modern-RosePine' -c 'Rose Pine Bibata modern XCursors'

    # build hyprcursors
    ./hyprcursor-build

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    install -dm 0755 $out/share/icons
    cp -rf bin/* $out/share/icons/

    runHook postInstall
  '';

  meta = with lib; {
    description = "Bibata Modern Cursor (RosePine & Left Variant)";
    homepage = "https://github.com/adam01110/bibata-cursor";
    license = licenses.gpl3Only;
    platforms = platforms.linux;
  };
}
