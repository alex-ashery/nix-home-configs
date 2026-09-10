{ config, lib, pkgs, ... }:
let
  cfg = config.modules.git;
  isLinux = pkgs.stdenv.hostPlatform.isLinux;
in
{
  options.modules.git = {
    userName = lib.mkOption {
      type = lib.types.str;
      default = "alex-ashery";
      description = "Git author name for this Home Manager profile.";
    };

    userEmail = lib.mkOption {
      type = lib.types.str;
      default = "alexander.ashery@gmail.com";
      description = "Git author email for this Home Manager profile.";
    };
  };

  config.programs.git = {
    enable = true;
    settings = lib.mkMerge [
      {
        user = {
          name = cfg.userName;
          email = cfg.userEmail;
        };
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
