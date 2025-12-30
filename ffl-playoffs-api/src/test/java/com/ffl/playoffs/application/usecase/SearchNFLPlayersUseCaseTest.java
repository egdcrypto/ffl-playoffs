package com.ffl.playoffs.application.usecase;

import com.ffl.playoffs.application.dto.Page;
import com.ffl.playoffs.application.dto.nfl.NFLPlayerDTO;
import com.ffl.playoffs.infrastructure.persistence.mongodb.document.NFLPlayerDocument;
import com.ffl.playoffs.infrastructure.persistence.mongodb.repository.MongoNFLPlayerRepository;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Nested;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import org.springframework.data.domain.PageImpl;
import org.springframework.data.domain.Pageable;

import java.util.Arrays;
import java.util.Collections;
import java.util.List;

import static org.assertj.core.api.Assertions.*;
import static org.mockito.ArgumentMatchers.*;
import static org.mockito.Mockito.*;

/**
 * Unit tests for SearchNFLPlayersUseCase
 */
@ExtendWith(MockitoExtension.class)
@DisplayName("SearchNFLPlayersUseCase")
class SearchNFLPlayersUseCaseTest {

    @Mock
    private MongoNFLPlayerRepository playerRepository;

    private SearchNFLPlayersUseCase useCase;

    @BeforeEach
    void setUp() {
        useCase = new SearchNFLPlayersUseCase(playerRepository);
    }

    @Nested
    @DisplayName("execute - Search by name")
    class ExecuteSearchByName {

        @Test
        @DisplayName("should search players by name")
        void shouldSearchPlayersByName() {
            // Given
            List<NFLPlayerDocument> players = Arrays.asList(
                    createPlayerDocument("14876", "Patrick Mahomes", "QB", "KC"),
                    createPlayerDocument("12345", "Patrick Surtain", "CB", "DEN")
            );
            org.springframework.data.domain.Page<NFLPlayerDocument> page =
                    new PageImpl<>(players, Pageable.unpaged(), 2);

            when(playerRepository.findByNameContainingIgnoreCase(eq("Patrick"), any(Pageable.class)))
                    .thenReturn(page);

            SearchNFLPlayersUseCase.SearchCommand command = SearchNFLPlayersUseCase.SearchCommand.builder()
                    .name("Patrick")
                    .page(0)
                    .size(50)
                    .build();

            // When
            Page<NFLPlayerDTO> result = useCase.execute(command);

            // Then
            assertThat(result.getContent()).hasSize(2);
            assertThat(result.getTotalElements()).isEqualTo(2);
            verify(playerRepository).findByNameContainingIgnoreCase(eq("Patrick"), any(Pageable.class));
        }

        @Test
        @DisplayName("should return empty page when no matches")
        void shouldReturnEmptyPageWhenNoMatches() {
            // Given
            org.springframework.data.domain.Page<NFLPlayerDocument> emptyPage =
                    new PageImpl<>(Collections.emptyList(), Pageable.unpaged(), 0);

            when(playerRepository.findByNameContainingIgnoreCase(eq("XYZ123"), any(Pageable.class)))
                    .thenReturn(emptyPage);

            SearchNFLPlayersUseCase.SearchCommand command = SearchNFLPlayersUseCase.SearchCommand.builder()
                    .name("XYZ123")
                    .build();

            // When
            Page<NFLPlayerDTO> result = useCase.execute(command);

            // Then
            assertThat(result.getContent()).isEmpty();
            assertThat(result.getTotalElements()).isZero();
        }
    }

    @Nested
    @DisplayName("execute - Search by team")
    class ExecuteSearchByTeam {

        @Test
        @DisplayName("should search players by team")
        void shouldSearchPlayersByTeam() {
            // Given
            List<NFLPlayerDocument> players = Arrays.asList(
                    createPlayerDocument("14876", "Patrick Mahomes", "QB", "KC"),
                    createPlayerDocument("22222", "Travis Kelce", "TE", "KC"),
                    createPlayerDocument("33333", "Isiah Pacheco", "RB", "KC")
            );
            org.springframework.data.domain.Page<NFLPlayerDocument> page =
                    new PageImpl<>(players, Pageable.unpaged(), 3);

            when(playerRepository.findByTeam(eq("KC"), any(Pageable.class)))
                    .thenReturn(page);

            SearchNFLPlayersUseCase.SearchCommand command = SearchNFLPlayersUseCase.SearchCommand.builder()
                    .team("KC")
                    .page(0)
                    .size(50)
                    .build();

            // When
            Page<NFLPlayerDTO> result = useCase.execute(command);

            // Then
            assertThat(result.getContent()).hasSize(3);
            assertThat(result.getContent()).allMatch(p -> "KC".equals(p.getTeam()));
        }
    }

    @Nested
    @DisplayName("execute - Search by position")
    class ExecuteSearchByPosition {

