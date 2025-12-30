package com.ffl.playoffs.domain.aggregate;

import com.ffl.playoffs.domain.model.character.*;

import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.Collections;
import java.util.List;
import java.util.Objects;
import java.util.Optional;
import java.util.UUID;

/**
 * Character aggregate root
 *
 * Represents a player's customizable identity/profile within a league context.
 * Contains team branding, achievements, progression, and statistics.
 *
 * Domain model with no framework dependencies.
 */
public class Character {

    private static final int XP_PER_LEVEL = 100;
    private static final int MAX_LEVEL = 100;

    private UUID id;
    private UUID userId;
    private UUID leagueId;

    // Branding and identity
    private TeamBranding branding;

    // Progression
    private CharacterType type;
    private Integer level;
    private Integer experiencePoints;

    // Achievements
    private List<Achievement> achievements;

    // Statistics
    private CharacterStats stats;

    // Metadata
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;
    private LocalDateTime lastActivityAt;

    /**
     * Default constructor for creating a new Character
     */
    public Character() {
        this.id = UUID.randomUUID();
        this.type = CharacterType.ROOKIE;
        this.level = 1;
        this.experiencePoints = 0;
        this.achievements = new ArrayList<>();
        this.stats = CharacterStats.empty();
        this.createdAt = LocalDateTime.now();
        this.updatedAt = LocalDateTime.now();
        this.lastActivityAt = LocalDateTime.now();
    }

    /**
     * Constructor with essential parameters
     *
     * @param userId the user ID who owns this character
     * @param leagueId the league this character belongs to
     * @param teamName initial team name
     */
    public Character(UUID userId, UUID leagueId, String teamName) {
        this();
        this.userId = Objects.requireNonNull(userId, "User ID is required");
        this.leagueId = Objects.requireNonNull(leagueId, "League ID is required");
        this.branding = TeamBranding.defaultBranding(teamName);

        // Award first league achievement
        awardAchievement(AchievementType.FIRST_LEAGUE);
    }

    // ==================== Branding Methods ====================

    /**
     * Update team name
     * @param newName the new team name
     */
    public void updateTeamName(String newName) {
        this.branding = branding.withTeamName(newName);
        this.updatedAt = LocalDateTime.now();
    }

    /**
     * Update team slogan
     * @param newSlogan the new slogan
     */
    public void updateSlogan(String newSlogan) {
        this.branding = branding.withSlogan(newSlogan);
        this.updatedAt = LocalDateTime.now();
    }

    /**
     * Update team colors
     * @param primaryColor primary color hex code
     * @param secondaryColor secondary color hex code
     */
    public void updateColors(String primaryColor, String secondaryColor) {
        this.branding = branding.withColors(primaryColor, secondaryColor);
        this.updatedAt = LocalDateTime.now();
    }

    /**
     * Update team avatar
     * @param avatarUrl URL to the avatar image
     */
    public void updateAvatar(String avatarUrl) {
        this.branding = branding.withAvatar(avatarUrl);
        this.updatedAt = LocalDateTime.now();
    }

    /**
     * Update full branding
     * @param newBranding the new branding
     */
    public void updateBranding(TeamBranding newBranding) {
        this.branding = Objects.requireNonNull(newBranding, "Branding is required");
        this.updatedAt = LocalDateTime.now();
    }

    // ==================== Progression Methods ====================

    /**
     * Add experience points and handle leveling
     * @param xp experience points to add
     */
    public void gainExperience(int xp) {
        if (xp <= 0) {
            return;
        }

        this.experiencePoints += xp;

        // Check for level ups
        while (canLevelUp() && level < MAX_LEVEL) {
            levelUp();
        }

        this.lastActivityAt = LocalDateTime.now();
        this.updatedAt = LocalDateTime.now();
    }

    /**
     * Check if character can level up
     * @return true if enough XP for next level
     */
    private boolean canLevelUp() {
        return experiencePoints >= getXpForNextLevel();
    }

    /**
     * Get XP required for next level
     * @return XP needed
     */
    public int getXpForNextLevel() {
        return level * XP_PER_LEVEL;
    }

