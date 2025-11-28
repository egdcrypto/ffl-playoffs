# Solution Proposal: FFL-34 Scheduled NFL Data Sync

**Feature:** `features/ffl-34-scheduled-nfl-data-sync.feature`
**Author:** AI Engineer
**Date:** 2025-11-28
**Status:** Draft Proposal

---

## Executive Summary

This proposal outlines the implementation of an automated, scheduled NFL data synchronization system for the FFL Playoffs application. The system will keep player rosters, game schedules, live scores, and player statistics up-to-date by polling **nflreadpy** (FREE) every minute during active games, then pushing deltas to connected clients via **WebSockets** using **Hazelcast** for distributed state management.

**Key Design Decisions:**
- **No caching layer** - Small player count, simple in-memory state
- **nflreadpy** - FREE data source, poll every 1 minute
- **Hazelcast** - Distributed state for delta detection
- **WebSockets** - Push deltas to clients in real-time

---

## Problem Statement

The FFL Playoffs application requires current NFL data to function correctly:
- **Player Data:** Roster changes, injuries, and status updates affect draft decisions
- **Schedules:** Game times change, affecting lock deadlines
- **Live Scores:** Users expect real-time score updates during games
- **Stats:** Fantasy point calculations depend on accurate post-game statistics

Currently, there is no automated synchronization—data fetching is manual. This creates:
1. Stale data during critical game windows
2. Manual operational overhead
3. Risk of missed updates affecting user experience

---

## Proposed Solution

### Architecture Overview

```
┌─────────────────────────────────────────────────────────────────────┐
│                     Python FastAPI Application                       │
├─────────────────────────────────────────────────────────────────────┤
│  ┌─────────────────────────────────────────────────────────────┐   │
│  │                    Sync Scheduler Service                     │   │
│  │  ┌─────────────────────────────────────────────────────────┐ │   │
│  │  │            NflDataSyncJob (APScheduler)                  │ │   │
│  │  │            - Runs every 1 minute during games            │ │   │
│  │  │            - Polls nflreadpy for latest data             │ │   │
│  │  │            - Detects deltas via Hazelcast                │ │   │
│  │  │            - Pushes changes via WebSocket                │ │   │
│  │  └──────────────────────────┬──────────────────────────────┘ │   │
│  └─────────────────────────────┼────────────────────────────────┘   │
│                                ▼                                     │
│  ┌─────────────────────────────────────────────────────────────┐   │
│  │                    Application Layer                          │   │
│  │  ┌────────────────┐ ┌───────────────┐ ┌─────────────────┐   │   │
│  │  │DeltaDetection  │ │FantasyScoring │ │ WebSocketPush   │   │   │
│  │  │Service         │ │Engine         │ │ Service         │   │   │
│  │  └───────┬────────┘ └───────┬───────┘ └────────┬────────┘   │   │
│  └──────────┼──────────────────┼──────────────────┼─────────────┘   │
│             └──────────────────┼──────────────────┘                  │
│                                ▼                                     │
│  ┌─────────────────────────────────────────────────────────────┐   │
│  │                      Domain Layer                             │   │
│  │  ┌────────────────────────────────────────────────────────┐  │   │
│  │  │               NflDataProvider (Port)                    │  │   │
│  │  │  + get_player_stats(season, week) -> DataFrame          │  │   │
│  │  │  + get_schedule(season) -> DataFrame                    │  │   │
│  │  │  + get_rosters(season) -> DataFrame                     │  │   │
│  │  │  + get_current_week() -> int                            │  │   │
│  │  └────────────────────────────────────────────────────────┘  │   │
│  └──────────────────────────────────────────────────────────────┘   │
│                                ▼                                     │
│  ┌─────────────────────────────────────────────────────────────┐   │
│  │                  Infrastructure Layer                         │   │
│  │  ┌───────────────┐  ┌─────────────┐  ┌─────────────────┐    │   │
│  │  │NflReadPy      │  │  Hazelcast  │  │ WebSocket       │    │   │
│  │  │Adapter        │  │  (Deltas)   │  │ Handler         │    │   │
│  │  └───────┬───────┘  └──────┬──────┘  └────────┬────────┘    │   │
│  │          │                 │                   │              │   │
│  │          │                 └───────────────────┘              │   │
│  │          ▼                                                    │   │
│  │  ┌────────────────────────────────────────────────────────┐  │   │
│  │  │              MongoDB Repositories                       │  │   │
│  │  │  NFLPlayerRepository | NFLGameRepository | StatsRepo    │  │   │
│  │  └────────────────────────────────────────────────────────┘  │   │
│  └──────────────────────────────────────────────────────────────┘   │
└─────────────────────────────────────────────────────────────────────┘
                                 │
                                 ▼
                    ┌───────────────────────┐
                    │   nflreadpy (FREE)    │
                    │   - nflverse data     │
                    │   - No API key        │
                    │   - Poll every 1 min  │
                    └───────────────────────┘
```

