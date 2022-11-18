-- TODO: config
-- TODO:    save dir/repo
-- TODO:    shortcuts

local io = require'io'
local os = require'os'
local scan = require'plenary.scandir'
local Path = require('plenary.path')

local session_dir = Path:new(vim.fn.stdpath('data'), 'sessions').filename

local _M = {}

function _M.git_branch()
    local handle = io.popen('git rev-parse --abbrev-ref HEAD 2>/dev/null')
    local result = handle:read("*a")
    handle.close()
    local branch = string.gsub(result, '\n', '')
    if branch ~= "" then
        return branch
    end
end

function _M.local_branches()
    local handle = io.popen('git branch')
    local result = handle:read("*a")
    handle.close()
    local branches = {}
    for k in string.gmatch(result, '([^\n]+)') do
        table.insert(branches, k)
    end
    return branches
end

function _M.get_current()
    -- local session_dir = cfg .. '/sessions'
    local branch = _M.git_branch()
    local session = branch
    if branch == nil then
        local cwd = vim.fn.getcwd()
        session = string.gsub(cwd, '(.*)/', '')
    end
    return session_dir .. '/' .. session .. '.vim'
end

function _M.select_session()
    -- local handle = io.popen('ls ' .. session_dir)
    -- local ls = handle:read("*a")
    -- handle.close()
    --
    -- local sessions = {}
    -- for k in string.gmatch(ls, '([^\n]+)') do
    --     table.insert(sessions, k)
    -- end
    local sessions = scan.scan_dir(session_dir)
    vim.ui.select(
        sessions,
        {
            prompt = 'Select session:',
            format_item = function(item)
                if item ~= '' then
                    return string.gsub(item, session_dir .. '/', '')
                end
            end,
        },
        function(choice)
            if choice ~= '' then
                _M.load_session(choice)
            end
        end
)
end

function _M.save_session()
    local session = _M.get_current()
    print('Save session: ' .. session)
    vim.cmd('mksession! ' .. session)
end

function _M.load_session(session)
    local saved_sessions = scan.scan_dir(session_dir)
    if session == nil then
        session = _M.get_current()
    end
    local loaded = false

    for i=1,#saved_sessions do
        if saved_sessions[i] == session then
            print("Load session: " .. session)
            vim.cmd("source " .. session)
            loaded = true
            break
        end
    end
    if not loaded then print('No session found') end
end

function _M.delete_session(choice)
    if choice ~= nil then
        os.remove(choice)
    end
end

function _M.ui_delete_session()
    local sessions = scan.scan_dir(session_dir)
    vim.ui.select(
        sessions,
        {
            prompt = 'Delete session:',
            format_item = function(item)
                if item ~= '' then
                    return string.gsub(item, session_dir .. '/', '')
                end
            end,
        },
        function(choice)
            if choice ~= '' then
                print('Delete session: ' .. choice)
                _M.delete_session(choice)
            end
        end
)
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
