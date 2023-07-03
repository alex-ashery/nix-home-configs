{ inputs, config, pkgs, ... }:

let
    uname = "aashery";
in
{
  fonts.fontconfig.enable = true;

  imports = import ./modules.nix;

  home = {
    username = uname;
    homeDirectory = "/home/${uname}";
    packages = import ./packages.nix pkgs;
    sessionVariables.EDITOR = "vim";
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

  services = {
    picom.enable = true;
    betterlockscreen = {
      enable = true;
      arguments = [ "--off" "10" ];
    };
    redshift = {
      enable = true;
      # TODO: automatic identification may be broken for a bit due to this issue https://discourse.nixos.org/t/redshift-with-geoclue2/13820
      latitude = 47.6;
      longitude = -122.3;
    };
  };
}
