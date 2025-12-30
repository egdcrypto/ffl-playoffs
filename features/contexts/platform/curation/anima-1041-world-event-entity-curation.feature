@ANIMA-1041
Feature: World Event Entity Curation
  As a world owner
  I want to curate extracted world events from my narrative
  So that I can control story moments in my playable world
Background:
    Given I am logged in as a world owner
    And I have uploaded a narrative source
    And the system has extracted event entities
    And event curation interface is active
EVENT REVIEW
  @unit @event_review
  Scenario: View event details
    Given the world has extracted events
    When I select an event for detailed review
    Then I should see: title, description, event_type, participants, location, trigger_conditions, outcomes, source_passages, extraction_confidence
    And I should see related events and characters
    And I should see the event's position in narrative timeline
@unit @event_review
  Scenario: Filter and search extracted events
    Given the world has 50+ extracted events
    When I filter by event_type, status, importance
    Then I should see only matching events
    And events sorted by narrative sequence
    And toggle between list and timeline views
EVENT APPROVAL
  @unit @event_approval
  Scenario: Approve a major story event
    Given event has status PENDING_REVIEW
    When I approve with: title, importance_level, playability, visibility, trigger_mode, outcome_variability
    Then status should be APPROVED
    And WorldEventApproved domain event published
    And event added to world timeline
    And audit log records approval
@unit @event_rejection
  Scenario: Reject a minor event
    Given event has status PENDING_REVIEW
    When I reject with: rejection_reason, notes, archive_flag
    Then status should be REJECTED
    And WorldEventRejected domain event published
    And event removed from curation queue
    And can be restored later if needed
@edge_case @event_approval
  Scenario: Approve event with missing required fields
    Given event has incomplete extraction data
    When I attempt to approve
    Then receive validation warnings for missing required fields
    And prompted to add missing information
    And can override warnings with curator justification
EVENT EDITING
  @unit @event_editing
  Scenario: Edit event participants and roles
    Given event is approved
    When I edit participants with role assignments
    Then participant list updated
    And roles validated against character capabilities
    And EventParticipantsUpdated domain event published
    And version history records change
@unit @event_editing
  Scenario: Update event consequences and outcomes
    Given event is approved
    When I define consequences: CHARACTER_DEATH, RELATIONSHIP_CHANGE, EMOTIONAL_STATE, FACTION_TENSION, TRIGGER_EVENT
    Then consequences linked to event
    And cascade effects calculated
    And affected entities notified
    And EventConsequencesUpdated domain event published
@unit @event_editing
  Scenario: Modify event timing and prerequisites
    Given event exists
    When I configure: sequence_position, estimated_duration, can_be_skipped, repeatable, time_of_day
    And set prerequisites: EVENT_COMPLETED, CHARACTER_PRESENT, WORLD_STATE
    Then timing saved
    And prerequisites validated for logical consistency
    And timeline recalculated
DUPLICATE DETECTION
  @integration @duplicate
  Scenario: Identify duplicate events
    Given extraction created similar events
    When I run duplicate detection
    Then system identifies potential duplicates with similarity scores
    And I can compare events side-by-side
    And similarity methodology is transparent
@integration @duplicate
  Scenario: Merge duplicate event entries
    Given duplicates identified
    When I merge keeping primary: keep_all_participants, combine_descriptions, preserve_source_refs, transfer_relationships
    Then merged event contains combined data
    And secondary event marked MERGED_INTO primary
    And all references redirect to primary
    And WorldEventsMerged domain event published
VALIDATION
  @integration @validation
  Scenario: Validate event prerequisites and dependencies
    Given complex event chain exists
    When I validate dependency chain
    Then verify: no circular_deps, no orphan_deps, sequence_logic correct, character_presence valid, location_reachable
    And receive validation report
    And issues flagged with severity levels
@integration @validation
  Scenario: Detect event timeline conflicts
    Given events positioned in timeline
    When I run conflict detection
    Then identify: CHARACTER_OVERLAP, SEQUENCE_VIOLATION, TIME_COMPRESSION, LOCATION_IMPOSSIBLE, STATE_CONTRADICTION
    And conflicts displayed on timeline visualization
    And suggested resolutions provided
