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

  programs.password-store.enable = true;

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
      "docker"
      "signal"
      "pinta"
    ];

    autoBundleOnSwitch = true;
  };

  nix = {
    extraOptions = lib.optionalString hasPersonalSopsFile ''
      !include ${config.xdg.configHome}/nix/secrets/nix-access-tokens
    '';
  };

  sops = lib.mkIf hasPersonalSopsFile {
    age.keyFile = "/Users/${uname}/.config/sops/age/keys.txt";
    secrets."git-identity" = {
      sopsFile = personalSopsFile;
      path = "${config.xdg.configHome}/git/secrets/identity";
    };
    secrets."nix-access-tokens" = {
      sopsFile = personalSopsFile;
      path = "${config.xdg.configHome}/nix/secrets/nix-access-tokens";
    };
  };
}
