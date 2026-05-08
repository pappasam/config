# Claude Code User Settings

These dotfiles are stowed to `~/.claude/`. Below is a recommended portable
`settings.json` baseline (place at `~/.claude/settings.json`):

```json
{
  "$schema": "https://json.schemastore.org/claude-code-settings.json",

  "statusLine": {
    "type": "command",
    "command": "starship statusline claude-code"
  },

  "permissions": {
    "allow": [
      "Read",

      "Bash(git status*)",
      "Bash(git log*)",
      "Bash(git diff*)",
      "Bash(git show*)",
      "Bash(git branch*)",
      "Bash(git stash*)",
      "Bash(git rev-parse*)",
      "Bash(git remote -v*)",
      "Bash(git blame*)",
      "Bash(git shortlog*)",
      "Bash(git tag*)",
      "Bash(git ls-files*)",
      "Bash(git config --get*)",
      "Bash(git add *)",
      "Bash(git commit *)",
      "Bash(git switch *)",

      "Bash(ls *)",
      "Bash(find *)",
      "Bash(tree *)",
      "Bash(grep *)",
      "Bash(rg *)",
      "Bash(fd *)",
      "Bash(wc *)",
      "Bash(stat *)",
      "Bash(file *)",
      "Bash(which *)",
      "Bash(type *)",
      "Bash(cat *)",
      "Bash(head *)",
      "Bash(tail *)",
      "Bash(sort *)",
      "Bash(uniq *)",
      "Bash(cut *)",
      "Bash(diff *)",
      "Bash(jq *)",
      "Bash(yq *)",

      "Bash(make *)",
      "Bash(make)",
      "Bash(npm run *)",
      "Bash(npm test*)",
      "Bash(npm install*)",
      "Bash(yarn *)",
      "Bash(pnpm *)",
      "Bash(cargo build*)",
      "Bash(cargo test*)",
      "Bash(cargo check*)",
      "Bash(cargo clippy*)",
      "Bash(cargo fmt*)",
      "Bash(pytest*)",
      "Bash(python -m pytest*)",
      "Bash(pip install*)",
      "Bash(pip list*)",
      "Bash(uv run *)",
      "Bash(uv pip *)",
      "Bash(uv sync*)",
      "Bash(uv lock*)",
      "Bash(uv venv*)",
      "Bash(uv build*)",
      "Bash(go build*)",
      "Bash(go test*)",
      "Bash(go vet*)",

      "Bash(ruff *)",
      "Bash(black *)",
      "Bash(isort *)",
      "Bash(mypy *)",
      "Bash(pyright *)",
      "Bash(eslint *)",
      "Bash(prettier *)",
      "Bash(biome *)",
      "Bash(stylua *)",
      "Bash(shellcheck *)",
      "Bash(luacheck *)",
      "Bash(tsc *)",

      "Bash(docker ps*)",
      "Bash(docker logs*)",
      "Bash(docker images*)",
      "Bash(docker compose ps*)",
      "Bash(docker compose logs*)",
      "Bash(docker compose up*)",
      "Bash(docker compose down*)",
      "Bash(docker compose build*)",
      "Bash(docker build *)",

      "Bash(gh pr view*)",
      "Bash(gh pr list*)",
      "Bash(gh pr diff*)",
      "Bash(gh pr checks*)",
      "Bash(gh pr create*)",
      "Bash(gh issue view*)",
      "Bash(gh issue list*)",
      "Bash(gh repo view*)",
      "Bash(gh api --method GET *)",
      "Bash(gh run view*)",
      "Bash(gh run list*)",

      "Bash(kubectl get *)",
      "Bash(kubectl describe *)",
      "Bash(kubectl logs *)",

      "Bash(stow *)",
      "Bash(env *)",
      "Bash(printenv*)",
      "Bash(echo *)",
      "Bash(printf *)",
      "Bash(date*)",
      "Bash(pwd)",
      "Bash(id)",
      "Bash(whoami)",
      "Bash(hostname)",
      "Bash(uname *)",
      "Bash(mkdir *)",
      "Bash(touch *)",
      "Bash(cp *)",
      "Bash(mv *)"
    ]
  }
}
```

## Notes

- **statusLine**: requires starship >= 1.25. Uses starship's native
  `claude-code` provider which reads Claude Code's JSON from stdin. Customize
  modules (`claude_model`, `claude_context`, `claude_cost`, `git_branch`,
  `directory`, `python`, etc.) in your `starship.toml`.
- **permissions**: covers safe read-only commands, standard build/test/lint
  tooling, and git operations that don't touch the remote. Destructive commands
  (`rm`, `git push`, `git reset --hard`) intentionally require manual approval.
- **Machine-specific keys** like `awsAuthRefresh`, `env`, `enabledPlugins`,
  and `extraKnownMarketplaces` are omitted — add those per-machine in
  `~/.claude/settings.json` directly (not stowed).
