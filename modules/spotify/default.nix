{ config, lib, pkgs, ... }:
{
  config = {
    home.packages = [ pkgs.spotify-tui ];
    services.spotifyd = {
      enable = true;
      settings.spotifyd = {
        username = "zyxama@gmail.com";
        password_cmd = lib.mkIf config.programs.password-store.enable "pass spotify";
        backend = "pulseaudio";
      };
    };
  };
}
