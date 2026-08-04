#!/bin/bash

set -euo pipefail

target="$1"
shift

tmp="$(mktemp "${target}.XXXXXX")"
if "$@" >"$tmp"; then
  chmod 0644 "$tmp"
  mv "$tmp" "$target"
else
  rm -f "$tmp"
  exit 1
fi
