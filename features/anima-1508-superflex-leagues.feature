@superflex-leagues
Feature: Superflex Leagues
  As a fantasy football manager
  I want to compete in superflex format leagues
  So that I can utilize quarterback flexibility and strategic roster construction

  Background:
    Given the fantasy football platform is available
    And I am logged in as a registered user
    And I am a member of a superflex league

  # ============================================================================
  # SUPERFLEX POSITION RULES
  # ============================================================================

  @superflex-position-rules
  Scenario: Understand superflex position eligibility
    Given my league has a superflex roster slot
    When I view the superflex position rules
    Then I should see that quarterbacks are eligible
    And I should see that running backs are eligible
    And I should see that wide receivers are eligible
    And I should see that tight ends are eligible

  @superflex-position-rules
  Scenario: Start a quarterback in superflex slot
    Given I have multiple quarterbacks on my roster
    When I set my lineup with a quarterback in the superflex
    Then the quarterback should be accepted in the superflex slot
    And I should see the projected points from that quarterback
    And my lineup should be valid

  @superflex-position-rules
  Scenario: Start a running back in superflex slot
    Given I have running backs available
    When I place a running back in the superflex slot
    Then the running back should be accepted
    And I should see appropriate projections
    And my lineup should be valid

  @superflex-position-rules
  Scenario: Start a wide receiver in superflex slot
    Given I have wide receivers available
    When I place a wide receiver in the superflex slot
    Then the wide receiver should be accepted
    And I should see appropriate projections
    And my lineup should be valid

  @superflex-position-rules
  Scenario: Start a tight end in superflex slot
    Given I have tight ends available
    When I place a tight end in the superflex slot
    Then the tight end should be accepted
    And I should see appropriate projections
    And my lineup should be valid

  @superflex-position-rules
  Scenario: Prevent ineligible positions in superflex
    Given my league superflex excludes certain positions
    When I attempt to place an ineligible player
    Then the system should reject the placement
    And I should see an error message explaining eligibility
    And the slot should remain empty or unchanged

  @superflex-position-rules
  Scenario: View superflex position guidelines
    Given I am new to superflex leagues
    When I access position rules help
    Then I should see clear explanation of superflex
    And I should see eligible positions listed
    And I should see strategic recommendations

  @superflex-position-rules
  Scenario: Handle superflex with injured starter
    Given my superflex quarterback is injured
    When I need to replace the superflex player
    Then I should see all eligible replacement options
    And I should see injury impact on projections
    And I should be able to make the swap easily

  @superflex-position-rules
  Scenario: Differentiate superflex from standard flex
    Given my league has both flex and superflex slots
    When I view my roster positions
    Then I should see superflex allows quarterbacks
    And I should see standard flex excludes quarterbacks
    And the distinction should be clear

  @superflex-position-rules
  Scenario Outline: Validate superflex eligibility by position
    Given I have a <position> player on my roster
    When I attempt to place them in the superflex slot
    Then the action should be <result>
    And I should see <message>

    Examples:
      | position | result   | message                    |
      | QB       | accepted | Player set in superflex    |
      | RB       | accepted | Player set in superflex    |
      | WR       | accepted | Player set in superflex    |
      | TE       | accepted | Player set in superflex    |
      | K        | rejected | Kickers not superflex eligible |
      | DEF      | rejected | Defense not superflex eligible |

  # ============================================================================
  # QUARTERBACK VALUATION
  # ============================================================================

  @quarterback-valuation
  Scenario: View increased quarterback value in superflex
    Given I am in a superflex league
    When I view quarterback rankings
    Then quarterback values should be significantly higher
    And I should see superflex-specific valuations
    And top quarterbacks should be premium assets

  @quarterback-valuation
  Scenario: Compare QB value superflex vs standard
    Given I want to understand superflex QB impact
    When I view valuation comparisons
    Then I should see how much more QBs are worth
    And I should see the value multiplier
    And I should understand the strategic implications

  @quarterback-valuation
  Scenario: Assess elite quarterback premium
    Given I am evaluating elite quarterbacks
    When I view their superflex values
    Then top-tier QBs should have highest values
    And the gap to tier-two QBs should be significant
    And scarcity premium should be reflected

  @quarterback-valuation
  Scenario: Evaluate backup quarterback value
    Given backup quarterbacks have value in superflex
    When I assess backup QB values
    Then I should see their contingency value
    And I should see their bye week fill-in value
    And I should understand streaming potential

  @quarterback-valuation
  Scenario: Track quarterback value over season
    Given the season is progressing
    When I monitor QB values
    Then I should see value fluctuations
    And I should see injury impact on values
    And I should see bye week effects

  @quarterback-valuation
  Scenario: View quarterback trade value chart
    Given I am considering QB trades
    When I access trade value charts
    Then I should see superflex QB values
    And I should see position equivalencies
    And I should see fair trade suggestions

  @quarterback-valuation
  Scenario: Understand QB valuation in dynasty superflex
    Given I am in a dynasty superflex league
    When I view long-term QB values
    Then I should see age-adjusted valuations
    And I should see contract implications
    And I should see future value projections

  @quarterback-valuation
  Scenario: Assess rookie quarterback value
    Given rookie quarterbacks are available
    When I evaluate their superflex value
    Then I should see upside-based valuations
    And I should see landing spot impact
    And I should see developmental timeline

  @quarterback-valuation
  Scenario: Compare quarterback to other positions
    Given I want to understand positional value
    When I compare QB value to RB and WR
    Then I should see relative value charts
    And I should see scarcity comparisons
    And I should see replacement level analysis

  # ============================================================================
  # FLEX POSITION ELIGIBILITY
  # ============================================================================

  @flex-position-eligibility
  Scenario: Understand standard flex eligibility
    Given my league has a standard flex position
    When I view flex eligibility
    Then I should see RB, WR, and TE are eligible
    And I should see QB is not eligible
    And I should see the distinction from superflex

  @flex-position-eligibility
  Scenario: Configure flex position rules
    Given I am the commissioner
    When I configure flex position settings
    Then I should be able to set eligible positions
    And I should be able to customize rules
    And I should see the impact on league dynamics

  @flex-position-eligibility
  Scenario: Handle multiple flex slots
    Given my league has multiple flex slots
    When I set my lineup
    Then I should be able to fill each flex appropriately
    And eligibility should be enforced per slot type
    And I should maximize my scoring potential

  @flex-position-eligibility
  Scenario: View flex eligibility indicators
    Given I am setting my lineup
    When I view player eligibility icons
    Then I should see which players fit which slots
    And superflex-eligible should be marked
    And standard flex-eligible should be marked

  @flex-position-eligibility
  Scenario: Prevent duplicate player placement
    Given I have a player in a starting position
    When I try to also place them in flex
    Then the system should prevent the duplicate
    And I should see a clear error message
    And my lineup should remain valid

  @flex-position-eligibility
  Scenario: Optimize flex placement automatically
    Given I want optimal lineup suggestions
    When I use auto-optimize feature
    Then the system should consider all flex options
    And it should place best players optimally
    And superflex should be considered

  @flex-position-eligibility
  Scenario: Handle position eligibility with dual-eligible players
    Given a player has multiple position eligibility
    When I view their placement options
    Then I should see all valid slots for them
    And I should understand optimal placement
    And eligibility should be clearly shown

  @flex-position-eligibility
  Scenario: View flex eligibility during draft
    Given I am in a draft
    When I evaluate players
    Then I should see their flex eligibility
    And I should consider positional flexibility
    And eligibility should factor into my picks

  @flex-position-eligibility
  Scenario: Configure custom flex position
    Given I am the commissioner
    When I create a custom flex position
    Then I should be able to name the position
    And I should set eligible positions
    And the league should see the new slot

  # ============================================================================
  # SUPERFLEX DRAFT STRATEGY
  # ============================================================================

  @superflex-draft-strategy
  Scenario: Plan quarterback draft timing
    Given I am preparing for a superflex draft
    When I develop my draft strategy
    Then I should prioritize early QB selection
    And I should identify target QB tiers
    And I should plan for positional runs

  @superflex-draft-strategy
  Scenario: Assess early quarterback investment
    Given elite QBs go early in superflex drafts
    When I evaluate first-round QB selection
    Then I should see the value proposition
    And I should understand opportunity cost
    And I should see tier break analysis

  @superflex-draft-strategy
  Scenario: Plan for two quarterback roster
    Given superflex benefits from multiple QBs
    When I plan my draft approach
    Then I should target multiple quarterbacks
    And I should identify value picks
    And I should ensure bye week coverage

  @superflex-draft-strategy
  Scenario: Handle missing on early quarterbacks
    Given I miss out on top-tier quarterbacks
    When I adjust my strategy mid-draft
    Then I should pivot to other positions
    And I should identify late QB value
    And I should maximize other positions

  @superflex-draft-strategy
  Scenario: Evaluate quarterback runs
    Given quarterbacks go in positional runs
    When I see a QB run developing
    Then I should assess joining the run
    And I should consider waiting it out
    And I should understand supply impact

  @superflex-draft-strategy
  Scenario: Draft for superflex bye week coverage
    Given QB bye weeks impact superflex
    When I select my quarterbacks
    Then I should consider bye week alignment
    And I should ensure coverage options
    And I should minimize zero-QB weeks

  @superflex-draft-strategy
  Scenario: Balance QB investment with other needs
    Given roster balance matters
    When I allocate draft capital
    Then I should balance QB investment
    And I should not neglect RB and WR
    And I should consider overall team strength

  @superflex-draft-strategy
  Scenario: Identify superflex draft sleepers
    Given late-round value exists
    When I identify superflex sleepers
    Then I should find undervalued QBs
    And I should find high-upside options
    And I should target backup QBs with paths

  @superflex-draft-strategy
  Scenario: Analyze mock draft results for superflex
    Given I have completed mock drafts
    When I analyze the results
    Then I should see typical QB selection patterns
    And I should identify value positions
    And I should refine my strategy

  # ============================================================================
  # POSITIONAL SCARCITY
  # ============================================================================

  @positional-scarcity
  Scenario: Understand quarterback scarcity in superflex
    Given there are limited starting QBs
    When I analyze QB scarcity
    Then I should see supply vs demand imbalance
    And I should understand scarcity premium
    And I should see roster requirement impact

  @positional-scarcity
  Scenario: Calculate replacement level by position
    Given I want to understand positional value
    When I view replacement level analysis
    Then I should see replacement value for each position
    And I should see how superflex affects QB replacement
    And I should understand value over replacement

  @positional-scarcity
  Scenario: Compare positional depth charts
    Given I want to assess position depth
    When I view depth comparisons
    Then I should see how deep each position is
    And I should see where scarcity is greatest
    And I should identify draft strategy implications

  @positional-scarcity
  Scenario: Track in-season scarcity changes
    Given injuries affect scarcity
    When I monitor scarcity during season
    Then I should see how injuries impact value
    And I should see waiver wire implications
    And I should see trade market effects

  @positional-scarcity
  Scenario: Assess tight end scarcity in superflex
    Given TE is often scarce
    When I evaluate TE scarcity
    Then I should see premium TE value
    And I should compare to superflex QB value
    And I should understand relative scarcity

  @positional-scarcity
  Scenario: View tier-based scarcity analysis
    Given players are grouped in tiers
    When I view tier-based scarcity
    Then I should see dropoffs between tiers
    And I should identify tier breaks
    And I should time my selections accordingly

  @positional-scarcity
  Scenario: Analyze scarcity in dynasty superflex
    Given dynasty adds age dimension
    When I analyze long-term scarcity
    Then I should see young QB premium
    And I should see aging impact on value
    And I should understand dynasty-specific scarcity

  @positional-scarcity
  Scenario: Compare scarcity superflex vs 1QB
    Given I want to understand format differences
    When I compare scarcity between formats
    Then I should see QB scarcity difference
    And I should see how it affects all positions
    And I should understand strategic shifts

  @positional-scarcity
  Scenario: Use scarcity for trade valuation
    Given I am evaluating a trade
    When I apply scarcity analysis
    Then scarcity should inform fair value
    And I should see positional adjustments
    And I should make scarcity-aware decisions

  # ============================================================================
  # SUPERFLEX SCORING
  # ============================================================================

  @superflex-scoring
  Scenario: View superflex slot scoring
    Given I have a player in superflex
    When I view my scoring breakdown
    Then I should see superflex position contribution
    And I should see points from that slot
    And I should see percentage of total

  @superflex-scoring
  Scenario: Compare QB scoring in superflex
    Given quarterbacks score differently
    When I compare QB scoring output
    Then I should see higher scoring potential
    And I should see value of elite QBs
    And I should understand floor vs ceiling

  @superflex-scoring
  Scenario: Analyze superflex scoring by position
    Given I can start any eligible position
    When I analyze scoring by position type
    Then I should see average QB points in superflex
    And I should see average RB/WR/TE points
    And I should see optimal position choices

  @superflex-scoring
  Scenario: View weekly superflex scoring leaders
    Given the week has completed
    When I view superflex scoring leaders
    Then I should see top superflex performers
    And I should see position breakdown
    And I should see who maximized the slot

  @superflex-scoring
  Scenario: Project superflex slot scoring
    Given I want to optimize my lineup
    When I view superflex projections
    Then I should see projected points per option
    And I should see best projected player
    And I should see variance in projections

  @superflex-scoring
  Scenario: Handle superflex scoring with backup QB
    Given my starter is on bye
    And I start a backup QB in superflex
    When scoring is calculated
    Then I should see actual backup performance
    And I should see comparison to alternatives
    And I should understand the opportunity cost

  @superflex-scoring
  Scenario: Analyze superflex scoring trends
    Given multiple weeks have been played
    When I view superflex scoring trends
    Then I should see my superflex production over time
    And I should see position mix history
    And I should see optimal choices retrospectively

  @superflex-scoring
  Scenario: Compare scoring with non-QB superflex start
    Given I started a RB in superflex this week
    When I compare to starting a QB
    Then I should see point differential
    And I should see strategic trade-off
    And I should understand decision impact

  @superflex-scoring
  Scenario: View league-wide superflex scoring patterns
    Given I want to see league trends
    When I analyze league superflex usage
    Then I should see what positions teams start
    And I should see average superflex scoring
    And I should see winning team patterns

  # ============================================================================
  # ROSTER CONSTRUCTION
  # ============================================================================

  @roster-construction
  Scenario: Plan superflex roster composition
    Given I am building a superflex roster
    When I plan my roster structure
    Then I should prioritize multiple QBs
    And I should ensure position depth
    And I should plan for bye weeks

  @roster-construction
  Scenario: Determine optimal QB count
    Given roster spots are limited
    When I decide on QB roster count
    Then I should consider at least 2 QBs
    And I should weigh opportunity cost of third
    And I should factor in bye weeks

  @roster-construction
  Scenario: Balance roster for superflex
    Given I need balanced production
    When I construct my roster
    Then I should not over-invest in one position
    And I should maintain flexibility
    And I should ensure starting lineup depth

  @roster-construction
  Scenario: Handle roster construction in dynasty
    Given dynasty requires long-term planning
    When I build my dynasty superflex roster
    Then I should consider player age
    And I should value young QBs highly
    And I should build sustainable production

  @roster-construction
  Scenario: Adjust roster for trade deadline
    Given the trade deadline approaches
    When I evaluate roster needs
    Then I should identify weaknesses
    And I should consider QB upgrades
    And I should balance win-now vs future

  @roster-construction
  Scenario: Plan roster for playoff push
    Given playoffs are approaching
    When I optimize my roster
    Then I should consolidate talent
    And I should ensure QB stability
    And I should maximize weekly ceiling

  @roster-construction
  Scenario: Handle injured QB in roster construction
    Given my starting QB is injured
    When I adjust my roster
    Then I should find replacement options
    And I should consider trade or waiver
    And I should maintain competitive lineup

  @roster-construction
  Scenario: Construct roster with limited cap
    Given salary cap constraints exist
    When I build within cap limits
    Then I should allocate appropriately to QB
    And I should find value at other positions
    And I should stay under the cap

  @roster-construction
  Scenario: View roster construction recommendations
    Given I want expert guidance
    When I access roster construction advice
    Then I should see superflex-specific tips
    And I should see common mistakes to avoid
    And I should see optimal structures

  # ============================================================================
  # SUPERFLEX TRADES
  # ============================================================================

  @superflex-trades
  Scenario: Evaluate quarterback trade value
    Given I am considering trading a QB
    When I assess the trade value
    Then I should see superflex-inflated value
    And I should see comparable return options
    And I should understand market value

  @superflex-trades
  Scenario: Trade for quarterback upgrade
    Given I need a better QB
    When I pursue a QB trade
    Then I should understand the cost
    And I should identify trade targets
    And I should structure fair offers

  @superflex-trades
  Scenario: Trade quarterback for positional help
    Given I have excess QB depth
    When I trade a QB for RB or WR
    Then I should get appropriate return
    And I should maintain QB coverage
    And the trade should improve my team

  @superflex-trades
  Scenario: Assess trade involving multiple QBs
    Given a trade involves multiple quarterbacks
    When I evaluate the package
    Then I should assess combined QB value
    And I should consider roster fit
    And I should ensure fair exchange

  @superflex-trades
  Scenario: Negotiate superflex trade offers
    Given I receive a trade offer
    When I negotiate terms
    Then I should understand superflex values
    And I should counter appropriately
    And I should seek fair deals

  @superflex-trades
  Scenario: Trade quarterback during bye week
    Given my QB has an upcoming bye
    When I consider trading them
    Then I should factor bye impact into value
    And I should consider timing
    And I should assess replacement options

  @superflex-trades
  Scenario: Evaluate rookie QB in trade
    Given a rookie QB is offered in trade
    When I assess the offer
    Then I should consider upside potential
    And I should value developmental timeline
    And I should weigh risk vs reward

  @superflex-trades
  Scenario: Trade for QB in championship window
    Given I am competing for a championship
    When I trade for an elite QB
    Then I should understand the cost
    And I should assess championship odds impact
    And I should consider all-in approach

  @superflex-trades
  Scenario: View superflex trade calculator
    Given I want to verify trade fairness
    When I use the trade calculator
    Then I should see superflex-adjusted values
    And I should see trade balance
    And I should get fair trade guidance

  # ============================================================================
  # TWO-QB FORMATS
  # ============================================================================

  @two-qb-formats
  Scenario: Understand two-QB format differences
    Given my league uses two-QB format
    When I review the format rules
    Then I should see two required QB slots
    And I should understand the difference from superflex
    And I should see strategic implications

  @two-qb-formats
  Scenario: Handle two-QB bye week challenges
    Given both my QBs have the same bye week
    When that bye week arrives
    Then I should have prepared a backup option
    And I should see the lineup challenge
    And I should minimize point loss

  @two-qb-formats
  Scenario: Draft strategy for two-QB leagues
    Given drafting for a two-QB league
    When I plan my strategy
    Then I should prioritize early QB picks
    And I should roster at least 3 QBs
    And I should not leave draft QB-needy

  @two-qb-formats
  Scenario: Evaluate QB value in two-QB vs superflex
    Given I want to compare formats
    When I assess QB values across formats
    Then two-QB should show higher QB demand
    And superflex should have more flexibility
    And values should differ accordingly

  @two-qb-formats
  Scenario: Handle QB injury in two-QB league
    Given one of my starting QBs is injured
    When I assess my options
    Then I should have a rostered backup
    And I should consider waiver claims
    And I should possibly pursue trades

  @two-qb-formats
  Scenario: View two-QB streaming options
    Given I need a QB for this week
    When I view streaming options
    Then I should see available QBs
    And I should see matchup-based recommendations
    And I should make informed pickup decision

  @two-qb-formats
  Scenario: Manage two-QB roster depth
    Given roster spots are at a premium
    When I manage QB depth
    Then I should carry adequate backups
    And I should balance with other positions
    And I should prepare for contingencies

  @two-qb-formats
  Scenario: Compare two-QB scoring distribution
    Given I want to analyze scoring
    When I view scoring distribution
    Then I should see QB scoring percentage of team
    And I should see higher floor from two QBs
    And I should understand lineup construction

  @two-qb-formats
  Scenario: Handle two-QB trade market
    Given trades are active in two-QB league
    When I assess trade values
    Then QB prices should be very high
    And trades should reflect scarcity
    And I should trade carefully

  # ============================================================================
  # SUPERFLEX LEAGUE SETTINGS
  # ============================================================================

  @superflex-league-settings
  Scenario: Configure superflex position
    Given I am the commissioner
    When I set up the superflex slot
    Then I should be able to add superflex to roster
    And I should configure eligible positions
    And the setting should be saved

  @superflex-league-settings
  Scenario: Set superflex eligible positions
    Given I am configuring superflex
    When I select eligible positions
    Then I should be able to include or exclude positions
    And the default should include QB, RB, WR, TE
    And my choices should be reflected in the league

  @superflex-league-settings
  Scenario: Configure roster size for superflex
    Given superflex affects roster needs
    When I set roster size
    Then I should account for additional QB needs
    And I should set appropriate bench size
    And roster constraints should be balanced

  @superflex-league-settings
  Scenario: Set scoring for superflex format
    Given scoring affects superflex strategy
    When I configure scoring settings
    Then I should consider pass-heavy vs balanced scoring
    And I should see impact on QB value
    And scoring should be appropriate for format

  @superflex-league-settings
  Scenario: Configure trade settings for superflex
    Given trades are important in superflex
    When I set trade rules
    Then I should configure trade deadline
    And I should set review period
    And I should establish trade limits if desired

  @superflex-league-settings
  Scenario: Set waiver wire rules
    Given waiver claims affect QB availability
    When I configure waiver settings
    Then I should set waiver type
    And I should configure FAAB if using
    And I should set waiver periods

  @superflex-league-settings
  Scenario: View superflex settings summary
    Given all settings are configured
    When I view settings summary
    Then I should see superflex configuration
    And I should see roster setup
    And I should see all relevant rules

  @superflex-league-settings
  Scenario: Import superflex settings template
    Given standard templates exist
    When I import a superflex template
    Then settings should be pre-configured
    And I should be able to customize
    And the template should be a good starting point

  @superflex-league-settings
  Scenario: Configure multiple superflex slots
    Given some leagues use multiple superflex
    When I add additional superflex slots
    Then I should be able to add multiple
    And eligibility should apply to each
    And roster should accommodate the setup

  # ============================================================================
  # ERROR HANDLING
  # ============================================================================

  @error-handling
  Scenario: Handle invalid superflex placement
    Given I try to place an ineligible player
    When the placement fails
    Then I should see a clear error message
    And I should understand what went wrong
    And I should be guided to correct action

  @error-handling
  Scenario: Handle roster submission with empty superflex
    Given my superflex slot is empty
    When I try to submit my lineup
    Then I should receive a warning
    And I should be prompted to fill the slot
    And I should be able to proceed if intentional

  @error-handling
  Scenario: Handle duplicate player placement attempt
    Given a player is already in my lineup
    When I try to add them to superflex
    Then the system should prevent the duplicate
    And I should see an appropriate message
    And my lineup should remain valid

  @error-handling
  Scenario: Handle injured player in superflex
    Given my superflex player is ruled out
    When I view my lineup
    Then I should see injury notification
    And I should be prompted to replace
    And I should see eligible replacements

  @error-handling
  Scenario: Handle bye week with no QB available
    Given all my QBs are on bye
    When I set my lineup
    Then I should be notified of the issue
    And I should see non-QB superflex options
    And I should be guided to solutions

  @error-handling
  Scenario: Handle superflex trade processing error
    Given a trade involving superflex is pending
    When trade processing encounters an error
    Then the error should be logged
    And users should be notified
    And the trade should be held for review

  @error-handling
  Scenario: Handle scoring error for superflex slot
    Given scoring fails for superflex player
    When the error occurs
    Then the system should retry
    And if persistent, admin should be notified
    And affected owners should be informed

  @error-handling
  Scenario: Handle lineup lock with pending superflex change
    Given I have a pending superflex change
    When games lock my lineup
    Then the pending change should be addressed
    And I should see final lineup state
    And any issues should be resolved

  @error-handling
  Scenario: Handle configuration save failure
    Given I am updating superflex settings
    When the save fails
    Then I should see an error message
    And my changes should not be lost
    And I should be able to retry

  # ============================================================================
  # ACCESSIBILITY
  # ============================================================================

  @accessibility
  Scenario: Navigate superflex lineup with screen reader
    Given I am using a screen reader
    When I access my lineup
    Then superflex slot should be clearly labeled
    And eligibility information should be announced
    And I should be able to set my lineup

  @accessibility
  Scenario: Use keyboard for superflex player selection
    Given I am navigating via keyboard
    When I select a superflex player
    Then all options should be focusable
    And selection should work via keyboard
    And confirmation should be accessible

  @accessibility
  Scenario: View superflex settings with high contrast
    Given I use high contrast mode
    When I view superflex settings
    Then all text should be readable
    And form elements should be visible
    And I should be able to configure settings

  @accessibility
  Scenario: Access superflex help with accessibility tools
    Given I use accessibility tools
    When I access superflex help
    Then help content should be accessible
    And explanations should be clear
    And navigation should work properly

  @accessibility
  Scenario: Set superflex lineup on mobile
    Given I am using a mobile device
    When I set my superflex lineup
    Then the interface should be responsive
    And touch targets should be appropriately sized
    And all features should work on mobile

  @accessibility
  Scenario: Receive accessible superflex notifications
    Given I have accessibility preferences
    When I receive superflex-related notifications
    Then notifications should be screen reader compatible
    And important information should be conveyed
    And preferences should be respected

  @accessibility
  Scenario: View trade offers with accessibility
    Given I use accessibility features
    When I view superflex trade offers
    Then trade details should be accessible
    And values should be clearly presented
    And I should be able to respond

  @accessibility
  Scenario: Access draft interface with accessibility
    Given I am drafting with accessibility needs
    When I participate in superflex draft
    Then the draft interface should be accessible
    And picks should be announced
    And I should be able to make selections

  @accessibility
  Scenario: Navigate roster with reduced motion
    Given I have reduced motion preferences
    When I view and edit my roster
    Then animations should be minimized
    And transitions should be smooth
    And functionality should be preserved

  # ============================================================================
  # PERFORMANCE
  # ============================================================================

  @performance
  Scenario: Load superflex lineup quickly
    Given I am accessing my lineup
    When the page loads
    Then lineup should appear within 2 seconds
    And superflex options should load smoothly
    And the experience should be responsive

  @performance
  Scenario: Calculate superflex projections efficiently
    Given projections need calculation
    When I view superflex projections
    Then projections should load quickly
    And all eligible players should be included
    And performance should be smooth

  @performance
  Scenario: Handle large leagues with superflex
    Given a league has many teams
    When superflex operations run
    Then operations should complete efficiently
    And no timeouts should occur
    And all users should have good experience

  @performance
  Scenario: Process superflex trades quickly
    Given trades are being processed
    When a superflex trade completes
    Then processing should be fast
    And rosters should update promptly
    And all parties should see updates

  @performance
  Scenario: Load superflex draft board efficiently
    Given I am in a superflex draft
    When the draft board loads
    Then players should appear quickly
    And superflex values should be shown
    And the interface should be responsive

  @performance
  Scenario: Update superflex scoring in real-time
    Given games are in progress
    When superflex players score
    Then updates should appear promptly
    And projections should refresh
    And no lag should occur

  @performance
  Scenario: Handle multiple concurrent lineup updates
    Given many users update lineups simultaneously
    When updates are processed
    Then all updates should complete
    And no data should be lost
    And system should remain stable

  @performance
  Scenario: Cache superflex player data effectively
    Given player data is accessed frequently
    When data is requested
    Then cached data should be used when valid
    And cache should update appropriately
    And performance should benefit from caching

  @performance
  Scenario: Generate superflex reports efficiently
    Given I request superflex analytics
    When reports are generated
    Then generation should complete quickly
    And data should be accurate
    And the experience should be smooth