    /**
     * Get XP progress toward next level
     * @return progress percentage (0-100)
     */
    public int getLevelProgress() {
        int required = getXpForNextLevel();
        int previousLevelXp = (level - 1) * XP_PER_LEVEL;
        int currentLevelXp = experiencePoints - previousLevelXp;
        int xpNeeded = required - previousLevelXp;

        if (xpNeeded <= 0) {
            return 100;
        }
        return Math.min(100, (currentLevelXp * 100) / xpNeeded);
    }

    /**
     * Level up the character
     */
    private void levelUp() {
        this.level++;

        // Update character type based on level
        CharacterType newType = CharacterType.forLevel(level);
        if (newType != this.type) {
            this.type = newType;
        }
    }

    // ==================== Achievement Methods ====================

    /**
     * Award an achievement to the character
     * @param achievementType the type of achievement
     * @return the awarded achievement, or empty if already has one-time achievement
     */
    public Optional<Achievement> awardAchievement(AchievementType achievementType) {
        return awardAchievement(achievementType, null);
    }

    /**
     * Award an achievement with context
     * @param achievementType the type of achievement
     * @param context additional context
     * @return the awarded achievement, or empty if already has one-time achievement
     */
    public Optional<Achievement> awardAchievement(AchievementType achievementType, String context) {
        // Check if already has this achievement
        Optional<Achievement> existing = findAchievement(achievementType);

        if (existing.isPresent()) {
            if (achievementType.isOneTime()) {
                // Already have this one-time achievement
                return Optional.empty();
            }

            // Increment count for repeatable achievement
            Achievement updated = existing.get().incrementCount();
            achievements.removeIf(a -> a.getType() == achievementType);
            achievements.add(updated);
            gainExperience(achievementType.getXpReward());
            this.updatedAt = LocalDateTime.now();
            return Optional.of(updated);
        }

        // Award new achievement
        Achievement newAchievement = context != null
                ? Achievement.create(achievementType, context)
                : Achievement.create(achievementType);

        achievements.add(newAchievement);
        gainExperience(achievementType.getXpReward());
        this.updatedAt = LocalDateTime.now();

        return Optional.of(newAchievement);
    }

    /**
     * Find an achievement by type
     * @param type the achievement type
     * @return the achievement if found
     */
    public Optional<Achievement> findAchievement(AchievementType type) {
        return achievements.stream()
                .filter(a -> a.getType() == type)
                .findFirst();
    }

    /**
     * Check if character has an achievement
     * @param type the achievement type
     * @return true if has the achievement
     */
    public boolean hasAchievement(AchievementType type) {
        return findAchievement(type).isPresent();
    }

    /**
     * Get all achievements
     * @return unmodifiable list of achievements
     */
    public List<Achievement> getAchievements() {
        return Collections.unmodifiableList(achievements);
    }

    /**
     * Get total achievement count
     * @return number of achievements
     */
    public int getAchievementCount() {
        return achievements.size();
    }

    // ==================== Statistics Methods ====================

    /**
     * Record a game win
     * @param pointsScored points scored in the game
     */
    public void recordWin(double pointsScored) {
        this.stats = stats.recordWin(pointsScored);

        // Check for first win achievement
        if (stats.getWins() == 1) {
            awardAchievement(AchievementType.FIRST_WIN);
        }

        // Check for streak achievements
        if (stats.getCurrentWinStreak() == 5) {
            awardAchievement(AchievementType.STREAK_5);
        } else if (stats.getCurrentWinStreak() == 10) {
            awardAchievement(AchievementType.STREAK_10);
        }

        // Award XP for winning
        gainExperience(20);

        this.lastActivityAt = LocalDateTime.now();
        this.updatedAt = LocalDateTime.now();
    }

    /**
     * Record a game loss
     * @param pointsScored points scored in the game
     */
    public void recordLoss(double pointsScored) {
        this.stats = stats.recordLoss(pointsScored);

        // Award XP for participation
        gainExperience(5);

        this.lastActivityAt = LocalDateTime.now();
        this.updatedAt = LocalDateTime.now();
    }

    /**
     * Record a tie
     * @param pointsScored points scored in the game
     */
    public void recordTie(double pointsScored) {
        this.stats = stats.recordTie(pointsScored);

        // Award XP for participation
        gainExperience(10);

        this.lastActivityAt = LocalDateTime.now();
        this.updatedAt = LocalDateTime.now();
    }

