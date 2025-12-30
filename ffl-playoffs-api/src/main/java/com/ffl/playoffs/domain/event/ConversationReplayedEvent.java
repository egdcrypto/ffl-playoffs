package com.ffl.playoffs.domain.event;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDateTime;
import java.util.Map;
import java.util.UUID;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class ConversationReplayedEvent {
    private UUID replayId;
    private UUID conversationId;
    private UUID characterId;
    private UUID adminId;
    private boolean useCurrentSettings;
    private Map<String, Double> modifiedTraits;
    private double qualityDelta;
    private LocalDateTime timestamp;
}
