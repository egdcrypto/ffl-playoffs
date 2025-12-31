@authentication @ANIMA-1334
Feature: Authentication
  As a fantasy football application user
  I want secure authentication functionality
  So that I can safely access my account and protect my data

  Background:
    Given the fantasy football playoffs application is running

  # ============================================================================
  # USER REGISTRATION - HAPPY PATH
  # ============================================================================

  @happy-path @registration
  Scenario: View registration page
    Given I am not logged in
    When I navigate to the registration page
    Then I should see the registration form
    And I should see required fields
    And I should see terms and conditions link

  @happy-path @registration
  Scenario: Register with email and password
    Given I am on the registration page
    When I enter a valid email
    And I enter a strong password
    And I confirm the password
    And I accept terms and conditions
    And I submit the registration
    Then my account should be created
    And I should receive a verification email
    And I should see confirmation message

  @happy-path @registration
  Scenario: Register with username
    Given I am on the registration page
    When I enter a unique username
    And I complete other required fields
    Then my username should be validated
    And my account should include the username
    And I should be able to login with username

  @happy-path @registration
  Scenario: View password requirements
    Given I am on the registration page
    When I focus on the password field
    Then I should see password requirements
    And requirements should update as I type
    And I should meet all requirements

  @happy-path @registration
  Scenario: Accept terms and privacy policy
    Given I am registering
    When I view terms and conditions
    Then I should see the full terms
    And I should see the privacy policy
    And I should accept before continuing

  @happy-path @registration
  Scenario: Complete registration with optional fields
    Given I am registering
    When I fill out optional profile fields
    Then my profile should be more complete
    And I should skip optional fields if desired
    And registration should complete

  # ============================================================================
  # LOGIN/LOGOUT
  # ============================================================================

  @happy-path @login
  Scenario: Login with email and password
    Given I am a registered user
    And I am on the login page
    When I enter my email
    And I enter my password
    And I submit the login form
    Then I should be logged in
    And I should be redirected to dashboard
    And my session should be active

  @happy-path @login
  Scenario: Login with username and password
    Given I have a username set
    When I login with my username
    And I enter my password
    Then I should be authenticated
    And I should access my account
    And login should succeed

  @happy-path @login
  Scenario: Remember me option
    Given I am logging in
    When I check remember me
    And I complete login
    Then my session should persist longer
    And I should not need to login frequently
    And I can disable this later

  @happy-path @login
  Scenario: Logout successfully
    Given I am logged in
    When I click logout
    Then I should be logged out
    And my session should be terminated
    And I should be redirected to home

  @happy-path @login
  Scenario: Logout from all devices
    Given I am logged in on multiple devices
    When I logout from all devices
    Then all sessions should be terminated
    And I should be logged out everywhere
    And the action should be confirmed

  @happy-path @login
  Scenario: Session timeout
    Given I am logged in
    When my session expires due to inactivity
    Then I should be logged out
    And I should see session expired message
    And I should login again

  # ============================================================================
  # PASSWORD MANAGEMENT
  # ============================================================================

  @happy-path @password-management
  Scenario: Change password
    Given I am logged in
    When I access password settings
    And I enter current password
    And I enter new password
    And I confirm new password
    Then my password should be changed
    And I should receive confirmation
    And old password should not work

  @happy-path @password-management
  Scenario: Password strength validation
    Given I am setting a new password
    When I enter a password
    Then I should see strength indicator
    And weak passwords should be rejected
    And I should be guided to stronger password

  @happy-path @password-management
  Scenario: Password complexity requirements
    Given I am setting a password
    When I enter characters
    Then I should meet minimum length
    And I should include uppercase
    And I should include numbers or symbols

  @happy-path @password-management
  Scenario: View password while typing
    Given I am entering a password
    When I click show password
    Then the password should be visible
    And I should hide it again
    And I should verify what I typed

  @happy-path @password-management
  Scenario: Prevent password reuse
    Given I am changing my password
    When I enter a previously used password
    Then the password should be rejected
    And I should be informed of the policy
    And I should choose a different password

  # ============================================================================
  # SOCIAL LOGIN
  # ============================================================================

  @happy-path @social-login
  Scenario: Login with Google
    Given I am on the login page
    When I click login with Google
    Then I should be redirected to Google
    And I should authorize the app
    And I should be logged in

  @happy-path @social-login
  Scenario: Login with Facebook
    Given I am on the login page
    When I click login with Facebook
    Then I should be redirected to Facebook
    And I should authorize the app
    And I should be logged in

  @happy-path @social-login
  Scenario: Login with Apple
    Given I am on the login page
    When I click login with Apple
    Then I should be redirected to Apple
    And I should authorize with Apple ID
    And I should be logged in with privacy

  @happy-path @social-login
  Scenario: Register via social login
    Given I am a new user
    When I login with a social provider
    Then my account should be created
    And my profile should be populated
    And I should complete any required info

  @happy-path @social-login
  Scenario: Link social account to existing profile
    Given I am logged in
    When I link a social account
    Then the account should be connected
    And I should login with either method
    And the link should be confirmed

  @happy-path @social-login
  Scenario: Unlink social account
    Given I have a linked social account
    When I unlink the account
    Then the connection should be removed
    And I should have password login as backup
    And I should confirm the unlink

  # ============================================================================
  # TWO-FACTOR AUTHENTICATION
  # ============================================================================

  @happy-path @two-factor-auth
  Scenario: Enable two-factor authentication
    Given I am logged in
    When I enable 2FA
    Then I should see setup instructions
    And I should scan QR code with authenticator
    And I should verify with a code

  @happy-path @two-factor-auth
  Scenario: Login with 2FA enabled
    Given I have 2FA enabled
    When I login with password
    Then I should be prompted for 2FA code
    And I should enter the code
    And I should be fully authenticated

  @happy-path @two-factor-auth
  Scenario: Generate backup codes
    Given I have 2FA enabled
    When I generate backup codes
    Then I should receive one-time codes
    And I should store them securely
    And I can use them if I lose my device

  @happy-path @two-factor-auth
  Scenario: Use backup code for login
    Given I cannot access my authenticator
    When I use a backup code
    Then I should be logged in
    And the code should be consumed
    And I should generate new codes

  @happy-path @two-factor-auth
  Scenario: Disable two-factor authentication
    Given I have 2FA enabled
    When I disable 2FA
    Then I should verify my identity
    And 2FA should be removed
    And I should be warned about security

  @happy-path @two-factor-auth
  Scenario: Set up SMS as 2FA backup
    Given I am setting up 2FA
    When I add SMS as backup
    Then I should verify my phone number
    And SMS should be available as fallback
    And I can receive codes via text

  @happy-path @two-factor-auth
  Scenario: Recover account with 2FA lost
    Given I lost my 2FA device
    When I request account recovery
    Then I should verify identity other ways
    And I should regain access
    And I should set up new 2FA

  # ============================================================================
  # SESSION MANAGEMENT
  # ============================================================================

  @happy-path @session-management
  Scenario: View active sessions
    Given I am logged in
    When I view my active sessions
    Then I should see all logged in devices
    And I should see locations and times
    And I should see device types

  @happy-path @session-management
  Scenario: Terminate specific session
    Given I have multiple active sessions
    When I terminate one session
    Then that session should be ended
    And the device should be logged out
    And other sessions should remain

  @happy-path @session-management
  Scenario: Terminate all other sessions
    Given I have multiple sessions
    When I terminate all other sessions
    Then only my current session should remain
    And other devices should be logged out
    And I should stay logged in

  @happy-path @session-management
  Scenario: Detect suspicious session
    Given there is an unusual login
    When the system detects it
    Then I should be alerted
    And I should review the session
    And I should terminate if needed

  @happy-path @session-management
  Scenario: Session information display
    Given I am viewing sessions
    When I check session details
    Then I should see IP address
    And I should see browser/app info
    And I should see last activity time

  # ============================================================================
  # PASSWORD RECOVERY
  # ============================================================================

  @happy-path @password-recovery
  Scenario: Request password reset
    Given I forgot my password
    When I click forgot password
    And I enter my email address
    Then I should receive a reset email
    And the email should contain a link
    And I should be informed to check email

  @happy-path @password-recovery
  Scenario: Reset password via email link
    Given I received a reset email
    When I click the reset link
    Then I should see reset password form
    And I should enter a new password
    And my password should be updated

  @happy-path @password-recovery
  Scenario: Password reset link expiration
    Given I requested a password reset
    When I wait too long to use the link
    Then the link should expire
    And I should request a new link
    And expiration should be communicated

  @happy-path @password-recovery
  Scenario: Recover via security questions
    Given I set up security questions
    When I use security question recovery
    Then I should answer my questions
    And correct answers should grant access
    And I should reset my password

  @happy-path @password-recovery
  Scenario: Account recovery options
    Given I cannot access my account
    When I view recovery options
    Then I should see email recovery
    And I should see phone recovery
    And I should see other verification methods

  # ============================================================================
  # EMAIL VERIFICATION
  # ============================================================================

  @happy-path @email-verification
  Scenario: Verify email after registration
    Given I just registered
    When I receive verification email
    And I click the verification link
    Then my email should be verified
    And I should have full account access
    And verification should be confirmed

  @happy-path @email-verification
  Scenario: Resend verification email
    Given I have not verified my email
    When I request a new verification email
    Then a new email should be sent
    And the old link should be invalidated
    And I should check my inbox

  @happy-path @email-verification
  Scenario: Change email requires verification
    Given I am changing my email
    When I submit the new email
    Then a verification should be sent
    And I should verify the new email
    And the change should complete

  @happy-path @email-verification
  Scenario: Verification email expiration
    Given I received a verification email
    When I wait too long to verify
    Then the link should expire
    And I should request a new link
    And I should be informed

  # ============================================================================
  # ACCOUNT SECURITY
  # ============================================================================

  @happy-path @account-security
  Scenario: View account security status
    Given I am logged in
    When I view security status
    Then I should see security score
    And I should see recommendations
    And I should see recent activity

  @happy-path @account-security
  Scenario: Enable login notifications
    Given I am in security settings
    When I enable login notifications
    Then I should be notified of new logins
    And I should see device information
    And I can act on suspicious logins

  @happy-path @account-security
  Scenario: Set up trusted devices
    Given I am logging in
    When I mark device as trusted
    Then future logins should be easier
    And I should not need 2FA each time
    And I can remove trusted status

  @happy-path @account-security
  Scenario: Security checkup
    Given I want to review security
    When I run security checkup
    Then my settings should be reviewed
    And I should see vulnerabilities
    And I should get improvement suggestions

  @happy-path @account-security
  Scenario: Account lockout after failed attempts
    Given someone tries to login
    When multiple failed attempts occur
    Then the account should be temporarily locked
    And I should be notified
    And legitimate user should unlock

  @happy-path @account-security
  Scenario: Suspicious activity detection
    Given there is suspicious activity
    When the system detects it
    Then I should be alerted immediately
    And I should review the activity
    And I should secure my account

  # ============================================================================
  # LOGIN HISTORY
  # ============================================================================

  @happy-path @login-history
  Scenario: View login history
    Given I am logged in
    When I view login history
    Then I should see past logins
    And I should see dates and times
    And I should see locations and devices

  @happy-path @login-history
  Scenario: Filter login history
    Given I have login history
    When I filter the history
    Then I should filter by date
    And I should filter by device type
    And I should filter by success/failure

  @happy-path @login-history
  Scenario: Identify unfamiliar login
    Given I am reviewing login history
    When I see an unfamiliar login
    Then I should investigate
    And I should change my password
    And I should secure my account

  @happy-path @login-history
  Scenario: Export login history
    Given I want a record of logins
    When I export login history
    Then I should receive a file
    And it should contain login data
    And the format should be readable

  # ============================================================================
  # DEVICE MANAGEMENT
  # ============================================================================

  @happy-path @device-management
  Scenario: View registered devices
    Given I am logged in
    When I view my devices
    Then I should see all registered devices
    And I should see device names
    And I should see last used time

  @happy-path @device-management
  Scenario: Name a device
    Given I have a registered device
    When I name the device
    Then the name should be saved
    And I should recognize it easily
    And the name should be displayed

  @happy-path @device-management
  Scenario: Remove device
    Given I have a registered device
    When I remove the device
    Then it should be unregistered
    And future logins should require verification
    And the device should be logged out

  @happy-path @device-management
  Scenario: Detect new device login
    Given I login from a new device
    When the login is detected
    Then I should verify my identity
    And I should approve the device
    And I should receive notification

  @happy-path @device-management
  Scenario: Device limit enforcement
    Given there is a device limit
    When I exceed the limit
    Then I should remove a device
    And I should be informed of the limit
    And I should choose which to remove

  # ============================================================================
  # OAUTH INTEGRATION
  # ============================================================================

  @happy-path @oauth-integration
  Scenario: View connected OAuth apps
    Given I have authorized apps
    When I view connected apps
    Then I should see all authorized apps
    And I should see permissions granted
    And I should see last used time

  @happy-path @oauth-integration
  Scenario: Authorize new OAuth app
    Given an app requests authorization
    When I review the permissions
    Then I should see what it will access
    And I should approve or deny
    And the app should be connected

  @happy-path @oauth-integration
  Scenario: Revoke OAuth app access
    Given I have an authorized app
    When I revoke access
    Then the app should lose access
    And my data should be protected
    And the revocation should be confirmed

  @happy-path @oauth-integration
  Scenario: View OAuth app activity
    Given I have connected apps
    When I view app activity
    Then I should see what they accessed
    And I should see access times
    And I should monitor usage

  # ============================================================================
  # ERROR HANDLING
  # ============================================================================

  @error
  Scenario: Invalid login credentials
    Given I am trying to login
    When I enter wrong credentials
    Then I should see error message
    And I should not reveal which is wrong
    And I should try again

  @error
  Scenario: Registration with existing email
    Given I am registering
    When I use an already registered email
    Then I should see error message
    And I should login instead
    And I should use different email

  @error
  Scenario: Password reset for unknown email
    Given I request password reset
    When I enter unknown email
    Then I should see generic message
    And I should not reveal if email exists
    And security should be maintained

  @error
  Scenario: Social login failure
    Given I am using social login
    When the login fails
    Then I should see error message
    And I should retry
    And I should use alternative method

  @error
  Scenario: 2FA code invalid
    Given I am entering 2FA code
    When I enter wrong code
    Then I should see error message
    And I should try again
    And I should use backup code option

  # ============================================================================
  # MOBILE EXPERIENCE
  # ============================================================================

  @mobile
  Scenario: Login on mobile device
    Given I am using the mobile app
    When I login
    Then the login should work on mobile
    And biometric login should be available
    And the experience should be smooth

  @mobile
  Scenario: Biometric authentication
    Given I have biometric enabled
    When I open the app
    Then I should authenticate with fingerprint
    And I should authenticate with face
    And login should be quick

  @mobile
  Scenario: Mobile 2FA
    Given I have 2FA enabled
    When I login on mobile
    Then 2FA should work on mobile
    And push notifications should work
    And codes should be easy to enter

  @mobile
  Scenario: Mobile session management
    Given I am on mobile
    When I manage sessions
    Then I should view and manage sessions
    And the interface should be mobile-friendly
    And actions should work properly

  # ============================================================================
  # ACCESSIBILITY
  # ============================================================================

  @accessibility
  Scenario: Navigate authentication with keyboard
    Given I am using keyboard navigation
    When I use authentication features
    Then login form should be accessible
    And I should tab through fields
    And I should submit with keyboard

  @accessibility
  Scenario: Screen reader authentication access
    Given I am using a screen reader
    When I login or register
    Then forms should be labeled
    And errors should be announced
    And success should be communicated

  @accessibility
  Scenario: High contrast authentication display
    Given I have high contrast enabled
    When I view authentication pages
    Then forms should be visible
    And buttons should be clear
    And errors should be distinguishable

  @accessibility
  Scenario: Authentication with reduced motion
    Given I have reduced motion enabled
    When I use authentication
    Then animations should be minimal
    And transitions should be simple
    And functionality should work
