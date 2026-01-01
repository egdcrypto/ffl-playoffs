@backend @priority_1 @playoffs @competition
Feature: Comprehensive Playoffs System
  As a fantasy football playoffs application
  I want to provide complete playoff bracket, matchup, and championship management
  So that users can compete in an engaging and fair playoff competition

  Background:
    Given a league "2025 NFL Playoffs Pool" exists
    And the league has 12 teams registered
    And the NFL playoff schedule is configured
    And the game has 4 weeks (Wild Card, Divisional, Conference, Super Bowl)

  # ==================== PLAYOFF QUALIFICATION ====================

  Scenario: Determine playoff qualifiers based on regular season standings
    Given the regular season has concluded
    And final standings are:
      | Rank | Team              | Record | Points For |
      | 1    | Mahomes' Militia  | 11-3   | 1,892.5    |
      | 2    | Bills Mafia       | 10-4   | 1,845.0    |
      | 3    | Bird Gang         | 10-4   | 1,820.5    |
      | 4    | Purple Reign      | 9-5    | 1,780.0    |
      | 5    | Team Five         | 8-6    | 1,720.5    |
      | 6    | Team Six          | 8-6    | 1,695.0    |
      | 7    | Team Seven        | 7-7    | 1,650.0    |
      | 8    | Team Eight        | 6-8    | 1,580.5    |
    When playoff qualifiers are determined
    Then top 8 teams qualify for playoffs
    And teams 1-2 receive first-round byes
    And seeding matches regular season ranking

  Scenario: Apply tiebreaker for playoff seeding
    Given two teams have identical records
    And tiebreaker rules are configured:
      | Priority | Tiebreaker                    |
      | 1        | Head-to-head record           |
      | 2        | Total points for              |
      | 3        | Points against                |
    When team_a and team_b both have 10-4 records
    And team_a beat team_b in head-to-head
    Then team_a is seeded higher than team_b

  Scenario: Display playoff clinching scenarios
    Given 2 weeks remain in regular season
    When calculating clinching scenarios
    Then scenarios show:
      | Team              | Clinch Condition                    |
      | Mahomes' Militia  | Clinched #1 seed                    |
      | Bills Mafia       | Win OR Team Five loss               |
      | Bird Gang         | Win + Team Six loss                 |
      | Team Seven        | Eliminated from playoff contention  |

  Scenario: Display playoff elimination scenarios
    Given teams are fighting for playoff spots
    When calculating elimination scenarios
    Then eliminated teams are shown:
      | Team              | Status      | Reason                         |
      | Team Eleven       | Eliminated  | Cannot catch 8th place         |
      | Team Twelve       | Eliminated  | Record cannot improve enough   |
    And eliminated teams cannot qualify

  Scenario: Handle playoff bubble teams
    Given multiple teams competing for last spots
    When viewing playoff race
    Then bubble display shows:
      | Team          | Current Seed | Games Back | Strength of Schedule |
      | Team Six      | 6            | 0          | Easy                 |
      | Team Seven    | 7            | 0.5        | Hard                 |
      | Team Eight    | 8            | 1          | Medium               |
      | Team Nine     | 9 (out)      | 1.5        | Easy                 |

  Scenario: Lock playoff field after regular season
    Given regular season has ended
    When playoff field is finalized
    Then qualified teams are locked:
      | Seed | Team              | Status      |
      | 1    | Mahomes' Militia  | Qualified   |
      | 2    | Bills Mafia       | Qualified   |
      | 3    | Bird Gang         | Qualified   |
      | 4    | Purple Reign      | Qualified   |
    And non-qualifiers are marked "Season Complete"

  # ==================== PLAYOFF BRACKET ====================

  Scenario: Generate standard playoff bracket
    Given 8 teams have qualified for playoffs
    When the playoff bracket is generated
    Then bracket structure is:
      | Round      | Matchups                              |
      | Wild Card  | 3v6, 4v5 (seeds 1-2 on bye)           |
      | Divisional | 1v lowest, 2v highest                 |
      | Conference | Winners of Divisional                 |
      | Super Bowl | Conference winners                    |
    And bracket is displayed to all teams

  Scenario: Generate bracket with reseeding
    Given league uses reseeding after each round
    When Divisional round matchups are set
    And Wild Card results are:
      | Winner    | Seed |
      | #3 seed   | 3    |
      | #5 seed   | 5    |
    Then Divisional matchups are:
      | Matchup | Higher Seed      | Lower Seed    |
      | 1       | #1 (bye)         | #5 seed       |
      | 2       | #2 (bye)         | #3 seed       |

  Scenario: Generate bracket without reseeding
    Given league does not use reseeding
    When bracket is generated
    Then matchups follow fixed bracket lines:
      | Path           | Teams                    |
      | Top bracket    | 1, 4/5 winner            |
      | Bottom bracket | 2, 3/6 winner            |
    And bracket paths remain fixed

  Scenario: Display interactive playoff bracket
    Given playoffs are in progress
    When user views playoff bracket
    Then bracket displays:
      | Visual Element       | Description                    |
      | Team names           | With seeds and logos           |
      | Matchup lines        | Connecting opponents           |
      | Scores               | For completed matchups         |
      | Live indicators      | For in-progress matchups       |
      | Advancement arrows   | Showing winner progression     |

  Scenario: Update bracket after round completion
    Given Wild Card round has completed
    And winners are determined:
      | Matchup | Winner        | Score   |
      | 3v6     | #3 Bird Gang  | 165-148 |
      | 4v5     | #5 Team Five  | 158-152 |
    When bracket is updated
    Then Divisional matchups show:
      | Matchup | Team A           | Team B        |
      | 1       | #1 Mahomes       | #5 Team Five  |
      | 2       | #2 Bills         | #3 Bird Gang  |
    And Wild Card section shows completed results

  Scenario: Display bracket for eliminated teams
    Given team "Team Six" was eliminated in Wild Card
    When Team Six views the bracket
    Then Team Six sees full bracket
    And their matchup shows "Eliminated"
    And they can view ongoing matchups
    And consolation bracket is available if configured

  Scenario: Print playoff bracket
    Given user wants physical bracket
    When user requests printable bracket
    Then PDF is generated with:
      | Element              | Included |
      | All matchup slots    | Yes      |
      | Team names/seeds     | Yes      |
      | Dates and times      | Yes      |
      | League branding      | Yes      |

  # ==================== PLAYOFF SCHEDULE ====================

  Scenario: Configure playoff round schedule
    Given commissioner sets playoff schedule
    When schedule is configured:
      | Round      | Start Date  | End Date    | Lock Time           |
      | Wild Card  | Jan 11      | Jan 13      | Sat Jan 11, 4:25 PM |
      | Divisional | Jan 18      | Jan 19      | Sat Jan 18, 4:25 PM |
      | Conference | Jan 26      | Jan 26      | Sun Jan 26, 3:00 PM |
      | Super Bowl | Feb 9       | Feb 9       | Sun Feb 9, 6:30 PM  |
    Then schedule is saved
    And lock times are enforced

  Scenario: Display playoff schedule to users
    Given playoff schedule is configured
    When user views schedule
    Then schedule shows:
      | Round      | Dates           | Status      | Roster Lock          |
      | Wild Card  | Jan 11-13       | Complete    | Locked               |
      | Divisional | Jan 18-19       | In Progress | Locks in 2 hours     |
      | Conference | Jan 26          | Upcoming    | Locks Jan 26, 3 PM   |
      | Super Bowl | Feb 9           | Upcoming    | Locks Feb 9, 6:30 PM |

  Scenario: Send roster lock reminders
    Given roster lock is approaching
    When lock time is 1 hour away
    Then reminders are sent to teams with unlocked rosters:
      | Notification Type | Message                              |
      | Push              | Roster locks in 1 hour!              |
      | Email             | Submit your lineup before lock       |
    And reminder includes link to roster page

  Scenario: Handle NFL schedule changes
    Given NFL reschedules a playoff game
    When commissioner updates schedule:
      | Original          | New               |
      | Sun Jan 12, 1 PM  | Mon Jan 13, 8 PM  |
    Then affected roster locks are adjusted
    And teams are notified of changes
    And fantasy matchup timing updates

  Scenario: Display countdown to next round
    Given Divisional round is approaching
    When user views playoff schedule
    Then countdown shows:
      | Timer                | Value              |
      | Until roster lock    | 2d 5h 30m          |
      | Until first game     | 2d 8h 15m          |
      | Games this round     | 4                  |
    And countdown updates in real-time

  Scenario: Sync with NFL playoff schedule
    Given NFL official schedule is available
    When system syncs schedule
    Then all game times are updated:
      | Game               | Date       | Time        | Network |
      | KC vs MIA          | Jan 11     | 4:30 PM ET  | NBC     |
      | BAL vs HOU         | Jan 11     | 8:00 PM ET  | ESPN    |
      | PHI vs TB          | Jan 12     | 1:00 PM ET  | FOX     |
    And roster locks align with game times

  # ==================== PLAYOFF MATCHUPS ====================

  Scenario: Create playoff matchup
    Given Divisional round is starting
    When matchups are created:
      | Matchup | Team A           | Team B        | Round      |
      | 1       | Mahomes' Militia | Team Five     | Divisional |
      | 2       | Bills Mafia      | Bird Gang     | Divisional |
    Then matchups are visible to all teams
    And head-to-head comparison is available

  Scenario: Display matchup details
    Given a playoff matchup exists
    When viewing matchup between "Mahomes' Militia" and "Team Five"
    Then details show:
      | Detail               | Team A           | Team B        |
      | Seed                 | #1               | #5            |
      | Projected Score      | 165.5            | 152.0         |
      | Win Probability      | 62%              | 38%           |
      | Head-to-Head Record  | 2-0              | 0-2           |
      | Playoff Experience   | 5 years          | 2 years       |

  Scenario: Display live matchup scores
    Given playoff games are in progress
    When viewing live matchup
    Then scores update in real-time:
      | Team              | Score  | Status      | Players Left |
      | Mahomes' Militia  | 85.5   | In Progress | 4            |
      | Team Five         | 72.0   | In Progress | 5            |
    And last update timestamp is shown

  Scenario: Display position-by-position matchup comparison
    Given matchup is in progress
    When viewing position breakdown
    Then comparison shows:
      | Position | Team A Player | Team A Pts | Team B Player | Team B Pts |
      | QB       | Mahomes       | 28.5       | Allen         | 25.0       |
      | RB1      | Henry         | 18.0       | Barkley       | 22.5       |
      | RB2      | McCaffrey     | 15.5       | Cook          | 12.0       |
      | WR1      | Hill          | 12.0       | Chase         | 18.0       |
    And position advantages are highlighted

  Scenario: Determine matchup winner
    Given playoff matchup has completed
    And final scores are:
      | Team              | Score  |
      | Mahomes' Militia  | 168.5  |
      | Team Five         | 155.0  |
    When matchup result is determined
    Then Mahomes' Militia is declared winner
    And Team Five is eliminated
    And bracket is updated
    And notifications are sent

  Scenario: Handle matchup tie
    Given matchup ends in exact tie at 155.5 points
    When tiebreaker is applied
    Then tiebreaker process:
      | Step | Tiebreaker                    | Result        |
      | 1    | Highest single position       | Team A QB: 32 |
      | 2    | If still tied: 2nd highest    | -             |
    And winner is determined
    And tiebreaker explanation is shown

  Scenario: Display matchup history
    Given teams have playoff history
    When viewing historical matchups
    Then history shows:
      | Season | Round      | Winner           | Score     |
      | 2024   | Divisional | Mahomes' Militia | 172-165   |
      | 2023   | Conference | Team Five        | 158-155   |
      | 2022   | Wild Card  | Mahomes' Militia | 145-138   |

  # ==================== PLAYOFF SCORING ====================

  Scenario: Calculate playoff round scoring
    Given Wild Card round has completed
    When scoring is calculated
    Then all team scores are tallied:
      | Team              | Wild Card Score |
      | Mahomes' Militia  | BYE             |
      | Bills Mafia       | BYE             |
      | Bird Gang         | 165.5           |
      | Team Five         | 158.0           |
    And scores are persisted to database

  Scenario: Apply cumulative playoff scoring
    Given multiple rounds have completed
    When cumulative scoring is calculated
    Then totals show:
      | Team              | WC    | Div   | Conf  | Total  |
      | Mahomes' Militia  | BYE   | 172.0 | 168.5 | 340.5  |
      | Bills Mafia       | BYE   | 165.5 | 162.0 | 327.5  |
    And cumulative rankings are updated

  Scenario: Display scoring breakdown by NFL game
    Given roster includes players from multiple games
    When viewing scoring by game
    Then breakdown shows:
      | Game          | Players              | Points | Status     |
      | KC vs MIA     | Mahomes, Kelce, Hill | 52.5   | Final      |
      | BAL vs HOU    | Henry, Jackson       | 38.0   | Final      |
      | PHI vs TB     | Barkley, Brown       | 35.5   | In Progress|
    And game-by-game contribution is clear

  Scenario: Calculate playoff bonus points
    Given league has playoff bonuses configured
    When milestone is reached:
      | Bonus Type           | Threshold | Points |
      | Triple Crown QB      | 300/3/1   | 5      |
      | Rushing Champion     | 150+ rush | 3      |
      | Shutdown Defense     | 0-6 pts   | 5      |
    Then bonuses are applied to qualifying performances
    And bonus breakdown is shown

  Scenario: Handle stat corrections during playoffs
    Given playoff scoring is complete
    When NFL issues stat correction
    Then corrections are evaluated:
      | Impact           | Action                      |
      | Minor (< margin) | Apply, no result change     |
      | Major (> margin) | Apply, review matchup       |
    And affected teams are notified
    And correction log is updated

  Scenario: Display playoff scoring leaders
    Given playoff scoring is tracked
    When viewing scoring leaders
    Then leaders show:
      | Rank | Team              | Total Points | PPG    |
      | 1    | Mahomes' Militia  | 340.5        | 170.3  |
      | 2    | Bills Mafia       | 327.5        | 163.8  |
      | 3    | Bird Gang         | 285.0        | 142.5  |
    And position leaders are also shown

  # ==================== CONSOLATION BRACKET ====================

  Scenario: Generate consolation bracket
    Given league has consolation bracket enabled
    And teams are eliminated from championship bracket
    When consolation bracket is generated
    Then bracket includes:
      | Round          | Matchups                    |
      | Consolation R1 | #5 vs #8, #6 vs #7          |
      | Consolation SF | Winners advance             |
      | 5th Place Game | Consolation final           |
    And separate from championship bracket

  Scenario: Determine consolation bracket seeding
    Given 4 teams are eliminated
    When consolation seeding is set
    Then seeding reflects:
      | Seed | Team        | Elimination Round | Score at Elim |
      | 1    | Team Five   | Divisional        | 165.5         |
      | 2    | Team Six    | Wild Card         | 158.0         |
      | 3    | Team Seven  | Wild Card         | 152.5         |
      | 4    | Team Eight  | Wild Card         | 148.0         |

  Scenario: Track consolation bracket separately
    Given consolation games are in progress
    When viewing consolation standings
    Then display shows:
      | Matchup              | Team A      | Team B      | Status      |
      | 5th Place Semi       | Team Five   | Team Eight  | In Progress |
      | 5th Place Semi       | Team Six    | Team Seven  | Final       |
    And consolation winner earns prizes if configured

  Scenario: Award consolation prizes
    Given consolation bracket has concluded
    And league has consolation prizes:
      | Place    | Prize            |
      | 5th      | Entry fee refund |
      | 6th      | -                |
    When consolation results are final
    Then 5th place team receives prize
    And results are recorded in history

  Scenario: Option to disable consolation bracket
    Given commissioner configures playoffs
    When consolation bracket is disabled
    Then eliminated teams have season ended
    And no consolation matchups are created
    And eliminated teams can still view bracket

  Scenario: Toilet Bowl bracket for lowest seeds
    Given league wants fun competition for eliminated teams
    When Toilet Bowl is enabled
    Then bracket includes non-playoff teams:
      | Round        | Teams                        |
      | Toilet R1    | #9 vs #12, #10 vs #11        |
      | Toilet Final | Loser advances (worst team)  |
    And "winner" receives last place designation

  # ==================== CHAMPIONSHIP GAME ====================

  Scenario: Set up championship matchup
    Given Conference round has completed
    And championship participants are:
      | Team              | Path to Final    |
      | Mahomes' Militia  | #1 seed, 2-0     |
      | Bills Mafia       | #2 seed, 2-0     |
    When championship matchup is created
    Then Super Bowl matchup displays:
      | Detail               | Value                    |
      | Title                | League Championship      |
      | Date                 | February 9, 2025         |
      | Matchup              | Mahomes' Militia vs Bills|
      | Stakes               | $400 first place prize   |

  Scenario: Display championship preview
    Given championship matchup is set
    When viewing championship preview
    Then preview shows:
      | Section              | Content                        |
      | Season Summary       | Both teams' playoff journey    |
      | Statistical Matchup  | Head-to-head stats comparison  |
      | Key Players          | Top performers for each team   |
      | Expert Predictions   | Win probability, projected score|
      | Historical Context   | Past championships, records    |

  Scenario: Apply championship week bonuses
    Given league has Super Bowl bonuses
    When championship scoring includes:
      | Bonus Type           | Condition         | Points |
      | Super Bowl MVP pick  | Correct pick      | 10     |
      | Exact score predict  | Within 5 points   | 5      |
    Then bonuses are applied if earned
    And bonus impact is shown

  Scenario: Determine league champion
    Given Super Bowl matchup is complete
    And final scores are:
      | Team              | Score  |
      | Mahomes' Militia  | 175.5  |
      | Bills Mafia       | 168.0  |
    When champion is determined
    Then Mahomes' Militia is league champion
    And championship trophy is awarded
    And celebration notification is sent
    And league history is updated

  Scenario: Handle championship tie
    Given Super Bowl ends in tie
    When all tiebreakers are applied
    And tie remains unbroken
    Then co-champions are declared
    And first place prize is split equally
    And both teams receive championship recognition

  Scenario: Award championship prizes
    Given champion is determined
    When prizes are distributed:
      | Place | Team              | Prize   |
      | 1st   | Mahomes' Militia  | $400    |
      | 2nd   | Bills Mafia       | $150    |
      | 3rd   | Bird Gang         | $50     |
    Then payments are processed
    And winners are notified
    And financial records are updated

  Scenario: Display championship celebration
    Given league champion is determined
    When championship page is viewed
    Then celebration includes:
      | Element              | Display                   |
      | Champion banner      | Team name and logo        |
      | Final score          | Championship matchup      |
      | Playoff journey      | Round-by-round results    |
      | MVP                  | Top performer             |
      | Trophy animation     | Virtual trophy display    |

  # ==================== PLAYOFF PROJECTIONS ====================

  Scenario: Generate playoff advancement projections
    Given playoffs are in progress
    When projections are calculated
    Then advancement probabilities show:
      | Team              | Div Round | Conf Round | Super Bowl | Champion |
      | Mahomes' Militia  | 100%      | 72%        | 48%        | 28%      |
      | Bills Mafia       | 100%      | 68%        | 42%        | 25%      |
      | Bird Gang         | -         | 55%        | 32%        | 18%      |
      | Team Five         | -         | 45%        | 22%        | 12%      |

  Scenario: Update projections after each round
    Given Wild Card round has completed
    When projections are recalculated
    Then probabilities update:
      | Change Type          | Impact                    |
      | Eliminated teams     | Drop to 0% advancement    |
      | Winners              | Increase probability      |
      | Matchup knowledge    | More accurate projections |

  Scenario: Display projected matchup outcomes
    Given upcoming matchup projections exist
    When viewing projected results
    Then projections show:
      | Matchup                   | Favorite         | Win Prob | Proj Score |
      | Mahomes vs Team Five      | Mahomes' Militia | 62%      | 165-152    |
      | Bills vs Bird Gang        | Bills Mafia      | 58%      | 162-155    |

  Scenario: Compare projection sources
    Given multiple projection models exist
    When viewing projection comparison
    Then comparison shows:
      | Team              | Model A | Model B | Model C | Average |
      | Mahomes' Militia  | 28%     | 32%     | 26%     | 28.7%   |
      | Bills Mafia       | 25%     | 22%     | 27%     | 24.7%   |
    And methodology is explained

  Scenario: Display what-if playoff scenarios
    Given user wants to explore scenarios
    When running what-if analysis:
      | Scenario                  | Result                    |
      | If Team A wins by 20+     | 75% to reach Super Bowl   |
      | If Team A wins by < 10    | 60% to reach Super Bowl   |
      | If Team A loses           | Season over               |
    Then scenario outcomes are displayed

  Scenario: Track projection accuracy
    Given historical projections exist
    When analyzing accuracy
    Then accuracy metrics show:
      | Metric               | Value  |
      | Correct winner picks | 78%    |
      | Average point diff   | 8.5    |
      | Champion prediction  | 35%    |

  # ==================== PLAYOFF HISTORY ====================

  Scenario: Display league playoff history
    Given multiple seasons have completed
    When viewing playoff history
    Then history shows:
      | Season | Champion         | Runner-Up   | Score     |
      | 2024   | Mahomes' Militia | Bills Mafia | 175-168   |
      | 2023   | Bird Gang        | Purple Reign| 165-158   |
      | 2022   | Bills Mafia      | Team Five   | 178-172   |

  Scenario: Display all-time playoff records
    Given comprehensive history exists
    When viewing records
    Then records show:
      | Record                    | Holder           | Value   | Year |
      | Highest championship score| Mahomes' Militia | 192.5   | 2022 |
      | Most playoff appearances  | Bills Mafia      | 6       | All  |
      | Longest playoff streak    | Mahomes' Militia | 4       | '21-'24|
      | Most championships        | Bills Mafia      | 3       | All  |

  Scenario: Display team playoff history
    Given viewing specific team history
    When viewing "Mahomes' Militia" playoff history
    Then history shows:
      | Season | Seed | Result      | Points | Key Player   |
      | 2024   | 1    | Champion    | 516.0  | P. Mahomes   |
      | 2023   | 2    | Semifinal   | 320.5  | T. Kelce     |
      | 2022   | 4    | Runner-up   | 485.0  | P. Mahomes   |

  Scenario: Display head-to-head playoff history
    Given two teams have playoff history
    When viewing "Mahomes' Militia" vs "Bills Mafia"
    Then history shows:
      | Season | Round      | Winner           | Score     |
      | 2024   | Super Bowl | Mahomes' Militia | 175-168   |
      | 2023   | Divisional | Bills Mafia      | 162-158   |
      | 2022   | Conference | Bills Mafia      | 168-165   |
    And series record: Bills Mafia leads 2-1

  Scenario: Archive playoff season
    Given season has concluded
    When season is archived
    Then archive preserves:
      | Data Type          | Preserved |
      | Bracket            | Yes       |
      | All matchup scores | Yes       |
      | Weekly rosters     | Yes       |
      | Transaction log    | Yes       |
      | Final standings    | Yes       |

  Scenario: Export playoff history report
    Given comprehensive history exists
    When exporting history
    Then report includes:
      | Section              |
      | Championship results |
      | Record book          |
      | Team histories       |
      | Player performances  |
    And export formats: PDF, CSV

  # ==================== PLAYOFF SETTINGS ====================

  Scenario: Configure playoff format
    Given commissioner sets up playoffs
    When playoff format is configured:
      | Setting              | Value              |
      | Playoff Teams        | 8                  |
      | Rounds               | 4                  |
      | Bye Weeks            | Top 2 seeds        |
      | Reseeding            | No                 |
      | Consolation          | Yes                |
    Then format is saved
    And format is displayed to league

  Scenario: Configure playoff seeding rules
    Given commissioner sets seeding
    When seeding rules are configured:
      | Rule                 | Priority |
      | Record               | 1        |
      | Head-to-head         | 2        |
      | Points for           | 3        |
      | Points against       | 4        |
      | Division winner      | Bonus    |
    Then seeding rules are applied

  Scenario: Configure playoff scoring settings
    Given commissioner sets playoff scoring
    When scoring is configured:
      | Setting              | Value              |
      | Scoring Type         | PPR                |
      | Playoff Multiplier   | 1.0                |
      | Bonus Points         | Enabled            |
      | Negative Points      | Allowed            |
    Then scoring applies to all playoff rounds

  Scenario: Configure playoff roster settings
    Given commissioner sets roster rules
    When roster settings are configured:
      | Setting              | Value              |
      | Lock Type            | Game time lock     |
      | IR Slots             | 1                  |
      | Transactions         | Allowed until SB   |
      | Trade Deadline       | Conference week    |
    Then roster rules are enforced

  Scenario: Configure playoff tiebreaker rules
    Given commissioner sets tiebreakers
    When tiebreaker cascade is configured:
      | Priority | Rule                          |
      | 1        | Highest single position score |
      | 2        | Most touchdowns               |
      | 3        | Fewer turnovers               |
      | 4        | Higher seed                   |
    Then tiebreakers apply in order

  Scenario: Lock playoff settings after start
    Given playoffs have begun
    When commissioner attempts to change:
      | Setting              | Change Allowed |
      | Scoring rules        | No             |
      | Roster positions     | No             |
      | Schedule times       | Yes (emergency)|
      | Prize structure      | No             |
    Then critical settings are locked
    And only schedule can be adjusted

  Scenario: Configure playoff notifications
    Given notification settings exist
    When playoff notifications are configured:
      | Notification         | Timing           |
      | Roster lock reminder | 24h, 1h before   |
      | Matchup start        | At kickoff       |
      | Score updates        | Real-time        |
      | Round results        | At completion    |
    Then notifications are sent per schedule

  Scenario: Display playoff rules to members
    Given playoff settings are configured
    When member views playoff rules
    Then display shows:
      | Section              | Content                    |
      | Format               | 8-team, 4 rounds           |
      | Seeding              | By regular season record   |
      | Scoring              | PPR with bonuses           |
      | Tiebreakers          | Cascading rules list       |
      | Schedule             | Round dates and lock times |
      | Prizes               | Distribution structure     |
