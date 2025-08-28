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
    owner = "ful1e5";
    repo = "Bibata_Cursor";
    rev = "v${version}";
    hash = "sha256-kIKidw1vditpuxO1gVuZeUPdWBzkiksO/q2R/+DUdEc=";
  };

  nativeBuildInputs = [
    clickgen
    cbmp
    python3
    python3.pkgs.attrs
    python3.pkgs.pillow
  ];

  buildPhase = ''
        runHook preBuild

        # Patch render.json to add rose pine variants
        python3 -c "
    import json

    # Read the original render.json
    with open('render.json', 'r') as f:
        config = json.load(f)

    # Add rose pine variants
    config['Bibata-Modern-RosePine'] = {
        'dir': 'svg/modern',
        'out': 'bitmaps/Bibata-Modern-RosePine',
        'colors': [
            { 'match': '#00FF00', 'replace': '#26233a' },
            { 'match': '#0000FF', 'replace': '#21202e' },
            { 'match': '#FF0000', 'replace': '#191724' }
        ]
    }

    config['Bibata-Original-RosePine'] = {
        'dir': 'svg/original',
        'out': 'bitmaps/Bibata-Original-RosePine',
        'colors': [
            { 'match': '#00FF00', 'replace': '#26233a' },
            { 'match': '#0000FF', 'replace': '#21202e' },
            { 'match': '#FF0000', 'replace': '#191724' }
        ]
    }

    # Write the patched render.json
    with open('render.json', 'w') as f:
        json.dump(config, f, indent=4)
    "

        # Build bitmaps with rose pine colors
        cbmp render.json

        # Build rose pine cursors
        ctgen configs/normal/x.build.toml -p x11 -d bitmaps/Bibata-Modern-RosePine -n 'Bibata-Modern-RosePine' -c 'Rose Pine Bibata modern XCursors'
        ctgen configs/normal/x.build.toml -p x11 -d bitmaps/Bibata-Original-RosePine -n 'Bibata-Original-RosePine' -c 'Rose Pine Bibata sharp edge XCursors'
        ctgen configs/right/x.build.toml -p x11 -d bitmaps/Bibata-Modern-RosePine -n 'Bibata-Modern-RosePine-Right' -c 'Rose Pine right-hand Bibata modern XCursors'
        ctgen configs/right/x.build.toml -p x11 -d bitmaps/Bibata-Original-RosePine -n 'Bibata-Original-RosePine-Right' -c 'Rose Pine right-hand Bibata sharp edge XCursors'

        runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    install -dm 0755 $out/share/icons
    cp -rf themes/* $out/share/icons/

    runHook postInstall
  '';

  meta = with lib; {
    description = "Material Based Rose Pine Cursor Theme";
    homepage = "https://github.com/ful1e5/Bibata_Cursor";
    license = licenses.gpl3Only;
    platforms = platforms.linux;
  };
}
