local lsp = require("aashery.lsp")

vim.lsp.config("bashls", {
  on_attach = lsp.on_attach,
  capabilities = lsp.capabilities,
})

vim.lsp.enable("bashls")
