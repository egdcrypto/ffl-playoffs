package com.ffl.playoffs.application.usecase;

import com.ffl.playoffs.application.dto.nfl.NFLPlayerDTO;
import com.ffl.playoffs.infrastructure.adapter.integration.sportsdataio.SportsDataIoFantasyClient;
import com.ffl.playoffs.infrastructure.adapter.integration.sportsdataio.SportsDataIoMapper;
import com.ffl.playoffs.infrastructure.adapter.integration.sportsdataio.dto.SportsDataIoPlayerResponse;
import com.ffl.playoffs.infrastructure.persistence.mongodb.document.NFLPlayerDocument;
import com.ffl.playoffs.infrastructure.persistence.mongodb.repository.MongoNFLPlayerRepository;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Nested;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;

import java.util.Optional;

import static org.assertj.core.api.Assertions.*;
import static org.mockito.ArgumentMatchers.*;
import static org.mockito.Mockito.*;

/**
 * Unit tests for GetNFLPlayerByIdUseCase
 */
@ExtendWith(MockitoExtension.class)
@DisplayName("GetNFLPlayerByIdUseCase")
class GetNFLPlayerByIdUseCaseTest {

    @Mock
    private MongoNFLPlayerRepository playerRepository;

    @Mock
    private SportsDataIoFantasyClient sportsDataClient;

    @Mock
    private SportsDataIoMapper mapper;

    private GetNFLPlayerByIdUseCase useCase;

    @BeforeEach
    void setUp() {
        useCase = new GetNFLPlayerByIdUseCase(playerRepository, sportsDataClient, mapper);
    }

    @Nested
    @DisplayName("execute")
    class Execute {

        @Test
        @DisplayName("should return player from cache when found")
        void shouldReturnPlayerFromCache() {
            // Given
            String playerId = "14876";
            NFLPlayerDocument cachedPlayer = createPlayerDocument(playerId, "Patrick Mahomes", "QB", "KC");
            when(playerRepository.findByPlayerId(playerId)).thenReturn(Optional.of(cachedPlayer));

            // When
            Optional<NFLPlayerDTO> result = useCase.execute(playerId);

            // Then
            assertThat(result).isPresent();
            assertThat(result.get().getPlayerId()).isEqualTo(playerId);
            assertThat(result.get().getName()).isEqualTo("Patrick Mahomes");
            assertThat(result.get().getPosition()).isEqualTo("QB");
            assertThat(result.get().getTeam()).isEqualTo("KC");

            verify(playerRepository).findByPlayerId(playerId);
            verifyNoInteractions(sportsDataClient);
        }

        @Test
        @DisplayName("should fetch from API when not in cache")
        void shouldFetchFromApiWhenNotInCache() {
            // Given
            String playerId = "14876";
            when(playerRepository.findByPlayerId(playerId)).thenReturn(Optional.empty());

            SportsDataIoPlayerResponse apiResponse = createApiResponse(14876L, "Patrick Mahomes", "QB", "KC");
            when(sportsDataClient.getPlayer(14876L)).thenReturn(apiResponse);

            NFLPlayerDocument document = createPlayerDocument(playerId, "Patrick Mahomes", "QB", "KC");
            when(mapper.toDocument(apiResponse)).thenReturn(document);
            when(playerRepository.save(any(NFLPlayerDocument.class))).thenReturn(document);

            // When
            Optional<NFLPlayerDTO> result = useCase.execute(playerId);

            // Then
            assertThat(result).isPresent();
            assertThat(result.get().getName()).isEqualTo("Patrick Mahomes");

            verify(playerRepository).findByPlayerId(playerId);
            verify(sportsDataClient).getPlayer(14876L);
            verify(mapper).toDocument(apiResponse);
            verify(playerRepository).save(document);
        }

        @Test
        @DisplayName("should return empty when player not found in API")
        void shouldReturnEmptyWhenPlayerNotFoundInApi() {
            // Given
            String playerId = "999999";
            when(playerRepository.findByPlayerId(playerId)).thenReturn(Optional.empty());
            when(sportsDataClient.getPlayer(999999L)).thenReturn(null);

            // When
            Optional<NFLPlayerDTO> result = useCase.execute(playerId);

            // Then
            assertThat(result).isEmpty();
            verify(sportsDataClient).getPlayer(999999L);
            verify(playerRepository, never()).save(any());
        }

        @Test
        @DisplayName("should throw exception for null player ID")
        void shouldThrowExceptionForNullPlayerId() {
            // When/Then
            assertThatThrownBy(() -> useCase.execute(null))
                    .isInstanceOf(IllegalArgumentException.class)
                    .hasMessageContaining("INVALID_PLAYER_ID");
        }

        @Test
        @DisplayName("should throw exception for empty player ID")
        void shouldThrowExceptionForEmptyPlayerId() {
            // When/Then
            assertThatThrownBy(() -> useCase.execute(""))
                    .isInstanceOf(IllegalArgumentException.class)
                    .hasMessageContaining("INVALID_PLAYER_ID");
        }

        @Test
        @DisplayName("should throw exception for non-numeric player ID")
        void shouldThrowExceptionForNonNumericPlayerId() {
            // Given
            String playerId = "abc";
            when(playerRepository.findByPlayerId(playerId)).thenReturn(Optional.empty());

            // When/Then
            assertThatThrownBy(() -> useCase.execute(playerId))
                    .isInstanceOf(IllegalArgumentException.class)
                    .hasMessageContaining("INVALID_PLAYER_ID");
        }
    }

    @Nested
    @DisplayName("executeWithRefresh")
    class ExecuteWithRefresh {

        @Test
        @DisplayName("should fetch from API and update existing document")
        void shouldFetchFromApiAndUpdateExisting() {
            // Given
            String playerId = "14876";
            NFLPlayerDocument existingDoc = createPlayerDocument(playerId, "Patrick Mahomes", "QB", "KC");
            existingDoc.setId("mongo-id-123");

            SportsDataIoPlayerResponse apiResponse = createApiResponse(14876L, "Patrick Mahomes II", "QB", "KC");
            NFLPlayerDocument newDoc = createPlayerDocument(playerId, "Patrick Mahomes II", "QB", "KC");

            when(sportsDataClient.getPlayer(14876L)).thenReturn(apiResponse);
            when(mapper.toDocument(apiResponse)).thenReturn(newDoc);
            when(playerRepository.findByPlayerId(playerId)).thenReturn(Optional.of(existingDoc));
            when(playerRepository.save(any(NFLPlayerDocument.class))).thenReturn(newDoc);

            // When
            Optional<NFLPlayerDTO> result = useCase.executeWithRefresh(playerId);

            // Then
            assertThat(result).isPresent();
            assertThat(result.get().getName()).isEqualTo("Patrick Mahomes II");

            verify(sportsDataClient).getPlayer(14876L);
            verify(playerRepository).save(argThat(doc -> doc.getId().equals("mongo-id-123")));
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

    private SportsDataIoPlayerResponse createApiResponse(Long playerId, String name, String position, String team) {
        SportsDataIoPlayerResponse response = new SportsDataIoPlayerResponse();
        response.setPlayerID(playerId);
        response.setName(name);
        String[] nameParts = name.split(" ");
        response.setFirstName(nameParts[0]);
        response.setLastName(nameParts.length > 1 ? nameParts[1] : "");
        response.setPosition(position);
        response.setTeam(team);
        response.setStatus("Active");
        return response;
    }
}
