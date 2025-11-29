"""
Domain Models for NFL Data Sync Service

These are pure domain models with no framework dependencies.
They represent the core business entities and data structures.
"""
from datetime import datetime
from decimal import Decimal
from enum import Enum
from typing import Optional
from pydantic import BaseModel, Field


class SyncJobType(str, Enum):
    """Types of sync jobs"""
    PLAYERS = "PLAYERS"
    SCHEDULES = "SCHEDULES"
    LIVE_SCORES = "LIVE_SCORES"
    PLAYER_STATS = "PLAYER_STATS"


class SyncJobStatus(str, Enum):
    """Status of a sync job"""
    PENDING = "PENDING"
    IN_PROGRESS = "IN_PROGRESS"
    COMPLETED = "COMPLETED"
    PARTIAL_FAILURE = "PARTIAL_FAILURE"
    FAILED = "FAILED"


class GameStatus(str, Enum):
    """NFL Game status"""
    SCHEDULED = "SCHEDULED"
    IN_PROGRESS = "IN_PROGRESS"
    HALFTIME = "HALFTIME"
    FINAL = "FINAL"
    POSTPONED = "POSTPONED"
    CANCELLED = "CANCELLED"


class PlayerStats(BaseModel):
    """Player statistics for a specific game/week"""
    player_id: str
    player_name: str
    week: int
    season: int
    team: Optional[str] = None
    position: Optional[str] = None

    # Passing stats
    passing_yards: int = 0
    passing_tds: int = 0
    interceptions: int = 0
    passing_attempts: int = 0
    passing_completions: int = 0

    # Rushing stats
    rushing_yards: int = 0
    rushing_tds: int = 0
    rushing_attempts: int = 0

    # Receiving stats
    receptions: int = 0
    receiving_yards: int = 0
    receiving_tds: int = 0
    targets: int = 0

    # Other offensive stats
    two_point_conversions: int = 0
    fumbles_lost: int = 0

    # Kicker stats
    field_goals_made: int = 0
    field_goals_attempted: int = 0
    fg_made_0_19: int = 0
    fg_made_20_29: int = 0
    fg_made_30_39: int = 0
    fg_made_40_49: int = 0
    fg_made_50_plus: int = 0
    extra_points_made: int = 0
    extra_points_attempted: int = 0

    class Config:
        frozen = False


class NFLGame(BaseModel):
    """NFL Game information"""
    game_id: str
    season: int
    week: int
    home_team: str
    away_team: str
    home_score: Optional[int] = None
    away_score: Optional[int] = None
    game_time: Optional[datetime] = None
    game_date: Optional[datetime] = None  # Date of the actual game (required for FFL-36)
    status: GameStatus = GameStatus.SCHEDULED
    quarter: Optional[str] = None
    time_remaining: Optional[str] = None
    venue: Optional[str] = None

    class Config:
        frozen = False


class NFLPlayer(BaseModel):
    """NFL Player information"""
    player_id: str
    name: str
    first_name: Optional[str] = None
    last_name: Optional[str] = None
    position: Optional[str] = None
    team: Optional[str] = None
    jersey_number: Optional[int] = None
    status: str = "ACTIVE"

    class Config:
        frozen = False


class PlayerStatsDelta(BaseModel):
    """Represents a change in player stats"""
    player_id: str
    player_name: str
    week: int
    season: int
    previous_stats: Optional[dict] = None
    current_stats: PlayerStats
    fantasy_points: Optional[Decimal] = None
    fantasy_points_ppr: Optional[Decimal] = None
    fantasy_points_half_ppr: Optional[Decimal] = None
    timestamp: datetime = Field(default_factory=datetime.utcnow)


class GameScoreDelta(BaseModel):
    """Represents a change in game score"""
    game_id: str
    home_team: str
    away_team: str
    home_score: Optional[int]
    away_score: Optional[int]
    status: GameStatus
    quarter: Optional[str] = None
    time_remaining: Optional[str] = None
    timestamp: datetime = Field(default_factory=datetime.utcnow)


class SyncJob(BaseModel):
    """Represents a data sync job"""
    job_id: str
    job_type: SyncJobType
    status: SyncJobStatus = SyncJobStatus.PENDING
    started_at: Optional[datetime] = None
    completed_at: Optional[datetime] = None
    records_processed: int = 0
    records_added: int = 0
    records_updated: int = 0
    error_message: Optional[str] = None
    partial_failures: list[str] = Field(default_factory=list)

    class Config:
        frozen = False


class SyncConfiguration(BaseModel):
    """Configuration for sync jobs"""
    players_enabled: bool = True
    players_cron: str = "0 0 6 * * *"  # 6 AM daily
    schedules_enabled: bool = True
    schedules_cron: str = "0 0 0 * * MON"  # Monday at midnight
    live_scores_enabled: bool = True
    live_scores_interval_seconds: int = 60  # 1 minute during games
    offseason_interval_seconds: int = 3600  # 1 hour when no games


class SyncMetrics(BaseModel):
    """Metrics for monitoring sync operations"""
    sync_jobs_total: int = 0
    sync_duration_seconds: float = 0.0
    records_processed: int = 0
    errors_total: int = 0
    api_requests_total: int = 0
    rate_limit_hits: int = 0
