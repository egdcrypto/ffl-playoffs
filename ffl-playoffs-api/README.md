# FFL Playoffs API

A Spring Boot application for managing fantasy football playoff games, built with hexagonal (ports and adapters) architecture.

## Overview

This API allows users to create fantasy football playoff games where players select NFL teams each week and compete based on real game scores. The application follows Domain-Driven Design principles and hexagonal architecture to ensure clean separation of concerns.

## Architecture

The project follows **Hexagonal Architecture** (Ports and Adapters pattern) with three main layers:

### Domain Layer (`com.ffl.playoffs.domain`)
- **Pure business logic** with zero framework dependencies
- **Models**: Core entities
  - Game, Player, TeamSelection, Week, Score
  - League, LeaguePlayer, User, PersonalAccessToken
  - NFLPlayer, NFLTeam, NFLGame
  - Roster, RosterConfiguration, RosterSlot, RosterSelection
  - Position, Role, PlayerStats, ScoringRules (PPR, FieldGoal, Defensive)
  - Enums: GameStatus, PlayerStatus, WeekStatus, PATScope
- **Events**: Domain events (GameCreatedEvent, TeamEliminatedEvent)
- **Services**: Business logic services (ScoringService)
- **Ports**: Interfaces defining contracts
  - GameRepository, PlayerRepository, TeamSelectionRepository
  - LeagueRepository, LeaguePlayerRepository, UserRepository
  - RosterRepository, NFLPlayerRepository, NFLTeamRepository
  - PersonalAccessTokenRepository, LeaderboardRepository
  - NflDataProvider (external data integration)

### Application Layer (`com.ffl.playoffs.application`)
- **Use Cases**: Application-specific business rules (30+ use cases)
  - Game Management: CreateGameUseCase, ProcessGameResultsUseCase
  - Player Management: InvitePlayerUseCase, AcceptPlayerInvitationUseCase
  - Team Selection: SelectTeamUseCase, BuildRosterUseCase, LockRosterUseCase
  - League Management: CreateLeagueUseCase, ConfigureLeagueUseCase
  - User Management: CreateUserAccountUseCase, AssignRoleUseCase
  - Authentication: ValidateGoogleJWTUseCase, ValidatePATUseCase, CreatePATUseCase
  - Scoring: CalculateScoresUseCase, SyncNFLDataUseCase
  - Admin: InviteAdminUseCase, AcceptAdminInvitationUseCase
  - Roster: ValidateRosterUseCase, AddNFLPlayerToSlotUseCase
  - Data Sync: FetchNFLScheduleUseCase, SyncNFLDataUseCase
- **DTOs**: Data transfer objects for API communication
  - GameDTO, PlayerDTO, TeamSelectionDTO, LeagueDTO
  - RosterDTO, RosterSlotDTO, RosterConfigurationDTO
  - NFLTeamDTO, ScoringRulesDTO, LeaderboardEntryDTO
  - Pagination: Page, PageRequest, PageLinks
- **Services**: Application orchestration services (ApplicationService)

### Infrastructure Layer (`com.ffl.playoffs.infrastructure`)
- **REST Adapters**: HTTP controllers with comprehensive API
  - GameController, PlayerController, AdminController, SuperAdminController
  - LeagueController, RosterController, LeaderboardController
  - NFLPlayerController
  - Common response wrapper: ApiResponse
- **Persistence Adapters**: MongoDB-based repository implementations
  - Document models for persistence (GameDocument, LeagueDocument, etc.)
  - Repository implementations (GameRepositoryImpl, LeagueRepositoryImpl, etc.)
  - Spring Data MongoDB repositories
  - Mappers for domain ↔ document conversion
- **Integration Adapters**: External NFL data integration
  - NflDataAdapter (main adapter)
  - SportsDataIO integration (SportsDataIoFantasyAdapter, SportsDataIoFantasyClient)
  - Caching decorator (CachingNflDataDecorator)
  - Rate limiting decorator (RateLimitingNflDataDecorator)
  - Custom DTOs for external API responses
- **Authentication & Authorization**: Complete auth system
  - GoogleJwtValidator, PATValidator, TokenValidator
  - AuthService, AuthServiceConfiguration
  - SecurityConfig with role-based access control
