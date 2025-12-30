@leaderboard @rankings @cloudscape @frontend
Feature: Leaderboard UI
  As a fantasy football player
  I want to view leaderboard rankings and scores
  So that I can see how I compare to other teams in my league

  Background:
    Given I am authenticated as a valid user
    And I am a member of an active league
    And I navigate to the leaderboard page

  # ==========================================
  # Leaderboard Layout
  # ==========================================

  @layout @structure
  Scenario: Display leaderboard page structure
    Given I am on the leaderboard page
    Then I should see the leaderboard with sections:
      | section              | description                    |
      | page_header          | Leaderboard title and controls |
      | view_toggle          | Weekly/Season view switch      |
      | week_selector        | Week dropdown (weekly view)    |
      | leaderboard_table    | Main rankings table            |
      | summary_cards        | Quick stats summary            |
    And layout should follow Cloudscape patterns

  @layout @cloudscape
  Scenario: Use Cloudscape components for leaderboard
    Given I am on the leaderboard page
    Then the following Cloudscape components should be used:
      | component         | usage                      |
      | Table             | Main leaderboard table     |
      | Header            | Page and section headers   |
      | SegmentedControl  | Weekly/Season toggle       |
      | Select            | Week selector dropdown     |
      | Container         | Section containers         |
      | TextFilter        | Search/filter input        |
      | Pagination        | Table pagination           |

  @layout @responsive
  Scenario: Leaderboard is responsive across devices
    Given I am on the leaderboard page
    When I view on different screen sizes:
      | device    | width    | behavior              |
      | mobile    | 375px    | Horizontal scroll     |
      | tablet    | 768px    | Condensed columns     |
      | desktop   | 1280px   | Full table display    |
    Then table should adapt appropriately
    And essential columns should remain visible

  @layout @loading
  Scenario: Display loading state for leaderboard
    Given leaderboard data is being fetched
    When the page loads
    Then skeleton loader should display for table
    And Cloudscape Spinner may overlay table
    And table structure should be visible
    And loading should complete within 3 seconds

  # ==========================================
  # Rankings Display
  # ==========================================

  @rankings @table
  Scenario: Display rankings in table format
    Given I am on the leaderboard page
    Then I should see rankings table with columns:
      | column           | description              |
      | Rank             | Position number          |
      | Team             | Team name and owner      |
      | Record           | Win-Loss(-Tie)           |
      | Points For       | Total points scored      |
      | Points Against   | Total points allowed     |
      | Point Diff       | Points differential      |
      | Streak           | Current win/loss streak  |
    And Cloudscape Table should be used

  @rankings @position
  Scenario: Display rank position with indicators
    Given I am viewing rankings
    Then rank positions should display:
      | position | indicator              |
      | 1        | Gold medal/crown icon  |
      | 2        | Silver medal icon      |
      | 3        | Bronze medal icon      |
      | 4+       | Numeric position       |
    And rank numbers should be clearly visible

  @rankings @highlight-my-team
  Scenario: Highlight my team in rankings
    Given my team is "Thunder Squad"
    When I view the leaderboard
    Then my team row should be highlighted
    And highlight should use distinct styling
    And "You" badge may appear next to team name

  @rankings @movement
  Scenario: Show ranking movement indicators
    Given rankings have changed from previous week
    Then I should see movement indicators:
      | team          | movement   | indicator          |
      | Team Alpha    | Up 3       | Green arrow + 3    |
      | Team Beta     | Down 2     | Red arrow - 2      |
      | Team Gamma    | No change  | Gray dash          |
    And movement should compare to previous period

  @rankings @playoff-position
  Scenario: Indicate playoff qualification status
    Given league has 6 playoff spots
    Then rankings should show qualification:
      | position | status              | indicator         |
      | 1-4      | Clinched playoff    | Green check       |
      | 5-6      | In playoff position | Yellow dot        |
      | 7        | On the bubble       | Orange warning    |
      | 8-12     | Eliminated/Out      | Gray X            |
    And playoff line should be visually distinct

  @rankings @ties
  Scenario: Handle tied rankings
    Given two teams have identical records and points
    When ties are displayed
    Then tied teams should show same rank
    And tiebreaker info should be available on hover
    And next rank should skip appropriately

  @rankings @detailed-view
  Scenario: Expand row for detailed stats
    Given I want more information about a team
    When I click on a team row
    Then expanded detail should show:
      | stat                | value              |
      | Weekly scores       | Last 5 weeks       |
      | Best week           | Score and week     |
      | Worst week          | Score and week     |
      | Current roster      | Top players        |
    And Cloudscape ExpandableSection may be used

  # ==========================================
  # Weekly View
  # ==========================================

  @weekly @display
  Scenario: Display weekly leaderboard view
    Given I select "Weekly" view
    Then I should see weekly-specific columns:
      | column           | description              |
      | Rank             | Weekly position          |
      | Team             | Team name                |
      | Score            | Weekly score             |
      | Projected        | Projected final score    |
      | High Scorer      | Highest player score     |
      | Matchup Result   | W/L and opponent         |

  @weekly @selector
  Scenario: Select specific week to view
    Given I am in weekly view
    When I use the week selector dropdown
    Then I should see all completed weeks:
      | option        | description              |
      | Week 15       | Current week             |
      | Week 14       | Previous week            |
      | Week 1-13     | All prior weeks          |
    And selecting a week should update the table

  @weekly @current
  Scenario: Display current week with live data
    Given games are in progress
    When I view the current week
    Then scores should show live updates
    And "Live" indicator should appear
    And projections should update in real-time
    And refresh timestamp should be visible

  @weekly @scores
  Scenario: Display weekly score breakdown
    Given I am viewing Week 14
    Then I should see for each team:
      | data              | format               |
      | Final score       | 125.4 pts            |
      | vs opponent       | vs Team X (110.2)    |
      | win/loss          | W or L indicator     |
      | margin            | +15.2 or -10.5       |

  @weekly @high-score
  Scenario: Highlight weekly high score
    Given Week 14 has been completed
    Then the highest scoring team should:
      | element           | display              |
      | row_highlight     | Special styling      |
      | badge             | "High Score" badge   |
      | icon              | Trophy or star icon  |
    And high score value should be prominent

  @weekly @comparison
  Scenario: Compare weekly performance
    Given I am viewing weekly leaderboard
    When I select "Compare to Season Average"
    Then I should see:
      | column              | showing              |
      | Score               | Weekly score         |
      | Season Avg          | Average points       |
      | Difference          | +/- from average     |
    And over/under performance should be indicated

  # ==========================================
  # Season View
  # ==========================================

  @season @display
  Scenario: Display season leaderboard view
    Given I select "Season" view
    Then I should see season-specific columns:
      | column           | description              |
      | Rank             | Overall position         |
      | Team             | Team name                |
      | Record           | Season W-L record        |
      | Win %            | Winning percentage       |
      | Points For       | Total season points      |
      | Points Against   | Total points allowed     |
      | Avg PPG          | Average points per game  |

  @season @standings
  Scenario: Display complete season standings
    Given season is at Week 15
    Then standings should reflect:
      | data              | accuracy             |
      | Record            | All 14 games         |
      | Total Points      | Sum of all weeks     |
      | Ranking           | Based on record/pts  |
    And all teams should be included

  @season @division
  Scenario: Display division standings
    Given league has divisions configured
    When I toggle division view
    Then I should see standings grouped by division:
      | division      | teams              |
      | AFC           | 6 teams            |
      | NFC           | 6 teams            |
    And division leaders should be indicated
    And overall rank should still be visible

  @season @trends
  Scenario: Show season performance trends
    Given I want to see performance trends
    When I enable trend visualization
    Then I should see for each team:
      | trend             | display              |
      | Last 5 weeks      | Mini sparkline       |
      | Current form      | Hot/Cold indicator   |
      | Trajectory        | Rising/Falling arrow |

  @season @projections
  Scenario: Display season projections
    Given season is in progress
    When I view season projections
    Then I should see:
      | projection        | display              |
      | Projected Record  | Based on remaining   |
      | Playoff Odds      | Percentage chance    |
      | Projected Finish  | Expected final rank  |
    And projection confidence should be shown

  # ==========================================
  # Sorting
  # ==========================================

  @sorting @columns
  Scenario: Sort leaderboard by column
    Given I am viewing the leaderboard
    When I click on a column header
    Then table should sort by that column
    And clicking again should reverse order
    And sort indicator should show direction

  @sorting @multiple
  Scenario: Sort by multiple columns
    Given I want multi-column sorting
    When I hold Shift and click additional columns
    Then secondary sort should apply
    And sort order should be indicated (1, 2, etc.)

  @sorting @options
  Scenario: Available sorting options
    Given I want to sort the leaderboard
    Then I should be able to sort by:
      | column           | default_order        |
      | Rank             | Ascending            |
      | Points For       | Descending           |
      | Points Against   | Ascending            |
      | Record (Wins)    | Descending           |
      | Point Diff       | Descending           |
      | Streak           | Descending           |
    And Cloudscape Table sorting should be used

  @sorting @persist
  Scenario: Persist sorting preference
    Given I sort by "Points For" descending
    When I navigate away and return
    Then my sorting preference should be remembered
    And same sort should be applied

  @sorting @default
  Scenario: Default sorting order
    Given I first load the leaderboard
    Then default sort should be by Rank ascending
    And this represents official standings order

  # ==========================================
  # Filtering
  # ==========================================

  @filtering @text-search
  Scenario: Filter by team name
    Given I want to find a specific team
    When I type "Thunder" in the search filter
    Then only teams matching "Thunder" should display
    And Cloudscape TextFilter should be used
    And clear button should reset filter

  @filtering @playoff-status
  Scenario: Filter by playoff status
    Given I want to see only playoff teams
    When I select filter "Playoff Teams"
    Then only teams in playoff position should display
    And filter should update table immediately

  @filtering @division
  Scenario: Filter by division
    Given league has divisions
    When I select division filter "AFC"
    Then only AFC division teams should display
    And division filter should be a dropdown

  @filtering @record
  Scenario: Filter by record criteria
    Given I want to see winning teams
    When I apply filter "Record: Above .500"
    Then only teams with winning record should display
    And filter options should include:
      | filter              |
      | Above .500          |
      | Below .500          |
      | .500 exactly        |

  @filtering @combine
  Scenario: Combine multiple filters
    Given I apply multiple filters:
      | filter_type    | value              |
      | Division       | AFC                |
      | Playoff Status | In Contention      |
    Then only teams matching all criteria should display
    And active filters should be visible
    And "Clear All" should remove all filters

  @filtering @no-results
  Scenario: Handle no filter results
    Given I apply a filter with no matches
    When filter returns empty result
    Then empty state should display
    And message should explain no matches
    And option to clear filter should be prominent

  # ==========================================
  # Summary Cards
  # ==========================================

  @summary @stats
  Scenario: Display league summary statistics
    Given I am on the leaderboard page
    Then I should see summary cards:
      | card              | value example        |
      | League Leader     | Team Alpha (10-3)    |
      | Highest Scorer    | 1,567.8 pts          |
      | Most Points Week  | 168.4 (Week 8)       |
      | Closest Race      | 1-2 separated by 0.5 |
    And cards should use Cloudscape Container

  @summary @my-stats
  Scenario: Display my team summary
    Given I have a team in this league
    Then I should see my stats card:
      | stat              | display              |
      | My Rank           | 4th of 12            |
      | My Record         | 8-5                  |
      | Points Behind     | 45.2 behind leader   |
      | Playoff Status    | Clinched/Contending  |

  @summary @weekly-awards
  Scenario: Display weekly awards summary
    Given Week 14 has been completed
    Then I should see weekly awards:
      | award             | winner               |
      | High Score        | Team Gamma - 158.4   |
      | Biggest Blowout   | Team Delta (+52.3)   |
      | Narrowest Win     | Team Epsilon (+0.5)  |

  # ==========================================
  # Team Details
  # ==========================================

  @team-details @modal
  Scenario: View team details in modal
    Given I am viewing the leaderboard
    When I click on team "Lightning Bolts"
    Then a modal should display with:
      | section           | content              |
      | Team header       | Name, owner, record  |
      | Season stats      | Points, avg, rank    |
      | Recent matchups   | Last 5 results       |
      | Roster preview    | Top performers       |
    And Cloudscape Modal should be used

  @team-details @navigation
  Scenario: Navigate to full team page
    Given team detail modal is open
    When I click "View Full Team"
    Then I should navigate to team page
    And team page should load with context

  @team-details @head-to-head
  Scenario: View head-to-head record
    Given I am viewing another team's details
    Then I should see head-to-head vs my team:
      | data              | display              |
      | H2H Record        | 2-1                  |
      | Total Points      | 345.2 vs 312.8       |
      | Last Matchup      | Week 10: W 118-102   |

  # ==========================================
  # Pagination
  # ==========================================

  @pagination @display
  Scenario: Paginate large leaderboards
    Given league has more than 20 teams
    When pagination is needed
    Then Cloudscape Pagination should display
    And page size options should include:
      | option |
      | 10     |
      | 20     |
      | 50     |
    And total count should be shown

  @pagination @navigation
  Scenario: Navigate between pages
    Given leaderboard has multiple pages
    When I click "Next" or page number
    Then table should update to show that page
    And current page should be indicated
    And keyboard navigation should work

  @pagination @preference
  Scenario: Remember pagination preference
    Given I set page size to 50
    When I navigate away and return
    Then page size should still be 50
    And preference should persist in session

  # ==========================================
  # Export and Share
  # ==========================================

  @export @download
  Scenario: Export leaderboard data
    Given I want to save leaderboard data
    When I click export button
    Then I should have export options:
      | format   | description          |
      | CSV      | Spreadsheet format   |
      | PDF      | Printable format     |
    And export should include current view/filters

  @share @link
  Scenario: Share leaderboard view
    Given I want to share current standings
    When I click share button
    Then I should get a shareable link
    And link should preserve current view settings
    And link may require authentication to view

  @share @screenshot
  Scenario: Generate standings image
    Given I want to share standings as image
    When I select "Share as Image"
    Then image should be generated
    And image should include current standings
    And image should be downloadable/shareable

  # ==========================================
  # Real-time Updates
  # ==========================================

  @realtime @live-scores
  Scenario: Update leaderboard with live scores
    Given games are in progress
    When score updates occur
    Then leaderboard should refresh automatically
    And updates should animate smoothly
    And "Last updated" timestamp should update

  @realtime @rank-changes
  Scenario: Animate rank changes
    Given rankings change during live updates
    When my team moves from 5th to 4th
    Then row should animate to new position
    And movement should be visually indicated
    And highlight should draw attention

  @realtime @toggle
  Scenario: Toggle real-time updates
    Given I prefer manual refresh
    When I toggle "Live Updates" off
    Then automatic updates should stop
    And manual refresh button should be visible
    And toggle state should persist

  # ==========================================
  # Accessibility
  # ==========================================

  @a11y @keyboard
  Scenario: Leaderboard is keyboard navigable
    Given I am using keyboard navigation
    Then I should be able to:
      | action              | key              |
      | Navigate table rows | Arrow Up/Down    |
      | Sort columns        | Enter on header  |
      | Open team details   | Enter on row     |
      | Change pages        | Tab to pagination|

  @a11y @screen-reader
  Scenario: Leaderboard is screen reader accessible
    Given I am using a screen reader
    When I navigate the leaderboard
    Then I should hear:
      | element           | announcement           |
      | Table structure   | Row and column counts  |
      | Sort status       | Sorted by, direction   |
      | Rank positions    | Position and team      |
      | Movement          | Change from previous   |

  @a11y @focus
  Scenario: Visible focus indicators
    Given I am navigating with keyboard
    When focus moves through table
    Then focus ring should be clearly visible
    And focus should follow logical order
    And focus should not get trapped

  # ==========================================
  # Error Handling
  # ==========================================

  @error @load-failure
  Scenario: Handle data load failure
    Given API request fails
    When leaderboard cannot load
    Then error message should display
    And retry button should be available
    And Cloudscape Flashbar should show error

  @error @partial-data
  Scenario: Handle partial data availability
    Given some team data is missing
    When leaderboard loads
    Then available data should display
    And missing data should show placeholder
    And notification should explain partial load

  @error @stale-data
  Scenario: Handle stale data warning
    Given data is more than 5 minutes old
    When viewing leaderboard
    Then stale data warning should display
    And manual refresh option should be prominent
    And auto-retry may be attempted
