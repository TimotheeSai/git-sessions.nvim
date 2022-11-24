local Path = require('plenary.path')
local sessions = require 'git-sessions.sessions'

local _M = {}

---@param user_opts? table
function _M.setup(user_opts)
    local cfg = require('git-sessions.config'):set(user_opts):get()

    if cfg.create_mappings == true then
        local opts = { noremap = false }
        vim.keymap.set('n', cfg.mapping.save, ':SaveSession<CR>', opts)
        vim.keymap.set('n', cfg.mapping.load, ':LoadSession<CR>', opts)
        vim.keymap.set('n', cfg.mapping.checkout, ':CheckoutSession<CR>', opts)
        vim.keymap.set('n', cfg.mapping.select, ':SelectSession<CR>', opts)
        vim.keymap.set('n', cfg.mapping.delete, ':DeleteSession<CR>', opts)
    end
end

return _M
