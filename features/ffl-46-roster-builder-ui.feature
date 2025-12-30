@ui @roster @builder @frontend
Feature: Roster Builder UI
  As a fantasy football player
  I want to build and manage my roster through an intuitive interface
  So that I can select NFL players for each position slot on my team

  Background:
    Given I am authenticated as a player
    And I am a member of an active league
    And the current week is open for roster changes
    And NFL player data is available

  # =============================================================================
  # ROSTER BUILDER LAYOUT
  # =============================================================================

  @layout @structure
  Scenario: Display roster builder interface
    Given I navigate to the roster builder page
    When the page loads
    Then I should see the roster builder with sections:
      | Section               | Description                          |
      | Position slots        | Visual roster with position slots    |
      | Player search         | Search and filter NFL players        |
      | Available players     | List of available players            |
      | My roster             | Current roster selections            |
      | Roster status         | Lock status and deadline info        |

  @layout @positions
  Scenario: Display position slots for roster
    Given I am on the roster builder page
    When I view the position slots section
    Then I should see the following position slots:
      | Position | Slots | Description                    |
      | QB       | 1     | Quarterback                    |
      | RB       | 2     | Running Back                   |
      | WR       | 2     | Wide Receiver                  |
      | TE       | 1     | Tight End                      |
      | FLEX     | 1     | RB/WR/TE                       |
      | K        | 1     | Kicker                         |
      | DEF      | 1     | Team Defense                   |
    And each slot should show its current player or "Empty"

  @layout @slot-display
  Scenario: Display player information in filled slot
    Given I have a player assigned to the QB position
    When I view the QB slot
    Then the slot should display:
      | Information           | Example                          |
      | Player name           | Patrick Mahomes                  |
      | Team                  | KC                               |
      | Position              | QB                               |
      | Opponent              | vs DEN                           |
      | Game time             | Sun 1:00 PM                      |
      | Projected points      | 22.5                             |
    And I should see a remove button

  @layout @empty-slot
  Scenario: Display empty position slot
    Given I have no player assigned to the RB1 position
    When I view the RB1 slot
    Then the slot should display:
      | Element               | Description                      |
      | Position label        | RB1                              |
      | Empty indicator       | "Select Player" or "+"           |
      | Click target          | Clickable to add player          |
    And clicking should focus the search on RB players

  @layout @responsive
  Scenario: Roster builder is responsive
    Given I am on the roster builder page
    When I view on different screen sizes
    Then the layout should adapt:
      | Screen Size    | Layout                              |
      | Desktop        | Side-by-side roster and search      |
      | Tablet         | Stacked with collapsible sections   |
      | Mobile         | Full-width single column            |

  # =============================================================================
  # NFL PLAYER SEARCH
  # =============================================================================

  @search @basic
  Scenario: Search for NFL players by name
    Given I am on the roster builder page
    When I type "Mahomes" in the player search field
    Then the search results should filter to show players matching "Mahomes"
    And the results should update as I type (debounced)
    And each result should show player name, team, and position

  @search @autocomplete
  Scenario: Search autocomplete suggestions
    Given I am on the roster builder page
    When I type "Pat" in the player search field
    Then I should see autocomplete suggestions:
      | Suggestion            | Details                          |
      | Patrick Mahomes       | QB - KC                          |
      | Patrick Surtain II    | CB - DEN                         |
      | Pat Freiermuth        | TE - PIT                         |
    And I can select a suggestion to view player details

  @search @filters
  Scenario: Filter players by position
    Given I am on the roster builder page
    When I click on position filter buttons
    Then I should be able to filter by:
      | Filter                | Shows                            |
      | All                   | All available players            |
      | QB                    | Only quarterbacks                |
      | RB                    | Only running backs               |
      | WR                    | Only wide receivers              |
      | TE                    | Only tight ends                  |
      | K                     | Only kickers                     |
      | DEF                   | Only team defenses               |
    And filters should be visually indicated when active

  @search @team-filter
  Scenario: Filter players by NFL team
    Given I am on the roster builder page
    When I select a team from the team filter dropdown
    Then only players from that team should be displayed
    And I should be able to clear the team filter

  @search @availability
  Scenario: Filter by player availability
    Given I am on the roster builder page
    When I toggle availability filters
    Then I should be able to show:
      | Filter                | Description                      |
      | Available only        | Not on any roster in league      |
      | All players           | Including rostered players       |
      | Free agents           | Never been rostered              |

  @search @sort
  Scenario: Sort player search results
    Given I am viewing player search results
    When I click on sort options
    Then I should be able to sort by:
      | Sort Option           | Order                            |
      | Projected points      | Highest to lowest                |
      | Name                  | Alphabetical                     |
      | Team                  | By team name                     |
      | Bye week              | By bye week number               |
    And the current sort should be indicated

  @search @results
  Scenario: Display player search results
    Given I have searched for players
    When I view the results list
    Then each player card should display:
      | Information           | Description                      |
      | Player photo          | Headshot or placeholder          |
      | Player name           | Full name                        |
      | Position              | QB, RB, WR, etc.                 |
      | Team                  | Team abbreviation                |
      | Opponent              | This week's opponent             |
      | Projected points      | Weekly projection                |
      | Status                | Available/Rostered               |
      | Add button            | If available                     |

  @search @pagination
  Scenario: Paginate player search results
    Given search results exceed page size
    When I view the results
    Then I should see pagination controls:
      | Control               | Function                         |
      | Page numbers          | Jump to specific page            |
      | Next/Previous         | Navigate pages                   |
      | Items per page        | 10, 25, 50 options               |
    And results should load without full page refresh

  @search @performance
  Scenario: Search performs efficiently
    Given I am searching for players
    When I type in the search field
    Then search should:
      | Performance           | Requirement                      |
      | Debounce input        | Wait 300ms before searching      |
      | Show loading          | Indicate search in progress      |
      | Cache results         | Avoid redundant API calls        |
      | Cancel pending        | Cancel old requests on new input |

  # =============================================================================
  # ADD PLAYER FUNCTIONALITY
  # =============================================================================

  @add @basic
  Scenario: Add player to empty roster slot
    Given I have an empty RB slot
    And I have searched for running backs
    When I click "Add" on an available RB player
    Then the player should be added to my RB slot
    And the player should be removed from search results
    And I should see a success notification
    And my roster should update in real-time

  @add @position-select
  Scenario: Add player with position slot selection
    Given I have multiple empty FLEX-eligible slots
    When I click "Add" on a WR player
    Then I should see a slot selection modal:
      | Slot                  | Status                           |
      | WR1                   | Available                        |
      | WR2                   | Available                        |
      | FLEX                  | Available                        |
    And I can select which slot to assign the player

  @add @confirmation
  Scenario: Confirm player addition
    Given I am adding a player to my roster
    When the add action completes
    Then I should see:
      | Feedback              | Description                      |
      | Success toast         | "Player added to roster"         |
      | Slot update           | Player appears in slot           |
      | Search refresh        | Player no longer available       |

  @add @validation
  Scenario: Prevent adding ineligible player
    Given my RB slots are full
    When I try to add another RB player
    Then I should see an error message:
      | Error                 | Message                          |
      | Position full         | "No available RB slots"          |
    And the add button should be disabled or hidden for RBs
    And I should be prompted to drop a player first

  @add @quick-add
  Scenario: Quick add from player card
    Given I am viewing a player card
    When I click the quick add button
    Then if only one valid slot exists, add immediately
    And if multiple slots, show slot selection
    And provide visual feedback during the operation

  # =============================================================================
  # DROP PLAYER FUNCTIONALITY
  # =============================================================================

  @drop @basic
  Scenario: Drop player from roster slot
    Given I have a player in my WR1 slot
    When I click the "Drop" or "X" button on the slot
    Then I should see a confirmation dialog:
      | Element               | Content                          |
      | Title                 | "Drop Player?"                   |
      | Message               | "Remove {Player} from roster?"   |
      | Confirm button        | "Drop"                           |
      | Cancel button         | "Cancel"                         |

  @drop @confirmation
  Scenario: Confirm player drop
    Given I have clicked drop on a player
    When I confirm the drop action
    Then the player should be removed from my roster
    And the slot should show as empty
    And the player should become available for others
    And I should see a success notification

  @drop @cancel
  Scenario: Cancel player drop
    Given I have clicked drop on a player
    When I click "Cancel" in the confirmation dialog
    Then the player should remain on my roster
    And the dialog should close
    And no changes should be made

  @drop @swap
  Scenario: Drop and add in one transaction
    Given I have a player in my QB slot
    And I want to add a different QB
    When I click "Add" on the new QB
    Then I should see a swap confirmation:
      | Element               | Content                          |
      | Current player        | Patrick Mahomes                  |
      | New player            | Josh Allen                       |
      | Action                | "Swap Players"                   |
    And confirming should drop old and add new atomically

  # =============================================================================
  # ROSTER LOCK STATUS
  # =============================================================================

  @lock @display
  Scenario: Display roster lock status
    Given I am on the roster builder page
    When I view the roster status section
    Then I should see:
      | Information           | Description                      |
      | Lock status           | "Rosters Open" or "Rosters Locked" |
      | Deadline              | "Locks in 2h 30m" or countdown   |
      | Week indicator        | "Week 15 Roster"                 |

  @lock @countdown
  Scenario: Display countdown to roster lock
    Given rosters lock in 2 hours
    When I view the roster status
    Then I should see a countdown timer
    And the timer should update in real-time
    And as deadline approaches, urgency should increase:
      | Time Remaining        | Display                          |
      | > 1 hour              | Normal display                   |
      | < 1 hour              | Yellow warning                   |
      | < 15 minutes          | Red urgent warning               |

  @lock @locked-state
  Scenario: Display locked roster state
    Given rosters are locked for the current week
    When I view the roster builder
    Then I should see:
      | Element               | State                            |
      | Add buttons           | Disabled                         |
      | Drop buttons          | Disabled                         |
      | Status message        | "Rosters are locked"             |
      | Next unlock           | When rosters unlock next         |
    And the UI should clearly indicate locked state

  @lock @game-started
  Scenario: Lock individual player after game starts
    Given player's game has started
    When I view that player's slot
    Then the player should show:
      | Indicator             | Description                      |
      | Lock icon             | Player is locked                 |
      | Game status           | "In Progress" or "Final"         |
      | Score                 | If game in progress              |
    And I cannot drop this player until next week

  @lock @mixed-state
  Scenario: Display mixed lock states
    Given some games have started and others haven't
    When I view my roster
    Then I should see:
      | Player State          | Display                          |
      | Game not started      | Editable, can drop               |
      | Game started          | Locked, game status shown        |
      | Bye week              | Editable, shows "BYE"            |

  # =============================================================================
  # PLAYER DETAILS
  # =============================================================================

  @details @modal
  Scenario: View detailed player information
    Given I am viewing a player in search or roster
    When I click on the player card/name
    Then a player details modal should open with:
      | Section               | Information                      |
      | Header                | Photo, name, team, position      |
      | This week             | Opponent, time, projection       |
      | Season stats          | Key statistics                   |
      | Recent performance    | Last 3-5 games                   |
      | News                  | Recent news/injury updates       |
      | Schedule              | Upcoming opponents               |

  @details @stats
  Scenario: Display player statistics
    Given I am viewing player details
    When I view the stats section
    Then I should see relevant stats by position:
      | Position | Stats Shown                          |
      | QB       | Pass yards, TDs, INTs, Rush yards    |
      | RB       | Rush yards, Rush TDs, Rec, Rec yards |
      | WR       | Rec, Rec yards, Rec TDs, Targets     |
      | TE       | Rec, Rec yards, Rec TDs, Targets     |
      | K        | FG made, FG %, XP made               |
      | DEF      | Sacks, INTs, Points allowed          |

  @details @injury
  Scenario: Display injury status
    Given a player has an injury designation
    When I view the player
    Then I should see injury information:
      | Status                | Display                          |
      | Questionable          | Yellow "Q" indicator             |
      | Doubtful              | Orange "D" indicator             |
      | Out                   | Red "O" indicator                |
      | IR                    | Red "IR" indicator               |
    And hovering should show injury details

  @details @news
  Scenario: Display player news
    Given a player has recent news
    When I view player details
    Then I should see:
      | News Element          | Description                      |
      | Headlines             | Recent news headlines            |
      | Date                  | When news was published          |
      | Source                | News source                      |
      | Impact                | Fantasy impact analysis          |

  # =============================================================================
  # MY ROSTER VIEW
  # =============================================================================

  @roster @summary
  Scenario: Display roster summary
    Given I have players on my roster
    When I view the my roster section
    Then I should see:
      | Summary               | Description                      |
      | Total projected       | Sum of player projections        |
      | Roster completeness   | 8/9 slots filled                 |
      | Bye week conflicts    | Players on bye this week         |

  @roster @projections
  Scenario: Display projected points
    Given I have a complete roster
    When I view projected points
    Then I should see:
      | Projection            | Display                          |
      | Per player            | Individual projections           |
      | Total                 | Sum of all projections           |
      | Rank                  | My rank vs league                |

  @roster @bye-week
  Scenario: Highlight bye week players
    Given I have a player on bye this week
    When I view my roster
    Then the bye week player should:
      | Indicator             | Description                      |
      | Visual badge          | "BYE" label                      |
      | Grayed out            | Visual distinction               |
      | Zero projection       | 0 points for this week           |
      | Warning               | Alert to replace player          |

  @roster @empty-slots
  Scenario: Highlight empty roster slots
    Given I have empty roster slots
    When I view my roster
    Then empty slots should:
      | Indicator             | Description                      |
      | Visual highlight      | Dashed border or highlight       |
      | Call to action        | "Add Player" prompt              |
      | Warning               | If approaching deadline          |

  # =============================================================================
  # DRAG AND DROP
  # =============================================================================

  @dnd @reorder
  Scenario: Drag player between slots
    Given I have players that can fill multiple slots
    When I drag a player from WR1 to FLEX
    Then the player should move to the FLEX slot
    And the WR1 slot should become empty
    And the change should be saved automatically

  @dnd @swap
  Scenario: Drag to swap players
    Given I have players in WR1 and WR2
    When I drag WR1 player onto WR2 slot
    Then the players should swap positions
    And both slots should update
    And a swap animation should play

  @dnd @validation
  Scenario: Prevent invalid drag operations
    Given I have a QB in the QB slot
    When I try to drag the QB to an RB slot
    Then the drop should be rejected
    And a visual indicator should show invalid drop
    And the player should return to original slot

  @dnd @visual-feedback
  Scenario: Provide drag feedback
    Given I am dragging a player
    When I hover over different slots
    Then I should see:
      | Feedback              | Description                      |
      | Drag preview          | Player card follows cursor       |
      | Valid drop zone       | Green highlight on valid slots   |
      | Invalid drop zone     | Red highlight on invalid slots   |
      | Original slot         | Placeholder or ghost             |

  # =============================================================================
  # REAL-TIME UPDATES
  # =============================================================================

  @realtime @roster-sync
  Scenario: Sync roster changes in real-time
    Given I am on the roster builder
    When I make a roster change
    Then the change should:
      | Behavior              | Description                      |
      | Save automatically    | No manual save required          |
      | Show saving indicator | "Saving..." status               |
      | Confirm save          | "Saved" confirmation             |
      | Handle conflicts      | Optimistic locking               |

  @realtime @availability
  Scenario: Update player availability in real-time
    Given another player adds a free agent
    When the change occurs
    Then my view should update to show:
      | Change                | Display                          |
      | Player rostered       | "Rostered" status                |
      | Add button disabled   | Cannot add rostered player       |
      | Visual indicator      | Grayed out or marked             |

  @realtime @scores
  Scenario: Update live game scores
    Given games are in progress
    When I view my roster
    Then I should see:
      | Live Data             | Display                          |
      | Current points        | Points scored so far             |
      | Game status           | Q1, Halftime, Final, etc.        |
      | Live updates          | Refresh every 30 seconds         |

  # =============================================================================
  # ERROR HANDLING
  # =============================================================================

  @error @network
  Scenario: Handle network errors gracefully
    Given a network error occurs
    When I try to add a player
    Then I should see:
      | Error Handling        | Behavior                         |
      | Error message         | "Unable to update roster"        |
      | Retry option          | "Try Again" button               |
      | Offline indicator     | If no connection                 |
      | Queue changes         | Save when back online            |

  @error @conflict
  Scenario: Handle concurrent modification conflict
    Given another user added the same player
    When I try to add that player
    Then I should see:
      | Conflict Handling     | Behavior                         |
      | Error message         | "Player no longer available"     |
      | Refresh prompt        | Update available players         |
      | Alternative           | Suggest similar players          |

  @error @validation
  Scenario: Display validation errors
    Given roster validation fails
    When I try to save an invalid roster
    Then I should see:
      | Validation Error      | Example                          |
      | Position error        | "RB slot cannot have WR"         |
      | Duplicate error       | "Player already on roster"       |
      | Lock error            | "Rosters are locked"             |

  # =============================================================================
  # ACCESSIBILITY
  # =============================================================================

  @accessibility @keyboard
  Scenario: Navigate roster builder with keyboard
    Given I am using keyboard navigation
    When I navigate the roster builder
    Then I should be able to:
      | Action                | Keys                             |
      | Navigate slots        | Tab, Arrow keys                  |
      | Open search           | Enter on empty slot              |
      | Add player            | Enter on search result           |
      | Drop player           | Delete on slot                   |
      | Cancel action         | Escape                           |

  @accessibility @screen-reader
  Scenario: Support screen reader navigation
    Given I am using a screen reader
    When I use the roster builder
    Then the screen reader should announce:
      | Element               | Announcement                     |
      | Position slots        | "QB slot, Patrick Mahomes, KC"   |
      | Empty slots           | "RB1 slot, empty, add player"    |
      | Search results        | "Josh Allen, QB, Buffalo Bills"  |
      | Actions               | "Add player button"              |
      | Status changes        | "Player added successfully"      |

  @accessibility @focus
  Scenario: Manage focus appropriately
    Given I perform an action
    When the action completes
    Then focus should move logically:
      | Action                | Focus Moves To                   |
      | Add player            | Added slot                       |
      | Drop player           | Empty slot or search             |
      | Close modal           | Triggering element               |
      | Error occurs          | Error message                    |

  # =============================================================================
  # MOBILE EXPERIENCE
  # =============================================================================

  @mobile @touch
  Scenario: Support touch interactions
    Given I am on a mobile device
    When I use the roster builder
    Then I should be able to:
      | Action                | Gesture                          |
      | View player details   | Tap player card                  |
      | Add player            | Tap add button                   |
      | Drop player           | Swipe left on slot               |
      | Search                | Tap search field                 |
      | Scroll results        | Vertical swipe                   |

  @mobile @layout
  Scenario: Mobile-optimized layout
    Given I am on a mobile device
    When I view the roster builder
    Then the layout should:
      | Optimization          | Description                      |
      | Stack vertically      | Single column layout             |
      | Larger touch targets  | Min 44px touch areas             |
      | Collapsible sections  | Expandable roster/search         |
      | Sticky search         | Search accessible while scrolling|

  # =============================================================================
  # PERFORMANCE
  # =============================================================================

  @performance @loading
  Scenario: Load roster builder efficiently
    Given I navigate to the roster builder
    When the page loads
    Then loading should:
      | Performance           | Requirement                      |
      | Initial load          | < 2 seconds                      |
      | Time to interactive   | < 3 seconds                      |
      | Show skeleton         | While loading data               |
      | Progressive load      | Roster first, then search        |

  @performance @search
  Scenario: Search responds quickly
    Given I am searching for players
    When I type in the search field
    Then search should:
      | Performance           | Requirement                      |
      | Results appear        | < 500ms after debounce           |
      | Smooth scrolling      | 60fps while scrolling results    |
      | Virtualized list      | For large result sets            |

  @performance @updates
  Scenario: Handle real-time updates efficiently
    Given live updates are active
    When scores and data update
    Then updates should:
      | Performance           | Requirement                      |
      | Minimal re-renders    | Only changed elements            |
      | Efficient diffing     | Use React keys properly          |
      | Background updates    | Don't block user interaction     |
