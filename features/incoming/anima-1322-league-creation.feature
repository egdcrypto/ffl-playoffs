@league-creation @ANIMA-1322
Feature: League Creation
  As a fantasy football enthusiast
  I want to create and configure fantasy leagues
  So that I can organize competitions with my friends

  Background:
    Given the fantasy football playoffs application is running
    And I am logged in as a registered user

  # ============================================================================
  # LEAGUE SETUP WIZARD - HAPPY PATH
  # ============================================================================

  @happy-path @setup-wizard
  Scenario: Start league creation wizard
    Given I am on the main dashboard
    When I click "Create New League"
    Then I should see the league creation wizard
    And I should see step indicators
    And I should be on the first step

  @happy-path @setup-wizard
  Scenario: Complete basic league information step
    Given I am in the league creation wizard
    And I am on the basic information step
    When I enter a league name
    And I select the number of teams
    And I click "Next"
    Then I should proceed to the next step
    And my information should be saved

  @happy-path @setup-wizard
  Scenario: Navigate wizard steps
    Given I am in the league creation wizard
    When I complete each step
    Then I should be able to go back to previous steps
    And I should see my previous selections preserved
    And I should see progress in the step indicator

  @happy-path @setup-wizard
  Scenario: Save draft and continue later
    Given I am partway through the wizard
    When I click "Save Draft"
    Then my progress should be saved
    And I should be able to return later
    And I should resume where I left off

  @happy-path @setup-wizard
  Scenario: Complete wizard and create league
    Given I have completed all wizard steps
    When I click "Create League"
    Then the league should be created
    And I should be taken to the league home page
    And I should be assigned as commissioner

  @happy-path @setup-wizard
  Scenario: Use league template
    Given I am starting league creation
    When I select a pre-configured template
    Then settings should be populated automatically
    And I should be able to modify template settings
    And I should proceed with template as base

  # ============================================================================
  # LEAGUE TYPE SELECTION
  # ============================================================================

  @happy-path @league-type
  Scenario: Select redraft league type
    Given I am selecting league type
    When I choose "Redraft"
    Then redraft-specific options should appear
    And keeper/dynasty options should be hidden
    And the league should be configured for annual reset

  @happy-path @league-type
  Scenario: Select keeper league type
    Given I am selecting league type
    When I choose "Keeper"
    Then keeper configuration options should appear
    And I should be able to set number of keepers
    And I should see keeper cost options

  @happy-path @league-type
  Scenario: Select dynasty league type
    Given I am selecting league type
    When I choose "Dynasty"
    Then dynasty-specific options should appear
    And I should see taxi squad options
    And I should see rookie draft settings

  @happy-path @league-type
  Scenario: Select best ball league type
    Given I am selecting league type
    When I choose "Best Ball"
    Then best ball scoring should be configured
    And lineup setting should be disabled
    And optimal lineup should auto-calculate

  @happy-path @league-type
  Scenario: Select guillotine league type
    Given I am selecting league type
    When I choose "Guillotine"
    Then elimination rules should be configured
    And weekly elimination settings should appear
    And playoff format should be adjusted

  @happy-path @league-type
  Scenario: Select IDP league type
    Given I am selecting league type
    When I enable "Include IDP"
    Then defensive player positions should be added
    And IDP scoring settings should appear
    And roster spots should include defense

  # ============================================================================
  # SCORING SETTINGS
  # ============================================================================

  @happy-path @scoring
  Scenario: Configure standard scoring
    Given I am configuring scoring settings
    When I select "Standard Scoring"
    Then default scoring values should load
    And I should see points per stat category
    And I should be able to modify values

  @happy-path @scoring
  Scenario: Configure PPR scoring
    Given I am configuring scoring settings
    When I select "PPR Scoring"
    Then points per reception should be set to 1
    And other settings should use PPR defaults
    And I should be able to adjust reception points

  @happy-path @scoring
  Scenario: Configure half-PPR scoring
    Given I am configuring scoring settings
    When I select "Half-PPR Scoring"
    Then points per reception should be set to 0.5
    And other settings should use half-PPR defaults
    And I should see the scoring summary

  @happy-path @scoring
  Scenario: Configure custom scoring
    Given I am configuring scoring settings
    When I select "Custom Scoring"
    Then I should be able to set each stat category
    And I should see all available scoring options
    And I should be able to add bonus scoring

  @happy-path @scoring
  Scenario: Configure passing touchdown points
    Given I am in custom scoring settings
    When I set passing touchdown points
    Then I should be able to choose 4, 6, or custom value
    And the change should be reflected in projections
    And the scoring summary should update

  @happy-path @scoring
  Scenario: Configure bonus scoring
    Given I am in scoring settings
    When I add bonus scoring rules
    Then I should be able to set yardage bonuses
    And I should set long play bonuses
    And I should see bonus thresholds

  @happy-path @scoring
  Scenario: Configure TE premium scoring
    Given I am configuring scoring settings
    When I enable TE Premium
    Then tight ends should receive bonus reception points
    And I should be able to set the premium amount
    And the change should affect projections

  @happy-path @scoring
  Scenario: Preview scoring with sample game
    Given I have configured scoring settings
    When I click "Preview Scoring"
    Then I should see a sample player performance
    And I should see calculated points
    And I should be able to verify settings

  # ============================================================================
  # ROSTER CONFIGURATION
  # ============================================================================

  @happy-path @roster-config
  Scenario: Configure starting lineup positions
    Given I am configuring roster settings
    When I set starting lineup requirements
    Then I should specify number of each position
    And I should be able to add flex positions
    And I should see roster summary

  @happy-path @roster-config
  Scenario: Configure bench size
    Given I am configuring roster settings
    When I set bench size
    Then I should be able to choose number of bench spots
    And the total roster size should update
    And I should see roster capacity

  @happy-path @roster-config
  Scenario: Configure IR slots
    Given I am configuring roster settings
    When I enable IR slots
    Then I should set number of IR positions
    And I should configure IR eligibility rules
    And IR slots should not count against active roster

  @happy-path @roster-config
  Scenario: Configure superflex position
    Given I am configuring roster settings
    When I add a superflex position
    Then QB eligibility should be added to flex
    And roster projections should update
    And I should see superflex in lineup requirements

  @happy-path @roster-config
  Scenario: Configure taxi squad for dynasty
    Given the league is dynasty type
    When I configure taxi squad
    Then I should set taxi squad size
    And I should set eligibility rules
    And I should configure promotion rules

  @happy-path @roster-config
  Scenario: Configure roster limits by position
    Given I am configuring roster settings
    When I set position limits
    Then I should limit players per position
    And limits should apply to adds and trades
    And I should see limit summary

  # ============================================================================
  # DRAFT SETTINGS
  # ============================================================================

  @happy-path @draft-settings
  Scenario: Configure snake draft
    Given I am configuring draft settings
    When I select "Snake Draft"
    Then snake draft options should appear
    And I should set pick time limits
    And draft order options should be available

  @happy-path @draft-settings
  Scenario: Configure auction draft
    Given I am configuring draft settings
    When I select "Auction Draft"
    Then auction options should appear
    And I should set budget per team
    And I should configure bid increments

  @happy-path @draft-settings
  Scenario: Configure slow draft
    Given I am configuring draft settings
    When I select "Slow Draft"
    Then slow draft timing should be set
    And I should configure hours per pick
    And I should set draft pause times

  @happy-path @draft-settings
  Scenario: Schedule draft date
    Given I am configuring draft settings
    When I set the draft date and time
    Then a calendar picker should appear
    And timezone should be configurable
    And all managers should see the scheduled time

  @happy-path @draft-settings
  Scenario: Configure draft order method
    Given I am configuring draft settings
    When I select draft order method
    Then I should choose random, lottery, or manual
    And the method should be saved
    And order determination should follow selection

  @happy-path @draft-settings
  Scenario: Configure rookie draft for dynasty
    Given the league is dynasty type
    When I configure rookie draft settings
    Then I should set rookie draft rounds
    And I should configure rookie draft format
    And I should set rookie draft timing

  # ============================================================================
  # TRADE RULES
  # ============================================================================

  @happy-path @trade-rules
  Scenario: Configure trade deadline
    Given I am configuring trade settings
    When I set the trade deadline
    Then I should pick a date or week number
    And trades should be blocked after deadline
    And the deadline should be displayed to managers

  @happy-path @trade-rules
  Scenario: Configure trade review period
    Given I am configuring trade settings
    When I set trade review period
    Then I should set hours for review
    And other managers should be able to vote
    And trades should process after period

  @happy-path @trade-rules
  Scenario: Configure trade veto settings
    Given I am configuring trade settings
    When I set veto rules
    Then I should choose commissioner or league vote
    And I should set vote threshold
    And veto process should be defined

  @happy-path @trade-rules
  Scenario: Enable future pick trading
    Given I am configuring trade settings
    When I enable future pick trading
    Then managers should be able to trade future picks
    And I should set how many years ahead
    And pick trading limits should be configurable

  @happy-path @trade-rules
  Scenario: Configure trade approval process
    Given I am configuring trade settings
    When I set approval process
    Then I should choose instant, commissioner, or vote
    And I should configure review timeline
    And the process should be documented

  # ============================================================================
  # WAIVER RULES
  # ============================================================================

  @happy-path @waiver-rules
  Scenario: Configure waiver priority system
    Given I am configuring waiver settings
    When I select priority system
    Then I should choose inverse standings, rolling, or FAAB
    And the system rules should be explained
    And priority reset options should appear

  @happy-path @waiver-rules
  Scenario: Configure FAAB budget
    Given I am configuring waiver settings
    And FAAB is selected
    When I set FAAB settings
    Then I should set budget per team
    And I should set minimum bid
    And I should configure tiebreaker rules

  @happy-path @waiver-rules
  Scenario: Configure waiver processing time
    Given I am configuring waiver settings
    When I set waiver processing time
    Then I should choose day and time
    And timezone should be shown
    And processing schedule should be clear

  @happy-path @waiver-rules
  Scenario: Configure waiver periods
    Given I am configuring waiver settings
    When I set waiver period duration
    Then I should set hours on waivers
    And I should configure game-time waivers
    And waiver rules should be summarized

  @happy-path @waiver-rules
  Scenario: Configure continuous waivers
    Given I am configuring waiver settings
    When I enable continuous waivers
    Then waivers should process multiple times
    And I should set processing frequency
    And free agent availability should be defined

  # ============================================================================
  # PLAYOFF SETTINGS
  # ============================================================================

  @happy-path @playoff-settings
  Scenario: Configure number of playoff teams
    Given I am configuring playoff settings
    When I set number of playoff teams
    Then I should see valid options based on league size
    And playoff bracket should preview
    And seeding rules should appear

  @happy-path @playoff-settings
  Scenario: Configure playoff start week
    Given I am configuring playoff settings
    When I set playoff start week
    Then the regular season length should adjust
    And playoff weeks should be displayed
    And schedule should update

  @happy-path @playoff-settings
  Scenario: Configure playoff bracket format
    Given I am configuring playoff settings
    When I select bracket format
    Then I should choose single elimination or other
    And I should configure bye weeks
    And matchup format should be set

  @happy-path @playoff-settings
  Scenario: Configure two-week playoff matchups
    Given I am configuring playoff settings
    When I enable two-week matchups
    Then playoff rounds should span two weeks
    And scoring should accumulate
    And the schedule should adjust

  @happy-path @playoff-settings
  Scenario: Configure consolation bracket
    Given I am configuring playoff settings
    When I enable consolation bracket
    Then non-playoff teams should have games
    And consolation winner should be tracked
    And toilet bowl should be optional

  @happy-path @playoff-settings
  Scenario: Configure playoff seeding
    Given I am configuring playoff settings
    When I set seeding rules
    Then I should choose by record, points, or division
    And tiebreaker rules should be defined
    And seeding priority should be clear

  # ============================================================================
  # DIVISION SETUP
  # ============================================================================

  @happy-path @divisions
  Scenario: Enable divisions
    Given I am configuring league structure
    When I enable divisions
    Then I should set number of divisions
    And I should name each division
    And I should assign teams to divisions

  @happy-path @divisions
  Scenario: Configure divisional play
    Given divisions are enabled
    When I configure divisional play
    Then I should set intra-division games
    And I should set inter-division games
    And schedule should reflect division structure

  @happy-path @divisions
  Scenario: Configure division winner benefits
    Given divisions are enabled
    When I set division winner rules
    Then I should configure playoff seeding advantage
    And division winners should be guaranteed playoffs
    And tiebreakers should consider division record

  @happy-path @divisions
  Scenario: Balance divisions
    Given teams are assigned to divisions
    When I view division balance
    Then I should see team count per division
    And I should be warned about imbalance
    And I should be able to reassign teams

  # ============================================================================
  # SCHEDULE GENERATION
  # ============================================================================

  @happy-path @schedule
  Scenario: Generate regular season schedule
    Given league configuration is complete
    When I generate the schedule
    Then matchups should be created for each week
    And each team should have equal games
    And rivalries should be considered if set

  @happy-path @schedule
  Scenario: Configure matchup frequency
    Given I am configuring the schedule
    When I set matchup frequency
    Then I should choose single or double round robin
    And schedule length should adjust
    And bye weeks should be configured

  @happy-path @schedule
  Scenario: Set rivalry games
    Given I am configuring the schedule
    When I designate rivalry matchups
    Then specified teams should play specific weeks
    And rivalry games should be highlighted
    And schedule should accommodate rivalries

  @happy-path @schedule
  Scenario: Preview generated schedule
    Given a schedule has been generated
    When I preview the schedule
    Then I should see all matchups by week
    And I should see balance statistics
    And I should be able to regenerate if needed

  @happy-path @schedule
  Scenario: Manually adjust schedule
    Given a schedule has been generated
    When I make manual adjustments
    Then I should be able to swap matchups
    And conflicts should be prevented
    And changes should be validated

  # ============================================================================
  # LEAGUE NAMING AND BRANDING
  # ============================================================================

  @happy-path @branding
  Scenario: Set league name
    Given I am creating a league
    When I enter the league name
    Then the name should be validated
    And the name should appear in league header
    And the name should be searchable

  @happy-path @branding
  Scenario: Upload league logo
    Given I am configuring league branding
    When I upload a league logo
    Then the image should be validated
    And the logo should appear in league pages
    And the logo should be resized appropriately

  @happy-path @branding
  Scenario: Set league colors
    Given I am configuring league branding
    When I select league colors
    Then colors should apply to league theme
    And I should see color preview
    And colors should be saved

  @happy-path @branding
  Scenario: Write league description
    Given I am configuring league branding
    When I write a league description
    Then the description should be saved
    And it should appear on league home
    And it should be visible to invitees

  @happy-path @branding
  Scenario: Set league motto or tagline
    Given I am configuring league branding
    When I enter a league motto
    Then the motto should appear in header
    And it should be part of league identity
    And it should be shown in invitations

  # ============================================================================
  # PRIVACY SETTINGS
  # ============================================================================

  @happy-path @privacy
  Scenario: Set league to public
    Given I am configuring privacy settings
    When I set league to public
    Then the league should be discoverable
    And anyone should be able to request to join
    And league activity should be visible

  @happy-path @privacy
  Scenario: Set league to private
    Given I am configuring privacy settings
    When I set league to private
    Then the league should not be discoverable
    And only invited users can join
    And league activity should be hidden

  @happy-path @privacy
  Scenario: Configure join approval
    Given I am configuring privacy settings
    When I set join approval requirements
    Then I should require commissioner approval
    And I should see pending requests
    And I should be able to approve or deny

  @happy-path @privacy
  Scenario: Set league password
    Given I am configuring privacy settings
    When I set a league password
    Then joiners should enter password
    And password should be validated
    And I should be able to change password

  @happy-path @privacy
  Scenario: Configure roster visibility
    Given I am configuring privacy settings
    When I set roster visibility
    Then I should choose public or private rosters
    And the setting should apply to external viewers
    And league members should always see rosters

  # ============================================================================
  # LEAGUE IMPORT/EXPORT
  # ============================================================================

  @happy-path @import-export
  Scenario: Import league from another platform
    Given I want to import an existing league
    When I start the import process
    Then I should select source platform
    And I should authenticate with that platform
    And league settings should be imported

  @happy-path @import-export
  Scenario: Import league settings from file
    Given I have exported settings previously
    When I import settings from file
    Then settings should populate automatically
    And I should review imported settings
    And I should be able to modify before creating

  @happy-path @import-export
  Scenario: Export league settings
    Given I have configured a league
    When I export league settings
    Then a settings file should be generated
    And the file should be downloadable
    And I should be able to use it for new leagues

  @happy-path @import-export
  Scenario: Copy settings from existing league
    Given I have existing leagues
    When I choose to copy from another league
    Then I should select the source league
    And settings should be copied
    And I should modify as needed

  @happy-path @import-export
  Scenario: Import historical data
    Given I am importing a league
    When I include historical data
    Then past seasons should be imported
    And historical standings should appear
    And records should be preserved

  # ============================================================================
  # COMMISSIONER TOOLS
  # ============================================================================

  @happy-path @commissioner-tools
  Scenario: Access commissioner dashboard
    Given I am the league commissioner
    When I access the commissioner dashboard
    Then I should see all management tools
    And I should see pending actions
    And I should see league health metrics

  @happy-path @commissioner-tools
  Scenario: Invite managers to league
    Given the league is created
    When I invite managers
    Then I should be able to enter email addresses
    And invitation emails should be sent
    And I should see invitation status

  @happy-path @commissioner-tools
  Scenario: Assign co-commissioner
    Given I am the commissioner
    When I assign a co-commissioner
    Then the co-commissioner should get permissions
    And they should access commissioner tools
    And both should be able to manage the league

  @happy-path @commissioner-tools
  Scenario: Manage league settings post-creation
    Given the league is created
    When I access settings management
    Then I should be able to modify most settings
    And some settings should require season reset
    And changes should notify managers

  @happy-path @commissioner-tools
  Scenario: Remove team from league
    Given a manager needs to be removed
    When I remove the team
    Then the team should be removed
    And their roster should become available
    And the slot should open for new manager

  @happy-path @commissioner-tools
  Scenario: Add team mid-season
    Given the league has an open slot
    When I add a new team
    Then I should assign a manager
    And I should set up their roster
    And the schedule should accommodate them

  @happy-path @commissioner-tools
  Scenario: Force transaction
    Given a transaction needs to be forced
    When I use commissioner override
    Then I should be able to complete the transaction
    And a log should be created
    And managers should be notified

  @happy-path @commissioner-tools
  Scenario: Edit player scores
    Given there is a scoring error
    When I edit a player's score
    Then the score should be corrected
    And matchup results should update
    And a correction log should be created

  # ============================================================================
  # ERROR HANDLING
  # ============================================================================

  @error
  Scenario: Attempt to create league with invalid name
    Given I am in the league creation wizard
    When I enter an invalid league name
    Then I should see a validation error
    And I should be prompted to fix the name
    And I should not be able to proceed

  @error
  Scenario: Attempt to create league with insufficient team count
    Given I am configuring league size
    When I set team count below minimum
    Then I should see a validation error
    And minimum requirements should be shown
    And I should adjust the count

  @error
  Scenario: Attempt invalid scoring configuration
    Given I am configuring custom scoring
    When I enter invalid scoring values
    Then I should see validation errors
    And affected fields should be highlighted
    And I should be guided to fix issues

  @error
  Scenario: Attempt to schedule draft in the past
    Given I am setting draft date
    When I select a date in the past
    Then I should see an error message
    And I should be prompted for future date
    And the date should not be saved

  @error
  Scenario: Import fails due to invalid file
    Given I am importing league settings
    When I upload an invalid file
    Then I should see an import error
    And error details should be shown
    And I should be able to try again

  @error
  Scenario: Network error during league creation
    Given I am creating a league
    When a network error occurs
    Then I should see an error message
    And my progress should be preserved
    And I should be able to retry

  @error
  Scenario: Roster configuration conflicts
    Given I am configuring roster settings
    When configurations conflict
    Then I should see conflict warnings
    And conflicts should be explained
    And I should resolve before proceeding

  # ============================================================================
  # MOBILE EXPERIENCE
  # ============================================================================

  @mobile
  Scenario: Create league on mobile device
    Given I am using the mobile app
    When I start league creation
    Then the wizard should be mobile-optimized
    And all steps should be accessible
    And touch controls should work properly

  @mobile
  Scenario: Configure settings on mobile
    Given I am using mobile for league setup
    When I configure various settings
    Then dropdowns should be touch-friendly
    And sliders should work on touch
    And all options should be reachable

  @mobile
  Scenario: Review league summary on mobile
    Given I have completed mobile wizard
    When I view the summary
    Then all settings should be readable
    And I should be able to scroll through
    And confirmation should be easy to tap

  @mobile
  Scenario: Invite managers from mobile
    Given I created a league on mobile
    When I invite managers
    Then I should access contacts if permitted
    And sharing should use native share
    And invitations should send properly

  # ============================================================================
  # ACCESSIBILITY
  # ============================================================================

  @accessibility
  Scenario: Navigate wizard with keyboard
    Given I am using keyboard navigation
    When I go through the wizard
    Then all steps should be keyboard accessible
    And focus should move logically
    And selections should work with keyboard

  @accessibility
  Scenario: Screen reader league creation
    Given I am using a screen reader
    When I create a league
    Then all steps should be announced
    And options should be clearly labeled
    And progress should be communicated

  @accessibility
  Scenario: High contrast league creation
    Given I have high contrast mode enabled
    When I use the league creation wizard
    Then all text should be readable
    And buttons should be visible
    And selections should be clear

  @accessibility
  Scenario: League creation with voice control
    Given I am using voice control
    When I create a league
    Then I should be able to navigate by voice
    And I should select options by voice
    And commands should be recognized
