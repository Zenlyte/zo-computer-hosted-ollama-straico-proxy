"""
Authentication Middleware for Zo Secure AI Proxy

Validates Bearer tokens before allowing access to proxy endpoints.
This ensures only authenticated clients can access the AI provider API.
"""
from fastapi import Request, HTTPException, status
from starlette.middleware.base import BaseHTTPMiddleware
from os import environ
import logging

logger = logging.getLogger(__name__)

class APIKeyAuthMiddleware(BaseHTTPMiddleware):
    """
    Middleware to validate API keys before processing requests.
    
    Checks for Bearer token in Authorization header and validates
    against configured PROXY_API_KEY.
    """
    
    async def dispatch(self, request: Request, call_next):
        """
        Validate API key before forwarding request.
        
        Args:
            request: Incoming HTTP request
            call_next: Next middleware/handler in chain
            
        Returns:
            Response with 401 error if invalid key,
            otherwise proceeds with request
        """
        # Get proxy API key from environment
        proxy_api_key = environ.get("PROXY_API_KEY")
        
        if not proxy_api_key:
            logger.error("PROXY_API_KEY not set in environment")
            raise HTTPException(
                status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
                detail="Proxy configuration error"
            )
        
        # Check for Authorization header
        auth_header = request.headers.get("authorization")
        
        if not auth_header:
            logger.warning("Request missing Authorization header")
            raise HTTPException(
                status_code=status.HTTP_401_UNAUTHORIZED,
                detail="Missing authorization header"
            )
        
        # Extract Bearer token
        try:
            token = auth_header.replace("Bearer ", "")
        except Exception as e:
            logger.error(f"Error parsing Authorization header: {e}")
            raise HTTPException(
                status_code=status.HTTP_401_UNAUTHORIZED,
                detail="Invalid authorization format"
            )
        
        # Validate token
        if token != proxy_api_key:
            logger.warning(f"Invalid API key attempt from {request.client.host}")
            raise HTTPException(
                status_code=status.HTTP_401_UNAUTHORIZED,
                detail="Invalid API key"
            )
        
        # Token valid - proceed with request
        logger.debug("API key validated successfully")
        return await call_next(request)

