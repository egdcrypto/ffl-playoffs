package com.ffl.playoffs.application.dto;

import com.ffl.playoffs.domain.model.Game;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDateTime;
import java.util.Set;
import java.util.stream.Collectors;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class GameDTO {
    private Long id;
    private String name;
    private String inviteCode;
    private LocalDateTime createdAt;
    private Integer currentWeek;
    private String status;
    private Set<PlayerDTO> players;
    
    public static GameDTO fromDomain(Game game) {
        return GameDTO.builder()
                .id(game.getId())
                .name(game.getName())
                .inviteCode(game.getInviteCode())
                .createdAt(game.getCreatedAt())
                .currentWeek(game.getCurrentWeek())
                .status(game.getStatus().name())
                .players(game.getPlayers().stream()
                        .map(PlayerDTO::fromDomain)
                        .collect(Collectors.toSet()))
                .build();
    }
}
