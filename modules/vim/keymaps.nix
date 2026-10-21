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
    mode = "n";
    lhs = "<leader>gs";
    vimRhs = ":Git<CR>";
    nvimRhs = "<cmd>Git<cr>";
    desc = "Git status";
    silent = true;
  }
  {
    mode = "n";
    lhs = "<leader>gd";
    vimRhs = ":Gvdiffsplit<CR>";
    nvimRhs = "<cmd>Gvdiffsplit<cr>";
    desc = "Diff file against index";
    silent = true;
  }
  {
    mode = "n";
    lhs = "<leader>gD";
    vimRhs = ":Gvdiffsplit HEAD<CR>";
    nvimRhs = "<cmd>Gvdiffsplit HEAD<cr>";
    desc = "Diff file against HEAD";
    silent = true;
  }
  {
    mode = "n";
    lhs = "<leader>gq";
    vimRhs = ":call fugitive#DiffClose()<CR>";
    nvimRhs = "<cmd>call fugitive#DiffClose()<cr>";
    desc = "Close other diff windows";
    silent = true;
  }
  {
    mode = "n";
    lhs = "<leader>gu";
    vimRhs = ":Git diff<CR>";
    nvimRhs = "<cmd>Git diff<cr>";
    desc = "View unstaged diff";
    silent = true;
  }
  {
    mode = "n";
    lhs = "<leader>gS";
    vimRhs = ":Git diff --cached<CR>";
    nvimRhs = "<cmd>Git diff --cached<cr>";
    desc = "View staged diff";
    silent = true;
  }
  {
    mode = "n";
    lhs = "<leader>gr";
    vimRhs = ":Git difftool<CR>:copen<CR>";
    nvimRhs = "<cmd>Git difftool<cr><cmd>copen<cr>";
    desc = "Review unstaged hunks in quickfix";
    silent = true;
  }
  {
    mode = "n";
    lhs = "<leader>gn";
    vimRhs = ":cnext<CR>";
    nvimRhs = "<cmd>cnext<cr>";
    desc = "Next quickfix item";
    silent = true;
  }
  {
    mode = "n";
    lhs = "<leader>gp";
    vimRhs = ":cprevious<CR>";
    nvimRhs = "<cmd>cprevious<cr>";
    desc = "Previous quickfix item";
    silent = true;
  }
  {
    mode = "n";
    lhs = "<leader>gb";
    vimRhs = ":Git blame<CR>";
    nvimRhs = "<cmd>Git blame<cr>";
    desc = "Git blame";
    silent = true;
  }
  {
    mode = "n";
    lhs = "<leader>gh";
    vimRhs = ":help fugitive-maps<CR>";
    nvimRhs = "<cmd>help fugitive-maps<cr>";
    desc = "Help for Fugitive keys";
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
