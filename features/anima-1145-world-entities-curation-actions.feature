@world-entities @curation @bulk-actions @MVP-FOUNDATION
Feature: World Entities Curation Actions
  As a world creator
  I want to perform bulk curation actions on entities at the world level
  So that I can efficiently manage entities across all documents

  Background:
    Given I am authenticated as a user with role "world_creator"
    And a world exists with id "curation-test-world"
    And the world contains multiple extracted entities
    And the world has documents with entities:
      | document_id | document_name        | entity_count |
      | doc-001     | Character Backstory  | 45           |
      | doc-002     | World Lore           | 78           |
      | doc-003     | Location Descriptions| 52           |
      | doc-004     | Magic System         | 34           |
      | doc-005     | Creature Bestiary    | 61           |

  # ==========================================
  # Bulk Approve Entities by Type
  # ==========================================

  @bulk-approve @entity-type
  Scenario: Bulk approve all entities of a specific type
    Given the world has pending entities of type "character" with count 25
    When I select entity type "character" for bulk approval
    And I execute bulk approve action
    Then all 25 character entities should be marked as "approved"
    And each entity should have approval timestamp recorded
    And each entity should have approver set to my user id
    And an audit log entry should be created for the bulk action

  @bulk-approve @entity-type @filtering
  Scenario: Bulk approve entities by type with confidence filter
    Given the world has pending entities of type "location" with varying confidence scores
    When I select entity type "location" for bulk approval
    And I set confidence threshold filter to "0.8"
    And I execute bulk approve action
    Then only location entities with confidence >= 0.8 should be approved
    And entities below threshold should remain pending
    And the response should include count of approved entities

  @bulk-approve @entity-type @multiple
  Scenario: Bulk approve multiple entity types simultaneously
    Given the world has pending entities of types:
      | type      | count |
      | character | 15    |
      | location  | 22    |
      | item      | 18    |
    When I select entity types "character,location,item" for bulk approval
    And I execute bulk approve action
    Then all 55 entities should be marked as "approved"
    And the response should include breakdown by entity type

  @bulk-approve @selective
  Scenario: Bulk approve selected entities from list
    Given I am viewing the entity list for world "curation-test-world"
    And I select entities with ids:
      | entity_id |
      | ent-001   |
      | ent-005   |
      | ent-012   |
      | ent-023   |
    When I execute bulk approve for selected entities
    Then the 4 selected entities should be marked as "approved"
    And unselected entities should remain unchanged

  @bulk-approve @document-scope
  Scenario: Bulk approve all entities from specific document
    Given document "doc-002" has 78 pending entities
    When I select document "doc-002" for entity approval
    And I execute bulk approve action
    Then all 78 entities from document "doc-002" should be approved
    And entities from other documents should remain unchanged

  @bulk-approve @undo
  Scenario: Undo bulk approve action within time window
    Given I have just bulk approved 30 entities
    And the undo window is 5 minutes
    When I request undo for the bulk approve action
    Then all 30 entities should be reverted to "pending" status
    And an audit log entry should record the undo action

  # ==========================================
  # Bulk Reject Entities with Reason
  # ==========================================

  @bulk-reject @reason
  Scenario: Bulk reject entities with standard reason
    Given the world has 15 entities flagged for review
    When I select all flagged entities
    And I execute bulk reject with reason "duplicate_entity"
    Then all 15 entities should be marked as "rejected"
    And each entity should have rejection reason "duplicate_entity"
    And each entity should have rejection timestamp recorded

  @bulk-reject @custom-reason
  Scenario: Bulk reject entities with custom reason
    Given the world has 8 entities selected for rejection
    When I execute bulk reject with custom reason "Does not fit world narrative style"
    Then all 8 entities should be marked as "rejected"
    And each entity should have the custom rejection reason stored
    And the custom reason should be searchable

  @bulk-reject @categorized-reasons
  Scenario: Bulk reject with categorized rejection reasons
    Given the system supports rejection reason categories:
      | category    | reasons                                          |
      | quality     | low_confidence, extraction_error, incomplete     |
      | relevance   | out_of_scope, duplicate, not_applicable          |
      | content     | inappropriate, contradictory, factually_wrong    |
    When I bulk reject 10 entities with category "quality" and reason "extraction_error"
    Then all 10 entities should have rejection category and reason recorded
    And the rejection should be filterable by category

  @bulk-reject @feedback
  Scenario: Bulk reject with feedback for ML improvement
    Given I have selected 12 incorrectly extracted entities
    When I execute bulk reject with reason "extraction_error"
    And I include ML feedback flag
    Then the rejection data should be queued for ML model retraining
    And the feedback payload should include entity context

  @bulk-reject @partial
  Scenario: Bulk reject with some entities already processed
    Given I have selected 20 entities for rejection
    And 5 of those entities are already approved
    When I execute bulk reject action
    Then 15 pending entities should be rejected
    And the 5 approved entities should remain unchanged
    And the response should indicate 5 entities were skipped

  @bulk-reject @cascade
  Scenario: Bulk reject with cascade to related entities
    Given entity "main-char-001" has 5 related entities
    When I reject entity "main-char-001" with cascade option enabled
    Then "main-char-001" should be marked as rejected
    And all 5 related entities should be flagged for review
    And relationships to the rejected entity should be marked inactive

  # ==========================================
  # Merge Duplicate Entities Across Documents
  # ==========================================

  @merge @duplicates
  Scenario: Identify and merge duplicate entities
    Given the world has potential duplicate entities:
      | entity_id | name           | type      | document    | confidence |
      | ent-101   | Lord Aldric    | character | doc-001     | 0.95       |
      | ent-205   | Lord Aldrik    | character | doc-002     | 0.88       |
      | ent-312   | Aldric the Old | character | doc-003     | 0.72       |
    When I select entities "ent-101,ent-205,ent-312" for merge
    And I designate "ent-101" as the primary entity
    And I execute merge action
    Then a single merged entity should exist with id "ent-101"
    And the merged entity should have combined attributes
    And references to "ent-205" and "ent-312" should redirect to "ent-101"
    And original entities should be marked as "merged"

  @merge @attribute-selection
  Scenario: Merge entities with attribute selection
    Given I am merging duplicate entities:
      | entity_id | name         | description                    | aliases           |
      | ent-a     | Dragon Peak  | A mountain with ancient caves  | The Spire         |
      | ent-b     | Dragon's Peak| Home of the fire dragons       | Flame Mountain    |
    When I configure merge settings:
      | attribute   | source  |
      | name        | ent-a   |
      | description | ent-b   |
      | aliases     | combine |
    And I execute merge action
    Then the merged entity should have:
      | attribute   | value                         |
      | name        | Dragon Peak                   |
      | description | Home of the fire dragons      |
      | aliases     | The Spire, Flame Mountain     |

  @merge @cross-document
  Scenario: Merge entities preserving cross-document references
    Given entity "ent-x" appears in documents "doc-001,doc-002"
    And entity "ent-y" appears in documents "doc-003,doc-004"
    And entities "ent-x" and "ent-y" are duplicates
    When I merge "ent-y" into "ent-x"
    Then "ent-x" should be referenced in all 4 documents
    And document-specific context should be preserved for each reference
    And the entity source should list all contributing documents

  @merge @auto-detection
  Scenario: Auto-detect duplicate entities for review
    Given the world has not been scanned for duplicates recently
    When I request duplicate entity detection
    Then the system should analyze all entities for similarity
    And potential duplicates should be grouped by similarity score
    And groups with similarity > 0.85 should be flagged for review
    And a duplicate detection report should be generated

  @merge @conflict-resolution
  Scenario: Handle merge conflicts with conflicting attributes
    Given I am merging entities with conflicting attributes:
      | entity_id | birth_year | death_year | allegiance |
      | ent-p     | 1450       | null       | Kingdom A  |
      | ent-q     | 1448       | 1520       | Kingdom B  |
    When I execute merge with conflict resolution mode "manual"
    Then a conflict resolution prompt should be displayed
    And I should be able to select values for each conflicting attribute
    And the merge should only complete after conflicts are resolved

  @merge @history
  Scenario: Track merge history for entity lineage
    Given entity "ent-merged" was created from merging 3 entities
    When I view merge history for "ent-merged"
    Then I should see the original entity ids
    And I should see the merge timestamp
    And I should see who performed the merge
    And I should be able to view original entity snapshots

  # ==========================================
  # Auto-Approve High Confidence Entities
  # ==========================================

  @auto-approve @confidence
  Scenario: Configure auto-approval threshold
    Given I am configuring world curation settings
    When I set auto-approval confidence threshold to 0.95
    And I enable auto-approval for entity types "character,location"
    And I save the configuration
    Then entities of specified types with confidence >= 0.95 should auto-approve
    And auto-approved entities should be marked with "auto_approved" flag

  @auto-approve @trigger
  Scenario: Trigger auto-approval on entity extraction
    Given auto-approval is configured with threshold 0.92
    When new entities are extracted from document "doc-new":
      | entity_id | name          | type      | confidence |
      | new-001   | Sir Galahad   | character | 0.97       |
      | new-002   | Dark Forest   | location  | 0.94       |
      | new-003   | Ancient Relic | item      | 0.89       |
    Then "new-001" and "new-002" should be auto-approved
    And "new-003" should remain pending for manual review
    And auto-approval events should be logged

  @auto-approve @entity-type-specific
  Scenario: Set different thresholds per entity type
    Given I configure type-specific auto-approval:
      | entity_type | threshold | enabled |
      | character   | 0.90      | true    |
      | location    | 0.85      | true    |
      | item        | 0.95      | true    |
      | event       | 0.98      | false   |
    When entities are extracted with varying confidence
    Then each entity type should be evaluated against its specific threshold
    And event entities should never auto-approve regardless of confidence

  @auto-approve @override
  Scenario: Manual override of auto-approved entity
    Given entity "auto-ent-001" was auto-approved with confidence 0.96
    When I manually change status to "rejected" with reason "incorrect_classification"
    Then the entity status should update to "rejected"
    And the auto-approval should be marked as overridden
    And override details should be logged for ML feedback

  @auto-approve @batch
  Scenario: Batch auto-approve existing pending entities
    Given the world has 150 pending entities
    And 45 entities meet auto-approval criteria
    When I run batch auto-approval process
    Then 45 entities should be auto-approved
    And 105 entities should remain pending
    And a summary report should be generated

  @auto-approve @exclusions
  Scenario: Configure auto-approval exclusions
    Given I configure auto-approval exclusions:
      | exclusion_type | value                    |
      | source_doc     | doc-untrusted            |
      | entity_pattern | *_PLACEHOLDER*           |
      | extractor      | experimental-v2          |
    When entities matching exclusion criteria are extracted
    Then those entities should not auto-approve regardless of confidence
    And excluded entities should be flagged for manual review

  # ==========================================
  # Set Entity Curation Rules
  # ==========================================

  @curation-rules @create
  Scenario: Create entity curation rule
    Given I am configuring curation rules for world "curation-test-world"
    When I create a curation rule:
      | name        | Auto-approve named characters              |
      | condition   | type = 'character' AND has_proper_name     |
      | action      | approve                                    |
      | priority    | 10                                         |
    Then the rule should be saved and active
    And the rule should be applied to new entity extractions

  @curation-rules @complex-conditions
  Scenario: Create rule with complex conditions
    Given I am creating an advanced curation rule
    When I define the rule with conditions:
      """
      (type = 'location' AND confidence >= 0.85)
      OR (type = 'character' AND source_document IN trusted_docs)
      AND NOT (name MATCHES '.*UNKNOWN.*')
      """
    And I set action to "approve"
    Then the rule should parse and validate successfully
    And the rule should apply to matching entities

  @curation-rules @priority
  Scenario: Apply curation rules by priority order
    Given multiple curation rules exist:
      | rule_id | name              | priority | action  |
      | rule-1  | Reject low conf   | 1        | reject  |
      | rule-2  | Approve trusted   | 10       | approve |
      | rule-3  | Flag for review   | 5        | flag    |
    When an entity matches both rule-1 and rule-2
    Then rule-2 should be applied due to higher priority
    And rule application should be logged

  @curation-rules @scheduled
  Scenario: Schedule curation rule execution
    Given I have a curation rule "nightly-cleanup"
    When I configure the rule to run on schedule "0 2 * * *"
    Then the rule should execute daily at 2 AM
    And execution results should be logged
    And I should receive notification of rule execution

  @curation-rules @test
  Scenario: Test curation rule before activation
    Given I have created a new curation rule
    When I run the rule in test mode against current entities
    Then I should see a preview of affected entities
    And no actual changes should be made
    And I should see counts of entities per action type

  @curation-rules @versioning
  Scenario: Version control for curation rules
    Given curation rule "quality-filter" exists with version 1
    When I modify the rule conditions
    And I save the changes
    Then a new version 2 should be created
    And I should be able to view version history
    And I should be able to rollback to version 1

  @curation-rules @import-export
  Scenario: Export and import curation rules
    Given world "world-a" has 5 curation rules
    When I export curation rules from "world-a"
    Then I should receive a rules configuration file
    When I import the rules file into "world-b"
    Then all 5 rules should be created in "world-b"
    And rules should be adapted to world-b context

  # ==========================================
  # Export Curated Entities for Game Import
  # ==========================================

  @export @game-import
  Scenario: Export curated entities in game-compatible format
    Given the world has 200 approved entities
    When I request entity export for game import
    And I select target format "game-engine-v2"
    Then an export file should be generated
    And the file should contain all approved entities
    And entity relationships should be preserved
    And the format should be compatible with game engine import

  @export @selective
  Scenario: Export selected entity types only
    Given the world has approved entities:
      | type      | count |
      | character | 50    |
      | location  | 35    |
      | item      | 45    |
      | event     | 30    |
    When I export only entity types "character,location"
    Then the export should contain 85 entities
    And items and events should be excluded

  @export @with-relationships
  Scenario: Export entities with relationship graph
    Given entities have defined relationships:
      | from_entity | relationship    | to_entity    |
      | char-001    | lives_in        | loc-001      |
      | char-001    | owns            | item-001     |
      | char-002    | allied_with     | char-001     |
    When I export entities with relationship inclusion
    Then the export should include entity data
    And the export should include relationship graph
    And relationships should reference entity export ids

  @export @format-options
  Scenario: Export with multiple format options
    Given I am configuring entity export
    When I select format options:
      | option            | value           |
      | format            | json            |
      | include_metadata  | true            |
      | flatten_hierarchy | false           |
      | encoding          | utf-8           |
      | compression       | gzip            |
    And I execute export
    Then the export should match specified format options
    And metadata should be included in output
    And file should be gzip compressed

  @export @incremental
  Scenario: Export incremental changes since last export
    Given last export was performed on "2024-01-15"
    And 25 entities have been added or modified since then
    When I request incremental export
    Then only the 25 changed entities should be exported
    And each entity should include change type (added/modified)
    And the export should include delta timestamp

  @export @validation
  Scenario: Validate export before download
    Given I have generated an entity export
    When the export validation runs
    Then entity references should be validated
    And relationship integrity should be checked
    And required fields should be verified
    And validation report should be generated

  # ==========================================
  # Review Entity Extraction Quality
  # ==========================================

  @quality-review @metrics
  Scenario: View entity extraction quality metrics
    Given the world has processed 500 entities
    When I access entity extraction quality dashboard
    Then I should see overall extraction accuracy
    And I should see confidence distribution chart
    And I should see entity type breakdown
    And I should see extraction trends over time

  @quality-review @by-document
  Scenario: Review extraction quality by document
    Given the world has 10 documents with extracted entities
    When I view quality metrics by document
    Then I should see per-document extraction scores
    And I should see documents ranked by quality
    And I should identify problematic documents

  @quality-review @by-type
  Scenario: Review extraction quality by entity type
    Given entities have been extracted across multiple types
    When I view quality metrics by entity type
    Then I should see accuracy per entity type
    And I should see which types have lowest quality
    And I should see recommendations for improvement

  @quality-review @comparison
  Scenario: Compare extraction quality across time periods
    Given extraction has occurred over multiple weeks
    When I compare quality between "2024-01-01" and "2024-01-31"
    Then I should see quality trend visualization
    And I should see improvement or degradation metrics
    And I should see contributing factors

  @quality-review @sampling
  Scenario: Generate quality review sample
    Given the world has 1000 entities
    When I request a quality review sample of 50 entities
    And I specify stratified sampling by entity type
    Then 50 entities should be selected for review
    And sample should be representative of type distribution
    And entities should be queued for manual verification

  @quality-review @feedback-loop
  Scenario: Submit quality feedback for ML improvement
    Given I have reviewed 100 entities for quality
    And I have annotated 15 entities as incorrect
    When I submit quality feedback
    Then feedback should be packaged for ML training
    And affected entity patterns should be identified
    And improvement recommendations should be generated

  # ==========================================
  # Batch Update Entity Attributes
  # ==========================================

  @batch-update @attributes
  Scenario: Batch update single attribute across entities
    Given 30 entities are selected for batch update
    When I set attribute "status" to "reviewed"
    And I execute batch update
    Then all 30 entities should have status "reviewed"
    And previous values should be logged for audit
    And update timestamp should be recorded

  @batch-update @multiple-attributes
  Scenario: Batch update multiple attributes
    Given 25 character entities are selected
    When I batch update attributes:
      | attribute    | value        |
      | verified     | true         |
      | reviewer     | user-123     |
      | review_date  | 2024-01-20   |
    And I execute batch update
    Then all 25 entities should have updated attributes
    And all changes should be atomic

  @batch-update @conditional
  Scenario: Batch update with conditions
    Given I want to update entities conditionally
    When I execute batch update:
      | condition                    | update                    |
      | confidence < 0.7             | needs_review = true       |
      | type = 'character'           | category = 'npc'          |
      | source = 'auto-extracted'    | verified = false          |
    Then entities matching each condition should be updated
    And non-matching entities should remain unchanged

  @batch-update @add-tags
  Scenario: Batch add tags to entities
    Given 40 location entities are selected
    When I batch add tags:
      | tag           |
      | outdoor       |
      | natural       |
      | explorable    |
    And I execute batch update
    Then all 40 entities should have the new tags
    And existing tags should be preserved

  @batch-update @remove-attribute
  Scenario: Batch remove attribute from entities
    Given 20 entities have attribute "deprecated_field"
    When I batch remove attribute "deprecated_field"
    Then the attribute should be removed from all 20 entities
    And removal should be logged for audit

  @batch-update @transform
  Scenario: Batch transform attribute values
    Given entities have name attribute with inconsistent casing
    When I batch transform "name" with function "title_case"
    Then all entity names should be in title case
    And original values should be preserved in history

  @batch-update @preview
  Scenario: Preview batch update before applying
    Given I have configured a batch update for 100 entities
    When I request batch update preview
    Then I should see sample of entities before/after
    And I should see total count of affected entities
    And I should be able to confirm or cancel update

  # ==========================================
  # Create Entity Curation Session
  # ==========================================

  @curation-session @create
  Scenario: Create new curation session
    Given I want to organize my curation work
    When I create a curation session:
      | name        | Character Review Session          |
      | description | Review all character entities     |
      | scope       | type = 'character'                |
      | assignee    | user-curator-01                   |
    Then a new curation session should be created
    And matching entities should be loaded into session
    And session should be saved as "in_progress"

  @curation-session @workflow
  Scenario: Progress through curation session workflow
    Given curation session "session-001" is active
    And session contains 50 entities to review
    When I review and decide on each entity:
      | decision | count |
      | approve  | 35    |
      | reject   | 10    |
      | skip     | 5     |
    Then session progress should show 90% complete
    And decisions should be staged but not applied

  @curation-session @save-progress
  Scenario: Save curation session progress
    Given I am in the middle of curation session
    And I have made decisions on 30 of 50 entities
    When I save session progress
    Then all 30 decisions should be preserved
    And I should be able to resume later
    And session state should include current position

  @curation-session @collaborative
  Scenario: Collaborative curation session
    Given curation session allows multiple curators
    When curator-a and curator-b are assigned to session
    Then entities should be distributed between curators
    And curators should not see same entities
    And decisions should be aggregated in session

  @curation-session @conflict
  Scenario: Handle conflicting decisions in collaborative session
    Given entity "ent-conflict" was reviewed by two curators
    And curator-a approved and curator-b rejected
    When session consolidation runs
    Then a conflict should be flagged
    And session owner should be notified
    And conflict should require resolution

  @curation-session @templates
  Scenario: Create curation session from template
    Given curation template "standard-review" exists
    When I create session from template "standard-review"
    Then session should inherit template settings
    And template rules should be pre-configured
    And workflow steps should match template

  @curation-session @deadline
  Scenario: Set curation session deadline
    Given curation session "urgent-review" is created
    When I set deadline to "2024-02-01"
    Then deadline should be recorded
    And reminder notifications should be scheduled
    And overdue sessions should be flagged

  # ==========================================
  # Apply Curation Session Decisions
  # ==========================================

  @apply-decisions @commit
  Scenario: Commit all session decisions
    Given curation session "session-complete" has all entities reviewed
    And session has decisions:
      | decision | count |
      | approve  | 80    |
      | reject   | 15    |
      | merge    | 5     |
    When I commit session decisions
    Then all 80 approved entities should be approved
    And all 15 rejected entities should be rejected
    And 5 merge operations should be executed
    And session should be marked as "completed"

  @apply-decisions @partial
  Scenario: Apply partial session decisions
    Given curation session has 100 decisions staged
    When I apply only decisions of type "approve"
    Then only approval decisions should be applied
    And rejections should remain staged
    And session should remain "in_progress"

  @apply-decisions @rollback
  Scenario: Rollback applied session decisions
    Given session "session-applied" was committed 1 hour ago
    When I request rollback of session decisions
    Then all entity states should revert to pre-session state
    And session should be marked as "rolled_back"
    And rollback should be logged for audit

  @apply-decisions @dry-run
  Scenario: Dry run session decision application
    Given session "session-ready" has decisions ready
    When I execute dry run of decision application
    Then no actual changes should be made
    And I should see preview of all changes
    And potential conflicts should be identified

  @apply-decisions @validation
  Scenario: Validate session decisions before applying
    Given session has 50 decisions staged
    When decision validation runs
    Then entity references should be verified
    And merge conflicts should be detected
    And validation report should be generated
    And invalid decisions should be flagged

  @apply-decisions @audit
  Scenario: Generate audit report for applied decisions
    Given session decisions have been applied
    When I request session audit report
    Then report should include all decisions
    And report should include decision timestamps
    And report should include curator information
    And report should be exportable

  @apply-decisions @notifications
  Scenario: Notify stakeholders of applied decisions
    Given session has notification settings configured
    When session decisions are applied
    Then configured stakeholders should receive notification
    And notification should include decision summary
    And notification should link to audit report

  # ==========================================
  # Curation Analytics and Reporting
  # ==========================================

  @analytics @curator-performance
  Scenario: View curator performance metrics
    Given multiple curators have completed sessions
    When I access curator performance dashboard
    Then I should see entities reviewed per curator
    And I should see average review time
    And I should see decision distribution
    And I should see agreement rate with other curators

  @analytics @curation-trends
  Scenario: Analyze curation trends over time
    Given curation has occurred over 3 months
    When I view curation trends report
    Then I should see approval rate trends
    And I should see rejection reason distribution
    And I should see entity volume trends
    And I should see quality improvement metrics

  @analytics @bottleneck
  Scenario: Identify curation bottlenecks
    Given there is a backlog of uncurated entities
    When I run bottleneck analysis
    Then I should see queue wait times
    And I should see entity types with longest wait
    And I should see curator availability gaps
    And I should see recommendations for improvement

  @analytics @export-report
  Scenario: Export curation analytics report
    Given I have configured a curation report
    When I export the report
    Then report should be generated in selected format
    And report should include all selected metrics
    And report should be downloadable

  # ==========================================
  # Error Handling and Edge Cases
  # ==========================================

  @error-handling @permission
  Scenario: Handle insufficient permissions for bulk actions
    Given I am authenticated as a user with role "viewer"
    When I attempt to bulk approve entities
    Then I should receive a permission denied error
    And no entities should be modified
    And the attempt should be logged

  @error-handling @concurrent
  Scenario: Handle concurrent modification conflict
    Given entity "ent-001" is being modified by another user
    When I attempt to approve "ent-001"
    Then I should receive a conflict error
    And I should see current entity state
    And I should be able to retry or skip

  @error-handling @partial-failure
  Scenario: Handle partial failure in bulk operation
    Given I am bulk approving 50 entities
    And entity "ent-025" has a validation error
    When bulk approval executes
    Then 49 entities should be approved
    And "ent-025" should remain unchanged
    And error details should be reported
    And I should be able to retry failed entity

  @error-handling @session-timeout
  Scenario: Handle curation session timeout
    Given curation session has been idle for 30 minutes
    When session timeout occurs
    Then current progress should be auto-saved
    And session should be marked as "paused"
    And I should be able to resume session

  @error-handling @merge-validation
  Scenario: Handle invalid merge operation
    Given I am attempting to merge entities of different types
    When I execute merge action
    Then I should receive a validation error
    And error should explain type mismatch
    And no entities should be modified

  @error-handling @circular-reference
  Scenario: Detect circular reference in merge
    Given entity "ent-a" references "ent-b"
    And entity "ent-b" references "ent-c"
    And entity "ent-c" references "ent-a"
    When I attempt to merge "ent-a" and "ent-c"
    Then circular reference should be detected
    And warning should be displayed
    And I should choose how to handle cycle

  @error-handling @large-batch
  Scenario: Handle very large batch operation
    Given I am attempting to bulk update 10000 entities
    When I execute the bulk operation
    Then operation should be processed in batches
    And progress should be reported incrementally
    And operation should complete without timeout
    And memory usage should remain bounded

  @error-handling @recovery
  Scenario: Recover from interrupted bulk operation
    Given bulk operation was interrupted at 60% completion
    When I access operation recovery
    Then I should see incomplete operation status
    And I should be able to resume from checkpoint
    And completed portion should not be repeated

  @edge-case @empty-selection
  Scenario: Handle bulk action on empty selection
    Given no entities are selected
    When I attempt bulk approve action
    Then I should receive a validation message
    And message should indicate no entities selected
    And no operation should be performed

  @edge-case @all-processed
  Scenario: Handle bulk action when all entities already processed
    Given all selected entities are already approved
    When I attempt bulk approve action
    Then I should receive informational message
    And message should indicate all already approved
    And entities should remain unchanged

  @edge-case @deleted-entity
  Scenario: Handle action on recently deleted entity
    Given entity "ent-deleted" was deleted by another user
    When my pending action references "ent-deleted"
    Then action should fail gracefully
    And error should explain entity no longer exists
    And my action queue should be updated
