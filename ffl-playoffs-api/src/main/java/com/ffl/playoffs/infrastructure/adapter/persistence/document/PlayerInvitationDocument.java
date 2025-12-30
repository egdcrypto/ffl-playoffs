package com.ffl.playoffs.infrastructure.adapter.persistence.document;

import org.springframework.data.annotation.Id;
import org.springframework.data.mongodb.core.index.CompoundIndex;
import org.springframework.data.mongodb.core.index.Indexed;
import org.springframework.data.mongodb.core.mapping.Document;

import java.time.LocalDateTime;

/**
 * MongoDB document for PlayerInvitation entity.
 * Infrastructure layer persistence model.
 */
@Document(collection = "playerInvitations")
@CompoundIndex(name = "email_league_idx", def = "{'email': 1, 'leagueId': 1}")
public class PlayerInvitationDocument {

    @Id
    private String id;

    @Indexed
    private String leagueId;

    private String leagueName;

    @Indexed
    private String email;

    @Indexed(unique = true)
    private String invitationToken;

    private String status;  // PENDING, ACCEPTED, DECLINED, EXPIRED, CANCELLED

    private String invitedByUserId;

    private LocalDateTime createdAt;

    @Indexed
    private LocalDateTime expiresAt;

    private LocalDateTime acceptedAt;

    private String acceptedByUserId;

    public PlayerInvitationDocument() {
    }

    // Getters and Setters

    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public String getLeagueId() {
        return leagueId;
    }

    public void setLeagueId(String leagueId) {
        this.leagueId = leagueId;
    }

    public String getLeagueName() {
        return leagueName;
    }

    public void setLeagueName(String leagueName) {
        this.leagueName = leagueName;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getInvitationToken() {
        return invitationToken;
    }

    public void setInvitationToken(String invitationToken) {
        this.invitationToken = invitationToken;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public String getInvitedByUserId() {
        return invitedByUserId;
    }

    public void setInvitedByUserId(String invitedByUserId) {
        this.invitedByUserId = invitedByUserId;
    }

    public LocalDateTime getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(LocalDateTime createdAt) {
        this.createdAt = createdAt;
    }

    public LocalDateTime getExpiresAt() {
        return expiresAt;
    }

    public void setExpiresAt(LocalDateTime expiresAt) {
        this.expiresAt = expiresAt;
    }

    public LocalDateTime getAcceptedAt() {
        return acceptedAt;
    }

    public void setAcceptedAt(LocalDateTime acceptedAt) {
        this.acceptedAt = acceptedAt;
    }

    public String getAcceptedByUserId() {
        return acceptedByUserId;
    }

    public void setAcceptedByUserId(String acceptedByUserId) {
        this.acceptedByUserId = acceptedByUserId;
    }
}
