@standings @rankings
Feature: Standings
  As a fantasy football manager
  I want to view league standings and playoff positioning
  So that I can track my progress and playoff chances

  Background:
    Given I am logged in as a league member
    And the league "Playoff Champions" exists
    And the current week is Week 10

  # ============================================================================
  # OVERALL STANDINGS
  # ============================================================================

  @happy-path @overall
  Scenario: View current league standings
    When I view the league standings
    Then I should see all teams ranked by record
    And I should see each team's win-loss record
    And I should see points for and against

  @happy-path @overall
  Scenario: View standings with full statistics
    When I view the expanded standings
    Then I should see:
      | Rank | Team     | Record | PF     | PA     | Streak | Last 3 |
      | 1    | Team A   | 8-2    | 1052.4 | 892.3  | W3     | 2-1    |
      | 2    | Team B   | 7-3    | 1001.2 | 945.6  | W1     | 3-0    |
      | 3    | Team C   | 6-4    | 978.5  | 956.2  | L2     | 1-2    |

  @happy-path @overall
  Scenario: View my position in standings
    When I view the standings
    Then my team should be highlighted
    And I should see my current ranking
    And I should see gap to teams above and below

  @happy-path @overall
  Scenario: Sort standings by different criteria
    When I sort standings by "Points For"
    Then teams should be ordered by total points scored
    And I should be able to sort by:
      | Criteria       |
      | Record         |
      | Points For     |
      | Points Against |
      | Point Diff     |
      | Streak         |

  @happy-path @overall
  Scenario: View standings with playoff line indicator
    Given the league has 6 playoff spots
    When I view the standings
    Then I should see a visual line between 6th and 7th place
    And teams above should show "Playoff Position"
    And teams below should show "Outside Playoffs"

  @happy-path @overall
  Scenario: View median standings mode
    Given the league uses median scoring
    When I view median standings
    Then I should see standard record and median record
    And I should see combined record
    And I should understand the median line

  # ============================================================================
  # DIVISIONAL STANDINGS
  # ============================================================================

  @happy-path @division
  Scenario: View divisional standings
    Given the league has 2 divisions
    When I view divisional standings
    Then I should see teams grouped by division
    And each division should show its own rankings
    And I should see division leaders highlighted

  @happy-path @division
  Scenario: View division record
    When I view my team's division stats
    Then I should see my division record (e.g., "4-2")
    And I should see head-to-head vs each division opponent
    And I should see remaining division games

  @happy-path @division
  Scenario: Compare division standings
    Given there are 2 divisions
    When I view the division comparison
    Then I should see East vs West standings side by side
    And I should see average points per division
    And I should see inter-division record

  @happy-path @division
  Scenario: View division winner implications
    When I view playoff seeding rules
    Then I should see that division winners are guaranteed playoffs
    And I should see current division leaders
    And I should see division races

  @happy-path @division
  Scenario: Division clinch scenarios
    Given I lead my division by 2 games
    When I view division standings
    Then I should see games until division clinch
    And I should see magic number if applicable

  # ============================================================================
  # WEEKLY UPDATES
  # ============================================================================

  @happy-path @weekly
  Scenario: View standings change after week completes
    Given Week 9 has completed
    When I view Week 10 standings
    Then I should see updated records
    And I should see rank changes from last week
    And movement should be indicated with arrows

  @happy-path @weekly
  Scenario: View weekly movement indicators
    When I view standings with movement
    Then I should see:
      | Team   | Rank | Change |
      | Team A | 1    | -      |
      | Team B | 2    | +2     |
      | Team C | 3    | -1     |
      | Team D | 4    | -1     |

  @happy-path @weekly
  Scenario: View standings timeline
    When I view standings over time
    Then I should see a graph of my ranking by week
    And I should see when I rose or fell
    And I should be able to compare with other teams

  @happy-path @weekly
  Scenario: View week-by-week standings snapshot
    When I select Week 6 standings
    Then I should see standings as they were after Week 6
    And I should be able to navigate between weeks
    And I should see historical context

  @happy-path @weekly
  Scenario: Live standings during game week
    Given games are in progress
    When I view live standings
    Then I should see projected standings changes
    And I should see teams that could move up/down
    And standings should update as games finish

  # ============================================================================
  # STANDINGS HISTORY
  # ============================================================================

  @happy-path @history
  Scenario: View previous season standings
    Given multiple seasons have been played
    When I view 2023 final standings
    Then I should see the complete 2023 standings
    And I should see the champion
    And I should see playoff results

  @happy-path @history
  Scenario: View all-time standings
    When I view all-time league standings
    Then I should see career records for all managers
    And I should see total championships
    And I should see all-time win percentage

  @happy-path @history
  Scenario: View my historical performance
    When I view my standings history
    Then I should see my finish position each season
    And I should see playoff appearances
    And I should see best and worst finishes

  @happy-path @history
  Scenario: Compare seasons
    When I compare 2023 and 2024 standings
    Then I should see improvement/decline for each team
    And I should see roster changes impact
    And I should see year-over-year trends

  @happy-path @history
  Scenario: View franchise records
    When I view franchise records
    Then I should see:
      | Record                | Team   | Value  | Season |
      | Most Wins (Season)    | Team A | 12     | 2022   |
      | Most Points (Season)  | Team B | 1543.2 | 2023   |
      | Longest Win Streak    | Team C | 8      | 2021   |

  # ============================================================================
  # PLAYOFF CLINCHING
  # ============================================================================

  @happy-path @clinching
  Scenario: View playoff clinching scenarios
    When I view playoff scenarios
    Then I should see what is needed to clinch a playoff spot
    And I should see scenarios that would clinch
    And I should see if I've already clinched

  @happy-path @clinching
  Scenario: Display clinched playoff spot
    Given my team has clinched a playoff spot
    When I view the standings
    Then I should see a "Clinched" badge next to my team
    And I should see when I clinched
    And I should see my potential seeding range

  @happy-path @clinching
  Scenario: View magic number for clinching
    Given I have not yet clinched
    When I view my playoff chances
    Then I should see my magic number
    And I should see the explanation (wins + competitor losses)
    And I should see likely scenarios

  @happy-path @clinching
  Scenario: View first round bye clinching
    Given the top 2 seeds get a bye
    When I view bye scenarios
    Then I should see what's needed for a first-round bye
    And I should see current bye teams
    And I should see bye race standings

  @happy-path @clinching
  Scenario: Clinch notification
    Given my team clinches a playoff spot this week
    When the week's results are finalized
    Then I should receive a clinch notification
    And the standings should update with the badge
    And league-wide announcement should be made

  @happy-path @clinching
  Scenario: View seeding scenarios
    Given I've clinched a playoff spot
    When I view seeding scenarios
    Then I should see possible seeding outcomes
    And I should see what's needed for each seed
    And I should see opponent implications

  # ============================================================================
  # ELIMINATION TRACKING
  # ============================================================================

  @happy-path @elimination
  Scenario: View elimination scenarios
    Given my team is in playoff contention
    When I view elimination scenarios
    Then I should see what would eliminate me
    And I should see my "tragic number"
    And I should see survival scenarios

  @happy-path @elimination
  Scenario: Display eliminated team
    Given a team has been mathematically eliminated
    When I view the standings
    Then that team should show "Eliminated" status
    And they should be grayed out or marked
    And they should still be ranked

  @happy-path @elimination
  Scenario: Track remaining playoff spots
    When I view playoff race summary
    Then I should see how many spots are available
    And I should see teams fighting for spots
    And I should see teams safely in or out

  @happy-path @elimination
  Scenario: Elimination notification
    Given a team is eliminated this week
    When the week's results are finalized
    Then that team should receive elimination notification
    And the standings should update
    And other teams should see updated scenarios

  @happy-path @elimination
  Scenario: View consolation bracket implications
    Given I am eliminated from playoffs
    When I view standings
    Then I should see consolation bracket seeding
    And I should see what's at stake (draft picks, etc.)
    And I should still have goals to compete for

  # ============================================================================
  # TIEBREAKERS
  # ============================================================================

  @happy-path @tiebreaker
  Scenario: View tiebreaker rules
    When I view tiebreaker settings
    Then I should see the tiebreaker order:
      | Priority | Tiebreaker           |
      | 1        | Head-to-Head Record  |
      | 2        | Division Record      |
      | 3        | Points For           |
      | 4        | Points Against       |

  @happy-path @tiebreaker
  Scenario: Display active tiebreaker
    Given Team A and Team B have the same record
    When I view the standings
    Then I should see which tiebreaker determined ranking
    And I should see the tiebreaker values
    And I should be able to click for details

  @happy-path @tiebreaker
  Scenario: View head-to-head tiebreaker
    Given Team A and Team B are tied
    And they have played each other
    When I view the tiebreaker details
    Then I should see their head-to-head record
    And I should see the matchup results
    And I should see who wins the tiebreaker

  @happy-path @tiebreaker
  Scenario: View three-way tiebreaker
    Given three teams are tied at 7-5
    When I view the tiebreaker details
    Then I should see the three-way tiebreaker process
    And I should see each step of resolution
    And I should see the final ordering

  @happy-path @tiebreaker
  Scenario: Tiebreaker preview for upcoming games
    Given I'm tied with Team B
    When I view tiebreaker implications
    Then I should see how this week's games affect tiebreaker
    And I should see what I need to win tiebreaker
    And I should see current tiebreaker status

  # ============================================================================
  # POINTS FOR/AGAINST
  # ============================================================================

  @happy-path @points
  Scenario: View points for rankings
    When I sort by points for
    Then I should see teams ranked by total points scored
    And I should see weekly average points
    And I should see high and low scores

  @happy-path @points
  Scenario: View points against rankings
    When I sort by points against
    Then I should see teams ranked by points allowed
    And I should see my "luck factor"
    And I should see expected vs actual record

  @happy-path @points
  Scenario: View point differential
    When I view point differential standings
    Then I should see total point differential for each team
    And positive differential should be green
    And negative differential should be red

  @happy-path @points
  Scenario: View weekly scoring trends
    When I view scoring trends
    Then I should see each team's weekly scores
    And I should see consistency metrics
    And I should see trending up/down indicators

  @happy-path @points
  Scenario: Compare points vs record
    When I view luck analysis
    Then I should see expected wins based on points
    And I should see actual wins
    And I should see "luckiest" and "unluckiest" teams

  @happy-path @points
  Scenario: View all-play record
    When I view all-play standings
    Then I should see each team's record if they played everyone each week
    And I should see true strength of schedule
    And I should see adjusted rankings

  # ============================================================================
  # WIN STREAKS
  # ============================================================================

  @happy-path @streaks
  Scenario: View current win/loss streaks
    When I view streak information
    Then I should see each team's current streak
    And I should see "W5" for 5 game win streak
    And I should see "L3" for 3 game losing streak

  @happy-path @streaks
  Scenario: View longest streaks in league
    When I view streak records
    Then I should see:
      | Record Type         | Team   | Length | Dates          |
      | Longest Win Streak  | Team A | 7      | Week 3-9       |
      | Longest Loss Streak | Team D | 5      | Week 5-9       |
      | Current Hot Streak  | Team B | 4      | Active         |

  @happy-path @streaks
  Scenario: View streak history
    When I view my team's streak history
    Then I should see all my win/loss streaks
    And I should see when streaks started and ended
    And I should see what broke each streak

  @happy-path @streaks
  Scenario: Streak milestone notification
    Given I just won my 5th straight game
    When the result is finalized
    Then I should receive a streak milestone notification
    And it should compare to league records
    And it should be sharable

  # ============================================================================
  # PROJECTIONS
  # ============================================================================

  @happy-path @projections
  Scenario: View projected final standings
    When I view standings projections
    Then I should see predicted final standings
    And I should see confidence intervals
    And I should see range of possible finishes

  @happy-path @projections
  Scenario: View playoff probability
    When I view playoff probabilities
    Then I should see each team's playoff odds
    And I should see probability over time graph
    And I should see how odds changed this week

  @happy-path @projections
  Scenario: View championship probability
    When I view championship odds
    Then I should see each team's title odds
    And I should see the favorites
    And I should see my chances

  @happy-path @projections
  Scenario: Run standings simulation
    When I run 10,000 season simulations
    Then I should see distribution of outcomes
    And I should see most likely scenarios
    And I should see edge cases

  @happy-path @projections
  Scenario: View remaining schedule difficulty
    When I view schedule strength
    Then I should see remaining opponent strength
    And I should see projected record for rest of season
    And I should see how schedule compares to others

  @happy-path @projections
  Scenario: What-if scenario analysis
    When I create a "what if" scenario
    And I set "I win out" and "Team B loses twice"
    Then I should see projected final standings
    And I should see my seeding
    And I should see probability of this scenario

  # ============================================================================
  # STANDINGS EXPORT
  # ============================================================================

  @happy-path @export
  Scenario: Export standings to CSV
    When I export standings to CSV
    Then I should receive a CSV file
    And it should include all standings data
    And columns should be properly labeled

  @happy-path @export
  Scenario: Export standings to PDF
    When I export standings to PDF
    Then I should receive a formatted PDF
    And it should include league logo
    And it should be printable

  @happy-path @export
  Scenario: Share standings image
    When I generate a standings image
    Then I should receive a shareable image
    And it should show current standings
    And I should be able to share on social media

  @happy-path @export
  Scenario: Export historical standings
    When I export all-time standings
    Then I should receive comprehensive data
    And it should include all seasons
    And it should include playoff results

  @happy-path @export
  Scenario: Email standings to league
    Given I am the commissioner
    When I email standings to the league
    Then all members should receive the standings
    And the email should include commentary section
    And it should be formatted nicely

  # ============================================================================
  # MOBILE DISPLAY
  # ============================================================================

  @mobile @responsive
  Scenario: View standings on mobile device
    Given I am using a mobile device
    When I view the standings
    Then I should see a mobile-optimized layout
    And essential stats should be visible
    And I should be able to scroll horizontally for more

  @mobile @responsive
  Scenario: Compact standings view
    Given I am on mobile
    When I view compact standings
    Then I should see:
      | Rank | Team | Record |
      | 1    | A    | 8-2    |
      | 2    | B    | 7-3    |
    And I should tap to expand for full stats

  @mobile @responsive
  Scenario: Standings widget on home screen
    Given I have the mobile widget enabled
    When I view my home screen
    Then I should see my current standing
    And I should see abbreviated league standings
    And it should update weekly

  @mobile @responsive
  Scenario: Swipe between standings views
    Given I am on mobile
    When I swipe left on standings
    Then I should see divisional standings
    And swiping again should show projections
    And I should see view indicator dots

  @mobile @responsive
  Scenario: Pull to refresh standings
    Given I am on mobile
    When I pull down to refresh
    Then standings should reload
    And I should see the last updated time
    And any changes should be highlighted

  # ============================================================================
  # ACCESSIBILITY
  # ============================================================================

  @accessibility @a11y
  Scenario: Screen reader support for standings
    Given I am using a screen reader
    When I navigate the standings
    Then each team's position should be announced
    And record and statistics should be readable
    And movement indicators should be described

  @accessibility @a11y
  Scenario: Keyboard navigation for standings
    Given I am using keyboard only
    When I navigate standings
    Then I should be able to tab through teams
    And I should be able to sort with keyboard
    And I should access all features without mouse

  @accessibility @a11y
  Scenario: High contrast standings display
    Given I have high contrast mode enabled
    When I view standings
    Then all text should be clearly readable
    And rank changes should use patterns not just colors
    And playoff line should be clearly visible

  # ============================================================================
  # ERROR HANDLING
  # ============================================================================

  @error @resilience
  Scenario: Handle standings calculation delay
    Given standings are being recalculated
    When I view standings
    Then I should see last known standings
    And I should see "Updating..." indicator
    And standings should refresh when ready

  @error @resilience
  Scenario: Handle missing game data
    Given some game data is unavailable
    When I view standings
    Then I should see partial standings
    And missing data should be indicated
    And I should see expected update time

  @error @resilience
  Scenario: Handle standings sync issue
    Given there's a sync issue between devices
    When I view standings on a new device
    Then standings should sync correctly
    And any discrepancies should resolve
    And I should see consistent data
