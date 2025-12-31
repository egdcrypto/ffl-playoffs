@backend @priority_1 @players @data
Feature: Comprehensive Players System
  As a fantasy football playoffs application
  I want to provide detailed player information, search, and tracking capabilities
  So that users can make informed decisions about their roster selections

  Background:
    Given a league "2025 NFL Playoffs Pool" exists
    And NFL player data is available from the data source
    And the game has 4 weeks (Wild Card, Divisional, Conference, Super Bowl)

  # ==================== PLAYER PROFILES ====================

  Scenario: Display player profile with basic information
    Given a user wants to view Patrick Mahomes profile
    When the user navigates to the player profile
    Then the profile displays:
      | Field           | Value              |
      | Name            | Patrick Mahomes    |
      | Position        | QB                 |
      | Team            | Kansas City Chiefs |
      | Jersey Number   | 15                 |
      | Age             | 29                 |
      | Height          | 6'3"               |
      | Weight          | 225 lbs            |
      | College         | Texas Tech         |
      | Experience      | 7 years            |
      | Draft           | 2017, Round 1, Pick 10 |

  Scenario: Display player career statistics
    Given a user is viewing Travis Kelce's profile
    When the user views career statistics
    Then career stats are displayed:
      | Season | Games | Receptions | Yards | TDs  | Avg   |
      | 2024   | 17    | 97         | 1,029 | 9    | 10.6  |
      | 2023   | 15    | 93         | 984   | 5    | 10.6  |
      | 2022   | 17    | 110        | 1,338 | 12   | 12.2  |
      | Career | 156   | 908        | 11,328| 74   | 12.5  |

  Scenario: Display player playoff statistics
    Given a user is viewing player playoff history
    When the user selects "Playoff Stats" tab
    Then playoff career stats are shown:
      | Player           | Playoff Games | Playoff TDs | Avg Points/Game |
      | Patrick Mahomes  | 18            | 45          | 26.5            |
      | Travis Kelce     | 22            | 19          | 14.2            |
    And playoff performance trends are visualized

  Scenario: Display player contract information
    Given a user wants contract details
    When viewing contract information for Josh Allen
    Then contract details show:
      | Field              | Value           |
      | Contract Length    | 6 years         |
      | Total Value        | $258 million    |
      | Average Annual     | $43 million     |
      | Guaranteed         | $150 million    |
      | Contract End       | 2028            |
      | Cap Hit (2025)     | $39.5 million   |

  Scenario: Display player fantasy history
    Given a user wants fantasy performance history
    When viewing fantasy history for Derrick Henry
    Then fantasy stats are shown by season:
      | Season | Games | Fantasy Points | PPG   | Position Rank |
      | 2024   | 17    | 285.5          | 16.8  | RB4           |
      | 2023   | 17    | 248.0          | 14.6  | RB8           |
      | 2022   | 16    | 312.0          | 19.5  | RB2           |
    And scoring format toggle allows PPR/Standard view

  Scenario: Display player photo and team branding
    Given a user views any player profile
    When the profile loads
    Then the player headshot is displayed
    And team logo and colors are shown
    And the background reflects team branding

  Scenario: Display player social media links
    Given a user wants to follow players on social media
    When viewing player profile
    Then social links are available:
      | Platform  | Available |
      | Twitter/X | Yes       |
      | Instagram | Yes       |
      | TikTok    | Yes       |
    And links open in new tabs

  # ==================== PLAYER SEARCH ====================

  Scenario: Search players by name
    Given a user wants to find a specific player
    When the user searches for "Mahomes"
    Then search results show:
      | Player           | Position | Team |
      | Patrick Mahomes  | QB       | KC   |
    And results are returned within 500ms

  Scenario: Search players with partial name match
    Given a user searches with partial input
    When the user types "Trav"
    Then autocomplete suggests:
      | Player           | Position | Team |
      | Travis Kelce     | TE       | KC   |
      | Travis Etienne   | RB       | JAX  |
      | Travon Walker    | DE       | JAX  |
    And suggestions update as user types

  Scenario: Search players by team
    Given a user wants all players from a team
    When the user filters by team "Kansas City Chiefs"
    Then all Chiefs players are displayed:
      | Player           | Position |
      | Patrick Mahomes  | QB       |
      | Travis Kelce     | TE       |
      | Isiah Pacheco    | RB       |
      | Rashee Rice      | WR       |
    And results are sortable by position

  Scenario: Search players by position
    Given a user wants players at a specific position
    When the user filters by position "RB"
    Then all playoff-eligible running backs are shown
    And results are sortable by projected points
    And pagination handles large result sets

  Scenario: Advanced player search with multiple filters
    Given a user needs specific player criteria
    When the user applies filters:
      | Filter           | Value              |
      | Position         | WR                 |
      | Team             | Any Playoff Team   |
      | Min Projected    | 12.0 points        |
      | Injury Status    | Healthy            |
    Then only matching players are displayed
    And filter summary is shown
    And filters can be saved for reuse

  Scenario: Search players by college
    Given a user wants players from a specific college
    When the user searches by college "Alabama"
    Then Alabama alumni in playoffs are shown:
      | Player           | Position | Team | College Years |
      | Derrick Henry    | RB       | BAL  | 2013-2015     |
      | Jaylen Waddle    | WR       | MIA  | 2018-2020     |
    And college stats are available

  Scenario: Search players currently available
    Given a user is making roster decisions
    When the user searches for available players
    Then only unrostered players are shown
    And ownership percentage is displayed
    And "Add to Roster" action is available

  Scenario: Search with no results handling
    Given a user searches for non-existent player
    When the user searches for "XXXXXX"
    Then a "No players found" message is displayed
    And suggestions for similar searches are offered
    And recent searches are shown

  # ==================== PLAYER STATS ====================

  Scenario: Display current season statistics
    Given a user views player statistics
    When viewing Ja'Marr Chase's 2024 stats
    Then season stats are displayed:
      | Stat Category    | Value  |
      | Games Played     | 17     |
      | Receptions       | 117    |
      | Receiving Yards  | 1,708  |
      | Yards/Reception  | 14.6   |
      | Touchdowns       | 17     |
      | Targets          | 158    |
      | Catch Rate       | 74.1%  |

  Scenario: Display game-by-game statistics
    Given a user wants detailed game logs
    When viewing game log for Saquon Barkley
    Then each game is displayed:
      | Week | Opponent | Rush Yds | Rush TD | Rec | Rec Yds | Fantasy Pts |
      | 18   | NYG      | 167      | 1       | 3   | 22      | 26.9        |
      | 17   | DAL      | 150      | 2       | 2   | 31      | 33.1        |
      | 16   | WAS      | 124      | 0       | 5   | 45      | 22.4        |
    And playoff games are highlighted separately

  Scenario: Display red zone statistics
    Given a user wants scoring opportunity data
    When viewing red zone stats for Travis Kelce
    Then red zone metrics are shown:
      | Metric              | Value |
      | Red Zone Targets    | 35    |
      | Red Zone Receptions | 28    |
      | Red Zone TDs        | 9     |
      | Goal Line Carries   | N/A   |
      | RZ Target Share     | 28%   |

  Scenario: Display snap count and usage statistics
    Given a user wants playing time data
    When viewing usage stats for Derrick Henry
    Then usage metrics are shown:
      | Metric              | Value |
      | Offensive Snaps     | 892   |
      | Snap Percentage     | 78%   |
      | Carries/Game        | 21.3  |
      | Targets/Game        | 2.8   |
      | Touch Share         | 82%   |

  Scenario: Display advanced analytics statistics
    Given a user wants advanced metrics
    When viewing advanced stats for Patrick Mahomes
    Then advanced metrics are shown:
      | Metric                  | Value   | League Rank |
      | QBR                     | 78.5    | 2nd         |
      | EPA/Play                | 0.28    | 1st         |
      | CPOE                    | 4.2%    | 3rd         |
      | Air Yards/Attempt       | 8.7     | 5th         |
      | Pressure Rate           | 28%     | 12th        |
      | Time to Throw           | 2.65s   | 8th         |

  Scenario: Compare player stats to position average
    Given a user wants context for statistics
    When viewing stats with position comparison
    Then comparison shows:
      | Stat            | Player Value | Position Avg | Difference |
      | Passing Yards   | 4,839        | 3,850        | +989       |
      | Passing TDs     | 38           | 24           | +14        |
      | Interceptions   | 11           | 14           | -3         |
    And above-average stats are highlighted green

  Scenario: Display stats filtered by game type
    Given a user wants specific game context
    When filtering stats by:
      | Filter        | Options                    |
      | Home/Away     | Home, Away, All            |
      | Indoor/Outdoor| Dome, Outdoor, All         |
      | Opponent Type | Division, Conference, All  |
    Then stats are recalculated for selected filter
    And sample size is displayed

  # ==================== PLAYER NEWS ====================

  Scenario: Display latest player news
    Given a user views player news section
    When viewing news for Josh Allen
    Then recent news articles are shown:
      | Date       | Source   | Headline                              |
      | Jan 10     | ESPN     | Allen leads Bills to playoff berth   |
      | Jan 8      | NFL.com  | Allen named AFC Player of the Month  |
      | Jan 5      | Yahoo    | Bills offense clicking at right time |
    And articles are sorted by date descending

  Scenario: Display injury news and updates
    Given a player has injury information
    When viewing news for injured player
    Then injury news is prioritized:
      | Date       | Update Type | Status      | Detail                    |
      | Jan 10     | Practice    | Limited     | Participated in walkthrough|
      | Jan 9      | Report      | Questionable| Knee, day-to-day          |
      | Jan 8      | Initial     | Injured     | Left game in 4th quarter  |
    And estimated return timeline is shown

  Scenario: Display transaction news
    Given roster transactions affect player value
    When viewing transaction news
    Then recent transactions are shown:
      | Date       | Type       | Detail                              |
      | Jan 10     | Activation | Activated from IR                   |
      | Jan 8      | Signing    | Signed to practice squad            |
      | Jan 5      | Trade      | Traded from Team A to Team B        |

  Scenario: Subscribe to player news notifications
    Given player "john_doe" wants news alerts
    When john_doe subscribes to Patrick Mahomes news
    Then john_doe receives notifications for:
      | News Type          | Notify |
      | Injury updates     | Yes    |
      | Game highlights    | Yes    |
      | Trade/Transaction  | Yes    |
      | Practice reports   | Yes    |
    And notification preferences are customizable

  Scenario: Display news from multiple sources
    Given news aggregation is enabled
    When viewing player news feed
    Then sources include:
      | Source       | Type              |
      | ESPN         | Major outlet      |
      | NFL.com      | Official league   |
      | Team website | Official team     |
      | Twitter/X    | Social media      |
      | Beat writers | Local coverage    |
    And source filtering is available

  Scenario: Display fantasy-relevant news highlights
    Given fantasy impact is analyzed
    When viewing fantasy news for players
    Then fantasy impact is indicated:
      | News                           | Impact  | Analysis                    |
      | WR1 ruled out                  | High    | Target share to WR2         |
      | Weather forecast: high winds   | Medium  | Reduces passing upside      |
      | RB returns from injury         | High    | Reduces backup value        |
    And impact affects projections

  # ==================== PLAYER AVAILABILITY ====================

  Scenario: Display player injury status
    Given injury reports are available
    When viewing player availability
    Then injury status is shown:
      | Player           | Status       | Injury      | Updated    |
      | Travis Kelce     | Questionable | Knee        | Jan 10     |
      | Davante Adams    | Out          | Hamstring   | Jan 10     |
      | Tyreek Hill      | Probable     | Ankle       | Jan 10     |
    And status impacts projections

  Scenario: Display practice participation
    Given practice reports are updated daily
    When viewing practice status
    Then participation is shown:
      | Player           | Wednesday | Thursday | Friday | Status      |
      | Travis Kelce     | DNP       | Limited  | Full   | Probable    |
      | Davante Adams    | DNP       | DNP      | DNP    | Out         |
      | Tyreek Hill      | Limited   | Full     | Full   | Active      |

  Scenario: Display bye week status
    Given some teams have first-round byes
    When viewing player availability
    Then bye status is indicated:
      | Player           | Round      | Status  |
      | Chiefs players   | Wild Card  | BYE     |
      | Bills players    | Wild Card  | BYE     |
    And players return for Divisional round

  Scenario: Display suspension status
    Given a player may be suspended
    When viewing suspended player
    Then suspension details show:
      | Field              | Value              |
      | Status             | Suspended          |
      | Reason             | League policy      |
      | Games Remaining    | 2                  |
      | Eligible Return    | Conference Round   |

  Scenario: Track player availability changes
    Given player "jane_doe" monitors availability
    When a player's status changes
    Then jane_doe is notified:
      | Previous Status | New Status   | Time        |
      | Questionable    | Out          | 2 hours ago |
      | Doubtful        | Probable     | 1 hour ago  |
    And roster recommendations update

  Scenario: Display COVID/illness protocol status
    Given health protocols may affect availability
    When a player is in protocol
    Then protocol status shows:
      | Field           | Value              |
      | Status          | Illness - Out      |
      | Protocol Day    | Day 2              |
      | Earliest Return | January 12         |

  Scenario: Filter players by availability status
    Given a user wants only available players
    When filtering by "Active" status
    Then only healthy, active players are shown
    And injured/suspended players are hidden
    And bye week players show appropriate status

  # ==================== PLAYER COMPARISON ====================

  Scenario: Compare two players side by side
    Given a user wants to compare players
    When comparing Patrick Mahomes and Josh Allen
    Then comparison shows:
      | Metric              | Mahomes | Allen  | Advantage |
      | Passing Yards       | 4,839   | 4,544  | Mahomes   |
      | Passing TDs         | 38      | 34     | Mahomes   |
      | Rushing Yards       | 389     | 531    | Allen     |
      | Rushing TDs         | 4       | 12     | Allen     |
      | Fantasy PPG (PPR)   | 24.5    | 26.2   | Allen     |
      | Playoff Experience  | 6 years | 4 years| Mahomes   |

  Scenario: Compare players across different positions
    Given position-adjusted comparison is needed
    When comparing Travis Kelce (TE) to Tyreek Hill (WR)
    Then comparison shows position context:
      | Metric              | Kelce   | Hill   | Position Avg |
      | Targets             | 121     | 158    | TE: 85, WR: 120 |
      | Receptions          | 97      | 108    | TE: 62, WR: 78 |
      | Fantasy PPG         | 14.2    | 17.5   | TE: 8.5, WR: 12.0 |
      | Position Rank       | TE1     | WR3    | - |

  Scenario: Compare player stats in specific matchups
    Given matchup history is available
    When comparing players against specific defense
    Then matchup history shows:
      | Player       | vs Defense | Games | Avg Points | Best Game |
      | Tyreek Hill  | vs NYJ     | 4     | 12.5       | 22.0      |
      | Davante Adams| vs NYJ     | 2     | 18.0       | 24.5      |

  Scenario: Compare players by fantasy scoring format
    Given different leagues use different scoring
    When comparing players in PPR vs Standard
    Then format comparison shows:
      | Player       | PPR Points | Standard Points | PPR Boost |
      | Travis Kelce | 242.5      | 145.5           | +97.0     |
      | Derrick Henry| 285.5      | 225.5           | +60.0     |
    And the high-volume receiver benefits more from PPR

  Scenario: Compare player career trajectories
    Given historical performance data exists
    When comparing career arcs
    Then trajectory comparison shows:
      | Age  | Mahomes PPG | Allen PPG | Advantage |
      | 25   | 22.5        | 18.0      | Mahomes   |
      | 26   | 24.0        | 21.5      | Mahomes   |
      | 27   | 25.5        | 24.0      | Mahomes   |
      | 28   | 24.5        | 26.2      | Allen     |
    And career trajectory charts are displayed

  Scenario: Generate comparison report
    Given a user wants detailed comparison
    When generating comparison report
    Then report includes:
      | Section              |
      | Basic stats          |
      | Advanced metrics     |
      | Matchup history      |
      | Injury history       |
      | Playoff performance  |
      | Projection comparison|
    And report is exportable as PDF

  # ==================== PLAYER WATCHLIST ====================

  Scenario: Add player to watchlist
    Given player "john_doe" wants to track specific players
    When john_doe adds Patrick Mahomes to watchlist
    Then Mahomes appears in john_doe's watchlist
    And the add action is confirmed
    And watchlist count is updated

  Scenario: View watchlist with live updates
    Given player "jane_doe" has a watchlist
    When jane_doe views their watchlist
    Then watched players are displayed:
      | Player           | Position | Team | Proj Points | News |
      | Patrick Mahomes  | QB       | KC   | 24.5        | 2    |
      | Travis Kelce     | TE       | KC   | 14.5        | 1    |
      | Saquon Barkley   | RB       | PHI  | 18.5        | 0    |
    And live scores update during games

  Scenario: Organize watchlist into categories
    Given player "bob_player" has many watched players
    When bob_player creates watchlist folders:
      | Folder Name     | Description           |
      | Must Start      | Weekly starters       |
      | Streaming       | Matchup-based plays   |
      | Stash           | Future value          |
    Then players can be organized into folders
    And folders are customizable

  Scenario: Remove player from watchlist
    Given player "alice_player" no longer wants to track a player
    When alice_player removes Davante Adams from watchlist
    Then Adams is removed from the watchlist
    And a confirmation message is shown
    And the action can be undone

  Scenario: Receive watchlist notifications
    Given player "john_doe" has watchlist notifications enabled
    When a watched player has news or status change
    Then john_doe receives notifications for:
      | Event Type          | Notification |
      | Injury update       | Push + Email |
      | Projection change   | Push         |
      | Game start          | Push         |
      | Big play            | Push         |

  Scenario: Share watchlist with league members
    Given player "jane_doe" has a curated watchlist
    When jane_doe shares their watchlist
    Then league members can view the shared list
    And the list shows "Shared by jane_doe"
    And members can copy to their own watchlist

  Scenario: Set watchlist player alerts
    Given player "bob_player" wants specific alerts
    When bob_player configures alerts for Tyreek Hill:
      | Alert Type        | Threshold    |
      | Points scored     | 10+          |
      | Touchdown         | Any          |
      | Injury update     | Any change   |
    Then custom alerts are set for Hill
    And alerts trigger based on thresholds

  Scenario: View watchlist analytics
    Given player "alice_player" has watched players all season
    When alice_player views watchlist analytics
    Then performance tracking shows:
      | Player           | Added Date | Points Since | Trend   |
      | Patrick Mahomes  | Sep 1      | 392.5        | Stable  |
      | Puka Nacua       | Oct 15     | 185.0        | Rising  |
    And ROI on watchlist picks is shown

  # ==================== PLAYER NOTES ====================

  Scenario: Add personal notes to a player
    Given player "john_doe" wants to track observations
    When john_doe adds a note to Travis Kelce:
      | Note                                    |
      | "Looked slower in Week 17, monitor knee"|
    Then the note is saved to john_doe's profile
    And the note appears on Kelce's player card
    And note timestamp is recorded

  Scenario: View all notes for a player
    Given player "jane_doe" has multiple notes on a player
    When jane_doe views notes for Patrick Mahomes
    Then notes are displayed chronologically:
      | Date       | Note                                    |
      | Jan 10     | "Ready for playoffs, looked sharp"      |
      | Dec 28     | "Minor ankle tweak, should be fine"     |
      | Dec 15     | "Dominant performance vs Chargers"      |

  Scenario: Edit existing player note
    Given player "bob_player" wants to update a note
    When bob_player edits their note on Derrick Henry
    Then the note is updated
    And edit history is preserved
    And last modified timestamp updates

  Scenario: Delete player note
    Given player "alice_player" wants to remove a note
    When alice_player deletes a note
    Then the note is removed
    And confirmation is required before deletion
    And the action can be undone

  Scenario: Tag notes for categorization
    Given player "john_doe" wants organized notes
    When john_doe adds tags to notes:
      | Tag Type    | Examples                |
      | Injury      | #knee, #hamstring       |
      | Performance | #elite, #declining      |
      | Situation   | #gamescript, #matchup   |
    Then notes are filterable by tag
    And tag suggestions appear while typing

  Scenario: Search through player notes
    Given player "jane_doe" has many notes
    When jane_doe searches notes for "injury"
    Then all notes containing "injury" are shown
    And search highlights matching text
    And results are sorted by relevance

  Scenario: Export player notes
    Given player "bob_player" wants to backup notes
    When bob_player exports notes
    Then notes are exported as CSV or JSON
    And export includes player name, date, and note text
    And notes can be re-imported later

  Scenario: View notes alongside projections
    Given notes provide context for decisions
    When viewing player projections
    Then personal notes are displayed inline
    And notes icon indicates players with notes
    And clicking reveals full note text

  # ==================== PLAYER TRENDS ====================

  Scenario: Display recent performance trend
    Given trending data is available
    When viewing trend for Ja'Marr Chase
    Then recent trend shows:
      | Metric         | Last 3 Games | Season Avg | Trend    |
      | Targets        | 14.0         | 9.3        | Up       |
      | Receptions     | 10.0         | 6.9        | Up       |
      | Yards          | 145.0        | 100.5      | Up       |
      | Fantasy Points | 28.5         | 21.5       | Up       |
    And trend indicators use arrows/colors

  Scenario: Display target share trend
    Given target data is tracked
    When viewing target trend for wide receivers
    Then trends show:
      | Player       | Wk 15 | Wk 16 | Wk 17 | Wk 18 | Trend  |
      | Ja'Marr Chase| 28%   | 32%   | 35%   | 38%   | Rising |
      | Tee Higgins  | 24%   | 22%   | 18%   | 15%   | Falling|
    And target share changes are highlighted

  Scenario: Display snap count trends
    Given usage data is tracked weekly
    When viewing snap trends
    Then trends show:
      | Player         | Wk 15 | Wk 16 | Wk 17 | Wk 18 | Change  |
      | Isiah Pacheco  | 55%   | 62%   | 68%   | 72%   | +17%    |
      | Clyde Edwards  | 45%   | 38%   | 32%   | 28%   | -17%    |

  Scenario: Display red zone opportunity trends
    Given red zone data is tracked
    When viewing red zone trends
    Then RZ opportunities show:
      | Player       | Last 4 Weeks RZ Opps | Season Avg | Trend  |
      | Saquon Barkley| 8.5/game            | 5.2/game   | Rising |
      | Josh Jacobs   | 3.0/game            | 4.8/game   | Falling|

  Scenario: Display fantasy points trend chart
    Given historical fantasy data exists
    When viewing trend chart for a player
    Then a line chart displays:
      | Data Points          |
      | Weekly fantasy points|
      | Moving average       |
      | Season average line  |
    And hovering shows exact values

  Scenario: Compare trends across players
    Given multiple players are selected
    When comparing trends
    Then overlay comparison shows:
      | Chart Elements       |
      | Both player trends   |
      | Crossover points     |
      | Divergence periods   |
    And legend identifies each player

  Scenario: Display advanced metric trends
    Given advanced analytics are tracked
    When viewing advanced trends
    Then metrics show evolution:
      | Metric         | Start of Year | Current | Change |
      | Target Quality | 8.5           | 10.2    | +1.7   |
      | Route Win Rate | 22%           | 28%     | +6%    |
      | Separation Avg | 2.1 yds       | 2.8 yds | +0.7   |

  Scenario: Identify breakout and bust trends
    Given trend analysis algorithms run
    When viewing trend alerts
    Then alerts identify:
      | Trend Type     | Player         | Signal                    |
      | Breakout       | Puka Nacua     | 3 weeks of rising usage   |
      | Buy Low        | Stefon Diggs   | Soft schedule ahead       |
      | Sell High      | Tank Dell      | Unsustainable TD rate     |
      | Bust Alert     | RB with split  | Declining touch share     |

  # ==================== PLAYER ALERTS ====================

  Scenario: Configure player alert preferences
    Given player "john_doe" wants customized alerts
    When john_doe configures alert settings:
      | Alert Type          | Enabled | Threshold    |
      | Injury status change| Yes     | Any change   |
      | Projection change   | Yes     | +/- 3 points |
      | News published      | Yes     | All news     |
      | Game start          | Yes     | 30 min before|
      | Scoring play        | Yes     | TD only      |
    Then alert preferences are saved
    And alerts trigger based on configuration

  Scenario: Receive injury alert notification
    Given player "jane_doe" has injury alerts enabled
    When a watched player's injury status changes
    Then jane_doe receives notification:
      | Field       | Value                              |
      | Player      | Travis Kelce                       |
      | Previous    | Questionable                       |
      | Current     | Out                                |
      | Impact      | Significant - Find replacement TE  |
    And notification links to player profile

  Scenario: Receive projection change alert
    Given player "bob_player" monitors projections
    When projections update significantly
    Then bob_player receives alert:
      | Player      | Previous Proj | New Proj | Change  |
      | Tyreek Hill | 18.5          | 14.0     | -4.5    |
      | Reason      | Tough CB matchup added to analysis |
    And roster recommendations update

  Scenario: Receive game-time alerts
    Given player "alice_player" has game alerts enabled
    When a player's game is about to start
    Then alice_player receives alert:
      | Alert                              |
      | Chiefs vs Dolphins kickoff in 30min|
      | Your players: Mahomes, Kelce       |
      | Weather: Clear, 45°F               |

  Scenario: Receive inactive report alerts
    Given inactive reports are published before games
    When inactives are announced
    Then alerts show:
      | Player       | Status   | Fantasy Impact          |
      | WR1 (Out)    | Inactive | WR2 value increases     |
      | Starting RB  | Active   | Confirmed start         |
    And roster lock reminder is included

  Scenario: Receive trade/transaction alerts
    Given transactions affect player value
    When a significant transaction occurs
    Then alert shows:
      | Transaction                         |
      | WR traded from Team A to Team B    |
      | Fantasy Impact: New team pass-heavy|
      | Projection Change: +3.5 points     |

  Scenario: Configure alert delivery methods
    Given player "john_doe" has delivery preferences
    When john_doe sets delivery options:
      | Alert Type     | Push | Email | SMS  |
      | Injury         | Yes  | Yes   | Yes  |
      | Projection     | Yes  | No    | No   |
      | Game start     | Yes  | No    | No   |
      | News           | No   | Yes   | No   |
    Then alerts deliver via selected channels

  Scenario: Manage alert frequency and quiet hours
    Given player "jane_doe" doesn't want constant alerts
    When jane_doe sets alert limits:
      | Setting        | Value              |
      | Max per hour   | 5 alerts           |
      | Quiet hours    | 11 PM - 7 AM       |
      | Batch mode     | Enabled (hourly)   |
    Then alerts respect frequency limits
    And critical alerts bypass quiet hours

  Scenario: View alert history
    Given player "bob_player" wants to review past alerts
    When bob_player views alert history
    Then historical alerts are shown:
      | Date       | Time    | Alert Type  | Player        | Content                |
      | Jan 10     | 2:30 PM | Injury      | Travis Kelce  | Status: Questionable   |
      | Jan 10     | 10:00 AM| Projection  | Tyreek Hill   | -2.5 points            |
      | Jan 9      | 6:00 PM | News        | Josh Allen    | Practice report        |
    And alerts are searchable and filterable
