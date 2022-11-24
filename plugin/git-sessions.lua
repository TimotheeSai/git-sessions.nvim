if vim.fn.has("nvim-0.7.0") == 0 then
  vim.api.nvim_err_writeln("git-sessions requires at least nvim-0.7.0.1")
  return
end

if vim.g.loaded_git_sessions == 1 then
  return
end
vim.g.loaded_git_sessions = 1

vim.api.nvim_create_user_command(
    "SaveSession",
    function()
        require'git-sessions.sessions'.save_session()
    end,
    {}
)

vim.api.nvim_create_user_command(
    "LoadSession",
    function()
        local s = require'git-sessions'.get_current()
        require'git-sessions'.load(s)
    end,
    {}
)

vim.api.nvim_create_user_command(
    "SelectSession",
    function()
        require'git-sessions'.select_load()
    end,
    {}
)

vim.api.nvim_create_user_command(
    "DeleteSession",
    function()
        require'git-sessions'.select_delete()
    end,
    {}
)

vim.api.nvim_create_user_command(
    "CheckoutSession",
    function()
        require'git-sessions'.checkout()
    end,
    {}
)
