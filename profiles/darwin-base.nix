{ inputs, outputs }:
{ lib, config, pkgs, ... }:

{
  imports = [
    ../modules/amethyst
    ../modules/copyq
    ../modules/git
    ../modules/kitty
    ../modules/neovim
    ../modules/zsh
    ../modules/direnv
    ../modules/homebrew
    ../modules/ssh
    ../modules/llm-cli
  ];

  fonts.fontconfig.enable = true;
  nixpkgs.overlays = [ outputs.overlays.unstable-packages ];

  home = {
    packages = with pkgs; [
      bashInteractive
      gh
      nerd-fonts.meslo-lg
      ripgrep
      yq
    ];
    sessionPath = [ "/usr/local/bin" ];
    sessionVariables = {
      EDITOR = "nvim";
      NIX_HOME_CONFIGS_FLAKE = "${config.home.homeDirectory}/Development/alex-ashery/nix-home-configs";
    };
    stateVersion = "20.09";

    activation.makeTrampolineApps = lib.hm.dag.entryAfter [ "writeBoundary" ] (
      builtins.readFile ./make-app-trampolines.sh
    );
    activation.ensureSopsAgeDir = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
      mkdir -p "$HOME/.config/sops/age"
    '';
  };

  programs = pkgs.lib.genAttrs [
    "bat"
    "fzf"
    "home-manager"
    "jq"
  ] (_: {
    enable = true;
  });

  modules.llmCli = {
    primary = "codex";
    packages = inputs.llm-agents.packages.${pkgs.stdenv.hostPlatform.system};
  };

  nix = {
    enable = true;
    package = pkgs.nix;
    settings.substituters = [
      "https://cache.nixos.org/"
      "https://install.determinate.systems"
    ];
  };
}
