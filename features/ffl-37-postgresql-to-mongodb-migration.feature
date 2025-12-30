@database @migration @mongodb @postgresql
Feature: FFL-37: PostgreSQL to MongoDB Migration
  As a development team
  I want to migrate the FFL Playoffs application from PostgreSQL to MongoDB
  So that we can leverage document-based storage for flexible schema and better scalability

  Background:
    Given the application currently uses PostgreSQL as the primary database
    And Spring Data JPA is used for database access
    And the migration target is MongoDB 7.0 or higher

  # ========================================
  # SECTION 1: DEPENDENCY UPDATES
  # ========================================

  @dependency @build @priority-critical
  Scenario: Update Gradle dependencies for MongoDB
    Given the build.gradle file contains PostgreSQL dependencies
    When the following dependencies are removed:
      | dependency                                    |
      | org.postgresql:postgresql                     |
      | org.springframework.boot:spring-boot-starter-data-jpa |
    And the following dependencies are added:
      | dependency                                           | version |
      | org.springframework.boot:spring-boot-starter-data-mongodb | latest  |
    Then the build.gradle should compile without errors
    And no JPA-related dependencies should remain

  @dependency @build @priority-critical
  Scenario: Add MongoDB test dependencies
    Given the project uses JUnit 5 and Testcontainers for testing
    When the following test dependencies are added:
      | dependency                           | scope |
      | org.testcontainers:mongodb           | test  |
      | de.flapdoodle.embed:de.flapdoodle.embed.mongo | test |
    Then integration tests can run with MongoDB Testcontainers
    And unit tests can use embedded MongoDB

  @dependency @validation
  Scenario: Verify no PostgreSQL artifacts remain in build
    Given the dependency migration is complete
    When I analyze the resolved dependency tree
    Then no PostgreSQL driver should be present
    And no Hibernate ORM dependencies should be present
    And no JDBC connection pool dependencies should be present

  # ========================================
  # SECTION 2: ENTITY CONVERSION
  # ========================================

  @entity @conversion @priority-critical
  Scenario: Convert User entity from JPA to MongoDB Document
    Given the User entity uses JPA annotations:
      | annotation      | field     |
      | @Entity         | class     |
      | @Table          | class     |
      | @Id             | id        |
      | @GeneratedValue | id        |
      | @Column         | email     |
      | @Column         | googleId  |
      | @Enumerated     | role      |
    When the entity is converted to MongoDB format
    Then the annotations should be:
      | annotation                          | field     |
      | @Document(collection = "users")     | class     |
      | @Id                                 | id        |
      | @Field                              | email     |
      | @Field                              | googleId  |
      | @Field                              | role      |
    And the id field should be of type String or ObjectId

  @entity @conversion @priority-critical
  Scenario: Convert League entity with embedded configuration
    Given the League entity has a one-to-one relationship with LeagueConfiguration
    When the entity is converted to MongoDB format
    Then LeagueConfiguration should be embedded within League document
    And the @DBRef annotation should NOT be used for configuration
    And the embedded document should be stored atomically

  @entity @conversion @priority-critical
  Scenario: Convert Roster entity with player references
    Given the Roster entity has many-to-many relationships with NFLPlayer
    When the entity is converted to MongoDB format
    Then player references should be stored as embedded player IDs
    Or player references should use @DBRef with lazy loading
    And the choice should be documented based on query patterns

  @entity @conversion @priority-high
  Scenario Outline: Convert all domain entities to MongoDB documents
    Given the entity "<entity>" exists with JPA annotations
    When I convert the entity to MongoDB document
    Then the document should be stored in collection "<collection>"
    And the ID field should be properly typed for MongoDB
    And all JPA imports should be replaced with MongoDB imports

    Examples:
      | entity              | collection           |
      | User                | users                |
      | League              | leagues              |
      | Roster              | rosters              |
      | NFLPlayer           | nfl_players          |
      | NFLGame             | nfl_games            |
      | TeamSelection       | team_selections      |
      | PersonalAccessToken | personal_access_tokens |
      | AdminInvitation     | admin_invitations    |
      | PlayerInvitation    | player_invitations   |
      | ScoringFormula      | scoring_formulas     |

  @entity @audit @priority-medium
  Scenario: Handle audit fields in MongoDB
    Given entities have audit fields (createdAt, updatedAt, createdBy)
    When converting to MongoDB
    Then @CreatedDate annotation should work with MongoDB
    And @LastModifiedDate annotation should work with MongoDB
    And @EnableMongoAuditing should be configured
    And audit fields should be automatically populated

  @entity @versioning @priority-medium
  Scenario: Handle optimistic locking version field
    Given entities use @Version for optimistic locking in JPA
    When converting to MongoDB
    Then @Version should continue to work with Spring Data MongoDB
    And concurrent update conflicts should throw OptimisticLockingFailureException

  # ========================================
  # SECTION 3: REPOSITORY MIGRATION
  # ========================================

  @repository @migration @priority-critical
  Scenario: Convert JpaRepository to MongoRepository
    Given repositories extend JpaRepository<Entity, Long>
    When I update repository interfaces
    Then repositories should extend MongoRepository<Entity, String>
    And the ID type should change from Long to String
    And all repository methods should compile

  @repository @query @priority-high
  Scenario: Convert JPQL queries to MongoDB JSON queries
    Given repository has custom query:
      """
      @Query("SELECT u FROM User u WHERE u.email = :email")
      Optional<User> findByEmail(@Param("email") String email);
      """
    When the query is converted for MongoDB
    Then the query should become:
      """
      @Query("{ 'email': ?0 }")
      Optional<User> findByEmail(String email);
      """
    And the query should return correct results

  @repository @query @priority-high
  Scenario: Convert complex JOIN queries to MongoDB aggregations
    Given repository has a query with JOINs:
      """
      @Query("SELECT r FROM Roster r JOIN r.league l WHERE l.status = :status")
      List<Roster> findByLeagueStatus(@Param("status") LeagueStatus status);
      """
    When the query is converted for MongoDB
    Then the query should use MongoDB aggregation pipeline
    Or the query should be implemented using MongoTemplate
    And the query should return equivalent results

  @repository @derived @priority-medium
  Scenario: Verify derived query methods work with MongoDB
    Given repositories use Spring Data derived query methods:
      | method                                    |
      | findByEmail(String email)                 |
      | findByStatusAndSeason(Status s, int year) |
      | existsByGoogleId(String googleId)         |
      | countByRole(Role role)                    |
    Then all derived query methods should work without modification
    And Spring Data MongoDB should generate correct queries

  @repository @pagination @priority-medium
  Scenario: Verify pagination works with MongoDB
    Given repositories use Pageable for pagination
    When I call findAll(Pageable pageable)
    Then pagination should work correctly with MongoDB
    And sorting should be applied correctly
    And total element count should be accurate

  # ========================================
  # SECTION 4: CONFIGURATION CHANGES
  # ========================================

  @config @properties @priority-critical
  Scenario: Update application.yml for MongoDB connection
    Given application.yml contains PostgreSQL configuration:
      """
      spring:
        datasource:
          url: jdbc:postgresql://localhost:5432/ffl_playoffs
          username: postgres
          password: secret
        jpa:
          hibernate:
            ddl-auto: update
      """
    When the configuration is updated for MongoDB
    Then application.yml should contain:
      """
      spring:
        data:
          mongodb:
            uri: mongodb://localhost:27017/ffl_playoffs
            database: ffl_playoffs
      """
    And no spring.datasource properties should remain
    And no spring.jpa properties should remain

  @config @profiles @priority-high
  Scenario: Configure environment-specific MongoDB settings
    Given the application has profiles: dev, staging, prod
    When I configure MongoDB for each environment
    Then application-dev.yml should connect to local MongoDB
    And application-staging.yml should connect to staging MongoDB Atlas
    And application-prod.yml should connect to production MongoDB Atlas
    And connection strings should use environment variables for secrets

  @config @java @priority-critical
  Scenario: Create MongoDB configuration class
    Given MongoDB requires Java configuration
    When I create MongoConfiguration class
    Then the class should be annotated with @Configuration
    And the class should be annotated with @EnableMongoRepositories
    And the class should configure MongoClient bean
    And the class should configure MongoTemplate bean
    And the class should enable auditing with @EnableMongoAuditing

  @config @index @priority-high
  Scenario: Configure MongoDB indexes
    Given entities have frequently queried fields
    When I add index annotations
    Then User.email should have @Indexed(unique = true)
    And User.googleId should have @Indexed(unique = true)
    And League.adminId should have @Indexed
    And NFLPlayer.team should have @Indexed
    And NFLGame.week and NFLGame.season should have @CompoundIndex

  @config @transaction @priority-medium
  Scenario: Configure MongoDB transaction support
    Given some operations require multi-document transactions
    When I configure MongoDB for transactions
    Then MongoTransactionManager bean should be configured
    And MongoDB should be running as replica set
    And @Transactional annotation should work for multi-document operations

  # ========================================
  # SECTION 5: DOCKER SETUP
  # ========================================

  @docker @compose @priority-critical
  Scenario: Update docker-compose.yml for MongoDB
    Given docker-compose.yml contains PostgreSQL service
    When I update the compose file for MongoDB
    Then the file should contain MongoDB service:
      """
      mongodb:
        image: mongo:7.0
        container_name: ffl-mongodb
        ports:
          - "27017:27017"
        volumes:
          - mongodb_data:/data/db
        environment:
          - MONGO_INITDB_DATABASE=ffl_playoffs
      """
    And PostgreSQL service should be removed
    And the application service should depend on mongodb

  @docker @replicaset @priority-high
  Scenario: Configure MongoDB replica set for transactions
    Given MongoDB transactions require replica set
    When I configure single-node replica set in Docker
    Then the docker-compose should include replica set initialization
    And the MongoDB should start with --replSet rs0
    And an init script should run rs.initiate()
    And the application should connect using replica set connection string

  @docker @healthcheck @priority-medium
  Scenario: Add health check for MongoDB container
    Given the application depends on MongoDB being ready
    When I add health check to MongoDB service
    Then the health check should use mongosh to verify connectivity
    And the application container should wait for MongoDB health
    And startup should not proceed until MongoDB is healthy

  @docker @volumes @priority-medium
  Scenario: Configure persistent storage for MongoDB
    Given MongoDB data should persist across container restarts
    When I configure Docker volumes
    Then a named volume should be created for /data/db
    And data should survive container recreation
    And the volume should be defined in docker-compose volumes section

  # ========================================
  # SECTION 6: DATA MIGRATION
  # ========================================

  @migration @data @priority-high
  Scenario: Export existing data from PostgreSQL
    Given the PostgreSQL database contains existing data
    When I export data for migration
    Then all tables should be exported to JSON format
    And relationships should be preserved in the export
    And data types should be compatible with MongoDB

  @migration @data @priority-high
  Scenario: Import data into MongoDB
    Given data has been exported from PostgreSQL
    When I import data into MongoDB
    Then all documents should be imported with correct structure
    And ObjectId references should replace foreign keys
    And embedded documents should be properly nested
    And indexes should be created after import

  @migration @data @priority-medium
  Scenario: Handle ID type conversion during migration
    Given PostgreSQL uses Long/Integer IDs
    And MongoDB uses String/ObjectId IDs
    When migrating data
    Then a mapping should be maintained between old and new IDs
    And all references should be updated to new ID format
    And the mapping should be preserved for rollback if needed

  @migration @data @priority-medium
  Scenario: Validate data integrity after migration
    Given data has been migrated to MongoDB
    When I run data validation
    Then document counts should match original row counts
    And all required fields should be populated
    And all references should point to existing documents
    And no orphaned documents should exist

  @migration @rollback @priority-low
  Scenario: Rollback plan for migration failure
    Given the migration may fail partway through
    When a rollback is required
    Then the original PostgreSQL database should remain intact
    And a rollback script should restore the application to use PostgreSQL
    And no data loss should occur during rollback

  # ========================================
  # SECTION 7: VERIFICATION SCENARIOS
  # ========================================

  @verification @compile @priority-critical
  Scenario: Application compiles after migration
    Given all migration changes have been applied
    When I run ./gradlew compileJava
    Then the build should succeed with no errors
    And there should be no deprecation warnings related to JPA
    And all MongoDB annotations should be properly resolved

  @verification @startup @priority-critical
  Scenario: Application starts successfully with MongoDB
    Given MongoDB is running
    And application is configured for MongoDB
    When I start the application with ./gradlew bootRun
    Then the application should start without errors
    And the application should connect to MongoDB
    And all beans should be initialized successfully
    And REST endpoints should be accessible

  @verification @crud @priority-critical
  Scenario Outline: CRUD operations work for all entities
    Given the application is running with MongoDB
    When I perform CRUD operations on "<entity>"
    Then CREATE should insert a document and return ID
    And READ should retrieve the document by ID
    And UPDATE should modify the document fields
    And DELETE should remove the document
    And all operations should be reflected in MongoDB

    Examples:
      | entity              |
      | User                |
      | League              |
      | Roster              |
      | NFLPlayer           |
      | NFLGame             |
      | TeamSelection       |
      | PersonalAccessToken |
      | AdminInvitation     |
      | ScoringFormula      |

  @verification @query @priority-high
  Scenario: All custom queries return correct results
    Given the application is running with MongoDB
    And test data is loaded
    When I execute all custom repository queries
    Then each query should return expected results
    And query performance should be acceptable (< 100ms for simple queries)
    And no N+1 query problems should occur

  @verification @test @priority-critical
  Scenario: All unit tests pass after migration
    Given the codebase has been migrated to MongoDB
    When I run ./gradlew test
    Then all unit tests should pass
    And test coverage should remain above 80%
    And no tests should be skipped due to MongoDB incompatibility

  @verification @integration @priority-critical
  Scenario: All integration tests pass with MongoDB
    Given MongoDB Testcontainers is configured
    When I run integration tests
    Then all integration tests should pass
    And tests should use isolated MongoDB instances
    And test data should be cleaned up after each test

  @verification @performance @priority-medium
  Scenario: Performance is acceptable after migration
    Given the application is running with MongoDB
    And sample data of 10000 documents per collection is loaded
    When I run performance benchmarks
    Then read operations should complete within 50ms average
    And write operations should complete within 100ms average
    And aggregate queries should complete within 500ms
    And no performance regression should exceed 20%

  @verification @cleanup @priority-critical
  Scenario: No PostgreSQL references remain in codebase
    Given the migration is complete
    When I search the codebase for PostgreSQL references
    Then no files should contain "postgresql"
    Then no files should contain "postgres"
    Then no files should import javax.persistence
    Then no files should import jakarta.persistence
    And the application should be purely MongoDB-based
