# FFL Playoffs API

A Spring Boot application for managing Fantasy Football League Playoff games, built with hexagonal architecture principles.

## Overview

The FFL Playoffs API enables users to create and manage playoff elimination games where participants select NFL playoff teams each week. The game continues until only one player remains, with configurable scoring rules and team selection constraints.

## Architecture

This project follows **Hexagonal Architecture** (Ports and Adapters), ensuring a clean separation of concerns:

```
├── domain/              # Core business logic (framework-agnostic)
│   ├── model/          # Domain entities (Game, Player, TeamSelection, etc.)
│   ├── event/          # Domain events
│   ├── service/        # Domain services (ScoringService)
│   └── port/           # Interfaces for external dependencies
├── application/         # Application use cases and orchestration
│   ├── usecase/        # Use case implementations
│   ├── dto/            # Data transfer objects
│   └── service/        # Application services
└── infrastructure/      # External adapters and configurations
    ├── adapter/
    │   ├── rest/       # REST controllers
    │   ├── persistence/# Database implementations
    │   └── integration/# External API clients
    └── config/         # Spring configuration
```

### Key Principles

- **Domain Layer**: Contains no framework dependencies, pure business logic
- **Application Layer**: Orchestrates use cases, coordinates domain objects
- **Infrastructure Layer**: Implements ports, handles external concerns
- **Dependency Rule**: All dependencies point inward toward the domain

## Technology Stack

- **Java 17**
- **Spring Boot 3.2.1**
- **Spring Data MongoDB**
- **MongoDB**
- **Lombok**
- **OpenAPI/Swagger**
- **Cucumber** (BDD testing)
- **JUnit 5 & Mockito**

## Prerequisites

- Java 17 or higher
- MongoDB 6.0+ (for production/development)
- Gradle 8.x (wrapper included)

## Getting Started

### 1. Database Setup

Start MongoDB locally or use Docker:

```bash
docker run -d \
  --name ffl-mongodb \
  -p 27017:27017 \
  -e MONGO_INITDB_DATABASE=ffl_playoffs \
  mongo:6
```

Or install MongoDB locally:
```bash
# macOS
brew install mongodb-community@6.0

# Ubuntu
sudo apt install mongodb-org

# Start MongoDB
mongod --dbpath /path/to/data
```

### 2. Environment Configuration

Create a `.env` file or set environment variables:

```bash
MONGODB_URI=mongodb://localhost:27017/ffl_playoffs
```

### 3. Build the Project

```bash
./gradlew build
```

### 4. Run the Application

```bash
./gradlew bootRun
```

Or use the development profile:

```bash
./gradlew bootRun --args='--spring.profiles.active=dev'
```

The API will be available at `http://localhost:8080`

## API Documentation

Once the application is running, access the interactive API documentation:

- **Swagger UI**: http://localhost:8080/swagger-ui.html
- **OpenAPI Spec**: http://localhost:8080/api-docs

## API Endpoints Overview

### Game Management
- `POST /api/v1/games` - Create a new game
- `GET /api/v1/games/{gameId}` - Get game details
- `GET /api/v1/games` - List all games

### Player Management
- `POST /api/v1/players/invite` - Invite a player to a game
- `POST /api/v1/players/{playerId}/teams` - Select a team for a week
- `GET /api/v1/players/{playerId}` - Get player details
- `GET /api/v1/players/{playerId}/teams` - Get player's team selections

### Admin
- `POST /api/v1/admin/games/{gameId}/calculate-scores` - Calculate scores for a week
- `POST /api/v1/admin/games/{gameId}/advance-week` - Advance to next week
- `GET /api/v1/admin/games/{gameId}/status` - Get game status

## Development

### Running Tests

```bash
# Run all tests
./gradlew test

# Run specific test class
./gradlew test --tests "com.ffl.playoffs.domain.service.ScoringServiceTest"

# Run with coverage
./gradlew test jacocoTestReport
```

### Code Style

This project uses standard Java conventions with Lombok to reduce boilerplate.

### Database Migrations

MongoDB is schemaless, but we use Spring Data MongoDB for document mapping. Schema validation and indexes are defined in the domain models using annotations.

## Project Structure Details

### Domain Layer (`com.ffl.playoffs.domain`)

**Models:**
- `Game` - Represents a playoff game instance
- `Player` - Represents a game participant
- `TeamSelection` - A player's team choice for a specific week
- `Week` - Represents a game week
- `Score` - Player's score for a week
- `ScoringRules` - Configurable scoring parameters

**Ports (Interfaces):**
- `GameRepository` - Game persistence operations
- `PlayerRepository` - Player persistence operations
- `NflDataProvider` - External NFL data integration

**Services:**
- `ScoringService` - Core scoring logic

### Application Layer (`com.ffl.playoffs.application`)

**Use Cases:**
- `CreateGameUseCase` - Create a new game
- `InvitePlayerUseCase` - Invite players
- `SelectTeamUseCase` - Handle team selections
- `CalculateScoresUseCase` - Calculate weekly scores

**DTOs:**
- `GameDTO`, `PlayerDTO`, `TeamSelectionDTO` - Data transfer objects for API

### Infrastructure Layer (`com.ffl.playoffs.infrastructure`)

**REST Controllers:**
- `GameController` - Game management endpoints
- `PlayerController` - Player and team selection endpoints
- `AdminController` - Administrative operations

**Persistence:**
- `GameRepositoryImpl` - MongoDB implementation of GameRepository
- `PlayerRepositoryImpl` - MongoDB implementation of PlayerRepository

**Integration:**
- `NflDataAdapter` - NFL data API client implementation

## Configuration

### Application Profiles

- **default**: Production settings
- **dev**: Development mode (detailed logging, etc.)

### Key Configuration Properties

See `src/main/resources/application.yml` and `application-dev.yml`

## Security

The application uses Spring Security with:
- JWT token-based authentication (to be implemented)
- Role-based access control (ADMIN, USER)
- CORS configuration for frontend integration

## Contributing

1. Follow hexagonal architecture principles
2. Keep domain layer free of framework dependencies
3. Write tests for all use cases
4. Use Gherkin feature files for BDD tests
5. Update API documentation when adding endpoints

## License

MIT License

## Contact

For questions or support, contact: support@fflplayoffs.com
