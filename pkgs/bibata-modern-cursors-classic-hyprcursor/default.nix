{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  clickgen,
  cbmp,
  python3,
}:

stdenvNoCC.mkDerivation {
  pname = "bibata-cursors-classic";
  version = "2.0.7";

  src = fetchFromGitHub {
    owner = "adam01110";
    repo = "bibata-cursor";
    rev = "HEAD";
    hash = "";
  };

  nativeBuildInputs = [
    clickgen
    cbmp
    python3
  ];

  buildPhase = ''
    runHook preBuild

    # Build bitmaps
    cbmp render.json

    # Build xcursors
    ctgen build.toml -p x11 -d bitmaps/Bibata-Modern-Classic -n 'Bibata-Modern-Classic' -c 'Classic Bibata modern XCursors'

    # Build hyprcursors
    ./hyprcursor-build

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    # Build bitmaps
    cbmp render.json

    install -dm 0755 $out/share/icons
    cp -rf bin/* $out/share/icons/

    runHook postInstall
  '';

  meta = with lib; {
    description = "Bibata Modern Cursor (Classic & Left Variant)";
    homepage = "https://github.com/adam01110/bibata-cursor";
    license = licenses.gpl3Only;
    platforms = platforms.linux;
  };
}