---

## Component Design

### 1. Sync Configuration

**Location:** `config/settings.py`

```python
from pydantic_settings import BaseSettings

class NflSyncSettings(BaseSettings):
    enabled: bool = True
    interval_seconds: int = 60  # 1 minute polling
    offseason_interval_seconds: int = 3600  # 1 hour when no games

    class Config:
        env_prefix = "NFL_SYNC_"
```

**Environment variables:**
```bash
NFL_SYNC_ENABLED=true
NFL_SYNC_INTERVAL_SECONDS=60
NFL_SYNC_OFFSEASON_INTERVAL_SECONDS=3600
```

---

### 2. nflreadpy Adapter

**Location:** `infrastructure/adapters/nflreadpy_adapter.py`

```python
import nflreadpy as nfl
from domain.ports import NflDataProvider
from domain.models import PlayerStats, NFLGame
from typing import List
import polars as pl


class NflReadPyAdapter(NflDataProvider):
    """
    Adapter for nflreadpy - FREE NFL data from nflverse.
    """

    def get_player_stats(self, season: int, week: int) -> List[PlayerStats]:
        """Get player stats for a specific week."""
        stats_df = nfl.load_player_stats([season])
        week_stats = stats_df.filter(pl.col("week") == week)
        return self._map_to_player_stats(week_stats)

    def get_schedule(self, season: int) -> List[NFLGame]:
        """Get season schedule."""
        schedule_df = nfl.load_schedules(season)
        return self._map_to_games(schedule_df)

    def get_rosters(self, season: int) -> pl.DataFrame:
        """Get team rosters."""
        return nfl.load_rosters(season)

    def get_current_week(self) -> int:
        """Get current NFL week."""
        return nfl.get_current_week()

    def get_current_season(self) -> int:
        """Get current NFL season."""
        return nfl.get_current_season()

    def _map_to_player_stats(self, df: pl.DataFrame) -> List[PlayerStats]:
        """Map DataFrame to PlayerStats domain objects."""
        stats = []
        for row in df.iter_rows(named=True):
            stats.append(PlayerStats(
                player_id=row.get("player_id"),
                player_name=row.get("player_name"),
                week=row.get("week"),
                season=row.get("season"),
                passing_yards=row.get("passing_yards", 0),
                passing_tds=row.get("passing_tds", 0),
                interceptions=row.get("interceptions", 0),
                rushing_yards=row.get("rushing_yards", 0),
                rushing_tds=row.get("rushing_tds", 0),
                receptions=row.get("receptions", 0),
                receiving_yards=row.get("receiving_yards", 0),
                receiving_tds=row.get("receiving_tds", 0),
                fumbles_lost=row.get("sack_fumbles_lost", 0),
            ))
        return stats

    def _map_to_games(self, df: pl.DataFrame) -> List[NFLGame]:
        """Map DataFrame to NFLGame domain objects."""
        games = []
        for row in df.iter_rows(named=True):
            games.append(NFLGame(
                game_id=row.get("game_id"),
                season=row.get("season"),
                week=row.get("week"),
                home_team=row.get("home_team"),
                away_team=row.get("away_team"),
                home_score=row.get("home_score"),
                away_score=row.get("away_score"),
                game_time=row.get("gameday"),
                status=row.get("game_type"),
            ))
        return games
```

