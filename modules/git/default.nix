{ config, lib, pkgs, ... }:
let
  isLinux = pkgs.stdenv.hostPlatform.isLinux;
in
{
  config.programs.git = {
    enable = true;
    settings = lib.mkMerge [
      {
        init.defaultBranch = "main";
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
