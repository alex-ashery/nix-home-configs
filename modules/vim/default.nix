{ config, pkgs, lib, ... }:
let
  cfg = config.modules.vim;
  keymaps = import ./keymaps.nix;
  modeCommand = mode: {
    n = "nnoremap";
    x = "xnoremap";
    i = "inoremap";
  }.${mode};
  renderKeymap = keymap:
    let
      silent = if keymap.silent or false then "<silent> " else "";
    in
      "${modeCommand keymap.mode} ${silent}${keymap.lhs} ${keymap.vimRhs}";
  renderedKeymaps = builtins.concatStringsSep "\n" (map renderKeymap keymaps);
in
{
  options.modules.vim.additionalPlugins = lib.mkOption {
    type = lib.types.listOf lib.types.package;
    default = [ ];
    example = lib.literalExpression "with pkgs.vimPlugins; [ vim-commentary ];";
    description = "Additional Vim plugins appended to the shared default Vim plugin set.";
  };

  config.programs.vim = {
    enable = true;
    plugins = import ./plugins.nix {
      inherit pkgs;
      inherit (cfg) additionalPlugins;
    };
    extraConfig = ''
      ${builtins.readFile ./vimrc}

      " Generated shared mappings
      ${renderedKeymaps}
    '';
  };
}
