@database @migration @mongodb
Feature: FFL-41: PostgreSQL to MongoDB Migration
  As a system architect
  I want to migrate from PostgreSQL to MongoDB
  So that we have a unified NoSQL database architecture

  Background:
    Given the application uses Spring Data for database access
    And all entities are currently configured for PostgreSQL
    And MongoDB is the target database

  # ========================================
  # DEPENDENCY MIGRATION
  # ========================================

  @dependency @priority-1
  Scenario: Remove PostgreSQL dependencies from build
    Given the project uses Gradle for build management
    When I remove the PostgreSQL JDBC driver dependency
    And I remove Spring Data JPA dependencies
    And I add Spring Data MongoDB dependency
    And I add MongoDB driver dependency
    Then the build file should not contain "postgresql"
    And the build file should contain "spring-boot-starter-data-mongodb"
    And the build should compile successfully

  @dependency @priority-1
  Scenario: Update application configuration for MongoDB
    Given the application has database configuration
    When I remove PostgreSQL connection properties
    And I add MongoDB connection properties
    Then the configuration should contain "spring.data.mongodb.uri"
    And the configuration should contain "spring.data.mongodb.database"
    And the configuration should not contain "spring.datasource"
    And the configuration should not contain "spring.jpa"

  # ========================================
  # ENTITY MIGRATION
  # ========================================

  @entity @priority-1
  Scenario: Convert JPA entities to MongoDB documents
    Given the project has JPA entity classes annotated with @Entity
    When I replace @Entity with @Document annotation
    And I replace @Id with MongoDB @Id
    And I replace @Column with @Field where needed
    And I remove JPA-specific annotations (@Table, @GeneratedValue, etc.)
    Then all entity classes should compile successfully
    And all entity classes should use org.springframework.data.mongodb annotations

  @entity @priority-1
  Scenario Outline: Migrate domain entities to MongoDB documents
    Given the entity "<entity_name>" exists in the domain layer
    When I convert the entity to a MongoDB document
    Then the class should be annotated with @Document(collection = "<collection_name>")
    And the ID field should use MongoDB ObjectId or String type
    And all relationships should be converted to embedded documents or references

    Examples:
      | entity_name    | collection_name   |
      | User           | users             |
      | League         | leagues           |
      | Team           | teams             |
      | Player         | players           |
      | Roster         | rosters           |
      | Game           | games             |
      | Score          | scores            |
      | NFLPlayer      | nfl_players       |
      | NFLGame        | nfl_games         |
      | ScoringFormula | scoring_formulas  |

  # ========================================
  # REPOSITORY MIGRATION
  # ========================================

  @repository @priority-1
  Scenario: Convert JPA repositories to MongoDB repositories
    Given the project has repository interfaces extending JpaRepository
    When I replace JpaRepository with MongoRepository
    And I update generic type parameters for MongoDB
    Then all repository interfaces should compile successfully
    And all repository interfaces should extend MongoRepository

  @repository @priority-2
  Scenario: Update custom query methods for MongoDB
    Given repositories have custom query methods with @Query annotation
    When I convert JPQL queries to MongoDB JSON queries
    And I update query parameter binding syntax
    Then all custom queries should be valid MongoDB queries
    And all repository methods should work correctly

  @repository @priority-2
  Scenario: Handle relationship queries in MongoDB
    Given JPA repositories use join queries for relationships
    When I convert join queries to MongoDB aggregation pipelines
    Or I use @DBRef for document references
    Or I use embedded documents for one-to-many relationships
    Then all relationship queries should return correct results

  # ========================================
  # CONFIGURATION CLASSES
  # ========================================

  @config @priority-1
  Scenario: Remove JPA configuration classes
    Given the project has JPA configuration classes
    When I remove @EnableJpaRepositories annotation
    And I remove @EnableTransactionManagement for JPA
    And I remove EntityManagerFactory beans
    And I remove DataSource configuration for PostgreSQL
    Then no JPA configuration should remain in the codebase

  @config @priority-1
  Scenario: Add MongoDB configuration class
    Given MongoDB configuration is required
    When I create a MongoDB configuration class
    And I add @EnableMongoRepositories annotation
    And I configure MongoClient bean
    And I configure MongoTemplate bean
    Then MongoDB should be properly configured for the application

  @config @priority-2
  Scenario: Configure MongoDB indexes
    Given entities have fields that need indexing
    When I add @Indexed annotation to frequently queried fields
    And I add @CompoundIndex for composite queries
    And I add @TextIndexed for text search fields
    Then MongoDB should create appropriate indexes on startup

  # ========================================
  # TEST MIGRATION
  # ========================================

  @testing @priority-2
  Scenario: Update test configuration for MongoDB
    Given tests use embedded PostgreSQL or test containers
    When I replace PostgreSQL test configuration with MongoDB
    And I add embedded MongoDB dependency for tests
    Or I configure MongoDB TestContainers
    Then tests should use MongoDB for database testing

  @testing @priority-2
  Scenario: Update BDD step definitions for MongoDB
    Given BDD step definitions interact with the database
    When I update database setup steps for MongoDB
    And I update data verification steps for MongoDB
    And I update cleanup steps for MongoDB
    Then all BDD tests should pass with MongoDB

  # ========================================
  # DOCKER CONFIGURATION
  # ========================================

  @docker @priority-1
  Scenario: Update Docker Compose for MongoDB
    Given docker-compose.yml contains PostgreSQL service
    When I remove the PostgreSQL service definition
    And I add MongoDB service definition with version 7.0
    And I configure MongoDB volumes for persistence
    And I update application service to depend on MongoDB
    Then docker-compose should start MongoDB successfully
    And the application should connect to MongoDB

  @docker @priority-2
  Scenario: Configure MongoDB replica set for transactions
    Given MongoDB transactions require a replica set
    When I configure MongoDB as a single-node replica set
    And I add replica set initialization script
    Then MongoDB should support multi-document transactions
    And the application should handle transactions correctly

  # ========================================
  # DATA MIGRATION (if needed)
  # ========================================

  @migration @priority-3
  Scenario: Create data migration script
    Given existing data may need to be migrated
    When I create a migration script for existing data
    And I handle data type conversions
    And I handle relationship restructuring
    Then the migration script should successfully migrate all data
    And data integrity should be maintained

  # ========================================
  # CLEANUP
  # ========================================

  @cleanup @priority-1
  Scenario: Remove all PostgreSQL references
    Given the migration to MongoDB is complete
    When I search the codebase for PostgreSQL references
    Then no files should contain "postgresql"
    And no files should contain "postgres"
    And no files should contain JPA-specific imports
    And the application should start successfully with only MongoDB

  @verification @priority-1
  Scenario: Verify application functionality after migration
    Given the MongoDB migration is complete
    When I start the application
    And I run all integration tests
    And I run all BDD tests
    Then all tests should pass
    And the application should function correctly
    And all CRUD operations should work with MongoDB
