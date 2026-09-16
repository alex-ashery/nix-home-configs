{ config, lib, ... }:

let
  cfg = config.modules.homeManager;
  hmsfDefaultProfileArg =
    lib.escapeShellArg (if cfg.defaultProfile == null then "" else cfg.defaultProfile);
in
{
  options.modules.homeManager.defaultProfile = lib.mkOption {
    type = lib.types.nullOr lib.types.str;
    default = null;
    description = "Default home-manager flake profile used by the hmsf helper.";
  };

  config = {
    programs.home-manager.enable = true;

    programs.zsh.shellAliases.hmsf = ''
      f() {
        local profile="$1"
        if [ -z "$profile" ]; then
          profile=${hmsfDefaultProfileArg}
        fi
        if [ -z "$profile" ]; then
          echo "hmsf: no profile supplied and modules.homeManager.defaultProfile is unset" >&2
          return 2
        fi
        home-manager switch --flake ".#$profile"
      }; f'';
  };
}
