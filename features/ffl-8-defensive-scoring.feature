Feature: Defensive Scoring with Configurable Tiers
  As the system
  I want to calculate defensive fantasy points using configurable scoring rules and tiers
  So that teams receive accurate defensive scores based on league configuration

  Background:
    Given the game "2025 NFL Playoffs Pool" is active
    And the league has defensive scoring enabled

  # Individual Defensive Play Scoring

  Scenario: Calculate points for sacks
    Given player "john_player" selected "Pittsburgh Steelers" for week 1
    And the league has sack points configured as 1 point
    And the "Pittsburgh Steelers" defense recorded 5 sacks
    When defensive scoring is calculated
    Then the sack points should be 5.0
    # 5 sacks * 1 point = 5 points

  Scenario: Calculate points for interceptions
    Given player "jane_player" selected "Baltimore Ravens" for week 2
    And the league has interception points configured as 2 points
    And the "Baltimore Ravens" defense had 3 interceptions
    When defensive scoring is calculated
    Then the interception points should be 6.0
    # 3 interceptions * 2 points = 6 points

  Scenario: Calculate points for fumble recoveries
    Given player "bob_player" selected "San Francisco 49ers" for week 1
    And the league has fumble recovery points configured as 2 points
    And the "San Francisco 49ers" defense recovered 2 fumbles
    When defensive scoring is calculated
    Then the fumble recovery points should be 4.0
    # 2 fumbles * 2 points = 4 points

  Scenario: Calculate points for safeties
    Given player "sarah_player" selected "Denver Broncos" for week 3
    And the league has safety points configured as 2 points
    And the "Denver Broncos" defense recorded 1 safety
    When defensive scoring is calculated
    Then the safety points should be 2.0

  Scenario: Calculate points for defensive touchdowns
    Given player "mike_player" selected "Dallas Cowboys" for week 1
    And the league has defensive TD points configured as 6 points
    And the "Dallas Cowboys" defense scored 2 touchdowns
    When defensive scoring is calculated
    Then the defensive touchdown points should be 12.0
    # 2 TDs * 6 points = 12 points

  # Points Allowed Tier Scoring

  Scenario: Defense allows 0 points - maximum tier
    Given player "alex_player" selected "Buffalo Bills" for week 2
    And the league has standard points allowed tiers configured
    And the "Buffalo Bills" defense allowed 0 points
    When defensive scoring is calculated
    Then the points allowed tier score should be 10.0
    # 0 points allowed = 10 fantasy points

  Scenario: Defense allows 1-6 points - high tier
    Given player "chris_player" selected "New England Patriots" for week 1
    And the "New England Patriots" defense allowed 6 points
    When defensive scoring is calculated
    Then the points allowed tier score should be 7.0
    # 1-6 points allowed = 7 fantasy points

  Scenario: Defense allows 7-13 points - mid tier
    Given player "lisa_player" selected "Green Bay Packers" for week 3
    And the "Green Bay Packers" defense allowed 10 points
    When defensive scoring is calculated
    Then the points allowed tier score should be 4.0
    # 7-13 points allowed = 4 fantasy points

  Scenario: Defense allows 14-20 points - low tier
    Given player "tom_player" selected "Seattle Seahawks" for week 1
    And the "Seattle Seahawks" defense allowed 17 points
    When defensive scoring is calculated
    Then the points allowed tier score should be 1.0
    # 14-20 points allowed = 1 fantasy point

  Scenario: Defense allows 21-27 points - zero tier
    Given player "nina_player" selected "Tampa Bay Buccaneers" for week 2
    And the "Tampa Bay Buccaneers" defense allowed 24 points
    When defensive scoring is calculated
    Then the points allowed tier score should be 0.0
    # 21-27 points allowed = 0 fantasy points

  Scenario: Defense allows 28-34 points - negative tier
    Given player "omar_player" selected "Cleveland Browns" for week 1
    And the "Cleveland Browns" defense allowed 31 points
    When defensive scoring is calculated
    Then the points allowed tier score should be -1.0
    # 28-34 points allowed = -1 fantasy point

  Scenario: Defense allows 35+ points - maximum negative tier
    Given player "penny_player" selected "Arizona Cardinals" for week 3
    And the "Arizona Cardinals" defense allowed 42 points
    When defensive scoring is calculated
    Then the points allowed tier score should be -4.0
    # 35+ points allowed = -4 fantasy points

  # Yards Allowed Tier Scoring

  Scenario: Defense allows 0-99 total yards - maximum tier
    Given player "quinn_player" selected "Chicago Bears" for week 1
    And the league has standard yards allowed tiers configured
    And the "Chicago Bears" defense allowed 95 total yards
    When defensive scoring is calculated
    Then the yards allowed tier score should be 10.0
    # 0-99 yards = 10 fantasy points

  Scenario: Defense allows 100-199 yards - high tier
    Given player "rachel_player" selected "Miami Dolphins" for week 2
    And the "Miami Dolphins" defense allowed 175 total yards
    When defensive scoring is calculated
    Then the yards allowed tier score should be 7.0
    # 100-199 yards = 7 fantasy points

  Scenario: Defense allows 200-299 yards - mid-high tier
    Given player "steve_player" selected "Kansas City Chiefs" for week 1
    And the "Kansas City Chiefs" defense allowed 250 total yards
    When defensive scoring is calculated
    Then the yards allowed tier score should be 5.0
    # 200-299 yards = 5 fantasy points

  Scenario: Defense allows 300-349 yards - mid tier
    Given player "tina_player" selected "Indianapolis Colts" for week 3
    And the "Indianapolis Colts" defense allowed 325 total yards
    When defensive scoring is calculated
    Then the yards allowed tier score should be 3.0
    # 300-349 yards = 3 fantasy points

  Scenario: Defense allows 350-399 yards - zero tier
    Given player "victor_player" selected "Los Angeles Rams" for week 1
    And the "Los Angeles Rams" defense allowed 375 total yards
    When defensive scoring is calculated
    Then the yards allowed tier score should be 0.0
    # 350-399 yards = 0 fantasy points

  Scenario: Defense allows 400-449 yards - negative tier
    Given player "wendy_player" selected "Atlanta Falcons" for week 2
    And the "Atlanta Falcons" defense allowed 425 total yards
    When defensive scoring is calculated
    Then the yards allowed tier score should be -3.0
    # 400-449 yards = -3 fantasy points

  Scenario: Defense allows 450+ yards - maximum negative tier
    Given player "xander_player" selected "Detroit Lions" for week 1
    And the "Detroit Lions" defense allowed 485 total yards
    When defensive scoring is calculated
    Then the yards allowed tier score should be -5.0
    # 450+ yards = -5 fantasy points

  # Comprehensive Defensive Scoring

  Scenario: Calculate total defensive points with all components
    Given player "yara_player" selected "Philadelphia Eagles" for week 1
    And the "Philadelphia Eagles" defense had the following performance:
      | stat_type              | value |
      | sacks                  | 3     |
      | interceptions          | 1     |
      | fumbleRecoveries       | 1     |
      | safeties               | 0     |
      | defensiveTouchdowns    | 1     |
      | pointsAllowed          | 10    |
      | totalYardsAllowed      | 250   |
    And the league has standard defensive scoring configured:
      | sackPoints           | 1 |
      | interceptionPoints   | 2 |
      | fumbleRecoveryPoints | 2 |
      | safetyPoints         | 2 |
      | defensiveTDPoints    | 6 |
    When defensive scoring is calculated
    Then the defensive score breakdown should be:
      | category                | points |
      | Sacks (3)               | 3      |
      | Interceptions (1)       | 2      |
      | Fumble Recoveries (1)   | 2      |
      | Safeties (0)            | 0      |
      | Defensive TDs (1)       | 6      |
      | Points Allowed (10)     | 4      |
      | Yards Allowed (250)     | 5      |
    And the total defensive points should be 22.0
    # 3 + 2 + 2 + 0 + 6 + 4 + 5 = 22

  Scenario: Calculate defensive score with negative components
    Given player "zane_player" selected "New York Giants" for week 2
    And the "New York Giants" defense had the following performance:
      | stat_type              | value |
      | sacks                  | 1     |
      | interceptions          | 0     |
      | fumbleRecoveries       | 0     |
      | safeties               | 0     |
      | defensiveTouchdowns    | 0     |
      | pointsAllowed          | 35    |
      | totalYardsAllowed      | 450   |
    When defensive scoring is calculated
    Then the defensive score breakdown should be:
      | category                | points |
      | Sacks (1)               | 1      |
      | Points Allowed (35)     | -4     |
      | Yards Allowed (450)     | -5     |
    And the total defensive points should be -8.0
    # 1 + (-4) + (-5) = -8

  # Custom Defensive Scoring Configuration

  Scenario: Admin configures custom defensive play points
    Given the admin owns a league
    When the admin configures custom defensive scoring:
      | sackPoints           | 2   |
      | interceptionPoints   | 3   |
      | fumbleRecoveryPoints | 3   |
      | safetyPoints         | 4   |
      | defensiveTDPoints    | 8   |
    Then the defensive scoring rules are saved
    And future defensive calculations use the custom values

  Scenario: Admin configures custom points allowed tiers
    Given the admin owns a league
    When the admin configures custom points allowed tiers:
      | pointsAllowedRange | fantasyPoints |
      | 0                  | 15            |
      | 1-10               | 10            |
      | 11-20              | 5             |
      | 21-30              | 0             |
      | 31-40              | -5            |
      | 41+                | -10           |
    Then the points allowed tiers are saved
    And defensive scoring uses the custom tiers

  Scenario: Admin configures custom yards allowed tiers
    Given the admin owns a league
    When the admin configures custom yards allowed tiers:
      | yardsAllowedRange | fantasyPoints |
      | 0-150             | 15            |
      | 151-250           | 10            |
      | 251-350           | 5             |
      | 351-450           | 0             |
      | 451+              | -10           |
    Then the yards allowed tiers are saved
    And defensive scoring uses the custom tiers

  # Tier Boundary Conditions

  Scenario Outline: Points allowed tier boundaries
    Given player "test_player" selected "<team>" for week 1
    And the "<team>" defense allowed <pointsAllowed> points
    When defensive scoring is calculated
    Then the points allowed tier score should be <expectedPoints>

    Examples:
      | team    | pointsAllowed | expectedPoints |
      | Team A  | 0             | 10             |
      | Team B  | 1             | 7              |
      | Team C  | 6             | 7              |
      | Team D  | 7             | 4              |
      | Team E  | 13            | 4              |
      | Team F  | 14            | 1              |
      | Team G  | 20            | 1              |
      | Team H  | 21            | 0              |
      | Team I  | 27            | 0              |
      | Team J  | 28            | -1             |
      | Team K  | 34            | -1             |
      | Team L  | 35            | -4             |
      | Team M  | 100           | -4             |

  Scenario Outline: Yards allowed tier boundaries
    Given player "test_player" selected "<team>" for week 1
    And the "<team>" defense allowed <yardsAllowed> total yards
    When defensive scoring is calculated
    Then the yards allowed tier score should be <expectedPoints>

    Examples:
      | team    | yardsAllowed | expectedPoints |
      | Team A  | 0            | 10             |
      | Team B  | 99           | 10             |
      | Team C  | 100          | 7              |
      | Team D  | 199          | 7              |
      | Team E  | 200          | 5              |
      | Team F  | 299          | 5              |
      | Team G  | 300          | 3              |
      | Team H  | 349          | 3              |
      | Team I  | 350          | 0              |
      | Team J  | 399          | 0              |
      | Team K  | 400          | -3             |
      | Team L  | 449          | -3             |
      | Team M  | 450          | -5             |
      | Team N  | 600          | -5             |

  # Integration with Team Elimination

  Scenario: Eliminated team receives zero defensive points
    Given player "eliminated_player" selected "Jacksonville Jaguars" for week 1
    And the "Jacksonville Jaguars" lost their week 1 game
    And the "Jacksonville Jaguars" are eliminated
    And the "Jacksonville Jaguars" had excellent defensive performance in week 2:
      | sacks                | 6   |
      | interceptions        | 3   |
      | defensiveTouchdowns  | 1   |
      | pointsAllowed        | 3   |
      | totalYardsAllowed    | 150 |
    When week 2 defensive scoring is calculated
    Then the total defensive points should be 0.0
    And the elimination override is applied

  # Defensive Scoring Display

  Scenario: Player views detailed defensive scoring breakdown
    Given player "detail_player" selected "Los Angeles Chargers" for week 1
    And the final defensive score is 18.5 points
    When the player requests the defensive scoring breakdown
    Then they should see:
      | category                     | value | points |
      | Sacks                        | 4     | 4.0    |
      | Interceptions                | 2     | 4.0    |
      | Fumble Recoveries            | 1     | 2.0    |
      | Safeties                     | 0     | 0.0    |
      | Defensive TDs                | 1     | 6.0    |
      | Points Allowed (10)          | 10    | 4.0    |
      | Yards Allowed (225)          | 225   | 5.0    |
      | Total Defensive Points       |       | 25.0   |

  # Data Integration for Defensive Stats

  Scenario: Fetch defensive statistics from NFL data source
    Given a game has completed
    And the "Minnesota Vikings" defense is being scored
    When the system fetches defensive statistics
    Then the following data is retrieved:
      | sacks                  |
      | interceptions          |
      | fumbleRecoveries       |
      | safeties               |
      | defensiveTouchdowns    |
      | pointsAllowed          |
      | passingYardsAllowed    |
      | rushingYardsAllowed    |
      | totalYardsAllowed      |
    And totalYardsAllowed = passingYardsAllowed + rushingYardsAllowed

  Scenario: Calculate total yards from passing and rushing yards allowed
    Given the "Carolina Panthers" defense allowed:
      | passingYardsAllowed | 180 |
      | rushingYardsAllowed | 95  |
    When defensive scoring is calculated
    Then the totalYardsAllowed should be 275
    And the yards allowed tier score should be 5.0 (200-299 tier)

  # ============================================
  # ADVANCED TURNOVER SCORING
  # ============================================

  Scenario: Calculate points for forced fumbles
    Given player "turnover_player" selected "Pittsburgh Steelers" for week 1
    And the league has forced fumble points configured as 1 point
    And the "Pittsburgh Steelers" defense forced 3 fumbles
    When defensive scoring is calculated
    Then the forced fumble points should be 3.0
    # Note: Forced fumble may or may not result in recovery

  Scenario: Track forced fumbles vs recovered fumbles separately
    Given the "Baltimore Ravens" defense:
      | forcedFumbles    | 4 |
      | fumbleRecoveries | 2 |
    And the league scoring is:
      | forcedFumblePoints   | 1 |
      | fumbleRecoveryPoints | 2 |
    When defensive scoring is calculated
    Then the forced fumble points should be 4.0
    And the fumble recovery points should be 4.0
    And total turnover-related points should be 8.0

  Scenario: Calculate points for strip sacks
    Given player "strip_player" selected "Dallas Cowboys" for week 2
    And the league has strip sack points configured as 3 points
    And the "Dallas Cowboys" defense recorded 2 strip sacks
    When defensive scoring is calculated
    Then the strip sack points should be 6.0
    # Strip sack is a sack + forced fumble combo

  Scenario: Interception return yards bonus
    Given player "pick_player" selected "Buffalo Bills" for week 1
    And the league has interception return yard points configured as 0.1 per yard
    And the "Buffalo Bills" defense returned interceptions for 85 yards
    When defensive scoring is calculated
    Then the interception return yard points should be 8.5

  Scenario: Fumble return yards bonus
    Given player "fumble_return_player" selected "San Francisco 49ers" for week 2
    And the league has fumble return yard points configured as 0.1 per yard
    And the "San Francisco 49ers" defense returned fumbles for 45 yards
    When defensive scoring is calculated
    Then the fumble return yard points should be 4.5

  Scenario: Pick-six scoring (interception returned for TD)
    Given player "picksix_player" selected "Miami Dolphins" for week 1
    And the "Miami Dolphins" defense had:
      | interceptions          | 2 |
      | interceptionReturnTDs  | 1 |
    And the league scoring is:
      | interceptionPoints | 2 |
      | defensiveTDPoints  | 6 |
    When defensive scoring is calculated
    Then interception points should be 4.0
    And defensive TD points should be 6.0
    # The TD is counted in defensive TDs, interception counted separately

  Scenario: Scoop and score (fumble returned for TD)
    Given player "scoop_player" selected "Denver Broncos" for week 3
    And the "Denver Broncos" defense had:
      | fumbleRecoveries      | 3 |
      | fumbleReturnTDs       | 1 |
    And the league scoring is:
      | fumbleRecoveryPoints | 2 |
      | defensiveTDPoints    | 6 |
    When defensive scoring is calculated
    Then fumble recovery points should be 6.0
    And defensive TD points should be 6.0

  # ============================================
  # SPECIAL TEAMS DEFENSIVE SCORING
  # ============================================

  Scenario: Calculate points for blocked kicks
    Given player "block_player" selected "New England Patriots" for week 1
    And the league has blocked kick points configured as 3 points
    And the "New England Patriots" blocked 2 kicks
    When defensive scoring is calculated
    Then the blocked kick points should be 6.0

  Scenario: Calculate points for blocked punts
    Given player "punt_block_player" selected "Green Bay Packers" for week 2
    And the league has blocked punt points configured as 3 points
    And the "Green Bay Packers" blocked 1 punt
    When defensive scoring is calculated
    Then the blocked punt points should be 3.0

  Scenario: Blocked kick returned for touchdown
    Given player "block_td_player" selected "Kansas City Chiefs" for week 1
    And the "Kansas City Chiefs" blocked a field goal and returned it for TD
    And the league scoring is:
      | blockedKickPoints | 3 |
      | specialTeamsTDPoints | 6 |
    When defensive scoring is calculated
    Then blocked kick points should be 3.0
    And special teams TD points should be 6.0

  Scenario: Punt return for touchdown (special teams)
    Given player "punt_return_player" selected "Chicago Bears" for week 3
    And the "Chicago Bears" had a punt return for touchdown
    And the league has punt return TD points configured as 6 points
    When defensive scoring is calculated
    Then the punt return TD points should be 6.0

  Scenario: Kickoff return for touchdown
    Given player "kick_return_player" selected "Seattle Seahawks" for week 1
    And the "Seattle Seahawks" had a kickoff return for touchdown
    And the league has kick return TD points configured as 6 points
    When defensive scoring is calculated
    Then the kick return TD points should be 6.0

  # ============================================
  # ADVANCED DEFENSIVE PLAYS
  # ============================================

  Scenario: Calculate points for pass deflections
    Given player "deflection_player" selected "Los Angeles Rams" for week 2
    And the league has pass deflection points configured as 0.5 points
    And the "Los Angeles Rams" defense had 8 pass deflections
    When defensive scoring is calculated
    Then the pass deflection points should be 4.0

  Scenario: Calculate points for tackles for loss
    Given player "tfl_player" selected "Cleveland Browns" for week 1
    And the league has tackle for loss points configured as 1 point
    And the "Cleveland Browns" defense had 7 tackles for loss
    When defensive scoring is calculated
    Then the tackles for loss points should be 7.0

  Scenario: Calculate points for quarterback hits
    Given player "qb_hit_player" selected "Arizona Cardinals" for week 3
    And the league has QB hit points configured as 0.5 points
    And the "Arizona Cardinals" defense had 12 quarterback hits
    When defensive scoring is calculated
    Then the QB hit points should be 6.0

  Scenario: Fourth down stops scoring
    Given player "fourth_down_player" selected "Cincinnati Bengals" for week 1
    And the league has fourth down stop points configured as 2 points
    And the "Cincinnati Bengals" defense stopped 3 fourth down attempts
    When defensive scoring is calculated
    Then the fourth down stop points should be 6.0

  Scenario: Three and out bonus
    Given player "three_out_player" selected "Tennessee Titans" for week 2
    And the league has three and out points configured as 1 point
    And the "Tennessee Titans" defense forced 5 three-and-outs
    When defensive scoring is calculated
    Then the three and out points should be 5.0

  Scenario: Goal line stand bonus
    Given player "goal_line_player" selected "Las Vegas Raiders" for week 1
    And the league has goal line stand points configured as 3 points
    And the "Las Vegas Raiders" defense held on 2 goal line stands
    When defensive scoring is calculated
    Then the goal line stand points should be 6.0

  # ============================================
  # FIRST HALF / SECOND HALF SCORING
  # ============================================

  Scenario: First half shutout bonus
    Given player "shutout_player" selected "Philadelphia Eagles" for week 2
    And the league has first half shutout bonus configured as 3 points
    And the "Philadelphia Eagles" defense allowed 0 points in the first half
    When defensive scoring is calculated
    Then the first half shutout bonus should be 3.0

  Scenario: Complete shutout bonus
    Given player "complete_shutout_player" selected "Jacksonville Jaguars" for week 1
    And the league has complete shutout bonus configured as 5 points
    And the "Jacksonville Jaguars" defense allowed 0 points all game
    When defensive scoring is calculated
    Then the shutout bonus should be 5.0
    And the points allowed tier score should be 10.0
    And total shutout-related points should be 15.0

  # ============================================
  # CONFIGURABLE TIER SYSTEMS
  # ============================================

  Scenario: Use linear points allowed scoring instead of tiers
    Given the admin configures linear points allowed scoring:
      | basePoints       | 20    |
      | pointsPerAllowed | -0.5  |
      | minimumScore     | -10   |
    When the defense allows 28 points
    Then the points allowed score should be 6.0
    # 20 - (28 * 0.5) = 20 - 14 = 6

  Scenario: Use granular 7-point tier system
    Given the admin configures 7-point tier system:
      | pointsAllowedRange | fantasyPoints |
      | 0                  | 12            |
      | 1-7                | 10            |
      | 8-14               | 7             |
      | 15-21              | 4             |
      | 22-28              | 1             |
      | 29-35              | -2            |
      | 36-42              | -5            |
      | 43+                | -8            |
    When the defense allows 22 points
    Then the points allowed tier score should be 1.0

  Scenario: DraftKings-style defensive scoring
    Given the league uses DraftKings defensive scoring format:
      | stat                | points |
      | sack                | 1      |
      | interception        | 2      |
      | fumbleRecovery      | 2      |
      | safety              | 2      |
      | defensiveTD         | 6      |
      | blockedKick         | 2      |
      | 0 points allowed    | 10     |
      | 1-6 points allowed  | 7      |
      | 7-13 points allowed | 4      |
      | 14-20 allowed       | 1      |
      | 21-27 allowed       | 0      |
      | 28-34 allowed       | -1     |
      | 35+ allowed         | -4     |
    When defensive scoring is calculated
    Then DraftKings scoring format is applied

  Scenario: FanDuel-style defensive scoring
    Given the league uses FanDuel defensive scoring format:
      | stat                | points |
      | sack                | 1      |
      | interception        | 2      |
      | fumbleRecovery      | 2      |
      | safety              | 2      |
      | defensiveTD         | 6      |
      | blockedKick         | 2      |
      | 0 points allowed    | 10     |
      | 1-6 points allowed  | 7      |
      | 7-13 points allowed | 4      |
      | 14-20 allowed       | 1      |
      | 21-27 allowed       | 0      |
      | 28-34 allowed       | -1     |
      | 35+ allowed         | -4     |
    When defensive scoring is calculated
    Then FanDuel scoring format is applied

  Scenario: Yahoo-style defensive scoring with bonus points
    Given the league uses Yahoo defensive scoring format
    And bonus points are configured:
      | bonusType           | threshold | points |
      | sackBonus           | 5+ sacks  | 2      |
      | interceptionBonus   | 3+ ints   | 3      |
      | turnoverBonus       | 4+ total  | 3      |
    When the defense has 6 sacks, 3 interceptions, and 1 fumble recovery
    Then the sack bonus of 2.0 is applied
    And the interception bonus of 3.0 is applied
    And the turnover bonus of 3.0 is applied

  # ============================================
  # OPPONENT-ADJUSTED SCORING
  # ============================================

  Scenario: Apply opponent strength multiplier
    Given opponent strength adjustments are enabled
    And the "Buffalo Bills" defense played against a top-5 offense
    When the defensive performance multiplier is calculated
    Then a 1.2x multiplier is applied to defensive stats
    And the adjusted score reflects opponent difficulty

  Scenario: Home/away defensive adjustment
    Given home/away adjustments are enabled
    And the "Kansas City Chiefs" defense played an away game
    When defensive scoring is calculated
    Then a 0.95x adjustment is applied for away games
    And home games receive 1.05x adjustment

  # ============================================
  # INDIVIDUAL DEFENSIVE PLAYER (IDP) INTEGRATION
  # ============================================

  Scenario: IDP league with individual player scoring
    Given the league uses IDP scoring
    And individual defensive players are rostered
    When player "idp_fan" has rostered T.J. Watt
    And T.J. Watt recorded:
      | tackles       | 8  |
      | sacks         | 2  |
      | forcedFumbles | 1  |
      | passDeflected | 1  |
    And IDP scoring rules are:
      | tackle          | 1   |
      | sack            | 4   |
      | forcedFumble    | 3   |
      | passDeflection  | 1   |
    Then T.J. Watt's IDP score should be 20.0
    # 8 + (2*4) + 3 + 1 = 8 + 8 + 3 + 1 = 20

  Scenario: Combine team defense and IDP scoring
    Given the league uses both team defense and IDP
    When calculating total defensive points
    Then team defense score is calculated separately
    And IDP scores are calculated for individual players
    And both contribute to total team score

  # ============================================
  # DEFENSIVE SCORING VALIDATION
  # ============================================

  Scenario: Validate defensive stats are within reasonable ranges
    Given defensive stats are received from data source
    When validating the stats:
      | stat               | minValue | maxValue |
      | sacks              | 0        | 15       |
      | interceptions      | 0        | 10       |
      | fumbleRecoveries   | 0        | 10       |
      | pointsAllowed      | 0        | 100      |
      | totalYardsAllowed  | 0        | 800      |
    Then stats outside ranges trigger validation warnings
    And extreme outliers are flagged for review

  Scenario: Handle missing defensive stats gracefully
    Given defensive stats are partially available
    And sacks and interceptions are available
    But fumble recoveries data is missing
    When defensive scoring is calculated
    Then available stats are scored normally
    And missing stats default to 0
    And a warning indicates incomplete data

  Scenario: Handle overtime game defensive scoring
    Given the "Tampa Bay Buccaneers" played an overtime game
    And points allowed in regulation was 27
    And points allowed in overtime was 3
    When defensive scoring is calculated
    Then total points allowed is 30
    And the points allowed tier is based on total (30 = -1 points)
    And overtime does not receive special treatment by default

  Scenario: Option to exclude overtime from points allowed
    Given overtime exclusion is configured
    And the "Minnesota Vikings" allowed 24 points in regulation
    And the "Minnesota Vikings" allowed 6 points in overtime
    When defensive scoring is calculated with overtime exclusion
    Then points allowed is based on regulation only (24)
    And the points allowed tier score is 0.0 (21-27 tier)

  # ============================================
  # DEFENSIVE SCORING EDGE CASES
  # ============================================

  Scenario: Defense scores on special teams miscue
    Given the opponent's punt team fumbled
    And the "Houston Texans" defense recovered and scored
    When categorizing the touchdown
    Then the TD is counted as special teams TD (not defensive TD)
    And scoring rules for special teams TD apply

  Scenario: Two-point conversion return
    Given the "New Orleans Saints" defense returned a failed 2-point conversion
    And the league has 2-point conversion return points configured as 2 points
    When defensive scoring is calculated
    Then the 2-point conversion return points should be 2.0

  Scenario: Defensive scoring during garbage time
    Given garbage time scoring adjustment is enabled
    And the game was decided by 28+ points
    And late defensive stats occurred during garbage time
    When defensive scoring is calculated
    Then garbage time stats receive 0.5x weight
    And meaningful stats receive full weight

  Scenario: Bye week team has no defensive score
    Given player "bye_player" selected "New York Jets" for week 14
    And the "New York Jets" have a bye in week 14
    When defensive scoring is calculated for week 14
    Then the defensive score is null (not zero)
    And the bye week is indicated in the response

  Scenario: Defensive score minimum floor
    Given the league has a defensive score floor of -10 points
    And the defense had a catastrophically bad game:
      | sacks              | 0   |
      | interceptions      | 0   |
      | pointsAllowed      | 56  |
      | totalYardsAllowed  | 600 |
    When defensive scoring is calculated
    Then the raw score would be -13.0
    But the floor is applied
    And the final score is -10.0

  Scenario: Defensive score maximum ceiling
    Given the league has a defensive score ceiling of 35 points
    And the defense had an historically great game:
      | sacks              | 10  |
      | interceptions      | 5   |
      | fumbleRecoveries   | 3   |
      | defensiveTouchdowns| 3   |
      | pointsAllowed      | 0   |
      | totalYardsAllowed  | 50  |
    When defensive scoring is calculated
    Then the raw score would be 58.0
    But the ceiling is applied
    And the final score is 35.0

  # ============================================
  # DEFENSIVE SCORING HISTORY AND TRENDS
  # ============================================

  Scenario: View defensive scoring history by week
    Given a player has made selections for weeks 1-4
    When viewing their defensive scoring history
    Then they see week-by-week breakdown:
      | week | team      | defScore | rank |
      | 1    | Steelers  | 18.0     | 3    |
      | 2    | Ravens    | 12.5     | 8    |
      | 3    | 49ers     | -2.0     | 28   |
      | 4    | Bills     | 22.0     | 1    |
    And average defensive score is 12.6

  Scenario: Compare defensive scoring to league average
    Given the league average defensive score for week 1 is 8.5
    And player's defensive score is 15.0
    When viewing scoring comparison
    Then the player is +6.5 above league average
    And percentile rank is displayed

  # ============================================
  # SCORING FORMULA DISPLAY
  # ============================================

  Scenario: Display defensive scoring formula
    Given a user views league scoring rules
    When accessing defensive scoring formula
    Then the formula is displayed:
      """
      Defensive Score =
        (Sacks × 1) +
        (Interceptions × 2) +
        (Fumble Recoveries × 2) +
        (Safeties × 2) +
        (Defensive TDs × 6) +
        (Points Allowed Tier) +
        (Yards Allowed Tier)
      """
    And tier tables are shown

  Scenario: Export defensive scoring configuration
    Given an admin wants to share scoring rules
    When exporting defensive scoring configuration
    Then a JSON export is generated with:
      | playScoring       | sacks, ints, fumbles, etc. |
      | pointsAllowedTiers| tier configuration         |
      | yardsAllowedTiers | tier configuration         |
      | bonuses           | shutout, etc.              |
    And the config can be imported to another league

  # ============================================
  # REAL-TIME DEFENSIVE SCORE UPDATES
  # ============================================

  Scenario: Live defensive score updates during game
    Given a game is in progress
    And real-time updates are enabled
    When the defense records a sack
    Then the defensive score is updated immediately
    And the user sees the score change
    And a notification shows "+1.0 (Sack)"

  Scenario: Defensive score projection during game
    Given a game is in the 3rd quarter
    And current defensive score is 8.0
    When projecting final defensive score
    Then projection considers:
      | current pace of scoring against     |
      | historical 4th quarter performance  |
      | game situation (leading/trailing)   |
    And projected final score is displayed

  Scenario Outline: Defensive scoring by position played
    Given position <position> has specific scoring rules
    When a player at <position> records <stat>
    Then <points> points are awarded

    Examples:
      | position | stat              | points |
      | DL       | sack              | 4      |
      | DL       | tackle            | 1      |
      | LB       | sack              | 4      |
      | LB       | tackle            | 1      |
      | LB       | passDeflection    | 1      |
      | DB       | interception      | 6      |
      | DB       | passDeflection    | 1      |
      | DB       | tackle            | 1      |

  # ============================================
  # API AND INTEGRATION
  # ============================================

  Scenario: Calculate defensive score via API
    Given a valid API request
    When POST /api/v1/scoring/defensive with:
      """
      {
        "teamId": "PIT",
        "week": 1,
        "stats": {
          "sacks": 4,
          "interceptions": 2,
          "fumbleRecoveries": 1,
          "safeties": 0,
          "defensiveTouchdowns": 1,
          "pointsAllowed": 14,
          "totalYardsAllowed": 280
        }
      }
      """
    Then response status is 200 OK
    And response includes:
      | totalScore     | 20.0              |
      | breakdown      | detailed scores   |
      | tierInfo       | which tiers hit   |

  Scenario: Retrieve defensive scoring configuration
    Given a league with custom defensive scoring
    When GET /api/v1/leagues/{leagueId}/scoring/defensive
    Then response includes complete configuration:
      | playScoring        |
      | pointsAllowedTiers |
      | yardsAllowedTiers  |
      | bonuses            |
      | adjustments        |

  Scenario: Update defensive scoring configuration
    Given an admin with league ownership
    When PUT /api/v1/leagues/{leagueId}/scoring/defensive with new config
    Then the configuration is updated
    And future scores use new configuration
    And existing scores are not retroactively changed
    And an audit entry is created
