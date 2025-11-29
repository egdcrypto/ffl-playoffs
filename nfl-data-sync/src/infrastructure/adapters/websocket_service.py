"""
WebSocket Service

Manages WebSocket connections and broadcasts NFL data updates to clients.
Supports subscriptions to specific leagues or players for targeted updates.
"""
import logging
from datetime import datetime
from typing import Dict, List, Set

from fastapi import WebSocket

from src.domain.models import GameScoreDelta, PlayerStatsDelta

logger = logging.getLogger(__name__)


class WebSocketManager:
    """
    Manages WebSocket connections and broadcasts deltas to clients.

    Supports:
    - Global broadcasts (all connected clients)
    - League-specific broadcasts
    - Player-specific broadcasts
    """

    def __init__(self):
        """Initialize the WebSocket manager."""
        self.active_connections: Set[WebSocket] = set()
        self.league_subscriptions: Dict[str, Set[WebSocket]] = {}
        self.player_subscriptions: Dict[str, Set[WebSocket]] = {}

    async def connect(self, websocket: WebSocket):
        """
        Accept a new WebSocket connection.

        Args:
            websocket: The WebSocket to connect
        """
        await websocket.accept()
        self.active_connections.add(websocket)
        logger.info(f"WebSocket connected. Total connections: {len(self.active_connections)}")

    def disconnect(self, websocket: WebSocket):
        """
        Remove a WebSocket connection.

        Args:
            websocket: The WebSocket to disconnect
        """
        self.active_connections.discard(websocket)

        # Clean up subscriptions
        for subs in self.league_subscriptions.values():
            subs.discard(websocket)
        for subs in self.player_subscriptions.values():
            subs.discard(websocket)

        logger.info(f"WebSocket disconnected. Total connections: {len(self.active_connections)}")

    def subscribe_to_league(self, websocket: WebSocket, league_id: str):
        """
        Subscribe to league updates.

        Args:
            websocket: The WebSocket connection
            league_id: The league ID to subscribe to
        """
        if league_id not in self.league_subscriptions:
            self.league_subscriptions[league_id] = set()
        self.league_subscriptions[league_id].add(websocket)
        logger.debug(f"WebSocket subscribed to league {league_id}")

    def subscribe_to_player(self, websocket: WebSocket, player_id: str):
        """
        Subscribe to individual player updates.

        Args:
            websocket: The WebSocket connection
            player_id: The player ID to subscribe to
        """
        if player_id not in self.player_subscriptions:
            self.player_subscriptions[player_id] = set()
        self.player_subscriptions[player_id].add(websocket)
        logger.debug(f"WebSocket subscribed to player {player_id}")

    async def broadcast_player_deltas(self, deltas: List[PlayerStatsDelta]):
        """
        Broadcast player stat deltas to all connected clients.

        Args:
            deltas: List of player stat changes to broadcast
        """
        if not deltas:
            return

        message = {
            "type": "PLAYER_STATS",
            "timestamp": datetime.utcnow().isoformat(),
            "count": len(deltas),
            "deltas": [
                {
                    "player_id": d.player_id,
                    "player_name": d.player_name,
                    "week": d.week,
                    "season": d.season,
                    "fantasy_points": float(d.fantasy_points) if d.fantasy_points else None,
                    "fantasy_points_ppr": float(d.fantasy_points_ppr) if d.fantasy_points_ppr else None,
                    "stats": d.current_stats.model_dump(),
                }
                for d in deltas
            ],
        }

        # Broadcast to all connections
        disconnected = []
        for connection in self.active_connections:
            try:
                await connection.send_json(message)
            except Exception as e:
                logger.warning(f"Error sending to WebSocket: {e}")
                disconnected.append(connection)

        # Clean up disconnected
        for conn in disconnected:
            self.disconnect(conn)

        # Send individual player updates
        for delta in deltas:
            if delta.player_id in self.player_subscriptions:
                player_message = {
                    "type": "PLAYER_UPDATE",
                    "timestamp": datetime.utcnow().isoformat(),
                    "data": {
                        "player_id": delta.player_id,
                        "player_name": delta.player_name,
                        "fantasy_points": float(delta.fantasy_points) if delta.fantasy_points else None,
                        "stats": delta.current_stats.model_dump(),
                    },
                }
                for conn in self.player_subscriptions[delta.player_id].copy():
                    try:
                        await conn.send_json(player_message)
                    except Exception:
                        self.disconnect(conn)

        logger.info(f"Broadcasted {len(deltas)} player stat updates")

    async def broadcast_game_deltas(self, deltas: List[GameScoreDelta]):
        """
        Broadcast game score deltas to all connected clients.

        Args:
            deltas: List of game score changes to broadcast
        """
        if not deltas:
            return

        message = {
            "type": "GAME_SCORES",
            "timestamp": datetime.utcnow().isoformat(),
            "count": len(deltas),
            "deltas": [
                {
                    "game_id": d.game_id,
                    "home_team": d.home_team,
                    "away_team": d.away_team,
                    "home_score": d.home_score,
                    "away_score": d.away_score,
                    "status": d.status.value,
                    "quarter": d.quarter,
                    "time_remaining": d.time_remaining,
                }
                for d in deltas
            ],
        }

        disconnected = []
        for connection in self.active_connections:
            try:
                await connection.send_json(message)
            except Exception as e:
                logger.warning(f"Error sending to WebSocket: {e}")
                disconnected.append(connection)

        for conn in disconnected:
            self.disconnect(conn)

        logger.info(f"Broadcasted {len(deltas)} game score updates")

    async def broadcast_leaderboard(self, league_id: str, leaderboard: List[dict]):
        """
        Broadcast leaderboard update to league subscribers.

        Args:
            league_id: The league ID
            leaderboard: The updated leaderboard data
        """
        if league_id not in self.league_subscriptions:
            return

        message = {
            "type": "LEADERBOARD_UPDATE",
            "league_id": league_id,
            "timestamp": datetime.utcnow().isoformat(),
            "leaderboard": leaderboard,
        }

        disconnected = []
        for conn in self.league_subscriptions[league_id].copy():
            try:
                await conn.send_json(message)
            except Exception:
                disconnected.append(conn)

        for conn in disconnected:
            self.disconnect(conn)

        logger.info(f"Broadcasted leaderboard update for league {league_id}")

    async def broadcast_sync_status(self, status: dict):
        """
        Broadcast sync status to all admin connections.

        Args:
            status: The sync status information
        """
        message = {
            "type": "SYNC_STATUS",
            "timestamp": datetime.utcnow().isoformat(),
            "status": status,
        }

        disconnected = []
        for connection in self.active_connections:
            try:
                await connection.send_json(message)
            except Exception:
                disconnected.append(connection)

        for conn in disconnected:
            self.disconnect(conn)

    def get_connection_count(self) -> int:
        """Get total active connection count."""
        return len(self.active_connections)

    def get_stats(self) -> dict:
        """Get WebSocket manager statistics."""
        return {
            "active_connections": len(self.active_connections),
            "league_subscriptions": len(self.league_subscriptions),
            "player_subscriptions": len(self.player_subscriptions),
        }


# Global singleton instance
ws_manager = WebSocketManager()
