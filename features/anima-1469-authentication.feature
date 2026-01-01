@authentication
Feature: Authentication
  As a fantasy football user
  I want secure authentication options
  So that my account and data are protected

  # --------------------------------------------------------------------------
  # User Registration
  # --------------------------------------------------------------------------

  @user-registration
  Scenario: Register with email and password
    Given I am on the registration page
    When I enter a valid email address
    And I enter a valid username
    And I enter a password meeting requirements
    And I confirm the password
    And I accept the terms of service
    And I submit the registration form
    Then my account should be created
    And I should receive a verification email

  @user-registration
  Scenario: Validate username requirements
    Given I am on the registration page
    When I enter a username
    Then the username should be at least 3 characters
    And the username should be at most 20 characters
    And the username should only contain allowed characters
    And the username should not be already taken

  @user-registration
  Scenario: Validate password requirements
    Given I am on the registration page
    When I enter a password
    Then I should see password strength indicator
    And the password should be at least 8 characters
    And the password should contain uppercase and lowercase
    And the password should contain at least one number
    And the password should contain a special character

  @user-registration
  Scenario: Verify email address
    Given I have registered for an account
    And I have received a verification email
    When I click the verification link
    Then my email should be verified
    And I should be able to log in
    And I should see verification confirmation

  @user-registration
  Scenario: Resend verification email
    Given I have registered but not verified my email
    When I request to resend verification email
    Then a new verification email should be sent
    And the old verification link should be invalidated

  @user-registration
  Scenario: Handle duplicate email registration
    Given I am on the registration page
    When I enter an email that is already registered
    And I submit the registration form
    Then I should see an error message
    And I should be offered password reset option

  @user-registration
  Scenario: Handle expired verification link
    Given I have a verification link that has expired
    When I click the expired link
    Then I should see an expiration message
    And I should be able to request a new verification email

  # --------------------------------------------------------------------------
  # User Login
  # --------------------------------------------------------------------------

  @user-login
  Scenario: Login with email and password
    Given I am on the login page
    And I have a verified account
    When I enter my email address
    And I enter my password
    And I click login
    Then I should be logged in successfully
    And I should be redirected to the dashboard

  @user-login
  Scenario: Login with remember me option
    Given I am on the login page
    When I enter valid credentials
    And I check the remember me option
    And I log in
    Then my session should persist longer
    And I should remain logged in on next visit

  @user-login
  Scenario: Handle incorrect password
    Given I am on the login page
    When I enter my email address
    And I enter an incorrect password
    Then I should see an authentication error
    And I should not be logged in
    And I should be offered password reset

  @user-login
  Scenario: Track failed login attempts
    Given I am on the login page
    When I enter incorrect credentials multiple times
    Then failed attempts should be tracked
    And I should see warning about remaining attempts
    And I should see increasing delay between attempts

  @user-login
  Scenario: Account lockout after failed attempts
    Given I have exceeded maximum login attempts
    When I try to log in again
    Then my account should be temporarily locked
    And I should see lockout duration
    And I should be offered account recovery options

  @user-login
  Scenario: Login from new device
    Given I am logging in from a new device
    When I enter valid credentials
    Then I may be prompted for additional verification
    And I should receive a new device login notification
    And the device should be logged in login history

  @user-login
  Scenario: Login with case-insensitive email
    Given I am on the login page
    When I enter my email with different case
    And I enter correct password
    Then I should be logged in successfully

  # --------------------------------------------------------------------------
  # Social Login
  # --------------------------------------------------------------------------

  @social-login
  Scenario: Login with Google OAuth
    Given I am on the login page
    When I click Sign in with Google
    And I authorize the application on Google
    Then I should be logged in with my Google account
    And my profile should be created from Google data

  @social-login
  Scenario: Login with Apple Sign-In
    Given I am on the login page
    When I click Sign in with Apple
    And I authorize with Apple ID
    Then I should be logged in with my Apple account
    And I should be able to hide my email if desired

  @social-login
  Scenario: Login with Facebook
    Given I am on the login page
    When I click Sign in with Facebook
    And I authorize the application on Facebook
    Then I should be logged in with my Facebook account
    And my profile should be created from Facebook data

  @social-login
  Scenario: Login with Twitter/X
    Given I am on the login page
    When I click Sign in with Twitter
    And I authorize the application on Twitter
    Then I should be logged in with my Twitter account
    And my profile should be created from Twitter data

  @social-login
  Scenario: Link social account to existing account
    Given I am logged in with email/password
    When I link my Google account
    Then I should be able to login with Google
    And my accounts should be linked
    And I can choose which method to use

  @social-login
  Scenario: Unlink social account
    Given I have a linked social account
    And I have another login method available
    When I unlink the social account
    Then the social login should be removed
    And I should still be able to log in with other methods

  @social-login
  Scenario: Handle social login with existing email
    Given I try to login with a social account
    And the social account email matches existing account
    When I complete social login
    Then I should be prompted to link accounts
    And I should verify ownership of existing account

  # --------------------------------------------------------------------------
  # Password Management
  # --------------------------------------------------------------------------

  @password-management
  Scenario: Request forgot password
    Given I am on the login page
    When I click forgot password
    And I enter my email address
    Then I should receive a password reset email
    And the email should contain a reset link
    And I should see confirmation message

  @password-management
  Scenario: Reset password via email link
    Given I have received a password reset email
    When I click the reset link
    And I enter a new password
    And I confirm the new password
    Then my password should be updated
    And I should be logged in automatically
    And I should receive confirmation email

  @password-management
  Scenario: Change password while logged in
    Given I am logged in
    When I navigate to password settings
    And I enter my current password
    And I enter a new password
    And I confirm the new password
    Then my password should be changed
    And other sessions should be invalidated

  @password-management
  Scenario: Validate password strength
    Given I am changing my password
    When I enter a new password
    Then I should see real-time strength indicator
    And weak passwords should show warnings
    And I should see suggestions for improvement

  @password-management
  Scenario: Prevent password reuse
    Given I am changing my password
    When I enter a password I have used before
    Then I should see a password reuse error
    And I should be required to choose a different password

  @password-management
  Scenario: Handle expired password reset link
    Given I have a password reset link that has expired
    When I click the expired link
    Then I should see an expiration message
    And I should be able to request a new reset link

  @password-management
  Scenario: Rate limit password reset requests
    Given I have requested multiple password resets
    When I exceed the rate limit
    Then I should see a rate limit message
    And I should wait before requesting again

  # --------------------------------------------------------------------------
  # Multi-Factor Authentication
  # --------------------------------------------------------------------------

  @mfa
  Scenario: Set up MFA with authenticator app
    Given I am logged in
    When I enable multi-factor authentication
    And I scan the QR code with my authenticator app
    And I enter the verification code
    Then MFA should be enabled on my account
    And I should receive backup codes

  @mfa
  Scenario: Login with MFA enabled
    Given I have MFA enabled
    When I log in with my credentials
    Then I should be prompted for MFA code
    And I should enter my authenticator code
    And I should be logged in after verification

  @mfa
  Scenario: Set up SMS verification
    Given I am logged in
    When I enable SMS verification
    And I enter my phone number
    And I verify with the SMS code
    Then SMS verification should be enabled
    And I should receive codes via SMS at login

  @mfa
  Scenario: Use backup codes for MFA
    Given I have MFA enabled
    And I cannot access my authenticator
    When I log in and choose backup code option
    And I enter a valid backup code
    Then I should be logged in
    And the backup code should be invalidated

  @mfa
  Scenario: Generate new backup codes
    Given I am logged in
    And I have MFA enabled
    When I generate new backup codes
    Then new backup codes should be created
    And old backup codes should be invalidated
    And I should download or save the new codes

  @mfa
  Scenario: Disable MFA
    Given I have MFA enabled
    When I disable multi-factor authentication
    And I confirm with my password
    And I enter my MFA code
    Then MFA should be disabled
    And I should see confirmation

  @mfa
  Scenario: Remember trusted device for MFA
    Given I have MFA enabled
    When I log in with MFA
    And I check trust this device
    Then I should not need MFA on this device for configured period
    And the device should appear in trusted devices

  # --------------------------------------------------------------------------
  # Session Management
  # --------------------------------------------------------------------------

  @session-management
  Scenario: Create session token on login
    Given I log in successfully
    Then a secure session token should be created
    And the token should be stored securely
    And the token should have appropriate expiry

  @session-management
  Scenario: Handle session expiration
    Given I am logged in
    And my session has expired
    When I try to perform an action
    Then I should be redirected to login
    And I should see session expired message
    And I should be able to log in again

  @session-management
  Scenario: Manage concurrent sessions
    Given I am logged in on multiple devices
    When I view my active sessions
    Then I should see all active sessions
    And I should see device information
    And I should see last activity time

  @session-management
  Scenario: Revoke specific session
    Given I am logged in on multiple devices
    When I revoke a specific session
    Then that session should be terminated
    And the device should be logged out
    And I should see confirmation

  @session-management
  Scenario: Logout from all devices
    Given I am logged in on multiple devices
    When I logout from all devices
    Then all sessions should be terminated
    And I should be logged out everywhere
    And I should need to log in again on each device

  @session-management
  Scenario: Extend session on activity
    Given I am logged in
    When I perform actions in the application
    Then my session should be extended
    And session timeout should reset

  @session-management
  Scenario: Handle session on password change
    Given I am logged in on multiple devices
    When I change my password
    Then all other sessions should be invalidated
    And I should remain logged in on current device
    And other devices should require new login

  # --------------------------------------------------------------------------
  # Account Security
  # --------------------------------------------------------------------------

  @account-security
  Scenario: Set up security questions
    Given I am logged in
    When I navigate to security settings
    And I set up security questions
    Then I should select questions from list
    And I should provide answers
    And security questions should be saved

  @account-security
  Scenario: Manage trusted devices
    Given I am logged in
    When I view trusted devices
    Then I should see all trusted devices
    And I should see device details
    And I should be able to remove trusted status

  @account-security
  Scenario: View login history
    Given I am logged in
    When I view my login history
    Then I should see recent login attempts
    And I should see successful and failed logins
    And I should see IP addresses and locations
    And I should see timestamps and devices

  @account-security
  Scenario: Detect suspicious activity
    Given I am logged in
    When suspicious activity is detected on my account
    Then I should be notified immediately
    And I should see details of the activity
    And I should be offered security actions

  @account-security
  Scenario: Enable login notifications
    Given I am logged in
    When I enable login notifications
    Then I should receive alerts on new logins
    And I should be notified of new device logins
    And I should be able to act on suspicious logins

  @account-security
  Scenario: Require re-authentication for sensitive actions
    Given I am logged in
    When I try to perform a sensitive action
    Then I should be prompted to re-authenticate
    And I should enter my password
    And the action should complete after verification

  # --------------------------------------------------------------------------
  # Single Sign-On
  # --------------------------------------------------------------------------

  @sso
  Scenario: Login via SSO provider
    Given my organization uses SSO
    When I click login with SSO
    And I enter my organization domain
    Then I should be redirected to SSO provider
    And I should authenticate with my organization
    And I should be logged in automatically

  @sso
  Scenario: Configure SAML integration
    Given I am an organization admin
    When I configure SAML SSO
    And I provide SAML metadata
    And I configure attribute mappings
    Then SAML SSO should be enabled
    And organization members should use SAML login

  @sso
  Scenario: Enterprise SSO enforcement
    Given my organization requires SSO
    When I try to login with email/password
    Then I should be redirected to SSO
    And I should not be able to bypass SSO
    And I should see organization login requirement

  @sso
  Scenario: SSO logout
    Given I am logged in via SSO
    When I log out
    Then I should be logged out of the application
    And I should be optionally logged out of SSO provider
    And my SSO session should be terminated

  @sso
  Scenario: Handle SSO provider unavailability
    Given my organization uses SSO
    And the SSO provider is unavailable
    When I try to log in
    Then I should see an error message
    And I should be offered alternative login if configured
    And I should see status of SSO provider

  # --------------------------------------------------------------------------
  # API Authentication
  # --------------------------------------------------------------------------

  @api-authentication
  Scenario: Generate API key
    Given I am logged in
    When I navigate to API settings
    And I generate a new API key
    Then an API key should be created
    And I should see the key only once
    And I should be able to set key permissions

  @api-authentication
  Scenario: Authenticate with JWT token
    Given I have valid credentials
    When I request a JWT token via API
    Then I should receive an access token
    And I should receive a refresh token
    And the token should have appropriate claims

  @api-authentication
  Scenario: Refresh expired access token
    Given I have a valid refresh token
    And my access token has expired
    When I request a new access token
    Then I should receive a new access token
    And my session should continue
    And the refresh token should be rotated

  @api-authentication
  Scenario: OAuth2 authorization code flow
    Given I am implementing OAuth2 integration
    When I initiate authorization code flow
    And I authorize the application
    Then I should receive an authorization code
    And I can exchange the code for tokens
    And tokens should have requested scopes

  @api-authentication
  Scenario: Revoke API key
    Given I have generated API keys
    When I revoke an API key
    Then the key should be invalidated immediately
    And requests with that key should fail
    And I should see revocation confirmation

  @api-authentication
  Scenario: Set API key permissions
    Given I am generating an API key
    When I configure key permissions
    Then I should be able to set read/write access
    And I should be able to limit to specific endpoints
    And I should be able to set key expiration

  @api-authentication
  Scenario: Rate limit API authentication
    Given I am authenticating via API
    When I exceed authentication rate limits
    Then I should receive rate limit error
    And I should see retry-after header
    And excessive attempts should be logged

  # --------------------------------------------------------------------------
  # Account Recovery
  # --------------------------------------------------------------------------

  @account-recovery
  Scenario: Recover account via recovery email
    Given I cannot access my primary email
    And I have a recovery email configured
    When I initiate account recovery
    And I verify via recovery email
    Then I should regain access to my account
    And I should be prompted to update primary email

  @account-recovery
  Scenario: Recover account via recovery phone
    Given I cannot access my email
    And I have a recovery phone configured
    When I initiate account recovery via phone
    And I verify with SMS code
    Then I should regain access to my account
    And I should be prompted to secure my account

  @account-recovery
  Scenario: Identity verification for recovery
    Given I cannot access normal recovery methods
    When I request identity verification
    Then I should be asked to verify identity
    And I should provide identity documents
    And support should review my request

  @account-recovery
  Scenario: Unlock locked account
    Given my account has been locked
    When I receive the unlock email
    And I click the unlock link
    And I verify my identity
    Then my account should be unlocked
    And I should be able to log in
    And I should review security settings

  @account-recovery
  Scenario: Recovery with security questions
    Given I have set up security questions
    When I initiate account recovery
    And I answer security questions correctly
    Then I should be able to reset my password
    And I should regain account access

  @account-recovery
  Scenario: Recovery using backup codes
    Given I have MFA backup codes
    And I cannot access my normal MFA method
    When I use a backup code for recovery
    Then I should regain access to my account
    And I should be prompted to set up new MFA

  # --------------------------------------------------------------------------
  # Error Handling and Edge Cases
  # --------------------------------------------------------------------------

  @authentication @error-handling
  Scenario: Handle network errors during authentication
    Given I am trying to log in
    When a network error occurs
    Then I should see a clear error message
    And I should be able to retry
    And my credentials should not be exposed

  @authentication @error-handling
  Scenario: Handle invalid session token
    Given I have an invalid session token
    When I try to access protected resources
    Then I should be redirected to login
    And I should see session invalid message
    And I should be able to log in fresh

  @authentication @security
  Scenario: Prevent brute force attacks
    Given there are multiple failed login attempts
    When a brute force attack is detected
    Then the account should be protected
    And CAPTCHA should be required
    And security team should be notified

  @authentication @security
  Scenario: Secure password transmission
    Given I am submitting my password
    Then the password should be transmitted securely
    And the password should never be logged
    And the password should be hashed before storage

  @authentication @security
  Scenario: Prevent session hijacking
    Given I am logged in
    Then session tokens should be secure
    And tokens should be bound to device/IP when possible
    And session fixation should be prevented
