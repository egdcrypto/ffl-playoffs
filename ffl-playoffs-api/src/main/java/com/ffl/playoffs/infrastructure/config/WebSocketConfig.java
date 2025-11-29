package com.ffl.playoffs.infrastructure.config;

import com.ffl.playoffs.infrastructure.websocket.NFLDataWebSocketHandler;
import lombok.RequiredArgsConstructor;
import org.springframework.context.annotation.Configuration;
import org.springframework.web.socket.config.annotation.EnableWebSocket;
import org.springframework.web.socket.config.annotation.WebSocketConfigurer;
import org.springframework.web.socket.config.annotation.WebSocketHandlerRegistry;

/**
 * WebSocket configuration for NFL real-time updates
 * Configures the WebSocket endpoint and handler
 */
@Configuration
@EnableWebSocket
@RequiredArgsConstructor
public class WebSocketConfig implements WebSocketConfigurer {

    private final NFLDataWebSocketHandler nflDataWebSocketHandler;

    @Override
    public void registerWebSocketHandlers(WebSocketHandlerRegistry registry) {
        registry.addHandler(nflDataWebSocketHandler, "/ws/nfl-updates")
                .setAllowedOrigins("*");
    }
}
