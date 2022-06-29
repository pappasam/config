# System Configuration

Samuel Roeca's various files to configure latest versions of Linux Mint and / or Ubuntu. Feel free to use anything you find useful.

## dotfiles/

My system [dotfiles](https://wiki.archlinux.org/index.php/Dotfiles) can be installed automatically with some useful tools.

- [GNU Stow](https://www.gnu.org/software/stow/) is used to [automate the placement of symbolic links in the home directory](https://alexpearce.me/2016/02/managing-dotfiles-with-stow/).
- [GNU Make](https://www.gnu.org/software/make/) manages the details.

Read the `Makefile` for more information.

```bash
# Install system dependencies if not already installed
sudo apt install git build-essential stow
# Now place the dotfiles
make
```

## Author

[Samuel Roeca](https://samroeca.com/)
