package com.ffl.playoffs.domain.port;

import com.ffl.playoffs.application.dto.NFLTeamDTO;
import com.ffl.playoffs.application.dto.Page;
import com.ffl.playoffs.application.dto.PageRequest;

import java.util.List;
import java.util.Optional;

/**
 * Port interface for NFL Team data retrieval
 * Domain defines the contract, infrastructure implements it (external API integration)
 * No framework dependencies in this interface
 */
public interface NFLTeamRepository {

    /**
     * Find all NFL teams with pagination support
     * @param pageRequest pagination parameters
     * @return paginated list of NFL teams
     */
    Page<NFLTeamDTO> findAll(PageRequest pageRequest);

    /**
     * Find NFL teams filtered by conference
     * @param conference AFC or NFC
     * @param pageRequest pagination parameters
     * @return paginated list of NFL teams in the specified conference
     */
    Page<NFLTeamDTO> findByConference(String conference, PageRequest pageRequest);

    /**
     * Find NFL teams filtered by division
     * @param division division name (e.g., "AFC East")
     * @param pageRequest pagination parameters
     * @return paginated list of NFL teams in the specified division
     */
    Page<NFLTeamDTO> findByDivision(String division, PageRequest pageRequest);

    /**
     * Find a specific NFL team by name
     * @param name team name
     * @return Optional containing the team if found
     */
    Optional<NFLTeamDTO> findByName(String name);

    /**
     * Find a specific NFL team by abbreviation
     * @param abbreviation team abbreviation (e.g., "KC" for Kansas City Chiefs)
     * @return Optional containing the team if found
     */
    Optional<NFLTeamDTO> findByAbbreviation(String abbreviation);

    /**
     * Get all 32 NFL teams (unpaginated)
     * @return list of all NFL teams
     */
    List<NFLTeamDTO> findAll();
}
