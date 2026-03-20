#!/bin/sh
set -e

# Ensure data directory exists
mkdir -p /app/data

# Execute the command
exec "$@"
