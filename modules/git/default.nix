{ config, lib, pkgs, ... }:
let
  isLinux = pkgs.stdenv.hostPlatform.isLinux;
in
{
  config.programs.delta = {
    enable = true;
    enableGitIntegration = true;
    options = {
      line-numbers = true;
      navigate = true;
    };
  };

  config.programs.git = {
    enable = true;
    settings = lib.mkMerge [
      {
        init.defaultBranch = "main";
        pager = {
          branch = "false";
        };
        core.pager = "bat";
      }

      (lib.mkIf (isLinux && (config.programs.password-store.enable or false)) {
        credential.helper = "!pass git-creds";
      })
    ];
  };
}
