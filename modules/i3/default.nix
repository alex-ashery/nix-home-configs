{ config, pkgs, ... }:
{
  config.xsession.windowManager.i3 = {
    enable = true;
    config.bars = [ ];
    extraConfig = builtins.readFile ./config;
  };
}
