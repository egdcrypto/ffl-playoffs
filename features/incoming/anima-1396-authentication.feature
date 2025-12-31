@authentication @anima-1396
Feature: Authentication
  As a fantasy football user
  I want secure authentication options
  So that I can safely access my account

  Background:
    Given the authentication system is available
    And I am on the login page

  # ============================================================================
  # USER LOGIN
  # ============================================================================

  @happy-path @user-login
  Scenario: Login with email
    Given I have a registered account
    When I login with my email and password
    Then I should be logged in
    And I should see the dashboard

  @happy-path @user-login
  Scenario: Login with username
    Given I have a registered account
    When I login with my username and password
    Then I should be logged in
    And I should see the dashboard

  @happy-path @user-login
  Scenario: Use remember me option
    Given I am logging in
    When I check remember me
    Then my session should persist
    And I should stay logged in

  @error @user-login
  Scenario: Login with invalid credentials
    Given I enter wrong credentials
    When I attempt to login
    Then I should see error message
    And I should remain on login page

  @error @user-login
  Scenario: Handle failed login attempts
    Given I have failed multiple times
    When I exceed attempt limit
    Then account should be temporarily locked
    And I should see lockout message

  @happy-path @user-login
  Scenario: Login from new device
    Given I am on a new device
    When I login successfully
    Then I should receive device notification
    And I should be prompted to verify

  @happy-path @user-login
  Scenario: Login with case-insensitive email
    Given my email has different case
    When I login with any case
    Then login should succeed
    And I should be authenticated

  @error @user-login
  Scenario: Login with unverified email
    Given my email is not verified
    When I attempt to login
    Then I should see verification prompt
    And I should receive verification email

  @happy-path @user-login
  Scenario: Redirect after login
    Given I was redirected to login
    When I login successfully
    Then I should return to original page
    And context should be preserved

  @happy-path @user-login
  Scenario: View password while typing
    Given I am entering password
    When I toggle password visibility
    Then password should be visible
    And I can toggle back

  # ============================================================================
  # USER REGISTRATION
  # ============================================================================

  @happy-path @user-registration
  Scenario: Create new account
    Given I am on registration page
    When I complete registration form
    Then account should be created
    And I should receive welcome email

  @happy-path @user-registration
  Scenario: Verify email address
    Given I registered with email
    When I click verification link
    Then email should be verified
    And I can access full features

  @happy-path @user-registration
  Scenario: Select unique username
    Given I am registering
    When I choose a username
    Then username availability should be checked
    And unique username should be accepted

  @error @user-registration
  Scenario: Handle duplicate username
    Given username is taken
    When I try to use it
    Then I should see error
    And I should choose different username

  @happy-path @user-registration
  Scenario: Meet password requirements
    Given I am setting password
    When I enter valid password
    Then password should be accepted
    And strength indicator should show

  @error @user-registration
  Scenario: Reject weak password
    Given I enter weak password
    When I submit form
    Then I should see password requirements
    And I should create stronger password

  @happy-path @user-registration
  Scenario: Accept terms and conditions
    Given I am registering
    When I accept terms
    Then acceptance should be recorded
    And I can proceed

  @error @user-registration
  Scenario: Require terms acceptance
    Given I have not accepted terms
    When I try to register
    Then I should see error
    And I must accept to continue

  @happy-path @user-registration
  Scenario: Resend verification email
    Given I did not receive email
    When I request resend
    Then new email should be sent
    And I should see confirmation

  @happy-path @user-registration
  Scenario: Complete profile after registration
    Given I just registered
    When I am prompted to complete profile
    Then I can add additional info
    And profile should be enhanced

  # ============================================================================
  # PASSWORD MANAGEMENT
  # ============================================================================

  @happy-path @password-management
  Scenario: Request password reset
    Given I forgot my password
    When I request reset
    Then reset email should be sent
    And I should see confirmation

  @happy-path @password-management
  Scenario: Reset password via link
    Given I received reset email
    When I click reset link
    Then I should see reset form
    And I can enter new password

  @happy-path @password-management
  Scenario: Change password when logged in
    Given I am logged in
    When I change my password
    Then password should be updated
    And I should confirm old password

  @happy-path @password-management
  Scenario: View password strength
    Given I am entering new password
    When I type password
    Then strength meter should update
    And I should see requirements

  @error @password-management
  Scenario: Prevent password reuse
    Given I used password before
    When I try to reuse it
    Then I should see error
    And I must choose new password

  @error @password-management
  Scenario: Handle expired reset link
    Given reset link is expired
    When I click the link
    Then I should see expired message
    And I can request new link

  @happy-path @password-management
  Scenario: Confirm password match
    Given I am setting new password
    When I confirm password
    Then passwords should match
    And I can proceed

  @error @password-management
  Scenario: Handle password mismatch
    Given passwords do not match
    When I submit form
    Then I should see mismatch error
    And I should correct it

  @happy-path @password-management
  Scenario: Log out other sessions on password change
    Given I have other active sessions
    When I change password
    Then other sessions should be ended
    And I should be notified

  @happy-path @password-management
  Scenario: View password history
    Given password history is tracked
    When I view history
    Then I should see when changed
    And dates should be shown

  # ============================================================================
  # SOCIAL LOGIN
  # ============================================================================

  @happy-path @social-login
  Scenario: Login with Google
    Given Google login is available
    When I login with Google
    Then I should be authenticated
    And account should be linked

  @happy-path @social-login
  Scenario: Login with Facebook
    Given Facebook login is available
    When I login with Facebook
    Then I should be authenticated
    And account should be linked

  @happy-path @social-login
  Scenario: Login with Apple
    Given Apple login is available
    When I login with Apple
    Then I should be authenticated
    And account should be linked

  @happy-path @social-login
  Scenario: Login with Twitter
    Given Twitter login is available
    When I login with Twitter
    Then I should be authenticated
    And account should be linked

  @happy-path @social-login
  Scenario: Link social account to existing account
    Given I have an existing account
    When I link social account
    Then accounts should be linked
    And I can use either to login

  @happy-path @social-login
  Scenario: Unlink social account
    Given social account is linked
    When I unlink account
    Then link should be removed
    And I should have alternate login

  @happy-path @social-login
  Scenario: Create account via social login
    Given I am new user
    When I signup via social
    Then account should be created
    And profile should be populated

  @error @social-login
  Scenario: Handle social login failure
    Given social provider is unavailable
    When I try social login
    Then I should see error
    And I can use alternate method

  @happy-path @social-login
  Scenario: View linked accounts
    Given I have linked accounts
    When I view linked accounts
    Then I should see all connections
    And I can manage them

  @happy-path @social-login
  Scenario: Sync profile from social
    Given social account is linked
    When I sync profile
    Then profile should update
    And I can choose what to sync

  # ============================================================================
  # TWO-FACTOR AUTHENTICATION
  # ============================================================================

  @happy-path @two-factor-auth
  Scenario: Enable 2FA
    Given 2FA is available
    When I enable 2FA
    Then 2FA should be activated
    And I should receive backup codes

  @happy-path @two-factor-auth
  Scenario: Disable 2FA
    Given 2FA is enabled
    When I disable 2FA
    Then 2FA should be deactivated
    And I should confirm with code

  @happy-path @two-factor-auth
  Scenario: Setup authenticator app
    Given I am enabling 2FA
    When I setup authenticator
    Then I should see QR code
    And I can scan with app

  @happy-path @two-factor-auth
  Scenario: Verify via SMS
    Given SMS verification is enabled
    When I request SMS code
    Then I should receive code
    And I can enter to verify

  @happy-path @two-factor-auth
  Scenario: Use backup code
    Given I cannot access authenticator
    When I use backup code
    Then I should be authenticated
    And code should be consumed

  @happy-path @two-factor-auth
  Scenario: Generate new backup codes
    Given I need new codes
    When I generate new codes
    Then new codes should be created
    And old codes should be invalidated

  @happy-path @two-factor-auth
  Scenario: View remaining backup codes
    Given I have backup codes
    When I view codes
    Then I should see remaining count
    And I can generate more if needed

  @error @two-factor-auth
  Scenario: Handle invalid 2FA code
    Given I enter wrong code
    When I submit
    Then I should see error
    And I should try again

  @happy-path @two-factor-auth
  Scenario: Remember device for 2FA
    Given I am verifying 2FA
    When I choose remember device
    Then device should be trusted
    And 2FA should be skipped next time

  @happy-path @two-factor-auth
  Scenario: Require 2FA on new device
    Given I have 2FA enabled
    When I login on new device
    Then 2FA should be required
    And I must verify

  # ============================================================================
  # SESSION MANAGEMENT
  # ============================================================================

  @happy-path @session-management
  Scenario: View active sessions
    Given I have active sessions
    When I view sessions
    Then I should see all sessions
    And device info should be shown

  @happy-path @session-management
  Scenario: Handle session timeout
    Given session is expiring
    When timeout occurs
    Then I should be warned
    And I can extend session

  @happy-path @session-management
  Scenario: Logout from current session
    Given I am logged in
    When I logout
    Then I should be logged out
    And session should be ended

  @happy-path @session-management
  Scenario: Logout from all devices
    Given I have multiple sessions
    When I logout all devices
    Then all sessions should end
    And I should be logged out

  @happy-path @session-management
  Scenario: Refresh session
    Given session is active
    When I interact with app
    Then session should be refreshed
    And timeout should reset

  @happy-path @session-management
  Scenario: End specific session
    Given I have multiple sessions
    When I end specific session
    Then that session should end
    And device should be logged out

  @happy-path @session-management
  Scenario: View session history
    Given sessions are tracked
    When I view session history
    Then I should see past sessions
    And dates should be shown

  @happy-path @session-management
  Scenario: Set session preferences
    Given preferences exist
    When I set preferences
    Then preferences should be saved
    And sessions should follow them

  @happy-path @session-management
  Scenario: Receive session expiration warning
    Given session is expiring soon
    When threshold is reached
    Then I should see warning
    And I can extend or logout

  @happy-path @session-management
  Scenario: Auto-logout on inactivity
    Given I am inactive
    When inactivity timeout reached
    Then I should be logged out
    And work should be saved

  # ============================================================================
  # ACCOUNT SECURITY
  # ============================================================================

  @happy-path @account-security
  Scenario: Receive login alerts
    Given alerts are enabled
    When login occurs
    Then I should receive alert
    And login details should be shown

  @happy-path @account-security
  Scenario: Detect suspicious activity
    Given unusual activity occurs
    When detected by system
    Then I should be alerted
    And I can verify or report

  @happy-path @account-security
  Scenario: Handle account lockout
    Given account is locked
    When I try to access
    Then I should see lockout message
    And I can request unlock

  @happy-path @account-security
  Scenario: Set security questions
    Given security questions are available
    When I set questions
    Then questions should be saved
    And I can use for recovery

  @happy-path @account-security
  Scenario: Manage trusted devices
    Given I have devices
    When I manage trusted devices
    Then I should see all devices
    And I can trust or remove

  @happy-path @account-security
  Scenario: Review security recommendations
    Given recommendations exist
    When I review security
    Then I should see suggestions
    And I can improve security

  @happy-path @account-security
  Scenario: Enable login notifications
    Given notifications are available
    When I enable notifications
    Then I should receive on login
    And I can manage settings

  @happy-path @account-security
  Scenario: Report compromised account
    Given I suspect compromise
    When I report issue
    Then account should be secured
    And I should receive guidance

  @happy-path @account-security
  Scenario: View security log
    Given security events are logged
    When I view log
    Then I should see all events
    And details should be shown

  @happy-path @account-security
  Scenario: Complete security checkup
    Given checkup is available
    When I complete checkup
    Then I should see security status
    And improvements should be suggested

  # ============================================================================
  # TOKEN MANAGEMENT
  # ============================================================================

  @happy-path @token-management
  Scenario: Receive access token
    Given I am authenticated
    When I login
    Then I should receive access token
    And it should be valid

  @happy-path @token-management
  Scenario: Refresh access token
    Given token is expiring
    When refresh is requested
    Then new token should be issued
    And session should continue

  @happy-path @token-management
  Scenario: Handle token expiration
    Given token has expired
    When I make request
    Then token should be refreshed
    And request should succeed

  @happy-path @token-management
  Scenario: Revoke access token
    Given token is active
    When I revoke token
    Then token should be invalidated
    And access should be denied

  @happy-path @token-management
  Scenario: Generate API key
    Given API access is available
    When I generate API key
    Then key should be created
    And I should save it securely

  @happy-path @token-management
  Scenario: Manage API keys
    Given I have API keys
    When I manage keys
    Then I should see all keys
    And I can revoke or regenerate

  @happy-path @token-management
  Scenario: Set API key permissions
    Given I have API key
    When I set permissions
    Then permissions should be saved
    And key should respect them

  @happy-path @token-management
  Scenario: View API key usage
    Given API key is in use
    When I view usage
    Then I should see usage stats
    And patterns should be shown

  @happy-path @token-management
  Scenario: Expire API key
    Given API key should expire
    When I set expiration
    Then expiration should be saved
    And key should expire on date

  @happy-path @token-management
  Scenario: Rotate API keys
    Given I need to rotate keys
    When I rotate key
    Then new key should be created
    And old key should be deprecated

  # ============================================================================
  # SINGLE SIGN-ON
  # ============================================================================

  @happy-path @single-sign-on
  Scenario: Login via SSO
    Given SSO is configured
    When I login via SSO
    Then I should be authenticated
    And I should access the app

  @happy-path @single-sign-on
  Scenario: Configure enterprise SSO
    Given I am admin
    When I configure SSO
    Then SSO should be setup
    And users can use it

  @happy-path @single-sign-on
  Scenario: Authenticate via SAML
    Given SAML is configured
    When I authenticate via SAML
    Then I should be logged in
    And session should be created

  @happy-path @single-sign-on
  Scenario: Use OAuth provider
    Given OAuth is configured
    When I use OAuth
    Then I should be authenticated
    And tokens should be issued

  @happy-path @single-sign-on
  Scenario: Setup identity federation
    Given federation is available
    When I setup federation
    Then identities should be linked
    And SSO should work

  @happy-path @single-sign-on
  Scenario: Handle SSO logout
    Given I am logged in via SSO
    When I logout
    Then I should be logged out
    And SSO session should end

  @happy-path @single-sign-on
  Scenario: Map SSO attributes
    Given SSO provides attributes
    When I map attributes
    Then user profile should populate
    And data should sync

  @error @single-sign-on
  Scenario: Handle SSO failure
    Given SSO provider is unavailable
    When I try SSO login
    Then I should see error
    And I can use alternate method

  @happy-path @single-sign-on
  Scenario: Test SSO configuration
    Given SSO is configured
    When I test configuration
    Then test should run
    And results should be shown

  @happy-path @single-sign-on
  Scenario: View SSO audit log
    Given SSO is in use
    When I view audit log
    Then I should see SSO events
    And details should be shown

  # ============================================================================
  # BIOMETRIC AUTHENTICATION
  # ============================================================================

  @happy-path @biometric-auth
  Scenario: Login with fingerprint
    Given fingerprint is enrolled
    When I use fingerprint
    Then I should be authenticated
    And login should be quick

  @happy-path @biometric-auth
  Scenario: Login with face recognition
    Given face is enrolled
    When I use face recognition
    Then I should be authenticated
    And login should be seamless

  @happy-path @biometric-auth
  Scenario: Use device biometrics
    Given device supports biometrics
    When I use device biometrics
    Then I should be authenticated
    And native flow should work

  @happy-path @biometric-auth
  Scenario: Enroll biometric
    Given I want to use biometrics
    When I enroll biometric
    Then biometric should be registered
    And I can use for login

  @happy-path @biometric-auth
  Scenario: Use fallback authentication
    Given biometric fails
    When I use fallback
    Then I should see alternate options
    And I can login with password

  @happy-path @biometric-auth
  Scenario: Remove biometric enrollment
    Given biometric is enrolled
    When I remove enrollment
    Then biometric should be removed
    And I must use other methods

  @happy-path @biometric-auth
  Scenario: View enrolled biometrics
    Given I have biometrics
    When I view enrolled
    Then I should see all biometrics
    And I can manage them

  @happy-path @biometric-auth
  Scenario: Re-enroll biometric
    Given biometric needs update
    When I re-enroll
    Then new biometric should be saved
    And old should be replaced

  @error @biometric-auth
  Scenario: Handle biometric not recognized
    Given biometric does not match
    When I try to authenticate
    Then I should see error
    And I can try again or use fallback

  @happy-path @biometric-auth
  Scenario: Configure biometric preferences
    Given preferences exist
    When I configure preferences
    Then preferences should be saved
    And biometrics should follow them

