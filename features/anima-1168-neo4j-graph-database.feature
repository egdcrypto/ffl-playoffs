@infrastructure @neo4j @graph-database @semantic-memory
Feature: Neo4j Graph Database Integration
  As the narrative engine
  I want to store entities and relationships in a graph database
  So that I can query complex relationships for AI context generation

  Background:
    Given the Neo4j graph database is configured and running
    And the connection pool is initialized with 20 connections
    And I have a world "Romeo and Juliet" with ingested source material
    And the graph schema is initialized with proper indexes
    And the following entity types are defined:
      | entity_type  | description              |
      | CHARACTER    | Story characters/NPCs    |
      | LOCATION     | Places in the world      |
      | ITEM         | Objects and artifacts    |
      | ORGANIZATION | Groups and factions      |
      | EVENT        | Story events and moments |
      | CONCEPT      | Abstract ideas and themes|

  # ============================================
  # ENTITY NODE OPERATIONS
  # ============================================

  @domain @entity_nodes
  Scenario: Store world entity as graph node with full properties
    Given I have extracted the following entity from source material:
      | property    | value                                    |
      | name        | Romeo Montague                           |
      | type        | CHARACTER                                |
      | description | Young heir to the Montague family, passionate and impulsive |
    When I persist the entity to the graph database
    Then a node should be created with the following properties:
      | property         | value                                    |
      | entity_id        | auto-generated UUID                      |
      | entity_type      | CHARACTER                                |
      | name             | Romeo Montague                           |
      | description      | Young heir to the Montague family...     |
      | embedding_vector | 1536-dimension float array               |
      | canonical        | true                                     |
      | created_at       | current timestamp                        |
      | updated_at       | current timestamp                        |
      | world_id         | romeo-and-juliet-world                   |
      | version          | 1                                        |
    And the node should have label "Entity" and "CHARACTER"
    And the node should be indexed for fast lookup
    And domain event EntityNodeCreated should be published

  @domain @entity_nodes
  Scenario: Create entity node with embedding vector
    Given I have an entity "Juliet Capulet" to persist
    And I have generated an embedding vector for the entity description
    When I persist the entity with embedding:
      | property         | value                           |
      | name             | Juliet Capulet                  |
      | embedding_vector | [0.123, 0.456, ..., 0.789]      |
    Then the embedding should be stored as a native vector property
    And the vector index should be updated for similarity search
    And I should be able to query similar entities using vector search

  @domain @entity_nodes
  Scenario: Query nodes by entity type
    Given the following entities exist in the graph:
      | name              | entity_type  |
      | Romeo Montague    | CHARACTER    |
      | Juliet Capulet    | CHARACTER    |
      | Friar Lawrence    | CHARACTER    |
      | Capulet Mansion   | LOCATION     |
      | Verona Streets    | LOCATION     |
      | Poison Vial       | ITEM         |
    When I query all entities of type "CHARACTER"
    Then I should receive 3 character entities
    And the results should include Romeo, Juliet, and Friar Lawrence
    And location and item entities should not be included

  @domain @entity_nodes
  Scenario: Search nodes by semantic similarity
    Given entities with embeddings exist in the graph
    And I have a query embedding for "young lovers in conflict"
    When I search for entities with similarity threshold 0.75
    Then I should receive entities ordered by similarity:
      | entity           | similarity_score |
      | Romeo Montague   | 0.92             |
      | Juliet Capulet   | 0.91             |
      | Paris            | 0.78             |
    And entities below threshold should be excluded
    And each result should include the similarity score

  @domain @entity_nodes
  Scenario: Update entity node properties
    Given entity "Romeo Montague" exists with version 1
    When I update the entity with new properties:
      | property    | new_value                                |
      | description | Tragic hero who dies for love            |
      | status      | deceased                                 |
    Then the entity should be updated:
      | property   | value                               |
      | version    | 2                                   |
      | updated_at | current timestamp                   |
    And the embedding vector should be regenerated
    And domain event EntityNodeUpdated should be published with:
      | field          | value                    |
      | entity_id      | romeo-entity-id          |
      | changed_fields | description, status      |
      | old_version    | 1                        |
      | new_version    | 2                        |

  @domain @entity_nodes
  Scenario: Create player-generated entity (non-canonical)
    Given a player creates a new character in the world
    When I persist the player-generated entity:
      | property    | value                    |
      | name        | Sir Reginald             |
      | type        | CHARACTER                |
      | canonical   | false                    |
      | created_by  | player-12345             |
    Then the entity should be created with canonical=false
    And the entity should be flagged as player-generated
    And the entity should be isolated to the player's session

  # ============================================
  # RELATIONSHIP EDGE OPERATIONS
  # ============================================

  @domain @relationship_edges
  Scenario: Create relationship between entities with full properties
    Given entities "Romeo" and "Juliet" exist in the graph
    When I create a relationship between them:
      | property          | value                    |
      | relationship_type | LOVES                    |
      | weight            | 0.95                     |
      | sentiment         | passionate               |
      | canonical         | true                     |
      | context           | Star-crossed lovers      |
    Then a directed edge should be created from Romeo to Juliet
    And the edge should have all specified properties
    And domain event RelationshipCreated should be published

  @domain @relationship_edges
  Scenario: Create bidirectional relationship
    Given entities "Romeo" and "Juliet" exist in the graph
    When I create a bidirectional LOVES relationship with weight 0.95
    Then two edges should be created:
      | from   | to     | type  | weight |
      | Romeo  | Juliet | LOVES | 0.95   |
      | Juliet | Romeo  | LOVES | 0.95   |
    And both edges should share a relationship_pair_id
    And I should be able to query the relationship from either direction

  @domain @relationship_edges
  Scenario: Query relationships by type
    Given the following relationships exist:
      | from    | to      | type      | weight |
      | Romeo   | Juliet  | LOVES     | 0.95   |
      | Romeo   | Mercutio| FRIEND_OF | 0.85   |
      | Romeo   | Tybalt  | HATES     | 0.70   |
      | Juliet  | Nurse   | TRUSTS    | 0.80   |
    When I query all relationships of type "LOVES" for world
    Then I should receive only the Romeo-Juliet relationship
    And the result should include both endpoints and edge properties

  @domain @relationship_edges
  Scenario: Traverse relationship chains
    Given the following relationship chain exists:
      | from              | to                | type      |
      | Romeo             | Montague_Family   | MEMBER_OF |
      | Montague_Family   | Verona            | LOCATED_IN|
      | Verona            | Italy             | PART_OF   |
    When I traverse from "Romeo" with max depth 3
    Then I should receive the complete path:
      | path                                                    |
      | Romeo -> Montague_Family -> Verona -> Italy             |
    And each step should include the relationship type
    And I should be able to filter by relationship types

  @domain @relationship_edges
  Scenario: Query all relationships for an entity
    Given "Romeo" has 8 relationships with various entities
    When I query all relationships for "Romeo"
    Then I should receive all 8 relationships:
      | related_entity | relationship_type | direction |
      | Juliet         | LOVES             | outgoing  |
      | Mercutio       | FRIEND_OF         | outgoing  |
      | Tybalt         | ENEMY_OF          | outgoing  |
      | Montague       | CHILD_OF          | outgoing  |
      | Lady_Montague  | CHILD_OF          | outgoing  |
      | Benvolio       | FRIEND_OF         | outgoing  |
      | Friar_Lawrence | TRUSTS            | outgoing  |
      | Player         | KNOWS             | incoming  |
    And relationships should be grouped by direction

  @domain @relationship_edges
  Scenario: Update relationship weight and sentiment
    Given relationship "Romeo LOVES Juliet" exists with weight 0.80
    When a story event increases Romeo's love:
      | event                        | weight_change |
      | Romeo meets Juliet at party  | +0.10         |
      | Romeo and Juliet marry       | +0.05         |
    Then the relationship weight should be updated to 0.95
    And the sentiment should be updated to "devoted"
    And relationship history should be preserved
    And domain event RelationshipUpdated should be published

  @domain @dynamic_relationships
  Scenario: Create dynamic relationship from player interaction
    Given "Romeo" has no existing relationship with "Player"
    When the player performs a friendly action toward Romeo
    Then a new relationship should be created:
      | from   | to     | type      | weight | sentiment |
      | Romeo  | Player | LIKES     | 0.30   | friendly  |
    And subsequent friendly actions should increase weight
    And the relationship should be marked as player-influenced

  @domain @dynamic_relationships
  Scenario: Update relationship based on negative player interaction
    Given "Romeo" has relationship "LIKES" with "Player" at weight 0.50
    When the player performs a hostile action toward Romeo
    Then the relationship should be updated:
      | action                    | result                    |
      | Decrease LIKES weight     | LIKES weight becomes 0.20 |
      | Create DISLIKES edge      | If hostility continues    |
      | Remove LIKES relationship | If weight drops to 0      |
    And conflicting relationships should be handled appropriately

  @domain @dynamic_relationships
  Scenario: Handle conflicting relationship types
    Given "Romeo" has both "LIKES" (0.3) and "DISLIKES" (0.4) with "Tybalt"
    When I query Romeo's sentiment toward Tybalt
    Then the system should return:
      | field              | value                          |
      | primary_sentiment  | DISLIKES (higher weight)       |
      | conflicted         | true                           |
      | relationship_history| Timeline of changes           |
    And narrative context should reflect the conflict

  # ============================================
  # CAUSALITY GRAPH OPERATIONS
  # ============================================

  @domain @causality_graph
  Scenario: Create causal relationship between events
    Given the following story events exist as nodes:
      | event_id | event_name           | timestamp           |
      | evt-001  | Tybalt_insults_Romeo | 2024-01-15T10:00:00 |
      | evt-002  | Duel_begins          | 2024-01-15T10:05:00 |
      | evt-003  | Mercutio_dies        | 2024-01-15T10:15:00 |
    When I create causality relationships:
      | event_a              | relationship | event_b        |
      | Tybalt_insults_Romeo | CAUSES       | Duel_begins    |
      | Duel_begins          | CAUSES       | Mercutio_dies  |
    Then causal edges should be created between events
    And I should be able to query the causal chain
    And temporal consistency should be validated

  @domain @causality_graph
  Scenario: Query prerequisite events
    Given a causal chain exists for "Romeo_kills_Tybalt"
    When I query the prerequisites for this event
    Then I should receive all causally preceding events:
      | event                | depth |
      | Duel_begins          | 1     |
      | Mercutio_dies        | 1     |
      | Tybalt_insults_Romeo | 2     |
    And events should be ordered by causal depth
    And optional prerequisites should be marked

  @domain @causality_graph
  Scenario: Find all triggered events
    Given event "Juliet_takes_poison" exists
    When I query all events triggered by this event
    Then I should receive:
      | triggered_event          | relationship |
      | Romeo_believes_dead      | CAUSES       |
      | Romeo_buys_poison        | CAUSES       |
      | Romeo_dies               | CAUSES       |
      | Juliet_wakes_finds_Romeo | CAUSES       |
    And the causal chain should extend to final outcomes

  @domain @causality_graph
  Scenario: Create prevention relationship
    Given canonical event "Juliet_dies" exists
    And player action "Player_warns_Romeo" occurs
    When I create a prevention relationship:
      | event_a            | relationship | event_b     |
      | Player_warns_Romeo | PREVENTS     | Romeo_dies  |
    Then the prevention should be recorded
    And the prevented event should be marked as "invalidated"
    And alternative outcomes should be calculated

  @domain @causality_graph
  Scenario: Invalidate downstream events on prevention
    Given event chain A -> B -> C -> D exists
    When event B is prevented
    Then downstream events C and D should be marked as "potentially_invalidated"
    And the narrative engine should recalculate possible futures
    And domain event CausalChainBroken should be published

  # ============================================
  # AI CONTEXT RETRIEVAL
  # ============================================

  @integration @context_retrieval
  Scenario: Query graph for comprehensive AI context
    Given I need context for generating Romeo's dialogue
    And Romeo has existing relationships and event history
    When I query the graph for Romeo's AI context
    Then I should receive structured context:
      """json
      {
        "entity": {
          "id": "romeo-123",
          "name": "Romeo Montague",
          "type": "CHARACTER",
          "description": "Young heir to the Montague family..."
        },
        "relationships": [
          {"target": "Juliet", "type": "LOVES", "weight": 0.95, "sentiment": "passionate"},
          {"target": "Tybalt", "type": "ENEMY_OF", "weight": 0.80, "sentiment": "hostile"}
        ],
        "sentiment_summary": {
          "overall_mood": "conflicted",
          "positive_connections": 5,
          "negative_connections": 2
        },
        "recent_events": [
          {"event": "Married Juliet in secret", "timestamp": "..."},
          {"event": "Killed Tybalt", "timestamp": "..."}
        ],
        "location_context": {
          "current": "Mantua",
          "known_locations": ["Verona", "Capulet_Tomb"]
        },
        "active_goals": [
          {"goal": "Return to Juliet", "progress": 0.3}
        ]
      }
      """
    And the context should be formatted for LLM injection
    And retrieval should complete within 100ms

  @integration @context_retrieval
  Scenario: Retrieve context for multiple entities
    Given I need context for a scene with Romeo, Juliet, and Friar Lawrence
    When I query context for all three entities
    Then I should receive aggregated context:
      | entity          | relationship_count | event_count |
      | Romeo           | 8                  | 5           |
      | Juliet          | 6                  | 4           |
      | Friar_Lawrence  | 4                  | 3           |
    And inter-entity relationships should be highlighted
    And shared events should be deduplicated

  @integration @context_retrieval
  Scenario: Filter context by relevance to current scene
    Given I am generating dialogue for a love scene
    When I query context with scene filter "romantic":
      | filter              | value     |
      | relationship_types  | LOVES, ADMIRES, TRUSTS |
      | sentiment_filter    | positive  |
      | time_window         | recent    |
    Then hostile relationships should be excluded
    And context should be optimized for romantic dialogue generation

  @integration @context_retrieval
  Scenario: Include player-specific context
    Given player has interacted with Romeo multiple times
    When I query context including player relationships
    Then context should include:
      | context_type        | data                              |
      | player_relationship | Romeo's sentiment toward player   |
      | interaction_history | Recent player-Romeo interactions  |
      | player_reputation   | Player's standing with Montagues  |
    And player context should be separate from canonical context

  # ============================================
  # GRAPH CONSISTENCY AND MAINTENANCE
  # ============================================

  @integration @graph_consistency
  Scenario: Detect and merge duplicate entities
    Given entity "Romeo Montague" exists with id "char-001"
    When I attempt to create "Romeo" with 0.95 embedding similarity
    Then the system should:
      | action              | description                        |
      | detect_similarity   | Flag potential duplicate           |
      | calculate_confidence| Report 95% duplicate confidence    |
      | suggest_merge       | Prompt curator for decision        |
    And if merge is approved:
      | action              | description                        |
      | combine_properties  | Merge unique properties            |
      | redirect_relationships| Point all edges to surviving node|
      | preserve_provenance | Record merge history               |
    And domain event EntitiesMerged should be published

  @integration @graph_consistency
  Scenario: Clean up orphaned entities
    Given scheduled cleanup job runs
    When orphaned entities are detected:
      | criteria                              |
      | No incoming or outgoing relationships |
      | No activity in last 30 days           |
      | Not marked as intentionally isolated  |
    Then orphan report should be generated:
      | entity_id | name        | last_activity | recommendation |
      | char-099  | Old_Guard   | 45 days ago   | archive        |
      | loc-055   | Unused_Room | 60 days ago   | delete         |
    And curator should review before deletion
    And audit log should record cleanup actions

  @integration @graph_consistency
  Scenario: Detect relationship contradictions
    Given the following relationships exist:
      | from   | to     | type      | weight |
      | Romeo  | Juliet | LOVES     | 0.95   |
      | Romeo  | Juliet | HATES     | 0.80   |
    When I run contradiction detection
    Then the system should flag the contradiction:
      | entity_pair | conflicting_types | resolution_needed |
      | Romeo-Juliet| LOVES vs HATES    | yes               |
    And suggest resolution options:
      | option              | description                      |
      | keep_stronger       | Keep LOVES (higher weight)       |
      | mark_conflicted     | Flag as complex relationship     |
      | archive_weaker      | Archive HATES with history       |

  @integration @graph_consistency
  Scenario: Maintain temporal ordering of events
    Given events are being added to the graph
    When I add an event with invalid temporal ordering:
      | event              | timestamp           | issue               |
      | Romeo_speaks_after_death | After Romeo's death | Temporal violation |
    Then the system should reject the event
    And return error "Event violates temporal consistency"
    And suggest valid timestamp range

  # ============================================
  # CONNECTION AND ERROR HANDLING
  # ============================================

  @infrastructure @connection @error
  Scenario: Handle database connection failure with retry
    Given the Neo4j database becomes unavailable
    When I attempt to perform a graph operation
    Then the system should implement retry logic:
      | retry_attempt | delay    | action                    |
      | 1             | 100ms    | Retry connection          |
      | 2             | 500ms    | Retry connection          |
      | 3             | 2000ms   | Retry connection          |
      | 4             | -        | Open circuit breaker      |
    And after circuit breaker opens:
      | action              | behavior                       |
      | reject_requests     | Fail fast for 30 seconds       |
      | return_cached       | Return cached data if available|
      | emit_alert          | Trigger monitoring alert       |
    And log the failure with diagnostic info

  @infrastructure @connection @error
  Scenario: Recover from connection failure
    Given the circuit breaker is open due to connection failure
    When the database becomes available again
    Then the system should:
      | action              | behavior                       |
      | half_open_test      | Allow one test request         |
      | verify_connection   | Confirm database is responsive |
      | close_circuit       | Resume normal operations       |
      | log_recovery        | Record recovery timestamp      |
    And pending operations should be retried

  @infrastructure @connection @error
  Scenario: Handle connection pool exhaustion
    Given all 20 connections in the pool are in use
    When a new graph operation is requested
    Then the system should:
      | action           | behavior                       |
      | queue_request    | Add to wait queue              |
      | set_timeout      | Wait maximum 30 seconds        |
      | emit_metric      | Record pool_exhausted metric   |
    And if timeout expires:
      | action           | behavior                       |
      | return_error     | Return PoolExhaustedException  |
      | log_details      | Record waiting requests count  |
      | suggest_scaling  | Recommend pool size increase   |

  @infrastructure @timeout @error
  Scenario: Handle query timeout with cleanup
    Given a complex graph traversal is running
    When the query exceeds 5 second timeout
    Then the system should:
      | action              | behavior                       |
      | terminate_query     | Cancel the running query       |
      | release_connection  | Return connection to pool      |
      | log_slow_query      | Record query for analysis      |
      | return_error        | Return QueryTimeoutException   |
    And the error should include:
      | field           | value                          |
      | query_summary   | Abbreviated query description  |
      | execution_time  | Time before termination        |
      | suggestion      | Add filters or reduce depth    |

  # ============================================
  # NODE OPERATION VALIDATION
  # ============================================

  @domain @entity_nodes @error
  Scenario Outline: Reject invalid entity node creation
    Given I am creating an entity node
    When I provide invalid data: <invalid_data>
    Then the system should reject the node creation
    And return error "<error_message>"
    And no node should be created in the database

    Examples:
      | invalid_data                      | error_message                                    |
      | missing entity_id                 | entity_id is required                            |
      | missing entity_type               | entity_type is required                          |
      | invalid entity_type "UNKNOWN"     | entity_type must be valid EntityType enum        |
      | missing world_id                  | world_id is required for multi-tenant isolation  |
      | embedding_vector wrong dimension  | embedding_vector must have 1536 dimensions       |
      | empty name                        | name cannot be empty                             |
      | name exceeds 500 characters       | name must not exceed 500 characters              |

  @domain @entity_nodes @duplicate
  Scenario: Reject duplicate entity by ID
    Given entity "Romeo" with id "char-001" exists in the graph
    When I attempt to create another entity with id "char-001"
    Then the system should reject the duplicate
    And return error "Entity with id char-001 already exists"
    And suggest:
      | option          | description                    |
      | use_update      | Update existing entity         |
      | generate_new_id | Create with new ID             |
      | check_existing  | Review existing entity first   |

  @domain @entity_nodes @deletion
  Scenario: Delete node with cascade option
    Given entity "Tybalt" has 5 relationships with other entities:
      | related_entity | relationship |
      | Romeo          | ENEMY_OF     |
      | Juliet         | COUSIN_OF    |
      | Capulet        | NEPHEW_OF    |
      | Mercutio       | KILLED       |
      | Benvolio       | FOUGHT       |
    When I delete "Tybalt" with cascade option
    Then the node should be deleted
    And all 5 relationships should be deleted
    And audit log should record:
      | deleted_entity | Tybalt                    |
      | deleted_relationships | 5                   |
      | cascade_option | true                      |
    And domain event EntityNodeDeleted should be published

  @domain @entity_nodes @deletion
  Scenario: Reject node deletion without cascade when relationships exist
    Given entity "Tybalt" has relationships
    When I attempt to delete "Tybalt" without cascade option
    Then the system should reject deletion
    And return error "Cannot delete entity with existing relationships"
    And provide options:
      | option    | description                     |
      | CASCADE   | Delete entity and relationships |
      | REVIEW    | Show existing relationships     |
      | CANCEL    | Abort deletion                  |

  # ============================================
  # RELATIONSHIP VALIDATION
  # ============================================

  @domain @relationship_edges @error
  Scenario: Reject relationship with non-existent source node
    Given entity "Juliet" exists in the graph
    But entity "Hamlet" does not exist
    When I create a relationship from "Hamlet" to "Juliet"
    Then the system should reject the relationship
    And return error "Source entity 'Hamlet' not found"
    And suggest creating the entity first

  @domain @relationship_edges @error
  Scenario: Reject relationship with non-existent target node
    Given entity "Romeo" exists in the graph
    But entity "Ophelia" does not exist
    When I create a relationship from "Romeo" to "Ophelia"
    Then the system should reject the relationship
    And return error "Target entity 'Ophelia' not found"

  @domain @relationship_edges @self_reference
  Scenario Outline: Handle self-referential relationships appropriately
    Given entity "Romeo" exists in the graph
    When I create a <relationship_type> relationship from "Romeo" to "Romeo"
    Then the result should be <result>
    And message should be "<message>"

    Examples:
      | relationship_type | result  | message                                    |
      | KNOWS             | reject  | Self-knowledge relationship is implicit    |
      | LOVES             | accept  | Self-referential relationship created      |
      | HATES             | accept  | Self-referential relationship created      |
      | PARENT_OF         | reject  | PARENT_OF cannot be self-referential       |
      | CHILD_OF          | reject  | CHILD_OF cannot be self-referential        |
      | SIBLING_OF        | reject  | SIBLING_OF cannot be self-referential      |
      | CREATED           | accept  | Self-creation relationship created         |

  @domain @relationship_edges @invalid_type
  Scenario: Reject invalid relationship type
    Given entities "Romeo" and "Juliet" exist
    When I create a relationship with type "INVALID_TYPE"
    Then the system should reject the relationship
    And return error "Invalid relationship type: INVALID_TYPE"
    And suggest valid relationship types grouped by category:
      | category     | types                                           |
      | emotional    | LOVES, HATES, FEARS, ADMIRES, TRUSTS, DISTRUSTS |
      | familial     | PARENT_OF, CHILD_OF, SIBLING_OF, SPOUSE_OF      |
      | social       | KNOWS, FRIEND_OF, ENEMY_OF, ALLY_OF, SERVES     |
      | possessive   | OWNS, CREATED, DESTROYED                        |
      | causal       | KILLED, SAVED, BETRAYED, HELPED                 |
      | spatial      | LOCATED_IN, MEMBER_OF, PART_OF                  |

  @domain @relationship_edges @weight_validation
  Scenario Outline: Validate relationship weight boundaries
    Given entities "Romeo" and "Juliet" exist
    When I create a LOVES relationship with weight <weight>
    Then the result should be <result>
    And message should be "<message>"

    Examples:
      | weight | result  | message                                     |
      | 0.0    | success | Relationship created with minimum weight    |
      | 1.0    | success | Relationship created with maximum weight    |
      | 0.5    | success | Relationship created                        |
      | -0.1   | error   | Weight must be between 0.0 and 1.0          |
      | 1.5    | error   | Weight must be between 0.0 and 1.0          |
      | null   | success | Relationship created with default weight 0.5|

  # ============================================
  # CAUSALITY VALIDATION
  # ============================================

  @domain @causality_graph @cycle_detection
  Scenario: Detect and reject causal cycles
    Given the following causality chain exists:
      | event_a | relationship | event_b |
      | A       | CAUSES       | B       |
      | B       | CAUSES       | C       |
      | C       | CAUSES       | D       |
    When I attempt to create causality "D CAUSES A"
    Then the system should reject the relationship
    And return error "Causal cycle detected: A -> B -> C -> D -> A"
    And visualize the cycle in the error response
    And suggest reviewing the causality chain

  @domain @causality_graph @temporal
  Scenario: Validate temporal consistency in causality
    Given event "Romeo_dies" occurred at timestamp "2024-01-15T12:00:00"
    And event "Romeo_speaks" occurred at timestamp "2024-01-15T14:00:00"
    When I create causality "Romeo_dies CAUSES Romeo_speaks"
    Then the system should reject with temporal violation
    And return error "Cannot create causality: effect occurs after cause but cause implies prevention"
    And suggest reviewing event timestamps

  @domain @causality_graph @temporal
  Scenario: Accept valid temporal causality
    Given event "Poison_consumed" occurred at timestamp "2024-01-15T11:00:00"
    And event "Romeo_dies" occurred at timestamp "2024-01-15T12:00:00"
    When I create causality "Poison_consumed CAUSES Romeo_dies"
    Then the causality should be created successfully
    And temporal consistency should be verified

  # ============================================
  # QUERY AND TRAVERSAL
  # ============================================

  @integration @context_retrieval @empty_result
  Scenario: Handle empty query results gracefully
    Given entity "NewCharacter" exists with no relationships
    When I query the graph for NewCharacter's context
    Then the system should return:
      """json
      {
        "entity": {"id": "new-char", "name": "NewCharacter"},
        "relationships": [],
        "sentiment_summary": {"overall_mood": "neutral", "note": "No relationships established"},
        "recent_events": [],
        "metadata": {"sparse_data": true, "recommendation": "Establish relationships for richer context"}
      }
      """
    And no exception should be thrown
    And the response should indicate sparse data

  @integration @context_retrieval @depth_limit
  Scenario: Enforce traversal depth limits
    Given a densely connected graph with 1000+ entities
    When I query relationships with depth parameter 10
    Then the system should:
      | action          | behavior                        |
      | cap_depth       | Limit traversal to depth 5      |
      | include_warning | Warn about truncated results    |
      | return_partial  | Return results up to depth 5    |
    And response metadata should include:
      | field               | value                        |
      | requested_depth     | 10                           |
      | actual_depth        | 5                            |
      | truncated           | true                         |
      | recommendation      | Use relationship type filters|

  @integration @context_retrieval @pagination
  Scenario: Paginate large relationship result sets
    Given entity "King" has 500 relationships
    When I query all relationships for "King" without pagination params
    Then the system should:
      | action           | behavior                      |
      | apply_default    | Return first 100 results      |
      | include_metadata | Provide pagination info       |
    And response should include:
      | field        | value                         |
      | total_count  | 500                           |
      | page         | 1                             |
      | page_size    | 100                           |
      | has_next     | true                          |
      | cursor       | pagination cursor string      |

  @integration @context_retrieval @pagination
  Scenario: Navigate paginated results with cursor
    Given "King" has 500 relationships and I have the first page
    When I request the next page using cursor
    Then I should receive relationships 101-200
    And the cursor should update for the next page
    And I should be able to continue until all results are retrieved

  @integration @vector_search @error
  Scenario: Handle vector similarity search with wrong dimensions
    Given I am searching for similar entities
    When I provide an embedding vector with 512 dimensions
    Then the system should reject the search
    And return error "Embedding vector must have 1536 dimensions, received 512"
    And suggest regenerating the embedding with correct model

  @integration @vector_search @threshold
  Scenario: Apply and validate similarity threshold
    Given entities with embeddings exist in the graph
    When I search with similarity threshold 0.8
    Then only entities with cosine similarity >= 0.8 should be returned
    And results should be ordered by similarity descending
    And each result should include:
      | field            | description                    |
      | entity_id        | The matching entity ID         |
      | similarity_score | The calculated similarity      |
      | distance         | Vector distance metric         |

  # ============================================
  # TRANSACTIONS AND CONSISTENCY
  # ============================================

  @domain @transaction @rollback
  Scenario: Rollback partial graph updates on failure
    Given I am performing a bulk update transaction with:
      | operation            | entity/relationship |
      | CREATE_NODE          | Entity_A            |
      | CREATE_NODE          | Entity_B            |
      | CREATE_RELATIONSHIP  | A KNOWS B           |
      | CREATE_NODE          | Entity_C (fails)    |
    When the fourth operation fails due to validation error
    Then all operations should be rolled back atomically
    And Entity_A, Entity_B should not exist in the graph
    And the A KNOWS B relationship should not exist
    And error response should indicate:
      | field              | value                         |
      | failed_operation   | CREATE_NODE Entity_C          |
      | rollback_count     | 3                             |
      | error_details      | Specific validation error     |

  @domain @transaction @success
  Scenario: Commit bulk transaction successfully
    Given I am performing a bulk update with 10 valid operations
    When all operations complete successfully
    Then all changes should be committed atomically
    And all 10 entities/relationships should be queryable
    And domain event BulkUpdateCompleted should be published

  @domain @concurrent @conflict
  Scenario: Handle concurrent modification with optimistic locking
    Given entity "Romeo" exists with version 5
    And user Alice loads Romeo for editing
    And user Bob loads Romeo for editing (same version 5)
    When Alice saves her changes first (version becomes 6)
    And Bob attempts to save his changes with version 5
    Then Bob's update should be rejected
    And error should indicate version conflict:
      | field           | value                         |
      | error_code      | OPTIMISTIC_LOCK_FAILURE       |
      | expected_version| 5                             |
      | actual_version  | 6                             |
      | modified_by     | Alice                         |
    And Bob should be offered resolution options:
      | option          | description                   |
      | reload          | Fetch latest version          |
      | merge           | Attempt automatic merge       |
      | force           | Overwrite (requires permission)|

  # ============================================
  # MULTI-TENANCY AND ISOLATION
  # ============================================

  @domain @multitenancy @isolation
  Scenario: Enforce strict world isolation in queries
    Given world "World_A" has entity "Romeo" with id "romeo-a"
    And world "World_B" has entity "Romeo" with id "romeo-b"
    When I query for entities named "Romeo" in World_A context
    Then only World_A's Romeo (romeo-a) should be returned
    And World_B's Romeo should never be accessible
    And the query should automatically filter by world_id

  @domain @multitenancy @isolation
  Scenario: Prevent cross-world relationship queries
    Given I have access to World_A only
    When I attempt to query relationships in World_B
    Then the system should reject the query
    And return error "Access denied: No permission for world World_B"

  @domain @multitenancy @error
  Scenario: Reject cross-world relationship creation
    Given entity "Romeo" belongs to World_A
    And entity "Hamlet" belongs to World_B
    When I attempt to create a relationship between them
    Then the system should reject the operation
    And return error "Cannot create relationship across world boundaries"
    And suggest:
      | option              | description                         |
      | create_entity       | Create Hamlet in World_A            |
      | use_reference       | Create external reference instead   |

  @domain @multitenancy @admin
  Scenario: Allow cross-world queries for admin operations
    Given I have admin permissions
    When I query for all entities named "Romeo" across worlds
    Then I should receive entities from all worlds:
      | entity_id | world_id |
      | romeo-a   | World_A  |
      | romeo-b   | World_B  |
      | romeo-c   | World_C  |
    And results should be clearly labeled by world

  # ============================================
  # PERFORMANCE AND MONITORING
  # ============================================

  @integration @performance @monitoring
  Scenario: Track and emit query performance metrics
    Given graph queries are being executed
    Then for each query the system should emit metrics:
      | metric_name           | type     | description                    |
      | graph.query.duration_ms| histogram| Query execution time           |
      | graph.query.nodes_traversed| counter | Nodes visited in query     |
      | graph.query.edges_scanned| counter | Relationships examined       |
      | graph.query.result_count| gauge   | Results returned              |
      | graph.cache.hit_ratio  | gauge    | Cache effectiveness           |
      | graph.pool.active      | gauge    | Active connections            |
      | graph.pool.waiting     | gauge    | Queued connection requests    |
    And queries exceeding 100ms should be logged as slow

  @integration @performance @slow_query
  Scenario: Analyze and report slow queries
    Given a query takes 250ms to execute
    Then the slow query should be logged with:
      | field            | value                          |
      | query_id         | Unique query identifier        |
      | duration_ms      | 250                            |
      | query_summary    | Human-readable query summary   |
      | nodes_traversed  | Count of nodes visited         |
      | query_plan       | Execution plan analysis        |
    And optimization suggestions should be included:
      | suggestion           | impact          |
      | add_index_on_type    | high            |
      | limit_traversal_depth| medium          |
      | add_relationship_filter| high          |

  @integration @index @validation
  Scenario: Warn about missing indexes in queries
    Given a query performs a full graph scan
    When the query plan is analyzed
    Then the system should:
      | action           | behavior                        |
      | detect_scan      | Identify full scan operation    |
      | log_warning      | Warn about potential performance issue |
      | suggest_index    | Recommend index based on query  |
      | track_pattern    | Record for optimization review  |
    And suggestion should include specific index creation query

  @integration @performance @caching
  Scenario: Cache frequently accessed entity contexts
    Given entity "Romeo" context is requested frequently
    When context has been requested 10 times in 1 minute
    Then the context should be cached:
      | cache_property   | value                          |
      | ttl              | 5 minutes                      |
      | invalidation     | On entity or relationship change|
      | cache_key        | world_id:entity_id:context_type|
    And subsequent requests should return cached data
    And cache hit should be recorded in metrics

  # ============================================
  # SCHEMA AND MIGRATION
  # ============================================

  @infrastructure @schema @migration
  Scenario: Handle schema evolution with backward compatibility
    Given the graph schema has added new required property "importance_score"
    When I query legacy nodes missing this property
    Then the system should:
      | action            | behavior                        |
      | apply_default     | Use default value 0.5           |
      | flag_for_migration| Mark node for batch update      |
      | return_data       | Include with default value      |
    And the query should not fail
    And migration job should be triggered asynchronously

  @infrastructure @schema @migration
  Scenario: Run batch migration for schema changes
    Given 10,000 legacy nodes need migration
    When batch migration job is executed
    Then the system should:
      | action            | behavior                        |
      | batch_process     | Process 1000 nodes at a time    |
      | track_progress    | Report percentage complete      |
      | handle_errors     | Log failures, continue batch    |
      | emit_metrics      | Report migration metrics        |
    And migration should complete without system downtime
    And failed nodes should be retried

  @infrastructure @schema @validation
  Scenario: Validate schema on startup
    Given the application is starting
    When connecting to Neo4j database
    Then the system should:
      | action            | behavior                        |
      | verify_indexes    | Check required indexes exist    |
      | verify_constraints| Check uniqueness constraints    |
      | verify_labels     | Check expected labels exist     |
      | create_missing    | Create missing schema elements  |
    And schema validation results should be logged
    And startup should fail if critical elements cannot be created

  # ============================================
  # BACKUP AND RECOVERY
  # ============================================

  @infrastructure @backup
  Scenario: Create graph database snapshot
    Given the graph contains 50,000 nodes and 200,000 relationships
    When I request a database snapshot
    Then the system should:
      | action            | behavior                        |
      | create_snapshot   | Generate consistent snapshot    |
      | store_safely      | Save to configured backup location|
      | record_metadata   | Log snapshot timestamp and size |
      | verify_integrity  | Validate snapshot completeness  |
    And the snapshot should be restorable
    And normal operations should continue during backup

  @infrastructure @recovery
  Scenario: Restore graph from snapshot
    Given a valid snapshot from 2024-02-15 exists
    When I restore the graph from this snapshot
    Then the system should:
      | action            | behavior                        |
      | verify_snapshot   | Validate snapshot integrity     |
      | stop_writes       | Pause write operations          |
      | restore_data      | Load snapshot data              |
      | verify_restoration| Confirm node and edge counts    |
      | resume_operations | Resume normal operations        |
    And all data from snapshot should be accessible
    And post-snapshot changes should be noted as lost

  # ============================================
  # DOMAIN EVENTS
  # ============================================

  @domain-events
  Scenario: EntityNodeCreated event structure
    Given I create a new entity in the graph
    When the entity is persisted
    Then EntityNodeCreated event should be published with:
      | field       | type     | description               |
      | event_id    | UUID     | Unique event identifier   |
      | entity_id   | string   | Created entity ID         |
      | entity_type | enum     | CHARACTER, LOCATION, etc. |
      | world_id    | string   | Parent world              |
      | canonical   | boolean  | Source material origin    |
      | created_by  | string   | User/system that created  |
      | timestamp   | datetime | Creation time             |

  @domain-events
  Scenario: RelationshipCreated event triggers context update
    Given a new relationship is created between entities
    When RelationshipCreated event is published
    Then the context service should:
      | action              | behavior                       |
      | invalidate_cache    | Clear cached context for both entities |
      | update_sentiment    | Recalculate sentiment summaries|
      | notify_subscribers  | Alert interested services      |

  @domain-events
  Scenario: CausalChainBroken event triggers narrative recalculation
    Given a causal event chain is broken by player action
    When CausalChainBroken event is published with:
      | field              | value                         |
      | broken_at_event    | Event that was prevented      |
      | downstream_events  | List of invalidated events    |
      | player_action      | Action that caused break      |
    Then the narrative engine should:
      | action              | behavior                       |
      | recalculate_futures | Generate new possible outcomes |
      | update_goals        | Adjust active character goals  |
      | notify_ai           | Update AI context              |

  @domain-events
  Scenario: EntityNodeUpdated event includes change details
    Given entity "Romeo" is updated
    When EntityNodeUpdated event is published
    Then the event should include:
      | field           | value                         |
      | entity_id       | romeo-123                     |
      | changed_fields  | [description, status]         |
      | previous_values | {description: "old", status: "alive"} |
      | new_values      | {description: "new", status: "deceased"} |
      | updated_by      | user-456                      |
      | version_before  | 5                             |
      | version_after   | 6                             |

  # ============================================
  # API ENDPOINTS
  # ============================================

  @api @entities
  Scenario: Create entity via API
    Given I have a valid API token with graph permissions
    When I send a POST request to "/api/v1/worlds/{worldId}/graph/entities" with:
      """json
      {
        "name": "Romeo Montague",
        "entity_type": "CHARACTER",
        "description": "Young heir to the Montague family",
        "canonical": true,
        "properties": {
          "age": 16,
          "family": "Montague"
        }
      }
      """
    Then the response status should be 201
    And the response should contain the created entity with ID
    And embedding should be generated asynchronously

  @api @entities
  Scenario: Query entities via API
    Given entities exist in the world
    When I send a GET request to "/api/v1/worlds/{worldId}/graph/entities?type=CHARACTER&limit=10"
    Then the response status should be 200
    And the response should contain up to 10 character entities
    And pagination metadata should be included

  @api @relationships
  Scenario: Create relationship via API
    Given entities exist in the graph
    When I send a POST request to "/api/v1/worlds/{worldId}/graph/relationships" with:
      """json
      {
        "source_entity_id": "romeo-123",
        "target_entity_id": "juliet-456",
        "relationship_type": "LOVES",
        "weight": 0.95,
        "bidirectional": true
      }
      """
    Then the response status should be 201
    And the response should contain the created relationship(s)

  @api @context
  Scenario: Get entity context via API
    Given entity "romeo-123" has relationships and events
    When I send a GET request to "/api/v1/worlds/{worldId}/graph/entities/romeo-123/context"
    Then the response status should be 200
    And the response should contain full AI context structure

  @api @search
  Scenario: Vector similarity search via API
    Given I have a query text to search
    When I send a POST request to "/api/v1/worlds/{worldId}/graph/search" with:
      """json
      {
        "query_text": "young lovers in conflict",
        "entity_types": ["CHARACTER"],
        "threshold": 0.75,
        "limit": 10
      }
      """
    Then the response status should be 200
    And the response should contain matching entities with similarity scores

  @api @error
  Scenario: Handle API validation errors
    When I send a POST request with invalid entity data
    Then the response status should be 400
    And the response should contain:
      """json
      {
        "error": "VALIDATION_ERROR",
        "message": "Invalid entity data",
        "details": [
          {"field": "entity_type", "error": "must be valid EntityType enum"}
        ]
      }
      """
