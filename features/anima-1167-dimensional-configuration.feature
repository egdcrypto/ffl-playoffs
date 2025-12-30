@domain @narrative-engine @world-building @dimensions
Feature: Dimensional Configuration (World Dials)
  As a world curator
  I want to configure tunable dimensional parameters for my world
  So that I can control the narrative tone, genre, and experience without coding

  Background:
    Given I am authenticated as a world curator
    And I have a world "Mystic Realms" in curation phase
    And the dimensional configuration system is initialized
    And the following default dimensions are defined:
      | dimension_name       | range   | default | category    |
      | tragedy_level        | 0.0-1.0 | 0.5     | narrative   |
      | chaos_factor         | 0.0-1.0 | 0.3     | narrative   |
      | romance_intensity    | 0.0-1.0 | 0.5     | narrative   |
      | verisimilitude       | 0.0-1.0 | 0.5     | setting     |
      | hope_index           | 0.0-1.0 | 0.6     | tone        |
      | violence_graphicness | 0.0-1.0 | 0.4     | content     |
      | mystery_depth        | 0.0-1.0 | 0.5     | narrative   |
      | humor_presence       | 0.0-1.0 | 0.3     | tone        |

  # ============================================
  # CORE DIMENSION CONFIGURATION
  # ============================================

  @domain @dimensions
  Scenario: View dimensional configuration interface
    Given my world "Mystic Realms" has default dimension configuration
    When I access the dimensional configuration interface
    Then I should see all configurable dimensions displayed:
      | dimension_name       | current_value | default | description                               |
      | tragedy_level        | 0.5           | 0.5     | How often characters face irreversible loss |
      | chaos_factor         | 0.3           | 0.3     | Randomness vs logical story progression    |
      | romance_intensity    | 0.5           | 0.5     | How prominently relationships feature      |
      | verisimilitude       | 0.5           | 0.5     | Historical accuracy vs high fantasy        |
      | hope_index           | 0.6           | 0.6     | Grimdark vs optimistic tone                |
      | violence_graphicness | 0.4           | 0.4     | Combat description intensity               |
      | mystery_depth        | 0.5           | 0.5     | How much is hidden vs revealed             |
      | humor_presence       | 0.3           | 0.3     | Serious vs comedic moments                 |
    And each dimension should display a visual slider control
    And each dimension should show impact preview tooltips
    And dimensions should be grouped by category

  @domain @dimensions
  Scenario: Configure world dimensions with visual feedback
    Given I am on the dimensional configuration interface
    When I adjust the following dimension sliders:
      | dimension_name  | new_value |
      | tragedy_level   | 0.8       |
      | hope_index      | 0.2       |
      | chaos_factor    | 0.6       |
    Then each slider should update visually to reflect the new position
    And the impact preview panel should update in real-time
    And I should see narrative tone indicator shift to "Dark & Unpredictable"
    And sample narrative snippets should regenerate to match new settings
    And changes should be marked as unsaved

  @domain @dimensions @update
  Scenario: Update single dimension value with validation
    Given my world has default dimension configuration
    When I update tragedy_level to 0.8
    And I save the configuration
    Then the dimension value should be persisted as 0.8
    And the impact preview should show higher tragedy narratives:
      | narrative_aspect    | expected_change                    |
      | character_deaths    | More frequent and impactful        |
      | happy_endings       | Rare, often subverted              |
      | sacrifice_moments   | Common and meaningful              |
    And domain event DimensionValueChanged should be published with:
      | field          | value          |
      | world_id       | mystic-realms  |
      | dimension_name | tragedy_level  |
      | old_value      | 0.5            |
      | new_value      | 0.8            |
      | changed_by     | current_user   |
    And the configuration history should record the change

  @domain @dimensions @batch
  Scenario: Batch update multiple dimensions atomically
    Given my world has default dimension configuration
    When I update multiple dimensions simultaneously:
      | dimension          | value |
      | tragedy_level      | 0.7   |
      | hope_index         | 0.3   |
      | chaos_factor       | 0.6   |
      | mystery_depth      | 0.8   |
      | violence_graphicness| 0.6  |
    And I save the batch configuration
    Then all dimensions should be updated in a single transaction
    And if any update fails, all updates should be rolled back
    And a single DimensionalConfigurationBatchUpdated event should be published with:
      | field              | value                                        |
      | world_id           | mystic-realms                                |
      | changes_count      | 5                                            |
      | changed_dimensions | tragedy_level, hope_index, chaos_factor, mystery_depth, violence_graphicness |
      | changed_by         | current_user                                 |
    And the history should show a single batch change entry

  @domain @dimensions @preview
  Scenario: Preview dimension effects before saving
    Given I am configuring dimensions
    And tragedy_level is currently 0.5
    When I adjust tragedy_level to 0.9 without saving
    Then the preview pane should update immediately
    And I should see sample narrative snippets reflecting high tragedy:
      | snippet_type      | example_content                              |
      | death_scene       | "The hero fell, their sacrifice complete..." |
      | loss_moment       | "Everything they loved turned to ash..."     |
      | bitter_victory    | "They won, but at what cost?"                |
    And the preview should be clearly labeled as "Preview - Not Saved"
    And no changes should be persisted to the database
    And I should see "Discard Changes" and "Save Changes" buttons

  @domain @dimensions @preview
  Scenario: Generate multiple preview samples
    Given I am adjusting dimensions in preview mode
    When I request additional preview samples
    Then the system should generate 5 diverse narrative snippets
    And each snippet should reflect the current dimension settings
    And I should be able to regenerate samples without saving
    And sample generation should not affect story engine state

  @domain @dimensions @undo
  Scenario: Undo dimension changes before saving
    Given I have made unsaved changes to multiple dimensions:
      | dimension       | original | changed_to |
      | tragedy_level   | 0.5      | 0.9        |
      | hope_index      | 0.6      | 0.1        |
    When I click "Discard Changes"
    Then I should see a confirmation prompt
    And upon confirming, all dimensions should revert to original values
    And the preview should update to reflect original settings
    And no domain events should be published

  # ============================================
  # DIMENSION CATEGORIES AND GROUPING
  # ============================================

  @domain @dimensions @categories
  Scenario: View dimensions organized by category
    When I access the dimensional configuration interface
    Then dimensions should be grouped into categories:
      | category   | dimensions                                      |
      | Narrative  | tragedy_level, chaos_factor, romance_intensity, mystery_depth |
      | Tone       | hope_index, humor_presence                      |
      | Setting    | verisimilitude                                  |
      | Content    | violence_graphicness                            |
    And each category should be collapsible
    And I should be able to expand/collapse all categories

  @domain @dimensions @search
  Scenario: Search for specific dimension
    Given I am on the dimensional configuration interface
    When I search for "tragedy"
    Then the interface should filter to show only matching dimensions
    And tragedy_level should be highlighted in the results
    And non-matching dimensions should be hidden or grayed out

  # ============================================
  # ERA VECTOR CONFIGURATION
  # ============================================

  @domain @era_vector
  Scenario: View era vector configuration options
    Given I want to set the time period aesthetic for my world
    When I access the era vector configuration section
    Then I should see the following configurable components:
      | component           | type        | options_or_range                              |
      | base_era            | enum        | PREHISTORIC, ANCIENT, MEDIEVAL, RENAISSANCE, INDUSTRIAL, MODERN, FUTURISTIC, CUSTOM |
      | technology_level    | slider      | 0.0-1.0 (primitive to advanced)               |
      | magical_presence    | slider      | 0.0-1.0 (none to pervasive)                   |
      | cultural_complexity | slider      | 0.0-1.0 (tribal to cosmopolitan)              |
      | aesthetic_blend     | multi-select| Secondary era influences                      |
    And each component should display contextual help
    And I should see a visual representation of the era setting

  @domain @era_vector
  Scenario: Configure era vector with base era selection
    Given I am configuring the era vector for my world
    When I select base_era as "MEDIEVAL"
    And I set technology_level to 0.3
    And I set magical_presence to 0.7
    And I set cultural_complexity to 0.5
    And I save the era vector configuration
    Then the era vector should be persisted with:
      | component           | value    |
      | base_era            | MEDIEVAL |
      | technology_level    | 0.3      |
      | magical_presence    | 0.7      |
      | cultural_complexity | 0.5      |
    And the translation catalog should be generated for MEDIEVAL era
    And domain event EraVectorConfigured should be published with:
      | field              | value                |
      | world_id           | mystic-realms        |
      | base_era           | MEDIEVAL             |
      | technology_level   | 0.3                  |
      | magical_presence   | 0.7                  |
      | cultural_complexity| 0.5                  |

  @domain @era_vector @translation
  Scenario: View era translation catalog
    Given I have configured base_era as MEDIEVAL
    And the translation catalog has been generated
    When I view the translation catalog
    Then I should see canonical items with era-appropriate translations:
      | canonical_item | translation        | category       | confidence |
      | sword          | longsword          | weapons        | 0.95       |
      | gun            | crossbow           | weapons        | 0.75       |
      | letter         | sealed scroll      | communication  | 0.90       |
      | phone          | messenger pigeon   | communication  | 0.60       |
      | car            | horse-drawn cart   | transportation | 0.70       |
      | poison         | hemlock vial       | substances     | 0.85       |
      | money          | gold coins         | currency       | 0.95       |
      | hospital       | healer's house     | locations      | 0.80       |
    And I should be able to filter translations by category
    And I should see translation confidence scores
    And low-confidence translations should be flagged for review

  @domain @era_vector @translation
  Scenario: Search translation catalog
    Given I have a populated translation catalog
    When I search the catalog for "weapon"
    Then I should see all weapon-category translations
    And results should be sorted by confidence score descending
    And I should be able to navigate to edit any translation

  @domain @era_vector @translation @custom
  Scenario: Add custom translation override
    Given I have configured base_era as MEDIEVAL
    And the default translation for "sword" is "longsword"
    When I add a custom translation override:
      | canonical_item | custom_translation | reason                        |
      | sword          | enchanted claymore | Unique to this world's lore   |
    Then my custom translation should be saved
    And the custom translation should take precedence over default
    And the default translation should still be visible as fallback
    And domain event TranslationOverrideAdded should be published with:
      | field              | value              |
      | world_id           | mystic-realms      |
      | canonical_item     | sword              |
      | default_translation| longsword          |
      | custom_translation | enchanted claymore |

  @domain @era_vector @translation @custom
  Scenario: Remove custom translation override
    Given I have a custom translation override for "sword"
    When I remove the custom translation override
    Then the system should revert to the default translation "longsword"
    And domain event TranslationOverrideRemoved should be published

  @domain @era_vector @translation @bulk
  Scenario: Bulk import custom translations
    Given I have a CSV file with custom translations:
      | canonical_item | custom_translation |
      | sword          | runic blade        |
      | shield         | warded buckler     |
      | armor          | enchanted mail     |
    When I import the custom translations file
    Then all translations should be validated
    And valid translations should be saved as overrides
    And I should see import results with success/failure counts

  @domain @era_vector @translation @missing
  Scenario: Handle missing translation gracefully
    Given I have configured base_era as PREHISTORIC
    And the narrative engine references canonical item "smartphone"
    When the translation is requested
    Then the system should detect the missing translation
    And flag it for curator review with:
      | field             | value                            |
      | canonical_item    | smartphone                       |
      | suggested_equivalent| stone tablet for messaging     |
      | confidence        | 0.40                             |
      | requires_review   | true                             |
    And the suggested equivalent should be used temporarily
    And a notification should be sent to the curator

  @domain @era_vector @translation @missing
  Scenario: Review and resolve missing translations
    Given there are flagged missing translations for review
    When I access the translation review queue
    Then I should see all pending translations:
      | canonical_item | suggested    | confidence | status  |
      | smartphone     | stone tablet | 0.40       | pending |
      | email          | letter       | 0.50       | pending |
    And I should be able to approve, modify, or reject each suggestion
    And approved translations should be added to the catalog

  @domain @era_vector @custom
  Scenario: Configure custom era with required parameters
    Given I am configuring the era vector
    When I select base_era as "CUSTOM"
    Then the system should require the following fields:
      | required_field      | description                           | validation           |
      | custom_era_name     | Display name for the era              | 3-50 characters      |
      | technology_level    | Tech level (required for custom)      | 0.0-1.0              |
      | cultural_complexity | Culture level (required for custom)   | 0.0-1.0              |
      | translation_base    | Which era to use as translation base  | Valid era enum       |
    And I should not be able to save until all required fields are filled
    And validation errors should be shown for missing fields

  @domain @era_vector @custom
  Scenario: Save valid custom era configuration
    Given I am configuring a custom era
    When I provide all required custom era fields:
      | field               | value              |
      | custom_era_name     | Steampunk Victorian|
      | technology_level    | 0.7                |
      | magical_presence    | 0.4                |
      | cultural_complexity | 0.8                |
      | translation_base    | INDUSTRIAL         |
    And I save the configuration
    Then the custom era should be saved successfully
    And translations should be generated using INDUSTRIAL as base
    And the custom era should be available for future reference

  @domain @era_vector @blend
  Scenario: Configure aesthetic blend with multiple eras
    Given I am configuring the era vector
    When I set base_era as "MEDIEVAL"
    And I configure aesthetic_blend with multiple influences:
      | era        | influence_weight | description                |
      | MEDIEVAL   | 0.6              | Primary aesthetic          |
      | FUTURISTIC | 0.3              | Technology elements        |
      | ANCIENT    | 0.1              | Cultural references        |
    Then the influence weights should sum to 1.0
    And the translation engine should blend era influences
    And items should have hybrid translations where applicable:
      | canonical_item | blended_translation    | influence_breakdown          |
      | sword          | laser-etched longsword | 60% medieval, 30% futuristic |
      | armor          | runic power armor      | 40% medieval, 50% futuristic |

  @domain @era_vector @blend @validation
  Scenario: Validate aesthetic blend weights
    Given I am configuring aesthetic blend
    When I set influence weights that sum to more than 1.0:
      | era        | weight |
      | MEDIEVAL   | 0.7    |
      | FUTURISTIC | 0.5    |
    Then the system should display validation error
    And suggest adjusting weights to sum to 1.0
    And provide auto-normalize option

  @domain @era_vector @blend
  Scenario: Auto-normalize blend weights
    Given I have set influence weights summing to 1.2
    When I click "Auto-normalize weights"
    Then the weights should be proportionally adjusted to sum to 1.0:
      | era        | original | normalized |
      | MEDIEVAL   | 0.7      | 0.58       |
      | FUTURISTIC | 0.5      | 0.42       |
    And I should be able to accept or reject the normalization

  # ============================================
  # CANON FIDELITY CONFIGURATION
  # ============================================

  @domain @canon_fidelity
  Scenario: View canon fidelity configuration options
    Given I want to control story deviation from source material
    When I access the canon fidelity configuration section
    Then I should see the following configurable parameters:
      | parameter             | range   | default | description                          |
      | overall_fidelity      | 0.0-1.0 | 0.7     | Probability of following canonical events |
      | character_fidelity    | 0.0-1.0 | 0.8     | How closely NPCs match source personalities |
      | plot_fidelity         | 0.0-1.0 | 0.6     | Whether major plot points must occur |
      | relationship_fidelity | 0.0-1.0 | 0.7     | Whether canonical relationships form |
      | outcome_fidelity      | 0.0-1.0 | 0.5     | Whether canonical endings are preserved |
    And each parameter should have impact examples
    And I should see a deviation probability calculator

  @domain @canon_fidelity
  Scenario: Configure canon fidelity parameters
    Given I am configuring canon fidelity for my world
    When I set the following fidelity parameters:
      | parameter             | value |
      | overall_fidelity      | 0.3   |
      | character_fidelity    | 0.5   |
      | plot_fidelity         | 0.2   |
      | relationship_fidelity | 0.4   |
      | outcome_fidelity      | 0.1   |
    And I save the configuration
    Then the canon fidelity should be persisted
    And the system should calculate expected deviation rates:
      | story_element      | deviation_probability |
      | Major plot points  | 80%                   |
      | Character arcs     | 50%                   |
      | Relationship paths | 60%                   |
      | Story endings      | 90%                   |
    And domain event CanonFidelityConfigured should be published

  @domain @canon_fidelity @divergence
  Scenario: Player causes canon divergence at low fidelity
    Given the world has plot_fidelity set to 0.3
    And a major canonical event "The King's Assassination" is approaching
    And the player has befriended the assassin character
    When the player takes actions to prevent the assassination
    Then the story engine should calculate divergence probability as 70%
    And with 70% probability, allow the divergence
    And if divergence occurs:
      | action                                                    |
      | Record the divergence point in world history              |
      | Mark "The King's Assassination" as diverged               |
      | Recalculate downstream story possibilities                |
      | Publish CanonDivergenceOccurred domain event              |
    And the player should receive subtle narrative acknowledgment

  @domain @canon_fidelity @divergence
  Scenario: Canon event proceeds despite player interference at high fidelity
    Given the world has plot_fidelity set to 0.9
    And a major canonical event "The Dragon's Awakening" is approaching
    When the player attempts to prevent the awakening
    Then the story engine should calculate divergence probability as 10%
    And with 90% probability, the canon event should proceed
    And the narrative should explain why player actions failed
    And the player should not feel cheated by the outcome

  @domain @canon_fidelity @preview
  Scenario: Preview canon divergence scenarios
    Given I am configuring canon fidelity
    When I request a divergence preview
    Then the system should show sample scenarios:
      | canonical_event        | fidelity | likely_outcome          |
      | Hero's Death           | 0.2      | Probably avoidable      |
      | Villain's Redemption   | 0.5      | Could go either way     |
      | Kingdom's Fall         | 0.8      | Likely inevitable       |
    And I should see player agency implications for each setting

  # ============================================
  # DIMENSIONAL PRESETS
  # ============================================

  @domain @presets
  Scenario: Browse available dimensional presets
    Given I want to quickly configure my world
    When I browse the dimensional presets library
    Then I should see system presets organized by genre:
      | preset_name           | tragedy | chaos | hope | romance | mystery | genre      |
      | shakespearean_tragedy | 0.9     | 0.3   | 0.2  | 0.7     | 0.4     | tragedy    |
      | fairy_tale_adventure  | 0.2     | 0.4   | 0.9  | 0.5     | 0.3     | fantasy    |
      | noir_mystery          | 0.6     | 0.5   | 0.4  | 0.3     | 0.9     | noir       |
      | epic_fantasy          | 0.5     | 0.4   | 0.7  | 0.4     | 0.5     | fantasy    |
      | horror_survival       | 0.8     | 0.7   | 0.2  | 0.2     | 0.6     | horror     |
      | romantic_drama        | 0.4     | 0.3   | 0.6  | 0.9     | 0.3     | romance    |
      | comedy_adventure      | 0.1     | 0.5   | 0.8  | 0.4     | 0.2     | comedy     |
      | grimdark_epic         | 0.9     | 0.6   | 0.1  | 0.3     | 0.5     | dark fantasy|
    And each preset should show a brief description
    And I should be able to filter presets by genre

  @domain @presets
  Scenario: Preview preset before applying
    Given I am browsing presets
    When I hover over or select the "noir_mystery" preset for preview
    Then I should see a detailed preview:
      | preview_element       | content                                   |
      | dimension_values      | Full list of all dimension settings       |
      | sample_narrative      | Example narrative snippet in noir style   |
      | tone_description      | "Morally grey, atmospheric, cynical"      |
      | recommended_for       | Detective stories, crime fiction          |
    And I should see "Apply" and "Cancel" buttons

  @domain @presets @apply
  Scenario: Apply preset and customize further
    Given I have selected the "noir_mystery" preset
    When I click "Apply Preset"
    Then all dimensions should update to preset values:
      | dimension            | preset_value |
      | tragedy_level        | 0.6          |
      | chaos_factor         | 0.5          |
      | hope_index           | 0.4          |
      | romance_intensity    | 0.3          |
      | mystery_depth        | 0.9          |
      | humor_presence       | 0.2          |
    And the preset name should be displayed as the current configuration base
    And I should be able to modify individual dimensions
    And changes from preset should be tracked
    And domain event PresetApplied should be published with:
      | field       | value        |
      | world_id    | mystic-realms|
      | preset_id   | noir_mystery |
      | preset_name | Noir Mystery |

  @domain @presets @customize
  Scenario: Customize applied preset with tracking
    Given I have applied the "noir_mystery" preset
    When I modify mystery_depth from 0.9 to 0.7
    And I modify humor_presence from 0.2 to 0.4
    Then the configuration should be marked as "noir_mystery (customized)"
    And the modifications should be tracked:
      | dimension      | preset_value | custom_value | delta |
      | mystery_depth  | 0.9          | 0.7          | -0.2  |
      | humor_presence | 0.2          | 0.4          | +0.2  |
    And I should be able to "Reset to Preset" to restore original values

  @domain @presets @save
  Scenario: Save custom preset with validation
    Given I have configured custom dimension values
    When I click "Save as Custom Preset"
    And I enter preset details:
      | field       | value                        |
      | preset_name | My Dark Comedy World         |
      | description | A unique blend of dark humor |
    Then the system should validate:
      | validation                  | rule                              |
      | preset_name length          | 3-50 characters                   |
      | preset_name format          | alphanumeric, spaces, hyphens     |
      | preset_name uniqueness      | no duplicates in my presets       |
      | description length          | max 500 characters                |
    And upon passing validation, the preset should be saved
    And domain event CustomPresetCreated should be published
    And the preset should appear in my custom presets list

  @domain @presets @save @error
  Scenario: Reject duplicate preset name
    Given I have a custom preset named "My Dark World"
    When I attempt to save another preset with name "My Dark World"
    Then the system should display error "A preset with this name already exists"
    And suggest alternative names or renaming option

  @domain @presets @update
  Scenario: Update existing custom preset
    Given I have a custom preset "My Dark World"
    And I have modified dimension values
    When I click "Update Preset"
    Then I should see options:
      | option                    | description                          |
      | Update existing           | Overwrite My Dark World              |
      | Save as new               | Create new preset with these values  |
    And upon choosing "Update existing", the preset should be updated
    And domain event CustomPresetUpdated should be published

  @domain @presets @delete
  Scenario: Delete custom preset with confirmation
    Given I have created a custom preset named "my_custom_world"
    When I click "Delete Preset"
    Then the system should display confirmation dialog:
      | message | Are you sure you want to delete "my_custom_world"? |
      | warning | Worlds using this preset will retain their current values. |
    And upon confirming, the preset should be removed
    And my preset list should no longer contain "my_custom_world"
    And domain event CustomPresetDeleted should be published

  @domain @presets @share
  Scenario: Share preset with community
    Given I have created a custom preset "Unique Horror Blend"
    When I choose to share the preset publicly
    Then I should set sharing options:
      | option          | value           |
      | visibility      | public          |
      | allow_cloning   | true            |
      | allow_comments  | true            |
    And the preset should be submitted for review
    And upon approval, appear in community presets section
    And I should remain the owner with edit rights

  @domain @presets @community
  Scenario: Browse and apply community presets
    Given there are community-shared presets available
    When I browse the community presets section
    Then I should see presets from other curators:
      | preset_name        | creator      | uses  | rating |
      | Cosmic Horror      | curator_x    | 450   | 4.5    |
      | Slice of Life      | curator_y    | 320   | 4.2    |
      | Cyberpunk Noir     | curator_z    | 280   | 4.7    |
    And I should be able to filter by genre, rating, and popularity
    And I should be able to apply any community preset to my world

  @domain @presets @clone
  Scenario: Clone existing preset for modification
    Given I want to create a variation of the "noir_mystery" preset
    When I click "Clone Preset" on noir_mystery
    Then a new editable preset should be created:
      | field       | value             |
      | name        | noir_mystery_copy |
      | source      | noir_mystery      |
      | is_clone    | true              |
    And all dimension values should be copied
    And I should be in edit mode for the cloned preset
    And I should be able to modify and save with a new name

  # ============================================
  # DIMENSION LOCKING AND LIFECYCLE
  # ============================================

  @domain @lifecycle @lock
  Scenario: Dimensions lock after world launch
    Given my world "Mystic Realms" has been launched to players
    When I navigate to the dimensional configuration interface
    Then all dimension controls should be in read-only mode
    And I should see message "Dimensions are locked after world launch"
    And I should see an explanation of why locking is necessary
    And I should see option "Create New Version" to modify dimensions

  @domain @lifecycle @lock
  Scenario: Attempt to modify locked dimensions via API
    Given my world has been launched
    When I send a PUT request to update dimensions
    Then the response status should be 403
    And the response should contain error:
      | code    | DIMENSIONS_LOCKED                                     |
      | message | Cannot modify dimensions after world launch           |
      | suggestion | Create a new world version to use different settings |

  @domain @lifecycle @version
  Scenario: Create new world version with different dimensions
    Given my world "Mystic Realms" has been launched with locked dimensions
    When I click "Create New Version"
    Then a new world version should be created:
      | field           | value                    |
      | name            | Mystic Realms v2         |
      | base_version    | Mystic Realms            |
      | phase           | curation                 |
      | dimensions      | copied from v1           |
    And the new version should be in curation phase
    And I should be able to modify dimensions in the new version
    And domain event WorldVersionCreated should be published
    And players in v1 should not be affected

  @domain @lifecycle @version
  Scenario: View dimension differences between versions
    Given I have world version 1 and version 2 with different dimensions
    When I compare dimension configurations
    Then I should see a diff view:
      | dimension       | v1_value | v2_value | changed |
      | tragedy_level   | 0.5      | 0.8      | yes     |
      | hope_index      | 0.6      | 0.3      | yes     |
      | chaos_factor    | 0.3      | 0.3      | no      |
    And changed dimensions should be highlighted

  @domain @lifecycle @inheritance
  Scenario: Inherit dimensions from parent world template
    Given I am creating a new world based on template "Dark Fantasy Template"
    And the template has specific dimension values
    When I choose to inherit dimensions
    Then all dimension values should be copied from the template:
      | dimension       | inherited_value |
      | tragedy_level   | 0.7             |
      | hope_index      | 0.3             |
      | chaos_factor    | 0.5             |
    And I should be able to override individual dimensions
    And the inheritance relationship should be tracked
    And I should see "Based on: Dark Fantasy Template" indicator

  @domain @lifecycle @inheritance
  Scenario: Break inheritance and customize fully
    Given I have inherited dimensions from a template
    When I click "Break Inheritance"
    Then I should see confirmation warning:
      | message | Breaking inheritance will disconnect from template updates |
    And upon confirming, the inheritance link should be removed
    And all values should become independently editable
    And future template updates should not affect my world

  # ============================================
  # AI GENERATION EFFECTS
  # ============================================

  @integration @ai_effects
  Scenario: Dimensions affect AI narrative generation
    Given my world has the following dimension configuration:
      | dimension            | value |
      | tragedy_level        | 0.8   |
      | hope_index           | 0.2   |
      | chaos_factor         | 0.6   |
      | violence_graphicness | 0.7   |
    When the AI generates narrative content for a combat scene
    Then the generated content should reflect configured dimensions:
      | content_aspect        | expected_behavior                        |
      | character_deaths      | More frequent, described in detail       |
      | happy_resolutions     | Rare, pyrrhic victories common           |
      | random_events         | Unpredictable, often negative            |
      | combat_descriptions   | Visceral, impactful                      |
    And dimension adherence should be measurable
    And content should feel consistent with settings

  @integration @ai_effects
  Scenario: Low tragedy settings produce hopeful content
    Given my world has tragedy_level set to 0.1 and hope_index set to 0.9
    When the AI generates narrative content
    Then the generated content should:
      | characteristic              |
      | Avoid permanent character deaths |
      | Include optimistic outcomes |
      | Feature successful rescues |
      | Show villains reforming |
    And the tone should feel uplifting and adventurous

  @integration @ai_effects @calibration
  Scenario: Calibrate AI generation for dimension accuracy
    Given my world has specific dimension configuration
    When I run a calibration test
    Then the system should:
      | step                                              |
      | Generate 10 sample narrative passages             |
      | Analyze each for dimension adherence              |
      | Calculate adherence scores per dimension          |
      | Display calibration results                       |
    And I should see adherence report:
      | dimension       | target | actual | adherence |
      | tragedy_level   | 0.8    | 0.75   | 94%       |
      | hope_index      | 0.2    | 0.25   | 88%       |
      | chaos_factor    | 0.6    | 0.55   | 92%       |
    And the system should suggest parameter adjustments if needed

  @integration @ai_effects @consistency
  Scenario: Ensure dimensional consistency across sessions
    Given my world has been running for multiple player sessions
    When I review content consistency metrics
    Then I should see dimension adherence over time:
      | time_period | tragedy_adherence | hope_adherence | overall |
      | Week 1      | 92%               | 88%            | 90%     |
      | Week 2      | 94%               | 91%            | 92%     |
      | Week 3      | 93%               | 90%            | 91%     |
    And any drift should be flagged for attention
    And I should see trending direction for each dimension

  # ============================================
  # VALIDATION AND ERROR SCENARIOS
  # ============================================

  @domain @validation @error
  Scenario Outline: Reject invalid dimension values
    Given I am configuring dimension <dimension>
    When I attempt to set the value to <invalid_value>
    Then the system should reject the configuration
    And display error "<error_message>"
    And the dimension should retain its previous value
    And the slider should snap back to the valid range

    Examples:
      | dimension       | invalid_value | error_message                              |
      | tragedy_level   | -0.1          | Dimension value must be between 0.0 and 1.0 |
      | tragedy_level   | 1.5           | Dimension value must be between 0.0 and 1.0 |
      | chaos_factor    | NaN           | Dimension value must be a valid number      |
      | hope_index      | null          | Dimension value is required                 |
      | mystery_depth   | "high"        | Dimension value must be numeric             |

  @domain @validation @boundary
  Scenario Outline: Accept valid boundary dimension values
    Given I am configuring dimension <dimension>
    When I set the value to <boundary_value>
    Then the system should accept the configuration
    And the dimension should be set to <boundary_value>
    And no validation errors should be displayed

    Examples:
      | dimension       | boundary_value |
      | tragedy_level   | 0.0            |
      | tragedy_level   | 1.0            |
      | chaos_factor    | 0.5            |
      | hope_index      | 0.001          |
      | hope_index      | 0.999          |
      | mystery_depth   | 0.0            |
      | humor_presence  | 1.0            |

  @domain @era_vector @error
  Scenario: Reject invalid era selection
    Given I am configuring the era vector
    When I attempt to set base_era to "INVALID_ERA"
    Then the system should reject the configuration
    And display error:
      | message | Invalid era: must be one of PREHISTORIC, ANCIENT, MEDIEVAL, RENAISSANCE, INDUSTRIAL, MODERN, FUTURISTIC, CUSTOM |
    And suggest valid era options in a dropdown

  @domain @authorization @error
  Scenario: Non-curator cannot modify dimensions
    Given I am authenticated as a world viewer with read-only access
    When I attempt to access dimension modification controls
    Then all controls should be disabled
    And I should see message "View Only - World Curator role required to edit"
    When I attempt to modify dimensions via API
    Then the response status should be 403
    And the response should contain error "Insufficient permissions: World Curator role required"

  @domain @authorization @readonly
  Scenario: Curator views launched world dimensions in read-only mode
    Given I am authenticated as a world curator
    And my world "Mystic Realms" has been launched
    When I access the dimensional configuration interface
    Then I should see all dimension values displayed
    And all values should be in read-only mode
    And modification controls should be disabled
    And I should see "Create New Version" button to modify dimensions

  @domain @concurrent @error
  Scenario: Handle concurrent dimension modifications
    Given curator Alice has loaded the dimension configuration
    And curator Bob has also loaded the same configuration
    When Alice saves changes to tragedy_level = 0.8 at timestamp T1
    And Bob attempts to save tragedy_level = 0.3 at timestamp T2
    Then Bob should receive error:
      | code    | CONCURRENT_MODIFICATION                        |
      | message | Dimension configuration has been modified by another user |
      | modified_by | Alice                                      |
      | modified_at | T1                                         |
    And Bob should see option to refresh and retry
    And Alice's changes (0.8) should be preserved

  @domain @concurrent
  Scenario: Resolve concurrent modification conflict
    Given I received a concurrent modification error
    When I click "Refresh and Review"
    Then I should see the current configuration (Alice's changes)
    And my intended changes should be shown in a comparison view
    And I should be able to:
      | option                | description                          |
      | Keep current          | Accept Alice's values                |
      | Apply my changes      | Overwrite with my values             |
      | Merge manually        | Choose value-by-value                |

  @domain @conflicts @warning
  Scenario: Warn about conflicting dimension combinations
    Given I am configuring dimensions
    When I set values that create narrative tension:
      | dimension     | value |
      | hope_index    | 0.9   |
      | tragedy_level | 0.9   |
    Then the system should display a warning:
      | type    | warning                                                    |
      | message | High hope and high tragedy may create inconsistent narrative tone |
      | suggestion | Consider reducing one dimension for more coherent storytelling |
    And I should be able to proceed anyway by acknowledging the warning
    And proceeding should log the acknowledged conflict

  @domain @conflicts @warning
  Scenario: Warn about extreme dimension values
    Given I am configuring dimensions
    When I set an extreme value:
      | dimension       | value |
      | chaos_factor    | 1.0   |
    Then the system should display a warning:
      | message | Maximum chaos may result in unpredictable and potentially frustrating gameplay |
    And suggest recommended range of 0.3-0.7 for most experiences

  # ============================================
  # HISTORY AND AUDIT
  # ============================================

  @domain @history @audit
  Scenario: View dimension configuration history
    Given I have modified dimensions multiple times over the past month
    When I view the dimension configuration history
    Then I should see a chronological list of changes:
      | timestamp           | actor  | dimension       | previous | new   | action |
      | 2024-02-19 10:30:00 | Alice  | tragedy_level   | 0.5      | 0.8   | update |
      | 2024-02-18 14:15:00 | Alice  | preset          | default  | noir  | apply  |
      | 2024-02-15 09:00:00 | Bob    | hope_index      | 0.6      | 0.3   | update |
    And I should be able to filter by:
      | filter    | options                        |
      | date_range| Custom date picker             |
      | dimension | Dropdown of all dimensions     |
      | actor     | Dropdown of curators           |
      | action    | update, apply_preset, reset, revert |
    And history entries should be paginated

  @domain @history @audit
  Scenario: View detailed change entry
    Given I am viewing dimension history
    When I click on a specific history entry
    Then I should see detailed information:
      | field           | value                          |
      | timestamp       | 2024-02-19 10:30:00 UTC        |
      | actor           | Alice (alice@example.com)      |
      | action          | Dimension Value Update         |
      | dimension       | tragedy_level                  |
      | previous_value  | 0.5                            |
      | new_value       | 0.8                            |
      | ip_address      | 192.168.1.100                  |
      | user_agent      | Chrome/120                     |
    And I should see option to revert to this configuration

  @domain @history @revert
  Scenario: Revert to previous configuration
    Given I have dimension history with multiple changes
    And my world is in curation phase
    When I select a historical configuration from 2024-02-15 to revert to
    Then the system should display confirmation:
      | message | Revert all dimensions to configuration from 2024-02-15? |
      | changes | Lists all dimension values that will change             |
    And upon confirming:
      | action                                          |
      | All dimensions should be restored to that point |
      | A new history entry should be created           |
      | Entry should be marked as "Revert"              |
    And domain event DimensionConfigurationReverted should be published

  @domain @history @revert @error
  Scenario: Cannot revert dimensions on launched world
    Given my world has been launched
    When I attempt to revert to a previous configuration
    Then the system should display error:
      | message | Cannot revert dimensions on a launched world |
      | suggestion | Create a new version to use historical configuration |
    And the revert should not occur

  @domain @history @compare
  Scenario: Compare dimension configurations across time
    Given I have multiple historical configurations
    When I select two configurations to compare:
      | config_a | 2024-02-01 Configuration |
      | config_b | 2024-02-19 Configuration |
    Then the system should display a diff view:
      | dimension       | config_a | config_b | change |
      | tragedy_level   | 0.5      | 0.8      | +0.3   |
      | hope_index      | 0.6      | 0.3      | -0.3   |
      | chaos_factor    | 0.3      | 0.3      | none   |
    And changed dimensions should be highlighted
    And I should see the time difference between configurations

  @domain @history @export
  Scenario: Export dimension history for audit
    Given I need to export dimension history for compliance
    When I export history with parameters:
      | start_date | 2024-01-01 |
      | end_date   | 2024-02-28 |
      | format     | CSV        |
    Then the system should generate an export file
    And the file should include all history entries in the date range
    And the file should be downloadable

  # ============================================
  # RESET AND DEFAULTS
  # ============================================

  @domain @defaults @reset
  Scenario: Reset all dimensions to defaults
    Given I have customized multiple dimensions:
      | dimension       | current_value |
      | tragedy_level   | 0.9           |
      | hope_index      | 0.1           |
      | chaos_factor    | 0.8           |
    When I choose to reset all dimensions to defaults
    Then the system should display confirmation:
      | message | Reset all dimensions to default values? |
      | warning | This will overwrite your current customizations |
    And upon confirmation, all dimensions should return to defaults:
      | dimension       | default_value |
      | tragedy_level   | 0.5           |
      | hope_index      | 0.6           |
      | chaos_factor    | 0.3           |
    And domain event DimensionsResetToDefaults should be published
    And history should record the reset action

  @domain @defaults @partial
  Scenario: Reset single dimension to default
    Given I have customized tragedy_level to 0.9
    When I click "Reset to Default" on tragedy_level
    Then only tragedy_level should return to its default value of 0.5
    And other dimensions should remain unchanged
    And a focused reset should be recorded in history

  @domain @defaults @preset
  Scenario: Reset to applied preset values
    Given I have applied the "noir_mystery" preset
    And I have made customizations on top of the preset
    When I click "Reset to Preset"
    Then all dimensions should return to noir_mystery preset values
    And my customizations should be cleared
    And the configuration should be marked as "noir_mystery (unmodified)"

  # ============================================
  # IMPORT AND EXPORT
  # ============================================

  @domain @export
  Scenario: Export complete dimension configuration
    Given my world has a complete dimension configuration
    When I export the configuration
    Then the system should generate a JSON file containing:
      | field           | description                           |
      | dimensions      | All dimension name-value pairs        |
      | era_vector      | Complete era configuration            |
      | canon_fidelity  | All fidelity parameters               |
      | presets_applied | List of presets that were used        |
      | custom_translations | Any translation overrides          |
      | metadata        | Version, export timestamp, world info |
    And the file should be named "{world_name}_dimensions_{timestamp}.json"
    And the export should be downloadable

  @domain @export @format
  Scenario: Export configuration in different formats
    Given I am exporting dimension configuration
    When I select export format
    Then I should have options:
      | format | description                  |
      | JSON   | Machine-readable format      |
      | YAML   | Human-readable format        |
      | CSV    | Spreadsheet-compatible       |
    And each format should contain the same data

  @domain @import
  Scenario: Import valid dimension configuration
    Given I have a valid dimension configuration JSON file
    And my world is in curation phase
    When I import the configuration
    Then the system should:
      | step                                         |
      | Parse and validate the JSON file             |
      | Check all dimension values are in valid range |
      | Check era vector is valid                    |
      | Check canon fidelity values are valid        |
    And upon passing validation, apply the configuration
    And record the import in dimension history
    And domain event DimensionConfigurationImported should be published

  @domain @import @preview
  Scenario: Preview import before applying
    Given I have selected a configuration file to import
    When the file is validated successfully
    Then I should see an import preview:
      | current_dimension | current_value | import_value | change |
      | tragedy_level     | 0.5           | 0.8          | +0.3   |
      | hope_index        | 0.6           | 0.2          | -0.4   |
    And I should see "Apply Import" and "Cancel" buttons
    And I should be able to review before committing

  @domain @import @error
  Scenario: Reject invalid import file format
    Given I have a file that is not valid JSON
    When I attempt to import the configuration
    Then the system should display error:
      | error | Invalid file format: expected JSON |
    And no dimensions should be modified

  @domain @import @error
  Scenario: Reject import with invalid dimension values
    Given I have a JSON file with invalid dimension values:
      """json
      {
        "dimensions": {
          "tragedy_level": 1.5,
          "hope_index": -0.2
        }
      }
      """
    When I attempt to import the configuration
    Then the system should validate and reject with specific errors:
      | field         | error                                   |
      | tragedy_level | Value 1.5 exceeds maximum of 1.0        |
      | hope_index    | Value -0.2 is below minimum of 0.0      |
    And no dimensions should be modified
    And I should see which fields failed validation

  @domain @import @partial
  Scenario: Import partial configuration (merge mode)
    Given I have a JSON file with only some dimensions:
      """json
      {
        "dimensions": {
          "tragedy_level": 0.7
        }
      }
      """
    When I import with merge option enabled
    Then only specified dimensions should be updated
    And unspecified dimensions should retain current values
    And import should be recorded with merge flag

  # ============================================
  # API SCENARIOS
  # ============================================

  @api @dimensions @get
  Scenario: Get complete dimensions via API
    Given I have a valid API token with curator permissions
    And world "mystic-realms" exists
    When I send a GET request to "/api/v1/worlds/mystic-realms/dimensions"
    Then the response status should be 200
    And the response should contain:
      """json
      {
        "dimensions": {
          "tragedy_level": 0.5,
          "chaos_factor": 0.3,
          "romance_intensity": 0.5,
          "verisimilitude": 0.5,
          "hope_index": 0.6,
          "violence_graphicness": 0.4,
          "mystery_depth": 0.5,
          "humor_presence": 0.3
        },
        "era_vector": {...},
        "canon_fidelity": {...},
        "locked": false,
        "last_modified": "2024-02-19T10:30:00Z"
      }
      """

  @api @dimensions @put
  Scenario: Update all dimensions via API
    Given I have a valid API token with curator permissions
    And world "mystic-realms" is in curation phase
    When I send a PUT request to "/api/v1/worlds/mystic-realms/dimensions" with:
      """json
      {
        "dimensions": {
          "tragedy_level": 0.8,
          "hope_index": 0.2,
          "chaos_factor": 0.6
        }
      }
      """
    Then the response status should be 200
    And the response should contain the updated configuration
    And dimension history should record the API update

  @api @dimensions @patch
  Scenario: Patch single dimension via API
    Given I have a valid API token with curator permissions
    When I send a PATCH request to "/api/v1/worlds/mystic-realms/dimensions" with:
      """json
      {
        "tragedy_level": 0.7
      }
      """
    Then the response status should be 200
    And only tragedy_level should be updated to 0.7
    And other dimensions should remain unchanged

  @api @dimensions @error
  Scenario: API rejects invalid dimension updates
    Given I have a valid API token with curator permissions
    When I send a PUT request with invalid values:
      """json
      {
        "dimensions": {
          "tragedy_level": 2.0
        }
      }
      """
    Then the response status should be 400
    And the response should contain:
      """json
      {
        "error": "VALIDATION_ERROR",
        "message": "Invalid dimension value",
        "details": {
          "tragedy_level": "Value 2.0 exceeds maximum of 1.0"
        }
      }
      """
    And no dimensions should be modified

  @api @dimensions @locked
  Scenario: API rejects updates on launched world
    Given I have a valid API token with curator permissions
    And world "mystic-realms" has been launched
    When I send a PUT request to update dimensions
    Then the response status should be 403
    And the response should contain:
      """json
      {
        "error": "DIMENSIONS_LOCKED",
        "message": "Cannot modify dimensions after world launch"
      }
      """

  @api @presets @get
  Scenario: List all presets via API
    Given I have a valid API token
    When I send a GET request to "/api/v1/dimensions/presets"
    Then the response status should be 200
    And the response should contain:
      | category | description                |
      | system   | Built-in presets           |
      | custom   | User-created presets       |
      | community| Shared community presets   |
    And each preset should include full dimension values

  @api @presets @apply
  Scenario: Apply preset via API
    Given I have a valid API token with curator permissions
    When I send a POST request to "/api/v1/worlds/mystic-realms/dimensions/presets/noir_mystery/apply"
    Then the response status should be 200
    And all dimensions should be updated to preset values
    And the response should include the applied configuration

  @api @history @get
  Scenario: Get dimension history via API
    Given I have a valid API token with curator permissions
    When I send a GET request to "/api/v1/worlds/mystic-realms/dimensions/history?limit=10"
    Then the response status should be 200
    And the response should contain paginated history entries
    And each entry should include:
      | field     | description                 |
      | timestamp | When change occurred        |
      | actor     | User who made change        |
      | action    | Type of change              |
      | changes   | What dimensions changed     |

  @api @era_vector @get
  Scenario: Get era vector configuration via API
    Given I have a valid API token with curator permissions
    When I send a GET request to "/api/v1/worlds/mystic-realms/dimensions/era-vector"
    Then the response status should be 200
    And the response should contain complete era vector configuration

  @api @era_vector @put
  Scenario: Update era vector via API
    Given I have a valid API token with curator permissions
    When I send a PUT request to "/api/v1/worlds/mystic-realms/dimensions/era-vector" with:
      """json
      {
        "base_era": "MEDIEVAL",
        "technology_level": 0.3,
        "magical_presence": 0.7,
        "cultural_complexity": 0.5
      }
      """
    Then the response status should be 200
    And the era vector should be updated
    And translation catalog should be regenerated

  @api @translations @get
  Scenario: Get translation catalog via API
    Given I have a valid API token with curator permissions
    When I send a GET request to "/api/v1/worlds/mystic-realms/dimensions/translations"
    Then the response status should be 200
    And the response should contain all translations with categories

  @api @translations @override
  Scenario: Add translation override via API
    Given I have a valid API token with curator permissions
    When I send a POST request to "/api/v1/worlds/mystic-realms/dimensions/translations/overrides" with:
      """json
      {
        "canonical_item": "sword",
        "custom_translation": "enchanted claymore"
      }
      """
    Then the response status should be 201
    And the custom translation should be saved

  # ============================================
  # DOMAIN EVENTS
  # ============================================

  @domain-events
  Scenario: DimensionValueChanged event structure
    Given I am saving a dimension value change
    When the change is persisted
    Then the system should publish DimensionValueChanged event with:
      | field          | type      | description                |
      | event_id       | UUID      | Unique event identifier    |
      | world_id       | string    | The affected world         |
      | dimension_name | string    | Which dimension changed    |
      | old_value      | float     | Previous value             |
      | new_value      | float     | New value                  |
      | changed_by     | string    | User who made the change   |
      | timestamp      | datetime  | When the change occurred   |
      | correlation_id | UUID      | For tracing related events |

  @domain-events
  Scenario: EraVectorConfigured event triggers translation generation
    Given I have configured the era vector
    When EraVectorConfigured event is published
    Then the translation service should:
      | action                                      |
      | Receive the event                           |
      | Generate translation catalog for the era    |
      | Index translations for quick lookup         |
      | Publish TranslationCatalogGenerated event   |

  @domain-events
  Scenario: PresetApplied event with customization tracking
    Given I have applied and customized a preset
    When PresetApplied event is published
    Then the event should contain:
      | field        | value                            |
      | world_id     | mystic-realms                    |
      | preset_id    | noir_mystery                     |
      | preset_name  | Noir Mystery                     |
      | overrides    | List of customized dimensions    |
      | override_count| Number of dimensions customized |

  @domain-events
  Scenario: Dimension changes propagate to story engine
    Given dimensions have been updated
    When DimensionValueChanged event is published
    Then the story generation engine should:
      | action                                         |
      | Receive the dimension change event             |
      | Recalibrate narrative parameters               |
      | Update AI generation prompts                   |
      | Invalidate cached generation contexts          |
      | Publish NarrativeParametersUpdated event       |

  @domain-events
  Scenario: CanonDivergenceOccurred event structure
    Given a player has caused a canon divergence
    When the divergence is recorded
    Then the system should publish CanonDivergenceOccurred event with:
      | field              | description                        |
      | world_id           | The world where divergence occurred|
      | divergence_point   | Story beat ID that diverged        |
      | canonical_outcome  | What should have happened          |
      | actual_outcome     | What actually happened             |
      | player_id          | Player who caused divergence       |
      | fidelity_setting   | The plot_fidelity value at time    |
      | probability_roll   | The random value that allowed it   |

  @domain-events
  Scenario: Batch update publishes single aggregate event
    Given I am updating multiple dimensions at once
    When all updates are saved successfully
    Then a single DimensionalConfigurationBatchUpdated event should be published
    And individual DimensionValueChanged events should NOT be published
    And the batch event should contain all changes

  # ============================================
  # ERROR HANDLING
  # ============================================

  @api @error
  Scenario: Handle database connection failure
    Given the database is temporarily unavailable
    When I attempt to save dimension configuration
    Then the response status should be 503
    And the response should contain:
      | error   | SERVICE_UNAVAILABLE                      |
      | message | Unable to save configuration. Please retry. |
      | retry_after | 30                                    |
    And the error should be logged for monitoring

  @api @error
  Scenario: Handle invalid world ID
    Given I send a request with invalid world ID
    When I send a GET request to "/api/v1/worlds/invalid-id-!@#/dimensions"
    Then the response status should be 400
    And the response should contain error "Invalid world ID format"

  @api @error
  Scenario: Handle world not found
    Given world "non-existent-world" does not exist
    When I send a GET request to "/api/v1/worlds/non-existent-world/dimensions"
    Then the response status should be 404
    And the response should contain error "World not found"

  @api @error
  Scenario: Handle rate limiting on dimension updates
    Given I have exceeded the rate limit for dimension updates
    When I attempt another update
    Then the response status should be 429
    And the response should contain:
      | error       | RATE_LIMIT_EXCEEDED                    |
      | message     | Too many dimension updates. Please wait. |
      | retry_after | 60                                     |
