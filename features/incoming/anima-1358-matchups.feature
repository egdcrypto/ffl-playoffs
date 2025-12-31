@matchups @ANIMA-1358
Feature: Matchups
  As a fantasy football playoffs application user
  I want comprehensive matchup management functionality
  So that I can view weekly matchups, head-to-head comparisons, and matchup analysis

  Background:
    Given the fantasy football playoffs application is running
    And I am logged in as a registered user
    And matchup data is available

  # ============================================================================
  # WEEKLY MATCHUPS - HAPPY PATH
  # ============================================================================

  @happy-path @weekly-matchups
  Scenario: View current week matchup
    Given current week is in progress
    When I view my matchup
    Then I should see my current matchup
    And I should see my opponent
    And matchup details should display

  @happy-path @weekly-matchups
  Scenario: View upcoming weeks matchups
    Given future weeks are scheduled
    When I view upcoming matchups
    Then I should see future opponents
    And schedule should be visible
    And I should plan ahead

  @happy-path @weekly-matchups
  Scenario: View past weeks matchups
    Given past weeks have occurred
    When I view past matchups
    Then I should see previous results
    And scores should be displayed
    And I should review history

  @happy-path @weekly-matchups
  Scenario: View full schedule
    Given full schedule exists
    When I view schedule
    Then I should see entire schedule
    And all weeks should be shown
    And I should see full picture

  @happy-path @weekly-matchups
  Scenario: View matchup calendar
    Given calendar view is available
    When I view calendar
    Then I should see matchup calendar
    And weeks should be organized
    And I should navigate easily

  @happy-path @weekly-matchups
  Scenario: View bye week matchups
    Given bye weeks affect matchups
    When I view bye week matchups
    Then I should see bye week impact
    And roster challenges should be noted
    And I should prepare

  @happy-path @weekly-matchups
  Scenario: View playoff matchups
    Given playoffs are scheduled
    When I view playoff matchups
    Then I should see playoff bracket
    And potential opponents should show
    And I should see path to championship

  @happy-path @weekly-matchups
  Scenario: Navigate between weeks
    Given multiple weeks exist
    When I navigate weeks
    Then I should switch between weeks
    And navigation should be smooth
    And I should find any week

  # ============================================================================
  # MATCHUP DISPLAY
  # ============================================================================

  @happy-path @matchup-display
  Scenario: View team lineups
    Given lineups are set
    When I view matchup lineups
    Then I should see my lineup
    And I should see opponent lineup
    And lineups should be compared

  @happy-path @matchup-display
  Scenario: View projected scores
    Given projections exist
    When I view projections
    Then I should see my projected score
    And I should see opponent projection
    And I should assess matchup

  @happy-path @matchup-display
  Scenario: View live scores
    Given games are in progress
    When I view live scores
    Then I should see real-time scores
    And scores should update live
    And I should track progress

  @happy-path @matchup-display
  Scenario: Compare players head-to-head
    Given players can be compared
    When I compare players
    Then I should see position matchups
    And comparisons should be side-by-side
    And I should assess advantages

  @happy-path @matchup-display
  Scenario: View position battles
    Given positions match up
    When I view position battles
    Then I should see position comparisons
    And advantages should be highlighted
    And I should identify edges

  @happy-path @matchup-display
  Scenario: View scoring breakdown
    Given scoring has categories
    When I view breakdown
    Then I should see scoring by category
    And breakdown should be detailed
    And I should understand points

  @happy-path @matchup-display
  Scenario: View bench comparison
    Given benches have players
    When I compare benches
    Then I should see bench players
    And bench strength should show
    And depth should be compared

  @happy-path @matchup-display
  Scenario: Toggle display views
    Given multiple views exist
    When I toggle views
    Then view should change
    And different perspectives should show
    And I should choose preferred view

  # ============================================================================
  # HEAD-TO-HEAD
  # ============================================================================

  @happy-path @head-to-head
  Scenario: View season record vs opponent
    Given we have played this season
    When I view season record
    Then I should see record vs opponent
    And wins and losses should show
    And I should know standing

  @happy-path @head-to-head
  Scenario: View all-time record
    Given historical data exists
    When I view all-time record
    Then I should see career record
    And all matchups should count
    And rivalry should be tracked

  @happy-path @head-to-head
  Scenario: View points for/against
    Given scoring history exists
    When I view points
    Then I should see points scored vs them
    And I should see points allowed
    And trends should be visible

  @happy-path @head-to-head
  Scenario: View historical matchups
    Given past matchups occurred
    When I view history
    Then I should see all past matchups
    And scores should be shown
    And I should see pattern

  @happy-path @head-to-head
  Scenario: View rivalry statistics
    Given rivalry exists
    When I view rivalry stats
    Then I should see rivalry metrics
    And key stats should be highlighted
    And rivalry should be contextualized

  @happy-path @head-to-head
  Scenario: View average margin
    Given margins are tracked
    When I view margins
    Then I should see average margin
    And close games should be noted
    And I should understand competitiveness

  @happy-path @head-to-head
  Scenario: View streak information
    Given streaks exist
    When I view streaks
    Then I should see current streak
    And longest streaks should show
    And momentum should be visible

  @happy-path @head-to-head
  Scenario: Compare head-to-head across league
    Given league has matchups
    When I compare across league
    Then I should see all H2H records
    And league rivalries should show
    And I should see context

  # ============================================================================
  # MATCHUP PROJECTIONS
  # ============================================================================

  @happy-path @matchup-projections
  Scenario: View win probability
    Given projections calculate probability
    When I view win probability
    Then I should see my win percentage
    And opponent percentage should show
    And I should understand odds

  @happy-path @matchup-projections
  Scenario: View projected margin
    Given margin is projected
    When I view projected margin
    Then I should see expected margin
    And who is favored should be clear
    And I should assess matchup

  @happy-path @matchup-projections
  Scenario: Identify key players
    Given players have impact
    When I view key players
    Then I should see most impactful players
    And key matchups should be highlighted
    And I should focus on them

  @happy-path @matchup-projections
  Scenario: View boom/bust potential
    Given players have variance
    When I view boom/bust
    Then I should see boom potential
    And bust risk should show
    And I should assess risk

  @happy-path @matchup-projections
  Scenario: View floor projections
    Given floors are calculated
    When I view floors
    Then I should see projected floor
    And safe points should be estimated
    And I should understand baseline

  @happy-path @matchup-projections
  Scenario: View ceiling projections
    Given ceilings are calculated
    When I view ceilings
    Then I should see projected ceiling
    And upside should be estimated
    And I should understand potential

  @happy-path @matchup-projections
  Scenario: Compare projection sources
    Given multiple sources exist
    When I compare sources
    Then I should see different projections
    And variance should show
    And I should assess consensus

  @happy-path @matchup-projections
  Scenario: View projection confidence
    Given confidence is calculated
    When I view confidence
    Then I should see projection confidence
    And certainty should be indicated
    And I should weigh accordingly

  # ============================================================================
  # PLAYER MATCHUPS
  # ============================================================================

  @happy-path @player-matchups
  Scenario: View positional matchups
    Given players face defenses
    When I view positional matchups
    Then I should see position vs defense
    And matchup difficulty should show
    And I should assess advantage

  @happy-path @player-matchups
  Scenario: View defensive rankings
    Given defenses are ranked
    When I view defensive rankings
    Then I should see defense rankings
    And position-specific ranks should show
    And I should identify exploits

  @happy-path @player-matchups
  Scenario: View strength of schedule
    Given schedule varies
    When I view schedule strength
    Then I should see SOS rating
    And difficulty should be assessed
    And I should plan accordingly

  @happy-path @player-matchups
  Scenario: Identify exploit opportunities
    Given mismatches exist
    When I identify exploits
    Then I should see favorable matchups
    And opportunities should be highlighted
    And I should target them

  @happy-path @player-matchups
  Scenario: View shadow coverage
    Given top corners shadow
    When I view shadow coverage
    Then I should see shadow matchups
    And coverage should be noted
    And I should adjust expectations

  @happy-path @player-matchups
  Scenario: View run defense matchups
    Given run defenses vary
    When I view run matchups
    Then I should see RB matchups
    And run defense rank should show
    And I should assess RB value

  @happy-path @player-matchups
  Scenario: View pass defense matchups
    Given pass defenses vary
    When I view pass matchups
    Then I should see WR/TE matchups
    And pass defense rank should show
    And I should assess passing value

  @happy-path @player-matchups
  Scenario: View historical performance vs opponent
    Given player has faced opponent
    When I view historical performance
    Then I should see past results
    And pattern should emerge
    And I should factor history

  # ============================================================================
  # MATCHUP ANALYSIS
  # ============================================================================

  @happy-path @matchup-analysis
  Scenario: View advantage breakdown
    Given advantages exist
    When I view advantages
    Then I should see my advantages
    And opponent advantages should show
    And I should understand edges

  @happy-path @matchup-analysis
  Scenario: Compare rosters
    Given rosters can be compared
    When I compare rosters
    Then I should see roster comparison
    And position by position should show
    And strengths should be identified

  @happy-path @matchup-analysis
  Scenario: Assess bench strength
    Given benches have value
    When I assess bench strength
    Then I should see bench quality
    And depth should be evaluated
    And coverage should be assessed

  @happy-path @matchup-analysis
  Scenario: View injury impact
    Given injuries affect matchup
    When I view injury impact
    Then I should see injury effects
    And impact should be quantified
    And I should adjust expectations

  @happy-path @matchup-analysis
  Scenario: View bye week impact
    Given bye weeks affect teams
    When I view bye impact
    Then I should see bye week effects
    And roster holes should show
    And I should see disadvantages

  @happy-path @matchup-analysis
  Scenario: View optimal lineup analysis
    Given optimal lineups exist
    When I view optimal analysis
    Then I should see optimal lineup
    And current vs optimal should compare
    And I should optimize

  @happy-path @matchup-analysis
  Scenario: View risk assessment
    Given risk can be calculated
    When I view risk assessment
    Then I should see matchup risk
    And factors should be shown
    And I should understand uncertainty

  @happy-path @matchup-analysis
  Scenario: View what-if scenarios
    Given scenarios can be run
    When I run scenarios
    Then I should see scenario results
    And different outcomes should show
    And I should plan accordingly

  # ============================================================================
  # LIVE MATCHUP TRACKING
  # ============================================================================

  @happy-path @live-tracking
  Scenario: View real-time score updates
    Given games are live
    When I view live scores
    Then scores should update real-time
    And changes should be instant
    And I should track progress

  @happy-path @live-tracking
  Scenario: View scoring plays
    Given scoring plays occur
    When I view scoring plays
    Then I should see recent scores
    And play details should show
    And I should see who scored

  @happy-path @live-tracking
  Scenario: Receive player alerts
    Given players are performing
    When player has big play
    Then I should receive alert
    And play should be described
    And I should celebrate or worry

  @happy-path @live-tracking
  Scenario: View game flow
    Given matchup is progressing
    When I view game flow
    Then I should see lead changes
    And momentum should be visible
    And I should understand trajectory

  @happy-path @live-tracking
  Scenario: Track momentum shifts
    Given momentum changes
    When I track momentum
    Then I should see momentum shifts
    And turning points should be noted
    And I should understand changes

  @happy-path @live-tracking
  Scenario: View win probability changes
    Given probability updates
    When I view probability
    Then probability should update live
    And changes should be visible
    And I should see my chances

  @happy-path @live-tracking
  Scenario: View players yet to play
    Given some players haven't played
    When I view remaining players
    Then I should see who is left
    And projections should show
    And I should assess hope

  @happy-path @live-tracking
  Scenario: View points needed to win
    Given I need to catch up
    When I view points needed
    Then I should see points required
    And calculation should be accurate
    And I should know what's needed

  # ============================================================================
  # MATCHUP RECAP
  # ============================================================================

  @happy-path @matchup-recap
  Scenario: View final scores
    Given matchup is complete
    When I view final
    Then I should see final score
    And winner should be clear
    And result should be documented

  @happy-path @matchup-recap
  Scenario: Identify top performers
    Given players performed
    When I view top performers
    Then I should see best players
    And standouts should be highlighted
    And I should see who delivered

  @happy-path @matchup-recap
  Scenario: View biggest surprises
    Given surprises occurred
    When I view surprises
    Then I should see unexpected performances
    And overperformers should show
    And I should see what surprised

  @happy-path @matchup-recap
  Scenario: Review close calls
    Given matchup was close
    When I review close call
    Then I should see how close it was
    And key plays should be noted
    And I should understand margin

  @happy-path @matchup-recap
  Scenario: Review blowouts
    Given matchup was lopsided
    When I review blowout
    Then I should see margin
    And dominant performances should show
    And I should understand mismatch

  @happy-path @matchup-recap
  Scenario: View bench points
    Given bench scored
    When I view bench points
    Then I should see bench output
    And points left on bench should show
    And I should assess decisions

  @happy-path @matchup-recap
  Scenario: View decision analysis
    Given decisions were made
    When I view analysis
    Then I should see decision quality
    And right/wrong calls should show
    And I should learn from week

  @happy-path @matchup-recap
  Scenario: Share matchup recap
    Given recap is available
    When I share recap
    Then I should share results
    And social sharing should work
    And I should celebrate or commiserate

  # ============================================================================
  # MATCHUP INSIGHTS
  # ============================================================================

  @happy-path @matchup-insights
  Scenario: View start/sit advice
    Given advice is available
    When I view start/sit
    Then I should see recommendations
    And advice should be specific
    And I should optimize lineup

  @happy-path @matchup-insights
  Scenario: Track last-minute changes
    Given late news occurs
    When I view last-minute changes
    Then I should see late updates
    And changes should be highlighted
    And I should react quickly

  @happy-path @matchup-insights
  Scenario: View weather impact
    Given weather affects games
    When I view weather impact
    Then I should see weather effects
    And impacted players should show
    And I should adjust expectations

  @happy-path @matchup-insights
  Scenario: View game script predictions
    Given game scripts vary
    When I view game scripts
    Then I should see predicted script
    And pass/run tendencies should show
    And I should understand context

  @happy-path @matchup-insights
  Scenario: View injury updates impact
    Given injuries affect matchup
    When I view injury updates
    Then I should see latest injury news
    And matchup impact should show
    And I should adjust

  @happy-path @matchup-insights
  Scenario: View expert picks
    Given experts have opinions
    When I view expert picks
    Then I should see expert predictions
    And consensus should show
    And I should consider advice

  @happy-path @matchup-insights
  Scenario: View statistical trends
    Given trends exist
    When I view trends
    Then I should see relevant trends
    And patterns should be highlighted
    And I should use insights

  @happy-path @matchup-insights
  Scenario: View contrarian plays
    Given contrarian options exist
    When I view contrarian plays
    Then I should see differentiation options
    And upside should be noted
    And I should consider risk

  # ============================================================================
  # LEAGUE MATCHUPS
  # ============================================================================

  @happy-path @league-matchups
  Scenario: View all league matchups
    Given league has matchups
    When I view league matchups
    Then I should see all matchups
    And all teams should be shown
    And I should see full picture

  @happy-path @league-matchups
  Scenario: View standings impact
    Given matchups affect standings
    When I view standings impact
    Then I should see potential standings changes
    And scenarios should be shown
    And I should understand stakes

  @happy-path @league-matchups
  Scenario: View playoff implications
    Given playoffs are at stake
    When I view implications
    Then I should see playoff impact
    And scenarios should be calculated
    And I should see what matters

  @happy-path @league-matchups
  Scenario: View power rankings
    Given teams are ranked
    When I view power rankings
    Then I should see team rankings
    And my position should be shown
    And I should understand standing

  @happy-path @league-matchups
  Scenario: View league scoring leaders
    Given teams score differently
    When I view scoring leaders
    Then I should see top scoring teams
    And my ranking should show
    And I should see competition

  @happy-path @league-matchups
  Scenario: View weekly projections
    Given projections exist
    When I view weekly projections
    Then I should see projected outcomes
    And expected results should show
    And I should see league trends

  @happy-path @league-matchups
  Scenario: View matchups of the week
    Given exciting matchups exist
    When I view matchup of week
    Then I should see featured matchups
    And importance should be highlighted
    And I should see key games

  @happy-path @league-matchups
  Scenario: View schedule strength analysis
    Given schedules vary
    When I view schedule analysis
    Then I should see team schedule strength
    And difficulty should be assessed
    And I should understand paths

  # ============================================================================
  # ERROR HANDLING
  # ============================================================================

  @error
  Scenario: Handle matchup data unavailable
    Given matchup data is expected
    When data is unavailable
    Then I should see error message
    And cached data should show if available
    And I should retry later

  @error
  Scenario: Handle live score connection failure
    Given live scores are expected
    When connection fails
    Then I should see connection error
    And last known scores should show
    And I should retry

  @error
  Scenario: Handle projection unavailable
    Given projections are expected
    When projections are unavailable
    Then I should see appropriate message
    And fallback should be offered
    And I should check later

  @error
  Scenario: Handle opponent lineup not set
    Given opponent hasn't set lineup
    When I view matchup
    Then I should see lineup not set
    And partial info should show
    And I should check later

  # ============================================================================
  # MOBILE EXPERIENCE
  # ============================================================================

  @mobile
  Scenario: View matchups on mobile
    Given I am using mobile app
    When I view matchups
    Then display should be mobile-optimized
    And matchup should be readable
    And I should navigate easily

  @mobile
  Scenario: Track live scores on mobile
    Given I am on mobile
    When I track live scores
    Then scores should update on mobile
    And notifications should work
    And I should stay connected

  @mobile
  Scenario: Compare players on mobile
    Given I am on mobile
    When I compare players
    Then comparison should work on mobile
    And I should swipe between
    And data should be clear

  @mobile
  Scenario: Receive matchup alerts on mobile
    Given matchup alerts are enabled
    When alert is triggered
    Then I should receive mobile push
    And I should tap to view
    And I should stay informed

  # ============================================================================
  # ACCESSIBILITY
  # ============================================================================

  @accessibility
  Scenario: Navigate matchups with keyboard
    Given I am using keyboard navigation
    When I browse matchups
    Then I should navigate with keyboard
    And all features should be accessible
    And focus should be visible

  @accessibility
  Scenario: Screen reader matchup access
    Given I am using a screen reader
    When I view matchups
    Then matchup should be announced
    And scores should be read
    And I should understand matchup

  @accessibility
  Scenario: High contrast matchup display
    Given I have high contrast enabled
    When I view matchups
    Then interface should be readable
    And scores should be visible
    And data should be clear

  @accessibility
  Scenario: Matchups with reduced motion
    Given I have reduced motion enabled
    When matchup updates occur
    Then animations should be minimal
    And updates should still be visible
    And functionality should work
