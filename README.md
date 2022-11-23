# git-sessions.nvim

Use vanilla nvim `:mksession` to keep layout and buffers in sync with current git branch

**WIP** - This is a first attempt to create a plugin for neovim, feel free to make any suggestion.

## Usage

Save and load sessions from the current git branch. All sessions are stored into `session_dir` directory.
Use `:CheckoutSession` to checkout a branch and switch to the corresponding session.

### Commands

```vim
SaveSession     "Save current session into {session_dir}/{git_repo}/{git_branch}.nvim 
LoadSession     "Load current session from {session_dir}/{git_repo}/{git_branch}.nvim 
SelectSession   "Pick session to select from {session_dir} 
DeleteSession   "Pick session to delete from {session_dir} 
CheckoutSession "Pick branch to checkout and load session from
```

### Options

Default config:
```lua
{
    create_mappings = true,        -- create mapping for commands
    mapping = {
        select      = '<leader>se', --mapping for SelectSession
        checkout    = '<leader>sc', --mapping for CheckoutSession
        save        = '<leader>ss', --mapping for SaveSession
        load        = '<leader>sl', --mapping for LoadSession
        delete      = '<leader>sd', --mapping for DeleteSession
    },
    session_dir = Path:new(vim.fn.stdpath('data'), 'sessions').filename -- $HOME/.local/share/nvim/sessions/
}
```

As `mksession` is used, session options ar set with `vim.o.sessionoptions`, see `:h sessionoptions` for more detail

## Installation

### Requirements

- `git`
- `neovim > 0.7.0`
- `nvim-lua/plenary.nvim`
- _optional_ : `stevearc/dressing.nvim`

### Using Packer

```lua
use {
    'TimotheeSai/git-sessions.nvim',
    requires = {
        {'nvim-lua/plenary.nvim'},
        {'stevearc/dressing.nvim'} --optional
    },
    config = function()
        require('git-sessions').setup()
    end
}

```

