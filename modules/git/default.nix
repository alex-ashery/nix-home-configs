{ config, lib, pkgs, ... }:
let
  isLinux = pkgs.stdenv.hostPlatform.isLinux;
in
{
  config.programs.git = {
    enable = true;
    userName = "alex-ashery";
    userEmail = "alexander.ashery@gmail.com";
    extraConfig = lib.mkMerge [
      {
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
