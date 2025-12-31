@snake-drafts @platform
Feature: Snake Drafts
  As a fantasy football league
  I need comprehensive snake draft functionality
  So that owners can draft players in a fair serpentine order

  Background:
    Given the snake draft system is operational
    And draft rules are configured

  # ==================== Draft Order Management ====================

  @draft-order @randomized-order
  Scenario: Randomize draft order
    Given a league is preparing for the draft
    When the commissioner randomizes the draft order
    Then a random order should be generated
    And all teams should be assigned unique positions

  @draft-order @randomized-order
  Scenario: Display randomization results
    Given the draft order has been randomized
    When viewing the results
    Then each team's position should be displayed
    And the randomization timestamp should be shown

  @draft-order @custom-order
  Scenario: Set custom draft order
    Given the commissioner wants a custom order
    When setting the draft order manually
    Then teams can be arranged in any order
    And the order should be saved

  @draft-order @custom-order
  Scenario: Modify draft order before draft
    Given a draft order is set
    When modifications are needed
    Then the commissioner can adjust positions
    And changes should be reflected immediately

  @draft-order @position-trading
  Scenario: Trade draft positions
    Given two owners want to swap positions
    When a draft position trade is proposed
    Then both parties must accept
    And positions should be swapped upon approval

  @draft-order @position-trading
  Scenario: Trade draft position with picks
    Given an owner wants to trade up
    When offering picks for position
    Then the trade should include position and picks
    And both elements should transfer on acceptance

  @draft-order @order-reveal
  Scenario: Configure order reveal timing
    Given draft order reveal is configurable
    When setting reveal timing
    Then options should be available
      | reveal_timing     | description              |
      | immediately       | show after randomization |
      | scheduled         | reveal at specific time  |
      | before_draft      | reveal 1 hour before     |
      | at_draft          | reveal when draft starts |

  @draft-order @order-reveal
  Scenario: Reveal draft order to league
    Given the reveal time has arrived
    When the order is revealed
    Then all owners should see their position
    And notifications should be sent

  # ==================== Pick Timer System ====================

  @pick-timer @configurable-timers
  Scenario: Configure pick timer duration
    Given the draft settings are being configured
    When setting pick timer
    Then timer options should be available
      | timer_type | duration   |
      | fast       | 30 seconds |
      | standard   | 60 seconds |
      | slow       | 90 seconds |
      | extended   | 120 seconds|

  @pick-timer @configurable-timers
  Scenario: Apply different timers per round
    Given timer flexibility is desired
    When configuring round-specific timers
    Then early rounds can have longer timers
    And later rounds can have shorter timers

  @pick-timer @auto-pick
  Scenario: Auto-pick on timer expiration
    Given the pick timer expires
    When an owner hasn't made a selection
    Then auto-pick should activate
    And the best available player should be selected

  @pick-timer @auto-pick
  Scenario: Configure auto-pick preferences
    Given an owner sets auto-pick preferences
    When auto-pick is triggered
    Then preferences should guide selection
    And position priorities should be followed

  @pick-timer @pause-resume
  Scenario: Pause the draft
    Given the draft is in progress
    When the commissioner pauses the draft
    Then the timer should stop
    And all owners should be notified

  @pick-timer @pause-resume
  Scenario: Resume paused draft
    Given the draft is paused
    When the commissioner resumes
    Then the timer should restart
    And drafting should continue

  @pick-timer @timer-extensions
  Scenario: Request timer extension
    Given an owner needs more time
    When requesting an extension
    Then the request should go to the commissioner
    And the commissioner can grant extra time

  @pick-timer @timer-extensions
  Scenario: Grant timer extension
    Given an extension is requested
    When the commissioner approves
    Then additional time should be added
    And the owner should be notified

  # ==================== Draft Board Interface ====================

  @draft-board @live-board
  Scenario: Display live draft board
    Given the draft is in progress
    When viewing the draft board
    Then all picks should be displayed in grid format
    And the current pick should be highlighted

  @draft-board @live-board
  Scenario: Update board in real-time
    Given picks are being made
    When a pick is submitted
    Then the board should update immediately
    And all owners should see the change

  @draft-board @pick-history
  Scenario: View pick history
    Given picks have been made
    When viewing pick history
    Then all picks should be listed chronologically
    And pick details should be available
      | detail       | displayed |
      | pick_number  | yes       |
      | round        | yes       |
      | team         | yes       |
      | player       | yes       |
      | position     | yes       |
      | time_taken   | yes       |

  @draft-board @pick-history
  Scenario: Filter pick history
    Given pick history is extensive
    When filtering the history
    Then filters should include position, team, and round
    And results should update accordingly

  @draft-board @team-rosters
  Scenario: Display team rosters during draft
    Given teams are drafting players
    When viewing team rosters
    Then all teams' current rosters should be visible
    And roster needs should be apparent

  @draft-board @team-rosters
  Scenario: Highlight roster composition
    Given rosters are displayed
    When viewing a team's roster
    Then position breakdown should be shown
    And gaps should be highlighted

  @draft-board @available-players
  Scenario: Display available players grid
    Given the draft is in progress
    When viewing available players
    Then undrafted players should be displayed
    And sorting options should be available

  @draft-board @available-players
  Scenario: Filter available players
    Given many players are available
    When filtering the list
    Then filters should include
      | filter_type | options              |
      | position    | QB, RB, WR, TE, etc  |
      | team        | NFL team             |
      | bye_week    | specific weeks       |
      | ranking     | top 50, top 100, etc |

  # ==================== Player Rankings ====================

  @player-rankings @custom-rankings
  Scenario: Create custom player rankings
    Given an owner wants personalized rankings
    When creating custom rankings
    Then players can be reordered
    And custom rankings should be saved

  @player-rankings @custom-rankings
  Scenario: Use custom rankings during draft
    Given custom rankings are created
    When drafting
    Then custom rankings should guide suggestions
    And auto-pick should follow custom order

  @player-rankings @rankings-import
  Scenario: Import pre-draft rankings
    Given external rankings are available
    When importing rankings
    Then rankings should be uploaded
    And the format should be validated

  @player-rankings @rankings-import
  Scenario: Support multiple import formats
    Given different ranking sources exist
    When importing
    Then supported formats should include
      | format | source_example         |
      | CSV    | spreadsheet export     |
      | JSON   | API response           |
      | copy   | text paste             |

  @player-rankings @tier-rankings
  Scenario: Create tier-based rankings
    Given tiers help draft decisions
    When creating tiered rankings
    Then players can be grouped into tiers
    And tier breaks should be visible

  @player-rankings @tier-rankings
  Scenario: Display tier information during draft
    Given tiered rankings exist
    When viewing available players
    Then tier assignments should be shown
    And tier drops should be highlighted

  @player-rankings @positional-rankings
  Scenario: View positional rankings
    Given position-specific rankings are needed
    When viewing by position
    Then rankings should be filtered by position
    And position rank should be displayed

  @player-rankings @positional-rankings
  Scenario: Compare rankings across positions
    Given cross-position value matters
    When comparing positions
    Then relative value should be shown
    And position scarcity should be indicated

  # ==================== Draft Queue System ====================

  @draft-queue @queue-management
  Scenario: Add players to draft queue
    Given an owner is preparing for their pick
    When adding players to the queue
    Then players should be added in priority order
    And the queue should be visible only to that owner

  @draft-queue @queue-management
  Scenario: Reorder queue priorities
    Given a queue exists
    When reordering the queue
    Then priority order should update
    And changes should be saved immediately

  @draft-queue @queue-auto-pick
  Scenario: Auto-pick from queue
    Given a queue is set
    When the owner's turn arrives and timer expires
    Then the top available queued player should be selected
    And the pick should be announced

  @draft-queue @queue-auto-pick
  Scenario: Skip unavailable queued players
    Given queued players may be drafted
    When a queued player is taken
    Then the system should skip to next available
    And the queue should update

  @draft-queue @queue-priorities
  Scenario: Set position priorities in queue
    Given position needs vary
    When setting queue priorities
    Then position preferences can be specified
    And the queue should respect priorities

  @draft-queue @queue-priorities
  Scenario: Balance queue by position
    Given roster balance is important
    When building the queue
    Then position distribution should be suggested
    And over-concentration should be warned

  @draft-queue @backup-picks
  Scenario: Configure backup picks
    Given primary targets may be taken
    When setting backup picks
    Then backup players should be identified
    And they should activate if primaries are gone

  @draft-queue @backup-picks
  Scenario: Automatic backup activation
    Given a primary target is drafted
    When the queue needs adjustment
    Then backups should automatically move up
    And the owner should be notified

  # ==================== Mock Draft Tools ====================

  @mock-drafts @practice-drafts
  Scenario: Join mock draft lobby
    Given mock drafts are available
    When joining a mock draft
    Then the owner should be placed in a lobby
    And the draft should start when full

  @mock-drafts @practice-drafts
  Scenario: Configure mock draft settings
    Given mock draft customization is available
    When configuring settings
    Then options should match real draft options
    And custom scenarios should be available

  @mock-drafts @ai-opponents
  Scenario: Draft against AI opponents
    Given AI opponents are available
    When practicing against AI
    Then AI should draft realistically
    And different AI strategies should be available

  @mock-drafts @ai-opponents
  Scenario: Configure AI difficulty
    Given AI difficulty is adjustable
    When setting difficulty
    Then options should include
      | difficulty | behavior                    |
      | beginner   | predictable, ADP-based      |
      | standard   | balanced, some strategy     |
      | expert     | optimal picks, counters you |

  @mock-drafts @draft-simulations
  Scenario: Run draft simulation
    Given simulation mode is available
    When running a simulation
    Then the draft should complete automatically
    And results should be displayed

  @mock-drafts @draft-simulations
  Scenario: Simulate from specific pick
    Given a draft position is known
    When simulating from that position
    Then the simulation should start from that pick
    And outcomes should be analyzed

  @mock-drafts @strategy-testing
  Scenario: Test draft strategies
    Given strategies need validation
    When testing a strategy
    Then the simulation should apply the strategy
    And outcomes should be measured

  @mock-drafts @strategy-testing
  Scenario: Compare strategy outcomes
    Given multiple strategies exist
    When comparing strategies
    Then head-to-head results should be shown
    And best strategy should be identified

  # ==================== Draft Strategy Helpers ====================

  @strategy-helpers @best-available
  Scenario: Suggest best available player
    Given the owner is on the clock
    When viewing suggestions
    Then best available player should be highlighted
    And ranking source should be indicated

  @strategy-helpers @best-available
  Scenario: Show best available by position
    Given position needs vary
    When viewing best available
    Then best at each position should be shown
    And position ranks should be displayed

  @strategy-helpers @positional-needs
  Scenario: Analyze positional needs
    Given a team has drafted players
    When analyzing needs
    Then position gaps should be identified
    And priority recommendations should be made

  @strategy-helpers @positional-needs
  Scenario: Display roster projection
    Given picks remain
    When projecting the roster
    Then expected final roster should be shown
    And remaining needs should be highlighted

  @strategy-helpers @value-picks
  Scenario: Identify value picks
    Given ADP data is available
    When a player is available past ADP
    Then they should be flagged as a value
    And the value amount should be shown

  @strategy-helpers @value-picks
  Scenario: Alert on falling players
    Given players can fall in drafts
    When a highly-ranked player falls
    Then an alert should be displayed
    And the value opportunity should be highlighted

  @strategy-helpers @reach-warnings
  Scenario: Warn about reaches
    Given ADP data exists
    When an owner is about to reach
    Then a warning should be displayed
    And suggested picks should be shown

  @strategy-helpers @reach-warnings
  Scenario: Calculate reach amount
    Given a pick is a reach
    When quantifying the reach
    Then picks ahead of ADP should be calculated
    And comparable available players should be shown

  # ==================== Keeper Integration ====================

  @keeper-integration @keeper-selections
  Scenario: Display keeper selections
    Given keepers are selected before draft
    When viewing the draft board
    Then keepers should be marked as unavailable
    And keeper assignments should be visible

  @keeper-integration @keeper-selections
  Scenario: Assign keepers to teams
    Given keeper selections are made
    When the draft begins
    Then keepers should be on team rosters
    And they should not appear in available players

  @keeper-integration @round-assignments
  Scenario: Assign keepers to draft rounds
    Given keepers have round costs
    When the draft reaches keeper rounds
    Then keeper picks should be automatically placed
    And the team should skip that pick

  @keeper-integration @round-assignments
  Scenario: Display keeper round assignments
    Given keepers have assigned rounds
    When viewing the draft board
    Then keeper rounds should be marked
    And pick forfeitures should be clear

  @keeper-integration @pick-adjustments
  Scenario: Adjust draft picks for keepers
    Given keepers forfeit draft picks
    When calculating picks
    Then forfeited picks should be removed
    And remaining picks should be correct

  @keeper-integration @pick-adjustments
  Scenario: Handle multiple keeper costs
    Given a team has multiple keepers
    When calculating pick adjustments
    Then all forfeited picks should be accounted for
    And the draft order should adjust accordingly

  @keeper-integration @keeper-deadlines
  Scenario: Enforce keeper deadline
    Given a keeper deadline is set
    When the deadline passes
    Then keeper selections should lock
    And late changes should be prevented

  @keeper-integration @keeper-deadlines
  Scenario: Send keeper deadline reminders
    Given the deadline approaches
    When reminder period begins
    Then notifications should be sent
    And owners should be prompted to finalize

  # ==================== Draft Results ====================

  @draft-results @draft-recap
  Scenario: Generate draft recap
    Given the draft has completed
    When viewing the recap
    Then all picks should be summarized
    And key statistics should be displayed

  @draft-results @draft-recap
  Scenario: Display recap by round
    Given the recap is available
    When viewing by round
    Then each round's picks should be grouped
    And round summaries should be provided

  @draft-results @grade-analysis
  Scenario: Generate draft grades
    Given the draft is complete
    When generating grades
    Then each team should receive a grade
    And grading methodology should be explained

  @draft-results @grade-analysis
  Scenario: Display grade breakdown
    Given grades are calculated
    When viewing grade details
    Then category grades should be shown
      | category        | weight | description           |
      | value_picks     | 30%    | picks below ADP       |
      | position_balance| 25%    | roster construction   |
      | star_power      | 25%    | top-tier acquisitions |
      | depth           | 20%    | bench quality         |

  @draft-results @team-summaries
  Scenario: Generate team summaries
    Given the draft is complete
    When viewing team summaries
    Then each team's draft should be summarized
    And strengths and weaknesses should be identified

  @draft-results @team-summaries
  Scenario: Compare team summaries
    Given summaries are generated
    When comparing teams
    Then side-by-side comparison should be available
    And relative strengths should be highlighted

  @draft-results @pick-breakdown
  Scenario: View pick-by-pick breakdown
    Given detailed analysis is needed
    When viewing pick breakdown
    Then each pick should be analyzed
      | analysis_item    | included |
      | pick_grade       | yes      |
      | value_vs_adp     | yes      |
      | position_context | yes      |
      | alternatives     | yes      |

  @draft-results @pick-breakdown
  Scenario: Identify best and worst picks
    Given picks are analyzed
    When identifying extremes
    Then best value picks should be highlighted
    And biggest reaches should be noted

  # ==================== Draft Room Features ====================

  @draft-room @live-chat
  Scenario: Use live chat during draft
    Given the draft room has chat
    When owners send messages
    Then messages should appear in real-time
    And all participants should see them

  @draft-room @live-chat
  Scenario: Moderate draft room chat
    Given chat moderation is available
    When inappropriate content is posted
    Then the commissioner can moderate
    And messages can be removed

  @draft-room @trade-proposals
  Scenario: Propose trades during draft
    Given trading is allowed during draft
    When proposing a trade
    Then the proposal should be sent
    And picks can be included in trades

  @draft-room @trade-proposals
  Scenario: Execute trade during draft
    Given a trade is accepted during draft
    When processing the trade
    Then rosters should update immediately
    And pick order should adjust if needed

  @draft-room @pause-requests
  Scenario: Request draft pause
    Given an owner needs a pause
    When requesting a pause
    Then the request should go to commissioner
    And reason can be provided

  @draft-room @pause-requests
  Scenario: Handle pause request
    Given a pause is requested
    When the commissioner reviews
    Then they can approve or deny
    And the decision should be communicated

  @draft-room @commissioner-controls
  Scenario: Access commissioner controls
    Given the commissioner is in the draft room
    When accessing controls
    Then admin options should be available
      | control          | description              |
      | pause_draft      | stop the draft           |
      | resume_draft     | continue the draft       |
      | undo_pick        | reverse a mistake        |
      | assign_pick      | make pick for absent owner|
      | kick_owner       | remove disruptive owner  |

  @draft-room @commissioner-controls
  Scenario: Undo erroneous pick
    Given a pick was made in error
    When the commissioner undoes the pick
    Then the pick should be reversed
    And the player should return to available
