#!/usr/bin/env python3
"""
External Authorization Service for Envoy Gateway
Validates JWT tokens and Personal Access Tokens (PAT)
"""

import os
import jwt
import hashlib
import bcrypt
import logging
from typing import Optional, Dict, Any
from datetime import datetime
from pymongo import MongoClient
from concurrent import futures
import grpc
from envoy.service.auth.v3 import external_auth_pb2, external_auth_pb2_grpc
from envoy.service.auth.v3.external_auth_pb2 import CheckRequest, CheckResponse
from envoy.type.v3 import http_status_pb2
from google.rpc import status_pb2, code_pb2

# Configure logging
logging.basicConfig(
    level=logging.INFO,
    format='%(asctime)s - %(name)s - %(levelname)s - %(message)s'
)
logger = logging.getLogger(__name__)

# Configuration from environment variables
JWT_SECRET = os.getenv('JWT_SECRET')
if not JWT_SECRET:
    raise ValueError("JWT_SECRET environment variable must be set")
JWT_ENABLED = os.getenv('JWT_ENABLED', 'true').lower() == 'true'
PAT_ENABLED = os.getenv('PAT_ENABLED', 'true').lower() == 'true'
MONGODB_URI = os.getenv('MONGODB_URI', 'mongodb://mongodb:27017')
MONGODB_DB = os.getenv('MONGODB_DB', 'ffl_playoffs')

# MongoDB client
mongo_client = MongoClient(MONGODB_URI)
db = mongo_client[MONGODB_DB]


