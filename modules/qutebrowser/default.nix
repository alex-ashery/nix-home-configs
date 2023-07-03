{ config, ... }:
{
  config = {
    programs.qutebrowser = {
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
  };
}
