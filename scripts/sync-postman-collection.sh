#!/bin/bash
# Sync Postman collection from OpenAPI spec
# This is a wrapper script that calls the Python sync script

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PYTHON_SCRIPT="$SCRIPT_DIR/sync-postman-collection.py"

# Use Python script if available, otherwise show error
if [ -f "$PYTHON_SCRIPT" ]; then
    exec python3 "$PYTHON_SCRIPT" "$@"
else
    echo "Error: Python sync script not found at $PYTHON_SCRIPT" >&2
    exit 1
fi
