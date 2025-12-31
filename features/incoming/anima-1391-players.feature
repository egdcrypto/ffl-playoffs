@players @anima-1391
Feature: Players
  As a fantasy football user
  I want comprehensive player information and management tools
  So that I can research and track players effectively

  Background:
    Given I am a logged-in user
    And the player system is available

  # ============================================================================
  # PLAYER PROFILES
  # ============================================================================

  @happy-path @player-profiles
  Scenario: View player bio
    Given a player exists
    When I view player profile
    Then I should see player biography
    And personal details should be shown

  @happy-path @player-profiles
  Scenario: View career stats
    Given player has career history
    When I view career stats
    Then I should see career statistics
    And year-by-year breakdown should be shown

  @happy-path @player-profiles
  Scenario: View player photos
    Given player has photos
    When I view player profile
    Then I should see player photos
    And images should be high quality

  @happy-path @player-profiles
  Scenario: View team info
    Given player is on a team
    When I view team info
    Then I should see current team
    And team details should be shown

  @happy-path @player-profiles
  Scenario: View contract details
    Given player has contract info
    When I view contract details
    Then I should see contract terms
    And salary information should be shown

  @happy-path @player-profiles
  Scenario: View player position
    Given player has position
    When I view profile
    Then I should see player position
    And eligibility should be clear

  @happy-path @player-profiles
  Scenario: View player physical attributes
    Given player info exists
    When I view attributes
    Then I should see height and weight
    And age should be shown

  @happy-path @player-profiles
  Scenario: View player college info
    Given player attended college
    When I view college info
    Then I should see college name
    And draft info should be shown

  @happy-path @player-profiles
  Scenario: View player experience
    Given player has experience
    When I view profile
    Then I should see years in league
    And rookie status should be indicated

  @happy-path @player-profiles
  Scenario: View player social media
    Given player has social accounts
    When I view social links
    Then I should see social media links
    And accounts should be accessible

  # ============================================================================
  # PLAYER SEARCH
  # ============================================================================

  @happy-path @player-search
  Scenario: Search players by name
    Given players exist
    When I search by name
    Then I should see matching players
    And results should be relevant

  @happy-path @player-search
  Scenario: Filter by position
    Given I want specific position
    When I filter by position
    Then I should see position-filtered results
    And only that position should show

  @happy-path @player-search
  Scenario: Filter by team
    Given I want specific team
    When I filter by team
    Then I should see team-filtered results
    And only that team should show

  @happy-path @player-search
  Scenario: Filter by availability
    Given I want available players
    When I filter by availability
    Then I should see available players
    And owned players should be excluded

  @happy-path @player-search
  Scenario: Use advanced filters
    Given I need specific criteria
    When I use advanced filters
    Then I should see filtered results
    And all criteria should match

  @happy-path @player-search
  Scenario: Sort search results
    Given search results exist
    When I sort results
    Then results should be reordered
    And sort order should be applied

  @happy-path @player-search
  Scenario: Save search filters
    Given I have filters set
    When I save filters
    Then filters should be saved
    And I can reuse later

  @happy-path @player-search
  Scenario: Clear search filters
    Given filters are applied
    When I clear filters
    Then all filters should reset
    And full results should show

  @happy-path @player-search
  Scenario: Search with autocomplete
    Given I start typing
    When autocomplete appears
    Then I should see suggestions
    And I can select a player

  @happy-path @player-search
  Scenario: View recent searches
    Given I have searched before
    When I view recent searches
    Then I should see search history
    And I can repeat searches

  # ============================================================================
  # PLAYER STATS
  # ============================================================================

  @happy-path @player-stats
  Scenario: View season stats
    Given player has played games
    When I view season stats
    Then I should see current season stats
    And all categories should be shown

  @happy-path @player-stats
  Scenario: View weekly stats
    Given player has weekly data
    When I view weekly stats
    Then I should see week-by-week stats
    And all weeks should be listed

  @happy-path @player-stats
  Scenario: View career stats
    Given player has career history
    When I view career stats
    Then I should see career totals
    And season breakdown should be available

  @happy-path @player-stats
  Scenario: View game logs
    Given player has game history
    When I view game logs
    Then I should see game-by-game stats
    And opponents should be shown

  @happy-path @player-stats
  Scenario: View stat comparisons
    Given comparison data exists
    When I compare stats
    Then I should see comparison
    And differences should be highlighted

  @happy-path @player-stats
  Scenario: View fantasy points
    Given fantasy scoring exists
    When I view fantasy points
    Then I should see total points
    And scoring breakdown should be shown

  @happy-path @player-stats
  Scenario: View stat trends
    Given trends are tracked
    When I view trends
    Then I should see stat trends
    And trajectory should be visible

  @happy-path @player-stats
  Scenario: View advanced stats
    Given advanced metrics exist
    When I view advanced stats
    Then I should see advanced metrics
    And explanations should be available

  @happy-path @player-stats
  Scenario: Export player stats
    Given stats are displayed
    When I export stats
    Then I should receive export file
    And data should be complete

  @happy-path @player-stats
  Scenario: View stats by opponent
    Given opponent data exists
    When I view by opponent
    Then I should see opponent splits
    And matchup history should be shown

  # ============================================================================
  # PLAYER NEWS
  # ============================================================================

  @happy-path @player-news
  Scenario: View player updates
    Given news exists for player
    When I view updates
    Then I should see recent news
    And updates should be timely

  @happy-path @player-news
  Scenario: View injury reports
    Given player has injury info
    When I view injury reports
    Then I should see injury status
    And recovery timeline should be shown

  @happy-path @player-news
  Scenario: View practice reports
    Given practice data exists
    When I view practice reports
    Then I should see practice status
    And participation should be noted

  @happy-path @player-news
  Scenario: View trade rumors
    Given rumors exist
    When I view trade rumors
    Then I should see trade speculation
    And sources should be cited

  @happy-path @player-news
  Scenario: View breaking news
    Given breaking news exists
    When I view breaking news
    Then I should see urgent updates
    And timing should be shown

  @happy-path @player-news
  Scenario: Subscribe to player news
    Given I want updates
    When I subscribe to news
    Then I should receive notifications
    And updates should be timely

  @happy-path @player-news
  Scenario: Filter news by type
    Given news exists
    When I filter by type
    Then I should see filtered news
    And only selected type should show

  @happy-path @player-news
  Scenario: View news sources
    Given news has sources
    When I view sources
    Then I should see source information
    And credibility should be indicated

  @happy-path @player-news
  Scenario: Share player news
    Given news is available
    When I share news
    Then shareable link should be created
    And others can view

  @happy-path @player-news
  Scenario: View news history
    Given news history exists
    When I view history
    Then I should see past news
    And timeline should be clear

  # ============================================================================
  # PLAYER OWNERSHIP
  # ============================================================================

  @happy-path @player-ownership
  Scenario: View ownership percentage
    Given ownership is tracked
    When I view ownership
    Then I should see ownership percentage
    And league context should be shown

  @happy-path @player-ownership
  Scenario: View add/drop trends
    Given trends are tracked
    When I view trends
    Then I should see add/drop activity
    And direction should be clear

  @happy-path @player-ownership
  Scenario: View roster trends
    Given roster data exists
    When I view roster trends
    Then I should see rostering patterns
    And changes should be highlighted

  @happy-path @player-ownership
  Scenario: View start percentage
    Given start data exists
    When I view start percentage
    Then I should see how often started
    And comparison should be available

  @happy-path @player-ownership
  Scenario: View league ownership
    Given league data exists
    When I view league ownership
    Then I should see who owns player
    And availability should be clear

  @happy-path @player-ownership
  Scenario: Compare ownership across leagues
    Given multiple leagues exist
    When I compare ownership
    Then I should see cross-league data
    And patterns should be visible

  @happy-path @player-ownership
  Scenario: View ownership history
    Given history is tracked
    When I view history
    Then I should see ownership over time
    And trends should be visible

  @happy-path @player-ownership
  Scenario: View most added players
    Given add data exists
    When I view most added
    Then I should see top adds
    And rankings should be shown

  @happy-path @player-ownership
  Scenario: View most dropped players
    Given drop data exists
    When I view most dropped
    Then I should see top drops
    And reasons should be implied

  @happy-path @player-ownership
  Scenario: View ownership alerts
    Given thresholds are set
    When ownership changes significantly
    Then I should receive alert
    And I can take action

  # ============================================================================
  # PLAYER VALUES
  # ============================================================================

  @happy-path @player-values
  Scenario: View trade values
    Given trade values exist
    When I view trade value
    Then I should see player value
    And comparison should be available

  @happy-path @player-values
  Scenario: View dynasty values
    Given dynasty values exist
    When I view dynasty value
    Then I should see long-term value
    And age factor should be shown

  @happy-path @player-values
  Scenario: View keeper values
    Given keeper values exist
    When I view keeper value
    Then I should see keeper worth
    And cost should be factored

  @happy-path @player-values
  Scenario: View auction values
    Given auction values exist
    When I view auction value
    Then I should see dollar value
    And budget context should be shown

  @happy-path @player-values
  Scenario: View value trends
    Given trends are tracked
    When I view value trends
    Then I should see value changes
    And trajectory should be clear

  @happy-path @player-values
  Scenario: Compare player values
    Given multiple players selected
    When I compare values
    Then I should see value comparison
    And differences should be highlighted

  @happy-path @player-values
  Scenario: View value rankings
    Given rankings exist
    When I view rankings
    Then I should see value rankings
    And position should be shown

  @happy-path @player-values
  Scenario: View value methodology
    Given methodology exists
    When I view methodology
    Then I should see how calculated
    And factors should be explained

  @happy-path @player-values
  Scenario: Track value changes
    Given I follow a player
    When value changes
    Then I should be notified
    And change should be shown

  @happy-path @player-values
  Scenario: Export player values
    Given values are displayed
    When I export values
    Then I should receive export file
    And data should be complete

  # ============================================================================
  # PLAYER COMPARISONS
  # ============================================================================

  @happy-path @player-comparisons
  Scenario: Compare players
    Given I select players to compare
    When I compare them
    Then I should see comparison
    And stats should be side-by-side

  @happy-path @player-comparisons
  Scenario: View side-by-side stats
    Given comparison is displayed
    When I view stats
    Then I should see both players' stats
    And differences should be highlighted

  @happy-path @player-comparisons
  Scenario: View historical comparisons
    Given history exists
    When I compare historically
    Then I should see past performance
    And trends should be visible

  @happy-path @player-comparisons
  Scenario: View matchup comparisons
    Given matchup context exists
    When I compare for matchup
    Then I should see matchup-specific data
    And advantages should be shown

  @happy-path @player-comparisons
  Scenario: View value comparisons
    Given values exist
    When I compare values
    Then I should see value comparison
    And worth should be clear

  @happy-path @player-comparisons
  Scenario: Add player to comparison
    Given comparison exists
    When I add another player
    Then player should be added
    And comparison should update

  @happy-path @player-comparisons
  Scenario: Remove player from comparison
    Given comparison exists
    When I remove a player
    Then player should be removed
    And comparison should update

  @happy-path @player-comparisons
  Scenario: Save comparison
    Given comparison is displayed
    When I save comparison
    Then comparison should be saved
    And I can access later

  @happy-path @player-comparisons
  Scenario: Share comparison
    Given comparison is displayed
    When I share comparison
    Then shareable link should be created
    And others can view

  @happy-path @player-comparisons
  Scenario: View comparison history
    Given I have compared before
    When I view history
    Then I should see past comparisons
    And I can reload them

  # ============================================================================
  # PLAYER FAVORITES
  # ============================================================================

  @happy-path @player-favorites
  Scenario: Add favorite player
    Given I like a player
    When I add to favorites
    Then player should be favorited
    And I can access quickly

  @happy-path @player-favorites
  Scenario: View watchlist
    Given I have a watchlist
    When I view watchlist
    Then I should see watched players
    And status should be shown

  @happy-path @player-favorites
  Scenario: Set player alerts
    Given I want notifications
    When I set alerts
    Then alerts should be configured
    And I will be notified

  @happy-path @player-favorites
  Scenario: Create custom list
    Given I want organization
    When I create custom list
    Then list should be created
    And I can add players

  @happy-path @player-favorites
  Scenario: Quick access favorites
    Given I have favorites
    When I access favorites
    Then I should see quick list
    And navigation should be fast

  @happy-path @player-favorites
  Scenario: Remove from favorites
    Given player is favorited
    When I remove from favorites
    Then player should be unfavorited
    And list should update

  @happy-path @player-favorites
  Scenario: Organize favorites
    Given I have multiple favorites
    When I organize them
    Then order should be saved
    And groups should work

  @happy-path @player-favorites
  Scenario: Import favorites
    Given I have external list
    When I import favorites
    Then players should be added
    And list should update

  @happy-path @player-favorites
  Scenario: Export favorites
    Given I have favorites
    When I export favorites
    Then I should receive export
    And data should be complete

  @happy-path @player-favorites
  Scenario: Share favorites list
    Given I have favorites
    When I share list
    Then shareable link should be created
    And others can view

  # ============================================================================
  # PLAYER NOTES
  # ============================================================================

  @happy-path @player-notes
  Scenario: Add personal notes
    Given I want to note something
    When I add personal note
    Then note should be saved
    And only I can see it

  @happy-path @player-notes
  Scenario: Add scouting notes
    Given I am scouting players
    When I add scouting note
    Then note should be saved
    And I can reference later

  @happy-path @player-notes
  Scenario: Add draft notes
    Given I am preparing for draft
    When I add draft note
    Then note should be saved
    And visible during draft

  @happy-path @player-notes
  Scenario: Add trade notes
    Given I am evaluating trades
    When I add trade note
    Then note should be saved
    And I can reference later

  @happy-path @player-notes
  Scenario: Share notes
    Given I have notes
    When I share notes
    Then notes should be shared
    And others can view

  @happy-path @player-notes
  Scenario: Edit notes
    Given notes exist
    When I edit notes
    Then changes should be saved
    And history should be kept

  @happy-path @player-notes
  Scenario: Delete notes
    Given notes exist
    When I delete notes
    Then notes should be removed
    And I should confirm first

  @happy-path @player-notes
  Scenario: Search notes
    Given I have many notes
    When I search notes
    Then I should find matching notes
    And results should be relevant

  @happy-path @player-notes
  Scenario: Tag notes
    Given I want organization
    When I tag notes
    Then tags should be applied
    And I can filter by tag

  @happy-path @player-notes
  Scenario: Export notes
    Given notes exist
    When I export notes
    Then I should receive export
    And data should be complete

  # ============================================================================
  # PLAYER AVAILABILITY
  # ============================================================================

  @happy-path @player-availability
  Scenario: View free agents
    Given free agents exist
    When I view free agents
    Then I should see available players
    And I can add to roster

  @happy-path @player-availability
  Scenario: View waiver players
    Given waivers exist
    When I view waivers
    Then I should see waiver players
    And claim options should be shown

  @happy-path @player-availability
  Scenario: View restricted players
    Given restrictions exist
    When I view restricted
    Then I should see restricted players
    And restriction reasons should be shown

  @happy-path @player-availability
  Scenario: View IR eligible players
    Given IR eligibility exists
    When I view IR eligible
    Then I should see eligible players
    And I can move to IR

  @happy-path @player-availability
  Scenario: View practice squad players
    Given practice squads exist
    When I view practice squad
    Then I should see PS players
    And promotion options should be shown

  @happy-path @player-availability
  Scenario: Filter by availability status
    Given status data exists
    When I filter by status
    Then I should see filtered results
    And status should match

  @happy-path @player-availability
  Scenario: Track availability changes
    Given I follow players
    When availability changes
    Then I should be notified
    And I can take action

  @happy-path @player-availability
  Scenario: View availability across leagues
    Given I have multiple leagues
    When I view cross-league availability
    Then I should see where available
    And league context should be clear

  @happy-path @player-availability
  Scenario: Set availability alerts
    Given I want notifications
    When I set alerts
    Then alerts should be configured
    And I will be notified

  @happy-path @player-availability
  Scenario: View availability history
    Given history is tracked
    When I view history
    Then I should see past availability
    And timeline should be clear

