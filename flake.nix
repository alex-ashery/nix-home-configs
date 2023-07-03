{
  description = "home-manager flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-22.05";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    homeManager = {
      url = "github:nix-community/home-manager/release-22.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # awesomewm modules
    bling = { url = "github:BlingCorp/bling"; flake = false; };
    rubato = { url = "github:andOrlando/rubato"; flake = false; };
  };

  outputs = { self, nixpkgs, homeManager, nixpkgs-unstable, ... }@inputs:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
      extraSpecialArgs = {
        inherit inputs self;
        bling = inputs.bling;
        rubato = inputs.rubato;
      };
      overlay-unstable = final: prev: {
        unstable = nixpkgs-unstable.legacyPackages.${prev.system};
      };
    in {
      pkgs.config.allowUnfree = true;
      homeConfigurations = {
        "aashery" = homeManager.lib.homeManagerConfiguration {
          inherit pkgs system extraSpecialArgs;
          configuration.imports = [ ./aashery/home.nix ];
          configuration.nixpkgs.overlays = [ overlay-unstable ];
          homeDirectory = "/home/aashery";
          username = "aashery";
        };
      };
    };
}
