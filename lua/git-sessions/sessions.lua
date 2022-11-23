local os = require'os'
local scan = require'plenary.scandir'
local Path = require('plenary.path')

local git = require 'git-sessions.git'

local _M = {}

function _M.get_or_create_branch_sessions_dir(base_dir)
    local p = Path:new(base_dir, git.current_repo())
    if not p:exists() then
        p:mkdir()
    end
    return p
end

function _M.list_repo_sessions(session_dir)
    return scan.scan_dir(session_dir .. git.current_repo(), { depth = 1 })
end

function _M.get_current(session_dir)
    -- find session from current branch
    -- if not in a git repo will use current working dir name
    -- local session_dir = cfg .. '/sessions'
    local branch = git.current_branch()
    local session
    if branch == nil then
        local cwd = vim.fn.getcwd()
        session = string.gsub(cwd, '(.*)/', '')
    else
        session = git.current_repo() .. '/' .. branch
    end
    return session_dir .. '/' .. session .. '.vim'
end

function _M.get_branch_session(session_dir, branch)
    local session = git.current_repo() .. '/' .. branch
    return session_dir .. '/' .. session .. '.vim'
end

function _M.save_session(session_dir)
    local session = _M.get_current(session_dir)
    _M.get_or_create_branch_sessions_dir(session_dir)
    vim.notify('Save session: ' .. session)
    vim.cmd('mksession! ' .. session)
end

function _M.load(session)
    local p = Path:new(session)
    if p:exists() then
        vim.notify("Load session: " .. session, vim.log.levels.INFO)
        vim.cmd("source " .. session)
    else
        vim.notify('No session found', vim.log.levels.INFO)
    end
end

function _M.delete(session)
    if session ~= nil then
        vim.notify('Delete session: ' .. session, vim.log.levels.INFO)
        os.remove(session)
    end
end

function _M.select(session_dir, action, prompt)
    local sessions = scan.scan_dir(session_dir)
    vim.ui.select(
        sessions,
        {
            prompt = prompt,
            format_item = function(item)
                if item ~= '' then
                    return Path:new(item):make_relative(session_dir)
                end
            end,
        },
        function(choice)
            if choice ~= '' and choice then
                action(choice)
            end
        end
    )
end

function _M.select_load(session_dir)
    _M.select(session_dir, _M.load, 'Select session:')
end

function _M.select_delete(session_dir)
    _M.select(session_dir, _M.delete, 'Delete session:')
end

function _M.clean_sessions(session_dir)
    -- should delete session when no branch found
end

function _M.checkout(session_dir)
    vim.ui.select(
        git.local_branches(),
        {
            prompt = 'branch',
            format_item = function(item)
                if item == git.current_branch() then
                    return '* ' .. item
                end
                return '  ' .. item
            end,
        },
        function(choice)
            if choice ~= '' and choice then
                local res = git.checkout(choice)
                if res.signal == 0 then
                    vim.notify(res.result, vim.log.levels.INFO)
                    print('')
                    _M.load(_M.get_current(session_dir))
                else
                    vim.notify(res.error, vim.log.levels.ERROR)
                end
            end
        end
    )
    end

return _M
