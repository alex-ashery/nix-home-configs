{ config, pkgs, ... }:
{
  config.xsession.windowManager.i3 = {
    enable = true;
    package = pkgs.unstable.i3;
    config.bars = [ ];
    extraConfig = builtins.readFile ./config;
  };
}
