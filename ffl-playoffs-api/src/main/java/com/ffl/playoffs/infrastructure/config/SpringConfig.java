package com.ffl.playoffs.infrastructure.config;

import com.ffl.playoffs.domain.service.ScoringService;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

/**
 * Spring configuration for the application.
 */
@Configuration
public class SpringConfig {

    @Bean
    public ScoringService scoringService() {
        return new ScoringService();
    }
}
