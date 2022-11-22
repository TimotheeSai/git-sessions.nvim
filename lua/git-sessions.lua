local io = require'io'
local os = require'os'
local scan = require'plenary.scandir'
local Path = require('plenary.path')

local session_dir = Path:new(vim.fn.stdpath('data'), 'sessions').filename

local git = require 'git-sessions.git'
local sessions = require 'git-sessions.sessions'

local _M = {}

function _M.git_branch()
    return git.current_branch()
end

function _M.local_branches()
    return git.local_branches()
end

function _M.get_current()
    return sessions.get_current(session_dir)
end

function _M.select()
    return sessions.select(session_dir)
end

function _M.save_session()
    return sessions.save_session(session_dir)
end

function _M.load_session(session)
    sessions.load(session_dir, session)
end

function _M.ui_delete_session()
    sessions.ui_delete_session(session_dir)
end

_M.config = {
    create_mapping = true,
    mapping = {
        select = '<Leader>sc',
        save = '<Leader>ss',
        load = '<Leader>sl',
        delete = '<Leader>sd',
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
            sessions.load(_M.config.session_dir)
        end,
        {}
    )

    vim.api.nvim_create_user_command(
        "SelectSession",
        function()
            sessions.select(_M.config.session_dir)
        end,
        {}
    )

    vim.api.nvim_create_user_command(
        "DeleteSession",
        function()
            sessions.ui_delete_session(_M.config.session_dir)
        end,
        {}
    )

    if _M.config.create_mappings then
        local opts = { noremap = false }
        vim.keymap.set('n', _M.config.mapping.save, 'SaveSession', opts)
        vim.keymap.set('n', _M.config.mapping.load, 'LoadSession', opts)
        vim.keymap.set('n', _M.config.mapping.select, 'SelectSession', opts)
        vim.keymap.set('n', _M.config.mapping.delete, 'DeleteSession', opts)
    end
end

return _M
