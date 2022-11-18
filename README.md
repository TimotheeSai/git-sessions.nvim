# git-sessions.nvim

Use vanilla nvim sessions to keep layout and buffers in sync with current git branch

## Installation

### Requirements

- `git`
- `nvim-lua/plenary.nvim`

## Usage

### Commands

```
SaveSession
LoadSession
SelectSession
DeleteSession
```

### Options

Default config:
```
{
    create_mapping      =        true,
    select_mapping      =       '<Leader>sc',
    save_mapping        =       '<Leader>ss',
    load_mapping        =       '<Leader>sl',
    delete_mapping      =       '<Leader>sd',
    save_session_dir    =       Path:new(vim.fn.stdpath('data'), 'sessions').filename
}
```

