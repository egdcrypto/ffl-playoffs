@matchups @head-to-head
Feature: Matchups
  As a fantasy football manager
  I want to view and track my weekly matchups
  So that I can compete against other managers and track my performance

  Background:
    Given I am logged in as a league member
    And the league "Playoff Champions" exists
    And the current week is Week 5

  # ============================================================================
  # WEEKLY SCHEDULING
  # ============================================================================

  @happy-path @scheduling
  Scenario: View current week matchup
    When I view my current matchup
    Then I should see my opponent for this week
    And I should see both teams' rosters
    And I should see the matchup start time

  @happy-path @scheduling
  Scenario: View full season schedule
    When I view my season schedule
    Then I should see all 14 regular season matchups
    And I should see my opponent for each week
    And I should see past results and future opponents

  @happy-path @scheduling
  Scenario: View league-wide weekly matchups
    When I view all Week 5 matchups
    Then I should see all head-to-head matchups
    And I should see current scores for each matchup
    And I should be able to click into any matchup

  @happy-path @scheduling
  Scenario: View playoff matchups
    Given the playoffs have started
    When I view the playoff matchups
    Then I should see the current round matchups
    And I should see the bracket progression
    And I should see seeding information

  @commissioner @scheduling
  Scenario: Manually adjust weekly matchup
    Given I am the commissioner
    When I modify the Week 6 schedule
    And I swap Team A's opponent from Team B to Team C
    Then the schedule should update
    And affected teams should be notified

  @happy-path @scheduling
  Scenario: View bye week schedule
    When I view the league schedule for Week 9
    Then I should see which teams have bye weeks
    And bye teams should be clearly indicated
    And matchups should show "BYE" for those teams

  # ============================================================================
  # SCOREBOARD DISPLAY
  # ============================================================================

  @happy-path @scoreboard
  Scenario: View matchup scoreboard
    Given games are in progress
    When I view my matchup scoreboard
    Then I should see my current score
    And I should see my opponent's current score
    And I should see each player's contribution

  @happy-path @scoreboard
  Scenario: View detailed player scores
    Given my matchup is active
    When I view the detailed scoreboard
    Then I should see each player's stats:
      | Player          | Score | Passing | Rushing | Receiving |
      | Patrick Mahomes | 25.4  | 285 yds | 15 yds  | -         |
      | Derrick Henry   | 18.2  | -       | 122 yds | 2 rec     |

  @happy-path @scoreboard
  Scenario: View side-by-side roster comparison
    When I view the matchup comparison
    Then I should see my roster on the left
    And I should see my opponent's roster on the right
    And positions should align for easy comparison

  @happy-path @scoreboard
  Scenario: View bench player scores
    When I expand the scoreboard view
    Then I should see bench player scores
    And I should see who left points on the bench
    And bench scores should be visually distinguished

  @happy-path @scoreboard
  Scenario: View scoring breakdown by position
    When I view the position breakdown
    Then I should see total points per position:
      | Position | My Points | Opponent Points |
      | QB       | 25.4      | 22.1            |
      | RB       | 35.2      | 28.7            |
      | WR       | 28.9      | 31.4            |

  @happy-path @scoreboard
  Scenario: Mini scoreboard widget
    When I view the app header during game day
    Then I should see a mini scoreboard showing my matchup
    And I should see current scores
    And tapping should expand to full scoreboard

  # ============================================================================
  # LIVE TRACKING
  # ============================================================================

  @happy-path @live
  Scenario: Real-time score updates
    Given games are in progress
    When a player on my team scores
    Then my score should update within seconds
    And I should see a visual indicator of the score change

  @happy-path @live
  Scenario: Live play-by-play feed
    When I view the live feed
    Then I should see scoring plays as they happen
    And each play should show player, team, and points
    And the feed should update in real-time

  @happy-path @live
  Scenario: View active players indicator
    Given some players have games in progress
    When I view my matchup
    Then I should see which players are currently playing
    And I should see game quarter/time for each
    And finished games should show "Final"

  @happy-path @live
  Scenario: Live win probability
    Given the matchup is in progress
    When I view the win probability
    Then I should see my current win probability percentage
    And it should update as scores change
    And I should see a probability graph over time

  @happy-path @live
  Scenario: Track remaining players
    Given it's Sunday evening
    When I view remaining players
    Then I should see how many players each team has left
    And I should see potential points remaining
    And I should see which games are still to be played

  @happy-path @live
  Scenario: Red zone alerts
    Given my player is in the red zone
    When a red zone opportunity occurs
    Then I should see a red zone indicator
    And the player should be highlighted
    And I should receive an alert if enabled

  # ============================================================================
  # PROJECTIONS
  # ============================================================================

  @happy-path @projections
  Scenario: View pre-game matchup projection
    Given games have not started
    When I view my matchup projection
    Then I should see my projected score
    And I should see my opponent's projected score
    And I should see win probability

  @happy-path @projections
  Scenario: View player-level projections
    When I view player projections
    Then I should see each player's projected points
    And I should see projection confidence ranges
    And projections should update based on news

  @happy-path @projections
  Scenario: Compare projections to actual scores
    Given games are partially complete
    When I view the projection comparison
    Then I should see projected vs actual for completed games
    And I should see updated projections for remaining games
    And variance should be highlighted

  @happy-path @projections
  Scenario: View projection sources
    When I view projection details
    Then I should see which sources inform projections
    And I should see expert consensus rankings
    And I should see historical accuracy metrics

  @happy-path @projections
  Scenario: Adjust lineup based on projections
    Given I'm reviewing my lineup
    When I view projection scenarios
    Then I should see how different lineup choices affect projection
    And I should be able to optimize my lineup

  @happy-path @projections
  Scenario: Weekly projection trends
    When I view my projection history
    Then I should see how projections changed throughout the week
    And I should see factors that affected projections

  # ============================================================================
  # HEAD-TO-HEAD HISTORY
  # ============================================================================

  @happy-path @history
  Scenario: View all-time record vs opponent
    Given I have played Team B multiple times
    When I view my head-to-head history with Team B
    Then I should see my all-time record (e.g., "5-3")
    And I should see total points for and against
    And I should see each historical matchup

  @happy-path @history
  Scenario: View detailed historical matchup
    Given I played Team B in Week 3 of 2023
    When I view that historical matchup
    Then I should see the final score
    And I should see both rosters from that week
    And I should see scoring details

  @happy-path @history
  Scenario: View rivalry trends
    When I view trends against Team B
    Then I should see average margin of victory/defeat
    And I should see highest and lowest scoring matchups
    And I should see winning streaks

  @happy-path @history
  Scenario: Compare historical performance
    When I compare performance against Team B
    Then I should see position-by-position comparison
    And I should see which positions I typically win
    And I should see actionable insights

  @happy-path @history
  Scenario: View head-to-head across all seasons
    Given this is a multi-year league
    When I view all-time head-to-head
    Then I should see records for each season
    And I should see overall career record
    And I should see playoff head-to-head

  # ============================================================================
  # MATCHUP CHAT
  # ============================================================================

  @happy-path @chat
  Scenario: Send message in matchup chat
    When I open the matchup chat
    And I send a message "Good luck this week!"
    Then the message should appear in the chat
    And my opponent should be notified

  @happy-path @chat
  Scenario: View matchup chat history
    Given we have chatted in previous matchups
    When I view the matchup chat
    Then I should see the chat history
    And messages should be grouped by matchup week

  @happy-path @chat
  Scenario: React to chat message
    Given my opponent sent a message
    When I react with an emoji
    Then the reaction should be visible
    And my opponent should be notified

  @happy-path @chat
  Scenario: Send trash talk with GIF
    When I send a GIF in the matchup chat
    Then the GIF should display in the chat
    And it should be appropriately sized

  @happy-path @chat
  Scenario: Mute matchup chat
    Given I want to focus on my matchup
    When I mute the matchup chat
    Then I should not receive chat notifications
    And I should be able to unmute at any time

  @moderation @chat
  Scenario: Report inappropriate message
    Given my opponent sent an inappropriate message
    When I report the message
    Then the report should be sent to the commissioner
    And I should see a confirmation

  # ============================================================================
  # MATCHUP NOTIFICATIONS
  # ============================================================================

  @happy-path @notifications
  Scenario: Receive matchup preview notification
    Given my matchup starts tomorrow
    When the preview notification triggers
    Then I should receive a matchup preview
    And it should include projections and key matchups

  @happy-path @notifications
  Scenario: Receive score update notification
    Given my matchup is in progress
    When a significant scoring play occurs
    Then I should receive a notification
    And it should show the updated score

  @happy-path @notifications
  Scenario: Receive lead change notification
    Given I was winning my matchup
    When my opponent takes the lead
    Then I should receive a notification
    And it should say "Team B has taken the lead: 85-82"

  @happy-path @notifications
  Scenario: Receive close game notification
    Given my matchup is within 5 points
    And Monday Night Football is about to start
    Then I should receive a "Close Game" notification
    And it should highlight remaining players

  @happy-path @notifications
  Scenario: Receive final result notification
    Given all games have completed
    When my matchup result is finalized
    Then I should receive a win/loss notification
    And it should include final scores

  @happy-path @notifications
  Scenario: Configure matchup notification preferences
    When I configure matchup notifications
    Then I should be able to toggle:
      | Notification Type    | Enabled |
      | Matchup Preview      | Yes     |
      | Score Updates        | Yes     |
      | Lead Changes         | Yes     |
      | Close Game Alerts    | Yes     |
      | Final Results        | Yes     |

  # ============================================================================
  # BYE WEEKS
  # ============================================================================

  @happy-path @bye
  Scenario: View matchup with bye week impact
    Given I have 2 players on bye this week
    When I view my matchup
    Then I should see bye week indicators on those players
    And I should see adjusted projections
    And I should see suggestions for replacements

  @happy-path @bye
  Scenario: League-wide bye week view
    When I view the league bye week calendar
    Then I should see which teams are most affected each week
    And I should see player counts per team on bye
    And I should see bye week advantages in matchups

  @happy-path @bye
  Scenario: Bye week advantage notification
    Given my opponent has 3 players on bye
    When I view my matchup
    Then I should see a "Bye Week Advantage" indicator
    And I should see the projected point differential

  @happy-path @bye
  Scenario: Schedule bye week impact analysis
    When I view season schedule with bye analysis
    Then I should see which weeks have most bye players
    And I should see projected difficulty per week
    And I should plan accordingly

  # ============================================================================
  # RIVALRY TRACKING
  # ============================================================================

  @happy-path @rivalry
  Scenario: View designated rivalries
    When I view league rivalries
    Then I should see designated rivalry matchups
    And I should see rivalry records
    And rivalries should be prominently featured

  @commissioner @rivalry
  Scenario: Create rivalry matchup
    Given I am the commissioner
    When I designate Team A vs Team B as a rivalry
    Then the rivalry should be created
    And rivalry history should be tracked
    And rivalry weeks should be highlighted

  @happy-path @rivalry
  Scenario: View rivalry leaderboard
    When I view the rivalry standings
    Then I should see current rivalry records
    And I should see rivalry point differentials
    And I should see rivalry streaks

  @happy-path @rivalry
  Scenario: Rivalry week special features
    Given it's rivalry week
    When I view my rivalry matchup
    Then I should see rivalry branding
    And I should see historical rivalry moments
    And I should see rivalry stats prominently

  @happy-path @rivalry
  Scenario: Rivalry notification
    Given rivalry week is approaching
    When the week begins
    Then I should receive a rivalry notification
    And it should include rivalry history and stakes

  # ============================================================================
  # STATS COMPARISON
  # ============================================================================

  @happy-path @comparison
  Scenario: Compare team statistics
    When I view the stats comparison for my matchup
    Then I should see side-by-side team stats:
      | Stat              | My Team | Opponent |
      | Season Points     | 842.5   | 801.3    |
      | Points Per Game   | 105.3   | 100.2    |
      | High Score        | 145.2   | 132.8    |
      | Consistency       | 8.2     | 12.5     |

  @happy-path @comparison
  Scenario: Compare positional strength
    When I view positional comparison
    Then I should see each position's average points
    And I should see positional advantages/disadvantages
    And I should see head-to-head predictions

  @happy-path @comparison
  Scenario: Compare player matchups
    When I view player-by-player comparison
    Then I should see my QB vs their QB projections
    And I should see each position face-off
    And I should see who has the edge at each position

  @happy-path @comparison
  Scenario: Compare recent form
    When I view recent form comparison
    Then I should see last 3 weeks performance
    And I should see trending players for each team
    And I should see momentum indicators

  @happy-path @comparison
  Scenario: Compare strength of schedule
    When I view strength of schedule
    Then I should see each team's remaining schedule
    And I should see average opponent points against
    And I should see playoff positioning scenarios

  @happy-path @comparison
  Scenario: Export matchup comparison
    When I export the matchup comparison
    Then I should receive a shareable image/PDF
    And it should include key statistics
    And I should be able to share on social media

  # ============================================================================
  # RESULT FINALIZATION
  # ============================================================================

  @happy-path @finalization
  Scenario: View final matchup result
    Given all games have completed
    When results are finalized
    Then I should see the final score
    And I should see Win or Loss indicator
    And standings should update

  @happy-path @finalization
  Scenario: View stat corrections impact
    Given stat corrections have been applied
    When I view the corrected result
    Then I should see any score changes
    And I should see which corrections were applied
    And I should see if the result changed

  @happy-path @finalization
  Scenario: Finalization timing
    Given Tuesday morning has arrived
    When stat corrections are finalized
    Then all matchup results should be locked
    And standings should reflect final results
    And no further changes should occur

  @commissioner @finalization
  Scenario: Commissioner overrides score
    Given I am the commissioner
    And there's a scoring dispute
    When I manually adjust the score
    Then the result should be updated
    And an audit log should record the change
    And both teams should be notified

  @happy-path @finalization
  Scenario: View week-over-week results
    When I view my results history
    Then I should see all weekly results
    And I should see running record
    And I should see season-long trends

  # ============================================================================
  # TIEBREAKERS
  # ============================================================================

  @happy-path @tiebreaker
  Scenario: View tiebreaker rules
    When I view tiebreaker settings
    Then I should see the tiebreaker order:
      | Priority | Tiebreaker            |
      | 1        | Head-to-Head Record   |
      | 2        | Total Points For      |
      | 3        | Total Points Against  |
      | 4        | Coin Flip             |

  @happy-path @tiebreaker
  Scenario: Matchup ends in tie
    Given my matchup ends with identical scores
    When the tiebreaker is applied
    Then I should see the tiebreaker result
    And I should see which tiebreaker was used
    And the result should be clearly indicated

  @happy-path @tiebreaker
  Scenario: Bench points tiebreaker
    Given the league uses bench points as tiebreaker
    And the matchup is tied
    When the tiebreaker is applied
    Then bench scores should determine the winner
    And the bench tiebreaker should be displayed

  @happy-path @tiebreaker
  Scenario: View tiebreaker scenarios
    Given two teams are tied in standings
    When I view playoff seeding
    Then I should see the tiebreaker applied
    And I should see which team gets higher seed
    And I should see the tiebreaker explanation

  @commissioner @tiebreaker
  Scenario: Configure tiebreaker rules
    Given I am the commissioner
    When I configure tiebreaker settings
    Then I should be able to reorder tiebreakers
    And I should be able to enable/disable options
    And changes should apply to future ties

  # ============================================================================
  # MATCHUP ANALYTICS
  # ============================================================================

  @happy-path @analytics
  Scenario: View matchup win probability over time
    When I view the matchup analytics
    Then I should see win probability throughout the matchup
    And I should see key moments that shifted probability
    And I should see a timeline graph

  @happy-path @analytics
  Scenario: View optimal vs actual lineup comparison
    Given the matchup is complete
    When I view the optimal lineup analysis
    Then I should see my actual score
    And I should see my optimal possible score
    And I should see which changes would have helped

  @happy-path @analytics
  Scenario: View performance vs expectations
    When I view performance analysis
    Then I should see players who exceeded projections
    And I should see players who underperformed
    And I should see overall projection accuracy

  @happy-path @analytics
  Scenario: View luck factor analysis
    When I view matchup luck analysis
    Then I should see my expected wins based on points
    And I should see actual wins
    And I should see "luck" rating for the season

  @happy-path @analytics
  Scenario: View matchup simulation
    Given the matchup is upcoming
    When I run a matchup simulation
    Then I should see 1000 simulated outcomes
    And I should see win probability distribution
    And I should see key swing players

  @happy-path @analytics
  Scenario: Export matchup analytics
    When I export matchup analytics
    Then I should receive detailed statistics
    And it should include visualizations
    And I should be able to compare week-over-week

  @happy-path @analytics
  Scenario: View decision impact analysis
    Given my matchup is complete
    When I view decision analysis
    Then I should see which start/sit decisions mattered
    And I should see point differentials
    And I should see what would have won/lost

  # ============================================================================
  # MOBILE / RESPONSIVE
  # ============================================================================

  @mobile @responsive
  Scenario: View matchup on mobile device
    Given I am using a mobile device
    When I view my matchup
    Then I should see a mobile-optimized layout
    And I should be able to swipe between teams
    And scores should be prominently displayed

  @mobile @responsive
  Scenario: Live tracking on mobile
    Given I am using a mobile device
    And games are in progress
    When I view my matchup
    Then scores should update in real-time
    And I should see a compact player list
    And I should be able to expand for details

  @mobile @responsive
  Scenario: View matchup scoreboard widget
    Given I have the mobile widget enabled
    When I view my home screen
    Then I should see my matchup score widget
    And it should show current scores
    And it should update automatically

  # ============================================================================
  # ACCESSIBILITY
  # ============================================================================

  @accessibility @a11y
  Scenario: Screen reader support for matchups
    Given I am using a screen reader
    When I navigate my matchup
    Then scores should be announced clearly
    And player names and stats should be accessible
    And live updates should be announced

  @accessibility @a11y
  Scenario: Keyboard navigation for matchups
    Given I am using keyboard only
    When I navigate the matchup page
    Then I should be able to tab through sections
    And I should be able to access all actions
    And focus should be clearly visible

  @accessibility @a11y
  Scenario: Color-blind friendly indicators
    Given I have color vision deficiency
    When I view matchup status
    Then win/loss should use patterns not just colors
    And leading/trailing should be clearly indicated
    And all important info should be accessible

  # ============================================================================
  # ERROR HANDLING
  # ============================================================================

  @error @resilience
  Scenario: Handle score data delay
    Given live scoring data is delayed
    When I view my matchup
    Then I should see last known scores
    And I should see "Scores may be delayed" message
    And scores should update when data is available

  @error @resilience
  Scenario: Handle matchup data loading failure
    Given the matchup data fails to load
    When I view my matchup
    Then I should see a retry option
    And I should see cached data if available
    And I should not see a blank screen

  @error @resilience
  Scenario: Handle real-time connection loss
    Given I am viewing live scores
    And my connection is lost
    When I reconnect
    Then scores should sync to current state
    And I should see any missed updates
    And the connection status should be shown
