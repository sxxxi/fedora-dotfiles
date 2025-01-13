# NOTES

# Navigation
## Indent
* `<` AND `>`: Shift line left or right
    * Relevant options: [`shiftwidth`, `shiftround`]

## Search
* `*` & `#`: Search next/previous occurrence of the word under the cursor



# NVIM
## Reload `init.lua`
* `luafile init.lua` in cmd mode

## Mapping
* `vim.keymap.set('MODE', 'KEYMAP', 'ACTION')`
    * MODE: `n` for normal, 'c' for command
    * ACTION: Can be a string or a callback

## Autocommand
* `vim.api.nvim_create_autocmd(event: str|str[], options: {pattern: str[], command: str)} | {pattern: str[], command: str)})`

## Terminal Mode
When in `--TERMINAL--` mode, press `<C-\><C-n>` to enter command mode.

## Windows or Tabs
- `<C-w>` = Traverse to next window
    - `q` to quit
    - `n` new tab
    - `<C-w>` next tab

# Cool shit
- `vim.bo`: Buffer options
- Use `:arg <file_regex>` to load file in the argument list, then `:argdo <action>` to execute action in each file loaded in the argument list like substitution. Cool stuff


