{ config, lib, pkgs, ... }:
let
  isLinux = pkgs.stdenv.hostPlatform.isLinux;
in
{
  config.programs.git = {
    enable = true;
    settings = lib.mkMerge [
      {
        user = {
          name = "alex-ashery";
          email = "alexander.ashery@gmail.com";
        };
        pager = {
          branch = "false";
          diff = "false";
        };
        core.pager = "bat";
      }

      (lib.mkIf (isLinux && (config.programs.password-store.enable or false)) {
        credential.helper = "!pass git-creds";
      })
    ];
  };
}
