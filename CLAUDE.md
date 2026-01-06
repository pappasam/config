# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Overview

This repository contains system configuration files, scripts, and dotfiles for managing the user's Ubuntu setup. It follows a well-organized structure with specific top-level directories:

- `bin/`: Executable scripts that are added to the PATH
- `docs/`: Documentation and reference files
- `dotfiles/`: User configuration dotfiles that are stowed to the home directory using GNU Stow
- `scripts/`: Scripts for system setup and program installation

## Common Commands

### Basic Operations

```bash
# Display available Makefile commands with help messages
make help

# Install stowed dotfiles to home directory
make install

# Run scripts to set up system (apt-install, custom installations)
make run-scripts

# Remove stowed links
make clean
```

### System Setup and Maintenance

```bash
# Install system packages via apt
bash ./scripts/ubuntu/apt-installs.sh

# Install custom tools (docker, rust, ghcup, mise, etc.)
bash ./scripts/ubuntu/custom-installs.sh

# Toggle terminal theme between light and dark mode
togglebackground

# Perform system-wide upgrade (apt, snap, rust, mise)
upgrade
```

## Architecture and Structure

### Dotfiles Management

The repository uses GNU Stow to manage symlinks from the `dotfiles/` directory to the user's home directory. Key configuration files include:

1. Shell Configuration
   - `.zshrc`: Zsh shell configuration with completions, prompts, and plugins
   - `.bashrc`: Bash configuration and utility functions
   - `.profile`: Login shell environment setup
2. Git Configuration
   - `.gitconfig`: Global git settings and aliases
3. Neovim Configuration
   - `.config/nvim/init.vim`: Main Neovim configuration
   - `.config/nvim/lua/packages.lua`: Manage plugins using vim.pack
   - `.config/nvim/lua/settings.lua`: Additional Neovim settings
   - `.config/nvim/ftplugin/`: Language-specific configurations (50+ languages)
   - `.config/nvim/snippets/`: Code snippets for various languages
4. Terminal and UI Configuration
   - `.config/kitty/kitty.conf`: Kitty terminal configuration
   - `.config/starship/starship.toml`: Starship prompt customization
   - `.config/lazygit/config.yml`: Lazygit TUI configuration
5. Tool Configuration
   - `.config/mise/config.toml`: Mise tool and language version management
   - `.config/Code/User/settings.json`: VS Code settings
   - `.config/stylua/stylua.toml`: Lua formatter configuration
   - `.config/pypoetry/config.toml`: Poetry configuration
   - `.rustfmt.toml`, `.npmrc`, `.markdownlintrc`, `.cookiecutterrc`: Various tool configs

### Scripts and Tools

The repository contains several scripts for system setup and maintenance:

1. System Setup
   - `scripts/ubuntu/apt-installs.sh`: Installs common system packages
   - `scripts/ubuntu/custom-installs.sh`: Installs specialized tools and development environments
   - `scripts/ubuntu/firefox-deb.sh`: Installs Firefox from Mozilla's deb repository
   - `scripts/ubuntu/install-curl.sh`: Installs curl with necessary dependencies
2. Developer Tooling
   - Functions in `.bashrc` for setting up Python, Rust, and other development environments
   - Custom utilities for managing Git repositories and virtual environments

### Package Management

The system uses multiple package managers:

1. APT for system packages
2. Snap for containerized applications
3. Mise-en-place for:
   - Programming language versions (Python, Node, Go, Rust, Java, Perl, R)
   - CLI tools (ripgrep, fd, bat, delta, lazygit, k9s, etc.)
   - Language servers (basedpyright, gopls, lua-language-server, typescript-language-server, etc.)
   - Cargo, npm, and pipx packages
4. Custom installers for specific tools (Docker, etc.)

### Development Workflows

The repository includes utilities for various development workflows:

1. Python development with Poetry, uv, and virtualenv
2. Rust development with Cargo and rustup
3. Haskell development with ghcup
4. Git workflow shortcuts and utilities
5. Neovim as the primary editor with LSP configuration

## Documentation

For more detailed information on specific components:

- See `README.md` for a high-level overview
- Explore `docs/` for specific guides and conventions
- Check `scripts/ubuntu/README.md` for system setup information
