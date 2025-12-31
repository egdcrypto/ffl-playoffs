@player-database @ANIMA-1335
Feature: Player Database
  As a fantasy football application user
  I want comprehensive player database functionality
  So that I can access player information, statistics, and make informed decisions

  Background:
    Given the fantasy football playoffs application is running
    And I am logged in as a registered user

  # ============================================================================
  # PLAYER PROFILES - HAPPY PATH
  # ============================================================================

  @happy-path @player-profiles
  Scenario: View player profile
    Given I want to learn about a player
    When I navigate to a player's profile
    Then I should see the player's basic information
    And I should see the player's photo
    And I should see the player's current team

  @happy-path @player-profiles
  Scenario: View player biographical information
    Given I am on a player's profile
    When I view biographical information
    Then I should see the player's height and weight
    And I should see the player's age and birthdate
    And I should see the player's college and draft info

  @happy-path @player-profiles
  Scenario: View player position and number
    Given I am viewing a player
    When I check their role
    Then I should see their primary position
    And I should see their jersey number
    And I should see any secondary positions

  @happy-path @player-profiles
  Scenario: View player contract information
    Given I am on a player's profile
    When I view contract details
    Then I should see contract length
    And I should see salary information
    And I should see contract year status

  @happy-path @player-profiles
  Scenario: View player experience level
    Given I am viewing a player
    When I check their experience
    Then I should see years in the league
    And I should see their draft position
    And I should see career milestones

  @happy-path @player-profiles
  Scenario: View player social media links
    Given I am on a player's profile
    When I look for social media
    Then I should see linked social accounts
    And I should access their official pages
    And links should open externally

  # ============================================================================
  # PLAYER STATISTICS
  # ============================================================================

  @happy-path @player-statistics
  Scenario: View current season statistics
    Given I am on a player's profile
    When I view their statistics
    Then I should see current season stats
    And stats should be position-appropriate
    And I should see fantasy points scored

  @happy-path @player-statistics
  Scenario: View career statistics
    Given I want historical performance
    When I view career statistics
    Then I should see career totals
    And I should see season-by-season breakdown
    And I should see career averages

  @happy-path @player-statistics
  Scenario: View game-by-game statistics
    Given I want detailed performance
    When I view game log
    Then I should see each game's stats
    And I should see opponent information
    And I should see fantasy points per game

  @happy-path @player-statistics
  Scenario: View quarterback statistics
    Given I am viewing a quarterback
    When I check their stats
    Then I should see passing yards and touchdowns
    And I should see completion percentage
    And I should see interceptions and rating

  @happy-path @player-statistics
  Scenario: View running back statistics
    Given I am viewing a running back
    When I check their stats
    Then I should see rushing yards and touchdowns
    And I should see carries and average
    And I should see receiving statistics

  @happy-path @player-statistics
  Scenario: View wide receiver statistics
    Given I am viewing a wide receiver
    When I check their stats
    Then I should see receptions and targets
    And I should see receiving yards and touchdowns
    And I should see yards per reception

  @happy-path @player-statistics
  Scenario: View tight end statistics
    Given I am viewing a tight end
    When I check their stats
    Then I should see receiving statistics
    And I should see red zone targets
    And I should see blocking grade if available

  @happy-path @player-statistics
  Scenario: View kicker statistics
    Given I am viewing a kicker
    When I check their stats
    Then I should see field goal percentage
    And I should see field goals by distance
    And I should see extra point percentage

  @happy-path @player-statistics
  Scenario: View defense/special teams statistics
    Given I am viewing a defense
    When I check their stats
    Then I should see points allowed
    And I should see turnovers forced
    And I should see sacks and touchdowns

  @happy-path @player-statistics
  Scenario: Compare statistics across seasons
    Given I am viewing statistics
    When I compare across seasons
    Then I should see year-over-year changes
    And trends should be visualized
    And I should identify improvement areas

  # ============================================================================
  # PLAYER NEWS
  # ============================================================================

  @happy-path @player-news
  Scenario: View player news feed
    Given I am on a player's profile
    When I view their news
    Then I should see recent news articles
    And articles should be chronologically ordered
    And I should see news sources

  @happy-path @player-news
  Scenario: View injury reports
    Given a player has injury news
    When I view their profile
    Then I should see injury status prominently
    And I should see injury details
    And I should see expected return timeline

  @happy-path @player-news
  Scenario: View practice reports
    Given practice reports are available
    When I check player status
    Then I should see practice participation
    And I should see designation status
    And reports should be current

  @happy-path @player-news
  Scenario: View transaction news
    Given a player was involved in transactions
    When I view their news
    Then I should see trade news
    And I should see waiver activity
    And I should see roster moves

  @happy-path @player-news
  Scenario: Subscribe to player news alerts
    Given I want updates on a player
    When I subscribe to alerts
    Then I should receive news notifications
    And I should customize alert types
    And I should unsubscribe anytime

  @happy-path @player-news
  Scenario: View expert analysis
    Given experts have analyzed a player
    When I view analysis
    Then I should see expert opinions
    And I should see start/sit recommendations
    And analysis should be current

  # ============================================================================
  # INJURY STATUS
  # ============================================================================

  @happy-path @injury-status
  Scenario: View current injury status
    Given a player is injured
    When I view their status
    Then I should see injury designation
    And I should see injury type
    And I should see practice status

  @happy-path @injury-status
  Scenario: View injury history
    Given I want injury background
    When I view injury history
    Then I should see past injuries
    And I should see games missed
    And I should see recovery timelines

  @happy-path @injury-status
  Scenario: View injury impact on fantasy value
    Given a player is injured
    When I assess fantasy impact
    Then I should see projected point reduction
    And I should see replacement options
    And I should see timeline projections

  @happy-path @injury-status
  Scenario: View injury designations explained
    Given I see an injury designation
    When I want clarification
    Then I should understand what Out means
    And I should understand Doubtful, Questionable
    And I should understand IR designation

  @happy-path @injury-status
  Scenario: Track injury recovery progress
    Given a player is recovering
    When I monitor their status
    Then I should see recovery updates
    And I should see practice participation
    And I should see return projections

  @happy-path @injury-status
  Scenario: View team injury report
    Given I want all team injuries
    When I view team injury report
    Then I should see all injured players
    And I should see their statuses
    And the report should be official

  # ============================================================================
  # DEPTH CHARTS
  # ============================================================================

  @happy-path @depth-charts
  Scenario: View team depth chart
    Given I want to see team hierarchy
    When I view the depth chart
    Then I should see starters at each position
    And I should see backups listed
    And I should see third string players

  @happy-path @depth-charts
  Scenario: View player's depth chart position
    Given I am viewing a player
    When I check their depth chart status
    Then I should see their current position
    And I should see who is ahead of them
    And I should see who is behind them

  @happy-path @depth-charts
  Scenario: Track depth chart changes
    Given depth charts are updated
    When changes occur
    Then I should see position changes
    And I should see date of changes
    And I should understand the impact

  @happy-path @depth-charts
  Scenario: View depth chart by position group
    Given I want specific position group
    When I filter by position
    Then I should see that position's depth
    And I should compare across teams
    And I should see opportunities

  @happy-path @depth-charts
  Scenario: Understand depth chart impact on fantasy
    Given I am evaluating a player
    When I consider depth chart position
    Then I should see snap count projections
    And I should see opportunity share
    And I should assess value accordingly

  # ============================================================================
  # PLAYER SEARCH
  # ============================================================================

  @happy-path @player-search
  Scenario: Search for player by name
    Given I want to find a player
    When I search by name
    Then I should see matching players
    And results should show key info
    And I should select a player

  @happy-path @player-search
  Scenario: Search with partial name
    Given I know part of a name
    When I enter partial search
    Then I should see matching suggestions
    And autocomplete should help
    And I should find the player

  @happy-path @player-search
  Scenario: Search by team
    Given I want players from a team
    When I search by NFL team
    Then I should see all team players
    And they should be organized by position
    And I should filter further

  @happy-path @player-search
  Scenario: Search by position
    Given I want players at a position
    When I search by position
    Then I should see all players at that position
    And I should sort by various criteria
    And I should find specific players

  @happy-path @player-search
  Scenario: Search free agents
    Given I want available players
    When I search free agents in my league
    Then I should see unrostered players
    And I should filter by position
    And I should add from results

  @happy-path @player-search
  Scenario: Search rookies
    Given I want first-year players
    When I filter for rookies
    Then I should see all rookies
    And I should see draft position
    And I should assess rookie value

  # ============================================================================
  # PLAYER FILTERS
  # ============================================================================

  @happy-path @player-filters
  Scenario: Filter by position
    Given I have a list of players
    When I filter by position
    Then only that position should show
    And I should select multiple positions
    And I should clear the filter

  @happy-path @player-filters
  Scenario: Filter by team
    Given I have player results
    When I filter by NFL team
    Then only team players should show
    And I should select multiple teams
    And I should see team logos

  @happy-path @player-filters
  Scenario: Filter by fantasy points
    Given I want high performers
    When I filter by point threshold
    Then I should see qualifying players
    And I should set min and max
    And results should match criteria

  @happy-path @player-filters
  Scenario: Filter by availability
    Given I am looking for players
    When I filter by roster status
    Then I should see available only
    And I should see rostered only
    And I should see all players

  @happy-path @player-filters
  Scenario: Filter by bye week
    Given I need bye week coverage
    When I filter by bye week
    Then I should exclude certain weeks
    And I should find available players
    And bye weeks should be clear

  @happy-path @player-filters
  Scenario: Combine multiple filters
    Given I have specific criteria
    When I apply multiple filters
    Then filters should combine logically
    And results should match all criteria
    And I should see active filters

  @happy-path @player-filters
  Scenario: Save filter preferences
    Given I created useful filters
    When I save the filter set
    Then the combination should be saved
    And I should reuse it later
    And I should name the filter

  # ============================================================================
  # PLAYER RANKINGS
  # ============================================================================

  @happy-path @player-rankings
  Scenario: View overall player rankings
    Given I want to see top players
    When I view overall rankings
    Then I should see ranked player list
    And rankings should be current
    And I should see ranking criteria

  @happy-path @player-rankings
  Scenario: View position rankings
    Given I want position-specific rankings
    When I view position rankings
    Then I should see ranked players by position
    And I should compare within position
    And I should see position rank

  @happy-path @player-rankings
  Scenario: View expert consensus rankings
    Given I want expert opinions
    When I view consensus rankings
    Then I should see aggregated rankings
    And I should see ranking spread
    And I should see expert sources

  @happy-path @player-rankings
  Scenario: View rest-of-season rankings
    Given I want future projections
    When I view ROS rankings
    Then I should see projected rankings
    And rankings should factor schedule
    And I should see projection basis

  @happy-path @player-rankings
  Scenario: View dynasty rankings
    Given I play dynasty format
    When I view dynasty rankings
    Then I should see long-term value
    And age should factor in
    And I should see career trajectory

  @happy-path @player-rankings
  Scenario: View PPR vs standard rankings
    Given I need format-specific rankings
    When I select my scoring format
    Then rankings should adjust
    And reception-heavy players should shift
    And I should see format impact

  @happy-path @player-rankings
  Scenario: Track ranking changes
    Given I am monitoring players
    When rankings update
    Then I should see movement indicators
    And I should see trend direction
    And I should understand why changes occurred

  # ============================================================================
  # PLAYER PHOTOS
  # ============================================================================

  @happy-path @player-photos
  Scenario: View player headshot
    Given I am viewing a player
    When I see their profile
    Then I should see official headshot
    And the photo should be high quality
    And I should see team uniform

  @happy-path @player-photos
  Scenario: View player action photos
    Given I want game photos
    When I view player gallery
    Then I should see action shots
    And photos should be recent
    And I should browse the gallery

  @happy-path @player-photos
  Scenario: View player in search results
    Given I am searching players
    When results appear
    Then I should see player thumbnails
    And photos should help identify players
    And photos should load quickly

  @happy-path @player-photos
  Scenario: Handle missing player photo
    Given a player has no photo
    When I view their profile
    Then I should see a placeholder image
    And the placeholder should be appropriate
    And other info should still display

  # ============================================================================
  # HISTORICAL DATA
  # ============================================================================

  @happy-path @historical-data
  Scenario: View historical season data
    Given I want past performance
    When I view historical seasons
    Then I should see previous years' stats
    And I should select specific seasons
    And data should be complete

  @happy-path @historical-data
  Scenario: View historical matchup data
    Given I want past matchup performance
    When I view vs specific opponent
    Then I should see historical performance
    And I should see trends vs that team
    And I should assess matchup history

  @happy-path @historical-data
  Scenario: View historical fantasy finishes
    Given I want past fantasy rankings
    When I view historical finishes
    Then I should see end-of-season ranks
    And I should see year-over-year comparison
    And I should identify consistency

  @happy-path @historical-data
  Scenario: View career milestones
    Given I want career achievements
    When I view milestones
    Then I should see career records
    And I should see notable games
    And I should see awards and honors

  @happy-path @historical-data
  Scenario: View historical splits
    Given I want situational data
    When I view historical splits
    Then I should see home vs away
    And I should see indoor vs outdoor
    And I should see weather impacts

  # ============================================================================
  # PLAYER COMPARISONS
  # ============================================================================

  @happy-path @player-comparisons
  Scenario: Compare two players
    Given I want to compare players
    When I select two players
    Then I should see side-by-side stats
    And differences should be highlighted
    And I should identify the better option

  @happy-path @player-comparisons
  Scenario: Compare multiple players
    Given I want to compare several players
    When I add multiple players
    Then I should see multi-player comparison
    And I should sort by various metrics
    And I should remove players from comparison

  @happy-path @player-comparisons
  Scenario: Compare players by position
    Given I want position comparison
    When I compare within position
    Then comparisons should be meaningful
    And position-relevant stats should show
    And I should rank among peers

  @happy-path @player-comparisons
  Scenario: Compare schedule difficulty
    Given I want schedule comparison
    When I compare remaining schedules
    Then I should see strength of schedule
    And I should see matchup difficulty
    And I should factor schedule into decisions

  @happy-path @player-comparisons
  Scenario: Compare fantasy projections
    Given I want projected comparison
    When I compare projections
    Then I should see projected points
    And I should see projection ranges
    And I should see upside vs floor

  @happy-path @player-comparisons
  Scenario: Share player comparison
    Given I created a comparison
    When I share it
    Then I should generate a shareable link
    And others should view the comparison
    And sharing should be easy

  # ============================================================================
  # REAL-TIME DATA UPDATES
  # ============================================================================

  @happy-path @real-time-updates
  Scenario: Receive live stat updates
    Given games are in progress
    When stats are updated
    Then I should see real-time updates
    And stats should refresh automatically
    And I should see update timestamps

  @happy-path @real-time-updates
  Scenario: Receive live injury updates
    Given a player gets injured during game
    When the injury is reported
    Then I should see immediate update
    And injury status should change
    And I should receive notification if subscribed

  @happy-path @real-time-updates
  Scenario: Receive depth chart updates
    Given depth charts change
    When updates are published
    Then I should see changes quickly
    And I should understand the impact
    And fantasy values should adjust

  @happy-path @real-time-updates
  Scenario: Receive transaction updates
    Given player transactions occur
    When trades or moves happen
    Then I should see updates
    And team changes should reflect
    And news should be current

  @happy-path @real-time-updates
  Scenario: View data freshness indicator
    Given I am viewing player data
    When I check data currency
    Then I should see last update time
    And I should know data freshness
    And I should refresh manually if needed

  @happy-path @real-time-updates
  Scenario: Handle data sync during connection loss
    Given I lose internet connection
    When I reconnect
    Then data should sync automatically
    And I should see any missed updates
    And state should be current

  # ============================================================================
  # PLAYER PROJECTIONS
  # ============================================================================

  @happy-path @player-projections
  Scenario: View weekly projections
    Given I want this week's expectations
    When I view weekly projections
    Then I should see projected points
    And projections should factor matchup
    And I should see projection sources

  @happy-path @player-projections
  Scenario: View season projections
    Given I want full season outlook
    When I view season projections
    Then I should see total projected points
    And projections should factor schedule
    And I should see projection methodology

  @happy-path @player-projections
  Scenario: View projection ranges
    Given I want projection confidence
    When I view projection details
    Then I should see floor projections
    And I should see ceiling projections
    And I should see median expectations

  @happy-path @player-projections
  Scenario: Compare projections to actual
    Given I want projection accuracy
    When I compare projections to results
    Then I should see variance
    And I should see accuracy trends
    And I should assess projection reliability

  @happy-path @player-projections
  Scenario: View matchup-adjusted projections
    Given matchups affect performance
    When I view adjusted projections
    Then projections should factor opponent
    And defensive rankings should impact
    And I should see matchup rating

  # ============================================================================
  # PLAYER OWNERSHIP
  # ============================================================================

  @happy-path @player-ownership
  Scenario: View ownership percentage
    Given I want to know player availability
    When I view ownership stats
    Then I should see roster percentage
    And I should see start percentage
    And I should see trend direction

  @happy-path @player-ownership
  Scenario: View ownership in my leagues
    Given I want league-specific ownership
    When I check my leagues
    Then I should see if player is rostered
    And I should see which team has them
    And I should see across all my leagues

  @happy-path @player-ownership
  Scenario: Track ownership trends
    Given I want to spot emerging players
    When I view ownership trends
    Then I should see rising ownership
    And I should see dropping ownership
    And I should identify breakout candidates

  @happy-path @player-ownership
  Scenario: View add/drop trends
    Given I want transaction activity
    When I view add/drop data
    Then I should see most added players
    And I should see most dropped players
    And I should see net adds

  # ============================================================================
  # ERROR HANDLING
  # ============================================================================

  @error
  Scenario: Player not found
    Given I search for a player
    When the player doesn't exist
    Then I should see not found message
    And I should see suggestions
    And I should try different search

  @error
  Scenario: Statistics unavailable
    Given I want player statistics
    When stats are not available
    Then I should see appropriate message
    And I should see available data
    And I should understand limitation

  @error
  Scenario: Real-time update failure
    Given I expect live updates
    When updates fail to load
    Then I should see error indicator
    And I should retry manually
    And cached data should display

  @error
  Scenario: Photo fails to load
    Given I am viewing a player
    When their photo fails to load
    Then I should see placeholder
    And other content should work
    And I should retry loading

  @error
  Scenario: Comparison limit exceeded
    Given I am comparing players
    When I try to add too many
    Then I should see limit message
    And I should remove a player first
    And the limit should be clear

  # ============================================================================
  # MOBILE EXPERIENCE
  # ============================================================================

  @mobile
  Scenario: View player profile on mobile
    Given I am using the mobile app
    When I view a player profile
    Then the profile should be mobile-optimized
    And I should scroll through sections
    And navigation should be easy

  @mobile
  Scenario: Compare players on mobile
    Given I am on mobile
    When I compare players
    Then comparison should work on mobile
    And I should swipe between players
    And data should be readable

  @mobile
  Scenario: Search players on mobile
    Given I am using mobile
    When I search for players
    Then search should be touch-friendly
    And keyboard should appear
    And results should be tappable

  @mobile
  Scenario: View statistics on mobile
    Given I am viewing stats on mobile
    When I check player stats
    Then tables should be scrollable
    And data should be readable
    And I should zoom if needed

  # ============================================================================
  # ACCESSIBILITY
  # ============================================================================

  @accessibility
  Scenario: Navigate player database with keyboard
    Given I am using keyboard navigation
    When I browse player database
    Then I should navigate with keyboard
    And I should access all features
    And focus should be visible

  @accessibility
  Scenario: Screen reader player profile access
    Given I am using a screen reader
    When I view a player profile
    Then all content should be announced
    And images should have alt text
    And structure should be clear

  @accessibility
  Scenario: High contrast player display
    Given I have high contrast enabled
    When I view player information
    Then content should be visible
    And charts should be accessible
    And text should be readable

  @accessibility
  Scenario: Player database with reduced motion
    Given I have reduced motion enabled
    When I use the player database
    Then animations should be minimal
    And updates should not animate excessively
    And functionality should work
