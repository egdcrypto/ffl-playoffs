# FFL Playoffs API

A Fantasy Football League Playoffs game API built with Spring Boot following Hexagonal Architecture (Ports & Adapters) principles.

## Overview

FFL Playoffs is a fantasy football game where players select one NFL playoff team per week. The lowest-scoring player each week is eliminated until one winner remains.

## Architecture

This project follows **Hexagonal Architecture** with clear separation of concerns:

```
domain/          - Pure business logic, no framework dependencies
├── model/       - Domain entities (Game, Player, TeamSelection, Week, Score)
├── event/       - Domain events (GameCreatedEvent, TeamEliminatedEvent)
├── service/     - Domain services (ScoringService)
└── port/        - Interfaces for external dependencies (repositories, providers)

application/     - Use case orchestration
├── usecase/     - Business use cases
├── dto/         - Data transfer objects
└── service/     - Application services

infrastructure/  - Framework & external integrations
├── adapter/
│   ├── rest/        - REST API controllers
│   ├── persistence/ - Database implementations
│   └── integration/ - External API integrations
└── config/          - Spring configuration
```

### Key Principles

1. **Domain Independence**: Domain layer has NO Spring or framework dependencies
2. **Dependency Inversion**: All dependencies point inward (toward domain)
3. **Ports & Adapters**: External systems interact through interfaces (ports)
4. **Testability**: Each layer can be tested independently

## Technology Stack

- **Java 17**
- **Spring Boot 3.2.x**
- **Spring Data JPA** - Persistence
- **PostgreSQL** - Database
- **Lombok** - Boilerplate reduction
- **OpenAPI/Swagger** - API documentation
- **JUnit 5 & Mockito** - Testing
- **Cucumber** - BDD testing

## Getting Started

### Prerequisites

- Java 17 or higher
- PostgreSQL 14+
- Gradle 8.x

### Database Setup

```bash
# Create database
createdb ffl_playoffs_dev

# Set environment variables
export DB_USERNAME=ffl_user
export DB_PASSWORD=password
```

### Build & Run

```bash
# Build the project
./gradlew build

# Run tests
./gradlew test

# Run the application
./gradlew bootRun

# Or run with dev profile
./gradlew bootRun --args='--spring.profiles.active=dev'
```

The API will be available at: `http://localhost:8080/api`

### API Documentation

Once running, access Swagger UI at:
```
http://localhost:8080/api/swagger-ui.html
```

API docs (JSON):
```
http://localhost:8080/api/docs
```

## API Endpoints

### Game Management
- `POST /api/games` - Create a new game
- `POST /api/games/join` - Join a game with invite code

### Player Actions
- `POST /api/players/{playerId}/selections` - Select an NFL team for the week

### Admin Operations
- `POST /api/admin/weeks/{weekId}/calculate-scores` - Calculate scores for a week

## Development

### Running with Different Profiles

```bash
# Development (auto-create tables, verbose logging)
./gradlew bootRun --args='--spring.profiles.active=dev'

# Production (validate schema, minimal logging)
./gradlew bootRun
```

### Testing

```bash
# Run all tests
./gradlew test

# Run with coverage
./gradlew test jacocoTestReport

# Run Cucumber BDD tests
./gradlew test --tests "*CucumberTest"
```

## Project Status

This is the initial project structure. Key areas requiring implementation:

### Domain Layer
- ✅ Domain models defined
- ✅ Port interfaces defined
- ⏳ ScoringService implementation needed

### Application Layer
- ✅ Use cases scaffolded
- ⏳ Complete business logic implementation
- ⏳ DTO validation

### Infrastructure Layer
- ✅ REST controllers scaffolded
- ⏳ JPA entity mappings needed
- ⏳ Repository implementations needed
- ⏳ NFL Data API integration needed
- ⏳ Authentication/Authorization

## Configuration

Key configuration in `application.yml`:

- **Database**: PostgreSQL connection settings
- **JPA**: Hibernate settings
- **Security**: OAuth2/JWT configuration (to be implemented)
- **Swagger**: API documentation settings

## Contributing

When adding new features, follow these principles:

1. Start with domain model changes
2. Define ports (interfaces) if external dependencies needed
3. Implement use cases in application layer
4. Add adapters (controllers, repositories) in infrastructure layer
5. Write tests at each layer

## License

Proprietary - FFL Playoffs Project
