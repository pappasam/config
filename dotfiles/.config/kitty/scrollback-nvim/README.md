# scrollback-nvim

Kitty scrollback viewer backed by a small Neovim Lua module.

## Kitty config

See `../kitty.conf` for an example configuration.

The second argument to the kitten is the plugin root. The kitten uses it to find `lua/scrollback/init.lua` without assuming where this directory is installed.

## Flow

1. Kitty runs `kitty/scrollback.py` as a no-UI kitten.
2. The kitten reads the active window text, metadata, colors, cursor position, and kitty graphics placements.
3. It writes temporary `.json`, `.ansi`, and image files.
4. It launches an overlay `nvim --clean --noplugin`.
5. Neovim runs `lua/scrollback/init.lua`, reads the temp metadata, and renders the scrollback buffer.

The Lua module is plugin-shaped (`lua/scrollback/init.lua`), but the kitten loads it directly with `dofile()` during early Neovim startup.

## Images

Image support currently emits raw [kitty graphics protocol](https://sw.kovidgoyal.net/kitty/graphics-protocol/) escape sequences via `nvim_ui_send()`. This works because the scrollback pager always runs inside kitty.

[neovim/neovim#39434](https://github.com/neovim/neovim/issues/39434) proposes adding `ext_images` UI events to Neovim so that `vim.ui.img` works across all frontends, not just terminals. Once that lands, the image code in `lua/scrollback/init.lua` (`kitty_transmit`, `kitty_place`, `kitty_delete_placement`, `kitty_delete_image`, `update_image_placements`) could be replaced with `vim.ui.img()` calls, removing the kitty-specific escape sequence handling entirely.
