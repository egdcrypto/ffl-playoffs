@ANIMA-1031
Feature: Simulation World Curation and Configuration
  As a world owner
  I want to curate and configure extracted narrative content
  So that I can create a well-crafted virtual world ready for simulation
Background:
    Given I am authenticated as a world owner
    And I have uploaded and processed a narrative document
    And extracted entities are available for curation
    And the curation interface is loaded
===========================================
  # ENTITY CURATION
  # ===========================================
@curation @entities
  Scenario: Review and curate extracted entities
    Given entity extraction has completed for "Epic Fantasy Novel"
    And 50 entities have been extracted
    When I open the entity curation dashboard
    Then I should see all extracted entities listed
    And entities should be grouped by type (characters, locations, items, events)
    And each entity should show confidence score
    And entities should be sortable and filterable
    And an EntityCurationStartedEvent should be published
@curation @entities @approval
  Scenario: Approve extracted entity
    Given I am reviewing entity "Sir Galahad" of type "character"
    And the extraction confidence is 95%
    When I approve the entity
    Then the entity status should change to "APPROVED"
    And the entity should be marked ready for simulation
    And an EntityApprovedEvent should be published
@curation @entities @rejection
  Scenario: Reject incorrectly extracted entity
    Given I am reviewing entity "The" of type "character"
    And the entity appears to be a false positive
    When I reject the entity with reason "Extraction error - not a character"
    Then the entity status should change to "REJECTED"
    And the entity should be excluded from the world
    And the rejection should be logged for ML improvement
    And an EntityRejectedEvent should be published
@curation @entities @merge
  Scenario: Merge duplicate entities
    Given entities "Sir Galahad" and "Galahad the Knight" appear to be duplicates
    When I select both entities for merge
    And I confirm the merge with "Sir Galahad" as primary
    Then the entities should be merged into one
    And all references should point to the merged entity
    And attributes should be combined intelligently
    And an EntitiesMergedEvent should be published
@curation @entities @split
  Scenario: Split incorrectly merged entities
    Given entity "The Twin Brothers" was extracted as single entity
    And it should be two separate characters
    When I split the entity into "Brother Aric" and "Brother Beran"
    Then two separate entities should be created
    And attributes should be distributed appropriately
    And references should be updated where clear
    And an EntitySplitEvent should be published
@curation @entities @edit
  Scenario: Edit entity attributes
    Given I am editing entity "Castle Ironhold"
    When I modify the description to add details
    And I update the location coordinates
    And I add custom attributes "garrison_size: 500"
    And I save the changes
    Then the entity attributes should be updated
    And the edit history should be recorded
    And an EntityModifiedEvent should be published
@curation @entities @bulk
  Scenario: Bulk approve entities above confidence threshold
    Given 30 entities have confidence score above 90%
    When I apply bulk approval for entities above 90% confidence
    Then all 30 entities should be approved
    And a summary of approved entities should be displayed
    And individual approval events should be batched
    And a BulkApprovalCompletedEvent should be published
===========================================
  # RELATIONSHIP CONFIGURATION
  # ===========================================
@curation @relationships
  Scenario: Validate and configure entity relationships
    Given extracted relationships exist between entities
    When I open the relationship curation view
    Then I should see all extracted relationships
    And relationships should be displayed as connections
    And relationship types should be categorized
    And confidence scores should be visible
@curation @relationships @approval
  Scenario: Approve extracted relationship
    Given relationship "Sir Galahad" -> "King Arthur" with type "serves" exists
    And extraction confidence is 88%
    When I approve the relationship
    Then the relationship should be marked as verified
    And both entities should reflect the connection
    And a RelationshipApprovedEvent should be published
@curation @relationships @create
  Scenario: Create new relationship between entities
    Given entities "Princess Elena" and "Castle Ironhold" exist
    And no relationship currently exists between them
    When I create relationship type "resides_in"
    And I set relationship strength to "strong"
    Then the relationship should be created
    And both entities should show the connection
    And a RelationshipCreatedEvent should be published
@curation @relationships @modify
  Scenario: Modify existing relationship
    Given relationship "Hero" -> "Villain" with type "friends" exists
    And this appears incorrect based on narrative
    When I change the relationship type to "enemies"
    And I add relationship context "bitter rivals since childhood"
    Then the relationship should be updated
    And narrative consistency should improve
    And a RelationshipModifiedEvent should be published
