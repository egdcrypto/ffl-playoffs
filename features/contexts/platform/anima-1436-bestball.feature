@bestball @platform
Feature: Best Ball
  As a fantasy football player
  I need best ball league functionality
  So that I can enjoy a simplified fantasy experience with automatic lineup optimization

  Background:
    Given the best ball system is operational
    And best ball scoring rules are configured

  # ==================== Best Ball Scoring ====================

  @bestball-scoring @automatic-optimization
  Scenario: Automatically optimize lineup each week
    Given a best ball roster has multiple players at each position
    When the week's games are completed
    Then the system should automatically select the highest scorers
    And the optimal lineup should be calculated

  @bestball-scoring @automatic-optimization
  Scenario: Select best players for each position
    Given a team has the following WR scores for the week
      | player     | points |
      | WR1        | 22.5   |
      | WR2        | 18.3   |
      | WR3        | 15.7   |
      | WR4        | 8.2    |
    And the lineup requires 3 WRs
    Then WR1, WR2, and WR3 should be selected
    And WR4's points should not count

  @bestball-scoring @best-score-calculation
  Scenario: Calculate best possible score
    Given all player scores are finalized
    When calculating the team's best ball score
    Then the optimal combination should be computed
    And the highest possible score should be recorded

  @bestball-scoring @best-score-calculation
  Scenario: Handle flex position optimization
    Given multiple positions can fill the flex spot
    When optimizing the lineup
    Then the highest-scoring eligible player should fill flex
    And position requirements should still be met

  @bestball-scoring @position-optimization
  Scenario: Optimize across all positions
    Given a complete roster of players
    When the week concludes
    Then each position should be optimized independently
    And the total score should be the sum of optimal selections

  @bestball-scoring @position-optimization
  Scenario: Handle bye weeks automatically
    Given some players have bye weeks
    When calculating the best lineup
    Then players on bye should be excluded
    And depth players should fill in automatically

  @bestball-scoring @weekly-bestball
  Scenario: Track weekly best ball scores
    Given the season is in progress
    When viewing weekly results
    Then each week's optimal score should be displayed
    And player contributions should be shown

  @bestball-scoring @weekly-bestball
  Scenario: Compare actual vs potential scoring
    Given a week has completed
    When reviewing performance
    Then optimal score should be shown
    And points from each position should be detailed

  @bestball-scoring @cumulative-scoring
  Scenario: Accumulate season-long best ball points
    Given multiple weeks have been played
    When viewing season standings
    Then cumulative best ball scores should be totaled
    And rankings should reflect total points

  @bestball-scoring @cumulative-scoring
  Scenario: Track season-long performance trends
    Given a season of best ball data exists
    When analyzing performance
    Then weekly trends should be visible
    And consistency metrics should be calculated

  # ==================== Best Ball Drafts ====================

  @bestball-drafts @draft-lobby
  Scenario: Join best ball draft lobby
    Given best ball drafts are available
    When entering the draft lobby
    Then available drafts should be listed
    And entry requirements should be displayed

  @bestball-drafts @draft-lobby
  Scenario: Filter draft lobbies by criteria
    Given multiple draft options exist
    When filtering by preferences
    Then drafts should be filtered by
      | filter       | options                    |
      | entry_fee    | free, $5, $20, $50+        |
      | roster_size  | 18, 20, 24                 |
      | draft_type   | slow, fast, scheduled      |
      | scoring      | PPR, half-PPR, standard    |

  @bestball-drafts @slow-draft
  Scenario: Participate in slow draft
    Given a slow draft is in progress
    When it is my turn to pick
    Then I should have extended time to select
    And the draft should allow hours between picks

  @bestball-drafts @slow-draft
  Scenario: Configure slow draft timing
    Given a slow draft is being created
    When setting draft parameters
    Then pick timer options should include
      | timer_option | duration    |
      | standard     | 4 hours     |
      | extended     | 8 hours     |
      | relaxed      | 12 hours    |

  @bestball-drafts @fast-draft
  Scenario: Participate in fast draft
    Given a fast draft is scheduled
    When the draft begins
    Then picks should happen in real-time
    And a short pick timer should be enforced

  @bestball-drafts @fast-draft
  Scenario: Handle autopick in fast draft
    Given the pick timer expires
    When a selection isn't made
    Then the system should autopick
    And the best available player should be selected

  @bestball-drafts @draft-strategy
  Scenario: Apply best ball draft strategy
    Given best ball values differ from traditional
    When evaluating draft picks
    Then ceiling should be valued over floor
    And boom-bust players should have higher value

  @bestball-drafts @draft-strategy
  Scenario: Consider position scarcity in draft
    Given certain positions are scarce
    When making draft decisions
    Then positional strategy should be displayed
    And draft recommendations should be provided

  @bestball-drafts @position-stacking
  Scenario: Stack positions during draft
    Given stacking is a valid strategy
    When selecting players from same team
    Then stack opportunities should be highlighted
    And correlation potential should be shown

  @bestball-drafts @position-stacking
  Scenario: Identify stack opportunities
    Given the draft is in progress
    When viewing available players
    Then potential stacks should be identified
    And stack value should be displayed

  # ==================== Roster Construction ====================

  @roster-construction @roster-size
  Scenario: Configure best ball roster size
    Given best ball uses larger rosters
    When setting roster size
    Then expanded options should be available
      | roster_size | typical_use        |
      | 18          | standard best ball |
      | 20          | expanded           |
      | 24          | tournament         |

  @roster-construction @roster-size
  Scenario: Draft full roster
    Given a roster size is set
    When the draft completes
    Then all roster spots should be filled
    And no additional moves should be needed

  @roster-construction @position-limits
  Scenario: Enforce position limits
    Given position limits are configured
    When drafting players
    Then limits should be enforced
      | position | minimum | maximum |
      | QB       | 2       | 4       |
      | RB       | 4       | 8       |
      | WR       | 4       | 8       |
      | TE       | 2       | 4       |
      | K        | 1       | 2       |
      | DEF      | 1       | 2       |

  @roster-construction @position-limits
  Scenario: Warn about positional shortages
    Given a team has few players at a position
    When reviewing roster composition
    Then warnings should be displayed
    And bye week risks should be highlighted

  @roster-construction @roster-flexibility
  Scenario: Build flexible roster
    Given best ball rewards depth
    When constructing the roster
    Then flexibility should be prioritized
    And multiple startable options should be available

  @roster-construction @roster-flexibility
  Scenario: Balance starters and depth
    Given roster construction is important
    When evaluating the roster
    Then starter quality should be assessed
    And depth adequacy should be shown

  @roster-construction @depth-strategy
  Scenario: Implement depth strategy
    Given best ball uses all players
    When building roster depth
    Then depth at each position should be considered
    And ceiling players should be valued

  @roster-construction @depth-strategy
  Scenario: Evaluate depth at each position
    Given a completed roster exists
    When analyzing depth
    Then depth scores should be calculated
    And weak spots should be identified

  @roster-construction @stacking-players
  Scenario: Stack correlated players
    Given player stacking increases upside
    When building stacks
    Then QB-WR stacks should be available
    And game stacks should be possible

  @roster-construction @stacking-players
  Scenario: Track stack composition
    Given stacks have been built
    When viewing roster
    Then stacks should be identified
    And stack strength should be displayed

  # ==================== No Lineup Management ====================

  @no-management @set-and-forget
  Scenario: Play without weekly lineup decisions
    Given best ball is set-and-forget
    When the season progresses
    Then no lineup changes should be required
    And optimal lineups should be automatic

  @no-management @set-and-forget
  Scenario: Lock roster after draft
    Given the draft is complete
    When attempting roster changes
    Then changes should not be allowed
    And the roster should be locked

  @no-management @no-weekly-decisions
  Scenario: Eliminate weekly decision-making
    Given a best ball league is active
    When checking for required actions
    Then no lineup actions should be needed
    And the owner should have no required tasks

  @no-management @no-weekly-decisions
  Scenario: Skip start/sit decisions
    Given multiple players are at each position
    When games occur
    Then all players should be scored
    And best performers should automatically count

  @no-management @automatic-optimization
  Scenario: Trust automatic optimization
    Given the system optimizes lineups
    When reviewing results
    Then the optimal lineup should be guaranteed
    And no human error should be possible

  @no-management @automatic-optimization
  Scenario: Verify optimization accuracy
    Given a week has been scored
    When auditing the results
    Then the lineup should be mathematically optimal
    And no better combination should exist

  @no-management @hands-off-gameplay
  Scenario: Enjoy hands-off fantasy experience
    Given no management is required
    When participating in best ball
    Then the experience should be passive
    And engagement should be optional

  @no-management @hands-off-gameplay
  Scenario: Receive results without action
    Given the season progresses automatically
    When checking standings
    Then results should be available
    And no intervention should be needed

  @no-management @simplified-experience
  Scenario: Experience simplified fantasy
    Given best ball eliminates complexity
    When comparing to traditional fantasy
    Then time commitment should be minimal
    And stress should be reduced

  @no-management @simplified-experience
  Scenario: Focus on draft only
    Given the draft is the main activity
    When the draft completes
    Then active participation ends
    And results unfold automatically

  # ==================== Best Ball Tournaments ====================

  @tournaments @tournament-entry
  Scenario: Enter best ball tournament
    Given a best ball tournament is available
    When entering the tournament
    Then entry fee should be collected
    And roster should be drafted

  @tournaments @tournament-entry
  Scenario: View tournament details
    Given a tournament is available
    When viewing tournament info
    Then details should be displayed
      | detail        | included |
      | entry_fee     | yes      |
      | prize_pool    | yes      |
      | total_entries | yes      |
      | start_date    | yes      |

  @tournaments @multi-entry
  Scenario: Enter tournament multiple times
    Given multi-entry tournaments exist
    When entering multiple times
    Then each entry should have separate roster
    And entries should be tracked individually

  @tournaments @multi-entry
  Scenario: Manage multiple entries
    Given an owner has multiple entries
    When viewing their entries
    Then all entries should be listed
    And performance should be shown for each

  @tournaments @tournament-prizes
  Scenario: Display tournament prize structure
    Given a tournament has prizes
    When viewing prize details
    Then prize breakdown should be shown
      | position      | prize          |
      | 1st           | $100,000       |
      | 2nd-5th       | $10,000        |
      | 6th-20th      | $1,000         |
      | 21st-100th    | $100           |

  @tournaments @tournament-prizes
  Scenario: Award prizes to winners
    Given a tournament has concluded
    When determining prize winners
    Then prizes should be awarded correctly
    And payouts should be processed

  @tournaments @tournament-leaderboards
  Scenario: View tournament leaderboard
    Given a tournament is in progress
    When viewing the leaderboard
    Then all entries should be ranked
    And scores should be displayed

  @tournaments @tournament-leaderboards
  Scenario: Filter leaderboard view
    Given a large tournament leaderboard exists
    When filtering the view
    Then owners can filter by
      | filter        | description           |
      | my_entries    | show only my teams    |
      | top_100       | show leaders          |
      | by_position   | positional rankings   |

  @tournaments @tournament-payouts
  Scenario: Process tournament payouts
    Given the tournament has ended
    When processing payouts
    Then winners should receive prizes
    And payout status should be tracked

  @tournaments @tournament-payouts
  Scenario: Handle payout disputes
    Given a payout concern is raised
    When reviewing the dispute
    Then scoring should be verified
    And resolution should be provided

  # ==================== Best Ball Playoffs ====================

  @playoffs @playoff-qualification
  Scenario: Qualify for best ball playoffs
    Given playoff qualification is based on regular season
    When the regular season ends
    Then top scoring teams should qualify
    And qualification criteria should be applied

  @playoffs @playoff-qualification
  Scenario: Display qualification standings
    Given the season is in progress
    When viewing qualification race
    Then current standings should be shown
    And projection to qualify should be displayed

  @playoffs @playoff-scoring
  Scenario: Apply playoff scoring rules
    Given best ball playoffs have started
    When scoring playoff weeks
    Then playoff scoring rules should apply
    And multi-week scoring may be used

  @playoffs @playoff-scoring
  Scenario: Accumulate playoff scores
    Given playoffs span multiple weeks
    When calculating playoff scores
    Then scores should be accumulated
    And standings should update accordingly

  @playoffs @playoff-advancement
  Scenario: Advance in playoff rounds
    Given a playoff round has completed
    When determining advancement
    Then top scorers should advance
    And eliminated teams should be notified

  @playoffs @playoff-advancement
  Scenario: Handle ties in playoffs
    Given scores are tied after playoff week
    When determining advancement
    Then tiebreaker rules should apply
    And clear resolution should occur

  @playoffs @championship-rounds
  Scenario: Compete in championship round
    Given the championship round has begun
    When final scoring occurs
    Then champion should be determined
    And final rankings should be set

  @playoffs @championship-rounds
  Scenario: Award championship prizes
    Given the championship is complete
    When prizes are awarded
    Then champion should receive top prize
    And runner-up prizes should be distributed

  @playoffs @playoff-format
  Scenario: Configure playoff format
    Given different playoff formats exist
    When setting up playoffs
    Then format options should be available
      | format            | description                |
      | single_week       | one week playoff           |
      | multi_week        | cumulative playoff weeks   |
      | bracket           | elimination bracket        |
      | top_scorer        | highest total advances     |

  @playoffs @playoff-format
  Scenario: Display playoff bracket
    Given a bracket format is used
    When viewing playoff structure
    Then bracket should be displayed
    And matchups should be clear

  # ==================== Player Stacking ====================

  @stacking @team-stacks
  Scenario: Create team stacks
    Given stacking correlates player performance
    When building a team stack
    Then players from same team should be identified
    And stack potential should be shown

  @stacking @team-stacks
  Scenario: Evaluate team stack strength
    Given a team stack exists
    When analyzing the stack
    Then stack quality should be assessed
    And game script projections should be included

  @stacking @game-stacks
  Scenario: Build game stacks
    Given high-scoring games benefit multiple players
    When creating a game stack
    Then players from both teams should be included
    And shootout potential should be considered

  @stacking @game-stacks
  Scenario: Identify game stack opportunities
    Given game projections are available
    When viewing potential stacks
    Then high total games should be highlighted
    And stack suggestions should be made

  @stacking @correlation-strategy
  Scenario: Apply correlation strategy
    Given certain player combinations correlate
    When building stacks
    Then positive correlations should be leveraged
      | stack_type    | correlation |
      | QB + WR       | positive    |
      | QB + RB       | neutral     |
      | RB + opposing DEF | negative |

  @stacking @correlation-strategy
  Scenario: Avoid negative correlations
    Given some combinations have negative correlation
    When evaluating roster
    Then negative correlations should be identified
    And warnings should be displayed

  @stacking @stack-scoring
  Scenario: Track stack performance
    Given stacks have been built
    When games are played
    Then stack performance should be tracked
    And stack contribution should be shown

  @stacking @stack-scoring
  Scenario: Calculate stack bonus potential
    Given stacks can hit together
    When analyzing results
    Then stack hit rates should be calculated
    And ceiling outcomes should be tracked

  @stacking @stack-analysis
  Scenario: Analyze stack effectiveness
    Given stack data is available
    When reviewing stack strategy
    Then stack success rate should be displayed
    And recommendations should be provided

  @stacking @stack-analysis
  Scenario: Compare stack strategies
    Given different stacking approaches exist
    When analyzing roster construction
    Then stack comparison should be available
    And optimal strategy should be suggested

  # ==================== Best Ball Analytics ====================

  @analytics @optimal-lineup-analysis
  Scenario: Analyze optimal lineup selection
    Given a week has been scored
    When reviewing the optimal lineup
    Then selected players should be shown
    And selection logic should be explained

  @analytics @optimal-lineup-analysis
  Scenario: Compare to alternative lineups
    Given the optimal lineup was selected
    When exploring alternatives
    Then other lineup options should be shown
    And point differentials should be displayed

  @analytics @points-left-on-bench
  Scenario: Track points left on bench
    Given some players didn't make optimal lineup
    When analyzing bench performance
    Then unused points should be calculated
    And bench efficiency should be shown

  @analytics @points-left-on-bench
  Scenario: Minimize bench waste
    Given points on bench are wasted
    When evaluating roster construction
    Then bench waste should be tracked
    And optimization tips should be provided

  @analytics @efficiency-metrics
  Scenario: Calculate roster efficiency
    Given roster data is available
    When computing efficiency
    Then efficiency metrics should include
      | metric              | description                  |
      | points_per_player   | average contribution         |
      | hit_rate            | games with significant score |
      | optimal_inclusion   | times in optimal lineup      |

  @analytics @efficiency-metrics
  Scenario: Compare efficiency across positions
    Given efficiency varies by position
    When analyzing position efficiency
    Then position-by-position breakdown should be shown
    And weak areas should be highlighted

  @analytics @roster-evaluation
  Scenario: Evaluate roster quality
    Given a roster has been drafted
    When evaluating the roster
    Then quality score should be calculated
    And strengths and weaknesses should be identified

  @analytics @roster-evaluation
  Scenario: Project roster performance
    Given season projections are available
    When projecting roster outcome
    Then expected point total should be shown
    And finish range should be projected

  @analytics @performance-tracking
  Scenario: Track season-long performance
    Given the season is in progress
    When tracking performance
    Then weekly results should be recorded
    And trends should be visualized

  @analytics @performance-tracking
  Scenario: Compare performance to projections
    Given pre-season projections were made
    When comparing to actual results
    Then over/under performance should be shown
    And variance should be calculated

  # ==================== Best Ball Strategy ====================

  @strategy @draft-strategy
  Scenario: Develop draft strategy
    Given best ball requires unique strategy
    When preparing for draft
    Then strategy resources should be available
    And position priorities should be suggested

  @strategy @draft-strategy
  Scenario: Prioritize upside in drafts
    Given ceiling matters in best ball
    When evaluating players
    Then upside should be weighted heavily
    And safe players should be devalued

  @strategy @roster-construction-tips
  Scenario: Apply roster construction principles
    Given roster construction matters
    When building a team
    Then construction tips should be provided
    And best practices should be highlighted

  @strategy @roster-construction-tips
  Scenario: Balance roster composition
    Given different roster strategies exist
    When choosing an approach
    Then trade-offs should be explained
    And recommendations should be made

  @strategy @stacking-strategies
  Scenario: Implement stacking strategy
    Given stacking increases upside
    When applying stacking
    Then strategy options should be presented
    And implementation tips should be provided

  @strategy @stacking-strategies
  Scenario: Diversify stacks
    Given over-stacking has risks
    When building stacks
    Then diversification should be considered
    And risk management should be addressed

  @strategy @position-scarcity
  Scenario: Consider position scarcity
    Given some positions are scarcer
    When drafting
    Then scarcity should inform decisions
    And position value should be displayed

  @strategy @position-scarcity
  Scenario: Adjust for best ball position values
    Given best ball values differ
    When evaluating positions
    Then best ball adjustments should be applied
    And traditional rankings should be modified

  @strategy @value-picks
  Scenario: Identify value picks
    Given ADP doesn't always reflect value
    When identifying targets
    Then value picks should be highlighted
    And ADP discrepancies should be shown

  @strategy @value-picks
  Scenario: Target late-round upside
    Given late rounds offer upside plays
    When drafting in later rounds
    Then ceiling players should be prioritized
    And breakout candidates should be identified

  # ==================== Best Ball Leagues ====================

  @bestball-leagues @create-league
  Scenario: Create best ball league
    Given a user wants to start a best ball league
    When creating the league
    Then best ball settings should be available
    And league should be configured properly

  @bestball-leagues @create-league
  Scenario: Configure best ball league settings
    Given a best ball league is being created
    When configuring settings
    Then best ball options should include
      | setting         | options                    |
      | roster_size     | 18, 20, 24                 |
      | scoring_format  | PPR, half-PPR, standard    |
      | playoff_teams   | none, 4, 6, 8              |
      | draft_type      | slow, fast, scheduled      |

  @bestball-leagues @join-league
  Scenario: Join existing best ball league
    Given a best ball league is available
    When joining the league
    Then the owner should be added
    And draft position should be assigned

  @bestball-leagues @join-league
  Scenario: Find best ball leagues to join
    Given public best ball leagues exist
    When searching for leagues
    Then available leagues should be listed
    And filters should be available

  @bestball-leagues @league-settings
  Scenario: Review best ball league settings
    Given a best ball league is configured
    When viewing settings
    Then all best ball settings should be displayed
    And rules should be clear

  @bestball-leagues @league-settings
  Scenario: Modify league settings before draft
    Given the draft hasn't started
    When modifying settings
    Then changes should be allowed
    And all members should be notified

  @bestball-leagues @league-formats
  Scenario: Choose best ball format
    Given multiple formats are available
    When selecting format
    Then format options should be presented
      | format          | description                    |
      | season_long     | full season best ball          |
      | tournament      | large field competition        |
      | playoff_only    | condensed playoff format       |
      | weekly          | weekly best ball contests      |

  @bestball-leagues @league-formats
  Scenario: Apply format-specific rules
    Given a format is selected
    When the league operates
    Then format rules should be enforced
    And format-specific features should be active

  @bestball-leagues @league-payouts
  Scenario: Configure league payouts
    Given the league has an entry fee
    When setting payout structure
    Then payout options should be available
    And prize distribution should be set

  @bestball-leagues @league-payouts
  Scenario: Distribute league prizes
    Given the season has ended
    When distributing prizes
    Then winners should receive payouts
    And transactions should be recorded
