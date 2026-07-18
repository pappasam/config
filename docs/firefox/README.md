# Firefox Configuration

Step-by-step instructions to configure local files that customize Firefox.

1. Go to `about:support` and find your Profile Directory
2. Pass the directory as the first argument to the `link-chrome.sh` script `bash link-chrome.sh <dir>`
3. Now edit the `userContent.css` file in this directory's `chrome` folder
4. Go to `about:config` and set `toolkit.legacyUserProfileCustomizations.stylesheets` to `true`
5. Close all open Firefox windows, then re-open them. Changes should take effect!

## Plugins

- [Link Hints](https://addons.mozilla.org/en-US/firefox/addon/linkhints/)
- [Markdown Here](https://addons.mozilla.org/en-US/firefox/addon/markdown-here/)
- [Firefox Multi-Account Containers](https://addons.mozilla.org/en-US/firefox/addon/multi-account-containers/)
- [React Developer Tools](https://addons.mozilla.org/en-US/firefox/addon/react-devtools/)
- [Svelte Developer tools](https://addons.mozilla.org/en-US/firefox/addon/svelte-devtools/)
- [uBlock Origin](https://addons.mozilla.org/en-US/firefox/addon/ublock-origin/)

## Bookmarklets

### Don't Mess with Paste

<!-- prettier-ignore -->

```javascript
javascript:forceBrowserDefault=(e=>{e.stopImmediatePropagation();return true;});['copy','cut','paste'].forEach(e=>document.addEventListener(e,forceBrowserDefault,true));
```

[source](https://github.com/jswanner/DontF-WithPaste#bookmarklet)

## Enable Emacs keybindings in GTK and Firefox

<https://support.mozilla.org/en-US/kb/keyboard-shortcuts-perform-firefox-tasks-quickly>

On Cinnamon, set the GTK key theme through Cinnamon's settings namespace:

```bash
gsettings set org.cinnamon.desktop.interface gtk-key-theme "Emacs"
gtk-query-settings | grep gtk-key-theme-name # verify active value
```

Fully restart Firefox after changing it. Emacs bindings such as `Ctrl+W`, `Ctrl+A`, and `Ctrl+E` should then work in text fields and the address bar.

### Documentation

You can find the Emacs key bindings for gtk documented here: `/usr/share/themes/Emacs/`

Note: select-all is not `<C-a>`. Instead, it is `<C-/>`. See: <https://askubuntu.com/a/607920>

### Remove Search Bonnet

Firefox's Unified Search Button is annoying. To restore the plain address bar:

1. Enter `about:config` in the address bar.
2. Accept the warning.
3. Search for: `browser.urlbar.scotchBonnet.enableOverride`
4. Toggle it to `false`

The search-engine dropdown/icon should disappear, while the address bar will continue to handle both URLs and normal searches. Mozilla's current source still defines this preference as controlling the unified-search feature.
