#!/usr/bin/env bash
# Copyright (c) 2026 Kaden Cartwright. Distributed under MIT; see LICENSE.
set -euo pipefail

app="@out@/lib/chatgpt/ChatGPT"
user_flags=()

config_home="${XDG_CONFIG_HOME:-}"
if [[ -z "${config_home}" && -n "${HOME:-}" ]]; then
  config_home="${HOME}/.config"
fi

flags_file="${config_home:+${config_home}/chatgpt-flags.conf}"
if [[ -n "${flags_file}" && -f "${flags_file}" ]]; then
  while IFS= read -r flag_line || [[ -n "${flag_line}" ]]; do
    flag_line="${flag_line%%#*}"
    read -r -a flag_parts <<<"${flag_line}"
    user_flags+=("${flag_parts[@]}")
  done <"${flags_file}"
fi

exec "${app}" "${user_flags[@]}" "$@"
