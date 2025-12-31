@authentication @anima-1366
Feature: Authentication
  As a fantasy football user
  I want to securely authenticate with the application
  So that I can access my account and protect my data

  Background:
    Given the authentication system is available
    And the application is accessible

  # ============================================================================
  # USER REGISTRATION
  # ============================================================================

  @happy-path @registration
  Scenario: Sign up with email and password
    Given I am on the registration page
    When I enter a valid email address
    And I enter a valid password
    And I confirm my password
    And I submit the registration form
    Then my account should be created
    And I should receive a verification email

  @happy-path @registration
  Scenario: Verify email address
    Given I have registered for an account
    And I received a verification email
    When I click the verification link
    Then my email should be verified
    And I should be able to log in

  @happy-path @registration
  Scenario: Select username during registration
    Given I am completing registration
    When I select a unique username
    Then the username should be validated
    And my username should be saved

  @happy-path @registration
  Scenario: Accept terms and conditions
    Given I am on the registration page
    When I review the terms and conditions
    And I accept the terms
    Then my acceptance should be recorded
    And I can complete registration

  @happy-path @registration
  Scenario: Resend verification email
    Given I have registered but not verified
    When I request a new verification email
    Then a new verification email should be sent
    And old verification links should be invalidated

  @error @registration
  Scenario: Attempt to register with existing email
    Given an account exists with a specific email
    When I try to register with the same email
    Then I should see an error message
    And registration should fail

  @error @registration
  Scenario: Attempt to register with weak password
    Given I am on the registration page
    When I enter a weak password
    Then I should see password strength warnings
    And I should be prompted to use a stronger password

  @error @registration
  Scenario: Attempt to register with invalid email format
    Given I am on the registration page
    When I enter an invalid email format
    Then I should see a validation error
    And registration should not proceed

  @error @registration
  Scenario: Attempt to register without accepting terms
    Given I am on the registration page
    When I submit without accepting terms
    Then I should see an error message
    And registration should fail

  # ============================================================================
  # USER LOGIN
  # ============================================================================

  @happy-path @login
  Scenario: Login with email and password
    Given I have a verified account
    When I enter my email and password
    And I submit the login form
    Then I should be logged in
    And I should be redirected to the dashboard

  @happy-path @login
  Scenario: Login with remember me enabled
    Given I am on the login page
    When I log in with remember me checked
    Then my session should persist longer
    And I should stay logged in on return

  @happy-path @login
  Scenario: Login persistence across browser sessions
    Given I logged in with remember me
    When I close and reopen the browser
    Then I should still be logged in
    And my session should be valid

  @happy-path @login
  Scenario: Login and session management
    Given I log in successfully
    Then a new session should be created
    And my session details should be recorded

  @happy-path @login
  Scenario: Login from new device
    Given I log in from a new device
    Then I should receive a new device notification
    And the device should be added to my trusted list

  @error @login
  Scenario: Attempt login with incorrect password
    Given I have a valid account
    When I enter an incorrect password
    Then I should see an authentication error
    And I should not be logged in

  @error @login
  Scenario: Attempt login with non-existent email
    Given no account exists with a specific email
    When I try to log in with that email
    Then I should see a generic error message
    And account existence should not be revealed

  @error @login
  Scenario: Attempt login with unverified email
    Given I have an unverified account
    When I try to log in
    Then I should see a verification required message
    And I should be prompted to verify my email

  # ============================================================================
  # SOCIAL LOGIN
  # ============================================================================

  @happy-path @social-login
  Scenario: Login with Google account
    Given I am on the login page
    When I click login with Google
    And I authorize the application
    Then I should be logged in with my Google account
    And my profile should be populated from Google

  @happy-path @social-login
  Scenario: Login with Facebook account
    Given I am on the login page
    When I click login with Facebook
    And I authorize the application
    Then I should be logged in with my Facebook account
    And my profile should be populated from Facebook

  @happy-path @social-login
  Scenario: Login with Apple account
    Given I am on the login page
    When I click login with Apple
    And I authorize the application
    Then I should be logged in with my Apple account
    And my privacy preferences should be respected

  @happy-path @social-login
  Scenario: Login with Twitter account
    Given I am on the login page
    When I click login with Twitter
    And I authorize the application
    Then I should be logged in with my Twitter account

  @happy-path @social-login
  Scenario: Login with Yahoo account
    Given I am on the login page
    When I click login with Yahoo
    And I authorize the application
    Then I should be logged in with my Yahoo account

  @happy-path @social-login
  Scenario: Link social account to existing account
    Given I have an existing account
    When I link a social account
    Then the social account should be connected
    And I can log in with either method

  @error @social-login
  Scenario: Handle social login authorization denied
    Given I am logging in with a social provider
    When I deny authorization
    Then I should be returned to the login page
    And I should see an authorization denied message

  @error @social-login
  Scenario: Handle social provider unavailable
    Given a social login provider is unavailable
    When I try to log in with that provider
    Then I should see an error message
    And I should be prompted to try another method

  # ============================================================================
  # PASSWORD MANAGEMENT
  # ============================================================================

  @happy-path @password-management
  Scenario: Request password reset
    Given I forgot my password
    When I request a password reset
    And I enter my email address
    Then I should receive a password reset email
    And the email should contain a reset link

  @happy-path @password-management
  Scenario: Reset password with valid link
    Given I have a valid password reset link
    When I click the link
    And I enter a new password
    Then my password should be updated
    And I should be able to log in with new password

  @happy-path @password-management
  Scenario: Change password while logged in
    Given I am logged in
    When I go to change password
    And I enter my current password
    And I enter a new password
    Then my password should be updated
    And I should see confirmation

  @happy-path @password-management
  Scenario: View password strength indicator
    Given I am entering a new password
    Then I should see a password strength indicator
    And the indicator should update as I type

  @error @password-management
  Scenario: Attempt reset with expired link
    Given my password reset link has expired
    When I click the link
    Then I should see an expiration error
    And I should be prompted to request a new link

  @error @password-management
  Scenario: Attempt to use same password
    Given I am changing my password
    When I enter my current password as new password
    Then I should see an error message
    And I should be prompted to use a different password

  @error @password-management
  Scenario: Attempt password change with wrong current password
    Given I am changing my password
    When I enter an incorrect current password
    Then I should see an authentication error
    And my password should not be changed

  # ============================================================================
  # TWO-FACTOR AUTHENTICATION
  # ============================================================================

  @happy-path @two-factor-auth
  Scenario: Enable SMS two-factor authentication
    Given I am in security settings
    When I enable SMS 2FA
    And I verify my phone number
    Then SMS 2FA should be enabled
    And I should receive backup codes

  @happy-path @two-factor-auth
  Scenario: Enable email two-factor authentication
    Given I am in security settings
    When I enable email 2FA
    Then email 2FA should be enabled
    And codes will be sent to my email

  @happy-path @two-factor-auth
  Scenario: Enable authenticator app
    Given I am in security settings
    When I enable authenticator app
    And I scan the QR code
    And I enter the verification code
    Then authenticator 2FA should be enabled

  @happy-path @two-factor-auth
  Scenario: Login with two-factor code
    Given 2FA is enabled on my account
    When I log in with email and password
    Then I should be prompted for 2FA code
    And I should enter the code to complete login

  @happy-path @two-factor-auth
  Scenario: Use backup code for login
    Given I cannot access my 2FA method
    When I use a backup code
    Then I should be logged in
    And the backup code should be marked as used

  @happy-path @two-factor-auth
  Scenario: Recover account with backup codes
    Given I have lost access to my 2FA device
    When I use a backup code for recovery
    Then I should regain access to my account
    And I should be prompted to set up new 2FA

  @happy-path @two-factor-auth
  Scenario: Generate new backup codes
    Given 2FA is enabled
    When I generate new backup codes
    Then I should receive new codes
    And old codes should be invalidated

  @error @two-factor-auth
  Scenario: Attempt login with invalid 2FA code
    Given 2FA is enabled on my account
    When I enter an invalid 2FA code
    Then I should see an error message
    And I should not be logged in

  # ============================================================================
  # SESSION MANAGEMENT
  # ============================================================================

  @happy-path @session-management
  Scenario: View active sessions
    Given I am logged in
    When I view my active sessions
    Then I should see all active sessions
    And each session should show device and location

  @happy-path @session-management
  Scenario: Session timeout
    Given I am logged in
    When my session times out due to inactivity
    Then I should be logged out
    And I should be prompted to log in again

  @happy-path @session-management
  Scenario: Force logout of specific session
    Given I have multiple active sessions
    When I force logout a specific session
    Then that session should be terminated
    And the device should be logged out

  @happy-path @session-management
  Scenario: Logout all other devices
    Given I am logged in on multiple devices
    When I logout all other devices
    Then only my current session should remain
    And other devices should be logged out

  @happy-path @session-management
  Scenario: Manage trusted devices
    Given I am in session management
    When I view my devices
    Then I should see all trusted devices
    And I should be able to remove devices

  @happy-path @session-management
  Scenario: Session refresh
    Given my session is about to expire
    When I perform an action
    Then my session should be refreshed
    And I should remain logged in

  # ============================================================================
  # ACCOUNT SECURITY
  # ============================================================================

  @happy-path @account-security
  Scenario: Receive login alert
    Given login alerts are enabled
    When I log in from a new location
    Then I should receive a login alert
    And the alert should show login details

  @happy-path @account-security
  Scenario: Detect suspicious activity
    Given unusual login patterns are detected
    Then I should receive a security alert
    And I should be prompted to verify my identity

  @happy-path @account-security
  Scenario: Account lockout after failed attempts
    Given I have exceeded failed login attempts
    Then my account should be temporarily locked
    And I should see a lockout message

  @happy-path @account-security
  Scenario: Unlock account after lockout period
    Given my account was locked
    When the lockout period expires
    Then my account should be unlocked
    And I should be able to attempt login

  @happy-path @account-security
  Scenario: View IP login history
    Given I am in security settings
    When I view login history
    Then I should see IP addresses of logins
    And I should see login locations

  @happy-path @account-security
  Scenario: Report suspicious activity
    Given I notice unauthorized access
    When I report suspicious activity
    Then my report should be submitted
    And my account should be secured

  @error @account-security
  Scenario: Handle brute force attack
    Given multiple failed login attempts are detected
    Then rate limiting should be applied
    And the attacker should be blocked

  # ============================================================================
  # TOKEN MANAGEMENT
  # ============================================================================

  @happy-path @token-management
  Scenario: Issue JWT token on login
    Given I log in successfully
    Then a JWT token should be issued
    And the token should contain my identity

  @happy-path @token-management
  Scenario: Refresh token before expiration
    Given my access token is about to expire
    When the refresh token is used
    Then a new access token should be issued
    And my session should continue

  @happy-path @token-management
  Scenario: Token expiration handling
    Given my token has expired
    When I try to access a protected resource
    Then I should receive an authentication error
    And I should be prompted to log in

  @happy-path @token-management
  Scenario: Revoke specific token
    Given I want to revoke a token
    When I revoke the token
    Then the token should be invalidated
    And it should no longer work

  @happy-path @token-management
  Scenario: Revoke all tokens
    Given I want to revoke all tokens
    When I revoke all tokens
    Then all tokens should be invalidated
    And all sessions should be logged out

  @happy-path @token-management
  Scenario: Token rotation on sensitive actions
    Given I perform a sensitive action
    Then my token should be rotated
    And old token should be invalidated

  # ============================================================================
  # SINGLE SIGN-ON
  # ============================================================================

  @happy-path @single-sign-on
  Scenario: SSO integration login
    Given my organization uses SSO
    When I log in through SSO
    Then I should be authenticated
    And I should be redirected to the app

  @happy-path @single-sign-on
  Scenario: SAML authentication
    Given SAML is configured
    When I initiate SAML login
    Then I should be redirected to identity provider
    And I should be authenticated on return

  @happy-path @single-sign-on
  Scenario: OAuth authentication flow
    Given OAuth is configured
    When I complete OAuth flow
    Then I should receive authorization
    And I should be logged in

  @happy-path @single-sign-on
  Scenario: Enterprise SSO login
    Given my company has enterprise SSO
    When I enter my corporate email
    Then I should be redirected to corporate login
    And I should be authenticated

  @error @single-sign-on
  Scenario: Handle SSO provider unavailable
    Given the SSO provider is unavailable
    When I try to log in via SSO
    Then I should see an error message
    And I should be offered alternative login

  @error @single-sign-on
  Scenario: Handle SSO session expired
    Given my SSO session has expired
    When I try to access the application
    Then I should be redirected to re-authenticate
    And my access should be restored after login

  # ============================================================================
  # LOGOUT FUNCTIONALITY
  # ============================================================================

  @happy-path @logout
  Scenario: Sign out from current session
    Given I am logged in
    When I click sign out
    Then I should be logged out
    And I should be redirected to login page

  @happy-path @logout
  Scenario: Sign out from all devices
    Given I am logged in on multiple devices
    When I sign out from all devices
    Then all sessions should be terminated
    And all devices should be logged out

  @happy-path @logout
  Scenario: Session cleanup on logout
    Given I am logging out
    When I complete logout
    Then my session data should be cleared
    And my tokens should be invalidated

  @happy-path @logout
  Scenario: Redirect after logout
    Given I am logging out
    When logout completes
    Then I should be redirected to the login page
    And I should see a logout confirmation

  @happy-path @logout
  Scenario: Logout with unsaved changes warning
    Given I have unsaved changes
    When I try to log out
    Then I should see a warning about unsaved changes
    And I should be able to cancel or proceed

  @mobile @logout
  Scenario: Logout on mobile device
    Given I am logged in on a mobile device
    When I log out
    Then I should be logged out
    And push notifications should be unregistered

  @happy-path @logout
  Scenario: Automatic logout on password change
    Given I change my password
    Then all other sessions should be logged out
    And only my current session should remain

  @error @logout
  Scenario: Handle logout failure
    Given the logout process fails
    Then I should see an error message
    And I should be able to retry logout