---

### 3. Delta Detection with Hazelcast

**Location:** `infrastructure/adapters/hazelcast_delta_service.py`

```python
import hazelcast
from typing import List, Optional, Dict, Any
from domain.models import PlayerStats, NFLGame, PlayerStatsDelta, GameScoreDelta


class DeltaDetectionService:
    """
    Detects changes in NFL data using Hazelcast distributed maps.
    """

    def __init__(self):
        self.client = hazelcast.HazelcastClient()
        self._player_stats_map = self.client.get_map("player-stats").blocking()
        self._game_scores_map = self.client.get_map("game-scores").blocking()

    def detect_player_deltas(self, current_stats: List[PlayerStats]) -> List[PlayerStatsDelta]:
        """
        Compare current stats against previous state and return only deltas.
        """
        deltas = []

        for current in current_stats:
            key = f"{current.player_id}-{current.week}"
            previous = self._player_stats_map.get(key)

            if previous is None or self._has_stats_changed(previous, current):
                deltas.append(PlayerStatsDelta(
                    player_id=current.player_id,
                    player_name=current.player_name,
                    week=current.week,
                    previous_stats=previous,
                    current_stats=current,
                ))
                # Update stored state
                self._player_stats_map.put(key, current.model_dump())

        return deltas

    def detect_game_deltas(self, current_games: List[NFLGame]) -> List[GameScoreDelta]:
        """
        Compare current game scores against previous state and return only deltas.
        """
        deltas = []

        for current in current_games:
            key = current.game_id
            previous = self._game_scores_map.get(key)

            if previous is None or self._has_score_changed(previous, current):
                deltas.append(GameScoreDelta(
                    game_id=current.game_id,
                    home_team=current.home_team,
                    away_team=current.away_team,
                    home_score=current.home_score,
                    away_score=current.away_score,
                    status=current.status,
                ))
                self._game_scores_map.put(key, current.model_dump())

        return deltas

    def _has_stats_changed(self, prev: Dict[str, Any], curr: PlayerStats) -> bool:
        """Check if player stats have changed."""
        return (
            prev.get("passing_yards") != curr.passing_yards or
            prev.get("rushing_yards") != curr.rushing_yards or
            prev.get("receiving_yards") != curr.receiving_yards or
            prev.get("passing_tds") != curr.passing_tds or
            prev.get("rushing_tds") != curr.rushing_tds or
            prev.get("receiving_tds") != curr.receiving_tds
        )

    def _has_score_changed(self, prev: Dict[str, Any], curr: NFLGame) -> bool:
        """Check if game score has changed."""
        return (
            prev.get("home_score") != curr.home_score or
            prev.get("away_score") != curr.away_score or
            prev.get("status") != curr.status
        )

    def close(self):
        """Shutdown Hazelcast client."""
        self.client.shutdown()
```

---

### 4. WebSocket Push Service

**Location:** `infrastructure/adapters/websocket_service.py`

