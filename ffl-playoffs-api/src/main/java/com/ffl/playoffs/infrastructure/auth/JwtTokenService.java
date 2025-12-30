package com.ffl.playoffs.infrastructure.auth;

import com.ffl.playoffs.domain.aggregate.User;
import io.jsonwebtoken.Claims;
import io.jsonwebtoken.ExpiredJwtException;
import io.jsonwebtoken.Jwts;
import io.jsonwebtoken.security.Keys;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;

import javax.crypto.SecretKey;
import java.nio.charset.StandardCharsets;
import java.time.Instant;
import java.util.Date;
import java.util.UUID;

/**
 * Service for generating and validating application JWT tokens.
 * These are our own tokens issued after Google OAuth login.
 */
@Service
public class JwtTokenService {

    private static final Logger logger = LoggerFactory.getLogger(JwtTokenService.class);

    private final SecretKey accessTokenKey;
    private final SecretKey refreshTokenKey;
    private final long accessTokenExpirationMs;
    private final long refreshTokenExpirationMs;
    private final String issuer;

    public JwtTokenService(
            @Value("${jwt.access-token.secret:default-access-secret-key-change-in-production-32chars}") String accessSecret,
            @Value("${jwt.refresh-token.secret:default-refresh-secret-key-change-in-production-32chars}") String refreshSecret,
            @Value("${jwt.access-token.expiration-ms:900000}") long accessTokenExpirationMs,  // 15 minutes
            @Value("${jwt.refresh-token.expiration-ms:604800000}") long refreshTokenExpirationMs,  // 7 days
            @Value("${jwt.issuer:ffl-playoffs}") String issuer) {
        this.accessTokenKey = Keys.hmacShaKeyFor(padSecret(accessSecret).getBytes(StandardCharsets.UTF_8));
        this.refreshTokenKey = Keys.hmacShaKeyFor(padSecret(refreshSecret).getBytes(StandardCharsets.UTF_8));
        this.accessTokenExpirationMs = accessTokenExpirationMs;
        this.refreshTokenExpirationMs = refreshTokenExpirationMs;
        this.issuer = issuer;
    }

    /**
     * Pad secret to minimum 32 characters for HMAC-SHA256
     */
    private String padSecret(String secret) {
        if (secret.length() >= 32) {
            return secret;
        }
        return secret + "0".repeat(32 - secret.length());
    }

    /**
     * Generate access token for a user
     */
    public String generateAccessToken(User user) {
        Instant now = Instant.now();
        Instant expiration = now.plusMillis(accessTokenExpirationMs);

        return Jwts.builder()
                .subject(user.getId().toString())
                .issuer(issuer)
                .issuedAt(Date.from(now))
                .expiration(Date.from(expiration))
                .claim("email", user.getEmail())
                .claim("name", user.getName())
                .claim("role", user.getRole().name())
                .claim("type", "access")
                .signWith(accessTokenKey)
                .compact();
    }

    /**
     * Generate refresh token for a user
     */
    public String generateRefreshToken(User user) {
        Instant now = Instant.now();
        Instant expiration = now.plusMillis(refreshTokenExpirationMs);

        return Jwts.builder()
                .subject(user.getId().toString())
                .issuer(issuer)
                .issuedAt(Date.from(now))
                .expiration(Date.from(expiration))
                .claim("type", "refresh")
                .id(UUID.randomUUID().toString())  // Unique token ID for revocation
                .signWith(refreshTokenKey)
                .compact();
    }

    /**
     * Validate access token and extract claims
     * @return Claims if valid, null if invalid
     */
    public Claims validateAccessToken(String token) {
        try {
            Claims claims = Jwts.parser()
                    .verifyWith(accessTokenKey)
                    .requireIssuer(issuer)
                    .build()
                    .parseSignedClaims(token)
                    .getPayload();

            // Verify it's an access token
            String type = claims.get("type", String.class);
            if (!"access".equals(type)) {
                logger.warn("Token is not an access token");
                return null;
            }

            return claims;
        } catch (ExpiredJwtException e) {
            logger.debug("Access token expired");
            return null;
        } catch (Exception e) {
            logger.warn("Invalid access token: {}", e.getMessage());
            return null;
        }
    }

    /**
     * Validate refresh token and extract claims
     * @return Claims if valid, null if invalid
     */
    public Claims validateRefreshToken(String token) {
        try {
            Claims claims = Jwts.parser()
                    .verifyWith(refreshTokenKey)
                    .requireIssuer(issuer)
                    .build()
                    .parseSignedClaims(token)
                    .getPayload();

            // Verify it's a refresh token
            String type = claims.get("type", String.class);
            if (!"refresh".equals(type)) {
                logger.warn("Token is not a refresh token");
                return null;
            }

            return claims;
        } catch (ExpiredJwtException e) {
            logger.debug("Refresh token expired");
            return null;
        } catch (Exception e) {
            logger.warn("Invalid refresh token: {}", e.getMessage());
            return null;
        }
    }

    /**
     * Extract user ID from token claims
     */
    public UUID extractUserId(Claims claims) {
        return UUID.fromString(claims.getSubject());
    }

    /**
     * Get access token expiration in seconds
     */
    public long getAccessTokenExpirationSeconds() {
        return accessTokenExpirationMs / 1000;
    }

    /**
     * Get refresh token expiration in seconds
     */
    public long getRefreshTokenExpirationSeconds() {
        return refreshTokenExpirationMs / 1000;
    }
}
