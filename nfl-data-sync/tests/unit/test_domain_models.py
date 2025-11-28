"""
Domain Models Unit Tests

Tests for Pydantic domain models and their validation.
"""
from datetime import datetime
from decimal import Decimal

import pytest

from src.domain.models import (
    GameScoreDelta,
    GameStatus,
    NFLGame,
    NFLPlayer,
    PlayerStats,
    PlayerStatsDelta,
    SyncJob,
    SyncJobStatus,
    SyncJobType,
)


class TestPlayerStats:
    """Test suite for PlayerStats model."""

    def test_create_player_stats(self):
        """Test creating PlayerStats with required fields."""
        stats = PlayerStats(
            player_id="12345",
            player_name="Test Player",
            week=1,
            season=2024,
        )

        assert stats.player_id == "12345"
        assert stats.player_name == "Test Player"
        assert stats.week == 1
        assert stats.season == 2024
        # Defaults
        assert stats.passing_yards == 0
        assert stats.passing_tds == 0

    def test_player_stats_defaults(self):
        """Test that all stat fields default to zero."""
        stats = PlayerStats(
            player_id="test",
            player_name="Test",
            week=1,
            season=2024,
        )

        assert stats.interceptions == 0
        assert stats.rushing_yards == 0
        assert stats.rushing_tds == 0
        assert stats.receptions == 0
        assert stats.receiving_yards == 0
        assert stats.fumbles_lost == 0

    def test_player_stats_with_all_fields(self):
        """Test creating PlayerStats with all fields populated."""
        stats = PlayerStats(
            player_id="12345",
            player_name="Complete Player",
            week=18,
            season=2024,
            team="KC",
            position="QB",
            passing_yards=300,
            passing_tds=3,
            interceptions=1,
            rushing_yards=50,
            rushing_tds=1,
            receptions=0,
            receiving_yards=0,
            receiving_tds=0,
            fumbles_lost=1,
        )

        assert stats.passing_yards == 300
        assert stats.team == "KC"
        assert stats.position == "QB"


class TestNFLGame:
    """Test suite for NFLGame model."""

    def test_create_game(self):
        """Test creating NFLGame with required fields."""
        game = NFLGame(
            game_id="2024_01_KC_BUF",
            season=2024,
            week=1,
            home_team="KC",
            away_team="BUF",
        )

        assert game.game_id == "2024_01_KC_BUF"
        assert game.home_team == "KC"
        assert game.away_team == "BUF"
        assert game.status == GameStatus.SCHEDULED  # Default

    def test_game_with_scores(self):
        """Test game with final scores."""
        game = NFLGame(
            game_id="2024_01_KC_BUF",
            season=2024,
            week=1,
            home_team="KC",
            away_team="BUF",
            home_score=27,
            away_score=24,
            status=GameStatus.FINAL,
        )

        assert game.home_score == 27
        assert game.away_score == 24
        assert game.status == GameStatus.FINAL

    def test_game_status_enum(self):
        """Test all GameStatus enum values."""
        assert GameStatus.SCHEDULED.value == "SCHEDULED"
        assert GameStatus.IN_PROGRESS.value == "IN_PROGRESS"
        assert GameStatus.HALFTIME.value == "HALFTIME"
        assert GameStatus.FINAL.value == "FINAL"
        assert GameStatus.POSTPONED.value == "POSTPONED"
        assert GameStatus.CANCELLED.value == "CANCELLED"


class TestNFLPlayer:
    """Test suite for NFLPlayer model."""

    def test_create_player(self):
        """Test creating NFLPlayer."""
        player = NFLPlayer(
            player_id="12345",
            name="Patrick Mahomes",
            position="QB",
            team="KC",
        )

        assert player.player_id == "12345"
        assert player.name == "Patrick Mahomes"
        assert player.status == "ACTIVE"  # Default

    def test_player_with_full_details(self):
        """Test player with all details."""
        player = NFLPlayer(
            player_id="12345",
            name="Patrick Mahomes",
            first_name="Patrick",
            last_name="Mahomes",
            position="QB",
            team="KC",
            jersey_number=15,
            status="ACTIVE",
        )

        assert player.first_name == "Patrick"
        assert player.last_name == "Mahomes"
        assert player.jersey_number == 15


class TestPlayerStatsDelta:
    """Test suite for PlayerStatsDelta model."""

    def test_create_delta(self, sample_player_stats):
        """Test creating a delta."""
        delta = PlayerStatsDelta(
            player_id="12345",
            player_name="Patrick Mahomes",
            week=18,
            season=2024,
            previous_stats=None,
            current_stats=sample_player_stats,
        )

        assert delta.player_id == "12345"
        assert delta.previous_stats is None
        assert delta.current_stats == sample_player_stats
        assert delta.fantasy_points is None

    def test_delta_with_fantasy_points(self, sample_player_stats):
        """Test delta with calculated fantasy points."""
        delta = PlayerStatsDelta(
            player_id="12345",
            player_name="Patrick Mahomes",
            week=18,
            season=2024,
            current_stats=sample_player_stats,
            fantasy_points=Decimal("23.80"),
            fantasy_points_ppr=Decimal("23.80"),
            fantasy_points_half_ppr=Decimal("23.80"),
        )

        assert delta.fantasy_points == Decimal("23.80")

    def test_delta_timestamp_auto_set(self, sample_player_stats):
        """Test that timestamp is automatically set."""
        delta = PlayerStatsDelta(
            player_id="12345",
            player_name="Test",
            week=1,
            season=2024,
            current_stats=sample_player_stats,
        )

        assert delta.timestamp is not None
        assert isinstance(delta.timestamp, datetime)


class TestGameScoreDelta:
    """Test suite for GameScoreDelta model."""

    def test_create_game_delta(self):
        """Test creating a game score delta."""
        delta = GameScoreDelta(
            game_id="2024_18_KC_BUF",
            home_team="KC",
            away_team="BUF",
            home_score=27,
            away_score=24,
            status=GameStatus.FINAL,
        )

        assert delta.game_id == "2024_18_KC_BUF"
        assert delta.home_score == 27
        assert delta.status == GameStatus.FINAL


class TestSyncJob:
    """Test suite for SyncJob model."""

    def test_create_sync_job(self):
        """Test creating a sync job."""
        job = SyncJob(
            job_id="job-123",
            job_type=SyncJobType.PLAYERS,
        )

        assert job.job_id == "job-123"
        assert job.job_type == SyncJobType.PLAYERS
        assert job.status == SyncJobStatus.PENDING

    def test_sync_job_completion(self):
        """Test sync job with completion details."""
        now = datetime.utcnow()
        job = SyncJob(
            job_id="job-123",
            job_type=SyncJobType.LIVE_SCORES,
            status=SyncJobStatus.COMPLETED,
            started_at=now,
            completed_at=now,
            records_processed=100,
            records_updated=15,
        )

        assert job.status == SyncJobStatus.COMPLETED
        assert job.records_processed == 100
        assert job.records_updated == 15

    def test_sync_job_types(self):
        """Test all SyncJobType enum values."""
        assert SyncJobType.PLAYERS.value == "PLAYERS"
        assert SyncJobType.SCHEDULES.value == "SCHEDULES"
        assert SyncJobType.LIVE_SCORES.value == "LIVE_SCORES"
        assert SyncJobType.PLAYER_STATS.value == "PLAYER_STATS"
