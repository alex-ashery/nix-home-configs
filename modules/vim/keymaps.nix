[
  {
    mode = "n";
    lhs = "<leader>n";
    vimRhs = ":bn<CR>";
    nvimRhs = "<cmd>bn<cr>";
    desc = "Next buffer";
    silent = true;
  }
  {
    mode = "n";
    lhs = "<leader>p";
    vimRhs = ":bp<CR>";
    nvimRhs = "<cmd>bp<cr>";
    desc = "Previous buffer";
    silent = true;
  }
  {
    mode = "n";
    lhs = "<leader>s";
    vimRhs = ":w<CR>";
    nvimRhs = "<cmd>w<cr>";
    desc = "Save file";
    silent = true;
  }
  {
    mode = "n";
    lhs = "<leader>f";
    vimRhs = ":Ex<CR>";
    nvimRhs = "<cmd>Ex<cr>";
    desc = "Open netrw";
    silent = true;
  }
  {
    mode = "n";
    lhs = "<leader>o";
    vimRhs = ":FzfFiles<CR>";
    nvimRhs = "<cmd>FzfFiles<cr>";
    desc = "Find files";
    silent = true;
  }
  {
    mode = "n";
    lhs = "<leader>O";
    vimRhs = ":FzfFiles /<CR>";
    nvimRhs = "<cmd>FzfFiles /<cr>";
    desc = "Find files from root";
    silent = true;
  }
  {
    mode = "n";
    lhs = "<leader>b";
    vimRhs = ":FzfBuffers<CR>";
    nvimRhs = "<cmd>FzfBuffers<cr>";
    desc = "Find buffers";
    silent = true;
  }
  {
    mode = "n";
    lhs = "<leader>r";
    vimRhs = ":FzfRg<CR>";
    nvimRhs = "<cmd>FzfRg<cr>";
    desc = "Ripgrep";
    silent = true;
  }
  {
    mode = "n";
    lhs = "<leader>lc";
    vimRhs = ":lclose<CR>";
    nvimRhs = "<cmd>lclose<cr>";
    desc = "Close location list";
    silent = true;
  }
  {
    mode = "x";
    lhs = "%";
    vimRhs = "<Esc>%";
    nvimRhs = "<Esc>%";
    desc = "Jump to matching pair";
  }
  {
    mode = "x";
    lhs = "g%";
    vimRhs = "<Esc>g%";
    nvimRhs = "<Esc>g%";
    desc = "Jump to previous matching pair";
  }
]
