{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  fetchzip,
  clickgen,
  hyprcursor,
  xcur2png,
}:

stdenvNoCC.mkDerivation rec {
  pname = "bibata-cursors-classic-hyprcursor";
  version = "1.0.0";

  src = fetchFromGitHub {
    owner = "adam01110";
    repo = "bibata-cursor";
    rev = "${version}";
    hash = "sha256-M/S3zoNaBOto23O54L+PX0y+sHNy56BpkQNQ1gMdbgg=";
  };

  bitmaps = fetchzip {
    url = "https://github.com/adam01110/bibata-cursor/releases/download/${version}/Bibata-Modern-Classic.zip";
    hash = "sha256-oV+igawdHK1wbAZhuACxvcNrddcpAoJ/eWJR88kSrvw=";
  };

  nativeBuildInputs = [
    clickgen
    hyprcursor
    xcur2png
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
    description = "Bibata Modern Cursor (Classic & Left Variant)";
    homepage = "https://github.com/adam01110/bibata-cursor";
    license = licenses.gpl3Only;
    platforms = platforms.linux;
  };
}
