package com.ffl.playoffs.domain.model;

/**
 * Types of world events that can affect simulations.
 */
public enum WorldEventType {
    // Player events
    INJURY("Player injury affecting availability/performance"),
    SUSPENSION("Player suspended for violation"),
    ILLNESS("Player dealing with illness"),
    PERSONAL_LEAVE("Player away for personal reasons"),
    BREAKOUT("Player entering peak performance"),
    SLUMP("Player in performance decline"),
    RETURN_FROM_INJURY("Player returning to action"),

    // Team events
    COACH_CHANGE("Team coaching change"),
    SCHEME_CHANGE("Offensive/defensive scheme change"),
    HOME_FIELD_BOOST("Enhanced home field advantage"),
    RIVALRY_INTENSITY("Heightened rivalry game"),
    PLAYOFF_PUSH("Team motivation boost"),
    TANKING("Team motivation decline"),

    // Game events
    WEATHER_SEVERE("Severe weather affecting game"),
    WEATHER_COLD("Extreme cold conditions"),
    WEATHER_WIND("High wind conditions"),
    WEATHER_RAIN("Rain conditions"),
    WEATHER_SNOW("Snow conditions"),
    PRIME_TIME("Prime time game modifier"),
    NEUTRAL_SITE("Neutral site game"),

    // League events
    BYE_WEEK("Team on bye week"),
    SHORT_WEEK("Team on short rest"),
    LONG_WEEK("Team on extended rest"),
    INTERNATIONAL("International game"),

    // Fantasy events
    USAGE_INCREASE("Increased player usage"),
    USAGE_DECREASE("Decreased player usage"),
    ROLE_CHANGE("Player role change"),
    DEPTH_CHART_MOVE("Depth chart position change");

    private final String description;

    WorldEventType(String description) {
        this.description = description;
    }

    public String getDescription() {
        return description;
    }

    public boolean isPlayerEvent() {
        return this == INJURY || this == SUSPENSION || this == ILLNESS ||
               this == PERSONAL_LEAVE || this == BREAKOUT || this == SLUMP ||
               this == RETURN_FROM_INJURY;
    }

    public boolean isTeamEvent() {
        return this == COACH_CHANGE || this == SCHEME_CHANGE ||
               this == HOME_FIELD_BOOST || this == RIVALRY_INTENSITY ||
               this == PLAYOFF_PUSH || this == TANKING;
    }

    public boolean isGameEvent() {
        return this == WEATHER_SEVERE || this == WEATHER_COLD ||
               this == WEATHER_WIND || this == WEATHER_RAIN ||
               this == WEATHER_SNOW || this == PRIME_TIME || this == NEUTRAL_SITE;
    }

    public boolean isWeatherEvent() {
        return this == WEATHER_SEVERE || this == WEATHER_COLD ||
               this == WEATHER_WIND || this == WEATHER_RAIN || this == WEATHER_SNOW;
    }

    public boolean isNegative() {
        return this == INJURY || this == SUSPENSION || this == ILLNESS ||
               this == PERSONAL_LEAVE || this == SLUMP || this == TANKING ||
               this == USAGE_DECREASE;
    }
}
