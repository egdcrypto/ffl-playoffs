@architecture @priority_1 @tech-debt
Feature: Domain Layer Organization - Aggregate Folder Structure
  As a developer
  I want the domain layer organized with proper DDD folder structure
  So that aggregate classes are clearly separated and the codebase is maintainable

  Background:
    Given the project follows Domain-Driven Design principles
    And aggregate roots should be clearly identifiable in the folder structure

  Scenario: Create aggregate folder under domain
    Given the current domain structure is flat
    When the aggregate folder is created
    Then the folder structure should be:
      | path                                           |
      | src/main/java/.../domain/aggregate/            |
      | src/main/java/.../domain/entity/               |
      | src/main/java/.../domain/valueobject/          |
      | src/main/java/.../domain/repository/           |
      | src/main/java/.../domain/service/              |

  Scenario: Move aggregate classes to aggregate folder
    Given the following aggregate classes exist in domain:
      | class              | type           |
      | League             | Aggregate Root |
      | Team               | Aggregate Root |
      | Player             | Aggregate Root |
      | Season             | Aggregate Root |
      | Matchup            | Aggregate Root |
      | Roster             | Aggregate Root |
    When classes are moved to the aggregate folder
    Then package declarations are updated
    And all imports across the codebase are updated
    And the build still compiles successfully

  Scenario: Verify no broken references after reorganization
    Given the aggregate folder reorganization is complete
    When the project is built with Gradle
    Then there are no compilation errors
    And all tests pass
    And IDE navigation works correctly

  # Implementation Notes:
  # 1. Create src/main/java/com/fflplayoffs/domain/aggregate/
  # 2. Move all *Aggregate.java files to aggregate/
  # 3. Update package declarations in moved files
  # 4. Run: find . -name "*.java" -exec sed -i 's/old.package/new.package/g' {} \;
  # 5. Verify with: ./gradlew build
