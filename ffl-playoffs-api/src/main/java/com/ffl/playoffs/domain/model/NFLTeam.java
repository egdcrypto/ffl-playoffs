package com.ffl.playoffs.domain.model;

import java.time.LocalDateTime;

/**
 * NFL Team Entity
 * Represents an NFL team with conference and division information
 * Domain model with no framework dependencies
 */
public class NFLTeam {
    private String id;  // Team abbreviation used as ID (e.g., "KC", "SF", "BUF")
    private String name;  // Full team name (e.g., "Kansas City Chiefs")
    private String abbreviation;  // Short code (e.g., "KC")
    private String conference;  // AFC or NFC
    private String division;  // NORTH, SOUTH, EAST, WEST
    private String city;  // Team city (e.g., "Kansas City")
    private String nickname;  // Team nickname (e.g., "Chiefs")
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;

    // Constructors
    public NFLTeam() {
        this.createdAt = LocalDateTime.now();
        this.updatedAt = LocalDateTime.now();
    }

    public NFLTeam(String abbreviation, String name, String conference, String division) {
        this();
        this.id = abbreviation;
        this.abbreviation = abbreviation;
        this.name = name;
        this.conference = conference;
        this.division = division;
    }

    public NFLTeam(String abbreviation, String city, String nickname, String conference, String division) {
        this();
        this.id = abbreviation;
        this.abbreviation = abbreviation;
        this.city = city;
        this.nickname = nickname;
        this.name = city + " " + nickname;
        this.conference = conference;
        this.division = division;
    }

    // Business Logic
    public boolean isAFC() {
        return "AFC".equalsIgnoreCase(conference);
    }

    public boolean isNFC() {
        return "NFC".equalsIgnoreCase(conference);
    }

    public String getFullName() {
        return name;
    }

    public String getDivisionName() {
        return conference + " " + division;
    }

    // Getters and Setters
    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
        this.updatedAt = LocalDateTime.now();
    }

    public String getAbbreviation() {
        return abbreviation;
    }

    public void setAbbreviation(String abbreviation) {
        this.abbreviation = abbreviation;
        if (this.id == null) {
            this.id = abbreviation;
        }
        this.updatedAt = LocalDateTime.now();
    }

    public String getConference() {
        return conference;
    }

    public void setConference(String conference) {
        this.conference = conference;
        this.updatedAt = LocalDateTime.now();
    }

    public String getDivision() {
        return division;
    }

    public void setDivision(String division) {
        this.division = division;
        this.updatedAt = LocalDateTime.now();
    }

    public String getCity() {
        return city;
    }

    public void setCity(String city) {
        this.city = city;
        this.updatedAt = LocalDateTime.now();
    }

    public String getNickname() {
        return nickname;
    }

    public void setNickname(String nickname) {
        this.nickname = nickname;
        this.updatedAt = LocalDateTime.now();
    }

    public LocalDateTime getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(LocalDateTime createdAt) {
        this.createdAt = createdAt;
    }

    public LocalDateTime getUpdatedAt() {
        return updatedAt;
    }

    public void setUpdatedAt(LocalDateTime updatedAt) {
        this.updatedAt = updatedAt;
    }
}