@curation @relationships @delete
  Scenario: Delete incorrect relationship
    Given relationship "Tree" -> "Knight" with type "parent_of" exists
    And this is clearly an extraction error
    When I delete the relationship
    Then the relationship should be removed
    And connected entities should no longer show this link
    And a RelationshipDeletedEvent should be published
@curation @relationships @visualization
  Scenario: Visualize relationship network
    Given multiple relationships have been curated
    When I view the relationship graph
    Then entities should be displayed as nodes
    And relationships should be displayed as edges
    And relationship types should be color-coded
    And I should be able to filter by relationship type
===========================================
  # SIMULATION PARAMETERS
  # ===========================================
@configuration @simulation
  Scenario: Configure world simulation parameters
    Given I am configuring world "Eldoria"
    When I open the simulation parameters panel
    Then I should see configurable simulation settings
    And settings should include time flow, physics, magic systems
    And defaults should be based on narrative analysis
    And changes should preview their effects
@configuration @simulation @time
  Scenario: Configure time flow parameters
    Given I am setting time configuration
    When I set simulation time ratio to "1 hour real = 1 day simulation"
    And I set day length to "24 hours"
    And I configure seasons with "4 seasons, 90 days each"
    Then time flow should be configured
    And time-dependent events should adjust accordingly
    And a TimeConfigurationUpdatedEvent should be published
@configuration @simulation @physics
  Scenario: Configure world physics
    Given I am setting physics parameters
    When I configure gravity as "earth-normal"
    And I enable "realistic weather simulation"
    And I set movement speed modifier to "1.2x"
    Then physics parameters should be saved
    And physics should affect entity behaviors
    And a PhysicsConfigurationUpdatedEvent should be published
@configuration @simulation @magic
  Scenario: Configure magic system
    Given the narrative contains magical elements
    When I enable the magic system
    And I configure magic types as "elemental, divine, arcane"
    And I set magic power level to "moderate"
    And I configure mana regeneration rates
    Then the magic system should be configured
    And magic-capable entities should be updated
    And a MagicSystemConfiguredEvent should be published
@configuration @simulation @economy
  Scenario: Configure world economy
    Given I am configuring economic parameters
    When I set currency system to "gold, silver, copper"
    And I configure price modifiers by region
    And I set trade route influences
    Then the economy system should be configured
    And NPC merchants should use these settings
    And an EconomyConfiguredEvent should be published
===========================================
  # AI BEHAVIOR THRESHOLDS
  # ===========================================
@configuration @ai
  Scenario: Set AI behavior thresholds
    Given I am configuring AI behavior parameters
    When I open the AI configuration panel
    Then I should see behavior threshold settings
    And thresholds should affect NPC decision-making
    And presets should be available for common configurations
@configuration @ai @aggression
  Scenario: Configure aggression thresholds
    Given I am setting NPC aggression parameters
    When I set base aggression threshold to "moderate"
    And I configure faction-based aggression modifiers
    And I set player provocation sensitivity to "low"
    Then aggression thresholds should be saved
    And NPC combat initiation should follow these rules
    And an AggressionThresholdsUpdatedEvent should be published
@configuration @ai @dialogue
  Scenario: Configure dialogue generation parameters
    Given I am setting dialogue AI parameters
    When I set verbosity level to "detailed"
    And I configure personality expression strength to "high"
    And I set topic relevance strictness to "moderate"
    Then dialogue parameters should be saved
    And NPC conversations should reflect these settings
    And a DialogueConfigurationUpdatedEvent should be published
@configuration @ai @memory
  Scenario: Configure NPC memory parameters
    Given I am setting NPC memory configuration
    When I set short-term memory duration to "24 simulation hours"
    And I set long-term memory importance threshold to "significant events"
    And I configure memory decay rate to "gradual"
    Then memory parameters should be saved
    And NPCs should remember according to these rules
    And a MemoryConfigurationUpdatedEvent should be published
@configuration @ai @autonomy
  Scenario Outline: Configure NPC autonomy levels
    Given I am setting autonomy for entity type "<entity_type>"
    When I set autonomy level to "<autonomy_level>"
    Then NPCs of type "<entity_type>" should have "<behavior>"
