@backend @priority_1 @teams @management
Feature: Comprehensive Teams System
  As a fantasy football playoffs application
  I want to provide complete team management, collaboration, and analytics capabilities
  So that users can effectively manage their fantasy teams throughout the playoffs

  Background:
    Given a league "2025 NFL Playoffs Pool" exists
    And the league has 12 teams registered
    And the game has 4 weeks (Wild Card, Divisional, Conference, Super Bowl)

  # ==================== TEAM PROFILES ====================

  Scenario: Display team profile with basic information
    Given player "john_doe" owns a fantasy team
    When john_doe views their team profile
    Then the profile displays:
      | Field           | Value                  |
      | Team Name       | Mahomes' Militia       |
      | Owner           | john_doe               |
      | League          | 2025 NFL Playoffs Pool |
      | Join Date       | January 1, 2025        |
      | Avatar          | Custom team logo       |
      | Motto           | "In Mahomes We Trust"  |

  Scenario: Display team achievements and badges
    Given a team has earned achievements
    When viewing the team profile
    Then achievements are displayed:
      | Achievement         | Description                    | Date Earned |
      | League Champion     | Won 2024 playoffs              | Jan 2024    |
      | Perfect Week        | All starters scored 15+ pts   | Week 3      |
      | Streak Master       | 5 consecutive wins             | Weeks 2-6   |
      | High Scorer         | Highest weekly score           | Wild Card   |

  Scenario: Display team historical performance
    Given a team has participated in previous seasons
    When viewing historical performance
    Then history shows:
      | Season | Final Rank | Playoff Result | Total Points |
      | 2024   | 1st        | Champion       | 1,845.5      |
      | 2023   | 4th        | Semifinal      | 1,720.0      |
      | 2022   | 8th        | First Round    | 1,580.5      |

  Scenario: Customize team profile
    Given player "jane_doe" wants to update their team
    When jane_doe edits team profile:
      | Field      | New Value              |
      | Team Name  | Bills Mafia            |
      | Avatar     | Upload custom logo     |
      | Motto      | "Circle the Wagons"    |
      | Colors     | Blue and Red           |
    Then the profile is updated
    And other league members see the changes

  Scenario: Display team owner information
    Given a team has owner details configured
    When viewing team owner info
    Then owner profile shows:
      | Field           | Value                  |
      | Display Name    | John D.                |
      | Member Since    | 2020                   |
      | Leagues Joined  | 5                      |
      | Win Rate        | 62%                    |
      | Championships   | 2                      |

  Scenario: View team profile as other league member
    Given player "bob_player" views another team's profile
    When bob_player views "john_doe" team profile
    Then public information is visible:
      | Visible             | Hidden           |
      | Team name           | Owner email      |
      | Current roster      | Draft strategy   |
      | Win/Loss record     | Private notes    |
      | Playoff position    | Watchlist        |

  # ==================== TEAM ROSTERS ====================

  Scenario: Display current team roster
    Given player "john_doe" has a playoff roster
    When john_doe views their roster
    Then the roster displays:
      | Position | Player           | Team | Status  | Proj Points |
      | QB       | Patrick Mahomes  | KC   | Active  | 24.5        |
      | RB       | Derrick Henry    | BAL  | Active  | 17.0        |
      | RB       | Saquon Barkley   | PHI  | Active  | 18.5        |
      | WR       | Tyreek Hill      | MIA  | Active  | 15.5        |
      | WR       | CeeDee Lamb      | DAL  | Active  | 16.0        |
      | TE       | Travis Kelce     | KC   | Questionable | 14.5   |
      | FLEX     | A.J. Brown       | PHI  | Active  | 14.0        |
      | K        | Harrison Butker  | KC   | Active  | 10.5        |
      | DEF      | SF 49ers         | SF   | Active  | 8.0         |

  Scenario: Display bench players
    Given a team has bench slots
    When viewing the full roster
    Then bench players are shown:
      | Position | Player           | Team | Status  |
      | BENCH    | Lamar Jackson    | BAL  | Active  |
      | BENCH    | Josh Jacobs      | GB   | Active  |
      | BENCH    | Stefon Diggs     | HOU  | Active  |
      | BENCH    | Dallas Goedert   | PHI  | Active  |
    And bench is clearly separated from starters

  Scenario: Display injured reserve (IR) slot
    Given the league has IR slots enabled
    When viewing roster with IR player
    Then IR slot shows:
      | Position | Player           | Status | Eligible Return |
      | IR       | Davante Adams    | Out    | Divisional      |
    And IR player cannot be started

  Scenario: View roster by NFL game
    Given roster players are in different NFL games
    When viewing roster grouped by game
    Then grouping shows:
      | Game               | Players                    | Game Time       |
      | KC vs MIA          | Mahomes, Kelce, Hill       | Sat 4:30 PM     |
      | BAL vs HOU         | Henry, Jackson             | Sat 8:00 PM     |
      | PHI vs TB          | Barkley, Brown             | Sun 1:00 PM     |
      | DAL vs GB          | Lamb, Jacobs               | Sun 4:30 PM     |

  Scenario: Display roster salary cap status
    Given the league uses salary cap format
    When viewing roster cap status
    Then cap information shows:
      | Metric          | Value        |
      | Salary Cap      | $200,000,000 |
      | Current Roster  | $185,500,000 |
      | Cap Space       | $14,500,000  |
      | Dead Money      | $5,000,000   |
    And individual player salaries are displayed

  Scenario: Validate roster requirements
    Given roster requirements exist
    When the system validates a roster
    Then validation checks:
      | Requirement              | Status | Detail                    |
      | Minimum roster size      | Pass   | 15/15 players             |
      | Position minimums met    | Pass   | All positions filled      |
      | No duplicate players     | Pass   | All players unique        |
      | Salary cap compliance    | Pass   | Under cap limit           |
      | No ineligible players    | Pass   | All players playoff teams |

  # ==================== TEAM MANAGEMENT ====================

  Scenario: Add player to roster
    Given player "john_doe" wants to add a player
    And Rashee Rice is available
    When john_doe adds Rashee Rice to roster
    Then Rice is added to john_doe's roster
    And a confirmation message is shown
    And league transaction log is updated

  Scenario: Drop player from roster
    Given player "jane_doe" wants to drop a player
    When jane_doe drops Stefon Diggs from roster
    Then Diggs is removed from the roster
    And Diggs becomes available on waivers
    And the transaction is logged

  Scenario: Submit roster lineup for round
    Given player "bob_player" has selected starters
    When bob_player submits lineup for Wild Card
    Then the lineup is locked:
      | Position | Player           | Status  |
      | QB       | Josh Allen       | Locked  |
      | RB       | Derrick Henry    | Locked  |
    And lineup cannot be changed after lock
    And confirmation is sent to bob_player

  Scenario: Make lineup change before lock deadline
    Given lineup is not yet locked
    When player "alice_player" swaps starter and bench player
    Then the swap is processed:
      | From Starter | To Bench        |
      | Travis Kelce | Dallas Goedert  |
    And projected points are recalculated

  Scenario: Attempt lineup change after lock deadline
    Given lineup is locked for Wild Card
    When player "john_doe" attempts to change lineup
    Then the change is rejected
    And error message shows "Lineup locked for Wild Card round"
    And the original lineup remains unchanged

  Scenario: Set player to IR slot
    Given a player is eligible for IR
    When team owner moves player to IR
    Then the player is placed on IR
    And an active roster spot opens
    And the player cannot be activated until healthy

  Scenario: Process waiver wire claim
    Given waiver wire is open
    And player "jane_doe" submits a waiver claim
    When waiver processing runs
    Then claims are processed by priority:
      | Priority | Team     | Claim          | Result   |
      | 1        | team_3   | Rashee Rice    | Approved |
      | 2        | jane_doe | Rashee Rice    | Denied   |
      | 3        | team_5   | Jaylen Warren  | Approved |

  Scenario: Execute trade between teams
    Given a trade is proposed and accepted
    When the trade is processed:
      | Team A Sends     | Team B Sends     |
      | Travis Kelce     | Mark Andrews     |
      | 2025 2nd Pick    | Jaylen Waddle    |
    Then rosters are updated
    And both teams receive confirmation
    And trade is logged in league history

  # ==================== TEAM STATS ====================

  Scenario: Display team scoring statistics
    Given a team has completed games
    When viewing team scoring stats
    Then stats are displayed:
      | Metric               | Value    | Rank |
      | Total Points         | 485.5    | 2nd  |
      | Points Per Game      | 161.8    | 1st  |
      | Highest Week         | 185.5    | 1st  |
      | Lowest Week          | 132.0    | 5th  |
      | Standard Deviation   | 18.5     | 6th  |

  Scenario: Display team position scoring breakdown
    Given team has position-level stats
    When viewing position breakdown
    Then breakdown shows:
      | Position | Total Points | PPG    | League Rank |
      | QB       | 95.5         | 31.8   | 1st         |
      | RB       | 112.0        | 37.3   | 3rd         |
      | WR       | 98.5         | 32.8   | 4th         |
      | TE       | 45.0         | 15.0   | 2nd         |
      | K        | 32.5         | 10.8   | 5th         |
      | DEF      | 24.0         | 8.0    | 6th         |

  Scenario: Display team efficiency metrics
    Given advanced team analytics exist
    When viewing efficiency metrics
    Then metrics show:
      | Metric                    | Value  | Description                   |
      | Roster Efficiency         | 92%    | Optimal lineup % achieved     |
      | Bench Points Wasted       | 45.5   | Points left on bench          |
      | Projection Accuracy       | 85%    | Projected vs actual           |
      | Optimal Lineup Weeks      | 2/3    | Perfect lineup decisions      |

  Scenario: Display team record statistics
    Given team has match records
    When viewing records
    Then records show:
      | Record Type              | Value           | Detail              |
      | Playoff Record           | 2-1             | Current playoffs    |
      | All-Time Playoff Record  | 12-5            | Career              |
      | Win Streak               | 2               | Current             |
      | Longest Win Streak       | 6               | Season best         |
      | Head-to-Head vs Rival    | 5-3             | vs team_3           |

  Scenario: Display team scoring by week
    Given weekly scoring data exists
    When viewing weekly breakdown
    Then week-by-week shows:
      | Round      | Score  | Result | Opponent    | Margin |
      | Wild Card  | 165.5  | Win    | team_8      | +22.5  |
      | Divisional | 172.0  | Win    | team_4      | +8.5   |
      | Conference | TBD    | -      | team_2      | -      |

  Scenario: Display team strength analysis
    Given analytical tools are available
    When viewing team strength analysis
    Then analysis shows:
      | Category        | Rating | Strengths           | Weaknesses         |
      | Overall         | A-     | QB, TE depth        | WR2 production     |
      | Ceiling         | A      | High upside starters| Boom/bust players  |
      | Floor           | B+     | Consistent RBs      | Variable defense   |
      | Playoff Ready   | A      | Playoff experience  | Injury concerns    |

  # ==================== TEAM STANDINGS ====================

  Scenario: Display league standings
    Given the playoffs are in progress
    When viewing league standings
    Then standings show:
      | Rank | Team              | Record | Points | Status      |
      | 1    | Mahomes' Militia  | 2-0    | 337.5  | Advancing   |
      | 2    | Bills Mafia       | 2-0    | 325.0  | Advancing   |
      | 3    | Bird Gang         | 1-1    | 298.5  | Alive       |
      | 4    | Purple Reign      | 1-1    | 285.0  | Alive       |
      | 5    | Team Five         | 0-2    | 245.0  | Eliminated  |
    And eliminated teams are grayed out

  Scenario: Display standings with tiebreaker details
    Given teams are tied in standings
    When viewing standings with tiebreakers
    Then tiebreaker info shows:
      | Rank | Team              | Record | Points | Tiebreaker        |
      | 3    | Bird Gang         | 1-1    | 298.5  | Higher high score |
      | 4    | Purple Reign      | 1-1    | 298.5  | Lower high score  |
    And tiebreaker rules are explained

  Scenario: Display playoff bracket position
    Given playoff bracket exists
    When viewing bracket standings
    Then bracket position shows:
      | Round      | Matchup              | Status     |
      | Wild Card  | Beat team_8 (165-143)| Complete   |
      | Divisional | Beat team_4 (172-163)| Complete   |
      | Conference | vs Bills Mafia       | Upcoming   |
      | Super Bowl | TBD                  | Pending    |

  Scenario: Display standings trends
    Given historical standings data exists
    When viewing standings trends
    Then trend visualization shows:
      | Team              | Start | Week 1 | Week 2 | Week 3 | Trend   |
      | Mahomes' Militia  | 3     | 2      | 1      | 1      | Rising  |
      | Bills Mafia       | 1     | 1      | 2      | 2      | Stable  |
      | Bird Gang         | 5     | 4      | 3      | 3      | Rising  |

  Scenario: Display magic number for advancement
    Given teams can clinch playoff spots
    When viewing magic numbers
    Then clinching scenarios show:
      | Team              | Magic Number | Clinch Scenario                  |
      | Mahomes' Militia  | Clinched     | Already advanced to Super Bowl   |
      | Bills Mafia       | Clinched     | Already advanced to Super Bowl   |
      | Bird Gang         | Eliminated   | Lost in Conference round         |

  Scenario: Display standings with schedule strength
    Given remaining schedules are known
    When viewing strength of schedule
    Then SOS analysis shows:
      | Team              | Remaining SOS | Rank | Advantage |
      | Mahomes' Militia  | Easy          | 1st  | +8.5 pts  |
      | Bills Mafia       | Medium        | 4th  | +2.0 pts  |
      | Bird Gang         | Hard          | 10th | -5.5 pts  |

  # ==================== TEAM MATCHUPS ====================

  Scenario: Display current week matchup
    Given teams are matched for Conference round
    When viewing current matchup
    Then matchup displays:
      | Team              | Projected | Current | Status      |
      | Mahomes' Militia  | 158.5     | 0.0     | In Progress |
      | Bills Mafia       | 155.0     | 0.0     | In Progress |
    And player-by-player comparison is shown

  Scenario: Display matchup player comparison
    Given a matchup is in progress
    When viewing player comparison
    Then comparison shows:
      | Position | My Player    | Pts  | Opp Player   | Pts  | Advantage |
      | QB       | Mahomes      | 0    | Allen        | 0    | -         |
      | RB       | Henry        | 0    | Barkley      | 0    | -         |
      | RB       | McCaffrey    | 0    | Cook         | 0    | -         |
      | WR       | Hill         | 0    | Chase        | 0    | -         |
    And live scores update during games

  Scenario: Display matchup win probability
    Given projections are calculated
    When viewing win probability
    Then probability shows:
      | Team              | Win Probability | Projected Score |
      | Mahomes' Militia  | 55%             | 158.5           |
      | Bills Mafia       | 45%             | 155.0           |
    And probability updates as games progress

  Scenario: View historical matchup record
    Given teams have played before
    When viewing head-to-head history
    Then history shows:
      | Date       | Result                    | Score       |
      | Jan 2025   | Mahomes' Militia Won      | 165-152     |
      | Dec 2024   | Bills Mafia Won           | 148-142     |
      | Nov 2024   | Mahomes' Militia Won      | 172-158     |
      | Overall    | Mahomes' Militia leads    | 5-3         |

  Scenario: Display matchup key players
    Given matchup analytics are available
    When viewing key player analysis
    Then key players are highlighted:
      | Player         | Impact      | Reason                        |
      | Patrick Mahomes| High        | Highest projected scorer      |
      | Josh Allen     | High        | Rushing upside differential   |
      | Travis Kelce   | Medium      | Questionable status           |
    And boom/bust candidates are flagged

  Scenario: Display live matchup updates
    Given games are in progress
    When viewing live matchup
    Then real-time updates show:
      | Update Type    | Detail                              |
      | Score Change   | Mahomes TD pass: +4.0 pts           |
      | Lead Change    | Bills Mafia takes 2.5 pt lead       |
      | Injury Alert   | Kelce exits game (knee)             |
    And notifications are sent for significant events

  Scenario: Project matchup outcome with remaining players
    Given some games have completed
    When viewing projected final
    Then projection shows:
      | Team              | Current | Remaining Players | Projected Final |
      | Mahomes' Militia  | 85.5    | Hill, DEF          | 152.0           |
      | Bills Mafia       | 92.0    | RB2, K             | 158.5           |
    And win probability adjusts based on remaining

  # ==================== TEAM COMPARISON ====================

  Scenario: Compare two teams side by side
    Given a user wants to compare teams
    When comparing Mahomes' Militia and Bills Mafia
    Then comparison shows:
      | Metric               | Mahomes' Militia | Bills Mafia | Advantage |
      | Total Points         | 337.5            | 325.0       | Mahomes   |
      | Points Per Game      | 168.8            | 162.5       | Mahomes   |
      | QB Points            | 95.5             | 98.0        | Bills     |
      | RB Points            | 112.0            | 105.5       | Mahomes   |
      | Roster Value         | $185.5M          | $178.0M     | Mahomes   |

  Scenario: Compare teams by position group
    Given detailed position comparison is needed
    When comparing position groups
    Then comparison shows:
      | Position | Team A Players | Team A Pts | Team B Players | Team B Pts |
      | QB       | Mahomes        | 95.5       | Allen          | 98.0       |
      | RB       | Henry, CMC     | 112.0      | Barkley, Cook  | 105.5      |
      | WR       | Hill, Lamb     | 98.5       | Chase, Diggs   | 102.0      |

  Scenario: Compare team roster depth
    Given depth chart comparison is available
    When comparing roster depth
    Then depth analysis shows:
      | Position | Team A Depth | Team A Rating | Team B Depth | Team B Rating |
      | QB       | 2 players    | A             | 2 players    | A             |
      | RB       | 4 players    | A-            | 3 players    | B+            |
      | WR       | 5 players    | B+            | 4 players    | A             |

  Scenario: Compare team playoff experience
    Given historical data is available
    When comparing playoff experience
    Then experience comparison shows:
      | Metric                   | Team A | Team B |
      | Owner Playoff Appearances| 5      | 3      |
      | Championships            | 2      | 1      |
      | Playoff Win %            | 72%    | 65%    |
      | Roster Playoff Exp (Avg) | 3.2 yrs| 2.8 yrs|

  Scenario: Compare team salary allocation
    Given salary cap format is used
    When comparing salary allocation
    Then allocation shows:
      | Position | Team A $ | Team A % | Team B $ | Team B % |
      | QB       | $45M     | 24%      | $43M     | 24%      |
      | RB       | $38M     | 21%      | $35M     | 20%      |
      | WR       | $42M     | 23%      | $48M     | 27%      |
      | TE       | $20M     | 11%      | $15M     | 8%       |

  Scenario: Generate team comparison report
    Given comprehensive comparison is needed
    When generating comparison report
    Then report includes:
      | Section                  |
      | Overall team ratings     |
      | Position-by-position     |
      | Statistical comparison   |
      | Strength/weakness        |
      | Head-to-head history     |
      | Matchup prediction       |
    And report is exportable

  # ==================== TEAM SETTINGS ====================

  Scenario: Configure team notification preferences
    Given player "john_doe" manages notifications
    When john_doe configures preferences:
      | Notification Type    | Email | Push | SMS  |
      | Matchup results      | Yes   | Yes  | No   |
      | Trade offers         | Yes   | Yes  | Yes  |
      | Waiver results       | Yes   | Yes  | No   |
      | Lineup reminders     | No    | Yes  | Yes  |
      | Injury updates       | No    | Yes  | No   |
    Then preferences are saved
    And notifications respect settings

  Scenario: Configure roster lock settings
    Given team owner manages lock preferences
    When configuring lock settings:
      | Setting                  | Value           |
      | Auto-submit lineup       | Enabled         |
      | Default bench promotion  | By projection   |
      | Lock reminder timing     | 1 hour before   |
    Then settings are applied to future rounds

  Scenario: Configure team privacy settings
    Given team owner manages privacy
    When configuring privacy:
      | Setting                  | Value           |
      | Roster visibility        | League only     |
      | Transaction history      | Public          |
      | Watchlist visibility     | Private         |
      | Notes visibility         | Private         |
    Then privacy settings are enforced

  Scenario: Configure team display preferences
    Given team owner customizes display
    When setting display preferences:
      | Setting                  | Value           |
      | Default roster view      | By position     |
      | Scoring format display   | PPR             |
      | Projection source        | FantasyPros     |
      | Theme                    | Dark mode       |
    Then display preferences are applied

  Scenario: Configure trade preferences
    Given team owner sets trade rules
    When configuring trade settings:
      | Setting                  | Value           |
      | Accept trade offers      | Yes             |
      | Trade deadline reminder  | 24 hours        |
      | Auto-reject criteria     | None            |
      | Trade review period      | 12 hours        |
    Then trade settings are saved

  Scenario: Export team settings
    Given team has configured settings
    When exporting settings
    Then export includes:
      | Category               |
      | Notification prefs     |
      | Privacy settings       |
      | Display preferences    |
      | Trade rules            |
    And settings can be imported to new team

  # ==================== TEAM HISTORY ====================

  Scenario: View complete team transaction history
    Given a team has transaction records
    When viewing transaction history
    Then transactions are listed:
      | Date       | Type    | Detail                          | Status    |
      | Jan 10     | Add     | Added Rashee Rice from waivers  | Completed |
      | Jan 8      | Drop    | Dropped Stefon Diggs            | Completed |
      | Jan 5      | Trade   | Traded Kelce for Andrews + pick | Completed |
      | Jan 2      | Draft   | Drafted Patrick Mahomes (Rd 1)  | Completed |

  Scenario: View team draft history
    Given draft records exist
    When viewing draft history
    Then draft picks are shown:
      | Round | Pick | Player           | Position | Status      |
      | 1     | 3    | Patrick Mahomes  | QB       | On Roster   |
      | 2     | 10   | Travis Kelce     | TE       | Traded      |
      | 3     | 27   | Derrick Henry    | RB       | On Roster   |
    And draft grade is displayed

  Scenario: View team trade history
    Given trades have been executed
    When viewing trade history
    Then trades are detailed:
      | Date    | Sent              | Received          | Outcome |
      | Jan 5   | Kelce, 2nd pick   | Andrews, Waddle   | Won     |
      | Dec 15  | 1st pick          | Josh Jacobs       | Even    |
    And trade grades are shown

  Scenario: View seasonal performance history
    Given multi-season data exists
    When viewing season history
    Then seasons are summarized:
      | Season | Record  | Points   | Finish | Notable           |
      | 2024   | 2-0     | 337.5    | TBD    | Current playoffs  |
      | 2023   | 10-4    | 1,720.0  | 4th    | Semifinal loss    |
      | 2022   | 8-6     | 1,580.5  | 8th    | First round loss  |

  Scenario: View award history
    Given team has won awards
    When viewing awards
    Then awards are displayed:
      | Award               | Season | Detail                    |
      | League Champion     | 2024   | Defeated Bills Mafia      |
      | Highest Score       | 2024   | Week 5: 198.5 points      |
      | Best Draft          | 2023   | A+ draft grade            |
      | Comeback Player     | 2022   | 0-4 start, made playoffs  |

  Scenario: Export team history
    Given complete history is available
    When exporting team history
    Then export includes:
      | Data Category          |
      | All transactions       |
      | Season summaries       |
      | Draft history          |
      | Trade history          |
      | Awards and achievements|
    And export formats include CSV and PDF

  # ==================== TEAM COLLABORATION ====================

  Scenario: Invite co-manager to team
    Given player "john_doe" wants help managing
    When john_doe invites "helper_user" as co-manager
    Then an invitation is sent
    And helper_user can accept or decline
    And co-manager permissions are defined

  Scenario: Configure co-manager permissions
    Given a co-manager is added
    When configuring permissions:
      | Permission           | Allowed |
      | View roster          | Yes     |
      | Set lineup           | Yes     |
      | Add/drop players     | No      |
      | Accept trades        | No      |
      | Modify settings      | No      |
    Then permissions are enforced
    And co-manager can only perform allowed actions

  Scenario: Remove co-manager from team
    Given a co-manager exists
    When owner removes co-manager
    Then co-manager access is revoked
    And notification is sent to former co-manager
    And audit log is updated

  Scenario: Share team insights with league
    Given team owner has shareable content
    When owner shares roster analysis
    Then league members can view:
      | Shared Content       | Visibility    |
      | Weekly lineup        | League        |
      | Roster breakdown     | League        |
      | Player notes         | Not shared    |
      | Trade targets        | Not shared    |

  Scenario: Participate in league chat
    Given league chat is enabled
    When team owner sends message
    Then message is visible to all league members
    And message is attributed to team name
    And chat history is preserved

  Scenario: Send direct message to team owner
    Given direct messaging is enabled
    When player "jane_doe" messages "john_doe"
    Then message is delivered privately
    And conversation history is saved
    And notifications respect preferences

  Scenario: Collaborate on trade negotiation
    Given trade discussions are active
    When teams negotiate trade:
      | Step | Action                              |
      | 1    | Team A proposes initial offer       |
      | 2    | Team B counters with modification   |
      | 3    | Team A accepts counter              |
      | 4    | Trade is executed                   |
    Then negotiation history is saved
    And both teams can review conversation

  Scenario: Create team poll for league decision
    Given league decisions need voting
    When team owner creates poll:
      | Question            | Options                    |
      | Extend trade deadline?| Yes, No, 24 hours only   |
    Then all teams can vote
    And results are visible to league
    And commissioner can act on result

  Scenario: Share team projection analysis
    Given team has projection insights
    When owner shares projection report
    Then league can view:
      | Shared Analysis       |
      | Weekly projections    |
      | Strength of schedule  |
      | Matchup predictions   |
    And owner controls what is shared

  Scenario: Collaborate with multiple teams on keeper strategy
    Given keeper league format
    When teams discuss keeper strategies
    Then collaboration features include:
      | Feature              | Description                   |
      | Keeper value chat    | Discuss player keeper values  |
      | Trade coordination   | Multi-team trade discussions  |
      | Draft strategy       | Share draft approach          |
    And private conversations remain private
