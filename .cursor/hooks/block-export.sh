#!/usr/bin/env bash

set -euo pipefail

input=$(cat)

tool_name=$(echo "$input" | jq -r '.tool // ""')
command=$(echo "$input" | jq -r '.input.command // ""')

if echo "$command" | grep -qiE '(^|\s|;|&&|\|)export(\s|$)'; then
  echo "Blocked: the export command is not allowed by security policy" >&2
  exit 2
fi

exit 0
