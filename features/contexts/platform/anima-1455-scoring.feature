@scoring @platform
Feature: Scoring
  As a fantasy football league
  I need comprehensive scoring functionality
  So that owners can track points, understand scoring rules, and analyze performance

  Background:
    Given the scoring system is operational
    And scoring rules are configured for the league

  # ==================== Scoring Settings ====================

  @settings @points-per-stat
  Scenario: Configure points per stat category
    Given scoring settings are available
    When configuring point values
    Then standard categories should include
      | category          | default_points |
      | passing_yard      | 0.04           |
      | passing_td        | 4              |
      | interception      | -2             |
      | rushing_yard      | 0.1            |
      | rushing_td        | 6              |
      | receiving_yard    | 0.1            |
      | receiving_td      | 6              |
      | fumble_lost       | -2             |

  @settings @points-per-stat
  Scenario: Adjust point values
    Given default scoring is configured
    When adjusting point values
    Then custom values should be accepted
    And changes should apply to all games
    And historical scores should optionally recalculate

  @settings @custom-rules
  Scenario: Create custom scoring rules
    Given scoring customization is available
    When creating custom rules
    Then unique stat categories should be addable
    And point values should be configurable
    And activation conditions should be definable

  @settings @custom-rules
  Scenario: Define conditional scoring
    Given custom rules are supported
    When defining conditions
    Then triggers should include
      | condition_type    | example                    |
      | threshold         | 100+ rushing yards         |
      | game_outcome      | winning team bonus         |
      | performance       | QB rating over 100         |
      | situational       | overtime touchdown         |

  @settings @fractional-scoring
  Scenario: Enable fractional scoring
    Given fractional options exist
    When enabling fractional scoring
    Then decimal points should be awarded
    And precision should be configurable
    And display should show decimals

  @settings @fractional-scoring
  Scenario: Configure decimal precision
    Given fractional scoring is enabled
    When setting precision
    Then options should include
      | precision    | example       |
      | tenths       | 12.4 points   |
      | hundredths   | 12.47 points  |
      | whole        | 12 points     |
    And calculations should match precision

  # ==================== Live Scoring ====================

  @live @real-time-updates
  Scenario: Display real-time point updates
    Given games are in progress
    When scores are updated
    Then point changes should appear immediately
    And player totals should update live
    And team totals should recalculate

  @live @real-time-updates
  Scenario: Handle score update latency
    Given network conditions vary
    When updates are delayed
    Then last update time should show
    And pending updates should queue
    And synchronization should recover gracefully

  @live @play-by-play
  Scenario: Show play-by-play scoring
    Given live game data is available
    When viewing scoring details
    Then each scoring play should be shown
    And timestamps should be accurate
    And point values should be displayed

  @live @play-by-play
  Scenario: Filter play-by-play by player
    Given multiple players are active
    When filtering by player
    Then only that player's plays should show
    And running total should display
    And context should be maintained

  @live @animations
  Scenario: Animate score changes
    Given visual feedback is enabled
    When points are added
    Then animation should highlight change
    And direction should be indicated
    And magnitude should be visible

  @live @animations
  Scenario: Configure animation preferences
    Given animation settings exist
    When configuring preferences
    Then options should include
      | setting           | options                    |
      | enable_animations | on/off                     |
      | animation_speed   | slow/normal/fast           |
      | highlight_color   | customizable               |
      | sound_effects     | on/off                     |

  # ==================== Scoring Categories ====================

  @categories @passing
  Scenario: Score passing statistics
    Given a quarterback is playing
    When passing stats accumulate
    Then passing yards should score
    And passing touchdowns should score
    And interceptions should deduct points
    And two-point conversions should score

  @categories @passing
  Scenario: Handle passing stat edge cases
    Given complex passing situations occur
    When scoring edge cases
    Then lateral passes should be handled
    And fumbled snaps should be attributed
    And sack yardage should be applied correctly

  @categories @rushing
  Scenario: Score rushing statistics
    Given a ball carrier is playing
    When rushing stats accumulate
    Then rushing yards should score
    And rushing touchdowns should score
    And fumbles lost should deduct points
    And two-point conversions should score

  @categories @rushing
  Scenario: Attribute rushing to correct player
    Given handoffs and scrambles occur
    When attributing rushing stats
    Then ball carrier should receive credit
    And scrambles should go to quarterback
    And lateral recipients should receive yards

  @categories @receiving
  Scenario: Score receiving statistics
    Given a receiver is playing
    When receiving stats accumulate
    Then receiving yards should score
    And receiving touchdowns should score
    And receptions should score if PPR enabled
    And fumbles lost should deduct points

  @categories @receiving
  Scenario: Handle reception edge cases
    Given complex receiving situations occur
    When scoring edge cases
    Then backwards passes should be handled
    And fumbled catches should be attributed
    And multi-lateral plays should track correctly

  @categories @defensive
  Scenario: Score team defense statistics
    Given a team defense is playing
    When defensive stats accumulate
    Then points allowed should score
    And yards allowed should score
    And turnovers should score
    And sacks should score

  @categories @defensive
  Scenario: Calculate defensive scoring tiers
    Given defensive performance varies
    When calculating tier scoring
    Then tiers should include
      | points_allowed | fantasy_points |
      | 0              | 10             |
      | 1-6            | 7              |
      | 7-13           | 4              |
      | 14-20          | 1              |
      | 21-27          | 0              |
      | 28-34          | -1             |
      | 35+            | -4             |

  # ==================== PPR Scoring ====================

  @ppr @standard-ppr
  Scenario: Score full PPR format
    Given full PPR is enabled
    When a reception is made
    Then 1 point per reception should be awarded
    And this should add to other receiving points
    And total should reflect PPR value

  @ppr @standard-ppr
  Scenario: Display PPR impact
    Given PPR scoring is active
    When viewing player stats
    Then reception points should be itemized
    And PPR contribution should be clear
    And comparison to non-PPR should be available

  @ppr @half-ppr
  Scenario: Score half-PPR format
    Given half-PPR is enabled
    When a reception is made
    Then 0.5 points per reception should be awarded
    And this should add to other receiving points
    And total should reflect half-PPR value

  @ppr @half-ppr
  Scenario: Compare PPR formats
    Given format comparison is available
    When comparing PPR options
    Then full PPR values should show
    And half-PPR values should show
    And standard (non-PPR) values should show

  @ppr @te-premium
  Scenario: Apply tight end premium
    Given TE premium is enabled
    When a tight end makes a reception
    Then additional PPR bonus should apply
    And bonus should be configurable
    And other positions should remain standard

  @ppr @te-premium
  Scenario: Configure TE premium value
    Given TE premium settings exist
    When configuring premium
    Then bonus options should include
      | bonus_type        | value                      |
      | additional_ppr    | +0.5 per reception         |
      | multiplier        | 1.5x reception points      |
      | flat_bonus        | +2 per game                |
    And selection should apply league-wide

  # ==================== Bonus Scoring ====================

  @bonus @yardage-milestones
  Scenario: Award yardage milestone bonuses
    Given milestone bonuses are configured
    When a player reaches a milestone
    Then bonus points should be awarded
    And milestone should be noted
    And scoring breakdown should show bonus

  @bonus @yardage-milestones
  Scenario: Configure yardage thresholds
    Given bonus settings are available
    When configuring thresholds
    Then milestones should include
      | stat_type         | threshold | bonus  |
      | passing_yards     | 300       | 3      |
      | passing_yards     | 400       | 5      |
      | rushing_yards     | 100       | 3      |
      | rushing_yards     | 200       | 5      |
      | receiving_yards   | 100       | 3      |
      | receiving_yards   | 200       | 5      |

  @bonus @big-plays
  Scenario: Award big play bonuses
    Given big play bonuses are enabled
    When a long play occurs
    Then bonus points should be awarded
    And play distance should be tracked
    And bonus should add to base points

  @bonus @big-plays
  Scenario: Define big play thresholds
    Given big play settings exist
    When defining thresholds
    Then options should include
      | play_type         | distance  | bonus  |
      | long_pass         | 40+ yards | 2      |
      | long_rush         | 40+ yards | 2      |
      | long_reception    | 40+ yards | 2      |
      | long_td           | 50+ yards | 3      |

  @bonus @performance
  Scenario: Award performance bonuses
    Given performance thresholds are set
    When a player meets threshold
    Then performance bonus should be awarded
    And achievement should be noted
    And bonus should be itemized

  @bonus @performance
  Scenario: Configure performance thresholds
    Given performance settings exist
    When configuring thresholds
    Then metrics should include
      | metric            | threshold      | bonus  |
      | qb_rating         | 100+           | 2      |
      | completion_pct    | 70%+           | 1      |
      | yards_per_carry   | 5.0+           | 1      |
      | catch_rate        | 80%+           | 1      |

  # ==================== IDP Scoring ====================

  @idp @tackles
  Scenario: Score tackle statistics
    Given IDP scoring is enabled
    When a defender makes tackles
    Then solo tackles should score
    And assisted tackles should score
    And tackle for loss should score bonus
    And total should accumulate correctly

  @idp @tackles
  Scenario: Configure tackle point values
    Given tackle settings exist
    When configuring values
    Then options should include
      | tackle_type       | default_points |
      | solo_tackle       | 1              |
      | assisted_tackle   | 0.5            |
      | tackle_for_loss   | 2              |
      | stuff             | 1              |

  @idp @sacks
  Scenario: Score sack statistics
    Given defensive players are playing
    When sacks occur
    Then full sacks should score
    And half sacks should score proportionally
    And sack yardage bonus should apply if configured
    And forced fumbles on sacks should add points

  @idp @sacks
  Scenario: Handle split sacks
    Given multiple defenders contribute
    When a sack is split
    Then each defender should receive half credit
    And points should be divided appropriately
    And totals should be accurate

  @idp @interceptions
  Scenario: Score interception statistics
    Given a defender intercepts a pass
    When scoring the interception
    Then interception points should be awarded
    And return yardage should score
    And defensive touchdown should score
    And forced fumble should add if applicable

  @idp @interceptions
  Scenario: Track interception details
    Given interception data is available
    When viewing details
    Then pick location should be noted
    And return yards should be shown
    And result of play should display
    And historical context should be available

  @idp @defensive-tds
  Scenario: Score defensive touchdowns
    Given a defensive player scores
    When awarding points
    Then defensive TD points should be awarded
    And return yards should be included
    And play type should be noted
    And big play bonus should apply if configured

  @idp @defensive-tds
  Scenario: Categorize defensive scores
    Given defensive scores occur
    When categorizing
    Then categories should include
      | score_type           | description                |
      | pick_six             | interception return TD     |
      | fumble_return        | fumble recovery TD         |
      | blocked_kick_return  | blocked kick returned TD   |
      | safety               | safety awarded             |

  # ==================== Scoring Corrections ====================

  @corrections @stat-corrections
  Scenario: Apply stat corrections
    Given official stats are corrected
    When corrections are applied
    Then fantasy scores should update
    And point changes should be reflected
    And affected matchups should recalculate

  @corrections @stat-corrections
  Scenario: Display correction details
    Given a correction has been applied
    When viewing correction details
    Then original stat should be shown
    And corrected stat should be shown
    And point difference should be calculated
    And timestamp should be recorded

  @corrections @retroactive
  Scenario: Handle retroactive adjustments
    Given a past game is corrected
    When applying retroactively
    Then historical scores should update
    And standings should recalculate if needed
    And notification should be sent to affected owners

  @corrections @retroactive
  Scenario: Set correction window
    Given correction policies exist
    When defining the window
    Then timeframes should include
      | window            | description                |
      | same_week         | corrections within week    |
      | end_of_season     | until season ends          |
      | never             | lock after game final      |
      | custom            | commissioner defined       |

  @corrections @notifications
  Scenario: Notify owners of corrections
    Given corrections affect scores
    When sending notifications
    Then affected owners should be notified
    And correction details should be included
    And impact should be explained
    And appeal process should be noted if available

  @corrections @notifications
  Scenario: Track correction history
    Given multiple corrections occur
    When viewing history
    Then all corrections should be listed
    And dates should be shown
    And net impact should be calculated
    And filtering options should be available

  # ==================== Scoring Breakdown ====================

  @breakdown @player-detail
  Scenario: Display player scoring detail
    Given a player has scored points
    When viewing breakdown
    Then each stat category should be listed
    And points per category should show
    And total should be calculated
    And percentage by category should display

  @breakdown @player-detail
  Scenario: Show stat-by-stat breakdown
    Given detailed stats are available
    When viewing stat breakdown
    Then raw stats should be shown
    And point value per stat should display
    And calculation should be transparent
    And bonuses should be itemized separately

  @breakdown @category-view
  Scenario: Display category-by-category view
    Given player scoring exists
    When viewing by category
    Then major categories should be grouped
    And subtotals should be shown
    And visual breakdown should be available
    And comparison options should exist

  @breakdown @category-view
  Scenario: Filter breakdown by time period
    Given multi-game data exists
    When filtering by time
    Then game-by-game should be available
    And weekly totals should show
    And season totals should calculate
    And custom date ranges should work

  @breakdown @visual-charts
  Scenario: Display scoring charts
    Given visualization is enabled
    When viewing charts
    Then pie chart by category should show
    And bar chart over time should display
    And trend lines should be available
    And interactive features should work

  @breakdown @visual-charts
  Scenario: Export scoring data
    Given export options exist
    When exporting data
    Then CSV format should be available
    And PDF report should generate
    And print-friendly view should work
    And data should be complete

  # ==================== Scoring Comparison ====================

  @comparison @league-analysis
  Scenario: Analyze league scoring
    Given league-wide data exists
    When analyzing scoring
    Then league average should calculate
    And scoring distribution should show
    And outliers should be identified
    And trends should be visible

  @comparison @league-analysis
  Scenario: Display league scoring trends
    Given multi-week data exists
    When viewing trends
    Then week-over-week changes should show
    And seasonal patterns should emerge
    And comparative analysis should be available
    And insights should be provided

  @comparison @position-averages
  Scenario: Calculate position scoring averages
    Given all positions have scores
    When calculating averages
    Then average by position should show
    And standard deviation should calculate
    And tier breakdowns should be available
    And relative value should display

  @comparison @position-averages
  Scenario: Compare player to position average
    Given player and position data exist
    When comparing
    Then above/below average should be indicated
    And percentage difference should show
    And rank within position should display
    And consistency should be measured

  @comparison @head-to-head
  Scenario: Compare scoring between teams
    Given two teams are selected
    When comparing scoring
    Then side-by-side totals should show
    And category breakdown should display
    And advantages should be highlighted
    And weekly comparison should be available

  @comparison @head-to-head
  Scenario: Generate matchup scoring projection
    Given opponent is known
    When projecting matchup
    Then projected score should show
    And scoring sources should be compared
    And key players should be identified
    And win probability should calculate

  # ==================== Custom Scoring Rules ====================

  @custom @commissioner-rules
  Scenario: Allow commissioner customization
    Given commissioner access is available
    When customizing scoring
    Then any point value should be adjustable
    And new categories should be addable
    And existing categories should be removable
    And preview should show impact

  @custom @commissioner-rules
  Scenario: Save custom scoring configurations
    Given custom rules are defined
    When saving configuration
    Then settings should persist
    And templates should be saveable
    And sharing with other leagues should work
    And import/export should function

  @custom @unique-categories
  Scenario: Create unique stat categories
    Given custom category is needed
    When creating new category
    Then stat name should be definable
    And point value should be assignable
    And data source should be configurable
    And validation should occur

  @custom @unique-categories
  Scenario: Define exotic scoring rules
    Given creative scoring is desired
    When defining exotic rules
    Then examples should include
      | rule_name              | description                     |
      | rushing_td_distance    | bonus per yard of TD run        |
      | game_winning_score     | bonus for go-ahead score        |
      | primetime_multiplier   | bonus for Monday/Thursday games |
      | rivalry_bonus          | extra for division games        |

  @custom @scoring-templates
  Scenario: Use scoring templates
    Given standard templates exist
    When selecting template
    Then options should include
      | template          | description                |
      | standard          | traditional scoring        |
      | ppr               | point per reception        |
      | half_ppr          | half point per reception   |
      | superflex         | premium QB scoring         |
      | idp_heavy         | defensive player focused   |

  @custom @scoring-templates
  Scenario: Modify template after applying
    Given a template is selected
    When modifying template
    Then base values should be editable
    And additions should be allowed
    And removals should be possible
    And custom template should be saveable

  # ==================== Scoring Validation ====================

  @validation @accuracy
  Scenario: Validate scoring accuracy
    Given scores are calculated
    When validating accuracy
    Then calculations should be verified
    And discrepancies should be flagged
    And audit trail should be maintained
    And corrections should be trackable

  @validation @accuracy
  Scenario: Compare to official sources
    Given official stat sources exist
    When comparing scores
    Then discrepancies should be identified
    And source differences should be noted
    And reconciliation should be possible
    And reporting should be available

  @validation @rules-compliance
  Scenario: Ensure scoring rules compliance
    Given league rules are defined
    When scoring games
    Then rules should be applied consistently
    And edge cases should be handled
    And disputes should be loggable
    And commissioner override should be available

  @validation @rules-compliance
  Scenario: Audit scoring calculations
    Given audit is requested
    When auditing calculations
    Then step-by-step calculation should show
    And rule applications should be documented
    And anomalies should be flagged
    And report should be generatable

  @validation @data-integrity
  Scenario: Maintain scoring data integrity
    Given scoring data is critical
    When ensuring integrity
    Then backup should be automatic
    And recovery should be possible
    And version history should be maintained
    And corruption should be detectable

  @validation @data-integrity
  Scenario: Handle data source failures
    Given data sources may fail
    When a failure occurs
    Then fallback sources should be used
    And users should be notified
    And manual entry should be available
    And sync should recover when source returns

