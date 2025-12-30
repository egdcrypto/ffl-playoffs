@login @oauth @google @authentication @cloudscape @frontend
Feature: Login Page with Google OAuth
  As a user
  I want to login using my Google account
  So that I can securely access the fantasy football platform

  Background:
    Given the application is loaded
    And Google OAuth is configured
    And I am not authenticated

  # ==========================================
  # Login Page UI
  # ==========================================

  @ui @layout
  Scenario: Display login page layout
    Given I navigate to the login page
    Then I should see the login page with:
      | element             | description                    |
      | app_logo            | Application logo               |
      | welcome_message     | Welcome heading                |
      | tagline             | Application description        |
      | google_login_button | Sign in with Google button     |
      | footer              | Terms and privacy links        |
    And the layout should be centered on the page
    And the design should follow Cloudscape guidelines

  @ui @branding
  Scenario: Display application branding
    Given I am on the login page
    Then I should see the application branding:
      | element         | content                          |
      | logo            | FFL Playoffs logo                |
      | app_name        | FFL Playoffs                     |
      | tagline         | Fantasy Football Playoff Manager |
    And branding should be visually prominent

  @ui @responsive
  Scenario: Login page is responsive
    Given I am on the login page
    When I view on different screen sizes:
      | device    | width   |
      | mobile    | 375px   |
      | tablet    | 768px   |
      | desktop   | 1280px  |
    Then the layout should adapt appropriately
    And all elements should remain accessible
    And the Google button should be appropriately sized

  @ui @cloudscape
  Scenario: Use Cloudscape components for login UI
    Given I am on the login page
    Then the following Cloudscape components should be used:
      | component       | usage                    |
      | Box             | Layout container         |
      | Container       | Login card               |
      | Header          | Welcome message          |
      | SpaceBetween    | Element spacing          |
      | Button          | Login button styling     |
    And components should follow Cloudscape patterns

  @ui @dark-mode
  Scenario: Support dark mode on login page
    Given I am on the login page
    And my system preference is dark mode
    Then the login page should display in dark theme
    And colors should be accessible
    And Google button should remain recognizable

  @ui @loading
  Scenario: Display loading state appropriately
    Given I am on the login page
    When authentication is in progress
    Then the Google login button should show loading state
    And a spinner should be visible
    And the button should be disabled
    And user should not be able to click again

  # ==========================================
  # Google OAuth Integration
  # ==========================================

  @oauth @initiate
  Scenario: Initiate Google OAuth login
    Given I am on the login page
    When I click the "Sign in with Google" button
    Then I should be redirected to Google's OAuth consent screen
    And the redirect should include proper OAuth parameters:
      | parameter       | description              |
      | client_id       | Application client ID    |
      | redirect_uri    | Callback URL             |
      | scope           | Requested permissions    |
      | state           | CSRF protection token    |
      | response_type   | code                     |

  @oauth @consent
  Scenario: Google OAuth consent screen
    Given I have been redirected to Google
    When I view the consent screen
    Then I should see the permissions requested:
      | permission      | description              |
      | email           | View email address       |
      | profile         | View basic profile info  |
      | openid          | OpenID Connect auth      |
    And I should see the application name
    And I should be able to approve or deny

  @oauth @callback-success
  Scenario: Handle successful OAuth callback
    Given I approved the OAuth consent
    When Google redirects back with authorization code
    Then the application should receive the callback
    And the authorization code should be exchanged for tokens
    And user session should be created
    And I should be redirected to the dashboard

  @oauth @token-exchange
  Scenario: Exchange authorization code for tokens
    Given I have received an authorization code
    When token exchange is performed with the backend
    Then the backend should:
      | action                | result                 |
      | validate_code         | Verify code is valid   |
      | exchange_with_google  | Get Google tokens      |
      | extract_user_info     | Get user profile       |
      | create_session        | Generate JWT           |
    And JWT should be returned to frontend
    And JWT should be stored securely

  @oauth @user-creation
  Scenario: Create new user on first login
    Given I am logging in for the first time
    And my Google account is "newuser@gmail.com"
    When OAuth flow completes
    Then a new user account should be created
    And user profile should be populated from Google:
      | field           | source              |
      | email           | Google email        |
      | name            | Google display name |
      | picture         | Google profile pic  |
    And I should be welcomed as a new user

  @oauth @returning-user
  Scenario: Recognize returning user on login
    Given I have logged in before with "returning@gmail.com"
    When I login with the same Google account
    Then my existing account should be found
    And my profile should be updated if changed
    And I should be logged into my existing account
    And my previous data should be accessible

  @oauth @popup
  Scenario: Support popup-based OAuth flow
    Given popup OAuth is configured
    When I click "Sign in with Google"
    Then OAuth should open in a popup window
    And the main window should remain on login page
    And upon completion, popup should close
    And main window should navigate to dashboard

  # ==========================================
  # Redirect Flows
  # ==========================================

  @redirect @protected-page
  Scenario: Redirect to login from protected page
    Given I am not authenticated
    When I try to access "/dashboard"
    Then I should be redirected to the login page
    And the original URL should be stored
    And I should see message "Please login to continue"

  @redirect @return-url
  Scenario: Redirect back to original page after login
    Given I was redirected to login from "/leagues/123"
    When I complete the login flow
    Then I should be redirected to "/leagues/123"
    And not to the default dashboard
    And the return URL should be cleared

  @redirect @deep-link
  Scenario: Handle deep link with query parameters
    Given I was redirected from "/team?tab=roster&week=15"
    When I complete the login flow
    Then I should be redirected to "/team?tab=roster&week=15"
    And query parameters should be preserved

  @redirect @invalid-return
  Scenario: Handle invalid return URL
    Given return URL is set to "https://malicious-site.com"
    When I complete the login flow
    Then I should be redirected to the default dashboard
    And the malicious URL should be ignored
    And the attempt should be logged

  @redirect @already-authenticated
  Scenario: Redirect away from login if already authenticated
    Given I am already authenticated
    When I navigate to the login page
    Then I should be automatically redirected to the dashboard
    And I should not see the login page

  @redirect @logout-return
  Scenario: Return to login after logout
    Given I am logged in
    When I logout
    Then I should be redirected to the login page
    And my session should be cleared
    And I should see message "You have been logged out"

  # ==========================================
  # Error Handling
  # ==========================================

  @error @oauth-denied
  Scenario: Handle OAuth consent denied
    Given I am on Google's consent screen
    When I click "Cancel" or deny consent
    Then I should be redirected back to login page
    And I should see error message "Login was cancelled"
    And I should be able to try again

  @error @oauth-failure
  Scenario: Handle OAuth flow failure
    Given OAuth flow encounters an error
    When error callback is received
    Then I should be redirected to login page
    And I should see error message "Login failed. Please try again."
    And error details should be logged
    And retry option should be available

  @error @network
  Scenario: Handle network error during login
    Given I click "Sign in with Google"
    When network request fails
    Then I should see error message "Network error. Please check your connection."
    And I should be able to retry
    And offline indicator may be shown

  @error @token-exchange-failure
  Scenario: Handle token exchange failure
    Given OAuth callback is received
    When token exchange with backend fails
    Then I should see error message "Authentication failed. Please try again."
    And the error should be logged
    And I should remain on login page

  @error @invalid-state
  Scenario: Handle invalid OAuth state parameter
    Given OAuth callback has invalid state token
    When callback is processed
    Then login should be rejected
    And I should see error message "Invalid login attempt"
    And potential CSRF attack should be logged

  @error @expired-code
  Scenario: Handle expired authorization code
    Given authorization code has expired
    When token exchange is attempted
    Then I should see error message "Login session expired. Please try again."
    And I should be able to restart login flow

  @error @account-disabled
  Scenario: Handle disabled account
    Given my account has been disabled
    When I attempt to login
    Then I should see error message "Your account has been disabled"
    And I should see contact support information
    And I should not be granted access

  @error @display
  Scenario: Display errors using Cloudscape Flashbar
    Given an error occurs during login
    When error is displayed
    Then Cloudscape Flashbar should be used
    And error should have type "error"
    And error should be dismissible
    And error should include helpful message

  # ==========================================
  # Session Management
  # ==========================================

  @session @storage
  Scenario: Store authentication tokens securely
    Given I have successfully logged in
    When tokens are stored
    Then JWT should be stored in memory or httpOnly cookie
    And tokens should not be in localStorage (XSS vulnerable)
    And refresh token should be stored securely

  @session @persistence
  Scenario: Persist session across page refresh
    Given I am logged in
    When I refresh the page
    Then my session should still be valid
    And I should not need to login again
    And my user context should be restored

  @session @expiration
  Scenario: Handle session expiration
    Given my session token has expired
    When I make an authenticated request
    Then token refresh should be attempted
    And if refresh succeeds, request should proceed
    And if refresh fails, I should be redirected to login

  @session @logout
  Scenario: Clear session on logout
    Given I am logged in
    When I logout
    Then all tokens should be cleared
    And session storage should be cleared
    And I should be redirected to login
    And subsequent requests should be unauthorized

  @session @multiple-tabs
  Scenario: Sync session across browser tabs
    Given I am logged in in one tab
    When I open a new tab
    Then the new tab should also be logged in
    And session state should be synchronized
    And logout in one tab should logout all tabs

  # ==========================================
  # Accessibility
  # ==========================================

  @a11y @keyboard
  Scenario: Login page is keyboard accessible
    Given I am on the login page
    When I navigate using only keyboard
    Then I should be able to tab to all interactive elements
    And focus indicators should be visible
    And Enter key should activate buttons
    And Escape key should dismiss modals

  @a11y @screen-reader
  Scenario: Login page is screen reader accessible
    Given I am using a screen reader
    When I navigate the login page
    Then all elements should have appropriate ARIA labels
    And error messages should be announced
    And loading states should be announced
    And page structure should be conveyed

  @a11y @color-contrast
  Scenario: Login page meets color contrast requirements
    Given I am on the login page
    When accessibility audit runs
    Then all text should meet WCAG 2.1 AA contrast ratios
    And interactive elements should be distinguishable
    And focus states should be visible

  @a11y @motion
  Scenario: Respect reduced motion preference
    Given I have reduced motion preference enabled
    When I view the login page
    Then animations should be minimized or disabled
    And transitions should be instant
    And user experience should not be degraded

  # ==========================================
  # Security
  # ==========================================

  @security @csrf
  Scenario: Protect against CSRF attacks
    Given I initiate OAuth login
    When state parameter is generated
    Then state should be cryptographically random
    And state should be stored for verification
    And callback without matching state should be rejected

  @security @xss
  Scenario: Protect against XSS in error messages
    Given error message contains user input
    When error is displayed
    Then user input should be properly escaped
    And no script execution should be possible
    And HTML injection should be prevented

  @security @open-redirect
  Scenario: Protect against open redirect attacks
    Given return URL is provided
    When redirect is performed after login
    Then URL should be validated against whitelist
    And external URLs should be rejected
    And only same-origin URLs should be allowed

  @security @brute-force
  Scenario: Rate limit login attempts
    Given many login attempts are made
    When rate limit is exceeded
    Then further attempts should be blocked
    And user should see "Too many attempts" message
    And block duration should be communicated

  @security @https
  Scenario: Enforce HTTPS for login
    Given login page is accessed via HTTP
    When page is loaded
    Then request should be redirected to HTTPS
    And all OAuth communication should use HTTPS
    And mixed content should be blocked

  # ==========================================
  # Analytics and Monitoring
  # ==========================================

  @analytics @tracking
  Scenario: Track login events for analytics
    Given I complete the login flow
    When login event is tracked
    Then the following should be recorded:
      | event               | data                    |
      | login_initiated     | timestamp, source       |
      | login_completed     | timestamp, user_type    |
      | login_failed        | timestamp, error_type   |
    And PII should not be included in analytics

  @monitoring @logging
  Scenario: Log authentication events
    Given authentication events occur
    When events are logged
    Then the following should be captured:
      | event               | details                 |
      | oauth_initiated     | timestamp, client_ip    |
      | oauth_callback      | success/failure, timing |
      | session_created     | user_id, expiration     |
    And logs should be structured for monitoring

  @monitoring @errors
  Scenario: Report login errors to monitoring
    Given a login error occurs
    When error is reported
    Then error should be sent to monitoring service
    And error should include context
    And error should be actionable
    And alerts should trigger for error spikes

  # ==========================================
  # Edge Cases
  # ==========================================

  @edge-case @slow-network
  Scenario: Handle slow network conditions
    Given network is slow
    When I initiate login
    Then appropriate timeout should be applied
    And loading state should persist
    And user should be able to cancel
    And timeout error should be shown eventually

  @edge-case @popup-blocked
  Scenario: Handle popup blocked by browser
    Given popups are blocked by browser
    When popup OAuth flow is attempted
    Then user should be notified of blocked popup
    And alternative redirect flow should be offered
    And instructions to enable popups may be shown

  @edge-case @third-party-cookies
  Scenario: Handle third-party cookies disabled
    Given third-party cookies are blocked
    When OAuth flow relies on cookies
    Then appropriate error should be shown
    And workaround or instructions should be provided

  @edge-case @google-account-switch
  Scenario: Allow switching Google accounts
    Given I am logged in with one Google account
    When I logout and login with different Google account
    Then I should be prompted to select account
    And new account should be linked correctly
    And previous session should be fully cleared

  @edge-case @concurrent-login
  Scenario: Handle concurrent login attempts
    Given I click login button multiple times quickly
    When OAuth flow is initiated
    Then only one OAuth flow should proceed
    And duplicate clicks should be ignored
    And no race conditions should occur

  @edge-case @browser-back
  Scenario: Handle browser back button during OAuth
    Given I am on Google consent screen
    When I press browser back button
    Then I should return to login page
    And partial OAuth state should be cleared
    And I should be able to start fresh
