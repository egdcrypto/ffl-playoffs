@players @anima-1363
Feature: Players
  As a fantasy football manager
  I want to research and analyze players
  So that I can make informed decisions about my roster and lineup

  Background:
    Given I am a logged-in user
    And the fantasy platform is available
    And player data is loaded

  # ============================================================================
  # PLAYER PROFILES
  # ============================================================================

  @happy-path @player-profiles
  Scenario: View player bio
    Given I am on a player profile page
    Then I should see the player's biography
    And I should see background information

  @happy-path @player-profiles
  Scenario: View player photo
    Given I am on a player profile page
    Then I should see the player's headshot photo
    And the photo should be high quality

  @happy-path @player-profiles
  Scenario: View player team information
    Given I am on a player profile page
    Then I should see the player's current NFL team
    And I should see team logo and colors

  @happy-path @player-profiles
  Scenario: View player position
    Given I am on a player profile page
    Then I should see the player's position
    And fantasy-eligible positions should be listed

  @happy-path @player-profiles
  Scenario: View player jersey number
    Given I am on a player profile page
    Then I should see the player's jersey number
    And uniform information should be displayed

  @happy-path @player-profiles
  Scenario: View player physical stats
    Given I am on a player profile page
    Then I should see height and weight
    And I should see age and birthdate

  @happy-path @player-profiles
  Scenario: View player draft information
    Given I am on a player profile page
    Then I should see NFL draft year and round
    And I should see draft pick number and team

  @happy-path @player-profiles
  Scenario: View player college information
    Given I am on a player profile page
    Then I should see college attended
    And college statistics may be available

  @mobile @player-profiles
  Scenario: View player profile on mobile
    Given I am on a mobile device
    When I view a player profile
    Then the profile should be mobile-optimized
    And all information should be accessible

  @error @player-profiles
  Scenario: Handle missing player profile
    Given I search for a non-existent player
    Then I should see a not found message
    And I should be prompted to try another search

  # ============================================================================
  # PLAYER STATISTICS
  # ============================================================================

  @happy-path @player-statistics
  Scenario: View season statistics
    Given I am on a player profile page
    When I view season stats
    Then I should see current season statistics
    And stats should be position-appropriate

  @happy-path @player-statistics
  Scenario: View career statistics
    Given I am on a player profile page
    When I view career stats
    Then I should see career totals
    And year-by-year breakdown should be available

  @happy-path @player-statistics
  Scenario: View game logs
    Given I am on a player profile page
    When I view game logs
    Then I should see game-by-game statistics
    And game logs should show opponent and result

  @happy-path @player-statistics
  Scenario: View advanced metrics
    Given I am on a player profile page
    When I view advanced metrics
    Then I should see efficiency metrics
    And advanced analytics should be displayed

  @happy-path @player-statistics
  Scenario: View statistical splits
    Given I am on a player profile page
    When I view statistical splits
    Then I should see home vs away splits
    And I should see splits by opponent type

  @happy-path @player-statistics
  Scenario: View fantasy points history
    Given I am on a player profile page
    When I view fantasy stats
    Then I should see fantasy points by week
    And scoring format options should be available

  @happy-path @player-statistics
  Scenario: View red zone statistics
    Given I am on a player profile page
    When I view red zone stats
    Then I should see red zone opportunities
    And red zone efficiency should be shown

  @happy-path @player-statistics
  Scenario: Export player statistics
    Given I am on a player profile page
    When I export statistics
    Then I should receive a downloadable file
    And all stats should be included

  # ============================================================================
  # PLAYER SEARCH
  # ============================================================================

  @happy-path @player-search
  Scenario: Search player by name
    Given I am on the player search page
    When I enter a player name
    Then I should see matching players
    And results should update as I type

  @happy-path @player-search
  Scenario: Filter players by team
    Given I am on the player search page
    When I filter by NFL team
    Then I should see only players from that team
    And team filter should be clearable

  @happy-path @player-search
  Scenario: Filter players by position
    Given I am on the player search page
    When I filter by position
    Then I should see only players at that position
    And multiple positions can be selected

  @happy-path @player-search
  Scenario: Filter by availability
    Given I am on the player search page
    When I filter by availability
    Then I should see only available free agents
    And rostered players should be hidden

  @happy-path @player-search
  Scenario: Search with multiple filters
    Given I am on the player search page
    When I apply multiple filters
    Then results should match all criteria
    And filter combination should work correctly

  @happy-path @player-search
  Scenario: Sort search results
    Given I have search results
    When I sort by a statistic
    Then results should reorder accordingly
    And sort direction should be toggleable

  @happy-path @player-search
  Scenario: View search result details
    Given I have search results
    When I hover over a player
    Then I should see quick stats preview
    And I should be able to click for full profile

  @mobile @player-search
  Scenario: Search players on mobile
    Given I am on a mobile device
    When I search for players
    Then search should work on mobile
    And filters should be accessible

  @error @player-search
  Scenario: Handle no search results
    Given I search with no matching results
    Then I should see a no results message
    And I should be prompted to adjust filters

  # ============================================================================
  # PLAYER COMPARISON
  # ============================================================================

  @happy-path @player-comparison
  Scenario: Compare two players head-to-head
    Given I select two players to compare
    When I view the comparison
    Then I should see side-by-side statistics
    And advantages should be highlighted

  @happy-path @player-comparison
  Scenario: Compare multiple players
    Given I select multiple players
    When I view multi-player comparison
    Then I should see all players compared
    And stats should be in a table format

  @happy-path @player-comparison
  Scenario: Compare specific statistics
    Given I am comparing players
    When I select specific stats to compare
    Then only those stats should be displayed
    And comparisons should be focused

  @happy-path @player-comparison
  Scenario: Compare player trends
    Given I am comparing players
    When I view trend comparison
    Then I should see performance trends
    And trend lines should be visible

  @happy-path @player-comparison
  Scenario: Compare fantasy point averages
    Given I am comparing players
    Then I should see average fantasy points
    And scoring format should be selectable

  @happy-path @player-comparison
  Scenario: Compare players by schedule
    Given I am comparing players
    When I view schedule comparison
    Then I should see upcoming matchup difficulty
    And rest-of-season outlook should be compared

  @happy-path @player-comparison
  Scenario: Save comparison for later
    Given I have created a comparison
    When I save the comparison
    Then the comparison should be stored
    And I can access it later

  @mobile @player-comparison
  Scenario: Compare players on mobile
    Given I am on a mobile device
    When I compare players
    Then comparison should be mobile-friendly
    And I should be able to swipe between players

  # ============================================================================
  # PLAYER PROJECTIONS
  # ============================================================================

  @happy-path @player-projections
  Scenario: View weekly projections
    Given I am on a player profile page
    When I view weekly projections
    Then I should see projected points for the week
    And projection sources should be shown

  @happy-path @player-projections
  Scenario: View season projections
    Given I am on a player profile page
    When I view season projections
    Then I should see full season projected stats
    And projection methodology should be explained

  @happy-path @player-projections
  Scenario: View rest-of-season projections
    Given I am on a player profile page
    When I view ROS projections
    Then I should see remaining game projections
    And projections should factor in schedule

  @happy-path @player-projections
  Scenario: View playoff projections
    Given playoffs are approaching
    When I view playoff projections
    Then I should see playoff week projections
    And playoff matchup difficulty should factor in

  @happy-path @player-projections
  Scenario: Compare projections across sources
    Given I am viewing projections
    When I compare projection sources
    Then I should see projections from multiple experts
    And consensus projection should be shown

  @happy-path @player-projections
  Scenario: View projection confidence level
    Given I am viewing projections
    Then I should see confidence indicators
    And uncertainty ranges should be displayed

  @happy-path @player-projections
  Scenario: View projection factors
    Given I am viewing projections
    When I view projection breakdown
    Then I should see factors affecting projection
    And matchup impact should be shown

  @happy-path @player-projections
  Scenario: Track projection accuracy
    Given projections have been made
    When I view projection accuracy
    Then I should see how accurate past projections were
    And source accuracy should be compared

  # ============================================================================
  # PLAYER NEWS
  # ============================================================================

  @happy-path @player-news
  Scenario: View injury updates
    Given a player has an injury
    When I view player news
    Then I should see injury reports
    And injury status should be current

  @happy-path @player-news
  Scenario: View team news affecting player
    Given I am viewing player news
    Then I should see relevant team news
    And news should impact fantasy value

  @happy-path @player-news
  Scenario: View beat reporter tweets
    Given I am viewing player news
    Then I should see beat reporter updates
    And tweets should be from verified sources

  @happy-path @player-news
  Scenario: View fantasy analysis
    Given I am viewing player news
    Then I should see fantasy analysis articles
    And analysis should be from trusted sources

  @happy-path @player-news
  Scenario: Filter news by type
    Given I am viewing player news
    When I filter by news type
    Then I should see only that type of news
    And filters should be clearable

  @happy-path @player-news
  Scenario: View news timeline
    Given I am viewing player news
    When I view news timeline
    Then news should be chronologically ordered
    And I should be able to scroll through history

  @happy-path @player-news
  Scenario: Set up news alerts
    Given I am viewing a player
    When I set up news alerts
    Then I should receive notifications for news
    And alert preferences should be saved

  @mobile @player-news
  Scenario: View player news on mobile
    Given I am on a mobile device
    When I view player news
    Then news should be mobile-optimized
    And I should be able to share news

  # ============================================================================
  # PLAYER OWNERSHIP
  # ============================================================================

  @happy-path @player-ownership
  Scenario: View ownership percentage
    Given I am viewing a player
    Then I should see overall ownership percentage
    And ownership should be across all leagues

  @happy-path @player-ownership
  Scenario: View add/drop trends
    Given I am viewing player ownership
    When I view add/drop trends
    Then I should see recent transaction activity
    And trends should show direction

  @happy-path @player-ownership
  Scenario: View roster percentage
    Given I am viewing player ownership
    Then I should see percentage of teams rostering
    And roster percentage should be by format

  @happy-path @player-ownership
  Scenario: View start percentage
    Given I am viewing player ownership
    Then I should see percentage of teams starting
    And start percentage should indicate confidence

  @happy-path @player-ownership
  Scenario: View ownership by league type
    Given I am viewing player ownership
    When I filter by league type
    Then I should see ownership for that format
    And dynasty vs redraft should differ

  @happy-path @player-ownership
  Scenario: View ownership trends over time
    Given I am viewing player ownership
    When I view ownership history
    Then I should see how ownership has changed
    And trend chart should be displayed

  @happy-path @player-ownership
  Scenario: Compare ownership to value
    Given I am viewing player ownership
    Then I should see ownership vs projected value
    And underowned players should be highlighted

  # ============================================================================
  # PLAYER PERFORMANCE
  # ============================================================================

  @happy-path @player-performance
  Scenario: View weekly performance
    Given I am on a player profile page
    When I view weekly performance
    Then I should see performance by week
    And performance should include fantasy points

  @happy-path @player-performance
  Scenario: View consistency score
    Given I am viewing player performance
    Then I should see consistency rating
    And consistency should measure variance

  @happy-path @player-performance
  Scenario: View boom/bust rate
    Given I am viewing player performance
    Then I should see boom and bust percentages
    And thresholds should be defined

  @happy-path @player-performance
  Scenario: View floor and ceiling
    Given I am viewing player performance
    Then I should see projected floor and ceiling
    And range should be based on history

  @happy-path @player-performance
  Scenario: View performance by matchup type
    Given I am viewing player performance
    When I filter by matchup difficulty
    Then I should see performance vs tough/easy matchups
    And matchup-proof players should be identified

  @happy-path @player-performance
  Scenario: View target share and usage
    Given I am viewing player performance
    Then I should see target share or usage rate
    And opportunity metrics should be shown

  @happy-path @player-performance
  Scenario: View performance trend
    Given I am viewing player performance
    When I view trend analysis
    Then I should see if player is trending up or down
    And recent performance should be weighted

  @happy-path @player-performance
  Scenario: Compare performance to ADP
    Given I am viewing player performance
    Then I should see performance vs draft position
    And value assessment should be made

  # ============================================================================
  # PLAYER HISTORY
  # ============================================================================

  @happy-path @player-history
  Scenario: View historical statistics
    Given I am on a player profile page
    When I view historical stats
    Then I should see stats by year
    And all seasons should be available

  @happy-path @player-history
  Scenario: View career timeline
    Given I am viewing player history
    When I view career timeline
    Then I should see key career events
    And timeline should be visual

  @happy-path @player-history
  Scenario: View team history
    Given I am viewing player history
    When I view team history
    Then I should see all teams played for
    And tenure with each team should be shown

  @happy-path @player-history
  Scenario: View performance trends over career
    Given I am viewing player history
    When I view career trends
    Then I should see how performance has changed
    And age-related trends should be visible

  @happy-path @player-history
  Scenario: View historical rankings
    Given I am viewing player history
    Then I should see position rankings by year
    And ranking trajectory should be shown

  @happy-path @player-history
  Scenario: View injury history
    Given I am viewing player history
    When I view injury history
    Then I should see past injuries
    And games missed should be tracked

  @happy-path @player-history
  Scenario: View contract history
    Given I am viewing player history
    When I view contract info
    Then I should see contract details
    And free agency status should be shown

  # ============================================================================
  # PLAYER WATCHLIST
  # ============================================================================

  @happy-path @player-watchlist
  Scenario: Add player to watchlist
    Given I am viewing a player
    When I add them to my watchlist
    Then the player should be on my watchlist
    And I should see confirmation

  @happy-path @player-watchlist
  Scenario: View watchlist
    Given I have players on my watchlist
    When I view my watchlist
    Then I should see all watched players
    And key stats should be displayed

  @happy-path @player-watchlist
  Scenario: Receive watchlist alerts
    Given I have players on my watchlist
    When news or status changes occur
    Then I should receive alerts
    And alerts should be timely

  @happy-path @player-watchlist
  Scenario: Manage watchlist preferences
    Given I am managing my watchlist
    When I configure alert preferences
    Then I should set which alerts to receive
    And preferences should be saved

  @happy-path @player-watchlist
  Scenario: Remove player from watchlist
    Given I have a player on my watchlist
    When I remove them from the watchlist
    Then they should no longer be watched
    And alerts should stop

  @happy-path @player-watchlist
  Scenario: Perform bulk watchlist actions
    Given I have multiple players on watchlist
    When I select multiple players
    Then I should be able to perform bulk actions
    And bulk remove should be available

  @happy-path @player-watchlist
  Scenario: Organize watchlist into groups
    Given I have players on my watchlist
    When I create watchlist groups
    Then players should be categorized
    And groups should be manageable

  @happy-path @player-watchlist
  Scenario: Share watchlist
    Given I have a watchlist
    When I share my watchlist
    Then a shareable link should be created
    And others can view the watchlist

  @mobile @player-watchlist
  Scenario: Manage watchlist on mobile
    Given I am on a mobile device
    When I manage my watchlist
    Then watchlist should be mobile-friendly
    And swipe actions should work

  @error @player-watchlist
  Scenario: Handle watchlist limit exceeded
    Given my watchlist is at maximum capacity
    When I try to add another player
    Then I should see a limit error
    And I should be prompted to remove players
