#!/bin/bash
# Complete file reorganization script for XBillr
# Run this script from the project root: bash complete_reorganization.sh

set -e

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
cd "$SCRIPT_DIR"

echo "=========================================="
echo "XBillr File Reorganization"
echo "=========================================="
echo ""

# Create directories
echo "Creating directories..."
mkdir -p frontend documentation bin
echo "✓ Directories created"
echo ""

# Move frontend files
echo "Moving frontend files..."
[ -f index.html ] && mv index.html frontend/ && echo "  ✓ index.html"
[ -f login.html ] && mv login.html frontend/ && echo "  ✓ login.html"
[ -f test-api.html ] && mv test-api.html frontend/ && echo "  ✓ test-api.html"
echo ""

# Move documentation files
echo "Moving documentation files..."
[ -f CHANGELOG.md ] && mv CHANGELOG.md documentation/ && echo "  ✓ CHANGELOG.md"
[ -f ARCHITECTURE.md ] && mv ARCHITECTURE.md documentation/ && echo "  ✓ ARCHITECTURE.md"
[ -f README.md ] && mv README.md documentation/ && echo "  ✓ README.md"
[ -f DOCKER.md ] && mv DOCKER.md documentation/ && echo "  ✓ DOCKER.md"
[ -f DOCKER_QUICKSTART.md ] && mv DOCKER_QUICKSTART.md documentation/ && echo "  ✓ DOCKER_QUICKSTART.md"
[ -f README_DOCKER.md ] && mv README_DOCKER.md documentation/ && echo "  ✓ README_DOCKER.md"
[ -f SERVER-SETUP.md ] && mv SERVER-SETUP.md documentation/ && echo "  ✓ SERVER-SETUP.md"
[ -f START.md ] && mv START.md documentation/ && echo "  ✓ START.md"
[ -f INSTALLATION.txt ] && mv INSTALLATION.txt documentation/ && echo "  ✓ INSTALLATION.txt"
[ -f XBillr_Systemarchitektur.html ] && mv XBillr_Systemarchitektur.html documentation/ && echo "  ✓ XBillr_Systemarchitektur.html"
[ -f architecture.html ] && mv architecture.html documentation/ && echo "  ✓ architecture.html"
echo ""

# Remove old bin files if copies exist in bin/
echo "Cleaning up old files..."
[ -f docker-start.sh ] && [ -f bin/docker-start.sh ] && rm docker-start.sh && echo "  ✓ Removed old docker-start.sh"
[ -f setup-database.sh ] && [ -f bin/setup-database.sh ] && rm setup-database.sh && echo "  ✓ Removed old setup-database.sh"
echo ""

# Clean up temporary scripts
echo "Cleaning up temporary scripts..."
[ -f move_files.sh ] && rm move_files.sh && echo "  ✓ Removed move_files.sh"
[ -f reorganize.py ] && rm reorganize.py && echo "  ✓ Removed reorganize.py"
[ -f finalize_move.sh ] && rm finalize_move.sh && echo "  ✓ Removed finalize_move.sh"
[ -f complete_reorganization.sh ] && echo "  ℹ Keeping complete_reorganization.sh for reference"
echo ""

echo "=========================================="
echo "Reorganization Complete!"
echo "=========================================="
echo ""
echo "New structure:"
echo "  frontend/       - Frontend HTML files"
echo "  bin/            - Runtime scripts"
echo "  documentation/  - All documentation files"
echo "  backend/        - Backend application"
echo ""
echo "You can now delete this script if desired."
