# Contributing to Zo Secure AI Proxy

Thank you for your interest in contributing to Zo Secure AI Proxy! This document provides guidelines and instructions for contributors.

## Table of Contents

- [Code of Conduct](#code-of-conduct)
- [Getting Started](#getting-started)
- [Development Workflow](#development-workflow)
- [Pull Request Process](#pull-request-process)
- [Coding Standards](#coding-standards)
- [Testing](#testing)
- [Documentation](#documentation)

## Code of Conduct

This project adheres to a code of conduct. By participating, you are expected to uphold this code.

- Be respectful and inclusive
- Focus on what is best for the community
- Show empathy towards other community members

## Getting Started

### Prerequisites

- Zo Computer instance (for testing)
- Python 3.12+
- Git
- AI provider API key (for testing)

### Setting Up Development Environment

1. Fork the repository
2. Clone your fork:
   ```bash
   git clone https://github.com/YOUR_USERNAME/zo-secure-ai-proxy.git
   cd zo-secure-ai-proxy
   ```

3. Install dependencies:
   ```bash
   pip3 install -r requirements.txt
   ```

4. Set up environment variables:
   ```bash
   # Create test .env file (never commit this!)
   echo "PROVIDER_API_KEY=your-test-key" > .env.test
   echo "PROXY_API_KEY=sk-test-key" >> .env.test
   source .env.test
   ```

5. Run the proxy locally:
   ```bash
   python3 main.py
   ```

## Development Workflow

### Branching Strategy

- `main` - Stable production code
- `develop` - Integration branch for features
- `feature/*` - Feature branches
- `fix/*` - Bug fix branches
- `docs/*` - Documentation updates

### Creating a Branch

```bash
git checkout -b feature/your-feature-name
```

### Making Changes

1. Write clear, descriptive commit messages
2. Keep changes focused and atomic
3. Test thoroughly before committing
4. Update documentation as needed

### Commit Message Format

```
<type>(<scope>): <subject>

<body>

<footer>
```

**Types:**
- `feat`: New feature
- `fix`: Bug fix
- `docs`: Documentation changes
- `style`: Code style changes (formatting)
- `refactor`: Code refactoring
- `test`: Adding or updating tests
- `chore`: Maintenance tasks

**Example:**
```
feat(auth): add IP whitelist support for enhanced security

Implements IP-based access control to restrict proxy access to specific
network ranges. Useful for enterprise deployments with known client IPs.

Closes #42
```

## Pull Request Process

### Before Submitting

- [ ] Code passes all tests
- [ ] Documentation is updated
- [ ] Commit messages follow format
- [ ] No sensitive data in code
- [ ] Changes are focused and logical

### Submitting a PR

1. Push your branch:
   ```bash
   git push origin feature/your-feature-name
   ```

2. Open a pull request on GitHub
3. Fill in the PR template
4. Link related issues
5. Request review from maintainers

### PR Review Process

- At least one maintainer approval required
- All CI checks must pass
- Address reviewer feedback promptly
- Keep PRs small and focused

## Coding Standards

### Python Style

Follow PEP 8 guidelines:
```python
# Use snake_case for variables and functions
proxy_api_key = os.environ.get("PROXY_API_KEY")

# Use PascalCase for classes
class APIKeyAuthMiddleware:
    pass

# Add docstrings
def validate_api_key(token: str) -> bool:
    """Validate the provided API key against environment variable.
    
    Args:
        token: The Bearer token to validate
        
    Returns:
        True if valid, False otherwise
    """
    pass
```

### Security Best Practices

- ✅ Load credentials from environment only
- ✅ Validate all inputs
- ✅ Use parameterized queries
- ❌ Never hardcode API keys
- ❌ Never log sensitive data
- ❌ Never expose provider API keys to clients

### Error Handling

```python
try:
    result = await provider_request(data)
except HTTPException as e:
    # Log detailed error for debugging
    logger.error(f"Provider request failed: {e}")
    
    # Return generic error to client
    raise HTTPException(
        status_code=500,
        detail="Internal server error"
    )
```

## Testing

### Unit Tests

Run unit tests:
```bash
python3 -m pytest tests/
```

### Integration Tests

Test with actual provider:
```bash
python3 -m pytest tests/integration/
```

### Manual Testing Checklist

- [ ] Proxy starts without errors
- [ ] Authentication works (valid key)
- [ ] Authentication fails (invalid key)
- [ ] Streaming responses work
- [ ] Tool-calling works
- [ ] Multiple models accessible
- [ ] Error handling graceful

## Documentation

### Updating Documentation

- Keep docs in sync with code
- Use clear, concise language
- Include code examples
- Add diagrams where helpful

### Documentation Files

- `README.md` - Overview and quick start
- `docs/INSTALLATION.md` - Detailed setup guide
- `docs/SECURITY.md` - Security best practices
- `docs/MODELS.md` - Available models list
- `docs/API.md` - API reference

### Example Format

```markdown
## Feature Name

Brief description of the feature.

### Usage

```bash
curl -X POST https://endpoint/v1/chat/completions \
  -H "Authorization: Bearer YOUR-KEY" \
  -d '{"model": "...", "messages": [...]}'
```

### Parameters

| Parameter | Type | Required | Description |
|-----------|-------|-----------|-------------|
| model | string | Yes | Model identifier |
| messages | array | Yes | Conversation messages |
```

## Reporting Issues

### Bug Reports

Include:
- Zo Computer version
- Python version
- Error messages
- Steps to reproduce
- Expected vs actual behavior

### Feature Requests

Include:
- Use case description
- Proposed solution
- Alternative approaches considered
- Potential impact

## Questions?

- GitHub Issues: Report bugs and request features
- GitHub Discussions: Ask questions and share ideas
- Zo Community: https://discord.gg/zocomputer

## Recognition

Contributors are recognized in:
- README.md contributors section
- Release notes
- GitHub contributors graph

Thank you for contributing! 🙏

