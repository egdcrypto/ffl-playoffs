@standard-leagues
Feature: Standard Leagues
  As a fantasy football manager
  I want to compete in standard scoring leagues
  So that I can enjoy traditional fantasy football with established scoring rules

  Background:
    Given the fantasy football platform is available
    And I am logged in as a registered user
    And I am a member of a standard scoring league

  # ============================================================================
  # STANDARD SCORING RULES
  # ============================================================================

  @standard-scoring-rules
  Scenario: View standard scoring overview
    Given my league uses standard scoring
    When I access the scoring settings
    Then I should see all standard scoring categories
    And I should see point values for each category
    And I should understand how scoring works

  @standard-scoring-rules
  Scenario: Calculate player score using standard rules
    Given a player has accumulated stats
    When their score is calculated
    Then points should be awarded per standard rules
    And all applicable categories should contribute
    And the total should be accurate

  @standard-scoring-rules
  Scenario: Compare standard scoring to PPR
    Given I want to understand format differences
    When I view scoring comparisons
    Then I should see standard excludes reception points
    And I should see how player values differ
    And I should understand strategic implications

  @standard-scoring-rules
  Scenario: View standard scoring breakdown
    Given my player has scored points
    When I view their scoring breakdown
    Then I should see points by category
    And I should see yardage contributions
    And I should see touchdown points

  @standard-scoring-rules
  Scenario: Understand standard scoring philosophy
    Given I am new to standard leagues
    When I access scoring help
    Then I should see explanation of standard format
    And I should see why it is considered traditional
    And I should understand its characteristics

  @standard-scoring-rules
  Scenario: View league scoring settings summary
    Given all scoring rules are configured
    When I view the settings summary
    Then I should see complete scoring configuration
    And I should see any custom modifications
    And I should see the format labeled as standard

  @standard-scoring-rules
  Scenario: Track scoring in real-time
    Given games are in progress
    When my players accumulate stats
    Then I should see standard scoring updates
    And updates should reflect standard rules
    And my team total should update live

  @standard-scoring-rules
  Scenario: View historical standard scoring
    Given previous weeks have concluded
    When I view historical scoring
    Then I should see past week scores
    And I should see scoring breakdowns
    And I should see trends over time

  @standard-scoring-rules
  Scenario Outline: Apply standard scoring for stat categories
    Given my player has <stat_type> of <amount>
    When points are calculated
    Then the player should receive <points> points

    Examples:
      | stat_type       | amount | points |
      | passing yards   | 300    | 12     |
      | rushing yards   | 100    | 10     |
      | receiving yards | 80     | 8      |
      | passing TD      | 2      | 8      |
      | rushing TD      | 1      | 6      |
      | receiving TD    | 1      | 6      |

  # ============================================================================
  # TOUCHDOWN SCORING
  # ============================================================================

  @touchdown-scoring
  Scenario: Score passing touchdown
    Given my quarterback throws a touchdown
    When the touchdown is recorded
    Then the quarterback should receive passing TD points
    And the standard value should be 4 points
    And my team score should update

  @touchdown-scoring
  Scenario: Score rushing touchdown
    Given my running back scores a rushing touchdown
    When the touchdown is recorded
    Then the player should receive rushing TD points
    And the standard value should be 6 points
    And my team score should update

  @touchdown-scoring
  Scenario: Score receiving touchdown
    Given my receiver catches a touchdown pass
    When the touchdown is recorded
    Then the receiver should receive receiving TD points
    And the standard value should be 6 points
    And my team score should update

  @touchdown-scoring
  Scenario: Score return touchdown
    Given my player returns a kick for a touchdown
    When the touchdown is recorded
    Then the player should receive return TD points
    And the standard value should be 6 points
    And my team score should update

  @touchdown-scoring
  Scenario: View touchdown scoring leaders
    Given the week has concluded
    When I view touchdown leaders
    Then I should see most touchdowns by player
    And I should see TD points contribution
    And I should see league-wide TD stats

  @touchdown-scoring
  Scenario: Track live touchdown scoring
    Given a game is in progress
    When my player scores a touchdown
    Then the TD should appear immediately
    And points should be added to their total
    And I should see the play description

  @touchdown-scoring
  Scenario: Handle two-point conversion
    Given my player scores a two-point conversion
    When the conversion is recorded
    Then the player should receive 2 points
    And this should be separate from TD scoring
    And my team total should reflect it

  @touchdown-scoring
  Scenario: View touchdown history
    Given I want to see TD performance
    When I view my player's TD history
    Then I should see TDs by game
    And I should see TD types
    And I should see seasonal totals

  @touchdown-scoring
  Scenario: Project touchdown upside
    Given I want to optimize my lineup
    When I view TD projections
    Then I should see projected TDs by player
    And I should see red zone opportunity data
    And I should make informed decisions

  # ============================================================================
  # YARDAGE POINTS
  # ============================================================================

  @yardage-points
  Scenario: Calculate passing yardage points
    Given my quarterback passes for yards
    When yardage points are calculated
    Then points should be awarded at 1 per 25 yards
    And partial yards should be handled correctly
    And total should be accurate

  @yardage-points
  Scenario: Calculate rushing yardage points
    Given my running back rushes for yards
    When yardage points are calculated
    Then points should be awarded at 1 per 10 yards
    And this should apply to all rushing yards
    And total should be accurate

  @yardage-points
  Scenario: Calculate receiving yardage points
    Given my receiver gains receiving yards
    When yardage points are calculated
    Then points should be awarded at 1 per 10 yards
    And this should apply to all receiving yards
    And total should be accurate

  @yardage-points
  Scenario: View yardage breakdown by type
    Given my player has multiple yard types
    When I view their scoring breakdown
    Then I should see rushing yards and points
    And I should see receiving yards and points
    And I should see the calculation clearly

  @yardage-points
  Scenario: Track live yardage accumulation
    Given a game is in progress
    When my player gains yards
    Then I should see yardage update in real-time
    And I should see corresponding point changes
    And updates should be accurate

  @yardage-points
  Scenario: Handle negative yardage
    Given my player loses yards on a play
    When the negative yards are recorded
    Then their yardage total should decrease
    And points should be reduced accordingly
    And the calculation should be correct

  @yardage-points
  Scenario: View yardage leaders
    Given the week has concluded
    When I view yardage leaders
    Then I should see top yardage performers
    And I should see yards by category
    And I should see corresponding points

  @yardage-points
  Scenario: Calculate yardage bonus
    Given my league has yardage bonuses
    And my player reaches a bonus threshold
    When their score is calculated
    Then they should receive bonus points
    And the bonus should show in breakdown
    And total should include the bonus

  @yardage-points
  Scenario: Project yardage for matchups
    Given I want to evaluate matchups
    When I view yardage projections
    Then I should see projected yards by player
    And I should see matchup difficulty
    And I should use this for lineup decisions

  # ============================================================================
  # TURNOVER PENALTIES
  # ============================================================================

  @turnover-penalties
  Scenario: Apply interception penalty
    Given my quarterback throws an interception
    When the turnover is recorded
    Then the quarterback should lose points
    And the standard penalty should be applied
    And my team score should decrease

  @turnover-penalties
  Scenario: Apply fumble lost penalty
    Given my player fumbles and loses the ball
    When the fumble lost is recorded
    Then the player should lose points
    And the standard penalty should be applied
    And my team score should decrease

  @turnover-penalties
  Scenario: Handle fumble not lost
    Given my player fumbles but recovers
    When the play is recorded
    Then no penalty should be applied
    And the player's score should be unchanged
    And only lost fumbles should penalize

  @turnover-penalties
  Scenario: View turnover impact on score
    Given my player has committed turnovers
    When I view their scoring breakdown
    Then I should see turnover penalties listed
    And I should see the point deduction
    And I should understand the impact

  @turnover-penalties
  Scenario: Track turnovers in real-time
    Given a game is in progress
    When my player commits a turnover
    Then I should see the penalty immediately
    And my score should update live
    And the turnover should be noted

  @turnover-penalties
  Scenario: View league turnover leaders
    Given turnovers affect scoring
    When I view turnover statistics
    Then I should see most turnovers by player
    And I should see points lost to turnovers
    And I should see league-wide data

  @turnover-penalties
  Scenario: Analyze turnover-prone players
    Given I want to minimize turnover risk
    When I evaluate players
    Then I should see turnover history
    And I should see turnover rates
    And I should factor this into decisions

  @turnover-penalties
  Scenario: Configure turnover penalty values
    Given I am the commissioner
    When I access scoring settings
    Then I should be able to set INT penalty
    And I should be able to set fumble lost penalty
    And custom values should be saved

  @turnover-penalties
  Scenario: Handle multiple turnovers in a game
    Given my player commits multiple turnovers
    When all turnovers are recorded
    Then each turnover should apply a penalty
    And total penalties should be cumulative
    And my score should reflect all turnovers

  # ============================================================================
  # KICKER SCORING
  # ============================================================================

  @kicker-scoring
  Scenario: Score field goal by distance
    Given my kicker makes a field goal
    When the field goal is recorded
    Then points should be awarded based on distance
    And longer field goals should earn more points
    And my team score should update

  @kicker-scoring
  Scenario: Score extra point
    Given my kicker makes an extra point
    When the extra point is recorded
    Then the kicker should receive 1 point
    And this should add to their total
    And my team score should update

  @kicker-scoring
  Scenario: Handle missed field goal
    Given my kicker misses a field goal
    When the miss is recorded
    Then points should be deducted if configured
    And the missed attempt should be noted
    And my team score should reflect it

  @kicker-scoring
  Scenario: Handle missed extra point
    Given my kicker misses an extra point
    When the miss is recorded
    Then points should be deducted if configured
    And the missed attempt should be noted
    And my team score should reflect it

  @kicker-scoring
  Scenario: View kicker scoring breakdown
    Given my kicker has scored this week
    When I view their breakdown
    Then I should see field goals by distance
    And I should see extra points made
    And I should see any missed kick penalties

  @kicker-scoring
  Scenario: Track kicker performance live
    Given a game is in progress
    When my kicker attempts a kick
    Then I should see the result immediately
    And points should update in real-time
    And I should see the kick distance

  @kicker-scoring
  Scenario: View kicker rankings
    Given I need to evaluate kickers
    When I view kicker rankings
    Then I should see kickers by total points
    And I should see field goal percentages
    And I should see opportunity metrics

  @kicker-scoring
  Scenario: Project kicker scoring
    Given I want to optimize my kicker start
    When I view kicker projections
    Then I should see projected points
    And I should see team scoring expectations
    And I should see indoor vs outdoor factors

  @kicker-scoring
  Scenario Outline: Award field goal points by distance
    Given my kicker makes a field goal from <distance> yards
    When points are calculated
    Then the kicker should receive <points> points

    Examples:
      | distance | points |
      | 25       | 3      |
      | 35       | 3      |
      | 42       | 4      |
      | 52       | 5      |
      | 55       | 5      |

  # ============================================================================
  # DEFENSE SCORING
  # ============================================================================

  @defense-scoring
  Scenario: Score defense based on points allowed
    Given my defense allows a certain number of points
    When defensive scoring is calculated
    Then points should be awarded based on points allowed
    And fewer points allowed means more fantasy points
    And my team score should reflect this

  @defense-scoring
  Scenario: Score defensive touchdown
    Given my defense scores a touchdown
    When the touchdown is recorded
    Then the defense should receive TD points
    And this should add to their total
    And my team score should update

  @defense-scoring
  Scenario: Score defensive interception
    Given my defense intercepts a pass
    When the interception is recorded
    Then the defense should receive turnover points
    And the standard value should apply
    And my team score should update

  @defense-scoring
  Scenario: Score defensive fumble recovery
    Given my defense recovers a fumble
    When the recovery is recorded
    Then the defense should receive turnover points
    And this should add to their total
    And my team score should update

  @defense-scoring
  Scenario: Score defensive sack
    Given my defense sacks the quarterback
    When the sack is recorded
    Then the defense should receive sack points
    And each sack should earn points
    And my team score should update

  @defense-scoring
  Scenario: Score defensive safety
    Given my defense scores a safety
    When the safety is recorded
    Then the defense should receive safety points
    And the standard value should be 2 points
    And my team score should update

  @defense-scoring
  Scenario: View defense scoring breakdown
    Given my defense has scored this week
    When I view their breakdown
    Then I should see points allowed category
    And I should see takeaways
    And I should see sacks and special scores

  @defense-scoring
  Scenario: Track defensive performance live
    Given a game is in progress
    When my defense makes plays
    Then I should see scoring updates in real-time
    And points allowed should update
    And individual stats should be tracked

  @defense-scoring
  Scenario: Evaluate defensive matchups
    Given I am choosing a defense
    When I analyze matchups
    Then I should see opponent scoring averages
    And I should see turnover tendencies
    And I should make an informed decision

  @defense-scoring
  Scenario Outline: Award defense points by points allowed
    Given my defense allows <points_allowed> points
    When defensive scoring is calculated
    Then the defense should receive <fantasy_points> fantasy points

    Examples:
      | points_allowed | fantasy_points |
      | 0              | 10             |
      | 6              | 7              |
      | 13             | 4              |
      | 20             | 1              |
      | 28             | 0              |
      | 35             | -1             |

  # ============================================================================
  # STANDARD ROSTER POSITIONS
  # ============================================================================

  @standard-roster-positions
  Scenario: View standard roster configuration
    Given my league uses standard roster positions
    When I view roster settings
    Then I should see quarterback slot
    And I should see running back slots
    And I should see wide receiver slots
    And I should see flex and other positions

  @standard-roster-positions
  Scenario: Set lineup with standard positions
    Given I have players for each position
    When I set my starting lineup
    Then I should fill all required positions
    And I should see eligibility enforced
    And my lineup should be valid

  @standard-roster-positions
  Scenario: Understand standard roster structure
    Given I am new to standard leagues
    When I access roster help
    Then I should see typical position counts
    And I should see bench size
    And I should understand roster construction

  @standard-roster-positions
  Scenario: View position eligibility
    Given I want to know player eligibility
    When I view a player's details
    Then I should see their eligible positions
    And I should see where they can be placed
    And eligibility should be clear

  @standard-roster-positions
  Scenario: Handle flex position in standard
    Given I have a flex slot to fill
    When I select a player for flex
    Then RB, WR, and TE should be eligible
    And I should place the best option
    And the system should accept my choice

  @standard-roster-positions
  Scenario: Manage bench positions
    Given I have bench spots available
    When I manage my bench
    Then I should see all bench players
    And I should be able to swap with starters
    And roster management should be easy

  @standard-roster-positions
  Scenario: Handle injured reserve slot
    Given my league has IR slots
    When I place an injured player on IR
    Then the IR slot should be filled
    And I should have a roster spot freed
    And IR rules should be enforced

  @standard-roster-positions
  Scenario: View roster position requirements
    Given I need to understand requirements
    When I view position minimums
    Then I should see required starters by position
    And I should see roster limits
    And I should plan accordingly

  @standard-roster-positions
  Scenario: Configure custom roster positions
    Given I am the commissioner
    When I customize roster positions
    Then I should be able to adjust counts
    And I should add or remove positions
    And changes should be saved

  # ============================================================================
  # STANDARD DRAFT ORDER
  # ============================================================================

  @standard-draft-order
  Scenario: Generate random draft order
    Given the draft order needs to be set
    When the commissioner randomizes draft order
    Then a random order should be generated
    And all teams should be assigned positions
    And the order should be fair

  @standard-draft-order
  Scenario: View draft order
    Given draft order has been set
    When I view the draft order
    Then I should see all team positions
    And I should see my draft position
    And the order should be clear

  @standard-draft-order
  Scenario: Understand snake draft format
    Given the league uses snake draft
    When I view draft explanation
    Then I should understand order reversal each round
    And I should see how picks flow
    And I should plan accordingly

  @standard-draft-order
  Scenario: Set manual draft order
    Given the commissioner wants manual order
    When they set the order manually
    Then each position should be assignable
    And all teams should be placed
    And the order should be saved

  @standard-draft-order
  Scenario: View draft pick schedule
    Given draft order is set
    When I view my pick schedule
    Then I should see when I pick each round
    And I should see the snake pattern
    And I should know my upcoming picks

  @standard-draft-order
  Scenario: Trade draft picks
    Given draft pick trading is allowed
    When I trade a draft pick
    Then the pick should transfer ownership
    And the draft order should reflect the trade
    And both teams should see the change

  @standard-draft-order
  Scenario: Handle tied draft order determination
    Given multiple teams need order decided
    When a tiebreaker is needed
    Then a fair method should be used
    And the tie should be resolved
    And teams should accept the result

  @standard-draft-order
  Scenario: Lock draft order before draft
    Given the draft is approaching
    When the commissioner locks the order
    Then the order should be finalized
    And no further changes should be allowed
    And teams should be notified

  @standard-draft-order
  Scenario: View historical draft orders
    Given previous seasons exist
    When I view historical draft orders
    Then I should see past draft positions
    And I should see how they were determined
    And history should be preserved

  # ============================================================================
  # STANDARD WAIVERS
  # ============================================================================

  @standard-waivers
  Scenario: View waiver wire
    Given players are available on waivers
    When I access the waiver wire
    Then I should see available players
    And I should see waiver status
    And I should be able to make claims

  @standard-waivers
  Scenario: Submit waiver claim
    Given I want to add a player
    When I submit a waiver claim
    Then my claim should be recorded
    And I should set a priority
    And I should select a player to drop

  @standard-waivers
  Scenario: View waiver priority
    Given waiver priority affects claims
    When I view waiver standings
    Then I should see all team priorities
    And I should see my current position
    And I should understand the system

  @standard-waivers
  Scenario: Process waiver claims
    Given waiver period has ended
    When claims are processed
    Then highest priority claims should succeed
    And lower priority claims may fail
    And results should be announced

  @standard-waivers
  Scenario: Handle waiver claim for same player
    Given multiple teams claim the same player
    When claims are processed
    Then higher priority team should win
    And other claims should fail
    And the winning team should add the player

  @standard-waivers
  Scenario: Add free agent after waivers clear
    Given a player has cleared waivers
    When I add them as a free agent
    Then the add should be immediate
    And no waiver claim should be needed
    And my roster should update

  @standard-waivers
  Scenario: View waiver claim results
    Given waivers have processed
    When I view the results
    Then I should see successful claims
    And I should see failed claims
    And I should see new waiver priorities

  @standard-waivers
  Scenario: Configure waiver settings
    Given I am the commissioner
    When I configure waiver settings
    Then I should set waiver type
    And I should set waiver period
    And I should set priority reset rules

  @standard-waivers
  Scenario: Track waiver spending in FAAB
    Given my league uses FAAB waivers
    When I make a bid
    Then my bid amount should be recorded
    And my remaining budget should update
    And spending should be tracked

  # ============================================================================
  # STANDARD LEAGUE SETTINGS
  # ============================================================================

  @standard-league-settings
  Scenario: Create standard league
    Given I want to create a new league
    When I select standard format
    Then default standard settings should be applied
    And I should be able to customize
    And the league should be created

  @standard-league-settings
  Scenario: View all league settings
    Given my league is configured
    When I view league settings
    Then I should see all configuration options
    And I should see current values
    And settings should be organized clearly

  @standard-league-settings
  Scenario: Configure scoring settings
    Given I am the commissioner
    When I access scoring settings
    Then I should be able to modify values
    And I should see standard defaults
    And changes should be saved

  @standard-league-settings
  Scenario: Set league schedule
    Given the league needs a schedule
    When I configure schedule settings
    Then I should set season length
    And I should set playoff weeks
    And the schedule should be generated

  @standard-league-settings
  Scenario: Configure trade settings
    Given trades need rules
    When I configure trade settings
    Then I should set trade deadline
    And I should set review period
    And I should set veto process

  @standard-league-settings
  Scenario: Set roster limits
    Given roster limits need configuration
    When I set roster limits
    Then I should set max roster size
    And I should set position limits
    And limits should be enforced

  @standard-league-settings
  Scenario: Configure playoff settings
    Given playoffs need configuration
    When I set playoff settings
    Then I should set number of playoff teams
    And I should set playoff format
    And I should set tiebreakers

  @standard-league-settings
  Scenario: Import settings from template
    Given standard templates exist
    When I import a template
    Then settings should be pre-configured
    And I should be able to customize
    And setup should be faster

  @standard-league-settings
  Scenario: Lock settings before season
    Given the season is about to start
    When the commissioner locks settings
    Then settings should be finalized
    And changes should require approval
    And teams should be notified

  # ============================================================================
  # ERROR HANDLING
  # ============================================================================

  @error-handling
  Scenario: Handle scoring calculation error
    Given a scoring error occurs
    When the error is detected
    Then the system should attempt recalculation
    And if unresolved, admin should be notified
    And users should see accurate scores

  @error-handling
  Scenario: Handle missing player data
    Given player data is unavailable
    When the system detects missing data
    Then an appropriate message should appear
    And estimated data should be noted
    And the issue should be logged

  @error-handling
  Scenario: Handle stat correction
    Given official stats are corrected
    When corrections are processed
    Then scores should be updated
    And users should be notified
    And matchup results may change

  @error-handling
  Scenario: Handle waiver processing failure
    Given waiver processing fails
    When the failure is detected
    Then the system should retry
    And if persistent, admin should be notified
    And claims should not be lost

  @error-handling
  Scenario: Handle roster submission error
    Given a roster submission fails
    When the error occurs
    Then an error message should appear
    And the user should be able to retry
    And their lineup should not be lost

  @error-handling
  Scenario: Handle draft pick timeout
    Given a drafter does not pick in time
    When the timeout occurs
    Then auto-pick should engage
    And a player should be selected
    And the draft should continue

  @error-handling
  Scenario: Handle league creation failure
    Given league creation fails
    When the failure occurs
    Then an error message should appear
    And the user should be able to retry
    And no partial league should be created

  @error-handling
  Scenario: Handle trade processing error
    Given a trade fails to process
    When the error occurs
    Then both teams should be notified
    And the trade should be retried
    And rosters should remain consistent

  @error-handling
  Scenario: Handle concurrent roster changes
    Given multiple changes occur simultaneously
    When conflicts arise
    Then conflicts should be resolved
    And data integrity should be maintained
    And users should see consistent state

  # ============================================================================
  # ACCESSIBILITY
  # ============================================================================

  @accessibility
  Scenario: Navigate league with screen reader
    Given I am using a screen reader
    When I access league features
    Then all elements should be properly labeled
    And navigation should be logical
    And I should be able to use all features

  @accessibility
  Scenario: Use keyboard navigation
    Given I am navigating via keyboard
    When I access various features
    Then all interactive elements should be focusable
    And tab order should be logical
    And I should complete all tasks

  @accessibility
  Scenario: View in high contrast mode
    Given I use high contrast display
    When I view league information
    Then all text should be readable
    And colors should be distinguishable
    And the experience should be accessible

  @accessibility
  Scenario: Access on mobile devices
    Given I am using a mobile device
    When I access league features
    Then the interface should be responsive
    And touch targets should be appropriate
    And all features should work on mobile

  @accessibility
  Scenario: Receive accessible notifications
    Given I have accessibility preferences
    When I receive notifications
    Then notifications should be screen reader compatible
    And important information should be conveyed
    And preferences should be respected

  @accessibility
  Scenario: Set lineup with accessibility tools
    Given I use accessibility tools
    When I set my lineup
    Then all roster positions should be accessible
    And player information should be announced
    And I should complete lineup setting

  @accessibility
  Scenario: Participate in draft with accessibility
    Given I need accessible draft experience
    When I participate in the draft
    Then draft board should be accessible
    And picks should be announced
    And I should make selections

  @accessibility
  Scenario: View standings accessibly
    Given I need to view standings
    When I access standings page
    Then table should be accessible
    And rankings should be clear
    And I should understand positions

  @accessibility
  Scenario: Access settings with voice control
    Given I use voice control
    When I access league settings
    Then voice commands should work
    And settings should be navigable
    And I should make changes by voice

  # ============================================================================
  # PERFORMANCE
  # ============================================================================

  @performance
  Scenario: Load league page quickly
    Given I am accessing my league
    When the page loads
    Then content should appear within 2 seconds
    And all data should load smoothly
    And the experience should be responsive

  @performance
  Scenario: Calculate scores efficiently
    Given many players need scoring
    When scores are calculated
    Then calculations should complete quickly
    And all scores should be accurate
    And no timeouts should occur

  @performance
  Scenario: Process waivers for large league
    Given a league has many teams and claims
    When waivers are processed
    Then processing should complete efficiently
    And all claims should be handled
    And results should be accurate

  @performance
  Scenario: Handle draft with many participants
    Given a draft has many participants
    When the draft runs
    Then the interface should remain responsive
    And picks should register quickly
    And no lag should occur

  @performance
  Scenario: Load standings efficiently
    Given standings need calculation
    When I view standings
    Then standings should load quickly
    And calculations should be accurate
    And performance should be good

  @performance
  Scenario: Handle high traffic on game days
    Given many users access the platform
    When traffic peaks during games
    Then performance should remain stable
    And all users should have good experience
    And no degradation should occur

  @performance
  Scenario: Cache frequently accessed data
    Given certain data is accessed often
    When data is requested
    Then cached data should be used when valid
    And cache should update appropriately
    And performance should benefit

  @performance
  Scenario: Update live scores efficiently
    Given games are in progress
    When scores update live
    Then updates should appear promptly
    And the interface should remain responsive
    And no data should be lost

  @performance
  Scenario: Generate reports quickly
    Given I request league reports
    When reports are generated
    Then generation should complete quickly
    And reports should be accurate
    And the experience should be smooth