- **Configuration**: Spring configuration classes (SpringConfig, SecurityConfig)

### Dependency Rule
All dependencies point **inward** toward the domain:
```
Infrastructure → Application → Domain
```

## Technology Stack

- **Java 17**
- **Spring Boot 3.2.0**
- **Spring Data JPA** (ORM)
- **Spring Data MongoDB** (NoSQL persistence)
- **Spring Security** (Authentication & Authorization)
- **Spring Web** (REST API)
- **PostgreSQL** (relational database - optional)
- **MongoDB** (primary NoSQL database)
- **Lombok** (boilerplate reduction)
- **SpringDoc OpenAPI** (API documentation / Swagger)
- **Jackson** (JSON serialization)
- **JUnit 5 & Mockito** (unit testing)
- **Cucumber** (BDD/Gherkin acceptance tests)
- **H2** (in-memory testing database)

## Prerequisites

- Java 17 or higher
- Gradle 7.x or higher
- MongoDB 4.4+ (primary database)
- PostgreSQL 14+ (optional, for relational data)

## Build Instructions

### Building the Project

```bash
# Build the project
./gradlew build

# Run without tests
./gradlew build -x test

# Clean and build
./gradlew clean build
```

### Running the Application

```bash
# Run with default configuration
./gradlew bootRun

# Run with dev profile
./gradlew bootRun --args='--spring.profiles.active=dev'
```

The application will start on `http://localhost:8080`

### Running Tests

```bash
# Run all tests
./gradlew test

# Run tests with coverage
./gradlew test jacocoTestReport
```

## Configuration

### Environment Variables

Configure the following environment variables for production:

**Database**:
- `MONGODB_URI`: MongoDB connection URI (default: `mongodb://localhost:27017/ffl-playoffs`)
- `DATABASE_URL`: PostgreSQL connection URL (optional, default: `jdbc:postgresql://localhost:5432/ffl_playoffs`)
- `DATABASE_USERNAME`: Database username (default: `ffl_user`)
- `DATABASE_PASSWORD`: Database password (default: `ffl_password`)

**Authentication**:
- `JWT_ISSUER_URI`: Google JWT issuer URI for authentication
- `JWT_JWK_SET_URI`: Google JWT JWK set URI
- `GOOGLE_CLIENT_ID`: Google OAuth client ID

**External APIs**:
- `SPORTSDATA_IO_API_KEY`: SportsData.io API key for NFL data

**Server**:
- `PORT`: Server port (default: `8080`)
- `SPRING_PROFILES_ACTIVE`: Active profile (dev, prod)

### Profiles

- **default**: Production configuration
- **dev**: Development configuration with debug logging and H2 console

## API Endpoints

### Games
- `POST /api/games` - Create a new game
- `GET /api/games` - List all games
- `GET /api/games/{id}` - Get game by ID
- `POST /api/games/{gameId}/process-results` - Process game results

### Leagues
- `POST /api/leagues` - Create a new league
- `GET /api/leagues` - List all leagues (paginated)
- `GET /api/leagues/{id}` - Get league by ID
- `PUT /api/leagues/{id}/configuration` - Configure league settings
- `POST /api/leagues/{id}/invite-player` - Invite player to league
- `POST /api/leagues/{id}/invite-admin` - Invite admin to league
- `GET /api/leagues/{leagueId}/leaderboard` - Get league leaderboard

### Players
- `POST /api/players/invite` - Invite a player to a game
- `GET /api/players/{id}` - Get player by ID
- `GET /api/players/game/{gameId}` - List players in a game
- `POST /api/players/{playerId}/select-team` - Select a team for a week
- `POST /api/players/accept-invitation` - Accept player invitation

### Rosters
- `POST /api/rosters` - Build a roster
- `GET /api/rosters/{rosterId}` - Get roster by ID
- `POST /api/rosters/{rosterId}/slots` - Add NFL player to slot
- `POST /api/rosters/{rosterId}/lock` - Lock roster (finalize)
- `POST /api/rosters/validate` - Validate roster configuration

### NFL Data
- `GET /api/nfl/players` - Get NFL players (paginated, filterable)
- `GET /api/nfl/teams` - Get NFL teams
- `POST /api/nfl/sync` - Sync NFL data from external API
- `GET /api/nfl/schedule` - Fetch NFL schedule

