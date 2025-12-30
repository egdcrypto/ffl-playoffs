package com.ffl.playoffs.domain.aggregate;

import com.ffl.playoffs.domain.model.LeagueStatus;
import com.ffl.playoffs.domain.model.Player;
import com.ffl.playoffs.domain.model.RosterConfiguration;
import com.ffl.playoffs.domain.model.ScoringRules;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.DisplayName;

import java.util.UUID;

import static org.junit.jupiter.api.Assertions.*;

/**
 * Unit tests for League lifecycle management (FFL-3)
 */
class LeagueLifecycleTest {

    private League league;

    @BeforeEach
    void setUp() {
        league = new League("Test League", "TEST123", UUID.randomUUID(), 15, 4);
        league.setRosterConfiguration(RosterConfiguration.standardRoster());
        league.setScoringRules(new ScoringRules());
    }

    @Test
    @DisplayName("New league starts in DRAFT status")
    void newLeagueStartsInDraftStatus() {
        League newLeague = new League();
        assertEquals(LeagueStatus.DRAFT, newLeague.getStatus());
    }

    @Test
    @DisplayName("Admin can activate a league with minimum players")
    void adminCanActivateLeagueWithMinimumPlayers() {
        // Add minimum players
        addPlayers(2);

        league.activate();

        assertEquals(LeagueStatus.ACTIVE, league.getStatus());
        assertTrue(league.getConfigurationLocked());
    }

    @Test
    @DisplayName("Cannot activate league without minimum players")
    void cannotActivateLeagueWithoutMinimumPlayers() {
        // Only add 1 player (less than minimum of 2)
        addPlayers(1);

        assertThrows(League.InsufficientPlayersException.class, () -> league.activate());
    }

    @Test
    @DisplayName("Cannot activate league with incomplete configuration - no roster")
    void cannotActivateLeagueWithoutRosterConfiguration() {
        league.setRosterConfiguration(null);
        addPlayers(2);

        assertThrows(League.IncompleteConfigurationException.class, () -> league.activate());
    }

    @Test
    @DisplayName("Cannot activate league with incomplete configuration - no scoring rules")
    void cannotActivateLeagueWithoutScoringRules() {
        league.setScoringRules(null);
        addPlayers(2);

        assertThrows(League.IncompleteConfigurationException.class, () -> league.activate());
    }

    @Test
    @DisplayName("Admin can deactivate an active league")
    void adminCanDeactivateActiveLeague() {
        addPlayers(2);
        league.activate();

        league.deactivate();

        assertEquals(LeagueStatus.INACTIVE, league.getStatus());
    }

    @Test
    @DisplayName("Cannot deactivate a league that is not active")
    void cannotDeactivateNonActiveLeague() {
        // League is in DRAFT status
        assertThrows(IllegalStateException.class, () -> league.deactivate());
    }

    @Test
    @DisplayName("Admin can reactivate an inactive league")
    void adminCanReactivateInactiveLeague() {
        addPlayers(2);
        league.activate();
        league.deactivate();

        league.reactivate();

        assertEquals(LeagueStatus.ACTIVE, league.getStatus());
    }

    @Test
    @DisplayName("Admin can pause an active league")
    void adminCanPauseActiveLeague() {
        addPlayers(2);
        league.activate();

        league.pause();

        assertEquals(LeagueStatus.PAUSED, league.getStatus());
        assertNotNull(league.getPausedAt());
    }

    @Test
    @DisplayName("Admin can resume a paused league")
    void adminCanResumePausedLeague() {
        addPlayers(2);
        league.activate();
        league.pause();

        league.resume();

        assertEquals(LeagueStatus.ACTIVE, league.getStatus());
        assertNull(league.getPausedAt());
    }

    @Test
    @DisplayName("Admin can cancel a league with reason")
    void adminCanCancelLeagueWithReason() {
        addPlayers(2);
        league.activate();

        String reason = "Insufficient participation";
        league.cancel(reason);

        assertEquals(LeagueStatus.CANCELLED, league.getStatus());
        assertEquals(reason, league.getCancellationReason());
    }

