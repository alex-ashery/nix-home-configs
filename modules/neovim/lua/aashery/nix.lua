local lsp = require("aashery.lsp")

vim.lsp.config("nixd", {
  cmd = { "nixd" },
  filetypes = { "nix" },
  root_markers = { "flake.nix", ".git" },
  on_attach = lsp.on_attach,
  capabilities = lsp.capabilities,
})

vim.lsp.enable("nixd")