Examples:
      | entity_type    | autonomy_level | behavior                           |
      | major_npc      | high           | independent decision making        |
      | minor_npc      | medium         | scripted with variations           |
      | background_npc | low            | mostly scripted behavior           |
      | quest_giver    | medium         | follows quest logic with personality|
===========================================
  # CHARACTER CONFIGURATION
  # ===========================================
@configuration @characters
  Scenario: Deep character configuration
    Given I am configuring character "Sir Galahad"
    When I open the character configuration panel
    Then I should see comprehensive character settings
    And settings should include personality, abilities, backstory
    And AI behavior parameters should be editable
    And preview of character behavior should be available
@configuration @characters @personality
  Scenario: Configure character personality
    Given I am editing personality for "Princess Elena"
    When I set trait "kindness" to "very high"
    And I set trait "courage" to "moderate"
    And I add flaw "naive about politics"
    And I set mood baseline to "optimistic"
    Then personality configuration should be saved
    And the character's AI behavior should reflect these traits
    And a CharacterPersonalityConfiguredEvent should be published
@configuration @characters @abilities
  Scenario: Configure character abilities
    Given I am configuring abilities for "Wizard Theron"
    When I add ability "Fireball" with power level 8
    And I add ability "Teleport" with cooldown 1 hour
    And I set mana pool to 500
    Then abilities should be configured
    And the character should use these in simulation
    And an AbilitiesConfiguredEvent should be published
@configuration @characters @dialogue
  Scenario: Configure character dialogue style
    Given I am configuring dialogue for "Old Sage Mentor"
    When I set speech pattern to "formal, archaic"
    And I add vocabulary restrictions "no modern slang"
    And I configure knowledge areas "ancient history, prophecies"
    Then dialogue style should be configured
    And the character's speech should match configuration
    And a DialogueStyleConfiguredEvent should be published
@configuration @characters @schedule
  Scenario: Configure character daily schedule
    Given I am configuring schedule for "Blacksmith Gorn"
    When I set "06:00-18:00" as working hours at "The Forge"
    And I set "18:00-20:00" as dining at "Tavern"
    And I set "20:00-06:00" as sleeping at "Gorn's House"
    Then the schedule should be saved
    And the character should follow this routine
    And a ScheduleConfiguredEvent should be published
===========================================
  # LOCATION CONFIGURATION
  # ===========================================
@configuration @locations
  Scenario: Design location parameters
    Given I am configuring location "The Dark Forest"
    When I open the location configuration panel
    Then I should see location parameters
    And parameters should include ambiance, dangers, resources
    And connected locations should be configurable
    And location-specific rules should be editable
@configuration @locations @ambiance
  Scenario: Configure location ambiance
    Given I am setting ambiance for "Haunted Castle"
    When I set lighting to "dim, flickering torches"
    And I set sounds to "creaking, distant moans, wind"
    And I set mood to "ominous, foreboding"
    And I configure weather as "perpetual fog"
    Then ambiance should be configured
    And visitors should experience these elements
    And an AmbianceConfiguredEvent should be published
@configuration @locations @hazards
  Scenario: Configure location hazards
    Given I am configuring hazards for "Volcanic Crater"
    When I add hazard "lava pools" with damage level "severe"
    And I add hazard "toxic fumes" with effect "poison"
    And I set hazard frequency to "frequent"
    Then hazards should be configured
    And entities entering should face these dangers
    And a HazardsConfiguredEvent should be published
@configuration @locations @resources
  Scenario: Configure location resources
    Given I am configuring resources for "Crystal Caverns"
    When I add resource "magic crystals" with rarity "rare"
    And I add resource "iron ore" with rarity "common"
    And I set respawn rate to "7 simulation days"
    Then resources should be configured
    And harvesting should follow these rules
    And a ResourcesConfiguredEvent should be published
@configuration @locations @connections
  Scenario: Configure location connections
    Given locations "Town Square" and "Market District" exist
    When I create connection between them
    And I set travel time to "5 minutes walking"
    And I set access requirements to "none"
    Then the connection should be established
    And navigation should respect this path
    And a LocationConnectionCreatedEvent should be published
===========================================
  # TIMELINE CONFIGURATION
  # ===========================================
