package com.ffl.playoffs.domain.model;

import java.util.HashMap;
import java.util.Map;
import java.util.Objects;

/**
 * Value object representing settings for replaying a conversation
 * Allows modification of character traits and configuration for testing
 */
public class ConversationReplaySettings {
    private final boolean useCurrentSettings;
    private final Map<String, Double> modifiedTraits;
    private final Map<String, Object> modifiedConfig;
    private final boolean generateComparison;

    public ConversationReplaySettings(boolean useCurrentSettings) {
        this.useCurrentSettings = useCurrentSettings;
        this.modifiedTraits = new HashMap<>();
        this.modifiedConfig = new HashMap<>();
        this.generateComparison = true;
    }

    public ConversationReplaySettings(Map<String, Double> modifiedTraits, Map<String, Object> modifiedConfig) {
        this.useCurrentSettings = false;
        this.modifiedTraits = modifiedTraits != null ? new HashMap<>(modifiedTraits) : new HashMap<>();
        this.modifiedConfig = modifiedConfig != null ? new HashMap<>(modifiedConfig) : new HashMap<>();
        this.generateComparison = true;
    }

    /**
     * Creates default settings that use current character configuration
     */
    public static ConversationReplaySettings withCurrentSettings() {
        return new ConversationReplaySettings(true);
    }

    /**
     * Creates settings with a specific trait modification
     * @param trait trait name
     * @param value new trait value
     * @return new settings with the trait modified
     */
    public ConversationReplaySettings withModifiedTrait(String trait, double value) {
        if (value < 0.0 || value > 1.0) {
            throw new IllegalArgumentException("Trait value must be between 0 and 1");
        }
        ConversationReplaySettings copy = new ConversationReplaySettings(this.modifiedTraits, this.modifiedConfig);
        copy.modifiedTraits.put(trait, value);
        return copy;
    }

    /**
     * Creates settings with a specific config modification
     * @param key config key
     * @param value new config value
     * @return new settings with the config modified
     */
    public ConversationReplaySettings withModifiedConfig(String key, Object value) {
        ConversationReplaySettings copy = new ConversationReplaySettings(this.modifiedTraits, this.modifiedConfig);
        copy.modifiedConfig.put(key, value);
        return copy;
    }

    /**
     * Checks if any modifications were made
     * @return true if traits or config were modified
     */
    public boolean hasModifications() {
        return !modifiedTraits.isEmpty() || !modifiedConfig.isEmpty();
    }

    public boolean isUseCurrentSettings() {
        return useCurrentSettings;
    }

    public Map<String, Double> getModifiedTraits() {
        return new HashMap<>(modifiedTraits);
    }

    public Map<String, Object> getModifiedConfig() {
        return new HashMap<>(modifiedConfig);
    }

    public boolean isGenerateComparison() {
        return generateComparison;
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;
        ConversationReplaySettings that = (ConversationReplaySettings) o;
        return useCurrentSettings == that.useCurrentSettings &&
               generateComparison == that.generateComparison &&
               Objects.equals(modifiedTraits, that.modifiedTraits) &&
               Objects.equals(modifiedConfig, that.modifiedConfig);
    }

    @Override
    public int hashCode() {
        return Objects.hash(useCurrentSettings, modifiedTraits, modifiedConfig, generateComparison);
    }
}
