@search @anima-1370
Feature: Search
  As a fantasy football user
  I want to search for players, leagues, and other content
  So that I can quickly find the information I need

  Background:
    Given I am a logged-in user
    And the search system is available

  # ============================================================================
  # GLOBAL SEARCH
  # ============================================================================

  @happy-path @global-search
  Scenario: Use universal search bar
    Given I am on any page
    When I access the universal search bar
    Then I should be able to enter a search query
    And the search should be accessible from anywhere

  @happy-path @global-search
  Scenario: Search across entities
    Given I enter a search term
    When I search
    Then I should see results from players, leagues, and teams
    And results should be categorized

  @happy-path @global-search
  Scenario: View quick results
    Given I start typing a search query
    Then I should see quick results immediately
    And results should update as I type

  @happy-path @global-search
  Scenario: See search suggestions
    Given I am typing in the search bar
    Then I should see search suggestions
    And suggestions should be relevant to my input

  @happy-path @global-search
  Scenario: Use keyboard shortcuts for search
    Given I am using the application
    When I press the search keyboard shortcut
    Then the search bar should be focused
    And I should be ready to type

  @happy-path @global-search
  Scenario: Navigate search results with keyboard
    Given I have search results
    When I use arrow keys
    Then I should navigate through results
    And I should be able to select with Enter

  @mobile @global-search
  Scenario: Use global search on mobile
    Given I am on a mobile device
    When I access search
    Then the search should be mobile-optimized
    And keyboard should appear automatically

  @accessibility @global-search
  Scenario: Use search with screen reader
    Given I am using a screen reader
    When I perform a search
    Then search elements should be announced
    And results should be accessible

  # ============================================================================
  # PLAYER SEARCH
  # ============================================================================

  @happy-path @player-search
  Scenario: Search player by name
    Given I am searching for players
    When I enter a player name
    Then I should see matching players
    And results should show player details

  @happy-path @player-search
  Scenario: Filter players by position
    Given I am searching for players
    When I filter by position
    Then I should see only players at that position
    And the filter should be clearable

  @happy-path @player-search
  Scenario: Filter players by team
    Given I am searching for players
    When I filter by NFL team
    Then I should see only players from that team
    And I can select multiple teams

  @happy-path @player-search
  Scenario: Filter by availability
    Given I am searching for players
    When I filter by availability
    Then I should see only available free agents
    And rostered players should be hidden

  @happy-path @player-search
  Scenario: Search player by partial name
    Given I enter a partial player name
    Then I should see matching players
    And matches should include partial matches

  @happy-path @player-search
  Scenario: View player from search results
    Given I see player search results
    When I click on a player
    Then I should be taken to the player profile
    And I can return to search results

  @happy-path @player-search
  Scenario: Add player from search results
    Given I see an available player in results
    When I click add player
    Then I should be able to add them to my roster
    And the action should be quick

  @error @player-search
  Scenario: Handle no player results
    Given I search for a non-existent player
    Then I should see no results message
    And I should see suggestions

  # ============================================================================
  # LEAGUE SEARCH
  # ============================================================================

  @happy-path @league-search
  Scenario: Find leagues by name
    Given I am searching for leagues
    When I enter a league name
    Then I should see matching leagues
    And results should show league details

  @happy-path @league-search
  Scenario: Browse public leagues
    Given I am looking for public leagues
    When I browse public leagues
    Then I should see available public leagues
    And I should be able to filter them

  @happy-path @league-search
  Scenario: Use league discovery
    Given I want to join a league
    When I use league discovery
    Then I should see recommended leagues
    And leagues should match my preferences

  @happy-path @league-search
  Scenario: Join league by code
    Given I have a league invite code
    When I enter the code
    Then I should find the specific league
    And I should be able to join

  @happy-path @league-search
  Scenario: Filter leagues by type
    Given I am searching for leagues
    When I filter by league type
    Then I should see only that type of league
    And I can select multiple types

  @happy-path @league-search
  Scenario: Filter leagues by size
    Given I am searching for leagues
    When I filter by league size
    Then I should see leagues matching that size
    And size range should be configurable

  @happy-path @league-search
  Scenario: View league from search
    Given I see league search results
    When I click on a league
    Then I should see league details
    And I should see join options

  # ============================================================================
  # TEAM SEARCH
  # ============================================================================

  @happy-path @team-search
  Scenario: Search teams by name
    Given I am searching for teams
    When I enter a team name
    Then I should see matching teams
    And results should show team details

  @happy-path @team-search
  Scenario: Search by owner name
    Given I want to find an owner
    When I search by owner name
    Then I should see teams owned by that person
    And I should see their leagues

  @happy-path @team-search
  Scenario: Search within league
    Given I am in a league
    When I search for teams within the league
    Then I should see only teams in that league
    And search should be scoped

  @happy-path @team-search
  Scenario: Find league members
    Given I am looking for league members
    When I search league members
    Then I should see matching members
    And I should see their team info

  @happy-path @team-search
  Scenario: View team from search
    Given I see team search results
    When I click on a team
    Then I should be taken to the team page
    And I can return to search

  @happy-path @team-search
  Scenario: Message owner from search
    Given I find a team owner
    When I choose to message them
    Then I should be able to send a message
    And messaging should be quick

  # ============================================================================
  # SEARCH FILTERS
  # ============================================================================

  @happy-path @search-filters
  Scenario: Apply advanced filters
    Given I am searching
    When I apply advanced filters
    Then results should match all filters
    And filters should be visible

  @happy-path @search-filters
  Scenario: Use multi-select filters
    Given I am applying filters
    When I select multiple values
    Then results should match any selection
    And all selections should be shown

  @happy-path @search-filters
  Scenario: Use range filters
    Given I am filtering by a range
    When I set min and max values
    Then results should be within range
    And range should be adjustable

  @happy-path @search-filters
  Scenario: Save filter preset
    Given I configured filters
    When I save the filter preset
    Then filters should be saved
    And I can reuse them later

  @happy-path @search-filters
  Scenario: Load saved filters
    Given I have saved filter presets
    When I load a preset
    Then filters should be applied
    And search should update

  @happy-path @search-filters
  Scenario: Clear all filters
    Given I have active filters
    When I clear all filters
    Then all filters should be removed
    And results should update

  @happy-path @search-filters
  Scenario: View active filters
    Given I have filters applied
    Then I should see all active filters
    And I should be able to remove each one

  # ============================================================================
  # SEARCH RESULTS
  # ============================================================================

  @happy-path @search-results
  Scenario: View search results
    Given I performed a search
    Then I should see search results
    And results should be clearly displayed

  @happy-path @search-results
  Scenario: Sort search results
    Given I have search results
    When I change sort order
    Then results should be reordered
    And sort should persist

  @happy-path @search-results
  Scenario: Paginate through results
    Given I have many search results
    When I navigate pages
    Then I should see next page of results
    And pagination should work smoothly

  @happy-path @search-results
  Scenario: View grouped results
    Given I search across entities
    Then results should be grouped by type
    And I should see count per group

  @happy-path @search-results
  Scenario: Expand result groups
    Given I see grouped results
    When I expand a group
    Then I should see all results in that group
    And I can collapse it again

  @happy-path @search-results
  Scenario: See result count
    Given I performed a search
    Then I should see total result count
    And count should update with filters

  @happy-path @search-results
  Scenario: Highlight search terms
    Given I see search results
    Then search terms should be highlighted
    And matches should be visible

  @mobile @search-results
  Scenario: View results on mobile
    Given I am on a mobile device
    When I view search results
    Then results should be mobile-friendly
    And I should be able to scroll easily

  # ============================================================================
  # SEARCH HISTORY
  # ============================================================================

  @happy-path @search-history
  Scenario: View recent searches
    Given I have searched before
    When I access search
    Then I should see recent searches
    And I can click to search again

  @happy-path @search-history
  Scenario: Get suggestions from history
    Given I start typing
    Then I should see suggestions from my history
    And history should be prioritized

  @happy-path @search-history
  Scenario: Clear search history
    Given I have search history
    When I clear my history
    Then history should be deleted
    And I should see confirmation

  @happy-path @search-history
  Scenario: See popular searches
    Given I access search
    Then I should see popular searches
    And popular searches should be trending

  @happy-path @search-history
  Scenario: Remove single search from history
    Given I have search history
    When I remove a single item
    Then that item should be removed
    And other history should remain

  @happy-path @search-history
  Scenario: Disable search history
    Given I am in settings
    When I disable search history
    Then searches should not be saved
    And my preference should persist

  # ============================================================================
  # AUTOCOMPLETE
  # ============================================================================

  @happy-path @autocomplete
  Scenario: See type-ahead suggestions
    Given I am typing in search
    Then I should see type-ahead suggestions
    And suggestions should appear quickly

  @happy-path @autocomplete
  Scenario: Get smart suggestions
    Given I start typing
    Then I should see smart suggestions
    And suggestions should be contextual

  @happy-path @autocomplete
  Scenario: Use fuzzy matching
    Given I make a typo in my search
    Then I should still see relevant results
    And fuzzy matching should find matches

  @happy-path @autocomplete
  Scenario: Use phonetic search
    Given I search with phonetic spelling
    Then I should find the correct results
    And phonetic variations should match

  @happy-path @autocomplete
  Scenario: Select autocomplete suggestion
    Given I see autocomplete suggestions
    When I select a suggestion
    Then the search should be executed
    And I should see results

  @happy-path @autocomplete
  Scenario: Navigate autocomplete with keyboard
    Given I see autocomplete suggestions
    When I use arrow keys
    Then I should navigate suggestions
    And I can select with Enter

  @happy-path @autocomplete
  Scenario: Dismiss autocomplete
    Given I see autocomplete suggestions
    When I press Escape
    Then autocomplete should close
    And search bar should remain focused

  # ============================================================================
  # SEARCH ANALYTICS
  # ============================================================================

  @happy-path @search-analytics
  Scenario: Track search queries
    Given I perform searches
    Then searches should be tracked
    And data should be available for analysis

  @happy-path @search-analytics
  Scenario: Identify popular searches
    Given search data is collected
    When I view analytics
    Then I should see popular searches
    And popularity should be ranked

  @happy-path @search-analytics
  Scenario: Identify no-result queries
    Given some searches return no results
    Then no-result queries should be tracked
    And they should be flagged for improvement

  @happy-path @search-analytics
  Scenario: Optimize search based on data
    Given analytics show patterns
    When optimizations are applied
    Then search should improve
    And user experience should be better

  @happy-path @search-analytics
  Scenario: Track search-to-action conversion
    Given users search and take actions
    Then conversion should be tracked
    And effective searches should be identified

  @happy-path @search-analytics
  Scenario: Monitor search performance
    Given search is being used
    Then performance should be monitored
    And slow searches should be flagged

  # ============================================================================
  # VOICE SEARCH
  # ============================================================================

  @happy-path @voice-search
  Scenario: Initiate voice search
    Given voice search is available
    When I activate voice input
    Then I should see voice recording indicator
    And I should be able to speak

  @happy-path @voice-search
  Scenario: Speak search query
    Given voice input is active
    When I speak my search query
    Then my speech should be recognized
    And the search should be executed

  @happy-path @voice-search
  Scenario: Use voice commands
    Given voice input is active
    When I speak a command
    Then the command should be recognized
    And the action should be performed

  @happy-path @voice-search
  Scenario: Search hands-free
    Given I cannot type
    When I use voice search
    Then I should be able to search completely hands-free
    And results should be spoken or displayed

  @happy-path @voice-search
  Scenario: Correct voice recognition
    Given voice recognition made an error
    When I correct the text
    Then the correction should be applied
    And search should use corrected text

  @mobile @voice-search
  Scenario: Use voice search on mobile
    Given I am on a mobile device
    When I use voice search
    Then voice input should work on mobile
    And results should be mobile-friendly

  @error @voice-search
  Scenario: Handle voice recognition failure
    Given voice recognition fails
    Then I should see an error message
    And I should be able to type instead

  @error @voice-search
  Scenario: Handle no microphone access
    Given I denied microphone permission
    When I try voice search
    Then I should see a permission message
    And I should be prompted to enable it
