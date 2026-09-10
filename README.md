# nix-home-configs

Home Manager configurations

# Bootstrap
Enable the dev shell automatically with `direnv allow`

## SOPS personal secrets

This repo uses sops-nix to provide personal secrets to personal profiles.
The current personal secrets file includes the GitHub access token used by Nix
on macOS and the Git identity fragment used by `aashery-mac`.
- Add an age key at `~/.config/sops/age/keys.txt` by running `age-keygen -o ~/.config/sops/age/keys.txt`.
- Update the encrypted secret by adding your age public key as a recipient (so you can decrypt):
   `sops --add-age age1YOURPUBLICKEY -i secrets/personal.sops.yaml`

## SSH key passphrases

macOS:
- Home Manager config enables macOS Keychain integration.
- Run once: `ssh-add --apple-use-keychain ~/.ssh/id_ed25519`

Linux (NixOS):
- Home Manager enables a user `ssh-agent` systemd service.
- The agent does not persist keys across logins; run once per login/session:
  `ssh-add ~/.ssh/id_ed25519`

## Using this repo as an upstream

This repo exposes reusable Home Manager modules and profile bundles for use from
another flake. Keep company-specific configuration in the downstream work repo,
and consume generic personal tooling from this repo as an input.

Example downstream work flake:

```nix
{
  inputs = {
    personal-home.url = "github:alex-ashery/nix-home-configs";
    nixpkgs.follows = "personal-home/nixpkgs";
    home-manager.follows = "personal-home/home-manager";
  };

  outputs = { nixpkgs, home-manager, personal-home, ... }: {
    homeConfigurations."work-mac" = home-manager.lib.homeManagerConfiguration {
      pkgs = nixpkgs.legacyPackages.aarch64-darwin;
      modules = [
        personal-home.homeProfiles.darwinBase
        personal-home.homeManagerModules.git
        personal-home.homeManagerModules.homebrew
        personal-home.homeManagerModules.kitty
        personal-home.homeManagerModules.neovim
        personal-home.homeManagerModules.zsh
        ./work-mac/home.nix
      ];
    };
  };
}
```

The downstream work profile should set work-owned identity and policy locally:

```nix
{ config, ... }:

{
  home.username = "work-user";
  home.homeDirectory = "/Users/work-user";

  programs.git.includes = [
    {
      path = config.sops.secrets."git-identity".path;
    }
  ];

  modules.zsh.dev.defaultGithubOrg = "work-org";

  sops.secrets."git-identity" = {
    sopsFile = ./secrets/work.sops.yaml;
    path = "${config.xdg.configHome}/git/secrets/identity";
  };
}
```

Personal Git identity is loaded from the SOPS-managed `git-identity` secret on
`aashery-mac`, so the reusable Git module does not expose a default name or
email. Downstream work repos should provide their own identity locally, ideally
by adding a SOPS-managed Git config fragment to `programs.git.includes`.

Generic improvements belong here on personal time. Company-specific tools,
secrets, internal hostnames, SSH hosts, and work identity belong in the work
repo.
