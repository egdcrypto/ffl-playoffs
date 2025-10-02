# FFL Playoffs API

A Spring Boot application for managing fantasy football playoff games, built with hexagonal (ports and adapters) architecture.

## Overview

This API allows users to create fantasy football playoff games where players select NFL teams each week and compete based on real game scores. The application follows Domain-Driven Design principles and hexagonal architecture to ensure clean separation of concerns.

## Architecture

The project follows **Hexagonal Architecture** (Ports and Adapters pattern) with three main layers:

### Domain Layer (`com.ffl.playoffs.domain`)
- **Pure business logic** with zero framework dependencies
- **Models**: Core entities (Game, Player, TeamSelection, Week, Score)
- **Events**: Domain events (GameCreatedEvent, TeamEliminatedEvent)
- **Services**: Business logic services (ScoringService)
- **Ports**: Interfaces defining contracts (GameRepository, PlayerRepository, NflDataProvider)

### Application Layer (`com.ffl.playoffs.application`)
- **Use Cases**: Application-specific business rules
  - CreateGameUseCase
  - InvitePlayerUseCase
  - SelectTeamUseCase
  - CalculateScoresUseCase
- **DTOs**: Data transfer objects for API communication
- **Services**: Application orchestration services

### Infrastructure Layer (`com.ffl.playoffs.infrastructure`)
- **REST Adapters**: HTTP controllers (GameController, PlayerController, AdminController)
- **Persistence Adapters**: Repository implementations (currently in-memory, ready for JPA)
- **Integration Adapters**: External service integrations (NflDataAdapter)
- **Configuration**: Spring configuration classes

### Dependency Rule
All dependencies point **inward** toward the domain:
```
Infrastructure → Application → Domain
```

## Technology Stack

- **Java 17**
- **Spring Boot 3.2.0**
- **Spring Data JPA**
- **Spring Security**
- **PostgreSQL** (production database)
- **Lombok** (boilerplate reduction)
- **SpringDoc OpenAPI** (API documentation)
- **JUnit 5 & Mockito** (testing)
- **Cucumber** (BDD/Gherkin tests)

## Prerequisites

- Java 17 or higher
- Gradle 7.x or higher
- PostgreSQL 14+ (for production)

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

- `DATABASE_URL`: PostgreSQL connection URL (default: `jdbc:postgresql://localhost:5432/ffl_playoffs`)
- `DATABASE_USERNAME`: Database username (default: `ffl_user`)
- `DATABASE_PASSWORD`: Database password (default: `ffl_password`)
- `JWT_ISSUER_URI`: JWT issuer URI for authentication
- `JWT_JWK_SET_URI`: JWT JWK set URI
- `PORT`: Server port (default: `8080`)

### Profiles

- **default**: Production configuration
- **dev**: Development configuration with debug logging and H2 console

## API Endpoints

### Games

- `POST /api/games` - Create a new game
- `GET /api/games` - List all games
- `GET /api/games/{id}` - Get game by ID

### Players

- `POST /api/players/invite` - Invite a player to a game
- `GET /api/players/{id}` - Get player by ID
- `GET /api/players/game/{gameId}` - List players in a game
- `POST /api/players/{playerId}/select-team` - Select a team for a week

### Admin

- `POST /api/admin/games/{gameId}/calculate-scores?weekNumber={week}` - Calculate scores for a week

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
│   │   │   ├── domain/          # Business logic (framework-agnostic)
│   │   │   ├── application/     # Use cases and DTOs
│   │   │   └── infrastructure/  # Framework implementations
│   │   └── resources/
│   │       ├── application.yml
│   │       └── application-dev.yml
│   └── test/
│       ├── java/                # Unit and integration tests
│       └── resources/
│           └── features/        # Gherkin/Cucumber tests
├── build.gradle
└── README.md
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
