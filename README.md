# ⚙ System Configuration

[Samuel Roeca](https://samroeca.com)'s notes / scripts / [dotfiles](https://wiki.archlinux.org/index.php/Dotfiles) to configure the latest versions of [Ubuntu](https://en.wikipedia.org/wiki/Ubuntu) and [Linux Mint](https://en.wikipedia.org/wiki/Linux_Mint).

| Prerequisite                                   | Purpose                                                                                                                        |
| ---------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------ |
| [Git](https://git-scm.com/)                    | Used to version control this code repository.                                                                                  |
| [GNU Stow](https://www.gnu.org/software/stow/) | [Automates the placement of symbolic links in the home directory](https://alexpearce.me/2016/02/managing-dotfiles-with-stow/). |
| [GNU Make](https://www.gnu.org/software/make/) | Manages the above details.                                                                                                     |

```bash
sudo apt install git build-essential stow # Install prerequisites
make # Echo Makefile targets and associated help messages
make stow # Run stow on "dotfiles/" directory, linking user's $HOME
make clean # Remove stow managed links from user's $HOME
make setup-ubuntu # Set up Ubuntu for the first time
make setup-asdf # Install asdf plugins
make setup-cinnamon-on-ubuntu # Use the Cinnamon desktop environment
```

| Directory                  | Purpose                                                        |
| -------------------------- | -------------------------------------------------------------- |
| [📁 bin/](./bin)           | Executable scripts that are added, by default, to the [PATH].  |
| [📁 docs/](./docs)         | Documentation files for reference and automation.              |
| [📁 dotfiles/](./dotfiles) | User dotfiles - used to configure various tools - live here.   |
| [📁 scripts/](./scripts)   | Scripts for things like system setup and program installation. |

[path]: https://en.wikipedia.org/wiki/PATH_(variable)
