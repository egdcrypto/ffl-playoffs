package com.ffl.playoffs.application.usecase;

import com.ffl.playoffs.domain.aggregate.Character;
import com.ffl.playoffs.domain.model.character.Achievement;
import com.ffl.playoffs.domain.model.character.AchievementType;
import com.ffl.playoffs.domain.port.CharacterRepository;

import java.util.Optional;
import java.util.UUID;

/**
 * Use case for awarding achievements to characters
 * Application layer orchestrates domain logic
 */
public class AwardAchievementUseCase {

    private final CharacterRepository characterRepository;

    public AwardAchievementUseCase(CharacterRepository characterRepository) {
        this.characterRepository = characterRepository;
    }

    /**
     * Awards an achievement to a character
     *
     * @param command The award achievement command
     * @return The awarded achievement, or empty if already has one-time achievement
     * @throws IllegalArgumentException if character not found
     */
    public Optional<Achievement> execute(AwardAchievementCommand command) {
        Character character = characterRepository.findById(command.getCharacterId())
                .orElseThrow(() -> new IllegalArgumentException("Character not found: " + command.getCharacterId()));

        Optional<Achievement> awarded = character.awardAchievement(command.getAchievementType(), command.getContext());

        if (awarded.isPresent()) {
            characterRepository.save(character);
        }

        return awarded;
    }

    /**
     * Command object for awarding an achievement
     */
    public static class AwardAchievementCommand {
        private final UUID characterId;
        private final AchievementType achievementType;
        private String context;

        public AwardAchievementCommand(UUID characterId, AchievementType achievementType) {
            this.characterId = characterId;
            this.achievementType = achievementType;
        }

        // Getters
        public UUID getCharacterId() { return characterId; }
        public AchievementType getAchievementType() { return achievementType; }
        public String getContext() { return context; }

        // Setters
        public void setContext(String context) { this.context = context; }
    }
}
