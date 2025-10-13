package com.ffl.playoffs.infrastructure.auth;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.boot.autoconfigure.domain.EntityScan;
import org.springframework.context.annotation.ComponentScan;
import org.springframework.data.mongodb.repository.config.EnableMongoRepositories;

/**
 * Standalone authentication service application
 * Runs on localhost:9191 and validates tokens for Envoy ext_authz
 *
 * This is a separate Spring Boot application that:
 * 1. Listens on localhost:9191 (not externally accessible)
 * 2. Called by Envoy's ext_authz filter for every request
 * 3. Validates Google JWT tokens and PATs
 * 4. Returns user/service context headers to Envoy
 *
 * In production, this runs in the same Kubernetes pod as:
 * - Main API (localhost:8080)
 * - Envoy sidecar (pod IP:443)
 */
@SpringBootApplication
@ComponentScan(basePackages = {
        "com.ffl.playoffs.infrastructure.auth",
        "com.ffl.playoffs.infrastructure.adapter.persistence",
        "com.ffl.playoffs.domain"
})
@EnableMongoRepositories(basePackages = "com.ffl.playoffs.infrastructure.adapter.persistence.repository")
@EntityScan(basePackages = "com.ffl.playoffs.infrastructure.adapter.persistence.document")
public class AuthServiceApplication {

    public static void main(String[] args) {
        SpringApplication.run(AuthServiceApplication.class, args);
    }
}
