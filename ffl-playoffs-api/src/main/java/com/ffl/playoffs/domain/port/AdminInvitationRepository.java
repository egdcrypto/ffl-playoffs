package com.ffl.playoffs.domain.port;

import com.ffl.playoffs.domain.entity.AdminInvitation;
import com.ffl.playoffs.domain.model.AdminInvitationStatus;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Optional;
import java.util.UUID;

/**
 * Repository interface for AdminInvitation entity.
 * Port in hexagonal architecture.
 */
public interface AdminInvitationRepository {

    /**
     * Saves an admin invitation
     *
     * @param invitation the invitation to save
     * @return the saved invitation
     */
    AdminInvitation save(AdminInvitation invitation);

    /**
     * Finds an invitation by its ID
     *
     * @param id the invitation ID
     * @return Optional containing the invitation if found
     */
    Optional<AdminInvitation> findById(UUID id);

    /**
     * Finds an invitation by the invitation token
     *
     * @param token the unique invitation token
     * @return Optional containing the invitation if found
     */
    Optional<AdminInvitation> findByInvitationToken(String token);

    /**
     * Finds a pending invitation by email
     *
     * @param email the email address
     * @return Optional containing the pending invitation if found
     */
    Optional<AdminInvitation> findPendingByEmail(String email);

    /**
     * Finds all invitations for an email address
     *
     * @param email the email address
     * @return list of invitations
     */
    List<AdminInvitation> findByEmail(String email);

    /**
     * Finds all invitations with a specific status
     *
     * @param status the invitation status
     * @return list of invitations
     */
    List<AdminInvitation> findByStatus(AdminInvitationStatus status);

    /**
     * Finds all pending invitations that have expired
     *
     * @param now the current timestamp
     * @return list of expired pending invitations
     */
    List<AdminInvitation> findExpiredPending(LocalDateTime now);

    /**
     * Checks if a pending invitation exists for an email
     *
     * @param email the email address
     * @return true if a pending invitation exists
     */
    boolean existsPendingByEmail(String email);

    /**
     * Deletes an invitation by ID
     *
     * @param id the invitation ID
     */
    void deleteById(UUID id);

    /**
     * Finds all invitations
     *
     * @return list of all invitations
     */
    List<AdminInvitation> findAll();
}
