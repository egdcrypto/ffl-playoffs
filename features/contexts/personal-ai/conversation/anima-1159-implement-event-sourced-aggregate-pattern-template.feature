@ANIMA-1159
Feature: Implement Event-Sourced Aggregate Pattern Template
  Update the aggregate template to follow the event-sourced pattern from mph-platform-kotlin. All aggregates must implement:

  Scenario: Uncommitted events collection
    Given the system is ready
    When the user performs the action
    Then the expected result occurs

  Scenario: Command handlers returning events
    Given the system is ready
    When the user performs the action
    Then the expected result occurs

  Scenario: Event handlers (on() methods) for state mutation
    Given the system is ready
    When the user performs the action
    Then the expected result occurs

  Scenario: Rehydration via static factory method
    Given the system is ready
    When the user performs the action
    Then the expected result occurs

  Scenario: Version tracking for optimistic concurrency
    Given the system is ready
    When the user performs the action
    Then the expected result occurs

