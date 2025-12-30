package com.ffl.playoffs.domain.event;

import com.ffl.playoffs.domain.model.RankChange;

import java.time.LocalDateTime;
import java.util.List;
import java.util.UUID;

/**
 * Domain event fired when leaderboard rankings change
 * Contains all rank changes for a single update cycle
 */
public class LeaderboardRankChangedEvent {
    private final UUID eventId;
    private final String leagueId;
    private final List<RankChange> rankChanges;
    private final LocalDateTime occurredAt;

    private LeaderboardRankChangedEvent(Builder builder) {
        this.eventId = UUID.randomUUID();
        this.leagueId = builder.leagueId;
        this.rankChanges = builder.rankChanges != null ?
                List.copyOf(builder.rankChanges) : List.of();
        this.occurredAt = LocalDateTime.now();
    }

    public static Builder builder() {
        return new Builder();
    }

    public UUID getEventId() {
        return eventId;
    }

    public String getLeagueId() {
        return leagueId;
    }

    public List<RankChange> getRankChanges() {
        return rankChanges;
    }

    public LocalDateTime getOccurredAt() {
        return occurredAt;
    }

    /**
     * Get rank changes for a specific player
     * @param leaguePlayerId the player ID
     * @return the rank change if present, null otherwise
     */
    public RankChange getRankChangeForPlayer(String leaguePlayerId) {
        return rankChanges.stream()
                .filter(rc -> rc.getLeaguePlayerId().equals(leaguePlayerId))
                .findFirst()
                .orElse(null);
    }

    /**
     * Check if any player entered top 3
     * @return true if someone moved into top 3
     */
    public boolean hasTopThreeEntry() {
        return rankChanges.stream().anyMatch(RankChange::enteredTopThree);
    }

    /**
     * Get significant rank changes (3+ positions)
     * @return list of significant changes
     */
    public List<RankChange> getSignificantChanges() {
        return rankChanges.stream()
                .filter(RankChange::isSignificant)
                .toList();
    }

    public static class Builder {
        private String leagueId;
        private List<RankChange> rankChanges;

        public Builder leagueId(String leagueId) {
            this.leagueId = leagueId;
            return this;
        }

        public Builder rankChanges(List<RankChange> rankChanges) {
            this.rankChanges = rankChanges;
            return this;
        }

        public LeaderboardRankChangedEvent build() {
            return new LeaderboardRankChangedEvent(this);
        }
    }
}