@configuration @timeline
  Scenario: Configure narrative timeline
    Given I am configuring the world timeline
    When I open the timeline configuration panel
    Then I should see extracted timeline events
    And events should be arranged chronologically
    And I should be able to add, modify, or remove events
    And timeline consistency should be validated
@configuration @timeline @events
  Scenario: Add historical event to timeline
    Given I am adding to the world timeline
    When I create event "The Great War"
    And I set date to "500 years before present"
    And I set duration to "10 years"
    And I link affected entities "Kingdom A", "Kingdom B"
    Then the event should be added to timeline
    And affected entities should reference this history
    And a TimelineEventAddedEvent should be published
@configuration @timeline @sequence
  Scenario: Configure event sequence
    Given events "Treaty Signed" and "Peace Established" exist
    When I set "Treaty Signed" to occur before "Peace Established"
    And I set gap between events to "1 month"
    Then the sequence should be configured
    And timeline should show proper ordering
    And a SequenceConfiguredEvent should be published
@configuration @timeline @triggers
  Scenario: Configure timeline-triggered events
    Given I am setting up dynamic timeline
    When I create trigger "When player reaches level 10"
    And I set triggered event "Ancient Evil Awakens"
    And I configure consequence chain
    Then the trigger should be saved
    And simulation should watch for trigger condition
    And a TimelineTriggerConfiguredEvent should be published
@configuration @timeline @validation
  Scenario: Validate timeline consistency
    Given the timeline has multiple configured events
    When I run timeline validation
    Then temporal paradoxes should be detected
    And inconsistent dates should be flagged
    And suggestions for resolution should be provided
    And a TimelineValidationCompletedEvent should be published
===========================================
  # WORLD PREVIEW
  # ===========================================
@preview @world
  Scenario: Preview curated world before launch
    Given curation is complete for world "Eldoria"
    When I request a world preview
    Then a simulation preview should be generated
    And I should be able to explore the world
    And key locations should be visitable
    And NPCs should be interactive in preview mode
    And a PreviewGeneratedEvent should be published
@preview @validation
  Scenario: Validate world readiness for launch
    Given I am previewing world "Eldoria"
    When I run launch readiness check
    Then entity completeness should be verified
    And relationship consistency should be checked
    And configuration validity should be confirmed
    And a readiness report should be generated
@preview @testing
  Scenario: Test specific scenarios in preview
    Given I am in world preview mode
    When I create test scenario "Player meets Sir Galahad"
    And I run the test interaction
    Then the NPC should respond according to configuration
    And dialogue should match personality settings
    And the interaction should be recordable
    And test results should be reviewable
@preview @walkthrough
  Scenario: Perform guided walkthrough of curated content
    Given I am previewing curated world
    When I start guided walkthrough
    Then the system should guide me through key elements
    And important entities should be highlighted
    And potential issues should be pointed out
    And a walkthrough report should be generated
===========================================
  # CURATION TEMPLATES
  # ===========================================
@templates @curation
  Scenario: Apply curation templates
    Given I have a new world "Dragon's Realm" to curate
    And template "High Fantasy Standard" exists
    When I apply template "High Fantasy Standard"
    Then default configurations should be applied
    And entity type mappings should be set
    And simulation parameters should be pre-configured
    And a TemplateAppliedEvent should be published
@templates @creation
  Scenario: Create curation template from current configuration
    Given world "Eldoria" is fully configured
    When I save configuration as template "Eldoria Style"
    Then the template should capture all configurations
    And template should be available for future use
    And template should be shareable with others
    And a TemplateCreatedEvent should be published
@templates @customization
  Scenario: Customize applied template
    Given template "High Fantasy Standard" has been applied
    When I modify the magic system configuration
    And I adjust the economy settings
    Then changes should override template defaults
    And the world should use customized settings
    And a TemplateCustomizedEvent should be published
@templates @library
  Scenario: Browse template library
    Given multiple curation templates exist
    When I browse the template library
    Then I should see available templates
    And templates should show descriptions and ratings
    And I should be able to filter by genre
    And preview of template effects should be available
===========================================
  # COLLABORATIVE CURATION
  # ===========================================
@collaboration @curation
  Scenario: Collaborative curation workflow
    Given world "Eldoria" allows collaborative curation
    And I have invited curator "Alice" to collaborate
    When "Alice" joins the curation session
    Then both curators should see the same content
    And changes should synchronize in real-time
    And a CollaboratorJoinedEvent should be published
