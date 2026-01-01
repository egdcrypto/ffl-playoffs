@players
Feature: Players
  As a fantasy football user
  I want to access comprehensive player information
  So that I can make informed decisions about my roster

  # Player Search Scenarios
  @player-search
  Scenario: Search for player by name
    Given I am on the player search page
    When I search for a player by name
    Then matching players should display
    And results should be relevant
    And I should see player details in results

  @player-search
  Scenario: Filter players by position
    Given I am viewing player list
    When I filter by position
    Then only players at that position should show
    And filter should be clearly applied
    And I should see player count

  @player-search
  Scenario: Filter players by NFL team
    Given I am viewing player list
    When I filter by NFL team
    Then only players on that team should show
    And team filter should be visible
    And I should be able to clear filter

  @player-search
  Scenario: Use advanced search options
    Given I am on player search
    When I use advanced filters
    Then I should filter by multiple criteria
    And filters should combine correctly
    And results should match all filters

  @player-search
  Scenario: Search with partial name match
    Given I am searching for a player
    When I enter partial name
    Then autocomplete suggestions should appear
    And matching players should be found
    And search should be forgiving of typos

  @player-search
  Scenario: Sort search results
    Given I have search results
    When I sort by criteria
    Then results should reorder accordingly
    And sort direction should be toggleable
    And current sort should be indicated

  @player-search
  Scenario: View recently searched players
    Given I have searched for players before
    When I view recent searches
    Then recently searched players should show
    And I should be able to quickly access them
    And history should be clearable

  @player-search
  Scenario: Save search filters
    Given I have configured search filters
    When I save the filter set
    Then filters should be saved
    And I should be able to reapply them
    And saved filters should be manageable

  # Player Profiles Scenarios
  @player-profiles
  Scenario: View player bio
    Given I am viewing a player profile
    When I access the bio section
    Then I should see player name and photo
    And I should see position and team
    And I should see physical attributes

  @player-profiles
  Scenario: View career stats
    Given I am viewing a player profile
    When I access career stats
    Then I should see stats by season
    And I should see career totals
    And I should see key milestones

  @player-profiles
  Scenario: View current season stats
    Given I am viewing a player profile
    When I view current season
    Then I should see this season's stats
    And I should see game-by-game breakdown
    And I should see season averages

  @player-profiles
  Scenario: View injury history
    Given I am viewing a player profile
    When I access injury history
    Then I should see past injuries
    And I should see time missed
    And I should see current injury status

  @player-profiles
  Scenario: View player news feed
    Given I am viewing a player profile
    When I access the news feed
    Then I should see recent news
    And news should be sorted by date
    And I should see news sources

  @player-profiles
  Scenario: View player fantasy performance
    Given I am viewing a player profile
    When I access fantasy performance
    Then I should see fantasy points by week
    And I should see ranking among position
    And I should see scoring breakdown

  @player-profiles
  Scenario: View player contract details
    Given I am viewing a player profile
    When I access contract information
    Then I should see contract length
    And I should see salary details
    And I should see contract year

  @player-profiles
  Scenario: Share player profile
    Given I am viewing a player profile
    When I share the profile
    Then shareable link should be generated
    And profile preview should be included
    And sharing should work on social platforms

  # Player Stats Scenarios
  @player-stats
  Scenario: View weekly stats
    Given I am viewing player stats
    When I view weekly breakdown
    Then I should see stats for each week
    And weeks should be navigable
    And I should see game opponents

  @player-stats
  Scenario: View season totals
    Given I am viewing player stats
    When I view season totals
    Then I should see cumulative stats
    And I should see averages per game
    And I should see ranking in category

  @player-stats
  Scenario: View career stats
    Given I am viewing player stats
    When I view career stats
    Then I should see all seasons
    And I should see career totals
    And I should see career trajectory

  @player-stats
  Scenario: View stat categories
    Given I am viewing player stats
    When I explore stat categories
    Then I should see all relevant categories
    And categories should be organized
    And I should understand each stat

  @player-stats
  Scenario: Compare stats to league average
    Given I am viewing player stats
    When I compare to average
    Then I should see above or below average
    And comparison should be visual
    And percentile should be shown

  @player-stats
  Scenario: View advanced stats
    Given I am viewing player stats
    When I access advanced stats
    Then I should see efficiency metrics
    And I should see usage statistics
    And I should see advanced calculations

  @player-stats
  Scenario: Export player stats
    Given I am viewing player stats
    When I export stats
    Then export file should generate
    And stats should be comprehensive
    And format should be selectable

  @player-stats
  Scenario: View stats in different scoring formats
    Given I am viewing player stats
    When I change scoring format
    Then fantasy points should recalculate
    And I should see PPR vs standard
    And comparison should be clear

  # Player Projections Scenarios
  @player-projections
  Scenario: View weekly projections
    Given I am viewing player projections
    When I view weekly projection
    Then I should see projected points
    And I should see stat projections
    And I should see projection range

  @player-projections
  Scenario: View rest-of-season projections
    Given I am viewing player projections
    When I view ROS projections
    Then I should see projected totals
    And I should see remaining schedule impact
    And I should see projection confidence

  @player-projections
  Scenario: Compare projection sources
    Given multiple projection sources exist
    When I compare sources
    Then I should see different projections
    And I should see source names
    And I should see variance

  @player-projections
  Scenario: View projection accuracy
    Given projections have been made
    When I view accuracy
    Then I should see actual vs projected
    And I should see accuracy percentage
    And I should see trending accuracy

  @player-projections
  Scenario: View matchup-adjusted projections
    Given player has upcoming matchup
    When I view adjusted projections
    Then projection should factor in opponent
    And matchup difficulty should show
    And adjustment should be explained

  @player-projections
  Scenario: Set projection preferences
    Given I want to customize projections
    When I set preferences
    Then I should choose preferred source
    And I should set display options
    And preferences should save

  @player-projections
  Scenario: View projection trends
    Given player has historical projections
    When I view projection trends
    Then I should see projection changes
    And I should see trend direction
    And I should see triggering factors

  @player-projections
  Scenario: Get projection alerts
    Given I am watching a player
    When projection changes significantly
    Then I should receive alert
    And change should be explained
    And new projection should be shown

  # Player Rankings Scenarios
  @player-rankings
  Scenario: View expert rankings
    Given experts have ranked players
    When I view expert rankings
    Then I should see rankings by expert
    And I should see expert names
    And I should see ranking methodology

  @player-rankings
  Scenario: View consensus rankings
    Given multiple rankings exist
    When I view consensus
    Then I should see aggregated ranking
    And I should see ranking range
    And I should see agreement level

  @player-rankings
  Scenario: View position rankings
    Given I want position-specific rankings
    When I view position rankings
    Then I should see ranks within position
    And I should see tier breaks
    And I should compare to other positions

  @player-rankings
  Scenario: View dynasty rankings
    Given dynasty league context
    When I view dynasty rankings
    Then I should see long-term value
    And I should see age factors
    And I should see dynasty-specific tiers

  @player-rankings
  Scenario: View weekly rankings
    Given rankings update weekly
    When I view current week rankings
    Then I should see this week's ranks
    And I should see rank changes
    And I should see movement indicators

  @player-rankings
  Scenario: Compare rankings over time
    Given rankings have changed
    When I compare over time
    Then I should see ranking history
    And I should see trending direction
    And I should see key changes

  @player-rankings
  Scenario: Create custom rankings
    Given I want personalized rankings
    When I create custom rankings
    Then I should be able to rank players
    And rankings should save
    And I should be able to share

  @player-rankings
  Scenario: Filter rankings by criteria
    Given I am viewing rankings
    When I filter rankings
    Then I should filter by position or tier
    And filtered results should show
    And I should see count matching

  # Player News Scenarios
  @player-news
  Scenario: View injury updates
    Given player has injury news
    When I view injury updates
    Then I should see current status
    And I should see timeline
    And I should see impact analysis

  @player-news
  Scenario: View trade rumors
    Given trade rumors exist
    When I view trade news
    Then I should see rumor details
    And I should see sources
    And I should see potential impact

  @player-news
  Scenario: View depth chart changes
    Given depth chart has changed
    When I view depth chart news
    Then I should see new position
    And I should see players affected
    And I should see fantasy impact

  @player-news
  Scenario: View practice reports
    Given practice has occurred
    When I view practice reports
    Then I should see participation status
    And I should see injury designations
    And I should see game day outlook

  @player-news
  Scenario: Filter news by type
    Given various news exists
    When I filter news by type
    Then only selected type should show
    And filter should be clear
    And I should be able to change filter

  @player-news
  Scenario: Subscribe to player news
    Given I want news for specific player
    When I subscribe to news
    Then I should receive news alerts
    And alerts should be timely
    And I should be able to unsubscribe

  @player-news
  Scenario: View news timeline
    Given player has news history
    When I view news timeline
    Then I should see chronological news
    And I should navigate through time
    And key events should be highlighted

  @player-news
  Scenario: Share news article
    Given I am viewing news
    When I share the article
    Then share link should be generated
    And preview should be included
    And sharing should work properly

  # Player Availability Scenarios
  @player-availability
  Scenario: View ownership percentage
    Given player ownership varies
    When I view ownership
    Then I should see ownership percentage
    And I should see trend
    And I should see league-specific ownership

  @player-availability
  Scenario: View add/drop trends
    Given player activity exists
    When I view add/drop trends
    Then I should see recent adds
    And I should see recent drops
    And I should see net trend

  @player-availability
  Scenario: Check waiver wire status
    Given player may be on waivers
    When I check waiver status
    Then I should see if on waivers
    And I should see when clears
    And I should see claim count

  @player-availability
  Scenario: Check free agent status
    Given player may be free agent
    When I check availability
    Then I should see if free agent
    And I should see pickup options
    And I should see in my league status

  @player-availability
  Scenario: View availability across leagues
    Given I am in multiple leagues
    When I check availability
    Then I should see status per league
    And I should see where available
    And I should compare easily

  @player-availability
  Scenario: Set availability alerts
    Given I want to know when player available
    When I set availability alert
    Then I should receive alert when available
    And alert should be timely
    And I should be able to act quickly

  @player-availability
  Scenario: View trending players
    Given players have activity
    When I view trending
    Then I should see most added
    And I should see most dropped
    And I should see momentum

  @player-availability
  Scenario: View roster percentage by position
    Given players are rostered
    When I view by position
    Then I should see rostered percentage
    And I should compare within position
    And I should see sleepers

  # Player Watchlist Scenarios
  @player-watchlist
  Scenario: Add player to watchlist
    Given I want to track a player
    When I add to watchlist
    Then player should be on my watchlist
    And I should see confirmation
    And player should be easily accessible

  @player-watchlist
  Scenario: Receive watchlist alerts
    Given players are on my watchlist
    When significant news occurs
    Then I should receive alert
    And alert should identify player
    And I should see the news

  @player-watchlist
  Scenario: Manage watchlist
    Given I have players on watchlist
    When I manage watchlist
    Then I should see all watched players
    And I should be able to remove
    And I should be able to organize

  @player-watchlist
  Scenario: Share watchlist
    Given I have a curated watchlist
    When I share watchlist
    Then watchlist should be shareable
    And recipients should see players
    And I should control permissions

  @player-watchlist
  Scenario: Create multiple watchlists
    Given I want organized tracking
    When I create multiple lists
    Then I should create named lists
    And I should assign players to lists
    And I should manage lists separately

  @player-watchlist
  Scenario: View watchlist news feed
    Given I have players on watchlist
    When I view watchlist feed
    Then I should see news for all watched
    And news should be consolidated
    And I should see which player

  @player-watchlist
  Scenario: Set custom watchlist alerts
    Given I want specific alerts
    When I configure alert settings
    Then I should set alert types
    And I should set alert frequency
    And settings should save

  @player-watchlist
  Scenario: Import watchlist
    Given I have external watchlist
    When I import watchlist
    Then players should be added
    And import should be validated
    And duplicates should be handled

  # Player Comparison Scenarios
  @player-comparison
  Scenario: Compare players side-by-side
    Given I want to compare two players
    When I open comparison tool
    Then I should see both players
    And stats should align
    And differences should be clear

  @player-comparison
  Scenario: Compare player stats
    Given I am comparing players
    When I compare stats
    Then I should see stat-by-stat comparison
    And winner per category should show
    And totals should compare

  @player-comparison
  Scenario: Compare player schedules
    Given I am comparing players
    When I compare schedules
    Then I should see remaining matchups
    And I should see strength of schedule
    And I should see favorable matchups

  @player-comparison
  Scenario: Compare matchup performance
    Given I am comparing for specific matchup
    When I compare matchup factors
    Then I should see opponent analysis
    And I should see historical vs opponent
    And I should see recommendation

  @player-comparison
  Scenario: Add more players to comparison
    Given I am comparing two players
    When I add more players
    Then comparison should expand
    And I should compare multiple
    And layout should adjust

  @player-comparison
  Scenario: Save comparison
    Given I have a useful comparison
    When I save comparison
    Then comparison should save
    And I should access later
    And I should be able to share

  @player-comparison
  Scenario: Compare projections
    Given I am comparing players
    When I compare projections
    Then I should see projected points
    And I should see projection sources
    And I should see confidence

  @player-comparison
  Scenario: Compare dynasty value
    Given I am in dynasty context
    When I compare dynasty value
    Then I should see long-term value
    And I should see age and career stage
    And I should see trade value

  # Player Status Scenarios
  @player-status
  Scenario: View injury status
    Given player may be injured
    When I check injury status
    Then I should see current designation
    And I should see injury details
    And I should see expected return

  @player-status
  Scenario: View bye week
    Given player's team has bye
    When I check bye week
    Then I should see bye week number
    And I should see calendar date
    And I should see impact on lineup

  @player-status
  Scenario: Check game status
    Given game day is approaching
    When I check game status
    Then I should see game time
    And I should see if playing
    And I should see any concerns

  @player-status
  Scenario: View suspension status
    Given player may be suspended
    When I check suspension status
    Then I should see if suspended
    And I should see games remaining
    And I should see reinstatement date

  @player-status
  Scenario: Check roster status
    Given player's NFL roster may change
    When I check roster status
    Then I should see current NFL roster status
    And I should see if active
    And I should see recent changes

  @player-status
  Scenario: View all player statuses
    Given I have players on my roster
    When I view all statuses
    Then I should see status summary
    And I should see any concerns
    And I should see action items

  @player-status
  Scenario: Get status change notifications
    Given I want to track status changes
    When status changes
    Then I should receive notification
    And change should be explained
    And impact should be noted

  @player-status
  Scenario: View historical status
    Given player has status history
    When I view history
    Then I should see past statuses
    And I should see timeline
    And I should see patterns

  # Error Handling Scenarios
  @error-handling
  Scenario: Handle player not found
    Given I search for non-existent player
    When search completes
    Then I should see no results message
    And I should see suggestions
    And I should be able to search again

  @error-handling
  Scenario: Handle player data unavailable
    Given player data is missing
    When I view player
    Then I should see available data
    And missing data should be noted
    And functionality should continue

  @error-handling
  Scenario: Handle stats loading failure
    Given stats fail to load
    When failure occurs
    Then error should display
    And retry should be available
    And cached data may show

  @error-handling
  Scenario: Handle comparison limit exceeded
    Given I try to compare too many players
    When limit is exceeded
    Then I should see limit message
    And I should remove players to continue
    And maximum should be clear

  @error-handling
  Scenario: Handle news feed failure
    Given news feed fails to load
    When failure occurs
    Then error should display gracefully
    And other content should work
    And retry should be available

  @error-handling
  Scenario: Handle projection service down
    Given projection service is unavailable
    When I view projections
    Then I should see service status
    And cached projections may show
    And alternative should be suggested

  @error-handling
  Scenario: Handle watchlist sync failure
    Given watchlist fails to sync
    When sync fails
    Then local changes should preserve
    And retry should occur
    And user should be notified if persistent

  @error-handling
  Scenario: Handle search timeout
    Given search takes too long
    When timeout occurs
    Then I should see timeout message
    And I should be able to retry
    And partial results may show

  # Accessibility Scenarios
  @accessibility
  Scenario: Navigate player pages with keyboard
    Given I am viewing player pages
    When I navigate with keyboard
    Then all features should be accessible
    And focus should be visible
    And actions should be executable

  @accessibility
  Scenario: Screen reader announces player info
    Given I am using a screen reader
    When I view player information
    Then player name should be announced
    And stats should be readable
    And status should be communicated

  @accessibility
  Scenario: High contrast player display
    Given high contrast mode is enabled
    When I view player pages
    Then all text should be visible
    And stats should be readable
    And status indicators should be clear

  @accessibility
  Scenario: Player comparison is accessible
    Given I am using comparison tool
    When I compare with assistive technology
    Then comparisons should be navigable
    And differences should be announced
    And all data should be accessible

  @accessibility
  Scenario: Player search is accessible
    Given I am searching for players
    When I use search with assistive tech
    Then search should be accessible
    And results should be announced
    And selection should be possible

  @accessibility
  Scenario: Player charts have alternatives
    Given player charts are displayed
    When I access charts
    Then text alternatives should exist
    And data should be in tables
    And trends should be described

  @accessibility
  Scenario: Mobile player accessibility
    Given I am on mobile with accessibility
    When I view player information
    Then all features should work
    And touch targets should be adequate
    And zoom should function properly

  @accessibility
  Scenario: Player alerts are accessible
    Given player alerts are shown
    When alerts display
    Then alerts should be announced
    And content should be readable
    And actions should be accessible

  # Performance Scenarios
  @performance
  Scenario: Player search returns quickly
    Given I am searching for players
    When search executes
    Then results should appear within 1 second
    And autocomplete should be fast
    And no lag should be perceptible

  @performance
  Scenario: Player profile loads quickly
    Given I am viewing a player profile
    When page loads
    Then page should load within 2 seconds
    And content should appear progressively
    And no layout shifts should occur

  @performance
  Scenario: Player stats load efficiently
    Given I am viewing player stats
    When stats load
    Then stats should appear promptly
    And historical data should paginate
    And calculations should be fast

  @performance
  Scenario: Player comparison performs well
    Given I am comparing players
    When comparison loads
    Then comparison should be fast
    And adding players should be smooth
    And data should update quickly

  @performance
  Scenario: Player news loads efficiently
    Given I am viewing player news
    When news feed loads
    Then initial news should load quickly
    And infinite scroll should be smooth
    And images should optimize

  @performance
  Scenario: Watchlist syncs efficiently
    Given I have large watchlist
    When watchlist syncs
    Then sync should be fast
    And changes should propagate quickly
    And battery impact should be minimal

  @performance
  Scenario: Handle many search results
    Given search returns many results
    When results load
    Then results should virtualize
    And scrolling should be smooth
    And memory should be managed

  @performance
  Scenario: Mobile player performance
    Given I am on mobile device
    When I view player information
    Then performance should be acceptable
    And data usage should be efficient
    And loading should be optimized
