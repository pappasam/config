# dotfiles

Samuel Roeca's personal [dotfiles](https://wiki.archlinux.org/index.php/Dotfiles) for Linux Mint / Ubuntu. Feel free to use anything you find useful.

## Setup

GNU Stow [automates](https://alexpearce.me/2016/02/managing-dotfiles-with-stow/) the placement of symbolic links in the home directory. [GNU Make](https://www.gnu.org/software/make/) manages the details. Read the `Makefile` for more information.

Unfortunately, GNU Stow's development has been slowed down by various issues, like [this](https://github.com/aspiers/stow/issues/65). To avoid stow's bugs, I use [xstow](https://github.com/rspeed/xstow), a replacement for GNU stow written in C++.

```bash
# Install system dependencies if not already installed
sudo apt install git build-essential xstow
# Now place the dotfiles
make
```

## Author

[Samuel Roeca](https://samroeca.com/)
