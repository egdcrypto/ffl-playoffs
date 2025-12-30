package com.ffl.playoffs.application.usecase;

import com.ffl.playoffs.domain.aggregate.League;
import com.ffl.playoffs.domain.model.LeagueStatus;
import com.ffl.playoffs.domain.port.LeagueRepository;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;

import java.time.LocalDateTime;
import java.util.Arrays;
import java.util.List;
import java.util.UUID;

import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.Mockito.when;

@ExtendWith(MockitoExtension.class)
@DisplayName("ListAllLeaguesUseCase Tests")
class ListAllLeaguesUseCaseTest {

    @Mock
    private LeagueRepository leagueRepository;

    private ListAllLeaguesUseCase listAllLeaguesUseCase;

    @BeforeEach
    void setUp() {
        listAllLeaguesUseCase = new ListAllLeaguesUseCase(leagueRepository);
    }

    @Test
    @DisplayName("should return paginated list of all leagues")
    void shouldReturnPaginatedListOfLeagues() {
        // Arrange
        League league1 = createLeague("League One", "L1");
        League league2 = createLeague("League Two", "L2");
        League league3 = createLeague("League Three", "L3");

        when(leagueRepository.findAll()).thenReturn(Arrays.asList(league1, league2, league3));

        ListAllLeaguesUseCase.ListAllLeaguesCommand command = new ListAllLeaguesUseCase.ListAllLeaguesCommand(0, 10);

        // Act
        ListAllLeaguesUseCase.ListAllLeaguesResult result = listAllLeaguesUseCase.execute(command);

        // Assert
        assertNotNull(result);
        assertEquals(3, result.getLeagues().size());
        assertEquals(0, result.getPage());
        assertEquals(10, result.getSize());
        assertEquals(3, result.getTotalElements());
        assertEquals(1, result.getTotalPages());
        assertFalse(result.isHasNext());
        assertFalse(result.isHasPrevious());
    }

    @Test
    @DisplayName("should return empty list when no leagues exist")
    void shouldReturnEmptyListWhenNoLeagues() {
        // Arrange
        when(leagueRepository.findAll()).thenReturn(List.of());

        ListAllLeaguesUseCase.ListAllLeaguesCommand command = new ListAllLeaguesUseCase.ListAllLeaguesCommand(0, 10);

        // Act
        ListAllLeaguesUseCase.ListAllLeaguesResult result = listAllLeaguesUseCase.execute(command);

        // Assert
        assertNotNull(result);
        assertEquals(0, result.getLeagues().size());
        assertEquals(0, result.getTotalElements());
    }

    @Test
    @DisplayName("should handle pagination correctly")
    void shouldHandlePaginationCorrectly() {
        // Arrange
        League league1 = createLeague("League One", "L1");
        League league2 = createLeague("League Two", "L2");
        League league3 = createLeague("League Three", "L3");

        when(leagueRepository.findAll()).thenReturn(Arrays.asList(league1, league2, league3));

        ListAllLeaguesUseCase.ListAllLeaguesCommand command = new ListAllLeaguesUseCase.ListAllLeaguesCommand(0, 2);

        // Act
        ListAllLeaguesUseCase.ListAllLeaguesResult result = listAllLeaguesUseCase.execute(command);

        // Assert
        assertNotNull(result);
        assertEquals(2, result.getLeagues().size());
        assertEquals(3, result.getTotalElements());
        assertEquals(2, result.getTotalPages());
        assertTrue(result.isHasNext());
        assertFalse(result.isHasPrevious());
    }

