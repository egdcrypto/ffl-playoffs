package com.ffl.playoffs.domain.port;

import com.ffl.playoffs.domain.event.GameCompletedEvent;
import com.ffl.playoffs.domain.event.LeaderboardRankChangedEvent;
import com.ffl.playoffs.domain.event.PlayerStatsUpdatedEvent;
import com.ffl.playoffs.domain.event.RosterScoreChangedEvent;

import java.util.List;
import java.util.Map;

/**
 * Port for broadcasting live score updates via WebSocket
 * Infrastructure adapter handles actual WebSocket communication
 */
public interface LiveScoreBroadcastPort {

    /**
     * Broadcast a score update to a specific player's subscribed clients
     * @param event the roster score changed event
     */
    void broadcastScoreUpdate(RosterScoreChangedEvent event);

    /**
     * Broadcast a position-level score update
     * @param leaguePlayerId the league player ID
     * @param event the player stats update event
     */
    void broadcastPositionUpdate(String leaguePlayerId, PlayerStatsUpdatedEvent event);

    /**
     * Broadcast rank changes to affected players
     * @param event the leaderboard rank changed event
     */
    void broadcastRankChanges(LeaderboardRankChangedEvent event);

    /**
     * Broadcast game completion to all subscribers
     * @param event the game completed event
     */
    void broadcastGameCompleted(GameCompletedEvent event);

    /**
     * Broadcast updated leaderboard to all league members
     * @param leagueId the league ID
     * @param leaderboard the updated leaderboard data
     */
    void broadcastLeaderboard(String leagueId, List<Map<String, Object>> leaderboard);

    /**
     * Send a data delay warning to all connected clients
     * @param leagueId the league ID
     * @param message the delay message
     * @param delaySeconds estimated delay in seconds
     */
    void broadcastDataDelayWarning(String leagueId, String message, int delaySeconds);

    /**
     * Get the number of active connections for a league
     * @param leagueId the league ID
     * @return the connection count
     */
    int getActiveConnectionCount(String leagueId);

    /**
     * Check if a specific player is currently connected
     * @param leaguePlayerId the league player ID
     * @return true if connected
     */
    boolean isPlayerConnected(String leaguePlayerId);
}
