package com.ffl.playoffs.application.service;

import com.ffl.playoffs.domain.aggregate.League;
import com.ffl.playoffs.domain.aggregate.Roster;
import com.ffl.playoffs.domain.model.PlayerStats;
import com.ffl.playoffs.domain.model.Position;
import com.ffl.playoffs.domain.model.RosterSlot;
import com.ffl.playoffs.domain.port.LeaguePlayerRepository;
import com.ffl.playoffs.domain.port.LeagueRepository;
import com.ffl.playoffs.domain.port.LiveScoreRepository;
import com.ffl.playoffs.domain.port.NflLiveDataPort;
import com.ffl.playoffs.domain.port.RosterRepository;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Optional;
import java.util.UUID;

import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.ArgumentMatchers.anyInt;
import static org.mockito.ArgumentMatchers.anyList;
import static org.mockito.ArgumentMatchers.eq;
import static org.mockito.Mockito.when;

@ExtendWith(MockitoExtension.class)
@DisplayName("LiveLeaderboardService Tests")
class LiveLeaderboardServiceTest {

    @Mock
    private LiveScoreRepository liveScoreRepository;

    @Mock
    private LeaguePlayerRepository leaguePlayerRepository;

    @Mock
    private RosterRepository rosterRepository;

    @Mock
    private NflLiveDataPort nflLiveDataPort;

    @Mock
    private LeagueRepository leagueRepository;

    @InjectMocks
    private LiveLeaderboardService liveLeaderboardService;

    private UUID leagueId;
    private UUID player1Id;
    private UUID player2Id;
    private UUID gameInProgressId;
    private UUID completedGameId;
    private League testLeague;
    private Roster roster1;
    private Roster roster2;

    @BeforeEach
    void setUp() {
        leagueId = UUID.randomUUID();
        player1Id = UUID.randomUUID();
        player2Id = UUID.randomUUID();
        gameInProgressId = UUID.randomUUID();
        completedGameId = UUID.randomUUID();

        testLeague = new League();
        testLeague.setId(leagueId);
        testLeague.setCurrentWeek(1);

        // Create roster 1 with a player in a live game
        roster1 = new Roster();
        roster1.setLeaguePlayerId(player1Id);
        List<RosterSlot> slots1 = new ArrayList<>();
        RosterSlot slot1 = new RosterSlot(roster1.getId(), Position.QB, 1);
        slot1.assignPlayer(100L, Position.QB); // NFL player 100 in live game
        slots1.add(slot1);
        roster1.setSlots(slots1);

        // Create roster 2 with a player in a completed game
        roster2 = new Roster();
        roster2.setLeaguePlayerId(player2Id);
        List<RosterSlot> slots2 = new ArrayList<>();
        RosterSlot slot2 = new RosterSlot(roster2.getId(), Position.RB, 1);
        slot2.assignPlayer(200L, Position.RB); // NFL player 200 in completed game
        slots2.add(slot2);
        roster2.setSlots(slots2);
    }

    @Test
    @DisplayName("getPlayersWithLiveGames should return empty list when league not found")
    void getPlayersWithLiveGamesShouldReturnEmptyWhenLeagueNotFound() {
        // Arrange
        when(leagueRepository.findById(leagueId)).thenReturn(Optional.empty());

        // Act
        List<String> result = liveLeaderboardService.getPlayersWithLiveGames(leagueId.toString());

        // Assert
        assertTrue(result.isEmpty());
    }

    @Test
    @DisplayName("getPlayersWithLiveGames should return empty list when no games in progress")
    void getPlayersWithLiveGamesShouldReturnEmptyWhenNoGamesInProgress() {
        // Arrange
        when(leagueRepository.findById(leagueId)).thenReturn(Optional.of(testLeague));
        when(nflLiveDataPort.getGamesInProgress(anyInt(), anyInt())).thenReturn(List.of());

        // Act
        List<String> result = liveLeaderboardService.getPlayersWithLiveGames(leagueId.toString());

        // Assert
        assertTrue(result.isEmpty());
    }

    @Test
    @DisplayName("getPlayersWithLiveGames should return empty list when no rosters in league")
    void getPlayersWithLiveGamesShouldReturnEmptyWhenNoRosters() {
        // Arrange
        when(leagueRepository.findById(leagueId)).thenReturn(Optional.of(testLeague));
        when(nflLiveDataPort.getGamesInProgress(anyInt(), anyInt())).thenReturn(List.of(gameInProgressId));
        when(rosterRepository.findByLeagueId(leagueId.toString())).thenReturn(List.of());

        // Act
        List<String> result = liveLeaderboardService.getPlayersWithLiveGames(leagueId.toString());

        // Assert
        assertTrue(result.isEmpty());
    }

