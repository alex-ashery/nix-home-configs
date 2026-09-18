{ config, pkgs, ... }:
let
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
  config.programs.vim = {
    enable = true;
    plugins = import ./plugins.nix { inherit pkgs; };
    extraConfig = ''
      ${builtins.readFile ./vimrc}

      " Generated shared mappings
      ${renderedKeymaps}
    '';
  };
}
