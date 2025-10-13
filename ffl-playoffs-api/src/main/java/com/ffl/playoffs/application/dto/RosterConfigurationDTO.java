package com.ffl.playoffs.application.dto;

/**
 * Data Transfer Object for Roster Configuration
 * Defines position requirements for a league's rosters
 */
public class RosterConfigurationDTO {
    private Integer qbCount;
    private Integer rbCount;
    private Integer wrCount;
    private Integer teCount;
    private Integer flexCount;
    private Integer kCount;
    private Integer defenseCount;
    private Integer benchCount;

    // Constructors
    public RosterConfigurationDTO() {
    }

    // Getters and Setters
    public Integer getQbCount() {
        return qbCount;
    }

    public void setQbCount(Integer qbCount) {
        this.qbCount = qbCount;
    }

    public Integer getRbCount() {
        return rbCount;
    }

    public void setRbCount(Integer rbCount) {
        this.rbCount = rbCount;
    }

    public Integer getWrCount() {
        return wrCount;
    }

    public void setWrCount(Integer wrCount) {
        this.wrCount = wrCount;
    }

    public Integer getTeCount() {
        return teCount;
    }

    public void setTeCount(Integer teCount) {
        this.teCount = teCount;
    }

    public Integer getFlexCount() {
        return flexCount;
    }

    public void setFlexCount(Integer flexCount) {
        this.flexCount = flexCount;
    }

    public Integer getKCount() {
        return kCount;
    }

    public void setKCount(Integer kCount) {
        this.kCount = kCount;
    }

    public Integer getDefenseCount() {
        return defenseCount;
    }

    public void setDefenseCount(Integer defenseCount) {
        this.defenseCount = defenseCount;
    }

    public Integer getBenchCount() {
        return benchCount;
    }

    public void setBenchCount(Integer benchCount) {
        this.benchCount = benchCount;
    }
}
