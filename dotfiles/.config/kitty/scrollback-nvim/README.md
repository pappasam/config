# scrollback-nvim

Kitty scrollback viewer backed by a small Neovim Lua module.

## Kitty config

See ../kitty.conf .

The second argument to the kitten is the plugin root. The kitten uses it to find `lua/scrollback/init.lua` without assuming where this directory is installed.

## Flow

1. Kitty runs `kitty/scrollback.py` as a no-UI kitten.
2. The kitten reads the active window text, metadata, colors, cursor position, and kitty graphics placements.
3. It writes temporary `.json`, `.ansi`, and image files.
4. It launches an overlay `nvim --clean --noplugin`.
5. Neovim runs `lua/scrollback/init.lua`, reads the temp metadata, and renders the scrollback buffer.

The Lua module is plugin-shaped (`lua/scrollback/init.lua`), but the kitten loads it directly with `dofile()` during early Neovim startup.
