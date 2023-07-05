{ config, lib, ... }:
{
  config.services.xidlehook = {
    enable = true;
    not-when-audio = true;
    not-when-fullscreen = true;
    timers = [
      # TODO: This can't be used in desktop until I have a way to control brightness from a systemd unit
      # {
      #   delay = 1200;
      #   command = "${nixBinDir}/getbright > ${cacheFile};${setbright} 20";
      #   canceller = cancellerCommand;
      # }
      {
        delay = 1200;
        command = "${config.home.homeDirectory}/.nix-profile/bin/betterlockscreen -l --off 10";
        # canceller = cancellerCommand;
      }
    ];
  };
}
