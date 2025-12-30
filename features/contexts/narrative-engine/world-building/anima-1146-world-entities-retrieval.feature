@ANIMA-1146
Feature: World Entities Retrieval

As a world creator
I want to retrieve all entities extracted from documents in my world
So that I can see and manage all entities in one place
Background:
Given I am authenticated as a user
And a world exists with id "test-world-123"
And the following documents have been processed in the world:
| documentId | title                | entitiesCount |
| doc-001    | Romeo and Juliet     | 15           |
| doc-002    | Merchant of Venice   | 12           |
| doc-003    | Hamlet              | 20           |
- Scenario: Retrieve all entities for a world
- Scenario: Filter entities by type
- Scenario: Filter entities by multiple types
- Scenario: Filter entities by status
- Scenario: Filter entities by minimum confidence
- Scenario: Combine multiple filters
- Scenario: Paginate entity results
- Scenario: Sort entities by name
- Scenario: Sort entities by confidence score
- Scenario: Sort entities by occurrence count
- Scenario: Handle entities that appear in multiple documents
- Scenario: Search entities by name
- Scenario: Include entity statistics in response
- Scenario: Retrieve entities for non-existent world
- Scenario: Retrieve entities for world with no documents
- Scenario: Retrieve entities for world with documents but no extracted entities
- Scenario: Export entities as CSV
- Scenario: Group entities by type
- Scenario: Handle large number of entities efficiently
- Scenario: User can only retrieve entities from their own worlds