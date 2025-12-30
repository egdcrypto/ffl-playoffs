package com.ffl.playoffs.application;

import org.junit.jupiter.api.AfterEach;
import org.junit.jupiter.api.BeforeEach;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.data.mongodb.core.MongoTemplate;
import org.springframework.test.context.ActiveProfiles;
import org.springframework.test.context.DynamicPropertyRegistry;
import org.springframework.test.context.DynamicPropertySource;
import org.testcontainers.containers.MongoDBContainer;
import org.testcontainers.junit.jupiter.Container;
import org.testcontainers.junit.jupiter.Testcontainers;

/**
 * Base class for integration tests with embedded MongoDB using Testcontainers.
 * All integration tests should extend this class to get MongoDB support.
 */
@SpringBootTest
@ActiveProfiles("test")
@Testcontainers
public abstract class IntegrationTestBase {

    @Container
    static MongoDBContainer mongoDBContainer = new MongoDBContainer("mongo:4.0.10")
            .withExposedPorts(27017);

    @DynamicPropertySource
    static void setProperties(DynamicPropertyRegistry registry) {
        registry.add("spring.data.mongodb.uri", mongoDBContainer::getReplicaSetUrl);
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
