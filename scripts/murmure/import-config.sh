#!/bin/bash

set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
config_file="${repo_root}/docs/murmure/config.murmure"

if ! command -v murmure >/dev/null; then
  echo "SKIPPING: murmure is not installed"
  exit 0
fi

if [[ ! -f "${config_file}" ]]; then
  echo "SKIPPING: ${config_file} does not exist"
  exit 0
fi

echo "IMPORTING: murmure configuration"
murmure import "${config_file}" --strategy merge
