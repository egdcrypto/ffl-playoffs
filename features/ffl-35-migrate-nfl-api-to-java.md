# FFL-35: Migrate NFL Data Sync API to Java Spring Boot

@backend
## Overview
Migrate the NFL Data Sync API and WebSocket functionality from Python FastAPI to Java Spring Boot in `ffl-playoffs-api`. The Python `nfl-data-sync` module should remain as a data ingestion process only.

**Architecture:** Follow Hexagonal Architecture (Ports & Adapters) pattern:
- **Domain Layer** (`domain/`): Pure business logic, no framework dependencies
- **Application Layer** (`application/`): Use cases, orchestration
- **Infrastructure Layer** (`infrastructure/`): Adapters for persistence, web, external services

## Reference Documentation
- Existing Java API: `ffl-playoffs-api/`
- Python implementation to migrate: `nfl-data-sync/src/api/`
- MongoDB repositories (Python): `nfl-data-sync/src/infrastructure/adapters/mongodb_repositories.py`
- Domain models (Python): `nfl-data-sync/src/domain/models.py`
- MongoDB connection: `mongodb://localhost:30017`
- Database name: `ffl_playoffs`
- Collections: `nfl_players`, `nfl_games`, `player_stats`

## Requirements

### 1. Create Java Domain Models
Create domain models in `ffl-playoffs-api/src/main/java/com/ffl/playoffs/domain/model/nfl/`:
- `NFLPlayer.java` - player roster information
- `NFLGame.java` - game schedule and scores
- `PlayerStats.java` - weekly player statistics
- `GameStatus.java` enum (SCHEDULED, IN_PROGRESS, HALFTIME, FINAL, POSTPONED, CANCELLED)

### 2. Create MongoDB Repositories (Java)
Implement Spring Data MongoDB repositories in `ffl-playoffs-api/src/main/java/com/ffl/playoffs/infrastructure/persistence/`:
- `NFLPlayerRepository.java` - extends MongoRepository
- `NFLGameRepository.java` - extends MongoRepository
- `PlayerStatsRepository.java` - extends MongoRepository

### 3. Create Service Layer
Create services in `ffl-playoffs-api/src/main/java/com/ffl/playoffs/application/service/`:
- `NFLPlayerService.java`
- `NFLGameService.java`
- `PlayerStatsService.java`

### 4. Create REST API Endpoints
Create REST controllers in `ffl-playoffs-api/src/main/java/com/ffl/playoffs/infrastructure/web/` with Swagger/OpenAPI documentation:

**NFLPlayerController:**
- `GET /api/v1/nfl/players` - List all players (with pagination)
- `GET /api/v1/nfl/players/{playerId}` - Get player by ID
- `GET /api/v1/nfl/players/team/{team}` - Get players by team

**NFLGameController:**
- `GET /api/v1/nfl/games` - List games (with season/week filters)
- `GET /api/v1/nfl/games/{gameId}` - Get game by ID
- `GET /api/v1/nfl/games/week/{season}/{week}` - Get games for specific week

**PlayerStatsController:**
- `GET /api/v1/nfl/stats/week/{season}/{week}` - Get all stats for a week
- `GET /api/v1/nfl/stats/player/{playerId}` - Get stats for a player

### 5. Create WebSocket Support
Implement WebSocket for real-time NFL data updates:
- Configuration: `WebSocketConfig.java`
- Handler: `NFLDataWebSocketHandler.java`
- Endpoint: `/ws/nfl-updates`
- Support subscription to specific games or players
- Broadcast stat changes in real-time

### 6. Write Cucumber Step Definitions
Create BDD step definitions in `ffl-playoffs-api/src/test/java/com/ffl/playoffs/bdd/steps/`:
- `NflDataSteps.java` - Steps for NFL data API testing

Create feature file `ffl-playoffs-api/src/test/resources/features/nfl-data-api.feature`:
```gherkin
Feature: NFL Data API
  Scenario: Get players by team
    Given the NFL data has been synced
    When I request players for team "KC"
    Then I should receive a list of Kansas City Chiefs players

  Scenario: Get game schedule for week
    Given the NFL data has been synced
    When I request games for season 2024 week 15
    Then I should receive 16 games

  Scenario: Get player stats for week
    Given the NFL data has been synced
    When I request stats for season 2024 week 15
    Then I should receive player statistics
```

### 7. Write Unit Tests
Create unit tests in `ffl-playoffs-api/src/test/java/com/ffl/playoffs/`:
- `domain/model/nfl/NFLPlayerTest.java`
- `domain/model/nfl/NFLGameTest.java`
- `domain/model/nfl/PlayerStatsTest.java`
- `application/service/NFLPlayerServiceTest.java`
- `application/service/NFLGameServiceTest.java`
- `application/service/PlayerStatsServiceTest.java`
- `infrastructure/web/NFLPlayerControllerTest.java`
- `infrastructure/web/NFLGameControllerTest.java`
- `infrastructure/web/PlayerStatsControllerTest.java`

### 8. Integration Tests
Create integration tests that:
- Test full API flow with real MongoDB (localhost:30017)
- Test WebSocket connections
- Verify data retrieved matches what Python ingestion stored
- Use `@SpringBootTest` with test containers or real MongoDB

## Acceptance Criteria
- [ ] All REST endpoints return correct data from MongoDB
- [ ] Swagger UI accessible at `/swagger-ui.html`
- [ ] All endpoints documented with OpenAPI annotations
- [ ] WebSocket broadcasts work correctly
- [ ] All unit tests pass (`./gradlew test`)
- [ ] All integration tests pass
- [ ] Cucumber scenarios pass
- [ ] Build succeeds (`./gradlew build`)

## Technical Notes
- Use existing Spring Boot patterns from `ffl-playoffs-api`
- SpringDoc OpenAPI already configured in build.gradle
- MongoDB starter already in dependencies
- Follow hexagonal architecture pattern already established
- Use Lombok for boilerplate reduction

## Build & Test Commands
```bash
cd ffl-playoffs-api
./gradlew clean build
./gradlew test
./gradlew bootRun
```

## Verify Swagger
After starting the app, verify Swagger at:
- http://localhost:8080/swagger-ui.html
- http://localhost:8080/v3/api-docs
