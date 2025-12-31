@leagues @anima-1361
Feature: Leagues
  As a fantasy football enthusiast
  I want to create and manage fantasy leagues
  So that I can compete with friends and other managers in organized competition

  Background:
    Given I am a logged-in user
    And the fantasy platform is available

  # ============================================================================
  # LEAGUE CREATION
  # ============================================================================

  @happy-path @league-creation
  Scenario: Create a new league
    Given I am on the create league page
    When I enter a league name
    And I select league settings
    And I submit the creation form
    Then a new league should be created
    And I should be the commissioner

  @happy-path @league-creation
  Scenario: Select league type during creation
    Given I am creating a new league
    When I select a league type
    Then I should see options for redraft, keeper, or dynasty
    And the selected type should be saved

  @happy-path @league-creation
  Scenario: Configure scoring format during creation
    Given I am creating a new league
    When I configure scoring format
    Then I should see standard, PPR, and half-PPR options
    And I should be able to customize point values

  @happy-path @league-creation
  Scenario: Set roster positions during creation
    Given I am creating a new league
    When I configure roster positions
    Then I should set number of each position slot
    And I should configure bench and IR spots

  @happy-path @league-creation
  Scenario: Select draft type during creation
    Given I am creating a new league
    When I select draft type
    Then I should see snake, auction, and linear options
    And the selected draft type should be saved

  @happy-path @league-creation
  Scenario: Set league size during creation
    Given I am creating a new league
    When I set the number of teams
    Then the league should accommodate that many teams
    And roster and scoring should adjust accordingly

  @happy-path @league-creation
  Scenario: Create league from template
    Given I am creating a new league
    When I select a league template
    Then settings should be pre-populated
    And I should be able to modify template settings

  @happy-path @league-creation
  Scenario: Copy settings from existing league
    Given I have an existing league
    When I create a new league and copy settings
    Then all settings should be duplicated
    And I should be able to modify copied settings

  @error @league-creation
  Scenario: Attempt to create league with invalid name
    Given I am creating a new league
    When I enter an invalid or empty league name
    Then I should see a validation error
    And the league should not be created

  @error @league-creation
  Scenario: Attempt to create league with conflicting settings
    Given I am creating a new league
    When I select incompatible settings
    Then I should see a warning about conflicts
    And I should be prompted to resolve conflicts

  # ============================================================================
  # LEAGUE SETTINGS
  # ============================================================================

  @happy-path @league-settings
  Scenario: Configure scoring rules
    Given I am a league commissioner
    When I access scoring settings
    Then I should be able to set point values
    And I should configure bonus scoring options

  @happy-path @league-settings
  Scenario: Configure roster positions
    Given I am a league commissioner
    When I access roster settings
    Then I should set starting position requirements
    And I should configure flex positions

  @happy-path @league-settings
  Scenario: Configure trade settings
    Given I am a league commissioner
    When I access trade settings
    Then I should set trade review period
    And I should configure trade veto options

  @happy-path @league-settings
  Scenario: Configure waiver settings
    Given I am a league commissioner
    When I access waiver settings
    Then I should set waiver type (rolling, FAAB)
    And I should configure waiver processing time

  @happy-path @league-settings
  Scenario: Configure playoff settings
    Given I am a league commissioner
    When I access playoff settings
    Then I should set number of playoff teams
    And I should configure playoff bracket format

  @happy-path @league-settings
  Scenario: Configure division settings
    Given I am a league commissioner
    When I access division settings
    Then I should be able to create divisions
    And I should assign teams to divisions

  @happy-path @league-settings
  Scenario: Lock settings after season start
    Given the season has started
    When I try to change certain settings
    Then some settings should be locked
    And I should see which settings are modifiable

  @commissioner @league-settings
  Scenario: Override locked settings
    Given I am a commissioner with override permissions
    When I override a locked setting
    Then the setting should be changed
    And a notification should be sent to members

  # ============================================================================
  # LEAGUE MEMBERS
  # ============================================================================

  @happy-path @league-members
  Scenario: Invite members to league
    Given I am a league commissioner
    When I send league invitations
    Then invitations should be sent to recipients
    And I should see pending invitation status

  @happy-path @league-members
  Scenario: Join league with invitation code
    Given I have a league invitation code
    When I enter the code
    Then I should join the league
    And I should be assigned a team

  @happy-path @league-members
  Scenario: View member list
    Given I am a league member
    When I view the member list
    Then I should see all league members
    And I should see their team names and roles

  @happy-path @league-members
  Scenario: Assign member roles
    Given I am a league commissioner
    When I assign roles to members
    Then I should be able to set co-commissioners
    And role changes should take effect immediately

  @happy-path @league-members
  Scenario: Remove member from league
    Given I am a league commissioner
    When I remove a member
    Then the member should be removed from the league
    And their team should become available

  @happy-path @league-members
  Scenario: Transfer team ownership
    Given a member wants to leave
    When I transfer their team to a new owner
    Then the new owner should control the team
    And roster and history should be preserved

  @happy-path @league-members
  Scenario: View member activity
    Given I am viewing league members
    When I check member activity
    Then I should see last login times
    And I should see transaction activity

  @error @league-members
  Scenario: Attempt to join full league
    Given a league is at capacity
    When I try to join the league
    Then I should see a message that the league is full
    And my join request should be rejected

  @error @league-members
  Scenario: Attempt to remove commissioner
    Given there is only one commissioner
    When I try to remove the commissioner
    Then the removal should be blocked
    And I should see an error message

  # ============================================================================
  # COMMISSIONER TOOLS
  # ============================================================================

  @commissioner @commissioner-tools
  Scenario: Edit league settings
    Given I am a league commissioner
    When I access commissioner tools
    Then I should be able to edit all league settings
    And changes should be logged

  @commissioner @commissioner-tools
  Scenario: Manage league members
    Given I am a league commissioner
    When I access member management
    Then I should be able to add, remove, or modify members
    And I should manage member permissions

  @commissioner @commissioner-tools
  Scenario: Process manual transactions
    Given I am a league commissioner
    When I process a manual transaction
    Then the transaction should be executed immediately
    And affected parties should be notified

  @commissioner @commissioner-tools
  Scenario: Resolve disputes
    Given there is a dispute in the league
    When I access dispute resolution
    Then I should see dispute details
    And I should be able to make a ruling

  @commissioner @commissioner-tools
  Scenario: Post league notes
    Given I am a league commissioner
    When I post league notes
    Then all members should see the notes
    And notes should be timestamped

  @commissioner @commissioner-tools
  Scenario: Adjust team rosters
    Given I am a league commissioner
    When I make roster adjustments
    Then changes should be applied immediately
    And the affected team should be notified

  @commissioner @commissioner-tools
  Scenario: Reverse transactions
    Given a transaction was made in error
    When I reverse the transaction
    Then the transaction should be undone
    And all parties should be notified

  @commissioner @commissioner-tools
  Scenario: Set team on autopilot
    Given a team owner is inactive
    When I enable autopilot for their team
    Then the team should auto-set lineups
    And auto-drop injured players if configured

  # ============================================================================
  # LEAGUE TYPES
  # ============================================================================

  @happy-path @league-types
  Scenario: Create redraft league
    Given I am creating a new league
    When I select redraft type
    Then all rosters should reset each season
    And no keeper rules should apply

  @happy-path @league-types
  Scenario: Create keeper league
    Given I am creating a new league
    When I select keeper type
    Then I should configure keeper rules
    And teams should retain selected players

  @happy-path @league-types
  Scenario: Create dynasty league
    Given I am creating a new league
    When I select dynasty type
    Then rosters should carry over fully
    And rookie drafts should be configured

  @happy-path @league-types
  Scenario: Create best ball league
    Given I am creating a new league
    When I select best ball type
    Then optimal lineups should be auto-set
    And no lineup management should be required

  @happy-path @league-types
  Scenario: Create survivor league
    Given I am creating a new league
    When I select survivor type
    Then elimination rules should be configured
    And weekly picks should be tracked

  @happy-path @league-types
  Scenario: Create pick'em league
    Given I am creating a new league
    When I select pick'em type
    Then weekly game picks should be enabled
    And confidence points should be configurable

  @happy-path @league-types
  Scenario: Create DFS league
    Given I am creating a new league
    When I select DFS type
    Then salary cap settings should be configured
    And daily lineups should be enabled

  # ============================================================================
  # LEAGUE FORMATS
  # ============================================================================

  @happy-path @league-formats
  Scenario: Configure head-to-head format
    Given I am configuring league format
    When I select head-to-head
    Then weekly matchups should be scheduled
    And win-loss records should be tracked

  @happy-path @league-formats
  Scenario: Configure points-only format
    Given I am configuring league format
    When I select points-only
    Then standings should be based on total points
    And no head-to-head matchups should occur

  @happy-path @league-formats
  Scenario: Configure rotisserie format
    Given I am configuring league format
    When I select rotisserie
    Then category rankings should be tracked
    And composite scores should determine standings

  @happy-path @league-formats
  Scenario: Configure salary cap format
    Given I am configuring league format
    When I select salary cap
    Then team budgets should be enforced
    And player salaries should be tracked

  @happy-path @league-formats
  Scenario: Configure auction format
    Given I am configuring league format
    When I select auction draft
    Then bidding rules should be configured
    And nomination order should be set

  @happy-path @league-formats
  Scenario: Configure hybrid format
    Given I am configuring league format
    When I combine multiple formats
    Then hybrid rules should be applied
    And all format components should work together

  # ============================================================================
  # LEAGUE SCHEDULE
  # ============================================================================

  @happy-path @league-schedule
  Scenario: View regular season schedule
    Given I am in a league
    When I view the schedule
    Then I should see all regular season matchups
    And matchups should show dates and opponents

  @happy-path @league-schedule
  Scenario: View playoff bracket
    Given the playoffs are scheduled
    When I view the playoff bracket
    Then I should see the bracket structure
    And matchup paths should be visible

  @happy-path @league-schedule
  Scenario: View bye weeks in schedule
    Given I am viewing the schedule
    Then bye weeks should be clearly marked
    And my team's bye weeks should be highlighted

  @happy-path @league-schedule
  Scenario: View matchup schedule for specific week
    Given I am viewing the schedule
    When I select a specific week
    Then I should see all matchups for that week
    And game times should be displayed

  @happy-path @league-schedule
  Scenario: Generate league schedule
    Given I am a league commissioner
    When I generate the schedule
    Then matchups should be created for all teams
    And the schedule should be balanced

  @happy-path @league-schedule
  Scenario: Modify schedule manually
    Given I am a league commissioner
    When I modify the schedule
    Then matchup changes should be saved
    And affected teams should be notified

  @happy-path @league-schedule
  Scenario: View schedule conflicts
    Given the schedule has conflicts
    When I view schedule analysis
    Then conflicts should be highlighted
    And resolution suggestions should be provided

  @commissioner @league-schedule
  Scenario: Set playoff start week
    Given I am configuring playoffs
    When I set the playoff start week
    Then the regular season should end accordingly
    And playoff seeding should be calculated

  # ============================================================================
  # LEAGUE HISTORY
  # ============================================================================

  @happy-path @league-history
  Scenario: View past seasons
    Given my league has multiple seasons
    When I view league history
    Then I should see all past seasons
    And final standings should be displayed

  @happy-path @league-history
  Scenario: View all-time records
    Given I am viewing league history
    When I check all-time records
    Then I should see records like most points scored
    And record holders should be identified

  @happy-path @league-history
  Scenario: View hall of fame
    Given the league has a hall of fame
    When I view the hall of fame
    Then I should see inducted members
    And their achievements should be listed

  @happy-path @league-history
  Scenario: View trophy case
    Given the league has trophies
    When I view the trophy case
    Then I should see all trophies and awards
    And winners should be listed for each

  @happy-path @league-history
  Scenario: View historical statistics
    Given I am viewing league history
    When I check historical stats
    Then I should see all-time statistics
    And stats should be filterable by season

  @happy-path @league-history
  Scenario: Compare historical seasons
    Given I am viewing league history
    When I compare multiple seasons
    Then I should see side-by-side comparisons
    And trends should be visible

  @happy-path @league-history
  Scenario: Export league history
    Given I am viewing league history
    When I export history data
    Then I should receive a downloadable file
    And all historical data should be included

  # ============================================================================
  # LEAGUE COMMUNICATION
  # ============================================================================

  @happy-path @league-communication
  Scenario: Post to message board
    Given I am a league member
    When I post to the message board
    Then my message should appear on the board
    And other members should be able to reply

  @happy-path @league-communication
  Scenario: Use league chat
    Given league chat is enabled
    When I send a chat message
    Then the message should appear in chat
    And other online members should see it

  @happy-path @league-communication
  Scenario: View commissioner announcements
    Given the commissioner posted an announcement
    When I access the league
    Then I should see the announcement
    And it should be prominently displayed

  @happy-path @league-communication
  Scenario: Create league poll
    Given I am a league member
    When I create a poll
    Then members should be able to vote
    And results should be visible

  @happy-path @league-communication
  Scenario: Send league newsletter
    Given I am a league commissioner
    When I send a newsletter
    Then all members should receive it
    And the newsletter should be archived

  @happy-path @league-communication
  Scenario: Send direct message to member
    Given I want to message another member
    When I send a direct message
    Then the recipient should receive it
    And message history should be saved

  @happy-path @league-communication
  Scenario: Report inappropriate content
    Given I see inappropriate content
    When I report the content
    Then the report should be sent to commissioners
    And I should see confirmation

  @mobile @league-communication
  Scenario: Use league chat on mobile
    Given I am on a mobile device
    When I access league chat
    Then the chat should be mobile-optimized
    And push notifications should work

  # ============================================================================
  # LEAGUE CUSTOMIZATION
  # ============================================================================

  @happy-path @league-customization
  Scenario: Set team name
    Given I own a team
    When I change my team name
    Then the new name should be saved
    And it should display throughout the league

  @happy-path @league-customization
  Scenario: Upload team logo
    Given I own a team
    When I upload a team logo
    Then the logo should be saved
    And it should display with my team

  @happy-path @league-customization
  Scenario: Set team colors
    Given I own a team
    When I set team colors
    Then colors should be applied to my team display
    And colors should be visible in matchups

  @happy-path @league-customization
  Scenario: Customize league branding
    Given I am a league commissioner
    When I customize league branding
    Then the league should have custom appearance
    And branding should be visible throughout

  @happy-path @league-customization
  Scenario: Create custom awards
    Given I am a league commissioner
    When I create custom awards
    Then awards should be available for distribution
    And award history should be tracked

  @happy-path @league-customization
  Scenario: Set league motto
    Given I am a league commissioner
    When I set a league motto
    Then the motto should be displayed
    And it should appear on the league homepage

  @happy-path @league-customization
  Scenario: Configure league theme
    Given I am a league commissioner
    When I select a league theme
    Then the theme should be applied
    And all pages should reflect the theme

  @error @league-customization
  Scenario: Upload invalid logo format
    Given I am uploading a team logo
    When I upload an invalid file format
    Then I should see an error message
    And the upload should be rejected

  @error @league-customization
  Scenario: Upload oversized logo
    Given I am uploading a team logo
    When the file exceeds size limits
    Then I should see a size error
    And I should be prompted to resize

  @accessibility @league-customization
  Scenario: Ensure color contrast accessibility
    Given I am setting team colors
    Then the system should check color contrast
    And warn about accessibility issues
