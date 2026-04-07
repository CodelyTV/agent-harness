#!/usr/bin/env bash

set -euo pipefail

input=$(cat)

command=$(echo "$input" | jq -r '.tool_input.command // ""')

if echo "$command" | grep -qiE '(^|\s|;|&&|\|)export(\s|$)'; then
  echo '{"continue":false,"stopReason":"Blocked: the export command is not allowed by security policy"}'
  exit 0
fi
