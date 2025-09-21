{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  fetchzip,
  clickgen,
  hyprcursor,
}:

stdenvNoCC.mkDerivation rec {
  pname = "bibata-cursors-rosepine-hyprcursor";
  version = "1.0.0";

  src = fetchFromGitHub {
    owner = "adam01110";
    repo = "bibata-cursor";
    rev = "${version}";
    hash = "sha256-M/S3zoNaBOto23O54L+PX0y+sHNy56BpkQNQ1gMdbgg=";
  };

  bitmaps = fetchzip {
    url = "https://github.com/adam01110/bibata-cursor/releases/download/${version}/Bibata-Modern-RosePine.zip";
    hash = "sha256-jHV7/ZuXnTOUIVg1fltCG8xk1iXptqnYDY0o5b6x4W0=";
  };

  nativeBuildInputs = [
    clickgen
    hyprcursor
  ];

  buildPhase = ''
    runHook preBuild

    # Build xcursors
    ctgen build.toml -d $src/Bibata-Modern-RosePine -n 'Bibata-Modern-RosePine' -c 'Rose Pine Bibata modern XCursors'

    # build hyprcursors
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
    description = "Bibata Modern Cursor (RosePine & Left Variant)";
    homepage = "https://github.com/adam01110/bibata-cursor";
    license = licenses.gpl3Only;
    platforms = platforms.linux;
  };
}
