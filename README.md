# dotfiles

Samuel Roeca's personal [dotfiles](https://wiki.archlinux.org/index.php/Dotfiles) for Linux Mint 19 / Ubuntu 18. Feel free to use anything you find useful.

## Setup

GNU Stow [automates](https://alexpearce.me/2016/02/managing-dotfiles-with-stow/) the placement of symbolic links in the home directory. [GNU Make](https://www.gnu.org/software/make/) manages the details. Read the `Makefile` for more information.

```bash
# Install system dependencies if not already installed
sudo apt install git build-essential stow
# Now place the dotfiles
make
```

## Author

Samuel Roeca _samuel.roeca@gmail.com_
