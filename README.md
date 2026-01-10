# Zo Secure AI Proxy

A secure, OpenAI-compatible API proxy for Zo Computer that enables streaming and tool-calling support with any AI provider.

**⚠️ Important:** This project is built on top of [ollama-straico-apiproxy](https://github.com/jayrinaldime/ollama-straico-apiproxy) by @jayrinaldime. The original repository provides the core proxy functionality. This package adds security hardening, Zo Computer integration, and deployment documentation.

## Features

✅ **OpenAI-Compatible API** - Drop-in replacement for OpenAI endpoints
✅ **Bearer Token Authentication** - Secure access control
✅ **Streaming Support** - Real-time response streaming
✅ **Tool-Calling** - Full function calling support
✅ **80+ AI Models** - Access to models from OpenAI, Anthropic, Google, Meta, and more
✅ **Zo Computer Integration** - Optimized for Zo's cloud infrastructure
✅ **Security Hardened** - Two-layer authentication, Zo Secrets integration
✅ **Zero Configuration** - Works out of the box after setup

## Architecture

```
┌─────────────────────────────────────────────────────────────┐
│ Zo Computer                                              │
│                                                          │
│  ┌──────────────────────────────────────────────────────┐   │
│  │ Zo Secure AI Proxy                              │   │
│  │                                                  │   │
│  │  ┌────────────────────────────────────────────────┐  │   │
│  │  │ Layer 1: Proxy Authentication              │  │   │
│  │  │  - Bearer token validation                │  │   │
│  │  │  - Controls access to endpoint            │  │   │
│  │  └────────────────────────────────────────────────┘  │   │
│  │                   │                               │   │
│  │                   │ Valid request                 │   │
│  │                   ▼                               │   │
│  │  ┌────────────────────────────────────────────────┐  │   │
│  │  │ Layer 2: Provider API Key               │  │   │
│  │  │  - Stored in Zo Secrets                │  │   │
│  │  │  - Used only internally                 │  │   │
│  │  └────────────────────────────────────────────────┘  │   │
│  └──────────────────────────────────────────────────────┘   │
│                     │                                   │
└─────────────────────│───────────────────────────────────┘
                      │
                      │ HTTPS
                      ▼
            ┌─────────────────────┐
            │ AI Provider        │
            │ (Straico, etc.)   │
            └─────────────────────┘
```

## Quick Start

### Prerequisites

- Zo Computer instance
- AI provider API key (e.g., Straico)
- Terminal access to your Zo instance

### Installation (Automated)

```bash
# Clone repository
cd /home/workspace
git clone https://github.com/YOUR_USERNAME/zo-secure-ai-proxy.git
cd zo-secure-ai-proxy

# Run setup script
bash scripts/setup.sh
```

The setup script will:
1. Install Python dependencies
2. Prompt for your API keys
3. Generate a secure proxy authentication key
4. Create startup scripts
5. Provide service registration commands

### Register as Zo Service

Follow the setup script's instructions to register the proxy as a persistent Zo service:

```bash
register_user_service \
  --label "zo-secure-ai-proxy" \
  --protocol http \
  --local-port 3214 \
  --workdir "/home/workspace/zo-secure-ai-proxy" \
  --entrypoint "/bin/bash /home/workspace/zo-secure-ai-proxy/start.sh"
```

Or register via Zo UI at [Sites > Services](https://YOUR-INSTANCE.zo.computer/?t=sites&s=services).

### Verify Deployment

```bash
# Test endpoint with your proxy key
curl https://YOUR-SERVICE-LABEL-USERNAME.zocomputer.io/api/models \
  -H "Authorization: Bearer YOUR-PROXY-API-KEY"
```

## Usage

### Basic Chat Completion

```bash
curl -X POST https://YOUR-ENDPOINT/v1/chat/completions \
  -H "Authorization: Bearer YOUR-PROXY-API-KEY" \
  -H "Content-Type: application/json" \
  -d '{
    "model": "openai/gpt-4o-mini",
    "messages": [{"role": "user", "content": "Hello!"}]
  }'
```

### Streaming

```bash
curl -X POST https://YOUR-ENDPOINT/v1/chat/completions \
  -H "Authorization: Bearer YOUR-PROXY-API-KEY" \
  -H "Content-Type: application/json" \
  -d '{
    "model": "openai/gpt-4o-mini",
    "messages": [{"role": "user", "content": "Count to 5"}],
    "stream": true
  }'
```

### Tool-Calling

```bash
curl -X POST https://YOUR-ENDPOINT/v1/chat/completions \
  -H "Authorization: Bearer YOUR-PROXY-API-KEY" \
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

Response includes full `tool_calls` array with proper tool invocation.

## Available Models

Access 80+ AI models including:

- **OpenAI**: GPT-4, GPT-5, o1, o3, o4 series
- **Anthropic**: Claude 3.7, Claude 4 series
- **Google**: Gemini 2.0, Gemini 2.5, Gemma 2
- **Meta**: Llama 3, Llama 3.1, Llama 4
- **xAI**: Grok 2, Grok 3, Grok 4
- **DeepSeek**: DeepSeek V3, DeepSeek R1
- **Qwen**: Qwen 2, Qwen 3 series
- **And many more...**

See [MODELS.md](docs/MODELS.md) for complete list with use-case recommendations.

## Security

### 🔒 Security Architecture

**Two-Layer Authentication:**

1. **Proxy API Key** (Bearer token) - Controls access to your proxy endpoint
2. **Provider API Key** (Internal) - Authenticates with AI provider, never exposed

### 🔒 Credential Management

All API keys stored in **Zo Secrets** (`/root/.zo_secrets`):

- ✅ Encrypted storage
- ✅ Runtime loading only
- ✅ No hardcoded credentials
- ✅ Zero exposure risk

**Never hardcode API keys in code or documentation.**

### Security Features

- Bearer token authentication
- Provider key isolation
- No credential logging
- HTTPS enforcement (Zo provides TLS)
- Request validation
- Error sanitization

See [SECURITY.md](docs/SECURITY.md) for detailed security guidelines.

## Configuration

### Environment Variables

| Variable | Required | Description | Example |
|-----------|-----------|-------------|----------|
| `PROVIDER_API_KEY` | ✅ Yes | Your AI provider's API key | `sk-abc123...` |
| `PROXY_API_KEY` | ✅ Yes | Your proxy's authentication key | `sk-xyz789...` |
| `PORT` | No | Server port (default: 3214) | `3214` |
| `HOST` | No | Bind address (default: 0.0.0.0) | `0.0.0.0` |
| `LOG_LEVEL` | No | Logging level (default: INFO) | `DEBUG` |

### Setting API Keys

Edit `/root/.zo_secrets`:

```bash
# Provider API key (e.g., Straico)
export PROVIDER_API_KEY="your-provider-api-key-here"

# Proxy authentication key (generate securely)
export PROXY_API_KEY="sk-your-secure-proxy-key-here"
```

Generate a secure proxy key:

```bash
python3 -c "import secrets; print('sk-' + secrets.token_urlsafe(32))"
```

## Integration

### Use with AI Tools

Configure your favorite AI tools to use the proxy endpoint:

**Cursor AI IDE:**
```
https://YOUR-ENDPOINT.zocomputer.io/v1
API Key: YOUR-PROXY-API-KEY
```

**Continue.dev:**
```
https://YOUR-ENDPOINT.zocomputer.io/v1
Bearer: YOUR-PROXY-API-KEY
```

**Custom Applications:**
```python
import openai

client = openai.OpenAI(
    base_url="https://YOUR-ENDPOINT.zocomputer.io/v1",
    api_key="YOUR-PROXY-API-KEY"
)

response = client.chat.completions.create(
    model="openai/gpt-4o-mini",
    messages=[{"role": "user", "content": "Hello!"}]
)
```

## Why Use This Proxy?

### Straico Limitations

**Straico's native OpenAI-compatible API:**
- ✅ Access to 80+ AI models
- ❌ No streaming support
- ❌ No tool-calling support

**With Zo Secure AI Proxy:**
- ✅ Access to 80+ AI models
- ✅ **Full streaming support**
- ✅ **Full tool-calling support**
- ✅ **Secure authentication**
- ✅ **Zero configuration**

### Benefits

- **Enhanced Capabilities**: Add streaming and tool-calling to any provider
- **Security**: Two-layer authentication, Zo Secrets integration
- **Flexibility**: Switch providers without changing client code
- **Privacy**: No request logging, zero data retention
- **Cost Control**: Use budget-optimized auto-selection models

## Documentation

- [Installation Guide](docs/INSTALLATION.md) - Detailed setup instructions
- [Security Guide](docs/SECURITY.md) - Security best practices
- [Models List](docs/MODELS.md) - Available AI models
- [Contributing](CONTRIBUTING.md) - Contribution guidelines

## Troubleshooting

### Service Won't Start

Check error logs:
```bash
tail -50 /dev/shm/YOUR-SERVICE-LABEL_err.log
```

Verify dependencies:
```bash
pip3 install -r requirements.txt
```

### Authentication Failures

Check Bearer token format:
```bash
# Correct
-H "Authorization: Bearer YOUR-KEY"

# Incorrect
-H "Authorization: YOUR-KEY"
```

### Connection Issues

Verify Zo Secrets configuration:
```bash
cat /root/.zo_secrets
```

Check service status:
```bash
ps aux | grep python3 | grep main.py
```

## License

MIT License - See [LICENSE.md](LICENSE.md) for details.

## Credits

**Core Proxy Functionality:** [ollama-straico-apiproxy](https://github.com/jayrinaldime/ollama-straico-apiproxy) by [@jayrinaldime](https://github.com/jayrinaldime)

This package adds:
- Security hardening and authentication
- Zo Computer integration
- Deployment automation
- Comprehensive documentation
- Production-ready configuration

## Support

- **GitHub Issues**: Report bugs and request features
- **Zo Computer Support**: https://zocomputer.com/support
- **Community**: GitHub Discussions

## Roadmap

- [ ] Per-client rate limiting
- [ ] Request/response logging (opt-in)
- [ ] Metrics dashboard
- [ ] Multi-provider failover
- [ ] Custom model routing
- [ ] WebSocket support

---

**Built for Zo Computer - Your Personal AI Cloud** 🚀

