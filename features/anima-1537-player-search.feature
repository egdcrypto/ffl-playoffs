@player-search
Feature: Player Search
  As a fantasy football manager
  I want to search for players using various criteria
  So that I can quickly find players for my roster decisions

  Background:
    Given I am a registered user
    And I am logged into the platform
    And I have access to player search functionality

  # --------------------------------------------------------------------------
  # Basic Search Scenarios
  # --------------------------------------------------------------------------
  @basic-search
  Scenario: Search for player by full name
    Given I am on the player search page
    When I enter a player's full name
    Then I should see matching players in the results
    And the exact match should appear first
    And results should be relevant

  @basic-search
  Scenario: Search with partial name matching
    Given I want to find a player quickly
    When I enter a partial name
    Then I should see players matching the partial text
    And first name matches should show
    And last name matches should show

  @basic-search
  Scenario: Use autocomplete suggestions
    Given I start typing a player name
    When suggestions appear
    Then I should see relevant player suggestions
    And I can select a suggestion to search
    And suggestions should update as I type

  @basic-search
  Scenario: Search with phonetic matching
    Given player names can be misspelled
    When I enter a phonetically similar spelling
    Then I should still find the intended player
    And "did you mean" suggestions should appear
    And common misspellings should be handled

  @basic-search
  Scenario: Search by nickname or common name
    Given some players have nicknames
    When I search by a known nickname
    Then I should find the player
    And official name should display in results
    And nickname should be recognized

  @basic-search
  Scenario: Search with special characters
    Given some names have special characters
    When I search for names with accents or apostrophes
    Then I should find the correct players
    And special characters should be handled
    And results should be accurate

  @basic-search
  Scenario: Clear search and start fresh
    Given I have performed a search
    When I clear the search field
    Then the results should reset
    And I can start a new search
    And filters should optionally persist

  @basic-search
  Scenario: Search with no results
    Given I search for a non-existent player
    When no results are found
    Then I should see a helpful no results message
    And suggestions should be offered
    And similar name suggestions should display

  # --------------------------------------------------------------------------
  # Advanced Filters Scenarios
  # --------------------------------------------------------------------------
  @advanced-filters
  Scenario: Filter search results by position
    Given I want players at a specific position
    When I apply a position filter
    Then only players at that position should show
    And I can select multiple positions
    And filter should be clearly indicated

  @advanced-filters
  Scenario: Filter search results by team
    Given I want players from a specific team
    When I apply a team filter
    Then only players from that team should show
    And I can select multiple teams
    And team logos should help identification

  @advanced-filters
  Scenario: Filter by player status
    Given I want active or inactive players
    When I apply a status filter
    Then only players with that status should show
    And I can filter by healthy, injured, or suspended
    And status should be clearly displayed

  @advanced-filters
  Scenario: Filter by availability
    Given I want only available players
    When I apply an availability filter
    Then only available players should show
    And rostered vs unrostered should filter
    And availability should be current

  @advanced-filters
  Scenario: Combine multiple filters
    Given I want to narrow my search
    When I apply multiple filters together
    Then results should match all criteria
    And active filters should be visible
    And I can remove filters individually

  @advanced-filters
  Scenario: Filter by experience level
    Given I want players with certain experience
    When I filter by years of experience
    Then only players matching experience should show
    And rookie filter should be available
    And veteran filter should work

  @advanced-filters
  Scenario: Filter by bye week
    Given bye weeks matter for planning
    When I filter by bye week
    Then only players with that bye should show
    And I can exclude certain bye weeks
    And bye week should display in results

  @advanced-filters
  Scenario: Filter by draft eligibility
    Given I'm preparing for a draft
    When I filter for draftable players
    Then only draft-eligible players should show
    And ADP range filter should work
    And already drafted players can be excluded

  # --------------------------------------------------------------------------
  # Stat-Based Search Scenarios
  # --------------------------------------------------------------------------
  @stat-search
  Scenario: Search by fantasy points scored
    Given I want high-scoring players
    When I search by fantasy point range
    Then players in that range should show
    And I can set minimum and maximum thresholds
    And scoring format should be selectable

  @stat-search
  Scenario: Search by performance thresholds
    Given I want players meeting stat thresholds
    When I set stat minimums
    Then only players exceeding thresholds should show
    And multiple stat criteria can combine
    And threshold values should validate

  @stat-search
  Scenario: Search by yards gained
    Given yardage is a key metric
    When I search by yardage range
    Then players in that range should show
    And I can specify rushing, receiving, or passing
    And total yards should be accurate

  @stat-search
  Scenario: Search by touchdown production
    Given touchdowns drive fantasy scoring
    When I search by touchdown count
    Then players with that TD count should show
    And TD type can be specified
    And TD range should be configurable

  @stat-search
  Scenario: Search by efficiency metrics
    Given efficiency indicates quality
    When I search by efficiency stats
    Then players meeting efficiency criteria should show
    And yards per attempt can filter
    And catch rate can filter

  @stat-search
  Scenario: Search by target or touch volume
    Given opportunity predicts production
    When I search by volume metrics
    Then high-volume players should show
    And target share can filter
    And touch counts can filter

  @stat-search
  Scenario: Search by consistency metrics
    Given consistency matters for reliability
    When I search by consistency score
    Then consistent performers should show
    And floor and ceiling can filter
    And boom/bust tendency can filter

  @stat-search
  Scenario: Search by recent performance
    Given recent performance is relevant
    When I filter by last few weeks stats
    Then recently hot players should show
    And rolling average can filter
    And hot streak players can identify

  # --------------------------------------------------------------------------
  # Availability Search Scenarios
  # --------------------------------------------------------------------------
  @availability-search
  Scenario: Search for free agents only
    Given I want unowned players
    When I filter for free agents
    Then only unrostered players should show
    And waiver status should display
    And availability should be accurate

  @availability-search
  Scenario: Search waiver wire players
    Given waivers are a key acquisition method
    When I search waiver wire
    Then players on waivers should show
    And waiver priority should display
    And waiver period end should show

  @availability-search
  Scenario: Search for tradeable players
    Given I want trade targets
    When I filter for tradeable players
    Then players available for trade should show
    And trade value should display
    And owner information should be accessible

  @availability-search
  Scenario: Search for droppable players
    Given I might need to drop someone
    When I filter for droppable players
    Then droppable candidates should show
    And drop implications should note
    And waiver claim risk should assess

  @availability-search
  Scenario: Search by roster percentage
    Given ownership indicates value perception
    When I filter by roster percentage
    Then players in that ownership range should show
    And I can find under-owned gems
    And trending ownership should show

  @availability-search
  Scenario: Search by add/drop activity
    Given transaction activity shows trends
    When I filter by recent transactions
    Then recently added players should show
    And recently dropped players should show
    And net transaction direction should indicate

  @availability-search
  Scenario: Search my league's available players
    Given I care about my specific league
    When I search my league's free agents
    Then only my league's available players should show
    And competing owner interest should note
    And league-specific context should apply

  @availability-search
  Scenario: Search for IR-eligible players
    Given IR spots have specific rules
    When I filter for IR-eligible players
    Then only IR-eligible players should show
    And injury designation should display
    And return timeline should estimate

  # --------------------------------------------------------------------------
  # Search Sorting Scenarios
  # --------------------------------------------------------------------------
  @search-sorting
  Scenario: Sort search results by name
    Given I want alphabetical ordering
    When I sort by player name
    Then results should order alphabetically
    And I can toggle ascending or descending
    And sort indicator should display

  @search-sorting
  Scenario: Sort search results by position
    Given I want position grouping
    When I sort by position
    Then results should group by position
    And position order should be logical
    And secondary sort should apply within positions

  @search-sorting
  Scenario: Sort search results by team
    Given I want team grouping
    When I sort by team
    Then results should group by team
    And team order can be alphabetical or divisional
    And team context should provide

  @search-sorting
  Scenario: Sort by projected points
    Given projections drive decisions
    When I sort by projections
    Then highest projected should appear first
    And projection source should be indicated
    And I can choose projection timeframe

  @search-sorting
  Scenario: Sort by rankings
    Given rankings indicate value
    When I sort by ranking
    Then highest ranked should appear first
    And ranking source can be selected
    And I can choose ranking type

  @search-sorting
  Scenario: Sort by ownership percentage
    Given ownership shows popularity
    When I sort by ownership
    Then I can find least or most owned
    And ownership percentage should display
    And trending direction should show

  @search-sorting
  Scenario: Sort by recent performance
    Given recent results matter
    When I sort by recent points
    Then hot players should rank higher
    And time period can be selected
    And trend direction should indicate

  @search-sorting
  Scenario: Apply multiple sort levels
    Given I want nuanced ordering
    When I apply multiple sort criteria
    Then primary sort should apply first
    And secondary sort should break ties
    And sort hierarchy should be clear

  # --------------------------------------------------------------------------
  # Search History Scenarios
  # --------------------------------------------------------------------------
  @search-history
  Scenario: View recent searches
    Given I've searched previously
    When I access search history
    Then I should see my recent searches
    And searches should be ordered by recency
    And I can repeat a previous search

  @search-history
  Scenario: Save searches for later
    Given I want to save useful searches
    When I save a search
    Then it should be added to saved searches
    And I can name my saved search
    And I can access it later

  @search-history
  Scenario: Manage search favorites
    Given some searches are frequently used
    When I favorite a search
    Then it should appear in favorites
    And favorites should be easily accessible
    And I can unfavorite if needed

  @search-history
  Scenario: Clear search history
    Given I want privacy or fresh start
    When I clear my search history
    Then history should be removed
    And saved searches should optionally persist
    And confirmation should be required

  @search-history
  Scenario: Access search history across devices
    Given I use multiple devices
    When I access search on another device
    Then my search history should sync
    And saved searches should be available
    And consistency should maintain

  @search-history
  Scenario: View search history with context
    Given context helps remember searches
    When I view search history
    Then I should see what I was searching for
    And filters used should display
    And date and time should show

  @search-history
  Scenario: Delete individual history items
    Given I want to remove specific searches
    When I delete a history item
    Then only that item should be removed
    And other history should remain
    And deletion should confirm

  @search-history
  Scenario: Import and export search configurations
    Given I want to share or backup searches
    When I export search configurations
    Then I should receive exportable format
    And I can import to another account
    And configurations should restore correctly

  # --------------------------------------------------------------------------
  # Bulk Search Scenarios
  # --------------------------------------------------------------------------
  @bulk-search
  Scenario: Look up multiple players at once
    Given I have a list of player names
    When I perform a bulk search
    Then all matching players should show
    And unmatched names should be flagged
    And I can review all results together

  @bulk-search
  Scenario: Import player list for search
    Given I have players in a file
    When I import the player list
    Then the file should parse correctly
    And players should be matched
    And I can see the search results

  @bulk-search
  Scenario: Perform batch search operations
    Given I want to evaluate many players
    When I run a batch search
    Then all operations should execute
    And results should aggregate
    And I can export batch results

  @bulk-search
  Scenario: Compare bulk search results
    Given I've searched for multiple players
    When I view bulk results
    Then I should see comparison view
    And key stats should compare
    And I can select players from results

  @bulk-search
  Scenario: Add bulk search results to watchlist
    Given I want to track multiple players
    When I add bulk results to watchlist
    Then all selected players should add
    And watchlist should update
    And confirmation should display

  @bulk-search
  Scenario: Filter within bulk search results
    Given I have many bulk results
    When I filter the bulk results
    Then filters should apply to results
    And I can narrow down the list
    And original results should be recoverable

  @bulk-search
  Scenario: Handle large bulk searches
    Given bulk searches can be large
    When I submit a large player list
    Then the system should handle it gracefully
    And results should paginate if needed
    And performance should remain acceptable

  @bulk-search
  Scenario: Validate bulk search input
    Given input may have errors
    When I submit bulk search data
    Then input should be validated
    And errors should be highlighted
    And I can correct and retry

  # --------------------------------------------------------------------------
  # Search Suggestions Scenarios
  # --------------------------------------------------------------------------
  @search-suggestions
  Scenario: View trending player searches
    Given some players are trending
    When I access search suggestions
    Then I should see trending players
    And trending reason should display
    And I can click to search

  @search-suggestions
  Scenario: Get recommended searches
    Given the system can recommend
    When I view recommendations
    Then I should see personalized suggestions
    And recommendations should be relevant
    And I can provide feedback

  @search-suggestions
  Scenario: View similar player suggestions
    Given I've searched for a player
    When I view similar players
    Then related players should suggest
    And similarity reason should explain
    And I can explore suggestions

  @search-suggestions
  Scenario: Get position-based suggestions
    Given I might need position help
    When I search by position need
    Then position-relevant suggestions should show
    And suggestions should match my roster needs
    And availability should factor

  @search-suggestions
  Scenario: View breakout candidate suggestions
    Given I want emerging players
    When I access breakout suggestions
    Then potential breakouts should list
    And breakout reasoning should provide
    And I can add to watchlist

  @search-suggestions
  Scenario: Get waiver wire suggestions
    Given waivers are important weekly
    When I access waiver suggestions
    Then recommended waiver pickups should show
    And suggestions should match my needs
    And priority should indicate

  @search-suggestions
  Scenario: View buy-low and sell-high suggestions
    Given I want trade opportunities
    When I access trade suggestions
    Then buy-low candidates should show
    And sell-high candidates should show
    And reasoning should be provided

  @search-suggestions
  Scenario: Dismiss or hide suggestions
    Given some suggestions aren't relevant
    When I dismiss a suggestion
    Then it should be hidden
    And similar suggestions should reduce
    And I can undo if needed

  # --------------------------------------------------------------------------
  # Search Filter Persistence Scenarios
  # --------------------------------------------------------------------------
  @filter-persistence
  Scenario: Save filter presets
    Given I use certain filters frequently
    When I save a filter preset
    Then the preset should be saved
    And I can name the preset
    And I can apply it later

  @filter-persistence
  Scenario: Set default search settings
    Given I have preferred defaults
    When I set default filters
    Then defaults should apply to new searches
    And I can override when needed
    And defaults should persist

  @filter-persistence
  Scenario: Use quick filter toggles
    Given I want fast filtering
    When I use quick filter buttons
    Then filters should apply instantly
    And common filters should be accessible
    And toggle state should be visible

  @filter-persistence
  Scenario: Manage saved filter presets
    Given I have multiple presets
    When I manage my presets
    Then I should see all saved presets
    And I can edit or delete presets
    And I can reorder presets

  @filter-persistence
  Scenario: Share filter presets with others
    Given I want to share useful filters
    When I share a preset
    Then others can import my preset
    And attribution should preserve
    And sharing should be controllable

  @filter-persistence
  Scenario: Apply filters from URL
    Given filters can be in URLs
    When I access a URL with filters
    Then filters should apply automatically
    And search results should reflect filters
    And I can modify from there

  @filter-persistence
  Scenario: Reset filters to defaults
    Given I want to start fresh
    When I reset filters
    Then all filters should clear
    And defaults should apply if set
    And confirmation should be optional

  @filter-persistence
  Scenario: Sync filter preferences across sessions
    Given I use multiple sessions
    When I return to search
    Then my preferences should persist
    And last used filters can optionally restore
    And sync should be seamless

  # --------------------------------------------------------------------------
  # Search Exports Scenarios
  # --------------------------------------------------------------------------
  @search-exports
  Scenario: Export search results to file
    Given I want search results externally
    When I export search results
    Then I should receive a downloadable file
    And all result data should include
    And format should be selectable

  @search-exports
  Scenario: Share search results via link
    Given I want to share my search
    When I generate a share link
    Then I should receive a shareable URL
    And the link should reproduce the search
    And link should be accessible to recipients

  @search-exports
  Scenario: Download player list from results
    Given I want just the player list
    When I download the player list
    Then I should get a simple list
    And format should be importable
    And I can choose included fields

  @search-exports
  Scenario: Export to spreadsheet format
    Given I use spreadsheets for analysis
    When I export to CSV or Excel
    Then file should be properly formatted
    And columns should be organized
    And data should be accurate

  @search-exports
  Scenario: Schedule automated search exports
    Given I want regular exports
    When I schedule an export
    Then exports should generate on schedule
    And delivery method should be configurable
    And schedule should be manageable

  @search-exports
  Scenario: Export with custom column selection
    Given I need specific data
    When I customize export columns
    Then only selected columns should export
    And column order should be controllable
    And custom columns should be saveable

  @search-exports
  Scenario: Print search results
    Given I want a physical copy
    When I print search results
    Then print layout should be optimized
    And results should be readable
    And page breaks should be logical

  @search-exports
  Scenario: Copy search results to clipboard
    Given I want to paste results elsewhere
    When I copy results to clipboard
    Then data should copy correctly
    And format should be usable
    And I can paste into other applications

  # --------------------------------------------------------------------------
  # Error Handling Scenarios
  # --------------------------------------------------------------------------
  @error-handling
  Scenario: Handle search service unavailable
    Given search service may have issues
    When search is unavailable
    Then I should see an appropriate error
    And cached results should show if available
    And retry should be possible

  @error-handling
  Scenario: Handle search timeout
    Given searches may take too long
    When a search times out
    Then I should see a timeout message
    And I can retry the search
    And partial results should show if available

  @error-handling
  Scenario: Handle invalid search query
    Given queries may be malformed
    When I enter an invalid query
    Then I should see a helpful error
    And valid query format should explain
    And I can correct the query

  @error-handling
  Scenario: Handle filter conflicts
    Given some filter combinations are impossible
    When I apply conflicting filters
    Then I should be informed
    And conflicting filters should identify
    And resolution should be suggested

  @error-handling
  Scenario: Handle bulk search failures
    Given bulk searches may partially fail
    When some bulk items fail
    Then I should see which failed
    And successful results should show
    And I can retry failed items

  @error-handling
  Scenario: Handle export generation failures
    Given exports may fail
    When an export fails
    Then I should see the failure reason
    And I can retry the export
    And partial exports should be recoverable

  @error-handling
  Scenario: Handle search index outdated
    Given search index may lag
    When index is stale
    Then I should be informed
    And approximate results should show
    And refresh option should be available

  @error-handling
  Scenario: Handle rate limiting
    Given rapid searches may be limited
    When rate limit is hit
    Then I should see rate limit message
    And retry timing should indicate
    And cached results should serve

  @error-handling
  Scenario: Handle network connectivity issues
    Given network may be unstable
    When connectivity drops during search
    Then I should see connection error
    And offline search should work if cached
    And reconnection should retry

  @error-handling
  Scenario: Handle unsupported filter combinations
    Given some combinations aren't supported
    When unsupported filters are used
    Then I should see a helpful message
    And supported alternatives should suggest
    And the UI should not break

  @error-handling
  Scenario: Handle corrupted saved searches
    Given saved data may corrupt
    When corruption is detected
    Then corrupted items should be flagged
    And recovery should attempt
    And user should be notified

  @error-handling
  Scenario: Handle external data source failures
    Given some filters need external data
    When external source fails
    Then I should be informed
    And alternative filters should work
    And source status should indicate

  @error-handling
  Scenario: Handle search history sync failures
    Given sync may fail
    When history sync fails
    Then local history should preserve
    And sync retry should be automatic
    And user should be notified if persistent

  # --------------------------------------------------------------------------
  # Accessibility Scenarios
  # --------------------------------------------------------------------------
  @accessibility
  Scenario: Navigate search with keyboard only
    Given I rely on keyboard navigation
    When I use search without a mouse
    Then I should be able to access all features
    And focus indicators should be clear
    And shortcuts should be available

  @accessibility
  Scenario: Use search with screen reader
    Given I use a screen reader
    When I access search functionality
    Then all elements should be properly announced
    And results should be navigable
    And updates should be announced

  @accessibility
  Scenario: View search in high contrast mode
    Given I need high contrast visuals
    When I enable high contrast mode
    Then all search elements should be visible
    And filters should be distinguishable
    And results should be readable

  @accessibility
  Scenario: Access search on mobile devices
    Given I access search on a phone
    When I use search on mobile
    Then the interface should be responsive
    And touch targets should be adequate
    And all features should be accessible

  @accessibility
  Scenario: Customize search display font size
    Given I need larger text
    When I increase font size
    Then all search text should scale
    And layout should remain usable
    And no content should be cut off

  @accessibility
  Scenario: Use search with reduced motion
    Given I am sensitive to motion
    When I have reduced motion enabled
    Then animations should be minimized
    And autocomplete should not flash
    And functionality should be preserved

  @accessibility
  Scenario: Access autocomplete accessibly
    Given autocomplete provides suggestions
    When I use autocomplete
    Then suggestions should be announced
    And I can navigate suggestions by keyboard
    And selection should be clear

  @accessibility
  Scenario: Use voice input for search
    Given I may prefer voice input
    When I use voice search
    Then voice input should be supported
    And transcription should be accurate
    And I can correct by voice or keyboard

  # --------------------------------------------------------------------------
  # Performance Scenarios
  # --------------------------------------------------------------------------
  @performance
  Scenario: Return search results quickly
    Given I submit a search query
    When results are fetched
    Then results should appear within 500ms
    And perceived performance should be optimized
    And loading states should show immediately

  @performance
  Scenario: Display autocomplete suggestions instantly
    Given I am typing a query
    When suggestions are generated
    Then suggestions should appear within 100ms
    And typing should not lag
    And suggestions should be relevant

  @performance
  Scenario: Filter results without delay
    Given I am viewing results
    When I apply filters
    Then filtered results should appear within 200ms
    And filter interaction should feel instant
    And no loading spinner should be needed

  @performance
  Scenario: Handle large result sets efficiently
    Given searches may return many results
    When I view large result sets
    Then results should paginate or virtualize
    And scrolling should be smooth
    And memory should be managed

  @performance
  Scenario: Cache search results for quick access
    Given I may repeat searches
    When I perform a cached search
    Then cached results should load instantly
    And cache freshness should be indicated
    And cache should invalidate appropriately

  @performance
  Scenario: Perform bulk searches efficiently
    Given bulk searches involve many lookups
    When I run a bulk search
    Then bulk search should complete promptly
    And progress should be indicated
    And results should stream as available

  @performance
  Scenario: Export search results quickly
    Given exports should be fast
    When I export results
    Then export should generate promptly
    And large exports should stream
    And browser should remain responsive

  @performance
  Scenario: Sync search preferences efficiently
    Given sync should not impact performance
    When preferences sync
    Then sync should be background
    And search should not be blocked
    And bandwidth should be minimal
