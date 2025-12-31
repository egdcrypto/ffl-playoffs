@rookie-drafts @platform
Feature: Rookie Drafts
  As a dynasty or keeper fantasy football league
  I need comprehensive rookie draft functionality
  So that owners can draft incoming rookies to build their dynasty rosters

  Background:
    Given the rookie draft system is operational
    And rookie draft rules are configured

  # ==================== Rookie Draft Order ====================

  @draft-order @pick-trading
  Scenario: Trade rookie draft picks
    Given owners can trade picks
    When a pick trade is proposed
    Then the trade should include pick details
    And both parties must approve

  @draft-order @pick-trading
  Scenario: Display traded pick ownership
    Given picks have been traded
    When viewing draft order
    Then current owners should be displayed
    And original owners should be shown

  @draft-order @lottery-systems
  Scenario: Conduct draft lottery
    Given a lottery determines draft order
    When running the lottery
    Then odds should be assigned based on standings
    And results should be randomized fairly

  @draft-order @lottery-systems
  Scenario: Configure lottery odds
    Given lottery settings are configurable
    When setting odds
    Then odds can be assigned per position
      | finish_position | lottery_odds |
      | 12th (worst)    | 25%          |
      | 11th            | 20%          |
      | 10th            | 15%          |
      | 9th             | 12%          |
      | 8th             | 10%          |
      | 7th             | 8%           |
      | playoff_teams   | 10% combined |

  @draft-order @reverse-standings
  Scenario: Set order by reverse standings
    Given standings determine draft order
    When applying reverse standings
    Then the worst team should pick first
    And the champion should pick last

  @draft-order @reverse-standings
  Scenario: Handle tied standings
    Given teams have identical records
    When resolving ties
    Then tiebreakers should be applied
    And final order should be determined

  @draft-order @pick-forfeiture
  Scenario: Enforce pick forfeiture rules
    Given a team forfeits a pick
    When the forfeited pick comes up
    Then the pick should be skipped
    And the reason should be logged

  @draft-order @pick-forfeiture
  Scenario: Configure forfeiture conditions
    Given forfeiture rules exist
    When conditions are met
    Then picks may be forfeited for
      | condition           | consequence           |
      | rule_violation      | pick forfeiture       |
      | salary_cap_penalty  | pick forfeiture       |
      | trade_violation     | pick forfeiture       |

  # ==================== Rookie Pool Management ====================

  @rookie-pool @incoming-class
  Scenario: Display incoming rookie class
    Given a new draft class is available
    When viewing the rookie pool
    Then all eligible rookies should be listed
    And they should be sortable by various criteria

  @rookie-pool @incoming-class
  Scenario: Update rookie pool after NFL draft
    Given the NFL draft has occurred
    When updating the pool
    Then landing spots should be added
    And player values should be adjusted

  @rookie-pool @nfl-draft-integration
  Scenario: Integrate NFL draft results
    Given the NFL draft is complete
    When syncing results
    Then draft positions should be recorded
    And team assignments should update

  @rookie-pool @nfl-draft-integration
  Scenario: Track NFL draft capital
    Given draft capital affects value
    When analyzing picks
    Then draft capital should be displayed
    And value implications should be noted

  @rookie-pool @undrafted-free-agents
  Scenario: Include undrafted free agents
    Given some rookies go undrafted
    When they sign as UDFAs
    Then they should be added to the pool
    And their status should be indicated

  @rookie-pool @undrafted-free-agents
  Scenario: Track UDFA signings
    Given UDFAs sign with teams
    When updating the pool
    Then signing details should be recorded
    And opportunity level should be assessed

  @rookie-pool @rookie-eligibility
  Scenario: Determine rookie eligibility
    Given eligibility rules exist
    When evaluating players
    Then only eligible rookies should be in pool
    And ineligible players should be excluded

  @rookie-pool @rookie-eligibility
  Scenario: Handle eligibility exceptions
    Given edge cases occur
    When evaluating eligibility
    Then exceptions should be considered
    And commissioner rulings should apply

  # ==================== Rookie Rankings ====================

  @rookie-rankings @consensus-rankings
  Scenario: Display consensus rookie rankings
    Given multiple ranking sources exist
    When generating consensus rankings
    Then rankings should aggregate multiple sources
    And consensus position should be shown

  @rookie-rankings @consensus-rankings
  Scenario: Compare ranking sources
    Given sources differ
    When comparing rankings
    Then source-by-source comparisons should be available
    And variance should be highlighted

  @rookie-rankings @rookie-tiers
  Scenario: Organize rookies by tiers
    Given tiers help draft decisions
    When viewing tiered rankings
    Then rookies should be grouped in tiers
      | tier          | description              |
      | elite         | top 3-5 prospects        |
      | premium       | first-round talent       |
      | solid         | day 2 value              |
      | dart_throws   | late-round upside        |

  @rookie-rankings @rookie-tiers
  Scenario: Identify tier breaks
    Given tier breaks are important
    When viewing rankings
    Then tier breaks should be visible
    And significant drop-offs should be noted

  @rookie-rankings @positional-rankings
  Scenario: View positional rookie rankings
    Given positions have different depths
    When filtering by position
    Then position-specific rankings should display
    And position scarcity should be indicated

  @rookie-rankings @positional-rankings
  Scenario: Compare across positions
    Given cross-position value matters
    When comparing positions
    Then relative value should be shown
    And positional needs should be considered

  @rookie-rankings @landing-spot-analysis
  Scenario: Analyze landing spots
    Given NFL teams affect value
    When analyzing landing spots
    Then opportunity should be assessed
    And team context should be provided

  @rookie-rankings @landing-spot-analysis
  Scenario: Rate landing spot quality
    Given landing spots vary
    When rating quality
    Then factors should include
      | factor              | impact               |
      | depth_chart         | opportunity level    |
      | offensive_scheme    | role fit             |
      | coaching_staff      | development history  |
      | surrounding_talent  | support level        |

  # ==================== Draft Pick Trading ====================

  @pick-trading @future-picks
  Scenario: Trade future draft picks
    Given future picks are tradeable
    When trading future picks
    Then picks up to 3 years ahead should be available
    And trades should be recorded

  @pick-trading @future-picks
  Scenario: Validate future pick trades
    Given future picks are being traded
    When validating the trade
    Then pick ownership should be verified
    And duplicate trades should be prevented

  @pick-trading @value-charts
  Scenario: Display pick value charts
    Given pick values vary by position
    When viewing value charts
    Then value should be shown for each pick
    And historical value should be available

  @pick-trading @value-charts
  Scenario: Apply value chart to trades
    Given a trade is proposed
    When evaluating with value chart
    Then trade value should be calculated
    And fairness should be indicated

  @pick-trading @trade-calculator
  Scenario: Integrate with trade calculator
    Given trade calculators are available
    When evaluating pick trades
    Then picks should have calculator values
    And trades should be analyzable

  @pick-trading @trade-calculator
  Scenario: Calculate multi-pick trades
    Given multiple picks are involved
    When calculating value
    Then aggregate value should be computed
    And pick combinations should be valued

  @pick-trading @pick-swap-tracking
  Scenario: Track pick swap agreements
    Given pick swaps occur
    When recording swaps
    Then swap conditions should be documented
    And execution should be tracked

  @pick-trading @pick-swap-tracking
  Scenario: Execute pick swap
    Given swap conditions are met
    When executing the swap
    Then picks should exchange ownership
    And the swap should be completed

  # ==================== Rookie Scouting Reports ====================

  @scouting @player-profiles
  Scenario: View rookie player profiles
    Given scouting data is available
    When viewing a player profile
    Then comprehensive information should display
    And profile should be detailed

  @scouting @player-profiles
  Scenario: Display profile sections
    Given profiles have multiple sections
    When viewing sections
    Then content should include
      | section           | content                    |
      | bio               | height, weight, school     |
      | stats             | college statistics         |
      | strengths         | key abilities              |
      | weaknesses        | areas of concern           |
      | projection        | NFL outlook                |

  @scouting @combine-data
  Scenario: Display combine data
    Given combine results are available
    When viewing combine data
    Then measurables should be shown
      | measurable    | example      |
      | 40_yard_dash  | 4.42 seconds |
      | vertical_jump | 38 inches    |
      | broad_jump    | 128 inches   |
      | bench_press   | 22 reps      |

  @scouting @combine-data
  Scenario: Compare combine results
    Given multiple players have combine data
    When comparing players
    Then side-by-side comparisons should be available
    And percentiles should be shown

  @scouting @college-stats
  Scenario: Display college statistics
    Given college stats are tracked
    When viewing stats
    Then season-by-season stats should be shown
    And career totals should be calculated

  @scouting @college-stats
  Scenario: Analyze college production
    Given production varies
    When analyzing stats
    Then context should be provided
    And production trends should be visible

  @scouting @film-analysis
  Scenario: Access film analysis links
    Given film analysis is valuable
    When viewing analysis
    Then links to film should be available
    And analysis summaries should be included

  @scouting @film-analysis
  Scenario: Provide film breakdowns
    Given detailed analysis exists
    When viewing breakdowns
    Then play-by-play analysis should be accessible
    And key plays should be highlighted

  # ==================== Draft Pick Inventory ====================

  @pick-inventory @owned-picks-display
  Scenario: Display owned draft picks
    Given teams own various picks
    When viewing pick inventory
    Then all owned picks should be displayed
    And pick details should be shown

  @pick-inventory @owned-picks-display
  Scenario: Organize picks by year
    Given picks span multiple years
    When viewing inventory
    Then picks should be organized by year
    And each year should be expandable

  @pick-inventory @traded-picks-tracking
  Scenario: Track traded away picks
    Given picks have been traded
    When viewing traded picks
    Then traded picks should be identified
    And new owners should be shown

  @pick-inventory @traded-picks-tracking
  Scenario: Show complete trade details
    Given trades involve picks
    When viewing trade details
    Then full trade should be displayed
    And trade date should be shown

  @pick-inventory @acquisition-history
  Scenario: View pick acquisition history
    Given picks change hands
    When viewing history
    Then all transactions should be listed
    And a complete chain should be visible

  @pick-inventory @acquisition-history
  Scenario: Track original pick owner
    Given picks are traded multiple times
    When viewing pick details
    Then original owner should be traceable
    And trade path should be clear

  @pick-inventory @multi-year-view
  Scenario: View multi-year pick outlook
    Given picks span multiple years
    When viewing multi-year view
    Then all years should be visible
    And pick capital should be summarized

  @pick-inventory @multi-year-view
  Scenario: Project pick values
    Given future pick values are uncertain
    When projecting values
    Then estimated ranges should be shown
    And value scenarios should be available

  # ==================== Rookie Draft Formats ====================

  @draft-formats @linear-draft
  Scenario: Conduct linear rookie draft
    Given a linear format is selected
    When drafting
    Then pick order should remain constant each round
    And no snake should occur

  @draft-formats @linear-draft
  Scenario: Configure linear draft settings
    Given linear draft is configured
    When setting up draft
    Then settings should include pick timer
    And round count should be specified

  @draft-formats @snake-draft
  Scenario: Conduct snake rookie draft
    Given a snake format is selected
    When drafting
    Then order should reverse each round
    And snake pattern should apply

  @draft-formats @snake-draft
  Scenario: Display snake draft order
    Given snake format is active
    When viewing draft order
    Then snake pattern should be visible
    And pick positions should be clear

  @draft-formats @auction-rookie-draft
  Scenario: Conduct auction rookie draft
    Given an auction format is selected
    When drafting
    Then bidding should occur
    And budget constraints should apply

  @draft-formats @auction-rookie-draft
  Scenario: Set rookie auction budget
    Given auction budget is needed
    When configuring budget
    Then budget should be separate from veteran budget
    And rookie-specific limits should apply

  @draft-formats @supplemental-drafts
  Scenario: Conduct supplemental draft
    Given mid-season additions occur
    When running supplemental draft
    Then newly eligible players should be available
    And draft order should follow rules

  @draft-formats @supplemental-drafts
  Scenario: Determine supplemental draft eligibility
    Given some players become eligible mid-season
    When evaluating eligibility
    Then criteria should be applied
    And eligible players should be identified

  # ==================== Taxi Squad Integration ====================

  @taxi-squad @taxi-eligibility
  Scenario: Determine taxi squad eligibility
    Given rookies can go to taxi squad
    When evaluating eligibility
    Then rookie taxi rules should apply
    And eligible rookies should be identified

  @taxi-squad @taxi-eligibility
  Scenario: Place rookie on taxi squad
    Given a rookie is taxi eligible
    When placing on taxi squad
    Then the player should be assigned to taxi
    And taxi limits should be checked

  @taxi-squad @taxi-limits
  Scenario: Enforce taxi squad limits
    Given taxi squad has size limits
    When adding to taxi
    Then limits should be enforced
    And overflow should be prevented

  @taxi-squad @taxi-limits
  Scenario: Display taxi squad capacity
    Given taxi capacity varies
    When viewing taxi status
    Then current count and limit should be shown
    And available spots should be clear

  @taxi-squad @promotion-rules
  Scenario: Promote rookie from taxi
    Given a rookie is on taxi squad
    When promoting to active roster
    Then the promotion should process
    And taxi spot should free up

  @taxi-squad @promotion-rules
  Scenario: Enforce promotion deadlines
    Given promotion deadlines exist
    When a deadline approaches
    Then warnings should be issued
    And mandatory promotions should occur

  @taxi-squad @taxi-draft-picks
  Scenario: Draft directly to taxi squad
    Given direct taxi placement is allowed
    When drafting a rookie
    Then taxi designation can be selected
    And the player should go directly to taxi

  @taxi-squad @taxi-draft-picks
  Scenario: Configure taxi draft settings
    Given taxi settings are configurable
    When configuring draft
    Then options should include
      | option              | values              |
      | direct_taxi_picks   | yes, no             |
      | taxi_round_limit    | rounds 3+, all, none|
      | mandatory_taxi_time | 0-4 weeks           |

  # ==================== Rookie Contract System ====================

  @contracts @salary-slots
  Scenario: Assign rookie salary slots
    Given rookies have salary implications
    When drafting a rookie
    Then a salary slot should be assigned
    And slot value should be based on pick

  @contracts @salary-slots
  Scenario: Display rookie salary scale
    Given salaries are pick-based
    When viewing salary scale
    Then values should be shown
      | pick_range    | salary      |
      | 1.01-1.04     | $5-$4       |
      | 1.05-1.12     | $3-$2       |
      | 2.01-2.12     | $1.5-$1     |
      | 3.01+         | $0.5        |

  @contracts @contract-years
  Scenario: Assign rookie contract years
    Given rookies get multi-year contracts
    When assigning contract
    Then contract length should be set
    And years should be based on pick position

  @contracts @contract-years
  Scenario: Track rookie contract status
    Given contracts have terms
    When viewing contract status
    Then years remaining should be shown
    And expiration should be visible

  @contracts @cap-implications
  Scenario: Calculate cap implications
    Given salary cap exists
    When adding a rookie
    Then cap impact should be calculated
    And cap space should update

  @contracts @cap-implications
  Scenario: Project multi-year cap impact
    Given contracts span years
    When projecting cap
    Then future year impacts should be shown
    And cap planning should be supported

  @contracts @signing-bonuses
  Scenario: Apply signing bonuses
    Given signing bonuses exist
    When assigning bonus
    Then bonus should be prorated
    And cap hit should be calculated

  @contracts @signing-bonuses
  Scenario: Configure bonus rules
    Given bonus rules are configurable
    When setting rules
    Then options should include
      | option              | values              |
      | bonus_available     | yes, no             |
      | proration_years     | 1-4 years           |
      | max_bonus           | percentage of salary|

  # ==================== Rookie Draft Results ====================

  @draft-results @draft-recap
  Scenario: Generate rookie draft recap
    Given the draft is complete
    When generating recap
    Then all picks should be summarized
    And key details should be included

  @draft-results @draft-recap
  Scenario: Display recap by round
    Given multiple rounds were drafted
    When viewing by round
    Then round-by-round breakdown should be shown
    And round themes should be noted

  @draft-results @class-grades
  Scenario: Grade rookie draft classes
    Given draft analysis is available
    When grading classes
    Then each team should receive a grade
    And methodology should be explained

  @draft-results @class-grades
  Scenario: Compare class grades
    Given all teams are graded
    When comparing grades
    Then rankings should be displayed
    And grade distribution should be shown

  @draft-results @value-analysis
  Scenario: Analyze draft value
    Given value metrics exist
    When analyzing value
    Then picks should be evaluated vs rankings
    And value picks should be identified

  @draft-results @value-analysis
  Scenario: Identify steals and reaches
    Given ADP data exists
    When evaluating picks
    Then steals should be highlighted
    And reaches should be noted

  @draft-results @historical-comparisons
  Scenario: Compare to historical drafts
    Given historical data exists
    When comparing drafts
    Then similarities should be identified
    And trends should be analyzed

  @draft-results @historical-comparisons
  Scenario: Project class success
    Given historical outcomes are known
    When projecting success
    Then success rates should be estimated
    And comparisons should be drawn
