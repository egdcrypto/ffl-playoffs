package com.ffl.playoffs.application.usecase;

import com.ffl.playoffs.domain.aggregate.Character;
import com.ffl.playoffs.domain.model.character.TeamBranding;
import com.ffl.playoffs.domain.port.CharacterRepository;

import java.util.UUID;

/**
 * Use case for updating character branding
 * Application layer orchestrates domain logic
 */
public class UpdateCharacterBrandingUseCase {

    private final CharacterRepository characterRepository;

    public UpdateCharacterBrandingUseCase(CharacterRepository characterRepository) {
        this.characterRepository = characterRepository;
    }

    /**
     * Updates character branding
     *
     * @param command The update branding command
     * @return The updated Character
     * @throws IllegalArgumentException if character not found or team name is taken
     */
    public Character execute(UpdateBrandingCommand command) {
        Character character = characterRepository.findById(command.getCharacterId())
                .orElseThrow(() -> new IllegalArgumentException("Character not found: " + command.getCharacterId()));

        // Check if new team name is taken (if changing name)
        if (command.getTeamName() != null &&
                !command.getTeamName().equals(character.getTeamName()) &&
                characterRepository.existsByLeagueIdAndTeamName(character.getLeagueId(), command.getTeamName())) {
            throw new IllegalArgumentException(
                    String.format("Team name '%s' is already taken in this league", command.getTeamName()));
        }

        // Build new branding
        TeamBranding.Builder brandingBuilder = TeamBranding.builder()
                .teamName(command.getTeamName() != null ? command.getTeamName() : character.getTeamName());

        if (command.getTeamSlogan() != null) {
            brandingBuilder.teamSlogan(command.getTeamSlogan());
        } else if (character.getBranding() != null) {
            brandingBuilder.teamSlogan(character.getBranding().getTeamSlogan());
        }

        if (command.getAvatarUrl() != null) {
            brandingBuilder.avatarUrl(command.getAvatarUrl());
        } else if (character.getBranding() != null) {
            brandingBuilder.avatarUrl(character.getBranding().getAvatarUrl());
        }

        if (command.getPrimaryColor() != null) {
            brandingBuilder.primaryColor(command.getPrimaryColor());
        } else if (character.getBranding() != null) {
            brandingBuilder.primaryColor(character.getBranding().getPrimaryColor());
        }

        if (command.getSecondaryColor() != null) {
            brandingBuilder.secondaryColor(command.getSecondaryColor());
        } else if (character.getBranding() != null) {
            brandingBuilder.secondaryColor(character.getBranding().getSecondaryColor());
        }

        character.updateBranding(brandingBuilder.build());

        return characterRepository.save(character);
    }

    /**
     * Command object for updating branding
     */
    public static class UpdateBrandingCommand {
        private final UUID characterId;
        private String teamName;
        private String teamSlogan;
        private String avatarUrl;
        private String primaryColor;
        private String secondaryColor;

        public UpdateBrandingCommand(UUID characterId) {
            this.characterId = characterId;
        }

        // Getters
        public UUID getCharacterId() { return characterId; }
        public String getTeamName() { return teamName; }
        public String getTeamSlogan() { return teamSlogan; }
        public String getAvatarUrl() { return avatarUrl; }
        public String getPrimaryColor() { return primaryColor; }
        public String getSecondaryColor() { return secondaryColor; }

        // Setters
        public void setTeamName(String teamName) { this.teamName = teamName; }
        public void setTeamSlogan(String teamSlogan) { this.teamSlogan = teamSlogan; }
        public void setAvatarUrl(String avatarUrl) { this.avatarUrl = avatarUrl; }
        public void setPrimaryColor(String primaryColor) { this.primaryColor = primaryColor; }
        public void setSecondaryColor(String secondaryColor) { this.secondaryColor = secondaryColor; }
    }
}
