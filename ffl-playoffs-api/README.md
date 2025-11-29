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
- **MongoDB** - Document storage for game state and events
- **Redis** - Caching layer
- **Lombok** - Boilerplate reduction
- **OpenAPI/Swagger** - API documentation
- **JUnit 5 & Mockito** - Testing
- **Cucumber** - BDD testing

## Getting Started

### Prerequisites

- **Java 17 or higher** - Required for Spring Boot 3.2.x
- **Gradle 8.x** - Build tool (wrapper included)
- **PostgreSQL 14+** - Relational database
- **MongoDB 4.0+** - Document database for game state
- **Redis** (Optional) - Caching layer for performance

### Database Setup

#### PostgreSQL Setup

```bash
# Create database
createdb ffl_playoffs

# Set environment variables (or use defaults)
export DB_USERNAME=ffl_user
export DB_PASSWORD=password
```

#### MongoDB Setup

```bash
# Using Docker (recommended for development)
docker run -d -p 27017:27017 --name ffl-mongodb mongo:7.0

# Or install locally and ensure MongoDB is running on default port 27017
# The application will connect to: mongodb://localhost:27017/ffl_playoffs

# Set custom MongoDB connection (optional)
export MONGODB_URI=mongodb://localhost:27017
export MONGODB_DATABASE=ffl_playoffs
```

#### Redis Setup (Optional)

```bash
# Using Docker (recommended)
docker run -d -p 6379:6379 --name ffl-redis redis:7

# Or set custom Redis connection
export REDIS_HOST=localhost
export REDIS_PORT=6379
export REDIS_PASSWORD=
```

## Running the API Standalone

### Quick Start

```bash
# Ensure you're in the ffl-playoffs-api directory
cd ffl-playoffs-api

# Build and run in one command (default profile)
./gradlew bootRun
```

The API will start on: `http://localhost:8080/api`

### Running with Different Profiles

The application supports multiple Spring profiles for different environments:

#### Default Profile (No profile specified)
```bash
./gradlew bootRun
```
- Uses `application.yml` configuration
- JPA validation mode (validates database schema)
- INFO level logging
- Best for: Local development with existing database

#### Production Profile
```bash
./gradlew bootRun --args='--spring.profiles.active=production'
```
- Uses `application-production.yml` configuration
- Binds to localhost only (127.0.0.1:8080)
- Management port on 8081
- INFO level logging
- **Requires**: `MONGODB_URI` environment variable
- Best for: Production deployment

#### Auth Service Profile
```bash
./gradlew bootRun --args='--spring.profiles.active=auth'
```
- Uses `application-auth.yml` configuration
- Runs on port 9191 (for Envoy ext_authz)
- **Requires**: `GOOGLE_OAUTH_CLIENT_ID` environment variable
- Best for: Running the authentication service

#### Test Profile
```bash
./gradlew test
```
- Uses `application-test.yml` (automatically)
- Uses embedded/test MongoDB
- DEBUG level logging for troubleshooting
- Best for: Running tests

### Environment Variables

The application uses environment variables for configuration. Here are the key variables:

| Variable | Default | Description |
|----------|---------|-------------|
| `DB_USERNAME` | `ffl_user` | PostgreSQL username |
| `DB_PASSWORD` | `password` | PostgreSQL password |
| `MONGODB_URI` | `mongodb://localhost:27017` | MongoDB connection string |
| `MONGODB_DATABASE` | `ffl_playoffs` | MongoDB database name |
| `REDIS_HOST` | `localhost` | Redis server host |
| `REDIS_PORT` | `6379` | Redis server port |
| `REDIS_PASSWORD` | _(empty)_ | Redis password (if required) |
| `JWT_ISSUER_URI` | `https://accounts.google.com` | JWT token issuer |
| `GOOGLE_OAUTH_CLIENT_ID` | _(required for auth profile)_ | Google OAuth client ID |

### Setting Environment Variables

