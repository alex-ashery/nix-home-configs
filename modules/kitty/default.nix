{ config, lib, pkgs, ... }:
let
  launchFromRepoRootCommand = command: lib.escapeShellArgs [
    "zsh"
    "-lc"
    ''
      repo_root="$(repo root -p 2>/dev/null || pwd)"
      cd "$repo_root" || exit
      exec ${command}
    ''
  ];
  llmCliLaunchCommand = lib.attrByPath [ "modules" "llmCli" "kittyLaunchCommand" ] null config;
  llmCliEnabled = llmCliLaunchCommand != null;
  llmCliKittyLaunchCommand = launchFromRepoRootCommand llmCliLaunchCommand;
  vimEnabled = config.programs.vim.enable || config.programs.neovim.enable;
  vimCommand = if config.programs.neovim.enable then "nvim" else "vim";
  vimKittyLaunchCommand = launchFromRepoRootCommand "${vimCommand} .";
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
      "ctrl+shift+left" = "resize_window narrower";
      "ctrl+shift+right" = "resize_window wider";
      "ctrl+shift+down" = "resize_window taller";
      "ctrl+shift+up" = "resize_window shorter";
      "ctrl+<" = "move_tab_backward";
      "ctrl+>" = "move_tab_foreward";
      "ctrl+shift+s" = "launch --type=window --location=vsplit --cwd=current ${launchFromRepoRootCommand "zsh"}";
    } // lib.optionalAttrs llmCliEnabled {
      "ctrl+alt+c" = "launch --type=window --location=vsplit --cwd=current --title=current ${llmCliKittyLaunchCommand}";
    } // lib.optionalAttrs vimEnabled {
      "ctrl+alt+v" = "launch --type=overlay-main --cwd=current --title=current ${vimKittyLaunchCommand}";
    };
    settings = {
      shell = lib.mkIf config.programs.zsh.enable "zsh";
      enable_audio_bell = "no";
      font_size = "15.0";
      active_border_color = "red";
      draw_minimal_borders = "no";
    };
  };
}
