#!/bin/sh
set -e

echo "🔍 Running all scripts in the /db_init/scripts directory..."

for script in /db_init/scripts/*.sh; do
  if [ -f "$script" ] && [ "$script" != "/db_init/scripts/entrypoint.sh" ]; then
    echo "▶️ Running $script..."
    /bin/sh "$script"
  fi
done

echo "✅ All initialization scripts executed!"
