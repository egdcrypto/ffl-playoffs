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
public class AlertResolvedEvent {
    private UUID adminId;
    private UUID alertId;
    private String resolution;
    private String rootCause;
    private LocalDateTime timestamp;
}
