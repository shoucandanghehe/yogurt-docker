#!/bin/sh
set -e

APP_DIR=/app
YOGURT_WORKDIR=/app/data
CONFIG_PATH=$YOGURT_WORKDIR/config.json

mkdir -p "$YOGURT_WORKDIR"

# Yogurt writes config.json and other runtime artifacts to its current working directory.
# Keep that directory on the mounted volume so session stores, scripts, and QR assets persist.
if [ -f "$CONFIG_PATH" ] && [ ! -s "$CONFIG_PATH" ]; then
    echo "Empty config.json detected, asking yogurt to generate a default configuration..."
    BOOTSTRAP_DIR=$(mktemp -d)
    BOOTSTRAP_LOG=$(mktemp)
    trap 'rm -rf "$BOOTSTRAP_DIR"; rm -f "$BOOTSTRAP_LOG"' EXIT

    if ! (cd "$BOOTSTRAP_DIR" && printf '\n' | timeout 10 "$APP_DIR/yogurt" >"$BOOTSTRAP_LOG" 2>&1); then
        if [ ! -s "$BOOTSTRAP_DIR/config.json" ]; then
            cat "$BOOTSTRAP_LOG"
            echo "Failed to generate config.json via yogurt." >&2
            exit 1
        fi
    fi

    cp "$BOOTSTRAP_DIR/config.json" "$CONFIG_PATH"
fi

# Execute the command from Yogurt's persisted working directory.
cd "$YOGURT_WORKDIR"
exec "$@"