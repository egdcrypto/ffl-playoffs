@superflex @platform
Feature: Superflex
  As a fantasy football league
  I need superflex functionality
  So that owners can utilize flexible QB roster spots for strategic depth

  Background:
    Given the superflex system is operational
    And superflex rules are configured

  # ==================== Superflex Position ====================

  @superflex-position @superflex-slot
  Scenario: Configure superflex roster slot
    Given a league uses superflex format
    When configuring roster positions
    Then a superflex slot should be available
    And it should accept multiple positions

  @superflex-position @superflex-slot
  Scenario: Display superflex slot in lineup
    Given a team has a superflex slot
    When viewing the lineup
    Then the superflex position should be displayed
    And eligible positions should be indicated

  @superflex-position @eligible-positions
  Scenario: Define superflex eligible positions
    Given a superflex slot is configured
    When determining eligibility
    Then the following positions should be eligible
      | position | eligible |
      | QB       | yes      |
      | RB       | yes      |
      | WR       | yes      |
      | TE       | yes      |
      | K        | no       |
      | DEF      | no       |

  @superflex-position @eligible-positions
  Scenario: Restrict superflex to skill positions
    Given superflex excludes certain positions
    When attempting to start an ineligible player
    Then the action should be blocked
    And eligible positions should be displayed

  @superflex-position @qb-flexibility
  Scenario: Start QB in superflex slot
    Given a team has multiple QBs
    When setting their lineup
    Then they can start a QB in the superflex
    And benefit from QB production

  @superflex-position @qb-flexibility
  Scenario: Choose between QB and skill player
    Given a superflex decision must be made
    When evaluating options
    Then QB value should be compared to alternatives
    And optimal choice should be highlighted

  @superflex-position @position-versatility
  Scenario: Utilize position versatility
    Given superflex allows multiple positions
    When a QB is unavailable
    Then an RB, WR, or TE can fill the slot
    And the lineup remains valid

  @superflex-position @position-versatility
  Scenario: Handle bye weeks with versatility
    Given a starting QB has a bye
    When setting the lineup
    Then alternative positions can fill superflex
    And the owner has flexibility

  @superflex-position @superflex-optimization
  Scenario: Optimize superflex lineup
    Given multiple options exist for superflex
    When optimizing the lineup
    Then highest projected scorer should be suggested
    And position context should be provided

  @superflex-position @superflex-optimization
  Scenario: Calculate optimal superflex start
    Given projections are available
    When calculating optimal start
    Then all eligible players should be compared
    And recommendation should be made

  # ==================== QB Premium Scoring ====================

  @qb-premium @enhanced-scoring
  Scenario: Configure enhanced QB scoring
    Given superflex leagues often use QB premium
    When configuring scoring
    Then QB scoring enhancements should be available
    And settings should be adjustable

  @qb-premium @enhanced-scoring
  Scenario: Apply QB scoring boost
    Given QB premium is enabled
    When a QB scores
    Then enhanced points should be awarded
    And the boost should be visible

  @qb-premium @passing-td-value
  Scenario: Increase passing TD value
    Given passing TDs are typically undervalued
    When configuring passing TD scoring
    Then higher point values should be available
      | setting          | standard | premium |
      | passing_td       | 4 pts    | 6 pts   |
      | passing_yards    | 25:1     | 20:1    |

  @qb-premium @passing-td-value
  Scenario: Balance passing and rushing TDs
    Given rushing TDs are valued at 6 points
    When setting passing TD value
    Then parity options should be available
    And balance should be achievable

  @qb-premium @qb-point-boost
  Scenario: Apply points per completion
    Given QB premium can include PPC
    When configuring PPC
    Then completions should earn points
      | setting          | points |
      | per_completion   | 0.5    |
      | per_incompletion | -0.25  |

  @qb-premium @qb-point-boost
  Scenario: Configure first down passing bonus
    Given first downs are valuable
    When adding first down bonus
    Then passing first downs should score extra
    And the bonus should be configurable

  @qb-premium @premium-settings
  Scenario: Choose QB premium preset
    Given multiple premium options exist
    When selecting a preset
    Then presets should be available
      | preset       | passing_td | yards_per_point |
      | standard     | 4          | 25              |
      | light_premium| 5          | 25              |
      | full_premium | 6          | 20              |

  @qb-premium @premium-settings
  Scenario: Customize premium settings
    Given presets may not fit all leagues
    When customizing settings
    Then all QB scoring options should be editable
    And custom configuration should be saved

  @qb-premium @scoring-balance
  Scenario: Balance QB and skill player scoring
    Given QB premium affects league balance
    When evaluating scoring
    Then QB vs RB/WR value should be compared
    And balance should be displayed

  @qb-premium @scoring-balance
  Scenario: Display scoring distribution
    Given scoring varies by position
    When viewing league statistics
    Then position scoring distribution should be shown
    And QB percentage should be visible

  # ==================== Superflex Drafting ====================

  @superflex-drafting @qb-draft-strategy
  Scenario: Apply superflex draft strategy
    Given superflex changes QB value
    When preparing for draft
    Then superflex-specific strategy should be used
    And QB priority should increase

  @superflex-drafting @qb-draft-strategy
  Scenario: Prioritize QBs in superflex drafts
    Given QBs are more valuable in superflex
    When drafting
    Then QB ADP should be adjusted upward
    And early QB selection should be considered

  @superflex-drafting @early-qb-value
  Scenario: Evaluate early round QB value
    Given elite QBs are scarce
    When evaluating first round picks
    Then top QBs should be valued highly
    And opportunity cost should be calculated

  @superflex-drafting @early-qb-value
  Scenario: Compare QB to other positions early
    Given draft position affects options
    When comparing early round options
    Then QB vs RB/WR value should be analyzed
    And recommendations should be provided

  @superflex-drafting @qb-scarcity
  Scenario: Account for QB scarcity
    Given only 32 starting QBs exist
    When planning draft strategy
    Then scarcity should be factored
    And drop-off points should be identified

  @superflex-drafting @qb-scarcity
  Scenario: Identify QB tier breaks
    Given QB talent has tiers
    When viewing QB rankings
    Then tier breaks should be highlighted
      | tier   | range     | description        |
      | elite  | QB1-QB3   | league winners     |
      | strong | QB4-QB8   | every week starters|
      | average| QB9-QB15  | startable QBs      |
      | depth  | QB16+     | bye week fills     |

  @superflex-drafting @draft-position-impact
  Scenario: Adjust strategy by draft position
    Given draft position affects options
    When adjusting strategy
    Then early picks should consider elite QBs
    And late picks should plan for value

  @superflex-drafting @draft-position-impact
  Scenario: Plan for QB runs
    Given QB runs occur in superflex drafts
    When preparing for runs
    Then run timing should be anticipated
    And counter-strategies should be available

  @superflex-drafting @tier-based-drafting
  Scenario: Use tier-based drafting approach
    Given tiers help draft decisions
    When drafting by tiers
    Then tier values should guide picks
    And position needs should be balanced

  @superflex-drafting @tier-based-drafting
  Scenario: Balance QB and position tiers
    Given multiple tiers exist
    When making draft decisions
    Then tier comparisons should be shown
    And optimal picks should be suggested

  # ==================== Superflex Rankings ====================

  @superflex-rankings @player-rankings
  Scenario: Display superflex player rankings
    Given rankings differ in superflex
    When viewing rankings
    Then superflex-adjusted rankings should appear
    And QB rankings should be elevated

  @superflex-rankings @player-rankings
  Scenario: Compare superflex to standard rankings
    Given formats value players differently
    When comparing rankings
    Then ranking differences should be shown
    And position-specific adjustments should be visible

  @superflex-rankings @qb-rankings-boost
  Scenario: Apply QB rankings boost
    Given QBs are more valuable in superflex
    When generating rankings
    Then QB rankings should be boosted
    And elite QBs should rank with top RBs/WRs

  @superflex-rankings @qb-rankings-boost
  Scenario: Quantify QB value increase
    Given QB value increases in superflex
    When measuring increase
    Then value boost should be calculated
    And comparison to standard should be shown

  @superflex-rankings @position-adjustments
  Scenario: Adjust all position rankings
    Given superflex affects all positions
    When adjusting rankings
    Then relative values should shift
      | position | adjustment     |
      | QB       | significant up |
      | RB       | slight down    |
      | WR       | slight down    |
      | TE       | minimal change |

  @superflex-rankings @position-adjustments
  Scenario: Calculate positional value
    Given positions have relative values
    When calculating position value
    Then superflex adjustments should apply
    And position scarcity should be factored

  @superflex-rankings @superflex-adp
  Scenario: Display superflex ADP
    Given ADP varies by format
    When viewing superflex ADP
    Then superflex-specific ADP should be shown
    And QB ADP should reflect increased value

  @superflex-rankings @superflex-adp
  Scenario: Track ADP changes
    Given ADP evolves over time
    When tracking ADP trends
    Then rising and falling players should be identified
    And trends should be visualized

  @superflex-rankings @value-rankings
  Scenario: Generate value-based rankings
    Given value over replacement matters
    When generating value rankings
    Then VOR should be calculated for superflex
    And QB VOR should be appropriately higher

  @superflex-rankings @value-rankings
  Scenario: Compare value across positions
    Given cross-position value is important
    When comparing value
    Then unified value metric should be used
    And position-agnostic rankings should be available

  # ==================== Superflex Trades ====================

  @superflex-trades @qb-trade-value
  Scenario: Assess QB trade value
    Given QBs are premium in superflex
    When evaluating QB trades
    Then elevated value should be reflected
    And QB scarcity should be considered

  @superflex-trades @qb-trade-value
  Scenario: Display QB trade worth
    Given trade value is important
    When viewing QB trade value
    Then superflex value should be displayed
    And comparable players should be shown

  @superflex-trades @trade-calculator
  Scenario: Use superflex trade calculator
    Given trade calculators help decisions
    When using the calculator
    Then superflex values should be applied
    And QB premium should be factored

  @superflex-trades @trade-calculator
  Scenario: Calculate superflex trade fairness
    Given trade fairness is subjective
    When evaluating a trade
    Then superflex value should be calculated
    And fairness rating should be provided

  @superflex-trades @positional-value
  Scenario: Compare positional trade values
    Given positions have different values
    When trading across positions
    Then relative values should be compared
    And fair compensation should be suggested

  @superflex-trades @positional-value
  Scenario: Trade QB for skill players
    Given QB-for-RB/WR trades are common
    When evaluating such trades
    Then value equivalence should be shown
    And appropriate return should be calculated

  @superflex-trades @trade-leverage
  Scenario: Leverage QB scarcity in trades
    Given QB scarcity creates leverage
    When negotiating trades
    Then leverage position should be assessed
    And negotiation tips should be provided

  @superflex-trades @trade-leverage
  Scenario: Identify trade-needy teams
    Given some teams need QBs
    When seeking trade partners
    Then QB-needy teams should be identified
    And trade likelihood should be assessed

  @superflex-trades @fair-value
  Scenario: Determine fair trade value
    Given fair value is important
    When proposing trades
    Then fair value should be suggested
    And both sides should be balanced

  @superflex-trades @fair-value
  Scenario: Display trade value chart
    Given trade charts help negotiations
    When viewing trade values
    Then superflex-adjusted chart should be shown
    And position values should be clear

  # ==================== Superflex Roster Construction ====================

  @roster-construction @roster-balance
  Scenario: Balance superflex roster
    Given roster balance is crucial
    When constructing the roster
    Then QB depth should be prioritized
    And overall balance should be maintained

  @roster-construction @roster-balance
  Scenario: Evaluate roster composition
    Given roster composition affects success
    When evaluating the roster
    Then position balance should be displayed
    And recommendations should be provided

  @roster-construction @qb-depth
  Scenario: Build QB depth
    Given QB depth is essential in superflex
    When rostering QBs
    Then multiple startable QBs should be targeted
    And depth value should be considered

  @roster-construction @qb-depth
  Scenario: Determine optimal QB roster count
    Given QB roster count varies
    When planning roster
    Then optimal count should be suggested
      | roster_size | recommended_qbs |
      | 15 players  | 3 QBs           |
      | 20 players  | 4 QBs           |
      | 25 players  | 4-5 QBs         |

  @roster-construction @backup-qb-value
  Scenario: Value backup QBs appropriately
    Given backup QBs have value in superflex
    When evaluating backup QBs
    Then their value should be elevated
    And handcuff potential should be considered

  @roster-construction @backup-qb-value
  Scenario: Identify valuable backup QBs
    Given some backups are more valuable
    When targeting backups
    Then situation should be evaluated
    And upside should be assessed

  @roster-construction @roster-flexibility
  Scenario: Maintain roster flexibility
    Given flexibility helps in superflex
    When building roster
    Then versatile players should be valued
    And multiple lineup options should exist

  @roster-construction @roster-flexibility
  Scenario: Plan for lineup versatility
    Given versatility aids weekly decisions
    When planning the roster
    Then flexible options should be maintained
    And lineup permutations should be available

  @roster-construction @bye-week-management
  Scenario: Manage bye weeks effectively
    Given bye weeks challenge superflex
    When planning for byes
    Then QB byes should be prioritized
    And depth should cover bye weeks

  @roster-construction @bye-week-management
  Scenario: Avoid stacked QB byes
    Given QBs sharing byes is problematic
    When selecting QBs
    Then bye weeks should be diversified
    And risk should be minimized

  # ==================== Superflex Waivers ====================

  @superflex-waivers @qb-waiver-priority
  Scenario: Prioritize QB waiver claims
    Given QB waivers are valuable
    When setting waiver priorities
    Then QBs should be prioritized appropriately
    And value should guide decisions

  @superflex-waivers @qb-waiver-priority
  Scenario: Bid on waiver QBs
    Given FAAB is limited
    When bidding on QBs
    Then appropriate value should be bid
    And superflex premium should be applied

  @superflex-waivers @streaming-qbs
  Scenario: Stream QBs in superflex
    Given streaming is a strategy
    When streaming QBs
    Then matchup-based options should be shown
    And streaming viability should be assessed

  @superflex-waivers @streaming-qbs
  Scenario: Identify streaming QB options
    Given streamable QBs exist
    When finding streaming options
    Then available QBs should be listed
    And matchup rankings should be provided

  @superflex-waivers @waiver-strategy
  Scenario: Apply superflex waiver strategy
    Given strategy improves outcomes
    When managing waivers
    Then superflex-specific tips should be available
    And priorities should be suggested

  @superflex-waivers @waiver-strategy
  Scenario: Balance QB and skill player claims
    Given both are needed
    When deciding between claims
    Then relative value should be compared
    And need should be factored

  @superflex-waivers @qb-handcuffs
  Scenario: Target QB handcuffs
    Given backup QBs can become starters
    When targeting handcuffs
    Then high-value handcuffs should be identified
    And situation should be monitored

  @superflex-waivers @qb-handcuffs
  Scenario: Monitor QB injury situations
    Given injuries affect availability
    When monitoring injuries
    Then backup QB situations should be tracked
    And alerts should be provided

  @superflex-waivers @emergency-pickups
  Scenario: Make emergency QB pickups
    Given injuries require quick action
    When a QB emergency occurs
    Then available options should be shown
    And quick adds should be possible

  @superflex-waivers @emergency-pickups
  Scenario: Plan for QB emergencies
    Given emergencies happen
    When planning ahead
    Then contingency options should be identified
    And backup plans should exist

  # ==================== Two-QB Leagues ====================

  @two-qb @2qb-format
  Scenario: Configure 2QB league format
    Given 2QB is different from superflex
    When configuring 2QB league
    Then two QB slots should be required
    And format differences should be noted

  @two-qb @2qb-format
  Scenario: Differentiate 2QB from superflex
    Given formats are similar but different
    When comparing formats
    Then differences should be highlighted
      | aspect          | 2QB           | superflex      |
      | QB requirement  | mandatory 2   | optional 2     |
      | flexibility     | limited       | high           |
      | empty slot risk | penalty       | fill with RB/WR|

  @two-qb @qb-requirements
  Scenario: Enforce 2QB starting requirements
    Given 2QB requires two QBs
    When setting lineup
    Then two QB starters should be required
    And lineup should be incomplete without them

  @two-qb @qb-requirements
  Scenario: Handle insufficient QBs
    Given a team may lack two healthy QBs
    When QBs are unavailable
    Then lineup penalty should be applied
    Or emergency options should be presented

  @two-qb @starting-requirements
  Scenario: Display 2QB starting requirements
    Given requirements must be clear
    When viewing lineup requirements
    Then 2QB requirement should be shown
    And compliance status should be visible

  @two-qb @starting-requirements
  Scenario: Alert for unmet requirements
    Given requirements may not be met
    When lineup is incomplete
    Then alerts should be displayed
    And resolution options should be shown

  @two-qb @roster-construction
  Scenario: Build 2QB roster
    Given 2QB needs more QBs than superflex
    When constructing roster
    Then QB depth should be deeper
    And 4+ QBs should be rostered

  @two-qb @roster-construction
  Scenario: Plan 2QB draft strategy
    Given QB scarcity is extreme in 2QB
    When planning draft
    Then early QB priority should be emphasized
    And multiple QBs should be drafted early

  @two-qb @format-comparison
  Scenario: Compare 2QB and superflex formats
    Given both formats exist
    When comparing formats
    Then key differences should be shown
    And strategic implications should be explained

  @two-qb @format-comparison
  Scenario: Choose between formats
    Given league is deciding on format
    When evaluating options
    Then pros and cons should be displayed
    And recommendation should be available

  # ==================== Superflex Matchups ====================

  @superflex-matchups @qb-matchup-analysis
  Scenario: Analyze QB matchups
    Given matchups affect QB value
    When analyzing QB matchups
    Then opponent defense should be evaluated
    And matchup grade should be provided

  @superflex-matchups @qb-matchup-analysis
  Scenario: Display matchup factors
    Given multiple factors affect matchups
    When viewing matchup details
    Then relevant factors should be shown
      | factor              | impact                    |
      | pass_defense_rank   | points allowed to QBs     |
      | sack_rate           | pressure/risk             |
      | indoor_outdoor      | weather factor            |
      | pace_of_play        | passing volume            |

  @superflex-matchups @streaming-decisions
  Scenario: Make streaming decisions
    Given streaming requires matchup analysis
    When deciding to stream
    Then matchup quality should be compared
    And streaming recommendation should be made

  @superflex-matchups @streaming-decisions
  Scenario: Identify best streaming matchups
    Given some matchups are exploitable
    When finding streaming options
    Then best matchups should be highlighted
    And opportunity should be quantified

  @superflex-matchups @start-sit-qb
  Scenario: Make start/sit QB decisions
    Given multiple QBs may be available
    When deciding who to start
    Then matchup should be considered
    And start/sit recommendation should be provided

  @superflex-matchups @start-sit-qb
  Scenario: Compare QB start options
    Given superflex requires QB decisions
    When comparing QBs
    Then head-to-head comparison should be shown
    And confidence level should be indicated

  @superflex-matchups @weekly-optimization
  Scenario: Optimize weekly superflex lineup
    Given weekly optimization is needed
    When optimizing lineup
    Then superflex should be optimized
    And best lineup should be suggested

  @superflex-matchups @weekly-optimization
  Scenario: Consider game script in optimization
    Given game script affects production
    When projecting performance
    Then game script should be factored
    And script-based adjustments should apply

  @superflex-matchups @matchup-rankings
  Scenario: Generate QB matchup rankings
    Given matchups need rankings
    When generating matchup rankings
    Then QB matchups should be ranked
    And weekly tiers should be assigned

  @superflex-matchups @matchup-rankings
  Scenario: Display weekly matchup tiers
    Given tiers simplify decisions
    When viewing matchup tiers
    Then QB matchups should be tiered
      | tier     | description           |
      | smash    | elite matchups        |
      | start    | good matchups         |
      | consider | average matchups      |
      | avoid    | poor matchups         |

  # ==================== Superflex Strategy ====================

  @superflex-strategy @draft-strategy-guide
  Scenario: Access superflex draft strategy guide
    Given strategy guides help owners
    When accessing draft strategy
    Then superflex-specific guidance should be provided
    And key principles should be explained

  @superflex-strategy @draft-strategy-guide
  Scenario: Learn superflex draft principles
    Given principles guide decisions
    When learning strategy
    Then core principles should be taught
      | principle           | explanation                    |
      | QB early            | draft QBs earlier than standard|
      | secure two starters | ensure two every-week QBs      |
      | value depth         | backup QBs have real value     |
      | tier awareness      | know QB tier breaks            |

  @superflex-strategy @roster-management-tips
  Scenario: Access roster management tips
    Given roster management is ongoing
    When seeking management tips
    Then superflex-specific tips should be provided
    And best practices should be shared

  @superflex-strategy @roster-management-tips
  Scenario: Apply roster management best practices
    Given best practices improve outcomes
    When managing roster
    Then practices should be followed
    And recommendations should be made

  @superflex-strategy @trade-strategies
  Scenario: Learn superflex trade strategies
    Given trading is important
    When learning trade strategies
    Then superflex trade principles should be explained
    And examples should be provided

  @superflex-strategy @trade-strategies
  Scenario: Identify trade opportunities
    Given opportunities arise during season
    When looking for trades
    Then opportunities should be identified
    And value assessments should be provided

  @superflex-strategy @waiver-tactics
  Scenario: Apply waiver tactics
    Given waiver success helps teams
    When applying tactics
    Then superflex waiver tips should be available
    And tactical approaches should be explained

  @superflex-strategy @waiver-tactics
  Scenario: Maximize waiver value
    Given waiver budget is limited
    When managing waivers
    Then value maximization should be prioritized
    And spending strategy should be suggested

  @superflex-strategy @championship-building
  Scenario: Build championship team
    Given the goal is winning
    When building for championship
    Then championship blueprint should be provided
    And key roster elements should be identified

  @superflex-strategy @championship-building
  Scenario: Identify championship roster components
    Given certain elements are needed
    When evaluating roster
    Then championship components should be assessed
      | component           | importance |
      | elite QB            | critical   |
      | second QB           | high       |
      | RB depth            | high       |
      | WR production       | high       |
      | TE advantage        | medium     |
