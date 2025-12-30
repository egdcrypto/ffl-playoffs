@ANIMA-1043
Feature: Location Entity Curation
  As a world owner
  I want to curate extracted locations from my narrative
  So that I can ensure locations are properly configured for my playable world
Background:
    Given I am logged in as a world owner
    And I have uploaded a narrative source
    And the system has extracted location entities
    And location curation interface is active
LOCATION REVIEW
  @unit @location_review
  Scenario: View location details
    Given the world has extracted locations
    When I select a location for detailed review
    Then I should see: name, description, location_type, parent_location, sub_locations, accessibility, atmosphere, source_passages, extraction_confidence
    And I should see connected characters and events
    And I should see the location on a narrative map
@unit @location_review
  Scenario: Filter and search extracted locations
    Given the world has 30+ extracted locations
    When I filter by location_type, status, accessibility
    Then I should see only matching locations
    And locations sorted by narrative importance
    And toggle between list, grid, and map views
LOCATION APPROVAL
  @unit @location_approval
  Scenario: Approve a location
    Given location has status PENDING_REVIEW
    When I approve with: name, importance_level, explorable, visibility, spawn_point, fast_travel_enabled
    Then status should be APPROVED
    And LocationEntityApproved domain event published
    And location added to world map
    And audit log records approval
@unit @location_rejection
  Scenario: Reject a location
    Given location has status PENDING_REVIEW
    When I reject with: rejection_reason, notes, merge_suggestion
    Then status should be REJECTED
    And LocationEntityRejected domain event published
    And location removed from curation queue
    And can be restored later if needed
@edge_case @location_approval
  Scenario: Approve location with missing sub-locations
    Given location has incomplete extraction data
    When I attempt to approve
    Then receive validation warnings for missing required fields
    And prompted to add accessibility information
    And can override warnings with curator justification
LOCATION EDITING
  @unit @location_editing
  Scenario: Edit location description and attributes
    Given location is approved
    When I edit: description, size, lighting, ambient_sounds, notable_features
    Then attributes updated
    And LocationEntityUpdated domain event published
    And version history records change
@unit @location_editing
  Scenario: Update location accessibility
    Given location is approved
    When I configure: default_access, access_requirements, guard_presence, entry_points, sneak_difficulty, time_restrictions
    And define access rules: FACTION_MEMBER, EVENT_CONDITION, RELATIONSHIP
    Then accessibility updated
    And access rules validated for consistency
    And LocationAccessibilityUpdated domain event published
@unit @location_editing
  Scenario: Modify location atmosphere and mood
    Given location is approved
    When I configure: primary_mood, secondary_moods, lighting_level, lighting_sources, ambient_sounds, temperature, air_quality, time_of_day_effects
    And define mood triggers
    Then atmosphere updated
    And NPCs react appropriately to atmosphere
    And LocationAtmosphereUpdated domain event published
DUPLICATE DETECTION
  @integration @duplicate
  Scenario: Identify duplicate locations
    Given extraction created similar locations
    When I run duplicate detection
    Then system identifies duplicates with similarity scores
    And I can compare locations side-by-side
    And similarity methodology is transparent
@integration @duplicate
  Scenario: Merge duplicate location entries
    Given duplicates identified
    When I merge keeping primary: keep_all_features, combine_descriptions, preserve_source_refs, transfer_connections
    Then merged location contains combined data
    And secondary location marked MERGED_INTO primary
    And all references redirect to primary
    And LocationEntitiesMerged domain event published
VALIDATION
  @integration @validation
  Scenario: Validate location completeness
    Given location is being curated
    When I run completeness validation
    Then check: name, description, location_type, parent_location, accessibility, atmosphere, interaction_points, connected_events
    And receive completeness score percentage
    And incomplete fields highlighted with suggestions
@integration @validation
  Scenario: Detect location conflicts
    Given locations have been configured
    When I run conflict detection
    Then identify: HIERARCHY_LOOP, ORPHAN_SUBLOCATION, ACCESSIBILITY_PARADOX, SIZE_INCONSISTENCY, DUPLICATE_SUBLOCATION
    And conflicts displayed with suggested resolutions
@integration @validation
  Scenario: Validate location accessibility paths
    Given locations have entry points and connections
    When I validate accessibility paths
    Then verify: entry_reachability, exit_availability, path_consistency, dead_ends, secret_paths
    And unreachable locations flagged
    And path visualization generated
LOCATION TESTING
  @integration @testing
  Scenario: Test location atmosphere and descriptions
    Given location has atmosphere configured
    When I enter testing mode
    Then I can: view_description, test_lighting, hear_ambience, feel_atmosphere, check_consistency
    And see detailed test report
    And atmosphere issues highlighted
