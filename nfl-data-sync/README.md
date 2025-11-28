# NFL Data Sync Service

A standalone Python microservice that synchronizes NFL data from nflverse and broadcasts real-time updates via WebSocket.

## Overview

This service is part of the FFL Playoffs application and handles:
- Scheduled synchronization of NFL player data, schedules, and scores
- Delta detection to identify changed records
- Fantasy point calculations (Standard, PPR, Half-PPR)
- Real-time WebSocket broadcasts to connected clients
- Admin endpoints for manual sync triggers and monitoring

## Architecture

```
nfl-data-sync/
├── src/
│   ├── config/          # Pydantic settings
│   ├── domain/          # Domain models and port interfaces
│   ├── application/     # Business logic services
│   │   └── services/    # Fantasy scoring engine
│   ├── infrastructure/  # External adapters
│   │   ├── adapters/    # nfl_data_py, Redis, WebSocket
│   │   └── scheduler/   # APScheduler jobs
│   └── api/             # FastAPI routes
└── tests/               # Unit and integration tests
```

## Requirements

- Python 3.10+
- Redis (for delta detection)
- MongoDB (for persistence)

## Installation

1. Create a virtual environment:
```bash
python -m venv venv
source venv/bin/activate  # On Windows: venv\Scripts\activate
```

2. Install dependencies:
```bash
pip install -r requirements.txt
```

3. Copy environment configuration:
```bash
cp .env.example .env
```

4. Start the service:
```bash
uvicorn src.main:app --host 0.0.0.0 --port 8001
```

## Docker

Build and run with Docker Compose:
```bash
docker-compose up -d
```

This starts:
- `nfl-data-sync` - The sync service on port 8001
- `redis` - For delta detection on port 6379
- `mongo` - For data persistence on port 27017

## API Endpoints

### REST API

| Endpoint | Method | Description |
|----------|--------|-------------|
| `/` | GET | Service info |
| `/health` | GET | Health check |
| `/api/v1/admin/sync/players` | POST | Trigger manual player sync |
| `/api/v1/admin/sync/schedules` | POST | Trigger manual schedule sync |
| `/api/v1/admin/sync/live-scores` | POST | Trigger manual live scores sync |
| `/api/v1/admin/sync/{job_id}` | GET | Get sync job status |
| `/api/v1/admin/sync/history` | GET | Get sync history |
| `/api/v1/admin/health` | GET | Detailed health check |
| `/api/v1/admin/metrics` | GET | Sync metrics |

### WebSocket

Connect to `ws://localhost:8001/ws` for real-time updates.

**Subscription Messages:**
```json
{"action": "subscribe_league", "league_id": "xxx"}
{"action": "subscribe_player", "player_id": "xxx"}
```

**Update Messages:**
```json
{"type": "PLAYER_STATS", "deltas": [...]}
{"type": "GAME_SCORES", "deltas": [...]}
{"type": "LEADERBOARD_UPDATE", "league_id": "xxx", "leaderboard": [...]}
```

## Configuration

Environment variables:

| Variable | Default | Description |
|----------|---------|-------------|
| `SERVER_PORT` | 8001 | Service port |
| `NFL_SYNC_ENABLED` | true | Enable sync scheduler |
| `NFL_SYNC_INTERVAL_SECONDS` | 60 | Live sync interval |
| `REDIS_URL` | redis://localhost:6379 | Redis connection URL |
| `MONGO_URL` | mongodb://localhost:27017 | MongoDB connection URL |

## Testing

Run unit tests:
```bash
pytest tests/unit -v
```

Run with coverage:
```bash
pytest --cov=src tests/
```

## Data Sources

This service uses [nfl_data_py](https://github.com/nflverse/nfl_data_py), which provides FREE access to NFL data from the nflverse ecosystem.

Data update schedule:
- Player stats: Nightly (3-5 AM ET)
- Schedules: Every 5 minutes
- Rosters: Daily (7 AM UTC)

## Related Documentation

- [FFL-34 Feature Specification](../features/ffl-34-scheduled-nfl-data-sync.feature)
- [Solution Proposal](../docs/solutions/FFL-34-scheduled-nfl-data-sync-proposal.md)
- [NFL Data Integration Proposal](../docs/NFL_DATA_INTEGRATION_PROPOSAL.md)
