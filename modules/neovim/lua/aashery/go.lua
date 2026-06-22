local lsp = require("aashery.lsp")

vim.lsp.config("gopls", {
  on_attach = lsp.on_attach,
  capabilities = lsp.capabilities,
})

local gopls_enabled = false
local dap_go_configured = false

local enable_gopls_if_available = function()
  if gopls_enabled then
    return
  end

  if vim.fn.executable("gopls") == 1 and vim.fn.executable("go") == 1 then
    gopls_enabled = true
    vim.lsp.enable("gopls")
  end
end

local configure_dap_go_if_available = function()
  if dap_go_configured then
    return
  end

  if vim.fn.executable("go") ~= 1 or vim.fn.executable("dlv") ~= 1 then
    return
  end

  local has_dap_go, dap_go = pcall(require, "dap-go")
  if not has_dap_go then
    return
  end

  dap_go_configured = true
  dap_go.setup({})
end

vim.api.nvim_create_autocmd({ "VimEnter", "BufEnter", "DirChanged" }, {
  callback = function()
    vim.defer_fn(enable_gopls_if_available, 100)
    vim.defer_fn(configure_dap_go_if_available, 100)
  end,
})

vim.api.nvim_create_autocmd("FileType", {
  pattern = "go",
  callback = function()
    vim.defer_fn(enable_gopls_if_available, 100)
    vim.defer_fn(configure_dap_go_if_available, 100)
    vim.opt_local.expandtab = false
    vim.opt_local.tabstop = 4
    vim.opt_local.shiftwidth = 4
    vim.opt_local.softtabstop = 4
  end,
})
