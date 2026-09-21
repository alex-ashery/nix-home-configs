{ config, pkgs, lib, ... }:
let
  cfg = config.modules.zsh;
  isDarwin = pkgs.stdenv.hostPlatform.isDarwin;
  managedDotDir = "${config.xdg.configHome}/zsh/home-manager";
  mutableZshrcPath = ".zshrc";
  brewPrefix =
    if pkgs.stdenv.hostPlatform.isAarch64
    then "/opt/homebrew"
    else "/usr/local";
  brewBin = "${brewPrefix}/bin/brew";
  initDir = ./init;
  initFiles = map (name: initDir + "/${name}") (
    builtins.attrNames (
      lib.filterAttrs (name: type:
        type == "regular" && lib.hasSuffix ".zsh" name
      ) (builtins.readDir initDir)
    )
  );
  initContent = lib.concatMapStringsSep "\n\n" builtins.readFile initFiles;
  sharedInitContent = initContent + lib.optionalString isDarwin ''
    # Make `ls` colors work whether `ls` resolves to GNU or BSD tools.
    unalias ls 2>/dev/null || true
    ls() {
      if command ls --color=auto -d . >/dev/null 2>&1; then
        command ls --color=auto "$@"
      else
        command ls -G "$@"
      fi
    }
  '' + lib.optionalString (cfg.additionalInitContent != "") ''

    ${cfg.additionalInitContent}
  '';
  sourceMutableZshrc = ''
    # Source the normal writable zshrc late so tool installers can append
    # integrations without modifying Home Manager's generated files.
    if [[ -r "$HOME/${mutableZshrcPath}" ]]; then
      source "$HOME/${mutableZshrcPath}"
    fi
  '';
in
{
  options.modules.zsh = {
    additionalInitContent = lib.mkOption {
      type = lib.types.lines;
      default = "";
      example = ''
        export WORK_REPO_ROOT="$HOME/Development/work"
      '';
      description = "Additional zshrc content appended after the shared zsh configuration.";
    };

    dev = {
      defaultGithubOrg = lib.mkOption {
        type = lib.types.str;
        default = "alex-ashery";
        description = "Default GitHub owner used by dev shell helpers.";
      };

      flakeTemplateDir = lib.mkOption {
        type = lib.types.str;
        default = "$HOME/Development/alex-ashery/nix-templates/templates";
        description = "Local template directory used for zsh completion.";
      };

      localFlakeTemplateSource = lib.mkOption {
        type = lib.types.str;
        default = "$HOME/Development/alex-ashery/nix-templates";
        description = "Local flake template source used by dev init.";
      };

      remoteFlakeTemplateSource = lib.mkOption {
        type = lib.types.str;
        default = "github:alex-ashery/nix-templates";
        description = "Remote flake template source fallback used by dev init.";
      };
    };
  };

  config = {
    home.sessionVariables = {
      GITHUB_DEFAULT_ORG = cfg.dev.defaultGithubOrg;
      NIX_DEV_FLAKE_TEMPLATE_DIR = cfg.dev.flakeTemplateDir;
      NIX_DEV_FLAKE_TEMPLATE_SOURCE = cfg.dev.localFlakeTemplateSource;
      NIX_DEV_FLAKE_TEMPLATE_REMOTE_SOURCE = cfg.dev.remoteFlakeTemplateSource;
    };

    programs.zsh = {
      enable = true;
      enableCompletion = true;
      dotDir = managedDotDir;
      plugins = [
        {
          name = "powerlevel10k";
          src = pkgs.zsh-powerlevel10k;
          file = "share/zsh-powerlevel10k/powerlevel10k.zsh-theme";
        }
      ];
      initContent = lib.mkMerge [
        sharedInitContent
        (lib.mkOrder 2000 sourceMutableZshrc)
      ];
      envExtra = lib.optionalString isDarwin ''
        if [ -e /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh ]; then
          . /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh
        fi
      '';
      profileExtra = lib.mkIf (isDarwin && (config.homebrew.enable or false)) ''
        if [ -x "${brewBin}" ]; then
          eval "$("${brewBin}" shellenv)"
        fi
      '';
      oh-my-zsh = {
        enable = true;
        plugins = [ "git" "python" "aws" "colored-man-pages" "jira" "terraform" "kubectl" "fzf" ];
      };
      shellAliases = {
        nrsf = "f() { sudo nixos-rebuild switch --flake .#$1 };f";
      };
    };
    home.file = {
      ".zsh/p10k.zsh".source = ./p10k.zsh;
    };

    home.activation.ensureMutableZshrc = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
      mutable_zshrc="$HOME/${mutableZshrcPath}"
      if [ ! -e "$mutable_zshrc" ]; then
        touch "$mutable_zshrc"
      fi
    '';
  };
}