@collaboration @assignments
  Scenario: Assign curation tasks to collaborators
    Given I am coordinating curation for "Eldoria"
    When I assign "character curation" to "Alice"
    And I assign "location curation" to "Bob"
    Then tasks should be assigned to collaborators
    And collaborators should see their assignments
    And progress should be trackable
    And an AssignmentCreatedEvent should be published
@collaboration @review
  Scenario: Review collaborator's curation work
    Given "Alice" has completed character curation
    When I review her work
    Then I should see all changes she made
    And I should be able to approve or request changes
    And feedback should be recordable
    And a ReviewCompletedEvent should be published
@collaboration @conflict
  Scenario: Handle concurrent edit conflicts
    Given "Alice" and "Bob" are editing same entity
    When both submit changes simultaneously
    Then conflict should be detected
    And conflict resolution options should be presented
    And the conflict should be resolvable
    And a ConflictResolvedEvent should be published
@collaboration @permissions
  Scenario Outline: Enforce collaboration permissions
    Given user has role "<role>" on world curation
    When user attempts action "<action>"
    Then the action should be "<result>"
Examples:
      | role       | action              | result   |
      | owner      | approve entities    | allowed  |
      | curator    | edit entities       | allowed  |
      | curator    | delete entities     | denied   |
      | reviewer   | comment on entities | allowed  |
      | reviewer   | edit entities       | denied   |
===========================================
  # QUALITY MONITORING
  # ===========================================
@quality @monitoring
  Scenario: Monitor curation quality
    Given curation is in progress for world "Eldoria"
    When I view the quality dashboard
    Then I should see curation progress metrics
    And quality scores should be displayed
    And issues should be highlighted
    And recommendations should be provided
@quality @completeness
  Scenario: Track entity curation completeness
    Given 100 entities have been extracted
    And 75 have been curated
    When I check completeness metrics
    Then completeness should show 75%
    And remaining entities should be listed
    And time estimate to complete should be shown
    And a CompletenessReportEvent should be published
@quality @consistency
  Scenario: Detect curation inconsistencies
    Given curation includes conflicting information
    When consistency check runs
    Then inconsistencies should be identified
    And affected entities should be flagged
    And resolution suggestions should be provided
    And a ConsistencyIssueDetectedEvent should be published
@quality @recommendations
  Scenario: Receive AI-powered curation recommendations
    Given the AI has analyzed the narrative and curation
    When I request recommendations
    Then suggestions for improvements should be provided
    And missing entities should be identified
    And relationship suggestions should be offered
    And a RecommendationsGeneratedEvent should be published
@quality @scoring
  Scenario: Calculate world quality score
    Given curation is complete
    When quality scoring runs
    Then overall quality score should be calculated
    And score should factor in completeness, consistency, depth
    And comparison to benchmarks should be shown
    And a QualityScoreCalculatedEvent should be published
===========================================
  # ERROR HANDLING
  # ===========================================
@error @validation
  Scenario: Handle validation errors during configuration
    Given I submit invalid configuration value
    When validation fails
    Then specific error should be displayed
    And invalid fields should be highlighted
    And valid values should be preserved
    And guidance for correction should be provided
@error @save-failure
  Scenario: Handle save failures gracefully
    Given I am saving curation changes
    When the save operation fails
    Then the error should be displayed
    And unsaved changes should be preserved locally
    And retry option should be available
    And a SaveFailedEvent should be logged
@error @recovery
  Scenario: Recover from interrupted curation session
    Given a curation session was interrupted
    When I return to curation
    Then unsaved work should be recoverable
    And recovery options should be presented
    And I should be able to resume from last state
    And a SessionRecoveredEvent should be published
===========================================
  # VERSIONING AND HISTORY
  # ===========================================
@versioning @curation
  Scenario: Track curation version history
    Given multiple curation sessions have occurred
    When I view version history
    Then all curation versions should be listed
    And changes between versions should be viewable
    And I should be able to rollback to previous versions
    And version comparison should be available
@versioning @rollback
  Scenario: Rollback curation to previous version
    Given current curation has issues
    And a good previous version exists
    When I rollback to the previous version
    Then curation should revert to selected version
    And current changes should be archived
    And a RollbackCompletedEvent should be published