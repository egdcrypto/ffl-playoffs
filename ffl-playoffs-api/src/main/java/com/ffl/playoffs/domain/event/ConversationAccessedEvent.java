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
public class ConversationAccessedEvent {
    private UUID conversationId;
    private UUID adminId;
    private String purpose;
    private boolean wasAnonymized;
    private LocalDateTime timestamp;
}
