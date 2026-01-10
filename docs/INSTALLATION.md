# Installation Guide - Zo Secure AI Proxy

Detailed installation instructions for deploying the Zo Secure AI Proxy on Zo Computer.

## Table of Contents

1. [Prerequisites](#prerequisites)
2. [Quick Installation](#quick-installation)
3. [Manual Installation](#manual-installation)
4. [Configuration](#configuration)
5. [Service Registration](#service-registration)
6. [Verification](#verification)
7. [Troubleshooting](#troubleshooting)

## Prerequisites

### Required

- **Zo Computer instance** - You need an active Zo Computer account
- **AI Provider Account** - API key from your AI provider (e.g., Straico)
- **Terminal Access** - SSH or web terminal access to your Zo instance

### Optional

- **Custom Domain** - For branded endpoint URL
- **GitHub Account** - To fork and customize the repository

## Quick Installation

### Step 1: Clone Repository

Clone this repository to your Zo workspace:

```bash
cd /home/workspace
git clone https://github.com/YOUR_USERNAME/zo-secure-ai-proxy.git
cd zo-secure-ai-proxy
```

### Step 2: Run Setup Script

The automated setup script handles dependency installation, key configuration, and service preparation:

```bash
bash scripts/setup.sh
```

The script will:
1. ✅ Check Zo Computer environment
2. ✅ Install Python dependencies
3. ✅ Prompt for API keys
4. ✅ Generate proxy authentication key
5. ✅ Create startup script
6. ✅ Provide service registration commands

### Step 3: Register Service

Follow the instructions from the setup script to register the proxy as a Zo service:

**Using Zo CLI:**
```bash
register_user_service \
  --label "zo-secure-ai-proxy" \
  --protocol http \
  --local-port 3214 \
  --workdir "/home/workspace/zo-secure-ai-proxy" \
  --entrypoint "/bin/bash /home/workspace/zo-secure-ai-proxy/start.sh"
```

**Using Zo UI:**
1. Navigate to [Sites > Services](https://YOUR-INSTANCE.zo.computer/?t=sites&s=services)
2. Click "Register Service"
3. Enter configuration from setup script output
4. Click "Register"

### Step 4: Verify Deployment

Once the service is running, test the endpoint:

```bash
# Replace with your actual endpoint URL
curl https://YOUR-SERVICE-LABEL-USERNAME.zocomputer.io/api/models \
  -H "Authorization: Bearer YOUR-PROXY-KEY"
```

You should receive a JSON response listing available AI models.

## Manual Installation

If you prefer manual control over the installation process, follow these steps:

### Step 1: Clone and Install Dependencies

```bash
cd /home/workspace
git clone https://github.com/YOUR_USERNAME/zo-secure-ai-proxy.git
cd zo-secure-ai-proxy

# Install Python dependencies
pip3 install -r requirements.txt
```

### Step 2: Configure API Keys

Edit `/root/.zo_secrets` to add your API keys:

```bash
# Open Zo Secrets
nano /root/.zo_secrets

# Add your provider API key
export PROVIDER_API_KEY="your-provider-api-key-here"

# Add your proxy authentication key (generate or create your own)
export PROXY_API_KEY="sk-your-secure-proxy-key-here"
```

Generate a secure proxy key:

```bash
python3 -c "import secrets; print('sk-' + secrets.token_urlsafe(32))"
```

### Step 3: Create Startup Script

Create `/home/workspace/zo-secure-ai-proxy/start.sh`:

```bash
#!/bin/bash
# Source Zo Secrets
source /root/.zo_secrets

# Set provider-specific environment variables
export PROVIDER_API_KEY="${PROVIDER_API_KEY}"

# Start proxy server
cd /home/workspace/zo-secure-ai-proxy
python3 main.py
```

Make it executable:

```bash
chmod +x /home/workspace/zo-secure-ai-proxy/start.sh
```

### Step 4: Register Service

Follow service registration steps from [Quick Installation](#step-3-register-service)

## Configuration

### Environment Variables

The proxy uses these environment variables:

| Variable | Required | Description | Example |
|-----------|-----------|-------------|----------|
| `PROVIDER_API_KEY` | ✅ Yes | Your AI provider's API key | `sk-abc123...` |
| `PROXY_API_KEY` | ✅ Yes | Your proxy authentication key | `sk-xyz789...` |

### Port Configuration

Default port is `3214`. To change:

1. Edit startup script to use different port
2. Update service registration with new port
3. Ensure port is available on Zo instance

Check port availability:

```bash
netstat -tuln | grep 3214
```

### Provider-Specific Setup

The proxy is designed to work with various AI providers. Configure based on your provider:

**Straico:**
```bash
export PROVIDER_API_KEY="STRAICO_API_KEY"
export PROVIDER_API_KEY="${STRAICO_API_KEY}"
```

**Custom Provider:**
Modify `main.py` or provider-specific backend module.

## Service Registration

### Service Management Commands

Once registered as a Zo service, you can:

**Check Status:**
```bash
curl https://YOUR-ENDPOINT.zocomputer.io/api/models \
  -H "Authorization: Bearer YOUR-KEY"
```

**View Logs:**
```bash
tail -f /dev/shm/YOUR-SERVICE-LABEL.log
```

**Restart Service:**
Via Zo UI: [Sites > Services](https://YOUR-INSTANCE.zo.computer/?t=sites&s=services)

### Service Health

Monitor service health:

```bash
# Check if service is running
ps aux | grep python3 | grep main.py

# Check for errors
tail -50 /dev/shm/YOUR-SERVICE-LABEL_err.log

# Monitor recent activity
tail -100 /dev/shm/YOUR-SERVICE-LABEL.log
```

## Verification

### Test Authentication

Verify Bearer token authentication:

```bash
# Should succeed (valid key)
curl https://YOUR-ENDPOINT/api/models \
  -H "Authorization: Bearer YOUR-PROXY-KEY"

# Should fail (invalid key)
curl https://YOUR-ENDPOINT/api/models \
  -H "Authorization: Bearer invalid-key"
```

### Test Streaming

Test SSE streaming support:

```bash
curl -X POST https://YOUR-ENDPOINT/v1/chat/completions \
  -H "Authorization: Bearer YOUR-PROXY-KEY" \
  -H "Content-Type: application/json" \
  -d '{
    "model": "openai/gpt-4o-mini",
    "messages": [{"role": "user", "content": "Count to 5"}],
    "stream": true
  }'
```

Expected output: Server-sent events with streaming chunks.

### Test Tool Calling

Test function calling support:

```bash
curl -X POST https://YOUR-ENDPOINT/v1/chat/completions \
  -H "Authorization: Bearer YOUR-PROXY-KEY" \
  -H "Content-Type: application/json" \
  -d '{
    "model": "openai/gpt-4o-mini",
    "messages": [{"role": "user", "content": "What'\''s the weather?"}],
    "tools": [{
      "type": "function",
      "function": {
        "name": "get_weather",
        "description": "Get current weather",
        "parameters": {
          "type": "object",
          "properties": {
            "location": {"type": "string"}
          }
        }
      }
    }]
  }'
```

Expected output: Response with `tool_calls` array.

## Troubleshooting

### Service Won't Start

**Symptoms:** Service fails to start or crashes immediately

**Solutions:**

1. **Check error logs:**
   ```bash
   tail -50 /dev/shm/YOUR-SERVICE-LABEL_err.log
   ```

2. **Verify dependencies:**
   ```bash
   cd /home/workspace/zo-secure-ai-proxy
   pip3 install -r requirements.txt
   ```

3. **Check port conflicts:**
   ```bash
   netstat -tuln | grep 3214
   ```
   Change port if already in use.

4. **Verify API keys:**
   ```bash
   cat /root/.zo_secrets
   ```
   Ensure both `PROVIDER_API_KEY` and `PROXY_API_KEY` are set.

### Authentication Failures

**Symptoms:** `401 Unauthorized` responses

**Solutions:**

1. **Check Bearer token format:**
   ```bash
   # Correct format
   -H "Authorization: Bearer YOUR-KEY"
   
   # Incorrect format
   -H "Authorization: YOUR-KEY"
   ```

2. **Verify proxy key in Zo Secrets:**
   ```bash
   grep "PROXY_API_KEY" /root/.zo_secrets
   ```

3. **Restart service to reload keys:**
   Via Zo UI: Restart service button

### Provider Connection Issues

**Symptoms:** Errors connecting to AI provider API

**Solutions:**

1. **Verify provider API key:**
   - Check key is valid and active
   - Ensure key has required permissions

2. **Check provider service status:**
   - Visit provider's status page
   - Check for outages or maintenance

3. **Test network connectivity:**
   ```bash
   curl -I https://provider-api-domain.com
   ```

### High Latency

**Symptoms:** Slow response times

**Solutions:**

1. **Choose closer region:** Use provider endpoints geographically closer to Zo instance

2. **Select faster models:** Use models optimized for speed (e.g., `...:fast` variants)

3. **Enable streaming:** Streaming provides faster perceived response times

## Updates and Maintenance

### Update Proxy Code

```bash
cd /home/workspace/zo-secure-ai-proxy
git pull
# Service auto-restarts on file changes
```

### Update Dependencies

```bash
cd /home/workspace/zo-secure-ai-proxy
pip3 install --upgrade -r requirements.txt
```

### Rotate API Keys

1. Generate new proxy key
2. Update `/root/.zo_secrets`
3. Restart service
4. Update all clients using the old key

## Next Steps

- Configure AI tools (Cursor, Continue, etc.) to use your proxy endpoint
- Review [MODELS.md](MODELS.md) for available AI models
- Explore [SECURITY.md](SECURITY.md) for security best practices

## Support

For issues or questions:
- GitHub Issues: Report bugs and feature requests
- Zo Computer Support: https://zocomputer.com/support
- Community Discussions: GitHub Discussions

---

**Built for Zo Computer - Your Personal AI Cloud**

