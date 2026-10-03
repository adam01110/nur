{
  # keep-sorted start
  fetchFromGitHub,
  lib,
  rustPlatform,
  # keep-sorted end
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "xberg";
  version = "1.3.3";

  src = fetchFromGitHub {
    owner = "xberg-io";
    repo = "xberg";
    tag = "v${finalAttrs.version}";
    hash = "sha256-+nkWIgrLZ7vx4wSOA9We/72cbw7S06wJKPxytAcpQ7s=";
  };

  cargoHash = "sha256-70Tm9T5gr9D1MmmhQkwlvfGRlvZCDYL92aYacQXj+fU=";
  cargoBuildFlags = ["--package" "xberg-cli"];
  cargoTestFlags = ["--package" "xberg-cli"];

  # Keep document parsers without OCR, model runtimes, or PDFium.
  buildNoDefaultFeatures = true;
  buildFeatures = [
    # keep-sorted start
    "core-cli"
    "formats-no-heic"
    # keep-sorted end
  ];

  doInstallCheck = true;
  installCheckPhase = ''
    runHook preInstallCheck
    export HOME="$TMPDIR"
    $out/bin/xberg --version
    printf '%s\n' '<html><body>DocumentExtractionSentinel</body></html>' > sample.html
    $out/bin/xberg extract sample.html --output-format text | grep -F DocumentExtractionSentinel
    runHook postInstallCheck
  '';

  meta = {
    # keep-sorted start
    description = "Document text extractor without OCR or ML runtimes";
    homepage = "https://xberg.io";
    license = lib.licenses.mit;
    mainProgram = "xberg";
    platforms = lib.platforms.unix;
    # keep-sorted end
  };
})
