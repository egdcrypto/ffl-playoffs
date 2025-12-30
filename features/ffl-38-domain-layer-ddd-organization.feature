@architecture @ddd @domain @refactoring
Feature: FFL-38: Domain Layer Organization with DDD Aggregate Folder Structure
  As a development team
  I want to organize the domain layer following DDD tactical patterns
  So that aggregate roots, entities, value objects, and domain services are clearly separated

  Background:
    Given the project follows Domain-Driven Design principles
    And the domain layer is under src/main/java/com/ffl/playoffs/domain
    And hexagonal architecture is used with ports and adapters

  # ========================================
  # SECTION 1: FOLDER STRUCTURE CREATION
  # ========================================

  @folder @structure @priority-critical
  Scenario: Create DDD-compliant folder structure
    Given the domain layer needs proper organization
    When I create the DDD folder structure
    Then the following folders should exist:
      | folder                    | purpose                                    |
      | domain/aggregate          | Aggregate root classes                     |
      | domain/entity             | Non-root entities within aggregates        |
      | domain/valueobject        | Immutable value objects                    |
      | domain/model              | DTOs and simple domain models              |
      | domain/service            | Domain services with business logic        |
      | domain/port               | Inbound and outbound ports (interfaces)    |
      | domain/port/inbound       | Use case interfaces (primary ports)        |
      | domain/port/outbound      | Repository/external interfaces             |
      | domain/event              | Domain events                              |
      | domain/exception          | Domain-specific exceptions                 |
      | domain/specification      | Business rule specifications               |

  @folder @substructure @priority-high
  Scenario: Organize aggregate folder by bounded context
    Given multiple aggregates exist in the system
    When I organize aggregates by bounded context
    Then the aggregate folder should contain:
      | subfolder           | aggregates                              |
      | aggregate/league    | League aggregate and related entities   |
      | aggregate/roster    | Roster aggregate and related entities   |
      | aggregate/user      | User aggregate and related entities     |
      | aggregate/nfldata   | NFLPlayer, NFLGame aggregates           |
      | aggregate/scoring   | ScoringFormula and related entities     |

  @folder @port @priority-high
  Scenario: Organize port folder by direction
    Given ports define the domain boundaries
    When I organize the port folder
    Then the structure should be:
      | folder                    | contents                               |
      | port/inbound              | Use case interfaces                    |
      | port/outbound             | Repository interfaces                  |
      | port/outbound/persistence | Data persistence ports                 |
      | port/outbound/external    | External service ports (NFL API, etc)  |

  # ========================================
  # SECTION 2: CLASS MIGRATION - AGGREGATES
  # ========================================

  @migration @aggregate @priority-critical
  Scenario: Identify and migrate aggregate root classes
    Given the following classes are aggregate roots:
      | class              | identifies              | invariants                    |
      | League             | leagueId                | unique name, valid config     |
      | Roster             | rosterId                | valid players, position slots |
      | User               | userId                  | unique email, valid role      |
      | NFLPlayer          | playerId                | valid team, position          |
      | NFLGame            | gameId                  | valid teams, schedule         |
      | ScoringFormula     | formulaId               | valid rules, calculations     |
      | TeamSelection      | selectionId             | valid week, team              |
      | PersonalAccessToken| tokenId                 | valid hash, expiry            |
    When I migrate these classes to domain/aggregate
    Then each class should:
      | requirement                                          |
      | Be in package com.ffl.playoffs.domain.aggregate      |
      | Have @Document annotation for MongoDB                |
      | Have a unique identifier field                       |
      | Protect invariants through encapsulation             |
      | Expose behavior methods, not just getters/setters    |

  @migration @aggregate @priority-critical
  Scenario Outline: Migrate specific aggregate to correct package
    Given the class "<class_name>" exists in the domain layer
    When I move it to the aggregate folder
    Then the package should be "com.ffl.playoffs.domain.aggregate"
    And the file should be at "domain/aggregate/<class_name>.java"
    And all references should be updated across the codebase

    Examples:
      | class_name          |
      | League              |
      | Roster              |
      | User                |
      | NFLPlayer           |
      | NFLGame             |
      | ScoringFormula      |
      | TeamSelection       |
      | PersonalAccessToken |
      | AdminInvitation     |
      | PlayerInvitation    |

  # ========================================
  # SECTION 3: CLASS MIGRATION - ENTITIES
  # ========================================

  @migration @entity @priority-high
  Scenario: Identify and migrate non-root entity classes
    Given the following classes are entities within aggregates:
      | class              | parent_aggregate | relationship          |
      | LeagueConfiguration| League           | embedded              |
      | RosterSlot         | Roster           | embedded collection   |
      | PlayerStats        | NFLPlayer        | embedded collection   |
      | GameScore          | NFLGame          | embedded              |
    When I migrate these classes to domain/entity
    Then each class should:
      | requirement                                       |
      | Be in package com.ffl.playoffs.domain.entity      |
      | Have identity within its aggregate                |
      | Be referenced only through its aggregate root     |
      | Not be directly persisted (part of aggregate)     |

  @migration @entity @priority-high
  Scenario: Handle entity lifecycle within aggregate
    Given entities are part of their parent aggregate
    When organizing the entity folder
    Then entities should be created through aggregate factory methods
    And entities should be modified through aggregate methods
    And entities should not have public setters
    And aggregate root controls entity persistence

  # ========================================
  # SECTION 4: CLASS MIGRATION - VALUE OBJECTS
  # ========================================

  @migration @valueobject @priority-high
  Scenario: Identify and migrate value object classes
    Given the following classes are value objects:
      | class              | characteristics                          |
      | Email              | Immutable, validated email format        |
      | Score              | Immutable, calculated points             |
      | Week               | Immutable, NFL week number (1-22)        |
      | Season             | Immutable, NFL season year               |
      | Position           | Enum of NFL positions                    |
      | Role               | Enum of user roles                       |
      | LeagueStatus       | Enum of league states                    |
      | RosterStatus       | Enum of roster states                    |
    When I migrate these classes to domain/valueobject
    Then each class should:
      | requirement                                           |
      | Be in package com.ffl.playoffs.domain.valueobject     |
      | Be immutable (final fields, no setters)               |
      | Implement equals() based on all properties            |
      | Implement hashCode() based on all properties          |
      | Have factory methods or constructors with validation  |

  @migration @valueobject @priority-medium
  Scenario: Ensure value objects are immutable
    Given value objects must be immutable
    When I review value object classes
    Then all fields should be final
    And there should be no setter methods
    And any "modification" should return a new instance
    And value objects should be embeddable in aggregates

  # ========================================
  # SECTION 5: CLASS MIGRATION - DOMAIN SERVICES
  # ========================================

  @migration @service @priority-high
  Scenario: Identify and migrate domain service classes
    Given the following classes are domain services:
      | class              | purpose                                   |
      | ScoringCalculator  | Calculates fantasy points                 |
      | RosterValidator    | Validates roster composition              |
      | LeagueScorer       | Scores entire league standings            |
      | MatchupResolver    | Determines matchup winners                |
    When I migrate these classes to domain/service
    Then each class should:
      | requirement                                        |
      | Be in package com.ffl.playoffs.domain.service      |
      | Be stateless                                       |
      | Operate on aggregates passed as parameters         |
      | Not depend on infrastructure concerns              |
      | Have pure Java implementation (no Spring imports)  |

  @migration @service @priority-medium
  Scenario: Domain services should be framework-agnostic
    Given domain services are in the core domain
    When I review domain service implementations
    Then services should not import Spring framework classes
    And services should not import persistence annotations
    And services should only depend on domain layer classes
    And services should be easily unit testable

  # ========================================
  # SECTION 6: CLASS MIGRATION - PORTS
  # ========================================

  @migration @port @priority-critical
  Scenario: Migrate repository interfaces to outbound ports
    Given the following repository interfaces exist:
      | interface              | aggregate      |
      | LeagueRepository       | League         |
      | RosterRepository       | Roster         |
      | UserRepository         | User           |
      | NFLPlayerRepository    | NFLPlayer      |
      | NFLGameRepository      | NFLGame        |
      | TeamSelectionRepository| TeamSelection  |
    When I migrate these to domain/port/outbound
    Then each interface should:
      | requirement                                              |
      | Be in package com.ffl.playoffs.domain.port.outbound      |
      | Define only domain operations (not CRUD)                 |
      | Use domain types as parameters and return types          |
      | Not expose persistence details (no Page, Pageable)       |

  @migration @port @priority-high
  Scenario: Migrate use case interfaces to inbound ports
    Given use case interfaces define application entry points
    When I organize inbound ports
    Then use case interfaces should be in domain/port/inbound
    And each use case should have a single responsibility
    And use cases should accept command/query objects
    And use cases should return domain objects or DTOs

  @migration @port @priority-medium
  Scenario: Migrate external service interfaces to outbound ports
    Given external service interfaces exist:
      | interface              | external service        |
      | NflDataProvider        | SportsData.io API       |
      | EmailService           | Email sending           |
      | NotificationService    | Push notifications      |
    When I migrate these to domain/port/outbound/external
    Then interfaces should define domain-centric operations
    And interfaces should not expose external API details
    And interfaces should use domain types

  # ========================================
  # SECTION 7: PACKAGE UPDATES
  # ========================================

  @package @update @priority-critical
  Scenario: Update package declarations in migrated classes
    Given classes have been moved to new folders
    When I update package declarations
    Then each class should have correct package statement:
      | folder                  | package                                        |
      | domain/aggregate        | com.ffl.playoffs.domain.aggregate              |
      | domain/entity           | com.ffl.playoffs.domain.entity                 |
      | domain/valueobject      | com.ffl.playoffs.domain.valueobject            |
      | domain/service          | com.ffl.playoffs.domain.service                |
      | domain/port/inbound     | com.ffl.playoffs.domain.port.inbound           |
      | domain/port/outbound    | com.ffl.playoffs.domain.port.outbound          |
      | domain/event            | com.ffl.playoffs.domain.event                  |
      | domain/exception        | com.ffl.playoffs.domain.exception              |

  @package @model @priority-high
  Scenario: Organize model package for DTOs and simple models
    Given the model package contains various classes
    When I organize the model package
    Then command objects should be in model/command
    And query objects should be in model/query
    And response DTOs should be in model/response
    And simple data carriers should remain in model

  # ========================================
  # SECTION 8: IMPORT FIXES
  # ========================================

  @import @fix @priority-critical
  Scenario: Fix imports in application layer
    Given the application layer imports domain classes
    When package names change
    Then all imports in application/usecase should be updated
    And all imports in application/dto should be updated
    And all imports in application/service should be updated
    And no broken imports should remain

  @import @fix @priority-critical
  Scenario: Fix imports in infrastructure layer
    Given the infrastructure layer imports domain classes
    When package names change
    Then all imports in infrastructure/adapter should be updated
    And all imports in infrastructure/persistence should be updated
    And all imports in infrastructure/config should be updated
    And mapper classes should have correct imports

  @import @fix @priority-high
  Scenario: Fix imports in test classes
    Given test classes import domain classes
    When package names change
    Then all imports in test/java should be updated
    And BDD step definitions should have correct imports
    And integration tests should have correct imports
    And unit tests should have correct imports

  @import @automated @priority-high
  Scenario: Automate import fixing with IDE refactoring
    Given manual import fixing is error-prone
    When using IDE refactoring tools
    Then "Move Class" refactoring should update all references
    Or a sed/find script should update imports:
      """
      find . -name "*.java" -exec sed -i \
        's/com.ffl.playoffs.domain.League/com.ffl.playoffs.domain.aggregate.League/g' {} \;
      """
    And the build should compile after automated fixes

  # ========================================
  # SECTION 9: VERIFICATION SCENARIOS
  # ========================================

  @verification @compile @priority-critical
  Scenario: Project compiles after reorganization
    Given all classes have been migrated
    And all package declarations are updated
    And all imports are fixed
    When I run ./gradlew compileJava
    Then the build should succeed with no errors
    And there should be no unresolved symbol errors
    And there should be no package does not exist errors

  @verification @test @priority-critical
  Scenario: All unit tests pass after reorganization
    Given the project compiles successfully
    When I run ./gradlew test
    Then all unit tests should pass
    And no tests should fail due to import issues
    And test coverage should remain unchanged

  @verification @integration @priority-high
  Scenario: All integration tests pass after reorganization
    Given unit tests pass
    When I run integration tests
    Then all integration tests should pass
    And database mappings should work correctly
    And REST endpoints should function properly

  @verification @structure @priority-high
  Scenario: Verify correct class placement
    Given the reorganization is complete
    When I analyze the folder structure
    Then aggregate folder should only contain aggregate roots
    And entity folder should only contain non-root entities
    And valueobject folder should only contain immutable value objects
    And service folder should only contain stateless domain services
    And no domain classes should remain in the wrong folder

  @verification @dependencies @priority-high
  Scenario: Verify domain layer has no outward dependencies
    Given domain is the core layer in hexagonal architecture
    When I analyze domain class imports
    Then domain classes should not import from application layer
    And domain classes should not import from infrastructure layer
    And domain classes should not import Spring framework classes
    And domain classes should only use pure Java and domain imports

  @verification @circular @priority-medium
  Scenario: No circular dependencies exist
    Given classes reference each other
    When I analyze class dependencies
    Then there should be no circular package dependencies
    And aggregates should not directly reference other aggregates
    And value objects should not reference entities
    And the dependency flow should be: infrastructure -> application -> domain

  # ========================================
  # SECTION 10: DOCUMENTATION
  # ========================================

  @documentation @priority-medium
  Scenario: Document the new folder structure
    Given the reorganization is complete
    When I update documentation
    Then README should describe the DDD folder structure
    And each folder should have a package-info.java explaining its purpose
    And architecture decision records should document the change
    And developer onboarding docs should reflect new structure

  @documentation @diagram @priority-low
  Scenario: Create architecture diagrams
    Given the new structure is documented
    When I create visual documentation
    Then a folder structure diagram should be created
    And aggregate relationship diagrams should be updated
    And the hexagonal architecture diagram should show layers
