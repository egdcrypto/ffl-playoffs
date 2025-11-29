"""
Redis Delta Detection Service

Detects changes in NFL data by comparing current state against
previously stored state in Redis. Only returns records that have changed.

Uses Redis with TTL for automatic cleanup of stale data.
"""
import json
import logging
from datetime import datetime
from typing import Any, Dict, List, Optional

import redis

from src.domain.models import (
    GameScoreDelta,
    GameStatus,
    NFLGame,
    PlayerStats,
    PlayerStatsDelta,
)

logger = logging.getLogger(__name__)


class DeltaDetectionService:
    """
    Detects changes in NFL data using Redis for state storage.

    Keys:
    - nfl:player-stats:{player_id}-{week} -> PlayerStats JSON
    - nfl:game-scores:{game_id} -> NFLGame JSON
    """

    def __init__(self, redis_url: str = "redis://localhost:6379", ttl_seconds: int = 86400):
        """
        Initialize the delta detection service.

        Args:
            redis_url: Redis connection URL
            ttl_seconds: Time-to-live for cached state (default: 24 hours)
        """
        self._redis = redis.from_url(redis_url, decode_responses=True)
        self._ttl = ttl_seconds
        self._player_stats_prefix = "nfl:player-stats:"
        self._game_scores_prefix = "nfl:game-scores:"

    def detect_player_deltas(
        self, current_stats: List[PlayerStats]
    ) -> List[PlayerStatsDelta]:
        """
        Compare current stats against previous state and return only deltas.

        Args:
            current_stats: Current player stats from data source

        Returns:
            List of PlayerStatsDelta for changed players only
        """
        deltas = []

        for current in current_stats:
            try:
                key = f"{self._player_stats_prefix}{current.player_id}-{current.week}"
                previous_json = self._redis.get(key)
                previous = json.loads(previous_json) if previous_json else None

                if previous is None or self._has_stats_changed(previous, current):
                    delta = PlayerStatsDelta(
                        player_id=current.player_id,
                        player_name=current.player_name,
                        week=current.week,
                        season=current.season,
                        previous_stats=previous,
                        current_stats=current,
                        timestamp=datetime.utcnow(),
                    )
                    deltas.append(delta)

                    # Update stored state with TTL
                    self._redis.setex(
                        key, self._ttl, json.dumps(current.model_dump())
                    )
            except Exception as e:
                logger.warning(f"Error detecting delta for player {current.player_id}: {e}")
                continue

        logger.info(f"Detected {len(deltas)} player stat changes out of {len(current_stats)} total")
        return deltas

    def detect_game_deltas(self, current_games: List[NFLGame]) -> List[GameScoreDelta]:
        """
        Compare current game scores against previous state and return only deltas.

        Args:
            current_games: Current game data from data source

        Returns:
            List of GameScoreDelta for changed games only
        """
        deltas = []

        for current in current_games:
            try:
                key = f"{self._game_scores_prefix}{current.game_id}"
                previous_json = self._redis.get(key)
                previous = json.loads(previous_json) if previous_json else None

                if previous is None or self._has_score_changed(previous, current):
                    delta = GameScoreDelta(
                        game_id=current.game_id,
                        home_team=current.home_team,
                        away_team=current.away_team,
                        home_score=current.home_score,
                        away_score=current.away_score,
                        status=current.status,
                        quarter=current.quarter,
                        time_remaining=current.time_remaining,
                        timestamp=datetime.utcnow(),
                    )
                    deltas.append(delta)

                    # Update stored state with TTL
                    game_dict = current.model_dump()
                    # Convert enum to string for JSON serialization
                    game_dict["status"] = current.status.value
                    if game_dict.get("game_time"):
                        game_dict["game_time"] = game_dict["game_time"].isoformat()
                    self._redis.setex(key, self._ttl, json.dumps(game_dict))

            except Exception as e:
                logger.warning(f"Error detecting delta for game {current.game_id}: {e}")
                continue

        logger.info(f"Detected {len(deltas)} game score changes out of {len(current_games)} total")
        return deltas

    def _has_stats_changed(self, prev: Dict[str, Any], curr: PlayerStats) -> bool:
        """
        Check if player stats have changed.

        Compares key statistical fields to determine if there's a meaningful change.
        """
        return (
            prev.get("passing_yards") != curr.passing_yards
            or prev.get("rushing_yards") != curr.rushing_yards
            or prev.get("receiving_yards") != curr.receiving_yards
            or prev.get("passing_tds") != curr.passing_tds
            or prev.get("rushing_tds") != curr.rushing_tds
            or prev.get("receiving_tds") != curr.receiving_tds
            or prev.get("receptions") != curr.receptions
            or prev.get("interceptions") != curr.interceptions
            or prev.get("fumbles_lost") != curr.fumbles_lost
        )

    def _has_score_changed(self, prev: Dict[str, Any], curr: NFLGame) -> bool:
        """
        Check if game score has changed.

        Compares score and status to determine if there's a meaningful change.
        """
        return (
            prev.get("home_score") != curr.home_score
            or prev.get("away_score") != curr.away_score
            or prev.get("status") != curr.status.value
            or prev.get("quarter") != curr.quarter
        )

    def clear_cache(self, pattern: Optional[str] = None) -> int:
        """
        Clear cached state from Redis.

        Args:
            pattern: Optional pattern to match keys (default: clear all NFL data)

        Returns:
            Number of keys deleted
        """
        if pattern is None:
            pattern = "nfl:*"

        keys = self._redis.keys(pattern)
        if keys:
            deleted = self._redis.delete(*keys)
            logger.info(f"Cleared {deleted} keys from Redis cache")
            return deleted
        return 0

    def get_cached_stats_count(self) -> int:
        """Get count of cached player stats."""
        return len(self._redis.keys(f"{self._player_stats_prefix}*"))

    def get_cached_games_count(self) -> int:
        """Get count of cached game scores."""
        return len(self._redis.keys(f"{self._game_scores_prefix}*"))

    def close(self):
        """Close Redis connection."""
        self._redis.close()
