{ config, pkgs, ... }:
{
  config.programs.vim = {
    enable = true;
    plugins = with pkgs.vimPlugins; [
      vim-airline
      vim-fugitive
      vim-surround
      vim-nix
      fzf-vim
      molokai
    ];
    extraConfig = builtins.readFile ./vimrc;
  };
}
