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
    ];
    settings = {
      number = true;
      relativenumber = true;
      expandtab = true;
      smartcase = true;
    };
    extraConfig = builtins.readFile ./vimrc;
  };
}
