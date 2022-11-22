local os = require'os'
local scan = require'plenary.scandir'
local Path = require('plenary.path')

local git = require 'git-sessions.git'

local _M = {}

function _M.create_branch_sessions_dir(base_dir)
    Path.mkdir(Path:new(base_dir, git.current_repo()))
end

function _M.list_repo(session_dir)
    return scan.scan_dir(session_dir .. git.current_repo(), { depth = 1 })
end

function _M.get_current(session_dir)
    -- find session from current branch
    -- if not in a git repo will use current working dir name
    -- local session_dir = cfg .. '/sessions'
    local branch = git.current_branch()
    local session = branch
    if branch == nil then
        local cwd = vim.fn.getcwd()
        session = string.gsub(cwd, '(.*)/', '')
    end
    return session_dir .. '/' .. session .. '.vim'
end

function _M.save_session(session_dir)
    local session = _M.get_current(session_dir)
    print('Save session: ' .. session)
    vim.cmd('mksession! ' .. session)
end

function _M.load(session_dir, session)
    local saved_sessions = scan.scan_dir(session_dir)
    if session == nil then
        session = _M.get_current(session_dir)
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

function _M.delete(choice)
    if choice ~= nil then
        os.remove(choice)
    end
end

function _M.select(session_dir)
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
                _M.load(choice)
            end
        end
    )
end

function _M.ui_delete_session(session_dir)
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
                _M.delete_(choice)
            end
        end
    )
end

function _M.clean_sessions(session_dir)
    -- should delete session when no branch found
end

return _M