        @Test
        @DisplayName("should search players by position")
        void shouldSearchPlayersByPosition() {
            // Given
            List<NFLPlayerDocument> players = Arrays.asList(
                    createPlayerDocument("14876", "Patrick Mahomes", "QB", "KC"),
                    createPlayerDocument("44444", "Josh Allen", "QB", "BUF"),
                    createPlayerDocument("55555", "Lamar Jackson", "QB", "BAL")
            );
            org.springframework.data.domain.Page<NFLPlayerDocument> page =
                    new PageImpl<>(players, Pageable.unpaged(), 3);

            when(playerRepository.findByPosition(eq("QB"), any(Pageable.class)))
                    .thenReturn(page);

            SearchNFLPlayersUseCase.SearchCommand command = SearchNFLPlayersUseCase.SearchCommand.builder()
                    .position("QB")
                    .page(0)
                    .size(50)
                    .build();

            // When
            Page<NFLPlayerDTO> result = useCase.execute(command);

            // Then
            assertThat(result.getContent()).hasSize(3);
            assertThat(result.getContent()).allMatch(p -> "QB".equals(p.getPosition()));
        }
    }

    @Nested
    @DisplayName("execute - Pagination")
    class ExecutePagination {

        @Test
        @DisplayName("should use default page size when not specified")
        void shouldUseDefaultPageSizeWhenNotSpecified() {
            // Given
            org.springframework.data.domain.Page<NFLPlayerDocument> page =
                    new PageImpl<>(Collections.emptyList(), Pageable.unpaged(), 0);

            when(playerRepository.findAll(any(Pageable.class))).thenReturn(page);

            SearchNFLPlayersUseCase.SearchCommand command = new SearchNFLPlayersUseCase.SearchCommand();

            // When
            Page<NFLPlayerDTO> result = useCase.execute(command);

            // Then
            verify(playerRepository).findAll(argThat((Pageable p) -> p.getPageSize() == 50));
        }

        @Test
        @DisplayName("should limit page size to maximum")
        void shouldLimitPageSizeToMaximum() {
            // Given
            org.springframework.data.domain.Page<NFLPlayerDocument> page =
                    new PageImpl<>(Collections.emptyList(), Pageable.unpaged(), 0);

            when(playerRepository.findAll(any(Pageable.class))).thenReturn(page);

            SearchNFLPlayersUseCase.SearchCommand command = SearchNFLPlayersUseCase.SearchCommand.builder()
                    .size(500) // Exceeds max of 100
                    .build();

            // When
            Page<NFLPlayerDTO> result = useCase.execute(command);

            // Then
            verify(playerRepository).findAll(argThat((Pageable p) -> p.getPageSize() == 100));
        }
    }

    @Nested
    @DisplayName("executeWithFilters - Combined filters")
    class ExecuteWithFilters {

        @Test
        @DisplayName("should filter by name, position, and team")
        void shouldFilterByNamePositionAndTeam() {
            // Given
            List<NFLPlayerDocument> teamPlayers = Arrays.asList(
                    createPlayerDocument("14876", "Patrick Mahomes", "QB", "KC"),
                    createPlayerDocument("22222", "Travis Kelce", "TE", "KC"),
                    createPlayerDocument("33333", "Smith-Schuster", "WR", "KC")
            );
            org.springframework.data.domain.Page<NFLPlayerDocument> page =
                    new PageImpl<>(teamPlayers, Pageable.unpaged(), 3);

            when(playerRepository.findByTeam(eq("KC"), any(Pageable.class))).thenReturn(page);

            SearchNFLPlayersUseCase.SearchCommand command = SearchNFLPlayersUseCase.SearchCommand.builder()
                    .name("Smith")
                    .position("WR")
                    .team("KC")
                    .page(0)
                    .size(50)
                    .build();

            // When
            Page<NFLPlayerDTO> result = useCase.executeWithFilters(command);

            // Then
            assertThat(result.getContent()).hasSize(1);
            assertThat(result.getContent().get(0).getName()).contains("Smith");
        }
    }

    @Nested
    @DisplayName("SearchCommand Builder")
    class SearchCommandBuilder {

        @Test
        @DisplayName("should build command with all fields")
        void shouldBuildCommandWithAllFields() {
            // When
            SearchNFLPlayersUseCase.SearchCommand command = SearchNFLPlayersUseCase.SearchCommand.builder()
                    .name("Mahomes")
                    .position("QB")
                    .team("KC")
                    .status("ACTIVE")
                    .page(1)
                    .size(25)
                    .build();

            // Then
            assertThat(command.getName()).isEqualTo("Mahomes");
            assertThat(command.getPosition()).isEqualTo("QB");
            assertThat(command.getTeam()).isEqualTo("KC");
            assertThat(command.getStatus()).isEqualTo("ACTIVE");
            assertThat(command.getPage()).isEqualTo(1);
            assertThat(command.getSize()).isEqualTo(25);
        }
    }

    private NFLPlayerDocument createPlayerDocument(String playerId, String name, String position, String team) {
        return NFLPlayerDocument.builder()
                .playerId(playerId)
                .name(name)
                .firstName(name.split(" ")[0])
                .lastName(name.split(" ").length > 1 ? name.split(" ")[1] : "")
                .position(position)
                .team(team)
                .status("ACTIVE")
                .build();
    }
}
