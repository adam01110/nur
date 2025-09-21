{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  fetchzip,
  clickgen,
}:

stdenvNoCC.mkDerivation rec {
  pname = "bibata-cursors-classic";
  version = "1.0.0";

  src = fetchFromGitHub {
    owner = "adam01110";
    repo = "bibata-cursor";
    rev = "${version}";
    hash = "sha256-dQmCgeCuFEzEFy5zzldAz4k4CFAtD1jCXSf5OqMAC3o=";
  };

  bitmaps = fetchzip {
    url = "https://github.com/adam01110/bibata-cursor/releases/download/${version}/Bibata-Modern-Classic.zip";
    hash = "sha256-oV+igawdHK1wbAZhuACxvcNrddcpAoJ/eWJR88kSrvw=";
  };

  nativeBuildInputs = [
    clickgen

  ];

  buildPhase = ''
    runHook preBuild

    # Build xcursors
    ctgen build.toml -d $bitmaps -n 'Bibata-Modern-Classic' -c 'Classic Bibata modern XCursors'

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

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
