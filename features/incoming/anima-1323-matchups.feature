@matchups @ANIMA-1323
Feature: Matchups
  As a fantasy football team manager
  I want to view and track my weekly matchups
  So that I can monitor my team's performance against opponents

  Background:
    Given the fantasy football playoffs application is running
    And I am logged in as a team manager
    And I have an active team in a league
    And the current week has matchups scheduled

  # ============================================================================
  # MATCHUP DISPLAY - HAPPY PATH
  # ============================================================================

  @happy-path @matchup-display
  Scenario: View current week matchup
    Given I am on the matchups page
    When I view my current matchup
    Then I should see my team and opponent team
    And I should see both team scores
    And I should see the matchup status

  @happy-path @matchup-display
  Scenario: View matchup with starting lineups
    Given I am viewing a matchup
    When I expand the matchup details
    Then I should see both starting lineups
    And I should see each player's points
    And I should see position groupings

  @happy-path @matchup-display
  Scenario: View all league matchups for week
    Given I am on the matchups page
    When I view all league matchups
    Then I should see every matchup for the week
    And I should see scores for each matchup
    And I should be able to click into any matchup

  @happy-path @matchup-display
  Scenario: View matchup for different week
    Given I am on the matchups page
    When I select a different week
    Then I should see matchups for that week
    And past weeks should show final scores
    And future weeks should show projections

  @happy-path @matchup-display
  Scenario: View matchup in compact mode
    Given I am viewing matchups
    When I select compact view
    Then matchups should show minimal information
    And I should see team names and scores
    And I should be able to expand for details

  @happy-path @matchup-display
  Scenario: View matchup in detailed mode
    Given I am viewing matchups
    When I select detailed view
    Then I should see full lineup comparisons
    And I should see player-by-player breakdown
    And I should see all scoring details

  # ============================================================================
  # SCORE COMPARISONS
  # ============================================================================

  @happy-path @score-comparison
  Scenario: Compare position-by-position scores
    Given I am viewing a matchup
    When I view position comparison
    Then I should see scores by position group
    And I should see which team wins each position
    And I should see the point differential

  @happy-path @score-comparison
  Scenario: View head-to-head player comparison
    Given I am viewing a matchup
    When I compare players at the same position
    Then I should see side-by-side stats
    And I should see the point difference
    And I should see who won the position battle

  @happy-path @score-comparison
  Scenario: View scoring margin over time
    Given I am viewing a matchup in progress
    When I view the scoring timeline
    Then I should see how the margin changed
    And I should see key scoring plays
    And I should see momentum shifts

  @happy-path @score-comparison
  Scenario: Compare bench scores
    Given I am viewing a matchup
    When I view bench comparison
    Then I should see both teams' bench points
    And I should see potential lineup improvements
    And I should see bench vs starter analysis

  # ============================================================================
  # LIVE SCORING UPDATES
  # ============================================================================

  @happy-path @live-scoring
  Scenario: View live score updates
    Given games are currently in progress
    When I view my matchup
    Then scores should update in real-time
    And I should see live player stats
    And the matchup status should reflect current state

  @happy-path @live-scoring
  Scenario: Receive score change notifications
    Given I am watching a live matchup
    When a significant score change occurs
    Then I should receive a notification
    And the score should update immediately
    And I should see which player scored

  @happy-path @live-scoring
  Scenario: View live scoring play-by-play
    Given games are in progress
    When I view scoring updates
    Then I should see recent scoring plays
    And I should see which players are involved
    And I should see point values for each play

  @happy-path @live-scoring
  Scenario: View player currently playing
    Given a game is in progress
    When I view players in that game
    Then I should see a live indicator
    And I should see their current stats
    And I should see updated projections

  @happy-path @live-scoring
  Scenario: Track score differential live
    Given I am viewing a live matchup
    When scores change during games
    Then the lead indicator should update
    And I should see if I'm winning or losing
    And I should see the current margin

  @happy-path @live-scoring
  Scenario: View time remaining in games
    Given games are in progress
    When I view player status
    Then I should see game time remaining
    And I should see which quarter or half
    And I should see expected scoring potential

  # ============================================================================
  # PLAYER PERFORMANCE TRACKING
  # ============================================================================

  @happy-path @player-performance
  Scenario: View individual player performance
    Given I am viewing a matchup
    When I click on a player
    Then I should see their detailed stats
    And I should see their point breakdown
    And I should see their game log

  @happy-path @player-performance
  Scenario: View player stat categories
    Given I am viewing player performance
    When I expand stat details
    Then I should see all stat categories
    And I should see points per category
    And I should see targets/carries/etc.

  @happy-path @player-performance
  Scenario: Compare player to projection
    Given I am viewing player performance
    When I view projection comparison
    Then I should see actual vs projected points
    And I should see variance from expectation
    And I should see updated ROS projection

  @happy-path @player-performance
  Scenario: View player snap counts
    Given I am viewing a player in a completed game
    When I view their usage stats
    Then I should see snap count percentage
    And I should see route participation
    And I should see target share

  @happy-path @player-performance
  Scenario: Track fantasy relevant plays
    Given I am viewing player performance
    When I view play breakdown
    Then I should see each scoring play
    And I should see yardage on plays
    And I should see touchdown details

  # ============================================================================
  # MATCHUP PROJECTIONS
  # ============================================================================

  @happy-path @projections
  Scenario: View matchup projection before games
    Given games have not started
    When I view my matchup projection
    Then I should see projected final scores
    And I should see projected winner
    And I should see confidence level

  @happy-path @projections
  Scenario: View updated projections during games
    Given some games are in progress
    When I view projections
    Then projections should reflect current scores
    And remaining players should have updated projections
    And win probability should be current

  @happy-path @projections
  Scenario: View player-level projections
    Given I am viewing matchup details
    When I look at individual projections
    Then each player should have a projection
    And projections should be based on matchup
    And confidence ranges should be shown

  @happy-path @projections
  Scenario: Compare projections to actual
    Given a matchup is complete
    When I view the projection analysis
    Then I should see projected vs actual
    And I should see biggest over/under performers
    And I should see projection accuracy

  @happy-path @projections
  Scenario: View projection sources
    Given I am viewing projections
    When I check projection sources
    Then I should see which sources are used
    And I should see consensus projections
    And I should see expert breakdowns

  # ============================================================================
  # WIN PROBABILITY
  # ============================================================================

  @happy-path @win-probability
  Scenario: View pre-game win probability
    Given the matchup has not started
    When I view win probability
    Then I should see percentage chance to win
    And I should see the probability factors
    And I should see historical comparison

  @happy-path @win-probability
  Scenario: View live win probability
    Given games are in progress
    When I view win probability
    Then probability should update in real-time
    And I should see how it changed over time
    And I should see critical factors

  @happy-path @win-probability
  Scenario: View win probability chart
    Given I am viewing a live matchup
    When I view the probability chart
    Then I should see probability over time
    And key moments should be highlighted
    And current probability should be prominent

  @happy-path @win-probability
  Scenario: View scenarios for remaining games
    Given some games are complete
    When I view outcome scenarios
    Then I should see paths to victory
    And I should see what I need from remaining players
    And I should see break-even points

  @happy-path @win-probability
  Scenario: View comeback probability
    Given I am losing the matchup
    When I view comeback chances
    Then I should see probability of comeback
    And I should see what would need to happen
    And I should see similar historical comebacks

  # ============================================================================
  # MATCHUP HISTORY
  # ============================================================================

  @happy-path @matchup-history
  Scenario: View head-to-head history with opponent
    Given I have played this opponent before
    When I view matchup history
    Then I should see all previous matchups
    And I should see the win-loss record
    And I should see historical scores

  @happy-path @matchup-history
  Scenario: View all-time record against opponent
    Given I am viewing matchup history
    When I check all-time record
    Then I should see total wins and losses
    And I should see point differential
    And I should see streak information

  @happy-path @matchup-history
  Scenario: View historical matchup details
    Given I am viewing matchup history
    When I click on a past matchup
    Then I should see the full matchup details
    And I should see who started that week
    And I should see the scoring breakdown

  @happy-path @matchup-history
  Scenario: View matchup trends over seasons
    Given I have multi-season history with opponent
    When I view historical trends
    Then I should see performance over time
    And I should see scoring trends
    And I should see matchup patterns

  # ============================================================================
  # RIVALRY TRACKING
  # ============================================================================

  @happy-path @rivalry
  Scenario: View rivalry matchup indicator
    Given I am facing a designated rival
    When I view the matchup
    Then I should see a rivalry badge
    And I should see rivalry history
    And the matchup should be highlighted

  @happy-path @rivalry
  Scenario: View rivalry standings
    Given rivalries are configured in the league
    When I view rivalry standings
    Then I should see all rivalry pairings
    And I should see current season record
    And I should see all-time rivalry records

  @happy-path @rivalry
  Scenario: Track rivalry bragging rights
    Given a rivalry matchup is complete
    When I view rivalry stats
    Then I should see who has bragging rights
    And I should see biggest rivalry wins
    And I should see rivalry records

  @happy-path @rivalry
  Scenario: View rivalry week schedule
    Given the league has designated rivalry week
    When I view that week's matchups
    Then rivalry matchups should be highlighted
    And special rivalry stats should show
    And rivalry history should be prominent

  # ============================================================================
  # POINTS BREAKDOWN
  # ============================================================================

  @happy-path @points-breakdown
  Scenario: View detailed points breakdown
    Given I am viewing a matchup
    When I view points breakdown
    Then I should see points by category
    And I should see player contributions
    And I should see scoring efficiency

  @happy-path @points-breakdown
  Scenario: View scoring by position group
    Given I am viewing points breakdown
    When I view by position
    Then I should see QB points
    And I should see RB, WR, TE points
    And I should see flex and defense points

  @happy-path @points-breakdown
  Scenario: View scoring by time slot
    Given games are at different times
    When I view scoring by slot
    Then I should see points from Thursday
    And I should see Sunday early/late points
    And I should see primetime points

  @happy-path @points-breakdown
  Scenario: View bonus points breakdown
    Given the league has bonus scoring
    When I view bonus points
    Then I should see all bonus points earned
    And I should see which players earned bonuses
    And I should see bonus thresholds met

  @happy-path @points-breakdown
  Scenario: Export points breakdown
    Given I am viewing a complete matchup
    When I export the breakdown
    Then I should receive a detailed report
    And the report should include all stats
    And the format should be selectable

  # ============================================================================
  # BENCH POINTS COMPARISON
  # ============================================================================

  @happy-path @bench-points
  Scenario: View bench points for both teams
    Given I am viewing a matchup
    When I view bench analysis
    Then I should see my bench points
    And I should see opponent's bench points
    And I should see bench comparison

  @happy-path @bench-points
  Scenario: View points left on bench
    Given the matchup is complete
    When I view bench analysis
    Then I should see total bench points
    And I should see who outscored starters
    And I should see optimal vs actual score

  @happy-path @bench-points
  Scenario: Identify bench players who should have started
    Given the matchup is complete
    When I view bench recommendations
    Then I should see bench players who outscored starters
    And I should see point differentials
    And I should see which swaps would have helped

  @happy-path @bench-points
  Scenario: View season-long bench efficiency
    Given I want to analyze lineup decisions
    When I view bench efficiency stats
    Then I should see points left on bench by week
    And I should see optimal lineup percentage
    And I should see trends over time

  # ============================================================================
  # OPTIMAL LINEUP ANALYSIS
  # ============================================================================

  @happy-path @optimal-lineup
  Scenario: View optimal lineup for matchup
    Given the matchup is complete
    When I view optimal lineup analysis
    Then I should see what optimal lineup would have been
    And I should see points with optimal lineup
    And I should see the difference from actual

  @happy-path @optimal-lineup
  Scenario: Compare actual to optimal lineup
    Given I am viewing optimal analysis
    When I view the comparison
    Then I should see which positions differed
    And I should see the point swing per position
    And I should see if I still would have won or lost

  @happy-path @optimal-lineup
  Scenario: View optimal lineup impact on matchup
    Given the matchup is complete
    When I check if optimal lineup changes outcome
    Then I should see if I won with actual
    And I should see if I would have won with optimal
    And I should see opponent's optimal scenario

  @happy-path @optimal-lineup
  Scenario: Track optimal lineup percentage over season
    Given I want to track my decisions
    When I view season optimal percentage
    Then I should see weekly optimal percentage
    And I should see season average
    And I should see league ranking

  @happy-path @optimal-lineup
  Scenario: View what-if lineup scenarios
    Given I am viewing a past matchup
    When I explore lineup scenarios
    Then I should be able to swap players
    And I should see the score change
    And I should see matchup outcome change

  # ============================================================================
  # MATCHUP PREVIEWS
  # ============================================================================

  @happy-path @matchup-preview
  Scenario: View upcoming matchup preview
    Given I am viewing next week's matchup
    When I access the preview
    Then I should see opponent analysis
    And I should see key players to watch
    And I should see projected outcome

  @happy-path @matchup-preview
  Scenario: View opponent team analysis
    Given I am previewing a matchup
    When I analyze the opponent
    Then I should see their roster strengths
    And I should see their weaknesses
    And I should see their recent performance

  @happy-path @matchup-preview
  Scenario: View key matchup factors
    Given I am previewing a matchup
    When I view key factors
    Then I should see players likely to decide the matchup
    And I should see favorable/unfavorable game scripts
    And I should see injury concerns

  @happy-path @matchup-preview
  Scenario: View player matchup advantages
    Given I am previewing a matchup
    When I view player matchups
    Then I should see individual player matchups
    And I should see cornerback matchups for WRs
    And I should see defensive rankings against positions

  @happy-path @matchup-preview
  Scenario: View expert matchup picks
    Given I am previewing a matchup
    When I view expert predictions
    Then I should see expert picks for the matchup
    And I should see the consensus prediction
    And I should see expert reasoning

  @happy-path @matchup-preview
  Scenario: Generate matchup preview report
    Given I am previewing a matchup
    When I generate preview report
    Then a comprehensive report should be created
    And it should include all analysis
    And it should be shareable

  # ============================================================================
  # POST-MATCHUP RECAPS
  # ============================================================================

  @happy-path @matchup-recap
  Scenario: View matchup recap after completion
    Given the matchup is complete
    When I view the recap
    Then I should see final score
    And I should see key performers
    And I should see deciding factors

  @happy-path @matchup-recap
  Scenario: View MVP of matchup
    Given the matchup is complete
    When I view matchup MVP
    Then I should see the highest scorer
    And I should see their impact on the result
    And I should see their stat line

  @happy-path @matchup-recap
  Scenario: View matchup turning points
    Given the matchup is complete
    When I view turning points
    Then I should see key plays that swung the matchup
    And I should see when momentum shifted
    And I should see critical scoring plays

  @happy-path @matchup-recap
  Scenario: View disappointments and surprises
    Given the matchup is complete
    When I view performance analysis
    Then I should see biggest disappointments
    And I should see biggest surprises
    And I should see variance from projections

  @happy-path @matchup-recap
  Scenario: Share matchup recap
    Given the matchup is complete
    When I share the recap
    Then a shareable graphic should be generated
    And it should show the final result
    And it should be formatted for social media

  @happy-path @matchup-recap
  Scenario: View what could have been
    Given I lost the matchup
    When I view what-if analysis
    Then I should see how close I was
    And I should see lineup changes that would have won
    And I should see critical mistakes

  # ============================================================================
  # PLAYOFF MATCHUPS
  # ============================================================================

  @happy-path @playoff-matchups
  Scenario: View playoff matchup bracket
    Given it is playoff time
    When I view playoff matchups
    Then I should see the playoff bracket
    And I should see current round matchups
    And I should see advancement paths

  @happy-path @playoff-matchups
  Scenario: View two-week playoff matchup
    Given the league has two-week playoff matchups
    When I view a playoff matchup
    Then I should see combined score
    And I should see week 1 and week 2 breakdown
    And I should see current standings in matchup

  @happy-path @playoff-matchups
  Scenario: View elimination matchup stakes
    Given I am in a playoff elimination matchup
    When I view the matchup
    Then I should see elimination stakes
    And I should see what's at stake for winner
    And I should see the matchup intensity

  @happy-path @playoff-matchups
  Scenario: View championship matchup
    Given I am in the championship
    When I view the championship matchup
    Then I should see championship branding
    And I should see the season on the line
    And I should see trophy and prize information

  # ============================================================================
  # ERROR HANDLING
  # ============================================================================

  @error
  Scenario: Matchup data fails to load
    Given I try to view a matchup
    When the data fails to load
    Then I should see an error message
    And I should be able to retry
    And cached data should be shown if available

  @error
  Scenario: Live scoring update fails
    Given I am watching a live matchup
    When the live update fails
    Then I should see a connection warning
    And last known scores should remain
    And I should see when data was last updated

  @error
  Scenario: Player stats unavailable
    Given I am viewing a matchup
    When player stats are unavailable
    Then I should see a placeholder message
    And I should see estimated points
    And I should be notified when stats arrive

  @error
  Scenario: Matchup projection unavailable
    Given I am viewing matchup projections
    When projections cannot be calculated
    Then I should see a fallback projection
    And I should see the data limitation
    And I should be able to refresh

  @error
  Scenario: Historical matchup data missing
    Given I try to view matchup history
    When historical data is missing
    Then I should see available history only
    And missing data should be indicated
    And I should see when history starts

  # ============================================================================
  # MOBILE EXPERIENCE
  # ============================================================================

  @mobile
  Scenario: View matchup on mobile device
    Given I am using the mobile app
    When I view a matchup
    Then the layout should be mobile-optimized
    And scores should be prominent
    And I should be able to scroll through details

  @mobile
  Scenario: Swipe between matchups on mobile
    Given I am viewing matchups on mobile
    When I swipe left or right
    Then I should navigate between matchups
    And transitions should be smooth
    And current matchup should be indicated

  @mobile
  Scenario: Receive mobile matchup notifications
    Given I have notifications enabled
    When a significant matchup event occurs
    Then I should receive a push notification
    And tapping should open the matchup
    And I should see the relevant update

  @mobile
  Scenario: View live scoring on mobile
    Given I am watching a live matchup on mobile
    When scores update
    Then updates should appear quickly
    And the interface should remain responsive
    And I should see scoring animations

  @mobile
  Scenario: View matchup in landscape mode
    Given I am on mobile
    When I rotate to landscape
    Then I should see side-by-side comparison
    And more detail should be visible
    And navigation should remain accessible

  # ============================================================================
  # ACCESSIBILITY
  # ============================================================================

  @accessibility
  Scenario: Navigate matchup with keyboard
    Given I am using keyboard navigation
    When I navigate the matchup page
    Then all elements should be accessible
    And focus should move logically
    And scores should be readable

  @accessibility
  Scenario: Screen reader matchup access
    Given I am using a screen reader
    When I view a matchup
    Then scores should be announced
    And player stats should be readable
    And matchup status should be clear

  @accessibility
  Scenario: High contrast matchup display
    Given I have high contrast mode enabled
    When I view matchups
    Then scores should be clearly visible
    And winning/losing teams should be distinguishable
    And all text should be readable

  @accessibility
  Scenario: Live scoring with screen reader
    Given I am using a screen reader
    When live updates occur
    Then updates should be announced
    And score changes should be spoken
    And I should not lose my place
