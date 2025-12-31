@contests @anima-1376
Feature: Contests
  As a fantasy football user
  I want to participate in contests and competitions
  So that I can compete for prizes and test my skills

  Background:
    Given I am a logged-in user
    And the contest system is available

  # ============================================================================
  # CONTEST TYPES
  # ============================================================================

  @happy-path @contest-types
  Scenario: View daily contests
    Given I am in the contest lobby
    When I view daily contests
    Then I should see contests for the day
    And contest details should be shown

  @happy-path @contest-types
  Scenario: View weekly contests
    Given I am in the contest lobby
    When I view weekly contests
    Then I should see contests for the week
    And weekly format should be clear

  @happy-path @contest-types
  Scenario: View season-long contests
    Given I am in the contest lobby
    When I view season-long contests
    Then I should see full season competitions
    And season format should be explained

  @happy-path @contest-types
  Scenario: View tournaments
    Given I am in the contest lobby
    When I view tournaments
    Then I should see tournament brackets
    And tournament rules should be shown

  @happy-path @contest-types
  Scenario: View head-to-head contests
    Given I am in the contest lobby
    When I view head-to-head contests
    Then I should see 1v1 matchups
    And opponent matching should be explained

  @happy-path @contest-types
  Scenario: View large field contests
    Given I am in the contest lobby
    When I view GPP contests
    Then I should see large tournament contests
    And prize distribution should be shown

  @happy-path @contest-types
  Scenario: View 50/50 contests
    Given I am in the contest lobby
    When I view 50/50 contests
    Then I should see double-up contests
    And winning criteria should be clear

  # ============================================================================
  # CONTEST ENTRY
  # ============================================================================

  @happy-path @contest-entry
  Scenario: Join a contest
    Given I find a contest I want to join
    When I join the contest
    Then I should be entered into the contest
    And my entry should be confirmed

  @happy-path @contest-entry
  Scenario: Pay entry fee
    Given I am joining a paid contest
    When I pay the entry fee
    Then payment should be processed
    And I should be entered

  @happy-path @contest-entry
  Scenario: Enter multiple times
    Given multi-entry is allowed
    When I enter multiple times
    Then I should have multiple entries
    And each entry should be tracked

  @happy-path @contest-entry
  Scenario: View entry limits
    Given a contest has entry limits
    Then I should see my entry count
    And I should see maximum entries allowed

  @happy-path @contest-entry
  Scenario: Use bulk entry
    Given I want to enter many contests
    When I use bulk entry
    Then I should enter multiple contests
    And entries should be processed efficiently

  @happy-path @contest-entry
  Scenario: Withdraw from contest
    Given I entered a contest
    When I withdraw before lock
    Then my entry should be cancelled
    And my fee should be refunded

  @error @contest-entry
  Scenario: Attempt to exceed entry limit
    Given I reached the entry limit
    When I try to enter again
    Then I should see an error message
    And entry should be blocked

  @error @contest-entry
  Scenario: Handle insufficient funds
    Given I don't have enough funds
    When I try to join a paid contest
    Then I should see insufficient funds error
    And I should be prompted to add funds

  # ============================================================================
  # CONTEST LOBBY
  # ============================================================================

  @happy-path @contest-lobby
  Scenario: Browse contests
    Given I am in the contest lobby
    Then I should see available contests
    And contests should be organized

  @happy-path @contest-lobby
  Scenario: Filter contests
    Given I am browsing contests
    When I apply filters
    Then I should see filtered contests
    And filters should be clearable

  @happy-path @contest-lobby
  Scenario: Search contests
    Given I want a specific contest
    When I search for contests
    Then I should see matching contests
    And search should be fast

  @happy-path @contest-lobby
  Scenario: View featured contests
    Given I am in the lobby
    Then I should see featured contests
    And featured should be prominent

  @happy-path @contest-lobby
  Scenario: Quick join contest
    Given I see a contest I like
    When I use quick join
    Then I should join with one click
    And entry should be confirmed

  @happy-path @contest-lobby
  Scenario: Sort contests
    Given I am browsing contests
    When I change sort order
    Then contests should reorder
    And sort should persist

  @happy-path @contest-lobby
  Scenario: View contest details from lobby
    Given I see a contest in the lobby
    When I click for details
    Then I should see full contest info
    And I can join from details

  @mobile @contest-lobby
  Scenario: Browse lobby on mobile
    Given I am on a mobile device
    When I browse the lobby
    Then lobby should be mobile-friendly
    And filtering should work

  # ============================================================================
  # CONTEST RULES
  # ============================================================================

  @happy-path @contest-rules
  Scenario: View scoring rules
    Given I am viewing a contest
    When I check scoring rules
    Then I should see scoring system
    And point values should be clear

  @happy-path @contest-rules
  Scenario: View roster requirements
    Given I am viewing a contest
    When I check roster requirements
    Then I should see position requirements
    And roster slots should be clear

  @happy-path @contest-rules
  Scenario: View salary cap
    Given the contest has a salary cap
    Then I should see the cap amount
    And player salaries should be visible

  @happy-path @contest-rules
  Scenario: View contest format
    Given I am viewing a contest
    Then I should see contest format
    And format should be explained

  @happy-path @contest-rules
  Scenario: View tie-breaker rules
    Given I am viewing a contest
    When I check tie-breaker rules
    Then I should see how ties are resolved
    And rules should be fair

  @happy-path @contest-rules
  Scenario: Compare contest rules
    Given I am considering multiple contests
    When I compare rules
    Then I should see differences
    And comparison should be clear

  # ============================================================================
  # CONTEST PRIZES
  # ============================================================================

  @happy-path @contest-prizes
  Scenario: View prize pool
    Given I am viewing a contest
    Then I should see total prize pool
    And pool should be accurate

  @happy-path @contest-prizes
  Scenario: View prize distribution
    Given I am viewing a contest
    When I check prize payout
    Then I should see payout structure
    And each place's prize should be shown

  @happy-path @contest-prizes
  Scenario: View guaranteed prizes
    Given the contest is guaranteed
    Then I should see guaranteed badge
    And guarantee amount should be shown

  @happy-path @contest-prizes
  Scenario: Understand overlay protection
    Given the contest has overlay
    Then I should understand my advantage
    And overlay should be explained

  @happy-path @contest-prizes
  Scenario: View bonus prizes
    Given the contest has bonus prizes
    Then I should see bonus opportunities
    And bonus criteria should be clear

  @happy-path @contest-prizes
  Scenario: Calculate potential winnings
    Given I am considering entry
    When I view payout projections
    Then I should see potential winnings
    And calculations should be accurate

  # ============================================================================
  # CONTEST RESULTS
  # ============================================================================

  @happy-path @contest-results
  Scenario: View live standings
    Given my contest is in progress
    When I view standings
    Then I should see live rankings
    And standings should update

  @happy-path @contest-results
  Scenario: View final results
    Given my contest has completed
    When I view results
    Then I should see final standings
    And my position should be highlighted

  @happy-path @contest-results
  Scenario: View prize payouts
    Given I won a prize
    Then I should see my payout
    And payout should be credited

  @happy-path @contest-results
  Scenario: View result history
    Given I have contest history
    When I view past results
    Then I should see historical results
    And I can review any contest

  @happy-path @contest-results
  Scenario: View leaderboards
    Given contests are in progress
    When I view leaderboards
    Then I should see top performers
    And I can see my position

  @happy-path @contest-results
  Scenario: Compare to winning lineup
    Given a contest has ended
    When I compare my lineup
    Then I should see winning lineup
    And I can learn from it

  @happy-path @contest-results
  Scenario: Export results
    Given I want to save results
    When I export results
    Then I should receive export file
    And data should be complete

  # ============================================================================
  # CONTEST LINEUP
  # ============================================================================

  @happy-path @contest-lineup
  Scenario: Create lineup
    Given I am entering a contest
    When I create my lineup
    Then I should select players
    And lineup should meet requirements

  @happy-path @contest-lineup
  Scenario: Edit lineup before lock
    Given I submitted a lineup
    When I edit before lock
    Then my changes should be saved
    And new lineup should be valid

  @happy-path @contest-lineup
  Scenario: Use late swap
    Given late swap is enabled
    When I swap a player after lock
    Then I should be able to swap unlocked players
    And swap should be saved

  @happy-path @contest-lineup
  Scenario: Validate lineup
    Given I am building a lineup
    Then lineup should be validated
    And errors should be shown

  @happy-path @contest-lineup
  Scenario: Use lineup template
    Given I have saved templates
    When I apply a template
    Then players should be populated
    And I can adjust as needed

  @happy-path @contest-lineup
  Scenario: Save lineup as template
    Given I built a good lineup
    When I save as template
    Then template should be saved
    And I can reuse it

  @happy-path @contest-lineup
  Scenario: Check salary remaining
    Given I am building a lineup
    Then I should see salary remaining
    And I should stay under cap

  @error @contest-lineup
  Scenario: Submit invalid lineup
    Given my lineup is invalid
    When I try to submit
    Then I should see validation errors
    And submission should be blocked

  # ============================================================================
  # CONTEST NOTIFICATIONS
  # ============================================================================

  @happy-path @contest-notifications
  Scenario: Receive contest reminders
    Given I entered a contest
    When lineup lock approaches
    Then I should receive a reminder
    And I can take action

  @happy-path @contest-notifications
  Scenario: Receive lineup lock alerts
    Given my lineup is not set
    When lock is imminent
    Then I should receive urgent alert
    And I should set my lineup

  @happy-path @contest-notifications
  Scenario: Receive results notifications
    Given my contest has ended
    Then I should receive results notification
    And I should see my finish

  @happy-path @contest-notifications
  Scenario: Receive prize alerts
    Given I won a prize
    Then I should receive prize alert
    And I should see payout amount

  @happy-path @contest-notifications
  Scenario: Configure contest notifications
    Given I am in notification settings
    When I configure contest alerts
    Then I should choose what to receive
    And preferences should be saved

  @happy-path @contest-notifications
  Scenario: Receive live scoring updates
    Given my contest is in progress
    Then I should receive score updates
    And I can follow my lineup

  # ============================================================================
  # CONTEST HISTORY
  # ============================================================================

  @happy-path @contest-history
  Scenario: View past contests
    Given I have participated in contests
    When I view my history
    Then I should see past contests
    And history should be complete

  @happy-path @contest-history
  Scenario: View performance history
    Given I have contest history
    When I analyze performance
    Then I should see performance stats
    And trends should be visible

  @happy-path @contest-history
  Scenario: View contest statistics
    Given I have contest history
    Then I should see overall stats
    And stats should be accurate

  @happy-path @contest-history
  Scenario: Track ROI
    Given I have paid entry history
    When I view ROI
    Then I should see return on investment
    And calculation should be clear

  @happy-path @contest-history
  Scenario: View win/loss records
    Given I have contest history
    Then I should see win/loss record
    And record should be by contest type

  @happy-path @contest-history
  Scenario: Filter history by type
    Given I have diverse contest history
    When I filter by type
    Then I should see specific history
    And filter should work

  @happy-path @contest-history
  Scenario: Export history
    Given I want to save my history
    When I export history
    Then I should receive export file
    And data should be comprehensive

  # ============================================================================
  # CONTEST SOCIAL
  # ============================================================================

  @happy-path @contest-social
  Scenario: Create private contest
    Given I want a private competition
    When I create a private contest
    Then the contest should be created
    And I should receive invite link

  @happy-path @contest-social
  Scenario: Create friend contest
    Given I want to compete with friends
    When I create a friend contest
    Then I should invite friends
    And they should be able to join

  @happy-path @contest-social
  Scenario: Create contest league
    Given I want recurring competition
    When I create a contest league
    Then the league should be created
    And members can join

  @happy-path @contest-social
  Scenario: Invite friends to contest
    Given I am in a contest
    When I invite friends
    Then invitations should be sent
    And friends should be notified

  @happy-path @contest-social
  Scenario: Share contest
    Given I want to share a contest
    When I share the contest
    Then shareable link should be created
    And others can view and join

  @happy-path @contest-social
  Scenario: View friends in contest
    Given friends are in my contest
    Then I should see their entries
    And I can compare lineups

  @happy-path @contest-social
  Scenario: Chat in private contest
    Given I am in a private contest
    When I use contest chat
    Then I should communicate with others
    And chat should be real-time
