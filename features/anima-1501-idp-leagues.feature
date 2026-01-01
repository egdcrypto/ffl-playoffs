@idp-leagues
Feature: IDP Leagues
  As a fantasy football manager in an IDP league
  I want comprehensive individual defensive player features
  So that I can manage defensive players alongside offensive players

  # --------------------------------------------------------------------------
  # Defensive Positions
  # --------------------------------------------------------------------------

  @defensive-positions
  Scenario: Configure defensive lineman slots
    Given I am setting up an IDP league
    When I configure defensive lineman (DL) positions
    Then I should set number of DL slots
    And I should define DL eligibility
    And DL configuration should be saved

  @defensive-positions
  Scenario: Configure linebacker slots
    Given I am setting up IDP positions
    When I configure linebacker (LB) positions
    Then I should set number of LB slots
    And I should define LB types (ILB, OLB)
    And LB configuration should be saved

  @defensive-positions
  Scenario: Configure defensive back positions
    Given I am setting up IDP positions
    When I configure defensive back (DB) positions
    Then I should set number of DB slots
    And I should define DB types (CB, S)
    And DB configuration should be saved

  @defensive-positions
  Scenario: Set up edge rusher designation
    Given my league uses edge rushers
    When I configure edge rusher position
    Then I should define edge rusher eligibility
    And I should set edge rusher slots
    And designation should be clear

  @defensive-positions
  Scenario: Configure interior lineman settings
    Given my league distinguishes interior linemen
    When I configure interior lineman
    Then I should set DT/NT eligibility
    And I should configure slot counts
    And settings should be applied

  @defensive-positions
  Scenario: Set up flex defensive positions
    Given I want flexible IDP slots
    When I configure defensive flex
    Then I should set D-FLEX positions
    And I should define eligible positions
    And flex should provide flexibility

  @defensive-positions
  Scenario: Define positional eligibility rules
    Given positions have eligibility rules
    When I define eligibility
    Then rules should be clear
    And player assignments should follow rules
    And eligibility should be enforced

  @defensive-positions
  Scenario: Manage position scarcity
    Given some positions are scarce
    When I view position scarcity
    Then I should see scarcity levels
    And I should understand value implications
    And I should draft accordingly

  @defensive-positions
  Scenario: Handle multi-position players
    Given some players have multiple positions
    When I roster multi-position IDP
    Then I should see all eligible positions
    And I should start at any eligible position
    And flexibility should be provided

  @defensive-positions
  Scenario: View position display
    Given I have IDP players rostered
    When I view my lineup
    Then positions should be clearly displayed
    And IDP positions should be distinct
    And display should be intuitive

  # --------------------------------------------------------------------------
  # IDP Scoring Settings
  # --------------------------------------------------------------------------

  @idp-scoring
  Scenario: Configure tackle scoring
    Given I am setting up IDP scoring
    When I configure tackle scoring
    Then I should set solo tackle points
    And I should set assisted tackle points
    And tackle scoring should be saved

  @idp-scoring
  Scenario: Set sack scoring
    Given sacks are key defensive plays
    When I configure sack scoring
    Then I should set sack point value
    And I should set half-sack handling
    And sack scoring should be applied

  @idp-scoring
  Scenario: Configure interception points
    Given interceptions are high-value plays
    When I set interception scoring
    Then I should set INT point value
    And I should set INT return yards bonus
    And interception scoring should be saved

  @idp-scoring
  Scenario: Set forced fumble scoring
    Given forced fumbles are impactful
    When I configure forced fumble scoring
    Then I should set FF point value
    And scoring should be applied
    And FF should be tracked

  @idp-scoring
  Scenario: Configure fumble recovery points
    Given fumble recoveries score points
    When I set fumble recovery scoring
    Then I should set FR point value
    And I should set FR return yards bonus
    And recovery scoring should be saved

  @idp-scoring
  Scenario: Set pass deflection scoring
    Given pass deflections show coverage skill
    When I configure PD scoring
    Then I should set pass deflection points
    And scoring should be applied
    And PDs should be tracked

  @idp-scoring
  Scenario: Configure safety points
    Given safeties are rare and valuable
    When I set safety scoring
    Then I should set safety point value
    And scoring should reflect rarity
    And safeties should be tracked

  @idp-scoring
  Scenario: Set blocked kick scoring
    Given blocked kicks are impactful
    When I configure blocked kick scoring
    Then I should set blocked kick points
    And special teams blocks should count
    And scoring should be applied

  @idp-scoring
  Scenario: Configure defensive touchdown bonuses
    Given defensive TDs are exciting
    When I set defensive TD scoring
    Then I should set return TD points
    And I should set TD bonus points
    And scoring should be applied

  @idp-scoring
  Scenario: Set tackles for loss scoring
    Given TFLs show playmaking ability
    When I configure TFL scoring
    Then I should set TFL point value
    And TFLs should be tracked
    And scoring should be applied

  # --------------------------------------------------------------------------
  # IDP Roster Configuration
  # --------------------------------------------------------------------------

  @idp-roster-config
  Scenario: Set IDP roster slot counts
    Given I am configuring IDP roster
    When I set slot counts
    Then I should set total IDP slots
    And I should set per-position slots
    And configuration should be saved

  @idp-roster-config
  Scenario: Define minimum IDP requirements
    Given lineups need minimum IDP
    When I set minimum requirements
    Then minimum IDP starters should be defined
    And requirements should be enforced
    And lineups should comply

  @idp-roster-config
  Scenario: Configure IDP flex positions
    Given flex provides flexibility
    When I configure IDP flex
    Then I should set flex slot count
    And I should define eligible positions
    And flex should work correctly

  @idp-roster-config
  Scenario: Set balanced roster requirements
    Given balance between offense and defense matters
    When I set balance requirements
    Then I should define balance rules
    And requirements should be clear
    And balance should be enforced

  @idp-roster-config
  Scenario: Configure offensive to defensive ratio
    Given ratio affects roster construction
    When I set O/D ratio
    Then ratio should be defined
    And roster limits should reflect ratio
    And ratio should be enforced

  @idp-roster-config
  Scenario: Set bench IDP limits
    Given bench has IDP limits
    When I configure bench limits
    Then I should set max bench IDP
    And limits should be enforced
    And I should manage bench accordingly

  @idp-roster-config
  Scenario: Handle IR IDP rules
    Given IDP players can be on IR
    When I configure IR IDP rules
    Then IR should apply to IDP
    And IR rules should be consistent
    And IDP IR should work correctly

  @idp-roster-config
  Scenario: Set IDP taxi squad rules
    Given dynasty leagues have taxi squads
    When I configure IDP taxi rules
    Then I should set IDP taxi eligibility
    And I should set IDP taxi limits
    And rules should be applied

  @idp-roster-config
  Scenario: Define starting lineup requirements
    Given starting lineup has rules
    When I define requirements
    Then I should set required starters
    And requirements should be clear
    And lineups should comply

  @idp-roster-config
  Scenario: Calculate roster size
    Given roster size includes IDP
    When I view roster size
    Then total roster should be calculated
    And IDP slots should be included
    And size should be accurate

  # --------------------------------------------------------------------------
  # IDP Draft Strategy
  # --------------------------------------------------------------------------

  @idp-draft-strategy
  Scenario: Determine IDP draft timing
    Given IDP timing affects value
    When I plan IDP draft timing
    Then I should understand when to draft IDP
    And I should see positional timing
    And I should optimize my approach

  @idp-draft-strategy
  Scenario: Understand positional value by round
    Given value varies by round
    When I view positional value
    Then I should see value by position
    And I should see round recommendations
    And I should draft accordingly

  @idp-draft-strategy
  Scenario: Apply linebacker premium strategy
    Given LBs are often most valuable
    When I apply LB premium strategy
    Then I should target elite LBs
    And I should understand LB value
    And I should build LB advantage

  @idp-draft-strategy
  Scenario: Evaluate defensive back value
    Given DBs have specific value
    When I evaluate DB value
    Then I should understand DB scoring patterns
    And I should see DB rankings
    And I should value DBs correctly

  @idp-draft-strategy
  Scenario: Address edge rusher scarcity
    Given elite edge rushers are scarce
    When I address edge scarcity
    Then I should understand scarcity impact
    And I should identify value picks
    And I should plan accordingly

  @idp-draft-strategy
  Scenario: Use IDP ADP integration
    Given ADP helps draft planning
    When I use IDP ADP
    Then I should see IDP-specific ADP
    And I should compare to my rankings
    And I should find value

  @idp-draft-strategy
  Scenario: Participate in IDP mock drafts
    Given practice helps preparation
    When I do IDP mock drafts
    Then I should practice IDP drafting
    And I should test strategies
    And I should improve

  @idp-draft-strategy
  Scenario: Access IDP draft rankings
    Given rankings guide drafting
    When I access IDP rankings
    Then I should see comprehensive rankings
    And I should see positional rankings
    And I should use for drafting

  @idp-draft-strategy
  Scenario: Identify IDP sleepers
    Given sleepers provide value
    When I identify IDP sleepers
    Then I should see undervalued players
    And I should see sleeper reasoning
    And I should target value

  @idp-draft-strategy
  Scenario: Analyze IDP draft results
    Given draft analysis helps improvement
    When I analyze my IDP draft
    Then I should see IDP evaluation
    And I should see strengths and weaknesses
    And I should learn from results

  # --------------------------------------------------------------------------
  # IDP Waiver Wire
  # --------------------------------------------------------------------------

  @idp-waiver-wire
  Scenario: Set IDP waiver priorities
    Given waivers need prioritization
    When I set IDP waiver priorities
    Then I should prioritize IDP claims
    And I should rank IDP targets
    And priorities should guide claims

  @idp-waiver-wire
  Scenario: Stream defensive matchups
    Given matchups affect IDP value
    When I stream based on matchups
    Then I should identify favorable matchups
    And I should target streamable IDP
    And I should optimize weekly

  @idp-waiver-wire
  Scenario: Identify IDP waiver targets
    Given waivers have valuable adds
    When I identify targets
    Then I should see top IDP adds
    And I should see reasoning
    And I should prioritize claims

  @idp-waiver-wire
  Scenario: Analyze snap counts
    Given snaps indicate opportunity
    When I analyze snap counts
    Then I should see snap percentages
    And I should see trending players
    And I should identify opportunities

  @idp-waiver-wire
  Scenario: Evaluate IDP opportunity metrics
    Given opportunity drives production
    When I evaluate opportunities
    Then I should see opportunity metrics
    And I should see role changes
    And I should identify value

  @idp-waiver-wire
  Scenario: Access waiver wire IDP rankings
    Given rankings guide waiver decisions
    When I access waiver rankings
    Then I should see IDP waiver rankings
    And I should see add priorities
    And I should make informed decisions

  @idp-waiver-wire
  Scenario: Evaluate IDP free agent values
    Given free agents have value
    When I evaluate free agents
    Then I should see available IDP
    And I should see their values
    And I should identify pickups

  @idp-waiver-wire
  Scenario: Understand defensive scheme impact
    Given scheme affects production
    When I analyze scheme impact
    Then I should see scheme information
    And I should understand impact
    And I should factor into decisions

  @idp-waiver-wire
  Scenario: Process IDP waiver claims
    Given I make waiver claims
    When claims process
    Then IDP claims should process correctly
    And players should be added
    And roster should update

  @idp-waiver-wire
  Scenario: Apply IDP waiver strategy
    Given strategy guides waiver use
    When I apply strategy
    Then I should follow IDP waiver approach
    And I should optimize claims
    And I should improve roster

  # --------------------------------------------------------------------------
  # IDP Player Stats
  # --------------------------------------------------------------------------

  @idp-player-stats
  Scenario: View tackle statistics
    Given tackles are primary IDP stat
    When I view tackle stats
    Then I should see solo tackles
    And I should see assisted tackles
    And I should see tackle trends

  @idp-player-stats
  Scenario: Track sacks
    Given sacks are high-impact plays
    When I track sacks
    Then I should see sack totals
    And I should see sack trends
    And I should see sack leaders

  @idp-player-stats
  Scenario: View turnover statistics
    Given turnovers are crucial
    When I view turnover stats
    Then I should see interceptions
    And I should see forced fumbles
    And I should see fumble recoveries

  @idp-player-stats
  Scenario: Analyze pass rush metrics
    Given pass rush affects sacks
    When I analyze pass rush
    Then I should see pressures
    And I should see QB hurries
    And I should see pass rush efficiency

  @idp-player-stats
  Scenario: View coverage statistics
    Given coverage affects DB value
    When I view coverage stats
    Then I should see pass deflections
    And I should see targets allowed
    And I should see coverage grades

  @idp-player-stats
  Scenario: Track snap count percentages
    Given snaps indicate usage
    When I track snap counts
    Then I should see snap percentages
    And I should see snap trends
    And I should evaluate playing time

  @idp-player-stats
  Scenario: View defensive efficiency metrics
    Given efficiency matters
    When I view efficiency metrics
    Then I should see tackle efficiency
    And I should see big play rate
    And I should see advanced metrics

  @idp-player-stats
  Scenario: Track big plays
    Given big plays are impactful
    When I track big plays
    Then I should see TFLs
    And I should see sacks
    And I should see turnovers created

  @idp-player-stats
  Scenario: Measure consistency metrics
    Given consistency matters in fantasy
    When I measure consistency
    Then I should see consistency scores
    And I should see weekly variance
    And I should evaluate reliability

  @idp-player-stats
  Scenario: Access advanced IDP analytics
    Given advanced stats provide insight
    When I access advanced analytics
    Then I should see advanced metrics
    And I should see analytical breakdowns
    And I should gain deeper insights

  # --------------------------------------------------------------------------
  # IDP Projections
  # --------------------------------------------------------------------------

  @idp-projections
  Scenario: View weekly IDP projections
    Given projections guide decisions
    When I view weekly projections
    Then I should see IDP projections
    And I should see projected stats
    And I should set lineup accordingly

  @idp-projections
  Scenario: See matchup-based projections
    Given matchups affect projections
    When I view matchup projections
    Then I should see matchup impact
    And I should see adjusted projections
    And I should understand matchup effects

  @idp-projections
  Scenario: Understand game script impact
    Given game script affects IDP
    When I analyze game script impact
    Then I should see projected game flow
    And I should see tackle opportunity impact
    And I should adjust expectations

  @idp-projections
  Scenario: View IDP ceiling projections
    Given ceiling matters for upside
    When I view ceiling projections
    Then I should see upside projections
    And I should see ceiling scenarios
    And I should evaluate boom potential

  @idp-projections
  Scenario: View IDP floor projections
    Given floor provides safety
    When I view floor projections
    Then I should see floor projections
    And I should see minimum expectations
    And I should evaluate safety

  @idp-projections
  Scenario: Track projection accuracy
    Given accuracy builds trust
    When I track projection accuracy
    Then I should see historical accuracy
    And I should see projection performance
    And I should trust accurate sources

  @idp-projections
  Scenario: Access expert IDP projections
    Given experts provide projections
    When I access expert projections
    Then I should see multiple experts
    And I should see expert reasoning
    And I should evaluate options

  @idp-projections
  Scenario: View consensus IDP rankings
    Given consensus reduces variance
    When I view consensus
    Then I should see aggregated rankings
    And I should see consensus levels
    And I should use for decisions

  @idp-projections
  Scenario: Understand projection model transparency
    Given understanding models helps
    When I view model transparency
    Then I should see model methodology
    And I should see inputs used
    And I should understand approach

  @idp-projections
  Scenario: Receive projection updates
    Given projections change
    When updates occur
    Then I should see updated projections
    And I should see what changed
    And I should adjust accordingly

  # --------------------------------------------------------------------------
  # IDP Rankings
  # --------------------------------------------------------------------------

  @idp-rankings
  Scenario: View overall IDP rankings
    Given overall rankings guide decisions
    When I view overall IDP rankings
    Then I should see comprehensive rankings
    And I should see all IDP positions
    And I should use for decisions

  @idp-rankings
  Scenario: View positional IDP rankings
    Given positions have separate rankings
    When I view positional rankings
    Then I should see DL rankings
    And I should see LB rankings
    And I should see DB rankings

  @idp-rankings
  Scenario: Access dynasty IDP rankings
    Given dynasty values differ
    When I access dynasty rankings
    Then I should see long-term values
    And I should see age considerations
    And I should see dynasty tiers

  @idp-rankings
  Scenario: Access redraft IDP rankings
    Given redraft focuses on current year
    When I access redraft rankings
    Then I should see current season rankings
    And I should see weekly values
    And I should use for redraft leagues

  @idp-rankings
  Scenario: View IDP tier rankings
    Given tiers help decision-making
    When I view tier rankings
    Then I should see players in tiers
    And I should see tier breaks
    And I should identify tier value

  @idp-rankings
  Scenario: See expert IDP consensus
    Given expert consensus is valuable
    When I view expert consensus
    Then I should see aggregated expert rankings
    And I should see agreement levels
    And I should see outlier opinions

  @idp-rankings
  Scenario: Receive IDP ranking updates
    Given rankings change weekly
    When rankings update
    Then I should see updated rankings
    And I should see what changed
    And I should see movement

  @idp-rankings
  Scenario: Customize IDP rankings
    Given I have my own opinions
    When I customize rankings
    Then I should adjust player values
    And I should save my rankings
    And rankings should be personal

  @idp-rankings
  Scenario: View IDP ranking explanations
    Given understanding rankings helps
    When I view explanations
    Then I should see ranking reasoning
    And I should understand methodology
    And I should trust rankings

  @idp-rankings
  Scenario: Access IDP ranking history
    Given history shows trends
    When I access ranking history
    Then I should see past rankings
    And I should see player trends
    And I should see ranking changes

  # --------------------------------------------------------------------------
  # IDP Trade Values
  # --------------------------------------------------------------------------

  @idp-trade-values
  Scenario: Use IDP trade calculator
    Given trade evaluation is complex
    When I use IDP trade calculator
    Then I should input trade pieces
    And I should see IDP values
    And I should see trade recommendation

  @idp-trade-values
  Scenario: Understand positional value differences
    Given positions have different values
    When I compare positional values
    Then I should see relative values
    And I should understand differences
    And I should trade accordingly

  @idp-trade-values
  Scenario: View IDP dynasty values
    Given dynasty values are long-term
    When I view dynasty values
    Then I should see long-term values
    And I should see age adjustments
    And I should evaluate dynasty worth

  @idp-trade-values
  Scenario: View IDP keeper values
    Given keeper leagues have specific values
    When I view keeper values
    Then I should see keeper-adjusted values
    And I should see cost considerations
    And I should evaluate keeper worth

  @idp-trade-values
  Scenario: Analyze IDP trades
    Given analysis helps decisions
    When I analyze IDP trade
    Then I should see trade breakdown
    And I should see value comparison
    And I should make informed decision

  @idp-trade-values
  Scenario: Get IDP trade suggestions
    Given suggestions help optimization
    When I get trade suggestions
    Then I should see trade opportunities
    And I should see potential targets
    And I should find improvements

  @idp-trade-values
  Scenario: View IDP value trends
    Given values change over time
    When I view value trends
    Then I should see trending up players
    And I should see trending down players
    And I should act on trends

  @idp-trade-values
  Scenario: Understand IDP age curves
    Given age affects value trajectory
    When I view age curves
    Then I should see positional age curves
    And I should see player-specific curves
    And I should plan for aging

  @idp-trade-values
  Scenario: Monitor IDP situation changes
    Given situations affect value
    When I monitor situation changes
    Then I should see role changes
    And I should see scheme changes
    And I should adjust values

  @idp-trade-values
  Scenario: View IDP trade history
    Given history provides context
    When I view trade history
    Then I should see past IDP trades
    And I should see trade values used
    And I should learn from history

  # --------------------------------------------------------------------------
  # IDP League Settings
  # --------------------------------------------------------------------------

  @idp-league-settings
  Scenario: Configure scoring balance
    Given balance affects strategy
    When I configure scoring balance
    Then I should set offense/defense balance
    And I should see impact on values
    And balance should be applied

  @idp-league-settings
  Scenario: Set IDP weight vs offense
    Given weighting affects importance
    When I set IDP weight
    Then I should configure relative importance
    And I should see scoring implications
    And weighting should be clear

  @idp-league-settings
  Scenario: Use league type presets
    Given presets simplify setup
    When I use presets
    Then I should see IDP league presets
    And I should select appropriate preset
    And settings should be applied

  @idp-league-settings
  Scenario: Create custom IDP settings
    Given custom settings provide flexibility
    When I create custom settings
    Then I should configure all settings
    And settings should be saved
    And custom settings should apply

  @idp-league-settings
  Scenario: Use IDP commissioner tools
    Given commissioners need tools
    When I use commissioner tools
    Then I should manage IDP settings
    And I should resolve issues
    And tools should be comprehensive

  @idp-league-settings
  Scenario: View IDP rule explanations
    Given rules need clarity
    When I view rule explanations
    Then I should see clear explanations
    And I should understand all rules
    And rules should be documented

  @idp-league-settings
  Scenario: Get IDP setting recommendations
    Given recommendations help setup
    When I get recommendations
    Then I should see suggested settings
    And I should see reasoning
    And I should apply recommendations

  @idp-league-settings
  Scenario: Compare IDP league settings
    Given comparison helps understanding
    When I compare league settings
    Then I should see settings comparison
    And I should see differences
    And I should understand impact

  @idp-league-settings
  Scenario: Import IDP settings
    Given importing saves time
    When I import settings
    Then settings should be imported
    And I should verify settings
    And import should be complete

  @idp-league-settings
  Scenario: Export IDP settings
    Given exporting enables sharing
    When I export settings
    Then settings should be exported
    And I should choose format
    And export should be complete

  # --------------------------------------------------------------------------
  # IDP Accessibility
  # --------------------------------------------------------------------------

  @idp-leagues @accessibility
  Scenario: Navigate IDP features with screen reader
    Given I use a screen reader
    When I use IDP features
    Then all features should be accessible
    And content should be announced
    And navigation should be clear

  @idp-leagues @accessibility
  Scenario: Use IDP features with keyboard
    Given I use keyboard navigation
    When I navigate IDP features
    Then I should access all features
    And I should use keyboard shortcuts
    And focus should be visible

  # --------------------------------------------------------------------------
  # Error Handling and Edge Cases
  # --------------------------------------------------------------------------

  @idp-leagues @error-handling
  Scenario: Handle IDP stat discrepancies
    Given stats may have discrepancies
    When discrepancy occurs
    Then discrepancy should be detected
    And resolution should be provided
    And correct stats should apply

  @idp-leagues @error-handling
  Scenario: Handle multi-position eligibility issues
    Given eligibility may be unclear
    When eligibility issue occurs
    Then issue should be resolved
    And clear ruling should be made
    And eligibility should be enforced

  @idp-leagues @error-handling
  Scenario: Handle IDP scoring errors
    Given scoring errors may occur
    When error is detected
    Then error should be corrected
    And scores should be updated
    And users should be notified

  @idp-leagues @validation
  Scenario: Validate IDP roster requirements
    Given rosters must meet requirements
    When invalid roster is submitted
    Then validation should fail
    And error should be shown
    And valid roster should be required

  @idp-leagues @performance
  Scenario: Handle large IDP stat processing
    Given many stats need processing
    When stats are processed
    Then processing should be efficient
    And performance should be good
    And stats should be accurate
