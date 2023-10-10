# ⚙ System Configuration

[Samuel Roeca]'s notes / scripts / [dotfiles] to configure the latest versions of [Ubuntu] and [Linux Mint].

| Concept        | Purpose                                                            |
| -------------- | ------------------------------------------------------------------ |
| [➕ Git]       | Used to version control this code repository.                      |
| [➕ GNU Stow]  | [Automates the placement of symbolic links in the home directory]. |
| [➕ GNU Make]  | Manages the above details.                                         |
| [📁 bin/]      | Executable scripts that are added, by default, to the [PATH].      |
| [📁 docs/]     | Documentation files for reference and automation.                  |
| [📁 dotfiles/] | User dotfiles - used to configure various tools - live here.       |
| [📁 scripts/]  | Scripts for things like system setup and program installation.     |

```bash
sudo apt install git build-essential stow # Install prerequisites
make help # Describe all available Makefile targets
```

[Automates the placement of symbolic links in the home directory]: https://alexpearce.me/2016/02/managing-dotfiles-with-stow/
[Linux Mint]: https://en.wikipedia.org/wiki/Linux_Mint
[PATH]: https://en.wikipedia.org/wiki/PATH_(variable)
[Samuel Roeca]: https://samroeca.com
[Ubuntu]: https://en.wikipedia.org/wiki/Ubuntu
[dotfiles]: https://wiki.archlinux.org/index.php/Dotfiles
[➕ GNU Make]: https://www.gnu.org/software/make/
[➕ GNU Stow]: https://www.gnu.org/software/stow/
[➕ Git]: https://git-scm.com/
[📁 bin/]: ./bin
[📁 docs/]: ./docs
[📁 dotfiles/]: ./dotfiles
[📁 scripts/]: ./scripts
