# ⚙ System Configuration

[Samuel Roeca]'s notes / scripts / [dotfiles] to configure the latest versions of [Ubuntu] and [Linux Mint].

```bash
sudo apt install git # For version control
sudo apt install build-essential # Installs 'make'
sudo apt install stow # Manages symbolic links
make # Describe all available Makefile targets
```

Top-level directories are documented below.

- `bin/` Executable scripts that are added, by default, to the [PATH].
- `docs/` Documentation files for reference and automation.
- `dotfiles/` User dotfiles live here and are automatically organized on your system by [stow].
- `scripts/` Scripts for things like system setup and program installation.

[Linux Mint]: https://en.wikipedia.org/wiki/Linux_Mint
[PATH]: https://en.wikipedia.org/wiki/PATH_(variable)
[Samuel Roeca]: https://samroeca.com
[Ubuntu]: https://en.wikipedia.org/wiki/Ubuntu
[dotfiles]: https://wiki.archlinux.org/index.php/Dotfiles
[stow]: https://alexpearce.me/2016/02/managing-dotfiles-with-stow/
