package com.ffl.playoffs.domain.port;

import com.ffl.playoffs.domain.model.invitation.AdminInvitation;
import com.ffl.playoffs.domain.model.invitation.AdminInvitationStatus;

import java.util.List;
import java.util.Optional;
import java.util.UUID;

/**
 * Repository port for Admin Invitation persistence.
 * Defines the contract for Admin Invitation data access following hexagonal architecture.
 */
public interface AdminInvitationRepository {

    /**
     * Save an admin invitation.
     */
    AdminInvitation save(AdminInvitation invitation);

    /**
     * Find an invitation by ID.
     */
    Optional<AdminInvitation> findById(UUID id);

    /**
     * Find an invitation by token.
     */
    Optional<AdminInvitation> findByToken(String token);

    /**
     * Find an invitation by email.
     */
    Optional<AdminInvitation> findByEmail(String email);

    /**
     * Find the most recent pending invitation for an email.
     */
    Optional<AdminInvitation> findPendingByEmail(String email);

    /**
     * Find all invitations by status.
     */
    List<AdminInvitation> findByStatus(AdminInvitationStatus status);

    /**
     * Find all invitations sent by a specific admin.
     */
    List<AdminInvitation> findByInvitedBy(UUID invitedBy);

    /**
     * Find all pending invitations.
     */
    List<AdminInvitation> findPendingInvitations();

    /**
     * Find all expired invitations (pending but past expiry date).
     */
    List<AdminInvitation> findExpiredInvitations();

    /**
     * Find invitations by email and status.
     */
    List<AdminInvitation> findByEmailAndStatus(String email, AdminInvitationStatus status);

    /**
     * Check if an email has a pending invitation.
     */
    boolean existsPendingByEmail(String email);

    /**
     * Check if an invitation exists by ID.
     */
    boolean existsById(UUID id);

    /**
     * Delete an invitation by ID.
     */
    void deleteById(UUID id);

    /**
     * Count invitations by status.
     */
    long countByStatus(AdminInvitationStatus status);

    /**
     * Count pending invitations sent by a specific admin.
     */
    long countPendingByInvitedBy(UUID invitedBy);

    /**
     * Find all invitations (for admin dashboard).
     */
    List<AdminInvitation> findAll();
}
