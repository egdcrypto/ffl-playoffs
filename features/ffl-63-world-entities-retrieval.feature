@world @entities @retrieval @mvp-foundation
Feature: World Entities Retrieval
  As a world creator
  I want to retrieve all entities extracted from documents in my world
  So that I can see and manage all entities in one place

  Background:
    Given I am authenticated as a user
    And a world exists with id "test-world-123"
    And the following documents have been processed in the world:
      | documentId | title              | entitiesCount |
      | doc-001    | Romeo and Juliet   | 15            |
      | doc-002    | Merchant of Venice | 12            |
      | doc-003    | Hamlet             | 20            |

  # =============================================================================
  # BASIC ENTITY RETRIEVAL
  # =============================================================================

  @retrieval @all
  Scenario: Retrieve all entities for a world
    When I request all entities for world "test-world-123"
    Then the response should be successful
    And the response should contain entities from all documents
    And each entity should include:
      | Field             | Description                      |
      | id                | Unique entity identifier         |
      | name              | Entity name                      |
      | type              | Entity type (Character, etc.)    |
      | description       | Entity description               |
      | documentIds       | Documents containing entity      |
      | occurrenceCount   | Number of appearances            |
      | confidenceScore   | Extraction confidence            |
      | status            | Entity status                    |
      | createdAt         | Creation timestamp               |
      | updatedAt         | Last update timestamp            |

  @retrieval @details
  Scenario: Retrieve entity with full details
    Given entity "ent-romeo-001" exists in world "test-world-123"
    When I request full details for entity "ent-romeo-001"
    Then the response should include:
      | Section           | Content                          |
      | Basic info        | Name, type, description          |
      | Source documents  | All documents containing entity  |
      | Relationships     | Related entities                 |
      | Attributes        | Entity-specific attributes       |
      | Extraction info   | Confidence, method, timestamps   |
      | Enhancement info  | Enhancement status and history   |

  @retrieval @by-document
  Scenario: Retrieve entities for specific document
    When I request entities for document "doc-001" in world "test-world-123"
    Then the response should contain only entities from "Romeo and Juliet"
    And the entity count should be 15

  # =============================================================================
  # FILTERING BY TYPE
  # =============================================================================

  @filter @type
  Scenario: Filter entities by type
    Given the world contains entities of types:
      | Type        | Count |
      | Character   | 25    |
      | Location    | 10    |
      | Object      | 8     |
      | Event       | 4     |
    When I request entities with type filter "Character"
    Then the response should contain only Character entities
    And the entity count should be 25

  @filter @type-multiple
  Scenario: Filter entities by multiple types
    When I request entities with type filter "Character,Location"
    Then the response should contain entities of types:
      | Type        |
      | Character   |
      | Location    |
    And the response should not contain entities of type "Object"
    And the response should not contain entities of type "Event"

  @filter @type-invalid
  Scenario: Handle invalid entity type filter
    When I request entities with type filter "InvalidType"
    Then the response should return an empty list
    And the response should include a warning about unrecognized type

  # =============================================================================
  # FILTERING BY STATUS
  # =============================================================================

  @filter @status
  Scenario: Filter entities by status
    Given the world contains entities with statuses:
      | Status      | Count |
      | PENDING     | 10    |
      | APPROVED    | 30    |
      | REJECTED    | 5     |
      | ENHANCED    | 2     |
    When I request entities with status filter "APPROVED"
    Then the response should contain only approved entities
    And the entity count should be 30

  @filter @status-multiple
  Scenario: Filter entities by multiple statuses
    When I request entities with status filter "PENDING,APPROVED"
    Then the response should contain entities with status PENDING or APPROVED
    And the entity count should be 40

  # =============================================================================
  # FILTERING BY CONFIDENCE
  # =============================================================================

  @filter @confidence
  Scenario: Filter entities by minimum confidence
    Given the world contains entities with various confidence scores
    When I request entities with minimum confidence 0.8
    Then all returned entities should have confidence >= 0.8
    And lower confidence entities should be excluded

  @filter @confidence-range
  Scenario: Filter entities by confidence range
    When I request entities with confidence between 0.7 and 0.9
    Then all returned entities should have confidence >= 0.7
    And all returned entities should have confidence <= 0.9

  # =============================================================================
  # COMBINED FILTERS
  # =============================================================================

  @filter @combined
  Scenario: Combine multiple filters
    When I request entities with filters:
      | Filter            | Value                |
      | type              | Character            |
      | status            | APPROVED             |
      | minConfidence     | 0.85                 |
    Then all returned entities should match all filter criteria
    And I should see the applied filters in the response metadata

  @filter @complex
  Scenario: Apply complex filter combination
    When I request entities with filters:
      | Filter            | Value                |
      | types             | Character,Location   |
      | statuses          | APPROVED,ENHANCED    |
      | minConfidence     | 0.75                 |
      | documentId        | doc-001              |
    Then only entities matching all criteria should be returned
    And I should see filter statistics in response

  # =============================================================================
  # PAGINATION
  # =============================================================================

  @pagination @basic
  Scenario: Paginate entity results
    Given the world contains 47 entities
    When I request entities with page size 10 and page number 1
    Then the response should contain 10 entities
    And the response should include pagination info:
      | Field             | Value                |
      | totalEntities     | 47                   |
      | pageSize          | 10                   |
      | currentPage       | 1                    |
      | totalPages        | 5                    |
      | hasNextPage       | true                 |
      | hasPreviousPage   | false                |

  @pagination @navigate
  Scenario: Navigate through paginated results
    Given the world contains 47 entities
    When I request page 3 with page size 10
    Then the response should contain 10 entities
    And the response should show:
      | Field             | Value                |
      | currentPage       | 3                    |
      | hasNextPage       | true                 |
      | hasPreviousPage   | true                 |

  @pagination @last-page
  Scenario: Handle last page with partial results
    Given the world contains 47 entities
    When I request page 5 with page size 10
    Then the response should contain 7 entities
    And hasNextPage should be false

  @pagination @cursor
  Scenario: Support cursor-based pagination
    When I request entities with cursor-based pagination
    Then the response should include:
      | Field             | Description                      |
      | nextCursor        | Cursor for next page             |
      | previousCursor    | Cursor for previous page         |
    And I should be able to use cursor for next request

  # =============================================================================
  # SORTING
  # =============================================================================

  @sort @name
  Scenario: Sort entities by name
    When I request entities sorted by "name" in "ascending" order
    Then entities should be returned in alphabetical order by name
    And the first entity should have the alphabetically first name

  @sort @name-desc
  Scenario: Sort entities by name descending
    When I request entities sorted by "name" in "descending" order
    Then entities should be returned in reverse alphabetical order

  @sort @confidence
  Scenario: Sort entities by confidence score
    When I request entities sorted by "confidenceScore" in "descending" order
    Then entities should be ordered by confidence from highest to lowest
    And the first entity should have the highest confidence score

  @sort @occurrence
  Scenario: Sort entities by occurrence count
    When I request entities sorted by "occurrenceCount" in "descending" order
    Then entities should be ordered by number of occurrences
    And the most frequently occurring entity should be first

  @sort @created
  Scenario: Sort entities by creation date
    When I request entities sorted by "createdAt" in "descending" order
    Then entities should be ordered by creation date
    And the most recently created entity should be first

  @sort @type-then-name
  Scenario: Sort entities by multiple fields
    When I request entities sorted by "type" then by "name"
    Then entities should be grouped by type
    And within each type, entities should be alphabetical by name

  # =============================================================================
  # MULTI-DOCUMENT ENTITIES
  # =============================================================================

  @multi-document @tracking
  Scenario: Handle entities that appear in multiple documents
    Given entity "Romeo" appears in documents:
      | documentId | occurrences |
      | doc-001    | 150         |
      | doc-005    | 25          |
    When I retrieve entity "Romeo"
    Then the entity should show:
      | Field               | Value                |
      | documentIds         | [doc-001, doc-005]   |
      | totalOccurrences    | 175                  |
      | primaryDocumentId   | doc-001              |
    And I should see occurrence breakdown by document

  @multi-document @aggregation
  Scenario: Aggregate entity data from multiple documents
    Given entity "Verona" appears in 3 documents with different descriptions
    When I retrieve entity "Verona"
    Then the entity should have a merged description
    And I should see the sources for each attribute
    And conflicting attributes should be flagged

  # =============================================================================
  # SEARCH
  # =============================================================================

  @search @name
  Scenario: Search entities by name
    When I search entities with query "Romeo"
    Then the response should include entities with "Romeo" in the name
    And search should be case-insensitive
    And partial matches should be included

  @search @advanced
  Scenario: Search entities with advanced query
    When I search entities with:
      | Search Field      | Query                |
      | name              | romeo                |
      | description       | montague             |
    Then results should match any of the search criteria
    And I should see match scores for each result

  @search @fuzzy
  Scenario: Support fuzzy search for entity names
    When I search entities with query "Rommeo" and fuzzy matching enabled
    Then results should include "Romeo" despite the typo
    And I should see the match confidence

  # =============================================================================
  # STATISTICS
  # =============================================================================

  @statistics @response
  Scenario: Include entity statistics in response
    When I request entities with statistics enabled
    Then the response should include statistics:
      | Statistic           | Description                      |
      | totalEntities       | Total entity count               |
      | byType              | Count per entity type            |
      | byStatus            | Count per status                 |
      | avgConfidence       | Average confidence score         |
      | documentCoverage    | Entities per document            |
      | enhancementCoverage | Enhanced vs total                |

  @statistics @detailed
  Scenario: Request detailed entity statistics
    When I request detailed statistics for world entities
    Then I should see:
      | Metric              | Breakdown                        |
      | Entity distribution | By type, status, confidence      |
      | Document coverage   | Entities per document            |
      | Relationship stats  | Connections between entities     |
      | Quality metrics     | Confidence distribution          |

  # =============================================================================
  # EMPTY AND ERROR STATES
  # =============================================================================

  @error @world-not-found
  Scenario: Retrieve entities for non-existent world
    When I request entities for world "non-existent-world"
    Then the response should return 404 Not Found
    And the error message should be "World not found"

  @empty @no-documents
  Scenario: Retrieve entities for world with no documents
    Given world "empty-world-123" exists with no documents
    When I request entities for world "empty-world-123"
    Then the response should return an empty entity list
    And the response should include:
      | Field             | Value                |
      | totalEntities     | 0                    |
      | message           | No documents in world|

  @empty @no-entities
  Scenario: Retrieve entities for world with documents but no extracted entities
    Given world "docs-no-entities" has documents pending extraction
    When I request entities for world "docs-no-entities"
    Then the response should return an empty entity list
    And the response should include:
      | Field             | Value                    |
      | totalEntities     | 0                        |
      | message           | No entities extracted yet|
      | pendingDocuments  | Count of pending docs    |

  # =============================================================================
  # EXPORT
  # =============================================================================

  @export @csv
  Scenario: Export entities as CSV
    When I request entity export in CSV format
    Then the response should be a downloadable CSV file
    And the CSV should include columns:
      | Column            |
      | id                |
      | name              |
      | type              |
      | description       |
      | status            |
      | confidenceScore   |
      | occurrenceCount   |
      | documentIds       |
    And all entities should be included

  @export @json
  Scenario: Export entities as JSON
    When I request entity export in JSON format
    Then the response should be a downloadable JSON file
    And the JSON should contain the full entity structure
    And relationships should be included

  @export @filtered
  Scenario: Export filtered entities
    When I request entity export with filters:
      | Filter            | Value                |
      | type              | Character            |
      | status            | APPROVED             |
    Then only matching entities should be in the export
    And the export metadata should show applied filters

  # =============================================================================
  # GROUPING
  # =============================================================================

  @grouping @type
  Scenario: Group entities by type
    When I request entities grouped by type
    Then the response should organize entities by type:
      | Type        | Entities             |
      | Character   | [list of characters] |
      | Location    | [list of locations]  |
      | Object      | [list of objects]    |
      | Event       | [list of events]     |
    And each group should include entity count

  @grouping @document
  Scenario: Group entities by source document
    When I request entities grouped by document
    Then the response should organize entities by document:
      | Document           | EntityCount |
      | Romeo and Juliet   | 15          |
      | Merchant of Venice | 12          |
      | Hamlet             | 20          |

  @grouping @status
  Scenario: Group entities by status
    When I request entities grouped by status
    Then the response should show entities organized by status
    And each group should include count and percentage

  # =============================================================================
  # PERFORMANCE
  # =============================================================================

  @performance @large-dataset
  Scenario: Handle large number of entities efficiently
    Given the world contains 10000 entities
    When I request entities with pagination
    Then the response time should be under 2 seconds
    And the first page should load without loading all entities
    And I should see efficient query execution

  @performance @caching
  Scenario: Cache entity retrieval results
    Given I have retrieved entities for world "test-world-123"
    When I request the same entities again
    Then the response should be served from cache
    And the response time should be significantly faster
    And cache headers should indicate cache hit

  # =============================================================================
  # AUTHORIZATION
  # =============================================================================

  @auth @ownership
  Scenario: User can only retrieve entities from their own worlds
    Given user "user-A" owns world "world-A"
    And user "user-B" owns world "world-B"
    When user "user-B" requests entities for "world-A"
    Then the response should return 403 Forbidden
    And the error message should be "Access denied to this world"

  @auth @shared
  Scenario: Retrieve entities from shared worlds
    Given world "shared-world" is shared with user "user-B" with "read" access
    When user "user-B" requests entities for "shared-world"
    Then the response should be successful
    And all entities should be visible to user-B

  @auth @permissions
  Scenario: Respect entity-level permissions
    Given some entities are marked as private
    When a user with limited access requests entities
    Then only permitted entities should be returned
    And private entities should be filtered out

  # =============================================================================
  # ERROR CASES
  # =============================================================================

  @error @invalid-params
  Scenario: Handle invalid query parameters
    When I request entities with invalid page number -1
    Then the response should return 400 Bad Request
    And the error should explain the valid parameter range

  @error @invalid-sort
  Scenario: Handle invalid sort field
    When I request entities sorted by "invalidField"
    Then the response should return 400 Bad Request
    And the error should list valid sort fields

  @error @server-error
  Scenario: Handle server errors gracefully
    Given the entity database is temporarily unavailable
    When I request entities
    Then the response should return 503 Service Unavailable
    And the error should indicate retry information
    And the error should be logged for investigation
