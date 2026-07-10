#!/usr/bin/env bash
set -euo pipefail

repo="$(git rev-parse --show-toplevel)"
prompt_file="$repo/tools/update-agent-prompt.md"

cd "$repo"

exec pi --model minimax/MiniMax-M3:high -p "$(<"$prompt_file")"
