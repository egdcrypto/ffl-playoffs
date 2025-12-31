@rosters @platform
Feature: Rosters
  As a fantasy football league
  I need comprehensive roster management functionality
  So that owners can effectively manage their team rosters throughout the season

  Background:
    Given the roster system is operational
    And roster rules are configured for the league

  # ==================== Roster Configuration ====================

  @configuration @position-slots
  Scenario: Configure position slots
    Given league settings are accessible
    When configuring position slots
    Then slots should be configurable for each position
    And the configuration should be saved
    And all teams should receive the same structure

  @configuration @position-slots
  Scenario: Display position slot configuration
    Given positions are configured
    When viewing configuration
    Then the following should be shown
      | position    | slots | description           |
      | QB          | 1     | starting quarterback  |
      | RB          | 2     | starting running backs|
      | WR          | 2     | starting wide receivers|
      | TE          | 1     | starting tight end    |
      | FLEX        | 1     | RB/WR/TE flex         |
      | K           | 1     | kicker                |
      | DEF         | 1     | team defense          |

  @configuration @bench-size
  Scenario: Configure bench size
    Given bench settings are available
    When setting bench size
    Then the number of bench spots should be configurable
    And all teams should have equal bench sizes
    And the setting should apply league-wide

  @configuration @bench-size
  Scenario: Validate bench size limits
    Given bench size is being configured
    When setting the value
    Then minimum and maximum limits should apply
    And validation should prevent invalid values
    And warnings should appear for extreme values

  @configuration @ir-spots
  Scenario: Configure IR spots
    Given IR settings are available
    When configuring IR spots
    Then the number of IR slots should be settable
    And IR eligibility rules should be definable
    And the configuration should be saved

  @configuration @ir-spots
  Scenario: Set IR spot limits
    Given IR configuration is active
    When setting limits
    Then options should include
      | ir_option       | value           |
      | ir_spots        | 0, 1, 2, 3+     |
      | ir_plus         | enabled/disabled|
      | eligible_status | IR, IR-R, PUP, O|

  @configuration @taxi-squad
  Scenario: Configure taxi squad
    Given taxi squad settings exist
    When configuring taxi squad
    Then squad size should be configurable
    And eligibility rules should be settable
    And promotion rules should be definable

  @configuration @taxi-squad
  Scenario: Set taxi squad parameters
    Given taxi configuration is active
    When setting parameters
    Then options should include
      | parameter         | values              |
      | squad_size        | 0-5 players         |
      | eligibility       | rookies only, 1-2 yr|
      | promotion_deadline| week number         |

  @configuration @flex-positions
  Scenario: Configure flex positions
    Given flex settings are available
    When configuring flex slots
    Then eligible positions should be selectable
    And multiple flex slots should be supported
    And superflex options should be available

  @configuration @flex-positions
  Scenario: Set flex eligibility
    Given flex configuration is active
    When setting eligibility
    Then options should include
      | flex_type         | eligible_positions  |
      | FLEX              | RB, WR, TE          |
      | SUPERFLEX         | QB, RB, WR, TE      |
      | REC_FLEX          | WR, TE              |
      | IDP_FLEX          | DL, LB, DB          |

  # ==================== Roster Display ====================

  @display @active-lineup
  Scenario: Display active lineup
    Given an owner has a roster
    When viewing the active lineup
    Then all starting positions should be shown
    And players in each slot should be displayed
    And empty slots should be indicated

  @display @active-lineup
  Scenario: Show lineup player details
    Given the lineup is displayed
    When viewing a player
    Then player name should show
    And position eligibility should display
    And projected points should be visible

  @display @bench-players
  Scenario: Display bench players
    Given players are on the bench
    When viewing the bench
    Then all bench players should be listed
    And their positions should be shown
    And move-to-lineup options should be available

  @display @bench-players
  Scenario: Sort bench players
    Given bench has multiple players
    When sorting the bench
    Then sorting options should include
      | sort_option       | description         |
      | position          | grouped by position |
      | projected_points  | highest first       |
      | name              | alphabetical        |
      | acquisition_date  | most recent first   |

  @display @depth-chart
  Scenario: View roster depth chart
    Given a roster has players
    When viewing the depth chart
    Then players should be organized by position
    And depth should be visually clear
    And starters should be distinguished from backups

  @display @depth-chart
  Scenario: Analyze depth chart strength
    Given depth chart is displayed
    When analyzing strength
    Then position strength should be rated
    And depth concerns should be flagged
    And recommendations should be provided

  @display @position-groupings
  Scenario: Group players by position
    Given roster has multiple positions
    When viewing by position groups
    Then players should be grouped accordingly
    And group totals should display
    And position-specific stats should show

  @display @position-groupings
  Scenario: View position group details
    Given a position group is selected
    When viewing details
    Then all players at position should list
    And comparison should be available
    And usage recommendations should show

  # ==================== Roster Moves ====================

  @moves @slot-changes
  Scenario: Change player slot
    Given a player can move to another slot
    When moving the player
    Then the player should move to the new slot
    And the old slot should be vacated
    And the roster should update

  @moves @slot-changes
  Scenario: Swap players between slots
    Given two players can be swapped
    When swapping players
    Then both players should exchange slots
    And eligibility should be validated
    And the swap should be confirmed

  @moves @position-eligibility
  Scenario: Validate position eligibility
    Given a move is attempted
    When checking eligibility
    Then the player's eligible positions should be verified
    And ineligible moves should be blocked
    And alternative slots should be suggested

  @moves @position-eligibility
  Scenario: Display position eligibility
    Given a player is selected
    When viewing eligibility
    Then all eligible slots should be highlighted
    And ineligible slots should be dimmed
    And eligibility source should be shown

  @moves @lineup-optimization
  Scenario: Optimize lineup automatically
    Given lineup optimization is requested
    When optimizing the lineup
    Then the best players should be placed in starters
    And projections should drive placement
    And the result should maximize points

  @moves @lineup-optimization
  Scenario: Review optimization suggestions
    Given optimization is calculated
    When reviewing suggestions
    Then suggested changes should be listed
    And point impact should be shown
    And one-click apply should be available

  @moves @drag-drop
  Scenario: Use drag-and-drop interface
    Given the roster interface is active
    When dragging a player
    Then valid drop zones should highlight
    And the player should follow the cursor
    And dropping should execute the move

  @moves @drag-drop
  Scenario: Validate drag-and-drop moves
    Given a player is being dragged
    When hovering over slots
    Then valid slots should indicate eligibility
    And invalid slots should be restricted
    And release on valid slot should complete move

  # ==================== Roster Limits ====================

  @limits @maximum-size
  Scenario: Enforce maximum roster size
    Given maximum roster size is configured
    When the limit is reached
    Then additional adds should be blocked
    And the current count should be displayed
    And the limit should be clearly shown

  @limits @maximum-size
  Scenario: Display roster size status
    Given roster has players
    When viewing roster status
    Then current size should display
    And maximum should be shown
    And available spots should calculate

  @limits @position-limits
  Scenario: Enforce position limits
    Given position limits are configured
    When a limit is reached
    Then additional adds at that position should be blocked
    And current count should display
    And limit should be shown

  @limits @position-limits
  Scenario: Configure position limits
    Given position limit settings exist
    When configuring limits
    Then per-position maximums should be settable
    And minimums should be configurable
    And defaults should be available

  @limits @minimum-requirements
  Scenario: Enforce minimum requirements
    Given minimum requirements exist
    When roster would violate minimums
    Then the transaction should be blocked
    And the requirement should be displayed
    And correction should be required

  @limits @minimum-requirements
  Scenario: Display minimum requirement status
    Given minimums are configured
    When viewing compliance
    Then current vs required should show
    And deficiencies should be flagged
    And compliance should be indicated

  @limits @cap-compliance
  Scenario: Enforce salary cap compliance
    Given salary cap is enabled
    When a roster move would exceed cap
    Then the move should be blocked
    And cap status should display
    And required actions should be suggested

  @limits @cap-compliance
  Scenario: Display cap usage
    Given cap tracking is active
    When viewing cap status
    Then total cap should display
    And used cap should show
    And remaining cap should calculate

  # ==================== Injured Reserve Management ====================

  @ir @eligibility
  Scenario: Check IR eligibility
    Given a player has injury designation
    When checking IR eligibility
    Then eligible designations should qualify
    And ineligible players should be blocked
    And designation should be shown

  @ir @eligibility
  Scenario: Display IR eligibility rules
    Given IR rules are configured
    When viewing rules
    Then eligible designations should be listed
      | designation | eligible |
      | IR          | yes      |
      | IR-R        | yes      |
      | PUP         | yes      |
      | Out         | depends  |
      | Questionable| no       |

  @ir @ir-to-active
  Scenario: Move player from IR to active
    Given a player is on IR
    When moving to active roster
    Then roster space should be validated
    And the player should move to active
    And IR spot should be freed

  @ir @ir-to-active
  Scenario: Handle IR-to-active with full roster
    Given roster is full and IR return is needed
    When attempting the move
    Then a corresponding move should be required
    And options should be presented
    And the move should be contingent

  @ir @designation-tracking
  Scenario: Track injury designations
    Given players have designations
    When tracking designations
    Then current designations should display
    And changes should be logged
    And alerts should trigger on changes

  @ir @designation-tracking
  Scenario: Alert on designation changes
    Given designation tracking is active
    When a designation changes
    Then the owner should be notified
    And IR eligibility impact should be noted
    And required actions should be suggested

  @ir @return-timelines
  Scenario: Display return timelines
    Given injured players have return estimates
    When viewing timelines
    Then estimated return dates should show
    And confidence levels should be indicated
    And source information should be available

  @ir @return-timelines
  Scenario: Track return progress
    Given return timelines are tracked
    When viewing progress
    Then status updates should display
    And timeline changes should be noted
    And planning recommendations should be made

  # ==================== Taxi Squad ====================

  @taxi @rookie-eligibility
  Scenario: Determine taxi squad eligibility
    Given taxi rules are configured
    When evaluating eligibility
    Then rookie status should be checked
    And years of experience should be verified
    And eligible players should be identified

  @taxi @rookie-eligibility
  Scenario: Display taxi eligibility
    Given a player is being evaluated
    When checking taxi eligibility
    Then eligibility status should show
    And reason should be provided
    And remaining eligibility should be indicated

  @taxi @promotion
  Scenario: Promote player from taxi squad
    Given a player is on taxi squad
    When promoting to active roster
    Then roster space should be validated
    And the player should move to active
    And taxi spot should be freed

  @taxi @promotion
  Scenario: Handle promotion restrictions
    Given promotion rules exist
    When attempting promotion
    Then deadline restrictions should apply
    And one-way promotions should be enforced
    And violations should be blocked

  @taxi @squad-limits
  Scenario: Enforce taxi squad limits
    Given taxi squad size is limited
    When the limit is reached
    Then additional taxi additions should be blocked
    And current count should display
    And limit should be shown

  @taxi @squad-limits
  Scenario: Configure taxi squad limits
    Given taxi settings are available
    When configuring limits
    Then squad size should be settable
    And per-position limits should be optional
    And the configuration should save

  @taxi @development-tracking
  Scenario: Track player development on taxi
    Given players are on taxi squad
    When tracking development
    Then performance metrics should display
    And progress should be monitored
    And promotion recommendations should be made

  @taxi @development-tracking
  Scenario: View taxi squad analytics
    Given taxi analytics are available
    When viewing analytics
    Then player rankings should show
    And value assessments should display
    And breakout potential should be indicated

  # ==================== Roster Locks ====================

  @locks @game-time-locks
  Scenario: Apply game-time locks
    Given games are about to start
    When game time arrives
    Then affected players should lock
    And lock status should update
    And owners should be notified

  @locks @game-time-locks
  Scenario: Display game-time lock countdown
    Given a game is approaching
    When viewing lock status
    Then time until lock should display
    And countdown should update
    And warning should appear near lock time

  @locks @weekly-locks
  Scenario: Apply weekly roster locks
    Given weekly locks are configured
    When the lock time arrives
    Then all rosters should lock
    And no changes should be allowed
    And unlock time should be displayed

  @locks @weekly-locks
  Scenario: Configure weekly lock timing
    Given lock settings are available
    When configuring locks
    Then lock time should be settable
    And day of week should be configurable
    And exceptions should be definable

  @locks @individual-locks
  Scenario: Lock individual player
    Given commissioner can lock players
    When locking a specific player
    Then that player should be immovable
    And the lock should be displayed
    And unlock should be available

  @locks @individual-locks
  Scenario: View locked players
    Given players are locked
    When viewing locked players
    Then all locked players should list
    And lock reasons should show
    And unlock options should display for commissioner

  @locks @commissioner-overrides
  Scenario: Commissioner overrides lock
    Given a lock is in place
    When commissioner overrides
    Then the locked action should be allowed
    And the override should be logged
    And notification should be sent

  @locks @commissioner-overrides
  Scenario: Configure override permissions
    Given override settings exist
    When configuring permissions
    Then override types should be definable
    And approval requirements should be settable
    And logging should be mandatory

  # ==================== Roster Validation ====================

  @validation @lineup-legality
  Scenario: Validate lineup legality
    Given a lineup is set
    When validating legality
    Then all requirements should be checked
    And illegal lineups should be flagged
    And specific issues should be identified

  @validation @lineup-legality
  Scenario: Display lineup violations
    Given violations exist
    When displaying violations
    Then each violation should be listed
    And correction guidance should be provided
    And one-click fixes should be offered

  @validation @bye-week-conflicts
  Scenario: Detect bye week conflicts
    Given starters have bye weeks
    When checking for conflicts
    Then bye week players in lineup should be flagged
    And warnings should be prominent
    And replacement suggestions should be made

  @validation @bye-week-conflicts
  Scenario: Show bye week schedule
    Given roster has multiple bye weeks
    When viewing bye schedule
    Then upcoming byes should be displayed
    And affected weeks should be highlighted
    And planning tools should be available

  @validation @injury-warnings
  Scenario: Display injury warnings
    Given players have injury designations
    When viewing the lineup
    Then injured starters should be flagged
    And injury status should be shown
    And alternatives should be suggested

  @validation @injury-warnings
  Scenario: Configure injury alert thresholds
    Given injury settings exist
    When configuring alerts
    Then options should include
      | designation | alert_level |
      | Out         | critical    |
      | Doubtful    | high        |
      | Questionable| medium      |
      | Probable    | low         |

  @validation @empty-slots
  Scenario: Alert on empty starting slots
    Given a starting slot is empty
    When viewing the lineup
    Then empty slots should be prominently flagged
    And available players should be suggested
    And one-click fill should be available

  @validation @empty-slots
  Scenario: Prevent submission with empty slots
    Given lineup has empty required slots
    When attempting to finalize
    Then a warning should appear
    And confirmation should be required
    And the issue should be clearly stated

  # ==================== Roster History ====================

  @history @transaction-history
  Scenario: View transaction history
    Given roster transactions have occurred
    When viewing history
    Then all transactions should be listed
    And details should be accessible
    And filtering should be available

  @history @transaction-history
  Scenario: Filter transaction history
    Given extensive history exists
    When filtering transactions
    Then filters should include
      | filter_type       | options                 |
      | transaction_type  | add, drop, trade, claim |
      | date_range        | from/to dates           |
      | player            | specific player         |

  @history @lineup-changes
  Scenario: Track lineup changes
    Given lineup changes occur
    When viewing change history
    Then all changes should be logged
    And before/after should be visible
    And change reasons should be noted

  @history @lineup-changes
  Scenario: Compare lineup across weeks
    Given multi-week history exists
    When comparing lineups
    Then week-by-week comparison should show
    And changes should be highlighted
    And performance impact should be noted

  @history @historical-rosters
  Scenario: View historical rosters
    Given past rosters are archived
    When viewing historical rosters
    Then rosters from any week should be viewable
    And the state at that time should be accurate
    And navigation should be intuitive

  @history @historical-rosters
  Scenario: Analyze roster evolution
    Given season history exists
    When analyzing evolution
    Then roster changes over time should display
    And acquisition patterns should be visible
    And strategy insights should be provided

  @history @season-archives
  Scenario: Access season archives
    Given multi-season data exists
    When accessing archives
    Then past seasons should be viewable
    And final rosters should be preserved
    And championship rosters should be highlighted

  @history @season-archives
  Scenario: Compare rosters across seasons
    Given multiple seasons are archived
    When comparing seasons
    Then side-by-side comparison should be available
    And retention should be calculated
    And changes should be tracked

  # ==================== Roster Import/Export ====================

  @import-export @roster-sharing
  Scenario: Share roster with others
    Given sharing is enabled
    When sharing a roster
    Then a shareable link should be generated
    And view permissions should be configurable
    And expiration should be settable

  @import-export @roster-sharing
  Scenario: View shared roster
    Given a roster is shared
    When viewing the shared roster
    Then the roster should display accurately
    And the viewer should be identified
    And edit restrictions should apply

  @import-export @csv-export
  Scenario: Export roster to CSV
    Given export is requested
    When exporting to CSV
    Then a CSV file should be generated
    And all roster data should be included
    And format should be consistent

  @import-export @csv-export
  Scenario: Configure CSV export options
    Given export options exist
    When configuring export
    Then options should include
      | option            | description             |
      | include_stats     | player statistics       |
      | include_salary    | salary information      |
      | include_contract  | contract details        |
      | include_history   | transaction history     |

  @import-export @league-transfer
  Scenario: Transfer roster to another league
    Given league transfer is supported
    When transferring roster
    Then roster data should be exportable
    And format should be compatible
    And import should be seamless

  @import-export @league-transfer
  Scenario: Import roster from another league
    Given an import file exists
    When importing roster
    Then player matching should occur
    And conflicts should be flagged
    And confirmation should be required

  @import-export @backup-restore
  Scenario: Backup roster data
    Given backup is requested
    When creating backup
    Then a complete backup should be generated
    And all roster data should be preserved
    And the backup should be downloadable

  @import-export @backup-restore
  Scenario: Restore roster from backup
    Given a backup exists
    When restoring from backup
    Then roster should be restored to backup state
    And confirmation should be required
    And current roster should be optionally preserved

  # ==================== Roster Interface ====================

  @interface @roster-view
  Scenario: Display comprehensive roster view
    Given a roster exists
    When viewing the roster
    Then all sections should be visible
    And navigation should be intuitive
    And key information should be prominent

  @interface @roster-view
  Scenario: Customize roster display
    Given customization options exist
    When customizing display
    Then layout should be adjustable
    And columns should be selectable
    And preferences should be saved

  @interface @mobile-roster
  Scenario: Manage roster on mobile
    Given mobile access is available
    When managing roster on mobile
    Then interface should be responsive
    And all features should work
    And touch interactions should be smooth

  @interface @mobile-roster
  Scenario: Make lineup changes on mobile
    Given mobile is being used
    When making changes
    Then moves should process correctly
    And confirmation should work
    And feedback should be clear

  @interface @quick-actions
  Scenario: Access quick roster actions
    Given quick actions are available
    When accessing actions
    Then common actions should be prominent
    And one-click operations should work
    And efficiency should be prioritized

  @interface @quick-actions
  Scenario: Configure quick action preferences
    Given action settings exist
    When configuring preferences
    Then default actions should be settable
    And shortcuts should be configurable
    And the configuration should save
