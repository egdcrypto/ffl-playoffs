package com.ffl.playoffs.application.service;

import com.ffl.playoffs.domain.aggregate.League;
import com.ffl.playoffs.domain.aggregate.Roster;
import com.ffl.playoffs.domain.model.LiveScoreStatus;
import com.ffl.playoffs.domain.model.PlayerStats;
import com.ffl.playoffs.domain.model.Position;
import com.ffl.playoffs.domain.model.RosterSlot;
import com.ffl.playoffs.domain.model.nfl.NFLGameStatus;
import com.ffl.playoffs.domain.port.LeaguePlayerRepository;
import com.ffl.playoffs.domain.port.LeagueRepository;
import com.ffl.playoffs.domain.port.LiveScoreBroadcastPort;
import com.ffl.playoffs.domain.port.LiveScoreRepository;
import com.ffl.playoffs.domain.port.NflLiveDataPort;
import com.ffl.playoffs.domain.port.RosterRepository;
import com.ffl.playoffs.domain.service.ScoringService;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;

import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Optional;
import java.util.UUID;

import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.ArgumentMatchers.anyInt;
import static org.mockito.ArgumentMatchers.anyList;
import static org.mockito.ArgumentMatchers.anyString;
import static org.mockito.ArgumentMatchers.eq;
import static org.mockito.Mockito.*;

@ExtendWith(MockitoExtension.class)
@DisplayName("LiveScoringService Tests")
class LiveScoringServiceTest {

    @Mock
    private NflLiveDataPort nflDataPort;

    @Mock
    private LiveScoreRepository liveScoreRepository;

    @Mock
    private LiveScoreBroadcastPort broadcastPort;

    @Mock
    private ScoringService scoringService;

    @Mock
    private RosterRepository rosterRepository;

    @Mock
    private LeagueRepository leagueRepository;

    @Mock
    private LeaguePlayerRepository leaguePlayerRepository;

    @InjectMocks
    private LiveScoringService liveScoringService;

    private UUID leagueId;
    private UUID player1Id;
    private UUID gameId;
    private League testLeague;
    private Roster testRoster;

    @BeforeEach
    void setUp() {
        leagueId = UUID.randomUUID();
        player1Id = UUID.randomUUID();
        gameId = UUID.randomUUID();

        testLeague = new League();
        testLeague.setId(leagueId);
        testLeague.setCurrentWeek(1);

        // Create test roster with filled slots
        testRoster = new Roster();
        testRoster.setLeaguePlayerId(player1Id);

        List<RosterSlot> slots = new ArrayList<>();
        RosterSlot qbSlot = new RosterSlot(testRoster.getId(), Position.QB, 1);
        qbSlot.assignPlayer(100L, Position.QB);
        slots.add(qbSlot);

        RosterSlot rbSlot = new RosterSlot(testRoster.getId(), Position.RB, 1);
        rbSlot.assignPlayer(200L, Position.RB);
        slots.add(rbSlot);

        RosterSlot wrSlot = new RosterSlot(testRoster.getId(), Position.WR, 1);
        wrSlot.assignPlayer(300L, Position.WR);
        slots.add(wrSlot);

        testRoster.setSlots(slots);
    }

    @Test
    @DisplayName("pollAndUpdateScores should skip when data source unavailable")
    void pollAndUpdateScoresShouldSkipWhenDataSourceUnavailable() {
        // Arrange
        when(nflDataPort.isAvailable()).thenReturn(false);

        // Act
        liveScoringService.pollAndUpdateScores(1, 2024, leagueId.toString());

        // Assert
        verify(broadcastPort).broadcastDataDelayWarning(eq(leagueId.toString()), anyString(), anyInt());
        verify(nflDataPort, never()).getGamesInProgress(anyInt(), anyInt());
    }

