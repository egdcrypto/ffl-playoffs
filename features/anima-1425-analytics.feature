@backend @priority_2 @analytics
Feature: Analytics System
  As a fantasy football playoffs application
  I want to provide comprehensive analytics across users, leagues, teams, players, and games
  So that users can gain insights, make informed decisions, and track performance

  Background:
    Given a league "2025 NFL Playoffs Pool" exists
    And the league has completed multiple seasons with rich historical data
    And analytics services are enabled and configured

  # ==================== USER ANALYTICS ====================

  Scenario: View user engagement analytics
    Given player "john_doe" has been active in the platform
    When viewing user engagement analytics for john_doe
    Then engagement metrics show:
      | Metric                    | Value          | Trend     |
      | Sessions This Month       | 45             | +12%      |
      | Average Session Duration  | 8.5 minutes    | +2.3 min  |
      | Pages Per Session         | 6.2            | +0.8      |
      | Last Active               | 2 hours ago    | -         |
      | Login Streak              | 15 days        | Current   |
    And engagement trends are visualized over time

  Scenario: Track user activity patterns
    Given user activity is being monitored
    When analyzing john_doe's activity patterns
    Then patterns show:
      | Pattern               | Value                    |
      | Most Active Day       | Sunday                   |
      | Most Active Hour      | 7:00 PM - 9:00 PM        |
      | Peak Activity Season  | January (playoffs)       |
      | Feature Most Used     | Live Scoring             |
      | Average Response Time | Within 5 min of updates  |
    And heatmap of activity is available

  Scenario: Analyze user retention metrics
    Given the platform tracks user retention
    When viewing retention analytics
    Then retention metrics show:
      | Cohort          | Week 1 | Week 4 | Week 8 | Week 12 |
      | Jan 2024        | 100%   | 85%    | 72%    | 65%     |
      | Feb 2024        | 100%   | 82%    | 68%    | 60%     |
      | Mar 2024        | 100%   | 88%    | 75%    | 70%     |
    And churn risk indicators are highlighted

  Scenario: Track user feature adoption
    Given new features have been released
    When viewing feature adoption analytics
    Then adoption metrics show:
      | Feature              | Adoption Rate | Avg Time to Adopt | Power Users |
      | Mobile App           | 78%           | 3 days            | 245         |
      | Push Notifications   | 65%           | 5 days            | 180         |
      | Custom Scoring       | 42%           | 7 days            | 95          |
      | Social Sharing       | 35%           | 10 days           | 72          |
    And adoption funnel is visualized

  Scenario: Generate user behavior reports
    Given comprehensive user data is available
    When generating user behavior report for Q1 2024
    Then the report includes:
      | Section                | Metrics                           |
      | User Growth            | New signups, activation rate      |
      | Engagement Trends      | DAU, WAU, MAU, session metrics    |
      | Feature Usage          | Top features, adoption rates      |
      | User Segments          | Casual, regular, power users      |
      | Churn Analysis         | At-risk users, churn reasons      |

  # ==================== LEAGUE ANALYTICS ====================

  Scenario: View league performance overview
    Given the league has completed seasons
    When viewing league analytics dashboard
    Then league metrics show:
      | Metric                    | Current Season | All-Time  |
      | Total Players             | 12             | 45 unique |
      | Active Participation Rate | 95%            | 88%       |
      | Average Weekly Score      | 145.2          | 138.5     |
      | Competitive Balance Index | 0.82           | 0.78      |
      | Transaction Activity      | High           | Medium    |
    And league health indicators are displayed

  Scenario: Analyze league scoring trends
    Given scoring data is available across seasons
    When analyzing league scoring trends
    Then trends show:
      | Season | Avg Score | High Score | Low Score | Std Dev |
      | 2024   | 145.2     | 185.3      | 98.5      | 18.5    |
      | 2023   | 138.5     | 175.0      | 92.0      | 20.2    |
      | 2022   | 142.8     | 168.5      | 105.2     | 15.8    |
    And scoring distribution charts are available

  Scenario: Track league competitive balance
    Given competitive metrics are calculated
    When viewing competitive balance analytics
    Then balance metrics show:
      | Metric                      | Value   | Assessment    |
      | Gini Coefficient            | 0.28    | Well Balanced |
      | Top-Heavy Index             | 0.15    | Healthy       |
      | Win Distribution Variance   | 2.5     | Normal        |
      | Blowout Percentage          | 12%     | Acceptable    |
      | Close Game Percentage       | 35%     | Good          |
    And recommendations for improving balance are provided

  Scenario: Analyze league transaction patterns
    Given transaction history is available
    When viewing transaction analytics
    Then transaction metrics show:
      | Type           | Count | Avg Per Week | Most Active User |
      | Trades         | 24    | 2.0          | jane_doe         |
      | Waiver Claims  | 85    | 7.1          | bob_player       |
      | Free Agent Add | 120   | 10.0         | john_doe         |
      | Drops          | 145   | 12.1         | alice_player     |
    And transaction timing patterns are shown

  Scenario: Compare league to platform averages
    Given platform-wide data is available
    When comparing league to platform benchmarks
    Then comparison shows:
      | Metric                | League Value | Platform Avg | Percentile |
      | Engagement Rate       | 95%          | 78%          | 92nd       |
      | Avg Score             | 145.2        | 138.0        | 75th       |
      | Transaction Volume    | High         | Medium       | 85th       |
      | Completion Rate       | 100%         | 82%          | 95th       |
    And improvement suggestions are provided

  # ==================== TEAM ANALYTICS ====================

  Scenario: View team performance dashboard
    Given player "john_doe" wants team analytics
    When viewing john_doe's team analytics
    Then team metrics show:
      | Metric                    | Value    | League Rank | Trend   |
      | Total Points              | 1,520.5  | 1st         | +8.2%   |
      | Points Per Game           | 108.6    | 1st         | +5.5%   |
      | Win Percentage            | 85.7%    | 1st         | +10%    |
      | Consistency Score         | 0.88     | 2nd         | +0.05   |
      | Efficiency Rating         | 1.15     | 1st         | +0.08   |
    And historical performance chart is displayed

  Scenario: Analyze team roster composition
    Given roster data is available
    When analyzing john_doe's roster composition
    Then composition analysis shows:
      | Position | Points Share | Efficiency | Value Rating |
      | QB       | 22%          | A          | Elite        |
      | RB       | 28%          | B+         | Above Avg    |
      | WR       | 32%          | A-         | Strong       |
      | TE       | 10%          | B          | Average      |
      | K        | 4%           | A          | Elite        |
      | DEF      | 4%           | B+         | Above Avg    |
    And roster optimization suggestions are provided

  Scenario: Track team weekly performance
    Given weekly performance data exists
    When viewing team weekly analytics
    Then weekly breakdown shows:
      | Week       | Score  | Rank | Best Player    | Worst Player  |
      | Wild Card  | 145.0  | 3rd  | Mahomes (32.5) | K (5.0)       |
      | Divisional | 152.8  | 2nd  | Henry (28.0)   | DEF (4.5)     |
      | Conference | 165.2  | 1st  | Hill (35.5)    | TE (8.0)      |
      | Super Bowl | 178.5  | 1st  | Mahomes (38.0) | K (7.5)       |
    And performance consistency is graded

  Scenario: Analyze team draft effectiveness
    Given draft and performance data are linked
    When analyzing draft effectiveness for john_doe
    Then draft analytics show:
      | Pick   | Player     | Projected | Actual  | Value Add |
      | 1.01   | CMC        | 285.0     | 310.5   | +25.5     |
      | 2.12   | Andrews    | 145.0     | 155.2   | +10.2     |
      | 3.01   | Hill       | 210.0     | 235.8   | +25.8     |
      | 4.12   | Mahomes    | 280.0     | 295.0   | +15.0     |
    And overall draft grade is calculated

  Scenario: Compare team to opponents
    Given matchup data is available
    When comparing john_doe to past opponents
    Then comparison shows:
      | Opponent     | Record | Avg Margin | Strength | Next Proj |
      | jane_doe     | 4-2    | +5.8       | Strong   | Favored   |
      | bob_player   | 5-3    | +8.2       | Medium   | Favored   |
      | alice_player | 3-1    | +12.5      | Medium   | Favored   |
    And strength of schedule is calculated

  # ==================== PLAYER ANALYTICS (NFL PLAYERS) ====================

  Scenario: View NFL player performance analytics
    Given NFL player data is tracked
    When viewing analytics for Patrick Mahomes
    Then player metrics show:
      | Metric                | Season Avg | Playoff Avg | Peak Game |
      | Fantasy Points        | 24.5       | 28.5        | 42.5      |
      | Passing Yards         | 285.0      | 310.5       | 385       |
      | Passing TDs           | 2.2        | 2.8         | 4         |
      | Interceptions         | 0.8        | 0.5         | 2         |
      | Consistency Rating    | 0.85       | 0.92        | -         |
    And game log with trends is available

  Scenario: Analyze player ownership trends
    Given ownership data is tracked
    When viewing ownership analytics for Patrick Mahomes
    Then ownership trends show:
      | Week       | Ownership % | Trend    | Avg Points When Owned |
      | Week 1     | 45%         | -        | 25.5                  |
      | Week 2     | 52%         | +7%      | 28.0                  |
      | Week 3     | 58%         | +6%      | 32.5                  |
      | Week 4     | 65%         | +7%      | 35.0                  |
    And ownership correlation with performance is shown

  Scenario: Compare players at same position
    Given multiple players at position exist
    When comparing QBs in the league
    Then comparison shows:
      | Player        | Owner      | PPG   | Ceiling | Floor | Boom % |
      | P. Mahomes    | john_doe   | 28.5  | 42.5    | 15.0  | 45%    |
      | J. Allen      | jane_doe   | 26.8  | 40.0    | 12.5  | 42%    |
      | L. Jackson    | bob_player | 25.2  | 38.5    | 14.0  | 38%    |
    And statistical comparison charts are available

  Scenario: Analyze player matchup history
    Given NFL game data is available
    When analyzing Patrick Mahomes vs specific defenses
    Then matchup analysis shows:
      | Defense     | Games | Avg Points | Best Game | Worst Game |
      | vs Raiders  | 8     | 32.5       | 42.0      | 22.5       |
      | vs Broncos  | 8     | 28.0       | 38.5      | 18.0       |
      | vs Chargers | 8     | 30.2       | 40.0      | 20.5       |
      | vs Bills    | 4     | 26.5       | 35.0      | 18.5       |
    And favorable/unfavorable matchups are highlighted

  Scenario: Track player value over time
    Given historical value data exists
    When viewing player value trends
    Then value analytics show:
      | Player     | Draft Value | Current Value | ROI    | Trend   |
      | CMC        | 1.01        | 1.01          | 0%     | Stable  |
      | Mahomes    | 4.12        | 2.05          | +150%  | Rising  |
      | Andrews    | 2.12        | 3.08          | -35%   | Falling |
    And value projections are provided

  # ==================== GAME ANALYTICS ====================

  Scenario: View game performance breakdown
    Given game data is available
    When viewing analytics for Wild Card round
    Then game analytics show:
      | Metric                    | Value     |
      | Total Points Scored       | 1,742.5   |
      | Highest Individual Score  | 185.3     |
      | Lowest Individual Score   | 98.5      |
      | Average Score             | 145.2     |
      | Closest Matchup           | 0.5 pts   |
      | Largest Blowout           | 45.2 pts  |
    And game flow visualizations are available

  Scenario: Analyze scoring distribution by game
    Given detailed game scoring exists
    When analyzing scoring distribution
    Then distribution shows:
      | Score Range | Count | Percentage | Outcome    |
      | 180+        | 2     | 8%         | 100% Win   |
      | 160-179     | 5     | 21%        | 80% Win    |
      | 140-159     | 8     | 33%        | 62% Win    |
      | 120-139     | 6     | 25%        | 33% Win    |
      | Below 120   | 3     | 13%        | 0% Win     |
    And histogram visualization is provided

  Scenario: Track game momentum shifts
    Given live game data is tracked
    When viewing game momentum analytics
    Then momentum analysis shows:
      | Time Period      | Leader    | Margin | Key Play               |
      | Q1 (0-15 min)    | john_doe  | +5.5   | Mahomes TD pass        |
      | Q2 (15-30 min)   | jane_doe  | +2.0   | Jefferson 60-yd TD     |
      | Q3 (30-45 min)   | john_doe  | +8.5   | Henry rushing TD       |
      | Q4 (45-60 min)   | john_doe  | +13.3  | Kelce 2 TDs            |
    And momentum chart shows lead changes

  Scenario: Analyze optimal lineup decisions
    Given actual vs optimal data exists
    When viewing optimal lineup analytics
    Then analysis shows:
      | Player     | Actual Points | Optimal Points | Efficiency |
      | john_doe   | 178.5         | 195.2          | 91.5%      |
      | jane_doe   | 165.2         | 188.5          | 87.6%      |
      | bob_player | 143.2         | 172.0          | 83.3%      |
    And missed opportunities are highlighted

  Scenario: View historical game statistics
    Given historical game data is comprehensive
    When viewing all-time game statistics
    Then statistics show:
      | Record                     | Value    | Game Details          |
      | Highest Scoring Game       | 343.7    | john_doe vs jane_doe  |
      | Lowest Scoring Game        | 198.5    | player5 vs player8    |
      | Most Lopsided              | 65.2 pts | bob_player vs player7 |
      | Most Lead Changes          | 12       | jane_doe vs alice     |
      | Longest Win Streak         | 8 games  | john_doe (2024)       |

  # ==================== PLATFORM ANALYTICS ====================

  Scenario: View platform usage dashboard
    Given platform-wide metrics are tracked
    When viewing platform analytics dashboard
    Then metrics show:
      | Metric                    | Value        | Change (MoM) |
      | Total Users               | 15,420       | +8.5%        |
      | Active Users (Monthly)    | 12,350       | +12.2%       |
      | Total Leagues             | 2,850        | +5.3%        |
      | Daily Active Users        | 4,520        | +15.0%       |
      | API Calls (Daily)         | 2.5M         | +22.0%       |
    And trend charts show growth over time

  Scenario: Analyze platform performance metrics
    Given performance monitoring is active
    When viewing platform performance analytics
    Then performance metrics show:
      | Metric                    | Value    | SLA Target | Status |
      | API Response Time (p95)   | 125ms    | 200ms      | Good   |
      | Uptime (30 days)          | 99.95%   | 99.9%      | Good   |
      | Error Rate                | 0.02%    | 0.1%       | Good   |
      | Concurrent Users (Peak)   | 8,500    | 10,000     | Good   |
      | Database Query Time (avg) | 15ms     | 50ms       | Good   |
    And performance alerts are configured

  Scenario: Track platform revenue analytics
    Given revenue data is available
    When viewing revenue analytics
    Then revenue metrics show:
      | Metric                    | Current Month | YoY Change |
      | Total Revenue             | $45,250       | +28%       |
      | Premium Subscriptions     | 1,250         | +35%       |
      | ARPU                      | $3.65         | +12%       |
      | Conversion Rate           | 8.1%          | +1.2%      |
      | Churn Rate                | 2.5%          | -0.8%      |
    And revenue breakdown by source is shown

  Scenario: Analyze platform feature usage
    Given feature tracking is enabled
    When viewing feature usage analytics
    Then usage metrics show:
      | Feature             | Daily Users | Usage Rate | Satisfaction |
      | Live Scoring        | 8,500       | 68.9%      | 4.5/5        |
      | Roster Management   | 7,200       | 58.4%      | 4.2/5        |
      | League Chat         | 4,500       | 36.5%      | 4.0/5        |
      | Trade Center        | 3,200       | 26.0%      | 3.8/5        |
      | Analytics Dashboard | 2,800       | 22.7%      | 4.3/5        |
    And feature improvement suggestions are prioritized

  Scenario: Monitor platform health indicators
    Given health monitoring is configured
    When viewing platform health analytics
    Then health indicators show:
      | Component           | Status  | Last Check | Issues |
      | API Gateway         | Healthy | 30s ago    | 0      |
      | Database Cluster    | Healthy | 30s ago    | 0      |
      | Cache Layer         | Healthy | 30s ago    | 0      |
      | Message Queue       | Warning | 30s ago    | 1      |
      | External APIs       | Healthy | 60s ago    | 0      |
    And historical health trends are available

  # ==================== CUSTOM REPORTS ====================

  Scenario: Create custom analytics report
    Given user has report builder access
    When creating a custom report with:
      | Parameter    | Selection                        |
      | Metrics      | Points, Wins, Transactions       |
      | Dimensions   | Week, Player, Position           |
      | Filters      | Season = 2024, League = Current  |
      | Grouping     | By Week                          |
      | Sort         | Points Descending                |
    Then the custom report is generated
    And report can be saved for future use
    And report can be scheduled for delivery

  Scenario: Generate comparative analysis report
    Given multiple data sources are available
    When generating comparative report:
      | Comparison Type | Season over Season         |
      | Subjects        | john_doe, jane_doe         |
      | Metrics         | All performance metrics    |
      | Time Period     | 2023 vs 2024               |
    Then side-by-side comparison is generated
    And statistical significance is indicated
    And key differences are highlighted

  Scenario: Build league summary report
    Given league season is complete
    When generating end-of-season report
    Then report sections include:
      | Section              | Contents                           |
      | Executive Summary    | Key highlights and superlatives    |
      | Final Standings      | Complete standings with stats      |
      | MVP Analysis         | Top performers by various metrics  |
      | Season Timeline      | Major events and milestones        |
      | Statistical Leaders  | Category leaders                   |
      | Awards               | Custom league awards               |
      | Year in Review       | Memorable moments                  |

  Scenario: Create player scouting report
    Given detailed player data exists
    When generating scouting report for a player
    Then report includes:
      | Section              | Analysis                           |
      | Performance Summary  | Overall stats and grades           |
      | Strengths            | Top performing areas               |
      | Weaknesses           | Areas needing improvement          |
      | Trend Analysis       | Performance trajectory             |
      | Matchup Analysis     | Performance vs opponent types      |
      | Projection           | Expected future performance        |
    And comparable players are suggested

  Scenario: Schedule automated reports
    Given reporting automation is available
    When scheduling a weekly report:
      | Setting      | Value                          |
      | Report Type  | Weekly Performance Summary     |
      | Schedule     | Every Monday at 9:00 AM        |
      | Recipients   | League Members                 |
      | Format       | PDF and Email Summary          |
    Then reports are automatically generated on schedule
    And delivery is confirmed
    And schedule can be modified

  # ==================== DATA VISUALIZATION ====================

  Scenario: View interactive performance charts
    Given visualization tools are available
    When viewing performance charts
    Then available chart types include:
      | Chart Type        | Best For                        |
      | Line Chart        | Trends over time                |
      | Bar Chart         | Comparisons between categories  |
      | Scatter Plot      | Correlation analysis            |
      | Heatmap           | Pattern identification          |
      | Radar Chart       | Multi-dimensional comparison    |
    And charts are interactive with hover details

  Scenario: Create custom dashboard
    Given dashboard builder is available
    When creating custom dashboard with:
      | Widget               | Position | Size   |
      | Score Trend Chart    | Top Left | Large  |
      | Standings Table      | Top Right| Medium |
      | Recent Activity Feed | Bottom   | Full   |
      | Quick Stats Cards    | Sidebar  | Small  |
    Then dashboard is assembled and displayed
    And layout can be saved and shared

  Scenario: Generate infographic summary
    Given infographic generator is available
    When generating season infographic
    Then infographic includes:
      | Element              | Content                          |
      | Header               | Season and league branding       |
      | Champion Spotlight   | Winner with key stats            |
      | League Stats         | Interesting numbers              |
      | Records Set          | New records this season          |
      | Fun Facts            | Quirky statistics                |
    And infographic is shareable on social media

  Scenario: Display real-time score visualization
    Given games are in progress
    When viewing live score visualization
    Then visualization shows:
      | Element              | Update Frequency |
      | Live Scores          | Every 10 seconds |
      | Scoring Plays        | Real-time        |
      | Projection Updates   | Every minute     |
      | Win Probability      | After each play  |
      | Momentum Indicator   | Every 30 seconds |
    And animations highlight scoring plays

  Scenario: Export visualizations
    Given visualizations are created
    When exporting chart visualizations
    Then export options include:
      | Format    | Quality      | Use Case          |
      | PNG       | High (300dpi)| Presentations     |
      | SVG       | Vector       | Web/Print         |
      | PDF       | Print-ready  | Reports           |
      | Interactive| Web Embed   | Sharing Online    |
    And exports maintain visual fidelity

  # ==================== PREDICTIVE ANALYTICS ====================

  Scenario: Generate score projections
    Given historical and current data are available
    When generating score projections
    Then projections show:
      | Player       | Projected Score | Confidence | Range        |
      | john_doe     | 155.2           | 78%        | 140.5-170.0  |
      | jane_doe     | 148.5           | 72%        | 132.0-165.0  |
      | bob_player   | 142.0           | 70%        | 125.5-158.5  |
    And projection methodology is explained

  Scenario: Calculate win probability
    Given matchup data and projections exist
    When calculating win probability for john_doe vs jane_doe
    Then probability analysis shows:
      | Outcome              | Probability | Key Factor          |
      | john_doe Win         | 62%         | QB advantage        |
      | jane_doe Win         | 38%         | WR ceiling          |
      | Margin > 10 pts      | 35%         | Consistency         |
      | Margin < 5 pts       | 28%         | Similar rosters     |
    And probability factors are broken down

  Scenario: Predict playoff outcomes
    Given playoff bracket is set
    When running playoff simulations
    Then simulation results show:
      | Player       | Win Championship | Make Finals | First Round Exit |
      | john_doe     | 28%              | 45%         | 15%              |
      | jane_doe     | 22%              | 38%         | 18%              |
      | bob_player   | 18%              | 32%         | 22%              |
    And simulation is based on 10,000 iterations

  Scenario: Identify breakout candidates
    Given player performance data is analyzed
    When identifying breakout candidates
    Then candidates show:
      | Player         | Current Rank | Breakout Prob | Key Indicator      |
      | Tank Dell      | WR42         | 72%           | Target share trend |
      | Jahmyr Gibbs   | RB18         | 65%           | Snap count increase|
      | Evan Engram    | TE8          | 58%           | Red zone targets   |
    And supporting statistics are provided

  Scenario: Forecast trade values
    Given trade market data is available
    When forecasting player trade values
    Then value projections show:
      | Player        | Current Value | Proj Value (4 wk) | Recommendation |
      | CMC           | Elite         | Elite             | Hold           |
      | Mark Andrews  | Above Avg     | Average           | Sell High      |
      | Tank Dell     | Average       | Above Avg         | Buy Low        |
    And value trends are visualized

  Scenario: Generate waiver wire recommendations
    Given available players and team needs exist
    When generating waiver recommendations for john_doe
    Then recommendations show:
      | Player         | Proj Points | Availability | Fit Score | Priority |
      | Romeo Doubs    | 12.5        | 85%          | 92        | 1        |
      | Jaylen Warren  | 10.8        | 72%          | 88        | 2        |
      | Dalton Schultz | 8.5         | 95%          | 78        | 3        |
    And recommendations factor in team composition

  # ==================== REAL-TIME ANALYTICS ====================

  Scenario: View live scoring analytics
    Given NFL games are in progress
    When viewing real-time scoring analytics
    Then live metrics show:
      | Metric                    | Value           | Update Freq |
      | Current Scores            | All matchups    | 10 seconds  |
      | Points Remaining (Proj)   | Per player      | 1 minute    |
      | Win Probability           | Live            | Per play    |
      | Scoring Leader            | Current         | 30 seconds  |
      | Biggest Mover             | Last 5 minutes  | 1 minute    |
    And alerts notify of significant events

  Scenario: Track live leaderboard changes
    Given scoring is in progress
    When viewing live leaderboard analytics
    Then leaderboard shows:
      | Rank | Player       | Score  | Change | Trend     |
      | 1    | john_doe     | 85.5   | +12.5  | Rising    |
      | 2    | jane_doe     | 78.2   | +5.0   | Stable    |
      | 3    | bob_player   | 75.0   | +8.5   | Rising    |
    And rank change animations are displayed

  Scenario: Monitor scoring pace analysis
    Given partial scoring data exists
    When viewing scoring pace analytics
    Then pace analysis shows:
      | Player       | Current | Pace     | Proj Final | On Track For |
      | john_doe     | 85.5    | 171.0    | 165.5      | Season High  |
      | jane_doe     | 78.2    | 156.4    | 152.0      | Above Avg    |
      | bob_player   | 75.0    | 150.0    | 148.5      | Average      |
    And pace trends are visualized

  Scenario: Receive real-time alerts
    Given alert preferences are configured
    When scoring events occur
    Then alerts are triggered for:
      | Event Type              | Condition            | Delivery   |
      | Lead Change             | Any lead change      | Push       |
      | Big Play                | 20+ point play       | Push       |
      | Projection Change       | 10+ point swing      | In-App     |
      | Player Injury           | Any injury report    | Push       |
      | Final Score             | Game ends            | Push/Email |
    And alerts are delivered within 30 seconds

  Scenario: Analyze real-time performance vs projection
    Given projections and live scores exist
    When comparing real-time performance to projections
    Then analysis shows:
      | Player       | Projected | Actual (So Far) | Pace vs Proj | Status       |
      | john_doe     | 155.0     | 85.5 (50%)      | +8%          | Exceeding    |
      | jane_doe     | 148.0     | 78.2 (55%)      | -5%          | Below        |
      | bob_player   | 142.0     | 75.0 (52%)      | +2%          | On Track     |
    And variance explanations are provided

  Scenario: Stream analytics data via API
    Given real-time API is available
    When subscribing to analytics stream
    Then streaming data includes:
      | Data Type              | Format    | Latency   |
      | Score Updates          | JSON      | < 5 sec   |
      | Stat Changes           | JSON      | < 10 sec  |
      | Projection Updates     | JSON      | < 30 sec  |
      | Alert Events           | JSON      | < 5 sec   |
    And WebSocket connection is maintained

  # ==================== ANALYTICS PERMISSIONS AND PRIVACY ====================

  Scenario: Enforce analytics access levels
    Given different user roles exist
    When users access analytics
    Then access is controlled:
      | Role         | Personal Analytics | League Analytics | Platform Analytics |
      | Player       | Full               | Limited          | None               |
      | League Admin | Full               | Full             | None               |
      | Super Admin  | Full               | Full             | Full               |
    And unauthorized access attempts are logged

  Scenario: Anonymize analytics data for privacy
    Given privacy settings are configured
    When generating aggregated analytics
    Then data is anonymized:
      | Data Type              | Anonymization Method       |
      | Individual Scores      | Aggregated only            |
      | User Behavior          | Pseudonymized              |
      | Personal Stats         | Owner-only access          |
      | Comparative Rankings   | Opt-in only                |
    And privacy compliance is maintained

  # ==================== ANALYTICS DATA QUALITY ====================

  Scenario: Validate analytics data accuracy
    Given analytics data is generated
    When validating data accuracy
    Then validation checks:
      | Check Type             | Status  | Details            |
      | Score Reconciliation   | Pass    | Matches source     |
      | Calculation Accuracy   | Pass    | Within 0.01%       |
      | Data Completeness      | Pass    | No missing records |
      | Timestamp Accuracy     | Pass    | Synced correctly   |
    And discrepancies are flagged for review

  Scenario: Handle analytics data gaps
    Given some data is incomplete
    When generating analytics with gaps
    Then handling includes:
      | Situation              | Response                   |
      | Missing Score Data     | Use projection estimate    |
      | Incomplete Game Data   | Mark as partial            |
      | Historical Gaps        | Note data unavailable      |
      | Real-time Delays       | Show last known + age      |
    And data quality indicators are displayed
