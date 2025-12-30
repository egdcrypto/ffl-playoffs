package com.ffl.playoffs.infrastructure.config;

import org.springframework.context.annotation.Configuration;
import org.springframework.data.mongodb.repository.config.EnableMongoRepositories;

/**
 * MongoDB configuration
 * Separated from main application to prevent loading during @WebMvcTest
 */
@Configuration
@EnableMongoRepositories(basePackages = {
        "com.ffl.playoffs.infrastructure.adapter.persistence.repository",
        "com.ffl.playoffs.infrastructure.persistence.mongodb.repository"
})
public class MongoDbConfig {
}
