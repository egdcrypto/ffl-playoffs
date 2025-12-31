@backend @priority_1 @gamification
Feature: Gamification System
  As a fantasy football playoffs application
  I want to provide experience points, achievements, badges, levels, challenges, missions, events, rewards, streaks, and gamified leaderboards
  So that players are engaged, motivated, and rewarded for their participation throughout the playoff season

  Background:
    Given a league "2025 NFL Playoffs Pool" exists
    And the gamification system is enabled for the league
    And player "john_doe" is an active participant in the league
    And the current date and time are tracked for time-based features

  # ==================== EXPERIENCE POINTS (XP) ====================

  Scenario: Award XP for completing a roster submission
    Given player "john_doe" has not yet submitted their Wild Card roster
    When "john_doe" successfully submits a complete roster for Wild Card round
    Then "john_doe" earns 100 XP for roster submission
    And an XP transaction record is created with source "ROSTER_SUBMISSION"
    And "john_doe" receives a notification about the XP earned

  Scenario: Award XP for winning a matchup
    Given player "john_doe" completes a Wild Card matchup against "bob_player"
    And "john_doe" wins with score 152.3 to 138.7
    When the matchup result is finalized
    Then "john_doe" earns 250 XP for winning the matchup
    And bonus XP of 50 is awarded for margin of victory over 10 points
    And total XP earned for the matchup is 300

  Scenario: Award XP for high-scoring performance
    Given player "john_doe" scores 175.5 points in Divisional round
    And the league average score for that round is 135.0 points
    When scoring is finalized
    Then "john_doe" earns 150 bonus XP for scoring 30% above average
    And an XP transaction with source "HIGH_PERFORMANCE" is recorded

  Scenario: Award XP for daily login
    Given player "john_doe" has not logged in today
    When "john_doe" logs into the application
    Then "john_doe" earns 10 XP for daily login
    And the daily login is recorded with timestamp
    And "john_doe" cannot earn another daily login XP until tomorrow

  Scenario: Award XP for making correct predictions
    Given player "john_doe" predicted Chiefs would beat Ravens in Divisional
    And the Chiefs defeat the Ravens in the actual game
    When prediction results are processed
    Then "john_doe" earns 75 XP for the correct prediction
    And prediction accuracy statistics are updated

  Scenario: View XP transaction history
    Given player "john_doe" has earned XP from multiple sources
    When "john_doe" views their XP history
    Then the history displays:
      | Date       | Source              | Amount | Balance |
      | 2025-01-11 | ROSTER_SUBMISSION   | 100    | 100     |
      | 2025-01-12 | DAILY_LOGIN         | 10     | 110     |
      | 2025-01-13 | MATCHUP_WIN         | 300    | 410     |
      | 2025-01-14 | CORRECT_PREDICTION  | 75     | 485     |
    And total XP balance is displayed prominently

  Scenario: Prevent duplicate XP awards for same action
    Given player "john_doe" already submitted Wild Card roster and received XP
    When "john_doe" updates their Wild Card roster
    Then no additional roster submission XP is awarded
    And the system records the update without XP transaction

  Scenario: Calculate XP multipliers during special events
    Given a "Double XP Weekend" event is active
    And the XP multiplier is set to 2.0
    When player "john_doe" earns 100 XP for roster submission
    Then the actual XP awarded is 200
    And the transaction shows base amount 100 with multiplier 2.0

  # ==================== ACHIEVEMENT SYSTEM ====================

  Scenario: Unlock achievement for first matchup win
    Given player "john_doe" has never won a playoff matchup
    When "john_doe" wins their first matchup
    Then achievement "First Blood" is unlocked
    And achievement details show:
      | name        | First Blood                          |
      | description | Win your first playoff matchup       |
      | rarity      | COMMON                               |
      | xp_reward   | 500                                  |
      | icon        | trophy_bronze                        |
    And a celebratory notification is displayed

  Scenario: Unlock achievement for perfect roster week
    Given player "john_doe" submitted a roster where every player scored points
    And no roster slots had zero-point performances
    When scoring is finalized for the round
    Then achievement "No Zeros" is unlocked
    And "john_doe" earns 350 XP achievement bonus

  Scenario: Unlock tiered achievement for consecutive wins
    Given player "john_doe" has won 2 consecutive matchups
    When "john_doe" wins their 3rd consecutive matchup
    Then achievement "Hot Streak - Bronze" is unlocked for 3 wins
    And the achievement has progression toward next tier:
      | current_tier  | Bronze    |
      | next_tier     | Silver    |
      | progress      | 3/5       |
      | next_unlock   | 2 more wins |

  Scenario: Track achievement progress for incomplete achievements
    Given achievement "Road to Glory" requires winning the championship
    And player "john_doe" has reached the Conference round
    When "john_doe" views the achievement
    Then progress shows:
      | requirement       | Win the championship    |
      | current_progress  | Conference Finals       |
      | status            | IN_PROGRESS             |
      | rounds_remaining  | 2                       |

  Scenario: Unlock secret achievement for rare event
    Given player "john_doe" wins a matchup by exactly 0.1 points
    When the matchup result is finalized
    Then secret achievement "Photo Finish" is revealed and unlocked
    And the achievement was previously hidden from the achievement list
    And "john_doe" earns 1000 XP for the rare achievement

  Scenario: Display achievement showcase on player profile
    Given player "john_doe" has unlocked 15 achievements
    And "john_doe" has selected 5 achievements to showcase
    When another player views "john_doe" profile
    Then the showcase displays the 5 selected achievements
    And total achievement count shows 15 unlocked
    And achievement completion percentage is displayed

  Scenario: Award retroactive achievements for historical performance
    Given player "john_doe" participated in 3 previous playoff seasons
    And achievement "Veteran" requires 3 seasons of participation
    When the gamification system processes historical data
    Then "Veteran" achievement is retroactively unlocked
    And unlock date reflects the date criteria was met

  Scenario: Prevent achievement farming through repeated actions
    Given achievement "Roster Tweaker" requires 10 roster updates
    And player "john_doe" has made 8 roster updates
    When "john_doe" makes 5 updates within 1 minute
    Then only 2 updates count toward the achievement
    And rate limiting message is displayed
    And achievement unlocks at 10 valid updates

  # ==================== BADGE COLLECTION ====================

  Scenario: Award participation badge for joining playoffs
    Given player "john_doe" joins the 2025 playoff pool
    When their registration is confirmed
    Then badge "2025 Playoff Participant" is awarded
    And the badge includes:
      | name       | 2025 Playoff Participant           |
      | type       | PARTICIPATION                       |
      | year       | 2025                               |
      | rarity     | COMMON                             |
      | image_url  | /badges/2025-participant.png       |

  Scenario: Award position-based excellence badge
    Given player "john_doe" has the highest scoring QB across all Wild Card rosters
    When Wild Card round is finalized
    Then badge "QB Whisperer - Wild Card" is awarded
    And badge is unique to that round and position

  Scenario: Award championship badge to winner
    Given player "john_doe" wins the Super Bowl championship matchup
    When the final results are processed
    Then badge "2025 Playoff Champion" is awarded
    And the badge is marked as LEGENDARY rarity
    And the badge has animated visual effects
    And badge is permanently displayed on profile

  Scenario: Display badge collection gallery
    Given player "john_doe" has collected 25 badges over 3 seasons
    When "john_doe" views their badge collection
    Then badges are organized by category:
      | Category        | Count |
      | Championship    | 1     |
      | Seasonal        | 8     |
      | Achievement     | 10    |
      | Participation   | 6     |
    And filter options allow viewing by year, rarity, or category

  Scenario: Award limited edition event badge
    Given "Super Bowl Special Event" is active
    And player "john_doe" completes all Super Bowl challenges
    When the event ends
    Then limited edition badge "Super Bowl LVIII Superfan" is awarded
    And badge shows total number ever awarded across all players
    And badge cannot be earned after event ends

  Scenario: Trade duplicate badges between players
    Given badge trading is enabled for the league
    And player "john_doe" has duplicate badge "Weekly Winner - Wild Card"
    And player "jane_doe" wants the badge
    When "john_doe" initiates a badge trade with "jane_doe"
    Then trade request is sent to "jane_doe"
    And "jane_doe" can accept or decline the trade
    And trade history is recorded for both players

  Scenario: Display badge rarity statistics
    Given badge "Perfect Week" has been awarded 50 times
    And total players across all seasons is 5000
    When viewing badge details
    Then rarity statistics show:
      | times_awarded    | 50          |
      | total_players    | 5000        |
      | percentage       | 1.0%        |
      | rarity_tier      | EPIC        |

  # ==================== LEVEL PROGRESSION ====================

  Scenario: Level up when XP threshold is reached
    Given player "john_doe" is at Level 5 with 2450 XP
    And Level 6 requires 2500 XP
    When "john_doe" earns 100 XP from a matchup win
    Then "john_doe" advances to Level 6
    And a level up celebration animation is displayed
    And level up notification is sent
    And level up rewards are granted

  Scenario: Calculate XP requirements for progressive levels
    Given the XP formula is exponential with base 500 and factor 1.2
    When calculating level requirements
    Then level thresholds are:
      | Level | XP Required | Cumulative XP |
      | 1     | 0           | 0             |
      | 2     | 500         | 500           |
      | 3     | 600         | 1100          |
      | 4     | 720         | 1820          |
      | 5     | 864         | 2684          |
      | 10    | 1792        | 8916          |
      | 20    | 5160        | 38745         |

  Scenario: Grant rewards upon reaching milestone levels
    Given player "john_doe" reaches Level 10
    When level up processing completes
    Then milestone rewards are granted:
      | reward_type        | description                    |
      | TITLE              | "Playoff Veteran" title        |
      | AVATAR_FRAME       | Gold frame for profile avatar  |
      | BADGE              | "Level 10 Elite" badge         |
      | XP_BOOST           | 10% XP boost for 7 days        |

  Scenario: Display level progress bar
    Given player "john_doe" is Level 7 with 4200 cumulative XP
    And Level 8 requires 5100 cumulative XP
    When "john_doe" views their profile
    Then the level progress shows:
      | current_level     | 7           |
      | current_xp        | 4200        |
      | next_level_xp     | 5100        |
      | xp_remaining      | 900         |
      | progress_percent  | 73%         |

  Scenario: Handle max level cap
    Given player "john_doe" has reached Level 100 (maximum level)
    And "john_doe" continues to earn XP
    When "john_doe" earns 500 additional XP
    Then "john_doe" remains at Level 100
    And excess XP is tracked as "Prestige XP"
    And prestige rewards become available

  Scenario: Enable prestige system after max level
    Given player "john_doe" is at Level 100 with 50000 Prestige XP
    When "john_doe" chooses to "Prestige"
    Then "john_doe" resets to Level 1
    And "john_doe" receives Prestige Star 1 badge
    And a 5% permanent XP bonus is applied
    And previous achievements are retained
    And prestige count is displayed on profile

  Scenario: Compare level with other players
    Given player "john_doe" is Level 15
    And the league has 50 players
    When "john_doe" views level rankings
    Then rankings show:
      | Rank | Player       | Level | XP      |
      | 1    | alice_player | 22    | 42000   |
      | 2    | bob_player   | 20    | 38500   |
      | 15   | john_doe     | 15    | 12500   |
    And "john_doe" sees their league percentile

  # ==================== DAILY CHALLENGES ====================

  Scenario: Generate new daily challenges at midnight
    Given it is midnight in the league's configured timezone
    When the daily challenge system runs
    Then 3 new daily challenges are generated for each player
    And challenges are tailored based on current playoff round
    And previous day's incomplete challenges expire
    And players are notified of new challenges

  Scenario: Complete daily challenge for roster optimization
    Given player "john_doe" has daily challenge "Roster Perfectionist"
    And the challenge requires updating roster with 3 different players
    When "john_doe" makes 3 roster changes with different players
    Then challenge "Roster Perfectionist" is marked complete
    And 150 XP reward is granted
    And daily challenge progress updates to "1/3 Complete"

  Scenario: Display active daily challenges
    Given player "john_doe" has 3 active daily challenges
    When "john_doe" views their daily challenges
    Then challenges display:
      | Challenge             | Description                      | Progress | Reward | Expires    |
      | Social Butterfly      | Comment on 2 matchups            | 1/2      | 100 XP | 8h 30m     |
      | Prediction Pro        | Make 3 game predictions          | 0/3      | 125 XP | 8h 30m     |
      | Early Bird            | Log in before 9 AM               | Complete | 50 XP  | Claimed    |

  Scenario: Refresh single daily challenge
    Given player "john_doe" does not want to complete "Prediction Pro" challenge
    And "john_doe" has 1 daily refresh available
    When "john_doe" uses refresh on "Prediction Pro"
    Then "Prediction Pro" is replaced with a different challenge
    And refresh count decreases to 0
    And the new challenge has same or similar difficulty

  Scenario: Scale daily challenge difficulty based on level
    Given player "john_doe" is Level 5
    And player "jane_doe" is Level 15
    When daily challenges are generated
    Then "john_doe" receives challenges with EASY to MEDIUM difficulty
    And "jane_doe" receives challenges with MEDIUM to HARD difficulty
    And rewards scale with difficulty:
      | Difficulty | XP Range    |
      | EASY       | 50-100      |
      | MEDIUM     | 100-200     |
      | HARD       | 200-350     |

  Scenario: Award bonus for completing all daily challenges
    Given player "john_doe" has completed 2 of 3 daily challenges
    When "john_doe" completes the final daily challenge
    Then individual challenge reward of 125 XP is granted
    And bonus "Daily Sweep" reward of 200 XP is granted
    And badge "Daily Dominator" progress increases

  Scenario: Track daily challenge streak
    Given player "john_doe" has completed all daily challenges for 6 consecutive days
    When "john_doe" completes all challenges on day 7
    Then streak counter increases to 7 days
    And weekly streak bonus of 500 XP is awarded
    And streak badge "Week Warrior" is unlocked

  # ==================== WEEKLY MISSIONS ====================

  Scenario: Assign weekly missions at start of playoff round
    Given Wild Card round begins on Saturday
    When the weekly mission system activates
    Then 5 weekly missions are assigned to each player:
      | Mission                  | Requirement                    | Reward   |
      | Wild Card Warrior        | Score 140+ points              | 400 XP   |
      | Underdog Champion        | Start 2 players from underdog teams | 300 XP |
      | Social Star              | Share roster on social media   | 200 XP   |
      | Analyst                  | View 10 player stat pages      | 150 XP   |
      | Community Contributor    | Post 5 league comments         | 250 XP   |
    And mission timer shows days remaining until round ends

  Scenario: Track weekly mission progress
    Given player "john_doe" has mission "Score 140+ points in Wild Card"
    And "john_doe" currently has 128.5 points with 1 game remaining
    When "john_doe" views the mission
    Then progress shows:
      | current_score     | 128.5         |
      | target_score      | 140           |
      | remaining_points  | 11.5          |
      | status            | IN_PROGRESS   |
      | players_remaining | 1             |

  Scenario: Complete weekly mission for matchup performance
    Given player "john_doe" has mission "Win Wild Card matchup by 15+ points"
    And "john_doe" beats opponent 155.5 to 132.0
    When matchup results are finalized
    Then mission "Win by 15+ points" is completed
    And 500 XP mission reward is granted
    And mission completion is recorded with timestamp

  Scenario: Handle mission failure gracefully
    Given player "john_doe" has mission "Score 150+ points"
    And Wild Card round ends with "john_doe" scoring 142.3 points
    When the round finalizes
    Then mission "Score 150+ points" is marked FAILED
    And no penalty is applied
    And mission stats show 0/1 completion for this mission type

  Scenario: Award weekly mission completion tier rewards
    Given player "john_doe" completed weekly missions:
      | Completed | Total |
      | 4         | 5     |
    When weekly rewards are processed
    Then tier reward "Gold" is granted for 4+ completions
    And tier rewards are:
      | Tier     | Missions | Bonus XP |
      | Bronze   | 2        | 200      |
      | Silver   | 3        | 400      |
      | Gold     | 4        | 700      |
      | Platinum | 5        | 1200     |

  Scenario: Display weekly mission leaderboard
    Given all players have weekly mission progress
    When viewing weekly mission leaderboard
    Then rankings show:
      | Rank | Player       | Missions Complete | Total XP Earned |
      | 1    | alice_player | 5/5               | 2500            |
      | 2    | jane_doe     | 4/5               | 1950            |
      | 5    | john_doe     | 3/5               | 1200            |

  Scenario: Carry over partial mission progress between rounds
    Given player "john_doe" has multi-round mission "Score 400+ total playoff points"
    And "john_doe" scored 145.5 in Wild Card
    When Divisional round begins
    Then mission progress shows:
      | cumulative_score  | 145.5         |
      | target            | 400           |
      | progress_percent  | 36%           |
      | rounds_remaining  | 3             |

  # ==================== SEASONAL EVENTS ====================

  Scenario: Launch Wild Card Weekend event
    Given Wild Card Weekend is approaching
    When the event activates on Friday at 6 PM
    Then "Wild Card Frenzy" event begins
    And event features include:
      | Feature                    | Description                         |
      | Double XP                  | All XP earnings doubled             |
      | Exclusive Challenges       | 5 limited-time challenges           |
      | Special Badge              | "Wild Card Warrior 2025" available  |
      | Bonus Predictions          | Extra prediction opportunities      |
    And event banner is displayed on dashboard
    And event countdown timer shows duration

  Scenario: Track seasonal event progress
    Given "Wild Card Frenzy" event is active
    And event has 5 exclusive challenges
    And player "john_doe" has completed 3 challenges
    When "john_doe" views event progress
    Then progress displays:
      | challenges_complete | 3/5          |
      | event_xp_earned     | 1500         |
      | event_rank          | 12th         |
      | time_remaining      | 1d 5h 30m    |
      | rewards_unlocked    | 2/4 tiers    |

  Scenario: Award seasonal event exclusive rewards
    Given "Divisional Drama" event is ending
    And player "john_doe" completed all event objectives
    When event concludes
    Then exclusive rewards are distributed:
      | Reward Type      | Item                              |
      | Badge            | Divisional Dynasty 2025           |
      | Avatar           | Special playoff-themed avatar     |
      | Title            | "Divisional Dominator"            |
      | XP Bonus         | 2000 bonus XP                     |
    And rewards are marked as "Event Exclusive - Not Available Again"

  Scenario: Display seasonal event calendar
    Given it is the start of playoff season
    When player views event calendar
    Then upcoming events are shown:
      | Event                    | Start Date | End Date   | Status      |
      | Wild Card Frenzy         | Jan 11     | Jan 13     | UPCOMING    |
      | Divisional Drama         | Jan 18     | Jan 20     | SCHEDULED   |
      | Conference Championship  | Jan 25     | Jan 27     | SCHEDULED   |
      | Super Bowl Spectacular   | Feb 9      | Feb 10     | SCHEDULED   |

  Scenario: Trigger surprise flash event
    Given no scheduled events are active
    When a major NFL playoff upset occurs
    Then "Upset Alert" flash event triggers
    And event duration is 4 hours
    And players can earn bonus XP for upset-related activities
    And push notification is sent to all players

  Scenario: Apply event-specific scoring modifiers
    Given "Super Bowl Spectacular" event is active
    And event includes 1.5x XP for Super Bowl predictions
    When player "john_doe" makes a correct Super Bowl prediction
    Then base XP of 100 is multiplied by 1.5
    And total XP awarded is 150
    And modifier is displayed in XP transaction

  Scenario: Restrict event to qualified participants
    Given "Championship Contenders" event requires reaching Conference round
    And player "bob_player" was eliminated in Divisional round
    When "bob_player" attempts to access event challenges
    Then access is denied with message "Event requires Conference round qualification"
    And "bob_player" can view event details but not participate

  # ==================== REWARD SYSTEM ====================

  Scenario: Grant XP reward from loot box
    Given player "john_doe" earns a reward loot box
    When "john_doe" opens the loot box
    Then possible rewards include:
      | Type         | Probability | Examples                    |
      | XP_SMALL     | 40%         | 100-250 XP                  |
      | XP_MEDIUM    | 30%         | 250-500 XP                  |
      | XP_LARGE     | 15%         | 500-1000 XP                 |
      | BADGE        | 10%         | Random collectible badge    |
      | AVATAR_ITEM  | 5%          | Profile customization item  |
    And the reward is randomly selected and granted
    And opening animation is displayed

  Scenario: Claim streak protection reward
    Given player "john_doe" reaches a 14-day login streak
    When streak rewards are processed
    Then "Streak Shield" reward is granted
    And the shield allows one missed day without breaking streak
    And shield is visible in inventory

  Scenario: Exchange reward currency for items
    Given player "john_doe" has 5000 Playoff Points (reward currency)
    And the reward shop has items available
    When "john_doe" views the reward shop
    Then available items include:
      | Item                    | Cost    | Type         |
      | XP Boost (24h, 25%)     | 1000    | CONSUMABLE   |
      | Custom Avatar Frame     | 2500    | COSMETIC     |
      | Profile Banner          | 3000    | COSMETIC     |
      | Streak Shield           | 4000    | CONSUMABLE   |
      | Legendary Badge         | 10000   | COLLECTIBLE  |

  Scenario: Apply consumable reward boost
    Given player "john_doe" has "25% XP Boost" consumable
    When "john_doe" activates the boost
    Then boost is active for 24 hours
    And all XP earned is increased by 25%
    And boost timer is displayed on profile
    And boost cannot be stacked with same type

  Scenario: Earn reward currency from achievements
    Given player "john_doe" unlocks achievement "Triple Threat"
    And the achievement grants 500 Playoff Points
    When achievement is processed
    Then 500 Playoff Points are added to "john_doe" balance
    And points transaction is recorded
    And total Playoff Points balance is updated

  Scenario: Display reward history
    Given player "john_doe" has received multiple rewards
    When "john_doe" views reward history
    Then history shows:
      | Date       | Reward                  | Source              | Value      |
      | Jan 15     | 500 XP                  | Matchup Win         | 500 XP     |
      | Jan 14     | Bronze Badge            | Loot Box            | N/A        |
      | Jan 13     | 250 Playoff Points      | Weekly Mission      | 250 PP     |
      | Jan 12     | XP Boost (25%)          | Level Up Reward     | Consumable |

  Scenario: Limit reward redemptions per period
    Given player "john_doe" has purchased 3 items today
    And daily purchase limit is 3 items
    When "john_doe" attempts to purchase another item
    Then purchase is blocked
    And message "Daily purchase limit reached. Resets in 8h 30m" is displayed

  # ==================== STREAKS AND COMBOS ====================

  Scenario: Track daily login streak
    Given player "john_doe" has logged in for 5 consecutive days
    When "john_doe" logs in on day 6
    Then login streak increases to 6 days
    And streak milestone rewards are:
      | Days | Reward                    |
      | 3    | 50 XP                     |
      | 7    | 200 XP + Badge            |
      | 14   | 500 XP + Streak Shield    |
      | 30   | 1500 XP + Exclusive Title |

  Scenario: Break login streak after missed day
    Given player "john_doe" has a 12-day login streak
    And "john_doe" does not log in for 24 hours
    When "john_doe" logs in the following day
    Then login streak resets to 1 day
    And previous streak record is preserved in history
    And notification shows "Streak broken! Previous best: 12 days"

  Scenario: Protect streak with streak shield
    Given player "john_doe" has a 20-day login streak
    And "john_doe" has 1 Streak Shield in inventory
    And "john_doe" does not log in for 24 hours
    When the streak protection check runs
    Then Streak Shield is automatically consumed
    And login streak remains at 20 days
    And notification shows "Streak Shield used! Streak protected."

  Scenario: Award combo bonus for consecutive matchup wins
    Given player "john_doe" has won 3 consecutive matchups
    When "john_doe" wins their 4th consecutive matchup
    Then win streak increases to 4
    And combo multiplier of 1.2x is applied to win XP
    And base 250 XP becomes 300 XP with combo bonus
    And combo streak badge progress updates

  Scenario: Track prediction streak
    Given player "john_doe" has made 7 correct predictions in a row
    When "john_doe" makes another correct prediction
    Then prediction streak increases to 8
    And streak bonus of 25 XP is awarded
    And "Hot Predictor" visual indicator is displayed
    And streak leaderboard position updates

  Scenario: Display streak statistics dashboard
    Given player "john_doe" has multiple active streaks
    When "john_doe" views their streak dashboard
    Then dashboard shows:
      | Streak Type      | Current | Best   | Status     |
      | Daily Login      | 15      | 28     | ACTIVE     |
      | Matchup Wins     | 3       | 5      | ACTIVE     |
      | Predictions      | 0       | 12     | BROKEN     |
      | Challenge Comp.  | 7       | 7      | PERSONAL BEST |

  Scenario: Award end-of-season streak rewards
    Given playoff season is ending
    And player "john_doe" maintained streaks:
      | Streak Type   | Final Value |
      | Daily Login   | 28          |
      | Matchup Wins  | 4           |
    When season-end processing runs
    Then streak rewards are calculated:
      | Streak          | Reward              |
      | 28-Day Login    | 2000 XP + Badge     |
      | 4 Win Streak    | 1000 XP             |
    And seasonal streak records are archived

  Scenario: Stack combo bonuses from multiple sources
    Given player "john_doe" has:
      | Bonus Source          | Multiplier |
      | Win Streak (3)        | 1.1x       |
      | Daily Challenge Combo | 1.1x       |
      | Event Bonus           | 1.5x       |
    When "john_doe" earns 100 base XP
    Then multipliers stack multiplicatively: 100 * 1.1 * 1.1 * 1.5 = 181.5 XP
    And bonus breakdown is shown in XP transaction

  # ==================== LEADERBOARD GAMIFICATION ====================

  Scenario: Display XP-based leaderboard
    Given all players in the league have earned XP
    When viewing the XP leaderboard
    Then leaderboard shows:
      | Rank | Player       | Level | Total XP | Change |
      | 1    | alice_player | 22    | 42000    | -      |
      | 2    | bob_player   | 20    | 38500    | +1     |
      | 3    | jane_doe     | 19    | 35200    | -1     |
      | 15   | john_doe     | 15    | 12500    | +3     |
    And "Change" indicates movement since last update

  Scenario: Display achievement leaderboard
    Given all players have achievement progress
    When viewing the achievement leaderboard
    Then leaderboard shows:
      | Rank | Player       | Achievements | Completion % | Rarest Achievement  |
      | 1    | alice_player | 45/60        | 75%          | Perfect Season      |
      | 2    | jane_doe     | 42/60        | 70%          | Triple Crown        |
      | 10   | john_doe     | 28/60        | 47%          | Hot Streak Bronze   |

  Scenario: Display weekly leaderboard for time-boxed competition
    Given it is Divisional round
    And the weekly leaderboard resets each round
    When viewing weekly XP leaderboard
    Then leaderboard shows only XP earned during current round
    And previous round winners are highlighted
    And countdown to leaderboard reset is displayed

  Scenario: Award leaderboard position rewards
    Given Divisional round is ending
    And weekly leaderboard final standings are:
      | Rank | Player       | Weekly XP |
      | 1    | alice_player | 2500      |
      | 2    | bob_player   | 2350      |
      | 3    | jane_doe     | 2200      |
    When round ends and leaderboard finalizes
    Then position rewards are distributed:
      | Position | Reward                           |
      | 1st      | 1000 XP + Gold Badge + Title     |
      | 2nd      | 750 XP + Silver Badge            |
      | 3rd      | 500 XP + Bronze Badge            |
      | Top 10   | 250 XP                           |

  Scenario: Display friend-filtered leaderboard
    Given player "john_doe" has 5 friends in the league
    When "john_doe" views the friends-only leaderboard
    Then only friends are displayed in rankings
    And "john_doe" position shows relative to friends
    And option to view full league leaderboard is available

  Scenario: Track leaderboard position over time
    Given player "john_doe" wants to track their progress
    When "john_doe" views leaderboard history
    Then historical data shows:
      | Date       | XP Rank | Achievement Rank | Weekly Rank |
      | Jan 15     | 15      | 10               | 8           |
      | Jan 14     | 18      | 12               | 12          |
      | Jan 13     | 20      | 15               | -           |
    And trend graphs visualize progress over time

  Scenario: Generate end-of-season leaderboard awards
    Given playoff season has concluded
    When final leaderboard processing runs
    Then season awards are distributed:
      | Award                    | Winner       | Criteria                |
      | XP Champion              | alice_player | Most total XP           |
      | Achievement Hunter       | bob_player   | Most achievements       |
      | Streak Master            | jane_doe     | Longest combined streak |
      | Most Improved            | john_doe     | Biggest rank improvement|
    And awards include exclusive end-of-season badges
    And winners are announced in league feed

  Scenario: Display multi-league leaderboard comparison
    Given player "john_doe" participates in 3 leagues
    When "john_doe" views cross-league standings
    Then comparison shows:
      | League            | XP Rank | Percentile |
      | Main League       | 15/50   | Top 30%    |
      | Work League       | 3/20    | Top 15%    |
      | Family League     | 1/8     | 1st Place  |
    And aggregate statistics across leagues are displayed

  # ==================== GAMIFICATION SETTINGS AND CONTROLS ====================

  Scenario: Configure league gamification settings
    Given an admin is configuring league settings
    When the admin accesses gamification configuration
    Then configurable options include:
      | Setting                  | Options                        | Default |
      | XP System               | Enabled / Disabled             | Enabled |
      | Achievements            | Enabled / Disabled             | Enabled |
      | Daily Challenges        | Enabled / Disabled             | Enabled |
      | Leaderboards            | Public / Friends / Private     | Public  |
      | Notifications           | All / Important / None         | All     |
      | XP Multiplier Base      | 0.5x - 2.0x                    | 1.0x    |

  Scenario: Player opts out of gamification features
    Given player "john_doe" wants to minimize gamification
    When "john_doe" accesses gamification preferences
    Then options allow disabling:
      | Feature              | Effect                                |
      | XP Notifications     | No XP earn popups                     |
      | Achievement Popups   | Silent achievement unlocks            |
      | Leaderboard Display  | Hidden from public leaderboards       |
      | Challenge Reminders  | No daily/weekly challenge alerts      |
    And core features remain functional
    And progress still tracked in background

  Scenario: Reset gamification progress
    Given player "john_doe" wants to start fresh
    And "john_doe" confirms reset with password
    When the reset is processed
    Then the following are reset:
      | XP balance        | 0                  |
      | Level             | 1                  |
      | Streaks           | 0                  |
      | Challenge progress| Cleared            |
    And the following are preserved:
      | Achievements      | Kept               |
      | Badges            | Kept               |
      | Historical records| Kept               |
    And reset is logged for audit purposes

  Scenario: Display gamification onboarding for new players
    Given player "new_player" joins the league for the first time
    When "new_player" accesses the dashboard
    Then gamification tutorial is displayed
    And tutorial explains:
      | Topic            | Description                           |
      | XP System        | How to earn and track experience      |
      | Levels           | Progression and rewards               |
      | Achievements     | Unlockables and how to earn them      |
      | Daily Challenges | Daily tasks and streaks               |
      | Leaderboards     | Competition and rankings              |
    And completing tutorial grants 100 XP bonus
