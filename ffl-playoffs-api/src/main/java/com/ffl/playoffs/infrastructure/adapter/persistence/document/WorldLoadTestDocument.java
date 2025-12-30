package com.ffl.playoffs.infrastructure.adapter.persistence.document;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;
import org.springframework.data.annotation.Id;
import org.springframework.data.mongodb.core.index.Indexed;
import org.springframework.data.mongodb.core.mapping.Document;

import java.time.Instant;
import java.util.Map;

/**
 * MongoDB document for WorldLoadTest aggregate.
 */
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
@Document(collection = "world_load_tests")
public class WorldLoadTestDocument {

    @Id
    private String id;

    @Indexed(unique = true)
    private String worldId;

    private String worldName;
    private String overallStatus;
    private String currentRunId;
    private Instant lastRunAt;
    private Integer totalRunsCompleted;
    private Integer totalRunsFailed;
    private Long averageRunDurationMillis;
    private Map<String, String> metadata;
    private Instant createdAt;
    private Instant updatedAt;
}
