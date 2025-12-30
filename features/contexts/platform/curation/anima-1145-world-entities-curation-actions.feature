@ANIMA-1145
Feature: World Entities Curation Actions

As a world creator
I want to perform bulk curation actions on entities at the world level
So that I can efficiently manage entities across all documents
Background:
Given I am authenticated as a user
And a world exists with id "curation-test-world"
And the world contains multiple extracted entities
- Scenario: Bulk approve entities by type
- Scenario: Bulk reject entities with reason
- Scenario: Merge duplicate entities across documents
- Scenario: Auto-approve high confidence entities
- Scenario: Set entity curation rules
- Scenario: Export curated entities for game import
- Scenario: Review entity extraction quality
- Scenario: Batch update entity attributes
- Scenario: Create entity curation session
- Scenario: Apply curation session decisions