{ config, pkgs, lib, ... }:
let
  isDarwin = pkgs.stdenv.hostPlatform.isDarwin;
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
in
{
  config = {
    programs.zsh = {
      enable = true;
      enableCompletion = true;
      plugins = [
        {
          name = "powerlevel10k";
          src = pkgs.zsh-powerlevel10k;
          file = "share/zsh-powerlevel10k/powerlevel10k.zsh-theme";
        }
      ];
      initContent = initContent + lib.optionalString isDarwin ''
        # Make `ls` colors work whether `ls` resolves to GNU or BSD tools.
        unalias ls 2>/dev/null || true
        ls() {
          if command ls --color=auto -d . >/dev/null 2>&1; then
            command ls --color=auto "$@"
          else
            command ls -G "$@"
          fi
        }
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
        hmsf = "f() { home-manager switch --flake .#$1 };f";
        nrsf = "f() { sudo nixos-rebuild switch --flake .#$1 };f";
      };
    };
    home.file = {
      ".zsh/p10k.zsh".source = ./p10k.zsh;
    };
  };
}
