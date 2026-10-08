# Agent Configuration

This repository contains system configuration files, scripts, and dotfiles for managing an Ubuntu setup.

## Key Concepts

- `dotfiles/` is managed with GNU Stow — symlinked to the home directory via `make install`
- `bin/` scripts are on PATH
- Run `make help` to see available Makefile targets

## Desktop Preferences

- Use vanilla GNOME behavior and built-in settings. Do not install or rely on GNOME extensions for requested changes.
- If a requested behavior is unavailable natively, explain the limitation rather than introducing an extension dependency.

## Formatting

- Lua files are formatted with Stylua.
- Always run Stylua with the tracked repo config:
    - `stylua --config-path dotfiles/.config/stylua/stylua.toml <files>`
- Do not run bare `stylua` from the repo root; it will not discover the stowed config.
