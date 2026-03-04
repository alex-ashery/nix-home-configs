{
  description = "home-manager flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.11";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    llm-agents.url = "github:numtide/llm-agents.nix";
    home-manager = {
      url = "github:nix-community/home-manager/release-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    sops-nix = {
      url = "github:Mic92/sops-nix?ref=7f49111254333bda6881b0dfa8cf7d82fe305f93";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, sops-nix, llm-agents, ... }@inputs:
    let
      inherit (self) outputs;
      linuxSystem = "x86_64-linux";
      macSystem = "aarch64-darwin";
      forAllSystems = nixpkgs.lib.genAttrs [ linuxSystem macSystem ];
    in {
      overlays.unstable-packages = final: prev: {
        unstable = import inputs.nixpkgs-unstable {
          system = final.stdenv.hostPlatform.system;
        };
      };
      homeConfigurations = {
        "aashery" = home-manager.lib.homeManagerConfiguration {
          pkgs = nixpkgs.legacyPackages.${linuxSystem};
          extraSpecialArgs = {
            inherit inputs outputs;
            keyMap = import ./keymap.nix;
          };
          modules = [ ./aashery/home.nix ];
        };
        "aashery-mac" = home-manager.lib.homeManagerConfiguration {
          pkgs = nixpkgs.legacyPackages.${macSystem};
          extraSpecialArgs = {
            inherit inputs outputs;
          };
          modules = [
            sops-nix.homeManagerModules.sops
            ./aashery-mac/home.nix
          ];
        };
      };

      devShells = forAllSystems (system:
        let
          pkgs = nixpkgs.legacyPackages.${system};
        in {
          default = pkgs.mkShell {
            packages = [
              pkgs.age
              pkgs.sops
            ];
            SOPS_AGE_KEY_FILE = "$HOME/.config/sops/age/keys.txt";
            shellHook = ''
              export SOPS_AGE_KEY_FILE="$HOME/.config/sops/age/keys.txt"
            '';
          };
        });
    };
}