@edge_case @validation
  Scenario: Handle circular event dependencies
    Given events configured with circular dependencies
    When system validates
    Then circular dependency error detected
    And cycle path displayed
    And prompted to break cycle
    And cannot save until resolved
EVENT TESTING
  @integration @testing
  Scenario: Test event trigger conditions
    Given event has triggers configured
    When I enter testing mode
    Then I can: simulate_conditions, test_partial_match, manual_trigger, condition_debug
    And see detailed test report
    And trigger issues highlighted
@integration @testing
  Scenario: Test player participation in events
    Given event configured for player interaction
    When I test participation options
    Then each choice leads to valid outcomes
    And dialogue options coherent
    And NPC reactions appropriate
    And no world state errors
@integration @testing
  Scenario: Test event consequences propagation
    Given event triggers multiple consequences
    When I simulate completion
    Then verify each consequence propagation
    And cascade timing verified
    And no infinite loops
    And world state consistent
CURATION WORKFLOW
  @unit @workflow
  Scenario: Complete event curation checklist
    Given I am reviewing an event
    When I work through checklist
    Then verify: title_accurate, participants_correct, location_set, timing_configured, triggers_defined, outcomes_specified, consequences_linked, tested
    And see completion percentage
    And incomplete items block final approval
@integration @workflow
  Scenario: Lock events for world deployment
    Given all events passed curation and testing
    When I lock with: version_tag, lock_level, allow_hotfixes, deployment_target
    Then all approved events locked
    And locked events cannot be edited without unlock permission
    And deployment manifest generated
    And WorldEventsLocked domain event published
ERROR HANDLING
  @error @curation
  Scenario: Handle event with no valid trigger conditions
    Given event approved but has no triggers
    When I attempt to finalize
    Then receive MISSING_TRIGGERS error
    And prompted to configure at least one trigger
    And cannot lock until triggers defined
@error @curation
  Scenario: Handle event referencing non-existent characters
    Given event references participant not in extracted entities
    When I validate
    Then receive MISSING_ENTITY warning
    And offered options: CREATE_CHARACTER, MAP_TO_EXISTING, REMOVE_PARTICIPANT
@error @curation
  Scenario: Handle conflicting event outcomes
    Given event A has outcome "character dies"
    And event B sequenced after requires "character alive"
    When I validate event chain
    Then receive STATE_CONTRADICTION conflict error
    And shown conflicting events
    And suggested resolutions: reorder_events, change_prerequisite, branch_timeline
EDGE CASES
  @edge_case @curation
  Scenario: Handle massive event import
    Given narrative with 500+ extracted events
    When I access curation interface
    Then system uses: pagination (batches of 50), lazy_loading, smart_filtering, bulk_operations
    And performance remains responsive
    And no timeout errors
@edge_case @curation
  Scenario: Recover from mid-curation session failure
    Given I am curating with unsaved changes
    When session unexpectedly terminates
    Then upon reconnection: draft_recovery, session_restore, change_summary, conflict_check
    And can continue from where I left off
@integration @collaboration
  Scenario: Handle concurrent event editing
    Given curator A is editing event
    And curator B attempts to edit same event
    When both try to save
    Then system provides: lock_warning, optimistic_lock, merge_changes, conflict_resolution
    And neither curator's work lost
    And all changes tracked in version history
BULK OPERATIONS
  @unit @bulk
  Scenario: Bulk approve events by category
    Given filtered events by type and status
    When I select all and apply bulk approval with settings
    Then all matching events approved
    And multiple WorldEventApproved domain events published
    And audit log records bulk operation
@unit @bulk
  Scenario: Bulk update event timing for sequence
    Given I have selected events in a sequence
    When I apply bulk timing update
    Then all selected events have updated timing
    And sequence order preserved
    And bulk update audit entry created
API CONTRACT
  @api @contract
  Scenario: Event curation API returns correct format
    Given event curation request via API
    When request processed
    Then response includes: event_id, status, validation_result, audit_trail
@api @validation
  Scenario: API validates curation requests
    Given curation request received
    Then validate: event_exists, user_authorized, required_fields_present, no_conflicts