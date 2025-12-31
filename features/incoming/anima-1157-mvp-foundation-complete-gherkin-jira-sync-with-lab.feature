@ANIMA-1157
Feature: MVP Foundation - Complete Gherkin-JIRA Sync with Labels
  As a Product Manager using the orchestrator framework
  I want JIRA tickets to synchronize bidirectionally with Gherkin feature files
  So that requirements stay consistent between JIRA and the codebase
  And I can track which engineers are working on which tickets via labels

  Background:
    Given the orchestrator framework is configured with valid JIRA credentials
    And a project exists with a features/incoming directory
    And the sync tracking database is initialized

  # ============================================
  # JIRA TO FEATURE FILE SYNC SCENARIOS
  # ============================================

  @sync @happy-path
  Scenario: Sync creates new feature file from JIRA ticket with Gherkin description
    Given a JIRA ticket "ANIMA-1200" exists with status "To Do"
    And the ticket description contains valid Gherkin syntax:
      """
      Feature: User Registration
        Scenario: Successful registration
          Given a new user visits the registration page
          When they submit valid credentials
          Then their account is created
      """
    And no local feature file exists for "ANIMA-1200"
    When the orchestrator runs "jira sync"
    Then a feature file is created at "features/incoming/anima-1200-user-registration.feature"
    And the feature file contains the Gherkin from the JIRA description
    And the feature file is tagged with "@ANIMA-1200"
    And the sync tracking database records the ticket key and sync timestamp

  @sync @happy-path
  Scenario: Sync updates existing feature file when JIRA description changes
    Given a JIRA ticket "ANIMA-1201" exists with status "In Progress"
    And a local feature file exists for "ANIMA-1201" from a previous sync
    And the JIRA ticket was updated after the last sync timestamp
    And the ticket description now contains additional scenarios
    When the orchestrator runs "jira sync"
    Then the local feature file is updated with the new Gherkin content
    And the sync tracking database records the new sync timestamp

  @sync @optimization
  Scenario: Sync skips tickets that have not changed since last sync
    Given a JIRA ticket "ANIMA-1202" exists with status "To Do"
    And a sync was performed at "2024-01-15T10:00:00Z"
    And the JIRA ticket was last updated at "2024-01-14T09:00:00Z"
    When the orchestrator runs "jira sync"
    Then the feature file for "ANIMA-1202" is not modified
    And the sync completes faster due to skipped tickets

  @sync @force
  Scenario: Force sync updates all tickets regardless of timestamp
    Given multiple JIRA tickets exist in "To Do" status
    And local feature files exist for all tickets from previous syncs
    And none of the JIRA tickets have been modified since last sync
    When the orchestrator runs "jira sync --force"
    Then all feature files are regenerated from their JIRA descriptions
    And the sync tracking database is updated for all tickets

  @sync @filter
  Scenario: Sync excludes Done tickets from synchronization
    Given a JIRA ticket "ANIMA-1203" exists with status "Done"
    And the ticket has a valid Gherkin description
    When the orchestrator runs "jira sync"
    Then no feature file is created for "ANIMA-1203"
    And the sync log indicates the ticket was skipped due to Done status

  @sync @edge-case
  Scenario: Sync handles ticket with no Gherkin in description
    Given a JIRA ticket "ANIMA-1204" exists with status "To Do"
    And the ticket description contains only plain text requirements
    And no Gherkin code block is present in the description
    When the orchestrator runs "jira sync"
    Then a feature file is created with placeholder scenarios
    And the feature file summary matches the JIRA ticket summary
    And the description is preserved as a comment in the feature file

  @sync @edge-case
  Scenario: Sync handles malformed Gherkin syntax gracefully
    Given a JIRA ticket "ANIMA-1205" exists with status "To Do"
    And the ticket description contains invalid Gherkin syntax:
      """
      Feature User Login
        Scenario Missing colon
          Given user logs in
          When they submit
          Then result
      """
    When the orchestrator runs "jira sync"
    Then a feature file is created with the content as-is
    And a warning is logged about potential Gherkin syntax issues
    And the sync continues processing remaining tickets

  @sync @naming
  Scenario: Sync generates feature file name from ticket key and summary
    Given a JIRA ticket "ANIMA-1206" exists with summary "NFL Player Data Integration"
    When the orchestrator runs "jira sync"
    Then the feature file is named "anima-1206-nfl-player-data-integration.feature"
    And special characters in the summary are converted to hyphens
    And the filename is lowercase

  # ============================================
  # LABEL MANAGEMENT SCENARIOS
  # ============================================

  @labels @happy-path
  Scenario: Add engineer label to JIRA ticket
    Given a JIRA ticket "ANIMA-1210" exists with no labels
    When the orchestrator runs "jira label ANIMA-1210 engineer1"
    Then the label "engineer1" is added to ticket "ANIMA-1210"
    And the JIRA API confirms the label was applied

  @labels @happy-path
  Scenario: Add multiple labels to JIRA ticket
    Given a JIRA ticket "ANIMA-1211" exists with no labels
    When the orchestrator runs "jira label ANIMA-1211 engineer1 backend-engineer"
    Then the labels "engineer1" and "backend-engineer" are added to ticket "ANIMA-1211"

  @labels @happy-path
  Scenario: Remove engineer label from JIRA ticket
    Given a JIRA ticket "ANIMA-1212" exists with label "engineer2"
    When the orchestrator runs "jira label ANIMA-1212 engineer2 --remove"
    Then the label "engineer2" is removed from ticket "ANIMA-1212"
    And the ticket has no engineer labels

  @labels @assignment
  Scenario: Set engineer label clears previous engineer assignments
    Given a JIRA ticket "ANIMA-1213" exists with label "engineer1"
    When an engineer assignment changes to "engineer2"
    And the orchestrator calls set_engineer_label for "engineer2"
    Then the label "engineer1" is removed from the ticket
    And the label "engineer2" is added to the ticket
    And only one engineer ID label exists on the ticket

  @labels @assignment
  Scenario: Clear all engineer labels from ticket
    Given a JIRA ticket "ANIMA-1214" exists with labels:
      | label             |
      | engineer1         |
      | backend-engineer  |
      | sdet              |
    When the orchestrator clears engineer labels from "ANIMA-1214"
    Then all engineer-related labels are removed
    And non-engineer labels remain unchanged

  @labels @query
  Scenario: Query labels from JIRA ticket
    Given a JIRA ticket "ANIMA-1215" exists with labels:
      | label       |
      | engineer3   |
      | priority    |
      | mvp         |
    When the orchestrator retrieves labels for "ANIMA-1215"
    Then the response contains all three labels
    And the labels can be filtered to find engineer assignments

  # ============================================
  # ENGINEER WORKFLOW INTEGRATION SCENARIOS
  # ============================================

  @workflow @spawn
  Scenario: Spawning engineer automatically sets JIRA label
    Given a JIRA ticket "ANIMA-1220" exists in "To Do" status
    And no engineer labels are present on the ticket
    When the orchestrator spawns "engineer1" to work on "ANIMA-1220"
    Then the ticket status transitions to "In Progress"
    And the label "engineer1" is automatically added to the ticket
    And the spawn confirmation shows the label was set

  @workflow @reassign
  Scenario: Reassigning ticket updates engineer labels
    Given a JIRA ticket "ANIMA-1221" is assigned to "engineer1"
    And the ticket has label "engineer1"
    When the orchestrator reassigns "ANIMA-1221" to "engineer2"
    Then the label "engineer1" is removed from the ticket
    And the label "engineer2" is added to the ticket
    And the reassignment log shows the label change

  @workflow @complete
  Scenario: Completing work transitions ticket and preserves labels
    Given a JIRA ticket "ANIMA-1222" is in "In Progress" status
    And the ticket has label "engineer1"
    When the engineer completes work and moves ticket to "Done"
    Then the ticket status is "Done"
    And the label "engineer1" remains for attribution
    And future syncs exclude this Done ticket

  @workflow @list
  Scenario: List tickets shows engineer assignments via labels
    Given multiple JIRA tickets exist with different engineer labels:
      | ticket      | label     | status      |
      | ANIMA-1223  | engineer1 | In Progress |
      | ANIMA-1224  | engineer2 | In Progress |
      | ANIMA-1225  | -         | To Do       |
    When the orchestrator runs "jira list"
    Then the output table shows ticket, summary, status, and engineer columns
    And unassigned tickets show "-" in the engineer column
    And assigned tickets show their engineer label

  # ============================================
  # ERROR HANDLING SCENARIOS
  # ============================================

  @error @credentials
  Scenario: Sync fails gracefully with missing JIRA credentials
    Given the orchestrator is configured without JIRA credentials
    When the orchestrator runs "jira sync"
    Then an error message indicates missing JIRA_URL, JIRA_EMAIL, or JIRA_API_TOKEN
    And the sync operation exits without modifying any files

  @error @network
  Scenario: Sync handles JIRA API network failures
    Given valid JIRA credentials are configured
    And the JIRA API is unreachable due to network issues
    When the orchestrator runs "jira sync"
    Then an error message indicates the API connection failed
    And previously synced feature files remain unchanged
    And the sync can be retried when connectivity is restored

  @error @permission
  Scenario: Label operation fails with insufficient permissions
    Given valid JIRA credentials are configured
    And the configured user lacks label modification permissions
    When the orchestrator runs "jira label ANIMA-1230 engineer1"
    Then an error message indicates insufficient permissions
    And the ticket labels remain unchanged

  @error @invalid-ticket
  Scenario: Operations fail gracefully for non-existent ticket
    Given no JIRA ticket exists with key "ANIMA-9999"
    When the orchestrator runs "jira get ANIMA-9999"
    Then an error message indicates the ticket was not found
    And the operation exits with a clear error code

  @error @transition
  Scenario: Status transition fails for invalid workflow
    Given a JIRA ticket "ANIMA-1231" exists in "Done" status
    When the orchestrator attempts to transition to "In Progress"
    And the JIRA workflow does not allow this transition
    Then an error message indicates the transition is not available
    And the ticket status remains "Done"

  # ============================================
  # BULK OPERATIONS SCENARIOS
  # ============================================

  @bulk @sync
  Scenario: Sync handles large number of tickets efficiently
    Given 100 JIRA tickets exist in "To Do" status
    And each ticket has valid Gherkin in its description
    When the orchestrator runs "jira sync"
    Then all 100 feature files are created in features/incoming
    And the sync uses pagination to handle large result sets
    And progress is reported during the sync operation

  @bulk @move
  Scenario: Bulk move tickets between statuses
    Given 10 JIRA tickets exist in "To Do" status
    And each ticket has valid Gherkin descriptions
    When the orchestrator runs "jira bulk-move 'To Do' 'In Progress'"
    Then all 10 tickets are transitioned to "In Progress"
    And a summary shows how many tickets were moved

  # ============================================
  # SYNC TRACKING DATABASE SCENARIOS
  # ============================================

  @database @tracking
  Scenario: Sync tracking persists across orchestrator restarts
    Given a sync was performed and recorded in the tracking database
    And the orchestrator process was restarted
    When the orchestrator runs "jira sync"
    Then the previous sync timestamps are read from the database
    And only tickets modified after those timestamps are processed

  @database @cleanup
  Scenario: Sync tracking removes entries for deleted JIRA tickets
    Given the sync tracking database has an entry for "ANIMA-1240"
    And the JIRA ticket "ANIMA-1240" has been deleted
    When the orchestrator runs "jira sync"
    Then the orphaned database entry is identified
    And the local feature file can be optionally removed

  @database @integrity
  Scenario: Sync tracking handles database corruption gracefully
    Given the sync tracking database is corrupted
    When the orchestrator runs "jira sync"
    Then a warning indicates the database will be rebuilt
    And a fresh sync is performed for all eligible tickets
    And the database is recreated with current sync state
