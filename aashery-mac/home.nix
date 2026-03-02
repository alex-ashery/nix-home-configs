{ inputs, outputs, lib, config, pkgs, ... }:

let
    uname = "aashery";
in
{
  fonts.fontconfig.enable = true;
  imports = import ./modules.nix;
  nixpkgs.overlays = [ outputs.overlays.unstable-packages ];

  home = {
    username = uname;
    homeDirectory = "/Users/${uname}";
    packages = import ./packages.nix pkgs;
    sessionVariables.EDITOR = "vim";
    stateVersion = "20.09";

    # Shim for linking HM managed apps into spotlight
    activation.makeTrampolineApps = lib.hm.dag.entryAfter [ "writeBoundary" ] (
      builtins.readFile ./make-app-trampolines.sh
    );
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
    ];

    autoBundleOnSwitch = true;
  };
}
