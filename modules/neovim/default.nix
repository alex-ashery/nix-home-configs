{ pkgs, ... }:
let
  vimPlugins = import ../vim/plugins.nix { inherit pkgs; };
in
{
  config = {
    xdg.configFile."nvim/lua/aashery".source = ./lua/aashery;

    programs.neovim = {
      enable = true;
      defaultEditor = true;
      vimAlias = true;
      viAlias = true;

      plugins = vimPlugins ++ (with pkgs.vimPlugins; [
        direnv-vim
        fzf-lua
        nvim-lspconfig
        nvim-cmp
        cmp-nvim-lsp
        cmp-buffer
        cmp-path
      ]);

      extraPackages = with pkgs; [
        nixd
        lua-language-server
        bash-language-server
        yaml-language-server
      ];

      extraConfig = builtins.readFile ../vim/vimrc;

      extraLuaConfig = builtins.readFile ./lua/init.lua;
    };
  };
}
