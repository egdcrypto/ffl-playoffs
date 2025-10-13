package com.ffl.playoffs.domain.model;

import java.time.LocalDateTime;

/**
 * NFL Player Entity
 * Represents an individual NFL player (not the fantasy league player)
 */
public class NFLPlayer {
    private Long id;
    private String name;
    private String firstName;
    private String lastName;
    private Position position;
    private String nflTeam;
    private String nflTeamAbbreviation;
    private Integer jerseyNumber;
    private String status; // ACTIVE, INJURED, OUT, QUESTIONABLE, DOUBTFUL, BYE

    // Current Season Stats
    private Integer gamesPlayed;
    private Double fantasyPoints;
    private Double averagePointsPerGame;

    // Position-specific stats (stored as JSON or separate tables)
    // QB stats
    private Integer passingYards;
    private Integer passingTouchdowns;
    private Integer interceptions;
    private Integer completions;
    private Integer attempts;
    private Double completionPercentage;

    // RB/WR/TE stats
    private Integer rushingYards;
    private Integer rushingTouchdowns;
    private Integer receptions;
    private Integer receivingYards;
    private Integer receivingTouchdowns;
    private Integer targets;

    // K stats
    private Integer fieldGoalsMade;
    private Integer fieldGoalsAttempted;
    private Integer extraPointsMade;
    private Integer extraPointsAttempted;

    // DEF stats (team defense - stored per team)
    private Integer sacks;
    private Integer interceptionsDef;
    private Integer fumbleRecoveries;
    private Integer safeties;
    private Integer defensiveTouchdowns;
    private Integer pointsAllowed;
    private Integer yardsAllowed;

    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;
    private String externalPlayerId; // ESPN/Yahoo/Sleeper API ID

    // Constructors
    public NFLPlayer() {
        this.createdAt = LocalDateTime.now();
        this.updatedAt = LocalDateTime.now();
    }

    public NFLPlayer(String name, Position position, String nflTeam) {
        this();
        this.name = name;
        this.position = position;
        this.nflTeam = nflTeam;
    }

    // Business Logic
    public boolean isActive() {
        return "ACTIVE".equalsIgnoreCase(status);
    }

    public boolean isInjured() {
        return "INJURED".equalsIgnoreCase(status) || "OUT".equalsIgnoreCase(status);
    }

    public boolean isOnBye() {
        return "BYE".equalsIgnoreCase(status);
    }

    public String getFullName() {
        if (firstName != null && lastName != null) {
            return firstName + " " + lastName;
        }
        return name;
    }

    public String getDisplayName() {
        return getFullName() + " (" + position.name() + ")";
    }

