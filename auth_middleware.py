from fastapi import Request
from starlette.middleware.base import BaseHTTPMiddleware
from starlette.responses import JSONResponse
from os import environ
import logging

logger = logging.getLogger(__name__)

class APIKeyAuthMiddleware(BaseHTTPMiddleware):
    def __init__(self, app):
        super().__init__(app)
        self.api_key = environ.get("PROXY_API_KEY")
        logger.info("APIKeyAuthMiddleware initialized")
    
    async def dispatch(self, request: Request, call_next):
        # Check for Authorization header
        auth_header = request.headers.get("Authorization")
        
        if not auth_header:
            logger.warning("Request missing Authorization header")
            return JSONResponse(
                status_code=401,
                content={"error": "Missing Authorization header"}
            )
        
        # Extract Bearer token
        if not auth_header.startswith("Bearer "):
            logger.warning("Invalid Authorization header format")
            return JSONResponse(
                status_code=401,
                content={"error": "Invalid Authorization header format. Use: Bearer <token>"}
            )
        
        token = auth_header[7:]  # Remove "Bearer " prefix
        
        # Validate token
        if token != self.api_key:
            logger.warning(f"Invalid API key attempt: {token[:10]}...")
            return JSONResponse(
                status_code=401,
                content={"error": "Invalid API key"}
            )
        
        # Token valid - proceed
        logger.debug("API key validated successfully")
        return await call_next(request)

