@head-to-head-leagues
Feature: Head to Head Leagues
  As a fantasy football manager
  I want to compete in head-to-head matchups against other managers
  So that I can experience traditional weekly competition with direct opponents

  Background:
    Given the fantasy football platform is available
    And I am logged in as a registered user
    And I am a member of a head-to-head league

  # ============================================================================
  # WEEKLY MATCHUPS
  # ============================================================================

  @weekly-matchups
  Scenario: View current week matchup
    Given my league uses head-to-head format
    And the current NFL week is active
    When I navigate to my matchup page
    Then I should see my team paired against an opponent
    And I should see both team lineups side by side
    And I should see projected points for each team
    And I should see the matchup deadline

  @weekly-matchups
  Scenario: View live matchup scoring
    Given my matchup is currently in progress
    And NFL games are being played
    When I view my matchup details
    Then I should see real-time point updates
    And I should see which players are currently playing
    And I should see win probability percentage
    And I should see points remaining projections

  @weekly-matchups
  Scenario: View all league matchups for the week
    Given my league has multiple teams competing
    And the current week schedule is set
    When I view the league matchups page
    Then I should see all head-to-head pairings
    And I should see scores or projections for each matchup
    And I should see completed and in-progress indicators
    And I should be able to click into any matchup

  @weekly-matchups
  Scenario: Receive matchup preview notification
    Given I have notifications enabled
    And my weekly matchup is scheduled
    When the matchup preview period begins
    Then I should receive a matchup preview notification
    And the notification should include opponent information
    And the notification should include key player matchups

  @weekly-matchups
  Scenario: View matchup history with opponent
    Given I have faced the same opponent in previous weeks
    When I view my current matchup details
    Then I should see our head-to-head record
    And I should see previous matchup scores
    And I should see average points when facing each other

  @weekly-matchups
  Scenario: Compare rosters in matchup view
    Given I am viewing my weekly matchup
    When I access the roster comparison tool
    Then I should see position-by-position comparisons
    And I should see strength indicators for each position
    And I should see injury status for both rosters
    And I should see bye week impacts

  @weekly-matchups
  Scenario: View matchup with bye week challenges
    Given several of my starters have bye weeks
    And I am viewing my matchup
    When I analyze my matchup situation
    Then I should see bye week warnings
    And I should see suggested replacements
    And I should see impact on projected score

  @weekly-matchups
  Scenario: Handle matchup during short week
    Given my matchup includes Thursday night players
    And it is Wednesday before game time
    When I view my matchup
    Then I should see early game lineup lock warnings
    And I should see countdown to Thursday kickoff
    And I should be prompted to set my lineup

  @weekly-matchups
  Scenario Outline: View matchup result status
    Given my matchup has concluded
    And my team scored <my_score> points
    And my opponent scored <opponent_score> points
    When I view the matchup result
    Then I should see the result as "<result>"
    And I should see the final margin of <margin> points

    Examples:
      | my_score | opponent_score | result | margin |
      | 125.5    | 110.3          | Win    | 15.2   |
      | 98.7     | 115.2          | Loss   | 16.5   |
      | 105.0    | 105.0          | Tie    | 0.0    |

  # ============================================================================
  # WIN-LOSS RECORDS
  # ============================================================================

  @win-loss-records
  Scenario: View my team record
    Given I have completed several weeks of matchups
    When I view my team standings
    Then I should see my win-loss-tie record
    And I should see my winning percentage
    And I should see my current streak
    And I should see my playoff positioning

  @win-loss-records
  Scenario: View league standings by record
    Given multiple matchups have been completed
    When I view the league standings
    Then I should see teams ordered by record
    And I should see wins, losses, and ties for each team
    And I should see points for and against
    And I should see current ranking

  @win-loss-records
  Scenario: View head-to-head record against specific team
    Given I have played against a specific team multiple times
    When I view my record against that team
    Then I should see our all-time head-to-head record
    And I should see each matchup result
    And I should see total points scored in those matchups
    And I should see average margin of victory or defeat

  @win-loss-records
  Scenario: Track record trends over season
    Given the season has progressed several weeks
    When I view my team performance trends
    Then I should see my record progression by week
    And I should see hot and cold streaks identified
    And I should see trajectory toward playoffs

  @win-loss-records
  Scenario: View divisional record
    Given my league uses divisions
    And I have played divisional opponents
    When I view my divisional standings
    Then I should see my record against division opponents
    And I should see divisional win percentage
    And I should see divisional ranking

  @win-loss-records
  Scenario: Compare records across seasons
    Given I have participated in multiple seasons
    When I view my historical records
    Then I should see my record for each season
    And I should see playoff appearances
    And I should see championship wins
    And I should see all-time record

  @win-loss-records
  Scenario: View record breakdown by opponent strength
    Given I have completed multiple matchups
    When I analyze my record breakdown
    Then I should see record against top teams
    And I should see record against bottom teams
    And I should see record against middle-tier teams

  @win-loss-records
  Scenario: Handle tied records in standings
    Given two teams have identical records
    When I view the league standings
    Then I should see tiebreaker criteria applied
    And I should see the tiebreaker used indicated
    And I should see teams properly ordered

  @win-loss-records
  Scenario: View current standings clinch scenarios
    Given the season is nearing playoff cutoff
    When I view playoff clinching scenarios
    Then I should see which records clinch playoffs
    And I should see which records result in elimination
    And I should see scenarios that keep hopes alive

  # ============================================================================
  # SCHEDULE GENERATION
  # ============================================================================

  @schedule-generation
  Scenario: Generate balanced regular season schedule
    Given a new league has been created
    And all teams have been finalized
    When the commissioner generates the schedule
    Then each team should play the same number of games
    And matchups should be distributed evenly
    And the schedule should minimize repeat matchups

  @schedule-generation
  Scenario: Generate schedule with divisions
    Given the league has configured divisions
    And teams are assigned to divisions
    When the schedule is generated
    Then teams should play divisional opponents more frequently
    And all teams should play at least once
    And divisional schedules should be balanced

  @schedule-generation
  Scenario: Customize schedule manually
    Given the commissioner has schedule editing privileges
    When the commissioner accesses schedule management
    Then they should be able to swap matchups
    And they should be able to set specific week pairings
    And changes should maintain schedule balance

  @schedule-generation
  Scenario: Handle odd number of teams
    Given the league has an odd number of teams
    When the schedule is generated
    Then one team should have a bye each week
    And byes should be distributed evenly
    And all teams should receive the same number of byes

  @schedule-generation
  Scenario: Generate playoff schedule
    Given the regular season has concluded
    And playoff teams have been determined
    When the playoff bracket is generated
    Then seeding should be based on standings
    And bracket structure should match playoff settings
    And matchups should be set for round one

  @schedule-generation
  Scenario: Regenerate schedule before season starts
    Given the season has not started
    And a schedule exists
    When the commissioner regenerates the schedule
    Then a new random schedule should be created
    And the previous schedule should be replaced
    And the commissioner should confirm the change

  @schedule-generation
  Scenario: View full season schedule
    Given the schedule has been generated
    When I view the full season schedule
    Then I should see all weeks listed
    And I should see my opponent for each week
    And I should see home or away designation if applicable

  @schedule-generation
  Scenario: Export schedule to calendar
    Given I want to track my matchups externally
    When I export my schedule
    Then I should receive a calendar file
    And each matchup should be a calendar event
    And events should include opponent information

  @schedule-generation
  Scenario: Prevent schedule changes after season starts
    Given the regular season has begun
    When the commissioner attempts to regenerate the schedule
    Then the system should prevent regeneration
    And an explanation should be provided
    And manual adjustments should still be possible with restrictions

  # ============================================================================
  # DIVISION PLAY
  # ============================================================================

  @division-play
  Scenario: Configure league divisions
    Given I am the commissioner
    When I access division settings
    Then I should be able to create divisions
    And I should be able to name divisions
    And I should be able to assign teams to divisions
    And I should see balanced division sizes

  @division-play
  Scenario: View divisional standings
    Given my league uses divisions
    And the season is in progress
    When I view standings by division
    Then I should see teams grouped by division
    And I should see divisional records
    And I should see division leaders highlighted
    And I should see wild card standings

  @division-play
  Scenario: Track divisional matchup frequency
    Given divisional scheduling is configured
    When I view my schedule
    Then I should see divisional games marked
    And I should see more games against division opponents
    And I should see divisional matchup count

  @division-play
  Scenario: Determine division winner
    Given the regular season has concluded
    And divisional play was used
    When playoff seeding is determined
    Then division winners should receive priority seeding
    And ties should use divisional record as tiebreaker
    And wild card teams should fill remaining spots

  @division-play
  Scenario: View cross-division matchups
    Given I want to see inter-division games
    When I filter matchups by cross-division
    Then I should see only matchups between divisions
    And I should see divisional balance information

  @division-play
  Scenario: Handle uneven divisions
    Given the league has more teams in one division
    When standings are calculated
    Then percentage-based comparisons should be used
    And playoff spots should account for size differences

  @division-play
  Scenario: Rename or restructure divisions mid-season
    Given divisions need to be modified
    And the commissioner has appropriate permissions
    When division structure is changed
    Then historical divisional records should be preserved
    And future matchups should reflect changes
    And standings should be recalculated if needed

  @division-play
  Scenario: View division rivalry history
    Given divisions have multi-season history
    When I view division statistics
    Then I should see historical division champions
    And I should see all-time divisional records
    And I should see divisional dominance metrics

  @division-play
  Scenario: Configure divisional playoff format
    Given playoffs will use divisional format
    When the commissioner configures playoffs
    Then they should be able to set division winner auto-bids
    And they should set wild card spot allocation
    And they should configure cross-division playoff matchups

  # ============================================================================
  # PLAYOFF SEEDING
  # ============================================================================

  @playoff-seeding
  Scenario: Calculate playoff seeding from standings
    Given the regular season has concluded
    And final standings are determined
    When playoff seeding is calculated
    Then top teams should receive highest seeds
    And seeding should respect division winners
    And wild card teams should be seeded appropriately

  @playoff-seeding
  Scenario: View projected playoff seeding
    Given the season is in progress
    When I view projected standings
    Then I should see current playoff seeding
    And I should see teams on bubble highlighted
    And I should see magic numbers for clinching

  @playoff-seeding
  Scenario: Configure number of playoff teams
    Given I am the commissioner
    When I configure playoff settings
    Then I should be able to set playoff team count
    And I should see bracket structure preview
    And I should set first round byes if applicable

  @playoff-seeding
  Scenario: Handle seeding with division winners
    Given the league uses divisions
    And division winners get automatic bids
    When seeding is determined
    Then division winners should receive top seeds
    And remaining seeds go to best records
    And wild cards fill remaining positions

  @playoff-seeding
  Scenario: Award first round bye
    Given playoffs are configured with byes
    When seeding is finalized
    Then top seeds should receive first round byes
    And bye teams should advance automatically
    And bracket should show bye notation

  @playoff-seeding
  Scenario: Reseed bracket after each round
    Given the league uses reseeding format
    When a playoff round concludes
    Then remaining teams should be reseeded
    And highest seed should face lowest seed
    And bracket should update accordingly

  @playoff-seeding
  Scenario: Lock playoff seeding
    Given the regular season has ended
    When seeding is finalized
    Then seeding should be locked
    And changes should require commissioner override
    And historical record should be preserved

  @playoff-seeding
  Scenario: View playoff picture throughout season
    Given the season is ongoing
    When I view the playoff picture
    Then I should see current projected matchups
    And I should see each team's path to playoffs
    And I should see elimination scenarios

  @playoff-seeding
  Scenario Outline: Handle different playoff formats
    Given the league has <teams> playoff teams
    And the format is <format>
    When the playoff bracket is set
    Then the bracket should have <rounds> rounds
    And <byes> teams should have first round byes

    Examples:
      | teams | format       | rounds | byes |
      | 4     | Single Elim  | 2      | 0    |
      | 6     | Single Elim  | 3      | 2    |
      | 8     | Single Elim  | 3      | 0    |
      | 6     | Double Elim  | 4      | 2    |

  # ============================================================================
  # TIEBREAKER RULES
  # ============================================================================

  @tiebreaker-rules
  Scenario: Configure tiebreaker priority
    Given I am the commissioner
    When I access tiebreaker settings
    Then I should be able to set tiebreaker order
    And I should see available tiebreaker options
    And I should be able to save custom configuration

  @tiebreaker-rules
  Scenario: Apply points for tiebreaker
    Given two teams have identical records
    And points for is the first tiebreaker
    When standings are calculated
    Then the team with more points for should rank higher
    And the tiebreaker used should be displayed

  @tiebreaker-rules
  Scenario: Apply head-to-head tiebreaker
    Given two teams have identical records
    And head-to-head is the first tiebreaker
    When standings are calculated
    Then the team with better head-to-head record should rank higher
    And if split, the next tiebreaker should apply

  @tiebreaker-rules
  Scenario: Apply divisional record tiebreaker
    Given two teams in the same division are tied
    And divisional record is a tiebreaker
    When standings are calculated
    Then the team with better divisional record should rank higher

  @tiebreaker-rules
  Scenario: Handle three-way tie
    Given three teams have identical records
    When tiebreakers are applied
    Then head-to-head among all three should be checked
    And if inconclusive, next tiebreaker applies
    And proper ordering should be determined

  @tiebreaker-rules
  Scenario: Display tiebreaker explanation
    Given a tiebreaker has been applied
    When I view the standings
    Then I should see which tiebreaker was used
    And I should see the specific values compared
    And the explanation should be clear

  @tiebreaker-rules
  Scenario: Use points against as tiebreaker
    Given two teams are tied on primary tiebreakers
    And points against is configured as a tiebreaker
    When the tiebreaker is applied
    Then the team with fewer points against should rank higher

  @tiebreaker-rules
  Scenario: Apply victory margin tiebreaker
    Given teams are tied after other tiebreakers
    And victory margin is configured
    When this tiebreaker is applied
    Then average margin of victory should be compared
    And higher margin should rank higher

  @tiebreaker-rules
  Scenario: Handle tiebreaker for playoff seeding vs elimination
    Given multiple teams are on the playoff bubble
    And they have identical records
    When the final standings are determined
    Then tiebreakers should be applied consistently
    And affected teams should be notified
    And final positions should be clearly shown

  @tiebreaker-rules
  Scenario: Use coin flip as final tiebreaker
    Given all configured tiebreakers result in ties
    And coin flip is the final tiebreaker
    When the coin flip is executed
    Then the result should be random
    And the outcome should be recorded
    And the result should be displayed to the league

  # ============================================================================
  # MATCHUP SCORING
  # ============================================================================

  @matchup-scoring
  Scenario: Calculate weekly matchup score
    Given my lineup is set for the week
    And NFL games have concluded
    When matchup scoring is calculated
    Then all active player points should be summed
    And bench player points should not be included
    And my total should match my lineup performance

  @matchup-scoring
  Scenario: View position-by-position scoring breakdown
    Given my matchup has concluded
    When I view the scoring breakdown
    Then I should see points by position group
    And I should see who won each position battle
    And I should see the margin at each position

  @matchup-scoring
  Scenario: Track scoring throughout games
    Given NFL games are in progress
    When I view my live matchup
    Then I should see real-time score updates
    And I should see projected final scores
    And I should see time remaining in games

  @matchup-scoring
  Scenario: Handle stat corrections
    Given my matchup has been finalized
    And the NFL issues stat corrections
    When corrections are applied
    Then my matchup score should be updated
    And the result may change if margin was small
    And I should be notified of any changes

  @matchup-scoring
  Scenario: View scoring leaders in matchup
    Given my matchup is complete
    When I view matchup details
    Then I should see top scorers from each team
    And I should see biggest performances highlighted
    And I should see underperformers noted

  @matchup-scoring
  Scenario: Compare matchup scores league-wide
    Given all matchups for the week are complete
    When I view league scoring summary
    Then I should see all matchup scores
    And I should see highest scoring team
    And I should see average score for the week

  @matchup-scoring
  Scenario: Track Monday Night miracle scenarios
    Given my matchup extends to Monday Night Football
    And I am trailing my opponent
    When I view Monday scenarios
    Then I should see points needed from remaining players
    And I should see probability of comeback
    And I should see historical context

  @matchup-scoring
  Scenario: View scoring consistency metrics
    Given multiple weeks have been played
    When I view my scoring trends
    Then I should see my average weekly score
    And I should see my scoring variance
    And I should see my floor and ceiling games

  @matchup-scoring
  Scenario: Handle zero-point performances
    Given a player in my lineup scores zero points
    When the matchup is scored
    Then the zero should be correctly recorded
    And injury status should be noted
    And the impact on my matchup should be shown

  # ============================================================================
  # RIVALRY MATCHUPS
  # ============================================================================

  @rivalry-matchups
  Scenario: Identify natural rivalries
    Given my league has rivalry designations
    When I view rivalry matchups
    Then I should see my designated rival
    And I should see our all-time rivalry record
    And I should see rivalry matchups highlighted on schedule

  @rivalry-matchups
  Scenario: Track rivalry statistics
    Given I have a designated rival
    When I view rivalry history
    Then I should see total games played
    And I should see points differential
    And I should see biggest wins and losses
    And I should see current streak

  @rivalry-matchups
  Scenario: Set custom rivalry designations
    Given I am the commissioner
    When I configure rivalry settings
    Then I should be able to pair rivals
    And I should be able to name rivalries
    And I should ensure all teams have rivals

  @rivalry-matchups
  Scenario: View rivalry week notifications
    Given it is rivalry week on the schedule
    When I receive matchup notifications
    Then rivalry status should be emphasized
    And special rivalry messaging should appear
    And rivalry stakes should be highlighted

  @rivalry-matchups
  Scenario: Display rivalry trophy or badge
    Given my league has rivalry achievements
    When a rivalry matchup concludes
    Then the winner should receive rivalry recognition
    And season rivalry leaders should be tracked
    And all-time rivalry dominance should be noted

  @rivalry-matchups
  Scenario: Generate automatic rivalries from history
    Given the league has multiple seasons of history
    When automatic rivalries are generated
    Then closest all-time records should be paired
    And geographic or division factors should be considered
    And compelling matchups should be identified

  @rivalry-matchups
  Scenario: View division rivalry standings
    Given divisional play creates natural rivalries
    When I view division rivalry board
    Then I should see records against each division opponent
    And I should see who dominates the division
    And I should see division rivalry trends

  @rivalry-matchups
  Scenario: Track rivalry matchup importance
    Given playoff implications exist in rivalry game
    When I view the rivalry matchup
    Then I should see playoff impact for both teams
    And I should see stakes clearly displayed
    And I should see historical context with stakes

  @rivalry-matchups
  Scenario: Handle rivalry matchup in playoffs
    Given rivals meet in playoff matchup
    When the playoff rivalry game occurs
    Then special playoff rivalry status should be noted
    And elimination stakes should be emphasized
    And rivalry history should be prominently displayed

  # ============================================================================
  # CONSOLATION BRACKET
  # ============================================================================

  @consolation-bracket
  Scenario: Generate consolation bracket
    Given playoff teams have been determined
    And non-playoff teams remain
    When the consolation bracket is created
    Then all non-playoff teams should be included
    And seeding should be based on standings
    And bracket structure should be clear

  @consolation-bracket
  Scenario: Compete in consolation matchups
    Given I did not make the playoffs
    And the consolation bracket is active
    When I view my consolation matchup
    Then I should see my opponent
    And I should see bracket progression
    And I should see consolation standings

  @consolation-bracket
  Scenario: Win consolation championship
    Given I have advanced through consolation rounds
    When I win the final consolation matchup
    Then I should be recognized as consolation champion
    And the achievement should be recorded
    And league history should reflect the win

  @consolation-bracket
  Scenario: Play for draft position
    Given consolation affects next year's draft order
    When consolation games are played
    Then standings should determine draft position
    And incentive to win should be maintained
    And tanking should be discouraged

  @consolation-bracket
  Scenario: View consolation bracket separately
    Given both playoff and consolation brackets exist
    When I view league postseason
    Then I should see distinct bracket views
    And I should be able to toggle between them
    And my bracket should be highlighted

  @consolation-bracket
  Scenario: Track consolation ladder
    Given consolation uses ladder format
    When consolation games are played
    Then teams should move up or down the ladder
    And final positions should determine draft order
    And all games should matter for positioning

  @consolation-bracket
  Scenario: Opt out of consolation bracket
    Given consolation participation is optional
    And I prefer not to participate
    When the commissioner allows opt-outs
    Then I should be able to opt out
    And the bracket should adjust accordingly
    And default draft position should be assigned

  @consolation-bracket
  Scenario: Award consolation prizes
    Given the league has consolation prizes
    When the consolation bracket concludes
    Then prizes should be distributed
    And winners should be recognized
    And the incentive structure should be honored

  @consolation-bracket
  Scenario: Display loser's bracket final
    Given the consolation bracket reaches the final
    When the loser's bracket final is played
    Then it should be displayed prominently
    And last place should be determined
    And any last place penalties should be noted

  # ============================================================================
  # HEAD TO HEAD SETTINGS
  # ============================================================================

  @head-to-head-settings
  Scenario: Configure regular season length
    Given I am the commissioner
    When I access head-to-head settings
    Then I should be able to set number of regular season weeks
    And I should see how it affects schedule
    And I should be warned about balance issues

  @head-to-head-settings
  Scenario: Set playoff week configuration
    Given playoff settings need to be configured
    When I access playoff settings
    Then I should set playoff start week
    And I should set number of playoff weeks
    And I should configure championship week

  @head-to-head-settings
  Scenario: Enable or disable ties
    Given the commissioner wants to configure tie handling
    When tie settings are accessed
    Then ties can be allowed or disallowed
    And if disallowed, tiebreaker game rules should be set
    And the impact on standings should be explained

  @head-to-head-settings
  Scenario: Configure matchup periods
    Given special matchup periods exist
    When the commissioner sets matchup timing
    Then single-week or multi-week matchups can be set
    And playoff matchup length can differ
    And championship matchup weeks can be configured

  @head-to-head-settings
  Scenario: Set home and away designations
    Given the league wants home/away tracking
    When this setting is enabled
    Then matchups should show home and away
    And schedule should balance home and away games
    And standings should track home and away records

  @head-to-head-settings
  Scenario: Configure playoff bracket structure
    Given playoff format needs customization
    When the commissioner accesses bracket settings
    Then single or double elimination can be selected
    And reseeding options can be configured
    And wild card format can be set

  @head-to-head-settings
  Scenario: Enable median scoring
    Given the league wants median scoring added
    When median scoring is enabled
    Then teams also play against the median
    And two games are recorded each week
    And standings reflect both matchup types

  @head-to-head-settings
  Scenario: Configure all-play weeks
    Given the league wants all-play format for some weeks
    When all-play is configured
    Then teams play all other teams those weeks
    And wins are awarded for each victory
    And standings account for all-play results

  @head-to-head-settings
  Scenario: Set trade deadline relative to playoffs
    Given trade deadline should align with playoffs
    When the commissioner sets trade deadline
    Then deadline should be before playoffs begin
    And the number of weeks before playoffs should be configurable
    And the deadline should be clearly communicated

  @head-to-head-settings
  Scenario: View head-to-head settings summary
    Given all settings have been configured
    When I view league settings summary
    Then I should see complete head-to-head configuration
    And I should see regular season details
    And I should see playoff configuration
    And I should see any special rules

  # ============================================================================
  # ERROR HANDLING
  # ============================================================================

  @error-handling
  Scenario: Handle missing opponent in matchup
    Given a team has no assigned opponent
    When the matchup is loaded
    Then a bye week should be assigned
    Or an error message should be displayed
    And the commissioner should be notified

  @error-handling
  Scenario: Handle schedule generation failure
    Given schedule generation encounters an issue
    When the error occurs
    Then a clear error message should be displayed
    And the commissioner should be given resolution options
    And partial schedules should not be saved

  @error-handling
  Scenario: Handle scoring calculation errors
    Given a scoring error occurs during matchup
    When the error is detected
    Then the system should attempt recalculation
    And affected users should be notified
    And manual override should be available

  @error-handling
  Scenario: Handle playoff seeding conflicts
    Given seeding calculation has conflicts
    When the conflict is identified
    Then the system should apply tiebreakers
    And if unresolved, commissioner input should be requested
    And the resolution should be documented

  @error-handling
  Scenario: Handle stat correction reversals
    Given a stat correction changes a matchup result
    When the correction is applied
    Then both teams should be notified
    And standings should be updated
    And historical record should note the change

  @error-handling
  Scenario: Handle mid-season team changes
    Given a team owner changes mid-season
    When the transition occurs
    Then the schedule should remain intact
    And historical matchups should be preserved
    And the new owner should see full history

  @error-handling
  Scenario: Handle playoff bracket corruption
    Given the playoff bracket data becomes corrupted
    When the corruption is detected
    Then the system should attempt recovery
    And backups should be checked
    And manual rebuild options should be available

  @error-handling
  Scenario: Handle duplicate matchup scheduling
    Given the same matchup appears twice in a week
    When the duplicate is detected
    Then the commissioner should be alerted
    And resolution options should be provided
    And schedule integrity should be maintained

  @error-handling
  Scenario: Handle division configuration errors
    Given division setup has errors
    When the errors are detected
    Then teams without divisions should be flagged
    And unbalanced divisions should be warned
    And the commissioner should be guided to fix

  # ============================================================================
  # ACCESSIBILITY
  # ============================================================================

  @accessibility
  Scenario: Navigate matchup page with screen reader
    Given I am using a screen reader
    When I access my matchup page
    Then all elements should have proper labels
    And score information should be announced clearly
    And navigation should be logical

  @accessibility
  Scenario: Use keyboard navigation for standings
    Given I am navigating via keyboard
    When I access the standings page
    Then all interactive elements should be focusable
    And tab order should be logical
    And standings data should be accessible

  @accessibility
  Scenario: View bracket with high contrast
    Given I use high contrast mode
    When I view the playoff bracket
    Then bracket lines should be visible
    And team names should be readable
    And matchup status should be distinguishable

  @accessibility
  Scenario: Receive accessible matchup notifications
    Given I have accessibility preferences set
    When I receive matchup notifications
    Then notifications should be screen reader compatible
    And important information should be clearly conveyed
    And notification preferences should be respected

  @accessibility
  Scenario: Access schedule on mobile devices
    Given I am viewing on a mobile device
    When I access my schedule
    Then the schedule should be responsive
    And touch targets should be appropriately sized
    And scrolling should work correctly

  @accessibility
  Scenario: View live scoring with reduced motion
    Given I have reduced motion preferences
    When viewing live matchup scoring
    Then score updates should not use animations
    And information should still update clearly
    And the experience should remain informative

  @accessibility
  Scenario: Navigate bracket on touch devices
    Given I am using a touch device
    When I navigate the playoff bracket
    Then touch gestures should work correctly
    And zoom should be supported
    And bracket should remain usable when zoomed

  @accessibility
  Scenario: Access tiebreaker information
    Given I need to understand tiebreaker details
    When I access tiebreaker explanations
    Then explanations should be in plain language
    And technical terms should be defined
    And the information should be complete

  @accessibility
  Scenario: Use voice commands for matchup viewing
    Given I use voice control
    When I request matchup information
    Then voice commands should be recognized
    And matchup data should be spoken clearly
    And navigation should work via voice

  # ============================================================================
  # PERFORMANCE
  # ============================================================================

  @performance
  Scenario: Load matchup page quickly
    Given I am accessing my matchup
    When the page loads
    Then initial content should appear within 2 seconds
    And live data should stream in smoothly
    And the experience should feel responsive

  @performance
  Scenario: Handle high-traffic game days
    Given it is a peak NFL game time
    And many users are viewing matchups
    When I access live scoring
    Then the system should remain responsive
    And updates should continue flowing
    And no data loss should occur

  @performance
  Scenario: Generate schedule for large league
    Given a league has many teams
    When the schedule is generated
    Then generation should complete in reasonable time
    And all matchups should be correctly created
    And the system should not time out

  @performance
  Scenario: Calculate complex tiebreakers efficiently
    Given multiple teams are tied
    And tiebreakers require extensive calculation
    When tiebreakers are resolved
    Then results should be returned quickly
    And calculations should be accurate
    And the process should be transparent

  @performance
  Scenario: Load playoff bracket with full history
    Given the bracket has extensive history
    When the playoff bracket page loads
    Then the current bracket should load first
    And history should load progressively
    And navigation should remain smooth

  @performance
  Scenario: Update standings in real-time
    Given multiple games are affecting standings
    When scores change across the league
    Then standings should update quickly
    And seeding changes should be reflected
    And the display should remain stable

  @performance
  Scenario: Handle season-long data retrieval
    Given I request full season statistics
    When the data is retrieved
    Then results should be returned efficiently
    And pagination should be available if needed
    And performance should scale with data size

  @performance
  Scenario: Support multiple concurrent matchup views
    Given many users view matchups simultaneously
    When peak usage occurs
    Then all users should receive updates
    And no user should be degraded
    And system should scale appropriately

  @performance
  Scenario: Cache frequently accessed standings
    Given standings are viewed frequently
    When standings are requested
    Then cached data should be served when valid
    And cache should be invalidated on changes
    And users should always see accurate data
