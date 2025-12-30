package com.ffl.playoffs.domain.model;

/**
 * Intent type enumeration
 * Defines the types of player intents that can be recognized
 */
public enum IntentType {
    /**
     * Player is asking about a location
     */
    LOCATION_QUERY,

    /**
     * Player is requesting information
     */
    INFORMATION_REQUEST,

    /**
     * Player wants to purchase something
     */
    PURCHASE_INTENT,

    /**
     * Player is greeting the character
     */
    GREETING,

    /**
     * Player is saying goodbye
     */
    FAREWELL,

    /**
     * Player needs help or assistance
     */
    HELP_REQUEST,

    /**
     * Player is negotiating
     */
    NEGOTIATION,

    /**
     * Player is expressing emotion
     */
    EMOTIONAL_EXPRESSION,

    /**
     * Player is asking a question
     */
    QUESTION,

    /**
     * Player's intent is ambiguous
     */
    AMBIGUOUS,

    /**
     * Intent could not be determined
     */
    UNKNOWN
}
