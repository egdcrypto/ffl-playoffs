package com.ffl.playoffs.domain.model.character;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.Instant;
import java.util.Objects;
import java.util.UUID;

/**
 * Character entity representing a player's character in a league/game
 * Follows a three-stage lifecycle: DRAFT -> ACTIVE -> ELIMINATED
 */
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class Character {

    private UUID id;
    private UUID userId;           // The user who owns this character
    private UUID leagueId;         // The league this character belongs to
    private String name;           // Display name for the character
    private String avatarUrl;      // Optional avatar image URL
    private CharacterStatus status;

    // Score tracking
    private Double totalScore;
    private Integer weeklyRank;
    private Integer overallRank;

    // Elimination details
    private Integer eliminationWeek;
    private Double eliminationScore;
    private Integer eliminationRank;
    private String eliminationReason;

    // Timestamps
    private Instant createdAt;
    private Instant activatedAt;
    private Instant eliminatedAt;
    private Instant updatedAt;

    /**
     * Create a new character in DRAFT status
     * @param userId the user who owns this character
     * @param leagueId the league this character belongs to
     * @param name the display name for the character
     * @return new Character in DRAFT status
     */
    public static Character create(UUID userId, UUID leagueId, String name) {
        Objects.requireNonNull(userId, "User ID cannot be null");
        Objects.requireNonNull(leagueId, "League ID cannot be null");
        if (name == null || name.isBlank()) {
            throw new IllegalArgumentException("Name cannot be blank");
        }

        Instant now = Instant.now();

        return Character.builder()
                .id(UUID.randomUUID())
                .userId(userId)
                .leagueId(leagueId)
                .name(name.trim())
                .status(CharacterStatus.DRAFT)
                .totalScore(0.0)
                .createdAt(now)
                .updatedAt(now)
                .build();
    }

    /**
     * Activate the character for competition
     * Transitions from DRAFT to ACTIVE
     * @throws IllegalStateException if character cannot be activated
     */
    public void activate() {
        if (!status.canActivate()) {
            throw new IllegalStateException("Cannot activate character in status: " + status);
        }

        this.status = CharacterStatus.ACTIVE;
        this.activatedAt = Instant.now();
        this.updatedAt = Instant.now();
    }

    /**
     * Eliminate the character from competition
     * Transitions from ACTIVE to ELIMINATED
     * @param week the week of elimination
     * @param rank the rank at elimination
     * @param reason the reason for elimination
     * @throws IllegalStateException if character cannot be eliminated
     */
    public void eliminate(Integer week, Integer rank, String reason) {
        if (!status.canEliminate()) {
            throw new IllegalStateException("Cannot eliminate character in status: " + status);
        }

        this.status = CharacterStatus.ELIMINATED;
        this.eliminationWeek = week;
        this.eliminationRank = rank;
        this.eliminationScore = this.totalScore;
        this.eliminationReason = reason;
        this.eliminatedAt = Instant.now();
        this.updatedAt = Instant.now();
    }

    /**
     * Eliminate the character from competition (simple version)
     * @param week the week of elimination
     * @param rank the rank at elimination
     */
    public void eliminate(Integer week, Integer rank) {
        eliminate(week, rank, "Lowest score in week " + week);
    }

    /**
     * Add score to the character's total
     * Only active characters can accumulate score
     * @param score the score to add
     * @throws IllegalStateException if character cannot accumulate score
     */
    public void addScore(Double score) {
        if (!status.canAccumulateScore()) {
            throw new IllegalStateException("Cannot add score to character in status: " + status);
        }

        if (score == null || score < 0) {
            throw new IllegalArgumentException("Score must be non-negative");
        }

        this.totalScore = (this.totalScore != null ? this.totalScore : 0.0) + score;
        this.updatedAt = Instant.now();
    }

    /**
     * Update the character's weekly rank
     * @param rank the new weekly rank
     */
    public void updateWeeklyRank(Integer rank) {
        this.weeklyRank = rank;
        this.updatedAt = Instant.now();
    }

    /**
     * Update the character's overall rank
     * @param rank the new overall rank
     */
    public void updateOverallRank(Integer rank) {
        this.overallRank = rank;
        this.updatedAt = Instant.now();
    }

    /**
     * Update the character's name
     * Only draft characters can change their name
     * @param newName the new name
     */
    public void updateName(String newName) {
        if (newName == null || newName.isBlank()) {
            throw new IllegalArgumentException("Name cannot be blank");
        }

        if (!status.isDraft()) {
            throw new IllegalStateException("Cannot change name after draft phase");
        }

        this.name = newName.trim();
        this.updatedAt = Instant.now();
    }

    /**
     * Update the character's avatar
     * @param avatarUrl the new avatar URL
     */
    public void updateAvatar(String avatarUrl) {
        this.avatarUrl = avatarUrl;
        this.updatedAt = Instant.now();
    }

    /**
     * Check if the character is in draft status
     * @return true if in draft
     */
    public boolean isDraft() {
        return status != null && status.isDraft();
    }

    /**
     * Check if the character is active
     * @return true if active
     */
    public boolean isActive() {
        return status != null && status.isActive();
    }

    /**
     * Check if the character is eliminated
     * @return true if eliminated
     */
    public boolean isEliminated() {
        return status != null && status.isEliminated();
    }

    /**
     * Check if the character is still in competition
     * @return true if still in competition
     */
    public boolean isInCompetition() {
        return status != null && status.isInCompetition();
    }

    /**
     * Check if the character can make selections
     * @return true if can make selections
     */
    public boolean canMakeSelections() {
        return status != null && status.canMakeSelections();
    }

    /**
     * Get the number of weeks the character participated
     * @return number of weeks, or null if not eliminated
     */
    public Integer getWeeksParticipated() {
        if (eliminationWeek != null) {
            return eliminationWeek;
        }
        return null;
    }

    /**
     * Get a display string for the character's status
     * @return status display string
     */
    public String getStatusDisplay() {
        if (status == null) {
            return "Unknown";
        }

        return switch (status) {
            case DRAFT -> "Preparing";
            case ACTIVE -> "In Competition (Rank #" + (overallRank != null ? overallRank : "?") + ")";
            case ELIMINATED -> "Eliminated (Week " + eliminationWeek + ", Rank #" + eliminationRank + ")";
        };
    }

    /**
     * Check if this character belongs to the specified user
     * @param userId the user ID to check
     * @return true if the character belongs to the user
     */
    public boolean belongsTo(UUID userId) {
        return this.userId != null && this.userId.equals(userId);
    }

    /**
     * Check if this character is in the specified league
     * @param leagueId the league ID to check
     * @return true if the character is in the league
     */
    public boolean isInLeague(UUID leagueId) {
        return this.leagueId != null && this.leagueId.equals(leagueId);
    }
}