    @Test
    @DisplayName("should return second page correctly")
    void shouldReturnSecondPageCorrectly() {
        // Arrange
        League league1 = createLeague("League One", "L1");
        League league2 = createLeague("League Two", "L2");
        League league3 = createLeague("League Three", "L3");

        when(leagueRepository.findAll()).thenReturn(Arrays.asList(league1, league2, league3));

        ListAllLeaguesUseCase.ListAllLeaguesCommand command = new ListAllLeaguesUseCase.ListAllLeaguesCommand(1, 2);

        // Act
        ListAllLeaguesUseCase.ListAllLeaguesResult result = listAllLeaguesUseCase.execute(command);

        // Assert
        assertNotNull(result);
        assertEquals(1, result.getLeagues().size());
        assertEquals(1, result.getPage());
        assertFalse(result.isHasNext());
        assertTrue(result.isHasPrevious());
    }

    @Test
    @DisplayName("should return empty list for out of range page")
    void shouldReturnEmptyListForOutOfRangePage() {
        // Arrange
        League league1 = createLeague("League One", "L1");

        when(leagueRepository.findAll()).thenReturn(List.of(league1));

        ListAllLeaguesUseCase.ListAllLeaguesCommand command = new ListAllLeaguesUseCase.ListAllLeaguesCommand(10, 10);

        // Act
        ListAllLeaguesUseCase.ListAllLeaguesResult result = listAllLeaguesUseCase.execute(command);

        // Assert
        assertNotNull(result);
        assertEquals(0, result.getLeagues().size());
    }

    @Test
    @DisplayName("should include league summary with all fields")
    void shouldIncludeLeagueSummaryWithAllFields() {
        // Arrange
        League league = createLeague("Test League", "TEST");
        league.setStatus(LeagueStatus.ACTIVE);
        league.setCurrentWeek(2);
        league.setNumberOfWeeks(4);

        when(leagueRepository.findAll()).thenReturn(List.of(league));

        ListAllLeaguesUseCase.ListAllLeaguesCommand command = new ListAllLeaguesUseCase.ListAllLeaguesCommand(0, 10);

        // Act
        ListAllLeaguesUseCase.ListAllLeaguesResult result = listAllLeaguesUseCase.execute(command);

        // Assert
        assertNotNull(result);
        assertEquals(1, result.getLeagues().size());

        ListAllLeaguesUseCase.LeagueSummary summary = result.getLeagues().get(0);
        assertNotNull(summary.getId());
        assertEquals("Test League", summary.getName());
        assertEquals("TEST", summary.getCode());
        assertNotNull(summary.getOwnerId());
        assertEquals("ACTIVE", summary.getStatus());
        assertNotNull(summary.getCreatedAt());
        assertEquals(2, summary.getCurrentWeek());
        assertEquals(4, summary.getNumberOfWeeks());
    }

    @Test
    @DisplayName("should cap size at 100")
    void shouldCapSizeAt100() {
        // Arrange
        when(leagueRepository.findAll()).thenReturn(List.of());

        ListAllLeaguesUseCase.ListAllLeaguesCommand command = new ListAllLeaguesUseCase.ListAllLeaguesCommand(0, 200);

        // Act
        ListAllLeaguesUseCase.ListAllLeaguesResult result = listAllLeaguesUseCase.execute(command);

        // Assert
        assertEquals(100, result.getSize());
    }

    @Test
    @DisplayName("should handle negative page number")
    void shouldHandleNegativePageNumber() {
        // Arrange
        when(leagueRepository.findAll()).thenReturn(List.of());

        ListAllLeaguesUseCase.ListAllLeaguesCommand command = new ListAllLeaguesUseCase.ListAllLeaguesCommand(-1, 10);

        // Act
        ListAllLeaguesUseCase.ListAllLeaguesResult result = listAllLeaguesUseCase.execute(command);

        // Assert
        assertEquals(0, result.getPage());
    }

    private League createLeague(String name, String code) {
        League league = new League();
        league.setId(UUID.randomUUID());
        league.setName(name);
        league.setCode(code);
        league.setOwnerId(UUID.randomUUID());
        league.setCreatedAt(LocalDateTime.now());
        league.setStatus(LeagueStatus.DRAFT);
        return league;
    }
}
