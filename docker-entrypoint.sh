#!/bin/sh
set -e

# Remove empty config file to let yogurt generate default one
if [ -f /app/config.json ] && [ ! -s /app/config.json ]; then
    echo "Empty config.json detected, removing to let yogurt generate default configuration..."
    rm /app/config.json
fi

# Ensure data directory exists
mkdir -p /app/data

# Execute the command
exec "$@"
