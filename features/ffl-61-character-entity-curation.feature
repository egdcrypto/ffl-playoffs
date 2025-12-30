@curation @character-entity @mvp-curation
Feature: Character Entity Curation
  As a world owner
  I want to curate extracted characters from my narrative
  So that I can ensure characters are properly configured for my playable world

  Background:
    Given I am logged in as a world owner
    And I have uploaded "Romeo and Juliet" narrative
    And the system has extracted character entities

  # =============================================================================
  # REVIEW EXTRACTED CHARACTERS
  # =============================================================================

  @review @list
  Scenario: View list of extracted characters
    When I navigate to the character curation dashboard
    Then I should see a list of all extracted characters
    And each character should display:
      | Field               | Description                      |
      | Name                | Character name                   |
      | Status              | Pending/Approved/Rejected        |
      | Confidence score    | Extraction confidence level      |
      | Appearances         | Number of narrative appearances  |
      | Relationships count | Number of relationships          |
      | Completeness        | Data completeness percentage     |
    And I should be able to filter by status
    And I should be able to sort by any column

  @review @details
  Scenario: View character details
    Given character "Romeo" has been extracted
    When I view the details for "Romeo"
    Then I should see comprehensive character information:
      | Section             | Content                          |
      | Basic info          | Name, aliases, description       |
      | Personality traits  | Extracted personality attributes |
      | Relationships       | Connections to other characters  |
      | Key quotes          | Notable dialogue from narrative  |
      | Narrative context   | Where character appears          |
      | Extraction metadata | Confidence scores, sources       |
    And I should see the original text excerpts
    And I should be able to edit any section

  @review @confidence
  Scenario: View extraction confidence breakdown
    Given character "Romeo" has been extracted
    When I view the extraction confidence details
    Then I should see confidence scores for:
      | Attribute           | Confidence Score |
      | Name identification | High             |
      | Personality traits  | Medium           |
      | Relationships       | High             |
      | Background story    | Low              |
      | Speech patterns     | Medium           |
    And I should see the source text for each attribute
    And low confidence items should be highlighted for review

  @review @excerpts
  Scenario: View source narrative excerpts for character
    Given character "Juliet" has been extracted
    When I view the source excerpts for "Juliet"
    Then I should see all narrative passages mentioning "Juliet"
    And excerpts should be organized by:
      | Organization        | Description                      |
      | Chronological       | Order of appearance              |
      | By attribute        | Grouped by what they reveal      |
      | By confidence       | Sorted by extraction confidence  |
    And I should be able to navigate to full context

  # =============================================================================
  # CHARACTER APPROVAL WORKFLOW
  # =============================================================================

  @approval @approve
  Scenario: Approve a character
    Given character "Romeo" is in pending status
    When I review the character details
    And I approve the character
    Then the character status should change to "Approved"
    And the character should be added to the approved characters list
    And an approval event should be logged
    And the character should be available for world deployment

  @approval @reject
  Scenario: Reject a character
    Given character "Servant #3" is in pending status
    And the character has low extraction confidence
    When I review the character details
    And I reject the character with reason "Minor character, insufficient data"
    Then the character status should change to "Rejected"
    And the rejection reason should be recorded
    And the character should not be available for world deployment
    And I should be able to restore the character if needed

  @approval @defer
  Scenario: Defer character review
    Given character "Friar Laurence" is in pending status
    When I defer the character review with note "Need to verify relationships"
    Then the character status should change to "Deferred"
    And a reminder should be scheduled
    And the character should appear in the deferred queue

  @approval @bulk
  Scenario: Bulk approve multiple characters
    Given multiple characters are in pending status
    When I select multiple characters for bulk approval
    And I approve all selected characters
    Then all selected characters should change to "Approved" status
    And a bulk approval event should be logged
    And I should see a summary of approved characters

  # =============================================================================
  # CHARACTER EDITING
  # =============================================================================

  @edit @personality
  Scenario: Edit character personality traits
    Given character "Romeo" has been extracted with personality traits
    When I edit the personality traits for "Romeo"
    Then I should be able to:
      | Action              | Description                      |
      | Add trait           | Add new personality trait        |
      | Remove trait        | Remove existing trait            |
      | Modify trait        | Change trait description         |
      | Adjust intensity    | Set trait strength (1-10)        |
      | Add contradiction   | Define conflicting traits        |
    And I should see trait suggestions based on narrative
    And changes should be tracked in edit history

  @edit @relationships
  Scenario: Update character relationships
    Given character "Romeo" has relationships extracted
    When I update the relationships for "Romeo"
    Then I should be able to:
      | Action              | Description                      |
      | Add relationship    | Create new relationship          |
      | Remove relationship | Delete existing relationship     |
      | Modify type         | Change relationship type         |
      | Set direction       | Define one-way or mutual         |
      | Add context         | Describe relationship dynamics   |
    And relationship types should include:
      | Type                | Description                      |
      | Family              | Blood or marriage relation       |
      | Romantic            | Love interest                    |
      | Friend              | Friendship                       |
      | Enemy               | Antagonistic relationship        |
      | Mentor              | Teacher/student                  |
      | Ally                | Cooperative relationship         |
    And I should see a relationship graph visualization

  @edit @background
  Scenario: Edit character background story
    Given character "Juliet" has been extracted
    When I edit the background story for "Juliet"
    Then I should be able to modify:
      | Field               | Description                      |
      | Origin              | Where character is from          |
      | History             | Character's past                 |
      | Motivations         | What drives the character        |
      | Goals               | Character objectives             |
      | Fears               | What character fears             |
      | Secrets             | Hidden aspects                   |
    And I should see suggestions from narrative analysis
    And I should be able to mark fields as canonical or inferred

  @edit @dialogue
  Scenario: Edit character speech patterns
    Given character "Mercutio" has been extracted
    When I edit the speech patterns for "Mercutio"
    Then I should be able to configure:
      | Pattern             | Description                      |
      | Vocabulary level    | Simple to sophisticated          |
      | Tone                | Formal, casual, poetic, etc.     |
      | Speech quirks       | Unique verbal habits             |
      | Catchphrases        | Repeated phrases                 |
      | Emotional range     | How emotions affect speech       |
    And I should see example dialogue from narrative
    And I should be able to test speech generation

  @edit @appearance
  Scenario: Edit character physical description
    Given character "Tybalt" has been extracted
    When I edit the physical description for "Tybalt"
    Then I should be able to specify:
      | Attribute           | Description                      |
      | Age                 | Character age or range           |
      | Physical build      | Body type and stature            |
      | Distinctive features| Notable physical traits          |
      | Typical attire      | Clothing style                   |
      | Mannerisms          | Physical behaviors               |
    And I should see extracted descriptions from narrative
    And I should be able to generate character portrait

  # =============================================================================
  # DUPLICATE DETECTION
  # =============================================================================

  @duplicate @identify
  Scenario: Identify duplicate characters
    Given the system has extracted multiple characters
    When I run duplicate detection analysis
    Then I should see potential duplicates grouped:
      | Duplicate Type      | Example                          |
      | Exact match         | "Romeo" and "Romeo"              |
      | Case variant        | "ROMEO" and "Romeo"              |
      | Alias               | "Romeo Montague" and "Romeo"     |
      | Phonetic similar    | "Juliet" and "Juliette"          |
      | Reference           | "The Prince" and "Prince Escalus"|
    And each group should show confidence score
    And I should be able to review each potential duplicate

  @duplicate @case-sensitive
  Scenario: Detect case-sensitive name duplicates
    Given character "ROMEO" and character "Romeo" both exist
    When the system analyzes for duplicates
    Then the system should flag case-sensitive duplicates
    And I should see both entries highlighted
    And I should be presented with merge options

  @duplicate @phonetic
  Scenario: Identify phonetically similar names
    Given character "Juliet" and character "Juliette" both exist
    When the system analyzes for phonetic duplicates
    Then the system should flag phonetically similar names
    And I should see similarity score
    And I should be able to confirm or dismiss as duplicate

  @duplicate @merge
  Scenario: Merge duplicate character entries
    Given "Romeo Montague" and "Romeo" are identified as duplicates
    When I choose to merge these characters
    Then I should be able to:
      | Merge Action        | Description                      |
      | Select primary      | Choose which name to keep        |
      | Combine traits      | Merge personality traits         |
      | Merge relationships | Consolidate relationships        |
      | Combine quotes      | Merge notable dialogue           |
      | Preserve aliases    | Keep alternate names             |
    And the merge should be reversible
    And merge history should be tracked

  @duplicate @split
  Scenario: Split incorrectly merged character
    Given "Capulet" and "Lady Capulet" were incorrectly merged
    When I split the merged character
    Then I should be able to:
      | Split Action        | Description                      |
      | Define characters   | Name each split character        |
      | Assign attributes   | Distribute traits appropriately  |
      | Divide relationships| Assign relationships correctly   |
      | Allocate quotes     | Assign dialogue to each          |
    And the original merge should be preserved in history

  # =============================================================================
  # VALIDATION AND COMPLETENESS
  # =============================================================================

  @validation @completeness
  Scenario: Validate character completeness
    Given character "Romeo" is being reviewed
    When I run completeness validation
    Then I should see completeness scores for:
      | Category            | Required Fields                  |
      | Basic identity      | Name, description                |
      | Personality         | At least 3 traits                |
      | Relationships       | At least 1 relationship          |
      | Background          | Origin or history                |
      | Speech patterns     | Tone and vocabulary level        |
    And missing required fields should be highlighted
    And I should see recommendations for improvement

  @validation @conflicts
  Scenario: Detect character conflicts
    Given character "Romeo" has been edited
    When I run conflict detection
    Then I should see any conflicting information:
      | Conflict Type       | Example                          |
      | Trait contradiction | "Brave" and "Cowardly"           |
      | Relationship loop   | A loves B, B loves C, C loves A  |
      | Timeline issue      | Events out of order              |
      | Inconsistent age    | Age references don't match       |
    And I should be able to resolve each conflict
    And resolutions should be documented

  @validation @behavior
  Scenario: Validate character behavior consistency
    Given character "Romeo" has personality traits defined
    When I validate behavior consistency
    Then the system should check:
      | Consistency Check   | Validation                       |
      | Trait-action match  | Actions align with traits        |
      | Relationship logic  | Relationships make sense         |
      | Motivation clarity  | Goals support behaviors          |
      | Response patterns   | Reactions are consistent         |
    And inconsistencies should be flagged
    And I should be able to adjust as needed

  @validation @narrative
  Scenario: Validate character against narrative
    Given character "Juliet" has been modified
    When I validate against the original narrative
    Then I should see:
      | Validation Result   | Description                      |
      | Canonical matches   | Edits that align with narrative  |
      | Creative additions  | New content not in narrative     |
      | Contradictions      | Edits that contradict narrative  |
    And I should be able to justify creative additions
    And contradictions should require explanation

  # =============================================================================
  # CHARACTER TESTING
  # =============================================================================

  @testing @conversation
  Scenario: Test basic character conversation
    Given character "Romeo" is approved
    When I initiate a test conversation with "Romeo"
    Then I should be able to:
      | Test Action         | Description                      |
      | Ask questions       | Query character about themselves |
      | Test reactions      | Present scenarios for response   |
      | Check personality   | Verify trait expression          |
      | Test relationships  | Ask about other characters       |
    And responses should reflect configured traits
    And I should be able to rate response quality

  @testing @memory
  Scenario: Test character memory retention
    Given character "Juliet" is approved
    When I test memory retention
    Then I should verify:
      | Memory Type         | Test                             |
      | Relationship recall | Remembers other characters       |
      | Event recall        | Remembers narrative events       |
      | Personal history    | Recalls own background           |
      | Conversation memory | Remembers current conversation   |
    And memory gaps should be identified
    And I should be able to adjust memory configuration

  @testing @personality
  Scenario: Test character personality consistency
    Given character "Mercutio" is approved
    When I run personality consistency tests
    Then the system should:
      | Test Type           | Validation                       |
      | Trait expression    | Traits appear in responses       |
      | Emotional range     | Appropriate emotional responses  |
      | Speech style        | Consistent vocabulary and tone   |
      | Decision making     | Choices align with character     |
    And I should see a consistency score
    And inconsistent responses should be logged

  @testing @scenario
  Scenario: Test character in scenario situations
    Given character "Romeo" is approved
    When I run scenario-based testing
    Then I should be able to test scenarios:
      | Scenario Type       | Example                          |
      | Meeting new person  | Introduction behavior            |
      | Conflict situation  | Response to confrontation        |
      | Emotional moment    | Handling sad or happy news       |
      | Decision point      | Making a difficult choice        |
    And responses should be evaluated for appropriateness
    And I should be able to save scenario test results

  @testing @interaction
  Scenario: Test character-to-character interaction
    Given characters "Romeo" and "Juliet" are approved
    When I simulate interaction between them
    Then I should see:
      | Interaction Aspect  | Validation                       |
      | Relationship dynamic| Reflects configured relationship |
      | Dialogue quality    | Natural conversation flow        |
      | Emotional tone      | Appropriate for relationship     |
      | Memory continuity   | Consistent references            |
    And I should be able to adjust relationship parameters
    And interaction logs should be saved

  # =============================================================================
  # CURATION WORKFLOW
  # =============================================================================

  @workflow @checklist
  Scenario: Complete character curation checklist
    Given character "Romeo" is in review
    When I access the curation checklist
    Then I should see checklist items:
      | Checklist Item        | Status                           |
      | Basic info complete   | Required fields filled           |
      | Personality defined   | Minimum traits configured        |
      | Relationships mapped  | Connections established          |
      | Conflicts resolved    | No contradictions                |
      | Duplicates checked    | No duplicate entries             |
      | Conversation tested   | Basic test completed             |
      | Personality validated | Consistency score acceptable     |
    And all items must be complete to approve
    And I should see overall readiness score

  @workflow @lock
  Scenario: Lock character for world deployment
    Given character "Romeo" has passed all validation
    When I lock the character for deployment
    Then the character should be marked as "Locked"
    And no further edits should be allowed without unlocking
    And the character should be ready for world deployment
    And lock event should be logged with timestamp

  @workflow @unlock
  Scenario: Unlock character for further editing
    Given character "Juliet" is locked
    When I unlock the character for editing
    Then I should provide an unlock reason
    And the character should return to "Approved" status
    And previous lock status should be recorded
    And I should be able to make edits

  @workflow @batch
  Scenario: Batch process character curation
    Given multiple characters are pending curation
    When I initiate batch curation
    Then I should be able to:
      | Batch Action        | Description                      |
      | Bulk validate       | Run validation on all            |
      | Bulk test           | Run basic tests on all           |
      | Bulk approve        | Approve multiple at once         |
      | Bulk lock           | Lock all approved characters     |
    And I should see batch processing progress
    And I should receive a summary report

  # =============================================================================
  # HISTORY AND AUDIT
  # =============================================================================

  @history @changes
  Scenario: View character edit history
    Given character "Romeo" has been edited multiple times
    When I view the edit history
    Then I should see all changes with:
      | Field               | Information                      |
      | Timestamp           | When change was made             |
      | User                | Who made the change              |
      | Field changed       | What was modified                |
      | Previous value      | Value before change              |
      | New value           | Value after change               |
      | Reason              | Why change was made              |
    And I should be able to revert to any previous state
    And I should be able to compare versions

  @history @revert
  Scenario: Revert character to previous version
    Given character "Juliet" has edit history
    When I select a previous version to revert to
    Then I should see a comparison of current vs selected version
    And I should confirm the revert action
    And the character should be restored to the selected version
    And revert action should be logged

  # =============================================================================
  # EXPORT AND IMPORT
  # =============================================================================

  @export @character
  Scenario: Export character configuration
    Given character "Romeo" is approved
    When I export the character
    Then I should receive a complete character definition including:
      | Export Section      | Content                          |
      | Basic info          | Name, aliases, description       |
      | Personality         | All traits and intensities       |
      | Relationships       | All relationships defined        |
      | Background          | History and motivations          |
      | Speech patterns     | Dialogue configuration           |
      | Metadata            | Creation and approval info       |
    And export should be in standard format
    And I should be able to import into another world

  @import @character
  Scenario: Import character configuration
    Given I have a character export file
    When I import the character to my world
    Then the character should be created with imported data
    And relationships should be linked if targets exist
    And import should be validated
    And I should be able to review before finalizing

  # =============================================================================
  # ERROR CASES
  # =============================================================================

  @error @permission-denied
  Scenario: Handle insufficient curation permissions
    Given I do not have character curation permissions
    When I attempt to edit a character
    Then I should see an "Access Denied" error
    And I should see the required permissions
    And the access attempt should be logged

  @error @locked-character
  Scenario: Handle edit attempt on locked character
    Given character "Romeo" is locked for deployment
    When I attempt to edit the character
    Then I should see a "Character Locked" error
    And I should see who locked the character
    And I should see the unlock request option

  @error @validation-failed
  Scenario: Handle validation failure during approval
    Given character "Mercutio" has incomplete data
    When I attempt to approve the character
    Then approval should be blocked
    And I should see the validation errors
    And I should see which fields need completion

  @error @merge-conflict
  Scenario: Handle merge conflict during duplicate resolution
    Given two characters have conflicting data
    When I attempt to merge them
    Then I should see the conflicting fields highlighted
    And I should be required to resolve each conflict
    And I should confirm the final merged state

  @error @test-failure
  Scenario: Handle character test failure
    Given character "Tybalt" is ready for testing
    When character testing reveals inconsistencies
    Then test results should show failures
    And I should see specific issues identified
    And the character should be flagged for review
    And I should not be able to lock until resolved
