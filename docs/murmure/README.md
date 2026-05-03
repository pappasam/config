# Murmure

Murmure's portable configuration format is a `.murmure` JSON file.
This directory keeps the repo-backed copy:

```text
docs/murmure/config.murmure
```

Import it into Murmure with:

```bash
make murmure-import
```

Refresh it from this machine's current Murmure settings with:

```bash
make murmure-sync
```

Murmure also stores runtime state under:

```text
~/.local/share/com.al1x-ai.murmure/
```

Those files include WebKit cache, logs, stats, and app state, so they
are not backed up directly.
