local lsp = require("aashery.lsp")

vim.lsp.config("yamlls", {
  cmd = { "yaml-language-server", "--stdio" },
  filetypes = { "yaml", "yaml.docker-compose", "yml" },
  on_attach = lsp.on_attach,
  capabilities = lsp.capabilities,
})

vim.lsp.enable("yamlls")
