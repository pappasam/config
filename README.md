# ⚙ System Configuration

[Samuel Roeca](https://samroeca.com)'s notes / scripts / [dotfiles](https://wiki.archlinux.org/index.php/Dotfiles) to configure the latest versions of [Ubuntu](https://en.wikipedia.org/wiki/Ubuntu) and [Linux Mint](https://en.wikipedia.org/wiki/Linux_Mint). Feel free to use anything you find useful.

## 📜 Commands

This repository can automatically configure your system. As a prerequisite, run:

```bash
sudo apt install git build-essential stow
```

- [Git](https://git-scm.com/) is used to version control this code repository.
- [GNU Stow](https://www.gnu.org/software/stow/) is used to [automate the placement of symbolic links in the home directory](https://alexpearce.me/2016/02/managing-dotfiles-with-stow/).
- [GNU Make](https://www.gnu.org/software/make/) manages the details.

Now, using the [Makefile] in this directory with GNU Make, you can run the following commands:

[makefile]: https://en.wikipedia.org/wiki/Make_(software)#Makefile

| Command                         | Purpose                                                             |
| ------------------------------- | ------------------------------------------------------------------- |
| `make help`                     | Prints each `Makefile` target and its associated help message       |
| `make stow`                     | Runs `stow` on the `dotfiles/` directory, linking to user's [$HOME] |
| `make clean`                    | Removes `stow` managed links from the user's [$HOME]                |
| `make setup-ubuntu`             | Setup Ubuntu for the first time, installing necessary software      |
| `make setup-asdf`               | After `asdf` has been installed, use it to install plugins          |
| `make setup-cinnamon-on-ubuntu` | If desired, make [Cinnamon] Ubuntu's default desktop environment    |

[$home]: https://en.wikipedia.org/wiki/Environment_variable#$HOME
[Cinnamon]: https://en.wikipedia.org/wiki/Cinnamon_(desktop_environment)

## 🔱 Directories

Files are separated into folders documented below.

### [📁 bin/](./bin)

Executable scripts that are added, by default, to the [PATH].

[path]: https://en.wikipedia.org/wiki/PATH_(variable)

### [📁 docs/](./docs)

Document files for reference and automation. Includes Markdown-formatted notes, dictionaries, etc.

### [📁 dotfiles/](./dotfiles)

User dotfiles - used to configure various tools - live here.

### [📁 scripts/](./scripts)

Useful automated scripts for things like system setup and program installation.
