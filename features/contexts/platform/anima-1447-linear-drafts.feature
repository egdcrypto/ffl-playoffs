@linear-drafts @straight-drafts @platform
Feature: Linear Drafts
  As a fantasy football league
  I need comprehensive linear (straight) draft functionality
  So that leagues can use this traditional draft format with consistent pick order

  Background:
    Given the linear draft system is operational
    And linear draft rules are configured

  # ==================== Linear Draft Order ====================

  @draft-order @same-order
  Scenario: Maintain same order every round
    Given a 12-team linear draft is configured
    When the draft progresses through rounds
    Then pick order should remain identical each round
    And Team 1 should pick first every round
    And Team 12 should pick last every round

  @draft-order @same-order
  Scenario: Display consistent pick sequence
    Given a linear draft is in progress
    When viewing the pick order
    Then each round should show the same sequence
      | round | pick_1 | pick_12 |
      | 1     | Team 1 | Team 12 |
      | 2     | Team 1 | Team 12 |
      | 3     | Team 1 | Team 12 |

  @draft-order @no-snake-reversal
  Scenario: Verify no snake reversal occurs
    Given round 1 has completed
    When round 2 begins
    Then pick order should NOT reverse
    And the same team should pick first
    And the draft should continue in linear fashion

  @draft-order @no-snake-reversal
  Scenario: Compare linear to snake format
    Given format comparison is available
    When comparing pick sequences
    Then linear format should show same order each round
    And snake format should show alternating order
    And the differences should be clearly displayed

  @draft-order @pick-sequence
  Scenario: Display complete draft pick sequence
    Given a linear draft is configured
    When viewing the full pick sequence
    Then all picks should display with team assignments
    And the consistent order should be visible across rounds
    And total picks per team should be equal

  @draft-order @pick-sequence
  Scenario: Show owner's picks across all rounds
    Given an owner views their pick schedule
    When viewing their assigned picks
    Then their pick position should be the same each round
    And all their picks should be listed
    And timing estimates should be provided

  @draft-order @order-display
  Scenario: Display draft order prominently
    Given the draft room is active
    When viewing the draft board
    Then the linear order should be clearly displayed
    And the current pick should be highlighted
    And the order should not change between rounds

  @draft-order @order-display
  Scenario: Show round progression
    Given the draft is progressing
    When rounds advance
    Then round number should update
    And pick position within round should show
    And total draft progress should be visible

  # ==================== Draft Position Strategy ====================

  @position-strategy @first-pick-advantage
  Scenario: Analyze first pick advantage in linear
    Given draft position analysis is available
    When analyzing first pick advantage
    Then significant value advantage should be shown
    And cumulative pick value should be calculated
    And positional monopoly potential should be noted

  @position-strategy @first-pick-advantage
  Scenario: Display first pick strategy guide
    Given strategy guides are available
    When viewing first pick strategy
    Then elite player targeting should be emphasized
    And positional domination strategies should be shown
    And round-by-round recommendations should be provided

  @position-strategy @late-pick-strategies
  Scenario: Access late pick strategies
    Given owner has late draft position
    When viewing strategy guides
    Then value-based drafting should be recommended
    And sleeper targeting should be emphasized
    And patience strategies should be outlined

  @position-strategy @late-pick-strategies
  Scenario: Identify late pick value opportunities
    Given late pick analysis is available
    When viewing opportunities
    Then undervalued players should be highlighted
    And positional scarcity should be considered
    And breakout candidates should be identified

  @position-strategy @positional-targeting
  Scenario: Plan positional targeting strategy
    Given positional scarcity data exists
    When planning draft strategy
    Then position-by-position recommendations should show
    And optimal rounds for each position should be suggested
    And depth considerations should be noted

  @position-strategy @positional-targeting
  Scenario: Track positional runs by draft position
    Given historical data is available
    When analyzing position runs
    Then trends by draft slot should be shown
    And common patterns should be identified
    And counter-strategies should be suggested

  @position-strategy @round-planning
  Scenario: Create round-by-round plan
    Given planning tools are available
    When creating a draft plan
    Then each round can have target positions
    And backup options can be specified
    And flexibility notes can be added

  @position-strategy @round-planning
  Scenario: Adjust plan based on draft flow
    Given a plan is in place
    When the draft deviates from expectations
    Then plan adjustments should be suggested
    And alternative targets should be recommended
    And real-time updates should occur

  # ==================== Pick Value Calculations ====================

  @pick-value @linear-values
  Scenario: Calculate linear-specific pick values
    Given pick value analysis is available
    When calculating linear format values
    Then each pick should have assigned value
    And values should reflect linear format advantage
    And position 1 should have significantly higher value

  @pick-value @linear-values
  Scenario: Display pick value chart
    Given value calculations are complete
    When viewing the pick value chart
    Then all picks should show their values
      | pick  | round | value |
      | 1.01  | 1     | 100   |
      | 1.06  | 1     | 75    |
      | 1.12  | 1     | 55    |
      | 2.01  | 2     | 50    |

  @pick-value @scarcity-adjustments
  Scenario: Adjust values for positional scarcity
    Given scarcity data is available
    When adjusting pick values
    Then scarcity should factor into calculations
    And elite position picks should be valued higher
    And depth position picks should be adjusted

  @pick-value @scarcity-adjustments
  Scenario: Show scarcity-adjusted rankings
    Given adjustments are calculated
    When viewing adjusted rankings
    Then rankings should reflect scarcity
    And tier breaks should account for scarcity
    And value recommendations should incorporate scarcity

  @pick-value @tier-mapping
  Scenario: Map picks to player tiers
    Given player tiers are defined
    When mapping picks to tiers
    Then expected tier for each pick should show
    And tier depletion should be tracked
    And value targets should be highlighted

  @pick-value @tier-mapping
  Scenario: Track tier depletion during draft
    Given the draft is in progress
    When tracking tiers
    Then remaining players per tier should show
    And tier exhaustion warnings should trigger
    And next tier should be highlighted when current depletes

  @pick-value @optimal-usage
  Scenario: Suggest optimal pick usage
    Given pick optimization analysis exists
    When viewing suggestions
    Then position recommendations per pick should show
    And value-maximizing strategies should be suggested
    And common mistakes should be flagged

  @pick-value @optimal-usage
  Scenario: Identify reach and value picks
    Given picks are being made
    When analyzing selection
    Then reaches should be flagged
    And value picks should be highlighted
    And comparative analysis should be shown

  # ==================== Linear Draft Board ====================

  @draft-board @round-visualization
  Scenario: Display round-by-round draft board
    Given the draft board is active
    When viewing the board
    Then picks should be organized by round
    And each round should show all 12 picks
    And team columns should be consistent

  @draft-board @round-visualization
  Scenario: Navigate between rounds on board
    Given multiple rounds have completed
    When navigating rounds
    Then round selection should be easy
    And scrolling between rounds should be smooth
    And current round should be highlighted

  @draft-board @pick-flow
  Scenario: Display pick flow indicators
    Given picks are progressing
    When viewing pick flow
    Then current pick should be highlighted
    And upcoming picks should be shown
    And completed picks should be marked

  @draft-board @pick-flow
  Scenario: Show picks remaining in round
    Given a round is in progress
    When viewing round status
    Then picks remaining should display
    And progress bar should update
    And time estimates should be shown

  @draft-board @roster-tracking
  Scenario: Track team rosters on board
    Given picks are being made
    When viewing team rosters
    Then each team's selections should be visible
    And roster composition should be shown
    And position counts should be tracked

  @draft-board @roster-tracking
  Scenario: Display roster summary panel
    Given a team is selected
    When viewing roster summary
    Then all drafted players should show
    And positions filled should be indicated
    And roster needs should be highlighted

  @draft-board @available-players
  Scenario: Display available players grid
    Given the draft is in progress
    When viewing available players
    Then undrafted players should be listed
    And filtering by position should work
    And sorting options should be available

  @draft-board @available-players
  Scenario: Filter and search available players
    Given the available players grid is shown
    When filtering or searching
    Then results should update in real-time
    And multiple filters should stack
    And search should find player names

  # ==================== Mock Linear Drafts ====================

  @mock-drafts @practice-simulations
  Scenario: Run linear mock draft simulation
    Given mock draft functionality exists
    When starting a linear mock
    Then the mock should use linear format
    And practice should be enabled
    And results should be analyzable

  @mock-drafts @practice-simulations
  Scenario: Configure mock draft settings
    Given mock settings are available
    When configuring the mock
    Then linear format should be selected
    And league size should be adjustable
    And draft position should be selectable

  @mock-drafts @ai-opponents
  Scenario: Draft against AI opponents
    Given AI fills empty slots
    When AI makes picks
    Then AI should follow realistic strategy
    And AI should consider positional scarcity
    And AI difficulty should be configurable

  @mock-drafts @ai-opponents
  Scenario: Configure AI difficulty
    Given AI settings are available
    When setting difficulty
    Then options should include
      | difficulty | behavior                       |
      | easy       | follows basic ADP              |
      | medium     | positional awareness           |
      | hard       | optimal linear strategy        |
      | random     | unpredictable selections       |

  @mock-drafts @position-testing
  Scenario: Test different draft positions
    Given position testing is wanted
    When selecting positions to test
    Then multiple positions can be practiced
    And results can be compared
    And optimal position can be identified

  @mock-drafts @position-testing
  Scenario: Compare outcomes by draft position
    Given multiple mocks have completed
    When comparing outcomes
    Then position-by-position analysis should show
    And win projections should be calculated
    And position recommendations should be made

  @mock-drafts @strategy-refinement
  Scenario: Refine draft strategy through mocks
    Given multiple mock approaches are tested
    When analyzing results
    Then successful strategies should be identified
    And failing strategies should be flagged
    And refinement suggestions should be provided

  @mock-drafts @strategy-refinement
  Scenario: Save and replay mock drafts
    Given a mock draft completed
    When saving the mock
    Then the draft should be stored
    And it should be replayable
    And different decisions can be tested

  # ==================== Dynasty Linear Drafts ====================

  @dynasty @rookie-drafts
  Scenario: Conduct linear rookie draft
    Given a dynasty league uses linear rookie drafts
    When the rookie draft begins
    Then linear order should apply
    And the order should be based on standings
    And worst team should pick first each round

  @dynasty @rookie-drafts
  Scenario: Configure rookie draft order
    Given rookie draft settings exist
    When configuring order
    Then order basis should be selectable
      | order_type         | description                  |
      | reverse_standings  | worst to best                |
      | potential_points   | based on potential points    |
      | lottery            | randomized with weights      |
      | manual             | commissioner assigned        |

  @dynasty @startup-drafts
  Scenario: Conduct linear startup draft
    Given a new dynasty league is forming
    When the startup draft begins
    Then linear format should apply
    And all NFL players should be available
    And multi-round draft should proceed

  @dynasty @startup-drafts
  Scenario: Configure startup draft rounds
    Given startup configuration is needed
    When setting round count
    Then appropriate rounds should be configurable
    And roster size should be considered
    And taxi squad picks should be optional

  @dynasty @dispersal-drafts
  Scenario: Support linear dispersal draft
    Given orphan teams exist
    When conducting dispersal draft
    Then orphan players should enter pool
    And linear order should apply
    And remaining teams should draft from pool

  @dynasty @dispersal-drafts
  Scenario: Configure dispersal draft settings
    Given dispersal settings are needed
    When configuring dispersal
    Then order determination should be configurable
    And pick counts should be settable
    And player pool should be defined

  @dynasty @expansion-drafts
  Scenario: Conduct linear expansion draft
    Given new teams are joining
    When the expansion draft begins
    Then existing rosters should provide players
    And new teams should draft linearly
    And protection rules should apply

  @dynasty @expansion-drafts
  Scenario: Configure expansion draft rules
    Given expansion rules are needed
    When configuring expansion
    Then protected player count should be settable
    And draft rounds should be configurable
    And eligible players should be defined

  # ==================== Linear Timer Settings ====================

  @timers @consistent-timers
  Scenario: Apply consistent round timers
    Given timer settings are configured
    When timers are active
    Then the same timer should apply each round
    And all picks should have equal time
    And timer consistency should be maintained

  @timers @consistent-timers
  Scenario: Configure timer duration
    Given timer configuration is available
    When setting timer duration
    Then duration options should include
      | duration    | use_case           |
      | 30 seconds  | speed draft        |
      | 60 seconds  | standard live      |
      | 90 seconds  | casual live        |
      | 4 hours     | slow draft         |

  @timers @countdown-display
  Scenario: Display pick countdown
    Given an owner is on the clock
    When viewing the timer
    Then countdown should be prominently shown
    And visual warnings should appear at thresholds
    And audio alerts should be configurable

  @timers @countdown-display
  Scenario: Synchronize countdown across clients
    Given multiple clients are connected
    When the timer runs
    Then all clients should show same time
    And synchronization should be maintained
    And drift should be corrected

  @timers @auto-pick
  Scenario: Handle auto-pick on timer expiration
    Given the pick timer expires
    When auto-pick activates
    Then the best available player should be selected
    And the owner should be notified
    And the draft should continue

  @timers @auto-pick
  Scenario: Configure auto-pick preferences
    Given auto-pick settings are available
    When configuring preferences
    Then position priorities can be set
    And specific players can be queued
    And do-not-draft list can be defined

  @timers @timer-configuration
  Scenario: Configure timer settings
    Given commissioner accesses timer settings
    When configuring timers
    Then all timer options should be available
    And per-round timers should be settable
    And pause functionality should be included

  @timers @timer-configuration
  Scenario: Adjust timers mid-draft
    Given the draft is in progress
    When commissioner adjusts timers
    Then new timer should apply to next pick
    And all owners should be notified
    And changes should be logged

  # ==================== Trade Pick Integration ====================

  @pick-trading @linear-trades
  Scenario: Trade picks in linear format
    Given pick trading is enabled
    When a pick trade is proposed
    Then linear-specific values should apply
    And pick positions should be clearly shown
    And trade should be processed

  @pick-trading @linear-trades
  Scenario: Display tradeable picks
    Given picks can be traded
    When viewing tradeable picks
    Then all owned picks should be shown
    And pick values should be displayed
    And trade history should be accessible

  @pick-trading @value-comparison
  Scenario: Compare pick values in trade
    Given a trade is being evaluated
    When comparing values
    Then linear-specific values should be used
    And total value for each side should show
    And fairness should be indicated

  @pick-trading @value-comparison
  Scenario: Display trade value calculator
    Given the trade calculator is accessed
    When entering trade components
    Then pick values should auto-populate
    And player values should be included
    And total trade value should calculate

  @pick-trading @trade-impact
  Scenario: Analyze trade impact on draft
    Given a pick trade is proposed
    When analyzing impact
    Then draft capital changes should show
    And positional impact should be assessed
    And future implications should be noted

  @pick-trading @trade-impact
  Scenario: Show before/after draft capital
    Given a trade is being evaluated
    When viewing impact
    Then current pick inventory should show
    And post-trade inventory should show
    And changes should be highlighted

  @pick-trading @multi-round-trades
  Scenario: Execute multi-round pick trades
    Given picks across rounds are involved
    When executing the trade
    Then all picks should transfer correctly
    And each pick should be validated
    And the trade should be recorded

  @pick-trading @multi-round-trades
  Scenario: Validate multi-pick trade fairness
    Given multiple picks are involved
    When validating the trade
    Then combined values should be calculated
    And fairness threshold should be checked
    And approval process should follow rules

  # ==================== Linear League Settings ====================

  @settings @format-selection
  Scenario: Select linear draft format
    Given league settings are accessible
    When selecting draft format
    Then linear format should be an option
    And format differences should be explained
    And selection should be saved

  @settings @format-selection
  Scenario: Toggle between formats
    Given format can be changed
    When toggling format
    Then the new format should apply
    And owners should be notified
    And settings should update accordingly

  @settings @round-configuration
  Scenario: Configure draft rounds
    Given round configuration is available
    When setting round count
    Then appropriate rounds can be configured
    And roster requirements should be considered
    And validation should prevent issues

  @settings @round-configuration
  Scenario: Set position requirements per round
    Given positional requirements exist
    When configuring requirements
    Then minimum positions can be set
    And maximum positions can be limited
    And validation should enforce rules

  @settings @hybrid-formats
  Scenario: Configure hybrid draft format
    Given hybrid formats are supported
    When configuring hybrid
    Then combinations should be available
      | hybrid_type       | description                    |
      | linear_auction    | linear early, auction late     |
      | linear_snake      | linear first 3, snake rest     |
      | linear_slow       | linear with slow timing        |

  @settings @hybrid-formats
  Scenario: Validate hybrid format compatibility
    Given a hybrid is selected
    When validating settings
    Then compatibility should be checked
    And conflicts should be identified
    And resolution should be suggested

  @settings @commissioner-controls
  Scenario: Access commissioner draft controls
    Given commissioner is managing the draft
    When accessing controls
    Then pause/resume should be available
    And pick corrections should be possible
    And timer adjustments should be allowed

  @settings @commissioner-controls
  Scenario: Override draft settings
    Given commissioner override is needed
    When making overrides
    Then changes should take effect immediately
    And all participants should be notified
    And changes should be logged

  # ==================== Linear Draft Results ====================

  @results @position-analysis
  Scenario: Analyze picks by position
    Given the draft is complete
    When analyzing by position
    Then position distribution should be shown
    And average pick by position should display
    And positional strategies should be assessed

  @results @position-analysis
  Scenario: Compare positional strategies
    Given all teams' strategies are visible
    When comparing approaches
    Then position-first strategies should be identified
    And value-based approaches should be noted
    And success correlation should be shown

  @results @draft-grades
  Scenario: Calculate linear draft grades
    Given draft grading is available
    When calculating grades
    Then each team should receive a grade
    And linear-specific factors should be considered
    And methodology should be transparent

  @results @draft-grades
  Scenario: Display grade breakdown
    Given grades are calculated
    When viewing breakdown
    Then category scores should show
      | category            | weight |
      | value_picks         | 30%    |
      | positional_balance  | 25%    |
      | tier_management     | 25%    |
      | upside_picks        | 20%    |

  @results @value-assessment
  Scenario: Assess overall draft value
    Given value metrics exist
    When assessing value
    Then total value captured should be calculated
    And value vs pick position should be shown
    And efficiency rating should be provided

  @results @value-assessment
  Scenario: Identify best and worst value picks
    Given picks have value scores
    When identifying extremes
    Then best value picks should be highlighted
    And worst value picks should be noted
    And league-wide rankings should be shown

  @results @historical-comparison
  Scenario: Compare to historical drafts
    Given historical data exists
    When comparing results
    Then current draft should be contextualized
    And trends should be identified
    And performance benchmarks should be shown

  @results @historical-comparison
  Scenario: Track draft success over seasons
    Given multi-season data exists
    When tracking success
    Then draft success rates should be shown
    And improvement trends should be visible
    And learning opportunities should be highlighted

  # ==================== Linear Draft Education ====================

  @education @format-explanation
  Scenario: Access linear format explanation
    Given education content exists
    When accessing format info
    Then linear format should be explained
    And comparisons to other formats should show
    And pros and cons should be listed

  @education @format-explanation
  Scenario: View interactive tutorial
    Given tutorials are available
    When starting the tutorial
    Then step-by-step walkthrough should occur
    And interactive elements should engage user
    And comprehension should be verified

  @education @strategy-guides
  Scenario: Access linear strategy guides
    Given strategy content exists
    When viewing guides
    Then position-specific strategies should show
    And common mistakes should be highlighted
    And expert tips should be included

  @education @strategy-guides
  Scenario: View video strategy content
    Given video content exists
    When accessing videos
    Then strategy videos should be available
    And expert commentary should be included
    And real draft examples should be shown

  @education @faq
  Scenario: Access linear draft FAQ
    Given FAQ content exists
    When viewing FAQ
    Then common questions should be answered
    And detailed explanations should be available
    And links to more info should be provided

  @education @faq
  Scenario: Search help content
    Given help search is available
    When searching for help
    Then relevant content should be found
    And results should be ranked by relevance
    And quick answers should be highlighted

  @education @format-comparison
  Scenario: Compare linear to other formats
    Given format comparison tools exist
    When comparing formats
    Then side-by-side analysis should show
    And advantages of each should be listed
    And use case recommendations should be made

  @education @format-comparison
  Scenario: View format selection guide
    Given selection guidance exists
    When viewing the guide
    Then league type recommendations should show
    And decision factors should be outlined
    And format quiz should be available
