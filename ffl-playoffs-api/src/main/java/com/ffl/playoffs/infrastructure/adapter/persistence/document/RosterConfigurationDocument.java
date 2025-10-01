package com.ffl.playoffs.infrastructure.adapter.persistence.document;

import java.util.List;

/**
 * MongoDB embedded document for RosterConfiguration
 * Infrastructure layer persistence model
 */
public class RosterConfigurationDocument {

    private List<RosterSlotDocument> slots;
    private Integer totalSlots;
    private Integer flexSlots;

    public RosterConfigurationDocument() {
    }

    // Getters and Setters

    public List<RosterSlotDocument> getSlots() {
        return slots;
    }

    public void setSlots(List<RosterSlotDocument> slots) {
        this.slots = slots;
    }

    public Integer getTotalSlots() {
        return totalSlots;
    }

    public void setTotalSlots(Integer totalSlots) {
        this.totalSlots = totalSlots;
    }

    public Integer getFlexSlots() {
        return flexSlots;
    }

    public void setFlexSlots(Integer flexSlots) {
        this.flexSlots = flexSlots;
    }
}
