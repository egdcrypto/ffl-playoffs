package com.ffl.playoffs.infrastructure.persistence.mongodb.mapper;

import com.ffl.playoffs.domain.aggregate.Character;
import com.ffl.playoffs.domain.model.character.*;
import com.ffl.playoffs.infrastructure.persistence.mongodb.document.CharacterDocument;
import com.ffl.playoffs.infrastructure.persistence.mongodb.document.CharacterDocument.AchievementSubDocument;
import com.ffl.playoffs.infrastructure.persistence.mongodb.document.CharacterDocument.StatsSubDocument;
import org.springframework.stereotype.Component;

import java.util.ArrayList;
import java.util.List;
import java.util.UUID;
import java.util.stream.Collectors;

/**
 * Mapper between Character domain aggregate and CharacterDocument
 */
@Component
public class CharacterMapper {

    /**
     * Convert domain Character to MongoDB document
     * @param character the domain character
     * @return the MongoDB document
     */
    public CharacterDocument toDocument(Character character) {
        if (character == null) {
            return null;
        }

        CharacterDocument.CharacterDocumentBuilder builder = CharacterDocument.builder()
                .id(character.getId() != null ? character.getId().toString() : null)
                .userId(character.getUserId() != null ? character.getUserId().toString() : null)
                .leagueId(character.getLeagueId() != null ? character.getLeagueId().toString() : null)
                .type(character.getType() != null ? character.getType().name() : null)
                .level(character.getLevel())
                .experiencePoints(character.getExperiencePoints())
                .createdAt(character.getCreatedAt())
                .updatedAt(character.getUpdatedAt())
                .lastActivityAt(character.getLastActivityAt());

        // Map branding
        TeamBranding branding = character.getBranding();
        if (branding != null) {
            builder.teamName(branding.getTeamName())
                    .teamSlogan(branding.getTeamSlogan())
                    .avatarUrl(branding.getAvatarUrl())
                    .primaryColor(branding.getPrimaryColor())
                    .secondaryColor(branding.getSecondaryColor());
        }

        // Map achievements
        if (character.getAchievements() != null) {
            List<AchievementSubDocument> achievementDocs = character.getAchievements().stream()
                    .map(this::toAchievementSubDocument)
                    .collect(Collectors.toList());
            builder.achievements(achievementDocs);
        }

        // Map stats
        CharacterStats stats = character.getStats();
        if (stats != null) {
            builder.stats(toStatsSubDocument(stats));
        }

        return builder.build();
    }

    /**
     * Convert MongoDB document to domain Character
     * @param document the MongoDB document
     * @return the domain character
     */
    public Character toDomain(CharacterDocument document) {
        if (document == null) {
            return null;
        }

        Character character = new Character();

        // Set basic fields
        character.setId(document.getId() != null ? UUID.fromString(document.getId()) : null);
        character.setUserId(document.getUserId() != null ? UUID.fromString(document.getUserId()) : null);
        character.setLeagueId(document.getLeagueId() != null ? UUID.fromString(document.getLeagueId()) : null);
        character.setType(document.getType() != null ? CharacterType.valueOf(document.getType()) : CharacterType.ROOKIE);
        character.setLevel(document.getLevel() != null ? document.getLevel() : 1);
        character.setExperiencePoints(document.getExperiencePoints() != null ? document.getExperiencePoints() : 0);
        character.setCreatedAt(document.getCreatedAt());
        character.setUpdatedAt(document.getUpdatedAt());
        character.setLastActivityAt(document.getLastActivityAt());

        // Map branding
        if (document.getTeamName() != null) {
            TeamBranding branding = TeamBranding.builder()
                    .teamName(document.getTeamName())
                    .teamSlogan(document.getTeamSlogan())
                    .avatarUrl(document.getAvatarUrl())
                    .primaryColor(document.getPrimaryColor())
                    .secondaryColor(document.getSecondaryColor())
                    .build();
            character.setBranding(branding);
        }

        // Map achievements
        if (document.getAchievements() != null) {
            List<Achievement> achievements = document.getAchievements().stream()
                    .map(this::toAchievement)
                    .collect(Collectors.toList());
            character.setAchievements(achievements);
        } else {
            character.setAchievements(new ArrayList<>());
        }

        // Map stats
        if (document.getStats() != null) {
            character.setStats(toStats(document.getStats()));
        } else {
            character.setStats(CharacterStats.empty());
        }

        return character;
    }

    private AchievementSubDocument toAchievementSubDocument(Achievement achievement) {
        return AchievementSubDocument.builder()
                .id(achievement.getId().toString())
                .type(achievement.getType().name())
                .unlockedAt(achievement.getUnlockedAt())
                .context(achievement.getContext())
                .count(achievement.getCount())
                .build();
    }

    private Achievement toAchievement(AchievementSubDocument doc) {
        return Achievement.reconstitute(
                UUID.fromString(doc.getId()),
                AchievementType.valueOf(doc.getType()),
                doc.getUnlockedAt(),
                doc.getContext(),
                doc.getCount()
        );
    }

    private StatsSubDocument toStatsSubDocument(CharacterStats stats) {
        return StatsSubDocument.builder()
                .gamesPlayed(stats.getGamesPlayed())
                .wins(stats.getWins())
                .losses(stats.getLosses())
                .ties(stats.getTies())
                .seasonsPlayed(stats.getSeasonsPlayed())
                .seasonWins(stats.getSeasonWins())
                .currentWinStreak(stats.getCurrentWinStreak())
                .bestWinStreak(stats.getBestWinStreak())
                .totalPointsScored(stats.getTotalPointsScored())
                .highestWeeklyScore(stats.getHighestWeeklyScore())
                .build();
    }

    private CharacterStats toStats(StatsSubDocument doc) {
        return CharacterStats.builder()
                .gamesPlayed(doc.getGamesPlayed())
                .wins(doc.getWins())
                .losses(doc.getLosses())
                .ties(doc.getTies())
                .seasonsPlayed(doc.getSeasonsPlayed())
                .seasonWins(doc.getSeasonWins())
                .currentWinStreak(doc.getCurrentWinStreak())
                .bestWinStreak(doc.getBestWinStreak())
                .totalPointsScored(doc.getTotalPointsScored())
                .highestWeeklyScore(doc.getHighestWeeklyScore())
                .build();
    }
}
