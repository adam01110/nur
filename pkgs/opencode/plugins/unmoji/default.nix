{
  lib,
  fetchFromCodeberg,
  mkOpencodePlugin,
}:
mkOpencodePlugin rec {
  pname = "unmoji";
  version = "0.3.1";

  src = fetchFromCodeberg {
    owner = "bastiangx";
    repo = "opencode-${pname}";
    rev = version;
    hash = "sha256-5U6RSJTZBiCyQ7hKfQttcoH4iFUUfTMm2a/9xlM2ufw=";
  };

  dependencyHash = "sha256-mx5l95k3saYu7WYF7YDGziFZX9+YzZwk+UrogK1xlcQ=";

  postInstall = ''
    cd "$out"
    bun build src/index.ts --outdir dist --target node --format esm
  '';

  meta = with lib; {
    description = "OpenCode plugin that removes or replaces emojis";
    homepage = "https://codeberg.org/bastiangx/opencode-unmoji";
    license = licenses.mit;
  };
}
