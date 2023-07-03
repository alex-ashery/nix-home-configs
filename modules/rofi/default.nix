{ config, lib, ... }:
let
    rofiDir = "${config.home.homeDirectory}/.config/rofi";
in
{
  config = lib.mkIf (config.xsession.enable) {
    home = {
      file."${rofiDir}" = {
          source = ./resources;
          recursive = true;
      };
      sessionVariables = {
        ROFI_DIR = rofiDir;
        ROFI_SCRIPTS = "$ROFI_DIR/scripts";
        ROFI_THEMES = "$ROFI_DIR/themes";
      };
    };
    programs.rofi.enable = true;
  };
}
