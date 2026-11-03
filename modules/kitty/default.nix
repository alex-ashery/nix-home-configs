{ config, lib, pkgs, ... }:
let
  isDarwin = pkgs.stdenv.hostPlatform.isDarwin;
  llmCliLaunchCommand = lib.attrByPath [ "modules" "llmCli" "kittyLaunchCommand" ] null config;
  llmCliEnabled = llmCliLaunchCommand != null;
  tuicrLaunchCommand = lib.attrByPath [ "modules" "tuicr" "kittyLaunchCommand" ] null config;
  vimEnabled = config.programs.vim.enable || config.programs.neovim.enable;
  vimCommand = if config.programs.neovim.enable then "nvim" else "vim";
in
{
  imports = [ ../homebrew ];

  config = {
    # Work around nixpkgs#571894: use the cask so Amethyst can manage Kitty.
    homebrew.casks = lib.mkIf isDarwin (lib.mkAfter [ "kitty" ]);
    home.sessionPath = lib.optionals isDarwin [ "/Applications/kitty.app/Contents/MacOS" ];

    programs.kitty = {
      enable = true;
      package = if isDarwin then null else pkgs.unstable.kitty;
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
        "ctrl+shift+s" = "launch --type=window --location=vsplit --cwd=current";
      } // lib.optionalAttrs llmCliEnabled {
        "ctrl+alt+c" = "launch --type=window --location=vsplit --cwd=current --title=current ${llmCliLaunchCommand}";
      } // lib.optionalAttrs vimEnabled {
        "ctrl+alt+v" = "launch --type=overlay-main --cwd=current --title=current ${vimCommand} .";
      } // lib.optionalAttrs (tuicrLaunchCommand != null) {
        "ctrl+alt+r" = "launch --type=window --location=vsplit --cwd=current --title=current ${tuicrLaunchCommand}";
      };
      settings = {
        shell = lib.mkIf config.programs.zsh.enable "zsh";
        enable_audio_bell = "no";
        font_size = "15.0";
        initial_window_width = "1200";
        initial_window_height = "800";
        active_border_color = "red";
        draw_minimal_borders = "no";
      };
    };
  };
}
