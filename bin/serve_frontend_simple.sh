#!/bin/bash
# Serve frontend via HTTP server (simple version with port selection)

cd "$(dirname "$0")/.."

# Try ports in order
PORTS=(8080 8081 8082 3000 8000 8888)

for PORT in "${PORTS[@]}"; do
    # Try to start server
    cd frontend
    if python3 -m http.server $PORT > /dev/null 2>&1 &
    then
        SERVER_PID=$!
        sleep 1
        
        # Check if server is actually running
        if kill -0 $SERVER_PID 2>/dev/null; then
            echo "=========================================="
            echo "Serving XBillr Frontend"
            echo "=========================================="
            echo ""
            echo "Server started on port $PORT"
            echo ""
            echo "Open in browser:"
            echo "  http://localhost:$PORT/login.html"
            echo ""
            echo "Press Ctrl+C to stop"
            echo ""
            echo "Server PID: $SERVER_PID"
            echo "To stop: kill $SERVER_PID"
            echo ""
            
            # Wait for interrupt
            trap "kill $SERVER_PID 2>/dev/null; exit" INT TERM
            wait $SERVER_PID
            exit 0
        fi
    fi
    cd ..
done

echo "ERROR: Could not start server on any available port"
echo "Tried ports: ${PORTS[*]}"
echo ""
echo "Manual option:"
echo "  cd frontend"
echo "  python3 -m http.server <port>"
exit 1
