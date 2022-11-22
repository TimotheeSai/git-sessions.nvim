local io = require'io'
local Path = require('plenary.path')

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
    for k in string.gmatch(result, '([^\n]+)') do
        table.insert(branches, k)
    end
    return branches
end

function _M.current_repo()
    local handle = io.popen('git rev-parse --show-toplevel')
    local result
    if handle ~= nil then
        result = handle:read("*a")
        handle.close()
    end
    local repo = string.gsub(result, '\n', '')
    print(vim.inspect(Path:new(repo)))
    return repo:match("^.+/(.+)$")
end

function _M.checkout(branch)
end

return _M
