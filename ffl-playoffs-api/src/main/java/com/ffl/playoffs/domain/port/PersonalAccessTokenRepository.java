package com.ffl.playoffs.domain.port;

import com.ffl.playoffs.domain.model.PersonalAccessToken;
import java.util.Optional;
import java.util.UUID;
import java.util.List;

/**
 * Repository interface for PersonalAccessToken aggregate
 * Port in hexagonal architecture
 */
public interface PersonalAccessTokenRepository {

    /**
     * Find PAT by ID
     * @param id the PAT ID
     * @return Optional containing the PAT if found
     */
    Optional<PersonalAccessToken> findById(UUID id);

    /**
     * Find PAT by token identifier
     * @param tokenIdentifier the token identifier (not hashed)
     * @return Optional containing the PAT if found
     */
    Optional<PersonalAccessToken> findByTokenIdentifier(String tokenIdentifier);

    /**
     * Find all PATs created by a specific user
     * @param userId the user ID
     * @return list of PATs
     */
    List<PersonalAccessToken> findByCreatedBy(UUID userId);

    /**
     * Find all active (non-revoked, non-expired) PATs
     * @return list of active PATs
     */
    List<PersonalAccessToken> findAllActive();

    /**
     * Save a PAT
     * @param token the PAT to save
     * @return the saved PAT
     */
    PersonalAccessToken save(PersonalAccessToken token);

    /**
     * Delete a PAT
     * @param id the PAT ID
     */
    void deleteById(UUID id);

    /**
     * Check if PAT exists by name
     * @param name the PAT name
     * @return true if PAT exists
     */
    boolean existsByName(String name);
}
