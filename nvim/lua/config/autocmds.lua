-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
--
-- Add any additional autocmds here
-- with `vim.api.nvim_create_autocmd`
--
-- Or remove existing autocmds by their group name (which is prefixed with `lazyvim_` for the defaults)
-- e.g. vim.api.nvim_del_augroup_by_name("lazyvim_wrap_spell")
--
--
vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
  pattern = ".env*",
  callback = function()
    vim.bo.filetype = "text" -- formatter 비활성화
    vim.b.autoformat = false -- 자동 포맷 끄기
    vim.wo.wrap = true -- 화면에서 줄바꿈 (보이기만)
    vim.wo.linebreak = true -- 단어 단위로 줄바꿈
  end,
})
