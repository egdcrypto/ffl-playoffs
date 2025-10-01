# FFL Playoffs Game

A Fantasy Football League playoff game where players pick NFL teams for a configurable duration (1-17 weeks). If a player's selected team loses, that team no longer earns points for the remainder of the game. Uses standard PPR (Points Per Reception) scoring with configurable field goal and defensive scoring rules.

[![Java](https://img.shields.io/badge/Java-17-red.svg)](https://openjdk.java.net/)
[![Spring Boot](https://img.shields.io/badge/Spring%20Boot-3.x-brightgreen.svg)](https://spring.io/projects/spring-boot)
[![PostgreSQL](https://img.shields.io/badge/PostgreSQL-14+-blue.svg)](https://www.postgresql.org/)
[![License](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)

## Table of Contents
- [Overview](#overview)
- [Key Features](#key-features)
- [Quick Start](#quick-start)
- [Technology Stack](#technology-stack)
- [Architecture](#architecture)
- [Documentation](#documentation)
  - [UI Mockups](#ui-mockups)
- [Project Structure](#project-structure)
- [Contributing](#contributing)
- [License](#license)

## Overview

FFL Playoffs is an **enterprise-grade fantasy football application** with a unique elimination mechanic:
- Players select one NFL team per week
- If a team loses, it's **eliminated** and scores **0 points** for all remaining weeks
- Games can start at any NFL week (1-18) and run for any duration (1-17 weeks)
- Perfect for playoff pools, mid-season challenges, or full-season leagues

### Key Differentiators

1. **Elimination Mechanic**: Losing teams score zero for remaining weeks (not found in traditional fantasy)
2. **Flexible Scheduling**: Start at any NFL week, not just week 1
3. **League-Scoped Players**: Players belong to specific leagues, supporting multi-league participation
4. **Enterprise-Grade Security**: Envoy sidecar with custom auth service, Google OAuth, and PATs
5. **Hexagonal Architecture**: Clean separation of concerns for maintainability and testability

## Key Features

### Core Gameplay
- ⚡ **Weekly Team Selection**: Pick one NFL team per week
- 🚫 **No Duplicate Picks**: Cannot select the same team twice in a league
- ❌ **Team Elimination**: Losing teams score 0 for all remaining weeks
- 📊 **PPR Scoring**: Standard Points Per Reception scoring with full customization
- 🏆 **Real-Time Leaderboards**: Live standings and score breakdowns

### League Configuration
- 📅 **Flexible Start Weeks**: Begin at any NFL week (1-18)
- ⏱️ **Configurable Duration**: 1-17 weeks (default: 4 weeks for playoffs)
- ⚙️ **Custom Scoring Rules**:
  - PPR settings (yards per point, reception points)
  - Field goal scoring by distance (0-39, 40-49, 50+ yards)
  - Defensive scoring (sacks, INTs, fumbles, TDs)
  - Points allowed and yards allowed tiers

### User Management
- 👥 **Three-Tier Role System**: SUPER_ADMIN, ADMIN, PLAYER
- 🔐 **Google OAuth Authentication**: Secure login via Google accounts
- 🔑 **Personal Access Tokens (PAT)**: Service-to-service authentication
- 📧 **Email Invitations**: Admins invite players to specific leagues
- 🏢 **Multi-League Support**: Players can join multiple leagues

### Security & Deployment
- 🛡️ **Envoy Sidecar**: All traffic authenticated/authorized at proxy layer
- 🔒 **Zero-Trust Model**: API never exposed directly to internet
- 📦 **Kubernetes-Ready**: Three-service pod deployment (Envoy + Auth Service + Main API)
- 📈 **Production-Grade**: Rate limiting, monitoring, audit logging

## Quick Start

### Prerequisites
- Java 17+
- PostgreSQL 14+
- Gradle 8.0+
- Docker (optional)

### 1. Clone and Setup Database

```bash
# Clone repository
git clone https://github.com/your-org/ffl-playoffs.git
cd ffl-playoffs

# Create PostgreSQL database
psql -U postgres
CREATE DATABASE ffl_playoffs;
CREATE USER ffl_user WITH ENCRYPTED PASSWORD 'ffl_password';
GRANT ALL PRIVILEGES ON DATABASE ffl_playoffs TO ffl_user;
\q
```

### 2. Configure Application

Create `ffl-playoffs-api/src/main/resources/application-dev.yml`:

```yaml
spring:
  datasource:
    url: jdbc:postgresql://localhost:5432/ffl_playoffs
    username: ffl_user
    password: ffl_password

server:
  port: 8080

logging:
  level:
    com.ffl.playoffs: DEBUG
```

### 3. Run Application

```bash
cd ffl-playoffs-api

# Build and run
./gradlew clean build
./gradlew bootRun --args='--spring.profiles.active=dev'
```

### 4. Access API

- **API Base URL**: http://localhost:8080
- **Swagger UI**: http://localhost:8080/swagger-ui.html
- **Health Check**: http://localhost:8080/api/v1/public/health

### 5. Create First Super Admin

```bash
# Use bootstrap PAT to create super admin
curl -X POST http://localhost:8080/api/v1/setup/superadmin \
  -H "Authorization: Bearer pat_bootstrap_token" \
  -H "Content-Type: application/json" \
  -d '{
    "email": "admin@example.com",
    "googleId": "google-oauth-id"
  }'
```

## Technology Stack

### Backend
- **Language**: Java 17
- **Framework**: Spring Boot 3.x
- **Architecture**: Hexagonal Architecture (Ports & Adapters)
- **Database**: PostgreSQL 14+
- **ORM**: Spring Data JPA / Hibernate
- **Migrations**: Flyway
- **Build Tool**: Gradle 8.x

### Security & Infrastructure
- **Authentication**:
  - Google OAuth 2.0 (user authentication)
  - Personal Access Tokens (service-to-service)
- **Authorization**: Envoy sidecar with ext_authz filter
- **Proxy**: Envoy Proxy 1.28+
- **Container Orchestration**: Kubernetes
- **Monitoring**: Prometheus + Grafana

### Testing
- **Unit Tests**: JUnit 5, Mockito
- **Integration Tests**: Spring Boot Test, Testcontainers
- **API Tests**: Postman/Newman
- **Coverage**: JaCoCo

## Architecture

FFL Playoffs follows **Hexagonal Architecture** (Ports & Adapters) for clean separation of concerns:

```
┌─────────────────────────────────────────────────┐
│         Infrastructure Layer                     │
│  (REST, Database, External APIs, Envoy)          │
│                     ↓ depends on                 │
├─────────────────────────────────────────────────┤
│         Application Layer                        │
│  (Use Cases, DTOs, Port Interfaces)              │
│                     ↓ depends on                 │
├─────────────────────────────────────────────────┤
│         Domain Layer (CORE)                      │
│  (Business Logic, Entities, Value Objects)       │
│         NO EXTERNAL DEPENDENCIES                 │
└─────────────────────────────────────────────────┘
```

### Three-Service Pod Model

```
┌──────────────────────────────────────────┐
│         Kubernetes Pod                    │
│                                           │
│  ┌────────────────────────────────────┐  │
│  │   Envoy Sidecar (Port 443)         │  │
│  │   - TLS termination                │  │
│  │   - External authorization         │  │
│  │   - Rate limiting                  │  │
│  └────────┬───────────────┬───────────┘  │
│           │               │               │
│  ┌────────▼──────┐   ┌───▼──────────┐   │
│  │ Auth Service  │   │  Main API    │   │
│  │ (Port 9191)   │   │ (Port 8080)  │   │
│  └───────────────┘   └──────────────┘   │
│                                           │
└──────────────────────────────────────────┘
```

**Key Principles**:
- Envoy handles ALL authentication/authorization
- API focuses purely on business logic
- Auth service validates Google JWT and PAT tokens
- Zero-trust: API never directly exposed

## Documentation

Comprehensive documentation is available in the `docs/` directory:

| Document | Description |
|----------|-------------|
| [ARCHITECTURE.md](docs/ARCHITECTURE.md) | Hexagonal architecture layers, dependency rules, ports & adapters, design decisions |
| [API.md](docs/API.md) | REST API endpoints, authentication flows, request/response examples, error handling |
| [DATA_MODEL.md](docs/DATA_MODEL.md) | Entity relationships, database schema, aggregates, business rules |
| [DEPLOYMENT.md](docs/DEPLOYMENT.md) | Kubernetes deployment, Envoy configuration, environment variables, monitoring |
| [DEVELOPMENT.md](docs/DEVELOPMENT.md) | Local development setup, running tests, debugging, common issues |

### Feature Specifications (Gherkin)

Behavior-Driven Development (BDD) specifications in `features/`:

- [authentication.feature](features/authentication.feature) - Google OAuth & PAT authentication
- [super-admin-management.feature](features/super-admin-management.feature) - Super admin operations
- [admin-management.feature](features/admin-management.feature) - Admin league management
- [league-configuration.feature](features/league-configuration.feature) - League setup & config
- [player-invitation.feature](features/player-invitation.feature) - Player invitations
- [team-selection.feature](features/team-selection.feature) - Team picking logic
- [team-elimination.feature](features/team-elimination.feature) - Elimination mechanics
- [scoring-ppr.feature](features/scoring-ppr.feature) - PPR scoring calculations

### UI Mockups

Interactive HTML mockups demonstrating the user interface:

**📱 View Live Mockups:**
- **[Mockups Index](https://htmlpreview.github.io/?https://github.com/egdcrypto/ffl-playoffs/blob/main/ui-design/mockups/index.html)** - All mockups in one place
- **[Login Screen](https://htmlpreview.github.io/?https://github.com/egdcrypto/ffl-playoffs/blob/main/ui-design/mockups/login.html)** - Google OAuth authentication flow
- **[Player Dashboard](https://htmlpreview.github.io/?https://github.com/egdcrypto/ffl-playoffs/blob/main/ui-design/mockups/player-dashboard.html)** - Main player view with leagues, stats, and actions
- **[Team Selection](https://htmlpreview.github.io/?https://github.com/egdcrypto/ffl-playoffs/blob/main/ui-design/mockups/team-selection.html)** - Weekly team picker with all 32 NFL teams
- **[Leaderboard](https://htmlpreview.github.io/?https://github.com/egdcrypto/ffl-playoffs/blob/main/ui-design/mockups/leaderboard.html)** - Rankings, scores, and elimination status

> **✨ Repository is PUBLIC** - All mockups are accessible online via the links above!

**📐 Design Documentation:**
- [WIREFRAMES.md](ui-design/WIREFRAMES.md) - Detailed wireframes for all screens
- [COMPONENTS.md](ui-design/COMPONENTS.md) - Reusable UI component library
- [API-INTEGRATION.md](ui-design/API-INTEGRATION.md) - Screen-to-endpoint mappings
- [RESEARCH.md](ui-design/RESEARCH.md) - UI/UX research and framework analysis

All mockups are responsive (mobile/tablet/desktop) and built with Bootstrap 5.

## Project Structure

```
ffl-playoffs/
├── docs/                          # Comprehensive documentation
│   ├── ARCHITECTURE.md
│   ├── API.md
│   ├── DATA_MODEL.md
│   ├── DEPLOYMENT.md
│   └── DEVELOPMENT.md
├── features/                      # Gherkin feature specifications
│   ├── authentication.feature
│   ├── team-selection.feature
│   └── scoring-ppr.feature
├── ffl-playoffs-api/              # Main API (Spring Boot)
│   ├── src/
│   │   ├── main/
│   │   │   ├── java/com/ffl/playoffs/
│   │   │   │   ├── domain/        # Domain layer (business logic)
│   │   │   │   ├── application/   # Application layer (use cases)
│   │   │   │   └── infrastructure/ # Infrastructure layer (adapters)
│   │   │   └── resources/
│   │   │       ├── application.yml
│   │   │       └── db/migration/  # Flyway migrations
│   │   └── test/
│   └── build.gradle
├── ui-design/                     # UI design and mockups
│   ├── mockups/                   # Interactive HTML mockups
│   │   ├── index.html             # Mockups index page
│   │   ├── login.html
│   │   ├── player-dashboard.html
│   │   ├── team-selection.html
│   │   └── leaderboard.html
│   ├── WIREFRAMES.md              # Screen wireframes
│   ├── COMPONENTS.md              # UI component library
│   ├── API-INTEGRATION.md         # API endpoint mappings
│   └── RESEARCH.md                # UI/UX research
├── requirements.md                # Full requirements document
└── README.md                      # This file
```

## API Examples

### Health Check (No Auth)
```bash
curl http://localhost:8080/api/v1/public/health
```

### Create League (Admin)
```bash
curl -X POST http://localhost:8080/api/v1/admin/leagues \
  -H "Authorization: Bearer <google-jwt-token>" \
  -H "Content-Type: application/json" \
  -d '{
    "name": "2025 NFL Playoffs Pool",
    "startingWeek": 15,
    "numberOfWeeks": 4,
    "scoringRules": {
      "pprRules": {
        "passingYardsPerPoint": 25,
        "rushingYardsPerPoint": 10,
        "receptionPoints": 1
      }
    }
  }'
```

### Make Team Selection (Player)
```bash
curl -X POST http://localhost:8080/api/v1/player/leagues/1/selections \
  -H "Authorization: Bearer <google-jwt-token>" \
  -H "Content-Type: application/json" \
  -d '{
    "week": 1,
    "teamName": "Kansas City Chiefs"
  }'
```

### View Leaderboard (Player)
```bash
curl http://localhost:8080/api/v1/player/leagues/1/leaderboard \
  -H "Authorization: Bearer <google-jwt-token>"
```

## Development Workflow

### Running Tests

```bash
# Unit tests
./gradlew test

# Integration tests (with Testcontainers)
./gradlew integrationTest

# All tests with coverage
./gradlew test jacocoTestReport
```

### Code Quality

```bash
# Check code style
./gradlew checkstyleMain

# Run static analysis
./gradlew spotbugsMain

# Run all quality checks
./gradlew check
```

### Database Migrations

```bash
# Migrations run automatically on startup
./gradlew bootRun

# Or use Flyway CLI
flyway -url=jdbc:postgresql://localhost:5432/ffl_playoffs \
  -user=ffl_user -password=ffl_password migrate
```

## Contributing

We welcome contributions! Please see our contributing guidelines:

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'feat: add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

### Commit Message Format

Follow [Conventional Commits](https://www.conventionalcommits.org/):

```
feat: add team elimination notifications
fix: correct PPR scoring calculation
docs: update API documentation
test: add integration tests for leaderboard
```

## Roadmap

### Phase 1: Core Functionality (Current)
- ✅ Hexagonal architecture setup
- ✅ User management (SUPER_ADMIN, ADMIN, PLAYER)
- ✅ League configuration with flexible start weeks
- ✅ Team selection with elimination logic
- ✅ PPR scoring with configurable rules
- ✅ Google OAuth authentication
- ✅ Personal Access Token (PAT) system
- ✅ Comprehensive documentation

### Phase 2: Enhanced Features (Q2 2025)
- 🔲 Real-time score updates via WebSocket
- 🔲 Email notifications for team eliminations
- 🔲 Historical game archive
- 🔲 Mobile app (React Native)
- 🔲 Social features (comments, trash talk)

### Phase 3: Analytics & Insights (Q3 2025)
- 🔲 Advanced statistics dashboard
- 🔲 Player performance analytics
- 🔲 AI-powered team recommendations
- 🔲 Historical trends and visualizations

## Support

- **Issues**: [GitHub Issues](https://github.com/your-org/ffl-playoffs/issues)
- **Discussions**: [GitHub Discussions](https://github.com/your-org/ffl-playoffs/discussions)
- **Documentation**: [docs/](docs/)
- **Email**: support@ffl-playoffs.com

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

---

**Built with ❤️ using Hexagonal Architecture, Spring Boot, and PostgreSQL**
