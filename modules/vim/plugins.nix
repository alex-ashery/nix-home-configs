{ pkgs, additionalPlugins ? [ ] }:

(with pkgs.vimPlugins; [
  vim-airline
  vim-fugitive
  vim-surround
  vim-nix
  fzf-vim
  molokai
]) ++ additionalPlugins
