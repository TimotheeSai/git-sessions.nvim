# git-sessions.nvim

**WIP** - Use vanilla nvim sessions to keep layout and buffers in sync with current git branch

## Installation

### Requirements

- `git`
- `nvim-lua/plenary.nvim`

### Using Packer

```lua
use {
    'TimotheeSai/git-sessions.nvim',
    requires = {
        {'nvim-lua/plenary.nvim'}
    },
    config = function()
        require('git-sessions').setup()
    end
}

```

## Usage

### Commands

```vim
SaveSession     "Save current session into {session_dir}/{git_repo}/{git_branch}.nvim 
LoadSession     "Load current session from {session_dir}/{git_repo}/{git_branch}.nvim 
SelectSession   "Pick session to select from {session_dir} 
DeleteSession   "Pick session to delete from {session_dir} 
```

### Options

Default config:
```lua
{
    create_mappings = true,
    mapping = {
        select = '<leader>sc',
        save = '<leader>ss',
        load = '<leader>sl',
        delete = '<leader>sd',
    },
    session_dir = Path:new(vim.fn.stdpath('data'), 'sessions').filename
}
```

