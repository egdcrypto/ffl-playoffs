package com.ffl.playoffs.domain.event;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDateTime;
import java.util.UUID;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class TestSuiteCreatedEvent {
    private UUID suiteId;
    private String name;
    private UUID characterId;
    private int testCaseCount;
    private UUID createdBy;
    private LocalDateTime timestamp;
}
