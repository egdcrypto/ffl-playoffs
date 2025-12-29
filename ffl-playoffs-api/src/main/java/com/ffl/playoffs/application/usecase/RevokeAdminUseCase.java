package com.ffl.playoffs.application.usecase;

import com.ffl.playoffs.domain.aggregate.League;
import com.ffl.playoffs.domain.aggregate.User;
import com.ffl.playoffs.domain.model.LeagueOwnerStatus;
import com.ffl.playoffs.domain.port.LeagueRepository;
import com.ffl.playoffs.domain.port.UserRepository;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDateTime;
import java.util.List;
import java.util.UUID;

/**
 * Use case for revoking admin privileges.
 * Only SUPER_ADMIN can revoke admin access.
 * Downgrades admin to player and marks their leagues as ADMIN_REVOKED.
 */
@Service
public class RevokeAdminUseCase {

    private final UserRepository userRepository;
    private final LeagueRepository leagueRepository;

    public RevokeAdminUseCase(UserRepository userRepository, LeagueRepository leagueRepository) {
        this.userRepository = userRepository;
        this.leagueRepository = leagueRepository;
    }

    /**
     * Revokes admin privileges from a user.
     *
     * @param command the revoke command
     * @return the result containing affected resources
     * @throws IllegalStateException for authorization/validation errors
     */
    @Transactional
    public RevokeAdminResult execute(RevokeAdminCommand command) {
        // Verify requester is SUPER_ADMIN
        User requester = userRepository.findById(command.getRequesterId())
                .orElseThrow(() -> new IllegalArgumentException("Requester not found"));

        if (!requester.isSuperAdmin()) {
            throw new IllegalStateException("Only SUPER_ADMIN can revoke admin privileges");
        }

        // Find the admin by email
        User admin = userRepository.findByEmail(command.getAdminEmail())
                .orElseThrow(() -> new IllegalArgumentException("Admin not found: " + command.getAdminEmail()));

        // Verify the target is an ADMIN (not SUPER_ADMIN or PLAYER)
        if (!admin.isAdmin() || admin.isSuperAdmin()) {
            throw new IllegalStateException("User is not an admin: " + command.getAdminEmail());
        }

        // Downgrade role from ADMIN to PLAYER
        admin.downgradeToPlayer();
        userRepository.save(admin);

        // Find and mark all leagues owned by this admin as ADMIN_REVOKED
        List<League> ownedLeagues = leagueRepository.findByAdminId(admin.getId());
        int affectedLeagues = 0;

        for (League league : ownedLeagues) {
            league.setOwnerStatus(LeagueOwnerStatus.ADMIN_REVOKED);
            leagueRepository.save(league);
            affectedLeagues++;
        }

        return new RevokeAdminResult(
                admin.getId(),
                admin.getEmail(),
                affectedLeagues,
                LocalDateTime.now(),
                "Admin privileges revoked. User downgraded to PLAYER."
        );
    }

    /**
     * Command for revoking admin privileges
     */
    public static class RevokeAdminCommand {
        private final String adminEmail;
        private final UUID requesterId;

        public RevokeAdminCommand(String adminEmail, UUID requesterId) {
            this.adminEmail = adminEmail;
            this.requesterId = requesterId;
        }

        public String getAdminEmail() {
            return adminEmail;
        }

        public UUID getRequesterId() {
            return requesterId;
        }
    }

    /**
     * Result of revoking admin privileges
     */
    public static class RevokeAdminResult {
        private final UUID userId;
        private final String email;
        private final int affectedLeagues;
        private final LocalDateTime revokedAt;
        private final String message;

        public RevokeAdminResult(UUID userId, String email, int affectedLeagues,
                                 LocalDateTime revokedAt, String message) {
            this.userId = userId;
            this.email = email;
            this.affectedLeagues = affectedLeagues;
            this.revokedAt = revokedAt;
            this.message = message;
        }

        public UUID getUserId() {
            return userId;
        }

        public String getEmail() {
            return email;
        }

        public int getAffectedLeagues() {
            return affectedLeagues;
        }

        public LocalDateTime getRevokedAt() {
            return revokedAt;
        }

        public String getMessage() {
            return message;
        }
    }
}
