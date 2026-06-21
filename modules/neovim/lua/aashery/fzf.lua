local has_fzf_lua, fzf_lua = pcall(require, "fzf-lua")

if has_fzf_lua then
  fzf_lua.setup({})
end
