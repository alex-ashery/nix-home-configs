{ config, pkgs, ... }:

{
  fonts.fontconfig.enable = true;
  home = {
    username = "aashery";
    homeDirectory = "/home/aashery";
   # stateVersion = "22.05";
    packages = with pkgs; [
      libnotify
      vlc
      pavucontrol
      awesome
      pass
      spotify-tui
      joplin
      joplin-desktop
      (pkgs.nerdfonts.override { fonts = [ "Meslo" ]; })
      acpi
    ];
    sessionVariables = {
      EDITOR = "vim";
    };
  };

  programs = {
    home-manager.enable = true;
    obs-studio.enable = true;
    vim = {
      enable = true;
      plugins = with pkgs.vimPlugins; [
        vim-airline
        vim-fugitive
        vim-surround
      ];

      settings = {
        number = true;
        relativenumber = true;
        expandtab = true;
        smartcase = true;
      };

      extraConfig = builtins.readFile ./vim/vimrc;
    };
    git = {
      enable = true;
      userName = "alex-ashery";
      userEmail = "alexander.ashery@gmail.com";
      extraConfig = {
        credential.helper = "!pass git-creds";
        };
    };
    kitty = {
      enable = true;
      keybindings = {
        "ctrl+shift+j" = "previous_tab";
        "ctrl+shift+k" = "next_tab";
        "ctrl+shift+x" = "close_tab";
        "ctrl+shift+n" = "set_tab_title";
        "ctrl+<" = "move_tab_backward";
        "ctrl+>" = "move_tab_foreward";
      };
      settings = {
        shell = "zsh";
        enable_audio_bell = "no";
      };
    };
    qutebrowser = {
      enable = true;
      quickmarks = {
          yt = "https://www.youtube.com";
          rdt = "https://www.reddit.com";
          gh = "https://www.github.com";
          az = "https://www.amazon.com";
          ud = "https://www.udemy.com";
          hmm = "https://rycee.gitlab.io/home-manager/options.html";
      };
      keyBindings = {
        normal = {
          D = "hint links download";
          J = "tab-prev";
          K = "tab-next";
          X = "undo";
          d = "scroll-page 0 0.5";
          #gp = "spawn --userscript qute-lastpass";
          u = "scroll-page 0 -0.5";
          x = "tab-close";
          yf = "hint links yank";
          "<" = "tab-move -";
          ">" = "tab-move +";
        };
      };
      searchEngines = {
        g = "https://www.google.com/search?hl=en&q={}";
      };
      settings = {
        content.blocking.enabled = true;
        fonts.default_size = "15pt";
        scrolling.smooth = true;
        content.pdfjs = true;
      };
    };
    brave.enable = true;
    zsh = {
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
    fzf.enable = true;
    feh.enable = true;
  };

  home.file = {
    ".hm-xsession".source = ./hm-xsession;
    ".config/awesome" = {
      source = ./awesome;
      recursive = true;
    };
    ".zsh".source = ./zsh;
    ".zsh".recursive = true;
    ".local/share/applications/mimeapps.list".source = ./mime/mimeapps.list;
    ".local/share/applications/qutebrowser.desktop".source = ./mime/qutebrowser.desktop;
  };

  services = {
    spotifyd = {
      enable = true;
      settings = {
        spotifyd = {
          username = "zyxama@gmail.com";
          password_cmd = "/home/aashery/.nix-profile/bin/pass spotify";
          backend = "pulseaudio";
        };
      };
    };
    betterlockscreen = {
      enable = true;
      arguments = [ "--off" "10" ];
    };
    xidlehook = {
      enable = true;
      not-when-audio = true;
      timers = [
        {
          delay = 120;
          command = "/run/current-system/sw/bin/light -G > $HOME/.cache/pre_idle_brightness;/run/current-system/sw/bin/light -S 20";
          canceller = "if [ -f $HOME/.cache/pre_idle_brightness ]; then /run/current-system/sw/bin/light -S $(<$HOME/.cache/pre_idle_brightness);fi";
        }
        {
          delay = 10;
          command = "/home/aashery/.nix-profile/bin/betterlockscreen -l --off 10";
          canceller = "if [ -f $HOME/.cache/pre_idle_brightness ]; then /run/current-system/sw/bin/light -S $(<$HOME/.cache/pre_idle_brightness);fi";
        }
      ];
    };
    redshift = {
      enable = true;
      # TODO: automatic identification may be broken for a bit due to this issue https://discourse.nixos.org/t/redshift-with-geoclue2/13820
      latitude = 47.6;
      longitude = -122.3;
    };
  };
}
