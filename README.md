# System Configuration

Samuel Roeca's various files to configure latest versions of Linux Mint and / or Ubuntu. Feel free to use anything you find useful.

## Directories

Files are separated into folders documented below.

### bin/

Executable scripts that are added, by default, to the PATH in my zshrc.

### docs/

Document files for reference and automation. Includes Markdown-formatted notes, dictionaries, etc.

### dotfiles/

My system [dotfiles](https://wiki.archlinux.org/index.php/Dotfiles) can be installed automatically with some useful tools.

- [GNU Stow](https://www.gnu.org/software/stow/) is used to [automate the placement of symbolic links in the home directory](https://alexpearce.me/2016/02/managing-dotfiles-with-stow/).
- [GNU Make](https://www.gnu.org/software/make/) manages the details.

Read the `Makefile` for more information. Run the following command to install necessary dependencies:

```bash
sudo apt install git build-essential stow
```

In order to place the dotfiles in the correct place in your system, run:


```bash
make stow-dotfiles
```

### scripts/

Useful automated scripts for things like system setup and program installation.

## Author

[Samuel Roeca](https://samroeca.com/)
