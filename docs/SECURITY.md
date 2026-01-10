# Security Guide - Zo Secure AI Proxy

Security best practices and architecture for the Zo Secure AI Proxy.

## Security Architecture Overview

The proxy implements a **two-layer security model** to protect both the proxy endpoint and the underlying AI provider API.

### Layers of Security

```
┌─────────────────────────────────────────────┐
│ Layer 1: Proxy Authentication            │
│                                        │
│ - Bearer token validation                │
│ - Controls access to proxy endpoint        │
│ - Prevents unauthorized usage            │
└────────────────┬────────────────────────────┘
                 │
                 │ Valid request
                 ↓
┌─────────────────────────────────────────────┐
│ Layer 2: Provider API Key               │
│                                        │
│ - Stored in Zo Secrets                  │
│ - Never exposed to clients               │
│ - Used only by proxy internally         │
└─────────────────────────────────────────────┘
```

### Two-Layer Authentication

| Layer | Purpose | Protection Level |
|--------|---------|-----------------|
| **Proxy API Key** | Controls access to your proxy endpoint | Public-facing, Bearer token |
| **Provider API Key** | Authenticates with AI provider | Internal, never exposed |

## Credential Management

### Zo Secrets Integration

All API keys are stored in **Zo Secrets** (`/root/.zo_secrets`), Zo Computer's secure credential management system.

**Benefits:**
- ✅ Encrypted storage
- ✅ Runtime loading only
- ✅ No hardcoded credentials
- ✅ Centralized management
- ✅ Easy rotation

### API Key Locations

| Credential | Storage Location | Access Level | Exposure Risk |
|------------|-----------------|---------------|----------------|
| Provider API Key | `/root/.zo_secrets` | Root only | Never exposed |
| Proxy API Key | `/root/.zo_secrets` | Root only | Used as Bearer token |

### Credential Flow

```
┌─────────────────────────────────────┐
│ Zo Secrets (/root/.zo_secrets)   │
│                                  │
│ PROVIDER_API_KEY = ...            │
│ PROXY_API_KEY = ...               │
└─────────────────────────────────────┘
              │
              │ source /root/.zo_secrets
              │
              ▼
┌─────────────────────────────────────┐
│ Startup Script (start.sh)         │
│                                  │
│ export PROVIDER_API_KEY="..."      │
│ export PROXY_API_KEY="..."        │
└─────────────────────────────────────┘
              │
              │ Environment Variables
              │
              ▼
┌─────────────────────────────────────┐
│ Proxy Application (Python)          │
│                                  │
│ os.environ.get("PROVIDER_API_KEY")│
│ os.environ.get("PROXY_API_KEY")   │
└─────────────────────────────────────┘
```

## Security Best Practices

### 1. Never Hardcode Credentials

**✅ DO:**
```python
# Load from environment at runtime
api_key = os.environ.get("PROVIDER_API_KEY")
```

**❌ DON'T:**
```python
# Never hardcode actual values
api_key = "sk-abc123def456..."
```

### 2. Use Zo Secrets Exclusively

**✅ DO:**
- Store all keys in `/root/.zo_secrets`
- Source secrets file at service startup
- Update keys via Zo Secrets interface

**❌ DON'T:**
- Store keys in `.env` files
- Pass keys as command-line arguments
- Embed keys in startup scripts

### 3. Rotate API Keys Regularly

**Recommended Rotation Schedule:**
- **Proxy API Key**: Every 90 days
- **Provider API Key**: Follow provider's recommendations

**Rotation Process:**
1. Generate new keys
2. Update `/root/.zo_secrets`
3. Restart proxy service
4. Update all client applications

### 4. Monitor Access Logs

**Check for unauthorized attempts:**
```bash
# View authentication failures
grep "Invalid API key" /dev/shm/YOUR-SERVICE-LABEL.log

# Monitor request patterns
tail -f /dev/shm/YOUR-SERVICE-LABEL.log | grep "POST"
```

**Suspicious Activity Indicators:**
- Multiple failed auth attempts
- Requests from unknown IPs
- Unusual request volumes

### 5. Limit Exposure

**Network Security:**
- Use HTTPS only (enforced by Zo)
- Keep Zo instance private when possible
- Use Zo's built-in firewall rules

**Access Control:**
- Only share proxy endpoint URL with trusted parties
- Never expose public endpoint on social media
- Use environment-specific proxies (dev/staging/prod)

## Threat Model

### Mitigated Threats

