# System Configuration

Samuel Roeca's various files to configure latest versions of Linux Mint and / or Ubuntu. Feel free to use anything you find useful.

## Commands

This repository can automatically configure your system. As a prerequisite, run:

```bash
sudo apt install git build-essential stow
```

- [Git](https://git-scm.com/) is used to version control this code repository.
- [GNU Stow](https://www.gnu.org/software/stow/) is used to [automate the placement of symbolic links in the home directory](https://alexpearce.me/2016/02/managing-dotfiles-with-stow/).
- [GNU Make](https://www.gnu.org/software/make/) manages the details.

Now, using the `Makefile` in this directory with GNU Make, you can run the following commands:

| Command                         | Purpose                                                             |
| ------------------------------- | ------------------------------------------------------------------- |
| `make help`                     | Prints each `Makefile` target and its associated help message       |
| `make stow`                     | Runs `stow` on the `dotfiles/` directory, linking to user's `$HOME` |
| `make clean`                    | Removes `stow` managed links from the user's `$HOME`                |
| `make setup-ubuntu`             | Setup Ubuntu for the first time, installing necessary software      |
| `make setup-asdf`               | After `asdf` has been installed, use it to install plugins          |
| `make setup-cinnamon-on-ubuntu` | If desired, make cinnamon Ubuntu's default desktop environment      |

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
