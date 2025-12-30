package com.ffl.playoffs.domain.worldbuilding;

/**
 * WorldConfigurationPresets
 * Factory class providing pre-configured WorldConfiguration instances
 * for common narrative scenarios.
 * Part of the Chronos Engine integration.
 */
public final class WorldConfigurationPresets {

    private WorldConfigurationPresets() {
        // Utility class - prevent instantiation
    }

    /**
     * Romeo & Juliet / Shakespearean Tragedy preset
     * High tragedy, high romance, low hope, Renaissance setting
     */
    public static WorldConfiguration shakespeareanTragedy() {
        return WorldConfiguration.builder()
            .name("Shakespearean Tragedy")
            .description("Star-crossed lovers, feuding families, inevitable doom")
            .dimensions(DimensionalConfiguration.builder()
                .tragedyLevel(0.9)
                .chaosFactor(0.3)
                .romanceIntensity(0.9)
                .hopeIndex(0.2)
                .verisimilitude(0.6)
                .violenceGraphicness(0.5)
                .build())
            .eraVector(EraVector.builder()
                .baseEra(Era.RENAISSANCE)
                .technologyLevel(0.2)
                .magicalPresence(0.1)
                .culturalComplexity(0.6)
                .build())
            .build();
    }

    /**
     * Classic Fairy Tale preset
     * High hope, moderate romance, magical medieval setting
     */
    public static WorldConfiguration fairyTale() {
        return WorldConfiguration.builder()
            .name("Fairy Tale")
            .description("Once upon a time, in a kingdom far away...")
            .dimensions(DimensionalConfiguration.builder()
                .tragedyLevel(0.2)
                .chaosFactor(0.3)
                .romanceIntensity(0.7)
                .hopeIndex(0.9)
                .verisimilitude(0.2)
                .violenceGraphicness(0.2)
                .build())
            .eraVector(EraVector.builder()
                .baseEra(Era.MEDIEVAL)
                .technologyLevel(0.2)
                .magicalPresence(0.8)
                .culturalComplexity(0.4)
                .build())
            .build();
    }

    /**
     * Grimdark Fantasy preset
     * High tragedy, high chaos, low hope, violent medieval setting
     */
    public static WorldConfiguration grimdarkFantasy() {
        return WorldConfiguration.builder()
            .name("Grimdark Fantasy")
            .description("Dark, morally grey world where heroes fall and evil triumphs")
            .dimensions(DimensionalConfiguration.builder()
                .tragedyLevel(0.9)
                .chaosFactor(0.7)
                .romanceIntensity(0.3)
                .hopeIndex(0.1)
                .verisimilitude(0.5)
                .violenceGraphicness(0.9)
                .build())
            .eraVector(EraVector.builder()
                .baseEra(Era.MEDIEVAL)
                .technologyLevel(0.3)
                .magicalPresence(0.6)
                .culturalComplexity(0.5)
                .build())
            .build();
    }

    /**
     * High Fantasy / Epic Quest preset
     * Balanced drama, high magic, hopeful outcome
     */
    public static WorldConfiguration highFantasy() {
        return WorldConfiguration.builder()
            .name("High Fantasy")
            .description("Epic quests, powerful magic, good triumphs over evil")
            .dimensions(DimensionalConfiguration.builder()
                .tragedyLevel(0.2)
                .chaosFactor(0.4)
                .romanceIntensity(0.5)
                .hopeIndex(0.8)
                .verisimilitude(0.3)
                .violenceGraphicness(0.4)
                .build())
            .eraVector(EraVector.builder()
                .baseEra(Era.MEDIEVAL)
                .technologyLevel(0.2)
                .magicalPresence(0.9)
                .culturalComplexity(0.6)
                .build())
            .build();
    }

    /**
     * Historical Drama preset
     * Realistic, low magic, high cultural complexity
     */
    public static WorldConfiguration historicalDrama() {
        return WorldConfiguration.builder()
            .name("Historical Drama")
            .description("Authentic historical setting with complex political intrigue")
            .dimensions(DimensionalConfiguration.builder()
                .tragedyLevel(0.5)
                .chaosFactor(0.4)
                .romanceIntensity(0.6)
                .hopeIndex(0.5)
                .verisimilitude(0.9)
                .violenceGraphicness(0.4)
                .build())
            .eraVector(EraVector.builder()
                .baseEra(Era.RENAISSANCE)
                .technologyLevel(0.3)
                .magicalPresence(0.0)
                .culturalComplexity(0.8)
                .build())
            .build();
    }

