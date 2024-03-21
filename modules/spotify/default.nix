{ config, lib, pkgs, ... }:
{
  config = {
    home.packages = [ pkgs.spotify-tui ];
    services.spotifyd = {
      enable = true;
      settings.spotifyd = {
        username = "zyxama@gmail.com";
        password_cmd = lib.mkIf config.programs.password-store.enable "${config.home.homeDirectory}/.nix-profile/bin/pass spotify";
        backend = "pulseaudio";
      };
    };
  };
}
