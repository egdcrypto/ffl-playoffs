@system @entity-enhancement @mvp-foundation
Feature: Entity Description Enhancement Tracking
  As a system
  I want to track when entity descriptions have been enhanced
  So that I know which documents have undergone context-aware processing

  Background:
    Given I am authenticated as a valid user
    And I have an active world

  # =============================================================================
  # ENHANCEMENT TRACKING COMPLETION
  # =============================================================================

  @tracking @completion
  Scenario: Track entity description enhancement completion
    Given a document has completed entity extraction
    And the document has extracted entities:
      | Entity Type | Name          | Status     |
      | Character   | Romeo         | Extracted  |
      | Character   | Juliet        | Extracted  |
      | Location    | Verona        | Extracted  |
    When the system enhances entity descriptions with context
    Then the enhancement status should be updated to "COMPLETED"
    And each entity should have enhancement metadata:
      | Field                | Value                            |
      | enhancement_status   | ENHANCED                         |
      | enhanced_at          | Current timestamp                |
      | enhancement_method   | Context-aware processing         |
      | context_sources      | List of source passages          |
    And the document processing state should reflect enhancement completion

  @tracking @partial
  Scenario: Track partial enhancement completion
    Given a document has 10 extracted entities
    And enhancement processing encounters an issue at entity 7
    When the system tracks enhancement progress
    Then the enhancement status should be "PARTIAL"
    And the tracking record should show:
      | Metric               | Value                            |
      | Total entities       | 10                               |
      | Enhanced entities    | 6                                |
      | Failed entities      | 1                                |
      | Pending entities     | 3                                |
    And failed entities should be flagged for retry

  @tracking @timestamp
  Scenario: Record enhancement timestamps accurately
    Given a document is undergoing enhancement processing
    When enhancement begins at a specific time
    And enhancement completes after processing
    Then the tracking record should include:
      | Timestamp Field      | Description                      |
      | started_at           | When enhancement began           |
      | completed_at         | When enhancement finished        |
      | duration_ms          | Total processing time            |
      | last_updated_at      | Most recent status update        |

  @tracking @metadata
  Scenario: Capture enhancement metadata
    Given entity "Romeo" is being enhanced
    When the enhancement process completes
    Then the entity should have enhancement metadata:
      | Metadata Field       | Description                      |
      | original_description | Description before enhancement   |
      | enhanced_description | Description after enhancement    |
      | enhancement_delta    | What was added/changed           |
      | confidence_score     | Enhancement quality score        |
      | source_passages      | Text used for enhancement        |
      | enhancement_version  | Version of enhancement algorithm |

  # =============================================================================
  # INVALID STATE HANDLING
  # =============================================================================

  @validation @invalid-state
  Scenario: Skip enhancement tracking for invalid document state
    Given a document is in "PENDING_UPLOAD" state
    When the system attempts to track enhancement
    Then enhancement tracking should be skipped
    And the system should log "Cannot track enhancement for document in PENDING_UPLOAD state"
    And the document state should remain unchanged

  @validation @no-entities
  Scenario: Skip enhancement for documents without entities
    Given a document has completed processing
    But no entities were extracted
    When the system attempts enhancement tracking
    Then enhancement should be skipped
    And the tracking record should show:
      | Field                | Value                            |
      | status               | SKIPPED                          |
      | reason               | No entities to enhance           |
      | document_id          | Document identifier              |

  @validation @already-enhanced
  Scenario: Handle already enhanced entities
    Given entity "Romeo" has already been enhanced
    When the system attempts to enhance the entity again
    Then the system should check existing enhancement status
    And if enhancement is current, the entity should be skipped
    And if enhancement is outdated, re-enhancement should proceed
    And the tracking should reflect the decision made

  @validation @extraction-incomplete
  Scenario: Block enhancement for incomplete extraction
    Given a document has extraction status "IN_PROGRESS"
    When the system attempts to begin enhancement
    Then enhancement should be blocked
    And an error should be logged:
      | Field                | Value                            |
      | error_type           | PREREQUISITE_NOT_MET             |
      | message              | Entity extraction must complete  |
      | document_state       | Current document state           |

  # =============================================================================
  # COMPLETED ENTITY EXTRACTION
  # =============================================================================

  @extraction @completed
  Scenario: Track enhancement for completed entity extraction
    Given a document has extraction status "COMPLETED"
    And the following entities were extracted:
      | Entity ID   | Type        | Name          | Extraction Confidence |
      | ent-001     | Character   | Romeo         | 0.95                  |
      | ent-002     | Character   | Juliet        | 0.92                  |
      | ent-003     | Location    | Verona        | 0.88                  |
      | ent-004     | Object      | Poison        | 0.75                  |
    When the system begins enhancement tracking
    Then each entity should be queued for enhancement
    And the tracking should show:
      | Field                | Value                            |
      | total_entities       | 4                                |
      | queued_for_enhancement| 4                               |
      | document_status      | ENHANCEMENT_IN_PROGRESS          |

  @extraction @prioritization
  Scenario: Prioritize entities for enhancement
    Given a document has multiple extracted entities
    When the system queues entities for enhancement
    Then entities should be prioritized by:
      | Priority Factor      | Weight                           |
      | Entity type          | Characters highest priority      |
      | Extraction confidence| Higher confidence first          |
      | Narrative importance | More appearances higher          |
      | Relationship count   | More connections higher          |
    And the enhancement queue should reflect priorities

  @extraction @dependency
  Scenario: Handle entity enhancement dependencies
    Given entity "Romeo" has relationships with "Juliet"
    When enhancing entity descriptions
    Then the system should consider related entities
    And enhancement should capture relationship context
    And dependent entities should be flagged for re-enhancement if needed

  # =============================================================================
  # ENHANCEMENT METHODS
  # =============================================================================

  @methods @context-aware
  Scenario: Enhancement tracking with context-aware method
    Given entity "Romeo" requires enhancement
    When using the "CONTEXT_AWARE" enhancement method
    Then the enhancement should:
      | Step                 | Description                      |
      | Gather context       | Collect all entity mentions      |
      | Analyze passages     | Extract descriptive information  |
      | Synthesize           | Combine into coherent description|
      | Validate             | Check for consistency            |
    And the tracking should record method "CONTEXT_AWARE"
    And context sources should be preserved

  @methods @ai-enhanced
  Scenario: Enhancement tracking with AI-enhanced method
    Given entity "Juliet" requires enhancement
    When using the "AI_ENHANCED" enhancement method
    Then the enhancement should:
      | Step                 | Description                      |
      | Prepare prompt       | Generate enhancement prompt      |
      | AI processing        | Send to AI model                 |
      | Parse response       | Extract enhanced description     |
      | Quality check        | Validate AI output               |
    And the tracking should record:
      | Field                | Value                            |
      | method               | AI_ENHANCED                      |
      | model_used           | AI model identifier              |
      | prompt_version       | Prompt template version          |
      | token_count          | Tokens used                      |

  @methods @manual
  Scenario: Enhancement tracking with manual method
    Given entity "Verona" requires enhancement
    When using the "MANUAL" enhancement method
    Then the enhancement should be marked for human review
    And the tracking should record:
      | Field                | Value                            |
      | method               | MANUAL                           |
      | status               | PENDING_REVIEW                   |
      | assigned_to          | Reviewer identifier              |
      | deadline             | Review deadline                  |

  @methods @hybrid
  Scenario: Enhancement tracking with hybrid method
    Given entity "Mercutio" requires enhancement
    When using the "HYBRID" enhancement method
    Then the enhancement should:
      | Step                 | Description                      |
      | Auto-enhance         | AI generates initial enhancement |
      | Flag for review      | Mark for human validation        |
      | Track both stages    | Record auto and manual steps     |
    And the tracking should capture both enhancement stages

  # =============================================================================
  # STATUS MANAGEMENT
  # =============================================================================

  @status @transitions
  Scenario: Track enhancement status transitions
    Given an entity is being enhanced
    Then valid status transitions should be:
      | From Status          | To Status          | Trigger              |
      | PENDING              | IN_PROGRESS        | Enhancement started  |
      | IN_PROGRESS          | COMPLETED          | Enhancement finished |
      | IN_PROGRESS          | FAILED             | Enhancement error    |
      | FAILED               | IN_PROGRESS        | Retry initiated      |
      | COMPLETED            | OUTDATED           | Source updated       |
      | OUTDATED             | IN_PROGRESS        | Re-enhancement       |
    And each transition should be logged with timestamp

  @status @document-level
  Scenario: Track document-level enhancement status
    Given a document has multiple entities
    When tracking enhancement at document level
    Then the document status should reflect:
      | Entity Status        | Document Status                  |
      | All PENDING          | ENHANCEMENT_PENDING              |
      | Any IN_PROGRESS      | ENHANCEMENT_IN_PROGRESS          |
      | All COMPLETED        | ENHANCEMENT_COMPLETED            |
      | Any FAILED           | ENHANCEMENT_PARTIAL              |
    And I should be able to query documents by enhancement status

  @status @aggregation
  Scenario: Aggregate enhancement statistics
    Given multiple documents have been enhanced
    When I query enhancement statistics
    Then I should see aggregated metrics:
      | Metric               | Description                      |
      | total_documents      | Total documents processed        |
      | enhanced_documents   | Fully enhanced documents         |
      | partial_documents    | Partially enhanced documents     |
      | pending_documents    | Awaiting enhancement             |
      | total_entities       | Total entities across documents  |
      | enhanced_entities    | Successfully enhanced entities   |
      | avg_enhancement_time | Average processing time          |

  # =============================================================================
  # QUERY AND REPORTING
  # =============================================================================

  @query @by-status
  Scenario: Query entities by enhancement status
    Given multiple entities exist with various enhancement states
    When I query entities by enhancement status "COMPLETED"
    Then I should receive all enhanced entities
    And each result should include:
      | Field                | Description                      |
      | entity_id            | Entity identifier                |
      | entity_type          | Type of entity                   |
      | entity_name          | Entity name                      |
      | enhancement_status   | Current status                   |
      | enhanced_at          | Enhancement timestamp            |
      | enhancement_method   | Method used                      |

  @query @by-document
  Scenario: Query enhancement status by document
    Given document "doc-123" has undergone enhancement
    When I query enhancement status for the document
    Then I should receive:
      | Field                | Value                            |
      | document_id          | doc-123                          |
      | document_status      | Enhancement status               |
      | entity_summary       | Count by entity status           |
      | last_enhanced_at     | Most recent enhancement          |
      | enhancement_history  | List of enhancement events       |

  @query @by-world
  Scenario: Query enhancement status by world
    Given a world contains multiple documents
    When I query enhancement status for the world
    Then I should receive world-level statistics:
      | Metric               | Description                      |
      | total_documents      | Documents in world               |
      | enhancement_coverage | Percentage enhanced              |
      | entity_statistics    | Enhancement by entity type       |
      | pending_work         | Entities awaiting enhancement    |

  @reporting @history
  Scenario: Generate enhancement history report
    Given enhancement tracking has been running
    When I generate an enhancement history report
    Then the report should include:
      | Section              | Content                          |
      | Summary              | Overall enhancement statistics   |
      | Timeline             | Enhancement events over time     |
      | By method            | Breakdown by enhancement method  |
      | By entity type       | Breakdown by entity type         |
      | Performance          | Processing time metrics          |
      | Errors               | Failed enhancements and reasons  |

  # =============================================================================
  # RETRY AND RECOVERY
  # =============================================================================

  @retry @failed
  Scenario: Retry failed entity enhancement
    Given entity "ent-001" has enhancement status "FAILED"
    When I initiate a retry for the failed enhancement
    Then the entity status should change to "IN_PROGRESS"
    And the retry attempt should be tracked:
      | Field                | Value                            |
      | retry_count          | Incremented count                |
      | retry_reason         | Manual or automatic              |
      | original_failure     | Reference to original failure    |

  @retry @automatic
  Scenario: Configure automatic retry for transient failures
    Given enhancement is configured with automatic retry
    When an enhancement fails with a transient error
    Then the system should automatically retry
    And retry should follow configured policy:
      | Policy Field         | Value                            |
      | max_retries          | Maximum retry attempts           |
      | retry_delay          | Delay between retries            |
      | backoff_multiplier   | Exponential backoff factor       |
    And final failure should be recorded after max retries

  @recovery @batch
  Scenario: Batch recovery of failed enhancements
    Given multiple entities have failed enhancement
    When I initiate batch recovery
    Then all failed entities should be queued for retry
    And batch recovery should be tracked:
      | Field                | Value                            |
      | batch_id             | Unique batch identifier          |
      | total_entities       | Count of entities in batch       |
      | recovery_status      | In progress/completed            |
      | success_count        | Successfully recovered           |
      | failure_count        | Still failing                    |

  # =============================================================================
  # VERSIONING
  # =============================================================================

  @versioning @tracking
  Scenario: Track enhancement versions
    Given entity "Romeo" has been enhanced multiple times
    When I query enhancement history
    Then I should see all enhancement versions:
      | Version | Enhanced At  | Method        | Status     |
      | 1       | 2024-01-10   | CONTEXT_AWARE | OUTDATED   |
      | 2       | 2024-01-15   | AI_ENHANCED   | OUTDATED   |
      | 3       | 2024-01-20   | HYBRID        | CURRENT    |
    And I should be able to compare versions

  @versioning @rollback
  Scenario: Rollback to previous enhancement version
    Given entity "Juliet" has enhancement version 3 as current
    When I rollback to version 2
    Then version 2 should become current
    And version 3 should be marked as "ROLLED_BACK"
    And the rollback should be tracked in history

  # =============================================================================
  # EVENTS AND NOTIFICATIONS
  # =============================================================================

  @events @emission
  Scenario: Emit events for enhancement tracking
    Given enhancement tracking is active
    Then the following events should be emitted:
      | Event Type                        | Trigger                    |
      | EntityEnhancementStartedEvent     | Enhancement begins         |
      | EntityEnhancementCompletedEvent   | Enhancement succeeds       |
      | EntityEnhancementFailedEvent      | Enhancement fails          |
      | DocumentEnhancementCompletedEvent | All entities enhanced      |
      | EnhancementRetryInitiatedEvent    | Retry started              |
      | EnhancementVersionCreatedEvent    | New version created        |
    And events should include relevant metadata

  @notifications @alerts
  Scenario: Configure enhancement tracking alerts
    When I configure enhancement alerts
    Then I should be able to set alerts for:
      | Alert Type           | Trigger                          |
      | Failure threshold    | Too many failures                |
      | Completion           | Enhancement batch complete       |
      | Long running         | Enhancement taking too long      |
      | Quality issues       | Low confidence enhancements      |

  # =============================================================================
  # ERROR CASES
  # =============================================================================

  @error @invalid-entity
  Scenario: Handle invalid entity for enhancement
    Given an entity ID that does not exist
    When the system attempts to track enhancement
    Then an error should be recorded:
      | Field                | Value                            |
      | error_type           | ENTITY_NOT_FOUND                 |
      | entity_id            | Invalid entity ID                |
      | message              | Entity not found for enhancement |

  @error @processing-failure
  Scenario: Handle enhancement processing failure
    Given entity enhancement is in progress
    When a processing error occurs
    Then the enhancement should be marked as "FAILED"
    And the error details should be captured:
      | Field                | Value                            |
      | error_type           | PROCESSING_ERROR                 |
      | error_message        | Specific error description       |
      | stack_trace          | Technical details                |
      | recoverable          | Whether retry is possible        |

  @error @timeout
  Scenario: Handle enhancement timeout
    Given enhancement has a configured timeout
    When enhancement exceeds the timeout
    Then the enhancement should be marked as "TIMED_OUT"
    And the entity should be queued for retry
    And timeout event should be logged

  @error @concurrent-modification
  Scenario: Handle concurrent enhancement attempts
    Given entity "Romeo" is being enhanced
    When another enhancement request arrives for the same entity
    Then the second request should be rejected
    And the system should return:
      | Field                | Value                            |
      | error_type           | CONCURRENT_MODIFICATION          |
      | message              | Entity enhancement in progress   |
      | current_status       | IN_PROGRESS                      |
