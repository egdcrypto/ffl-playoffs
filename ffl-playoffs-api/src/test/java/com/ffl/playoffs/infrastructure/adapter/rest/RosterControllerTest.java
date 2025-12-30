package com.ffl.playoffs.infrastructure.adapter.rest;

import com.ffl.playoffs.application.dto.RosterDTO;
import com.ffl.playoffs.application.usecase.BuildRosterUseCase;
import com.ffl.playoffs.application.usecase.LockRosterUseCase;
import com.ffl.playoffs.application.usecase.ValidateRosterUseCase;
import com.ffl.playoffs.domain.aggregate.Roster;
import com.ffl.playoffs.domain.model.Position;
import com.ffl.playoffs.domain.model.RosterSlot;
import com.ffl.playoffs.domain.port.RosterRepository;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;

import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;
import java.util.Optional;
import java.util.UUID;

import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.Mockito.*;

@ExtendWith(MockitoExtension.class)
@DisplayName("RosterController Tests")
class RosterControllerTest {

    @Mock
    private BuildRosterUseCase buildRosterUseCase;

    @Mock
    private LockRosterUseCase lockRosterUseCase;

    @Mock
    private ValidateRosterUseCase validateRosterUseCase;

    @Mock
    private RosterRepository rosterRepository;

    @InjectMocks
    private RosterController rosterController;

    private UUID rosterId;
    private UUID leagueId;
    private UUID leaguePlayerId;
    private Roster testRoster;

    @BeforeEach
    void setUp() {
        rosterId = UUID.randomUUID();
        leagueId = UUID.randomUUID();
        leaguePlayerId = UUID.randomUUID();

        testRoster = new Roster();
        testRoster.setId(rosterId);
        testRoster.setLeaguePlayerId(leaguePlayerId);
        testRoster.setGameId(leagueId);
        testRoster.setLocked(false);
        testRoster.setCreatedAt(LocalDateTime.now());
        testRoster.setUpdatedAt(LocalDateTime.now());

        // Add some roster slots
        List<RosterSlot> slots = new ArrayList<>();
        RosterSlot qbSlot = new RosterSlot(rosterId, Position.QB, 1);
        qbSlot.assignPlayer(100L, Position.QB);
        slots.add(qbSlot);

        RosterSlot rbSlot = new RosterSlot(rosterId, Position.RB, 1);
        slots.add(rbSlot); // Empty slot

        testRoster.setSlots(slots);
    }

    @Test
    @DisplayName("getRoster should return roster when found")
    void getRosterShouldReturnRosterWhenFound() {
        // Arrange
        when(rosterRepository.findById(rosterId)).thenReturn(Optional.of(testRoster));

        // Act
        ResponseEntity<RosterDTO> response = rosterController.getRoster(rosterId);

        // Assert
        assertEquals(HttpStatus.OK, response.getStatusCode());
        assertNotNull(response.getBody());
        assertEquals(rosterId, response.getBody().getId());
        assertEquals(leaguePlayerId, response.getBody().getLeaguePlayerId());
        assertEquals(leagueId, response.getBody().getLeagueId());
    }

    @Test
    @DisplayName("getRoster should return 404 when not found")
    void getRosterShouldReturn404WhenNotFound() {
        // Arrange
        when(rosterRepository.findById(rosterId)).thenReturn(Optional.empty());

        // Act
        ResponseEntity<RosterDTO> response = rosterController.getRoster(rosterId);

        // Assert
        assertEquals(HttpStatus.NOT_FOUND, response.getStatusCode());
    }

    @Test
    @DisplayName("getRostersByLeague should return all rosters in league")
    void getRostersByLeagueShouldReturnAllRosters() {
        // Arrange
        Roster roster2 = new Roster();
        roster2.setId(UUID.randomUUID());
        roster2.setGameId(leagueId);
        roster2.setLeaguePlayerId(UUID.randomUUID());

        when(rosterRepository.findByLeagueId(leagueId.toString()))
                .thenReturn(List.of(testRoster, roster2));

        // Act
        ResponseEntity<List<RosterDTO>> response = rosterController.getRostersByLeague(leagueId);

        // Assert
        assertEquals(HttpStatus.OK, response.getStatusCode());
        assertNotNull(response.getBody());
        assertEquals(2, response.getBody().size());
    }

    @Test
    @DisplayName("getRostersByLeague should return empty list when no rosters")
    void getRostersByLeagueShouldReturnEmptyList() {
        // Arrange
        when(rosterRepository.findByLeagueId(leagueId.toString())).thenReturn(List.of());

        // Act
        ResponseEntity<List<RosterDTO>> response = rosterController.getRostersByLeague(leagueId);

        // Assert
        assertEquals(HttpStatus.OK, response.getStatusCode());
        assertNotNull(response.getBody());
        assertTrue(response.getBody().isEmpty());
    }

    @Test
    @DisplayName("lockRoster should lock and return roster")
    void lockRosterShouldLockAndReturnRoster() {
        // Arrange
        LockRosterUseCase.LockRosterResult lockResult = mock(LockRosterUseCase.LockRosterResult.class);
        when(lockResult.getRosterId()).thenReturn(rosterId);

        testRoster.setLocked(true);
        testRoster.setLockedAt(LocalDateTime.now());

        when(lockRosterUseCase.execute(any())).thenReturn(lockResult);
        when(rosterRepository.findById(rosterId)).thenReturn(Optional.of(testRoster));

        // Act
        ResponseEntity<RosterDTO> response = rosterController.lockRoster(rosterId);

        // Assert
        assertEquals(HttpStatus.OK, response.getStatusCode());
        assertNotNull(response.getBody());
        assertTrue(response.getBody().getIsLocked());
    }

    @Test
    @DisplayName("getRoster should map roster slots correctly")
    void getRosterShouldMapRosterSlotsCorrectly() {
        // Arrange
        when(rosterRepository.findById(rosterId)).thenReturn(Optional.of(testRoster));

        // Act
        ResponseEntity<RosterDTO> response = rosterController.getRoster(rosterId);

        // Assert
        assertEquals(HttpStatus.OK, response.getStatusCode());
        assertNotNull(response.getBody());
        assertNotNull(response.getBody().getSlots());
        assertEquals(2, response.getBody().getSlots().size());

        // Verify slot mapping
        var slots = response.getBody().getSlots();
        assertTrue(slots.stream().anyMatch(s -> "QB".equals(s.getPosition())));
        assertTrue(slots.stream().anyMatch(s -> "RB".equals(s.getPosition())));
    }

    @Test
    @DisplayName("getRosterByLeaguePlayer should return roster when found")
    void getRosterByLeaguePlayerShouldReturnRosterWhenFound() {
        // Arrange
        when(rosterRepository.findByLeaguePlayerId(leaguePlayerId))
                .thenReturn(Optional.of(testRoster));

        // Act
        ResponseEntity<RosterDTO> response = rosterController.getRosterByLeaguePlayer(leagueId, leaguePlayerId);

        // Assert
        assertEquals(HttpStatus.OK, response.getStatusCode());
        assertNotNull(response.getBody());
        assertEquals(leaguePlayerId, response.getBody().getLeaguePlayerId());
    }
}
