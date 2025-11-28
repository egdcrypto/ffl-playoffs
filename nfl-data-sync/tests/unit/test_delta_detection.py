"""
Delta Detection Service Unit Tests

Tests for Redis-based delta detection functionality.
Uses mocked Redis for isolated testing.
"""
from unittest.mock import MagicMock, patch
import json

import pytest

from src.domain.models import GameStatus, NFLGame, PlayerStats
from src.infrastructure.adapters.redis_delta_service import DeltaDetectionService


class TestDeltaDetectionService:
    """Test suite for DeltaDetectionService."""

    @pytest.fixture
    def mock_redis(self):
        """Create mock Redis client."""
        return MagicMock()

    @pytest.fixture
    def delta_service(self, mock_redis):
        """Create delta service with mocked Redis."""
        with patch('src.infrastructure.adapters.redis_delta_service.redis') as mock_module:
            mock_module.from_url.return_value = mock_redis
            service = DeltaDetectionService(
                redis_url="redis://localhost:6379",
                ttl_seconds=86400
            )
            service._redis = mock_redis
            return service

    def test_detect_new_player_stats(self, delta_service, mock_redis, sample_player_stats):
        """Test detection of new player stats (no previous state)."""
        # No previous state in Redis
        mock_redis.get.return_value = None

        deltas = delta_service.detect_player_deltas([sample_player_stats])

        # Should return the new stats as a delta
        assert len(deltas) == 1
        assert deltas[0].player_id == "12345"
        assert deltas[0].player_name == "Patrick Mahomes"
        assert deltas[0].previous_stats is None
        assert deltas[0].current_stats == sample_player_stats

        # Should have updated Redis
        mock_redis.setex.assert_called_once()

    def test_detect_changed_player_stats(self, delta_service, mock_redis, sample_player_stats):
        """Test detection of changed player stats."""
        # Previous state with different stats
        previous_stats = {
            "player_id": "12345",
            "player_name": "Patrick Mahomes",
            "week": 18,
            "season": 2024,
            "passing_yards": 200,  # Was 200, now 325
            "passing_tds": 1,  # Was 1, now 3
            "interceptions": 0,  # Was 0, now 1
            "rushing_yards": 15,
            "receiving_yards": 0,
            "receiving_tds": 0,
            "receptions": 0,
            "fumbles_lost": 0,
        }
        mock_redis.get.return_value = json.dumps(previous_stats)

        deltas = delta_service.detect_player_deltas([sample_player_stats])

        # Should detect the change
        assert len(deltas) == 1
        assert deltas[0].previous_stats == previous_stats
        assert deltas[0].current_stats.passing_yards == 325

    def test_no_delta_for_unchanged_stats(self, delta_service, mock_redis, sample_player_stats):
        """Test that unchanged stats don't produce a delta."""
        # Previous state exactly matches current
        previous_stats = {
            "player_id": "12345",
            "player_name": "Patrick Mahomes",
            "week": 18,
            "season": 2024,
            "passing_yards": 325,
            "passing_tds": 3,
            "interceptions": 1,
            "rushing_yards": 28,
            "rushing_tds": 0,
            "receiving_yards": 0,
            "receiving_tds": 0,
            "receptions": 0,
            "fumbles_lost": 0,
        }
        mock_redis.get.return_value = json.dumps(previous_stats)

        deltas = delta_service.detect_player_deltas([sample_player_stats])

        # No changes detected
        assert len(deltas) == 0
        # Should not update Redis
        mock_redis.setex.assert_not_called()

    def test_detect_new_game_score(self, delta_service, mock_redis, sample_game):
        """Test detection of new game score."""
        mock_redis.get.return_value = None

        deltas = delta_service.detect_game_deltas([sample_game])

        assert len(deltas) == 1
        assert deltas[0].game_id == "2024_18_KC_BUF"
        assert deltas[0].home_team == "KC"
        assert deltas[0].home_score == 27
        assert deltas[0].away_score == 24

    def test_detect_score_change(self, delta_service, mock_redis, sample_game):
        """Test detection of score change during game."""
        # Previous score
        previous_game = {
            "game_id": "2024_18_KC_BUF",
            "home_team": "KC",
            "away_team": "BUF",
            "home_score": 20,  # Was 20, now 27
            "away_score": 24,
            "status": "IN_PROGRESS",
            "quarter": "Q4",
        }
        mock_redis.get.return_value = json.dumps(previous_game)

        deltas = delta_service.detect_game_deltas([sample_game])

        assert len(deltas) == 1
        assert deltas[0].home_score == 27

    def test_detect_status_change(self, delta_service, mock_redis, sample_game):
        """Test detection of game status change."""
        # Game was in progress, now final
        previous_game = {
            "game_id": "2024_18_KC_BUF",
            "home_team": "KC",
            "away_team": "BUF",
            "home_score": 27,
            "away_score": 24,
            "status": "IN_PROGRESS",  # Was in progress, now FINAL
            "quarter": "Q4",
        }
        mock_redis.get.return_value = json.dumps(previous_game)

        deltas = delta_service.detect_game_deltas([sample_game])

        assert len(deltas) == 1
        assert deltas[0].status == GameStatus.FINAL

    def test_multiple_players(self, delta_service, mock_redis, sample_player_stats, sample_rb_stats):
        """Test delta detection with multiple players."""
        # First player is new, second has no changes
        def get_side_effect(key):
            if "23456" in key:  # RB stats - same as before
                return json.dumps({
                    "player_id": "23456",
                    "rushing_yards": 112,
                    "rushing_tds": 2,
                    "receiving_yards": 45,
                    "receiving_tds": 0,
                    "receptions": 5,
                    "passing_yards": 0,
                    "passing_tds": 0,
                    "interceptions": 0,
                    "fumbles_lost": 0,
                })
            return None  # QB stats - new

        mock_redis.get.side_effect = get_side_effect

        deltas = delta_service.detect_player_deltas([sample_player_stats, sample_rb_stats])

        # Only QB should be in deltas (RB unchanged)
        assert len(deltas) == 1
        assert deltas[0].player_id == "12345"

    def test_clear_cache(self, delta_service, mock_redis):
        """Test cache clearing."""
        mock_redis.keys.return_value = ["nfl:player-stats:123", "nfl:game-scores:456"]
        mock_redis.delete.return_value = 2

        deleted = delta_service.clear_cache()

        assert deleted == 2
        mock_redis.delete.assert_called_once()

    def test_get_cached_counts(self, delta_service, mock_redis):
        """Test getting cached counts."""
        mock_redis.keys.side_effect = [
            ["key1", "key2", "key3"],  # player stats
            ["key4", "key5"],  # games
        ]

        stats_count = delta_service.get_cached_stats_count()
        games_count = delta_service.get_cached_games_count()

        assert stats_count == 3
        assert games_count == 2
