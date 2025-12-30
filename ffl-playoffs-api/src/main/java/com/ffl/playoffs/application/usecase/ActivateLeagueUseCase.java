package com.ffl.playoffs.application.usecase;

import com.ffl.playoffs.domain.aggregate.League;
import com.ffl.playoffs.domain.aggregate.Week;
import com.ffl.playoffs.domain.port.LeagueRepository;
import com.ffl.playoffs.domain.port.WeekRepository;
import com.ffl.playoffs.domain.service.WeekCreationService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.UUID;

/**
 * Use case for activating a league and creating week entities.
 * When a league is activated, week entities are created based on the league's
 * starting week and number of weeks configuration.
 */
@Service
@RequiredArgsConstructor
@Slf4j
public class ActivateLeagueUseCase {

    private final LeagueRepository leagueRepository;
    private final WeekRepository weekRepository;
    private final WeekCreationService weekCreationService;

    /**
     * Activates a league and creates all week entities.
     *
     * @param command the activation command
     * @return the result containing the activated league and created weeks
     * @throws IllegalArgumentException if league not found
     * @throws IllegalStateException if league cannot be activated or weeks already exist
     */
    public ActivateLeagueResult execute(ActivateLeagueCommand command) {
        log.info("Activating league: {}", command.getLeagueId());

        // Find the league
        League league = leagueRepository.findById(command.getLeagueId())
                .orElseThrow(() -> new IllegalArgumentException("League not found: " + command.getLeagueId()));

        // Validate league can be activated
        validateLeagueForActivation(league);

        // Check if weeks already exist
        if (weekRepository.existsByLeagueId(league.getId())) {
            throw new IllegalStateException("WEEKS_ALREADY_EXIST: Weeks have already been created for this league");
        }

        // Create week entities
        List<Week> weeks = weekCreationService.createWeeksForLeague(league);
        log.info("Created {} week entities for league {}", weeks.size(), league.getId());

        // Save weeks
        List<Week> savedWeeks = weekRepository.saveAll(weeks);

        // Activate the league (changes status to ACTIVE)
        league.start();
        League savedLeague = leagueRepository.save(league);

        log.info("League {} activated with {} weeks (NFL weeks {} to {})",
                league.getId(),
                savedWeeks.size(),
                league.getStartingWeek(),
                league.getEndingWeek());

        return new ActivateLeagueResult(savedLeague, savedWeeks);
    }

    private void validateLeagueForActivation(League league) {
        if (league.getStatus() == League.LeagueStatus.ACTIVE) {
            throw new IllegalStateException("League is already active");
        }
        if (league.getStatus() == League.LeagueStatus.COMPLETED) {
            throw new IllegalStateException("League has already been completed");
        }
        if (league.getStatus() == League.LeagueStatus.CANCELLED) {
            throw new IllegalStateException("League has been cancelled");
        }
        if (league.getStartingWeek() == null || league.getNumberOfWeeks() == null) {
            throw new IllegalStateException("League must have starting week and number of weeks configured");
        }
        if (league.getRosterConfiguration() == null) {
            throw new IllegalStateException("League must have roster configuration");
        }
        if (league.getScoringRules() == null) {
            throw new IllegalStateException("League must have scoring rules");
        }
        if (league.getPlayers() == null || league.getPlayers().size() < 2) {
            throw new IllegalStateException("League requires at least 2 players to activate");
        }
    }

    /**
     * Command for activating a league
     */
    public static class ActivateLeagueCommand {
        private final UUID leagueId;
        private final UUID activatedBy;

        public ActivateLeagueCommand(UUID leagueId, UUID activatedBy) {
            this.leagueId = leagueId;
            this.activatedBy = activatedBy;
        }

        public UUID getLeagueId() {
            return leagueId;
        }

        public UUID getActivatedBy() {
            return activatedBy;
        }
    }

    /**
     * Result of league activation
     */
    public static class ActivateLeagueResult {
        private final League league;
        private final List<Week> weeks;

        public ActivateLeagueResult(League league, List<Week> weeks) {
            this.league = league;
            this.weeks = weeks;
        }

        public League getLeague() {
            return league;
        }

        public List<Week> getWeeks() {
            return weeks;
        }
    }
}
