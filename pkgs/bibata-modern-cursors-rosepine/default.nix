{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  fetchzip,
  clickgen,
}:

stdenvNoCC.mkDerivation rec {
  pname = "bibata-cursors-rosepine";
  version = "1.0.0";

  src = fetchFromGitHub {
    owner = "adam01110";
    repo = "bibata-cursor";
    rev = "${version}";
    hash = "sha256-dQmCgeCuFEzEFy5zzldAz4k4CFAtD1jCXSf5OqMAC3o=";
  };

  bitmaps = fetchzip {
    url = "https://github.com/adam01110/bibata-cursor/releases/download/${version}/Bibata-Modern-RosePine.zip";
    hash = "sha256-jHV7/ZuXnTOUIVg1fltCG8xk1iXptqnYDY0o5b6x4W0=";
  };

  nativeBuildInputs = [ clickgen ];

  buildPhase = ''
    runHook preBuild

    # Build xcursors
    ctgen build.toml -d $bitmaps -n 'Bibata-Modern-RosePine' -c 'Rose Pine Bibata modern XCursors'

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
