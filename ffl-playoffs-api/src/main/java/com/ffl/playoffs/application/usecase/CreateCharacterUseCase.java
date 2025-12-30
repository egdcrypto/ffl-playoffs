package com.ffl.playoffs.application.usecase;

import com.ffl.playoffs.domain.model.character.Character;
import com.ffl.playoffs.domain.port.CharacterRepository;

import java.util.UUID;

/**
 * Use case for creating a new character in DRAFT status
 * Characters are created when a user joins a league
 */
public class CreateCharacterUseCase {

    private final CharacterRepository characterRepository;

    public CreateCharacterUseCase(CharacterRepository characterRepository) {
        this.characterRepository = characterRepository;
    }

    /**
     * Create a new character for a user in a league
     * @param command the creation command
     * @return the created character
     * @throws IllegalArgumentException if user already has character in league
     */
    public Character execute(CreateCharacterCommand command) {
        // Check if user already has a character in this league
        if (characterRepository.existsByUserIdAndLeagueId(command.getUserId(), command.getLeagueId())) {
            throw new IllegalArgumentException(
                    "User already has a character in this league");
        }

        // Check if character name is already taken in this league
        if (command.getName() != null &&
            characterRepository.existsByLeagueIdAndName(command.getLeagueId(), command.getName())) {
            throw new IllegalArgumentException(
                    "Character name is already taken in this league: " + command.getName());
        }

        // Create the character in DRAFT status
        Character character = Character.create(
                command.getUserId(),
                command.getLeagueId(),
                command.getName()
        );

        // Set optional avatar
        if (command.getAvatarUrl() != null) {
            character.updateAvatar(command.getAvatarUrl());
        }

        // Save and return
        return characterRepository.save(character);
    }

    /**
     * Command for creating a character
     */
    public static class CreateCharacterCommand {
        private final UUID userId;
        private final UUID leagueId;
        private final String name;
        private final String avatarUrl;

        public CreateCharacterCommand(UUID userId, UUID leagueId, String name) {
            this(userId, leagueId, name, null);
        }

        public CreateCharacterCommand(UUID userId, UUID leagueId, String name, String avatarUrl) {
            this.userId = userId;
            this.leagueId = leagueId;
            this.name = name;
            this.avatarUrl = avatarUrl;
        }

        public UUID getUserId() {
            return userId;
        }

        public UUID getLeagueId() {
            return leagueId;
        }

        public String getName() {
            return name;
        }

        public String getAvatarUrl() {
            return avatarUrl;
        }
    }
}