    @Test
    @DisplayName("getPlayersWithLiveGames should return player when their roster has player in live game")
    void getPlayersWithLiveGamesShouldReturnPlayerWithLiveGame() {
        // Arrange
        when(leagueRepository.findById(leagueId)).thenReturn(Optional.of(testLeague));
        when(nflLiveDataPort.getGamesInProgress(anyInt(), anyInt())).thenReturn(List.of(gameInProgressId));
        when(rosterRepository.findByLeagueId(leagueId.toString())).thenReturn(List.of(roster1, roster2));

        // Create player stats - player 100 is in live game, player 200 is not
        PlayerStats stats100 = new PlayerStats();
        stats100.setNflPlayerId(100L);
        stats100.setNflGameId(gameInProgressId); // in live game

        PlayerStats stats200 = new PlayerStats();
        stats200.setNflPlayerId(200L);
        stats200.setNflGameId(completedGameId); // in completed game, not in live game list

        Map<Long, PlayerStats> statsMap = new HashMap<>();
        statsMap.put(100L, stats100);
        statsMap.put(200L, stats200);

        when(nflLiveDataPort.fetchPlayerStats(anyList(), anyInt(), anyInt())).thenReturn(statsMap);

        // Act
        List<String> result = liveLeaderboardService.getPlayersWithLiveGames(leagueId.toString());

        // Assert
        assertEquals(1, result.size());
        assertEquals(player1Id.toString(), result.get(0));
    }

    @Test
    @DisplayName("getPlayersWithLiveGames should return multiple players with live games")
    void getPlayersWithLiveGamesShouldReturnMultiplePlayersWithLiveGames() {
        // Arrange
        when(leagueRepository.findById(leagueId)).thenReturn(Optional.of(testLeague));
        when(nflLiveDataPort.getGamesInProgress(anyInt(), anyInt())).thenReturn(List.of(gameInProgressId));

        // Update roster2 to also have a player in live game
        List<RosterSlot> slots2 = new ArrayList<>();
        RosterSlot slot2 = new RosterSlot(roster2.getId(), Position.RB, 1);
        slot2.assignPlayer(300L, Position.RB); // NFL player 300 also in live game
        slots2.add(slot2);
        roster2.setSlots(slots2);

        when(rosterRepository.findByLeagueId(leagueId.toString())).thenReturn(List.of(roster1, roster2));

        // Create player stats - both players in live game
        PlayerStats stats100 = new PlayerStats();
        stats100.setNflPlayerId(100L);
        stats100.setNflGameId(gameInProgressId);

        PlayerStats stats300 = new PlayerStats();
        stats300.setNflPlayerId(300L);
        stats300.setNflGameId(gameInProgressId);

        Map<Long, PlayerStats> statsMap = new HashMap<>();
        statsMap.put(100L, stats100);
        statsMap.put(300L, stats300);

        when(nflLiveDataPort.fetchPlayerStats(anyList(), anyInt(), anyInt())).thenReturn(statsMap);

        // Act
        List<String> result = liveLeaderboardService.getPlayersWithLiveGames(leagueId.toString());

        // Assert
        assertEquals(2, result.size());
        assertTrue(result.contains(player1Id.toString()));
        assertTrue(result.contains(player2Id.toString()));
    }

    @Test
    @DisplayName("getPlayersWithLiveGames should return empty list when roster has no filled slots")
    void getPlayersWithLiveGamesShouldReturnEmptyWhenNoFilledSlots() {
        // Arrange
        when(leagueRepository.findById(leagueId)).thenReturn(Optional.of(testLeague));
        when(nflLiveDataPort.getGamesInProgress(anyInt(), anyInt())).thenReturn(List.of(gameInProgressId));

        // Create roster with empty slots
        Roster emptyRoster = new Roster();
        emptyRoster.setLeaguePlayerId(player1Id);
        emptyRoster.setSlots(new ArrayList<>()); // No slots

        when(rosterRepository.findByLeagueId(leagueId.toString())).thenReturn(List.of(emptyRoster));

        // Act
        List<String> result = liveLeaderboardService.getPlayersWithLiveGames(leagueId.toString());

        // Assert
        assertTrue(result.isEmpty());
    }

    @Test
    @DisplayName("getPlayersWithLiveGames should handle null currentWeek gracefully")
    void getPlayersWithLiveGamesShouldHandleNullCurrentWeek() {
        // Arrange
        testLeague.setCurrentWeek(null);
        when(leagueRepository.findById(leagueId)).thenReturn(Optional.of(testLeague));
        when(nflLiveDataPort.getGamesInProgress(eq(0), anyInt())).thenReturn(List.of());

        // Act
        List<String> result = liveLeaderboardService.getPlayersWithLiveGames(leagueId.toString());

        // Assert
        assertTrue(result.isEmpty());
    }
}
