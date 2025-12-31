@ANIMA-1416 @backend @priority_2 @search
Feature: Search System
  As a fantasy football playoffs platform user
  I want to search for players, teams, leagues, and users
  So that I can quickly find the information I need

  Background:
    Given a user is authenticated
    And the search system is enabled
    And search indexes are up-to-date

  # ==================== GLOBAL SEARCH ====================

  Scenario: Perform global search
    Given the user accesses the search bar
    When the user enters "Mahomes"
    Then search results include all matching entities:
      | Type    | Result                    | Relevance |
      | Player  | Patrick Mahomes (QB, KC)  | High      |
      | Team    | Mahomes Fan Club          | Medium    |
      | League  | Mahomes Dynasty League    | Medium    |
      | User    | mahomes_lover_22          | Low       |
    And results are grouped by entity type
    And total result count is displayed

  Scenario: Search with empty query
    Given the user focuses on the search bar
    When the user submits an empty search
    Then the system displays:
      | Message              | "Enter a search term to find players, teams, leagues, and users" |
      | Suggestions          | Popular searches, trending topics                                 |
      | Recent Searches      | User's last 5 searches                                            |
    And no error is shown

  Scenario: Search with special characters
    Given the user enters a search query "O'Brien #1"
    When the search is executed
    Then special characters are properly handled
    And results matching "O'Brien" are returned
    And no injection vulnerabilities occur
    And search remains functional

  Scenario: Search with minimum character requirement
    Given the search requires minimum 2 characters
    When the user types "M"
    Then the system displays "Enter at least 2 characters"
    When the user types "Ma"
    Then search suggestions begin appearing
    And autocomplete activates

  Scenario: Search across all entity types
    Given the user searches for "Champions"
    When the global search executes
    Then results span multiple categories:
      | Category        | Results Found |
      | NFL Players     | 0             |
      | Fantasy Teams   | 12            |
      | Leagues         | 8             |
      | Users           | 5             |
    And category tabs allow filtering
    And "All Results" tab shows combined view

  Scenario: Handle no search results
    Given the user searches for "xyznonexistent123"
    When the search completes
    Then the system displays:
      | Message         | "No results found for 'xyznonexistent123'" |
      | Suggestions     | Check spelling, try different keywords      |
      | Similar Terms   | Related search suggestions if available     |
    And search analytics record the failed search

  # ==================== PLAYER SEARCH ====================

  Scenario: Search for NFL player by name
    Given the user selects "Players" search category
    When the user searches for "Patrick Mahomes"
    Then matching players are displayed:
      | Player           | Position | Team   | Status    | Fantasy Pts |
      | Patrick Mahomes  | QB       | Chiefs | Active    | 28.5 avg    |
    And player cards show key statistics
    And quick actions are available (Add to roster, View details)

  Scenario: Search for player by partial name
    Given the user searches for "Maho"
    When results load
    Then matching players include:
      | Player              | Match Type        |
      | Patrick Mahomes     | Last name match   |
      | Raheem Mahommed     | Last name partial |
    And results are ranked by relevance
    And exact matches appear first

  Scenario: Search for player by team
    Given the user searches for "Chiefs QB"
    When the search executes
    Then results show:
      | Player           | Position | Team   |
      | Patrick Mahomes  | QB       | Chiefs |
      | Carson Wentz     | QB       | Chiefs |
    And team filter is auto-applied
    And position filter is auto-applied

  Scenario: Search for player by position
    Given the user searches for "top RB"
    When results load
    Then running backs are displayed:
      | Player          | Team    | Fantasy Rank |
      | Christian McCaffrey | 49ers | #1 RB       |
      | Derrick Henry   | Ravens  | #2 RB        |
      | Saquon Barkley  | Eagles  | #3 RB        |
    And results are sorted by fantasy ranking
    And position statistics are shown

  Scenario: Search for injured players
    Given the user searches for "injured WR"
    When results load
    Then injured wide receivers are displayed:
      | Player          | Team    | Injury      | Status   |
      | Davante Adams   | Raiders | Hamstring   | Doubtful |
      | Chris Godwin    | Bucs    | Knee        | Out      |
    And injury details are prominently shown
    And return timeline is included when available

  Scenario: Search for available players
    Given the user searches for "available TE"
    When results load with roster context
    Then unrostered tight ends are shown:
      | Player          | Team    | Ownership % | Projected Pts |
      | Dalton Schultz  | Texans  | 45%         | 8.5           |
      | Cole Kmet       | Bears   | 38%         | 7.2           |
    And "Add to Team" action is available
    And ownership percentage helps gauge value

  # ==================== TEAM SEARCH ====================

  Scenario: Search for fantasy team by name
    Given the user selects "Teams" search category
    When the user searches for "Dominators"
    Then matching fantasy teams are displayed:
      | Team Name           | League              | Owner     | Record |
      | Doe's Dominators    | FFL Championship    | john_doe  | 8-2    |
      | The Dominators      | Office Pool 2025    | jane_doe  | 6-4    |
    And team cards show current standings
    And league context is provided

  Scenario: Search for team by owner
    Given the user searches for "john_doe teams"
    When the search executes
    Then teams owned by john_doe are displayed:
      | Team Name           | League              | Status   |
      | Doe's Dominators    | FFL Championship    | Active   |
      | John's All-Stars    | Dynasty League      | Active   |
      | Championship Squad  | FFL Pro 2024        | Archived |
    And owner profile link is available
    And team history is accessible

  Scenario: Search for team by league
    Given the user searches for teams in "FFL Championship"
    When results load
    Then all teams in that league are shown:
      | Team Name           | Owner        | Standing | Points  |
      | Doe's Dominators    | john_doe     | 1st      | 1,250.5 |
      | Jane's Juggernauts  | jane_doe     | 2nd      | 1,185.3 |
      | Bob's Ballers       | bob_player   | 3rd      | 1,142.8 |
    And league standings context is provided
    And matchup information is included

  Scenario: Search for NFL team
    Given the user searches for "Kansas City Chiefs"
    When results load
    Then NFL team information is displayed:
      | Section          | Content                        |
      | Team Overview    | Kansas City Chiefs             |
      | Record           | 12-4 (AFC West)                |
      | Playoff Status   | #2 Seed, Divisional Round      |
      | Key Players      | Mahomes, Kelce, Hill           |
      | Fantasy Impact   | 45 rostered players            |
    And links to player searches are available

  Scenario: Search for team by record
    Given the user searches for "undefeated teams"
    When results load
    Then teams with perfect records are shown:
      | Team Name           | League          | Record | Points  |
      | The Dynasty         | Dynasty League  | 10-0   | 1,520.3 |
      | Perfect Storm       | Pro League      | 8-0    | 1,180.5 |
    And record-based filtering is applied
    And sorting by win percentage is available

  # ==================== LEAGUE SEARCH ====================

  Scenario: Search for league by name
    Given the user selects "Leagues" search category
    When the user searches for "Championship"
    Then matching leagues are displayed:
      | League Name         | Type           | Players | Status  |
      | FFL Championship    | Head-to-Head   | 12      | Active  |
      | Championship 2024   | Points Only    | 20      | Active  |
      | Dynasty Championship| Dynasty        | 10      | Active  |
    And league cards show key information
    And join/view actions are available

  Scenario: Search for public leagues
    Given the user searches for "public league"
    When results load
    Then public leagues are displayed:
      | League Name         | Type           | Spots Open | Entry Fee |
      | Open Championship   | Head-to-Head   | 3          | Free      |
      | Pro Public League   | Points Only    | 5          | $25       |
    And "Join League" action is prominently shown
    And league rules summary is visible

  Scenario: Search for league by type
    Given the user searches for "dynasty league"
    When results load
    Then dynasty format leagues are shown:
      | League Name         | Dynasty Year | Players | Rookie Draft |
      | Dynasty Forever     | Year 5       | 12      | Upcoming     |
      | Long-Term Dynasty   | Year 3       | 10      | Completed    |
    And dynasty-specific details are included
    And keeper/draft information is shown

  Scenario: Search for league by commissioner
    Given the user searches for "commissioner:john_doe"
    When results load
    Then leagues managed by john_doe are displayed:
      | League Name         | Type           | Created    | Players |
      | FFL Championship    | Head-to-Head   | 2024-08-01 | 12      |
      | Friends League      | Points Only    | 2023-09-15 | 8       |
    And commissioner contact is available
    And league management context is provided

  Scenario: Search for leagues with open spots
    Given the user searches for "join league"
    When results load with availability filter
    Then leagues accepting members are shown:
      | League Name         | Spots Available | Draft Date | Buy-in  |
      | New Season Start    | 4               | 2025-08-15 | Free    |
      | Pro Money League    | 2               | 2025-08-20 | $50     |
    And join requirements are displayed
    And quick join action is available

  # ==================== USER SEARCH ====================

  Scenario: Search for user by username
    Given the user selects "Users" search category
    When the user searches for "@john_doe"
    Then matching users are displayed:
      | User            | Display Name | Status  | Mutual Friends |
      | @john_doe       | John Doe     | Online  | 5              |
      | @johnny_doe     | Johnny D     | Offline | 2              |
    And user cards show profile summary
    And connection actions are available

  Scenario: Search for user by display name
    Given the user searches for "John"
    When results load
    Then users with matching display names appear:
      | Username        | Display Name   | Teams | Leagues |
      | @john_doe       | John Doe       | 3     | 3       |
      | @johnny_b       | Johnny B       | 2     | 2       |
      | @john_smith_ff  | John Smith     | 1     | 1       |
    And partial matches are included
    And results are ranked by relevance

  Scenario: Search for user by email
    Given the user searches for "john@example.com"
    When results load
    Then the system:
      | If exact match found  | Show user with privacy notice    |
      | If user allows        | Display user in results          |
      | If user restricts     | Show "User found but private"    |
    And email privacy settings are respected
    And no email addresses are exposed

  Scenario: Search for users in same league
    Given the user searches for "FFL Championship members"
    When results load
    Then league members are displayed:
      | User            | Team                | Standing | Record |
      | @john_doe       | Doe's Dominators    | 1st      | 8-2    |
      | @jane_doe       | Jane's Juggernauts  | 2nd      | 7-3    |
      | @bob_player     | Bob's Ballers       | 3rd      | 6-4    |
    And league context is provided
    And head-to-head records are shown

  Scenario: Search for users to invite
    Given the user searches for friends to invite
    When the search includes contact integration
    Then suggestions include:
      | Source          | Users Found | Action          |
      | Existing Users  | 5           | Send Invite     |
      | Email Contacts  | 3           | Email Invite    |
      | Social Links    | 2           | Social Invite   |
    And invite actions are streamlined
    And duplicate detection prevents spam

  # ==================== SEARCH FILTERS ====================

  Scenario: Apply single filter to search
    Given the user searches for "RB"
    When the user applies the "Position: RB" filter
    Then results show only running backs
    And filter is displayed as active
    And "Clear Filter" option is available

  Scenario: Apply multiple filters
    Given the user searches for "available players"
    When the user applies multiple filters:
      | Filter Type     | Value           |
      | Position        | WR              |
      | Team            | Chiefs          |
      | Availability    | Unrostered      |
      | Projected Pts   | > 10            |
    Then results match all filter criteria
    And active filters are displayed
    And filter count is shown in UI

  Scenario: Use advanced filter options
    Given the user opens advanced filters
    When filter options are displayed
    Then available filters include:
      | Category        | Filter Options                    |
      | Entity Type     | Players, Teams, Leagues, Users    |
      | Date Range      | Last 7 days, 30 days, All time    |
      | Status          | Active, Archived, All             |
      | Ownership       | Rostered, Available, All          |
      | Score Range     | Min-Max point range               |
    And filters can be saved as presets

  Scenario: Save filter preset
    Given the user has configured complex filters
    When the user clicks "Save Filter Preset"
    Then the user can:
      | Action              | Input                      |
      | Name Preset         | "Available WR Targets"     |
      | Set as Default      | Optional checkbox          |
      | Share Preset        | Optional share link        |
    And preset is saved to user's account
    And preset appears in filter dropdown

  Scenario: Clear all filters
    Given the user has multiple active filters
    When the user clicks "Clear All Filters"
    Then all filters are removed
    And search results refresh to unfiltered state
    And filter UI resets to default
    And confirmation is shown briefly

  Scenario: Filter by date range
    Given the user searches for "league activity"
    When the user applies date filter "Last 7 days"
    Then results show only recent activity
    And date filter indicator shows active range
    And custom date range picker is available

  # ==================== SEARCH RESULTS ====================

  Scenario: Display search results with pagination
    Given a search returns 150 results
    When results are displayed
    Then pagination shows:
      | Element             | Value                      |
      | Results Per Page    | 20 (configurable)          |
      | Current Page        | 1 of 8                     |
      | Total Results       | 150                        |
      | Navigation          | First, Prev, Next, Last    |
    And infinite scroll is optionally available

  Scenario: Sort search results
    Given search results are displayed
    When the user selects sort option
    Then sort options include:
      | Sort By             | Order                      |
      | Relevance           | Default, most relevant     |
      | Name                | Alphabetical A-Z or Z-A    |
      | Date Added          | Newest or Oldest first     |
      | Fantasy Points      | Highest or Lowest first    |
      | Popularity          | Most viewed first          |
    And current sort is indicated
    And results refresh with new order

  Scenario: View search result details
    Given search results show player "Patrick Mahomes"
    When the user clicks on the result
    Then the detail view shows:
      | Section             | Content                    |
      | Player Info         | Full player profile        |
      | Statistics          | Season and career stats    |
      | Fantasy Value       | Points, projections, rank  |
      | Actions             | Add, Compare, Favorite     |
    And back navigation returns to results
    And result position is preserved

  Scenario: Quick actions on search results
    Given search results are displayed
    When the user hovers over a result
    Then quick actions appear:
      | Entity Type     | Available Actions              |
      | Player          | Add to Team, Compare, View     |
      | Team            | View Roster, Message Owner     |
      | League          | View Details, Join, Share      |
      | User            | View Profile, Add Friend       |
    And actions execute without leaving search

  Scenario: Group search results by category
    Given a global search returns mixed results
    When results are displayed
    Then grouping options include:
      | View Mode           | Description                |
      | Grouped             | Separate sections by type  |
      | Combined            | Single list by relevance   |
      | Tabbed              | Tabs for each entity type  |
    And user preference is remembered
    And counts per group are shown

  Scenario: Export search results
    Given the user has performed a search
    When the user clicks "Export Results"
    Then export options include:
      | Format              | Content                    |
      | CSV                 | Tabular data               |
      | JSON                | Structured data            |
      | Print               | Formatted for printing     |
    And export respects current filters
    And download initiates immediately

  # ==================== SEARCH HISTORY ====================

  Scenario: View recent searches
    Given the user accesses search history
    When history loads
    Then recent searches are displayed:
      | Search Query        | Date           | Results Found |
      | Patrick Mahomes     | 2 hours ago    | 5             |
      | available RB        | Yesterday      | 23            |
      | FFL Championship    | 3 days ago     | 1             |
    And searches are clickable to re-execute
    And "Clear History" option is available

  Scenario: Save search for later
    Given the user performs a search
    When the user clicks "Save Search"
    Then the search is saved with:
      | Element             | Value                      |
      | Query               | Original search term       |
      | Filters             | Active filters preserved   |
      | Date Saved          | Current timestamp          |
      | Notification        | Optional alert on changes  |
    And saved search appears in history
    And saved searches are accessible from profile

  Scenario: Delete search from history
    Given the user views search history
    When the user deletes a search entry
    Then the entry is removed from history
    And deletion is confirmed
    And remaining history is preserved
    And action can be undone briefly

  Scenario: Clear all search history
    Given the user has extensive search history
    When the user clicks "Clear All History"
    Then confirmation dialog appears
    And upon confirmation:
      | All search history is deleted     |
      | Saved searches are NOT deleted    |
      | Success message is displayed      |
    And history section shows empty state

  Scenario: Search history privacy
    Given the user configures search privacy
    When privacy settings are accessed
    Then options include:
      | Setting                 | Options                   |
      | Save History            | Enabled / Disabled        |
      | History Retention       | 7 days, 30 days, Forever  |
      | Share History           | Never / With consent      |
      | Include in Analytics    | Opt-in / Opt-out          |
    And changes apply immediately

  Scenario: Access search history across devices
    Given the user is logged in on multiple devices
    When search history is accessed
    Then history is synchronized:
      | Device          | History Status        |
      | Mobile          | Synced                |
      | Desktop         | Synced                |
      | Tablet          | Synced                |
    And real-time sync keeps history current
    And device-specific history is optionally available

  # ==================== SEARCH AUTOCOMPLETE ====================

  Scenario: Display autocomplete suggestions
    Given the user starts typing in search bar
    When the user types "Mah"
    Then autocomplete shows:
      | Suggestion          | Type    | Popularity |
      | Patrick Mahomes     | Player  | Trending   |
      | Mahomes Dynasty     | League  | Recent     |
      | mahomes_fan         | User    | -          |
    And suggestions update in real-time
    And keyboard navigation is supported

  Scenario: Show trending searches
    Given the user focuses on empty search bar
    When trending suggestions load
    Then trending searches display:
      | Trend               | Category | Searches Today |
      | Patrick Mahomes     | Player   | 1,250          |
      | Playoff Standings   | League   | 890            |
      | Injured Players     | Player   | 675            |
    And trends are time-relevant
    And personalized suggestions are included

  Scenario: Autocomplete with category hints
    Given the user types "Chiefs"
    When autocomplete displays
    Then category-tagged suggestions appear:
      | Suggestion              | Category Icon | Type   |
      | Kansas City Chiefs      | 🏈            | NFL Team |
      | Chiefs Fan League       | 🏆            | League   |
      | chiefs_kingdom          | 👤            | User     |
    And category icons aid quick identification
    And results are grouped logically

  Scenario: Learn from user behavior
    Given the user frequently searches for "Mahomes"
    When the user types "M"
    Then "Patrick Mahomes" appears as top suggestion
    And personalized ranking reflects:
      | Factor                  | Weight        |
      | Previous searches       | High          |
      | Clicked results         | High          |
      | Time of search          | Medium        |
      | General popularity      | Low           |
    And personalization can be disabled

  Scenario: Handle typos with fuzzy matching
    Given the user types "Patrik Mahomse"
    When autocomplete processes
    Then suggestions include:
      | Suggestion          | Match Type    |
      | Patrick Mahomes     | Fuzzy match   |
    And "Did you mean: Patrick Mahomes?" is shown
    And fuzzy matching threshold is reasonable

  Scenario: Autocomplete performance
    Given the user types quickly
    When characters are entered rapidly
    Then autocomplete:
      | Debounces requests (200ms delay)      |
      | Shows loading indicator if needed     |
      | Cancels pending requests on new input |
      | Displays results within 300ms         |
    And user experience remains smooth
    And server load is optimized

  # ==================== SEARCH ANALYTICS ====================

  Scenario: Track search metrics
    Given the system collects search analytics
    When analytics dashboard is accessed
    Then metrics include:
      | Metric                  | Value           |
      | Total Searches Today    | 5,432           |
      | Unique Searchers        | 1,234           |
      | Average Results/Search  | 15.3            |
      | Zero-Result Searches    | 3.2%            |
      | Search-to-Click Rate    | 68%             |
    And trends are visualized

  Scenario: Analyze popular searches
    Given search analytics are available
    When viewing popular searches
    Then top searches are displayed:
      | Rank | Search Term        | Count  | Trend    |
      | 1    | Patrick Mahomes    | 2,500  | +15%     |
      | 2    | available RB       | 1,800  | +8%      |
      | 3    | waiver wire        | 1,500  | Stable   |
      | 4    | injured players    | 1,200  | +25%     |
    And time-based filtering is available
    And export functionality is included

  Scenario: Identify failed searches
    Given zero-result searches are tracked
    When failed search report is viewed
    Then problem searches are identified:
      | Search Term            | Attempts | Suggested Fix          |
      | "Patrik Mahomse"       | 45       | Add fuzzy matching     |
      | "RB1 waiver"           | 32       | Create synonym         |
      | "keeper league open"   | 28       | Improve indexing       |
    And recommendations improve search quality
    And fixes can be implemented

  Scenario: Track search-to-action conversion
    Given search actions are tracked
    When conversion analytics are viewed
    Then data shows:
      | Search Type         | Searches | Actions | Conv. Rate |
      | Player Search       | 3,200    | 1,280   | 40%        |
      | League Search       | 850      | 510     | 60%        |
      | User Search         | 1,100    | 385     | 35%        |
    And action types are detailed
    And optimization opportunities are highlighted

  Scenario: Personalized search insights
    Given the user views their search insights
    When insights are displayed
    Then personal analytics show:
      | Insight                 | Value           |
      | Searches This Week      | 23              |
      | Most Searched           | RB, WR players  |
      | Search Success Rate     | 85%             |
      | Saved Searches          | 3               |
      | Favorite Categories     | Players, Teams  |
    And usage patterns are visualized
    And privacy controls are accessible

  Scenario: Real-time search monitoring
    Given admin monitors search system
    When real-time dashboard is viewed
    Then live metrics show:
      | Metric                  | Current Value   |
      | Searches Per Minute     | 45              |
      | Average Response Time   | 120ms           |
      | Cache Hit Rate          | 78%             |
      | Active Searchers        | 234             |
      | Error Rate              | 0.1%            |
    And alerts trigger on anomalies
    And historical comparison is available

  # ==================== SEARCH PERFORMANCE ====================

  Scenario: Search response time requirements
    Given search performance SLAs
    When searches are executed
    Then response times meet targets:
      | Search Type         | Target      | P95      |
      | Autocomplete        | < 100ms     | 85ms     |
      | Simple Search       | < 200ms     | 180ms    |
      | Filtered Search     | < 300ms     | 275ms    |
      | Complex Search      | < 500ms     | 450ms    |
    And performance is monitored
    And degradation triggers alerts

  Scenario: Search caching
    Given search caching is enabled
    When identical searches occur
    Then caching behavior:
      | First Search    | Cache miss, index query    |
      | Repeat Search   | Cache hit, instant return  |
      | Cache Duration  | 5 minutes default          |
      | Cache Invalidation | On data updates          |
    And cache metrics are tracked
    And cache can be manually cleared

  Scenario: Search index updates
    Given new data is added to the system
    When index update runs
    Then indexing behavior:
      | Update Type         | Latency       |
      | New Player Added    | < 30 seconds  |
      | Player Stats Update | < 1 minute    |
      | League Created      | < 30 seconds  |
      | User Registered     | < 30 seconds  |
    And search results reflect updates
    And reindexing can be triggered manually

  # ==================== SEARCH ACCESSIBILITY ====================

  Scenario: Keyboard navigation in search
    Given the user uses keyboard navigation
    When interacting with search
    Then keyboard controls work:
      | Key           | Action                       |
      | Tab           | Move to search bar           |
      | Enter         | Execute search               |
      | Arrow Down    | Navigate suggestions         |
      | Arrow Up      | Navigate suggestions up      |
      | Escape        | Close suggestions            |
    And focus indicators are visible
    And screen reader announces results

  Scenario: Voice search
    Given the user has voice search enabled
    When the user activates voice input
    Then the system:
      | Displays listening indicator       |
      | Transcribes speech to text         |
      | Executes search on completion      |
      | Shows confidence level             |
    And voice input can be corrected
    And fallback to text is available

  # ==================== ERROR HANDLING ====================

  Scenario: Handle search service unavailable
    Given the search service is temporarily down
    When the user attempts a search
    Then the system displays:
      | Error Message   | "Search is temporarily unavailable"  |
      | Status          | Service status indicator              |
      | Alternative     | "Try again in a few moments"          |
      | Fallback        | Basic search if available             |
    And error is logged
    And auto-retry is attempted

  Scenario: Handle search timeout
    Given a search query takes too long
    When timeout threshold is exceeded
    Then the system:
      | Shows timeout message               |
      | Offers to retry search              |
      | Suggests simplifying query          |
      | Logs timeout for analysis           |
    And partial results are shown if available
    And user is not blocked

  Scenario: Handle malformed search query
    Given the user enters potentially harmful input
    When the search is processed
    Then the system:
      | Sanitizes input                     |
      | Prevents injection attacks          |
      | Returns safe error if invalid       |
      | Logs security event                 |
    And user experience is not disrupted
    And security is maintained
