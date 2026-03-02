{
  description = "home-manager flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-23.05";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager/release-23.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, ... }@inputs:
    let
      inherit (self) outputs;
      linuxSystem = "x86_64-linux";
      macSystem = "aarch64-darwin";
    in {
      overlays.unstable-packages = final: prev: {
        unstable = import inputs.nixpkgs-unstable {
          system = final.system;
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
          modules = [ ./aashery-mac/home.nix ];
        };
      };
    };
}
