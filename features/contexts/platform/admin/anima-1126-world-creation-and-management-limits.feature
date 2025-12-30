@ANIMA-1126
Feature: World Creation and Management Limits

As a platform administrator
I want to enforce limits on world creation and activation
So that I can manage resource usage and monetize the platform appropriately
Background:
Given I am logged in as a world owner
And the platform has defined subscription tiers
# World Creation Limits
- Scenario: Check world creation limit for free tier
- Scenario: Create world within subscription limit
- Scenario: Upgrade subscription to increase world limit
- Scenario: Enforce active world limits
- Scenario: Deactivate world to activate another
- Scenario: Enforce entity limits per world
- Scenario: Check multiple entity type limits
- Scenario: Enforce concurrent player limits
- Scenario: Set custom player limits below subscription maximum
- Scenario: Monitor world storage usage
- Scenario: Archive world to free up slots
- Scenario: Restore archived world