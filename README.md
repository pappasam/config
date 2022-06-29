# System Configuration

Samuel Roeca's various files to configure latest versions of Linux Mint and / or Ubuntu. Feel free to use anything you find useful.

## Commands

This repository can automatically configure your system. As a prerequisite, run:

```bash
sudo apt install git build-essential stow
```

- [GNU Stow](https://www.gnu.org/software/stow/) is used to [automate the placement of symbolic links in the home directory](https://alexpearce.me/2016/02/managing-dotfiles-with-stow/).
- [GNU Make](https://www.gnu.org/software/make/) manages the details.

Now, using the `Makefile` in this directory with gnu, you can run the following commands:

| Command             | Purpose                                                                                 |
| ------------------- | --------------------------------------------------------------------------------------- |
| `make help`         | Prints each `Makefile` target and its associated help message                           |
| `make stow`         | Runs `stow` in the `dotfiles/` directory, linking files to the user's `$HOME` directory |
| `make clean`        | Removes `stow`-ed links from the user's `$HOME` directory                               |
| `make setup-ubuntu` | Setup Ubuntu for the first time, downloading / installing necessary software            |

## Directories

Files are separated into folders documented below.

### [bin/](./bin)

Executable scripts that are added, by default, to the PATH in my zshrc.

### [docs/](./docs)

Document files for reference and automation. Includes Markdown-formatted notes, dictionaries, etc.

### [dotfiles/](./dotfiles)

My system [dotfiles](https://wiki.archlinux.org/index.php/Dotfiles) live here.

### [scripts/](./scripts)

Useful automated scripts for things like system setup and program installation.

## Author

[Samuel Roeca](https://samroeca.com/)
