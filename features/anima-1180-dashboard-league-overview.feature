@dashboard @league-overview @cloudscape @frontend
Feature: Dashboard - League Overview
  As a fantasy football player
  I want to see a dashboard with my league overview
  So that I can quickly understand my standings, upcoming games, and key statistics

  Background:
    Given I am authenticated as a valid user
    And I have at least one active league
    And I navigate to the dashboard

  # ==========================================
  # Dashboard Layout
  # ==========================================

  @layout @structure
  Scenario: Display dashboard layout structure
    Given I am on the dashboard
    Then I should see the dashboard with sections:
      | section              | description                    |
      | welcome_header       | Personalized greeting          |
      | league_selector      | Switch between leagues         |
      | quick_stats          | Key statistics cards           |
      | upcoming_matchup     | Current/next matchup card      |
      | league_standings     | Standings table                |
      | recent_activity      | Activity feed                  |
      | quick_actions        | Common action buttons          |
    And layout should follow Cloudscape AppLayout pattern

  @layout @cloudscape
  Scenario: Use Cloudscape components for dashboard
    Given I am on the dashboard
    Then the following Cloudscape components should be used:
      | component         | usage                      |
      | ContentLayout     | Page structure             |
      | Container         | Section containers         |
      | Header            | Section headers            |
      | Cards             | Quick stat cards           |
      | Table             | Standings table            |
      | SpaceBetween      | Element spacing            |
      | ColumnLayout      | Grid arrangement           |
      | Box               | Content boxes              |

  @layout @responsive
  Scenario: Dashboard is responsive across devices
    Given I am on the dashboard
    When I view on different screen sizes:
      | device    | width    | columns |
      | mobile    | 375px    | 1       |
      | tablet    | 768px    | 2       |
      | desktop   | 1280px   | 3-4     |
    Then layout should adapt appropriately
    And all content should remain accessible
    And cards should stack on mobile

  @layout @loading
  Scenario: Display loading state for dashboard
    Given dashboard data is being fetched
    When the page loads
    Then skeleton loaders should display for:
      | section           |
      | quick_stats       |
      | upcoming_matchup  |
      | standings         |
      | recent_activity   |
    And Cloudscape Spinner may be shown
    And layout structure should be visible

  @layout @empty-state
  Scenario: Display empty state for new users
    Given I have no active leagues
    When I view the dashboard
    Then I should see empty state with:
      | element           | content                    |
      | illustration      | Empty state graphic        |
      | message           | No leagues yet             |
      | description       | Get started by joining...  |
      | cta_button        | Create or Join League      |
    And Cloudscape Box should be used for styling

  # ==========================================
  # League Overview
  # ==========================================

  @league-overview @selector
  Scenario: Switch between multiple leagues
    Given I am a member of multiple leagues:
      | league_name           | team_name      |
      | Championship League   | Thunder Squad  |
      | Office Pool           | Desk Warriors  |
      | Family League         | Dad's Team     |
    When I use the league selector
    Then I should see all my leagues listed
    And I can switch to view different league dashboards
    And the selected league should be highlighted

  @league-overview @current-league
  Scenario: Display current league information
    Given I have selected "Championship League"
    Then I should see league overview:
      | info                | value                    |
      | league_name         | Championship League      |
      | season              | 2024 Playoffs            |
      | my_team             | Thunder Squad            |
      | current_record      | 8-5                      |
      | playoff_status      | Clinched                 |
      | league_type         | PPR                      |

  @league-overview @status-badge
  Scenario: Display league status badges
    Given I am viewing a league
    Then appropriate status badges should display:
      | status          | badge_color | condition            |
      | In Season       | green       | Season active        |
      | Playoffs        | blue        | Playoff round        |
      | Draft Pending   | yellow      | Draft not complete   |
      | Completed       | gray        | Season ended         |
    And badges should use Cloudscape StatusIndicator

  @league-overview @playoff-bracket
  Scenario: Display playoff bracket preview
    Given my league is in playoffs
    When I view the dashboard
    Then I should see playoff bracket preview:
      | element             | display                  |
      | current_round       | Wild Card / Divisional   |
      | my_position         | Highlighted in bracket   |
      | opponent            | Current matchup opponent |
      | bracket_link        | Link to full bracket     |

  # ==========================================
  # Quick Stats Cards
  # ==========================================

  @quick-stats @cards
  Scenario: Display quick stats cards
    Given I am on the dashboard
    Then I should see quick stat cards:
      | card_title       | value_example | trend      |
      | Season Rank      | 3rd of 12     | up 2       |
      | Total Points     | 1,456.8       | +12.5%     |
      | Weekly Avg       | 112.1         | -2.3       |
      | Win Streak       | 3 games       | current    |
    And each card should use Cloudscape Container

  @quick-stats @trends
  Scenario: Display stat trends with indicators
    Given I have performance history
    When I view quick stats
    Then trends should be indicated:
      | direction | indicator         | color  |
      | up        | Arrow up icon     | green  |
      | down      | Arrow down icon   | red    |
      | neutral   | Dash icon         | gray   |
    And percentage change should be shown

  @quick-stats @comparison
  Scenario: Compare stats to league average
    Given I am viewing quick stats
    Then stats should show comparison:
      | stat              | my_value | league_avg | comparison    |
      | Points Per Game   | 112.1    | 98.5       | +13.6 above   |
      | Projected Wins    | 9        | 6.5        | +2.5 above    |
    And comparison should be visually indicated

  @quick-stats @clickable
  Scenario: Navigate to detailed stats from cards
    Given I am viewing quick stats cards
    When I click on "Total Points" card
    Then I should be navigated to detailed stats page
    And relevant stats section should be focused

  @quick-stats @real-time
  Scenario: Update stats in real-time during games
    Given games are currently in progress
    When stats update from live data
    Then quick stats should refresh automatically
    And update indicator should briefly show
    And values should animate smoothly

  # ==========================================
  # Upcoming Games / Matchups
  # ==========================================

  @matchup @current
  Scenario: Display current week matchup
    Given it is Week 15 of the season
    Then I should see current matchup:
      | element           | content                    |
      | week_label        | Week 15                    |
      | my_team           | Thunder Squad              |
      | opponent          | Lightning Bolts            |
      | my_projected      | 115.2 pts                  |
      | opp_projected     | 108.7 pts                  |
      | win_probability   | 62%                        |
    And matchup should be prominently displayed

  @matchup @live-score
  Scenario: Display live scores during game day
    Given games are currently in progress
    When I view the matchup card
    Then I should see live scores:
      | element           | content                    |
      | my_score          | 78.4 (live)                |
      | opp_score         | 65.2 (live)                |
      | players_playing   | 3 players active           |
      | players_yet       | 2 players yet to play      |
    And scores should update in real-time
    And live indicator should pulse

  @matchup @projection
  Scenario: Display matchup projection details
    Given I click on matchup projection
    Then I should see projection breakdown:
      | player           | projected | status    |
      | Patrick Mahomes  | 22.5      | Playing   |
      | Derrick Henry    | 18.2      | Playing   |
      | Tyreek Hill      | 16.8      | Bye Week  |
    And projection confidence should be shown

  @matchup @countdown
  Scenario: Display countdown to lineup lock
    Given lineup lock is approaching
    Then I should see countdown:
      | element           | content                    |
      | lock_time         | Sunday 1:00 PM ET          |
      | countdown         | 2h 34m until lock          |
      | warning           | Set your lineup!           |
    And countdown should update in real-time
    And urgency should increase as time decreases

  @matchup @schedule
  Scenario: Display upcoming schedule
    Given I want to see future matchups
    When I view schedule preview
    Then I should see next 3 weeks:
      | week    | opponent          | difficulty |
      | Week 16 | Team Alpha        | Easy       |
      | Week 17 | Team Beta         | Hard       |
      | Week 18 | Playoff TBD       | -          |
    And difficulty should be based on rankings

  @matchup @quick-actions
  Scenario: Access matchup quick actions
    Given I am viewing my matchup
    Then I should see quick action buttons:
      | action            | description              |
      | View Matchup      | Full matchup details     |
      | Edit Lineup       | Modify starting lineup   |
      | View Opponent     | See opponent's team      |
    And Cloudscape Button should be used

  # ==========================================
  # League Standings
  # ==========================================

  @standings @table
  Scenario: Display league standings table
    Given I am on the dashboard
    Then I should see standings table with columns:
      | column        | description              |
      | Rank          | Current position         |
      | Team          | Team name                |
      | Record        | W-L(-T)                  |
      | Points For    | Total points scored      |
      | Points Against| Total points allowed     |
      | Streak        | Current win/loss streak  |
    And table should use Cloudscape Table component

  @standings @highlight
  Scenario: Highlight my team in standings
    Given I am viewing standings
    Then my team row should be highlighted
    And highlight should use distinct background color
    And my position should be easily identifiable

  @standings @playoff-line
  Scenario: Indicate playoff qualification line
    Given league has 6 playoff spots
    Then standings should show:
      | position | indicator              |
      | 1-6      | Playoff position       |
      | 7-12     | Below playoff line     |
    And visual divider should separate playoff/non-playoff

  @standings @sorting
  Scenario: Sort standings by different columns
    Given I am viewing standings table
    When I click on column headers
    Then I should be able to sort by:
      | column         | sort_order |
      | Points For     | Desc/Asc   |
      | Points Against | Desc/Asc   |
      | Record         | By wins    |
    And Cloudscape Table sorting should be used

  @standings @mini-view
  Scenario: Show condensed standings on dashboard
    Given dashboard has limited space
    Then standings should show:
      | display             | content          |
      | top_3_teams         | Leaders          |
      | my_team_position    | Always visible   |
      | view_all_link       | Expand to full   |
    And full standings available via link

  @standings @movement
  Scenario: Show position movement indicators
    Given standings have changed from last week
    Then I should see movement indicators:
      | team          | movement    | indicator      |
      | Thunder Squad | Up 2        | Green arrow up |
      | Lightning     | Down 1      | Red arrow down |
      | Storm Chasers | No change   | Gray dash      |

  # ==========================================
  # Recent Activity Feed
  # ==========================================

  @activity @feed
  Scenario: Display recent activity feed
    Given there is league activity
    Then I should see activity feed with:
      | activity_type    | example                        |
      | trade            | Team A traded Player X to...   |
      | waiver           | Team B claimed Player Y        |
      | lineup_change    | Team C benched Player Z        |
      | score_update     | Week 14 final scores posted    |
      | chat_message     | New message in league chat     |

  @activity @timeline
  Scenario: Display activity in chronological order
    Given activity feed is loaded
    Then activities should be:
      | order          | description              |
      | most_recent    | At top of feed           |
      | grouped_by_day | With date headers        |
      | time_stamped   | With relative times      |
    And "2 hours ago" format should be used

  @activity @filtering
  Scenario: Filter activity by type
    Given I want to see specific activities
    When I filter by activity type
    Then I should be able to filter:
      | filter        | shows                    |
      | All           | All activity types       |
      | Trades        | Only trades              |
      | Waivers       | Only waiver claims       |
      | Transactions  | Trades + Waivers         |

  @activity @notifications
  Scenario: Show unread activity count
    Given there are unread activities
    Then activity section should show:
      | element           | content              |
      | unread_badge      | Number of unread     |
      | unread_highlight  | Unread items marked  |
    And clicking marks as read

  @activity @expand
  Scenario: Expand activity for details
    Given I see a trade activity
    When I click to expand
    Then I should see full details:
      | detail            | content                  |
      | trade_parties     | Teams involved           |
      | players_exchanged | Full player list         |
      | trade_date        | When trade occurred      |
      | trade_status      | Approved/Pending         |

  # ==========================================
  # Quick Actions
  # ==========================================

  @actions @buttons
  Scenario: Display quick action buttons
    Given I am on the dashboard
    Then I should see quick action buttons:
      | action           | icon      | destination          |
      | Set Lineup       | Roster    | Lineup editor        |
      | Add Player       | Plus      | Waiver wire          |
      | View Trades      | Exchange  | Trade center         |
      | League Chat      | Chat      | Chat interface       |
    And buttons should use Cloudscape Button component

  @actions @contextual
  Scenario: Show contextual actions based on state
    Given different league states
    Then actions should be contextual:
      | state             | primary_action           |
      | Pre-draft         | View Draft Order         |
      | Draft Active      | Go to Draft Room         |
      | Season Active     | Set Lineup               |
      | Playoffs          | View Bracket             |
      | Season Complete   | View Final Standings     |

  @actions @notifications
  Scenario: Show action required notifications
    Given I need to take action
    Then action buttons should show notifications:
      | action           | notification            |
      | Set Lineup       | Badge: "3 empty slots"  |
      | View Trades      | Badge: "1 pending"      |
      | Waiver Claims    | Badge: "2 processing"   |
    And Cloudscape Badge should be used

  # ==========================================
  # Charts and Visualizations
  # ==========================================

  @charts @performance
  Scenario: Display performance trend chart
    Given I have historical performance data
    Then I should see performance chart showing:
      | metric            | visualization          |
      | Weekly Points     | Line chart over time   |
      | League Average    | Comparison line        |
      | Projection        | Dotted future line     |
    And chart should be interactive

  @charts @comparison
  Scenario: Compare performance to opponents
    Given I want to compare with opponent
    Then comparison chart should show:
      | element           | display                |
      | My weekly scores  | Blue line              |
      | Opp weekly scores | Red line               |
      | Head-to-head      | Highlighted weeks      |

  @charts @breakdown
  Scenario: Display points breakdown chart
    Given I want to see scoring breakdown
    Then pie/bar chart should show:
      | category          | percentage    |
      | QB Points         | 22%           |
      | RB Points         | 28%           |
      | WR Points         | 32%           |
      | TE Points         | 10%           |
      | K/DEF Points      | 8%            |

  @charts @mini
  Scenario: Display mini sparkline charts
    Given dashboard cards show trends
    Then sparkline charts should show:
      | card              | sparkline              |
      | Weekly Points     | Last 5 weeks trend     |
      | Ranking           | Position over time     |
    And sparklines should be compact

  # ==========================================
  # Refresh and Real-time Updates
  # ==========================================

  @refresh @manual
  Scenario: Manually refresh dashboard data
    Given I want fresh data
    When I click refresh button
    Then all dashboard sections should refresh
    And loading indicators should show
    And data should update with latest

  @refresh @auto
  Scenario: Auto-refresh during game time
    Given games are in progress
    Then dashboard should auto-refresh:
      | data_type         | refresh_interval     |
      | live_scores       | 30 seconds           |
      | projections       | 2 minutes            |
      | standings         | 5 minutes            |
    And refresh should not interrupt user

  @refresh @websocket
  Scenario: Receive real-time updates via WebSocket
    Given WebSocket connection is established
    When score update occurs
    Then update should push to dashboard
    And no manual refresh needed
    And update animation should indicate new data

  # ==========================================
  # Personalization
  # ==========================================

  @personalization @greeting
  Scenario: Display personalized greeting
    Given I am logged in as "John"
    Then I should see personalized greeting:
      | time_of_day | greeting                |
      | Morning     | Good morning, John      |
      | Afternoon   | Good afternoon, John    |
      | Evening     | Good evening, John      |
    And greeting should feel welcoming

  @personalization @favorites
  Scenario: Pin favorite league to dashboard
    Given I have multiple leagues
    When I set "Championship League" as favorite
    Then it should be default dashboard view
    And it should appear first in league selector

  @personalization @layout
  Scenario: Customize dashboard layout
    Given I want to customize my view
    When I access dashboard settings
    Then I should be able to:
      | customization       | options              |
      | Reorder sections    | Drag and drop        |
      | Hide sections       | Toggle visibility    |
      | Resize cards        | Compact/expanded     |
    And preferences should persist

  # ==========================================
  # Error Handling
  # ==========================================

  @error @data-fetch
  Scenario: Handle data fetch errors gracefully
    Given API request fails
    When dashboard tries to load
    Then error state should show:
      | element           | content                |
      | error_message     | Unable to load data    |
      | retry_button      | Try Again              |
      | partial_data      | Show cached if available|
    And Cloudscape Flashbar should display error

  @error @partial-load
  Scenario: Handle partial data load
    Given some sections fail to load
    When dashboard renders
    Then successful sections should display
    And failed sections should show:
      | element           | content                |
      | error_indicator   | Could not load         |
      | retry_option      | Retry this section     |

  @error @offline
  Scenario: Handle offline state
    Given I lose network connection
    When dashboard cannot refresh
    Then I should see:
      | element           | content                |
      | offline_indicator | You are offline        |
      | cached_data       | Last updated data      |
      | reconnect_message | Will refresh when online|

  # ==========================================
  # Accessibility
  # ==========================================

  @a11y @keyboard
  Scenario: Dashboard is keyboard navigable
    Given I am using keyboard navigation
    When I navigate the dashboard
    Then I should be able to:
      | action            | key              |
      | Navigate sections | Tab              |
      | Activate buttons  | Enter/Space      |
      | Navigate tables   | Arrow keys       |
      | Close modals      | Escape           |

  @a11y @screen-reader
  Scenario: Dashboard is screen reader accessible
    Given I am using a screen reader
    When I navigate the dashboard
    Then I should hear:
      | element           | announcement           |
      | Section headers   | Section purpose        |
      | Stat values       | Value and context      |
      | Updates           | New content alerts     |
      | Errors            | Error messages         |

  @a11y @contrast
  Scenario: Charts meet accessibility standards
    Given I view dashboard charts
    Then charts should:
      | requirement       | implementation         |
      | Color contrast    | WCAG AA compliant      |
      | Pattern usage     | Not color-only         |
      | Alt text          | Describe data          |
      | Keyboard access   | Navigate data points   |
