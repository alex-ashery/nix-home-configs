{ config, lib, pkgs, ... }:
let
  codexEnabled = lib.attrByPath [ "modules" "codex" "enable" ] false config;
  vimEnabled = config.programs.vim.enable || config.programs.neovim.enable;
  vimCommand = if config.programs.neovim.enable then "nvim" else "vim";
in
{
  config.programs.kitty = {
    enable = true;
    package = pkgs.unstable.kitty;
    shellIntegration.mode = "enabled no-title";
    keybindings = {
      "ctrl+shift+j" = "previous_tab";
      "ctrl+shift+k" = "next_tab";
      "ctrl+shift+x" = "close_tab";
      "ctrl+shift+n" = "set_tab_title";
      "ctrl+<" = "move_tab_backward";
      "ctrl+>" = "move_tab_foreward";
    } // lib.optionalAttrs codexEnabled {
      "ctrl+shift+c" = "launch --type=window --location=vsplit --cwd=current --title=current codex resume --last";
    } // lib.optionalAttrs vimEnabled {
      "ctrl+shift+v" = "launch --type=overlay-main --cwd=current --title=current ${vimCommand} .";
    };
    settings = {
      shell = lib.mkIf config.programs.zsh.enable "zsh";
      enable_audio_bell = "no";
      font_size = "15.0";
    };
  };
}
