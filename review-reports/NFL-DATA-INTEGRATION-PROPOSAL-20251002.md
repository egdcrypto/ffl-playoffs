# NFL DATA INTEGRATION - ARCHITECTURAL PROPOSAL

**Date:** 2025-10-02
**Author:** Feature Architect (Engineer 1)
**Work Item:** WORK-20251002-125724-2287163
**Status:** PROPOSED

---

## Executive Summary

This proposal addresses the integration of external NFL data to support the Fantasy Football League application. **CRITICAL FINDING**: The current `NflDataProvider` interface is designed for survivor pool (team selection) rather than traditional fantasy football (individual player stats). This proposal provides a complete redesign with data source recommendations, implementation strategy, and architectural guidelines.

**UPDATED RECOMMENDATION (2025-10-02 13:18):** Use **sportsdata.io Fantasy Sports API** as primary data source with real-time updates. No league setup required - direct access to NFL player stats and fantasy points. Implement real-time polling strategy with automatic updates every 20-30 seconds during live games. Redesign NflDataProvider port to support individual player statistics and defensive team stats.

**Previous Recommendation:** ESPN API as primary with sportsdata.io as fallback (see Appendix for comparison)

---

## Table of Contents

1. [RECOMMENDED: SportsDataIO Fantasy Sports API](#recommended-sportsdataio-fantasy-sports-api)
2. [Critical Issue: Current Design Mismatch](#critical-issue-current-design-mismatch)
3. [Data Source Options Analysis](#data-source-options-analysis)
4. [Recommended Data Fetching Strategy](#recommended-data-fetching-strategy)
5. [Domain Model Mapping](#domain-model-mapping)
6. [NflDataProvider Port Redesign](#nfldataprovider-port-redesign)
7. [Caching Strategy](#caching-strategy)
8. [Error Handling & Fallback](#error-handling--fallback)
9. [Rate Limiting Considerations](#rate-limiting-considerations)
10. [Implementation Phases](#implementation-phases)
11. [Risk Assessment](#risk-assessment)

---

## RECOMMENDED: SportsDataIO Fantasy Sports API

**URL:** https://sportsdata.io/fantasy-sports-api
**Status:** ✅ RECOMMENDED PRIMARY DATA SOURCE
**Updated:** 2025-10-02 13:18

### Why SportsDataIO Fantasy Sports API?

**Key Advantages:**
- ✅ **Real-time fantasy points** - Updates every 20-30 seconds during live games
- ✅ **No league setup required** - Direct API access to NFL player stats
- ✅ **Fantasy-specific endpoints** - Pre-calculated fantasy points (DraftKings, FanDuel, Yahoo scoring)
- ✅ **Official NFL data partner** - Guaranteed data accuracy and SLA
- ✅ **Comprehensive stats** - Individual player performance + defensive team stats
- ✅ **Free trial available** - Test all endpoints before committing
- ✅ **Enterprise-grade** - Unlimited API calls on paid plans
- ✅ **Projections included** - BAKER Engine projections for player performance

---

### SportsDataIO Fantasy API Endpoints

#### 1. Player Game Stats by Week (Real-time)

**Endpoint:**
```
GET https://api.sportsdata.io/v3/nfl/stats/json/PlayerGameStatsByWeek/{season}/{week}?key={apiKey}
```

**Description:** Returns all player game statistics for a specific NFL week with real-time updates during live games.

**Response Fields (Key Fields for Our Application):**
- `PlayerID` - Unique player identifier
- `Name` - Player name (e.g., "Patrick Mahomes")
- `Team` - NFL team abbreviation (e.g., "KC")
- `Position` - QB, RB, WR, TE, K
- `PassingYards`, `PassingTouchdowns`, `Interceptions`
- `RushingYards`, `RushingTouchdowns`, `RushingAttempts`
- `Receptions`, `ReceivingYards`, `ReceivingTouchdowns`
- `FumblesLost`
- `TwoPointConversionPasses`, `TwoPointConversionRuns`, `TwoPointConversionReceptions`
- `FantasyPoints` - Pre-calculated fantasy points
- `FantasyPointsDraftKings` - DraftKings scoring
- `FantasyPointsFanDuel` - FanDuel scoring
- `FantasyPointsYahoo` - Yahoo scoring
- `FantasyPointsPPR` - **PPR scoring (what we need!)**

**Real-time Updates:** Updated every 20-30 seconds during live games

**Use Case:** Fetch all player stats for current NFL week, calculate custom PPR scores using our league's scoring rules

**Example Response:**
```json
{
  "PlayerID": 14876,
  "Name": "Patrick Mahomes",
  "Team": "KC",
  "Position": "QB",
  "PassingYards": 325,
  "PassingTouchdowns": 3,
  "Interceptions": 0,
  "RushingYards": 18,
  "RushingTouchdowns": 0,
  "Receptions": 0,
  "ReceivingYards": 0,
  "ReceivingTouchdowns": 0,
  "FumblesLost": 0,
  "TwoPointConversionPasses": 0,
  "TwoPointConversionRuns": 0,
  "FantasyPoints": 24.72,
  "FantasyPointsPPR": 24.72
}
```

---

#### 2. Fantasy Defense Game Stats (Real-time)

**Endpoint:**
```
GET https://api.sportsdata.io/v3/nfl/stats/json/FantasyDefenseByGame/{season}/{week}?key={apiKey}
```

**Description:** Returns defensive team statistics with fantasy scoring for a specific NFL week.

**Response Fields:**
- `Team` - NFL team abbreviation (e.g., "KC")
- `Sacks`
- `Interceptions`
- `FumbleRecoveries`
- `Safeties`
- `DefensiveTouchdowns`
- `SpecialTeamsTouchdowns`
- `PointsAllowed`
- `YardsAllowed`
- `FantasyPoints` - Pre-calculated defensive fantasy points
- `FantasyPointsAllowed` - Points scored by opponent

**Real-time Updates:** Updated every 20-30 seconds during live games

**Use Case:** Fetch defensive team stats for DEF roster position

**Example Response:**
```json
{
  "Team": "KC",
  "Sacks": 3.0,
  "Interceptions": 1,
  "FumbleRecoveries": 0,
  "Safeties": 0,
  "DefensiveTouchdowns": 1,
  "SpecialTeamsTouchdowns": 0,
  "PointsAllowed": 10,
  "YardsAllowed": 250,
  "FantasyPoints": 17.0
}
```

---

#### 3. Player Game Projections (Pre-game)

**Endpoint:**
```
GET https://api.sportsdata.io/v3/nfl/projections/json/PlayerGameProjectionStatsByWeek/{season}/{week}?key={apiKey}
```

**Description:** Returns projected player statistics and fantasy points for upcoming games (uses BAKER Engine).

**Response Fields:** Same as PlayerGameStats endpoint, but projected values

**Use Case:** Show projected scores to help users with roster decisions (future enhancement)

---

#### 4. Player Profiles - All Active Players

**Endpoint:**
```
GET https://api.sportsdata.io/v3/nfl/stats/json/PlayersByAvailable?key={apiKey}
```

**Description:** Returns all active NFL players with metadata.

**Response Fields:**
- `PlayerID`
- `FirstName`, `LastName`
- `Team`
- `Position`
- `Number` - Jersey number
- `BirthDate`
- `ByeWeek`

**Use Case:** Populate player search database for roster building UI

---

### Real-time Data Flow

**How Real-time Updates Work:**

```
Live NFL Game
    ↓
SportsDataIO ingests official NFL data (20-30 second delay from broadcast)
    ↓
Our API polls: GET /PlayerGameStatsByWeek/{season}/{week}
    ↓
Parse response → Calculate custom PPR scores using league's ScoringRules
    ↓
Update database (player_stats table)
    ↓
Fire StatsUpdatedEvent
    ↓
WebSocket push to connected clients
    ↓
UI updates live scores
```

**Polling Frequency During Live Games:**
- Every 30 seconds (matches SportsDataIO update frequency)
- Only during live game windows (Thu/Sun/Mon)
- Automatically detect live games via game status field

**No Polling When:**
- All games are FINAL (no live games in progress)
- Games haven't started yet (status = SCHEDULED)

---

### No League Setup Required ✅

**Important:** SportsDataIO Fantasy Sports API provides **raw NFL player statistics** - no need to set up a fantasy league on their platform.

**What You Get:**
- Direct access to all NFL player game stats
- Pre-calculated fantasy points (PPR, DraftKings, FanDuel, Yahoo)
- We calculate our own custom PPR scores using league's configurable `ScoringRules`

**What You Don't Need:**
- ❌ No league configuration on SportsDataIO platform
- ❌ No roster management on their side
- ❌ No third-party league ID
- ❌ No sync with external fantasy leagues

**We Control:**
- Our own league configuration (roster structure, scoring rules)
- Our own roster management (player selections)
- Our own scoring calculations (using their raw stats)

---

### Pricing

**Free Trial:**
- ✅ Never expires
- ✅ Full access to all endpoints
- ✅ All leagues (NFL, NBA, MLB, etc.)
- ✅ Suitable for testing and development
- ⚠️ Limited API calls (likely 500-1000/month)

**Paid Plans:**
- Contact SportsDataIO sales for custom pricing
- Industry average: $500-$1000+/month for unlimited calls
- ✅ Unlimited API calls
- ✅ Real-time updates
- ✅ SLA guarantees
- ✅ Dedicated support

**Recommendation:**
- Start with **free trial** for MVP development
- Monitor API usage
- Upgrade to paid plan when:
  - User base grows beyond 50 active users
  - Need guaranteed uptime (SLA)
  - Hit free tier API limits

---

### Implementation with SportsDataIO

#### Step 1: Create SportsDataAdapter

**File:** `ffl-playoffs-api/src/main/java/com/ffl/playoffs/infrastructure/adapter/integration/SportsDataAdapter.java`

**Implements:** `NflDataProvider` port

**Configuration:**
```java
@Configuration
@ConfigurationProperties(prefix = "nfl-data.sportsdata")
public class SportsDataConfig {
    private String apiKey;
    private String baseUrl = "https://api.sportsdata.io/v3/nfl";

    // getters/setters
}
```

**application.yml:**
```yaml
nfl-data:
  sportsdata:
    api-key: ${SPORTSDATA_API_KEY}
    base-url: https://api.sportsdata.io/v3/nfl
```

**Environment Variable:**
```bash
export SPORTSDATA_API_KEY="your-api-key-here"
```

---

#### Step 2: Fetch Player Stats

**Example Implementation:**
```java
@Override
public List<PlayerStats> getPlayerStatsByWeek(Integer nflWeek) {
    String url = String.format("%s/stats/json/PlayerGameStatsByWeek/%d/%d?key=%s",
        config.getBaseUrl(),
        getCurrentSeason(),
        nflWeek,
        config.getApiKey()
    );

    // Rate limiting
    rateLimiter.acquire();

    // Fetch from SportsDataIO
    SportsDataPlayerResponse[] response = restTemplate.getForObject(
        url,
        SportsDataPlayerResponse[].class
    );

    // Map to domain model
    return Arrays.stream(response)
        .map(this::mapToPlayerStats)
        .collect(Collectors.toList());
}

private PlayerStats mapToPlayerStats(SportsDataPlayerResponse response) {
    return PlayerStats.builder()
        .nflPlayerId(String.valueOf(response.getPlayerID()))
        .nflPlayerName(response.getName())
        .nflTeam(response.getTeam())
        .position(Position.valueOf(response.getPosition()))
        .nflWeek(response.getWeek())
        .passingYards(response.getPassingYards())
        .passingTouchdowns(response.getPassingTouchdowns())
        .interceptions(response.getInterceptions())
        .rushingYards(response.getRushingYards())
        .rushingTouchdowns(response.getRushingTouchdowns())
        .receptions(response.getReceptions())
        .receivingYards(response.getReceivingYards())
        .receivingTouchdowns(response.getReceivingTouchdowns())
        .fumblesLost(response.getFumblesLost())
        .twoPointConversionPasses(response.getTwoPointConversionPasses())
        .twoPointConversionRuns(response.getTwoPointConversionRuns())
        .twoPointConversionReceptions(response.getTwoPointConversionReceptions())
        .build();
}
```

---

#### Step 3: Real-time Polling Scheduler

**Scheduled Job:**
```java
@Component
public class LiveStatsPollingService {

    @Scheduled(fixedDelay = 30000) // Every 30 seconds
    public void pollLiveGameStats() {
        Integer currentWeek = getCurrentNflWeek();

        // Check if any games are live
        if (!hasLiveGames(currentWeek)) {
            return; // Skip polling if no live games
        }

        logger.info("Polling live stats for week {}", currentWeek);

        // Fetch latest stats
        List<PlayerStats> stats = nflDataProvider.getPlayerStatsByWeek(currentWeek);

        // Update database
        stats.forEach(playerStatsRepository::save);

        // Fire event for WebSocket updates
        eventPublisher.publishEvent(new StatsUpdatedEvent(currentWeek));
    }

    private boolean hasLiveGames(Integer week) {
        List<NflGame> games = nflDataProvider.getGamesByWeek(week);
        return games.stream()
            .anyMatch(game -> game.getStatus() == GameStatus.LIVE);
    }
}
```

**Polling Schedule:**
- Runs every 30 seconds (matches SportsDataIO update frequency)
- Only polls when games are live (checks game status first)
- Automatically stops when all games complete

---

#### Step 4: Custom PPR Scoring Calculation

**Why Calculate Our Own Scores:**
- SportsDataIO provides pre-calculated fantasy points (PPR, DraftKings, etc.)
- But our leagues have **configurable scoring rules**
- Each league can customize: yards per point, TD points, reception points, etc.

**Implementation:**
```java
@Service
public class ScoringService {

    public Score calculatePlayerScore(PlayerStats stats, ScoringRules rules) {
        double points = 0.0;

        // Passing stats
        points += stats.getPassingYards() / rules.getPpr().getPassingYardsPerPoint();
        points += stats.getPassingTouchdowns() * rules.getPpr().getPassingTDPoints();
        points += stats.getInterceptions() * rules.getPpr().getInterceptionPoints();

        // Rushing stats
        points += stats.getRushingYards() / rules.getPpr().getRushingYardsPerPoint();
        points += stats.getRushingTouchdowns() * rules.getPpr().getRushingTDPoints();

        // Receiving stats
        points += stats.getReceivingYards() / rules.getPpr().getReceivingYardsPerPoint();
        points += stats.getReceptions() * rules.getPpr().getReceptionPoints(); // PPR!
        points += stats.getReceivingTouchdowns() * rules.getPpr().getReceivingTDPoints();

        // Other
        points += stats.getFumblesLost() * rules.getPpr().getFumbleLostPoints();
        points += (stats.getTwoPointConversionPasses() +
                   stats.getTwoPointConversionRuns() +
                   stats.getTwoPointConversionReceptions()) *
                   rules.getPpr().getTwoPointConversionPoints();

        return Score.builder()
            .playerId(stats.getNflPlayerId())
            .week(stats.getNflWeek())
            .points(points)
            .breakdown(generateBreakdown(stats, rules))
            .build();
    }
}
```

**Flow:**
1. Fetch raw stats from SportsDataIO (passing yards, TDs, etc.)
2. Apply league's custom `ScoringRules` to calculate points
3. Store calculated score in `scores` table
4. Display to user with breakdown

---

### Comparison: SportsDataIO vs ESPN API

| Feature | SportsDataIO Fantasy API | ESPN API (Free) |
|---------|-------------------------|-----------------|
| **Cost** | Free trial → $500+/mo | Free (always) |
| **Real-time** | 20-30 sec updates ✅ | Undocumented (likely similar) |
| **Official** | Official NFL partner ✅ | Unofficial (ESPN-owned) |
| **SLA** | Guaranteed uptime ✅ | No guarantees ❌ |
| **Fantasy Points** | Pre-calculated (PPR, DK, FD) ✅ | Must calculate manually |
| **Documentation** | Official docs ✅ | Undocumented (reverse-engineered) ❌ |
| **Rate Limits** | Unlimited (paid), limited (free) | ~30 req/min (community estimate) |
| **Support** | Dedicated support ✅ | No support ❌ |
| **Risk** | Low (SLA guarantees) | Medium (API could change) |
| **League Setup** | Not required ✅ | Not required ✅ |

**Decision Matrix:**

**Choose SportsDataIO if:**
- ✅ Real-time updates are critical
- ✅ Need guaranteed uptime (production app)
- ✅ Budget allows $500+/month
- ✅ Want official support
- ✅ Planning to scale beyond 100 users

**Choose ESPN API if:**
- ✅ Budget is very limited
- ✅ MVP/prototype only
- ✅ Can tolerate occasional API changes
- ✅ Daily batch updates are sufficient

**Hybrid Approach:**
- Start with free SportsDataIO trial for development
- Monitor API usage and user growth
- Upgrade to paid plan when needed
- Keep ESPN API as backup fallback

---

### Summary: SportsDataIO Fantasy Sports API

**Recommended Approach:**

1. **Primary Data Source:** SportsDataIO Fantasy Sports API
2. **Setup:** No league configuration needed - direct stats access
3. **Real-time:** Poll every 30 seconds during live games
4. **Scoring:** Fetch raw stats, apply custom PPR rules per league
5. **Endpoints:**
   - `/PlayerGameStatsByWeek/{season}/{week}` - Player stats
   - `/FantasyDefenseByGame/{season}/{week}` - Defensive stats
   - `/PlayersByAvailable` - Player search
6. **Pricing:** Free trial for development → Paid plan for production
7. **Fallback:** ESPN API as backup if SportsDataIO unavailable

**Implementation Phases:**

**Phase 1 (MVP):**
- SportsDataIO free trial
- Real-time polling every 30 seconds
- Custom PPR scoring calculation
- WebSocket updates to UI

**Phase 2 (Production):**
- Upgrade to paid SportsDataIO plan
- Add circuit breaker and fallback to ESPN API
- Advanced caching and optimization
- Monitoring and alerts

---

## Critical Issue: Current Design Mismatch

### Current NflDataProvider Interface ❌

**File:** `ffl-playoffs-api/src/main/java/com/ffl/playoffs/domain/port/NflDataProvider.java`

```java
public interface NflDataProvider {
    Score getTeamScore(String nflTeam, Integer weekNumber);
    List<String> getPlayoffTeams(Integer year);
    List<String> getAvailableTeamsForWeek(Integer weekNumber);
    boolean isTeamInPlayoffs(String nflTeam, Integer year);
}
```

### Why This Is Wrong

1. **Team-Based, Not Player-Based**: Methods return team scores and team lists
2. **Survivor Pool Concept**: `getPlayoffTeams()` and `isTeamInPlayoffs()` are survivor pool mechanics
3. **Missing Individual Player Stats**: No methods for Patrick Mahomes' passing yards, Christian McCaffrey's rushing yards, etc.
4. **Missing Defensive Stats**: No methods for team defense performance
5. **No Game-by-Game Tracking**: Cannot track weekly player performance

### Requirements Mismatch

From `requirements.md` lines 150-166:
> "Scoring is based on INDIVIDUAL NFL PLAYER performance"
> "Standard PPR (Points Per Reception) scoring"
> "Example: Patrick Mahomes throws 300 yards (12 pts) + 3 TDs (12 pts) + 1 INT (-2 pts) = 22 fantasy points"
> "Each NFL player's stats tracked game-by-game throughout the season"

**Required Data:**
- Individual NFL player stats per game: passing yards, rushing yards, receiving yards, receptions, TDs, interceptions, fumbles
- Defensive team stats per game: sacks, interceptions, fumble recoveries, safeties, defensive TDs, points allowed, yards allowed
- Kicker stats: field goals made by distance (0-39, 40-49, 50+ yards), extra points
- Game metadata: game status (scheduled, live, final), game time, NFL week

---

## Data Source Options Analysis

### Option 1: ESPN API (Free, Public)

**Endpoints:**
- Scoreboard: `http://site.api.espn.com/apis/site/v2/sports/football/nfl/scoreboard?week={week}`
- Player Stats: `http://sports.core.api.espn.com/v2/sports/football/leagues/nfl/seasons/{year}/types/2/weeks/{week}/athletes/{playerId}/statistics`
- Team Roster: `http://site.api.espn.com/apis/site/v2/sports/football/nfl/teams/{teamId}/roster`

**Pros:**
- ✅ Free and publicly accessible (no API key required)
- ✅ Comprehensive stats (passing, rushing, receiving, defense, kicking)
- ✅ Real-time game data during live games
- ✅ Historical data available for past seasons
- ✅ Well-structured JSON responses
- ✅ Includes player metadata (name, position, team, jersey number)
- ✅ Used by millions of fantasy football players
- ✅ Reliable uptime (backed by Disney)

**Cons:**
- ⚠️ No official rate limits published (undocumented API)
- ⚠️ No guaranteed SLA or support
- ⚠️ API structure could change without notice
- ⚠️ May require reverse-engineering for advanced features

**Data Quality:**
- Game-by-game player stats ✅
- Defensive team stats ✅
- Field goal distance tracking ✅
- Live score updates ✅
- Stat corrections (typically within 48 hours) ✅

**Rate Limiting Observations:**
- Community reports suggest 1-2 requests/second is safe
- Recommend: 1 request every 2 seconds (30 requests/minute)
- Batch requests where possible
- Cache aggressively

**Example Response Structure:**
```json
{
  "athlete": {
    "id": "3139477",
    "displayName": "Patrick Mahomes",
    "position": {"abbreviation": "QB"}
  },
  "statistics": {
    "passing": {
      "yards": 325,
      "touchdowns": 3,
      "interceptions": 0,
      "completions": 28,
      "attempts": 38
    },
    "rushing": {
      "yards": 18,
      "touchdowns": 0
    }
  }
}
```

**Recommendation:** ✅ **PRIMARY DATA SOURCE**

---

### Option 2: sportsdata.io (Paid, Official)

**Pricing:** $20-$100/month (depending on calls/month)

**Endpoints:**
- Player Game Stats: `/Stats/PlayerGameStatsByWeek/{season}/{week}`
- Team Game Stats: `/Scores/ScoresByWeek/{season}/{week}`
- Real-time Player Stats: `/Stats/PlayerGameStatsByPlayerID/{playerId}`

**Pros:**
- ✅ Official NFL data partner
- ✅ Documented API with guaranteed SLA
- ✅ Dedicated support
- ✅ Higher rate limits (10,000+ calls/month on paid plans)
- ✅ Real-time updates with webhooks available
- ✅ Stat corrections handled automatically
- ✅ No risk of API structure changes

**Cons:**
- ⚠️ Costs $20-$100/month
- ⚠️ Free tier very limited (100-500 calls/month)
- ⚠️ Overkill for small user base

**Data Quality:**
- Game-by-game player stats ✅
- Defensive team stats ✅
- Field goal distance tracking ✅
- Live score updates ✅
- Stat corrections (real-time) ✅

**Rate Limiting:**
- Free tier: 100 calls/month
- Starter ($20/mo): 1,000 calls/month
- Pro ($100/mo): 10,000 calls/month

**Recommendation:** ✅ **FALLBACK/FUTURE UPGRADE** (use if ESPN API becomes unreliable or when scaling)

---

### Option 3: NFL.com Official API

**Status:** No public API available

**Pros:**
- ✅ Most authoritative data source

**Cons:**
- ❌ No public API available
- ❌ Unofficial scraping violates ToS
- ❌ Not recommended

**Recommendation:** ❌ **NOT VIABLE**

---

### Option 4: The Odds API (Focus: Betting)

**Focus:** Sports betting odds, not player stats

**Recommendation:** ❌ **NOT SUITABLE** (lacks player-level statistics)

---

### Option 5: MySportsFeeds (Paid)

**Pricing:** $75-$500/month

**Pros:**
- ✅ Comprehensive stats
- ✅ Good documentation

**Cons:**
- ⚠️ More expensive than sportsdata.io
- ⚠️ Less popular in fantasy football community

**Recommendation:** ⚠️ **ALTERNATIVE** (only if sportsdata.io unavailable)

---

## Data Source Recommendation Summary

| Source | Role | Cost | Reliability | Data Quality |
|--------|------|------|-------------|--------------|
| **ESPN API** | Primary | Free | High (community-tested) | Excellent |
| **sportsdata.io** | Fallback/Future | $20-$100/mo | Very High (SLA) | Excellent |
| NFL.com | N/A | N/A | N/A | N/A |
| The Odds API | Not suitable | N/A | N/A | N/A |
| MySportsFeeds | Alternative | $75+/mo | High | Excellent |

**Final Recommendation:** Start with **ESPN API** (free, reliable), build abstraction layer to easily switch to **sportsdata.io** if needed for scaling or reliability.

---

## Recommended Data Fetching Strategy

### Hybrid Approach: Batch + Real-time

#### Phase 1: Batch Fetching (Scheduled Jobs)

**Use Case:** Fetch completed game stats after games finish

**Schedule:**
- **Daily at 3 AM ET**: Fetch all completed games from previous day
  - Run after all Sunday/Monday/Thursday night games are final
  - Allows for ESPN stat corrections (usually within 24 hours)
- **Tuesday Morning (Stat Correction Window)**: Re-fetch previous week's stats
  - NFL typically applies stat corrections by Tuesday
  - Update existing records if stats changed

**What to Fetch:**
- All player game stats for completed games
- All defensive team stats for completed games
- Final scores and game status

**Implementation:**
```
Scheduled Job → NflDataAdapter.fetchWeeklyStats(week) → Store in DB → Fire StatsUpdatedEvent
```

**Advantages:**
- ✅ Reduces API calls (bulk fetch once per day)
- ✅ Handles stat corrections
- ✅ Simple to implement and maintain
- ✅ Works well for completed games

**Disadvantages:**
- ⚠️ No real-time updates during live games

---

#### Phase 2: Real-time Polling (During Live Games)

**Use Case:** Update scores while games are in progress (optional enhancement)

**Schedule:**
- **Only during live game windows**: Sunday 1 PM - 11 PM ET, Monday/Thursday 8-11 PM ET
- **Polling interval**: Every 5 minutes during live games
- **Detect live games**: Check ESPN scoreboard API for "in-progress" status

**What to Fetch:**
- Current scores for in-progress games
- Player stats for in-progress games
- Game clock and quarter information

**Implementation:**
```
Live Game Detector → Poll ESPN every 5 min → Update in-memory cache → WebSocket push to UI
```

**Advantages:**
- ✅ Provides real-time scoring experience
- ✅ Engages users during games
- ✅ Only runs during actual game times (limited API usage)

**Disadvantages:**
- ⚠️ Increases API calls during game windows
- ⚠️ Requires WebSocket infrastructure for UI updates
- ⚠️ More complex implementation

**Rate Limiting Math:**
- Typical Sunday: 10-13 games over 8 hours (480 minutes)
- Polling interval: 5 minutes
- Total API calls: 13 games × (480/5) = 1,248 calls per Sunday
- Monthly: ~5,000 calls (well within safe limits for ESPN API)

---

#### Phase 3: Webhook/Push (Future Enhancement)

**Use Case:** Receive instant stat updates from sportsdata.io

**Requires:**
- Paid sportsdata.io subscription with webhook support
- Webhook endpoint in API
- Event processing queue

**Implementation:**
```
sportsdata.io → Webhook → API /webhooks/nfl-stats → Queue Event → Process → Update DB
```

**Advantages:**
- ✅ Instant updates (no polling delay)
- ✅ Minimal API calls
- ✅ Most efficient approach

**Disadvantages:**
- ⚠️ Requires paid sportsdata.io subscription
- ⚠️ Additional infrastructure (webhook endpoint, queue)
- ⚠️ Overkill for initial MVP

---

### Recommended Implementation Roadmap

**MVP (Phase 1 Only):** Batch fetching after games complete
- Simple, reliable, low API usage
- Sufficient for most users (scores update within 24 hours)
- Easy to implement and maintain

**Enhancement (Add Phase 2):** Real-time polling during live games
- Better user experience
- Still uses free ESPN API
- Moderate complexity increase

**Future (Add Phase 3):** Migrate to sportsdata.io webhooks
- When user base justifies cost ($20-$100/mo)
- When real-time updates become critical
- Most scalable long-term solution

---

## Domain Model Mapping

### Required Domain Entities

Based on `requirements.md` lines 494-543:

#### 1. PlayerStats (Individual NFL Player)

**Purpose:** Track individual NFL player performance per game

**Fields:**
- `nflPlayerId` (String/Long): ESPN player ID
- `nflPlayerName` (String): "Patrick Mahomes"
- `nflTeam` (String): "Kansas City Chiefs" or "KC"
- `position` (Enum): QB, RB, WR, TE, K
- `nflWeek` (Integer): 1-22
- `nflGameId` (String): ESPN game ID
- `gameDate` (LocalDate): Date game was played
- `gameStatus` (Enum): SCHEDULED, LIVE, FINAL, POSTPONED

**Passing Stats:**
- `passingYards` (Integer)
- `passingTouchdowns` (Integer)
- `interceptions` (Integer)
- `completions` (Integer)
- `attempts` (Integer)
- `passingTwoPointConversions` (Integer)

**Rushing Stats:**
- `rushingYards` (Integer)
- `rushingTouchdowns` (Integer)
- `rushingAttempts` (Integer)
- `rushingTwoPointConversions` (Integer)

**Receiving Stats:**
- `receptions` (Integer)
- `receivingYards` (Integer)
- `receivingTouchdowns` (Integer)
- `targets` (Integer)
- `receivingTwoPointConversions` (Integer)

**Other Stats:**
- `fumblesLost` (Integer)

**Database Table:** `player_stats`

**JPA Entity:** `PlayerStatsEntity`

---

#### 2. DefensiveStats (Team Defense)

**Purpose:** Track team defense performance per game

**Fields:**
- `nflTeam` (String): "Kansas City Chiefs" or "KC"
- `nflWeek` (Integer): 1-22
- `nflGameId` (String): ESPN game ID
- `gameDate` (LocalDate)
- `gameStatus` (Enum): SCHEDULED, LIVE, FINAL, POSTPONED

**Defensive Stats:**
- `sacks` (Integer)
- `interceptions` (Integer)
- `fumbleRecoveries` (Integer)
- `safeties` (Integer)
- `defensiveTouchdowns` (Integer)
- `specialTeamsTouchdowns` (Integer)
- `pointsAllowed` (Integer)
- `yardsAllowed` (Integer)

**Database Table:** `defensive_stats`

**JPA Entity:** `DefensiveStatsEntity`

---

#### 3. KickerStats (Field Goals & Extra Points)

**Purpose:** Track kicker performance per game

**Fields:**
- `nflPlayerId` (String/Long): ESPN player ID
- `nflPlayerName` (String): "Harrison Butker"
- `nflTeam` (String): "Kansas City Chiefs"
- `nflWeek` (Integer): 1-22
- `nflGameId` (String)
- `gameDate` (LocalDate)
- `gameStatus` (Enum)

**Field Goal Stats:**
- `fieldGoalsMade0to39` (Integer)
- `fieldGoalsAttempted0to39` (Integer)
- `fieldGoalsMade40to49` (Integer)
- `fieldGoalsAttempted40to49` (Integer)
- `fieldGoalsMade50Plus` (Integer)
- `fieldGoalsAttempted50Plus` (Integer)

**Extra Point Stats:**
- `extraPointsMade` (Integer)
- `extraPointsAttempted` (Integer)

**Database Table:** `kicker_stats`

**JPA Entity:** `KickerStatsEntity`

---

#### 4. NflGame (Game Metadata)

**Purpose:** Track NFL game information and status

**Fields:**
- `nflGameId` (String): ESPN game ID (primary key)
- `nflWeek` (Integer): 1-22
- `homeTeam` (String): "Kansas City Chiefs"
- `awayTeam` (String): "Buffalo Bills"
- `gameDate` (LocalDateTime)
- `gameStatus` (Enum): SCHEDULED, LIVE, FINAL, POSTPONED
- `homeScore` (Integer)
- `awayScore` (Integer)
- `quarter` (Integer): 1-4 (or null if not started)
- `clockTime` (String): "12:45" in current quarter

**Database Table:** `nfl_games`

**JPA Entity:** `NflGameEntity`

---

### Data Mapping Examples

#### ESPN Player Stats → PlayerStats Entity

**ESPN Response:**
```json
{
  "athlete": {
    "id": "3139477",
    "displayName": "Patrick Mahomes",
    "position": {"abbreviation": "QB"},
    "team": {"abbreviation": "KC"}
  },
  "statistics": {
    "passing": {
      "yards": 325,
      "touchdowns": 3,
      "interceptions": 0,
      "completions": 28,
      "attempts": 38
    },
    "rushing": {
      "yards": 18,
      "touchdowns": 0,
      "attempts": 3
    }
  }
}
```

**Mapped to PlayerStatsEntity:**
```java
PlayerStatsEntity stats = new PlayerStatsEntity();
stats.setNflPlayerId("3139477");
stats.setNflPlayerName("Patrick Mahomes");
stats.setNflTeam("KC");
stats.setPosition(Position.QB);
stats.setNflWeek(1);
stats.setPassingYards(325);
stats.setPassingTouchdowns(3);
stats.setInterceptions(0);
stats.setCompletions(28);
stats.setAttempts(38);
stats.setRushingYards(18);
stats.setRushingTouchdowns(0);
stats.setRushingAttempts(3);
```

#### ESPN Defense Stats → DefensiveStats Entity

**ESPN Response:**
```json
{
  "team": {"abbreviation": "KC"},
  "statistics": {
    "sacks": 3,
    "interceptions": 1,
    "fumblesRecovered": 0,
    "safeties": 0,
    "touchdowns": 1,
    "pointsAllowed": 10,
    "yardsAllowed": 250
  }
}
```

**Mapped to DefensiveStatsEntity:**
```java
DefensiveStatsEntity stats = new DefensiveStatsEntity();
stats.setNflTeam("KC");
stats.setNflWeek(1);
stats.setSacks(3);
stats.setInterceptions(1);
stats.setFumbleRecoveries(0);
stats.setSafeties(0);
stats.setDefensiveTouchdowns(1);
stats.setPointsAllowed(10);
stats.setYardsAllowed(250);
```

---

## NflDataProvider Port Redesign

### Current Interface (WRONG) ❌

```java
public interface NflDataProvider {
    Score getTeamScore(String nflTeam, Integer weekNumber);
    List<String> getPlayoffTeams(Integer year);
    List<String> getAvailableTeamsForWeek(Integer weekNumber);
    boolean isTeamInPlayoffs(String nflTeam, Integer year);
}
```

---

### Proposed New Interface ✅

```java
package com.ffl.playoffs.domain.port;

import com.ffl.playoffs.domain.model.PlayerStats;
import com.ffl.playoffs.domain.model.DefensiveStats;
import com.ffl.playoffs.domain.model.KickerStats;
import com.ffl.playoffs.domain.model.NflGame;

import java.util.List;
import java.util.Optional;

/**
 * Port (interface) for NFL data integration.
 * This defines the contract for fetching individual NFL player statistics,
 * defensive team statistics, and game metadata.
 */
public interface NflDataProvider {

    // ==================== PLAYER STATS ====================

    /**
     * Fetch individual NFL player stats for a specific week.
     * Returns stats for ALL players who played in the specified week.
     *
     * @param nflWeek NFL week number (1-22)
     * @return List of player statistics for all games in that week
     */
    List<PlayerStats> getPlayerStatsByWeek(Integer nflWeek);

    /**
     * Fetch individual NFL player stats for a specific player in a specific week.
     *
     * @param nflPlayerId ESPN player ID
     * @param nflWeek NFL week number (1-22)
     * @return Player statistics for that week, or empty if player didn't play
     */
    Optional<PlayerStats> getPlayerStats(String nflPlayerId, Integer nflWeek);

    /**
     * Fetch individual NFL player stats for a specific game.
     *
     * @param nflPlayerId ESPN player ID
     * @param nflGameId ESPN game ID
     * @return Player statistics for that game, or empty if player didn't play
     */
    Optional<PlayerStats> getPlayerStatsForGame(String nflPlayerId, String nflGameId);

    // ==================== DEFENSIVE STATS ====================

    /**
     * Fetch team defense stats for a specific week.
     * Returns defensive stats for ALL teams in the specified week.
     *
     * @param nflWeek NFL week number (1-22)
     * @return List of defensive statistics for all teams in that week
     */
    List<DefensiveStats> getDefensiveStatsByWeek(Integer nflWeek);

    /**
     * Fetch team defense stats for a specific team in a specific week.
     *
     * @param nflTeam NFL team abbreviation (e.g., "KC", "BUF")
     * @param nflWeek NFL week number (1-22)
     * @return Defensive statistics for that team in that week
     */
    Optional<DefensiveStats> getDefensiveStats(String nflTeam, Integer nflWeek);

    /**
     * Fetch team defense stats for a specific game.
     *
     * @param nflTeam NFL team abbreviation
     * @param nflGameId ESPN game ID
     * @return Defensive statistics for that team in that game
     */
    Optional<DefensiveStats> getDefensiveStatsForGame(String nflTeam, String nflGameId);

    // ==================== KICKER STATS ====================

    /**
     * Fetch kicker stats for a specific week.
     *
     * @param nflWeek NFL week number (1-22)
     * @return List of kicker statistics for all kickers in that week
     */
    List<KickerStats> getKickerStatsByWeek(Integer nflWeek);

    /**
     * Fetch kicker stats for a specific kicker in a specific week.
     *
     * @param nflPlayerId ESPN player ID
     * @param nflWeek NFL week number (1-22)
     * @return Kicker statistics for that week
     */
    Optional<KickerStats> getKickerStats(String nflPlayerId, Integer nflWeek);

    // ==================== GAME METADATA ====================

    /**
     * Fetch all NFL games for a specific week.
     *
     * @param nflWeek NFL week number (1-22)
     * @return List of all games in that week with metadata
     */
    List<NflGame> getGamesByWeek(Integer nflWeek);

    /**
     * Fetch specific NFL game metadata.
     *
     * @param nflGameId ESPN game ID
     * @return Game metadata including status, scores, teams
     */
    Optional<NflGame> getGame(String nflGameId);

    /**
     * Check if games are currently live (in progress).
     * Used to determine if real-time polling should be active.
     *
     * @param nflWeek NFL week number (1-22)
     * @return True if any games in that week are currently in progress
     */
    boolean hasLiveGames(Integer nflWeek);

    // ==================== PLAYER SEARCH ====================

    /**
     * Search for NFL players by name.
     * Used for roster building UI to find players.
     *
     * @param nameQuery Partial player name (e.g., "Mahomes")
     * @param position Optional position filter (QB, RB, WR, TE, K, DEF)
     * @param limit Maximum number of results
     * @return List of matching players with metadata
     */
    List<NflPlayer> searchPlayers(String nameQuery, Optional<Position> position, Integer limit);

    /**
     * Get all active NFL players for a specific position.
     * Used for roster building UI to show position-specific player lists.
     *
     * @param position Player position (QB, RB, WR, TE, K, DEF)
     * @return List of all active players for that position
     */
    List<NflPlayer> getPlayersByPosition(Position position);
}
```

---

### Supporting Domain Model Classes

#### NflPlayer (Value Object)

**Purpose:** Represents an NFL player for roster selection

```java
package com.ffl.playoffs.domain.model;

public class NflPlayer {
    private final String nflPlayerId;      // ESPN player ID
    private final String displayName;       // "Patrick Mahomes"
    private final Position position;        // QB, RB, WR, TE, K, DEF
    private final String nflTeam;          // "KC"
    private final String nflTeamFullName;  // "Kansas City Chiefs"
    private final Integer jerseyNumber;    // 15
    private final Integer byeWeek;         // 12

    // Constructor, getters, equals/hashCode
}
```

#### Position (Enum)

```java
package com.ffl.playoffs.domain.model;

public enum Position {
    QB,      // Quarterback
    RB,      // Running Back
    WR,      // Wide Receiver
    TE,      // Tight End
    K,       // Kicker
    DEF,     // Defense/Special Teams
    FLEX,    // Flex position (RB/WR/TE eligible)
    SUPERFLEX // Superflex (QB/RB/WR/TE eligible)
}
```

#### GameStatus (Enum)

```java
package com.ffl.playoffs.domain.model;

public enum GameStatus {
    SCHEDULED,  // Game not started yet
    LIVE,       // Game in progress
    FINAL,      // Game completed
    POSTPONED,  // Game postponed
    CANCELLED   // Game cancelled
}
```

---

### Implementation: EspnDataAdapter

**Location:** `ffl-playoffs-api/src/main/java/com/ffl/playoffs/infrastructure/adapter/integration/EspnDataAdapter.java`

**Implements:** `NflDataProvider` port

**Responsibilities:**
- Make HTTP requests to ESPN API endpoints
- Parse JSON responses
- Map ESPN data to domain models (PlayerStats, DefensiveStats, etc.)
- Handle HTTP errors and timeouts
- Apply rate limiting
- Cache responses

**Dependencies:**
- HTTP client (RestTemplate or WebClient)
- JSON parser (Jackson)
- Cache (Spring Cache with Caffeine or Redis)

**Example Method:**
```java
@Override
public List<PlayerStats> getPlayerStatsByWeek(Integer nflWeek) {
    String url = String.format(
        "http://site.api.espn.com/apis/site/v2/sports/football/nfl/scoreboard?week=%d",
        nflWeek
    );

    // Check cache first
    String cacheKey = "player-stats-week-" + nflWeek;
    List<PlayerStats> cached = cacheService.get(cacheKey);
    if (cached != null) {
        return cached;
    }

    // Rate limit check
    rateLimiter.acquire();

    // Fetch from ESPN
    try {
        EspnScoreboardResponse response = restTemplate.getForObject(url, EspnScoreboardResponse.class);
        List<PlayerStats> stats = espnMapper.mapToPlayerStats(response);

        // Cache for 1 hour (or permanently if game is final)
        cacheService.put(cacheKey, stats, determineCacheTTL(nflWeek));

        return stats;
    } catch (HttpClientErrorException e) {
        logger.error("ESPN API error: {}", e.getMessage());
        throw new NflDataException("Failed to fetch player stats", e);
    }
}
```

---

## Caching Strategy

### Cache Layers

#### 1. Application-Level Cache (Caffeine)

**Purpose:** In-memory cache for frequently accessed data

**What to Cache:**
- Completed game stats (permanent cache until stat correction window)
- Live game stats (5-minute TTL)
- Player search results (1-hour TTL)
- NFL team rosters (1-day TTL)

**Implementation:**
```java
@Configuration
@EnableCaching
public class CacheConfig {
    @Bean
    public CacheManager cacheManager() {
        CaffeineCacheManager cacheManager = new CaffeineCacheManager(
            "player-stats",
            "defensive-stats",
            "games",
            "player-search"
        );

        cacheManager.setCaffeine(Caffeine.newBuilder()
            .maximumSize(10000)
            .expireAfterWrite(1, TimeUnit.HOURS)
            .recordStats());

        return cacheManager;
    }
}
```

**Cache Keys:**
- `player-stats:week:{week}` → List<PlayerStats>
- `player-stats:player:{playerId}:week:{week}` → PlayerStats
- `defensive-stats:week:{week}` → List<DefensiveStats>
- `games:week:{week}` → List<NflGame>
- `player-search:{query}:{position}` → List<NflPlayer>

**TTL Rules:**
- **Completed games (status=FINAL)**: Cache until Tuesday 3 AM ET (stat correction window)
- **Live games (status=LIVE)**: Cache for 5 minutes
- **Scheduled games (status=SCHEDULED)**: Cache for 1 hour
- **Player search results**: Cache for 1 hour
- **NFL rosters**: Cache for 1 day

---

#### 2. Database Cache (Persistent)

**Purpose:** Store fetched stats in database to avoid redundant API calls

**What to Store:**
- All player stats fetched from ESPN (player_stats table)
- All defensive stats (defensive_stats table)
- All kicker stats (kicker_stats table)
- All game metadata (nfl_games table)

**Query Strategy:**
1. Check database first for requested stats
2. If found and game is FINAL, return from database (no API call)
3. If found and game is LIVE/SCHEDULED, check if data is stale (>5 minutes)
4. If not found or stale, fetch from ESPN API and store in database

**Implementation:**
```java
@Override
public Optional<PlayerStats> getPlayerStats(String nflPlayerId, Integer nflWeek) {
    // Check database first
    Optional<PlayerStatsEntity> entity = playerStatsRepository
        .findByNflPlayerIdAndNflWeek(nflPlayerId, nflWeek);

    if (entity.isPresent()) {
        PlayerStatsEntity stats = entity.get();

        // If game is final, return cached stats (no API call)
        if (stats.getGameStatus() == GameStatus.FINAL && !isInStatCorrectionWindow(stats.getGameDate())) {
            return Optional.of(mapper.toDomain(stats));
        }

        // If data is fresh (< 5 minutes), return cached stats
        if (Duration.between(stats.getUpdatedAt(), Instant.now()).toMinutes() < 5) {
            return Optional.of(mapper.toDomain(stats));
        }
    }

    // Fetch from ESPN API and update database
    return fetchAndStorePlayerStats(nflPlayerId, nflWeek);
}
```

---

#### 3. HTTP Response Cache (Optional)

**Purpose:** Cache raw HTTP responses from ESPN API

**Implementation:** Use Spring's HTTP caching or reverse proxy (Nginx)

**Benefits:**
- Reduces parsing overhead
- Protects against ESPN API rate limits
- Faster response times

**Not Recommended for MVP:** Database cache is sufficient

---

### Cache Invalidation Strategy

#### Stat Correction Window

**Problem:** NFL applies stat corrections up to 48 hours after games
**Solution:** Re-fetch and update stats on Tuesday morning

**Implementation:**
```java
@Scheduled(cron = "0 0 3 * * TUE")  // Tuesday 3 AM ET
public void handleStatCorrections() {
    LocalDate lastWeekSunday = LocalDate.now().minusDays(2);
    Integer weekToUpdate = getNflWeek(lastWeekSunday);

    logger.info("Running stat correction update for week {}", weekToUpdate);

    // Re-fetch all stats for last week
    List<PlayerStats> updatedStats = nflDataProvider.getPlayerStatsByWeek(weekToUpdate);

    // Update database
    updatedStats.forEach(stats -> {
        playerStatsRepository.save(mapper.toEntity(stats));
    });

    // Clear cache
    cacheManager.getCache("player-stats").evict("week:" + weekToUpdate);

    logger.info("Stat corrections applied for week {}", weekToUpdate);
}
```

#### Live Game Cache Invalidation

**Problem:** Live game stats change constantly
**Solution:** Short TTL (5 minutes) for in-progress games

**Implementation:**
```java
private Duration determineCacheTTL(GameStatus gameStatus) {
    return switch (gameStatus) {
        case LIVE -> Duration.ofMinutes(5);
        case FINAL -> Duration.ofDays(7);  // Until stat correction window
        case SCHEDULED -> Duration.ofHours(1);
        default -> Duration.ofMinutes(30);
    };
}
```

---

## Error Handling & Fallback

### Error Scenarios

#### 1. ESPN API Unavailable (HTTP 5xx)

**Scenario:** ESPN API returns 500/503 error
**Fallback:** Return cached data if available, otherwise throw exception
**User Experience:** Show last known scores with "Last updated: X minutes ago" message

**Implementation:**
```java
try {
    return fetchFromEspnApi(url);
} catch (HttpServerErrorException e) {
    logger.error("ESPN API unavailable: {}", e.getMessage());

    // Try to return cached data
    Optional<PlayerStats> cached = cacheService.get(cacheKey);
    if (cached.isPresent()) {
        logger.warn("Returning stale cached data due to ESPN API error");
        return cached;
    }

    // No cached data available
    throw new NflDataUnavailableException("ESPN API unavailable and no cached data", e);
}
```

---

#### 2. Rate Limit Exceeded (HTTP 429)

**Scenario:** ESPN API throttles requests (unlikely but possible)
**Fallback:** Exponential backoff, return cached data
**Prevention:** Implement client-side rate limiting (1 request per 2 seconds)

**Implementation:**
```java
@Component
public class EspnRateLimiter {
    private final RateLimiter rateLimiter = RateLimiter.create(0.5);  // 1 request per 2 seconds

    public void acquire() {
        rateLimiter.acquire();
    }
}
```

**Retry Logic:**
```java
@Retryable(
    value = HttpClientErrorException.class,
    maxAttempts = 3,
    backoff = @Backoff(delay = 2000, multiplier = 2)
)
public PlayerStats fetchWithRetry(String url) {
    return restTemplate.getForObject(url, PlayerStats.class);
}
```

---

#### 3. Invalid/Missing Data

**Scenario:** ESPN API returns unexpected JSON structure or null values
**Fallback:** Log error, skip that record, continue processing others
**User Experience:** Show partial data with message "Some stats unavailable"

**Implementation:**
```java
private PlayerStats mapEspnResponse(EspnPlayerResponse response) {
    try {
        return PlayerStats.builder()
            .nflPlayerId(response.getAthlete().getId())
            .nflPlayerName(response.getAthlete().getDisplayName())
            .passingYards(response.getStatistics().getPassing().getYards())
            // ... more mappings ...
            .build();
    } catch (NullPointerException e) {
        logger.error("Invalid ESPN response for player {}: {}",
            response.getAthlete().getId(), e.getMessage());
        return null;  // Skip this player
    }
}
```

---

#### 4. Network Timeout

**Scenario:** ESPN API takes too long to respond
**Fallback:** Timeout after 10 seconds, return cached data or error
**Prevention:** Set reasonable HTTP timeouts

**Implementation:**
```java
@Bean
public RestTemplate restTemplate() {
    HttpComponentsClientHttpRequestFactory factory = new HttpComponentsClientHttpRequestFactory();
    factory.setConnectTimeout(5000);  // 5 seconds
    factory.setReadTimeout(10000);    // 10 seconds

    return new RestTemplate(factory);
}
```

---

### Fallback to sportsdata.io

**Trigger Conditions:**
- ESPN API returns 5xx errors for >1 hour
- ESPN API consistently fails validation checks
- Manual override by admin

**Implementation:**
```java
@Component
public class NflDataProviderSelector {
    private final EspnDataAdapter espnAdapter;
    private final SportsDataAdapter sportsDataAdapter;
    private final CircuitBreaker circuitBreaker;

    public NflDataProvider selectProvider() {
        if (circuitBreaker.isEspnHealthy()) {
            return espnAdapter;
        } else {
            logger.warn("ESPN API unhealthy, falling back to sportsdata.io");
            return sportsDataAdapter;
        }
    }
}
```

**Circuit Breaker:**
```java
@Configuration
public class CircuitBreakerConfig {
    @Bean
    public CircuitBreaker espnCircuitBreaker() {
        return CircuitBreaker.of("espnApi", CircuitBreakerConfig.custom()
            .failureRateThreshold(50)
            .waitDurationInOpenState(Duration.ofMinutes(5))
            .build());
    }
}
```

---

### Monitoring & Alerts

**Metrics to Track:**
- ESPN API success rate
- ESPN API response time
- Cache hit rate
- Number of stat corrections applied
- Number of live games being polled

**Alerts:**
- ESPN API success rate < 95%
- ESPN API response time > 5 seconds
- No stats updated for > 24 hours

**Implementation:**
```java
@Component
public class NflDataMetrics {
    private final MeterRegistry registry;

    public void recordApiCall(String provider, boolean success, long durationMs) {
        registry.counter("nfl.api.calls",
            "provider", provider,
            "success", String.valueOf(success))
            .increment();

        registry.timer("nfl.api.duration",
            "provider", provider)
            .record(durationMs, TimeUnit.MILLISECONDS);
    }
}
```

---

## Rate Limiting Considerations

### ESPN API Rate Limits

**Observed Limits (Community Reports):**
- No official published limits
- Anecdotal evidence suggests 1-2 requests/second is safe
- Burst requests (10+ in quick succession) may trigger throttling

**Recommended Approach:**
- **Conservative Limit**: 1 request per 2 seconds (30 requests/minute)
- **Burst Allowance**: Up to 5 requests in quick succession, then throttle
- **Daily Limit**: No known daily limit, but monitor for changes

**Implementation:**
```java
@Component
public class EspnRateLimiter {
    // Sustained rate: 0.5 requests/second (1 per 2 seconds)
    private final RateLimiter sustained = RateLimiter.create(0.5);

    // Burst rate: 5 permits available, refill at 0.5/second
    private final RateLimiter burst = RateLimiter.create(0.5, 5, TimeUnit.SECONDS);

    public void acquire() {
        sustained.acquire();
        burst.acquire();
    }
}
```

---

### Usage Estimates

#### Scenario 1: MVP (Batch Only)

**Daily Stats Fetch:**
- 1 request per NFL week for all player stats
- 1 request per NFL week for all defensive stats
- Total: 2 requests/day

**Weekly Stat Correction:**
- 1 request per week for re-fetch
- Total: 1 request/week

**Monthly Total:** ~60 requests/month

**Conclusion:** ✅ Well within safe limits for free ESPN API

---

#### Scenario 2: Real-time Polling (Phase 2)

**Typical Sunday:**
- 10-13 games over 8 hours
- Poll every 5 minutes
- 13 games × (480 minutes / 5) = 1,248 requests

**Typical Season:**
- 18 weeks
- Assume 3 game days per week (Thu, Sun, Mon)
- Sunday: 1,248 requests
- Thursday: ~200 requests (2 games)
- Monday: ~200 requests (2 games)
- Weekly total: ~1,650 requests

**Monthly Total:** ~7,000 requests/month

**Conclusion:** ✅ Still safe for free ESPN API with proper rate limiting

---

#### Scenario 3: Large Scale (100+ concurrent users)

**Real-time Polling:**
- Same as Scenario 2 (polling doesn't scale with users, only with number of games)
- 7,000 requests/month

**Player Search Requests:**
- Assume 100 users building rosters
- Each user searches 20 times
- Total: 2,000 searches

**Monthly Total:** ~9,000 requests/month

**Conclusion:** ✅ Still manageable with caching and rate limiting

**Recommendation:** If user base grows beyond 500 active users, consider migrating to sportsdata.io ($20-$100/mo)

---

### Rate Limiter Configuration

**Spring Configuration:**
```yaml
# application.yml
nfl-data:
  espn:
    rate-limit:
      requests-per-second: 0.5
      burst-capacity: 5
  sportsdata:
    rate-limit:
      requests-per-second: 10
      burst-capacity: 50
```

**Java Configuration:**
```java
@Configuration
@ConfigurationProperties(prefix = "nfl-data.espn.rate-limit")
public class EspnRateLimitConfig {
    private double requestsPerSecond = 0.5;
    private int burstCapacity = 5;

    @Bean
    public RateLimiter espnRateLimiter() {
        return RateLimiter.create(requestsPerSecond, burstCapacity, TimeUnit.SECONDS);
    }
}
```

---

## Implementation Phases

### Phase 1: MVP (Batch Stats Fetching)

**Timeline:** 2-3 weeks

**Features:**
- ✅ ESPN API integration (EspnDataAdapter)
- ✅ Redesigned NflDataProvider port
- ✅ PlayerStats, DefensiveStats, KickerStats domain models
- ✅ Database entities (PlayerStatsEntity, DefensiveStatsEntity, KickerStatsEntity, NflGameEntity)
- ✅ Scheduled batch job (daily at 3 AM ET)
- ✅ Stat correction handling (Tuesday re-fetch)
- ✅ Application-level caching (Caffeine)
- ✅ Database persistence
- ✅ Basic error handling
- ✅ Rate limiting (1 request per 2 seconds)

**What Users Get:**
- Daily stats updates (scores updated within 24 hours of game completion)
- Accurate stats after Tuesday stat correction window
- Reliable, low-maintenance system

**API Calls:** ~60/month (well within free ESPN API limits)

---

### Phase 2: Real-time Polling (Optional Enhancement)

**Timeline:** 1-2 weeks (after Phase 1 stable)

**Features:**
- ✅ Live game detection (check for in-progress games)
- ✅ Real-time polling during game windows (every 5 minutes)
- ✅ WebSocket support for pushing live updates to UI
- ✅ Short-lived cache for live stats (5-minute TTL)
- ✅ Increased rate limiting capacity

**What Users Get:**
- Real-time score updates during live games
- More engaging user experience
- See scores change as games progress

**API Calls:** ~7,000/month (still safe for free ESPN API)

---

### Phase 3: sportsdata.io Integration (Future)

**Timeline:** 1 week (when needed)

**Trigger:**
- ESPN API becomes unreliable
- User base grows beyond 500 active users
- Real-time accuracy becomes critical

**Features:**
- ✅ SportsDataAdapter implementing NflDataProvider
- ✅ Webhook endpoint for instant stat updates
- ✅ Event queue for processing stat updates
- ✅ Provider selection logic (ESPN vs sportsdata.io)
- ✅ Circuit breaker pattern for automatic failover

**What Users Get:**
- Instant stat updates (no 5-minute delay)
- Higher reliability (SLA-backed API)
- More comprehensive player metadata

**Cost:** $20-$100/month (depending on usage tier)

---

### Phase 4: Advanced Features (Future)

**Timeline:** TBD

**Features:**
- Player projections (expected fantasy points)
- Injury status tracking
- Weather data for outdoor games
- Advanced analytics (strength of schedule, matchup ratings)
- Historical player performance trends

---

## Risk Assessment

### High Risk ⚠️

#### 1. ESPN API Changes Without Notice

**Likelihood:** Medium
**Impact:** High (app stops working)
**Mitigation:**
- Build abstraction layer (NflDataProvider port)
- Monitor API responses for structure changes
- Have sportsdata.io adapter ready as fallback
- Version ESPN API responses in tests

**Detection:**
- Automated validation tests (daily)
- Alert if response structure changes

**Recovery Plan:**
- Switch to sportsdata.io within 24 hours
- Use cached data in interim

---

#### 2. ESPN API Rate Limiting

**Likelihood:** Low (with proper rate limiting)
**Impact:** Medium (temporary data unavailability)
**Mitigation:**
- Implement conservative rate limiting (1 request per 2 seconds)
- Aggressive caching strategy
- Return stale cached data during rate limit events

**Detection:**
- Monitor for HTTP 429 responses
- Track API call frequency

**Recovery Plan:**
- Exponential backoff retry logic
- Temporarily disable real-time polling
- Fall back to batch-only mode

---

### Medium Risk ⚠️

#### 3. Stat Corrections Break User Trust

**Likelihood:** Medium (stat corrections happen regularly in NFL)
**Impact:** Medium (user complaints, perceived bugs)
**Mitigation:**
- Clear UI messaging: "Stats update within 48 hours"
- Show stat correction history (what changed and when)
- Re-fetch stats on Tuesday after correction window

**Detection:**
- Compare stats before/after Tuesday re-fetch
- Log all stat changes

**User Communication:**
- "Final scores will be available Tuesday" message
- Highlight changed stats in UI

---

#### 4. Database Storage Growth

**Likelihood:** High (stats accumulate over time)
**Impact:** Low (just storage cost)
**Mitigation:**
- Archive old seasons to cold storage
- Compress historical data
- Monitor database size

**Estimates:**
- ~2,000 NFL players × 17 weeks × 100 bytes = 3.4 MB per season
- 10 seasons = 34 MB (negligible)

**Conclusion:** Not a real concern

---

### Low Risk ✅

#### 5. Player Data Inaccuracies

**Likelihood:** Low (ESPN data is authoritative)
**Impact:** Low (rare edge cases)
**Mitigation:**
- Use official ESPN data
- Validate against multiple sources if needed
- Allow admin override for disputed stats

---

#### 6. Cache Inconsistency

**Likelihood:** Low (with proper TTL)
**Impact:** Low (minor user confusion)
**Mitigation:**
- Clear cache invalidation rules
- Short TTLs for live games
- Manual cache clear admin tool

---

## Conclusion

### Summary of Recommendations

| Decision | Recommendation | Rationale |
|----------|---------------|-----------|
| **Primary Data Source** | ESPN API (free) | Comprehensive stats, reliable, free, widely used |
| **Fallback Data Source** | sportsdata.io (paid) | Official NFL partner, SLA guarantees, use when scaling |
| **Data Fetching Strategy** | Hybrid (batch + real-time) | Batch for MVP (simple, reliable), add real-time later |
| **NflDataProvider Design** | Redesigned interface | Current design is survivor pool (team-based), need player-based |
| **Caching Strategy** | Multi-layer (Caffeine + DB) | Application cache for speed, DB for persistence |
| **Rate Limiting** | 1 request per 2 seconds | Conservative, safe for ESP API |
| **Error Handling** | Circuit breaker + fallback | Return cached data on ESPN failure, switch to sportsdata.io if needed |

---

### Critical Actions Before Development

1. ✅ **Redesign NflDataProvider interface** (remove team-based methods, add player-based methods)
2. ✅ **Create domain models** (PlayerStats, DefensiveStats, KickerStats, NflGame)
3. ✅ **Create database entities** (PlayerStatsEntity, DefensiveStatsEntity, etc.)
4. ✅ **Implement EspnDataAdapter** (HTTP client, JSON parsing, mapping)
5. ✅ **Implement scheduled batch job** (daily stats fetch at 3 AM ET)
6. ✅ **Implement caching layer** (Caffeine for app cache, database for persistence)
7. ✅ **Implement rate limiting** (RateLimiter with 1 request per 2 seconds)
8. ✅ **Add monitoring and alerts** (track API success rate, response time)

---

### Next Steps

1. **Review and approve this proposal** with team
2. **Create implementation tickets** for Phase 1 (MVP)
3. **Set up ESPN API integration tests** (verify response structure)
4. **Implement NflDataProvider redesign** (update interface and create new adapter)
5. **Build scheduled batch jobs** (daily stats fetch + Tuesday stat corrections)
6. **Test with real ESPN data** (verify mapping accuracy)
7. **Monitor API usage and performance** (ensure rate limits not exceeded)
8. **Document API integration** for future developers

---

**Status:** 🟢 READY FOR APPROVAL

**Reviewed by:** Feature Architect (Engineer 1)
**Date:** 2025-10-02
**Priority:** HIGH
**Estimated Effort:** 2-3 weeks (Phase 1 MVP)

---

### Appendix: ESPN API Endpoints Reference

#### Scoreboard (All games for a week)
```
GET http://site.api.espn.com/apis/site/v2/sports/football/nfl/scoreboard?week={week}
```

#### Player Stats (Specific player, specific week)
```
GET http://sports.core.api.espn.com/v2/sports/football/leagues/nfl/seasons/{year}/types/2/weeks/{week}/athletes/{playerId}/statistics
```

#### Team Roster (All players on a team)
```
GET http://site.api.espn.com/apis/site/v2/sports/football/nfl/teams/{teamId}/roster
```

#### Player Search (Search by name)
```
GET http://site.api.espn.com/apis/common/v3/search?query={name}&limit={limit}&lang=en&region=us&type=player
```

---

### Appendix: sportsdata.io API Endpoints Reference

#### Player Game Stats (All players, specific week)
```
GET https://api.sportsdata.io/v3/nfl/stats/json/PlayerGameStatsByWeek/{season}/{week}?key={apiKey}
```

#### Team Game Stats (All teams, specific week)
```
GET https://api.sportsdata.io/v3/nfl/scores/json/ScoresByWeek/{season}/{week}?key={apiKey}
```

#### Real-time Player Stats (Specific player, live game)
```
GET https://api.sportsdata.io/v3/nfl/stats/json/PlayerGameStatsByPlayerID/{playerId}?key={apiKey}
```

---

**END OF PROPOSAL**
