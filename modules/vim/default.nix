{ config, pkgs, ... }:
{
  config.programs.vim = {
    enable = true;
    plugins = import ./plugins.nix { inherit pkgs; };
    extraConfig = builtins.readFile ./vimrc;
  };
}
