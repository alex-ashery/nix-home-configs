let
  username = "work-user";
in
{
  home = {
    inherit username;
    homeDirectory = "/Users/${username}";
  };

  modules.zsh.dev = {
    defaultGithubOrg = "work-org";
    flakeTemplateDir = "$HOME/Development/work/nix-templates/templates";
    localFlakeTemplateSource = "$HOME/Development/work/nix-templates";
    remoteFlakeTemplateSource = "github:work-org/nix-templates";
  };

  homebrew = {
    enable = true;
    casks = [
      "slack"
      "zoom"
    ];
    autoBundleOnSwitch = false;
  };
}