### Admin
- `POST /api/admin/games/{gameId}/calculate-scores?weekNumber={week}` - Calculate scores for a week
- `POST /api/admin/assign-role` - Assign role to user
- `POST /api/admin/accept-invitation` - Accept admin invitation

### Super Admin
- `POST /api/superadmin/users` - Create user account
- `POST /api/superadmin/pat` - Create Personal Access Token
- `GET /api/superadmin/pat` - List all PATs
- `DELETE /api/superadmin/pat/{tokenId}` - Delete PAT
- `POST /api/superadmin/pat/{tokenId}/revoke` - Revoke PAT
- `POST /api/superadmin/pat/{tokenId}/rotate` - Rotate PAT

### API Documentation

Swagger UI is available at:
- **Development**: `http://localhost:8080/swagger-ui.html`
- **OpenAPI Spec**: `http://localhost:8080/api-docs`

## Development

### Project Structure

```
ffl-playoffs-api/
├── src/
│   ├── main/
│   │   ├── java/com/ffl/playoffs/
│   │   │   ├── domain/                      # Business logic (framework-agnostic)
│   │   │   │   ├── model/                   # Core entities and value objects
│   │   │   │   ├── event/                   # Domain events
│   │   │   │   ├── service/                 # Domain services
│   │   │   │   └── port/                    # Ports (interfaces)
│   │   │   ├── application/                 # Use cases and DTOs
│   │   │   │   ├── usecase/                 # Application use cases
│   │   │   │   ├── dto/                     # Data transfer objects
│   │   │   │   └── service/                 # Application services
│   │   │   ├── infrastructure/              # Framework implementations
│   │   │   │   ├── adapter/
│   │   │   │   │   ├── rest/                # REST controllers
│   │   │   │   │   ├── persistence/         # Database adapters (MongoDB)
│   │   │   │   │   │   ├── document/        # MongoDB documents
│   │   │   │   │   │   ├── mapper/          # Domain ↔ Document mappers
│   │   │   │   │   │   └── repository/      # Spring Data repositories
│   │   │   │   │   └── integration/         # External API integrations
│   │   │   │   │       ├── sportsdataio/    # SportsData.io client
│   │   │   │   │       ├── cache/           # Caching decorators
│   │   │   │   │       └── ratelimit/       # Rate limiting
│   │   │   │   ├── auth/                    # Authentication system
│   │   │   │   ├── config/                  # Spring configuration
│   │   │   │   └── scripts/                 # Utility scripts
│   │   │   ├── Application.java             # Main application class
│   │   │   └── FflPlayoffsApiApplication.java
│   │   └── resources/
│   │       ├── application.yml              # Main configuration
│   │       └── application-dev.yml          # Development profile
│   └── test/
│       ├── java/                            # Unit and integration tests
│       │   └── com/ffl/playoffs/
│       │       ├── domain/                  # Domain model tests
│       │       ├── application/             # Use case tests
│       │       ├── infrastructure/          # Adapter tests
│       │       └── bdd/                     # BDD step definitions
│       └── resources/
│           ├── features/                    # Gherkin/Cucumber feature files
│           └── application-test.yml         # Test configuration
├── build.gradle                             # Gradle build configuration
└── README.md                                # This file
```

### Adding a New Feature

1. **Define domain model** in `domain/model/`
2. **Create port interface** in `domain/port/` if external integration needed
3. **Implement use case** in `application/usecase/`
4. **Create adapter** in `infrastructure/adapter/` (REST controller, repository impl, etc.)
5. **Write tests** at each layer

### Testing Strategy

- **Domain**: Pure unit tests with no mocks
- **Application**: Unit tests with mocked ports
- **Infrastructure**: Integration tests with test containers
- **End-to-end**: Cucumber/Gherkin scenarios

## Next Steps

1. **Implement JPA entities** and replace in-memory repositories
2. **Add database migrations** (Flyway or Liquibase)
3. **Implement NFL data integration** (replace NflDataAdapter stub)
4. **Add authentication and authorization**
5. **Implement real-time notifications** (WebSockets)
6. **Add comprehensive test coverage**
7. **Set up CI/CD pipeline**

## License

Proprietary - All rights reserved
