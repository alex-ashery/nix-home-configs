local has_dap, dap = pcall(require, "dap")

if not has_dap then
  return
end

local has_dap_view, dap_view = pcall(require, "dap-view")
if has_dap_view then
  dap_view.setup({})
end

vim.keymap.set("n", "<F5>", dap.continue, { silent = true })
vim.keymap.set("n", "<F10>", dap.step_over, { silent = true })
vim.keymap.set("n", "<F11>", dap.step_into, { silent = true })
vim.keymap.set("n", "<F12>", dap.step_out, { silent = true })
vim.keymap.set("n", "<leader>xc", dap.continue, { silent = true })
vim.keymap.set("n", "<leader>xo", dap.step_over, { silent = true })
vim.keymap.set("n", "<leader>xi", dap.step_into, { silent = true })
vim.keymap.set("n", "<leader>xu", dap.step_out, { silent = true })
vim.keymap.set("n", "<leader>xt", dap.toggle_breakpoint, { silent = true })
vim.keymap.set("n", "<leader>xB", function()
  dap.set_breakpoint(vim.fn.input("Breakpoint condition: "))
end, { silent = true })
vim.keymap.set("n", "<leader>xr", dap.repl.open, { silent = true })
vim.keymap.set("n", "<leader>xR", dap.run_last, { silent = true })
if has_dap_view then
  vim.keymap.set("n", "<leader>xv", dap_view.toggle, { silent = true })
end

vim.fn.sign_define("DapBreakpoint", { text = "B", texthl = "DiagnosticSignError" })
vim.fn.sign_define("DapStopped", { text = ">", texthl = "DiagnosticSignInfo" })

return dap