```python
from fastapi import WebSocket
from typing import List, Dict, Set
import json
from datetime import datetime
from domain.models import PlayerStatsDelta, GameScoreDelta


class WebSocketManager:
    """
    Manages WebSocket connections and broadcasts deltas to clients.
    """

    def __init__(self):
        self.active_connections: Set[WebSocket] = set()
        self.league_subscriptions: Dict[str, Set[WebSocket]] = {}
        self.player_subscriptions: Dict[str, Set[WebSocket]] = {}

    async def connect(self, websocket: WebSocket):
        """Accept a new WebSocket connection."""
        await websocket.accept()
        self.active_connections.add(websocket)

    def disconnect(self, websocket: WebSocket):
        """Remove a WebSocket connection."""
        self.active_connections.discard(websocket)
        # Clean up subscriptions
        for subs in self.league_subscriptions.values():
            subs.discard(websocket)
        for subs in self.player_subscriptions.values():
            subs.discard(websocket)

    def subscribe_to_league(self, websocket: WebSocket, league_id: str):
        """Subscribe to league updates."""
        if league_id not in self.league_subscriptions:
            self.league_subscriptions[league_id] = set()
        self.league_subscriptions[league_id].add(websocket)

    def subscribe_to_player(self, websocket: WebSocket, player_id: str):
        """Subscribe to individual player updates."""
        if player_id not in self.player_subscriptions:
            self.player_subscriptions[player_id] = set()
        self.player_subscriptions[player_id].add(websocket)

    async def broadcast_player_deltas(self, deltas: List[PlayerStatsDelta]):
        """Broadcast player stat deltas to all connected clients."""
        if not deltas:
            return

        message = {
            "type": "PLAYER_STATS",
            "timestamp": datetime.utcnow().isoformat(),
            "deltas": [d.model_dump() for d in deltas],
        }

        # Broadcast to all connections
        for connection in self.active_connections.copy():
            try:
                await connection.send_json(message)
            except Exception:
                self.disconnect(connection)

        # Also send individual player updates
        for delta in deltas:
            if delta.player_id in self.player_subscriptions:
                for conn in self.player_subscriptions[delta.player_id].copy():
                    try:
                        await conn.send_json({
                            "type": "PLAYER_UPDATE",
                            "data": delta.model_dump()
                        })
                    except Exception:
                        self.disconnect(conn)

    async def broadcast_game_deltas(self, deltas: List[GameScoreDelta]):
        """Broadcast game score deltas to all connected clients."""
        if not deltas:
            return

        message = {
            "type": "GAME_SCORES",
            "timestamp": datetime.utcnow().isoformat(),
            "deltas": [d.model_dump() for d in deltas],
        }

        for connection in self.active_connections.copy():
            try:
                await connection.send_json(message)
            except Exception:
                self.disconnect(connection)

    async def broadcast_leaderboard(self, league_id: str, leaderboard: List[dict]):
        """Broadcast leaderboard update to league subscribers."""
        if league_id not in self.league_subscriptions:
            return

        message = {
            "type": "LEADERBOARD_UPDATE",
            "league_id": league_id,
            "timestamp": datetime.utcnow().isoformat(),
            "leaderboard": leaderboard,
        }

        for conn in self.league_subscriptions[league_id].copy():
            try:
                await conn.send_json(message)
            except Exception:
                self.disconnect(conn)


# Global instance
ws_manager = WebSocketManager()
```

---

### 5. Main Sync Job

**Location:** `infrastructure/scheduler/nfl_data_sync_job.py`

