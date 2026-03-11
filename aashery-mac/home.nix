{ inputs, outputs, lib, config, pkgs, ... }:

let
  uname = "aashery";
  sopsTokenFile = ../secrets/github-token.sops.yaml;
  hasSopsToken = builtins.pathExists sopsTokenFile;
in {
  fonts.fontconfig.enable = true;
  imports = import ./modules.nix;
  nixpkgs.overlays = [ outputs.overlays.unstable-packages ];

  home = {
    username = uname;
    homeDirectory = "/Users/${uname}";
    packages = import ./packages.nix { inherit pkgs inputs; };
    sessionVariables.EDITOR = "nvim";
    stateVersion = "20.09";

    # Shim for linking HM managed apps into spotlight
    activation.makeTrampolineApps = lib.hm.dag.entryAfter [ "writeBoundary" ] (
      builtins.readFile ./make-app-trampolines.sh
    );
    activation.ensureSopsAgeDir = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
      mkdir -p "$HOME/.config/sops/age"
    '';
  };

  # For each program in the list, generate an attributeSet for it enabling the program
  programs = pkgs.lib.genAttrs (import ./programs.nix) (
    program: {enable = true;}
  );

  homebrew = {
    enable = true;
    brews = [
      "ripgrep"
      "gh"
    ];

    casks = [
      "amethyst"
      "chatgpt"
    ];

    autoBundleOnSwitch = true;
  };

  nix = {
    enable = true;
    package = pkgs.nix;
    settings.substituters  = [
          "https://cache.nixos.org/"
          "https://install.determinate.systems"
    ];
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
