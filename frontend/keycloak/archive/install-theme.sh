#!/bin/bash
# XBillr Keycloak Theme Installation Script

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Function to print colored messages
print_success() {
    echo -e "${GREEN}✓ $1${NC}"
}

print_error() {
    echo -e "${RED}✗ $1${NC}"
}

print_info() {
    echo -e "${YELLOW}→ $1${NC}"
}

# Default values
KEYCLOAK_DIR="/opt/keycloak"
THEME_NAME="smetools"
DOCKER_CONTAINER=""
THEME_SOURCE="$(cd "$(dirname "$0")" && pwd)/$THEME_NAME"

# Parse command line arguments
while [[ $# -gt 0 ]]; do
    case $1 in
        --keycloak-dir)
            KEYCLOAK_DIR="$2"
            shift 2
            ;;
        --docker)
            DOCKER_CONTAINER="$2"
            shift 2
            ;;
        --help)
            echo "XBillr Keycloak Theme Installation Script"
            echo ""
            echo "Usage: $0 [OPTIONS]"
            echo ""
            echo "Options:"
            echo "  --keycloak-dir DIR    Path to Keycloak installation (default: /opt/keycloak)"
            echo "  --docker CONTAINER    Install to Docker container instead of filesystem"
            echo "  --help                Show this help message"
            echo ""
            echo "Examples:"
            echo "  # Install to local Keycloak"
            echo "  sudo $0 --keycloak-dir /opt/keycloak"
            echo ""
            echo "  # Install to Docker container"
            echo "  $0 --docker keycloak-container"
            exit 0
            ;;
        *)
            print_error "Unknown option: $1"
            echo "Use --help for usage information"
            exit 1
            ;;
    esac
done

echo ""
echo "╔════════════════════════════════════════╗"
echo "║  SME Tools Keycloak Theme Installer   ║"
echo "╚════════════════════════════════════════╝"
echo ""

# Check if theme source exists
if [ ! -d "$THEME_SOURCE" ]; then
    print_error "Theme source directory not found: $THEME_SOURCE"
    exit 1
fi

print_info "Theme source: $THEME_SOURCE"

# Install to Docker container
if [ -n "$DOCKER_CONTAINER" ]; then
    print_info "Installing to Docker container: $DOCKER_CONTAINER"
    
    # Check if container exists
    if ! docker ps -a --format '{{.Names}}' | grep -q "^${DOCKER_CONTAINER}$"; then
        print_error "Docker container '$DOCKER_CONTAINER' not found"
        exit 1
    fi
    
    print_info "Copying theme to container..."
    docker cp "$THEME_SOURCE" "$DOCKER_CONTAINER:/opt/keycloak/themes/"
    
    print_info "Setting permissions..."
    docker exec "$DOCKER_CONTAINER" chown -R keycloak:keycloak "/opt/keycloak/themes/$THEME_NAME" 2>/dev/null || true
    docker exec "$DOCKER_CONTAINER" chmod -R 755 "/opt/keycloak/themes/$THEME_NAME"
    
    print_info "Clearing cache..."
    docker exec "$DOCKER_CONTAINER" rm -rf /opt/keycloak/data/cache/ 2>/dev/null || true
    
    print_success "Theme installed successfully to Docker container"
    echo ""
    print_info "Next steps:"
    echo "  1. Restart the container: docker restart $DOCKER_CONTAINER"
    echo "  2. Log in to Keycloak Admin Console"
    echo "  3. Go to Realm Settings → Themes"
    echo "  4. Set Login theme to '$THEME_NAME'"
    echo "  5. Save changes"
    
# Install to filesystem
else
    print_info "Installing to filesystem: $KEYCLOAK_DIR"
    
    # Check if Keycloak directory exists
    if [ ! -d "$KEYCLOAK_DIR" ]; then
        print_error "Keycloak directory not found: $KEYCLOAK_DIR"
        exit 1
    fi
    
    THEMES_DIR="$KEYCLOAK_DIR/themes"
    DEST_DIR="$THEMES_DIR/$THEME_NAME"
    
    # Create themes directory if it doesn't exist
    if [ ! -d "$THEMES_DIR" ]; then
        print_info "Creating themes directory..."
        mkdir -p "$THEMES_DIR"
    fi
    
    # Remove old theme if exists
    if [ -d "$DEST_DIR" ]; then
        print_info "Removing old theme..."
        rm -rf "$DEST_DIR"
    fi
    
    print_info "Copying theme files..."
    cp -r "$THEME_SOURCE" "$DEST_DIR"
    
    print_info "Setting permissions..."
    chown -R keycloak:keycloak "$DEST_DIR" 2>/dev/null || true
    chmod -R 755 "$DEST_DIR"
    
    print_info "Clearing cache..."
    rm -rf "$KEYCLOAK_DIR/data/cache/" 2>/dev/null || true
    
    print_success "Theme installed successfully to filesystem"
    echo ""
    print_info "Next steps:"
    echo "  1. Restart Keycloak: systemctl restart keycloak"
    echo "  2. Log in to Keycloak Admin Console"
    echo "  3. Go to Realm Settings → Themes"
    echo "  4. Set Login theme to '$THEME_NAME'"
    echo "  5. Save changes"
fi

echo ""
print_success "Installation complete!"
echo ""
