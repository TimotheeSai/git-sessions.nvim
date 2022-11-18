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

function _M.select_session()
    return sessions.select_session(session_dir)
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
    select_mapping = '<Leader>sc',
    save_mapping = '<Leader>ss',
    load_mapping = '<Leader>sl',
    delete_mapping = '<Leader>sd',
    save_session_dir = Path:new(vim.fn.stdpath('data'), 'sessions').filename
}

function _M.setup(user_opts)
    _M.config = vim.tbl_extend("force", _M.config, user_opts or {})

    if _M.config.create_mappings then
        local opts = { noremap = false }
        vim.keymap.set('n', '<Leader>ss', _M.save_session, opts)
        vim.keymap.set('n', '<Leader>sl', _M.load_session, opts)
        vim.keymap.set('n', '<Leader>sc', _M.select_session, opts)
        vim.keymap.set('n', '<Leader>sd', _M.ui_delete_session, opts)
  end
end

return _M
