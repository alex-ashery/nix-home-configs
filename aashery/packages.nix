pkgs:
let
  pulseaudio_custom = pkgs.pulseaudio.overrideAttrs (old: {
    src = pkgs.fetchurl {
      url = http://freedesktop.org/software/pulseaudio/releases/pulseaudio-16.1.tar.xz;
      sha256 = "sha256-ju8yzpHUeXn5X9mpNec4zX63RjQw2rxyhjJRdR5QSuQ=";
    };
  });
in
with pkgs; [
    libnotify
    vlc
    pavucontrol
    joplin
    joplin-desktop
    (nerdfonts.override { fonts = [ "Meslo" ]; })
    acpi
    lua5_2
    kubectl
    k9s
    unzip
    yq
    kind
    ripgrep
    pulseaudio_custom
    calcurse
    # spectacle
    betterlockscreen
    timg
    nsxiv
    # TODO: for now these are installed together but should probably be packaged
    ddcutil
    (pkgs.buildEnv { name = "bright"; paths = [ ./. ]; })
]
