# Shared Bash/Zsh navigation to the same directory in another Git worktree.
# Register shortcuts with: worktree-shortcut myapp "$HOME/src/myrepo/apps/myapp"
# Then use: myapp [branch] (with branch completion in interactive shells).
typeset -gA _worktree_shortcuts

# List checked-out branches, or resolve a branch to its worktree directory.
function _worktree_targets() {
  local directory="$1" entry worktree branch
  shift
  while IFS= read -r -d '' entry; do
    case "$entry" in
    'worktree '*) worktree="${entry#worktree }" ;;
    'branch refs/heads/'*)
      branch="${entry#branch refs/heads/}"
      if [[ $# -eq 0 ]]; then
        printf '%s\n' "$branch"
      elif [[ "$branch" == "$1" ]]; then
        printf '%s\n' "$worktree"
        return 0
      fi
      ;;
    esac
  done < <(git -C "$directory" worktree list --porcelain -z)
  [[ $# -eq 0 ]]
}

function worktree-cd() {
  if [[ $# -lt 1 || $# -gt 2 ]]; then
    echo 'usage: worktree-cd <directory> [branch]' >&2
    return 1
  fi
  if [[ $# -eq 1 ]]; then
    builtin cd -- "$1" || return
    return
  fi

  local relative_directory worktree
  relative_directory="$(git -C "$1" rev-parse --show-prefix)" || return
  worktree="$(_worktree_targets "$1" "$2")" || {
    printf 'worktree-cd: no worktree found for branch: %s\n' "$2" >&2
    return 1
  }
  builtin cd -- "$worktree/$relative_directory" || return
}

function worktree-shortcut() {
  if [[ $# -ne 2 || ! "$1" =~ ^[a-zA-Z_][a-zA-Z0-9_]*$ || -z "$2" ]]; then
    echo 'usage: worktree-shortcut <name> <directory> (name must be a shell identifier)' >&2
    return 1
  fi
  local name="$1" directory="$2"
  # Anchor relative paths at registration so shortcuts work from any directory.
  [[ "$directory" == /* ]] || directory="$PWD/$directory"
  _worktree_shortcuts[$name]="$directory"
  # Only the validated identifier enters shell code; paths stay in the map.
  eval "function $name() { worktree-cd \"\${_worktree_shortcuts[$name]}\" \"\$@\"; }"
  if [[ -n "${BASH_VERSION-}" ]]; then
    complete -F _worktree_shortcut_complete "$name"
  elif command -v compdef >/dev/null 2>&1; then
    compdef _worktree_shortcut "$name"
  fi
}
