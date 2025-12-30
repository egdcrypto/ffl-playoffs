@admin @system @configuration @settings @MVP-ADMIN
Feature: Admin System Configuration
  As a platform administrator
  I want to manage system-wide configuration
  So that I can control platform behavior and features

  Background:
    Given I am logged in as a platform administrator
    And I have system configuration permissions
    And the system configuration service is operational

  # ===========================================
  # CONFIGURATION DASHBOARD
  # ===========================================

  @dashboard @overview
  Scenario: View system configuration dashboard
    Given I am on the admin dashboard
    When I navigate to the system configuration section
    Then I should see the configuration dashboard
    And I should see overall configuration health status
    And I should see recent configuration changes
    And I should see pending changes awaiting approval
    And I should see feature flags summary
    And I should see current environment indicator

  @dashboard @health
  Scenario: View configuration health status
    Given I am on the configuration dashboard
    When I view the health panel
    Then I should see configuration sync status
    And I should see drift detection status
    And I should see last sync timestamp
    And I should see any configuration warnings
    And I should see validation status

  @dashboard @changes
  Scenario: View recent configuration changes
    Given I am on the configuration dashboard
    When I view recent changes
    Then I should see the last 10 configuration changes
    And each change should show the setting path
    And each change should show who made the change
    And each change should show when it was made
    And each change should show the change reason

  @dashboard @pending
  Scenario: View pending configuration changes
    Given there are pending configuration changes
    When I view pending changes
    Then I should see changes awaiting approval
    And I should see changes awaiting deployment
    And I should be able to approve or reject changes
    And I should see change impact assessment

  # ===========================================
  # CORE SYSTEM SETTINGS
  # ===========================================

  @settings @core
  Scenario: View core system settings
    Given I am on the configuration dashboard
    When I navigate to core settings
    Then I should see the settings categories interface
    And I should see general settings
    And I should see authentication settings
    And I should see notification settings
    And I should see storage settings
    And I should see rate limiting settings

  @settings @general
  Scenario: Configure general platform settings
    Given I am viewing core settings
    When I configure general settings
    Then I should be able to set platform name
    And I should be able to set default timezone
    And I should be able to set default locale
    And I should be able to set contact information
    And I should save the settings

  @settings @update
  Scenario: Update core system setting
    Given I am viewing a system setting
    When I update the setting value
    Then I should provide a new value
    And I should provide a reason for the change
    And the setting should be updated
    And the change should be logged in audit trail
    And affected services should apply the new value

  @settings @validate
  Scenario: Validate setting value before save
    Given I am updating a system setting
    When I enter an invalid value
    Then I should see a validation error
    And I should see what values are acceptable
    And the setting should not be saved
    And I should be able to correct the value

  @settings @reset
  Scenario: Reset setting to default
    Given a setting has been customized
    When I reset the setting to default
    Then the setting should return to default value
    And the reset should be logged in audit trail
    And I should see the default value applied

  @settings @dependencies
  Scenario: View setting dependencies
    Given I am viewing a system setting
    When I view dependencies
    Then I should see other settings that depend on this
    And I should see services affected by this setting
    And I should see impact of changing this setting

  # ===========================================
  # FEATURE FLAGS
  # ===========================================

  @feature-flags @list
  Scenario: List all feature flags
    Given I am on the configuration dashboard
    When I navigate to feature flags
    Then I should see all defined feature flags
    And each flag should show its key
    And each flag should show its name and description
    And each flag should show enabled/disabled status
    And each flag should show rollout percentage

  @feature-flags @create
  Scenario: Create new feature flag
    Given I am managing feature flags
    When I create a new feature flag
    Then I should enter a unique flag key
    And I should enter a human-readable name
    And I should enter a description
    And the flag should be created as disabled
    And the flag should have 0% rollout by default

  @feature-flags @enable
  Scenario: Enable feature flag globally
    Given a feature flag exists and is disabled
    When I enable the feature flag globally
    Then the flag should be enabled
    And the rollout percentage should be set to 100%
    And the change should be logged with reason
    And all users should have access to the feature

  @feature-flags @disable
  Scenario: Disable feature flag
    Given a feature flag is enabled
    When I disable the feature flag
    Then the flag should be disabled immediately
    And all users should lose access to the feature
    And the change should be logged
    And graceful degradation should be applied

  @feature-flags @targeting
  Scenario: Configure feature flag targeting
    Given a feature flag exists
    When I configure targeting rules
    Then I should be able to target by user attribute
    And I should be able to target by subscription tier
    And I should be able to target specific user IDs
    And I should be able to target by user groups
    And I should set default behavior for non-matching users

  @feature-flags @duplicate
  Scenario: Prevent duplicate feature flag key
    Given a feature flag with key "existing_feature" exists
    When I attempt to create a flag with the same key
    Then I should see an error message
    And the duplicate flag should not be created
    And I should be prompted to use a different key

  @feature-flags @delete
  Scenario: Delete feature flag
    Given a feature flag exists
    When I delete the feature flag
    Then I should confirm the deletion
    And I should see the impact on users
    And the flag should be removed
    And the deletion should be audit logged

  # ===========================================
  # FEATURE ROLLOUT
  # ===========================================

  @rollout @gradual
  Scenario: Configure gradual feature rollout
    Given a feature flag exists
    When I configure gradual rollout
    Then I should define rollout schedule with percentages
    And I should set dates for each rollout stage
    And I should configure auto-rollback threshold
    And the system should automatically advance rollout on schedule

  @rollout @percentage
  Scenario: Update rollout percentage
    Given a feature is partially rolled out
    When I update the rollout percentage
    Then the new percentage should be applied
    And the appropriate user sample should have access
    And users should be consistently assigned to groups

  @rollout @emergency
  Scenario: Emergency rollback feature
    Given a feature is rolled out to users
    And error rate has spiked above threshold
    When I trigger emergency rollback
    Then the feature should be disabled immediately
    And the rollback should be logged as emergency action
    And affected users should receive graceful degradation
    And stakeholders should be notified

  @rollout @pause
  Scenario: Pause feature rollout
    Given a gradual rollout is in progress
    When I pause the rollout
    Then the current percentage should be maintained
    And scheduled increases should be suspended
    And I should be able to resume later
    And the pause should be logged

  @rollout @monitor
  Scenario: Monitor rollout metrics
    Given a feature rollout is in progress
    When I monitor rollout metrics
    Then I should see error rates by variant
    And I should see performance metrics
    And I should see user feedback
    And I should see comparison to baseline

  # ===========================================
  # API SETTINGS
  # ===========================================

  @api @rate-limits
  Scenario: Configure API rate limits
    Given I am managing API settings
    When I configure rate limits
    Then I should set default rate limits
    And I should set authenticated user limits
    And I should set premium tier limits
    And I should set requests per minute and hour
    And new limits should apply to subsequent requests

  @api @versioning
  Scenario: Configure API versioning
    Given I am managing API settings
    When I configure versioning
    Then I should set current API version
    And I should set supported versions
    And I should set deprecated versions
    And I should set deprecation and sunset dates
    And deprecated version warnings should be enabled

  @api @deprecation
  Scenario: Manage API deprecation notices
    Given an API version is deprecated
    When clients use the deprecated version
    Then they should receive deprecation warnings
    And they should see the migration path
    And usage should be tracked for planning
    And sunset date should be communicated

  # ===========================================
  # ENVIRONMENT VARIABLES
  # ===========================================

  @env @list
  Scenario: List environment variables
    Given I am on the configuration dashboard
    When I navigate to environment variables
    Then I should see all environment variables
    And each variable should show its key
    And secret values should be masked
    And I should see the source of each variable
    And I should see last update timestamps

  @env @update
  Scenario: Update environment variable
    Given I am managing environment variables
    When I update a variable value
    Then the variable should be updated
    And services requiring restart should be flagged
    And the change should be logged
    And I should be notified of restart requirements

  @env @secret
  Scenario: Set secret environment variable
    Given I am managing environment variables
    When I set a secret variable
    Then the value should be encrypted at rest
    And the value should be masked in all responses
    And the value should be stored in secrets manager
    And access should be audit logged

  @env @validate
  Scenario: Validate environment variable names
    Given I am creating an environment variable
    When I enter an invalid variable name
    Then I should see a validation error
    And I should see naming requirements
    And the variable should not be created

  @env @delete
  Scenario: Delete environment variable
    Given an environment variable exists
    When I delete the variable
    Then I should confirm the deletion
    And I should see services that use this variable
    And the variable should be removed
    And the deletion should be logged

  # ===========================================
  # PERFORMANCE SETTINGS
  # ===========================================

  @performance @caching
  Scenario: Configure caching settings
    Given I am managing performance settings
    When I configure caching
    Then I should enable or disable caching
    And I should set default TTL
    And I should set maximum cache size
    And I should configure cache warming
    And I should set invalidation strategy

  @performance @connection-pool
  Scenario: Configure connection pool settings
    Given I am managing performance settings
    When I configure connection pools
    Then I should set database pool settings
    And I should set Redis pool settings
    And I should set minimum and maximum connections
    And I should set idle timeout
    And changes should apply after restart

  @performance @timeouts
  Scenario: Configure request timeouts
    Given I am managing performance settings
    When I configure timeouts
    Then I should set default request timeout
    And I should set long-running operation timeout
    And I should set database query timeout
    And I should set external API timeout

  @performance @compression
  Scenario: Configure response compression
    Given I am managing performance settings
    When I configure compression
    Then I should enable or disable compression
    And I should set compression threshold
    And I should select compression algorithm
    And I should set content types to compress

  # ===========================================
  # SECURITY SETTINGS
  # ===========================================

  @security @password-policy
  Scenario: Configure password policy
    Given I am managing security settings
    When I configure password policy
    Then I should set minimum password length
    And I should set character requirements
    And I should set password expiration
    And I should set reuse prevention count
    And I should set lockout thresholds

  @security @ip-whitelist
  Scenario: Configure IP whitelist
    Given I am managing security settings
    When I configure IP whitelist
    Then I should enable or disable whitelisting
    And I should add allowed IP addresses and ranges
    And I should set allowed countries
    And I should choose whitelist mode
    And my current session should not be affected

  @security @cors
  Scenario: Configure CORS settings
    Given I am managing security settings
    When I configure CORS
    Then I should set allowed origins
    And I should set allowed methods
    And I should set allowed headers
    And I should set max age
    And I should configure credentials handling

  @security @session
  Scenario: Configure session settings
    Given I am managing security settings
    When I configure session settings
    Then I should set session timeout
    And I should set idle timeout
    And I should set concurrent session limits
    And I should configure session refresh behavior

  @security @encryption
  Scenario: Configure encryption settings
    Given I am managing security settings
    When I configure encryption
    Then I should set encryption algorithm
    And I should configure key rotation schedule
    And I should set data-at-rest encryption
    And I should set data-in-transit encryption

  # ===========================================
  # THIRD-PARTY INTEGRATIONS
  # ===========================================

  @integrations @configure
  Scenario: Configure third-party integration
    Given I am managing integrations
    When I configure an integration
    Then I should select the provider
    And I should set API credentials via secret reference
    And I should configure environment settings
    And secrets should not be stored inline

  @integrations @test
  Scenario: Test integration connection
    Given an integration is configured
    When I test the connection
    Then I should see connection success or failure
    And I should see detailed error if failed
    And I should see latency metrics
    And I should be able to troubleshoot issues

  @integrations @disable
  Scenario: Disable integration
    Given an integration is enabled
    When I disable the integration
    Then the integration should be disabled
    And data flow to the provider should stop
    And the change should be logged
    And I should be able to re-enable later

  @integrations @credentials
  Scenario: Rotate integration credentials
    Given an integration has credentials
    When I rotate the credentials
    Then new credentials should be generated
    And old credentials should be invalidated
    And the integration should reconnect
    And the rotation should be logged

  # ===========================================
  # CONFIGURATION TEMPLATES
  # ===========================================

  @templates @apply
  Scenario: Apply configuration template
    Given a configuration template exists
    When I apply the template
    Then I should see which settings will change
    And I should backup current configuration
    And template settings should be applied
    And all changes should be logged

  @templates @preview
  Scenario: Preview template application
    Given a configuration template exists
    When I preview the template
    Then I should see which settings would change
    And I should see current vs new values
    And no actual changes should be made
    And I should be able to proceed or cancel

  @templates @create
  Scenario: Create configuration template from current settings
    Given I want to save current configuration
    When I create a template
    Then I should provide template name
    And I should provide description
    And I should choose to include or exclude secrets
    And the template should be created

  @templates @manage
  Scenario: Manage configuration templates
    Given I am managing templates
    When I view template list
    Then I should see all available templates
    And I should be able to edit templates
    And I should be able to delete templates
    And I should be able to export templates

  # ===========================================
  # CONFIGURATION VALIDATION
  # ===========================================

  @validation @preview
  Scenario: Validate configuration changes before applying
    Given I have pending configuration changes
    When I validate the changes
    Then I should see if all changes are valid
    And I should see any validation errors
    And I should see any warnings
    And I should see estimated impact

  @validation @reject
  Scenario: Reject configuration with validation errors
    Given I attempt to apply invalid configuration
    When validation fails
    Then I should see all validation errors
    And no changes should be applied
    And I should be able to fix the errors
    And I should retry after fixing

  @validation @conflicts
  Scenario: Detect configuration conflicts
    Given I am applying configuration changes
    When there are conflicting settings
    Then I should see the conflicts
    And I should see resolution options
    And I should resolve conflicts before applying

  # ===========================================
  # CONFIGURATION HISTORY AND AUDIT
  # ===========================================

  @history @view
  Scenario: View configuration history
    Given I am on the configuration dashboard
    When I view configuration history
    Then I should see all change records
    And each record should show the setting path
    And each record should show old and new values
    And each record should show who made the change
    And secret values should be masked

  @history @revert
  Scenario: Revert to previous configuration
    Given a configuration change exists in history
    When I revert the change
    Then the setting should be restored to previous value
    And the reversion should be logged as new change
    And I should see the revert confirmation

  @history @compare
  Scenario: Compare configuration versions
    Given I want to compare configurations
    When I select two dates to compare
    Then I should see all differences between the dates
    And I should see added settings
    And I should see removed settings
    And I should see changed values

  @history @export
  Scenario: Export configuration history
    Given I am viewing configuration history
    When I export the history
    Then I should select date range
    And I should select export format
    And the history should be exported
    And the export should be logged

  # ===========================================
  # A/B TESTING
  # ===========================================

  @ab-test @create
  Scenario: Configure A/B test
    Given I am managing A/B tests
    When I create a new A/B test
    Then I should provide test name and description
    And I should configure test variants with weights
    And I should set targeting criteria
    And I should define success metrics
    And I should set start and end dates

  @ab-test @results
  Scenario: View A/B test results
    Given an A/B test has been running
    When I view test results
    Then I should see metrics for each variant
    And I should see statistical significance
    And I should see confidence levels
    And I should see recommendation

  @ab-test @conclude
  Scenario: End A/B test and declare winner
    Given an A/B test shows significant results
    When I conclude the test
    Then I should select the winning variant
    And I should choose to apply the winner
    And the winning configuration should be applied to all users
    And the test should be marked as concluded

  @ab-test @stop
  Scenario: Stop A/B test early
    Given an A/B test is running
    When I stop the test early
    Then I should provide a reason
    And the test should be stopped
    And I should choose to keep current state or revert
    And the early stop should be logged

  # ===========================================
  # MAINTENANCE MODE
  # ===========================================

  @maintenance @enable
  Scenario: Enable maintenance mode
    Given I am managing system configuration
    When I enable maintenance mode
    Then I should provide a maintenance message
    And I should set estimated duration
    And I should choose if admins retain access
    And regular users should see maintenance message
    And admins should still have access if configured

  @maintenance @disable
  Scenario: Disable maintenance mode
    Given maintenance mode is currently active
    When I disable maintenance mode
    Then maintenance mode should be disabled
    And all users should regain access
    And the maintenance end should be logged
    And users should be notified

  @maintenance @schedule
  Scenario: Schedule maintenance window
    Given I need to plan maintenance
    When I schedule a maintenance window
    Then I should set start and end times
    And I should set maintenance message
    And I should set notification advance time
    And users should receive notification before maintenance
    And maintenance should start automatically

  @maintenance @extend
  Scenario: Extend maintenance window
    Given maintenance mode is active
    When I extend the maintenance window
    Then I should set new end time
    And I should update the message
    And users should see updated information
    And the extension should be logged

  # ===========================================
  # EXPORT AND IMPORT
  # ===========================================

  @export @configuration
  Scenario: Export system configuration
    Given I am managing configuration
    When I export configuration
    Then I should select export format
    And I should choose to include or exclude secrets
    And I should select sections to export
    And the configuration should be exported
    And the export should be audit logged

  @import @configuration
  Scenario: Import configuration
    Given I have a valid configuration file
    When I import the configuration
    Then I should select import mode (merge or replace)
    And I should validate before importing
    And I should backup current configuration
    And the configuration should be imported
    And conflicts should be handled per strategy

  @import @validate
  Scenario: Validate configuration before import
    Given I have a configuration file to import
    When I validate the file
    Then I should see validation results
    And I should see any errors
    And I should see any warnings
    And I should be able to proceed or cancel

  @import @reject
  Scenario: Reject invalid configuration import
    Given I attempt to import malformed configuration
    When validation fails
    Then I should see all validation errors
    And no configuration should be changed
    And I should be able to fix the file

  # ===========================================
  # CONFIGURATION DRIFT
  # ===========================================

  @drift @monitor
  Scenario: Monitor configuration drift
    Given a baseline configuration is defined
    When I check for configuration drift
    Then I should see if drift is detected
    And I should see which settings differ from baseline
    And I should see when baseline was established
    And I should see drift severity level

  @drift @resolve
  Scenario: Resolve configuration drift
    Given configuration drift has been detected
    When I resolve the drift
    Then I should choose resolution action
    And I should be able to update the baseline
    And I should be able to revert to baseline
    And the drift resolution should be logged

  @drift @baseline
  Scenario: Update configuration baseline
    Given I want to update the baseline
    When I update the baseline
    Then current configuration should become the new baseline
    And the baseline update should be timestamped
    And the update should be logged
    And previous baseline should be archived

  @drift @alerts
  Scenario: Configure drift alerts
    Given I am managing drift detection
    When I configure alerts
    Then I should set drift notification thresholds
    And I should set alert recipients
    And I should set alert frequency
    And I should enable or disable alerts

  # ===========================================
  # DOMAIN EVENTS
  # ===========================================

  @events @emit
  Scenario: Emit domain events for configuration changes
    Given configuration operations occur
    When configuration is changed
    Then ConfigurationChangedEvent should be emitted
    And the event should contain setting path
    And the event should contain old and new values
    And the event should contain who made the change
    And events should be published to message bus

  @events @feature-flags
  Scenario: Emit events for feature flag changes
    Given feature flag operations occur
    When a feature flag is toggled
    Then FeatureFlagToggledEvent should be emitted
    And the event should contain flag key
    And the event should contain enabled status
    And the event should support alerting

  @events @maintenance
  Scenario: Emit events for maintenance mode
    Given maintenance mode is managed
    When maintenance mode is enabled or disabled
    Then appropriate maintenance event should be emitted
    And the event should contain message and duration
    And the event should support notifications

  # ===========================================
  # ERROR HANDLING AND EDGE CASES
  # ===========================================

  @error-handling @save-failed
  Scenario: Handle configuration save failure
    Given I am updating configuration
    When the save operation fails
    Then I should see an error message
    And I should see the failure reason
    And my changes should be preserved
    And I should be able to retry
    And the failure should be logged

  @error-handling @sync-failed
  Scenario: Handle configuration sync failure
    Given configuration sync is attempted
    When sync fails
    Then I should see a sync error
    And I should see which settings failed
    And I should be able to retry sync
    And manual intervention options should be shown

  @error-handling @rollback-failed
  Scenario: Handle rollback failure
    Given I am reverting configuration
    When the rollback fails
    Then I should see the failure reason
    And I should see the current state
    And I should be able to try alternative recovery
    And the failure should be escalated

  @edge-case @circular-dependency
  Scenario: Detect circular configuration dependencies
    Given I am configuring settings
    When a circular dependency would be created
    Then I should see a dependency error
    And I should see the dependency chain
    And the change should be blocked
    And I should be guided to resolve

  @edge-case @concurrent-edit
  Scenario: Handle concurrent configuration edits
    Given another admin is editing configuration
    When I attempt to edit the same setting
    Then I should see a concurrent edit warning
    And I should see who is editing
    And I should be able to view or wait
    And I should be notified when available

  @edge-case @large-import
  Scenario: Handle large configuration import
    Given I am importing a large configuration
    When the import is very large
    Then import should be processed in chunks
    And I should see import progress
    And I should be able to cancel if needed
    And timeout should be handled gracefully

  @edge-case @secret-exposure
  Scenario: Prevent accidental secret exposure
    Given I am exporting configuration
    When I attempt to include secrets
    Then I should receive a strong warning
    And I should confirm intentional inclusion
    And the action should be heavily logged
    And secrets should be encrypted in export
