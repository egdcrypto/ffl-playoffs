package com.ffl.playoffs.infrastructure.config;

import com.ffl.playoffs.infrastructure.websocket.LiveScoreWebSocketHandler;
import com.ffl.playoffs.infrastructure.websocket.NFLDataWebSocketHandler;
import lombok.RequiredArgsConstructor;
import org.springframework.context.annotation.Configuration;
import org.springframework.web.socket.config.annotation.EnableWebSocket;
import org.springframework.web.socket.config.annotation.WebSocketConfigurer;
import org.springframework.web.socket.config.annotation.WebSocketHandlerRegistry;

/**
 * WebSocket configuration for NFL real-time updates and live scoring
 * Configures WebSocket endpoints and handlers
 */
@Configuration
@EnableWebSocket
@RequiredArgsConstructor
public class WebSocketConfig implements WebSocketConfigurer {

    private final NFLDataWebSocketHandler nflDataWebSocketHandler;
    private final LiveScoreWebSocketHandler liveScoreWebSocketHandler;

    @Override
    public void registerWebSocketHandlers(WebSocketHandlerRegistry registry) {
        // Existing NFL updates endpoint
        registry.addHandler(nflDataWebSocketHandler, "/ws/nfl-updates")
                .setAllowedOrigins("*");

        // New live scores endpoint
        registry.addHandler(liveScoreWebSocketHandler, "/ws/live-scores")
                .setAllowedOrigins("*");
    }
}
