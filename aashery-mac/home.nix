{ lib, config, ... }:

let
  uname = "aashery";
  personalSopsFile = ../secrets/personal.sops.yaml;
  hasPersonalSopsFile = builtins.pathExists personalSopsFile;
in {
  home = {
    username = uname;
    homeDirectory = "/Users/${uname}";
  };

  programs.password-store = {
    enable = true;
    settings = {
      PASSWORD_STORE_DIR = "$XDG_DATA_HOME/password-store";
    };
  };

  programs.git.includes = lib.optionals hasPersonalSopsFile [
    {
      path = config.sops.secrets."git-identity".path;
    }
  ];

  homebrew = {
    enable = true;

    casks = [
      "chatgpt"
      "discord"
      "docker-desktop"
      "signal"
      "pinta"
    ];

    autoBundleOnSwitch = true;
  };

  sops = lib.mkIf hasPersonalSopsFile {
    age.keyFile = "/Users/${uname}/.config/sops/age/keys.txt";
    secrets."git-identity" = {
      sopsFile = personalSopsFile;
      path = "${config.xdg.configHome}/git/secrets/identity";
    };
  };
}
