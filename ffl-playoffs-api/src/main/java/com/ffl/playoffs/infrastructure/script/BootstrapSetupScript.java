package com.ffl.playoffs.infrastructure.script;

import com.ffl.playoffs.application.usecase.CreateBootstrapPATUseCase;
import org.springframework.boot.CommandLineRunner;
import org.springframework.boot.autoconfigure.condition.ConditionalOnProperty;
import org.springframework.stereotype.Component;

/**
 * Bootstrap setup script that creates the initial bootstrap PAT
 * Run this script with: --bootstrap.enabled=true
 *
 * Example: ./gradlew bootRun --args='--bootstrap.enabled=true'
 *
 * SECURITY:
 * - The plaintext PAT is shown ONLY ONCE on console
 * - NEVER logged to files
 * - Only bcrypt hash is stored in database
 * - Can only be run once (prevents duplicate bootstrap PATs)
 */
@Component
@ConditionalOnProperty(name = "bootstrap.enabled", havingValue = "true")
public class BootstrapSetupScript implements CommandLineRunner {

    private final CreateBootstrapPATUseCase createBootstrapPATUseCase;

    public BootstrapSetupScript(CreateBootstrapPATUseCase createBootstrapPATUseCase) {
        this.createBootstrapPATUseCase = createBootstrapPATUseCase;
    }

    @Override
    public void run(String... args) {
        System.out.println("\n" + "=".repeat(80));
        System.out.println("BOOTSTRAP PAT SETUP");
        System.out.println("=".repeat(80));

        try {
            CreateBootstrapPATUseCase.CreateBootstrapPATResult result = createBootstrapPATUseCase.execute();

            System.out.println("\nBootstrap PAT created successfully!");
            System.out.println("\nPAT Details:");
            System.out.println("  ID:         " + result.getId());
            System.out.println("  Name:       " + result.getName());
            System.out.println("  Scope:      " + result.getScope());
            System.out.println("  Created By: " + result.getCreatedBy());
            System.out.println("  Created At: " + result.getCreatedAt());
            System.out.println("  Expires At: " + result.getExpiresAt());
            System.out.println("\n" + "=".repeat(80));
            System.out.println("⚠️  IMPORTANT: SAVE THIS TOKEN - IT WILL NOT BE SHOWN AGAIN  ⚠️");
            System.out.println("=".repeat(80));
            System.out.println("\nBootstrap PAT (SAVE THIS - shown only once):");
            System.out.println("\n  " + result.getPlaintextToken());
            System.out.println("\n" + "=".repeat(80));
            System.out.println("Use this PAT to create the first super admin account:");
            System.out.println("  POST /api/v1/superadmin/bootstrap");
            System.out.println("  Authorization: Bearer " + result.getPlaintextToken());
            System.out.println("  Body: {\"email\": \"admin@example.com\", \"googleId\": \"google-user-123\"}");
            System.out.println("=".repeat(80) + "\n");

        } catch (IllegalStateException e) {
            System.err.println("\n❌ ERROR: " + e.getMessage());
            System.err.println("\nThe bootstrap PAT has already been created.");
            System.err.println("If you need to create a new one, revoke the existing bootstrap PAT first.");
            System.err.println("=".repeat(80) + "\n");
        } catch (Exception e) {
            System.err.println("\n❌ FATAL ERROR: Failed to create bootstrap PAT");
            System.err.println("Error: " + e.getMessage());
            System.err.println("\nPlease check:");
            System.err.println("  - Database is running and accessible");
            System.err.println("  - Database schema is initialized");
            System.err.println("  - Application configuration is correct");
            System.err.println("=".repeat(80) + "\n");
            e.printStackTrace();
        }
    }
}
