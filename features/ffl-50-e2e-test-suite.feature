@e2e @integration @playwright
Feature: FFL-50: E2E Test Suite - Core User Flows
  As a QA engineer
  I want comprehensive end-to-end tests for all core user flows
  So that I can ensure the application works correctly from a user perspective

  Background:
    Given the application is running in test environment
    And the test database is seeded with test data
    And Playwright browser context is initialized
    And network requests are being monitored

  # ==========================================
  # LOGIN FLOW E2E TESTS
  # ==========================================

  @login @authentication @happy-path
  Scenario: Complete login flow with Google OAuth
    Given I am on the landing page
    And I am not authenticated
    When I click the "Sign in with Google" button
    Then I should be redirected to Google OAuth consent screen
    When I authenticate with valid Google credentials
    Then I should be redirected back to the application
    And I should see my user profile in the header
    And I should see the dashboard page
    And a session cookie should be set
    And the session should be valid for 24 hours

  @login @authentication @happy-path
  Scenario: Complete login flow with email/password
    Given I am on the landing page
    And I am not authenticated
    When I click the "Sign in with Email" button
    Then I should see the email login form
    When I enter valid credentials:
      | field    | value                |
      | email    | testuser@example.com |
      | password | ValidPassword123!    |
    And I click the "Sign In" button
    Then I should be redirected to the dashboard
    And I should see "Welcome back" message
    And my authentication token should be stored

  @login @authentication @error
  Scenario: Login with invalid credentials shows error
    Given I am on the login page
    When I enter invalid credentials:
      | field    | value              |
      | email    | wrong@example.com  |
      | password | WrongPassword123!  |
    And I click the "Sign In" button
    Then I should see an error message "Invalid email or password"
    And I should remain on the login page
    And no session should be created

  @login @authentication @session
  Scenario: Session persistence across page refreshes
    Given I am logged in as "testuser@example.com"
    And I am on the dashboard page
    When I refresh the page
    Then I should still be on the dashboard page
    And I should still see my user profile
    And I should not be redirected to login

  @login @authentication @logout
  Scenario: Complete logout flow
    Given I am logged in as "testuser@example.com"
    And I am on the dashboard page
    When I click on my profile menu
    And I click "Sign Out"
    Then I should be redirected to the landing page
    And my session should be invalidated
    And attempting to access protected pages should redirect to login

  @login @authentication @redirect
  Scenario: Redirect to requested page after login
    Given I am not authenticated
    When I navigate directly to "/leagues/123/roster"
    Then I should be redirected to the login page
    And the return URL should be stored
    When I successfully log in
    Then I should be redirected to "/leagues/123/roster"

  # ==========================================
  # LEAGUE JOIN FLOW E2E TESTS
  # ==========================================

  @league @join @invitation @happy-path
  Scenario: Join league via email invitation link
    Given I am logged in as "newplayer@example.com"
    And I have received a league invitation email for "Championship League"
    When I click the invitation link in the email
    Then I should see the league join confirmation page
    And I should see league details:
      | field        | value              |
      | League Name  | Championship League |
      | Admin        | admin@example.com   |
      | Season       | 2024               |
      | Players      | 7 of 10            |
    When I click "Accept Invitation"
    Then I should be added to the league
    And I should be redirected to the league dashboard
    And I should see "Welcome to Championship League" message

  @league @join @invitation @expired
  Scenario: Attempt to join league with expired invitation
    Given I am logged in as "newplayer@example.com"
    And I have an expired invitation link for "Old League"
    When I click the expired invitation link
    Then I should see an error page with message "This invitation has expired"
    And I should see a "Request New Invitation" button
    And I should not be added to any league

  @league @join @code @happy-path
  Scenario: Join league using league code
    Given I am logged in as "newplayer@example.com"
    And I am on the "Join League" page
    And a league exists with code "CHAMP2024"
    When I enter the league code "CHAMP2024"
    And I click "Join League"
    Then I should see the league preview:
      | field        | value              |
      | League Name  | Championship League |
      | Entry Fee    | $50                |
      | Scoring      | PPR                |
    When I confirm and click "Join"
    Then I should be added to the league
    And I should see a success notification

  @league @join @code @invalid
  Scenario: Attempt to join league with invalid code
    Given I am logged in as "newplayer@example.com"
    And I am on the "Join League" page
    When I enter an invalid league code "INVALID123"
    And I click "Join League"
    Then I should see an error message "Invalid league code"
    And I should remain on the join page

  @league @join @full
  Scenario: Attempt to join a full league
    Given I am logged in as "newplayer@example.com"
    And a league "Full League" has reached maximum capacity of 10 players
    When I try to join "Full League" with a valid invitation
    Then I should see an error message "This league is full"
    And I should not be added to the league
    And I should see option to "Join Waitlist"

  @league @join @duplicate
  Scenario: Attempt to join a league already a member of
    Given I am logged in as "existingplayer@example.com"
    And I am already a member of "My League"
    When I try to join "My League" again
    Then I should see a message "You are already a member of this league"
    And I should be redirected to the league dashboard

  @league @browse @happy-path
  Scenario: Browse and join public league
    Given I am logged in as "newplayer@example.com"
    And I am on the "Browse Leagues" page
    When I filter leagues by:
      | filter      | value     |
      | Scoring     | PPR       |
      | Entry Fee   | Free      |
      | Open Spots  | Available |
    Then I should see a list of matching public leagues
    When I click on "Casual PPR League"
    Then I should see the league details page
    When I click "Request to Join"
    Then I should see "Join request sent" confirmation
    And the league admin should receive a notification

  # ==========================================
  # ROSTER BUILDING FLOW E2E TESTS
  # ==========================================

  @roster @building @happy-path
  Scenario: Complete roster building flow
    Given I am logged in as "player@example.com"
    And I am a member of "Championship League"
    And it is before the roster lock deadline
    And I am on the roster builder page
    Then I should see empty roster slots:
      | position | slots |
      | QB       | 1     |
      | RB       | 2     |
      | WR       | 2     |
      | TE       | 1     |
      | FLEX     | 1     |
      | K        | 1     |
      | DEF      | 1     |
    When I search for player "Patrick Mahomes"
    Then I should see player search results
    And I should see player details for "Patrick Mahomes":
      | field          | value        |
      | Position       | QB           |
      | Team           | KC           |
      | Projected Pts  | 22.5         |
      | Bye Week       | 6            |
    When I click "Add to Roster" for "Patrick Mahomes"
    Then "Patrick Mahomes" should appear in my QB slot
    And my roster should show 1 of 9 positions filled
    And I should see a success notification

  @roster @building @search
  Scenario: Search and filter available players
    Given I am logged in and on the roster builder page
    When I search for "Smith"
    Then I should see multiple players named "Smith"
    When I filter by position "WR"
    Then I should only see wide receivers named "Smith"
    When I filter by team "DAL"
    Then I should only see Cowboys wide receivers named "Smith"
    When I sort by "Projected Points" descending
    Then players should be sorted by projected points

  @roster @building @drag-drop
  Scenario: Build roster using drag and drop
    Given I am logged in and on the roster builder page
    And I have searched for available running backs
    When I drag "Derrick Henry" from search results
    And I drop him on the RB1 slot
    Then "Derrick Henry" should be assigned to RB1
    And a "drop successful" animation should play
    When I drag "Derrick Henry" from RB1 to RB2
    Then "Derrick Henry" should move to RB2
    And RB1 should be empty

  @roster @building @flex
  Scenario: Add player to FLEX position
    Given I am logged in and on the roster builder page
    And my RB1 and RB2 slots are filled
    When I search for "Christian McCaffrey"
    And I click "Add to FLEX" for "Christian McCaffrey"
    Then "Christian McCaffrey" should appear in my FLEX slot
    And I should see position indicator showing "RB" in FLEX

  @roster @building @validation
  Scenario: Roster validation prevents invalid selections
    Given I am logged in and on the roster builder page
    And I have already added "Patrick Mahomes" as QB
    When I search for "Josh Allen"
    And I try to add "Josh Allen" to QB slot
    Then I should see error "QB position is already filled"
    And I should see option to "Replace Patrick Mahomes"

  @roster @building @replace
  Scenario: Replace existing player on roster
    Given I am logged in and on the roster builder page
    And I have "Patrick Mahomes" in my QB slot
    When I search for "Josh Allen"
    And I click "Replace QB" for "Josh Allen"
    Then I should see confirmation dialog:
      | current | Patrick Mahomes |
      | new     | Josh Allen      |
    When I confirm the replacement
    Then "Josh Allen" should be in my QB slot
    And "Patrick Mahomes" should be removed
    And "Patrick Mahomes" should appear in available players

  @roster @building @unavailable
  Scenario: Cannot add already-rostered player in same league
    Given I am logged in and on the roster builder page
    And "Travis Kelce" is already rostered by another team in my league
    When I search for "Travis Kelce"
    Then "Travis Kelce" should show as "Unavailable"
    And I should see "Rostered by Team: Eagles Fan Club"
    And the "Add to Roster" button should be disabled

  @roster @building @bye-week
  Scenario: Bye week warning when building roster
    Given I am logged in and on the roster builder page
    And it is Week 6
    And I have "Patrick Mahomes" (KC, Bye Week 6) in my QB slot
    Then I should see a bye week warning on "Patrick Mahomes"
    And I should see suggestion to add a backup QB
    When I hover over the bye week indicator
    Then I should see "Patrick Mahomes is on bye this week"

  @roster @building @save
  Scenario: Save roster progress
    Given I am logged in and on the roster builder page
    And I have partially filled my roster:
      | position | player          |
      | QB       | Patrick Mahomes |
      | RB1      | Derrick Henry   |
      | WR1      | Tyreek Hill     |
    When I click "Save Progress"
    Then I should see "Roster saved" confirmation
    When I navigate away and return to roster builder
    Then my previously saved roster should be loaded
    And all three players should still be assigned

  @roster @building @complete
  Scenario: Submit complete roster
    Given I am logged in and on the roster builder page
    And I have filled all required roster positions:
      | position | player              |
      | QB       | Patrick Mahomes     |
      | RB1      | Derrick Henry       |
      | RB2      | Christian McCaffrey |
      | WR1      | Tyreek Hill         |
      | WR2      | Ja'Marr Chase       |
      | TE       | Travis Kelce        |
      | FLEX     | Davante Adams       |
      | K        | Justin Tucker       |
      | DEF      | San Francisco 49ers |
    When I click "Submit Roster"
    Then I should see roster validation pass
    And I should see "Roster submitted successfully"
    And my roster status should change to "Submitted"
    And I should be redirected to my team page

  @roster @building @incomplete
  Scenario: Cannot submit incomplete roster
    Given I am logged in and on the roster builder page
    And I have only filled 5 of 9 roster positions
    When I click "Submit Roster"
    Then I should see error "Please fill all required positions"
    And I should see which positions are missing
    And the submit should be blocked

  # ==========================================
  # SCORE VIEWING FLOW E2E TESTS
  # ==========================================

  @scores @viewing @live @happy-path
  Scenario: View live scores during game day
    Given I am logged in as "player@example.com"
    And I am a member of "Championship League"
    And it is Sunday during NFL games
    And I navigate to the scores page
    Then I should see the live scoreboard
    And I should see my team's current score
    And I should see my opponent's current score
    And scores should be updating in real-time

  @scores @viewing @live @player-breakdown
  Scenario: View individual player score breakdown
    Given I am logged in and viewing live scores
    And "Patrick Mahomes" is currently playing
    When I click on "Patrick Mahomes" in my roster
    Then I should see his live stat breakdown:
      | stat              | value | points |
      | Passing Yards     | 287   | 11.48  |
      | Passing TDs       | 2     | 8.00   |
      | Interceptions     | 0     | 0.00   |
      | Rushing Yards     | 23    | 2.30   |
      | Total             |       | 21.78  |
    And stats should update as the game progresses

  @scores @viewing @matchup
  Scenario: View head-to-head matchup details
    Given I am logged in and on the scores page
    When I click on my current matchup
    Then I should see side-by-side roster comparison:
      | My Team         | Position | Opponent Team    |
      | Patrick Mahomes | QB       | Josh Allen       |
      | Derrick Henry   | RB1      | Saquon Barkley   |
    And I should see position-by-position score comparison
    And I should see win probability percentage

  @scores @viewing @projections
  Scenario: View projected vs actual scores
    Given I am logged in and viewing my matchup
    And some players have finished their games
    Then I should see for each player:
      | player          | projected | actual | status      |
      | Patrick Mahomes | 22.5      | 21.78  | In Progress |
      | Derrick Henry   | 18.2      | 24.50  | Final       |
      | Tyreek Hill     | 15.8      | -      | 4:25 PM     |
    And I should see total projected score
    And I should see current actual score

  @scores @viewing @historical
  Scenario: View historical week scores
    Given I am logged in as "player@example.com"
    And I am on the scores page
    When I select "Week 5" from the week dropdown
    Then I should see my Week 5 matchup results
    And I should see final scores for all players
    And I should see the matchup result (Win/Loss)
    And I should see point differential

  @scores @viewing @all-matchups
  Scenario: View all league matchups for the week
    Given I am logged in and on the scores page
    When I click "All Matchups"
    Then I should see all matchups in my league:
      | Team A          | Score A | Score B | Team B           |
      | My Team         | 124.5   | 118.2   | Eagles Fan Club  |
      | Rodgers Raiders | 132.8   | 98.4    | Brady Bunch      |
    And I should be able to click on any matchup to view details

  @scores @viewing @mobile
  Scenario: View scores on mobile device
    Given I am logged in on a mobile device
    And I am viewing the scores page
    Then I should see a mobile-optimized layout
    And I should be able to swipe between my roster and opponent
    And live score updates should work on mobile
    And I should see condensed player cards

  @scores @viewing @notifications
  Scenario: Receive score update notifications
    Given I am logged in and have enabled notifications
    And I am viewing scores for my matchup
    When one of my players scores a touchdown
    Then I should see a toast notification with the scoring play
    And my player's score should highlight briefly
    And my total score should animate updating

  # ==========================================
  # LEADERBOARD FLOW E2E TESTS
  # ==========================================

  @leaderboard @viewing @happy-path
  Scenario: View league leaderboard
    Given I am logged in as "player@example.com"
    And I am a member of "Championship League"
    When I navigate to the leaderboard page
    Then I should see all teams ranked by record:
      | Rank | Team            | Record | Points For | Points Against |
      | 1    | Rodgers Raiders | 5-1    | 842.5      | 698.2          |
      | 2    | My Team         | 4-2    | 798.4      | 712.6          |
      | 3    | Eagles Fan Club | 4-2    | 765.2      | 745.8          |
    And my team should be highlighted
    And I should see playoff cutoff line

  @leaderboard @viewing @standings
  Scenario: View detailed standings with tiebreakers
    Given I am logged in and on the leaderboard page
    And two teams have the same record
    Then teams should be sorted by tiebreaker rules:
      | Tiebreaker Order | Criteria           |
      | 1                | Head-to-head       |
      | 2                | Points For         |
      | 3                | Points Against     |
    And I should see tiebreaker indicators where applicable

  @leaderboard @viewing @weekly
  Scenario: View weekly high scores
    Given I am logged in and on the leaderboard page
    When I click on "Weekly Leaders" tab
    Then I should see weekly high scorers:
      | Week | Team            | Score  |
      | 6    | Rodgers Raiders | 156.8  |
      | 5    | My Team         | 148.2  |
      | 4    | Brady Bunch     | 142.5  |
    And I should see weekly awards (if configured)

  @leaderboard @viewing @trends
  Scenario: View team performance trends
    Given I am logged in and on the leaderboard page
    When I click on "My Team" in the standings
    Then I should see my team's performance dashboard:
      | Metric          | Value    |
      | Current Streak  | W3       |
      | Last 5          | 4-1      |
      | Avg Points/Week | 133.1    |
      | Best Week       | 156.8    |
      | Worst Week      | 98.4     |
    And I should see a points trend graph

  @leaderboard @viewing @playoffs
  Scenario: View playoff picture and scenarios
    Given I am logged in and on the leaderboard page
    And it is Week 10 of the season
    When I click on "Playoff Picture"
    Then I should see current playoff bracket projection
    And I should see clinch scenarios for each team
    And I should see elimination scenarios
    And I should see my team's playoff probability

  @leaderboard @viewing @comparison
  Scenario: Compare two teams head-to-head history
    Given I am logged in and on the leaderboard page
    When I select "Eagles Fan Club" for comparison
    Then I should see head-to-head history:
      | Season | My Team | Eagles Fan Club |
      | 2024   | 1-1     | 1-1             |
      | 2023   | 2-0     | 0-2             |
    And I should see all-time record
    And I should see upcoming matchup if scheduled

  @leaderboard @viewing @power-rankings
  Scenario: View power rankings
    Given I am logged in and on the leaderboard page
    And the league has power rankings enabled
    When I click on "Power Rankings" tab
    Then I should see teams ranked by power score:
      | Rank | Team            | Power Score | Trend |
      | 1    | Rodgers Raiders | 98.5        | +2    |
      | 2    | My Team         | 92.3        | -     |
      | 3    | Eagles Fan Club | 88.7        | -1    |
    And I should see explanation of power ranking algorithm

  @leaderboard @viewing @transactions
  Scenario: View league transaction history from leaderboard
    Given I am logged in and on the leaderboard page
    When I click on "Recent Activity"
    Then I should see recent league transactions:
      | Date       | Team            | Action         | Details              |
      | 2024-10-15 | Eagles Fan Club | Add/Drop       | Added: J. Smith      |
      | 2024-10-14 | My Team         | Roster Change  | Moved: T. Hill to WR1|
      | 2024-10-13 | Rodgers Raiders | Waiver Claim   | Claimed: R. White    |

  # ==========================================
  # CROSS-FLOW E2E TESTS
  # ==========================================

  @e2e @full-flow @new-user
  Scenario: Complete new user journey
    Given I am a new user visiting the application
    When I sign up with Google OAuth
    Then I should complete account creation
    When I browse available leagues
    And I join "Beginner League" using code "BEGINNER2024"
    Then I should be added to the league
    When I navigate to roster builder
    And I complete my roster selection
    Then my roster should be submitted
    When I view the leaderboard
    Then I should see myself ranked last (new team)
    When the first game week completes
    And I view my scores
    Then I should see my actual fantasy points

  @e2e @full-flow @game-day
  Scenario: Complete game day experience
    Given I am logged in as an existing player
    And it is NFL Sunday
    When I view my roster before games start
    Then I should see all players with game times
    When the first games kick off
    And I navigate to live scores
    Then I should see real-time score updates
    And I should see my matchup progress
    When a player scores
    Then I should see immediate score update
    When all games complete
    And I view the leaderboard
    Then standings should reflect the week's results

  @e2e @full-flow @season-end
  Scenario: End of season playoff and championship flow
    Given I am logged in and it is Week 14 (playoffs)
    And I have made the playoffs
    When I view the playoff bracket
    Then I should see my first round matchup
    When I win my playoff matchup
    Then I should advance to the championship
    When I view the championship matchup
    Then I should see the prize pool details
    When the championship week completes
    And I win the championship
    Then I should see championship celebration
    And I should see final season summary

  # ==========================================
  # PERFORMANCE E2E TESTS
  # ==========================================

  @e2e @performance @load-time
  Scenario Outline: Page load performance meets requirements
    Given I am logged in as "player@example.com"
    When I navigate to "<page>"
    Then the page should load within <max_load_time> milliseconds
    And the Largest Contentful Paint should be under <lcp_threshold> milliseconds
    And the First Input Delay should be under 100 milliseconds
    And the Cumulative Layout Shift should be under 0.1

    Examples:
      | page             | max_load_time | lcp_threshold |
      | Dashboard        | 2000          | 2500          |
      | Roster Builder   | 3000          | 3500          |
      | Live Scores      | 2000          | 2500          |
      | Leaderboard      | 2000          | 2500          |
      | League Settings  | 1500          | 2000          |

  @e2e @performance @api-response
  Scenario: API response times meet requirements
    Given I am logged in and on the dashboard
    When I trigger API calls for various endpoints
    Then response times should meet requirements:
      | endpoint              | max_response_time |
      | GET /api/roster       | 500ms             |
      | GET /api/scores       | 300ms             |
      | GET /api/leaderboard  | 400ms             |
      | POST /api/roster      | 800ms             |
      | GET /api/players      | 600ms             |

  @e2e @performance @concurrent
  Scenario: Application handles concurrent users
    Given 50 users are simultaneously logged in
    When all users refresh the scores page
    Then all requests should complete successfully
    And average response time should be under 1000ms
    And no users should see errors

  # ==========================================
  # ACCESSIBILITY E2E TESTS
  # ==========================================

  @e2e @accessibility @keyboard
  Scenario: Complete user flow using keyboard only
    Given I am on the login page
    When I navigate using only keyboard
    Then I should be able to tab to the login button
    And I should be able to activate it with Enter
    When I log in successfully
    Then I should be able to navigate the dashboard with Tab
    And I should be able to access all main features
    And focus indicators should be visible at all times

  @e2e @accessibility @screen-reader
  Scenario: Application works with screen reader
    Given I am using a screen reader
    And I am on the scores page
    Then all interactive elements should have aria labels
    And score updates should be announced
    And tables should have proper headers
    And navigation should be announced correctly

  @e2e @accessibility @wcag
  Scenario: Pages meet WCAG 2.1 AA compliance
    Given I am logged in
    When I run accessibility audit on each page
    Then all pages should pass WCAG 2.1 AA audit:
      | page           | violations_allowed |
      | Dashboard      | 0                  |
      | Roster Builder | 0                  |
      | Scores         | 0                  |
      | Leaderboard    | 0                  |
      | Settings       | 0                  |

  # ==========================================
  # ERROR HANDLING E2E TESTS
  # ==========================================

  @e2e @error @network
  Scenario: Graceful handling of network errors
    Given I am logged in and on the scores page
    When the network connection is lost
    Then I should see an offline indicator
    And cached data should still be displayed
    And I should see "You are offline" message
    When the network connection is restored
    Then data should automatically refresh
    And the offline indicator should disappear

  @e2e @error @api-failure
  Scenario: Graceful handling of API failures
    Given I am logged in and on the roster builder
    When the player search API returns a 500 error
    Then I should see a user-friendly error message
    And I should see a "Retry" button
    When I click "Retry"
    And the API recovers
    Then the search should work normally

  @e2e @error @timeout
  Scenario: Handling request timeouts
    Given I am logged in and submitting my roster
    When the request times out after 30 seconds
    Then I should see "Request timed out" message
    And I should see option to retry
    And my roster data should not be lost
    When I retry successfully
    Then my roster should be submitted

  # ==========================================
  # MOBILE RESPONSIVE E2E TESTS
  # ==========================================

  @e2e @mobile @responsive
  Scenario Outline: Application is responsive on different devices
    Given I am viewing the application on "<device>"
    And I am logged in
    When I navigate through core flows
    Then all features should be accessible
    And layout should be appropriate for "<viewport>"
    And touch interactions should work correctly
    And no horizontal scrolling should be required

    Examples:
      | device       | viewport    |
      | iPhone SE    | 375x667     |
      | iPhone 14    | 390x844     |
      | iPad         | 768x1024    |
      | iPad Pro     | 1024x1366   |
      | Desktop      | 1920x1080   |

  @e2e @mobile @touch
  Scenario: Touch interactions work on mobile
    Given I am on a touch device
    And I am on the roster builder page
    When I long-press on a player
    Then I should see the context menu
    When I swipe left on a player card
    Then I should see quick actions (add/remove)
    When I pinch to zoom on the leaderboard
    Then the view should zoom appropriately

  # ==========================================
  # DATA INTEGRITY E2E TESTS
  # ==========================================

  @e2e @data @integrity
  Scenario: Roster changes persist correctly
    Given I am logged in and on roster builder
    When I make the following roster changes:
      | action  | player          | position |
      | add     | Patrick Mahomes | QB       |
      | add     | Derrick Henry   | RB1      |
      | remove  | Derrick Henry   | RB1      |
      | add     | Saquon Barkley  | RB1      |
    And I save my roster
    And I log out and log back in
    Then my roster should show:
      | position | player          |
      | QB       | Patrick Mahomes |
      | RB1      | Saquon Barkley  |

  @e2e @data @real-time
  Scenario: Real-time updates reflect across sessions
    Given I am logged in on two browser tabs
    And both tabs are viewing the scores page
    When a score update occurs
    Then both tabs should show the updated score
    And the updates should appear within 5 seconds of each other

  # ==========================================
  # SECURITY E2E TESTS
  # ==========================================

  @e2e @security @authorization
  Scenario: Users cannot access other users' data
    Given I am logged in as "player1@example.com"
    When I try to access player2's roster via direct URL
    Then I should see "Access Denied" error
    And I should be redirected to my own dashboard

  @e2e @security @session
  Scenario: Session expires after inactivity
    Given I am logged in as "player@example.com"
    When I remain inactive for 24 hours
    And I try to perform an action
    Then I should be redirected to login
    And I should see "Session expired" message
    And my session token should be invalidated

  @e2e @security @csrf
  Scenario: CSRF protection is enforced
    Given I am logged in
    When a malicious site attempts a cross-site request
    Then the request should be rejected
    And I should see appropriate error handling
    And no data should be modified