```python
from apscheduler.schedulers.asyncio import AsyncIOScheduler
from apscheduler.triggers.interval import IntervalTrigger
import logging

from config.settings import NflSyncSettings
from infrastructure.adapters.nflreadpy_adapter import NflReadPyAdapter
from infrastructure.adapters.hazelcast_delta_service import DeltaDetectionService
from infrastructure.adapters.websocket_service import ws_manager
from application.services.fantasy_scoring_engine import FantasyScoringEngine
from application.services.leaderboard_service import LeaderboardService

logger = logging.getLogger(__name__)


class NflDataSyncJob:
    """
    Scheduled job that polls nflreadpy every minute and pushes deltas via WebSocket.
    """

    def __init__(
        self,
        settings: NflSyncSettings,
        nfl_provider: NflReadPyAdapter,
        delta_service: DeltaDetectionService,
        scoring_engine: FantasyScoringEngine,
        leaderboard_service: LeaderboardService,
    ):
        self.settings = settings
        self.nfl_provider = nfl_provider
        self.delta_service = delta_service
        self.scoring_engine = scoring_engine
        self.leaderboard_service = leaderboard_service
        self.scheduler = AsyncIOScheduler()

    def start(self):
        """Start the sync scheduler."""
        if not self.settings.enabled:
            logger.info("NFL data sync is disabled")
            return

        self.scheduler.add_job(
            self.sync_nfl_data,
            trigger=IntervalTrigger(seconds=self.settings.interval_seconds),
            id="nfl_data_sync",
            replace_existing=True,
        )
        self.scheduler.start()
        logger.info(f"NFL data sync started (interval: {self.settings.interval_seconds}s)")

    def stop(self):
        """Stop the sync scheduler."""
        self.scheduler.shutdown()

    async def sync_nfl_data(self):
        """
        Main sync job - runs every minute during active games.
        """
        logger.info("Starting NFL data sync...")

        try:
            current_season = self.nfl_provider.get_current_season()
            current_week = self.nfl_provider.get_current_week()

            # 1. Fetch latest player stats from nflreadpy
            player_stats = self.nfl_provider.get_player_stats(current_season, current_week)

            # 2. Detect deltas using Hazelcast
            player_deltas = self.delta_service.detect_player_deltas(player_stats)

            # 3. Calculate fantasy points for changed players
            for delta in player_deltas:
                delta.fantasy_points = self.scoring_engine.calculate(delta.current_stats)

            # 4. Push deltas to clients via WebSocket
            await ws_manager.broadcast_player_deltas(player_deltas)

            # 5. Fetch and push game score updates
            games = self.nfl_provider.get_schedule(current_season)
            current_week_games = [g for g in games if g.week == current_week]

            game_deltas = self.delta_service.detect_game_deltas(current_week_games)
            await ws_manager.broadcast_game_deltas(game_deltas)

            # 6. Update leaderboards if any changes
            if player_deltas:
                await self.leaderboard_service.recalculate_all()

            logger.info(
                f"NFL data sync complete. Player deltas: {len(player_deltas)}, "
                f"Game deltas: {len(game_deltas)}"
            )

        except Exception as e:
            logger.error(f"NFL data sync failed: {e}", exc_info=True)
```

---

### 6. Fantasy Scoring Engine

**Location:** `application/services/fantasy_scoring_engine.py`

```python
from decimal import Decimal, ROUND_HALF_UP
from domain.models import PlayerStats


class FantasyScoringEngine:
    """
    Calculate fantasy points from raw stats.
    Supports PPR scoring by default.
    """

    def calculate(self, stats: PlayerStats) -> Decimal:
        """Calculate fantasy points from player stats (PPR scoring)."""
        points = Decimal("0")

        # Passing
        points += self._divide(stats.passing_yards, 25)      # 1 pt per 25 yards
        points += self._multiply(stats.passing_tds, 4)       # 4 pts per TD
        points -= self._multiply(stats.interceptions, 2)     # -2 pts per INT

        # Rushing
        points += self._divide(stats.rushing_yards, 10)      # 1 pt per 10 yards
        points += self._multiply(stats.rushing_tds, 6)       # 6 pts per TD

        # Receiving (PPR)
        points += self._multiply(stats.receptions, 1)        # 1 pt per reception
        points += self._divide(stats.receiving_yards, 10)    # 1 pt per 10 yards
        points += self._multiply(stats.receiving_tds, 6)     # 6 pts per TD

        # Fumbles Lost
        points -= self._multiply(stats.fumbles_lost, 2)      # -2 pts per fumble

        return points.quantize(Decimal("0.01"), rounding=ROUND_HALF_UP)

    def _divide(self, value: int, divisor: int) -> Decimal:
        """Divide value by divisor, handling None."""
        if value is None:
            return Decimal("0")
        return Decimal(str(value)) / Decimal(str(divisor))

    def _multiply(self, value: int, multiplier: int) -> Decimal:
        """Multiply value by multiplier, handling None."""
        if value is None:
            return Decimal("0")
        return Decimal(str(value * multiplier))
```

---

### 7. Domain Models

**Location:** `domain/models.py`

