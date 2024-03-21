{ inputs, outputs, lib, config, pkgs, ... }:

let
    uname = "aashery";
in
{
  fonts.fontconfig.enable = true;
  imports = import ./modules.nix;
  nixpkgs.overlays = [ outputs.overlays.unstable-packages ];

  home = {
    username = uname;
    homeDirectory = "/home/${uname}";
    packages = import ./packages.nix pkgs;
    sessionVariables.EDITOR = "vim";
    stateVersion = "20.09";
  };

  xsession = {
    enable = true;
    # place a script in the path expected by NixOS for starting the session
    scriptPath = ".hm-xsession";
  };

  # For each program in the list, generate an attributeSet for it enabling the program
  programs = pkgs.lib.genAttrs (import ./programs.nix) (
    program: {enable = true;}
  );

  # services with a config too simplistic to modularize
  services = {
    picom.enable = true;
    # betterlockscreen = {
    #   enable = true;
    #   arguments = [ "--off" "10" ];
    # };
    gammastep = {
      enable = true;
      provider = "geoclue2";
    };
    gpg-agent = {
      enable = true;
      extraConfig = ''
        pinentry-program ${pkgs.pinentry-curses}/bin/pinentry
      '';
    };
  };
  dconf.settings = {
    "org/virt-manager/virt-manager/connections" = {
      autoconnect = ["qemu:///system"];
      uris = ["qemu:///system"];
    };
  };
}
