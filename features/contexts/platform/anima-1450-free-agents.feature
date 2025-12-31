@free-agents @platform
Feature: Free Agents
  As a fantasy football league
  I need comprehensive free agent functionality
  So that owners can quickly acquire unowned players without waiver delays

  Background:
    Given the free agent system is operational
    And free agent rules are configured for the league

  # ==================== Free Agent Pool ====================

  @pool @available-players
  Scenario: Display available free agents
    Given players are available as free agents
    When viewing the free agent pool
    Then all unowned players should be listed
    And their status should be clearly indicated
    And add buttons should be accessible

  @pool @available-players
  Scenario: Sort free agent pool
    Given the free agent pool is displayed
    When sorting by criteria
    Then sorting options should include
      | sort_option         | description                |
      | projected_points    | highest projected first    |
      | position            | grouped by position        |
      | team                | grouped by NFL team        |
      | name                | alphabetical order         |

  @pool @unowned-tracking
  Scenario: Track unowned players
    Given players exist in the system
    When tracking ownership
    Then unowned players should be identified
    And ownership changes should be logged
    And availability should update in real-time

  @pool @unowned-tracking
  Scenario: Display ownership history
    Given a player's ownership has changed
    When viewing ownership history
    Then all ownership changes should be shown
    And dates should be included
    And previous owners should be listed

  @pool @recently-dropped
  Scenario: View recently dropped players
    Given players have been dropped recently
    When viewing recently dropped
    Then dropped players should be listed
    And drop date should be shown
    And waiver status should be indicated

  @pool @recently-dropped
  Scenario: Filter by drop date
    Given dropped players exist
    When filtering by drop date
    Then date range filters should work
    And most recent drops should be highlighted
    And waiver clear time should be shown

  @pool @waiver-clearance
  Scenario: Display waiver clearance status
    Given players are on waivers
    When viewing clearance status
    Then time until clearance should be shown
    And clearance date/time should be displayed
    And countdown should update

  @pool @waiver-clearance
  Scenario: Notify when player clears waivers
    Given an owner is watching a player
    When the player clears waivers
    Then the owner should be notified
    And the player should move to free agents
    And pickup should be immediately available

  # ==================== Free Agent Pickup ====================

  @pickup @instant-add
  Scenario: Add free agent instantly
    Given a player is a free agent
    When clicking add
    Then the player should be added immediately
    And the roster should update
    And confirmation should be displayed

  @pickup @instant-add
  Scenario: Confirm instant add success
    Given an add is processed
    When confirmation displays
    Then the player's new status should show
    And roster position should be indicated
    And next steps should be suggested

  @pickup @roster-validation
  Scenario: Validate roster spot availability
    Given a free agent add is attempted
    When validating the roster
    Then available roster spots should be checked
    And position limits should be verified
    And errors should block if invalid

  @pickup @roster-validation
  Scenario: Display roster validation errors
    Given validation fails
    When displaying errors
    Then specific issues should be listed
    And correction options should be offered
    And alternative actions should be suggested

  @pickup @position-eligibility
  Scenario: Check position eligibility
    Given a player has position eligibility
    When adding the player
    Then eligible positions should be shown
    And slot assignment should be validated
    And multi-position eligibility should apply

  @pickup @position-eligibility
  Scenario: Handle multi-position players
    Given a player has multiple positions
    When adding to roster
    Then all eligible slots should be options
    And best slot should be suggested
    And flexibility should be noted

  @pickup @confirmation
  Scenario: Confirm transaction before processing
    Given confirmation is required
    When adding a free agent
    Then confirmation dialog should appear
    And transaction details should be shown
    And cancel option should be available

  @pickup @confirmation
  Scenario: Configure confirmation preferences
    Given confirmation settings exist
    When configuring preferences
    Then options should include
      | preference          | description                |
      | always_confirm      | confirm every transaction  |
      | confirm_drops_only  | only when dropping players |
      | never_confirm       | process immediately        |

  # ==================== Add/Drop Transactions ====================

  @add-drop @simultaneous
  Scenario: Execute simultaneous add/drop
    Given roster is full
    When adding with a drop
    Then both transactions should process together
    And roster should remain legal
    And both changes should be confirmed

  @add-drop @simultaneous
  Scenario: Select player to drop
    Given a drop is required
    When selecting drop candidate
    Then droppable players should be listed
    And drop recommendations should be shown
    And player comparison should be available

  @add-drop @roster-compliance
  Scenario: Ensure roster compliance
    Given an add/drop is submitted
    When checking compliance
    Then post-transaction roster should be legal
    And all requirements should be met
    And violations should be prevented

  @add-drop @roster-compliance
  Scenario: Display compliance requirements
    Given compliance rules exist
    When viewing requirements
    Then the following should be shown
      | requirement         | description                |
      | roster_size         | max players allowed        |
      | position_minimums   | required per position      |
      | position_maximums   | max per position           |

  @add-drop @drop-restrictions
  Scenario: Enforce drop restrictions
    Given drop restrictions exist
    When attempting to drop a restricted player
    Then the drop should be blocked
    And the restriction should be explained
    And alternatives should be suggested

  @add-drop @drop-restrictions
  Scenario: Configure drop restrictions
    Given restriction settings are available
    When configuring restrictions
    Then options should include
      | restriction_type    | description                |
      | cant_drop_list      | designated untouchables    |
      | locked_players      | game-started players       |
      | injured_reserve     | IR-designated players      |

  @add-drop @transaction-limits
  Scenario: Apply transaction limits
    Given transaction limits are configured
    When limit is reached
    Then additional transactions should be blocked
    And current count should be displayed
    And limit reset timing should be shown

  @add-drop @transaction-limits
  Scenario: Track transaction count
    Given limits are in effect
    When viewing transaction status
    Then current count should be displayed
    And remaining transactions should show
    And limit period should be indicated

  # ==================== Free Agent Filtering ====================

  @filtering @position-filters
  Scenario: Filter by position
    Given position filters are available
    When selecting a position filter
    Then only that position should display
    And multiple positions should be selectable
    And filter should be toggleable

  @filtering @position-filters
  Scenario: Apply multi-position filter
    Given multiple positions are selected
    When applying the filter
    Then all selected positions should show
    And results should combine
    And clear filter option should be available

  @filtering @team-filters
  Scenario: Filter by NFL team
    Given team filters are available
    When selecting a team
    Then only players from that team should show
    And team logo should be displayed
    And multiple teams should be selectable

  @filtering @team-filters
  Scenario: Filter by bye week
    Given bye week filters exist
    When filtering by bye week
    Then players with matching bye should show
    And current week bye should be highlighted
    And upcoming byes should be accessible

  @filtering @stat-sorting
  Scenario: Sort by statistical categories
    Given stat sorting is available
    When sorting by a stat
    Then players should reorder by that stat
    And stat value should be displayed
    And sort direction should be toggleable

  @filtering @stat-sorting
  Scenario: View stat comparison
    Given stats are displayed
    When comparing players
    Then side-by-side stats should show
    And differences should be highlighted
    And trends should be visible

  @filtering @availability-status
  Scenario: Filter by availability status
    Given availability filters exist
    When filtering by status
    Then options should include
      | status              | description                |
      | free_agent          | immediately available      |
      | on_waivers          | awaiting clearance         |
      | recently_cleared    | just became free agent     |

  @filtering @injury-filters
  Scenario: Filter by injury status
    Given injury filters are available
    When filtering by injury
    Then options should include
      | injury_filter       | players_shown              |
      | healthy_only        | no injury designation      |
      | questionable        | Q designation              |
      | doubtful            | D designation              |
      | out                 | O designation              |
      | ir                  | IR designation             |

  # ==================== Free Agent Search ====================

  @search @player-name
  Scenario: Search by player name
    Given search functionality exists
    When entering a player name
    Then matching players should appear
    And search should be case-insensitive
    And partial matches should work

  @search @player-name
  Scenario: Display search results
    Given a search is executed
    When results appear
    Then player cards should be shown
    And key info should be visible
    And add buttons should be accessible

  @search @advanced-filters
  Scenario: Apply advanced search filters
    Given advanced filters exist
    When configuring filters
    Then options should include
      | filter_type         | options                    |
      | min_projected_pts   | numeric threshold          |
      | years_experience    | rookie, 2-4, 5+            |
      | age_range           | under 25, 25-30, over 30   |
      | draft_capital       | 1st round, day 2, UDFA     |

  @search @advanced-filters
  Scenario: Combine multiple search criteria
    Given multiple filters are set
    When executing the search
    Then all criteria should apply
    And results should match all filters
    And filter summary should display

  @search @saved-searches
  Scenario: Save search criteria
    Given a search is configured
    When saving the search
    Then the search should be stored
    And it should be reusable
    And naming should be allowed

  @search @saved-searches
  Scenario: Access saved searches
    Given saved searches exist
    When accessing saved searches
    Then all saved searches should list
    And one-click execution should work
    And edit and delete should be available

  @search @recent-searches
  Scenario: View recent searches
    Given searches have been performed
    When viewing recent searches
    Then recent searches should be listed
    And quick re-search should be available
    And clear history should be an option

  @search @recent-searches
  Scenario: Quick access to recent search
    Given recent searches are shown
    When selecting a recent search
    Then the search should execute immediately
    And results should populate
    And filters should be restored

  # ==================== Ownership Data ====================

  @ownership @league-percentage
  Scenario: Display league ownership percentage
    Given ownership data is tracked
    When viewing a player
    Then league-wide ownership should show
    And percentage should be accurate
    And trend indicator should display

  @ownership @league-percentage
  Scenario: Compare ownership across leagues
    Given multi-league data exists
    When comparing ownership
    Then ownership by league should show
    And differences should be highlighted
    And insights should be provided

  @ownership @add-drop-trends
  Scenario: Display add/drop trends
    Given transaction data exists
    When viewing trends
    Then recent adds should be shown
    And recent drops should be shown
    And net change should calculate

  @ownership @add-drop-trends
  Scenario: Identify trending players
    Given trend data is calculated
    When viewing trending players
    Then players with highest adds should show
    And players with highest drops should show
    And percentage changes should display

  @ownership @roster-percentage
  Scenario: Show roster percentage
    Given roster data is available
    When viewing ownership
    Then rostered percentage should display
    And starting percentage should show
    And bench percentage should be calculated

  @ownership @roster-percentage
  Scenario: Display ownership breakdown
    Given detailed ownership data exists
    When viewing breakdown
    Then the following should show
      | metric              | description                |
      | rostered_pct        | on rosters league-wide     |
      | started_pct         | in starting lineups        |
      | benched_pct         | on benches                 |
      | ir_pct              | on injured reserve         |

  @ownership @start-percentage
  Scenario: Show start percentage
    Given start data is tracked
    When viewing start rate
    Then percentage started should display
    And trend should be shown
    And week-over-week change should calculate

  @ownership @start-percentage
  Scenario: Compare start rates
    Given start data exists
    When comparing players
    Then start rates should be comparable
    And position context should be provided
    And rankings should be available

  # ==================== Player Availability Status ====================

  @availability @waiver-indicator
  Scenario: Display waiver status indicator
    Given a player is on waivers
    When viewing the player
    Then waiver indicator should display
    And clearance time should be shown
    And claim option should be available

  @availability @waiver-indicator
  Scenario: Show waiver claim count
    Given claims exist on a player
    When viewing waiver status
    Then number of claims should show
    And competition should be indicated
    And priority should be relevant

  @availability @free-agent-indicator
  Scenario: Display free agent indicator
    Given a player is a free agent
    When viewing the player
    Then free agent indicator should display
    And instant add should be available
    And no waiting period should apply

  @availability @free-agent-indicator
  Scenario: Distinguish free agent from waiver
    Given both statuses exist
    When viewing players
    Then visual distinction should be clear
    And action options should differ
    And status should be unambiguous

  @availability @lockout-status
  Scenario: Display lockout status
    Given a player is locked
    When viewing the player
    Then locked indicator should display
    And lock reason should be shown
    And unlock time should be indicated

  @availability @lockout-status
  Scenario: Show lockout reasons
    Given lockout exists
    When viewing lockout details
    Then reason should be displayed
      | lockout_reason      | description                |
      | game_in_progress    | player's game has started  |
      | waiver_period       | on waivers                 |
      | trade_pending       | involved in pending trade  |

  @availability @game-time-locks
  Scenario: Apply game-time locks
    Given games are about to start
    When game time arrives
    Then affected players should lock
    And lock status should update
    And owners should be notified

  @availability @game-time-locks
  Scenario: Display game-time lock countdown
    Given a game is approaching
    When viewing lock status
    Then time until lock should display
    And countdown should update
    And warning should appear near lock time

  # ==================== Free Agent Projections ====================

  @projections @projected-points
  Scenario: Display projected points
    Given projections are available
    When viewing a free agent
    Then projected points should display
    And projection source should be shown
    And confidence level should be indicated

  @projections @projected-points
  Scenario: Compare projections across sources
    Given multiple projection sources exist
    When comparing projections
    Then source-by-source values should show
    And consensus should be calculated
    And variance should be highlighted

  @projections @ros-rankings
  Scenario: Show rest-of-season rankings
    Given ROS rankings exist
    When viewing rankings
    Then position rankings should display
    And overall rankings should show
    And ranking changes should be noted

  @projections @ros-rankings
  Scenario: View ROS ranking trends
    Given ranking history exists
    When viewing trends
    Then ranking movement should display
    And trend direction should be clear
    And significant changes should be highlighted

  @projections @matchup-ratings
  Scenario: Display matchup ratings
    Given matchup data exists
    When viewing upcoming matchup
    Then matchup rating should display
    And opponent strength should be shown
    And favorable matchups should be highlighted

  @projections @matchup-ratings
  Scenario: View schedule-based ratings
    Given schedule data exists
    When viewing extended schedule
    Then multi-week ratings should show
    And difficult stretches should be flagged
    And optimal pickup timing should be suggested

  @projections @expert-recommendations
  Scenario: Display expert recommendations
    Given expert analysis exists
    When viewing recommendations
    Then expert picks should be shown
    And reasoning should be provided
    And consensus should be indicated

  @projections @expert-recommendations
  Scenario: Filter by recommendation source
    Given multiple experts exist
    When filtering by source
    Then selected experts should display
    And comparison should be available
    And track records should be accessible

  # ==================== Transaction Processing ====================

  @processing @instant-processing
  Scenario: Process transactions instantly
    Given instant processing is enabled
    When a transaction is submitted
    Then processing should be immediate
    And roster should update instantly
    And confirmation should be quick

  @processing @instant-processing
  Scenario: Handle processing failures
    Given a processing error occurs
    When the failure is detected
    Then error message should display
    And retry option should be available
    And transaction should rollback cleanly

  @processing @confirmation-notifications
  Scenario: Send confirmation notifications
    Given a transaction completes
    When sending confirmation
    Then the owner should be notified
    And transaction details should be included
    And roster impact should be summarized

  @processing @confirmation-notifications
  Scenario: Configure notification preferences
    Given notification settings exist
    When configuring preferences
    Then channels should be selectable
      | channel             | configurable               |
      | email               | yes                        |
      | push                | yes                        |
      | in_app              | always on                  |

  @processing @roster-updates
  Scenario: Update roster after transaction
    Given a transaction completes
    When the roster updates
    Then new player should appear
    And dropped player should be removed
    And positions should be accurate

  @processing @roster-updates
  Scenario: Reflect changes across views
    Given roster changes occur
    When viewing any roster interface
    Then changes should be reflected
    And consistency should be maintained
    And cache should be updated

  @processing @transaction-history
  Scenario: Log transaction history
    Given transactions occur
    When viewing history
    Then all transactions should be logged
    And details should be complete
    And timestamps should be accurate

  @processing @transaction-history
  Scenario: Filter transaction history
    Given extensive history exists
    When filtering history
    Then filters should include
      | filter_type         | options                    |
      | transaction_type    | add, drop, add/drop        |
      | date_range          | from/to dates              |
      | player              | specific player            |

  # ==================== Free Agent Settings ====================

  @settings @acquisition-limits
  Scenario: Configure acquisition limits
    Given limit settings are available
    When configuring limits
    Then season-long limits should be settable
    And weekly limits should be configurable
    And daily limits should be an option

  @settings @acquisition-limits
  Scenario: Display limit status
    Given limits are configured
    When viewing status
    Then current usage should display
    And remaining transactions should show
    And limit period should be clear

  @settings @daily-caps
  Scenario: Apply daily transaction caps
    Given daily caps are configured
    When the cap is reached
    Then further transactions should be blocked
    And cap status should display
    And reset time should be shown

  @settings @daily-caps
  Scenario: Track daily transaction usage
    Given daily tracking is enabled
    When viewing usage
    Then today's count should display
    And history should be available
    And reset timing should be clear

  @settings @roster-minimums
  Scenario: Enforce roster minimums
    Given roster minimums are set
    When a transaction would violate minimums
    Then the transaction should be blocked
    And the minimum should be displayed
    And correction should be required

  @settings @roster-minimums
  Scenario: Configure roster minimums
    Given minimum settings are available
    When configuring minimums
    Then per-position minimums should be settable
    And total roster minimum should be configurable
    And validation should apply to all transactions

  @settings @position-requirements
  Scenario: Apply position requirements
    Given position requirements exist
    When processing transactions
    Then requirements should be enforced
    And violations should be prevented
    And guidance should be provided

  @settings @position-requirements
  Scenario: Display position requirement status
    Given requirements are configured
    When viewing roster status
    Then current vs required should show
    And deficiencies should be highlighted
    And compliance should be indicated

  # ==================== Free Agent Interface ====================

  @interface @player-cards
  Scenario: Display player cards
    Given the free agent pool is shown
    When viewing players
    Then player cards should display
    And key info should be visible
    And actions should be accessible

  @interface @player-cards
  Scenario: Expand player card details
    Given a player card is shown
    When expanding details
    Then full stats should display
    And projections should show
    And news should be accessible

  @interface @mobile-interface
  Scenario: Access free agents on mobile
    Given mobile access is available
    When viewing on mobile
    Then interface should be responsive
    And all features should work
    And touch interactions should be smooth

  @interface @mobile-interface
  Scenario: Add free agent from mobile
    Given mobile pickup is enabled
    When adding a player
    Then the process should be streamlined
    And confirmation should work
    And roster should update

  @interface @quick-add
  Scenario: Use quick add feature
    Given quick add is enabled
    When viewing a player
    Then one-click add should be available
    And default settings should apply
    And confirmation should be minimal

  @interface @quick-add
  Scenario: Configure quick add settings
    Given quick add settings exist
    When configuring defaults
    Then default drop player should be settable
    And confirmation toggle should be available
    And preferences should save

  @interface @watchlist-integration
  Scenario: Add free agent to watchlist
    Given watchlist feature exists
    When adding to watchlist
    Then the player should be tracked
    And alerts should be configurable
    And availability changes should notify

  @interface @watchlist-integration
  Scenario: View watchlist players in pool
    Given watchlist players exist
    When viewing free agent pool
    Then watchlist players should be highlighted
    And quick access should be available
    And status should be prominent
