{ pkgs, inputs }:
with pkgs; [
    libnotify
    vlc
    pavucontrol
    joplin
    joplin-desktop
    nerd-fonts.meslo-lg
    acpi
    lua5_2
    unzip
    yq
    ripgrep
    pulseaudio
    calcurse
    # spectacle
    betterlockscreen
    timg
    nsxiv
    # TODO: for now these are installed together but should probably be packaged
    ddcutil
    (pkgs.buildEnv { name = "bright"; paths = [ ./. ]; })
    docker-compose
    pinentry-curses
    sops
    glow
    bind
    tcpdump
    avahi
    (python3.withPackages(ps: with ps; [ i3ipc pip ]))
    libreoffice-qt
    hunspell
    hunspellDicts.uk_UA
    inputs.llm-agents.packages.${pkgs.stdenv.hostPlatform.system}.codex
    hunspellDicts.th_TH
]
