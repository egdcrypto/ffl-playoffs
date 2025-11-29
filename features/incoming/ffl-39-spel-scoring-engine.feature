@scoring @priority_2 @depends-FFL-6
Feature: SpEL-Based Dynamic Scoring Engine
  As a league administrator
  I want to define scoring formulas using Spring Expression Language (SpEL)
  So that scoring rules can be customized without code changes

  Background:
    Given the system uses Spring Expression Language for scoring calculations
    And scoring formulas are stored in the database per league
    And formulas can reference player stats as variables

  # ==================== SPEL FORMULA BASICS ====================

  @spel @configuration
  Scenario: Store and evaluate QB scoring formula in SpEL
    Given a league has a QB scoring formula defined as:
      """
      #passingYards * 0.04 + #passingTDs * 4 - #interceptions * 2 +
      #rushingYards * 0.1 + #rushingTDs * 6 - #fumblesLost * 2
      """
    And "Patrick Mahomes" has stats:
      | passingYards   | 325 |
      | passingTDs     | 3   |
      | interceptions  | 1   |
      | rushingYards   | 18  |
      | rushingTDs     | 0   |
      | fumblesLost    | 0   |
    When the SpEL engine evaluates the formula
    Then the calculation is:
      | Expression                      | Result |
      | #passingYards * 0.04           | 13.0   |
      | #passingTDs * 4                | 12.0   |
      | #interceptions * 2             | 2.0    |
      | #rushingYards * 0.1            | 1.8    |
    And total fantasy points = 24.8

  @spel @configuration
  Scenario: Store RB/WR scoring formula with PPR variable
    Given a league has a scoring formula for RB/WR defined as:
      """
      #rushingYards * 0.1 + #rushingTDs * 6 +
      #receivingYards * 0.1 + #receivingTDs * 6 +
      #receptions * #pprValue - #fumblesLost * 2
      """
    And the league PPR configuration is:
      | Format     | pprValue |
      | Standard   | 0        |
      | Half-PPR   | 0.5      |
      | Full-PPR   | 1.0      |
    And "Christian McCaffrey" has stats:
      | rushingYards    | 120 |
      | rushingTDs      | 2   |
      | receptions      | 8   |
      | receivingYards  | 65  |
      | receivingTDs    | 1   |
    When the SpEL engine evaluates with pprValue = 1.0 (Full PPR)
    Then total fantasy points = 44.5

  # ==================== CONDITIONAL EXPRESSIONS ====================

  @spel @conditional
  Scenario: Defense scoring with points-allowed tiers using SpEL conditionals
    Given a league has a DEF scoring formula with tiers:
      """
      #sacks * 1 + #interceptions * 2 + #fumbleRecoveries * 2 +
      #defensiveTDs * 6 + #safeties * 2 +
      (#pointsAllowed == 0 ? 10 :
       #pointsAllowed <= 6 ? 7 :
       #pointsAllowed <= 13 ? 4 :
       #pointsAllowed <= 20 ? 1 :
       #pointsAllowed <= 27 ? 0 :
       #pointsAllowed <= 34 ? -1 : -4)
      """
    And "49ers Defense" has stats:
      | sacks            | 4  |
      | interceptions    | 2  |
      | fumbleRecoveries | 1  |
      | defensiveTDs     | 1  |
      | pointsAllowed    | 10 |
    When the SpEL engine evaluates the formula
    Then the tier calculation for pointsAllowed = 10 returns 4
    And total fantasy points = 22.0

  @spel @conditional
  Scenario: Kicker scoring with distance-based field goal points
    Given a league has a kicker scoring formula:
      """
      #xpMade * 1 - #xpMissed * 1 +
      #fg0to39Made * 3 + #fg40to49Made * 4 + #fg50PlusMade * 5 -
      #fg0to39Missed * 1 - #fg40to49Missed * 0.5
      """
    And "Harrison Butker" has stats:
      | xpMade        | 4 |
      | fg0to39Made   | 2 |
      | fg40to49Made  | 1 |
      | fg50PlusMade  | 1 |
    When the SpEL engine evaluates the formula
    Then total fantasy points = 19.0

  # ==================== BONUS EXPRESSIONS ====================

  @spel @bonus
  Scenario: Milestone bonuses using SpEL conditionals
    Given a league has bonus scoring rules:
      """
      #baseScore +
      (#passingYards >= 300 ? 3 : 0) +
      (#passingYards >= 400 ? 2 : 0) +
      (#rushingYards >= 100 ? 3 : 0) +
      (#receivingYards >= 100 ? 3 : 0)
      """
    And "Josh Allen" has stats:
      | passingYards | 350 |
      | rushingYards | 45  |
    And base score = 20.0
    When the SpEL engine evaluates the formula
    Then the 300-yard passing bonus applies = 3
    And the 400-yard passing bonus does NOT apply = 0
    And total fantasy points = 23.0

  @spel @bonus
  Scenario: Perfect game bonus for kickers
    Given a league has kicker bonus rules:
      """
      #baseScore +
      (#fgMissed == 0 && #xpMissed == 0 && (#fgMade + #xpMade) >= 5 ? 3 : 0)
      """
    And "Perfect Kicker" has stats:
      | fgMade    | 3 |
      | xpMade    | 4 |
      | fgMissed  | 0 |
      | xpMissed  | 0 |
    And base score = 15.0
    When the SpEL engine evaluates the formula
    Then the perfect game bonus applies = 3
    And total fantasy points = 18.0

  # ==================== ADMIN CONFIGURATION ====================

  @admin @configuration
  Scenario: League admin creates custom scoring formula via API
    Given an authenticated league admin
    When the admin submits a new scoring configuration:
      | position | formula                                                          |
      | QB       | #passingYards * 0.05 + #passingTDs * 6 - #interceptions * 3     |
      | RB       | #rushingYards * 0.1 + #rushingTDs * 6 + #receptions * #pprValue |
      | WR       | #receivingYards * 0.1 + #receivingTDs * 6 + #receptions * #pprValue |
      | TE       | #receivingYards * 0.1 + #receivingTDs * 6 + #receptions * #tePremium |
      | K        | #xpMade * 1 + #fg0to39Made * 3 + #fg40to49Made * 4 + #fg50PlusMade * 5 |
    Then the formulas are validated for syntax
    And the formulas are stored in the league configuration
    And scoring calculations use the custom formulas

  @admin @validation
  Scenario: Reject invalid SpEL formula syntax
    Given an admin submits an invalid formula:
      """
      #passingYards * + 0.04
      """
    When the formula is validated
    Then the system returns a syntax error
    And the error message indicates the problem location
    And the formula is not saved

  @admin @validation
  Scenario: Reject formula with undefined variables
    Given an admin submits a formula with unknown variables:
      """
      #passingYards * 0.04 + #invalidStat * 2
      """
    When the formula is validated
    Then the system returns "Unknown variable: invalidStat"
    And the formula is not saved

  # ==================== FORMULA TEMPLATES ====================

  @templates
  Scenario: System provides pre-defined formula templates
    Given the system has built-in scoring templates:
      | template       | description                    |
      | STANDARD       | No PPR, standard scoring       |
      | HALF_PPR       | 0.5 points per reception       |
      | FULL_PPR       | 1.0 points per reception       |
      | TE_PREMIUM     | 1.5 PPR for tight ends         |
      | SUPERFLEX      | QBs in flex positions          |
    When a new league is created with template "FULL_PPR"
    Then all position formulas are populated from the template
    And the league can customize formulas further

  @templates
  Scenario: Clone scoring configuration from another league
    Given League A has custom scoring formulas
    When League B clones scoring from League A
    Then all formulas are copied to League B
    And League B can modify without affecting League A

  # ==================== REAL-TIME EVALUATION ====================

  @realtime @performance
  Scenario: Evaluate scoring for all players efficiently
    Given a league has 1000 players with stats
    And each player requires SpEL formula evaluation
    When batch scoring is triggered
    Then all players are scored within 5 seconds
    And formula compilation is cached for reuse
    And memory usage remains stable

  @realtime @live
  Scenario: Live scoring updates during games
    Given a player's stats are updated in real-time:
      | time   | passingYards | passingTDs | interceptions |
      | Q1     | 75           | 0          | 0             |
      | Q2     | 180          | 2          | 1             |
      | Q3     | 250          | 2          | 1             |
      | Q4     | 325          | 3          | 1             |
    When the SpEL engine re-evaluates after each update
    Then fantasy points update in real-time:
      | time   | points |
      | Q1     | 3.0    |
      | Q2     | 13.2   |
      | Q3     | 16.0   |
      | Q4     | 24.8   |

  # ==================== IMPLEMENTATION DETAILS ====================

  # SpEL Implementation in Java Spring Boot:
  #
  # @Service
  # public class SpelScoringEngine {
  #     private final ExpressionParser parser = new SpelExpressionParser();
  #     private final Map<String, Expression> cache = new ConcurrentHashMap<>();
  #
  #     public Double calculate(String formula, Map<String, Object> stats) {
  #         Expression exp = cache.computeIfAbsent(formula, parser::parseExpression);
  #         StandardEvaluationContext ctx = new StandardEvaluationContext();
  #         stats.forEach(ctx::setVariable);
  #         return exp.getValue(ctx, Double.class);
  #     }
  # }
  #
  # Variables available in formulas:
  # - #passingYards, #passingTDs, #interceptions
  # - #rushingYards, #rushingTDs
  # - #receptions, #receivingYards, #receivingTDs
  # - #fumblesLost, #sacks (QB sacks taken)
  # - #fg0to39Made, #fg40to49Made, #fg50PlusMade, #xpMade
  # - #fg0to39Missed, #fg40to49Missed, #xpMissed
  # - #pointsAllowed, #yardsAllowed
  # - #defensiveTDs, #safeties, #fumbleRecoveries
  # - #pprValue (0, 0.5, or 1.0 based on league config)
  # - #tePremium (TE-specific PPR multiplier)
