local os = require'os'
local scan = require'plenary.scandir'
local Path = require('plenary.path')

local git = require 'git-sessions.git'
local config = require'git-sessions.config'

local _M = {}

---@return Path
function _M.get_or_create_branch_sessions_dir()
    local base_dir = config:get().session_dir
    local p = Path:new(base_dir, git.current_repo())
    if not p:exists() then
        p:mkdir()
    end
    return p
end

---@return table
function _M.list_repo_sessions()
    local session_dir = config:get().session_dir
    return scan.scan_dir(session_dir .. git.current_repo(), { depth = 1 })
end

---Find session from current branch
---if not in a git repo will use current working dir name
---@return string
function _M.get_current()
    local session_dir = config:get().session_dir
    local branch = git.current_branch()
    local session

    if branch == nil then
        local cwd = vim.fn.getcwd()
        session = string.gsub(cwd, '(.*)/', '') .. '/main'
    else
        session = git.current_repo() .. '/' .. branch
    end
    return session_dir .. '/' .. session .. '.vim'
end

---@param branch string 
function _M.get_branch_session(branch)
    local session_dir = config:get().session_dir
    local session = git.current_repo() .. '/' .. branch
    return session_dir .. '/' .. session .. '.vim'
end

---@return nil
function _M.save_session()
    local session = _M.get_current()
    _M.get_or_create_branch_sessions_dir()
    vim.notify('Save session: ' .. session)
    vim.cmd('mksession! ' .. session)
end

---@param session string 
function _M.load(session)
    local p = Path:new(session)
    if p:exists() then
        vim.notify("Load session: " .. session, vim.log.levels.INFO)
        vim.cmd("source " .. session)
    else
        vim.notify('No session found', vim.log.levels.INFO)
    end
end

---@param session string 
---@return nil
function _M.delete(session)
    if session ~= nil then
        vim.notify('Delete session: ' .. session, vim.log.levels.INFO)
        os.remove(session)
    end
end

---@param action function 
---@param prompt string 
---@return nil
function _M.select(action, prompt)
    local session_dir = config:get().session_dir
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

---Spawn vim.ui to pick session to load
---@return nil
function _M.select_load()
    _M.select(_M.load, 'Select session:')
end

---Spawn vim.ui to pick session to delete
---@return nil
function _M.select_delete()
    _M.select(_M.delete, 'Delete session:')
end

---@return nil
function _M.clean_sessions()
    -- should delete session when no branch found
end

---@return nil
function _M.checkout()
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
                    _M.load(_M.get_current())
                else
                    vim.notify(res.error, vim.log.levels.ERROR)
                end
            end
        end
    )
    end

return _M
