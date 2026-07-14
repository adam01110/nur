{
  # keep-sorted start
  fetchFromGitHub,
  lib,
  mkHyprlandPlugin,
  # keep-sorted end
}:
mkHyprlandPlugin {
  pluginName = "hypr-kinetic-scroll";
  version = "0.4.0";

  src = fetchFromGitHub {
    owner = "savonovv";
    repo = "hypr-kinetic-scroll";
    rev = "1e77fb637b18bcc9d1f76f54212f5881d8b9223c";
    hash = "sha256-rYhrHXLqMOkiTCgub2s9s4CXoNkTrWq9Qsggq6oGjlQ=";
  };

  installPhase = ''
    runHook preInstall

    install -Dm755 hypr-kinetic-scroll.so $out/lib/libhypr-kinetic-scroll.so

    runHook postInstall
  '';

  meta = with lib; {
    # keep-sorted start
    description = "Hyprland plugin providing compositor-level kinetic scrolling for touchpads";
    homepage = "https://github.com/savonovv/hypr-kinetic-scroll";
    license = licenses.mit;
    platforms = platforms.linux;
    # keep-sorted end
  };
}
