@playoff-bracket @postseason
Feature: Playoff Bracket
  As a fantasy football manager
  I want to view and track the playoff bracket
  So that I can follow the postseason tournament and compete for the championship

  Background:
    Given I am logged in as a league member
    And the league "Playoff Champions" exists
    And the regular season has ended

  # ============================================================================
  # SINGLE ELIMINATION
  # ============================================================================

  @happy-path @single-elimination
  Scenario: View single elimination bracket
    Given the league uses single elimination format
    When I view the playoff bracket
    Then I should see all playoff matchups
    And each matchup should show the teams
    And eliminated teams should be marked

  @happy-path @single-elimination
  Scenario: Single elimination advancement
    Given a playoff matchup is complete
    When the winner is determined
    Then the winner should advance to the next round
    And the loser should be eliminated
    And the bracket should update automatically

  @happy-path @single-elimination
  Scenario: View elimination path to championship
    When I view my path to championship
    Then I should see all potential matchups
    And I should see win requirements
    And I should see projected opponents

  @happy-path @single-elimination
  Scenario: View remaining teams
    When I view remaining teams
    Then I should see all non-eliminated teams
    And I should see their seeds
    And I should see their next matchup

  # ============================================================================
  # DOUBLE ELIMINATION
  # ============================================================================

  @happy-path @double-elimination
  Scenario: View double elimination bracket
    Given the league uses double elimination format
    When I view the playoff bracket
    Then I should see winners bracket
    And I should see losers bracket
    And I should see how they connect

  @happy-path @double-elimination
  Scenario: Move to losers bracket after first loss
    Given I am in the winners bracket
    When I lose my matchup
    Then I should move to the losers bracket
    And I should still be alive in playoffs
    And my losers bracket matchup should appear

  @happy-path @double-elimination
  Scenario: Elimination after second loss
    Given I am in the losers bracket
    When I lose my matchup
    Then I should be eliminated
    And my playoff run should end
    And I should see my final placement

  @happy-path @double-elimination
  Scenario: Championship from losers bracket
    Given the losers bracket winner faces winners bracket winner
    When the losers bracket team wins
    Then a second championship game should be required
    And the true champion should be determined

  # ============================================================================
  # BRACKET SEEDING
  # ============================================================================

  @happy-path @seeding
  Scenario: Seed bracket based on standings
    Given final standings are determined
    When the bracket is seeded
    Then the #1 seed should face the lowest seed
    And the #2 seed should face the second-lowest
    And seeds should be displayed prominently

  @happy-path @seeding
  Scenario: View seeding breakdown
    When I view seeding information
    Then I should see:
      | Seed | Team   | Record | Reason           |
      | 1    | TeamA  | 11-3   | Best Record      |
      | 2    | TeamB  | 10-4   | Division Winner  |
      | 3    | TeamC  | 10-4   | Wild Card        |
      | 4    | TeamD  | 9-5    | Wild Card        |

  @happy-path @seeding
  Scenario: Tiebreaker for seeding
    Given two teams have the same record
    When seeding is determined
    Then tiebreakers should be applied
    And the higher seed should go to the tiebreaker winner
    And the tiebreaker reason should be shown

  @happy-path @seeding
  Scenario: Protected seeding for division winners
    Given division winners are guaranteed playoff spots
    When seeding is applied
    Then division winners should have top seeds
    And wild cards should have lower seeds

  # ============================================================================
  # BYE WEEKS
  # ============================================================================

  @happy-path @bye
  Scenario: Top seeds receive bye
    Given the top 2 seeds receive byes
    When I view the bracket
    Then seeds 1 and 2 should have "BYE" in round 1
    And they should appear in round 2
    And their potential opponents should be shown

  @happy-path @bye
  Scenario: View bye week advantage
    Given I have a first-round bye
    When I view my bracket position
    Then I should see "BYE - Awaiting Round 2"
    And I should see who I might face
    And I should see the rest week benefit

  @happy-path @bye
  Scenario: No byes with 4-team playoff
    Given the playoff has 4 teams
    When I view the bracket
    Then there should be no bye weeks
    And all teams should play in round 1

  # ============================================================================
  # MATCHUP VISUALIZATION
  # ============================================================================

  @happy-path @visualization
  Scenario: View bracket visualization
    When I view the bracket
    Then I should see a graphical bracket display
    And matchup lines should connect properly
    And the championship should be at the center/end

  @happy-path @visualization
  Scenario: View matchup details from bracket
    When I click on a matchup in the bracket
    Then I should see matchup details
    And I should see team rosters
    And I should see projected winner

  @happy-path @visualization
  Scenario: Navigate bracket with zoom/pan
    When I interact with the bracket
    Then I should be able to zoom in/out
    And I should be able to pan around
    And I should see focused matchup details

  @happy-path @visualization
  Scenario: Color-coded bracket status
    When I view the bracket
    Then completed matchups should be one color
    And in-progress matchups should be highlighted
    And future matchups should be another color

  @happy-path @visualization
  Scenario: View bracket with team logos
    When team logos are configured
    Then the bracket should display team logos
    And logos should be appropriately sized
    And fallback to team names if no logo

  # ============================================================================
  # REAL-TIME UPDATES
  # ============================================================================

  @happy-path @real-time
  Scenario: Live score updates in bracket
    Given playoff games are in progress
    When I view the bracket
    Then I should see live scores
    And scores should update in real-time
    And winning team should be highlighted

  @happy-path @real-time
  Scenario: Bracket updates when matchup completes
    Given a playoff matchup is in progress
    When the matchup is finalized
    Then the bracket should update automatically
    And the winner should advance visually
    And notifications should be sent

  @happy-path @real-time
  Scenario: View live win probability in bracket
    Given a matchup is in progress
    When I view the bracket
    Then I should see current win probability
    And it should update as games progress

  # ============================================================================
  # WINNER ADVANCEMENT
  # ============================================================================

  @happy-path @advancement
  Scenario: Automatic winner advancement
    When a playoff matchup is completed
    Then the system should determine the winner
    And the winner should advance to next round
    And the bracket should update immediately

  @happy-path @advancement
  Scenario: View advancement path
    When I view my advancement status
    Then I should see rounds I've won
    And I should see rounds remaining
    And I should see potential paths to victory

  @happy-path @advancement
  Scenario: Advancement notification
    When I win a playoff matchup
    Then I should receive an advancement notification
    And it should show my next opponent
    And it should celebrate my victory

  # ============================================================================
  # BRACKET RESET
  # ============================================================================

  @commissioner @reset
  Scenario: Reset bracket
    Given I am the commissioner
    When I reset the playoff bracket
    Then all matchup results should be cleared
    And the bracket should return to initial state
    And members should be notified

  @commissioner @reset
  Scenario: Reseed bracket after reset
    Given I am the commissioner
    And I have reset the bracket
    When I reseed based on current standings
    Then new seeding should be applied
    And the bracket should regenerate

  @commissioner @reset
  Scenario: Partial bracket reset
    Given I am the commissioner
    When I reset a specific round
    Then only that round's results should be cleared
    And prior rounds should remain
    And subsequent rounds should be reset

  # ============================================================================
  # CUSTOM FORMATS
  # ============================================================================

  @happy-path @formats
  Scenario: 4-team playoff bracket
    Given the league has a 4-team playoff
    When I view the bracket
    Then I should see 2 semifinals matchups
    And I should see 1 championship matchup
    And the bracket should be compact

  @happy-path @formats
  Scenario: 6-team playoff bracket
    Given the league has a 6-team playoff
    When I view the bracket
    Then top 2 seeds should have byes
    And 4 teams should play wild card round
    And bracket should show 3 rounds

  @happy-path @formats
  Scenario: 8-team playoff bracket
    Given the league has an 8-team playoff
    When I view the bracket
    Then all 8 teams should play round 1
    And bracket should show 3 rounds
    And seeding should match 1v8, 2v7, etc.

  @happy-path @formats
  Scenario: 10-team playoff bracket
    Given the league has a 10-team playoff
    When I view the bracket
    Then top 6 seeds should have byes
    And 4 teams should play wild card
    And bracket should accommodate format

  @happy-path @formats
  Scenario: 12-team playoff bracket
    Given the league has a 12-team playoff
    When I view the bracket
    Then top 4 seeds should have byes
    And 8 teams should play wild card
    And bracket should show 4 rounds

  # ============================================================================
  # CONSOLATION BRACKET
  # ============================================================================

  @happy-path @consolation
  Scenario: View consolation bracket (toilet bowl)
    Given the league has a consolation bracket
    When I view the brackets
    Then I should see the championship bracket
    And I should see the consolation bracket
    And eliminated teams should populate consolation

  @happy-path @consolation
  Scenario: Compete in consolation bracket
    Given I was eliminated from the main bracket
    When I enter the consolation bracket
    Then I should have a new matchup
    And I should compete for consolation prizes
    And my matchups should be tracked

  @happy-path @consolation
  Scenario: Consolation winner recognition
    When the consolation bracket completes
    Then the winner should be recognized
    And they should receive any consolation prizes
    And results should be recorded

  @happy-path @consolation
  Scenario: Last place punishment bracket
    Given the league has a "toilet bowl"
    When non-playoff teams compete
    Then the loser should be determined
    And they should receive the "punishment"
    And the loser should be displayed

  # ============================================================================
  # THIRD PLACE GAME
  # ============================================================================

  @happy-path @third-place
  Scenario: Third place game enabled
    Given the league has a third place game
    When semifinal losers are determined
    Then a third place matchup should be created
    And it should occur during championship week

  @happy-path @third-place
  Scenario: View third place matchup
    When I view the third place game
    Then I should see both competing teams
    And I should see it's for third place
    And I should see any prizes

  @happy-path @third-place
  Scenario: Third place game completion
    When the third place game completes
    Then the winner should be third place
    And the loser should be fourth place
    And final standings should update

  # ============================================================================
  # PREDICTION CONTESTS
  # ============================================================================

  @happy-path @predictions
  Scenario: Fill out bracket predictions
    Given playoff predictions are open
    When I fill out my bracket predictions
    Then I should pick winners for each matchup
    And I should predict the champion
    And my picks should be saved

  @happy-path @predictions
  Scenario: View prediction standings
    When I view prediction standings
    Then I should see who has the best picks
    And I should see correct picks count
    And I should see potential points remaining

  @happy-path @predictions
  Scenario: Lock predictions before playoffs
    Given the prediction deadline is reached
    When playoffs begin
    Then predictions should be locked
    And no changes should be allowed
    And picks should become visible

  @happy-path @predictions
  Scenario: Prediction scoring
    When playoff matchups are decided
    Then prediction scores should update
    And correct picks should earn points
    And championship pick should be worth more

  @happy-path @predictions
  Scenario: View my predictions vs reality
    When I view my bracket predictions
    Then I should see my picks highlighted
    And I should see which were correct
    And I should see which were wrong

  # ============================================================================
  # HISTORICAL ARCHIVES
  # ============================================================================

  @happy-path @archives
  Scenario: View historical playoff brackets
    When I view playoff history
    Then I should see past season brackets
    And I should see past champions
    And I should see bracket results

  @happy-path @archives
  Scenario: View specific past bracket
    When I view the 2023 playoff bracket
    Then I should see the complete bracket
    And I should see all matchup results
    And I should see the champion

  @happy-path @archives
  Scenario: Compare brackets across years
    When I compare playoff brackets
    Then I should see patterns over time
    And I should see repeat champions
    And I should see upset history

  # ============================================================================
  # PRINTABLE VIEWS
  # ============================================================================

  @happy-path @print
  Scenario: Print playoff bracket
    When I print the playoff bracket
    Then I should get a printable format
    And it should fit on one page
    And it should include all matchups

  @happy-path @print
  Scenario: Export bracket as PDF
    When I export bracket to PDF
    Then I should download a PDF file
    And it should be high quality
    And it should include league branding

  @happy-path @print
  Scenario: Print blank bracket for predictions
    When I print a blank bracket
    Then matchups should be shown
    And winner lines should be blank
    And I should be able to fill in by hand

  # ============================================================================
  # MOBILE DISPLAY
  # ============================================================================

  @mobile @responsive
  Scenario: View bracket on mobile
    Given I am using a mobile device
    When I view the bracket
    Then I should see a mobile-optimized layout
    And I should be able to scroll/swipe
    And matchups should be readable

  @mobile @responsive
  Scenario: Navigate bracket on mobile
    Given I am on mobile
    When I tap on a matchup
    Then I should see matchup details
    And I should navigate easily
    And I should return to bracket view

  @mobile @responsive
  Scenario: Horizontal bracket scroll on mobile
    Given I am on mobile
    When the bracket is wide
    Then I should scroll horizontally
    And current round should be centered
    And navigation should be intuitive

  @mobile @responsive
  Scenario: Mobile bracket notifications
    Given I am on mobile
    When a bracket update occurs
    Then I should receive a push notification
    And tapping should open the bracket
    And the update should be highlighted

  # ============================================================================
  # SOCIAL SHARING
  # ============================================================================

  @happy-path @sharing
  Scenario: Share bracket image
    When I share the playoff bracket
    Then I should get a shareable image
    And it should show current bracket state
    And I should share to social media

  @happy-path @sharing
  Scenario: Share championship victory
    Given I won the championship
    When I share my victory
    Then I should get a celebration graphic
    And it should show bracket path
    And I should share to social platforms

  @happy-path @sharing
  Scenario: Share bracket predictions
    When I share my bracket predictions
    Then I should get my picks as an image
    And my predicted champion should be highlighted
    And I should be able to share

  @happy-path @sharing
  Scenario: Share elimination announcement
    Given I eliminated my opponent
    When I share the result
    Then I should get a victory graphic
    And it should show the matchup result
    And I should be able to trash talk

  # ============================================================================
  # COMMISSIONER OVERRIDES
  # ============================================================================

  @commissioner @overrides
  Scenario: Override matchup result
    Given I am the commissioner
    When I override a matchup result
    Then the winner should change
    And bracket should update
    And an audit log should be created

  @commissioner @overrides
  Scenario: Manually advance team
    Given I am the commissioner
    When I manually advance a team
    Then they should move to next round
    And the bypass should be logged
    And members should be notified

  @commissioner @overrides
  Scenario: Remove team from playoffs
    Given I am the commissioner
    When I remove a team from playoffs
    Then they should be replaced
    And the bracket should adjust
    And the reason should be recorded

  @commissioner @overrides
  Scenario: Modify seeding
    Given I am the commissioner
    When I modify playoff seeding
    Then seeds should update
    And matchups should adjust
    And changes should be visible

  # ============================================================================
  # TIEBREAKERS
  # ============================================================================

  @happy-path @tiebreakers
  Scenario: Apply tiebreaker in playoff matchup
    Given a playoff matchup ends in a tie
    When the tiebreaker is applied
    Then the winner should be determined
    And the tiebreaker used should be shown
    And the matchup should complete

  @happy-path @tiebreakers
  Scenario: View tiebreaker rules
    When I view playoff tiebreaker rules
    Then I should see the tiebreaker order:
      | Priority | Tiebreaker           |
      | 1        | Higher Seed          |
      | 2        | Regular Season H2H   |
      | 3        | Total Points For     |
      | 4        | Bench Points         |

  @commissioner @tiebreakers
  Scenario: Configure tiebreaker rules
    Given I am the commissioner
    When I configure playoff tiebreakers
    Then I should set the priority order
    And the rules should apply to all matchups

  # ============================================================================
  # WILDCARDS
  # ============================================================================

  @happy-path @wildcards
  Scenario: View wildcard spots
    When I view playoff seeding
    Then I should see division winners
    And I should see wildcard teams
    And wildcards should be distinguished

  @happy-path @wildcards
  Scenario: Wildcard race tracking
    Given the regular season is ending
    When I view wildcard race
    Then I should see teams competing for spots
    And I should see scenarios for each
    And I should see clinch/elimination

  @happy-path @wildcards
  Scenario: Wildcard seeding order
    Given multiple wildcard teams
    When they are seeded
    Then they should be ordered by record
    And tiebreakers should apply
    And they should have lower seeds than division winners

  # ============================================================================
  # DIVISION SEEDING
  # ============================================================================

  @happy-path @division-seeding
  Scenario: Division winners get top seeds
    Given the league has divisions
    When playoff seeding is determined
    Then division winners should be top seeds
    And they should be seeded by record
    And division logos should appear

  @happy-path @division-seeding
  Scenario: Division matchup protection
    Given the league protects division matchups
    When the bracket is created
    Then division opponents should be separated
    And they should only meet in later rounds

  @happy-path @division-seeding
  Scenario: View division representation
    When I view the bracket
    Then I should see division indicators
    And I should see division balance
    And division rivalries should be highlighted

  # ============================================================================
  # RESEEDING OPTIONS
  # ============================================================================

  @happy-path @reseeding
  Scenario: Reseed after each round
    Given the league uses reseeding
    When a round completes
    Then remaining teams should reseed
    And highest seed should face lowest
    And the bracket should update

  @happy-path @reseeding
  Scenario: View reseeding changes
    When reseeding occurs
    Then I should see new matchups
    And I should see why seeding changed
    And new opponents should be clear

  @commissioner @reseeding
  Scenario: Enable/disable reseeding
    Given I am the commissioner
    When I configure reseeding option
    Then I should toggle on or off
    And the setting should apply to playoffs

  # ============================================================================
  # COUNTDOWN TIMERS
  # ============================================================================

  @happy-path @countdown
  Scenario: View countdown to playoffs
    Given playoffs start next week
    When I view the bracket page
    Then I should see a countdown timer
    And it should show days/hours/minutes
    And it should build anticipation

  @happy-path @countdown
  Scenario: View countdown to next round
    Given the current round is in progress
    When I view the bracket
    Then I should see countdown to next round
    And I should see when matchups start

  @happy-path @countdown
  Scenario: Championship countdown
    Given the championship is upcoming
    When I view the bracket
    Then I should see championship countdown
    And it should be prominently displayed
    And excitement should build

  # ============================================================================
  # ELIMINATION NOTIFICATIONS
  # ============================================================================

  @happy-path @elimination
  Scenario: Receive elimination notification
    Given I am in the playoffs
    When I am eliminated
    Then I should receive a notification
    And it should acknowledge my run
    And it should show my final placement

  @happy-path @elimination
  Scenario: View eliminated teams
    When I view eliminated teams
    Then I should see all eliminated teams
    And I should see when they were eliminated
    And I should see who eliminated them

  @happy-path @elimination
  Scenario: Elimination with consolation option
    Given I am eliminated and consolation exists
    When I receive elimination notification
    Then it should mention consolation bracket
    And I should have option to compete
    And my consolation matchup should appear

  # ============================================================================
  # CHAMPION CELEBRATION
  # ============================================================================

  @happy-path @celebration
  Scenario: Championship celebration display
    When the champion is determined
    Then a celebration should display
    And the champion's name should be prominent
    And confetti/animation should appear

  @happy-path @celebration
  Scenario: View champion trophy
    When I view the champion's profile
    Then I should see the championship trophy
    And it should show the year
    And it should be added to their collection

  @happy-path @celebration
  Scenario: Champion announcement
    When the championship is decided
    Then a league-wide announcement should be sent
    And all members should be notified
    And the bracket should show the champion

  @happy-path @celebration
  Scenario: Champion history recognition
    Given the league has multiple seasons
    When I view champion history
    Then I should see all past champions
    And I should see repeat champions highlighted
    And I should see dynasty recognition

  @happy-path @celebration
  Scenario: Share championship victory
    Given I am the champion
    When I share my victory
    Then I should get a champion graphic
    And it should show my bracket run
    And I should share across platforms

  # ============================================================================
  # ACCESSIBILITY
  # ============================================================================

  @accessibility @a11y
  Scenario: Screen reader support for bracket
    Given I am using a screen reader
    When I navigate the bracket
    Then matchups should be announced
    And seeds and scores should be clear
    And navigation should be logical

  @accessibility @a11y
  Scenario: Keyboard navigation for bracket
    Given I am using keyboard only
    When I navigate the bracket
    Then I should tab through matchups
    And I should access all details
    And focus should be visible

  # ============================================================================
  # ERROR HANDLING
  # ============================================================================

  @error @resilience
  Scenario: Handle bracket update failure
    Given a bracket update fails
    When I view the bracket
    Then I should see last known state
    And I should see error indicator
    And I should know when it will update

  @error @resilience
  Scenario: Handle incomplete matchup data
    Given some matchup data is missing
    When I view the bracket
    Then available data should display
    And missing data should be indicated
    And the bracket should remain usable