    @Test
    @DisplayName("Admin can complete an active league")
    void adminCanCompleteActiveLeague() {
        addPlayers(2);
        league.activate();

        league.complete();

        assertEquals(LeagueStatus.COMPLETED, league.getStatus());
        assertNotNull(league.getCompletedAt());
    }

    @Test
    @DisplayName("Admin can archive a completed league")
    void adminCanArchiveCompletedLeague() {
        addPlayers(2);
        league.activate();
        league.complete();

        league.archive();

        assertEquals(LeagueStatus.ARCHIVED, league.getStatus());
        assertNotNull(league.getArchivedAt());
    }

    @Test
    @DisplayName("Cannot archive a league that is not completed")
    void cannotArchiveNonCompletedLeague() {
        addPlayers(2);
        league.activate();

        assertThrows(IllegalStateException.class, () -> league.archive());
    }

    @Test
    @DisplayName("Cannot cancel an already completed league")
    void cannotCancelCompletedLeague() {
        addPlayers(2);
        league.activate();
        league.complete();

        assertThrows(IllegalStateException.class, () -> league.cancel("reason"));
    }

    @Test
    @DisplayName("League advances week correctly")
    void leagueAdvancesWeekCorrectly() {
        addPlayers(2);
        league.activate();
        int initialWeek = league.getCurrentWeek();

        league.advanceWeek();

        assertEquals(initialWeek + 1, league.getCurrentWeek());
    }

    @Test
    @DisplayName("League completes when advancing past final week")
    void leagueCompletesWhenAdvancingPastFinalWeek() {
        addPlayers(2);
        league.activate();
        // Set current week to final week
        league.setCurrentWeek(league.getEndingWeek());

        league.advanceWeek();

        assertEquals(LeagueStatus.COMPLETED, league.getStatus());
    }

    @Test
    @DisplayName("Can delete draft league with no players")
    void canDeleteDraftLeagueWithNoPlayers() {
        assertTrue(league.canDelete());
    }

    @Test
    @DisplayName("Cannot delete active league")
    void cannotDeleteActiveLeague() {
        addPlayers(2);
        league.activate();

        assertFalse(league.canDelete());
    }

    @Test
    @DisplayName("Cannot delete draft league with players")
    void cannotDeleteDraftLeagueWithPlayers() {
        addPlayers(2);

        assertFalse(league.canDelete());
    }

    @Test
    @DisplayName("Week mapping works correctly")
    void weekMappingWorksCorrectly() {
        // League starts at NFL week 15 with 4 weeks
        assertEquals(1, league.getGameWeekForNflWeek(15)); // Game week 1 = NFL week 15
        assertEquals(2, league.getGameWeekForNflWeek(16)); // Game week 2 = NFL week 16
        assertEquals(3, league.getGameWeekForNflWeek(17)); // Game week 3 = NFL week 17
        assertEquals(4, league.getGameWeekForNflWeek(18)); // Game week 4 = NFL week 18

        assertNull(league.getGameWeekForNflWeek(14)); // Before start
        assertNull(league.getGameWeekForNflWeek(19)); // After end
    }

    @Test
    @DisplayName("NFL week mapping works correctly")
    void nflWeekMappingWorksCorrectly() {
        assertEquals(15, league.getNflWeekForGameWeek(1)); // Game week 1 = NFL week 15
        assertEquals(16, league.getNflWeekForGameWeek(2)); // Game week 2 = NFL week 16
        assertEquals(17, league.getNflWeekForGameWeek(3)); // Game week 3 = NFL week 17
        assertEquals(18, league.getNflWeekForGameWeek(4)); // Game week 4 = NFL week 18

        assertNull(league.getNflWeekForGameWeek(0)); // Invalid
        assertNull(league.getNflWeekForGameWeek(5)); // Beyond league duration
    }

    // Helper method
    private void addPlayers(int count) {
        for (int i = 0; i < count; i++) {
            Player player = new Player();
            player.setId((long) i);
            player.setEmail("player" + i + "@test.com");
            player.setDisplayName("Player " + i);
            league.addPlayer(player);
        }
    }
}
