local has_fzf_lua, fzf_lua = pcall(require, "fzf-lua")

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

return {
  on_attach = on_attach,
  capabilities = capabilities,
}