    /**
     * Record a season championship win
     */
    public void recordSeasonChampionship() {
        this.stats = stats.recordSeasonWin();
        awardAchievement(AchievementType.SEASON_CHAMPION);

        // Check for back-to-back
        if (stats.getSeasonWins() >= 2) {
            awardAchievement(AchievementType.BACK_TO_BACK);
        }

        // Check for dynasty
        if (stats.getSeasonWins() >= 3) {
            awardAchievement(AchievementType.DYNASTY);
        }

        // Award XP for championship
        gainExperience(100);

        this.lastActivityAt = LocalDateTime.now();
        this.updatedAt = LocalDateTime.now();
    }

    /**
     * Record completing a season (without winning)
     */
    public void recordSeasonComplete() {
        this.stats = stats.recordSeasonComplete();

        // Check for first season achievement
        if (stats.getSeasonsPlayed() == 1) {
            awardAchievement(AchievementType.FIRST_SEASON);
        }

        // Check for veteran/iron man achievements
        if (stats.getSeasonsPlayed() == 10) {
            awardAchievement(AchievementType.IRON_MAN);
        }

        // Award XP for completing season
        gainExperience(50);

        this.lastActivityAt = LocalDateTime.now();
        this.updatedAt = LocalDateTime.now();
    }

    /**
     * Record activity (for idle tracking)
     */
    public void recordActivity() {
        this.lastActivityAt = LocalDateTime.now();
    }

    // ==================== Query Methods ====================

    /**
     * Get team name shorthand
     * @return team name
     */
    public String getTeamName() {
        return branding != null ? branding.getTeamName() : null;
    }

    /**
     * Check if character is at max level
     * @return true if at max level
     */
    public boolean isMaxLevel() {
        return level >= MAX_LEVEL;
    }

    /**
     * Get total XP earned (from achievements)
     * @return total XP
     */
    public int getTotalAchievementXp() {
        return achievements.stream()
                .mapToInt(Achievement::getXpReward)
                .sum();
    }

    // ==================== Getters and Setters ====================

    public UUID getId() {
        return id;
    }

    public void setId(UUID id) {
        this.id = id;
    }

    public UUID getUserId() {
        return userId;
    }

    public void setUserId(UUID userId) {
        this.userId = userId;
    }

    public UUID getLeagueId() {
        return leagueId;
    }

    public void setLeagueId(UUID leagueId) {
        this.leagueId = leagueId;
    }

    public TeamBranding getBranding() {
        return branding;
    }

    public void setBranding(TeamBranding branding) {
        this.branding = branding;
    }

    public CharacterType getType() {
        return type;
    }

    public void setType(CharacterType type) {
        this.type = type;
    }

    public Integer getLevel() {
        return level;
    }

    public void setLevel(Integer level) {
        this.level = level;
    }

    public Integer getExperiencePoints() {
        return experiencePoints;
    }

    public void setExperiencePoints(Integer experiencePoints) {
        this.experiencePoints = experiencePoints;
    }

    public void setAchievements(List<Achievement> achievements) {
        this.achievements = achievements != null ? new ArrayList<>(achievements) : new ArrayList<>();
    }

    public CharacterStats getStats() {
        return stats;
    }

    public void setStats(CharacterStats stats) {
        this.stats = stats;
    }

    public LocalDateTime getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(LocalDateTime createdAt) {
        this.createdAt = createdAt;
    }

    public LocalDateTime getUpdatedAt() {
        return updatedAt;
    }

    public void setUpdatedAt(LocalDateTime updatedAt) {
        this.updatedAt = updatedAt;
    }

    public LocalDateTime getLastActivityAt() {
        return lastActivityAt;
    }

    public void setLastActivityAt(LocalDateTime lastActivityAt) {
        this.lastActivityAt = lastActivityAt;
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;
        Character character = (Character) o;
        return Objects.equals(id, character.id);
    }

    @Override
    public int hashCode() {
        return Objects.hash(id);
    }

    @Override
    public String toString() {
        return String.format("Character{id=%s, team='%s', type=%s, level=%d, achievements=%d}",
                id, getTeamName(), type, level, achievements.size());
    }
}
