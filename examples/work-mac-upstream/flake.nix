{
  description = "Example work Home Manager flake consuming a personal upstream";

  inputs = {
    # For this in-repo example. In a real separate work repo, use:
    # personal-home.url = "github:alex-ashery/nix-home-configs";
    personal-home.url = "path:../..";

    nixpkgs.follows = "personal-home/nixpkgs";
    home-manager.follows = "personal-home/home-manager";
  };

  outputs = { nixpkgs, home-manager, personal-home, ... }: {
    homeConfigurations.work-mac = home-manager.lib.homeManagerConfiguration {
      pkgs = nixpkgs.legacyPackages.aarch64-darwin;

      modules = [
        personal-home.homeProfiles.darwinBase

        ./modules/work-shell.nix
        ./work-mac/home.nix
      ];
    };
  };
}
