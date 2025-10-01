# FFL Playoffs Development Guide

## Table of Contents
1. [Overview](#overview)
2. [Prerequisites](#prerequisites)
3. [Local Development Setup](#local-development-setup)
4. [Running the Application](#running-the-application)
5. [Database Setup](#database-setup)
6. [Testing](#testing)
7. [Code Structure](#code-structure)
8. [Development Workflow](#development-workflow)
9. [Debugging](#debugging)
10. [Common Issues](#common-issues)

## Overview

This guide covers setting up the FFL Playoffs application for local development. The application consists of:
- **Main API** (Spring Boot Java application)
- **Auth Service** (Token validation service)
- **MongoDB Database**
- **Envoy Proxy** (optional for local development)

## Prerequisites

### Required Software

| Software      | Version       | Purpose                           |
|---------------|---------------|-----------------------------------|
| Java          | 17+           | Main API runtime                  |
| Gradle        | 8.0+          | Build tool                        |
| MongoDB       | 6+            | Database                          |
| Docker        | 20.10+        | Containerization (optional)       |
| Git           | 2.30+         | Version control                   |
| IDE           | IntelliJ/VSCode | Development environment        |

### Optional Tools

| Tool          | Version       | Purpose                           |
|---------------|---------------|-----------------------------------|
| Envoy         | 1.28+         | Proxy (testing auth flow)         |
| Postman       | Latest        | API testing                       |
| DBeaver       | Latest        | Database management               |
| k9s           | Latest        | Kubernetes management (optional)  |

---

## Local Development Setup

### 1. Clone the Repository

```bash
git clone https://github.com/your-org/ffl-playoffs.git
cd ffl-playoffs
```

---

### 2. Install Java 17

**macOS (Homebrew)**:
```bash
brew install openjdk@17
sudo ln -sfn /opt/homebrew/opt/openjdk@17/libexec/openjdk.jdk \
  /Library/Java/JavaVirtualMachines/openjdk-17.jdk
```

**Ubuntu/Debian**:
```bash
sudo apt update
sudo apt install openjdk-17-jdk
```

**Verify Installation**:
```bash
java -version
# Should show: openjdk version "17.x.x"
```

---

### 3. Install MongoDB

**macOS (Homebrew)**:
```bash
brew tap mongodb/brew
brew install mongodb-community@6.0
brew services start mongodb-community@6.0
```

**Ubuntu/Debian**:
```bash
sudo apt update
sudo apt install -y mongodb-org
sudo systemctl start mongod
sudo systemctl enable mongod
```

**Docker (Alternative)**:
```bash
docker run --name ffl-mongodb \
  -p 27017:27017 \
  -d mongo:6
```

---

### 4. Configure Database

```bash
# MongoDB will automatically create the database on first connection
# No manual database creation needed

# Optional: Connect to MongoDB shell to verify
mongosh

# List databases
show dbs

# Exit MongoDB shell
exit
```

---

### 5. Configure Application

Create `ffl-playoffs-api/src/main/resources/application-dev.yml`:

```yaml
spring:
  application:
    name: ffl-playoffs-api

  data:
    mongodb:
      uri: mongodb://localhost:27017/ffl_playoffs
      # Optional: Uncomment for authentication
      # username: ffl_user
      # password: ffl_password
      # authentication-database: admin

  jackson:
    serialization:
      write-dates-as-timestamps: false
    default-property-inclusion: non_null

server:
  port: 8080
  error:
    include-message: always
    include-binding-errors: always

springdoc:
  api-docs:
    path: /api-docs
  swagger-ui:
    path: /swagger-ui.html
    enabled: true

logging:
  level:
    com.ffl.playoffs: DEBUG
    org.springframework: INFO
    org.springframework.data.mongodb: DEBUG

# Development-specific settings
management:
  endpoints:
    web:
      exposure:
        include: health,info,metrics,prometheus
  endpoint:
    health:
      show-details: always

# NFL API Configuration (optional for local dev)
nfl:
  api:
    url: ${NFL_API_URL:https://api.nfl.com/v1}
    key: ${NFL_API_KEY:your-api-key-here}
```

---

### 6. Environment Variables

Create `.env` file in project root:

```bash
# Database
MONGO_HOST=localhost
MONGO_PORT=27017
MONGO_DATABASE=ffl_playoffs
DB_PASSWORD=ffl_password

# NFL API (for external data integration)
NFL_API_URL=https://api.nfl.com/v1
NFL_API_KEY=your-nfl-api-key

# Google OAuth (for authentication testing)
GOOGLE_CLIENT_ID=your-google-client-id
GOOGLE_CLIENT_SECRET=your-google-client-secret
```

**Load environment variables**:
```bash
export $(cat .env | xargs)
```

---

## Running the Application

### Option 1: Using Gradle

```bash
cd ffl-playoffs-api

# Build the project
./gradlew clean build

# Run the application
./gradlew bootRun --args='--spring.profiles.active=dev'
```

**Application starts on**: `http://localhost:8080`

---

### Option 2: Using IDE (IntelliJ IDEA)

1. **Open Project**: File → Open → Select `ffl-playoffs` directory
2. **Import Gradle Project**: IntelliJ will auto-detect Gradle
3. **Set JDK**: File → Project Structure → Project SDK → Select JDK 17
4. **Create Run Configuration**:
   - Run → Edit Configurations → Add New → Spring Boot
   - Main class: `com.ffl.playoffs.Application`
   - VM options: `-Dspring.profiles.active=dev`
   - Environment variables: Load from `.env`
5. **Run**: Click Run button or `Shift + F10`

---

### Option 3: Using Docker Compose

Create `docker-compose.yml` in project root:

```yaml
version: '3.8'

services:
  mongodb:
    image: mongo:6
    container_name: ffl-mongodb
    environment:
      MONGO_INITDB_DATABASE: ffl_playoffs
    ports:
      - "27017:27017"
    volumes:
      - mongodb_data:/data/db

  api:
    build:
      context: ./ffl-playoffs-api
      dockerfile: Dockerfile
    container_name: ffl-api
    environment:
      SPRING_PROFILES_ACTIVE: dev
      MONGO_HOST: mongodb
      MONGO_PORT: 27017
      MONGO_DATABASE: ffl_playoffs
    ports:
      - "8080:8080"
    depends_on:
      - mongodb

volumes:
  mongodb_data:
```

**Run with Docker Compose**:
```bash
docker-compose up -d
```

---

## Database Setup

### Run Migrations

The application uses MongoDB migrations for database schema changes.

**Migrations location**: `ffl-playoffs-api/src/main/resources/db/migration/`

**Run migrations**:
```bash
# Migrations run automatically on application startup
./gradlew bootRun --args='--spring.profiles.active=dev'
```

**Manual migration** (mongosh):
```bash
mongosh mongodb://ffl_user:ffl_password@localhost:27017/ffl_playoffs \
  --file ./src/main/resources/db/migration/migration.js
```

---

### Seed Data (Development)

Create seed data script: `src/main/resources/db/seed/dev-data.js`

```javascript
// Insert test super admin
db.users.insertOne({
  _id: "a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a11",
  googleId: "google-admin-123",
  email: "admin@ffl-playoffs.com",
  name: "Test Admin",
  role: "SUPER_ADMIN",
  createdAt: new Date(),
  updatedAt: new Date()
});

// Insert test league
db.leagues.insertOne({
  _id: "b0eebc99-9c0b-4ef8-bb6d-6bb9bd380a22",
  adminId: "a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a11",
  name: "Test League 2025",
  description: "Development test league",
  startingWeek: 15,
  numberOfWeeks: 4,
  active: true,
  createdAt: new Date(),
  updatedAt: new Date()
});

// Insert test scoring rules
db.scoringRules.insertOne({
  _id: "c0eebc99-9c0b-4ef8-bb6d-6bb9bd380a33",
  leagueId: "b0eebc99-9c0b-4ef8-bb6d-6bb9bd380a22",
  passingYardsPerPoint: 25.0,
  rushingYardsPerPoint: 10.0,
  receivingYardsPerPoint: 10.0,
  receptionPoints: 1.0,
  touchdownPoints: 6.0,
  createdAt: new Date(),
  updatedAt: new Date()
});
```

**Load seed data**:
```bash
mongosh mongodb://ffl_user:ffl_password@localhost:27017/ffl_playoffs -f src/main/resources/db/seed/dev-data.js
```

---

## Testing

### Unit Tests

```bash
# Run all tests
./gradlew test

# Run specific test class
./gradlew test --tests "com.ffl.playoffs.domain.model.GameTest"

# Run with coverage
./gradlew test jacocoTestReport
```

**Coverage report**: `build/reports/jacoco/test/html/index.html`

---

### Integration Tests

```bash
# Run integration tests (uses Testcontainers)
./gradlew integrationTest

# Testcontainers will automatically start MongoDB Docker container
```

**Example Integration Test**:
```java
@SpringBootTest
@Testcontainers
class LeagueRepositoryIntegrationTest {

    @Container
    static MongoDBContainer mongo = new MongoDBContainer("mongo:6")
        .withExposedPorts(27017);

    @Test
    void shouldSaveAndRetrieveLeague() {
        // Test implementation
    }
}
```

---

### API Tests (Postman)

Import Postman collection: `docs/postman/FFL-Playoffs-API.postman_collection.json`

**Example Request**:
```bash
# Health check
curl http://localhost:8080/api/v1/public/health

# Create league (requires auth in production)
curl -X POST http://localhost:8080/api/v1/admin/leagues \
  -H "Content-Type: application/json" \
  -d '{
    "name": "Test League",
    "startingWeek": 15,
    "numberOfWeeks": 4
  }'
```

---

## Code Structure

### Project Layout

```
ffl-playoffs-api/
├── src/
│   ├── main/
│   │   ├── java/com/ffl/playoffs/
│   │   │   ├── Application.java                 # Spring Boot main class
│   │   │   ├── domain/                          # Domain layer (business logic)
│   │   │   │   ├── model/                       # Entities
│   │   │   │   │   ├── Game.java
│   │   │   │   │   ├── Player.java
│   │   │   │   │   ├── TeamSelection.java
│   │   │   │   │   └── ScoringRules.java
│   │   │   │   ├── service/                     # Domain services
│   │   │   │   │   ├── ScoringService.java
│   │   │   │   │   └── EliminationService.java
│   │   │   │   ├── port/                        # Port interfaces
│   │   │   │   │   ├── GameRepository.java
│   │   │   │   │   └── NflDataProvider.java
│   │   │   │   └── event/                       # Domain events
│   │   │   │       ├── TeamEliminatedEvent.java
│   │   │   │       └── GameCreatedEvent.java
│   │   │   ├── application/                     # Application layer (use cases)
│   │   │   │   ├── usecase/                     # Use cases
│   │   │   │   │   ├── CreateGameUseCase.java
│   │   │   │   │   ├── SelectTeamUseCase.java
│   │   │   │   │   └── CalculateScoresUseCase.java
│   │   │   │   ├── dto/                         # Data transfer objects
│   │   │   │   │   ├── GameDTO.java
│   │   │   │   │   └── PlayerDTO.java
│   │   │   │   └── service/                     # Application services
│   │   │   │       └── ApplicationService.java
│   │   │   └── infrastructure/                  # Infrastructure layer (adapters)
│   │   │       ├── adapter/
│   │   │       │   ├── rest/                    # REST controllers
│   │   │       │   │   ├── GameController.java
│   │   │       │   │   └── PlayerController.java
│   │   │       │   ├── persistence/             # Database adapters
│   │   │       │   │   ├── GameRepositoryAdapter.java
│   │   │       │   │   └── mongodb/
│   │   │       │   │       ├── GameMongoRepository.java
│   │   │       │   │       └── document/
│   │   │       │   │           └── GameDocument.java
│   │   │       │   └── integration/             # External API clients
│   │   │       │       └── NflApiClient.java
│   │   │       └── config/                      # Spring configuration
│   │   │           ├── DatabaseConfig.java
│   │   │           └── SecurityConfig.java
│   │   └── resources/
│   │       ├── application.yml                  # Default config
│   │       ├── application-dev.yml              # Dev config
│   │       ├── application-prod.yml             # Prod config
│   │       └── db/
│   │           └── migration/                   # MongoDB migrations
│   │               ├── V1__create_users_collection.js
│   │               ├── V2__create_leagues_collection.js
│   │               └── V3__create_team_selections_collection.js
│   └── test/
│       ├── java/com/ffl/playoffs/
│       │   ├── domain/                          # Domain tests
│       │   ├── application/                     # Application tests
│       │   └── infrastructure/                  # Integration tests
│       └── resources/
│           └── application-test.yml             # Test config
├── build.gradle                                 # Gradle build file
└── gradle.properties                            # Gradle properties
```

---

## Development Workflow

### 1. Create a New Feature

```bash
# Create feature branch
git checkout -b feature/team-elimination-logic

# Make changes
# ...

# Run tests
./gradlew test

# Commit changes
git add .
git commit -m "feat: implement team elimination logic"

# Push to remote
git push origin feature/team-elimination-logic
```

---

### 2. Code Style

**Java Code Style**: Google Java Style Guide

**Format code** (IntelliJ):
- Code → Reformat Code (`Cmd + Alt + L`)

**Install Google Java Format Plugin**:
1. Preferences → Plugins → Search "google-java-format"
2. Install plugin
3. Enable: Preferences → Other Settings → google-java-format → Enable

---

### 3. Pre-commit Hooks

Install pre-commit hooks:

```bash
# Install pre-commit
pip install pre-commit

# Setup hooks
pre-commit install
```

Create `.pre-commit-config.yaml`:
```yaml
repos:
  - repo: local
    hooks:
      - id: gradle-test
        name: Run Gradle Tests
        entry: ./gradlew test
        language: system
        pass_filenames: false
```

---

## Debugging

### Debug in IntelliJ IDEA

1. **Set Breakpoints**: Click left margin of code editor
2. **Debug Run Configuration**: Run → Debug 'Application'
3. **Debug Tools**:
   - Step Over: `F8`
   - Step Into: `F7`
   - Resume: `F9`
   - Evaluate Expression: `Alt + F8`

---

### Debug with Logs

**Enable debug logging** in `application-dev.yml`:
```yaml
logging:
  level:
    com.ffl.playoffs: DEBUG
    org.springframework.web: DEBUG
    org.springframework.data.mongodb: DEBUG
```

**Add logging to code**:
```java
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

public class GameService {
    private static final Logger log = LoggerFactory.getLogger(GameService.class);

    public void createGame(Game game) {
        log.debug("Creating game: {}", game.getName());
        // ...
        log.info("Game created successfully: id={}", game.getId());
    }
}
```

---

### Remote Debugging

**Start application with debug port**:
```bash
./gradlew bootRun --args='--spring.profiles.active=dev' \
  -Dspring-boot.run.jvmArguments="-Xdebug -Xrunjdwp:transport=dt_socket,server=y,suspend=n,address=*:5005"
```

**Connect from IntelliJ**:
1. Run → Edit Configurations → Add New → Remote JVM Debug
2. Host: `localhost`
3. Port: `5005`
4. Click Debug

---

## Common Issues

### Issue: "Port 8080 is already in use"

**Solution**:
```bash
# Find process using port 8080
lsof -i :8080

# Kill the process
kill -9 <PID>
```

---

### Issue: Database connection refused

**Diagnosis**:
```bash
# Check if MongoDB is running
mongosh --eval "db.adminCommand('ping')"

# Check connection
mongosh mongodb://ffl_user:ffl_password@localhost:27017/ffl_playoffs
```

**Solution**:
- Verify MongoDB is running: `brew services list` (macOS)
- Check credentials in `application-dev.yml`
- Verify database exists: `mongosh --eval "show dbs"`

---

### Issue: MongoDB migration fails

**Error**: `Migration failed: Collection or index already exists`

**Solution**:
```bash
# Connect to MongoDB and check collections
mongosh mongodb://ffl_user:ffl_password@localhost:27017/ffl_playoffs

# Drop specific collection if needed
db.collectionName.drop()

# Or reset database (dev only!)
mongosh --eval "use ffl_playoffs; db.dropDatabase()"

# Recreate user
mongosh --eval "use ffl_playoffs; db.createUser({user: 'ffl_user', pwd: 'ffl_password', roles: [{role: 'readWrite', db: 'ffl_playoffs'}]})"
```

---

### Issue: Tests fail with "Testcontainers not starting"

**Solution**:
```bash
# Ensure Docker is running
docker ps

# Pull MongoDB image
docker pull mongo:6

# Run with Docker socket mounted
export DOCKER_HOST=unix:///var/run/docker.sock
```

---

## Additional Resources

- [Spring Boot Documentation](https://docs.spring.io/spring-boot/docs/current/reference/html/)
- [Hexagonal Architecture Guide](https://alistair.cockburn.us/hexagonal-architecture/)
- [MongoDB Documentation](https://www.mongodb.com/docs/)
- [Spring Data MongoDB Documentation](https://docs.spring.io/spring-data/mongodb/docs/current/reference/html/)

---

## Next Steps

- See [ARCHITECTURE.md](ARCHITECTURE.md) for architecture details
- See [API.md](API.md) for API endpoints
- See [DATA_MODEL.md](DATA_MODEL.md) for database schema
- See [DEPLOYMENT.md](DEPLOYMENT.md) for production deployment
