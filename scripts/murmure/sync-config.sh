#!/bin/bash

set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
state_dir="${XDG_DATA_HOME:-${HOME}/.local/share}/com.al1x-ai.murmure"
settings_file="${state_dir}/settings.json"
llm_connect_file="${state_dir}/llm_connect.json"
config_file="${repo_root}/docs/murmure/config.murmure"

if ! command -v jq >/dev/null; then
  echo "ERROR: jq is required to sync Murmure configuration" >&2
  exit 1
fi

if [[ ! -f "${settings_file}" ]]; then
  echo "ERROR: missing ${settings_file}" >&2
  exit 1
fi

if [[ ! -f "${llm_connect_file}" ]]; then
  echo "ERROR: missing ${llm_connect_file}" >&2
  exit 1
fi

mkdir -p "$(dirname "${config_file}")"
jq --indent 2 --slurp '{
  version: 1,
  settings: .[0],
  llm_connect: .[1]
}' "${settings_file}" "${llm_connect_file}" >"${config_file}"

echo "WROTE: ${config_file}"
