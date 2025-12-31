@search @ANIMA-1333
Feature: Search
  As a fantasy football application user
  I want powerful search functionality
  So that I can quickly find players, leagues, users, and information

  Background:
    Given the fantasy football playoffs application is running
    And I am logged in as a registered user

  # ============================================================================
  # GLOBAL SEARCH - HAPPY PATH
  # ============================================================================

  @happy-path @global-search
  Scenario: Access global search
    Given I am on any page
    When I access the global search
    Then the search interface should appear
    And I should see the search input
    And I should see search categories

  @happy-path @global-search
  Scenario: Perform global search
    Given I am using global search
    When I enter a search query
    Then I should see results from all categories
    And results should be grouped by type
    And I should see result counts

  @happy-path @global-search
  Scenario: View unified search results
    Given I performed a search
    When I view the results
    Then I should see players matching the query
    And I should see leagues matching the query
    And I should see users matching the query

  @happy-path @global-search
  Scenario: Use keyboard shortcut for search
    Given I am on any page
    When I press the search keyboard shortcut
    Then the search should open
    And the cursor should be in the input
    And I should start typing immediately

  @happy-path @global-search
  Scenario: Close search with escape key
    Given the search is open
    When I press the escape key
    Then the search should close
    And I should return to the previous view
    And my search should be preserved

  @happy-path @global-search
  Scenario: Navigate search results with keyboard
    Given I have search results
    When I use arrow keys to navigate
    Then I should move through results
    And the selected result should be highlighted
    And I should select with enter key

  # ============================================================================
  # PLAYER SEARCH
  # ============================================================================

  @happy-path @player-search
  Scenario: Search for player by name
    Given I want to find a player
    When I search for a player name
    Then I should see matching players
    And I should see player positions
    And I should see player teams

  @happy-path @player-search
  Scenario: Search player with partial name
    Given I don't know full name
    When I enter a partial name
    Then I should see partial matches
    And autocomplete should suggest players
    And I should find the player

  @happy-path @player-search
  Scenario: Search player by team
    Given I want players from a team
    When I search by NFL team
    Then I should see all players on that team
    And they should be organized by position
    And I should filter further

  @happy-path @player-search
  Scenario: Search player by position
    Given I want players at a position
    When I filter by position
    Then I should see only that position
    And I should sort by various criteria
    And I should find specific players

  @happy-path @player-search
  Scenario: View player search result details
    Given I see player in results
    When I hover over the result
    Then I should see quick info
    And I should see recent stats
    And I should see ownership percentage

  @happy-path @player-search
  Scenario: Add player from search results
    Given I found a player in search
    When I click add player
    Then I should be taken to add flow
    And the player should be pre-selected
    And I should complete the add

  # ============================================================================
  # LEAGUE SEARCH
  # ============================================================================

  @happy-path @league-search
  Scenario: Search for public leagues
    Given I want to find a league
    When I search for leagues
    Then I should see matching public leagues
    And I should see league details
    And I should see open spots

  @happy-path @league-search
  Scenario: Search leagues by name
    Given I know a league name
    When I search for that name
    Then I should see matching leagues
    And exact matches should rank first
    And I should find the league

  @happy-path @league-search
  Scenario: Search leagues by format
    Given I want a specific format
    When I filter by league format
    Then I should see matching formats
    And I should filter by PPR, standard, etc.
    And results should be relevant

  @happy-path @league-search
  Scenario: Search leagues by size
    Given I want a specific league size
    When I filter by team count
    Then I should see matching sizes
    And I should filter by 8, 10, 12 team, etc.
    And results should match

  @happy-path @league-search
  Scenario: Search leagues by buy-in
    Given I want leagues in a price range
    When I filter by buy-in amount
    Then I should see matching leagues
    And I should set min and max
    And free leagues should be findable

  @happy-path @league-search
  Scenario: Request to join from search
    Given I found a league
    When I request to join
    Then my request should be sent
    And I should see pending status
    And the commissioner should be notified

  # ============================================================================
  # USER SEARCH
  # ============================================================================

  @happy-path @user-search
  Scenario: Search for users
    Given I want to find a user
    When I search for a username
    Then I should see matching users
    And I should see their profiles
    And I should see mutual connections

  @happy-path @user-search
  Scenario: Search users by display name
    Given I know someone's display name
    When I search for that name
    Then I should see matching users
    And I should distinguish between users
    And I should find the person

  @happy-path @user-search
  Scenario: Search users in my leagues
    Given I want to find a leaguemate
    When I search within my leagues
    Then I should see league members
    And I should see which league they're in
    And I should contact them

  @happy-path @user-search
  Scenario: View user profile from search
    Given I found a user in search
    When I click on the result
    Then I should view their profile
    And I should see their public info
    And I should connect with them

  @happy-path @user-search
  Scenario: Send friend request from search
    Given I found a user
    When I send a friend request
    Then the request should be sent
    And they should be notified
    And I should see pending status

  # ============================================================================
  # TRANSACTION SEARCH
  # ============================================================================

  @happy-path @transaction-search
  Scenario: Search transaction history
    Given I want to find a transaction
    When I search transactions
    Then I should see matching transactions
    And I should see transaction types
    And I should see dates

  @happy-path @transaction-search
  Scenario: Search transactions by player
    Given I want transactions for a player
    When I filter by player name
    Then I should see all that player's transactions
    And I should see adds, drops, trades
    And I should see who was involved

  @happy-path @transaction-search
  Scenario: Search transactions by type
    Given I want specific transaction type
    When I filter by type
    Then I should see only that type
    And I should filter trades, waivers, etc.
    And results should match

  @happy-path @transaction-search
  Scenario: Search transactions by date range
    Given I want transactions from a period
    When I set date range
    Then I should see transactions in range
    And I should adjust the range
    And results should be chronological

  @happy-path @transaction-search
  Scenario: Search my transactions
    Given I want my transaction history
    When I filter to my transactions
    Then I should see only my activity
    And I should see complete history
    And I should export if needed

  # ============================================================================
  # SEARCH FILTERS
  # ============================================================================

  @happy-path @search-filters
  Scenario: Apply search filters
    Given I have search results
    When I apply filters
    Then results should be filtered
    And I should see filter indicators
    And I should clear filters easily

  @happy-path @search-filters
  Scenario: Combine multiple filters
    Given I want specific results
    When I apply multiple filters
    Then filters should combine
    And results should match all criteria
    And filter logic should be clear

  @happy-path @search-filters
  Scenario: Filter by availability
    Given I am searching players
    When I filter by availability
    Then I should see available players only
    And I should see rostered status
    And I should filter by league

  @happy-path @search-filters
  Scenario: Filter by fantasy stats
    Given I want players by performance
    When I filter by stat thresholds
    Then I should set minimum stats
    And results should meet criteria
    And I should filter by various stats

  @happy-path @search-filters
  Scenario: Save filter combination
    Given I created a useful filter set
    When I save the filters
    Then the combination should be saved
    And I should apply it later
    And I should name the filter set

  @happy-path @search-filters
  Scenario: Clear all filters
    Given I have multiple filters applied
    When I clear all filters
    Then all filters should reset
    And full results should return
    And I should start fresh

  # ============================================================================
  # SEARCH SUGGESTIONS
  # ============================================================================

  @happy-path @search-suggestions
  Scenario: View search suggestions while typing
    Given I am typing a search query
    When suggestions appear
    Then I should see relevant suggestions
    And they should update as I type
    And I should select a suggestion

  @happy-path @search-suggestions
  Scenario: See player suggestions
    Given I am searching
    When I start typing a player name
    Then player suggestions should appear
    And they should show player info
    And I should select directly

  @happy-path @search-suggestions
  Scenario: See trending searches
    Given I open search
    When I haven't typed yet
    Then I should see trending searches
    And they should be relevant
    And I should select any

  @happy-path @search-suggestions
  Scenario: See personalized suggestions
    Given I have search history
    When I start searching
    Then I should see personalized suggestions
    And they should reflect my activity
    And they should be relevant

  @happy-path @search-suggestions
  Scenario: Dismiss unwanted suggestion
    Given I see a suggestion I don't want
    When I dismiss the suggestion
    Then it should be removed
    And it should not appear again
    And my preferences should be saved

  # ============================================================================
  # RECENT SEARCHES
  # ============================================================================

  @happy-path @recent-searches
  Scenario: View recent searches
    Given I have searched before
    When I access search
    Then I should see recent searches
    And they should be in chronological order
    And I should search them again

  @happy-path @recent-searches
  Scenario: Click recent search to repeat
    Given I see a recent search
    When I click on it
    Then that search should execute
    And results should appear
    And it should move to top of recent

  @happy-path @recent-searches
  Scenario: Clear individual recent search
    Given I have recent searches
    When I remove one search
    Then that search should be removed
    And other recent searches should remain
    And the list should update

  @happy-path @recent-searches
  Scenario: Clear all recent searches
    Given I have many recent searches
    When I clear all
    Then all recent searches should be removed
    And the list should be empty
    And I should confirm the action

  @happy-path @recent-searches
  Scenario: Recent searches sync across devices
    Given I search on one device
    When I access search on another device
    Then recent searches should be synced
    And I should see same history
    And sync should be current

  # ============================================================================
  # SAVED SEARCHES
  # ============================================================================

  @happy-path @saved-searches
  Scenario: Save a search
    Given I performed a useful search
    When I save the search
    Then the search should be saved
    And I should name it
    And it should appear in saved searches

  @happy-path @saved-searches
  Scenario: View saved searches
    Given I have saved searches
    When I view saved searches
    Then I should see all saved
    And I should see search names
    And I should run any saved search

  @happy-path @saved-searches
  Scenario: Run saved search
    Given I have a saved search
    When I run it
    Then the search should execute
    And results should appear
    And filters should be applied

  @happy-path @saved-searches
  Scenario: Edit saved search
    Given I have a saved search
    When I edit it
    Then I should modify the criteria
    And I should update the name
    And changes should be saved

  @happy-path @saved-searches
  Scenario: Delete saved search
    Given I have a saved search
    When I delete it
    Then the search should be removed
    And it should not appear in list
    And deletion should be confirmed

  @happy-path @saved-searches
  Scenario: Set saved search alert
    Given I have a saved search
    When I enable alerts
    Then I should be notified of new results
    And I should set alert frequency
    And alerts should be delivered

  # ============================================================================
  # ADVANCED SEARCH OPTIONS
  # ============================================================================

  @happy-path @advanced-search
  Scenario: Access advanced search
    Given I need complex search
    When I access advanced search
    Then I should see advanced options
    And I should see more filter fields
    And I should build complex queries

  @happy-path @advanced-search
  Scenario: Use boolean operators
    Given I am in advanced search
    When I use AND, OR, NOT
    Then the search should respect operators
    And I should combine terms correctly
    And results should be accurate

  @happy-path @advanced-search
  Scenario: Search with exact phrase
    Given I want exact match
    When I use quotation marks
    Then I should get exact phrase matches
    And partial matches should be excluded
    And results should be precise

  @happy-path @advanced-search
  Scenario: Search with wildcards
    Given I need flexible matching
    When I use wildcard characters
    Then matches should include variations
    And wildcards should work correctly
    And results should expand

  @happy-path @advanced-search
  Scenario: Search with range values
    Given I want a range of values
    When I specify a range
    Then results should fall within range
    And I should set min and max
    And range should be accurate

  @happy-path @advanced-search
  Scenario: Search by specific field
    Given I want to search a specific field
    When I target a field
    Then only that field should be searched
    And results should be field-specific
    And I should combine fields

  # ============================================================================
  # SEARCH RESULTS RANKING
  # ============================================================================

  @happy-path @results-ranking
  Scenario: View relevance-ranked results
    Given I performed a search
    When I view results
    Then results should be ranked by relevance
    And most relevant should be first
    And ranking should make sense

  @happy-path @results-ranking
  Scenario: Sort results by different criteria
    Given I have search results
    When I change sort order
    Then I should sort by relevance
    And I should sort alphabetically
    And I should sort by date or stats

  @happy-path @results-ranking
  Scenario: Understand result ranking
    Given I see ranked results
    When I check ranking factors
    Then I should understand why ranked
    And relevance indicators should show
    And ranking should be transparent

  @happy-path @results-ranking
  Scenario: Boost specific result types
    Given I prefer certain results
    When I set preferences
    Then preferred types should rank higher
    And my preferences should persist
    And ranking should reflect preferences

  @happy-path @results-ranking
  Scenario: Personalized result ranking
    Given I have activity history
    When I search
    Then results should be personalized
    And my leagues and players should rank higher
    And personalization should be helpful

  # ============================================================================
  # SEARCH ANALYTICS
  # ============================================================================

  @happy-path @search-analytics
  Scenario: Track search usage
    Given I am using search
    When my searches are tracked
    Then popular searches should be identified
    And search patterns should be analyzed
    And search should improve

  @happy-path @search-analytics
  Scenario: View my search statistics
    Given I have search history
    When I view my statistics
    Then I should see search frequency
    And I should see common searches
    And I should see search patterns

  @happy-path @search-analytics
  Scenario: Provide search feedback
    Given I got search results
    When I provide feedback
    Then I should rate result quality
    And I should report missing results
    And feedback should improve search

  # ============================================================================
  # SEARCH CONTEXT
  # ============================================================================

  @happy-path @search-context
  Scenario: Search within current context
    Given I am in a specific league
    When I search
    Then search should be contextual
    And league-specific results should appear
    And I should expand beyond context

  @happy-path @search-context
  Scenario: Search from player page
    Given I am viewing a player
    When I search from that page
    Then related players should appear
    And comparison options should show
    And context should be maintained

  @happy-path @search-context
  Scenario: Search from draft room
    Given I am in draft room
    When I search for players
    Then available players should be prioritized
    And drafted players should be marked
    And search should be draft-aware

  # ============================================================================
  # ERROR HANDLING
  # ============================================================================

  @error
  Scenario: Search returns no results
    Given I search for something
    When no results are found
    Then I should see no results message
    And I should see suggestions
    And I should try different terms

  @error
  Scenario: Search fails to load
    Given I perform a search
    When the search fails
    Then I should see an error message
    And I should be able to retry
    And my query should be preserved

  @error
  Scenario: Search timeout
    Given I perform a complex search
    When the search times out
    Then I should see timeout message
    And I should simplify the query
    And I should retry

  @error
  Scenario: Invalid search query
    Given I enter an invalid query
    When validation fails
    Then I should see what's wrong
    And I should be guided to fix it
    And search should not execute

  # ============================================================================
  # MOBILE EXPERIENCE
  # ============================================================================

  @mobile
  Scenario: Use search on mobile
    Given I am using the mobile app
    When I access search
    Then search should be mobile-optimized
    And the keyboard should appear
    And results should be touch-friendly

  @mobile
  Scenario: Voice search on mobile
    Given I am on mobile
    When I use voice search
    Then my voice should be transcribed
    And the search should execute
    And results should appear

  @mobile
  Scenario: Filter results on mobile
    Given I have results on mobile
    When I apply filters
    Then filter interface should be mobile-friendly
    And I should select filters easily
    And filtering should work

  @mobile
  Scenario: View result details on mobile
    Given I see results on mobile
    When I tap a result
    Then I should see details
    And I should navigate easily
    And I should return to results

  # ============================================================================
  # ACCESSIBILITY
  # ============================================================================

  @accessibility
  Scenario: Navigate search with keyboard
    Given I am using keyboard navigation
    When I use search
    Then I should access search with keyboard
    And I should navigate results
    And I should select with keyboard

  @accessibility
  Scenario: Screen reader search access
    Given I am using a screen reader
    When I use search
    Then the input should be labeled
    And results should be announced
    And I should navigate results

  @accessibility
  Scenario: High contrast search display
    Given I have high contrast enabled
    When I use search
    Then the input should be visible
    And results should be readable
    And selection should be clear

  @accessibility
  Scenario: Search with reduced motion
    Given I have reduced motion enabled
    When I use search
    Then animations should be minimal
    And transitions should be simple
    And search should still work