    @Test
    @DisplayName("pollAndUpdateScores should skip when no games in progress")
    void pollAndUpdateScoresShouldSkipWhenNoGamesInProgress() {
        // Arrange
        when(nflDataPort.isAvailable()).thenReturn(true);
        when(nflDataPort.getGamesInProgress(1, 2024)).thenReturn(List.of());

        // Act
        liveScoringService.pollAndUpdateScores(1, 2024, leagueId.toString());

        // Assert
        verify(nflDataPort, never()).fetchLivePlayerStats(anyInt(), anyInt());
    }

    @Test
    @DisplayName("pollAndUpdateScores should process stats and update scores")
    void pollAndUpdateScoresShouldProcessStatsAndUpdateScores() {
        // Arrange
        when(nflDataPort.isAvailable()).thenReturn(true);
        when(nflDataPort.getGamesInProgress(1, 2024)).thenReturn(List.of(gameId));

        // Create player stats with PPR scoring data
        PlayerStats qbStats = new PlayerStats();
        qbStats.setNflPlayerId(100L);
        qbStats.setPassingYards(300);
        qbStats.setPassingTouchdowns(3);

        PlayerStats rbStats = new PlayerStats();
        rbStats.setNflPlayerId(200L);
        rbStats.setRushingYards(100);
        rbStats.setRushingTouchdowns(1);
        rbStats.setReceptions(5);

        PlayerStats wrStats = new PlayerStats();
        wrStats.setNflPlayerId(300L);
        wrStats.setReceivingYards(150);
        wrStats.setReceivingTouchdowns(2);
        wrStats.setReceptions(8);

        List<PlayerStats> liveStats = List.of(qbStats, rbStats, wrStats);
        when(nflDataPort.fetchLivePlayerStats(1, 2024)).thenReturn(liveStats);
        when(rosterRepository.findByLeagueId(leagueId.toString())).thenReturn(List.of(testRoster));
        when(liveScoreRepository.isDuplicateUpdate(anyString())).thenReturn(false);
        when(liveScoreRepository.getAllScoresForLeague(anyString())).thenReturn(new HashMap<>());
        when(nflDataPort.getAllGameStatuses(1, 2024)).thenReturn(new HashMap<>());

        // Act
        liveScoringService.pollAndUpdateScores(1, 2024, leagueId.toString());

        // Assert
        verify(nflDataPort).fetchLivePlayerStats(1, 2024);
        verify(rosterRepository).findByLeagueId(leagueId.toString());
        verify(liveScoreRepository).saveAll(anyList());
    }

    @Test
    @DisplayName("pollAndUpdateScores should calculate PPR points correctly")
    void pollAndUpdateScoresShouldCalculatePPRPointsCorrectly() {
        // Arrange
        when(nflDataPort.isAvailable()).thenReturn(true);
        when(nflDataPort.getGamesInProgress(1, 2024)).thenReturn(List.of(gameId));

        // Create a roster with just one WR for simple calculation
        Roster simpleRoster = new Roster();
        simpleRoster.setLeaguePlayerId(player1Id);
        List<RosterSlot> slots = new ArrayList<>();
        RosterSlot wrSlot = new RosterSlot(simpleRoster.getId(), Position.WR, 1);
        wrSlot.assignPlayer(300L, Position.WR);
        slots.add(wrSlot);
        simpleRoster.setSlots(slots);

        // WR stats: 100 receiving yards (10 pts) + 1 TD (6 pts) + 5 receptions (5 pts PPR) = 21 pts
        PlayerStats wrStats = new PlayerStats();
        wrStats.setNflPlayerId(300L);
        wrStats.setReceivingYards(100);
        wrStats.setReceivingTouchdowns(1);
        wrStats.setReceptions(5);

        when(nflDataPort.fetchLivePlayerStats(1, 2024)).thenReturn(List.of(wrStats));
        when(rosterRepository.findByLeagueId(leagueId.toString())).thenReturn(List.of(simpleRoster));
        when(liveScoreRepository.isDuplicateUpdate(anyString())).thenReturn(false);
        when(liveScoreRepository.getAllScoresForLeague(anyString())).thenReturn(new HashMap<>());
        when(nflDataPort.getAllGameStatuses(1, 2024)).thenReturn(new HashMap<>());

        // Act
        liveScoringService.pollAndUpdateScores(1, 2024, leagueId.toString());

        // Assert - verify score update was created
        verify(liveScoreRepository).saveAll(argThat(updates -> {
            if (updates.isEmpty()) return false;
            var update = updates.get(0);
            // Expected: 10 (receiving yards) + 6 (TD) + 5 (receptions PPR) = 21
            return update.getNewScore().compareTo(BigDecimal.valueOf(21.0)) == 0;
        }));
    }

