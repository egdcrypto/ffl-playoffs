package com.ffl.playoffs.infrastructure.adapter.persistence.document;

/**
 * MongoDB embedded document for RosterSlot
 * Infrastructure layer persistence model
 */
public class RosterSlotDocument {

    private String position;  // QB, RB, WR, TE, K, DEF, FLEX
    private Integer count;
    private Boolean isFlex;

    public RosterSlotDocument() {
    }

    // Getters and Setters

    public String getPosition() {
        return position;
    }

    public void setPosition(String position) {
        this.position = position;
    }

    public Integer getCount() {
        return count;
    }

    public void setCount(Integer count) {
        this.count = count;
    }

    public Boolean getIsFlex() {
        return isFlex;
    }

    public void setIsFlex(Boolean flex) {
        isFlex = flex;
    }
}
