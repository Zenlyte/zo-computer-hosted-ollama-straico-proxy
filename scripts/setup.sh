#!/bin/bash
#
# Zo Secure AI Proxy - Automated Setup Script
#
# This script automates the deployment of a secure, OpenAI-compatible
# AI API proxy on Zo Computer with authentication layer.
#

set -e  # Exit on error

# Color codes for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Configuration
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_DIR="$(dirname "$SCRIPT_DIR")"
SERVICE_LABEL="${SERVICE_LABEL:-zo-secure-ai-proxy}"
PROXY_PORT="${PROXY_PORT:-3214}"
WORK_DIR="/home/workspace/zo-secure-ai-proxy"

# Print with colors
print_info() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Check if Zo environment
check_zo_environment() {
    print_info "Checking Zo Computer environment..."
    
    if [ ! -d "/home/workspace" ]; then
        print_error "This script must be run on Zo Computer"
        exit 1
    fi
    
    if ! command -v python3 &> /dev/null; then
        print_error "Python 3 not found. Please install Python 3.12+"
        exit 1
    fi
    
    print_info "Zo Computer environment detected"
}

# Install dependencies
install_dependencies() {
    print_info "Installing Python dependencies..."
    
    cd "$PROJECT_DIR"
    
    if [ -f "requirements.txt" ]; then
        pip3 install -q -r requirements.txt
        print_info "Dependencies installed successfully"
    else
        print_warning "No requirements.txt found, skipping dependency installation"
    fi
}

# Setup API keys
setup_api_keys() {
    print_info "Setting up API keys..."
    
    # Check for Zo secrets file
    if [ ! -f "/root/.zo_secrets" ]; then
        print_warning "Zo secrets file not found. Creating..."
        touch /root/.zo_secrets
    fi
    
    # Prompt for provider API key
    if ! grep -q "PROVIDER_API_KEY=" /root/.zo_secrets; then
        read -p "Enter your AI provider API key (e.g., Straico): " provider_key
        if [ -n "$provider_key" ]; then
            echo "export PROVIDER_API_KEY=\"$provider_key\"" >> /root/.zo_secrets
            print_info "Provider API key saved to Zo Secrets"
        else
            print_error "Provider API key is required"
            exit 1
        fi
    else
        print_info "Provider API key already configured"
    fi
    
    # Generate or use existing proxy API key
    if ! grep -q "PROXY_API_KEY=" /root/.zo_secrets; then
        print_info "Generating secure proxy API key..."
        proxy_key="sk-$(python3 -c "import secrets; print(secrets.token_urlsafe(32))")"
        echo "export PROXY_API_KEY=\"$proxy_key\"" >> /root/.zo_secrets
        print_info "Proxy API key generated: $proxy_key"
        print_warning "Please save this key securely!"
    else
        print_info "Proxy API key already configured"
    fi
    
    # Show configured keys (masked)
    print_info "API Keys configured:"
    grep "API_KEY=" /root/.zo_secrets | sed 's/=.*/=***/'
}

# Create startup script
create_startup_script() {
    print_info "Creating startup script..."
    
    cat > "$WORK_DIR/start.sh" << 'EOF'
#!/bin/bash
# Startup script for Zo Secure AI Proxy
# Sourced from Zo Secrets at runtime

# Source Zo Secrets to get API keys
source /root/.zo_secrets

# Map provider-specific environment variables
export PROVIDER_API_KEY="${PROVIDER_API_KEY}"

# Set authentication key
export PROXY_API_KEY

# Start the proxy server
cd "$WORK_DIR"
python3 main.py
EOF
    
    chmod +x "$WORK_DIR/start.sh"
    print_info "Startup script created"
}

# Register as Zo service
register_service() {
    print_info "Registering proxy as Zo service..."
    
    print_info "Service Configuration:"
    echo "  Label: $SERVICE_LABEL"
    echo "  Port: $PROXY_PORT"
    echo "  Work Directory: $WORK_DIR"
    
    # Note: Service registration requires Zo CLI
    # Users should manually register or use Zo UI
    echo ""
    print_warning "To complete setup, register service via Zo CLI or UI:"
    echo ""
    echo "  Using Zo CLI:"
    echo "  register_user_service \\"
    echo "    --label \"$SERVICE_LABEL\" \\"
    echo "    --protocol http \\"
    echo "    --local-port $PROXY_PORT \\"
    echo "    --workdir \"$WORK_DIR\" \\"
    echo "    --entrypoint \"/bin/bash $WORK_DIR/start.sh\""
    echo ""
    echo "  Using Zo UI:"
    echo "  1. Go to https://YOUR-INSTANCE.zo.computer/?t=sites&s=services"
    echo "  2. Click 'Register Service'"
    echo "  3. Enter the configuration above"
    echo ""
}

# Verify setup
verify_setup() {
    print_info "Verifying setup..."
    
    # Check required files
    if [ ! -f "$WORK_DIR/start.sh" ]; then
        print_error "Startup script not found"
        exit 1
    fi
    
    if [ ! -f "/root/.zo_secrets" ]; then
        print_error "Zo Secrets file not found"
        exit 1
    fi
    
    # Check API keys
    if ! grep -q "PROVIDER_API_KEY=" /root/.zo_secrets; then
        print_error "Provider API key not configured"
        exit 1
    fi
    
    if ! grep -q "PROXY_API_KEY=" /root/.zo_secrets; then
        print_error "Proxy API key not configured"
        exit 1
    fi
    
    print_info "Setup verification passed"
}

# Main setup flow
main() {
    print_info "Starting Zo Secure AI Proxy setup..."
    echo ""
    
    check_zo_environment
    install_dependencies
    setup_api_keys
    create_startup_script
    verify_setup
    register_service
    
    echo ""
    print_info "Setup completed successfully!"
    echo ""
    print_info "Next steps:"
    echo "  1. Register service using command above or Zo UI"
    echo "  2. Wait for service to start"
    echo "  3. Test endpoint: curl https://YOUR-ENDPOINT/api/models"
    echo ""
    print_warning "Keep your proxy API key secure. It controls access to your endpoint."
}

# Run main function
main

