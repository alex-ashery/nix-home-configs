{ lib, config, ... }:

let
  uname = "aashery";
  sopsTokenFile = ../secrets/github-token.sops.yaml;
  hasSopsToken = builtins.pathExists sopsTokenFile;
in {
  home = {
    username = uname;
    homeDirectory = "/Users/${uname}";
  };

  programs.password-store.enable = true;

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
    extraOptions = lib.optionalString hasSopsToken ''
      !include ${config.xdg.configHome}/nix/secrets/nix-access-tokens
    '';
  };

  sops = lib.mkIf hasSopsToken {
    age.keyFile = "/Users/${uname}/.config/sops/age/keys.txt";
    secrets."nix-access-tokens" = {
      sopsFile = sopsTokenFile;
      path = "${config.xdg.configHome}/nix/secrets/nix-access-tokens";
    };
  };
}
