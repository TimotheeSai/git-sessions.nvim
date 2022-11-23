local io = require'io'
local Path = require('plenary.path')
local Job = require('plenary.job')

local _M = {}

function _M.current_branch()
    local handle = io.popen('git rev-parse --abbrev-ref HEAD 2>/dev/null')
    local result
    if handle ~= nil then
        result = handle:read("*a")
        handle.close()
    end
    local branch = string.gsub(result, '\n', '')
    if branch ~= "" then
        return branch
    end
end

function _M.local_branches()
    local handle = io.popen('git branch')
    local result
    if handle ~= nil then
        result = handle:read("*a")
        handle.close()
    end
    local branches = {}
    for k in string.gmatch(result, '([^\n* ]+)') do
        table.insert(branches, k)
    end
    return branches
end

function _M.current_repo()
    local handle = io.popen('git rev-parse --show-toplevel 2>/dev/null')
    local result
    if handle ~= nil then
        result = handle:read("*a")
        handle.close()
    end
    local repo = string.gsub(result, '\n', '')
    return repo:match("^.+/(.+)$")
end

function _M.checkout(branch)
    local err = ''
    local res = ''
    local sig

    Job:new({
        command = 'git',
        args = {'checkout', branch},
        cwd = vim.fn.getcwd(),
        on_exit = function(_, return_val)
            sig = return_val
        end,
        on_stderr = function(_, data)
            err = err .. '\n' .. data:gsub('\t', '  ')
        end,
        on_stdout = function(_, data)
            res = res .. '\n' .. data:gsub('\t', '  ')
        end
    }):sync()

    return {result = vim.trim(res), error = vim.trim(err), signal = sig}
end

return _M
