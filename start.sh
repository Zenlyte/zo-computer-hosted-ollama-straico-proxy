#!/bin/bash
#
# Zo Secure AI Proxy - Startup Script
#
# This script loads API keys from Zo Secrets and starts the proxy server.
#
# Security: This script references environment variables from Zo Secrets.
# Actual key values are never hardcoded here.
#

# Function to log messages
log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $*"
}

# Function to handle errors
error_exit() {
    log "ERROR: $*"
    exit 1
}

# Main function
main() {
    log "Starting Zo Secure AI Proxy..."
    
    # Source Zo Secrets to get API keys
    if [ -f /root/.zo_secrets ]; then
        log "Loading API keys from Zo Secrets..."
        source /root/.zo_secrets
    else
        error_exit "Zo Secrets file not found at /root/.zo_secrets"
    fi
    
    # Validate environment variables
    if [ -z "$PROVIDER_API_KEY" ]; then
        error_exit "PROVIDER_API_KEY not set in Zo Secrets"
    fi
    
    if [ -z "$PROXY_API_KEY" ]; then
        error_exit "PROXY_API_KEY not set in Zo Secrets"
    fi
    
    log "PROVIDER_API_KEY loaded (${#PROVIDER_API_KEY} characters)"
    log "PROXY_API_KEY loaded (${#PROXY_API_KEY} characters)"
    
    # Set provider-specific environment variables
    # Example: If using Straico, you might map it like this:
    # export STRAICO_API_KEY="${PROVIDER_API_KEY}"
    
    # Change to script directory
    cd "$(dirname "$0")"
    log "Working directory: $(pwd)"
    
    # Check if main.py exists
    if [ ! -f "main.py" ]; then
        error_exit "main.py not found in $(pwd)"
    fi
    
    # Start the proxy server
    log "Starting Python server..."
    
    # Python runs with uvicorn embedded in main.py
    # The server binds to PORT environment variable or defaults to 3214
    python3 main.py
    
    # Capture exit code
    EXIT_CODE=$?
    
    if [ $EXIT_CODE -ne 0 ]; then
        log "Proxy server exited with error code: $EXIT_CODE"
        error_exit "Failed to start proxy server"
    fi
    
    log "Proxy server started successfully"
}

# Run main function
main

