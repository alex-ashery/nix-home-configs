pkgs:
with pkgs; [
    (nerdfonts.override { fonts = [ "Meslo" ]; })
    yq
    ripgrep
    pkgs.unstable.codex
    bashInteractive
]
