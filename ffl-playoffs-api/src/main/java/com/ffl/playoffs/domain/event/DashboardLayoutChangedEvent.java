package com.ffl.playoffs.domain.event;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDateTime;
import java.util.List;
import java.util.UUID;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class DashboardLayoutChangedEvent {
    private UUID adminId;
    private List<String> oldLayout;
    private List<String> newLayout;
    private LocalDateTime timestamp;
}
