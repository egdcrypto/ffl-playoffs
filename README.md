# FFL Playoffs Game

A **roster-based fantasy football application** with a unique **ONE-TIME DRAFT** model. League players build rosters by drafting individual NFL players across multiple positions (QB, RB, WR, TE, K, DEF, FLEX, SUPERFLEX). Once the first game starts, rosters are **permanently locked** for the entire season—no waiver wire, no trades, no lineup changes. Compete for a configurable duration (1-17 weeks) with fully customizable roster configurations and PPR (Points Per Reception) scoring.

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

FFL Playoffs is an **enterprise-grade fantasy football application** with a unique **ONE-TIME DRAFT** model:

### 🎯 Core Concept: ONE-TIME DRAFT Model

**CRITICAL RULE**: Rosters are built **ONCE** before the season starts and are **PERMANENTLY LOCKED** when the first NFL game begins.

**Pre-Lock Phase (Draft Phase)**:
- League players draft individual NFL players to fill all roster positions
- Players can modify their rosters (add/drop players) until the first game starts
- Countdown timer shows time remaining until permanent lock
- Admin-configurable roster structure (QB, RB, WR, TE, K, DEF, FLEX, SUPERFLEX)

**Post-Lock Phase (Season Active)**:
- Rosters are **PERMANENTLY LOCKED** for the entire season
- **NO waiver wire** pickups allowed
- **NO trades** between league players
- **NO lineup changes** week-to-week
- **NO player replacements** (even for injuries)
- League players compete with their locked rosters for the full duration

### 🏈 Roster-Based Gameplay

- **Individual NFL Player Selection**: Build rosters by selecting individual NFL players by position (QB, RB, WR, TE, K, DEF)
- **No Ownership Model**: Multiple league players CAN select the same NFL player—ALL players available to ALL league members
- **Customizable Rosters**: FLEX positions (RB/WR/TE eligible) and SUPERFLEX positions (QB/RB/WR/TE eligible)
- **Position-Based Scoring**: PPR scoring based on each individual NFL player's weekly performance
- **Flexible Scheduling**: Start at any NFL week (1-22, including playoffs), run for any duration (1-17 weeks)

### 🔑 Key Differentiators

1. **ONE-TIME DRAFT**: Permanent roster lock creates unique strategic challenge—must live with draft decisions
2. **Configurable Roster Positions**: Admin-defined roster slots with flexible position eligibility
3. **No Ownership Model**: All NFL players available to all league players (not a traditional draft)
4. **Flexible Scheduling**: Start at any NFL week (1-22), not just week 1
5. **League-Scoped Players**: Players belong to specific leagues, supporting multi-league participation
6. **Enterprise-Grade Security**: Envoy sidecar with custom auth service, Google OAuth, and PATs
7. **Hexagonal Architecture**: Clean separation of concerns for maintainability and testability

## Key Features

### Core Gameplay (ONE-TIME DRAFT Model)
- 🔓 **Pre-Lock Roster Building**: Draft individual NFL players across multiple positions before season starts
- 🔒 **Permanent Roster Lock**: Rosters lock when first game starts—NO changes for entire season
- 🏈 **Position-Based Rosters**: QB, RB, WR, TE, K, DEF, FLEX (RB/WR/TE), SUPERFLEX (QB/RB/WR/TE)
- 🚫 **No Waiver Wire/Trades**: Live with your draft decisions—no pickups, trades, or lineup changes
- 📊 **Individual Player Scoring**: PPR scoring based on each NFL player's weekly performance
- 🏆 **Real-Time Leaderboards**: Live standings with cumulative roster score breakdowns

### League Configuration
- 📅 **Flexible Start Weeks**: Begin at any NFL week (1-22, including playoffs)
- ⏱️ **Configurable Duration**: 1-17 weeks (default: 4 weeks for playoffs)
- 📋 **Roster Configuration**: Admin defines position requirements
  - Quarterbacks (QB): 0-4 slots
  - Running Backs (RB): 0-6 slots
  - Wide Receivers (WR): 0-6 slots
  - Tight Ends (TE): 0-3 slots
  - Kickers (K): 0-2 slots
  - Defense/ST (DEF): 0-2 slots
  - FLEX (RB/WR/TE): 0-3 slots
  - Superflex (QB/RB/WR/TE): 0-2 slots
- ⚙️ **Custom Scoring Rules**:
  - Individual player PPR scoring (passing, rushing, receiving, TDs, INTs, fumbles)
  - PPR format: Full PPR (1.0), Half PPR (0.5), or Standard (0.0)
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
- [league-configuration.feature](features/league-configuration.feature) - League setup & roster configuration
- [player-invitation.feature](features/player-invitation.feature) - Player invitations to leagues
- [player-roster-selection.feature](features/player-roster-selection.feature) - Individual NFL player roster drafting and position-based selection
- [roster-management.feature](features/roster-management.feature) - One-time draft model with permanent roster lock
- [scoring-ppr.feature](features/scoring-ppr.feature) - Individual player PPR scoring calculations
- [data-integration.feature](features/data-integration.feature) - NFL data synchronization and player statistics

### UI Mockups

Interactive HTML mockups demonstrating the **ONE-TIME DRAFT** user interface with pre-lock and post-lock states:

