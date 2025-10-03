package com.ffl.playoffs.domain.event;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDateTime;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class GameCreatedEvent {
    private Long gameId;
    private String gameName;
    private String inviteCode;
    private String creatorEmail;
    private LocalDateTime createdAt;
}
