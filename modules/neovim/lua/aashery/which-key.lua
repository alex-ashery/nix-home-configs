local has_which_key, which_key = pcall(require, "which-key")

if not has_which_key then
  return
end

which_key.setup({
  preset = "classic",
  triggers = {},
  icons = {
    mappings = false,
  },
})

local function search_keymaps()
  local has_fzf_lua, fzf_lua = pcall(require, "fzf-lua")

  if has_fzf_lua then
    fzf_lua.keymaps({
      previewer = false,
      show_details = false,
    })
  else
    vim.cmd("map")
  end
end

local function map(mode, lhs, rhs, desc)
  vim.keymap.set(mode, lhs, rhs, { silent = true, desc = desc })
end

map("n", "<leader>?", search_keymaps, "Search keybindings")

for _, keymap in ipairs(_G.aashery_shared_keymaps or {}) do
  map(keymap.mode, keymap.lhs, keymap.rhs, keymap.desc)
end

which_key.add({
  { "<leader>c", group = "code" },
  { "<leader>d", group = "diagnostics" },
  { "<leader>l", group = "lists" },
  { "<leader>x", group = "debug" },
})