@integration @testing
  Scenario: Test location access restrictions
    Given location has access rules configured
    When I test access scenarios for various characters and conditions
    Then each access scenario resolves correctly
    And guard responses appropriate
    And no access logic errors
@integration @testing
  Scenario: Test location interaction points
    Given location has interaction points
    When I test interactions: LEAN_ON, EXAMINE, CLIMB, KNOCK
    Then each interaction functions correctly
    And interactions contextually appropriate
    And no broken interactions
@integration @testing
  Scenario: Test conversation privacy distances
    Given location is a public space
    When I configure privacy zones: WHISPER, NORMAL, LOUD, SHOUT
    And test privacy distances
    Then NPCs outside privacy zones should not react to whispered conversations
    And NPCs within range can overhear and react
    And eavesdropping mechanics work correctly
@integration @testing
  Scenario: Test volume levels
    Given characters are in location
    When I test volume: WHISPER, SOFT, NORMAL, RAISED, SHOUT
    Then volume affects gameplay appropriately
    And stealth respects volume levels
    And sound propagation realistic for location type
CURATION WORKFLOW
  @unit @workflow
  Scenario: Complete location curation checklist
    Given I am reviewing a location
    When I work through checklist
    Then verify: name_appropriate, description_rich, type_classified, hierarchy_set, accessibility_config, atmosphere_defined, interaction_points, events_linked, characters_associated, tested
    And see completion percentage
    And incomplete items block final approval
@integration @workflow
  Scenario: Lock location for world deployment
    Given all locations passed curation and testing
    When I lock with: version_tag, lock_level, allow_hotfixes, deployment_target
    Then all approved locations locked
    And locked locations cannot be edited without unlock permission
    And deployment manifest generated
    And LocationsLocked domain event published
ERROR HANDLING
  @error @curation
  Scenario: Handle location with no entry points
    Given location approved but has no entry points
    When I attempt to finalize
    Then receive MISSING_ENTRY_POINTS error
    And prompted to configure entry points
    And cannot lock until entry points defined
@error @curation
  Scenario: Handle location referencing non-existent parent
    Given location references parent not in extracted entities
    When I validate
    Then receive MISSING_PARENT warning
    And offered options: CREATE_PARENT, MAP_TO_EXISTING, MAKE_ROOT
@error @curation
  Scenario: Handle conflicting sub-location assignments
    Given sub-location assigned to multiple parents
    When I validate hierarchy
    Then receive DUPLICATE_SUBLOCATION conflict error
    And shown conflicting assignments
    And must resolve by choosing one parent
EDGE CASES
  @edge_case @curation
  Scenario: Handle massive location import
    Given narrative with 200+ extracted locations
    When I access curation interface
    Then system uses: pagination, lazy_loading, smart_filtering, bulk_operations, map_visualization
    And performance remains responsive
    And no timeout errors
@edge_case @curation
  Scenario: Recover from mid-curation session failure
    Given I am curating with unsaved changes
    When session unexpectedly terminates
    Then upon reconnection: draft_recovery, session_restore, change_summary, conflict_check
    And can continue from where I left off
@integration @collaboration
  Scenario: Handle concurrent location editing
    Given curator A is editing location
    And curator B attempts to edit same location
    When both try to save
    Then system provides: lock_warning, optimistic_lock, merge_changes, conflict_resolution
    And neither curator's work lost
    And all changes tracked in version history
SPATIAL CONFIGURATION
  @unit @spatial
  Scenario: Configure location spatial dimensions
    Given location is approved
    When I configure: shape, approximate_area, capacity, height_variation, boundaries, sightlines
    Then spatial configuration saved
    And navigation mesh generated
    And capacity limits enforced during simulation
@unit @spatial
  Scenario: Configure location connections and travel
    Given locations exist in the world
    When I configure connections: connected_location, connection_type, travel_time, restrictions
    Then connections bidirectionally validated
    And travel times verified for consistency
    And secret passages require discovery conditions
BULK OPERATIONS
  @unit @bulk
  Scenario: Bulk approve locations by type
    Given filtered locations by type and status
    When I select all and apply bulk approval with settings
    Then all matching locations approved
    And multiple LocationEntityApproved domain events published
    And audit log records bulk operation
@unit @bulk
  Scenario: Bulk update atmosphere for location group
    Given I have selected locations in a hierarchy
    When I apply bulk atmosphere update
    Then all selected locations have updated atmosphere
    And family-specific ambience applied
    And bulk update audit entry created
API CONTRACT
  @api @contract
  Scenario: Location curation API returns correct format
    Given location curation request via API
    When request processed
    Then response includes: location_id, status, validation_result, audit_trail
@api @validation
  Scenario: API validates curation requests
    Given curation request received
    Then validate: location_exists, user_authorized, required_fields_present, no_conflicts