    // Getters and Setters
    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
        this.updatedAt = LocalDateTime.now();
    }

    public String getFirstName() {
        return firstName;
    }

    public void setFirstName(String firstName) {
        this.firstName = firstName;
        this.updatedAt = LocalDateTime.now();
    }

    public String getLastName() {
        return lastName;
    }

    public void setLastName(String lastName) {
        this.lastName = lastName;
        this.updatedAt = LocalDateTime.now();
    }

    public Position getPosition() {
        return position;
    }

    public void setPosition(Position position) {
        this.position = position;
        this.updatedAt = LocalDateTime.now();
    }

    public String getNflTeam() {
        return nflTeam;
    }

    public void setNflTeam(String nflTeam) {
        this.nflTeam = nflTeam;
        this.updatedAt = LocalDateTime.now();
    }

    public String getNflTeamAbbreviation() {
        return nflTeamAbbreviation;
    }

    public void setNflTeamAbbreviation(String nflTeamAbbreviation) {
        this.nflTeamAbbreviation = nflTeamAbbreviation;
    }

    public Integer getJerseyNumber() {
        return jerseyNumber;
    }

    public void setJerseyNumber(Integer jerseyNumber) {
        this.jerseyNumber = jerseyNumber;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
        this.updatedAt = LocalDateTime.now();
    }

    public Integer getGamesPlayed() {
        return gamesPlayed;
    }

    public void setGamesPlayed(Integer gamesPlayed) {
        this.gamesPlayed = gamesPlayed;
    }

    public Double getFantasyPoints() {
        return fantasyPoints;
    }

    public void setFantasyPoints(Double fantasyPoints) {
        this.fantasyPoints = fantasyPoints;
    }

    public Double getAveragePointsPerGame() {
        return averagePointsPerGame;
    }

    public void setAveragePointsPerGame(Double averagePointsPerGame) {
        this.averagePointsPerGame = averagePointsPerGame;
    }

    public Integer getPassingYards() {
        return passingYards;
    }

    public void setPassingYards(Integer passingYards) {
        this.passingYards = passingYards;
    }

    public Integer getPassingTouchdowns() {
        return passingTouchdowns;
    }

    public void setPassingTouchdowns(Integer passingTouchdowns) {
        this.passingTouchdowns = passingTouchdowns;
    }

    public Integer getInterceptions() {
        return interceptions;
    }

    public void setInterceptions(Integer interceptions) {
        this.interceptions = interceptions;
    }

    public Integer getCompletions() {
        return completions;
    }

    public void setCompletions(Integer completions) {
        this.completions = completions;
    }

    public Integer getAttempts() {
        return attempts;
    }

    public void setAttempts(Integer attempts) {
        this.attempts = attempts;
    }

    public Double getCompletionPercentage() {
        return completionPercentage;
    }

    public void setCompletionPercentage(Double completionPercentage) {
        this.completionPercentage = completionPercentage;
    }

    public Integer getRushingYards() {
        return rushingYards;
    }

    public void setRushingYards(Integer rushingYards) {
        this.rushingYards = rushingYards;
    }

    public Integer getRushingTouchdowns() {
        return rushingTouchdowns;
    }

    public void setRushingTouchdowns(Integer rushingTouchdowns) {
        this.rushingTouchdowns = rushingTouchdowns;
    }

    public Integer getReceptions() {
        return receptions;
    }

    public void setReceptions(Integer receptions) {
        this.receptions = receptions;
    }

    public Integer getReceivingYards() {
        return receivingYards;
    }

    public void setReceivingYards(Integer receivingYards) {
        this.receivingYards = receivingYards;
    }

    public Integer getReceivingTouchdowns() {
        return receivingTouchdowns;
    }

    public void setReceivingTouchdowns(Integer receivingTouchdowns) {
        this.receivingTouchdowns = receivingTouchdowns;
    }

    public Integer getTargets() {
        return targets;
    }

    public void setTargets(Integer targets) {
        this.targets = targets;
    }

    public Integer getFieldGoalsMade() {
        return fieldGoalsMade;
    }

    public void setFieldGoalsMade(Integer fieldGoalsMade) {
        this.fieldGoalsMade = fieldGoalsMade;
    }

    public Integer getFieldGoalsAttempted() {
        return fieldGoalsAttempted;
    }

    public void setFieldGoalsAttempted(Integer fieldGoalsAttempted) {
        this.fieldGoalsAttempted = fieldGoalsAttempted;
    }

    public Integer getExtraPointsMade() {
        return extraPointsMade;
    }

    public void setExtraPointsMade(Integer extraPointsMade) {
        this.extraPointsMade = extraPointsMade;
    }

    public Integer getExtraPointsAttempted() {
        return extraPointsAttempted;
    }

    public void setExtraPointsAttempted(Integer extraPointsAttempted) {
        this.extraPointsAttempted = extraPointsAttempted;
    }

    public Integer getSacks() {
        return sacks;
    }

    public void setSacks(Integer sacks) {
        this.sacks = sacks;
    }

    public Integer getInterceptionsDef() {
        return interceptionsDef;
    }

    public void setInterceptionsDef(Integer interceptionsDef) {
        this.interceptionsDef = interceptionsDef;
    }

    public Integer getFumbleRecoveries() {
        return fumbleRecoveries;
    }

    public void setFumbleRecoveries(Integer fumbleRecoveries) {
        this.fumbleRecoveries = fumbleRecoveries;
    }

    public Integer getSafeties() {
        return safeties;
    }

    public void setSafeties(Integer safeties) {
        this.safeties = safeties;
    }

    public Integer getDefensiveTouchdowns() {
        return defensiveTouchdowns;
    }

    public void setDefensiveTouchdowns(Integer defensiveTouchdowns) {
        this.defensiveTouchdowns = defensiveTouchdowns;
    }

    public Integer getPointsAllowed() {
        return pointsAllowed;
    }

    public void setPointsAllowed(Integer pointsAllowed) {
        this.pointsAllowed = pointsAllowed;
    }

    public Integer getYardsAllowed() {
        return yardsAllowed;
    }

    public void setYardsAllowed(Integer yardsAllowed) {
        this.yardsAllowed = yardsAllowed;
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

    public String getExternalPlayerId() {
        return externalPlayerId;
    }

    public void setExternalPlayerId(String externalPlayerId) {
        this.externalPlayerId = externalPlayerId;
    }
}
