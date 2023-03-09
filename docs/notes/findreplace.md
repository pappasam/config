# Find and Replace

Finding and replacing across a project is a generally annoying problem that in-editor tooling doesn't always help with. There are many CLI-based options that can help with this, but choosing them can be challenging. This document contains my (current) favorite tools, and will be updated if/when this changes.

## Find/Replace across project

```bash
sd 'pattern-from' 'pattern-to' $(fd --type file '\.py|\.svelte' project_folder)
```

I suggest exploring the options of `sd` and `fd`, since both allow you to toggle between literal matches and regex matches.
