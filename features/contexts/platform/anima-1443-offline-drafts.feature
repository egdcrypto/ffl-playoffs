@offline-drafts @platform
Feature: Offline Drafts
  As a fantasy football league
  I need comprehensive offline draft functionality
  So that leagues can conduct in-person drafts and sync results to the platform

  Background:
    Given the offline draft system is operational
    And offline draft tools are available

  # ==================== Manual Draft Entry ====================

  @manual-entry @commissioner-input
  Scenario: Enter draft picks manually
    Given the commissioner is entering draft results
    When inputting a pick
    Then the player, team, and pick number should be recorded
    And the entry should be validated

  @manual-entry @commissioner-input
  Scenario: Navigate draft entry interface
    Given the draft entry screen is open
    When entering picks
    Then the interface should support efficient entry
    And keyboard shortcuts should be available

  @manual-entry @pick-by-pick-entry
  Scenario: Enter picks one at a time
    Given the draft is being entered sequentially
    When entering each pick
    Then the system should track current position
    And auto-advance to the next pick

  @manual-entry @pick-by-pick-entry
  Scenario: Search for players during entry
    Given a pick is being entered
    When searching for a player
    Then search results should appear instantly
    And the player can be selected

  @manual-entry @bulk-import
  Scenario: Import multiple picks at once
    Given bulk entry is preferred
    When pasting multiple picks
    Then all picks should be parsed
    And they should be validated together

  @manual-entry @bulk-import
  Scenario: Handle bulk import errors
    Given bulk data contains errors
    When importing
    Then errors should be identified
    And the user should be prompted to correct them

  @manual-entry @draft-order-setup
  Scenario: Configure draft order before entry
    Given the draft order is known
    When setting up the order
    Then teams can be arranged in draft order
    And the order should be saved

  @manual-entry @draft-order-setup
  Scenario: Use snake draft order
    Given a snake draft was conducted
    When configuring order
    Then snake pattern should be applied
    And pick assignments should be correct

  # ==================== Offline Draft Board ====================

  @offline-board @printable-boards
  Scenario: Generate printable draft board
    Given an in-person draft is planned
    When generating printable board
    Then a PDF should be created
    And the layout should be suitable for printing

  @offline-board @printable-boards
  Scenario: Configure print settings
    Given printing preferences vary
    When configuring print options
    Then options should include
      | option          | values                    |
      | paper_size      | letter, legal, tabloid    |
      | orientation     | portrait, landscape       |
      | columns         | by round, by team         |
      | include_adp     | yes, no                   |

  @offline-board @physical-draft-support
  Scenario: Support physical draft tracking
    Given a physical draft board is used
    When tracking picks
    Then the board should mirror physical state
    And manual adjustments should be easy

  @offline-board @physical-draft-support
  Scenario: Provide player stickers/labels
    Given stickers aid physical drafts
    When generating stickers
    Then player labels should be printable
    And they should fit common sticker sheets

  @offline-board @board-templates
  Scenario: Access board templates
    Given different board styles exist
    When selecting a template
    Then template options should be available
      | template_type    | description               |
      | standard_grid    | rows by round, cols by team|
      | compact          | condensed for small spaces|
      | detailed         | includes player stats     |
      | auction          | includes bid amounts      |

  @offline-board @board-templates
  Scenario: Customize board template
    Given templates can be modified
    When customizing a template
    Then layout elements can be adjusted
    And custom templates can be saved

  @offline-board @customizable-layouts
  Scenario: Create custom board layout
    Given a unique layout is wanted
    When designing the layout
    Then drag-and-drop should be available
    And the layout should be exportable

  @offline-board @customizable-layouts
  Scenario: Include league branding
    Given leagues have branding
    When creating the board
    Then league logo should be includable
    And custom colors should be supported

  # ==================== Draft Import Tools ====================

  @import-tools @csv-excel-import
  Scenario: Import draft from CSV file
    Given draft results are in CSV format
    When uploading the file
    Then the file should be parsed
    And picks should be mapped to players

  @import-tools @csv-excel-import
  Scenario: Import draft from Excel file
    Given draft results are in Excel format
    When uploading the file
    Then Excel format should be supported
    And all sheets should be accessible

  @import-tools @third-party-sync
  Scenario: Sync from third-party platform
    Given the draft was conducted elsewhere
    When syncing from third-party
    Then supported platforms should include
      | platform     | sync_method           |
      | ESPN         | API/manual            |
      | Yahoo        | API/manual            |
      | Sleeper      | API                   |
      | NFL.com      | manual import         |

  @import-tools @third-party-sync
  Scenario: Map third-party player IDs
    Given player IDs differ across platforms
    When importing
    Then IDs should be mapped automatically
    And unmapped players should be flagged

  @import-tools @copy-paste-entry
  Scenario: Enter draft via copy-paste
    Given results are in text format
    When pasting text
    Then the system should parse the content
    And picks should be extracted

  @import-tools @copy-paste-entry
  Scenario: Handle various text formats
    Given text formats vary
    When parsing pasted text
    Then common formats should be recognized
      | format_type      | example                     |
      | comma_separated  | Team A, Patrick Mahomes, QB |
      | tab_separated    | Team A\tPatrick Mahomes\tQB |
      | line_by_line     | 1.01 Patrick Mahomes - Team A|

  @import-tools @format-validation
  Scenario: Validate import format
    Given data is being imported
    When validating the format
    Then format errors should be detected
    And guidance should be provided

  @import-tools @format-validation
  Scenario: Preview import before confirming
    Given data is parsed
    When previewing import
    Then all picks should be displayed
    And the user should confirm before finalizing

  # ==================== Post-Draft Roster Sync ====================

  @roster-sync @roster-finalization
  Scenario: Finalize rosters after import
    Given draft results are entered
    When finalizing rosters
    Then all teams should receive their players
    And rosters should be locked

  @roster-sync @roster-finalization
  Scenario: Confirm roster assignments
    Given rosters are set
    When reviewing assignments
    Then each team should verify their roster
    And discrepancies should be flagged

  @roster-sync @player-assignment-verification
  Scenario: Verify player assignments
    Given players are assigned to teams
    When verifying assignments
    Then each pick should be confirmed
    And assignment accuracy should be validated

  @roster-sync @player-assignment-verification
  Scenario: Display verification checklist
    Given verification is needed
    When viewing checklist
    Then all teams and picks should be listed
    And checkboxes should track verification

  @roster-sync @duplicate-detection
  Scenario: Detect duplicate player assignments
    Given data entry errors can occur
    When checking for duplicates
    Then any player on multiple teams should be flagged
    And resolution should be required

  @roster-sync @duplicate-detection
  Scenario: Resolve duplicate assignments
    Given a duplicate is detected
    When resolving the duplicate
    Then the correct assignment should be selected
    And the incorrect one should be removed

  @roster-sync @error-correction
  Scenario: Correct entry errors
    Given an error is discovered
    When correcting the error
    Then the pick should be editable
    And changes should be logged

  @roster-sync @error-correction
  Scenario: Maintain audit trail
    Given corrections are made
    When viewing history
    Then all changes should be logged
    And original entries should be preserved

  # ==================== Offline Draft Scheduling ====================

  @scheduling @draft-date-recording
  Scenario: Record draft date
    Given the offline draft occurred
    When recording the date
    Then the date should be saved
    And it should appear in draft history

  @scheduling @draft-date-recording
  Scenario: Set future draft date
    Given a draft is planned
    When setting the date
    Then the date should be scheduled
    And reminders should be configurable

  @scheduling @location-tracking
  Scenario: Record draft location
    Given the draft has a location
    When entering location details
    Then the location should be saved
    And it should be visible to league members

  @scheduling @location-tracking
  Scenario: Include location details
    Given location information is available
    When entering details
    Then information should include
      | detail          | example                   |
      | venue_name      | Joe's Sports Bar          |
      | address         | 123 Main St               |
      | room            | Private Room B            |
      | notes           | Parking in back           |

  @scheduling @event-details
  Scenario: Capture draft event details
    Given the draft event has details
    When entering event information
    Then details should be recorded
      | detail          | configurable |
      | start_time      | yes          |
      | end_time        | yes          |
      | dress_code      | optional     |
      | food_drink      | optional     |

  @scheduling @event-details
  Scenario: Share event details with league
    Given event details are entered
    When sharing with league
    Then all members should receive details
    And the information should be accessible

  @scheduling @calendar-integration
  Scenario: Add draft to calendar
    Given calendar integration is available
    When adding to calendar
    Then calendar events should be created
    And invites should be sent

  @scheduling @calendar-integration
  Scenario: Support calendar platforms
    Given multiple calendar systems exist
    When integrating
    Then supported platforms should include
      | platform        | integration_type |
      | Google Calendar | direct           |
      | Apple Calendar  | ICS file         |
      | Outlook         | direct/ICS       |

  # ==================== Draft Result Recording ====================

  @result-recording @round-by-round-entry
  Scenario: Enter results by round
    Given rounds are being entered
    When entering a round
    Then all picks in the round should be enterable
    And round completion should be tracked

  @result-recording @round-by-round-entry
  Scenario: Navigate between rounds
    Given multiple rounds exist
    When navigating rounds
    Then round selection should be easy
    And progress should be visible

  @result-recording @pick-timestamps
  Scenario: Record pick timestamps
    Given timing data is available
    When entering picks with times
    Then timestamps should be recorded
    And draft duration should be calculable

  @result-recording @pick-timestamps
  Scenario: Calculate pick durations
    Given timestamps are recorded
    When analyzing timing
    Then pick-by-pick durations should be available
    And statistics should be generated

  @result-recording @trade-documentation
  Scenario: Document draft day trades
    Given trades occurred during draft
    When documenting trades
    Then trade details should be recorded
    And pick assignments should update

  @result-recording @trade-documentation
  Scenario: Record trade details
    Given a trade is being documented
    When entering trade information
    Then details should include
      | detail          | required |
      | teams_involved  | yes      |
      | picks_traded    | yes      |
      | players_traded  | if any   |
      | trade_time      | optional |

  @result-recording @keeper-designations
  Scenario: Mark keeper picks
    Given keepers were part of the draft
    When entering keeper picks
    Then they should be marked as keepers
    And keeper costs should be recorded

  @result-recording @keeper-designations
  Scenario: Distinguish keepers from draft picks
    Given keepers and draft picks exist
    When viewing results
    Then keepers should be clearly identified
    And they should show keeper details

  # ==================== Commissioner Validation ====================

  @validation @pick-verification
  Scenario: Verify all picks are valid
    Given draft results are entered
    When validating picks
    Then all picks should be checked
    And invalid picks should be flagged

  @validation @pick-verification
  Scenario: Check player availability
    Given picks are being validated
    When checking availability
    Then unavailable players should be identified
    And alternatives should be suggested

  @validation @roster-legality
  Scenario: Verify roster legality
    Given rosters are complete
    When checking legality
    Then roster rules should be verified
    And illegal rosters should be flagged

  @validation @roster-legality
  Scenario: Display roster rule violations
    Given violations are found
    When displaying violations
    Then specific rules should be cited
    And correction guidance should be provided

  @validation @position-limits
  Scenario: Enforce position limits
    Given position limits are set
    When validating rosters
    Then limits should be checked
      | position | limit | action_if_exceeded |
      | QB       | 3     | flag for correction|
      | RB       | 8     | flag for correction|
      | WR       | 8     | flag for correction|
      | TE       | 3     | flag for correction|

  @validation @position-limits
  Scenario: Handle position limit violations
    Given a limit is exceeded
    When handling the violation
    Then the commissioner should be alerted
    And resolution options should be provided

  @validation @budget-validation
  Scenario: Validate auction budgets
    Given an auction draft was conducted
    When validating budgets
    Then spending should be within limits
    And overspending should be flagged

  @validation @budget-validation
  Scenario: Display budget summaries
    Given budgets are validated
    When viewing summaries
    Then each team's spending should be shown
    And compliance status should be indicated

  # ==================== Draft History Import ====================

  @history-import @previous-season-imports
  Scenario: Import previous season draft
    Given historical draft data exists
    When importing previous draft
    Then the draft should be loaded
    And historical context should be available

  @history-import @previous-season-imports
  Scenario: Map previous season players
    Given players change teams/status
    When importing historical data
    Then player references should be updated
    And retired players should be noted

  @history-import @historical-draft-data
  Scenario: Access historical draft data
    Given multiple seasons of data exist
    When viewing history
    Then all seasons should be accessible
    And data should be searchable

  @history-import @historical-draft-data
  Scenario: Analyze historical trends
    Given historical data is available
    When analyzing trends
    Then draft pattern analysis should be available
    And insights should be generated

  @history-import @legacy-system-migration
  Scenario: Migrate from legacy system
    Given data exists in old system
    When migrating
    Then data should be extracted
    And it should be imported to new system

  @history-import @legacy-system-migration
  Scenario: Handle legacy data formats
    Given old formats differ
    When processing legacy data
    Then format conversion should occur
    And data integrity should be maintained

  @history-import @archive-access
  Scenario: Access draft archives
    Given archives are maintained
    When accessing archives
    Then historical drafts should be viewable
    And data should be read-only

  @history-import @archive-access
  Scenario: Search draft archives
    Given extensive archives exist
    When searching archives
    Then search should find specific drafts
    And results should be filterable

  # ==================== Offline Draft Reports ====================

  @draft-reports @recap-generation
  Scenario: Generate draft recap
    Given the draft is entered
    When generating recap
    Then a comprehensive recap should be created
    And it should be shareable

  @draft-reports @recap-generation
  Scenario: Customize recap content
    Given recap preferences vary
    When customizing
    Then content options should include
      | content_type       | includable |
      | pick_by_pick       | yes        |
      | team_summaries     | yes        |
      | notable_picks      | yes        |
      | trade_summary      | yes        |

  @draft-reports @team-summaries
  Scenario: Generate team summaries
    Given teams have drafted
    When generating summaries
    Then each team should have a summary
    And key stats should be included

  @draft-reports @team-summaries
  Scenario: Compare team summaries
    Given summaries are generated
    When comparing teams
    Then side-by-side comparison should be available
    And strengths/weaknesses should be highlighted

  @draft-reports @grade-calculations
  Scenario: Calculate draft grades
    Given draft analysis is available
    When calculating grades
    Then grades should be assigned
    And methodology should be transparent

  @draft-reports @grade-calculations
  Scenario: Display grade breakdown
    Given grades are calculated
    When viewing breakdown
    Then category scores should be shown
      | category          | weight |
      | value_picks       | 30%    |
      | positional_balance| 25%    |
      | star_power        | 25%    |
      | depth_quality     | 20%    |

  @draft-reports @pick-analysis
  Scenario: Analyze individual picks
    Given picks are recorded
    When analyzing picks
    Then pick-level analysis should be available
    And value assessments should be included

  @draft-reports @pick-analysis
  Scenario: Identify best and worst picks
    Given analysis is complete
    When identifying extremes
    Then best picks should be highlighted
    And reaches should be noted

  # ==================== Hybrid Draft Support ====================

  @hybrid-draft @partial-modes
  Scenario: Support partial online/offline modes
    Given some picks are online, some offline
    When managing hybrid draft
    Then both modes should be supported
    And transitions should be seamless

  @hybrid-draft @partial-modes
  Scenario: Switch between online and offline
    Given mode switching is needed
    When switching modes
    Then the transition should be smooth
    And no data should be lost

  @hybrid-draft @mid-draft-transitions
  Scenario: Transition mid-draft
    Given the draft changes mode
    When transitioning
    Then progress should be preserved
    And all participants should be synced

  @hybrid-draft @mid-draft-transitions
  Scenario: Handle in-progress picks during transition
    Given a pick is in progress
    When mode changes
    Then the pick should complete properly
    And timing should be handled

  @hybrid-draft @sync-conflict-resolution
  Scenario: Resolve sync conflicts
    Given online and offline data differ
    When resolving conflicts
    Then conflicts should be identified
    And resolution options should be provided

  @hybrid-draft @sync-conflict-resolution
  Scenario: Display conflict details
    Given conflicts exist
    When viewing conflicts
    Then both versions should be shown
    And differences should be highlighted

  @hybrid-draft @backup-restoration
  Scenario: Restore from backup
    Given data loss occurs
    When restoring backup
    Then the most recent backup should be available
    And restoration should be complete

  @hybrid-draft @backup-restoration
  Scenario: Manage backup versions
    Given multiple backups exist
    When selecting backup
    Then backup versions should be listed
    And point-in-time restore should be possible