| Threat | Mitigation | Implementation |
|---------|-------------|-----------------|
| **Credential exposure** | Zo Secrets storage | Keys never in code |
| **Unauthorized access** | Bearer token auth | 401 responses |
| **Key theft from logs** | No key logging | Redact from all logs |
| **Man-in-the-middle** | HTTPS enforcement | Zo provides TLS |
| **Rate limit abuse** | Provider-side limits | Provider handles this |

### Remaining Risks

| Risk | Impact | Mitigation |
|-------|---------|------------|
| **Proxy key leak** | Unauthorized access | Rotate keys, monitor logs |
| **Provider key compromise** | Service disruption | Rotate immediately, contact provider |
| **Zo instance compromise** | Full access | Secure Zo account, MFA enabled |

## Code Security

### Input Validation

The proxy validates:
- Authorization header format
- Bearer token presence
- API key length and format

### Error Handling

Security-conscious error responses:
```python
# Generic error messages
{"error": "Invalid API key"}  # Don't reveal which key failed

# No stack traces in production
# Log detailed errors to /dev/shm/, return generic to client
```

### Log Security

**What's Logged:**
- Authentication failures (attempt counts)
- Request timestamps and IPs
- Error messages (for debugging)

**What's NOT Logged:**
- Actual API key values
- Sensitive request bodies
- Internal configuration

## Verification Checklist

Before deploying to production:

- [ ] Both API keys stored in `/root/.zo_secrets`
- [ ] No hardcoded credentials in source code
- [ ] No credentials in documentation files
- [ ] Proxy authentication tested with valid key
- [ ] Proxy authentication tested with invalid key
- [ ] HTTPS endpoint confirmed
- [ ] Logs reviewed for sensitive data
- [ ] Service registered with Zo
- [ ] Monitoring configured

## Incident Response

### Compromised Proxy Key

**Immediate Actions:**
1. Generate new proxy API key
2. Update `/root/.zo_secrets`
3. Restart proxy service
4. Update all client applications

**Post-Incident:**
1. Review access logs for timeframe of compromise
2. Identify all requests made with stolen key
3. Notify clients of key rotation

### Compromised Provider Key

**Immediate Actions:**
1. Generate new provider API key via provider dashboard
2. Update `/root/.zo_secrets`
3. Restart proxy service

**Post-Incident:**
1. Contact provider support
2. Review provider usage logs
3. Check for unusual activity or charges

## Compliance and Privacy

### Data Privacy

- **No request logging** - Only metadata is logged
- **No response caching** - Each request goes directly to provider
- **No data retention** - Proxy doesn't store conversations

### Audit Logging

Available for security audits:
- Authentication attempts
- Service start/stop times
- Error logs (in `/dev/shm/`)

### Regulatory Considerations

If deploying in regulated environments:
- Ensure provider is compliant (SOC2, GDPR, HIPAA, etc.)
- Review data residency requirements
- Implement additional logging if required

## Additional Security Measures

### Optional Enhancements

**Rate Limiting:**
Add per-client rate limiting:
```python
from slowapi import Limiter
limiter = Limiter(key_func=get_remote_address)

@app.post("/v1/chat/completions")
@limiter.limit("100/minute")
async def chat_completions(...):
    ...
```

**IP Whitelisting:**
Restrict access to specific IPs:
```python
ALLOWED_IPS = ["192.168.1.100", "10.0.0.50"]

if client.host not in ALLOWED_IPS:
    raise HTTPException(403, "Access denied")
```

**Request Signing:**
Add HMAC signature verification for high-security deployments.

## Security Auditing

### Regular Security Reviews

Perform quarterly reviews:
1. Audit code for credential exposure
2. Review access logs for anomalies
3. Test authentication endpoints
4. Verify Zo Secrets configuration
5. Update dependencies

### Penetration Testing

Test proxy security:
```bash
# Test invalid keys
curl -H "Authorization: Bearer invalid" https://YOUR-ENDPOINT/api/models

# Test missing headers
curl https://YOUR-ENDPOINT/api/models

# Test malformed requests
curl -X POST https://YOUR-ENDPOINT/api/models -d "{invalid}"
```

## Resources

- **Zo Security Documentation**: https://docs.zocomputer.com/security
- **OWASP API Security**: https://owasp.org/www-project-api-security
- **CIS Security Guidelines**: https://cisecurity.org/

## Support

For security-related issues:
- Report vulnerabilities via private GitHub security advisory
- Contact Zo Computer security team
- Use GitHub Issues for general questions

---

**Security is everyone's responsibility. Please report any vulnerabilities you discover.**

*Built for Zo Computer - Your Personal AI Cloud*

