local has_fzf_lua, fzf_lua = pcall(require, "fzf-lua")

local function opts(bufnr, desc)
  return { buffer = bufnr, silent = true, desc = desc }
end

local on_attach = function(_, bufnr)
  vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts(bufnr, "Go to definition"))
  vim.keymap.set("n", "gr", vim.lsp.buf.references, opts(bufnr, "References"))
  vim.keymap.set("n", "K", vim.lsp.buf.hover, opts(bufnr, "Hover"))
  vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, opts(bufnr, "Code action"))
  vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts(bufnr, "Rename"))
  vim.keymap.set("n", "<leader>dp", vim.diagnostic.goto_prev, opts(bufnr, "Previous diagnostic"))
  vim.keymap.set("n", "<leader>dn", vim.diagnostic.goto_next, opts(bufnr, "Next diagnostic"))
  vim.keymap.set("n", "<leader>df", vim.diagnostic.open_float, opts(bufnr, "Diagnostic float"))
  vim.keymap.set("n", "<leader>dl", function()
    if has_fzf_lua then
      fzf_lua.diagnostics_document()
    else
      vim.diagnostic.setloclist({ open = false })
      vim.cmd("lopen")
    end
  end, opts(bufnr, "Document diagnostics"))
end

local capabilities = require("cmp_nvim_lsp").default_capabilities(
  vim.lsp.protocol.make_client_capabilities()
)

return {
  on_attach = on_attach,
  capabilities = capabilities,
}
