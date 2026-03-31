{ lib, ... }:
{
  homebrew.casks = lib.mkAfter [ "amethyst" ];

  launchd.agents.amethyst = {
    enable = true;
    config = {
      ProgramArguments = [ "/usr/bin/open" "-a" "Amethyst" ];
      RunAtLoad = true;
      KeepAlive = false;
    };
  };
}
