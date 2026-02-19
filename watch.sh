#!/usr/bin/env bash
set -euo pipefail

INTERVAL="${1:-600}" # default 10 minutes (600 seconds)

echo "Watching $(pwd) for changes every ${INTERVAL}s. Ctrl+C to stop."

while true; do
  if [ -n "$(git status --porcelain)" ]; then
    git add -A
    git commit -m "Auto-commit: $(date '+%Y-%m-%d %H:%M:%S')"
    git push origin main
    echo "[$(date '+%H:%M:%S')] Pushed changes."
  else
    if [ "$INTERVAL" -lt 600 ]; then
      printf "."
    else
      echo "[$(date '+%H:%M:%S')] No changes."
    fi
  fi
  sleep "$INTERVAL"
done
