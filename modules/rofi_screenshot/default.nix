{ config, lib, pkgs, keyMap, ... }:
let
    rofiDir = "${config.home.homeDirectory}/.config/rofi";
    rofiScriptsDir = "${rofiDir}/scripts";
    screenshotDir = "${config.home.homeDirectory}/Pictures/Screenshots";
in
{
  config = lib.mkIf (config.programs.rofi.enable) {
    home = {
      # workaround to create an empty directory
      file = {
        "${screenshotDir}/.keep".source = builtins.toFile "keep" "";
        "${rofiScriptsDir}/rofi-screenshot" = {
          source = ./resources/rofi-screenshot;
          executable = true;
        };
      };
      sessionVariables = {
        SCREENSHOT_DIR = screenshotDir;
      };
      packages = with pkgs; [
        ffcast
        ffmpeg
        xclip
        slop
      ];
    };
    services.sxhkd.keybindings = lib.mkIf (config.services.sxhkd.enable) {
      ${keyMap.screenshot} = "$ROFI_SCRIPTS/rofi-screenshot";
    };
  };
}
