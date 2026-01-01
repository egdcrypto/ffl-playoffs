@teams
Feature: Teams
  As a fantasy football league member
  I want comprehensive team functionality
  So that I can create, customize, and manage my fantasy team effectively

  Background:
    Given I am logged in as a league member
    And I have an active fantasy football league
    And I own a team in the league

  # --------------------------------------------------------------------------
  # Team Creation Scenarios
  # --------------------------------------------------------------------------
  @team-creation
  Scenario: Create team with name
    Given I am joining a new league
    When I enter my team name
    And I submit the team creation form
    Then my team should be created
    And the team name should be displayed
    And I should be the team owner

  @team-creation
  Scenario: Upload team logo
    Given I am creating or editing my team
    When I upload a logo image
    And the image meets size requirements
    Then the logo should be saved
    And the logo should display on my team profile
    And the logo should appear in league views

  @team-creation
  Scenario: Select team colors
    Given I am customizing my team
    When I select primary and secondary colors
    And I save my color choices
    Then my team colors should be applied
    And my team should display with those colors
    And the colors should appear in matchups

  @team-creation
  Scenario: Choose team mascot
    Given mascot options are available
    When I browse mascot selections
    And I choose a mascot
    Then the mascot should be assigned to my team
    And the mascot should appear on my profile
    And mascot-themed elements should be applied

  @team-creation
  Scenario: Validate team name
    Given I am entering a team name
    When I enter an invalid or inappropriate name
    Then I should see a validation error
    And I should be prompted to choose another name
    And inappropriate content should be blocked

  @team-creation
  Scenario: Use team name generator
    Given I need help choosing a name
    When I use the team name generator
    Then I should see suggested names
    And I should be able to select a suggestion
    And I should be able to regenerate options

  @team-creation
  Scenario: Preview team appearance
    Given I have configured team options
    When I preview my team
    Then I should see how my team will look
    And logo, colors, and mascot should be shown
    And I should be able to make adjustments

  @team-creation
  Scenario: Save team as template
    Given I have configured a team I like
    When I save the team as a template
    Then the template should be stored
    And I should be able to use it in other leagues
    And templates should be manageable

  # --------------------------------------------------------------------------
  # Team Profile Scenarios
  # --------------------------------------------------------------------------
  @team-profile
  Scenario: View team profile
    Given I navigate to a team profile
    When the profile loads
    Then I should see team information
    And I should see the owner details
    And I should see team statistics

  @team-profile
  Scenario: Edit team bio
    Given I am on my team profile
    When I edit my team bio
    And I enter descriptive text
    And I save the bio
    Then the bio should be updated
    And other league members should see it

  @team-profile
  Scenario: Display owner information
    Given a team profile is viewed
    When the owner section is visible
    Then the owner's name should be shown
    And owner since date should be displayed
    And owner's other teams should be linkable

  @team-profile
  Scenario: View team history
    Given the team has been active for seasons
    When I view team history
    Then I should see past season records
    And championship appearances should be noted
    And significant moments should be highlighted

  @team-profile
  Scenario: Display achievements
    Given the team has earned achievements
    When I view the achievements section
    Then all achievements should be displayed
    And achievement dates should be shown
    And achievement descriptions should be available

  @team-profile
  Scenario: Share team profile
    Given I want to share a team profile
    When I click share options
    Then I should be able to share to social media
    And I should be able to copy a link
    And the shared content should be formatted nicely

  @team-profile
  Scenario: View team profile as visitor
    Given I am viewing another team's profile
    When I access their profile
    Then I should see public information
    And private settings should be respected
    And I should be able to interact appropriately

  @team-profile
  Scenario: Follow a team
    Given I want to track another team
    When I follow the team
    Then I should receive updates about them
    And they should appear in my followed teams
    And I should be able to unfollow later

  # --------------------------------------------------------------------------
  # Team Roster Scenarios
  # --------------------------------------------------------------------------
  @team-roster
  Scenario: View current roster
    Given I access my team roster
    When the roster page loads
    Then I should see all my players
    And players should be organized by position
    And current status should be indicated

  @team-roster
  Scenario: View position breakdown
    Given I am viewing my roster
    When I view the position breakdown
    Then I should see players grouped by position
    And position counts should be displayed
    And I should see position depth

  @team-roster
  Scenario: View salary cap status
    Given the league uses salary caps
    When I view cap status
    Then I should see my total cap usage
    And cap space remaining should be shown
    And individual player salaries should be listed

  @team-roster
  Scenario: Manage IR slots
    Given I have injured reserve slots
    When I manage IR players
    Then I should see IR-eligible players
    And I should be able to move players to IR
    And IR rules should be enforced

  @team-roster
  Scenario: View roster projections
    Given projections are available
    When I view roster projections
    Then I should see projected points by player
    And total team projection should be shown
    And projections should be for upcoming matchup

  @team-roster
  Scenario: Filter roster view
    Given I have a large roster
    When I filter the roster
    Then I should be able to filter by position
    And I should be able to filter by status
    And filters should apply immediately

  @team-roster
  Scenario: Sort roster by various criteria
    Given I am viewing my roster
    When I sort by different criteria
    Then players should be sorted accordingly
    And I should be able to sort by points, salary, etc.
    And sort direction should be toggleable

  @team-roster
  Scenario: Export roster
    Given I want to save my roster
    When I export my roster
    Then a file should be generated
    And all player information should be included
    And the format should be selectable

  # --------------------------------------------------------------------------
  # Team Settings Scenarios
  # --------------------------------------------------------------------------
  @team-settings
  Scenario: Configure notification preferences
    Given I access team settings
    When I configure notifications
    Then I should be able to select notification types
    And delivery methods should be configurable
    And preferences should be saved

  @team-settings
  Scenario: Set privacy settings
    Given I want to control privacy
    When I configure privacy settings
    Then I should be able to hide certain information
    And profile visibility should be adjustable
    And settings should take effect immediately

  @team-settings
  Scenario: Configure auto-draft settings
    Given a draft is upcoming
    When I configure auto-draft
    Then I should be able to set preferences
    And position priorities should be settable
    And my queue should be configurable

  @team-settings
  Scenario: Set lineup reminder preferences
    Given I want lineup reminders
    When I configure reminder settings
    Then I should set reminder timing
    And delivery method should be selectable
    And reminders should be sent accordingly

  @team-settings
  Scenario: Configure trade preferences
    Given I have trade preferences
    When I set trade settings
    Then I should indicate trade availability
    And players I'm shopping should be markable
    And preferences should be visible to others

  @team-settings
  Scenario: Set default lineup rules
    Given I want automatic lineup management
    When I configure default lineup rules
    Then rules should be applied automatically
    And I should be able to prioritize starters
    And injury handling should be configurable

  @team-settings
  Scenario: Export team settings
    Given I want to backup settings
    When I export team settings
    Then all settings should be exported
    And I should be able to import later
    And settings should be portable

  @team-settings
  Scenario: Reset team settings to defaults
    Given I want to start fresh
    When I reset settings to defaults
    Then all settings should revert
    And I should be asked to confirm
    And defaults should be applied

  # --------------------------------------------------------------------------
  # Team Branding Scenarios
  # --------------------------------------------------------------------------
  @team-branding
  Scenario: Upload custom logo
    Given I want a custom team logo
    When I upload a logo file
    Then the logo should be validated
    And the logo should be resized if needed
    And the logo should be saved to my team

  @team-branding
  Scenario: Create team banner
    Given I want a team banner
    When I design or upload a banner
    Then the banner should be applied
    And the banner should display on my profile
    And the banner should meet size requirements

  @team-branding
  Scenario: Design helmet
    Given helmet customization is available
    When I design my helmet
    Then I should be able to choose colors
    And I should be able to add decals
    And the design should be saved

  @team-branding
  Scenario: Set uniform colors
    Given I can customize uniforms
    When I select uniform colors
    Then home and away colors should be settable
    And colors should be previewed
    And colors should be saved

  @team-branding
  Scenario: Use branding templates
    Given templates are available
    When I select a branding template
    Then the template should be applied
    And I should be able to customize it
    And I should be able to save as my own

  @team-branding
  Scenario: Preview branding across views
    Given I have customized branding
    When I preview branding
    Then I should see how it looks in various contexts
    And matchup views should be shown
    And league views should be previewed

  @team-branding
  Scenario: Reset branding to defaults
    Given I want to reset branding
    When I reset to defaults
    Then all branding should revert
    And I should confirm the reset
    And default branding should be applied

  @team-branding
  Scenario: Import branding from another league
    Given I have branding in another league
    When I import branding
    Then my branding should be copied
    And I should be able to select what to import
    And branding should be applied

  # --------------------------------------------------------------------------
  # Team Stats Scenarios
  # --------------------------------------------------------------------------
  @team-stats
  Scenario: View season statistics
    Given the season is in progress
    When I view team stats
    Then I should see points scored and against
    And win-loss record should be displayed
    And rankings should be shown

  @team-stats
  Scenario: View historical performance
    Given the team has multiple seasons
    When I view historical stats
    Then I should see past season records
    And trends should be visible
    And year-by-year comparison should be available

  @team-stats
  Scenario: View win-loss records
    Given the team has played games
    When I view win-loss records
    Then overall record should be shown
    And home vs away records should be available
    And divisional records should be included

  @team-stats
  Scenario: View points scored breakdown
    Given the team has scored points
    When I view scoring breakdown
    Then points by position should be shown
    And top scorers should be highlighted
    And weekly scoring should be available

  @team-stats
  Scenario: Compare stats to league average
    Given league stats are available
    When I compare to league average
    Then I should see how I rank
    And above and below average should be indicated
    And percentile rankings should be shown

  @team-stats
  Scenario: View advanced team metrics
    Given advanced stats are calculated
    When I view advanced metrics
    Then efficiency metrics should be shown
    And luck factors should be indicated
    And strength of schedule should be displayed

  @team-stats
  Scenario: Export team statistics
    Given I want to save my stats
    When I export team statistics
    Then stats should be exported
    And historical data should be included
    And the format should be selectable

  @team-stats
  Scenario: View weekly stat trends
    Given multiple weeks have been played
    When I view weekly trends
    Then I should see performance over time
    And trends should be visualized
    And inflection points should be noted

  # --------------------------------------------------------------------------
  # Team Comparison Scenarios
  # --------------------------------------------------------------------------
  @team-comparison
  Scenario: Compare head-to-head records
    Given I want to compare with another team
    When I view head-to-head records
    Then all-time record should be shown
    And recent matchups should be displayed
    And point differentials should be calculated

  @team-comparison
  Scenario: Compare rosters
    Given I am comparing two teams
    When I view roster comparison
    Then players should be compared by position
    And strengths should be highlighted
    And projected points should be compared

  @team-comparison
  Scenario: View strength charts
    Given team strengths are analyzed
    When I view strength charts
    Then positional strengths should be visualized
    And radar charts should display balance
    And comparisons should be clear

  @team-comparison
  Scenario: Identify weaknesses
    Given team analysis is available
    When I view weakness identification
    Then weak positions should be highlighted
    And improvement suggestions should be offered
    And acquisition targets should be suggested

  @team-comparison
  Scenario: Compare to league leaders
    Given I want to compare to top teams
    When I compare to league leaders
    Then I should see how I stack up
    And gaps should be identified
    And what leaders do differently should be shown

  @team-comparison
  Scenario: Compare playoff matchups
    Given playoff scenarios exist
    When I compare potential matchups
    Then I should see how I match up
    And win probabilities should be shown
    And key matchups should be identified

  @team-comparison
  Scenario: Save comparison for later
    Given I have made a comparison
    When I save the comparison
    Then it should be stored
    And I should be able to access it later
    And I should be able to share it

  @team-comparison
  Scenario: Generate comparison report
    Given I want a detailed comparison
    When I generate a comparison report
    Then a comprehensive report should be created
    And all metrics should be included
    And the report should be downloadable

  # --------------------------------------------------------------------------
  # Team Management Scenarios
  # --------------------------------------------------------------------------
  @team-management
  Scenario: Invite co-owner
    Given I want to share team management
    When I invite a co-owner
    Then an invitation should be sent
    And the invitee should be able to accept
    And co-owner should gain appropriate access

  @team-management
  Scenario: Set manager permissions
    Given I have co-owners or managers
    When I configure permissions
    Then I should be able to grant specific permissions
    And permission levels should be customizable
    And changes should take effect immediately

  @team-management
  Scenario: Transfer team ownership
    Given I want to transfer my team
    When I initiate a team transfer
    Then the new owner should be confirmed
    And all ownership should transfer
    And I should lose access after transfer

  @team-management
  Scenario: View ownership history
    Given the team has had multiple owners
    When I view ownership history
    Then all past owners should be listed
    And transfer dates should be shown
    And ownership duration should be calculated

  @team-management
  Scenario: Remove co-owner
    Given I have a co-owner I want to remove
    When I remove the co-owner
    Then their access should be revoked
    And they should be notified
    And the removal should be logged

  @team-management
  Scenario: Set primary contact
    Given the team has multiple managers
    When I set the primary contact
    Then that person should receive primary notifications
    And they should be the main point of contact
    And the setting should be visible

  @team-management
  Scenario: Manage team access levels
    Given different access levels exist
    When I manage access levels
    Then I should be able to assign levels
    And level descriptions should be clear
    And access should be enforced accordingly

  @team-management
  Scenario: Archive team management history
    Given management changes have occurred
    When I view management history
    Then all changes should be logged
    And I should be able to search history
    And history should be exportable

  # --------------------------------------------------------------------------
  # Team Finances Scenarios
  # --------------------------------------------------------------------------
  @team-finances
  Scenario: View transaction budget
    Given the league has transaction limits
    When I view my transaction budget
    Then remaining transactions should be shown
    And used transactions should be listed
    And budget period should be indicated

  @team-finances
  Scenario: View FAAB balance
    Given the league uses FAAB
    When I view my FAAB balance
    Then current balance should be shown
    And spent FAAB should be listed
    And FAAB history should be available

  @team-finances
  Scenario: Manage salary cap
    Given the league has salary caps
    When I view cap management
    Then total cap should be shown
    And current usage should be displayed
    And cap space should be calculated

  @team-finances
  Scenario: Track dead money
    Given I have dead money on my cap
    When I view dead money tracking
    Then dead money amount should be shown
    And sources should be listed
    And expiration should be indicated

  @team-finances
  Scenario: Project future cap space
    Given contracts have future implications
    When I view cap projections
    Then future cap situations should be shown
    And pending increases should be noted
    And planning tools should be available

  @team-finances
  Scenario: View financial history
    Given financial transactions have occurred
    When I view financial history
    Then all transactions should be listed
    And dates and amounts should be shown
    And I should be able to filter and search

  @team-finances
  Scenario: Export financial data
    Given I want to save financial data
    When I export financial data
    Then all financial information should be exported
    And historical data should be included
    And the format should be selectable

  @team-finances
  Scenario: Receive low budget alerts
    Given I am running low on budget
    When my balance drops below threshold
    Then I should receive an alert
    And the alert should be configurable
    And suggestions should be offered

  # --------------------------------------------------------------------------
  # Team Achievements Scenarios
  # --------------------------------------------------------------------------
  @team-achievements
  Scenario: View trophy case
    Given my team has won trophies
    When I view my trophy case
    Then all trophies should be displayed
    And trophy details should be viewable
    And the case should be visually appealing

  @team-achievements
  Scenario: Earn badges
    Given badge criteria are defined
    When I meet badge criteria
    Then I should earn the badge
    And I should be notified
    And the badge should appear on my profile

  @team-achievements
  Scenario: View milestone awards
    Given milestones are tracked
    When I achieve a milestone
    Then I should receive an award
    And the milestone should be recorded
    And the award should be displayable

  @team-achievements
  Scenario: Display championship banners
    Given I have won championships
    When I view championship banners
    Then all banners should be shown
    And years should be indicated
    And banners should be prominently displayed

  @team-achievements
  Scenario: Unlock hidden achievements
    Given hidden achievements exist
    When I complete hidden criteria
    Then the achievement should unlock
    And I should be surprised by it
    And the achievement should be revealed

  @team-achievements
  Scenario: Share achievements
    Given I want to share an achievement
    When I share the achievement
    Then it should be shareable to social media
    And the share should include achievement details
    And the share should be visually appealing

  @team-achievements
  Scenario: Compare achievements with others
    Given other teams have achievements
    When I compare achievements
    Then I should see comparative counts
    And unique achievements should be highlighted
    And progress toward others' achievements should show

  @team-achievements
  Scenario: Track achievement progress
    Given achievements have multiple levels
    When I view achievement progress
    Then progress should be shown for each
    And next level requirements should be displayed
    And tips for earning should be offered

  # --------------------------------------------------------------------------
  # Error Handling Scenarios
  # --------------------------------------------------------------------------
  @error-handling
  Scenario: Handle logo upload failure
    Given I am uploading a team logo
    And the upload fails
    When the error occurs
    Then I should see a clear error message
    And I should be able to retry
    And my previous logo should be preserved

  @error-handling
  Scenario: Handle invalid team name
    Given I am setting a team name
    And the name is invalid
    When I submit the name
    Then I should see validation errors
    And the error should explain the issue
    And I should be able to correct it

  @error-handling
  Scenario: Handle roster sync failure
    Given roster data fails to sync
    When the error occurs
    Then I should be notified
    And cached data should be shown
    And sync should be retried automatically

  @error-handling
  Scenario: Handle permission denied error
    Given I lack permission for an action
    When I attempt the action
    Then I should see a permission error
    And the error should explain what permission is needed
    And I should be redirected appropriately

  @error-handling
  Scenario: Handle financial calculation error
    Given a financial calculation fails
    When the error occurs
    Then I should be notified
    And last known good values should show
    And recalculation should be offered

  @error-handling
  Scenario: Handle co-owner invitation failure
    Given I am inviting a co-owner
    And the invitation fails
    When the error occurs
    Then I should see an error message
    And the reason should be explained
    And I should be able to try again

  @error-handling
  Scenario: Handle achievement tracking error
    Given achievement tracking fails
    When the error occurs
    Then I should be notified
    And achievements should not be lost
    And tracking should resume when fixed

  @error-handling
  Scenario: Handle settings save failure
    Given I am saving team settings
    And the save fails
    When the error occurs
    Then I should see an error message
    And my changes should not be lost
    And I should be able to retry

  # --------------------------------------------------------------------------
  # Accessibility Scenarios
  # --------------------------------------------------------------------------
  @accessibility
  Scenario: Navigate team pages with keyboard
    Given I am on a team page
    When I navigate using only keyboard
    Then all team features should be accessible
    And focus indicators should be visible
    And tab order should be logical

  @accessibility
  Scenario: Use team features with screen reader
    Given I am using a screen reader
    When I access team pages
    Then all content should be announced
    And images should have alt text
    And actions should be clearly described

  @accessibility
  Scenario: View team pages in high contrast
    Given I have high contrast mode enabled
    When I view team pages
    Then all elements should be visible
    And team colors should not obscure content
    And text should meet contrast requirements

  @accessibility
  Scenario: Access team on mobile device
    Given I am using a mobile device
    When I access team features
    Then all features should be accessible
    And touch targets should be appropriately sized
    And the interface should be responsive

  @accessibility
  Scenario: Use team features with text scaling
    Given I have increased text size
    When I view team pages
    Then text should scale appropriately
    And layouts should adapt
    And no content should be cut off

  @accessibility
  Scenario: Navigate achievements accessibly
    Given I am viewing achievements
    When I use assistive technology
    Then achievements should be fully accessible
    And progress should be conveyed
    And all details should be available

  @accessibility
  Scenario: Upload logo with accessibility
    Given I need to upload a logo
    When I use the upload feature
    Then the upload should be keyboard accessible
    And status should be announced
    And errors should be clearly communicated

  @accessibility
  Scenario: Compare teams accessibly
    Given I am comparing teams
    When I use comparison features
    Then comparisons should be understandable
    And charts should have text alternatives
    And data should be accessible

  # --------------------------------------------------------------------------
  # Performance Scenarios
  # --------------------------------------------------------------------------
  @performance
  Scenario: Load team profile quickly
    Given I am accessing a team profile
    When the page loads
    Then the profile should load within 2 seconds
    And key information should appear first
    And additional content should load progressively

  @performance
  Scenario: Load large roster efficiently
    Given the team has a large roster
    When I view the roster
    Then all players should load quickly
    And the interface should remain responsive
    And sorting and filtering should be fast

  @performance
  Scenario: Handle team branding updates
    Given I am updating team branding
    When I save changes
    Then changes should apply within seconds
    And preview should be fast
    And no lag should occur

  @performance
  Scenario: Calculate team stats efficiently
    Given complex stats need calculation
    When I view team stats
    Then stats should calculate quickly
    And the interface should not freeze
    And results should be accurate

  @performance
  Scenario: Compare teams without delay
    Given I am comparing multiple teams
    When comparisons are generated
    Then results should appear within 2 seconds
    And charts should render quickly
    And data should be accurate

  @performance
  Scenario: Handle concurrent team access
    Given many users access team pages
    When all users are active
    Then all should have smooth experience
    And no timeouts should occur
    And data should be consistent

  @performance
  Scenario: Load achievement data efficiently
    Given the team has many achievements
    When I view achievements
    Then all achievements should load quickly
    And images should be optimized
    And scrolling should be smooth

  @performance
  Scenario: Cache team data appropriately
    Given I access team data frequently
    When I return to team pages
    Then cached data should load instantly
    And fresh data should be fetched as needed
    And cache should be invalidated appropriately
