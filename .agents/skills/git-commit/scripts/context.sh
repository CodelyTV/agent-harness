#!/bin/bash

echo "--------------------------------------------------------------------------------"
echo "# 🔀 Current Git context"

echo "## git status"
git status

echo ""
echo "## git diff (staged and unstaged changes)"
git diff HEAD
untracked_files=$(git ls-files --others --exclude-standard)
if [ -n "$untracked_files" ]; then
  echo ""
  echo "### Untracked files"
  while IFS= read -r file; do
    [ -z "$file" ] && continue
    echo "--- $file"
    git diff --no-index -- /dev/null "$file" || true
  done <<UNTRACKED_EOF
$untracked_files
UNTRACKED_EOF
fi

echo ""
echo "## Current branch"
git branch --show-current

echo ""
echo "## Recent commits"
git log --oneline -10

echo ""
echo "## Available scopes"
yarn scopes

echo "--------------------------------------------------------------------------------"
echo ""
