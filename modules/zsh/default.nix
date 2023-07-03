{ config, pkgs, ... }:
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
      initExtra = ''
        # Make Vi mode transitions faster (KEYTIMEOUT is in hundreths of a second)
        export KEYTIMEOUT=1
        bindkey -v
        source .zsh/p10k.zsh
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