**📱 View Live Mockups:**
- **[Mockups Index](https://htmlpreview.github.io/?https://github.com/egdcrypto/ffl-playoffs/blob/main/ui-design/mockups/index.html)** - Complete mockup navigation with state explanations

#### 🔓 Pre-Lock State (Draft Phase)
**Before first game starts** - Roster building is active, players can draft and modify rosters:

- **[Player Dashboard (Pre-Lock)](https://htmlpreview.github.io/?https://github.com/egdcrypto/ffl-playoffs/blob/main/ui-design/mockups/player-dashboard-prelock.html)** - Dashboard with countdown timer, incomplete roster warnings
- **[Player Selection (Pre-Lock)](https://htmlpreview.github.io/?https://github.com/egdcrypto/ffl-playoffs/blob/main/ui-design/mockups/player-selection-prelock.html)** - Active draft with "Add to Roster" buttons, position filters (QB, RB, WR, TE, K, DEF, FLEX, Superflex)
- **[My Roster (Pre-Lock)](https://htmlpreview.github.io/?https://github.com/egdcrypto/ffl-playoffs/blob/main/ui-design/mockups/my-roster-prelock.html)** - Editable roster with "Add Player" and "Drop Player" buttons, countdown to lock
- **[League Standings (Pre-Lock)](https://htmlpreview.github.io/?https://github.com/egdcrypto/ffl-playoffs/blob/main/ui-design/mockups/league-standings-prelock.html)** - Shows draft completion status, players still building rosters

#### 🔒 Post-Lock State (Season Active - Read-Only)
**After first game starts** - Rosters are PERMANENTLY LOCKED for entire season:

- **[Player Dashboard (Locked)](https://htmlpreview.github.io/?https://github.com/egdcrypto/ffl-playoffs/blob/main/ui-design/mockups/player-dashboard-locked.html)** - Shows locked rosters, weekly scores, no edit options
- **[Player Selection (Locked)](https://htmlpreview.github.io/?https://github.com/egdcrypto/ffl-playoffs/blob/main/ui-design/mockups/player-selection-locked.html)** - Browse-only view with "Roster Locked" warnings, no draft buttons
- **[My Roster (Locked)](https://htmlpreview.github.io/?https://github.com/egdcrypto/ffl-playoffs/blob/main/ui-design/mockups/my-roster-locked.html)** - Read-only roster view, weekly scoring, injured players remain (no replacements)
- **[League Standings (Locked)](https://htmlpreview.github.io/?https://github.com/egdcrypto/ffl-playoffs/blob/main/ui-design/mockups/league-standings-locked.html)** - Final rankings with locked roster badges, live scoring

#### 🔐 Authentication
- **[Login Screen](https://htmlpreview.github.io/?https://github.com/egdcrypto/ffl-playoffs/blob/main/ui-design/mockups/login.html)** - Google OAuth authentication flow

> **✨ Repository is PUBLIC** - All mockups are accessible online via the links above!

**📊 ONE-TIME DRAFT Model:**
- **Pre-Lock Phase**: League players draft individual NFL players to fill all roster positions. Roster can be modified (add/drop players) until first game starts.
- **Post-Lock Phase**: Once the first NFL game starts, rosters are **PERMANENTLY LOCKED** for the entire season. NO waiver wire, NO trades, NO lineup changes, NO player replacements (even for injuries).

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
│   │   ├── player-selection.html  # Draft NFL players by position
│   │   ├── my-roster.html         # View drafted roster
│   │   └── league-standings.html  # League player rankings
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
    "rosterConfiguration": {
      "positions": [
        {"position": "QB", "count": 1},
        {"position": "RB", "count": 2},
        {"position": "WR", "count": 2},
        {"position": "TE", "count": 1},
        {"position": "K", "count": 1},
        {"position": "DEF", "count": 1},
        {"position": "FLEX", "count": 1, "eligiblePositions": ["RB", "WR", "TE"]},
        {"position": "SUPERFLEX", "count": 1, "eligiblePositions": ["QB", "RB", "WR", "TE"]}
      ]
    },
    "scoringRules": {
      "pprRules": {
        "passingYardsPerPoint": 25,
        "passingTouchdownPoints": 4,
        "rushingYardsPerPoint": 10,
        "receptionPoints": 1.0,
        "receivingYardsPerPoint": 10
      }
    }
  }'
```

### Draft NFL Player (Player)
```bash
curl -X POST http://localhost:8080/api/v1/player/leagues/1/roster/draft \
  -H "Authorization: Bearer <google-jwt-token>" \
  -H "Content-Type: application/json" \
  -d '{
    "nflPlayerId": 12345,
    "rosterSlot": "QB"
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
- ✅ League configuration with flexible start weeks and roster configuration
- ✅ **ONE-TIME DRAFT model** with permanent roster lock
- ✅ Individual NFL player roster building (QB, RB, WR, TE, K, DEF, FLEX, SUPERFLEX)
- ✅ Pre-lock roster building phase with add/drop functionality
- ✅ Post-lock read-only roster enforcement (no waiver wire, no trades)
- ✅ Position-based PPR scoring with configurable field goal and defensive rules
- ✅ Google OAuth authentication
- ✅ Personal Access Token (PAT) system
- ✅ Comprehensive documentation and UI mockups (pre-lock and post-lock states)

### Phase 2: Enhanced Features (Q2 2025)
- 🔲 Real-time score updates via WebSocket
- 🔲 Email notifications for roster lock warnings and weekly scoring
- 🔲 Historical game archive and season statistics
- 🔲 Mobile app (React Native)
- 🔲 Social features (league chat, player comparisons, roster analysis)

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
