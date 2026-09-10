{ lib, ... }:

{
  programs.zsh = {
    shellAliases = {
      work-switch = "home-manager switch --flake ~/Development/work/nix-home-configs#work-mac";
    };

    initContent = lib.mkAfter ''
      # Work-local shell customizations belong in the downstream work repo.
      export WORK_REPO_ROOT="$HOME/Development/work"
    '';
  };
}

