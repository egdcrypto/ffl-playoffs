package com.ffl.playoffs.infrastructure;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.ffl.playoffs.application.dto.GameDTO;
import com.ffl.playoffs.application.dto.PlayerDTO;
import com.ffl.playoffs.application.service.ApplicationService;
import com.ffl.playoffs.infrastructure.adapter.rest.GameController;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Nested;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import org.springframework.http.MediaType;
import org.springframework.test.web.servlet.MockMvc;
import org.springframework.test.web.servlet.setup.MockMvcBuilders;

import java.time.LocalDateTime;

import static org.mockito.ArgumentMatchers.*;
import static org.mockito.Mockito.*;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.post;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.*;

@ExtendWith(MockitoExtension.class)
@DisplayName("GameController Tests")
class GameControllerTest {

    @Mock
    private ApplicationService applicationService;

    @InjectMocks
    private GameController gameController;

    private MockMvc mockMvc;
    private ObjectMapper objectMapper;

    @BeforeEach
    void setUp() {
        mockMvc = MockMvcBuilders.standaloneSetup(gameController).build();
        objectMapper = new ObjectMapper();
    }

    @Nested
    @DisplayName("POST /games - Create Game")
    class CreateGame {

        @Test
        @DisplayName("should create game and return 201 Created")
        void shouldCreateGameSuccessfully() throws Exception {
            // Arrange
            String gameName = "Test Playoff Game";
            String creatorEmail = "creator@example.com";

            GameDTO gameDTO = new GameDTO();
            gameDTO.setId(1L);
            gameDTO.setName(gameName);
            gameDTO.setInviteCode("ABC12345");
            gameDTO.setStatus("PENDING");
            gameDTO.setCurrentWeek(0);

            when(applicationService.createGame(gameName, creatorEmail)).thenReturn(gameDTO);

            // Act & Assert
            mockMvc.perform(post("/games")
                            .contentType(MediaType.APPLICATION_JSON)
                            .content("{\"gameName\":\"" + gameName + "\",\"creatorEmail\":\"" + creatorEmail + "\"}"))
                    .andExpect(status().isCreated())
                    .andExpect(jsonPath("$.id").value(1))
                    .andExpect(jsonPath("$.name").value(gameName))
                    .andExpect(jsonPath("$.inviteCode").value("ABC12345"))
                    .andExpect(jsonPath("$.status").value("PENDING"))
                    .andExpect(jsonPath("$.currentWeek").value(0));

            verify(applicationService).createGame(gameName, creatorEmail);
        }

        @Test
        @DisplayName("should call application service with correct parameters")
        void shouldCallServiceWithCorrectParameters() throws Exception {
            // Arrange
            String gameName = "My Fantasy League";
            String creatorEmail = "admin@fantasy.com";

            GameDTO gameDTO = new GameDTO();
            gameDTO.setId(2L);
            gameDTO.setName(gameName);
            gameDTO.setInviteCode("XYZ98765");
            gameDTO.setStatus("PENDING");

            when(applicationService.createGame(eq(gameName), eq(creatorEmail))).thenReturn(gameDTO);

            // Act
            mockMvc.perform(post("/games")
                    .contentType(MediaType.APPLICATION_JSON)
                    .content("{\"gameName\":\"" + gameName + "\",\"creatorEmail\":\"" + creatorEmail + "\"}"));

            // Assert
            verify(applicationService, times(1)).createGame(gameName, creatorEmail);
        }

        @Test
        @DisplayName("should handle null game name gracefully")
        void shouldHandleNullGameName() throws Exception {
            // Arrange
            String creatorEmail = "creator@example.com";

            GameDTO gameDTO = new GameDTO();
            gameDTO.setId(1L);
            gameDTO.setInviteCode("ABC12345");

            when(applicationService.createGame(isNull(), eq(creatorEmail))).thenReturn(gameDTO);

            // Act & Assert
            mockMvc.perform(post("/games")
                            .contentType(MediaType.APPLICATION_JSON)
                            .content("{\"creatorEmail\":\"" + creatorEmail + "\"}"))
                    .andExpect(status().isCreated());

            verify(applicationService).createGame(null, creatorEmail);
        }
    }

    @Nested
    @DisplayName("POST /games/join - Join Game")
    class JoinGame {

        @Test
        @DisplayName("should join game and return 200 OK")
        void shouldJoinGameSuccessfully() throws Exception {
            // Arrange
            String inviteCode = "ABC12345";
            String email = "player@example.com";
            String displayName = "Player One";
            String googleId = "google-123";

            PlayerDTO playerDTO = new PlayerDTO();
            playerDTO.setId(1L);
            playerDTO.setEmail(email);
            playerDTO.setDisplayName(displayName);

            when(applicationService.invitePlayer(inviteCode, email, displayName, googleId))
                    .thenReturn(playerDTO);

            // Act & Assert
            mockMvc.perform(post("/games/join")
                            .contentType(MediaType.APPLICATION_JSON)
                            .content("{" +
                                    "\"inviteCode\":\"" + inviteCode + "\"," +
                                    "\"email\":\"" + email + "\"," +
                                    "\"displayName\":\"" + displayName + "\"," +
                                    "\"googleId\":\"" + googleId + "\"" +
                                    "}"))
                    .andExpect(status().isOk())
                    .andExpect(content().string("Successfully joined game"));

            verify(applicationService).invitePlayer(inviteCode, email, displayName, googleId);
        }

        @Test
        @DisplayName("should call application service with all parameters")
        void shouldCallServiceWithAllParameters() throws Exception {
            // Arrange
            String inviteCode = "XYZ98765";
            String email = "newplayer@example.com";
            String displayName = "New Player";
            String googleId = "google-456";

            PlayerDTO playerDTO = new PlayerDTO();
            playerDTO.setId(2L);

            when(applicationService.invitePlayer(any(), any(), any(), any())).thenReturn(playerDTO);

            // Act
            mockMvc.perform(post("/games/join")
                    .contentType(MediaType.APPLICATION_JSON)
                    .content("{" +
                            "\"inviteCode\":\"" + inviteCode + "\"," +
                            "\"email\":\"" + email + "\"," +
                            "\"displayName\":\"" + displayName + "\"," +
                            "\"googleId\":\"" + googleId + "\"" +
                            "}"));

            // Assert
            verify(applicationService).invitePlayer(
                    eq(inviteCode),
                    eq(email),
                    eq(displayName),
                    eq(googleId)
            );
        }

        @Test
        @DisplayName("should handle missing optional fields")
        void shouldHandleMissingOptionalFields() throws Exception {
            // Arrange
            String inviteCode = "ABC12345";
            String email = "player@example.com";

            PlayerDTO playerDTO = new PlayerDTO();
            playerDTO.setId(3L);

            when(applicationService.invitePlayer(eq(inviteCode), eq(email), isNull(), isNull()))
                    .thenReturn(playerDTO);

            // Act & Assert
            mockMvc.perform(post("/games/join")
                            .contentType(MediaType.APPLICATION_JSON)
                            .content("{" +
                                    "\"inviteCode\":\"" + inviteCode + "\"," +
                                    "\"email\":\"" + email + "\"" +
                                    "}"))
                    .andExpect(status().isOk());

            verify(applicationService).invitePlayer(inviteCode, email, null, null);
        }

    }
}
