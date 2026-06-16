{ pkgs, ... }:
{
  config.programs.neovim = {
    enable = true;
    defaultEditor = true;
    vimAlias = true;
    viAlias = true;

    plugins = with pkgs.vimPlugins; [
      vim-airline
      vim-fugitive
      vim-surround
      vim-nix
      direnv-vim
      fzf-vim
      fzf-lua
      nvim-lspconfig
      nvim-cmp
      cmp-nvim-lsp
      cmp-buffer
      cmp-path
      molokai
    ];

    extraPackages = with pkgs; [
      nixd
      lua-language-server
      bash-language-server
      yaml-language-server
    ];

    extraConfig = builtins.readFile ../vim/vimrc;

    extraLuaConfig = ''
      local has_fzf_lua, fzf_lua = pcall(require, "fzf-lua")
      if has_fzf_lua then
        fzf_lua.setup({})
      end

      local cmp = require("cmp")
      cmp.setup({
        snippet = {
          expand = function(args)
            vim.snippet.expand(args.body)
          end,
        },
        mapping = cmp.mapping.preset.insert({
          ["<C-Space>"] = cmp.mapping.complete(),
          ["<CR>"] = cmp.mapping.confirm({ select = true }),
          ["<Tab>"] = cmp.mapping.select_next_item(),
          ["<S-Tab>"] = cmp.mapping.select_prev_item(),
        }),
        sources = cmp.config.sources({
          { name = "nvim_lsp" },
          { name = "path" },
        }, {
          { name = "buffer" },
        }),
      })

      local on_attach = function(_, bufnr)
        local opts = { buffer = bufnr, silent = true }
        vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
        vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
        vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
        vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, opts)
        vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)
        vim.keymap.set("n", "<leader>dp", vim.diagnostic.goto_prev, opts)
        vim.keymap.set("n", "<leader>dn", vim.diagnostic.goto_next, opts)
        vim.keymap.set("n", "<leader>df", vim.diagnostic.open_float, opts)
        vim.keymap.set("n", "<leader>dl", function()
          if has_fzf_lua then
            fzf_lua.diagnostics_document()
          else
            vim.diagnostic.setloclist({ open = false })
            vim.cmd("lopen")
          end
        end, opts)
      end

      local capabilities = require("cmp_nvim_lsp").default_capabilities(
        vim.lsp.protocol.make_client_capabilities()
      )

      vim.lsp.config("nixd", {
        cmd = { "nixd" },
        filetypes = { "nix" },
        root_markers = { "flake.nix", ".git" },
        on_attach = on_attach,
        capabilities = capabilities,
      })

      vim.lsp.config("lua_ls", {
        on_attach = on_attach,
        capabilities = capabilities,
      })

      vim.lsp.config("bashls", {
        on_attach = on_attach,
        capabilities = capabilities,
      })

      vim.lsp.config("gopls", {
        on_attach = on_attach,
        capabilities = capabilities,
      })

      vim.lsp.config("yamlls", {
        cmd = { "yaml-language-server", "--stdio" },
        filetypes = { "yaml", "yaml.docker-compose", "yml" },
        on_attach = on_attach,
        capabilities = capabilities,
      })

      vim.lsp.enable("nixd")
      vim.lsp.enable("lua_ls")
      vim.lsp.enable("bashls")
      vim.lsp.enable("yamlls")

      local gopls_enabled = false
      local enable_gopls_if_available = function()
        if gopls_enabled then
          return
        end

        if vim.fn.executable("gopls") == 1 and vim.fn.executable("go") == 1 then
          gopls_enabled = true
          vim.lsp.enable("gopls")
        end
      end

      vim.api.nvim_create_autocmd({ "VimEnter", "BufEnter", "DirChanged" }, {
        callback = function()
          vim.defer_fn(enable_gopls_if_available, 100)
        end,
      })

      vim.api.nvim_create_autocmd("FileType", {
        pattern = "go",
        callback = function()
          vim.defer_fn(enable_gopls_if_available, 100)
          vim.opt_local.expandtab = false
          vim.opt_local.tabstop = 4
          vim.opt_local.shiftwidth = 4
          vim.opt_local.softtabstop = 4
        end,
      })
    '';
  };
}
