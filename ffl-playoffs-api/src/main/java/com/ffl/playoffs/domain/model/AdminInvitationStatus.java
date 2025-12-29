package com.ffl.playoffs.domain.model;

/**
 * Status enum for admin invitation lifecycle
 */
public enum AdminInvitationStatus {
    /**
     * Invitation sent, awaiting response
     */
    PENDING,

    /**
     * User accepted and account created/upgraded
     */
    ACCEPTED,

    /**
     * Past expiration date
     */
    EXPIRED,

    /**
     * Email mismatch or other rejection
     */
    REJECTED,

    /**
     * Invitation cancelled by super admin
     */
    CANCELLED
}
