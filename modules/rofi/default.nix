{ config, lib, pkgs, keyMap, ... }:
let
    rofiDir = "${config.home.homeDirectory}/.config/rofi";
    rofiScriptsDir = "${rofiDir}/scripts";
    rofiThemesDir = "${rofiDir}/themes";
in
{
  config = lib.mkIf (config.xsession.enable) {
    home = {
      file = {
        "${rofiScriptsDir}" = {
          source = ./resources/scripts;
          recursive = true;
          executable = true;
        };
        "${rofiThemesDir}" = {
            source = ./resources/themes;
            recursive = true;
        };
      };
      packages = [ pkgs.rofimoji ];
      # workaround to create an empty directory
      sessionVariables = {
        ROFI_DIR = rofiDir;
        ROFI_SCRIPTS = "$ROFI_DIR/scripts";
        ROFI_THEMES = "$ROFI_DIR/themes";
      };
    };
    programs.rofi = {
      enable = true;
      plugins = [ pkgs.rofi-top ];
    };
    services.sxhkd.keybindings = lib.mkIf (config.services.sxhkd.enable) {
      ${keyMap.launcher} = "$ROFI_SCRIPTS/launch.sh";
      ${keyMap.session} = "$ROFI_SCRIPTS/session.sh";
      ${keyMap.emoji} = "rofimoji";
    };
  };
}
