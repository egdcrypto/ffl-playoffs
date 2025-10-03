package com.ffl.playoffs.application.dto;

import com.ffl.playoffs.domain.model.Player;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDateTime;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class PlayerDTO {
    private Long id;
    private String email;
    private String displayName;
    private String googleId;
    private LocalDateTime joinedAt;
    private String status;
    
    public static PlayerDTO fromDomain(Player player) {
        return PlayerDTO.builder()
                .id(player.getId())
                .email(player.getEmail())
                .displayName(player.getDisplayName())
                .googleId(player.getGoogleId())
                .joinedAt(player.getJoinedAt())
                .status(player.getStatus().name())
                .build();
    }
}
