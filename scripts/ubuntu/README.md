# Ubuntu Scripts

Most of these scripts will work on the latest stable versions of Ubuntu. Unless the script itself is also prefixed with `ubuntu-`, assume it can also be used on the latest stable version of Linux Mint.

## Manual commands

This section of the README describes useful programs you will need to install - or configure - manually, when the time is right.

### Less

If you'd like to use the latest version of `less`, do the following:

```bash
sudo apt remove less
```

Download the latest recommended version from: <www.greenwoodsoftware.com/less/download.html>. Follow installation instructions to compile from source.

### Keepass

Use: <https://keeweb.info/>

If you encouter errors opening application, add `--no-sandbox` to `/usr/share/applications/keeweb.desktop`. See <https://github.com/keeweb/keeweb/issues/1975>

Relevant line: `Exec=keeweb --no-sandbox %u`

### Fonts

Download relevant nerd fonts from here: <https://www.nerdfonts.com/font-downloads>

1. Download a Nerd Font (I recommend `FiraMono Nerd Font` as of 2023-09-28).
2. Unzip and copy to `~/.local/share/fonts`. In the past, this was `~/.fonts` and `~/.fontconfig`.
3. Optionally, run the command `fc-cache -fv` to manually rebuild the font cache.

### Pandoc

The available version in software repository is not the latest build. Use the provided deb package under Pandoc releases <https://github.com/jgm/pandoc/releases>
