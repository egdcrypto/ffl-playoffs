package com.ffl.playoffs.bdd;

import io.cucumber.spring.CucumberContextConfiguration;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.test.context.ActiveProfiles;
import org.springframework.test.context.DynamicPropertyRegistry;
import org.springframework.test.context.DynamicPropertySource;
import org.testcontainers.containers.GenericContainer;
import org.testcontainers.containers.wait.strategy.Wait;
import org.testcontainers.utility.DockerImageName;

import java.time.Duration;

/**
 * Cucumber Spring integration configuration
 * Enables Spring Boot context for all Cucumber scenarios
 */
@CucumberContextConfiguration
@SpringBootTest
@ActiveProfiles("test")
public class CucumberSpringConfiguration {

    // Shared MongoDB container for all Cucumber tests
    static GenericContainer<?> mongoDBContainer;

    static {
        mongoDBContainer = new GenericContainer<>(DockerImageName.parse("mongo:6.0"))
                .withExposedPorts(27017)
                .waitingFor(Wait.forListeningPort().withStartupTimeout(Duration.ofMinutes(2)));
        mongoDBContainer.start();
    }

    @DynamicPropertySource
    static void setProperties(DynamicPropertyRegistry registry) {
        registry.add("spring.data.mongodb.uri", () ->
            String.format("mongodb://%s:%d/test",
                mongoDBContainer.getHost(),
                mongoDBContainer.getMappedPort(27017)));
    }
}