    @Test
    @DisplayName("pollAndUpdateScores should finalize scores when game completes")
    void pollAndUpdateScoresShouldFinalizeScoresWhenGameCompletes() {
        // Arrange
        when(nflDataPort.isAvailable()).thenReturn(true);
        when(nflDataPort.getGamesInProgress(1, 2024)).thenReturn(List.of(gameId));

        // Create stats for roster players
        PlayerStats qbStats = new PlayerStats();
        qbStats.setNflPlayerId(100L);
        qbStats.setNflGameId(gameId);
        qbStats.setPassingYards(300);
        when(nflDataPort.fetchLivePlayerStats(1, 2024)).thenReturn(List.of(qbStats));
        when(rosterRepository.findByLeagueId(leagueId.toString())).thenReturn(List.of(testRoster));
        when(liveScoreRepository.isDuplicateUpdate(anyString())).thenReturn(false);
        when(liveScoreRepository.getAllScoresForLeague(anyString())).thenReturn(new HashMap<>());

        // Mark game as completed
        Map<UUID, NFLGameStatus> gameStatuses = new HashMap<>();
        gameStatuses.put(gameId, NFLGameStatus.FINAL);
        when(nflDataPort.getAllGameStatuses(1, 2024)).thenReturn(gameStatuses);

        // Game completion fetches final stats
        when(nflDataPort.fetchGamePlayerStats(gameId)).thenReturn(List.of(qbStats));

        // Setup for score finalization check
        when(leagueRepository.findById(leagueId)).thenReturn(Optional.of(testLeague));

        Map<Long, PlayerStats> playerStatsMap = new HashMap<>();
        PlayerStats stats100 = new PlayerStats();
        stats100.setNflPlayerId(100L);
        stats100.setNflGameId(gameId);
        PlayerStats stats200 = new PlayerStats();
        stats200.setNflPlayerId(200L);
        stats200.setNflGameId(gameId);
        PlayerStats stats300 = new PlayerStats();
        stats300.setNflPlayerId(300L);
        stats300.setNflGameId(gameId);
        playerStatsMap.put(100L, stats100);
        playerStatsMap.put(200L, stats200);
        playerStatsMap.put(300L, stats300);
        when(nflDataPort.fetchPlayerStats(anyList(), anyInt(), anyInt())).thenReturn(playerStatsMap);

        // Act
        liveScoringService.pollAndUpdateScores(1, 2024, leagueId.toString());

        // Assert - verify game completion was broadcast
        verify(broadcastPort).broadcastGameCompleted(any());
    }

    @Test
    @DisplayName("pollAndUpdateScores should handle roster with no players matching stats")
    void pollAndUpdateScoresShouldHandleRosterWithNoMatchingStats() {
        // Arrange
        when(nflDataPort.isAvailable()).thenReturn(true);
        when(nflDataPort.getGamesInProgress(1, 2024)).thenReturn(List.of(gameId));

        // Stats for different players than roster has
        PlayerStats otherPlayerStats = new PlayerStats();
        otherPlayerStats.setNflPlayerId(999L); // Not on roster
        otherPlayerStats.setPassingYards(400);

        when(nflDataPort.fetchLivePlayerStats(1, 2024)).thenReturn(List.of(otherPlayerStats));
        when(rosterRepository.findByLeagueId(leagueId.toString())).thenReturn(List.of(testRoster));
        when(liveScoreRepository.getAllScoresForLeague(anyString())).thenReturn(new HashMap<>());
        when(nflDataPort.getAllGameStatuses(1, 2024)).thenReturn(new HashMap<>());

        // Act
        liveScoringService.pollAndUpdateScores(1, 2024, leagueId.toString());

        // Assert - should not save any updates since score would be 0 (same as previous)
        verify(liveScoreRepository, never()).saveAll(argThat(updates -> !updates.isEmpty()));
    }

