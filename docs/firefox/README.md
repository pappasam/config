# Firefox Configuration

Step-by-step instructions to configure local files that customize Firefox.

1. Go to `about:support` and find your Profile Directory
2. Pass the directory as the first argument to the `link-chrome.sh` script
   `bash link-chrome.sh <dir>`
3. Now edit the `userContent.css` file in this directory's `chrome` folder
4. Go to `about:config` and set `toolkit.legacyUserProfileCustomizations.stylesheets` to `true`
5. Close all open Firefox windows, then re-open them. Changes should take effect!