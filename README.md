# ⚙ System Configuration

[Samuel Roeca](https://samroeca.com)'s notes / scripts / [dotfiles](https://wiki.archlinux.org/index.php/Dotfiles) to configure the latest versions of [Ubuntu](https://en.wikipedia.org/wiki/Ubuntu) and [Linux Mint](https://en.wikipedia.org/wiki/Linux_Mint).

| Concept                                           | Purpose                                                                                                                        |
| ------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------ |
| [➕ Git](https://git-scm.com/)                    | Used to version control this code repository.                                                                                  |
| [➕ GNU Stow](https://www.gnu.org/software/stow/) | [Automates the placement of symbolic links in the home directory](https://alexpearce.me/2016/02/managing-dotfiles-with-stow/). |
| [➕ GNU Make](https://www.gnu.org/software/make/) | Manages the above details.                                                                                                     |
| [📁 bin/](./bin)                                  | Executable scripts that are added, by default, to the [PATH].                                                                  |
| [📁 docs/](./docs)                                | Documentation files for reference and automation.                                                                              |
| [📁 dotfiles/](./dotfiles)                        | User dotfiles - used to configure various tools - live here.                                                                   |
| [📁 scripts/](./scripts)                          | Scripts for things like system setup and program installation.                                                                 |

```bash
sudo apt install git build-essential stow # Install prerequisites
make help # Describe all available Makefile targets
```

[path]: https://en.wikipedia.org/wiki/PATH_(variable)
