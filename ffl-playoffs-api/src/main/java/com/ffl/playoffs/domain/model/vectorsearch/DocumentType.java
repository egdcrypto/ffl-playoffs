package com.ffl.playoffs.domain.model.vectorsearch;

/**
 * Enum representing types of documents that can be indexed for vector search.
 */
public enum DocumentType {

    NFL_PLAYER("nfl_player", "NFL Player profiles and statistics"),
    LEAGUE("league", "Fantasy league information"),
    GAME("game", "Game and match data"),
    NEWS("news", "Player news and updates"),
    RULE("rule", "League rules and scoring rules");

    private final String code;
    private final String description;

    DocumentType(String code, String description) {
        this.code = code;
        this.description = description;
    }

    public String getCode() {
        return code;
    }

    public String getDescription() {
        return description;
    }

    /**
     * Get DocumentType from code string
     */
    public static DocumentType fromCode(String code) {
        for (DocumentType type : values()) {
            if (type.code.equalsIgnoreCase(code)) {
                return type;
            }
        }
        throw new IllegalArgumentException("Unknown document type code: " + code);
    }
}
