{ config, lib, ... }:
{
  config.services.xidlehook = {
    enable = true;
    not-when-audio = true;
    not-when-fullscreen = true;
    timers = [
      {
        delay = 1200;
        command = "/run/current-system/sw/bin/light -G > $HOME/.cache/pre_idle_brightness;/run/current-system/sw/bin/light -S 20";
        canceller = "if [ -f $HOME/.cache/pre_idle_brightness ]; then /run/current-system/sw/bin/light -S $(<$HOME/.cache/pre_idle_brightness);fi";
      }
      {
        delay = 10;
        command = "/home/aashery/.nix-profile/bin/betterlockscreen -l --off 10";
        canceller = "if [ -f $HOME/.cache/pre_idle_brightness ]; then /run/current-system/sw/bin/light -S $(<$HOME/.cache/pre_idle_brightness);fi";
      }
    ];
  };
}
