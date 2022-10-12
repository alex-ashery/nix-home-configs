{
  description = "home-manager flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-22.05";
    homeManager = {
      url = "github:nix-community/home-manager/release-22.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, homeManager }:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
    in {
      homeConfigurations = {
        "aashery" = homeManager.lib.homeManagerConfiguration {
          inherit pkgs system;
          configuration.imports = [ ./aashery/home.nix ];
          homeDirectory = "/home/aashery";
          username = "aashery";
        };
      };
    };
}
