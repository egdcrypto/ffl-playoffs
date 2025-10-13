package com.ffl.playoffs.scripts;

import com.ffl.playoffs.domain.model.PATScope;
import com.ffl.playoffs.domain.model.PersonalAccessToken;
import com.ffl.playoffs.domain.port.PersonalAccessTokenRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.CommandLineRunner;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.context.annotation.ComponentScan;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;

import java.security.SecureRandom;
import java.time.LocalDateTime;
import java.util.Base64;
import java.util.UUID;

/**
 * Bootstrap PAT (Personal Access Token) Setup Script
 *
 * Generates a bootstrap PAT with ADMIN scope and 1-year expiry for initial system setup.
 * The token is hashed with BCrypt, stored in the database, and the plaintext is output once.
 *
 * Usage:
 *   ./gradlew bootRun --args="--spring.profiles.active=bootstrap"
 *
 * Or compile and run:
 *   ./gradlew build
 *   java -jar build/libs/ffl-playoffs-api.jar --spring.profiles.active=bootstrap
 *
 * SECURITY WARNING:
 * - The plaintext token is displayed ONLY ONCE during generation
 * - Store it securely (e.g., in a password manager or secure vault)
 * - The token has ADMIN scope and can perform all operations
 * - Revoke this token once proper authentication is set up
 */
@SpringBootApplication
@ComponentScan(basePackages = "com.ffl.playoffs")
public class BootstrapPATScript implements CommandLineRunner {

    @Autowired
    private PersonalAccessTokenRepository tokenRepository;

    private final BCryptPasswordEncoder passwordEncoder = new BCryptPasswordEncoder(12);
    private final SecureRandom secureRandom = new SecureRandom();

    public static void main(String[] args) {
        SpringApplication.run(BootstrapPATScript.class, args);
    }

    @Override
    public void run(String... args) throws Exception {
        System.out.println("========================================");
        System.out.println("Bootstrap PAT Generation Script");
        System.out.println("========================================");
        System.out.println();

        // Check if bootstrap token already exists
        if (tokenRepository.existsByName("bootstrap-admin-token")) {
            System.err.println("ERROR: Bootstrap token already exists!");
            System.err.println("If you need to regenerate, manually delete the existing token from the database first.");
            System.exit(1);
        }

        // Generate secure random token
        String plaintextToken = generateSecureToken();

        // Extract token identifier (first 16 characters for lookup)
        String tokenIdentifier = plaintextToken.substring(0, 16);

        // Hash the full token with BCrypt
        String tokenHash = passwordEncoder.encode(plaintextToken);

        // Create PAT entity
        PersonalAccessToken pat = new PersonalAccessToken();
        pat.setId(UUID.randomUUID());
        pat.setName("bootstrap-admin-token");
        pat.setTokenIdentifier(tokenIdentifier);
        pat.setTokenHash(tokenHash);
        pat.setScope(PATScope.ADMIN);
        pat.setExpiresAt(LocalDateTime.now().plusYears(1));
        pat.setCreatedBy(null); // System-generated, no user
        pat.setCreatedAt(LocalDateTime.now());
        pat.setRevoked(false);

        // Save to database
        PersonalAccessToken savedPat = tokenRepository.save(pat);

        // Output results
        System.out.println("✓ Bootstrap PAT generated successfully!");
        System.out.println();
        System.out.println("Token Details:");
        System.out.println("  ID:         " + savedPat.getId());
        System.out.println("  Name:       " + savedPat.getName());
        System.out.println("  Scope:      " + savedPat.getScope());
        System.out.println("  Expires:    " + savedPat.getExpiresAt());
        System.out.println();
        System.out.println("========================================");
        System.out.println("PLAINTEXT TOKEN (SAVE THIS NOW!)");
        System.out.println("========================================");
        System.out.println();
        System.out.println("  " + plaintextToken);
        System.out.println();
        System.out.println("========================================");
        System.out.println();
        System.out.println("IMPORTANT SECURITY NOTES:");
        System.out.println("  1. This token will NOT be displayed again");
        System.out.println("  2. Store it in a secure location (password manager/vault)");
        System.out.println("  3. This token has ADMIN scope - protect it carefully");
        System.out.println("  4. Use this token to bootstrap the initial super admin user");
        System.out.println("  5. Revoke this token after setting up proper authentication");
        System.out.println();
        System.out.println("Usage in API requests:");
        System.out.println("  Authorization: Bearer " + plaintextToken);
        System.out.println();
        System.out.println("========================================");

        System.exit(0);
    }

    /**
     * Generate a cryptographically secure random token
     * Format: Base64-encoded 32-byte random value (43 characters)
     */
    private String generateSecureToken() {
        byte[] randomBytes = new byte[32];
        secureRandom.nextBytes(randomBytes);

        // Base64 URL-safe encoding (no padding)
        return Base64.getUrlEncoder().withoutPadding().encodeToString(randomBytes);
    }
}
