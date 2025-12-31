@league-history @archives
Feature: League History
  As a fantasy football manager
  I want to view and explore league history
  So that I can celebrate past achievements and track legacy

  Background:
    Given I am logged in as a league member
    And the league "Playoff Champions" exists
    And the league has 5 years of history

  # ============================================================================
  # PAST SEASON RECORDS
  # ============================================================================

  @happy-path @past-seasons
  Scenario: View list of past seasons
    When I view league history
    Then I should see a list of all past seasons
    And I should see the champion for each season
    And I should see season date ranges

  @happy-path @past-seasons
  Scenario: View specific season summary
    When I select the 2023 season
    Then I should see the 2023 season summary
    And I should see final standings
    And I should see playoff results
    And I should see the champion

  @happy-path @past-seasons
  Scenario: View season statistics
    When I view 2023 season statistics
    Then I should see:
      | Statistic           | Value  |
      | Total Points Scored | 15,234 |
      | Highest Weekly Score| 185.4  |
      | Lowest Weekly Score | 52.3   |
      | Average Team Score  | 98.7   |
      | Closest Matchup     | 0.2    |

  @happy-path @past-seasons
  Scenario: View my performance across seasons
    When I view my historical performance
    Then I should see my record each season
    And I should see my playoff appearances
    And I should see my championships
    And I should see trends over time

  @happy-path @past-seasons
  Scenario: Compare two seasons
    When I compare 2022 and 2023 seasons
    Then I should see side-by-side statistics
    And I should see scoring differences
    And I should see competitive balance metrics

  # ============================================================================
  # CHAMPIONSHIP HISTORY
  # ============================================================================

  @happy-path @championships
  Scenario: View championship history
    When I view the championship history
    Then I should see all league champions
    And I should see championship game scores
    And I should see runner-ups each year

  @happy-path @championships
  Scenario: View championship details
    When I view the 2023 championship details
    Then I should see the matchup between finalists
    And I should see box scores for both teams
    And I should see key players and performances

  @happy-path @championships
  Scenario: View dynasty rankings
    When I view dynasty/championship counts
    Then I should see:
      | Manager    | Championships | Runner-Up | Finals Apps |
      | John Smith | 3             | 2         | 5           |
      | Jane Doe   | 2             | 1         | 3           |
      | Bob Jones  | 1             | 3         | 4           |

  @happy-path @championships
  Scenario: View championship winning rosters
    When I view the 2023 championship roster
    Then I should see the complete winning roster
    And I should see each player's contribution
    And I should see the MVP of the championship

  @happy-path @championships
  Scenario: View back-to-back champions
    When I view repeat champion history
    Then I should see any back-to-back winners
    And I should see longest championship droughts
    And I should see teams that have never won

  @happy-path @championships
  Scenario: Share championship celebration
    When I share my championship from 2023
    Then I should receive a shareable image
    And it should include the trophy graphic
    And it should be postable to social media

  # ============================================================================
  # ALL-TIME STANDINGS
  # ============================================================================

  @happy-path @all-time
  Scenario: View all-time standings
    When I view all-time standings
    Then I should see career records for all managers
    And I should see total wins and losses
    And I should see all-time win percentage

  @happy-path @all-time
  Scenario: View all-time points leaders
    When I view all-time points leaders
    Then I should see:
      | Rank | Manager    | Total Points | Seasons |
      | 1    | John Smith | 8,542.3      | 5       |
      | 2    | Jane Doe   | 8,123.7      | 5       |
      | 3    | Bob Jones  | 7,891.2      | 4       |

  @happy-path @all-time
  Scenario: View all-time head-to-head records
    When I view all-time head-to-head records
    Then I should see my record vs every manager
    And I should see my best and worst matchups
    And I should see the rivalry leader

  @happy-path @all-time
  Scenario: View manager career statistics
    When I view career stats for "John Smith"
    Then I should see:
      | Statistic              | Value    |
      | Career Record          | 52-28    |
      | Championships          | 3        |
      | Playoff Appearances    | 5        |
      | Best Season            | 2022     |
      | Highest Single Game    | 185.4    |
      | All-Time Ranking       | 1st      |

  @happy-path @all-time
  Scenario: View all-time playoff statistics
    When I view playoff history
    Then I should see playoff records by manager
    And I should see playoff win percentage
    And I should see most playoff wins

  # ============================================================================
  # HISTORICAL MATCHUPS
  # ============================================================================

  @happy-path @matchups
  Scenario: View historical matchup between two teams
    When I search for matchups between Team A and Team B
    Then I should see all historical games
    And I should see the all-time record
    And I should see notable matchups

  @happy-path @matchups
  Scenario: View highest scoring matchups all-time
    When I view highest scoring matchups
    Then I should see top combined score games
    And I should see the teams involved
    And I should see which season and week

  @happy-path @matchups
  Scenario: View closest matchups all-time
    When I view closest matchups
    Then I should see games decided by smallest margins
    And I should see any ties
    And I should see overtime/tiebreaker results

  @happy-path @matchups
  Scenario: View playoff matchup history
    When I view historical playoff matchups
    Then I should see all playoff games
    And I should see upset victories
    And I should see championship games

  @happy-path @matchups
  Scenario: View rivalry matchup history
    When I view rivalry matchups
    Then I should see designated rivalry games
    And I should see rivalry records
    And I should see most intense rivalry moments

  @happy-path @matchups
  Scenario: Search matchups by player
    When I search for matchups featuring "Patrick Mahomes"
    Then I should see games where Mahomes was rostered
    And I should see his historical performance
    And I should see which teams had him

  # ============================================================================
  # DRAFT ARCHIVES
  # ============================================================================

  @happy-path @drafts
  Scenario: View past drafts
    When I view draft history
    Then I should see all previous drafts
    And I should see draft dates
    And I should see draft types (snake, auction)

  @happy-path @drafts
  Scenario: View specific draft results
    When I view the 2023 draft
    Then I should see the complete draft board
    And I should see every pick in order
    And I should see team results by round

  @happy-path @drafts
  Scenario: View draft pick analysis
    When I view 2023 draft analysis
    Then I should see best value picks
    And I should see biggest reaches
    And I should see retrospective grades

  @happy-path @drafts
  Scenario: View my draft history
    When I view my historical draft picks
    Then I should see all my picks across seasons
    And I should see my draft success rate
    And I should see my best and worst picks

  @happy-path @drafts
  Scenario: View player draft history
    When I search for "Patrick Mahomes" draft history
    Then I should see when he was drafted each year
    And I should see his draft position by season
    And I should see his fantasy production

  @happy-path @drafts
  Scenario: Compare draft strategies
    When I compare draft strategies over time
    Then I should see position selection trends
    And I should see correlation with team success
    And I should see optimal draft strategies

  # ============================================================================
  # TRADE LOGS
  # ============================================================================

  @happy-path @trades
  Scenario: View all historical trades
    When I view trade history
    Then I should see all trades ever made
    And I should see trade dates
    And I should see assets exchanged

  @happy-path @trades
  Scenario: View trade details
    When I view a specific trade
    Then I should see both teams involved
    And I should see players and picks exchanged
    And I should see trade outcome analysis

  @happy-path @trades
  Scenario: View trade winners and losers
    When I view trade analysis
    Then I should see retrospective trade grades
    And I should see points gained/lost per trade
    And I should see biggest wins and losses

  @happy-path @trades
  Scenario: View manager trade history
    When I view "John Smith" trade history
    Then I should see all trades involving John
    And I should see his trade win percentage
    And I should see his most common trade partners

  @happy-path @trades
  Scenario: View most impactful trades
    When I view most impactful trades
    Then I should see trades that changed championships
    And I should see blockbuster multi-player deals
    And I should see dynasty-altering moves

  @happy-path @trades
  Scenario: Search trades by player
    When I search trades involving "Derrick Henry"
    Then I should see all trades featuring Henry
    And I should see his trade value over time
    And I should see trade outcomes

  # ============================================================================
  # RECORD BOOK
  # ============================================================================

  @happy-path @records
  Scenario: View league record book
    When I view the record book
    Then I should see categories:
      | Category              | Record Holder | Value  | Date       |
      | Highest Weekly Score  | Team A        | 195.4  | Week 3 '22 |
      | Lowest Weekly Score   | Team D        | 42.3   | Week 8 '21 |
      | Most Points (Season)  | Team B        | 1,623  | 2023       |
      | Longest Win Streak    | Team C        | 12     | 2022-2023  |

  @happy-path @records
  Scenario: View single-game records
    When I view single-game records
    Then I should see highest individual performances
    And I should see position records
    And I should see team records

  @happy-path @records
  Scenario: View season records
    When I view season records
    Then I should see best season performances
    And I should see most wins in a season
    And I should see most points in a season

  @happy-path @records
  Scenario: View my personal records
    When I view my personal record book
    Then I should see my best performances
    And I should see my team records
    And I should see where I rank all-time

  @happy-path @records
  Scenario: Track record approaching
    Given I scored 180 points this week
    When the record for highest score is 195.4
    Then I should see how close I came
    And I should see my ranking for that week
    And near-record performances should be highlighted

  @happy-path @records
  Scenario: View unbreakable records
    When I view hardest records to break
    Then I should see records with largest margins
    And I should see how long records have stood
    And I should see attempts to break them

  # ============================================================================
  # HALL OF FAME
  # ============================================================================

  @happy-path @hall-of-fame
  Scenario: View Hall of Fame
    When I view the Hall of Fame
    Then I should see inducted members
    And I should see their achievements
    And I should see induction dates

  @commissioner @hall-of-fame
  Scenario: Nominate Hall of Fame candidate
    Given I am the commissioner
    When I nominate "John Smith" for the Hall of Fame
    Then the nomination should be recorded
    And voting should open for league members
    And the candidate profile should be visible

  @happy-path @hall-of-fame
  Scenario: Vote for Hall of Fame inductee
    Given a Hall of Fame vote is active
    When I cast my vote for "John Smith"
    Then my vote should be recorded
    And I should see current voting results
    And I should see the voting deadline

  @happy-path @hall-of-fame
  Scenario: View Hall of Fame inductee profile
    When I view "John Smith" Hall of Fame profile
    Then I should see their complete achievements
    And I should see their best moments
    And I should see their career statistics

  @happy-path @hall-of-fame
  Scenario: View Hall of Fame criteria
    When I view Hall of Fame eligibility
    Then I should see the requirements
    And I should see voting thresholds
    And I should see who is eligible

  @happy-path @hall-of-fame
  Scenario: Retire jersey number
    Given I am the commissioner
    When I retire jersey number for a manager
    Then the number should be permanently reserved
    And it should display in the Hall of Fame
    And it should be honored at season start

  # ============================================================================
  # SEASON RECAPS
  # ============================================================================

  @happy-path @recaps
  Scenario: View season recap video/slideshow
    When I view the 2023 season recap
    Then I should see a summary presentation
    And I should see season highlights
    And I should see key moments

  @happy-path @recaps
  Scenario: View auto-generated season summary
    When I generate a season recap
    Then it should include:
      | Section                | Content                    |
      | Champion              | Team A crowned champion     |
      | Best Regular Season   | Team B finished 12-2        |
      | Biggest Upset         | 8-seed beat 1-seed in R1    |
      | Best Trade            | Team C's mid-season trade   |
      | Rookie of the Year    | First-year manager awards   |

  @happy-path @recaps
  Scenario: View weekly highlights from past season
    When I view Week 5 of 2023
    Then I should see that week's matchup results
    And I should see notable performances
    And I should see standings at that point

  @happy-path @recaps
  Scenario: Create custom season recap
    When I create a custom 2023 recap
    Then I should be able to add commentary
    And I should be able to select highlights
    And I should be able to share with league

  @happy-path @recaps
  Scenario: View playoff recap
    When I view 2023 playoff recap
    Then I should see bracket progression
    And I should see each round summary
    And I should see championship story

  @happy-path @recaps
  Scenario: Compare season to historical averages
    When I view 2023 season in context
    Then I should see how it compared to other years
    And I should see unique aspects of the season
    And I should see where it ranks historically

  # ============================================================================
  # STAT LEADERS
  # ============================================================================

  @happy-path @stat-leaders
  Scenario: View all-time stat leaders
    When I view all-time stat leaders
    Then I should see leaders by category:
      | Category        | Leader     | Value  |
      | Total Points    | John Smith | 8,542  |
      | Total Wins      | Jane Doe   | 58     |
      | Championships   | John Smith | 3      |
      | Playoff Wins    | Bob Jones  | 12     |

  @happy-path @stat-leaders
  Scenario: View season stat leaders
    When I view 2023 stat leaders
    Then I should see top performers for the season
    And I should see weekly high scorers
    And I should see category leaders

  @happy-path @stat-leaders
  Scenario: View position stat leaders
    When I view all-time QB scoring leaders
    Then I should see the QBs that scored most points
    And I should see which managers rostered them
    And I should see fantasy production

  @happy-path @stat-leaders
  Scenario: View consistency leaders
    When I view consistency statistics
    Then I should see lowest standard deviation
    And I should see most reliable performers
    And I should see floor/ceiling analysis

  @happy-path @stat-leaders
  Scenario: View waiver wire heroes
    When I view best waiver pickups
    Then I should see top waiver additions
    And I should see points gained from waivers
    And I should see FAAB efficiency

  @happy-path @stat-leaders
  Scenario: View bench point leaders
    When I view bench scoring statistics
    Then I should see who left most points on bench
    And I should see best lineup optimization
    And I should see missed opportunities

  # ============================================================================
  # LEGACY IMPORT
  # ============================================================================

  @commissioner @import
  Scenario: Import history from another platform
    Given I am the commissioner
    When I import history from ESPN
    Then I should upload the export file
    And the system should parse historical data
    And I should preview the import before confirming

  @commissioner @import
  Scenario: Import from Yahoo
    Given I am the commissioner
    When I import history from Yahoo Fantasy
    Then I should connect my Yahoo account
    And historical data should be pulled
    And I should map teams to current managers

  @commissioner @import
  Scenario: Import from Sleeper
    Given I am the commissioner
    When I import history from Sleeper
    Then I should provide league ID
    And the import should retrieve all seasons
    And data should be normalized to our format

  @commissioner @import
  Scenario: Manual history entry
    Given I am the commissioner
    When I manually enter historical data
    Then I should be able to add past seasons
    And I should enter standings and results
    And I should upload supporting documentation

  @commissioner @import
  Scenario: Validate imported data
    Given I have imported historical data
    When the system validates the import
    Then I should see any data inconsistencies
    And I should be able to correct errors
    And I should confirm the final import

  @commissioner @import
  Scenario: Merge duplicate managers
    Given multiple manager names exist for same person
    When I merge the duplicate entries
    Then all historical data should consolidate
    And statistics should combine correctly
    And the record book should update

  # ============================================================================
  # HISTORICAL COMPARISONS
  # ============================================================================

  @happy-path @comparisons
  Scenario: Compare managers across eras
    When I compare "John Smith" to "Jane Doe"
    Then I should see head-to-head record
    And I should see career statistics comparison
    And I should see era-adjusted metrics

  @happy-path @comparisons
  Scenario: Compare championship teams
    When I compare 2022 champion to 2023 champion
    Then I should see roster comparisons
    And I should see scoring comparisons
    And I should see which team was stronger

  @happy-path @comparisons
  Scenario: View era analysis
    When I view league eras
    Then I should see how the league has evolved
    And I should see scoring trends over time
    And I should see competitive balance changes

  @happy-path @comparisons
  Scenario: Compare my teams across seasons
    When I compare my 2022 and 2023 teams
    Then I should see roster differences
    And I should see performance comparison
    And I should see what improved/declined

  @happy-path @comparisons
  Scenario: Rank all-time greatest teams
    When I view greatest teams ranking
    Then I should see the best single-season teams
    And I should see ranking methodology
    And I should see current team comparisons

  @happy-path @comparisons
  Scenario: GOAT debate analysis
    When I view the GOAT analysis
    Then I should see arguments for top managers
    And I should see weighted scoring metrics
    And I should see the debate continue

  # ============================================================================
  # MOBILE / RESPONSIVE
  # ============================================================================

  @mobile @responsive
  Scenario: View league history on mobile
    Given I am using a mobile device
    When I view league history
    Then I should see a mobile-optimized layout
    And I should be able to navigate easily
    And all data should be accessible

  @mobile @responsive
  Scenario: Browse past seasons on mobile
    Given I am on mobile
    When I browse through seasons
    Then I should be able to swipe between years
    And I should see condensed information
    And I should tap to expand details

  @mobile @responsive
  Scenario: Share historical moments
    Given I am on mobile
    When I find a historic moment
    Then I should be able to share easily
    And it should format well for social media
    And I should be able to add commentary

  # ============================================================================
  # ACCESSIBILITY
  # ============================================================================

  @accessibility @a11y
  Scenario: Screen reader support for history
    Given I am using a screen reader
    When I navigate league history
    Then all content should be accessible
    And tables should be properly labeled
    And navigation should be clear

  @accessibility @a11y
  Scenario: Keyboard navigation for history
    Given I am using keyboard only
    When I browse historical data
    Then I should be able to tab through sections
    And I should access all interactive elements
    And focus should be visible

  # ============================================================================
  # ERROR HANDLING
  # ============================================================================

  @error @resilience
  Scenario: Handle missing historical data
    Given some historical data is incomplete
    When I view that season
    Then I should see available data
    And missing data should be indicated
    And I should be able to report issues

  @error @resilience
  Scenario: Handle import failures
    Given a legacy import fails partway
    When the error occurs
    Then partial data should not be saved
    And I should see the error details
    And I should be able to retry

  @error @resilience
  Scenario: Handle large history datasets
    Given the league has 20 years of history
    When I load the history page
    Then data should load progressively
    And I should not experience slowdowns
    And I should be able to filter by date range