```bash
# Linux/Mac
export MONGODB_URI=mongodb://localhost:27017
export DB_USERNAME=myuser
export DB_PASSWORD=mypassword

# Windows (PowerShell)
$env:MONGODB_URI="mongodb://localhost:27017"
$env:DB_USERNAME="myuser"
$env:DB_PASSWORD="mypassword"

# Or create a .env file and source it
cat > .env << 'EOF'
MONGODB_URI=mongodb://localhost:27017
MONGODB_DATABASE=ffl_playoffs
DB_USERNAME=ffl_user
DB_PASSWORD=secure_password
EOF

source .env  # Linux/Mac
```

### Building and Running the JAR

If you prefer to run a standalone JAR file:

```bash
# Build the JAR file
./gradlew clean build

# The JAR will be created at: build/libs/ffl-playoffs-api-0.0.1-SNAPSHOT.jar

# Run the JAR
java -jar build/libs/ffl-playoffs-api-0.0.1-SNAPSHOT.jar

# Run with specific profile
java -jar build/libs/ffl-playoffs-api-0.0.1-SNAPSHOT.jar --spring.profiles.active=production

# Run with custom port
java -jar build/libs/ffl-playoffs-api-0.0.1-SNAPSHOT.jar --server.port=9090
```

### Development Workflow Tips

```bash
# Clean build (removes previous build artifacts)
./gradlew clean build

# Run without tests (faster for quick iteration)
./gradlew build -x test

# Run in continuous build mode (auto-rebuild on changes)
./gradlew bootRun --continuous

# Check for dependency updates
./gradlew dependencyUpdates

# View all available Gradle tasks
./gradlew tasks
```

### Common Troubleshooting

#### MongoDB Connection Issues

**Error**: `MongoSocketOpenException: Exception opening socket`

**Solution**:
```bash
# Verify MongoDB is running
docker ps | grep mongo
# or
mongosh --eval "db.version()"

# Check connection string
echo $MONGODB_URI

# Restart MongoDB container
docker restart ffl-mongodb
```

#### PostgreSQL Connection Issues

**Error**: `PSQLException: Connection refused`

**Solution**:
```bash
# Verify PostgreSQL is running
pg_isready

# Check if database exists
psql -l | grep ffl_playoffs

# Create database if missing
createdb ffl_playoffs

# Verify credentials
psql -U $DB_USERNAME -d ffl_playoffs -c "SELECT 1;"
```

#### Port Already in Use

**Error**: `Port 8080 is already in use`

**Solution**:
```bash
# Find process using port 8080
lsof -i :8080  # Mac/Linux
netstat -ano | findstr :8080  # Windows

# Kill the process or run on different port
./gradlew bootRun --args='--server.port=8081'
```

#### Out of Memory Errors

**Solution**:
```bash
# Increase heap size
export GRADLE_OPTS="-Xmx2g -Xms512m"
./gradlew bootRun

# Or for JAR execution
java -Xmx2g -Xms512m -jar build/libs/ffl-playoffs-api-0.0.1-SNAPSHOT.jar
```

#### Redis Connection Issues (Non-critical)

**Error**: `Unable to connect to Redis`

**Note**: Redis is optional for caching. The application will run without it, but with reduced performance.

**Solution**:
```bash
# Start Redis
docker run -d -p 6379:6379 --name ffl-redis redis:7

# Or disable Redis by setting cache type to none
./gradlew bootRun --args='--spring.cache.type=none'
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

### Testing

```bash
# Run all tests
./gradlew test

# Run with coverage
./gradlew test jacocoTestReport

# Run Cucumber BDD tests
./gradlew test --tests "*CucumberTest"

# Run specific test class
./gradlew test --tests "com.ffl.playoffs.application.usecase.*"

# Run tests with DEBUG output
./gradlew test --debug
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

- **Database**: PostgreSQL and MongoDB connection settings
- **JPA**: Hibernate settings for relational data
- **MongoDB**: Document storage for game state and events
- **Redis**: Caching configuration for performance
- **Security**: OAuth2/JWT configuration with Google authentication
- **Swagger**: API documentation settings

See the [Environment Variables](#environment-variables) section for configuration options.

## Contributing

When adding new features, follow these principles:

1. Start with domain model changes
2. Define ports (interfaces) if external dependencies needed
3. Implement use cases in application layer
4. Add adapters (controllers, repositories) in infrastructure layer
5. Write tests at each layer

## License

Proprietary - FFL Playoffs Project
