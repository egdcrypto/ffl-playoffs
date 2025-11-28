"""
Test Configuration and Fixtures

Pytest fixtures for testing the NFL Data Sync service.
"""
import pytest
from decimal import Decimal

from src.domain.models import (
    GameStatus,
    NFLGame,
    NFLPlayer,
    PlayerStats,
    SyncJob,
    SyncJobStatus,
    SyncJobType,
)


@pytest.fixture
def sample_player_stats():
    """Create sample player stats for testing."""
    return PlayerStats(
        player_id="12345",
        player_name="Patrick Mahomes",
        week=18,
        season=2024,
        team="KC",
        position="QB",
        passing_yards=325,
        passing_tds=3,
        interceptions=1,
        passing_attempts=40,
        passing_completions=28,
        rushing_yards=28,
        rushing_tds=0,
        receptions=0,
        receiving_yards=0,
        receiving_tds=0,
    )


@pytest.fixture
def sample_rb_stats():
    """Create sample running back stats for testing."""
    return PlayerStats(
        player_id="23456",
        player_name="Travis Etienne",
        week=18,
        season=2024,
        team="JAX",
        position="RB",
        rushing_yards=112,
        rushing_tds=2,
        rushing_attempts=22,
        receptions=5,
        receiving_yards=45,
        receiving_tds=0,
        targets=6,
    )


@pytest.fixture
def sample_wr_stats():
    """Create sample wide receiver stats for testing."""
    return PlayerStats(
        player_id="34567",
        player_name="Ja'Marr Chase",
        week=18,
        season=2024,
        team="CIN",
        position="WR",
        receptions=8,
        receiving_yards=132,
        receiving_tds=2,
        targets=12,
        rushing_yards=5,
        rushing_attempts=1,
    )


@pytest.fixture
def sample_kicker_stats():
    """Create sample kicker stats for testing."""
    return PlayerStats(
        player_id="45678",
        player_name="Justin Tucker",
        week=18,
        season=2024,
        team="BAL",
        position="K",
        fg_made_0_19=0,
        fg_made_20_29=1,
        fg_made_30_39=2,
        fg_made_40_49=1,
        fg_made_50_plus=1,
        field_goals_made=5,
        field_goals_attempted=6,
        extra_points_made=3,
        extra_points_attempted=3,
    )


@pytest.fixture
def sample_game():
    """Create sample NFL game for testing."""
    from datetime import datetime

    return NFLGame(
        game_id="2024_18_KC_BUF",
        season=2024,
        week=18,
        home_team="KC",
        away_team="BUF",
        home_score=27,
        away_score=24,
        game_time=datetime(2024, 1, 12, 18, 0),
        status=GameStatus.FINAL,
        venue="Arrowhead Stadium",
    )


@pytest.fixture
def sample_scheduled_game():
    """Create sample scheduled NFL game for testing."""
    from datetime import datetime, timedelta

    return NFLGame(
        game_id="2024_19_SF_GB",
        season=2024,
        week=19,
        home_team="SF",
        away_team="GB",
        game_time=datetime.now() + timedelta(days=7),
        status=GameStatus.SCHEDULED,
        venue="Levi's Stadium",
    )


@pytest.fixture
def sample_player():
    """Create sample NFL player for testing."""
    return NFLPlayer(
        player_id="12345",
        name="Patrick Mahomes",
        first_name="Patrick",
        last_name="Mahomes",
        position="QB",
        team="KC",
        jersey_number=15,
        status="ACTIVE",
    )


@pytest.fixture
def sample_players():
    """Create list of sample NFL players for testing."""
    return [
        NFLPlayer(
            player_id="12345",
            name="Patrick Mahomes",
            position="QB",
            team="KC",
        ),
        NFLPlayer(
            player_id="23456",
            name="Travis Etienne",
            position="RB",
            team="JAX",
        ),
        NFLPlayer(
            player_id="34567",
            name="Ja'Marr Chase",
            position="WR",
            team="CIN",
        ),
        NFLPlayer(
            player_id="45678",
            name="Travis Kelce",
            position="TE",
            team="KC",
        ),
    ]
