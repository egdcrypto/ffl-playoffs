package com.ffl.playoffs.bdd;

import io.cucumber.spring.CucumberContextConfiguration;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.test.context.ActiveProfiles;

/**
 * Cucumber Spring integration configuration
 * Enables Spring Boot context for all Cucumber scenarios
 */
@CucumberContextConfiguration
@SpringBootTest
@ActiveProfiles("test")
public class CucumberSpringConfiguration {
    // This class enables Spring Boot context for Cucumber
    // All step definitions will have access to Spring beans
}
