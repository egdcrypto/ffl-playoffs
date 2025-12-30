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
public class SyntheticTestFailedEvent {
    private UUID testId;
    private String testName;
    private String location;
    private String error;
    private double responseTimeMs;
    private LocalDateTime timestamp;
}
