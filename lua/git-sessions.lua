local Path = require('plenary.path')
local sessions = require 'git-sessions.sessions'

local _M = {}

_M.config = {
    create_mappings = true,
    mapping = {
        select = '<leader>sc',
        save = '<leader>ss',
        load = '<leader>sl',
        delete = '<leader>sd',
    },
    session_dir = Path:new(vim.fn.stdpath('data'), 'sessions').filename
}

function _M.setup(user_opts)
    _M.config = vim.tbl_extend("force", _M.config, user_opts or {})

    vim.api.nvim_create_user_command(
        "SaveSession",
        function()
            sessions.save_session(_M.config.session_dir)
        end,
        {}
    )

    vim.api.nvim_create_user_command(
        "LoadSession",
        function()
            local s = sessions.get_current(_M.config.session_dir)
            sessions.load(s)
        end,
        {}
    )

    vim.api.nvim_create_user_command(
        "SelectSession",
        function()
            sessions.select_load(_M.config.session_dir)
        end,
        {}
    )

    vim.api.nvim_create_user_command(
        "DeleteSession",
        function()
            sessions.select_delete(_M.config.session_dir)
        end,
        {}
    )

    if _M.config.create_mappings == true then
        local opts = { noremap = false }
        vim.keymap.set('n', _M.config.mapping.save, ':SaveSession<CR>', opts)
        vim.keymap.set('n', _M.config.mapping.load, ':LoadSession<CR>', opts)
        vim.keymap.set('n', _M.config.mapping.select, ':SelectSession<CR>', opts)
        vim.keymap.set('n', _M.config.mapping.delete, ':DeleteSession<CR>', opts)
    end
end

return _M
