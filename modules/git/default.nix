{ config, lib, ... }:
{
  config.programs.git = {
    enable = true;
    userName = "alex-ashery";
    userEmail = "alexander.ashery@gmail.com";
    extraConfig = {
      credential.helper = lib.mkIf config.programs.password-store.enable "!pass git-creds";
      pager = {
        branch = "false";
        diff = "false";
      };
      core.pager = "bat";
    };
  };
}