```python
from pydantic import BaseModel
from typing import Optional
from decimal import Decimal
from datetime import datetime


class PlayerStats(BaseModel):
    player_id: str
    player_name: str
    week: int
    season: int
    passing_yards: int = 0
    passing_tds: int = 0
    interceptions: int = 0
    rushing_yards: int = 0
    rushing_tds: int = 0
    receptions: int = 0
    receiving_yards: int = 0
    receiving_tds: int = 0
    fumbles_lost: int = 0


class NFLGame(BaseModel):
    game_id: str
    season: int
    week: int
    home_team: str
    away_team: str
    home_score: Optional[int] = None
    away_score: Optional[int] = None
    game_time: Optional[datetime] = None
    status: Optional[str] = None


class PlayerStatsDelta(BaseModel):
    player_id: str
    player_name: str
    week: int
    previous_stats: Optional[dict] = None
    current_stats: PlayerStats
    fantasy_points: Optional[Decimal] = None


class GameScoreDelta(BaseModel):
    game_id: str
    home_team: str
    away_team: str
    home_score: Optional[int]
    away_score: Optional[int]
    status: Optional[str]
```

---

### 8. FastAPI WebSocket Endpoint

**Location:** `api/websocket_routes.py`

```python
from fastapi import APIRouter, WebSocket, WebSocketDisconnect
from infrastructure.adapters.websocket_service import ws_manager

router = APIRouter()


@router.websocket("/ws")
async def websocket_endpoint(websocket: WebSocket):
    """Main WebSocket endpoint for receiving NFL data updates."""
    await ws_manager.connect(websocket)
    try:
        while True:
            # Receive subscription requests from client
            data = await websocket.receive_json()

            if data.get("action") == "subscribe_league":
                ws_manager.subscribe_to_league(websocket, data["league_id"])

            elif data.get("action") == "subscribe_player":
                ws_manager.subscribe_to_player(websocket, data["player_id"])

    except WebSocketDisconnect:
        ws_manager.disconnect(websocket)
```

---

## New Files to Create

| File | Location | Purpose |
|------|----------|---------|
| `settings.py` | `config/` | Configuration with Pydantic |
| `nflreadpy_adapter.py` | `infrastructure/adapters/` | nflreadpy data fetching |
| `hazelcast_delta_service.py` | `infrastructure/adapters/` | Delta detection with Hazelcast |
| `websocket_service.py` | `infrastructure/adapters/` | WebSocket connection manager |
| `nfl_data_sync_job.py` | `infrastructure/scheduler/` | Main sync job (APScheduler) |
| `fantasy_scoring_engine.py` | `application/services/` | Calculate fantasy points |
| `models.py` | `domain/` | Pydantic domain models |
| `websocket_routes.py` | `api/` | FastAPI WebSocket endpoints |

---

## Dependencies to Add

```txt
# requirements.txt
nflreadpy>=0.1.5
hazelcast-python-client>=5.3.0
apscheduler>=3.10.4
fastapi[all]>=0.104.0
websockets>=12.0
pydantic-settings>=2.1.0
polars>=0.19.0
```

---

## Data Flow

```
┌──────────────────────────────────────────────────────────────────┐
│                      Every 1 Minute                               │
└──────────────────────────────────────────────────────────────────┘
                                │
                                ▼
┌──────────────────────────────────────────────────────────────────┐
│  1. Poll nflreadpy                                                │
│     - nfl.load_player_stats([2025])                               │
│     - nfl.load_schedules(2025)                                    │
└──────────────────────────────────────────────────────────────────┘
                                │
                                ▼
┌──────────────────────────────────────────────────────────────────┐
│  2. Detect Deltas (Hazelcast)                                     │
│     - Compare current vs previous state                           │
│     - Return only changed records                                 │
└──────────────────────────────────────────────────────────────────┘
                                │
                                ▼
┌──────────────────────────────────────────────────────────────────┐
│  3. Calculate Fantasy Points                                      │
│     - Apply scoring rules to changed stats                        │
│     - PPR / Standard / Custom                                     │
└──────────────────────────────────────────────────────────────────┘
                                │
                                ▼
┌──────────────────────────────────────────────────────────────────┐
│  4. Push Deltas via WebSocket                                     │
│     - /ws (all player deltas)                                     │
│     - League-specific broadcasts                                  │
│     - Player-specific broadcasts                                  │
└──────────────────────────────────────────────────────────────────┘
                                │
                                ▼
┌──────────────────────────────────────────────────────────────────┐
│  5. Clients Receive Real-time Updates                             │
│     - React/Vue updates UI automatically                          │
│     - No page refresh needed                                      │
└──────────────────────────────────────────────────────────────────┘
```