class AuthorizationService(external_auth_pb2_grpc.AuthorizationServicer):
    """gRPC service for external authorization"""

    def Check(self, request: CheckRequest, context: grpc.ServicerContext) -> CheckResponse:
        """
        Handle authorization check from Envoy

        Args:
            request: CheckRequest from Envoy containing HTTP attributes
            context: gRPC service context

        Returns:
            CheckResponse with authorization decision
        """
        try:
            # Extract authorization header
            headers = request.attributes.request.http.headers
            auth_header = headers.get('authorization', '')

            if not auth_header:
                logger.warning("No authorization header provided")
                return self._deny_response(401, "Authorization header required")

            # Extract bearer token
            if not auth_header.startswith('Bearer '):
                logger.warning(f"Invalid authorization header format: {auth_header[:20]}")
                return self._deny_response(401, "Invalid authorization header format")

            token = auth_header[7:].strip()  # Remove 'Bearer ' prefix

            # Validate token length (max 8192 bytes)
            if len(token.encode('utf-8')) > 8192:
                logger.warning("Token exceeds maximum length")
                return self._deny_response(401, "Token too long")

            # Try JWT validation first
            if JWT_ENABLED:
                user_context = self._validate_jwt(token)
                if user_context:
                    logger.info(f"JWT validation successful for user: {user_context.get('user_id')}")
                    return self._allow_response(user_context)

            # Fallback to PAT validation
            if PAT_ENABLED:
                user_context = self._validate_pat(token)
                if user_context:
                    logger.info(f"PAT validation successful for user: {user_context.get('user_id')}")
                    return self._allow_response(user_context)

            # Both validations failed
            logger.warning("Token validation failed")
            return self._deny_response(401, "Invalid or expired token")

        except Exception as e:
            logger.error(f"Error during authorization check: {str(e)}", exc_info=True)
            return self._deny_response(500, "Internal server error")

    def _validate_jwt(self, token: str) -> Optional[Dict[str, Any]]:
        """
        Validate JWT token

        Args:
            token: JWT token string

        Returns:
            User context dict if valid, None otherwise
        """
        try:
            # Decode and validate JWT
            payload = jwt.decode(
                token,
                JWT_SECRET,
                algorithms=['HS256'],
                options={'verify_exp': True}
            )

            # Extract user information from JWT claims
            google_id = payload.get('sub')
            email = payload.get('email')

            if not google_id or not email:
                logger.warning("JWT missing required claims")
                return None

            # Look up user in database
            user = db.users.find_one({'googleId': google_id})

            if not user:
                # Auto-create user for first-time login
                logger.info(f"Creating new user for Google ID: {google_id}")
                user = {
                    'email': email,
                    'name': payload.get('name', email),
                    'googleId': google_id,
                    'role': 'PLAYER',  # Default role
                    'createdAt': datetime.utcnow()
                }
                db.users.insert_one(user)

            # Return user context
            return {
                'user_id': str(user.get('_id')),
                'user_email': user.get('email'),
                'user_roles': user.get('role', 'PLAYER'),
                'auth_method': 'jwt'
            }

        except jwt.ExpiredSignatureError:
            logger.warning("JWT token has expired")
            return None
        except jwt.InvalidTokenError as e:
            logger.warning(f"Invalid JWT token: {str(e)}")
            return None
        except Exception as e:
            logger.error(f"Error validating JWT: {str(e)}", exc_info=True)
            return None

    def _validate_pat(self, token: str) -> Optional[Dict[str, Any]]:
        """
        Validate Personal Access Token

        Args:
            token: PAT token string

        Returns:
            User context dict if valid, None otherwise
        """
        try:
            # PAT tokens start with 'pat_'
            if not token.startswith('pat_'):
                return None

            # Extract token identifier (first 8 chars after prefix)
            token_identifier = token[4:12]

            # Look up PAT in database by identifier
            pat = db.personalAccessTokens.find_one({
                'tokenIdentifier': token_identifier
            })

            if not pat:
                logger.warning(f"PAT not found for identifier: {token_identifier}")
                return None

            # Verify token hash using bcrypt
            stored_hash = pat.get('tokenHash')
            if not stored_hash or not isinstance(stored_hash, bytes):
                logger.warning(f"Invalid token hash format for PAT: {token_identifier}")
                return None

            if not bcrypt.checkpw(token.encode(), stored_hash):
                logger.warning(f"PAT hash verification failed: {token_identifier}")
                return None

            # Check if expired
            expires_at = pat.get('expiresAt')
            if expires_at and datetime.utcnow() > expires_at:
                logger.warning(f"PAT has expired: {token_identifier}")
                return None

            # Check if revoked
            if pat.get('revoked', False):
                logger.warning(f"PAT has been revoked: {token_identifier}")
                return None

            # Update lastUsedAt timestamp
            db.personalAccessTokens.update_one(
                {'_id': pat['_id']},
                {'$set': {'lastUsedAt': datetime.utcnow()}}
            )

            # Get associated user
            user_id = pat.get('createdBy')
            user = db.users.find_one({'_id': user_id})

            if not user:
                logger.warning(f"User not found for PAT: {user_id}")
                return None

            # Return user context
            return {
                'user_id': str(user.get('_id')),
                'user_email': user.get('email'),
                'user_roles': user.get('role', 'PLAYER'),
                'auth_method': 'pat'
            }

        except Exception as e:
            logger.error(f"Error validating PAT: {str(e)}", exc_info=True)
            return None

    def _allow_response(self, user_context: Dict[str, Any]) -> CheckResponse:
        """
        Create an ALLOW response with user context headers

        Args:
            user_context: Dictionary containing user information

        Returns:
            CheckResponse allowing the request
        """
        response = CheckResponse()
        response.status.code = code_pb2.OK

        # Add user context headers to forward to backend
        response.ok_response.headers.add(
            header={'key': 'x-user-id', 'value': user_context['user_id']}
        )
        response.ok_response.headers.add(
            header={'key': 'x-user-email', 'value': user_context['user_email']}
        )
        response.ok_response.headers.add(
            header={'key': 'x-user-roles', 'value': user_context['user_roles']}
        )
        response.ok_response.headers.add(
            header={'key': 'x-auth-method', 'value': user_context['auth_method']}
        )

        return response

    def _deny_response(self, status_code: int, message: str) -> CheckResponse:
        """
        Create a DENY response

        Args:
            status_code: HTTP status code
            message: Error message

        Returns:
            CheckResponse denying the request
        """
        response = CheckResponse()
        response.status.code = code_pb2.UNAUTHENTICATED if status_code == 401 else code_pb2.PERMISSION_DENIED
        response.status.message = message

        # Set HTTP status
        response.denied_response.status.code = http_status_pb2.StatusCode.Value(
            f'_{status_code}' if status_code < 600 else '_500'
        )
        response.denied_response.body = message

        return response


def serve():
    """Start the gRPC server"""
    server = grpc.server(futures.ThreadPoolExecutor(max_workers=10))
    external_auth_pb2_grpc.add_AuthorizationServicer_to_server(
        AuthorizationService(), server
    )
    server.add_insecure_port('[::]:9000')

    logger.info("Auth service starting on port 9000...")
    server.start()
    logger.info("Auth service ready to handle requests")

    try:
        server.wait_for_termination()
    except KeyboardInterrupt:
        logger.info("Shutting down auth service...")
        server.stop(0)


if __name__ == '__main__':
    serve()
