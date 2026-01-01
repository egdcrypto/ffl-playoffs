@user-accounts
Feature: User Accounts
  As a fantasy football platform user
  I want comprehensive account functionality
  So that I can securely manage my identity and preferences on the platform

  Background:
    Given I am on the fantasy football platform
    And the account management system is available

  # --------------------------------------------------------------------------
  # Registration Scenarios
  # --------------------------------------------------------------------------
  @registration
  Scenario: Register with email signup
    Given I am on the registration page
    When I enter my email address
    And I create a password
    And I submit the registration form
    Then my account should be created
    And I should receive a verification email
    And I should be prompted to verify my email

  @registration
  Scenario: Register with social login
    Given I am on the registration page
    And I choose to sign up with a social provider
    When I authenticate with the provider
    Then my account should be created
    And my profile should be pre-populated
    And I should be logged in

  @registration
  Scenario: Select username during registration
    Given I am completing registration
    When I choose my username
    Then username availability should be checked
    And username rules should be enforced
    And my username should be saved

  @registration
  Scenario: Complete email verification flow
    Given I have registered with email
    And I received a verification email
    When I click the verification link
    Then my email should be verified
    And I should be able to access all features
    And confirmation should be shown

  @registration
  Scenario: Resend verification email
    Given I have not verified my email
    When I request a new verification email
    Then a new email should be sent
    And the old link should be invalidated
    And I should be notified

  @registration
  Scenario: Handle duplicate email registration
    Given an account exists with my email
    When I try to register with the same email
    Then I should see an error message
    And I should be offered password recovery
    And the attempt should be logged

  @registration
  Scenario: Accept terms during registration
    Given I am completing registration
    When I review terms and conditions
    Then I must accept terms to proceed
    And my acceptance should be recorded
    And the version should be noted

  @registration
  Scenario: Set initial preferences during registration
    Given I am completing registration
    When I set initial preferences
    Then I should configure basic settings
    And defaults should be offered
    And I should be able to skip for later

  # --------------------------------------------------------------------------
  # Authentication Scenarios
  # --------------------------------------------------------------------------
  @authentication
  Scenario: Login with email and password
    Given I am on the login page
    When I enter my credentials
    And I submit the login form
    Then I should be authenticated
    And I should be redirected to my dashboard
    And a session should be created

  @authentication
  Scenario: Logout from the platform
    Given I am logged in
    When I click logout
    Then my session should be terminated
    And I should be redirected to the login page
    And I should need to re-authenticate

  @authentication
  Scenario: Change password
    Given I am logged in
    When I access password settings
    And I enter my current password
    And I enter a new password
    Then my password should be updated
    And I should receive confirmation
    And other sessions should be invalidated

  @authentication
  Scenario: Handle session expiration
    Given my session has expired
    When I try to access a protected page
    Then I should be redirected to login
    And I should see a session expired message
    And I should be able to re-authenticate

  @authentication
  Scenario: Use remember me functionality
    Given I am logging in
    When I check "Remember me"
    And I log in successfully
    Then my session should persist longer
    And I should not need to login frequently
    And the preference should be saved

  @authentication
  Scenario: Handle multiple failed login attempts
    Given I am trying to login
    When I fail multiple times
    Then my account should be temporarily locked
    And I should be notified
    And I should be offered recovery options

  @authentication
  Scenario: Login with social provider
    Given I have a linked social account
    When I choose to login with social provider
    Then I should be authenticated
    And my session should be created
    And I should access my account

  @authentication
  Scenario: Handle concurrent sessions
    Given I am logged in on one device
    When I login on another device
    Then both sessions should be active
    And I should be able to view all sessions
    And I should be able to terminate others

  # --------------------------------------------------------------------------
  # Profile Management Scenarios
  # --------------------------------------------------------------------------
  @profile-management
  Scenario: Update display name
    Given I am on my profile settings
    When I update my display name
    And I save changes
    Then my display name should be updated
    And it should appear across the platform
    And the change should be logged

  @profile-management
  Scenario: Upload avatar
    Given I am on my profile settings
    When I upload an avatar image
    Then the image should be validated
    And it should be resized if necessary
    And my avatar should be updated

  @profile-management
  Scenario: Update bio information
    Given I am editing my profile
    When I update my bio
    And I save changes
    Then my bio should be updated
    And it should be visible on my profile
    And character limits should be enforced

  @profile-management
  Scenario: Update contact information
    Given I am on profile settings
    When I update my contact info
    Then email changes should require verification
    And phone numbers should be validated
    And changes should be saved

  @profile-management
  Scenario: Set timezone preference
    Given I am configuring my profile
    When I select my timezone
    Then my timezone should be saved
    And times should display in my timezone
    And the setting should persist

  @profile-management
  Scenario: View public profile
    Given I have a profile configured
    When I view my public profile
    Then I should see what others see
    And privacy settings should be applied
    And I should be able to edit

  @profile-management
  Scenario: Add social links to profile
    Given I am editing my profile
    When I add social media links
    Then links should be validated
    And they should appear on my profile
    And I should be able to remove them

  @profile-management
  Scenario: Set profile visibility
    Given I am configuring privacy
    When I set profile visibility
    Then I should choose who can view
    And settings should be applied
    And I should be able to change anytime

  # --------------------------------------------------------------------------
  # Account Settings Scenarios
  # --------------------------------------------------------------------------
  @account-settings
  Scenario: Configure email preferences
    Given I am on account settings
    When I configure email preferences
    Then I should set email frequency
    And I should choose email types
    And preferences should be saved

  @account-settings
  Scenario: Set privacy controls
    Given I am configuring privacy
    When I set privacy controls
    Then I should control data visibility
    And I should control activity sharing
    And settings should take effect

  @account-settings
  Scenario: Configure notification settings
    Given I am on notification settings
    When I configure notifications
    Then I should enable or disable types
    And I should set delivery preferences
    And settings should be saved

  @account-settings
  Scenario: Select language preference
    Given I am on account settings
    When I select my language
    Then the interface should update
    And my preference should be saved
    And it should persist across sessions

  @account-settings
  Scenario: Configure accessibility settings
    Given I need accessibility options
    When I configure accessibility
    Then I should set text size
    And I should set contrast preferences
    And settings should be applied

  @account-settings
  Scenario: Set default league preferences
    Given I have multiple leagues
    When I set default preferences
    Then defaults should be applied
    And I should be able to override per league
    And preferences should be saved

  @account-settings
  Scenario: Export account settings
    Given I want to backup settings
    When I export settings
    Then settings should be exported
    And I should be able to import later
    And the format should be portable

  @account-settings
  Scenario: Reset settings to defaults
    Given I want to reset settings
    When I reset to defaults
    Then all settings should revert
    And I should confirm the action
    And the reset should be logged

  # --------------------------------------------------------------------------
  # Security Scenarios
  # --------------------------------------------------------------------------
  @security
  Scenario: Enable two-factor authentication
    Given I want enhanced security
    When I enable 2FA
    Then I should set up authenticator app
    And backup codes should be provided
    And 2FA should be required on login

  @security
  Scenario: View login history
    Given I want to review logins
    When I view login history
    Then I should see all login attempts
    And I should see device information
    And I should see location data

  @security
  Scenario: Manage active sessions
    Given I have multiple active sessions
    When I view active sessions
    Then I should see all sessions
    And I should be able to terminate any
    And current session should be marked

  @security
  Scenario: Receive security alerts
    Given security monitoring is enabled
    When a suspicious activity occurs
    Then I should receive an alert
    And I should be able to take action
    And the event should be logged

  @security
  Scenario: Disable two-factor authentication
    Given I have 2FA enabled
    When I disable 2FA
    Then I should confirm with password
    And 2FA should be removed
    And I should be notified

  @security
  Scenario: Generate new backup codes
    Given I have 2FA enabled
    When I generate new backup codes
    Then old codes should be invalidated
    And new codes should be provided
    And I should store them securely

  @security
  Scenario: Review security recommendations
    Given security analysis is available
    When I view recommendations
    Then I should see improvement suggestions
    And I should see my security score
    And I should be able to act on tips

  @security
  Scenario: Revoke all sessions
    Given I suspect unauthorized access
    When I revoke all sessions
    Then all sessions should be terminated
    And I should need to re-login
    And I should change my password

  # --------------------------------------------------------------------------
  # Subscription Management Scenarios
  # --------------------------------------------------------------------------
  @subscription-management
  Scenario: Select subscription plan
    Given I am viewing plans
    When I select a plan
    Then plan details should be shown
    And I should proceed to payment
    And my selection should be saved

  @subscription-management
  Scenario: Update billing information
    Given I have an active subscription
    When I update billing info
    Then new payment details should be saved
    And validation should occur
    And confirmation should be provided

  @subscription-management
  Scenario: Add payment method
    Given I need to add payment
    When I add a payment method
    Then the method should be validated
    And it should be securely stored
    And I should be able to set as default

  @subscription-management
  Scenario: View subscription history
    Given I have subscription history
    When I view my history
    Then I should see all transactions
    And invoices should be available
    And I should be able to download

  @subscription-management
  Scenario: Upgrade subscription plan
    Given I have a basic plan
    When I upgrade my plan
    Then I should see upgrade options
    And prorated pricing should apply
    And new features should be available

  @subscription-management
  Scenario: Downgrade subscription plan
    Given I have a premium plan
    When I downgrade my plan
    Then I should see impact of downgrade
    And changes should apply at renewal
    And I should be notified

  @subscription-management
  Scenario: Cancel subscription
    Given I want to cancel
    When I cancel my subscription
    Then I should confirm cancellation
    And I should retain access until period end
    And I should receive confirmation

  @subscription-management
  Scenario: Reactivate cancelled subscription
    Given I cancelled my subscription
    When I reactivate
    Then my subscription should resume
    And I should be charged appropriately
    And access should be restored

  # --------------------------------------------------------------------------
  # Connected Accounts Scenarios
  # --------------------------------------------------------------------------
  @connected-accounts
  Scenario: Link social media account
    Given I want to connect social media
    When I link an account
    Then I should authenticate with the provider
    And the account should be linked
    And I should be able to unlink

  @connected-accounts
  Scenario: Sync with other platforms
    Given I use other fantasy platforms
    When I sync accounts
    Then data should be imported
    And sync status should be shown
    And I should control what syncs

  @connected-accounts
  Scenario: Configure third-party integrations
    Given integrations are available
    When I configure an integration
    Then I should authorize access
    And the integration should be active
    And I should manage permissions

  @connected-accounts
  Scenario: Import data from other platforms
    Given I have data elsewhere
    When I import data
    Then I should select what to import
    And data should be transferred
    And conflicts should be handled

  @connected-accounts
  Scenario: Unlink connected account
    Given I have a linked account
    When I unlink the account
    Then the link should be removed
    And associated data should be handled
    And I should be notified

  @connected-accounts
  Scenario: View connected account permissions
    Given I have connected accounts
    When I view permissions
    Then I should see what access is granted
    And I should be able to modify
    And changes should take effect

  @connected-accounts
  Scenario: Refresh connected account tokens
    Given tokens may expire
    When tokens need refresh
    Then I should re-authorize if needed
    And connections should remain active
    And I should be notified of issues

  @connected-accounts
  Scenario: Export data to connected platform
    Given I want to export data
    When I export to a platform
    Then data should be formatted correctly
    And export should complete
    And confirmation should be shown

  # --------------------------------------------------------------------------
  # Account Recovery Scenarios
  # --------------------------------------------------------------------------
  @account-recovery
  Scenario: Initiate forgot password flow
    Given I forgot my password
    When I request password reset
    Then I should receive reset email
    And the link should be time-limited
    And I should be able to set new password

  @account-recovery
  Scenario: Reset password with link
    Given I have a reset link
    When I click the link
    Then I should be able to enter new password
    And my password should be updated
    And I should be logged in

  @account-recovery
  Scenario: Unlock account
    Given my account is locked
    When I request unlock
    Then I should verify my identity
    And my account should be unlocked
    And I should be notified

  @account-recovery
  Scenario: Change account email
    Given I need to change my email
    When I initiate email change
    Then I should verify current identity
    And I should verify new email
    And the change should complete

  @account-recovery
  Scenario: Verify identity for recovery
    Given I am recovering my account
    When I verify my identity
    Then I should answer security questions
    Or I should use backup codes
    And access should be restored

  @account-recovery
  Scenario: Recover account with backup codes
    Given I have 2FA enabled
    And I lost my device
    When I use a backup code
    Then I should gain access
    And I should set up new 2FA
    And the code should be invalidated

  @account-recovery
  Scenario: Contact support for recovery
    Given automated recovery failed
    When I contact support
    Then I should submit a request
    And support should verify my identity
    And my account should be recovered

  @account-recovery
  Scenario: Handle recovery email not received
    Given I did not receive recovery email
    When I report the issue
    Then I should check spam folder
    And I should be able to resend
    And alternative methods should be offered

  # --------------------------------------------------------------------------
  # Account Data Scenarios
  # --------------------------------------------------------------------------
  @account-data
  Scenario: Export all account data
    Given I want to export my data
    When I request data export
    Then all my data should be compiled
    And I should receive a download
    And the export should be comprehensive

  @account-data
  Scenario: View activity history
    Given I have account activity
    When I view activity history
    Then I should see all my actions
    And I should be able to filter
    And I should be able to search

  @account-data
  Scenario: View usage statistics
    Given usage is tracked
    When I view usage statistics
    Then I should see my usage patterns
    And comparisons should be available
    And insights should be offered

  @account-data
  Scenario: Manage storage usage
    Given I have stored data
    When I manage storage
    Then I should see what uses space
    And I should be able to delete items
    And quotas should be shown

  @account-data
  Scenario: Download specific data
    Given I want specific data
    When I request download
    Then I should select data type
    And the download should be provided
    And the format should be usable

  @account-data
  Scenario: View data retention policies
    Given I want to understand data retention
    When I view policies
    Then I should see what is retained
    And I should see for how long
    And my rights should be explained

  @account-data
  Scenario: Request data deletion
    Given I want data deleted
    When I request deletion
    Then I should specify what to delete
    And the request should be processed
    And I should receive confirmation

  @account-data
  Scenario: View third-party data sharing
    Given my data may be shared
    When I view sharing info
    Then I should see who has access
    And I should be able to revoke
    And I should understand the usage

  # --------------------------------------------------------------------------
  # Account Lifecycle Scenarios
  # --------------------------------------------------------------------------
  @account-lifecycle
  Scenario: Deactivate account temporarily
    Given I want to take a break
    When I deactivate my account
    Then my account should be hidden
    And I should be able to reactivate
    And my data should be preserved

  @account-lifecycle
  Scenario: Submit deletion request
    Given I want to delete my account
    When I submit deletion request
    Then I should understand consequences
    And I should have a grace period
    And I should confirm the request

  @account-lifecycle
  Scenario: Understand data retention after deletion
    Given I am deleting my account
    When I review retention policies
    Then I should see what is kept
    And I should see for how long
    And legal requirements should be noted

  @account-lifecycle
  Scenario: Reactivate deactivated account
    Given my account is deactivated
    When I reactivate my account
    Then I should log in successfully
    And my data should be restored
    And my profile should be visible again

  @account-lifecycle
  Scenario: Cancel account deletion
    Given I requested deletion
    And the grace period is active
    When I cancel the deletion
    Then my account should be preserved
    And I should be notified
    And normal access should resume

  @account-lifecycle
  Scenario: Transfer account ownership
    Given I want to transfer ownership
    When I initiate transfer
    Then I should specify the recipient
    And they should accept
    And ownership should transfer

  @account-lifecycle
  Scenario: Handle inherited accounts
    Given account ownership can transfer
    When ownership needs transfer
    Then verification should occur
    And the transfer should be secure
    And records should be updated

  @account-lifecycle
  Scenario: View account status
    Given my account may have status changes
    When I view account status
    Then I should see current status
    And any restrictions should be shown
    And I should understand next steps

  # --------------------------------------------------------------------------
  # Error Handling Scenarios
  # --------------------------------------------------------------------------
  @error-handling
  Scenario: Handle registration failure
    Given I am registering
    And registration fails
    When the error occurs
    Then I should see a clear message
    And I should be able to retry
    And my data should be preserved

  @error-handling
  Scenario: Handle login failure
    Given I am logging in
    And authentication fails
    When the error occurs
    Then I should see what went wrong
    And I should be offered help
    And attempts should be limited

  @error-handling
  Scenario: Handle password change failure
    Given I am changing password
    And the change fails
    When the error occurs
    Then I should see the reason
    And my old password should remain
    And I should be able to retry

  @error-handling
  Scenario: Handle payment processing error
    Given I am making a payment
    And the payment fails
    When the error occurs
    Then I should see the issue
    And I should be able to retry
    And my subscription should be unaffected

  @error-handling
  Scenario: Handle data export failure
    Given I am exporting data
    And the export fails
    When the error occurs
    Then I should be notified
    And I should be able to retry
    And partial exports should be handled

  @error-handling
  Scenario: Handle account recovery failure
    Given I am recovering my account
    And recovery fails
    When the error occurs
    Then I should see alternative options
    And support contact should be offered
    And security should not be compromised

  @error-handling
  Scenario: Handle session validation error
    Given my session validation fails
    When the error occurs
    Then I should be logged out safely
    And I should be able to re-login
    And my data should be safe

  @error-handling
  Scenario: Handle integration sync failure
    Given I am syncing integrations
    And the sync fails
    When the error occurs
    Then I should be notified
    And I should see what failed
    And I should be able to retry

  # --------------------------------------------------------------------------
  # Accessibility Scenarios
  # --------------------------------------------------------------------------
  @accessibility
  Scenario: Navigate account pages with keyboard
    Given I am on account pages
    When I navigate using only keyboard
    Then all features should be accessible
    And forms should be navigable
    And focus should be clearly visible

  @accessibility
  Scenario: Use account features with screen reader
    Given I am using a screen reader
    When I access account features
    Then all content should be announced
    And form fields should be labeled
    And errors should be announced

  @accessibility
  Scenario: View account pages in high contrast
    Given I have high contrast mode enabled
    When I view account pages
    Then all elements should be visible
    And text should be readable
    And buttons should be distinguishable

  @accessibility
  Scenario: Complete registration accessibly
    Given I am registering with assistive tech
    When I complete registration
    Then all steps should be accessible
    And progress should be communicated
    And errors should be clear

  @accessibility
  Scenario: Manage security settings accessibly
    Given I need to manage security
    When I use assistive technology
    Then all options should be accessible
    And 2FA setup should be possible
    And confirmations should be clear

  @accessibility
  Scenario: Access account recovery accessibly
    Given I need to recover my account
    When I use assistive technology
    Then recovery should be fully accessible
    And steps should be communicated
    And I should complete recovery

  @accessibility
  Scenario: Configure preferences accessibly
    Given I am setting preferences
    When I use assistive technology
    Then all options should be navigable
    And changes should be confirmed
    And I should save settings

  @accessibility
  Scenario: View subscription info accessibly
    Given I am viewing subscription
    When I use assistive technology
    Then all information should be accessible
    And actions should be available
    And confirmations should be clear

  # --------------------------------------------------------------------------
  # Performance Scenarios
  # --------------------------------------------------------------------------
  @performance
  Scenario: Load account pages quickly
    Given I am accessing account settings
    When the page loads
    Then it should load within 2 seconds
    And all sections should be visible
    And the interface should be responsive

  @performance
  Scenario: Process authentication quickly
    Given I am logging in
    When I submit credentials
    Then authentication should complete within 2 seconds
    And session should be created quickly
    And redirect should be immediate

  @performance
  Scenario: Handle profile updates efficiently
    Given I am updating my profile
    When I save changes
    Then changes should save quickly
    And feedback should be immediate
    And no lag should be noticeable

  @performance
  Scenario: Process payment quickly
    Given I am making a payment
    When the payment processes
    Then processing should be efficient
    And confirmation should appear quickly
    And the experience should be smooth

  @performance
  Scenario: Generate data export efficiently
    Given I am exporting data
    When the export runs
    Then it should complete efficiently
    And progress should be shown
    And the download should be ready quickly

  @performance
  Scenario: Handle concurrent account access
    Given I access my account from multiple places
    When all sessions are active
    Then all should work smoothly
    And no conflicts should occur
    And data should be consistent

  @performance
  Scenario: Load security settings quickly
    Given I am accessing security settings
    When the page loads
    Then settings should appear quickly
    And session list should load
    And the interface should be responsive

  @performance
  Scenario: Cache account data appropriately
    Given I access account pages frequently
    When I return to pages
    Then cached data should load quickly
    And updates should be reflected
    And cache should be managed properly
