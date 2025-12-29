package com.ffl.playoffs.infrastructure.adapter.filter;

import com.ffl.playoffs.domain.model.AuthenticationContext;
import com.ffl.playoffs.domain.model.PATScope;
import com.ffl.playoffs.domain.model.Role;
import jakarta.servlet.FilterChain;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Component;
import org.springframework.web.filter.OncePerRequestFilter;

import java.io.IOException;
import java.util.UUID;

/**
 * Filter that extracts authentication context from Envoy headers.
 * Envoy validates tokens and passes user/service context via headers.
 *
 * Headers for USER authentication (Google OAuth):
 * - X-User-Id: User UUID
 * - X-User-Email: User email
 * - X-User-Role: Role (PLAYER, ADMIN, SUPER_ADMIN)
 * - X-Google-Id: Google OAuth ID
 *
 * Headers for PAT authentication (Service):
 * - X-Service-Id: Service name
 * - X-PAT-Scope: Scope (READ_ONLY, WRITE, ADMIN)
 * - X-PAT-Id: PAT UUID
 */
@Component
public class EnvoyAuthenticationFilter extends OncePerRequestFilter {

    private static final Logger log = LoggerFactory.getLogger(EnvoyAuthenticationFilter.class);

    // Header names from Envoy auth service
    public static final String HEADER_USER_ID = "X-User-Id";
    public static final String HEADER_USER_EMAIL = "X-User-Email";
    public static final String HEADER_USER_ROLE = "X-User-Role";
    public static final String HEADER_GOOGLE_ID = "X-Google-Id";
    public static final String HEADER_SERVICE_ID = "X-Service-Id";
    public static final String HEADER_PAT_SCOPE = "X-PAT-Scope";
    public static final String HEADER_PAT_ID = "X-PAT-Id";

    // Request attribute key for storing the authentication context
    public static final String AUTH_CONTEXT_ATTRIBUTE = "authenticationContext";

    @Override
    protected void doFilterInternal(HttpServletRequest request, HttpServletResponse response,
                                    FilterChain filterChain) throws ServletException, IOException {

        // Check for PAT authentication headers
        String patId = request.getHeader(HEADER_PAT_ID);
        if (patId != null && !patId.isEmpty()) {
            AuthenticationContext ctx = extractPATContext(request);
            if (ctx != null) {
                request.setAttribute(AUTH_CONTEXT_ATTRIBUTE, ctx);
                log.debug("PAT authentication context set for service: {}", ctx.getServiceName());
            }
        }
        // Check for User authentication headers
        else {
            String userId = request.getHeader(HEADER_USER_ID);
            if (userId != null && !userId.isEmpty()) {
                AuthenticationContext ctx = extractUserContext(request);
                if (ctx != null) {
                    request.setAttribute(AUTH_CONTEXT_ATTRIBUTE, ctx);
                    log.debug("User authentication context set for user: {}", ctx.getUserId());
                }
            }
        }

        filterChain.doFilter(request, response);
    }

    /**
     * Extracts user authentication context from Envoy headers.
     */
    private AuthenticationContext extractUserContext(HttpServletRequest request) {
        try {
            String userIdStr = request.getHeader(HEADER_USER_ID);
            String email = request.getHeader(HEADER_USER_EMAIL);
            String roleStr = request.getHeader(HEADER_USER_ROLE);
            String googleId = request.getHeader(HEADER_GOOGLE_ID);

            if (userIdStr == null || email == null || roleStr == null) {
                log.warn("Missing required user authentication headers");
                return null;
            }

            UUID userId = UUID.fromString(userIdStr);
            Role role = Role.valueOf(roleStr);

            return AuthenticationContext.forUser(userId, email, role, googleId);

        } catch (IllegalArgumentException e) {
            log.error("Invalid user authentication header value: {}", e.getMessage());
            return null;
        }
    }

    /**
     * Extracts PAT authentication context from Envoy headers.
     */
    private AuthenticationContext extractPATContext(HttpServletRequest request) {
        try {
            String patIdStr = request.getHeader(HEADER_PAT_ID);
            String serviceName = request.getHeader(HEADER_SERVICE_ID);
            String scopeStr = request.getHeader(HEADER_PAT_SCOPE);

            if (patIdStr == null || scopeStr == null) {
                log.warn("Missing required PAT authentication headers");
                return null;
            }

            UUID patId = UUID.fromString(patIdStr);
            PATScope scope = PATScope.valueOf(scopeStr);

            return AuthenticationContext.forPAT(patId, serviceName, scope);

        } catch (IllegalArgumentException e) {
            log.error("Invalid PAT authentication header value: {}", e.getMessage());
            return null;
        }
    }

    /**
     * Utility method to get the authentication context from a request.
     *
     * @param request the HTTP request
     * @return the authentication context, or null if not authenticated
     */
    public static AuthenticationContext getAuthenticationContext(HttpServletRequest request) {
        return (AuthenticationContext) request.getAttribute(AUTH_CONTEXT_ATTRIBUTE);
    }

    /**
     * Public endpoints that don't require authentication
     */
    @Override
    protected boolean shouldNotFilter(HttpServletRequest request) {
        String path = request.getRequestURI();
        return path.startsWith("/api/v1/public/") ||
               path.equals("/health") ||
               path.equals("/ready") ||
               path.startsWith("/docs") ||
               path.startsWith("/swagger-ui") ||
               path.startsWith("/v3/api-docs");
    }
}
