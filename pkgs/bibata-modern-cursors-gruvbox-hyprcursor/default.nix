{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  fetchzip,
  clickgen,
  hyprcursor,
  xcur2png,
  bash,
}:

stdenvNoCC.mkDerivation rec {
  pname = "bibata-cursors-gruvbox-hyprcursor";
  version = "1.0.0";

  src = fetchFromGitHub {
    owner = "adam01110";
    repo = "bibata-cursor";
    rev = "${version}";
    hash = "sha256-dQmCgeCuFEzEFy5zzldAz4k4CFAtD1jCXSf5OqMAC3o=";
  };

  bitmaps = fetchzip {
    url = "https://github.com/adam01110/bibata-cursor/releases/download/${version}/Bibata-Modern-Gruvbox.zip";
    hash = "sha256-MHR5mhZJOXJsUvcJU41ZRe1dFFEcay93NbYllD4i4GM=";
  };

  nativeBuildInputs = [
    clickgen
    hyprcursor
    xcur2png
    bash
  ];

  buildPhase = ''
    runHook preBuild

    # Build xcursors
    ctgen build.toml -d $bitmaps -n 'Bibata-Modern-Classic' -c 'Classic Bibata modern XCursors'

    # Build hyprcursors
    bash hyprcursor-build.sh

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    install -dm 0755 $out/share/icons
    cp -rf bin/*-hyprcursor $out/share/icons/

    runHook postInstall
  '';

  meta = with lib; {
    description = "Bibata Modern Cursor (Gruvbox & Left Variant)";
    homepage = "https://github.com/adam01110/bibata-cursor";
    license = licenses.gpl3Only;
    platforms = platforms.linux;
  };
}
