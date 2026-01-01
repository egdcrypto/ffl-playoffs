@onboarding
Feature: Onboarding
  As a new fantasy football user
  I want a guided onboarding experience
  So that I can quickly get started and understand the platform

  # --------------------------------------------------------------------------
  # Welcome Flow
  # --------------------------------------------------------------------------

  @welcome-flow
  Scenario: View welcome screen
    Given I am a new user
    When I open the app for the first time
    Then I should see the welcome screen
    And I should see the app logo
    And I should see a welcome message
    And I should see options to get started

  @welcome-flow
  Scenario: View app introduction
    Given I am on the welcome screen
    When I start the introduction
    Then I should see app introduction slides
    And I should see key features highlighted
    And I should be able to swipe through slides
    And I should see progress indicators

  @welcome-flow
  Scenario: Understand value proposition
    Given I am viewing the introduction
    When I see the value proposition
    Then I should understand the app benefits
    And I should see what makes this app unique
    And I should be motivated to continue

  @welcome-flow
  Scenario: Begin getting started flow
    Given I have viewed the welcome content
    When I click get started
    Then I should begin the onboarding flow
    And I should see the first step
    And I should see overall progress

  @welcome-flow
  Scenario: Skip welcome introduction
    Given I am on the welcome screen
    When I choose to skip introduction
    Then I should go directly to account setup
    And I should be able to view intro later
    And skip option should be clearly visible

  # --------------------------------------------------------------------------
  # Account Setup
  # --------------------------------------------------------------------------

  @account-setup
  Scenario: Create new account
    Given I am in the account setup step
    When I enter my email address
    And I create a password
    And I confirm my password
    And I agree to terms of service
    Then my account should be created
    And I should proceed to next step

  @account-setup
  Scenario: Verify email address
    Given I have created an account
    When I receive the verification email
    And I click the verification link
    Then my email should be verified
    And I should see verification confirmation
    And I should continue onboarding

  @account-setup
  Scenario: Set unique username
    Given I am setting up my profile
    When I enter a username
    Then the system should check availability
    And I should see if username is taken
    And I should be able to choose available name
    And username requirements should be shown

  @account-setup
  Scenario: Upload profile avatar
    Given I am setting up my profile
    When I upload an avatar
    Then I should be able to take a photo
    And I should be able to choose from library
    And I should be able to crop the image
    And the avatar should be saved

  @account-setup
  Scenario: Skip optional account steps
    Given I am in account setup
    When I skip optional steps
    Then I should be able to continue
    And I should be reminded to complete later
    And skipped steps should be marked

  @account-setup
  Scenario: Sign up with social account
    Given I am creating an account
    When I choose social sign up
    Then I should be able to use Google
    And I should be able to use Apple
    And I should be able to use Facebook
    And account should be created from social data

  # --------------------------------------------------------------------------
  # Profile Completion
  # --------------------------------------------------------------------------

  @profile-completion
  Scenario: Add profile bio
    Given I am completing my profile
    When I add my bio
    Then I should have character limit guidance
    And I should be able to save my bio
    And bio should appear on my profile

  @profile-completion
  Scenario: Set user preferences
    Given I am completing my profile
    When I set my preferences
    Then I should choose display preferences
    And I should set privacy preferences
    And I should configure default settings

  @profile-completion
  Scenario: Select favorite NFL teams
    Given I am completing my profile
    When I select my favorite teams
    Then I should see all NFL teams
    And I should be able to select multiple
    And favorites should influence recommendations

  @profile-completion
  Scenario: Configure notification setup
    Given I am completing my profile
    When I configure notifications
    Then I should see notification options
    And I should enable preferred notifications
    And I should set notification preferences
    And setup should be saved

  @profile-completion
  Scenario: Set fantasy experience level
    Given I am completing my profile
    When I indicate my experience level
    Then I should choose beginner, intermediate, or expert
    And app should adjust to my level
    And recommendations should be tailored

  @profile-completion
  Scenario: View profile completion progress
    Given I am completing my profile
    When I view progress
    Then I should see completion percentage
    And I should see remaining items
    And I should see benefits of completing

  # --------------------------------------------------------------------------
  # Feature Tours
  # --------------------------------------------------------------------------

  @feature-tours
  Scenario: Start interactive walkthrough
    Given I am new to the app
    When I start the feature tour
    Then I should see step-by-step guidance
    And features should be highlighted
    And I should be able to interact with features
    And progress should be tracked

  @feature-tours
  Scenario: View feature highlights
    Given I am in the feature tour
    When I view feature highlights
    Then key features should be pointed out
    And I should see feature descriptions
    And I should understand how to use them

  @feature-tours
  Scenario: Learn tips and tricks
    Given I am in the feature tour
    When I view tips and tricks
    Then I should see helpful tips
    And I should learn shortcuts
    And I should see pro strategies
    And tips should be relevant to my level

  @feature-tours
  Scenario: Skip feature tour
    Given I am in the feature tour
    When I choose to skip
    Then I should exit the tour
    And I should be able to restart later
    And skip should be clearly available

  @feature-tours
  Scenario: Resume feature tour
    Given I have partially completed a tour
    When I return to the app
    Then I should be able to resume
    And I should continue from where I left
    And progress should be preserved

  @feature-tours
  Scenario: Complete feature tour
    Given I am finishing the feature tour
    When I complete all steps
    Then I should see completion celebration
    And I should earn onboarding badge
    And I should be ready to use the app

  # --------------------------------------------------------------------------
  # League Setup
  # --------------------------------------------------------------------------

  @league-setup
  Scenario: Create first league
    Given I am setting up my first league
    When I choose to create a league
    Then I should configure league settings
    And I should set league name
    And I should choose league type
    And league should be created

  @league-setup
  Scenario: Join existing league
    Given I am setting up leagues
    When I choose to join a league
    Then I should enter league code
    And I should request to join
    And I should see league details
    And I should be added upon approval

  @league-setup
  Scenario: Discover public leagues
    Given I am looking for a league
    When I browse league discovery
    Then I should see available leagues
    And I should see league details
    And I should be able to filter leagues
    And I should be able to request to join

  @league-setup
  Scenario: Invite friends to league
    Given I have created a league
    When I invite friends
    Then I should be able to share invite link
    And I should be able to invite by email
    And I should be able to invite from contacts
    And friends should receive invitations

  @league-setup
  Scenario: Skip league setup
    Given I am in league setup
    When I choose to skip
    Then I should be able to continue
    And I should be reminded to join/create league
    And I should be able to do this later

  @league-setup
  Scenario: Import league from other platform
    Given I am setting up leagues
    When I choose to import
    Then I should select platform to import from
    And I should authorize the connection
    And league should be imported
    And settings should be preserved

  # --------------------------------------------------------------------------
  # Team Setup
  # --------------------------------------------------------------------------

  @team-setup
  Scenario: Name my team
    Given I have joined a league
    When I set up my team
    Then I should enter team name
    And I should see name requirements
    And team name should be saved

  @team-setup
  Scenario: Select team logo
    Given I am setting up my team
    When I select a logo
    Then I should see logo options
    And I should be able to upload custom logo
    And I should be able to search logos
    And logo should be saved

  @team-setup
  Scenario: Customize team colors
    Given I am setting up my team
    When I customize colors
    Then I should choose primary color
    And I should choose secondary color
    And colors should be applied to team

  @team-setup
  Scenario: Set team preferences
    Given I am setting up my team
    When I configure team preferences
    Then I should set roster preferences
    And I should set notification preferences
    And I should set display preferences

  @team-setup
  Scenario: View team preview
    Given I have configured my team
    When I view team preview
    Then I should see how my team looks
    And I should see team branding applied
    And I should be able to make changes

  # --------------------------------------------------------------------------
  # Draft Preparation
  # --------------------------------------------------------------------------

  @draft-preparation
  Scenario: Complete draft tutorial
    Given I am preparing for draft
    When I start draft tutorial
    Then I should learn draft basics
    And I should understand draft order
    And I should learn pick strategies
    And I should feel prepared

  @draft-preparation
  Scenario: Practice with mock draft
    Given I want to practice drafting
    When I start a mock draft
    Then I should join mock draft room
    And I should practice picking players
    And I should learn the interface
    And mock should not affect real roster

  @draft-preparation
  Scenario: Set up cheat sheet
    Given I am preparing for draft
    When I set up my cheat sheet
    Then I should see player rankings
    And I should be able to customize rankings
    And I should add notes to players
    And cheat sheet should be saved

  @draft-preparation
  Scenario: Learn draft strategy tips
    Given I am preparing for draft
    When I view strategy tips
    Then I should see position strategy
    And I should see value picks
    And I should see common mistakes
    And tips should match my experience level

  @draft-preparation
  Scenario: Skip draft preparation
    Given I am in draft preparation
    When I choose to skip
    Then I should be able to continue
    And I should be reminded before draft
    And resources should remain available

  # --------------------------------------------------------------------------
  # App Permissions
  # --------------------------------------------------------------------------

  @app-permissions
  Scenario: Request notification permissions
    Given I am setting up the app
    When I am asked for notification permission
    Then I should see why notifications are needed
    And I should be able to allow notifications
    And I should be able to deny and continue
    And my choice should be respected

  @app-permissions
  Scenario: Request calendar access
    Given I am setting up the app
    When I am asked for calendar access
    Then I should see benefits of calendar sync
    And I should be able to allow access
    And I should be able to skip
    And I should be able to enable later

  @app-permissions
  Scenario: Request contact sync
    Given I am setting up the app
    When I am asked for contact access
    Then I should see how contacts will be used
    And I should be able to allow access
    And I should be able to skip
    And privacy should be explained

  @app-permissions
  Scenario: Request location services
    Given I am setting up the app
    When I am asked for location access
    Then I should see why location is needed
    And I should be able to allow access
    And I should be able to deny
    And location should be used appropriately

  @app-permissions
  Scenario: Manage permissions later
    Given I have completed onboarding
    When I want to change permissions
    Then I should be able to access settings
    And I should see all permissions
    And I should be able to enable or disable

  # --------------------------------------------------------------------------
  # Onboarding Progress
  # --------------------------------------------------------------------------

  @onboarding-progress
  Scenario: View progress indicators
    Given I am in the onboarding flow
    When I view my progress
    Then I should see progress bar
    And I should see completed steps
    And I should see remaining steps
    And I should see estimated time remaining

  @onboarding-progress
  Scenario: View completion checklist
    Given I am in onboarding
    When I view the checklist
    Then I should see all onboarding tasks
    And I should see completed tasks checked
    And I should see incomplete tasks
    And I should be able to jump to any task

  @onboarding-progress
  Scenario: Resume onboarding
    Given I have left onboarding incomplete
    When I return to the app
    Then I should be prompted to resume
    And I should continue from where I left
    And my progress should be saved

  @onboarding-progress
  Scenario: Skip individual steps
    Given I am in the onboarding flow
    When I skip a step
    Then the step should be skipped
    And I should see it in incomplete list
    And I should be able to complete later
    And I should continue to next step

  @onboarding-progress
  Scenario: Complete onboarding
    Given I have completed all required steps
    When I finish onboarding
    Then I should see congratulations
    And I should see summary of what I set up
    And I should be taken to the main app
    And I should receive onboarding completion badge

  @onboarding-progress
  Scenario: Restart onboarding
    Given I have completed onboarding
    When I want to restart onboarding
    Then I should be able to restart tours
    And I should be able to review settings
    And I should not lose my data

  # --------------------------------------------------------------------------
  # Personalization
  # --------------------------------------------------------------------------

  @personalization
  Scenario: Select interests
    Given I am personalizing my experience
    When I select my interests
    Then I should see interest categories
    And I should select fantasy football topics
    And I should select content preferences
    And interests should influence content

  @personalization
  Scenario: Indicate experience level
    Given I am personalizing my experience
    When I indicate my experience
    Then I should choose my level
    And the app should adapt complexity
    And tutorials should match my level
    And recommendations should be appropriate

  @personalization
  Scenario: Receive custom recommendations
    Given I have set my preferences
    When I view recommendations
    Then recommendations should be personalized
    And they should match my interests
    And they should match my experience
    And I should be able to improve recommendations

  @personalization
  Scenario: View tailored content
    Given I have completed personalization
    When I use the app
    Then content should be tailored to me
    And I should see relevant news
    And I should see appropriate tips
    And experience should feel personalized

  @personalization
  Scenario: Update personalization preferences
    Given I have set personalization
    When I update my preferences
    Then I should be able to change interests
    And I should be able to change level
    And content should update accordingly

  # --------------------------------------------------------------------------
  # Onboarding Accessibility
  # --------------------------------------------------------------------------

  @onboarding @accessibility
  Scenario: Complete onboarding with screen reader
    Given I use a screen reader
    When I complete onboarding
    Then all steps should be accessible
    And instructions should be announced
    And navigation should be clear

  @onboarding @accessibility
  Scenario: Navigate onboarding with keyboard
    Given I use keyboard navigation
    When I go through onboarding
    Then I should navigate with Tab
    And I should interact with Enter
    And focus should be clear

  # --------------------------------------------------------------------------
  # Error Handling and Edge Cases
  # --------------------------------------------------------------------------

  @onboarding @error-handling
  Scenario: Handle onboarding interruption
    Given I am in onboarding
    When the app is interrupted
    Then my progress should be saved
    And I should resume when I return
    And I should not lose entered data

  @onboarding @error-handling
  Scenario: Handle email verification failure
    Given I am verifying my email
    When verification fails
    Then I should see error message
    And I should be able to retry
    And I should be able to resend email

  @onboarding @error-handling
  Scenario: Handle account creation error
    Given I am creating an account
    When an error occurs
    Then I should see clear error message
    And I should be able to fix the issue
    And my entered data should be preserved

  @onboarding @validation
  Scenario: Validate required fields
    Given I am filling out onboarding forms
    When I try to continue with missing fields
    Then I should see validation errors
    And required fields should be highlighted
    And I should be able to fix and continue
