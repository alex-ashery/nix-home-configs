{ pkgs, ... }:
let
  vimPlugins = import ../vim/plugins.nix { inherit pkgs; };
  sharedKeymaps = map (keymap: {
    inherit (keymap) mode lhs desc;
    rhs = keymap.nvimRhs;
  }) (import ../vim/keymaps.nix);
  sharedKeymapsJson = builtins.toJSON sharedKeymaps;
in
{
  config = {
    xdg.configFile."nvim/lua/aashery".source = ./lua/aashery;

    programs.neovim = {
      enable = true;
      defaultEditor = true;
      vimAlias = true;
      viAlias = true;
      withPython3 = true;
      withRuby = true;

      plugins = vimPlugins ++ (with pkgs.vimPlugins; [
        direnv-vim
        fzf-lua
        which-key-nvim
        nvim-lspconfig
        nvim-cmp
        cmp-nvim-lsp
        cmp-buffer
        cmp-path
        cmp-cmdline
        nvim-dap
        nvim-dap-go
        nvim-dap-view
      ]);

      extraPackages = with pkgs; [
        nixd
        lua-language-server
        bash-language-server
        yaml-language-server
      ];

      extraConfig = builtins.readFile ../vim/vimrc;

      initLua = ''
        _G.aashery_shared_keymaps = vim.json.decode(${builtins.toJSON sharedKeymapsJson})

        ${builtins.readFile ./lua/init.lua}
      '';
    };
  };
}
