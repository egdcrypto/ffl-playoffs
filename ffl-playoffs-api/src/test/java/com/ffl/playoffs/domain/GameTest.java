package com.ffl.playoffs.domain;

import com.ffl.playoffs.domain.model.Game;
import org.junit.jupiter.api.Test;
import static org.junit.jupiter.api.Assertions.*;

class GameTest {

    @Test
    void shouldCreateGameWithValidParameters() {
        // Given
        String id = "game-123";
        String name = "Test Game";
        String adminId = "admin-123";

        // When
        Game game = new Game(id, name, adminId);

        // Then
        assertNotNull(game);
        assertEquals(id, game.getId());
        assertEquals(name, game.getName());
        assertEquals(adminId, game.getAdminId());
        assertEquals(Game.GameStatus.CREATED, game.getStatus());
    }
}
