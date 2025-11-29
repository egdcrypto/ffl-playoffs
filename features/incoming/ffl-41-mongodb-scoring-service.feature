@backend @priority_1 @database
Feature: MongoDB-Based Scoring Service Implementation
  As a developer
  I want to implement ScoringService using MongoDB instead of PostgreSQL
  So that scoring data is stored in our NoSQL database for better flexibility

  Background:
    Given the application uses MongoDB for document storage
    And the ScoringService interface is defined in domain.service

  Scenario: Create ScoringService implementation with MongoDB
    Given the ScoringService interface exists with methods:
      | method                    | description                           |
      | calculateTeamScore        | Calculate score for a team selection  |
      | calculateWeekScores       | Calculate all scores for a week       |
      | determineEliminatedPlayers| Determine which players are eliminated|
      | rankScores                | Rank players by score                 |
    When a MongoDB-based implementation is created
    Then it should be annotated with @Service
    And it should implement the ScoringService interface
    And it should use MongoTemplate or MongoRepository for data access

  Scenario: Store scoring configuration in MongoDB
    Given scoring rules need to be configurable
    When scoring configuration is stored in MongoDB
    Then the configuration document should include:
      | field              | type    | description                      |
      | scoringRules       | Map     | Position-based scoring rules     |
      | multipliers        | Map     | Bonus multipliers for performance|
      | eliminationRules   | Object  | Rules for player elimination     |

  Scenario: Calculate team scores from player stats
    Given a TeamSelection with player IDs
    And player statistics are available
    When calculateTeamScore is called
    Then it should apply scoring rules to each player
    And return the total calculated score
    And store the score calculation in MongoDB for audit

  Scenario: Rank and eliminate players based on weekly scores
    Given scores have been calculated for all team selections in a week
    When rankScores is called
    Then players should be ranked 1 to N by score (highest first)
    And determineEliminatedPlayers should return the lowest scoring players
    And elimination count should be configurable per week

  # Implementation Notes:
  # 1. Create ScoringServiceImpl in infrastructure/mongodb/service/
  # 2. Use @Service annotation for Spring component scanning
  # 3. Inject MongoTemplate for flexible queries
  # 4. Create ScoringConfiguration document model
  # 5. Consider using SpEL expressions for configurable scoring rules (see FFL-39)
  # 6. Remove PostgreSQL dependency for scoring - use MongoDB only
