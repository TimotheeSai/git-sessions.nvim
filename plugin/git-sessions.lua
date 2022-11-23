if vim.fn.has("nvim-0.7.0") == 0 then
  vim.api.nvim_err_writeln("git-sessions requires at least nvim-0.7.0.1")
  return
end

if vim.g.loaded_git_sessions == 1 then
  return
end
vim.g.loaded_git_sessions = 1
