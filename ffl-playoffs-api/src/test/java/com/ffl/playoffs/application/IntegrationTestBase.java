package com.ffl.playoffs.application;

import org.junit.jupiter.api.AfterEach;
import org.junit.jupiter.api.BeforeEach;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.data.mongodb.core.MongoTemplate;
import org.springframework.test.context.ActiveProfiles;
import org.springframework.test.context.DynamicPropertyRegistry;
import org.springframework.test.context.DynamicPropertySource;
import org.testcontainers.containers.GenericContainer;
import org.testcontainers.containers.wait.strategy.Wait;
import org.testcontainers.junit.jupiter.Container;
import org.testcontainers.junit.jupiter.Testcontainers;
import org.testcontainers.utility.DockerImageName;

import java.time.Duration;

/**
 * Base class for integration tests with embedded MongoDB using Testcontainers.
 * All integration tests should extend this class to get MongoDB support.
 */
@SpringBootTest
@ActiveProfiles("test")
@Testcontainers
public abstract class IntegrationTestBase {

    @Container
    static GenericContainer<?> mongoDBContainer = new GenericContainer<>(DockerImageName.parse("mongo:6.0"))
            .withExposedPorts(27017)
            .waitingFor(Wait.forListeningPort().withStartupTimeout(Duration.ofMinutes(2)));

    @DynamicPropertySource
    static void setProperties(DynamicPropertyRegistry registry) {
        registry.add("spring.data.mongodb.uri", () ->
            String.format("mongodb://%s:%d/test",
                mongoDBContainer.getHost(),
                mongoDBContainer.getMappedPort(27017)));
    }

    @Autowired
    protected MongoTemplate mongoTemplate;

    @BeforeEach
    protected void baseSetUp() {
        // Ensure clean state before each test
        cleanDatabase();
    }

    @AfterEach
    protected void baseTearDown() {
        // Clean up after each test
        cleanDatabase();
    }

    /**
     * Clean all collections in the test database
     */
    protected void cleanDatabase() {
        mongoTemplate.getDb().listCollectionNames()
                .forEach(collectionName -> mongoTemplate.getCollection(collectionName).drop());
    }
}
