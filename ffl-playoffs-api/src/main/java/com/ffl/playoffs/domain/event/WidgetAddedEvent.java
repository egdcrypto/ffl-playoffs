package com.ffl.playoffs.domain.event;

import com.ffl.playoffs.domain.model.WidgetPosition;
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
public class WidgetAddedEvent {
    private UUID adminId;
    private String widgetId;
    private WidgetPosition position;
    private LocalDateTime timestamp;
}
