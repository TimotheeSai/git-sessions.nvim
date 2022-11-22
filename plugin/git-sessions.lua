if vim.g.loaded_git_sessions == 1 then
  return
end
vim.g.loaded_git_sessions = 1

-- create any global command that does not depend on user setup
-- usually it is better to define most commands/mappings in the setup function
-- Be careful to not overuse this file!
