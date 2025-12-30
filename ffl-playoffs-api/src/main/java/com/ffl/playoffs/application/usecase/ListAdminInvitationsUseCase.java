package com.ffl.playoffs.application.usecase;

import com.ffl.playoffs.domain.model.invitation.AdminInvitation;
import com.ffl.playoffs.domain.model.invitation.AdminInvitationStatus;
import com.ffl.playoffs.domain.port.AdminInvitationRepository;

import java.util.List;
import java.util.Optional;
import java.util.UUID;

/**
 * Use case for listing and querying admin invitations.
 */
public class ListAdminInvitationsUseCase {

    private final AdminInvitationRepository repository;

    public ListAdminInvitationsUseCase(AdminInvitationRepository repository) {
        this.repository = repository;
    }

    /**
     * Get all invitations.
     */
    public List<AdminInvitation> getAll() {
        return repository.findAll();
    }

    /**
     * Get an invitation by ID.
     */
    public Optional<AdminInvitation> getById(UUID id) {
        return repository.findById(id);
    }

    /**
     * Get an invitation by token.
     */
    public Optional<AdminInvitation> getByToken(String token) {
        return repository.findByToken(token);
    }

    /**
     * Get invitations by status.
     */
    public List<AdminInvitation> getByStatus(AdminInvitationStatus status) {
        return repository.findByStatus(status);
    }

    /**
     * Get all pending invitations.
     */
    public List<AdminInvitation> getPendingInvitations() {
        return repository.findPendingInvitations();
    }

    /**
     * Get invitations sent by a specific admin.
     */
    public List<AdminInvitation> getByInvitedBy(UUID invitedBy) {
        return repository.findByInvitedBy(invitedBy);
    }

    /**
     * Get pending invitation for an email.
     */
    public Optional<AdminInvitation> getPendingByEmail(String email) {
        return repository.findPendingByEmail(email);
    }

    /**
     * Get expired invitations.
     */
    public List<AdminInvitation> getExpiredInvitations() {
        return repository.findExpiredInvitations();
    }

    /**
     * Count pending invitations.
     */
    public long countPending() {
        return repository.countByStatus(AdminInvitationStatus.PENDING);
    }

    /**
     * Count invitations by status.
     */
    public long countByStatus(AdminInvitationStatus status) {
        return repository.countByStatus(status);
    }

    /**
     * Check if email has a pending invitation.
     */
    public boolean hasPendingInvitation(String email) {
        return repository.existsPendingByEmail(email);
    }
}
