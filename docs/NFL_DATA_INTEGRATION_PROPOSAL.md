# NFL Data Integration Architecture Proposal

## Executive Summary

This document proposes an architectural solution for integrating external NFL data into the FFL Playoffs application. The solution follows hexagonal architecture principles, implements the existing `NflDataProvider` port, and provides comprehensive coverage for player statistics, team data, and game results.

## Table of Contents

1. [Requirements Analysis](#requirements-analysis)
2. [Data Source Evaluation](#data-source-evaluation)
3. [Recommended Architecture](#recommended-architecture)
4. [Data Model Mapping](#data-model-mapping)
5. [Implementation Strategy](#implementation-strategy)
6. [Caching Strategy](#caching-strategy)
7. [Error Handling & Resilience](#error-handling--resilience)
8. [Rate Limiting](#rate-limiting)
9. [Security Considerations](#security-considerations)
10. [Migration Path](#migration-path)

---

## Requirements Analysis

### Current Domain Port Interface

```java
public interface NflDataProvider {
    Score getTeamScore(String nflTeam, Integer weekNumber);
    List<String> getPlayoffTeams(Integer year);
    List<String> getAvailableTeamsForWeek(Integer weekNumber);
    boolean isTeamInPlayoffs(String nflTeam, Integer year);
}
```

### Extended Requirements (Inferred from Domain Models)

Based on `NFLPlayer`, `PlayerStats`, `NFLGame`, and `NFLTeam` domain models, we need:

1. **Player Data**:
   - Player profiles (name, position, team, status)
   - Weekly statistics (passing, rushing, receiving, kicking, defense)
   - Season aggregates
   - Injury reports

2. **Team Data**:
   - Roster information
   - Schedule/games
   - Playoff standings

3. **Game Data**:
   - Game results and scores
   - Real-time game status
   - Weekly schedules

4. **Scoring Data**:
   - Individual player fantasy points
   - Detailed statistical breakdowns

---

## Data Source Evaluation

### Option 1: ESPN API (Unofficial)

**Pros:**
- Free to use
- Comprehensive data coverage
- Real-time updates
- Good for fantasy football data

**Cons:**
- No official API documentation
- No guaranteed uptime/SLA
- Rate limits unclear
- Breaking changes possible
- No official support

**Rating:** ⚠️ Not Recommended for Production

---

### Option 2: NFL.com API (Unofficial)

**Pros:**
- Direct from source
- Comprehensive data
- Real-time updates

**Cons:**
- No official public API
- Reverse-engineered endpoints
- Rate limits unclear
- Legal concerns
- High risk of breaking changes

**Rating:** ⚠️ Not Recommended for Production

---

### Option 3: SportsData.io Fantasy Sports API (Commercial)

**URL:** https://sportsdata.io/fantasy-sports-api

**Pros:**
- Official, documented Fantasy Sports REST API
- Guaranteed SLA (99.9% uptime)
- **Real-time fantasy scoring and player stats**
- Fantasy-optimized data structure (no league setup required)
- Pre-calculated fantasy points (PPR, Standard, Half-PPR)
- Real-time injury updates and player news
- Live game data with play-by-play
- Excellent documentation
- Rate limiting clearly defined
- Multiple pricing tiers
- Dedicated support

**Cons:**
- Paid service ($0-$500+/month depending on tier)
- Requires API key management
- Usage-based pricing

**Pricing Tiers:**
- **Trial**: Free (500 API calls/month)
- **Developer**: $0/month (1,000 calls/month)
- **Starter**: $69/month (10,000 calls/month)
- **Pro**: $199/month (50,000 calls/month)
- **Enterprise**: Custom pricing

**Real-time Capabilities:**
- Live fantasy scoring updates (every 30 seconds during games)
- Real-time injury status changes
- Instant player news and analysis
- Live game status and play-by-play

**Rating:** ✅ **RECOMMENDED** for Production

---

### Option 4: API-FOOTBALL (RapidAPI)

**Pros:**
- Available on RapidAPI marketplace
- Good documentation
- Multiple sports coverage
- Structured pricing

**Cons:**
- Less NFL-specific features
- Pricing can scale quickly
- Mixed reviews on data accuracy

**Rating:** ⚠️ Acceptable Alternative

---

### Option 5: The Odds API

**Pros:**
- Good for game scores and results
- Fair pricing
- Simple API

**Cons:**
- Limited player-level statistics
- Primarily focused on betting data
- Not ideal for fantasy football

**Rating:** ⚠️ Limited Use Case

---

### Option 6: Hybrid Approach: Multiple Sources with Fallback

**Pros:**
- High availability through redundancy
- Cost optimization (use free tier, fallback to paid)
- Best-of-breed data for different use cases

**Cons:**
- Complex implementation
- Data consistency challenges
- Multiple API keys to manage
- Harder to maintain

**Rating:** ⚡ Advanced Option (Phase 2)

---

## Recommended Architecture

### Primary Recommendation: SportsData.io Fantasy Sports API with Redis Caching

**API URL:** https://sportsdata.io/fantasy-sports-api

**Key Benefits:**
- **No League Setup Required:** Works standalone with direct player/game queries
- **Real-time Fantasy Scoring:** Live updates during games (30-second intervals)
- **Pre-calculated Points:** PPR/Standard/Half-PPR scoring built-in
- **Fantasy-optimized Data:** Player projections, injury impact, DFS salaries

```
┌─────────────────────────────────────────────────────────────────┐
│                     Application Layer                            │
│  ┌────────────────────────────────────────────────────────────┐ │
│  │  Use Cases (ProcessGameResultsUseCase, etc.)               │ │
│  │         ↓                                                   │ │
│  │  NflDataProvider Port (Interface)                          │ │
│  └────────────────────────────────────────────────────────────┘ │
└────────────────────┬─────────────────────────────────────────────┘
                     │
                     ↓
┌─────────────────────────────────────────────────────────────────┐
│              Infrastructure Layer                                │
│  ┌────────────────────────────────────────────────────────────┐ │
│  │  NflDataAdapter (Primary Implementation)                   │ │
│  │    ├─→ CachingNflDataDecorator (Redis/Caffeine)           │ │
│  │    ├─→ RateLimitingNflDataDecorator (Bucket4j)            │ │
│  │    └─→ SportsDataIoFantasyClient (HTTP Client)            │ │
│  └────────────────────────────────────────────────────────────┘ │
│                                                                  │
│  ┌────────────────────────────────────────────────────────────┐ │
│  │  Fallback Chain (Optional Phase 2)                         │ │
│  │    └─→ StubNflDataProvider (Default/Offline Mode)         │ │
│  └────────────────────────────────────────────────────────────┘ │
└─────────────────────────────────────────────────────────────────┘
```

### Data Fetching Strategy: Hybrid Real-time + Batch

**Batch Processing (Scheduled Jobs):**
- Player roster data: Daily @ 3 AM ET
- Season schedules: Weekly @ 2 AM ET
- Team standings: Daily @ 4 AM ET
- Player season stats: Daily @ 5 AM ET

**Real-time (Live During Games):**
- Fantasy scoring: Every 30 seconds during active games (SportsData.io Fantasy API)
- Player stats: Every 30 seconds during active games
- Game status updates: Real-time via webhooks (optional)
- Injury reports: Instant updates via Fantasy API

**On-Demand (User-Triggered):**
- Manual refresh triggers (with rate limiting)
- Individual player lookups (cached heavily)

**Rationale:**
- Reduces API costs (batch jobs use fewer API calls)
- Provides timely updates during critical periods
- Better user experience with fast cached responses
- Predictable API usage patterns

---

## Data Model Mapping

### SportsData.io → Domain Model Mapping

#### 1. NFLPlayer Mapping

```java
// SportsData.io Response
{
  "PlayerID": 12345,
  "Name": "Patrick Mahomes",
  "FirstName": "Patrick",
  "LastName": "Mahomes",
  "Team": "KC",
  "Position": "QB",
  "Number": 15,
  "Status": "Active",
  "PhotoUrl": "https://..."
}

// Maps to Domain NFLPlayer
NFLPlayer {
  id: 12345L,
  name: "Patrick Mahomes",
  firstName: "Patrick",
  lastName: "Mahomes",
  position: Position.QB,
  nflTeam: "Kansas City Chiefs",
  nflTeamAbbreviation: "KC",
  jerseyNumber: 15,
  status: "ACTIVE"
}
```

#### 2. PlayerStats Mapping (Weekly)

```java
// SportsData.io PlayerGame Response
{
  "PlayerID": 12345,
  "GameKey": "202501120007",
  "Week": 18,
  "Season": 2025,
  "PassingYards": 320,
  "PassingTouchdowns": 3,
  "Interceptions": 1,
  "RushingYards": 15,
  "FantasyPoints": 28.3,
  ...
}

// Maps to Domain PlayerStats
PlayerStats {
  id: UUID.randomUUID(),
  nflPlayerId: 12345L,
  nflGameId: UUID (from game mapping),
  week: 18,
  season: 2025,
  passingYards: 320,
  passingTouchdowns: 3,
  interceptions: 1,
  rushingYards: 15,
  ...
}
```

#### 3. NFLGame Mapping

```java
// SportsData.io Game Response
{
  "GameKey": "202501120007",
  "Season": 2025,
  "Week": 18,
  "Date": "2025-01-12T18:00:00",
  "HomeTeam": "KC",
  "AwayTeam": "BUF",
  "HomeScore": 27,
  "AwayScore": 24,
  "Status": "Final"
}

// Maps to Domain NFLGame
NFLGame {
  id: UUID (generated from GameKey),
  season: 2025,
  week: 18,
  gameDate: LocalDateTime.parse("2025-01-12T18:00:00"),
  homeTeam: "KC",
  awayTeam: "BUF",
  homeScore: 27,
  awayScore: 24,
  status: GameStatus.FINAL
}
```

---

## Implementation Strategy

### Phase 1: Core Integration (Week 1-2)

#### 1.1 Extend NflDataProvider Port

```java
package com.ffl.playoffs.domain.port;

import com.ffl.playoffs.domain.model.*;
import java.util.List;
import java.util.Optional;

public interface NflDataProvider {
    // Existing methods
    Score getTeamScore(String nflTeam, Integer weekNumber);
    List<String> getPlayoffTeams(Integer year);
    List<String> getAvailableTeamsForWeek(Integer weekNumber);
    boolean isTeamInPlayoffs(String nflTeam, Integer year);

    // New methods (Phase 1)
    Optional<NFLPlayer> getPlayerById(Long nflPlayerId);
    List<NFLPlayer> getPlayersByTeam(String teamAbbreviation);
    List<NFLPlayer> searchPlayers(String searchTerm, Position position);

    Optional<PlayerStats> getPlayerWeeklyStats(Long nflPlayerId, Integer week, Integer season);
    List<PlayerStats> getWeeklyStats(Integer week, Integer season);

    List<NFLGame> getWeekSchedule(Integer week, Integer season);
    Optional<NFLGame> getGame(String gameKey);

    // Metadata
    Integer getCurrentWeek();
    Integer getCurrentSeason();
    boolean isGameDay(Integer week, Integer season);
}
```

#### 1.2 Create SportsDataIoFantasyClient

**Note:** Uses Fantasy Sports API (no league setup required, works standalone)

```java
package com.ffl.playoffs.infrastructure.adapter.integration.sportsdataio;

import org.springframework.stereotype.Component;
import org.springframework.web.client.RestTemplate;

@Component
public class SportsDataIoFantasyClient {
    private final RestTemplate restTemplate;
    private final SportsDataIoConfig config;

    // Fantasy Sports API Base URL
    private static final String BASE_URL = "https://api.sportsdata.io/v3/nfl/fantasy";

    public SportsDataIoFantasyClient(RestTemplate restTemplate, SportsDataIoConfig config) {
        this.restTemplate = restTemplate;
        this.config = config;
    }

    // Get player with pre-calculated fantasy points (PPR)
    public SportsDataIoFantasyPlayerResponse getFantasyPlayer(Long playerId) {
        String url = String.format("%s/json/Player/%d?key=%s",
            BASE_URL, playerId, config.getApiKey());
        return restTemplate.getForObject(url, SportsDataIoFantasyPlayerResponse.class);
    }

    // Get real-time fantasy stats for current week (updates every 30 seconds during games)
    public List<SportsDataIoFantasyStatsResponse> getLiveFantasyStats(Integer season, Integer week) {
        String url = String.format("%s/json/FantasyPlayerGameStatsByWeek/%d/%d?key=%s",
            BASE_URL, season, week, config.getApiKey());
        return Arrays.asList(restTemplate.getForObject(url, SportsDataIoFantasyStatsResponse[].class));
    }

    // Get real-time player news and injury updates
    public List<SportsDataIoPlayerNewsResponse> getPlayerNews() {
        String url = String.format("%s/json/PlayerNews?key=%s",
            BASE_URL, config.getApiKey());
        return Arrays.asList(restTemplate.getForObject(url, SportsDataIoPlayerNewsResponse[].class));
    }

    // Additional fantasy-specific methods...
}
```

#### 1.3 Create Mapper

```java
package com.ffl.playoffs.infrastructure.adapter.integration.sportsdataio;

import com.ffl.playoffs.domain.model.*;
import org.springframework.stereotype.Component;

@Component
public class SportsDataIoMapper {

    public NFLPlayer toDomain(SportsDataIoPlayerResponse response) {
        return NFLPlayer.builder()
            .id(response.getPlayerID())
            .name(response.getName())
            .firstName(response.getFirstName())
            .lastName(response.getLastName())
            .position(mapPosition(response.getPosition()))
            .nflTeam(response.getTeam())
            .nflTeamAbbreviation(response.getTeam())
            .jerseyNumber(response.getNumber())
            .status(mapStatus(response.getStatus()))
            .build();
    }

    public PlayerStats toPlayerStats(SportsDataIoPlayerGameResponse response) {
        return PlayerStats.builder()
            .id(UUID.randomUUID())
            .nflPlayerId(response.getPlayerID())
            .week(response.getWeek())
            .season(response.getSeason())
            .passingYards(response.getPassingYards())
            .passingTouchdowns(response.getPassingTouchdowns())
            .interceptions(response.getInterceptions())
            .rushingYards(response.getRushingYards())
            .rushingTouchdowns(response.getRushingTouchdowns())
            .receptions(response.getReceptions())
            .receivingYards(response.getReceivingYards())
            .receivingTouchdowns(response.getReceivingTouchdowns())
            .fieldGoalsMade(response.getFieldGoalsMade())
            .fieldGoalsAttempted(response.getFieldGoalsAttempted())
            .extraPointsMade(response.getExtraPointsMade())
            .build();
    }

    private Position mapPosition(String sportsDataPosition) {
        return switch (sportsDataPosition) {
            case "QB" -> Position.QB;
            case "RB" -> Position.RB;
            case "WR" -> Position.WR;
            case "TE" -> Position.TE;
            case "K" -> Position.K;
            case "DEF" -> Position.DEF;
            default -> throw new IllegalArgumentException("Unknown position: " + sportsDataPosition);
        };
    }

    private String mapStatus(String sportsDataStatus) {
        return switch (sportsDataStatus) {
            case "Active" -> "ACTIVE";
            case "Injured" -> "INJURED";
            case "Out" -> "OUT";
            case "Questionable" -> "QUESTIONABLE";
            case "Doubtful" -> "DOUBTFUL";
            default -> "UNKNOWN";
        };
    }
}
```

#### 1.4 Implement Enhanced NflDataAdapter

```java
package com.ffl.playoffs.infrastructure.adapter.integration;

import com.ffl.playoffs.domain.model.*;
import com.ffl.playoffs.domain.port.NflDataProvider;
import com.ffl.playoffs.infrastructure.adapter.integration.sportsdataio.*;
import org.springframework.stereotype.Component;

@Component
public class SportsDataIoFantasyAdapter implements NflDataProvider {

    private final SportsDataIoFantasyClient client;
    private final SportsDataIoMapper mapper;

    public SportsDataIoFantasyAdapter(SportsDataIoFantasyClient client, SportsDataIoMapper mapper) {
        this.client = client;
        this.mapper = mapper;
    }

    @Override
    public Optional<NFLPlayer> getPlayerById(Long nflPlayerId) {
        try {
            var response = client.getPlayer(nflPlayerId);
            return Optional.of(mapper.toDomain(response));
        } catch (Exception e) {
            // Log error
            return Optional.empty();
        }
    }

    @Override
    public Optional<PlayerStats> getPlayerWeeklyStats(Long nflPlayerId, Integer week, Integer season) {
        try {
            var allStats = client.getPlayerGameStats(season, week);
            var playerStat = allStats.stream()
                .filter(stat -> stat.getPlayerID().equals(nflPlayerId))
                .findFirst();

            return playerStat.map(mapper::toPlayerStats);
        } catch (Exception e) {
            // Log error
            return Optional.empty();
        }
    }

    // Implement remaining methods...
}
```

### Phase 2: Caching Layer (Week 2)

```java
package com.ffl.playoffs.infrastructure.adapter.integration.cache;

import com.ffl.playoffs.domain.model.*;
import com.ffl.playoffs.domain.port.NflDataProvider;
import org.springframework.cache.annotation.Cacheable;
import org.springframework.stereotype.Component;

@Component
public class CachingNflDataDecorator implements NflDataProvider {

    private final NflDataProvider delegate;

    public CachingNflDataDecorator(NflDataProvider delegate) {
        this.delegate = delegate;
    }

    @Override
    @Cacheable(value = "nfl-players", key = "#nflPlayerId")
    public Optional<NFLPlayer> getPlayerById(Long nflPlayerId) {
        return delegate.getPlayerById(nflPlayerId);
    }

    @Override
    @Cacheable(value = "player-stats", key = "#nflPlayerId + '-' + #week + '-' + #season")
    public Optional<PlayerStats> getPlayerWeeklyStats(Long nflPlayerId, Integer week, Integer season) {
        return delegate.getPlayerWeeklyStats(nflPlayerId, week, season);
    }

    // More cached methods...
}
```

### Phase 3: Rate Limiting (Week 2)

```java
package com.ffl.playoffs.infrastructure.adapter.integration.ratelimit;

import com.ffl.playoffs.domain.port.NflDataProvider;
import io.github.bucket4j.Bandwidth;
import io.github.bucket4j.Bucket;
import io.github.bucket4j.Refill;
import org.springframework.stereotype.Component;

import java.time.Duration;

@Component
public class RateLimitingNflDataDecorator implements NflDataProvider {

    private final NflDataProvider delegate;
    private final Bucket bucket;

    public RateLimitingNflDataDecorator(NflDataProvider delegate) {
        this.delegate = delegate;

        // SportsData.io: 10 requests per second limit
        Bandwidth limit = Bandwidth.classic(10, Refill.intervally(10, Duration.ofSeconds(1)));
        this.bucket = Bucket.builder()
            .addLimit(limit)
            .build();
    }

    @Override
    public Optional<NFLPlayer> getPlayerById(Long nflPlayerId) {
        if (bucket.tryConsume(1)) {
            return delegate.getPlayerById(nflPlayerId);
        } else {
            throw new RateLimitExceededException("NFL data API rate limit exceeded");
        }
    }

    // Apply rate limiting to all methods...
}
```

---

## Caching Strategy

### Multi-Tier Caching Architecture

```
┌──────────────────────────────────────────────────────────────┐
│ L1 Cache: Caffeine (In-Memory, JVM-local)                    │
│   - Player profiles: 1 hour TTL, 10,000 max entries          │
│   - Current week schedule: 5 minutes TTL                     │
│   - Playoff teams: 24 hours TTL                              │
└──────────────────────────────────────────────────────────────┘
                            ↓ (miss)
┌──────────────────────────────────────────────────────────────┐
│ L2 Cache: Redis (Distributed, Shared)                        │
│   - Player stats (historical): 7 days TTL                    │
│   - Game results (final): Never expire                       │
│   - Live game data: 2 minutes TTL                            │
│   - Season schedules: 24 hours TTL                           │
└──────────────────────────────────────────────────────────────┘
                            ↓ (miss)
┌──────────────────────────────────────────────────────────────┐
│ L3: Database (PostgreSQL/MongoDB)                            │
│   - Historical player stats (immutable)                      │
│   - Completed games (immutable)                              │
└──────────────────────────────────────────────────────────────┘
                            ↓ (miss)
┌──────────────────────────────────────────────────────────────┐
│ External API: SportsData.io                                  │
└──────────────────────────────────────────────────────────────┘
```

### Cache Configuration

```yaml
# application.yml
spring:
  cache:
    type: redis
    redis:
      time-to-live: 3600000 # 1 hour default
    cache-names:
      - nfl-players
      - player-stats
      - game-scores
      - playoff-teams
      - weekly-schedules

  data:
    redis:
      host: localhost
      port: 6379
      timeout: 2000ms

nfl-data:
  cache:
    player-profile-ttl: 3600      # 1 hour
    player-stats-final-ttl: 604800  # 7 days (game over)
    player-stats-live-ttl: 120    # 2 minutes (game in progress)
    schedule-ttl: 86400           # 24 hours
    playoff-teams-ttl: 86400      # 24 hours
```

### Cache Invalidation Strategy

1. **Time-based Expiration**:
   - Player profiles: 1 hour TTL
   - Live stats: 2 minutes TTL
   - Final stats: 7 days TTL

2. **Event-based Invalidation**:
   - Game completion → invalidate live stats, cache final stats
   - Injury report → invalidate player profile
   - Trade → invalidate player team data

3. **Manual Invalidation**:
   - Admin endpoint: `POST /admin/cache/invalidate/{cacheKey}`

---

## Error Handling & Resilience

### Circuit Breaker Pattern (Resilience4j)

```java
package com.ffl.playoffs.infrastructure.adapter.integration.resilience;

import io.github.resilience4j.circuitbreaker.annotation.CircuitBreaker;
import io.github.resilience4j.retry.annotation.Retry;
import org.springframework.stereotype.Component;

@Component
public class ResilientNflDataAdapter implements NflDataProvider {

    private final NflDataProvider delegate;
    private final NflDataProvider fallback;

    @Override
    @CircuitBreaker(name = "nflDataService", fallbackMethod = "getPlayerByIdFallback")
    @Retry(name = "nflDataService")
    public Optional<NFLPlayer> getPlayerById(Long nflPlayerId) {
        return delegate.getPlayerById(nflPlayerId);
    }

    private Optional<NFLPlayer> getPlayerByIdFallback(Long nflPlayerId, Exception ex) {
        // Try fallback data source or return cached/default data
        return fallback.getPlayerById(nflPlayerId);
    }
}
```

### Configuration

```yaml
# application.yml
resilience4j:
  circuitbreaker:
    instances:
      nflDataService:
        registerHealthIndicator: true
        slidingWindowSize: 10
        minimumNumberOfCalls: 5
        permittedNumberOfCallsInHalfOpenState: 3
        automaticTransitionFromOpenToHalfOpenEnabled: true
        waitDurationInOpenState: 30s
        failureRateThreshold: 50
        eventConsumerBufferSize: 10

  retry:
    instances:
      nflDataService:
        maxAttempts: 3
        waitDuration: 1000ms
        enableExponentialBackoff: true
        exponentialBackoffMultiplier: 2
```

### Fallback Strategies

1. **Cached Data Fallback**:
   - Return last known good data from Redis/DB
   - Clearly mark as stale with timestamp

2. **Degraded Mode**:
   - Return partial data (e.g., player profiles without live stats)
   - Show user-friendly message about delayed updates

3. **Stub Data**:
   - For development/testing only
   - Return mock data when external API unavailable

4. **Hybrid Fallback**:
   - Primary: SportsData.io
   - Secondary: ESPN unofficial API (best effort)
   - Tertiary: Stub data

---

## Rate Limiting

### Strategy: Token Bucket Algorithm (Bucket4j)

#### API Rate Limits (SportsData.io)

**Free Tier:**
- 10 requests per second
- 1,000 requests per month

**Starter Tier ($69/month):**
- 10 requests per second
- 10,000 requests per month

**Our Rate Limit Configuration:**

```java
// Conservative limits (80% of max to avoid edge cases)
Bandwidth limit = Bandwidth.classic(8, Refill.intervally(8, Duration.ofSeconds(1)));
```

### Usage Optimization

**Estimated Monthly API Calls:**

| Operation | Frequency | Calls/Month |
|-----------|-----------|-------------|
| Daily player sync | 1x/day | 30 |
| Weekly schedule fetch | 1x/week | 4 |
| Live game polling (18 weeks, 16 games/week, 60 polls/game) | Game days | ~17,280 |
| On-demand player lookups | User-triggered | ~1,000 |
| **TOTAL** | | **~18,314** |

**Tier Recommendation:** Starter ($69/month) provides comfortable buffer.

### Rate Limit Monitoring

```java
@Component
public class ApiUsageMetrics {

    private final MeterRegistry registry;

    public void recordApiCall(String endpoint) {
        registry.counter("nfl_api_calls", "endpoint", endpoint).increment();
    }

    public void recordCacheHit(String cacheKey) {
        registry.counter("nfl_cache_hits", "cache", cacheKey).increment();
    }
}
```

---

## Security Considerations

### 1. API Key Management

```yaml
# application.yml (DO NOT COMMIT)
nfl-data:
  api-key: ${NFL_API_KEY}  # Environment variable
  base-url: https://api.sportsdata.io/v3/nfl
```

**Best Practices:**
- Store API keys in Kubernetes Secrets
- Rotate keys quarterly
- Use different keys per environment (dev/staging/prod)
- Monitor for unauthorized usage

### 2. Request Validation

```java
public Optional<NFLPlayer> getPlayerById(Long nflPlayerId) {
    if (nflPlayerId == null || nflPlayerId <= 0) {
        throw new IllegalArgumentException("Invalid player ID");
    }
    // Proceed with API call
}
```

### 3. Response Sanitization

```java
public NFLPlayer toDomain(SportsDataIoPlayerResponse response) {
    return NFLPlayer.builder()
        .name(sanitize(response.getName()))
        .firstName(sanitize(response.getFirstName()))
        .lastName(sanitize(response.getLastName()))
        .build();
}

private String sanitize(String input) {
    return input != null ? input.replaceAll("[^a-zA-Z0-9 .-]", "") : "";
}
```

---

## Migration Path

### Phase 1: Foundation (Week 1)
- [ ] Set up SportsData.io account and API key
- [ ] Implement SportsDataIoClient
- [ ] Create mapper for basic entities
- [ ] Replace stub NflDataAdapter with real implementation
- [ ] Add integration tests

### Phase 2: Caching (Week 2)
- [ ] Set up Redis for distributed caching
- [ ] Implement CachingNflDataDecorator
- [ ] Configure cache TTLs
- [ ] Add cache monitoring

### Phase 3: Resilience (Week 2)
- [ ] Add Resilience4j circuit breaker
- [ ] Implement retry logic
- [ ] Create fallback mechanisms
- [ ] Add health checks

### Phase 4: Rate Limiting (Week 3)
- [ ] Implement Bucket4j rate limiter
- [ ] Add API usage metrics
- [ ] Create usage alerts
- [ ] Document rate limit handling

### Phase 5: Advanced Features (Week 4+)
- [ ] Scheduled batch jobs for daily syncs
- [ ] Real-time polling during games
- [ ] Admin dashboard for data monitoring
- [ ] Fallback to secondary data source

---

## Cost Analysis

### SportsData.io Pricing

| Tier | Monthly Cost | API Calls | Cost per Call |
|------|--------------|-----------|---------------|
| Free | $0 | 1,000 | $0 |
| Starter | $69 | 10,000 | $0.0069 |
| Pro | $199 | 50,000 | $0.00398 |

**Recommendation for Production:**
- **Start with:** Starter tier ($69/month)
- **Scale to:** Pro tier ($199/month) if user base grows

### Infrastructure Costs

| Component | Monthly Cost |
|-----------|--------------|
| Redis (AWS ElastiCache) | ~$15 |
| Additional monitoring | ~$5 |
| **Total Infrastructure** | **~$20** |

**Total Monthly Cost:** $89 (Starter) or $219 (Pro)

---

## Comparison Matrix

| Feature | SportsData.io Fantasy API | ESPN (Unofficial) | Hybrid |
|---------|---------------------------|-------------------|--------|
| **Reliability** | ✅ 99.9% SLA | ⚠️ No guarantee | ✅ High (fallback) |
| **Documentation** | ✅ Excellent (Fantasy-specific) | ❌ None | ✅ Good |
| **Cost** | ⚠️ $69-199/month | ✅ Free | ⚠️ $69+/month |
| **Real-time Data** | ✅ Yes (30-sec updates) | ✅ Yes | ✅ Yes |
| **League Setup** | ✅ Not required | ⚠️ N/A | ⚠️ Varies |
| **Pre-calc Fantasy Points** | ✅ Yes (PPR/Standard/Half) | ❌ No | ⚠️ Partial |
| **Support** | ✅ Dedicated | ❌ None | ⚠️ Partial |
| **Legal Risk** | ✅ None | ⚠️ Medium | ⚠️ Low |
| **Breaking Changes** | ✅ Rare (versioned) | ⚠️ Common | ✅ Mitigated |
| **Fantasy Data** | ✅ Native & optimized | ⚠️ Requires calc | ✅ Native |
| **Implementation Time** | 🟢 1-2 weeks | 🟡 2-3 weeks | 🔴 3-4 weeks |

---

## Final Recommendation

### ✅ Recommended Solution: SportsData.io Fantasy Sports API with Redis Caching

**API URL:** https://sportsdata.io/fantasy-sports-api

**Why:**
1. **Production-ready**: Official Fantasy Sports API with SLA guarantees
2. **Real-time Fantasy Data**: 30-second updates during games, no polling needed
3. **No League Setup**: Works standalone, direct player/game queries
4. **Pre-calculated Points**: PPR/Standard/Half-PPR built-in
5. **Cost-effective**: $69/month is reasonable for reliability
6. **Fantasy-optimized**: Built specifically for fantasy football use cases
7. **Scalable**: Easy to upgrade tiers as we grow
8. **Low risk**: No legal concerns, versioned API

**Implementation Timeline:**
- **Week 1**: Core integration with Fantasy Sports API
- **Week 2**: Real-time caching + resilience patterns
- **Week 3**: Rate limiting + monitoring
- **Week 4**: Production deployment

**Next Steps:**
1. Approve budget for SportsData.io Fantasy Sports API Starter tier ($69/month)
2. Create account at https://sportsdata.io/fantasy-sports-api and obtain API key
3. Begin Phase 1 implementation with real-time endpoints
4. Set up Redis for caching (with 30-second TTL for live data)
5. Configure monitoring and alerting for real-time feeds

---

## Appendix: Sample Fantasy Sports API Calls

**Base URL:** `https://api.sportsdata.io/v3/nfl/fantasy`

### Get Fantasy Player by ID (with pre-calculated points)
```http
GET https://api.sportsdata.io/v3/nfl/fantasy/json/Player/12345?key=YOUR_API_KEY

Response:
{
  "PlayerID": 12345,
  "FirstName": "Patrick",
  "LastName": "Mahomes",
  "Position": "QB",
  "Team": "KC",
  "Number": 15,
  "Status": "Active",
  "FantasyPointsPPR": 324.5,
  "FantasyPointsStandard": 298.2,
  "FantasyPointsHalfPPR": 311.3,
  "InjuryStatus": "Healthy",
  "InjuryNotes": null
}
```

### Get Real-time Fantasy Stats (updates every 30 seconds during games)
```http
GET https://api.sportsdata.io/v3/nfl/fantasy/json/FantasyPlayerGameStatsByWeek/2025/18?key=YOUR_API_KEY

Response: [
  {
    "PlayerID": 12345,
    "Season": 2025,
    "Week": 18,
    "PassingYards": 320,
    "PassingTouchdowns": 3,
    "Interceptions": 1,
    "FantasyPointsPPR": 28.3,
    "FantasyPointsStandard": 26.8,
    "FantasyPointsHalfPPR": 27.6,
    "IsGameOver": false,
    "GameStatus": "InProgress"
  },
  ...
]
```

### Get Real-time Player News and Injuries
```http
GET https://api.sportsdata.io/v3/nfl/fantasy/json/PlayerNews?key=YOUR_API_KEY

Response: [
  {
    "PlayerID": 12345,
    "Name": "Patrick Mahomes",
    "Team": "KC",
    "Title": "Mahomes Active for Week 18",
    "Updated": "2025-01-12T10:30:00Z",
    "Content": "QB Patrick Mahomes is active and will start...",
    "InjuryStatus": "Active"
  },
  ...
]
```

### Get Live Game Scores (real-time)
```http
GET https://api.sportsdata.io/v3/nfl/fantasy/json/ScoresByWeek/2025/18?key=YOUR_API_KEY

Response: [
  {
    "GameKey": "202501120007",
    "Season": 2025,
    "Week": 18,
    "Date": "2025-01-12T18:00:00",
    "HomeTeam": "KC",
    "AwayTeam": "BUF",
    "HomeScore": 27,
    "AwayScore": 24,
    "Status": "InProgress",
    "Quarter": "Q4",
    "TimeRemaining": "2:35",
    "IsGameOver": false
  },
  ...
]
```

**Note:** All Fantasy Sports API endpoints work standalone without league configuration. Pre-calculated fantasy points are available in real-time (30-second updates during games).

---

## Document Control

| Version | Date | Author | Changes |
|---------|------|--------|---------|
| 1.0 | 2025-10-02 | Project Structure Engineer | Initial proposal |

**Status:** 📋 Pending Approval

**Estimated Budget:** $89-219/month (SportsData.io + Redis)

**Estimated Implementation Time:** 3-4 weeks
