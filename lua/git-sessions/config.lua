local Path = require('plenary.path')

local Config = {
    state = {},
    config = {
        create_mappings = true,
        mapping = {
            select      = '<leader>se',
            checkout    = '<leader>sc',
            save        = '<leader>ss',
            load        = '<leader>sl',
            delete      = '<leader>sd',
        },
        session_dir = Path:new(vim.fn.stdpath('data'), 'sessions').filename
    }
}

---@param conf? table
function Config:set(conf)
    if Config then
        self.config = vim.tbl_deep_extend('force', self.config, conf or {})
    end
    return self
end

function Config:get()
    return self.config
end

---@export cfg
return setmetatable(Config, {
    __index = function(this, k)
        return this.state[k]
    end,
    __newindex = function(this, k, v)
        this.state[k] = v
    end,
})
