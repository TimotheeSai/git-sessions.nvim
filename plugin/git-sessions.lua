if vim.g.loaded_git_sessions == 1 then
  return
end
vim.g.loaded_git_sessions = 1

-- create any global command that does not depend on user setup
-- usually it is better to define most commands/mappings in the setup function
-- Be careful to not overuse this file!
local git_sessions = require'git-sessions'

vim.api.nvim_create_user_command(
    "SaveSession",
    git_sessions.save_session,
    {}
)

vim.api.nvim_create_user_command(
    "LoadSession",
    git_sessions.load_session,
    {}
)

vim.api.nvim_create_user_command(
    "SelectSession",
    git_sessions.load_session,
    {}
)

vim.api.nvim_create_user_command(
    "DeleteSession",
    git_sessions.ui_delete_session,
    {}
)

