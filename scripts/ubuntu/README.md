# Ubuntu Scripts

Most of these scripts will work on the latest stable versions of Ubuntu. Unless the script itself is also prefixed with `ubuntu-`, assume it can also be used on the latest stable version of Linux Mint.

## Manual commands

This section of the README describes useful programs you will need to install - or configure - manually, when the time is right.

### Default shell as zsh

If you would like to make zsh your default shell, migrate your `.bashrc` to `.zshrc` and run the following (one time) from your terminal:

```bash
chsh -s "$(which zsh)"
```

### Less

If you'd like to use the latest version of `less`, do the following:

```bash
sudo apt remove less
```

Download the latest recommended version from: <www.greenwoodsoftware.com/less/download.html>. Follow installation instructions to compile from source.

### Keepass

Use: <https://keeweb.info/>

### Insomnia

Install the latest version from: <https://insomnia.rest/download>

### Fonts

Download relevant nerd fonts from here: <https://www.nerdfonts.com/font-downloads>

1. Download a Nerd Font
2. Unzip and copy to `~/.fonts`
3. Run the command `fc-cache -fv` to manually rebuild the font cache.

### Pandoc

The available version in software repository is not the latest build. Use the provided deb package under Pandoc releases <https://github.com/jgm/pandoc/releases>

### Docker

Follow instructions here: <https://docs.docker.com/engine/install/ubuntu/>
