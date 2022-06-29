# Some notes about using Git effectively

I often do a web search for the above info. To reduce my overall bandwith usage, I'm writing down my most-searched concepts here.

## Rebasing

**Add upstream to local repo**

```bash
git clone REPO_MINE
cd REPO_MINE
git remote add upstream REPO_UPSTREAM
```

**Rebase**

```bash
git fetch upstream
git rebase upstream/master
```
