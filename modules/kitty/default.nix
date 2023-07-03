{ config, lib, ... }:
{
  config.programs.kitty = {
    enable = true;
    keybindings = {
      "ctrl+shift+j" = "previous_tab";
      "ctrl+shift+k" = "next_tab";
      "ctrl+shift+x" = "close_tab";
      "ctrl+shift+n" = "set_tab_title";
      "ctrl+<" = "move_tab_backward";
      "ctrl+>" = "move_tab_foreward";
    };
    settings = {
      shell = lib.mkIf config.programs.zsh.enable "zsh";
      enable_audio_bell = "no";
      font_size = "15.0";
    };
  };
}
