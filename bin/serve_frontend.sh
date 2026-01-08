#!/bin/bash
# Serve frontend via HTTP server

cd "$(dirname "$0")/.."

PORT=${1:-8080}

# Function to check if port is available
is_port_available() {
    local port=$1
    if command -v lsof >/dev/null 2>&1; then
        ! lsof -i :$port >/dev/null 2>&1
    elif command -v ss >/dev/null 2>&1; then
        ! ss -tlnp 2>/dev/null | grep -q ":$port "
    else
        # Can't check, assume available
        return 0
    fi
}

# If default port is in use, find alternative
if ! is_port_available $PORT; then
    echo "Port $PORT is already in use. Finding alternative..."
    for alt_port in 8081 8082 3000 8000 8888; do
        if is_port_available $alt_port; then
            PORT=$alt_port
            echo "Using port $PORT instead"
            break
        fi
    done
    
    # Final check
    if ! is_port_available $PORT; then
        echo "ERROR: Could not find an available port."
        echo "Please specify a port manually: ./bin/serve_frontend.sh <port>"
        echo "Or stop the process using the ports"
        exit 1
    fi
fi

echo "=========================================="
echo "Serving XBillr Frontend"
echo "=========================================="
echo ""
echo "Starting HTTP server on port $PORT..."
echo ""
echo "Open in browser:"
echo "  http://localhost:$PORT/login.html"
echo ""
echo "Press Ctrl+C to stop"
echo ""

cd frontend
exec python3 -m http.server $PORT
