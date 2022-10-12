{ config, pkgs, ... }:

{
  home = {
    username = "aashery";
    homeDirectory = "/home/aashery";
   # stateVersion = "22.05";
    packages = with pkgs; [
      libnotify
      vlc
    ];
    sessionVariables = {
      EDITOR = "vim";
    };
  };

  programs = {
    home-manager.enable = true;
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
    };
    qutebrowser = {
      enable = true;
      quickmarks = {
          yt = "https://www.youtube.com";
          rdt = "https://www.reddit.com";
          gh = "https://www.github.com";
          az = "https://www.amazon.com";
          ud = "https://www.udemy.com";
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
      settings = {
        content.blocking.enabled = true;
        fonts.default_size = "15pt";
        scrolling.smooth = true;
        colors.webpage.darkmode.enabled = true;
      };
    };
  };

  home.file.".hm-xsession".source = ./hm-xsession;
}
