package com.ffl.playoffs.application.usecase;

import com.ffl.playoffs.domain.aggregate.Character;
import com.ffl.playoffs.domain.port.CharacterRepository;

import java.util.UUID;

/**
 * Use case for creating a new character
 * Application layer orchestrates domain logic
 */
public class CreateCharacterUseCase {

    private final CharacterRepository characterRepository;

    public CreateCharacterUseCase(CharacterRepository characterRepository) {
        this.characterRepository = characterRepository;
    }

    /**
     * Creates a new character for a user in a league
     *
     * @param command The create character command
     * @return The newly created Character
     * @throws IllegalArgumentException if character already exists or team name is taken
     */
    public Character execute(CreateCharacterCommand command) {
        // Check if character already exists
        if (characterRepository.existsByUserIdAndLeagueId(command.getUserId(), command.getLeagueId())) {
            throw new IllegalArgumentException(
                    String.format("Character already exists for user %s in league %s",
                            command.getUserId(), command.getLeagueId()));
        }

        // Check if team name is taken in this league
        if (characterRepository.existsByLeagueIdAndTeamName(command.getLeagueId(), command.getTeamName())) {
            throw new IllegalArgumentException(
                    String.format("Team name '%s' is already taken in this league", command.getTeamName()));
        }

        // Create character
        Character character = new Character(command.getUserId(), command.getLeagueId(), command.getTeamName());

        // Set optional fields
        if (command.getTeamSlogan() != null) {
            character.updateSlogan(command.getTeamSlogan());
        }

        if (command.getPrimaryColor() != null && command.getSecondaryColor() != null) {
            character.updateColors(command.getPrimaryColor(), command.getSecondaryColor());
        }

        if (command.getAvatarUrl() != null) {
            character.updateAvatar(command.getAvatarUrl());
        }

        // Persist and return
        return characterRepository.save(character);
    }

    /**
     * Command object for creating a character
     */
    public static class CreateCharacterCommand {
        private final UUID userId;
        private final UUID leagueId;
        private final String teamName;
        private String teamSlogan;
        private String primaryColor;
        private String secondaryColor;
        private String avatarUrl;

        public CreateCharacterCommand(UUID userId, UUID leagueId, String teamName) {
            this.userId = userId;
            this.leagueId = leagueId;
            this.teamName = teamName;
        }

        // Getters
        public UUID getUserId() { return userId; }
        public UUID getLeagueId() { return leagueId; }
        public String getTeamName() { return teamName; }
        public String getTeamSlogan() { return teamSlogan; }
        public String getPrimaryColor() { return primaryColor; }
        public String getSecondaryColor() { return secondaryColor; }
        public String getAvatarUrl() { return avatarUrl; }

        // Setters for optional fields
        public void setTeamSlogan(String teamSlogan) { this.teamSlogan = teamSlogan; }
        public void setPrimaryColor(String primaryColor) { this.primaryColor = primaryColor; }
        public void setSecondaryColor(String secondaryColor) { this.secondaryColor = secondaryColor; }
        public void setAvatarUrl(String avatarUrl) { this.avatarUrl = avatarUrl; }
    }
}