    @Test
    @DisplayName("pollAndUpdateScores should handle exception gracefully")
    void pollAndUpdateScoresShouldHandleExceptionGracefully() {
        // Arrange
        when(nflDataPort.isAvailable()).thenReturn(true);
        when(nflDataPort.getGamesInProgress(1, 2024)).thenThrow(new RuntimeException("API error"));

        // Act
        liveScoringService.pollAndUpdateScores(1, 2024, leagueId.toString());

        // Assert
        verify(broadcastPort).broadcastDataDelayWarning(eq(leagueId.toString()), anyString(), anyInt());
    }

    @Test
    @DisplayName("pollAndUpdateScores should not duplicate updates")
    void pollAndUpdateScoresShouldNotDuplicateUpdates() {
        // Arrange
        when(nflDataPort.isAvailable()).thenReturn(true);
        when(nflDataPort.getGamesInProgress(1, 2024)).thenReturn(List.of(gameId));

        PlayerStats qbStats = new PlayerStats();
        qbStats.setNflPlayerId(100L);
        qbStats.setPassingYards(300);

        when(nflDataPort.fetchLivePlayerStats(1, 2024)).thenReturn(List.of(qbStats));
        when(rosterRepository.findByLeagueId(leagueId.toString())).thenReturn(List.of(testRoster));
        when(liveScoreRepository.isDuplicateUpdate(anyString())).thenReturn(true); // Already seen this update
        when(liveScoreRepository.getAllScoresForLeague(anyString())).thenReturn(new HashMap<>());
        when(nflDataPort.getAllGameStatuses(1, 2024)).thenReturn(new HashMap<>());

        // Act
        liveScoringService.pollAndUpdateScores(1, 2024, leagueId.toString());

        // Assert - isDuplicateUpdate was checked for the update
        verify(liveScoreRepository).isDuplicateUpdate(anyString());
        // saveAll should NOT be called since all updates were duplicates (updates list empty)
        verify(liveScoreRepository, never()).saveAll(anyList());
    }

    @Test
    @DisplayName("getLiveScore should return score when found")
    void getLiveScoreShouldReturnScoreWhenFound() {
        // Arrange
        when(liveScoreRepository.getCurrentScore(player1Id.toString()))
                .thenReturn(Optional.of(BigDecimal.valueOf(45.5)));
        when(liveScoreRepository.getScoreStatus(player1Id.toString()))
                .thenReturn(LiveScoreStatus.LIVE);
        when(liveScoreRepository.getLastUpdateTime(player1Id.toString()))
                .thenReturn(Optional.empty());

        // Act
        var result = liveScoringService.getLiveScore(player1Id.toString());

        // Assert
        assertTrue(result.isPresent());
        assertEquals(BigDecimal.valueOf(45.5), result.get().getCurrentScore());
        assertEquals(LiveScoreStatus.LIVE, result.get().getStatus());
    }

    @Test
    @DisplayName("getLiveScore should return empty when score not found")
    void getLiveScoreShouldReturnEmptyWhenNotFound() {
        // Arrange
        when(liveScoreRepository.getCurrentScore(player1Id.toString()))
                .thenReturn(Optional.empty());

        // Act
        var result = liveScoringService.getLiveScore(player1Id.toString());

        // Assert
        assertTrue(result.isEmpty());
    }

    @Test
    @DisplayName("clearCaches should clear all caches")
    void clearCachesShouldClearAllCaches() {
        // Arrange & Act
        liveScoringService.clearCaches(leagueId.toString());

        // Assert
        verify(liveScoreRepository).clearCache(leagueId.toString());
    }
}
