local lsp = require("aashery.lsp")

vim.lsp.config("gopls", {
  on_attach = lsp.on_attach,
  capabilities = lsp.capabilities,
})

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
