package com.ffl.playoffs.domain.aggregate;

import com.ffl.playoffs.domain.model.Player;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDateTime;
import java.util.HashSet;
import java.util.Set;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class Game {
    private Long id;
    private String name;
    private String inviteCode;
    private LocalDateTime createdAt;
    private Integer currentWeek;
    private GameStatus status;
    
    @Builder.Default
    private Set<Player> players = new HashSet<>();
    
    @Builder.Default
    private Set<Week> weeks = new HashSet<>();
    
    public enum GameStatus {
        PENDING,
        IN_PROGRESS,
        COMPLETED
    }
    
    public void addPlayer(Player player) {
        this.players.add(player);
    }
    
    public void advanceWeek() {
        if (this.currentWeek == null) {
            this.currentWeek = 1;
        } else {
            this.currentWeek++;
        }
    }
    
    public boolean isReadyToStart() {
        return this.players.size() >= 2 && this.status == GameStatus.PENDING;
    }
}