---

## Client WebSocket Integration

```javascript
// Client-side WebSocket connection
const ws = new WebSocket('ws://localhost:8000/ws');

ws.onopen = () => {
    console.log('Connected to NFL data stream');

    // Subscribe to a league
    ws.send(JSON.stringify({
        action: 'subscribe_league',
        league_id: 'my-league-123'
    }));
};

ws.onmessage = (event) => {
    const message = JSON.parse(event.data);

    switch (message.type) {
        case 'PLAYER_STATS':
            updatePlayerStats(message.deltas);
            break;
        case 'GAME_SCORES':
            updateGameScores(message.deltas);
            break;
        case 'LEADERBOARD_UPDATE':
            updateLeaderboard(message.leaderboard);
            break;
    }
};

ws.onclose = () => {
    console.log('Disconnected from NFL data stream');
    // Implement reconnection logic
};
```

---

## Why This Architecture

### No Caching Needed
- Small number of players per league (typical: 8-12 teams × 15 players = 120-180 players)
- Hazelcast holds current state in memory for delta detection
- MongoDB is the source of truth for persistence
- No Redis cache layer required

### nflreadpy (FREE)
- \$0/month operating cost
- Comprehensive NFL data (players, stats, schedules)
- Poll every 1 minute for near real-time updates
- Calculate fantasy points ourselves

### Hazelcast for Deltas
- Distributed in-memory data grid
- Fast comparison for delta detection
- Scales horizontally if needed
- Built-in cluster support
- Python client available

### WebSocket Push
- Real-time updates to clients
- Only send deltas (not full dataset)
- Reduces bandwidth
- Better UX than polling from client

---

## Cost

| Component | Cost |
|-----------|------|
| nflreadpy | FREE |
| Hazelcast (embedded) | FREE |
| WebSocket (FastAPI) | FREE |
| **Total** | **\$0/month** |

---

## Implementation Order

1. **Phase 1: nflreadpy Integration**
   - [ ] Create `NflReadPyAdapter`
   - [ ] Test data retrieval from nflverse

2. **Phase 2: Delta Detection**
   - [ ] Add hazelcast-python-client
   - [ ] Implement `DeltaDetectionService`
   - [ ] Create Pydantic domain models

3. **Phase 3: WebSocket Push**
   - [ ] Implement `WebSocketManager`
   - [ ] Add FastAPI WebSocket endpoint
   - [ ] Test client subscriptions

4. **Phase 4: Scoring Engine**
   - [ ] Implement `FantasyScoringEngine`
   - [ ] Support PPR/Standard scoring

5. **Phase 5: Main Sync Job**
   - [ ] Wire everything together in `NflDataSyncJob`
   - [ ] Test 1-minute polling cycle with APScheduler

---

## Document Control

| Version | Date | Author | Changes |
|---------|------|--------|---------|
| 1.0 | 2025-11-28 | AI Engineer | Initial proposal (Java/SportsData.io) |
| 2.0 | 2025-11-28 | Feature Architect | Rewrite for nflreadpy + Hazelcast + WebSocket |
| 2.1 | 2025-11-28 | Feature Architect | Convert to Python (FastAPI/APScheduler) |

**Status:** Draft Proposal

**Estimated Budget:** \$0/month

**Estimated Implementation Time:** 2-3 weeks
