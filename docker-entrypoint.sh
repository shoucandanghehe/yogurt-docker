#!/bin/sh
set -e

# When config.json is an empty bind mount, yogurt cannot replace the mount point.
# Generate the default file in a temporary working directory, then copy it into place.
if [ -f /app/config.json ] && [ ! -s /app/config.json ]; then
    echo "Empty config.json detected, asking yogurt to generate a default configuration..."
    BOOTSTRAP_DIR=$(mktemp -d)
    BOOTSTRAP_LOG=$(mktemp)
    trap 'rm -rf "$BOOTSTRAP_DIR"; rm -f "$BOOTSTRAP_LOG"' EXIT

    if ! (cd "$BOOTSTRAP_DIR" && printf '\n' | timeout 10 /app/yogurt >"$BOOTSTRAP_LOG" 2>&1); then
        if [ ! -s "$BOOTSTRAP_DIR/config.json" ]; then
            cat "$BOOTSTRAP_LOG"
            echo "Failed to generate config.json via yogurt." >&2
            exit 1
        fi
    fi

    cp "$BOOTSTRAP_DIR/config.json" /app/config.json
fi

# Ensure data directory exists
mkdir -p /app/data

# Execute the command
exec "$@"