    /**
     * Space Opera / Science Fiction preset
     * High action, futuristic technology, no magic
     */
    public static WorldConfiguration spaceOpera() {
        return WorldConfiguration.builder()
            .name("Space Opera")
            .description("Grand adventures across the stars with advanced technology")
            .dimensions(DimensionalConfiguration.builder()
                .tragedyLevel(0.4)
                .chaosFactor(0.5)
                .romanceIntensity(0.5)
                .hopeIndex(0.7)
                .verisimilitude(0.4)
                .violenceGraphicness(0.6)
                .build())
            .eraVector(EraVector.builder()
                .baseEra(Era.FUTURISTIC)
                .technologyLevel(0.9)
                .magicalPresence(0.0)
                .culturalComplexity(0.8)
                .build())
            .build();
    }

    /**
     * Gothic Horror preset
     * High tragedy, high chaos, dark atmosphere
     */
    public static WorldConfiguration gothicHorror() {
        return WorldConfiguration.builder()
            .name("Gothic Horror")
            .description("Dark castles, supernatural dread, and doomed protagonists")
            .dimensions(DimensionalConfiguration.builder()
                .tragedyLevel(0.8)
                .chaosFactor(0.6)
                .romanceIntensity(0.5)
                .hopeIndex(0.2)
                .verisimilitude(0.5)
                .violenceGraphicness(0.7)
                .build())
            .eraVector(EraVector.builder()
                .baseEra(Era.INDUSTRIAL)
                .technologyLevel(0.4)
                .magicalPresence(0.5)
                .culturalComplexity(0.6)
                .build())
            .build();
    }

    /**
     * Arthurian Legend preset
     * Chivalric romance, moderate magic, medieval setting
     */
    public static WorldConfiguration arthurianLegend() {
        return WorldConfiguration.builder()
            .name("Arthurian Legend")
            .description("Knights, honor, Camelot, and the quest for the Holy Grail")
            .dimensions(DimensionalConfiguration.builder()
                .tragedyLevel(0.6)
                .chaosFactor(0.3)
                .romanceIntensity(0.7)
                .hopeIndex(0.6)
                .verisimilitude(0.4)
                .violenceGraphicness(0.5)
                .build())
            .eraVector(EraVector.builder()
                .baseEra(Era.MEDIEVAL)
                .technologyLevel(0.2)
                .magicalPresence(0.5)
                .culturalComplexity(0.5)
                .build())
            .build();
    }

    /**
     * Greek Mythology preset
     * Epic heroes, divine intervention, ancient setting
     */
    public static WorldConfiguration greekMythology() {
        return WorldConfiguration.builder()
            .name("Greek Mythology")
            .description("Heroes, gods, monsters, and epic quests in ancient Greece")
            .dimensions(DimensionalConfiguration.builder()
                .tragedyLevel(0.7)
                .chaosFactor(0.5)
                .romanceIntensity(0.6)
                .hopeIndex(0.5)
                .verisimilitude(0.3)
                .violenceGraphicness(0.6)
                .build())
            .eraVector(EraVector.builder()
                .baseEra(Era.ANCIENT)
                .technologyLevel(0.2)
                .magicalPresence(0.8)
                .culturalComplexity(0.6)
                .build())
            .build();
    }

    /**
     * Dystopian Future preset
     * Oppressive society, high technology, low hope
     */
    public static WorldConfiguration dystopianFuture() {
        return WorldConfiguration.builder()
            .name("Dystopian Future")
            .description("Totalitarian regimes, surveillance states, and rebellion")
            .dimensions(DimensionalConfiguration.builder()
                .tragedyLevel(0.7)
                .chaosFactor(0.4)
                .romanceIntensity(0.4)
                .hopeIndex(0.3)
                .verisimilitude(0.6)
                .violenceGraphicness(0.6)
                .build())
            .eraVector(EraVector.builder()
                .baseEra(Era.FUTURISTIC)
                .technologyLevel(0.8)
                .magicalPresence(0.0)
                .culturalComplexity(0.7)
                .build())
            .build();
    }
}
