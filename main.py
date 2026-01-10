#!/usr/bin/env python3
"""
Zo Secure AI Proxy - Main Application

OpenAI-compatible API proxy with authentication and security.
Designed for Zo Computer deployment.

Usage:
    python3 main.py

Environment Variables:
    PROVIDER_API_KEY: Your AI provider's API key
    PROXY_API_KEY: Your proxy's authentication key
"""

from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
import os
import logging

# Import authentication middleware
from src.auth_middleware import APIKeyAuthMiddleware

# Import provider-specific backend
# Uncomment the provider you're using:
# from backend.straico import app as provider_app
# from backend.openai import app as provider_app

# Configure logging
log_level = os.environ.get("LOG_LEVEL", "INFO").upper()
logging.basicConfig(level=getattr(logging, log_level))
logger = logging.getLogger(__name__)

# Initialize FastAPI app
app = FastAPI(
    title="Zo Secure AI Proxy",
    description="Secure OpenAI-compatible API proxy for Zo Computer",
    version="1.0.0"
)

# CORS Configuration
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],  # Configure appropriately for production
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# Add Authentication Middleware
PROXY_API_KEY = os.environ.get("PROXY_API_KEY")

if PROXY_API_KEY:
    logger.info("Authentication middleware enabled")
    app.add_middleware(APIKeyAuthMiddleware)
else:
    logger.warning("PROXY_API_KEY not set - running in development mode (no authentication)")

# Mount provider-specific routes
# Example: app.mount("/v1", provider_app)

# Health check endpoint
@app.get("/health")
async def health_check():
    """Health check endpoint for monitoring."""
    return {"status": "healthy", "service": "zo-secure-ai-proxy"}

# API models endpoint (standard OpenAI-compatible)
@app.get("/api/models")
async def list_models():
    """List available AI models from provider."""
    # Implement based on your provider's API
    return {
        "object": "list",
        "data": [
            {
                "id": "provider/model-name",
                "object": "model",
                "owned_by": "Provider",
                "permission": [{}]
            }
        ]
    }

# Chat completions endpoint (standard OpenAI-compatible)
@app.post("/v1/chat/completions")
async def chat_completions(request: dict):
    """Handle chat completion requests with streaming and tool-calling support."""
    # Implement based on your provider's API
    # Handle streaming: request.get("stream", False)
    # Handle tools: request.get("tools", [])
    pass

if __name__ == "__main__":
    import uvicorn
    
    port = int(os.environ.get("PORT", "3214"))
    host = os.environ.get("HOST", "0.0.0.0")
    
    logger.info(f"Starting Zo Secure AI Proxy on {host}:{port}")
    
    uvicorn.run(
        "main:app",
        host=host,
        port=port,
        log_level=log_level.lower()
    )

