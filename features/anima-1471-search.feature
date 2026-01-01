@search
Feature: Search
  As a fantasy football user
  I want comprehensive search functionality
  So that I can quickly find players, leagues, and users

  # --------------------------------------------------------------------------
  # Player Search
  # --------------------------------------------------------------------------

  @player-search
  Scenario: Search player by name
    Given I am logged in
    When I search for a player by name "Patrick Mahomes"
    Then I should see matching players
    And results should include the player's team
    And results should include the player's position
    And I should be able to click to view player details

  @player-search
  Scenario: Search player by partial name
    Given I am logged in
    When I search for "Mahom"
    Then I should see players with names matching "Mahom"
    And results should update as I type
    And I should see autocomplete suggestions

  @player-search
  Scenario: Search players by position
    Given I am logged in
    When I search for players
    And I filter by position "QB"
    Then I should see only quarterbacks
    And results should be sorted by relevance
    And I should see position clearly indicated

  @player-search
  Scenario: Search players by team
    Given I am logged in
    When I search for players
    And I filter by team "Kansas City Chiefs"
    Then I should see only Chiefs players
    And results should show team affiliation
    And I should be able to combine with other filters

  @player-search
  Scenario: Search available players
    Given I am logged in
    And I am viewing my league
    When I search for available players
    And I filter by availability "Free Agent"
    Then I should see only unrostered players
    And I should see option to add players
    And results should update in real-time

  @player-search
  Scenario: Search players by stat filters
    Given I am logged in
    When I search for players
    And I filter by "rushing yards > 1000"
    Then I should see players meeting stat criteria
    And I should see the relevant stat displayed
    And I should be able to adjust stat thresholds

  @player-search
  Scenario: Search players by bye week
    Given I am logged in
    When I search for players
    And I filter by bye week "Week 10"
    Then I should see players with that bye week
    And I should be able to exclude certain bye weeks

  @player-search
  Scenario: Search injured players
    Given I am logged in
    When I search for players
    And I filter by injury status
    Then I should see injured players
    And I should see injury designation
    And I should see expected return timeline

  # --------------------------------------------------------------------------
  # League Search
  # --------------------------------------------------------------------------

  @league-search
  Scenario: Find public leagues
    Given I am logged in
    When I search for public leagues
    Then I should see available public leagues
    And I should see league size and format
    And I should be able to request to join

  @league-search
  Scenario: Search by league name
    Given I am logged in
    When I search for a league by name
    Then I should see leagues matching the name
    And I should see league details
    And I should see member count

  @league-search
  Scenario: Filter leagues by type
    Given I am logged in
    When I search for leagues
    And I filter by league type "Dynasty"
    Then I should see only dynasty leagues
    And I should see dynasty-specific details

  @league-search
  Scenario: Filter leagues by size
    Given I am logged in
    When I search for leagues
    And I filter by size "12 teams"
    Then I should see only 12-team leagues
    And I should see current roster count

  @league-search
  Scenario: Filter leagues by scoring format
    Given I am logged in
    When I search for leagues
    And I filter by scoring "PPR"
    Then I should see only PPR leagues
    And I should see scoring format clearly

  @league-search
  Scenario: Search leagues with open spots
    Given I am logged in
    When I search for leagues
    And I filter by "Open Spots"
    Then I should see leagues with available spots
    And I should see how many spots are open
    And I should be able to join directly

  # --------------------------------------------------------------------------
  # User Search
  # --------------------------------------------------------------------------

  @user-search
  Scenario: Find user by username
    Given I am logged in
    When I search for a user by username
    Then I should see matching users
    And I should see user avatars
    And I should be able to view their profile

  @user-search
  Scenario: Search user by email
    Given I am logged in
    When I search for a user by email
    And the user allows email search
    Then I should see the matching user
    And I should be able to send friend request

  @user-search
  Scenario: Search user by display name
    Given I am logged in
    When I search for a user by display name
    Then I should see users with matching names
    And results should show username and display name
    And I should see mutual connections if any

  @user-search
  Scenario: Find mutual connections
    Given I am logged in
    When I search for users
    And I filter by "Mutual Connections"
    Then I should see users who share connections with me
    And I should see which connections we share
    And I should be able to connect with them

  @user-search
  Scenario: Search users in my leagues
    Given I am logged in
    When I search for users
    And I filter by "My Leagues"
    Then I should see only league mates
    And I should see which leagues we share
    And I should be able to message them

  # --------------------------------------------------------------------------
  # Advanced Search
  # --------------------------------------------------------------------------

  @advanced-search
  Scenario: Perform multi-criteria search
    Given I am logged in
    When I use advanced search
    And I set multiple criteria
    And I combine position, team, and stat filters
    Then I should see results matching all criteria
    And I should see which criteria each result matches

  @advanced-search
  Scenario: Save search for later
    Given I am logged in
    And I have configured a search with filters
    When I save the search
    And I provide a name for the search
    Then the search should be saved
    And I should be able to run it again later

  @advanced-search
  Scenario: Use search operators
    Given I am logged in
    When I use advanced search operators
    And I use "AND" to combine terms
    And I use "OR" for alternatives
    And I use "NOT" to exclude
    Then results should respect operators
    And I should see operator syntax help

  @advanced-search
  Scenario: Search with wildcards
    Given I am logged in
    When I search using wildcards
    And I use asterisk for partial matches
    Then I should see matching results
    And wildcards should work at start and end

  @advanced-search
  Scenario: Search with exact phrase
    Given I am logged in
    When I search using quotes for exact phrase
    Then I should see only exact matches
    And partial matches should be excluded

  @advanced-search
  Scenario: Combine saved searches
    Given I have multiple saved searches
    When I combine saved searches
    Then I should see combined results
    And I should be able to save the combination

  # --------------------------------------------------------------------------
  # Search Filters
  # --------------------------------------------------------------------------

  @search-filters
  Scenario: Apply position filter
    Given I am searching for players
    When I apply position filter
    Then I should see position options
    And I should be able to select multiple positions
    And results should filter immediately

  @search-filters
  Scenario: Apply team filter
    Given I am searching for players
    When I apply team filter
    Then I should see all NFL teams
    And I should be able to select multiple teams
    And I should be able to filter by division

  @search-filters
  Scenario: Apply status filter
    Given I am searching for players
    When I apply status filter
    Then I should filter by available/rostered
    And I should filter by injury status
    And I should filter by active/inactive

  @search-filters
  Scenario: Apply stat range filter
    Given I am searching for players
    When I apply stat range filter
    Then I should set minimum and maximum values
    And I should choose which stat to filter
    And I should see stat previews in results

  @search-filters
  Scenario: Clear all filters
    Given I have applied multiple filters
    When I clear all filters
    Then all filters should be removed
    And I should see unfiltered results
    And I should see clear filters option

  @search-filters
  Scenario: Save filter combination
    Given I have applied multiple filters
    When I save this filter combination
    Then filters should be saved as preset
    And I should be able to apply preset later

  # --------------------------------------------------------------------------
  # Search Results
  # --------------------------------------------------------------------------

  @search-results
  Scenario: Sort search results
    Given I have search results
    When I change sort order
    Then I should be able to sort by relevance
    And I should be able to sort by name
    And I should be able to sort by stat values
    And I should be able to sort by recent activity

  @search-results
  Scenario: Paginate search results
    Given I have many search results
    When I view paginated results
    Then I should see results per page option
    And I should see page navigation
    And I should see total result count

  @search-results
  Scenario: View result cards
    Given I am viewing search results
    When I see result cards
    Then each card should show key information
    And each card should have quick action buttons
    And I should be able to expand for more details

  @search-results
  Scenario: Use quick actions on results
    Given I am viewing player search results
    When I use quick actions
    Then I should be able to add player to roster
    And I should be able to add to watchlist
    And I should be able to view full profile

  @search-results
  Scenario: Compare search results
    Given I am viewing search results
    When I select multiple results
    Then I should be able to compare them
    And I should see side-by-side comparison
    And I should see key differences highlighted

  @search-results
  Scenario: Export search results
    Given I have search results
    When I export results
    Then I should be able to download as CSV
    And I should be able to download as PDF
    And exported data should match visible results

  # --------------------------------------------------------------------------
  # Search Suggestions
  # --------------------------------------------------------------------------

  @search-suggestions
  Scenario: See autocomplete suggestions
    Given I am typing in search box
    When I type partial text
    Then I should see autocomplete suggestions
    And suggestions should update as I type
    And I should be able to select a suggestion

  @search-suggestions
  Scenario: View recent searches
    Given I have performed searches before
    When I focus on the search box
    Then I should see my recent searches
    And I should be able to repeat a recent search
    And I should be able to remove from recent

  @search-suggestions
  Scenario: See popular searches
    Given I am in the search interface
    When I view search suggestions
    Then I should see popular searches
    And popularity should be contextual
    And I should be able to try popular searches

  @search-suggestions
  Scenario: Get typo correction
    Given I am searching
    When I make a typo in my search
    Then I should see "Did you mean..." suggestion
    And I should be able to use corrected search
    And I should still see results for original query

  @search-suggestions
  Scenario: See trending searches
    Given I am in the search interface
    When I view trending searches
    Then I should see currently trending topics
    And trending should be updated regularly
    And I should see why items are trending

  @search-suggestions
  Scenario: Get personalized suggestions
    Given I have search history
    When I view suggestions
    Then suggestions should be personalized
    And suggestions should reflect my interests
    And I should be able to disable personalization

  # --------------------------------------------------------------------------
  # Global Search
  # --------------------------------------------------------------------------

  @global-search
  Scenario: Search across all entities
    Given I am using global search
    When I enter a search term
    Then I should see results across players, leagues, and users
    And results should be categorized
    And I should see result count per category

  @global-search
  Scenario: Use unified search bar
    Given I am anywhere in the application
    When I access the global search bar
    Then I should be able to search from anywhere
    And keyboard shortcut should open search
    And search should be fast and responsive

  @global-search
  Scenario: Filter by search category
    Given I am using global search
    When I filter by category
    Then I should filter to only players
    And I should filter to only leagues
    And I should filter to only users
    And I should filter to only content

  @global-search
  Scenario: See categorized results
    Given I have global search results
    When I view the results
    Then players should be in player section
    And leagues should be in league section
    And users should be in user section
    And I should navigate between sections easily

  @global-search
  Scenario: Quick navigation from search
    Given I have search results
    When I select a result
    Then I should navigate directly to that item
    And navigation should be instant
    And I should be able to return to results

  # --------------------------------------------------------------------------
  # Search History
  # --------------------------------------------------------------------------

  @search-history
  Scenario: View recent searches
    Given I have performed searches
    When I view my search history
    Then I should see all recent searches
    And searches should be chronologically ordered
    And I should see search timestamps

  @search-history
  Scenario: View search analytics
    Given I have search history
    When I view search analytics
    Then I should see most searched terms
    And I should see search patterns
    And I should see filter usage

  @search-history
  Scenario: Clear search history
    Given I have search history
    When I clear my search history
    Then all search history should be removed
    And recent searches should be empty
    And I should see confirmation

  @search-history
  Scenario: Bookmark search
    Given I have performed a useful search
    When I bookmark the search
    Then the search should be saved to bookmarks
    And I should be able to access bookmarked searches
    And bookmarks should be separate from history

  @search-history
  Scenario: Manage bookmarked searches
    Given I have bookmarked searches
    When I manage bookmarks
    Then I should be able to rename bookmarks
    And I should be able to organize into folders
    And I should be able to delete bookmarks

  @search-history
  Scenario: Share search with others
    Given I have a search I want to share
    When I share the search
    Then I should generate a shareable link
    And recipients should see same search
    And shared search should include filters

  # --------------------------------------------------------------------------
  # Search Performance
  # --------------------------------------------------------------------------

  @search-performance
  Scenario: Experience fast search results
    Given I am performing a search
    When I submit my search
    Then results should appear quickly
    And results should appear within 500ms
    And I should see loading indicator if delayed

  @search-performance
  Scenario: Benefit from indexed search
    Given I am searching
    When the search executes
    Then search should use optimized indexes
    And complex queries should still be fast
    And result count should be accurate

  @search-performance
  Scenario: Benefit from search caching
    Given I have performed a search before
    When I repeat the same search
    Then results should be served from cache
    And cached results should be fast
    And cache should be invalidated when data changes

  @search-performance
  Scenario: See relevance ranked results
    Given I have search results
    When I view the results
    Then most relevant results should be first
    And relevance should consider multiple factors
    And I should understand why results are ranked

  @search-performance
  Scenario: Search with instant results
    Given I am typing a search
    When I type each character
    Then results should update instantly
    And there should be no lag
    And I should be able to select as I type

  @search-performance
  Scenario: Handle large result sets
    Given my search matches many items
    When I view results
    Then results should load progressively
    And I should be able to scroll smoothly
    And total count should be displayed

  # --------------------------------------------------------------------------
  # Search Accessibility
  # --------------------------------------------------------------------------

  @search @accessibility
  Scenario: Navigate search with keyboard
    Given I am using the search interface
    When I use keyboard navigation
    Then I should navigate with arrow keys
    And I should select with Enter
    And I should escape with Escape key

  @search @accessibility
  Scenario: Screen reader compatibility
    Given I am using a screen reader
    When I use the search interface
    Then search elements should be labeled
    And results should be announced
    And actions should be accessible

  # --------------------------------------------------------------------------
  # Error Handling and Edge Cases
  # --------------------------------------------------------------------------

  @search @error-handling
  Scenario: Handle no results found
    Given I perform a search
    When no results match my query
    Then I should see "No results found" message
    And I should see search suggestions
    And I should see tips to broaden search

  @search @error-handling
  Scenario: Handle search timeout
    Given I perform a complex search
    When the search times out
    Then I should see a timeout message
    And I should be able to retry
    And I should be offered to simplify search

  @search @error-handling
  Scenario: Handle special characters
    Given I am searching
    When I include special characters
    Then special characters should be handled safely
    And search should not break
    And I should see appropriate results

  @search @validation
  Scenario: Validate search input
    Given I am entering a search query
    When I enter extremely long input
    Then input should be limited to reasonable length
    And I should see character count
    And search should still function

  @search @security
  Scenario: Prevent search injection
    Given I am searching
    When I enter potentially malicious input
    Then input should be sanitized
    And search should be safe
    And no security vulnerabilities should exist
