# Mapping F13

The key is physically emitting Linux/X11 keycode `191`, but XKB maps that code to `XF86Tools`, not the `F13` keysym. WebKit therefore sends Murmure `KeyboardEvent.key === "Unidentified"`.

Murmure’s frontend saves that literal value ([use-shortcut-interactions.ts](/home/sroeca/src/lib/murmure/src/features/settings/shortcuts/shortcuts-regular/shortcut-button/hooks/use-shortcut-interactions.ts:83)), while the backend only accepts names such as `f13` ([helpers.rs](/home/sroeca/src/lib/murmure/src-tauri/src/shortcuts/helpers.rs:95)). The save consequently fails as an invalid shortcut.

The underlying X11 listener actually handles this key correctly: raw code `191` is interpreted by Murmure’s `rdev` fork as `F13`, then converted to its internal code ([x11.rs](/home/sroeca/src/lib/murmure/src-tauri/src/shortcuts/platform_linux/x11.rs:271)).

Recommended workaround:

1. Quit Murmure.
2. Open `~/.local/share/com.al1x-ai.murmure/settings.json`.
3. Set:

```json
"record_shortcut": "f13"
```

4. Restart Murmure.

Alternatively, fix the X11 keysym for the current session:

```bash
xmodmap -e 'keycode 191 = F13'
```

Then `xev` should report something like:

```text
keycode 191 (keysym 0xffca, F13)
```

After that, Murmure’s shortcut dialog should recognize it normally.

If this is a Wayland session, `xmodmap` only affects XWayland. Bind F13 through the desktop/compositor to:

```bash
murmure --transcription
```

The underlying Murmure bug is in the settings capture path: it depends on WebKit’s key name while the global listener uses raw X11 codes. No files were changed.
