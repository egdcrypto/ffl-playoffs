@polls @anima-1405
Feature: Polls
  As a fantasy football user
  I want comprehensive polling capabilities
  So that I can gather league member opinions and make collective decisions

  Background:
    Given I am a logged-in user
    And the polling system is available

  # ============================================================================
  # POLL CREATION
  # ============================================================================

  @happy-path @poll-creation
  Scenario: Create poll
    Given I want to create poll
    When I create poll
    Then poll should be created
    And members can vote

  @happy-path @poll-creation
  Scenario: Add poll questions
    Given I am creating poll
    When I add question
    Then question should be added
    And I can add more questions

  @happy-path @poll-creation
  Scenario: Add poll options
    Given question exists
    When I add options
    Then options should be added
    And voters can select them

  @happy-path @poll-creation
  Scenario: Configure poll settings
    Given I am creating poll
    When I configure settings
    Then settings should be saved
    And poll should follow them

  @happy-path @poll-creation
  Scenario: Create multiple choice poll
    Given I want multiple options
    When I create multiple choice
    Then voters can select multiple
    And selections should be counted

  @happy-path @poll-creation
  Scenario: Set poll deadline
    Given poll is being created
    When I set deadline
    Then deadline should be saved
    And poll should close at deadline

  @happy-path @poll-creation
  Scenario: Add poll description
    Given I am creating poll
    When I add description
    Then description should be saved
    And voters should see it

  @happy-path @poll-creation
  Scenario: Preview poll
    Given poll is configured
    When I preview poll
    Then I should see how it looks
    And I can make changes

  @happy-path @poll-creation
  Scenario: Save poll as draft
    Given poll is not ready
    When I save as draft
    Then draft should be saved
    And I can continue later

  @happy-path @poll-creation
  Scenario: Publish poll
    Given poll is ready
    When I publish poll
    Then poll should be live
    And members should be notified

  # ============================================================================
  # POLL VOTING
  # ============================================================================

  @happy-path @poll-voting
  Scenario: Cast vote
    Given poll is active
    When I cast vote
    Then vote should be recorded
    And I should see confirmation

  @happy-path @poll-voting
  Scenario: View options
    Given poll exists
    When I view options
    Then I should see all options
    And I can make selection

  @happy-path @poll-voting
  Scenario: Submit vote
    Given I selected option
    When I submit vote
    Then vote should be submitted
    And it should be counted

  @happy-path @poll-voting
  Scenario: Receive vote confirmation
    Given I voted
    When vote is recorded
    Then I should receive confirmation
    And my choice should be shown

  @happy-path @poll-voting
  Scenario: Change vote
    Given I already voted
    When I change vote
    Then vote should be updated
    And new choice should be recorded

  @happy-path @poll-voting
  Scenario: View my vote
    Given I have voted
    When I view poll
    Then I should see my vote
    And it should be highlighted

  @happy-path @poll-voting
  Scenario: Vote anonymously
    Given anonymous voting is enabled
    When I vote
    Then my identity should be hidden
    And vote should be counted

  @happy-path @poll-voting
  Scenario: Skip voting
    Given poll allows skipping
    When I skip poll
    Then I should not be counted
    And I can vote later

  @error @poll-voting
  Scenario: Handle expired poll
    Given poll has expired
    When I try to vote
    Then I should see error
    And expiration should be explained

  @happy-path @poll-voting
  Scenario: Vote on mobile
    Given I am on mobile
    When I vote
    Then voting should work
    And interface should be mobile-friendly

  # ============================================================================
  # POLL RESULTS
  # ============================================================================

  @happy-path @poll-results
  Scenario: View results
    Given poll has votes
    When I view results
    Then I should see results
    And they should be accurate

  @happy-path @poll-results
  Scenario: View results breakdown
    Given results exist
    When I view breakdown
    Then I should see detailed breakdown
    And each option should be shown

  @happy-path @poll-results
  Scenario: View vote count
    Given votes have been cast
    When I view count
    Then I should see vote counts
    And totals should be accurate

  @happy-path @poll-results
  Scenario: View percentage display
    Given results exist
    When I view percentages
    Then I should see percentages
    And they should be calculated correctly

  @happy-path @poll-results
  Scenario: View winner display
    Given poll has ended
    When I view winner
    Then winner should be displayed
    And it should be clear

  @happy-path @poll-results
  Scenario: View live results
    Given poll is active
    When votes are cast
    Then results should update live
    And I can see progress

  @happy-path @poll-results
  Scenario: View results chart
    Given results exist
    When I view chart
    Then chart should display results
    And it should be visual

  @happy-path @poll-results
  Scenario: Export results
    Given results exist
    When I export results
    Then export file should be created
    And data should be complete

  @happy-path @poll-results
  Scenario: Share results
    Given results exist
    When I share results
    Then shareable link should be created
    And others can view

  @happy-path @poll-results
  Scenario: View voter list
    Given voting is not anonymous
    When I view voters
    Then I should see who voted
    And their choices should be shown

  # ============================================================================
  # POLL TYPES
  # ============================================================================

  @happy-path @poll-types
  Scenario: Create single choice poll
    Given I want single selection
    When I create single choice
    Then voters can select one
    And only one should count

  @happy-path @poll-types
  Scenario: Create multiple choice poll
    Given I want multiple selections
    When I create multiple choice
    Then voters can select multiple
    And all should count

  @happy-path @poll-types
  Scenario: Create ranked choice poll
    Given I want ranking
    When I create ranked choice
    Then voters can rank options
    And ranking should be calculated

  @happy-path @poll-types
  Scenario: Create yes/no poll
    Given I want simple answer
    When I create yes/no poll
    Then options should be yes and no
    And voting should be simple

  @happy-path @poll-types
  Scenario: Create open-ended poll
    Given I want text responses
    When I create open-ended
    Then voters can type responses
    And responses should be collected

  @happy-path @poll-types
  Scenario: Create rating poll
    Given I want ratings
    When I create rating poll
    Then voters can rate
    And average should be calculated

  @happy-path @poll-types
  Scenario: Create prediction poll
    Given I want predictions
    When I create prediction poll
    Then voters can predict
    And predictions should be tracked

  @happy-path @poll-types
  Scenario: Create tiebreaker poll
    Given tie needs breaking
    When I create tiebreaker
    Then finalists should be options
    And winner should be determined

  @happy-path @poll-types
  Scenario: Create survey poll
    Given I want multiple questions
    When I create survey
    Then I can add multiple questions
    And responses should be collected

  @happy-path @poll-types
  Scenario: Create quick poll
    Given I need fast decision
    When I create quick poll
    Then poll should be simple
    And voting should be fast

  # ============================================================================
  # POLL TARGETING
  # ============================================================================

  @happy-path @poll-targeting
  Scenario: Create league poll
    Given I want league-wide poll
    When I create league poll
    Then all league members can vote
    And it should be visible to all

  @happy-path @poll-targeting
  Scenario: Create team poll
    Given I want team-only poll
    When I create team poll
    Then only team can vote
    And it should be private to team

  @commissioner @poll-targeting
  Scenario: Create commissioner poll
    Given I am commissioner
    When I create commissioner poll
    Then poll should be official
    And results should be binding

  @happy-path @poll-targeting
  Scenario: Create public poll
    Given I want public poll
    When I create public poll
    Then anyone can vote
    And results should be public

  @happy-path @poll-targeting
  Scenario: Create private poll
    Given I want private poll
    When I create private poll
    Then only selected can vote
    And results should be private

  @happy-path @poll-targeting
  Scenario: Target specific members
    Given I want specific voters
    When I target members
    Then only they can vote
    And others cannot see poll

  @happy-path @poll-targeting
  Scenario: Exclude members from poll
    Given I want to exclude some
    When I exclude members
    Then they cannot vote
    And poll should be hidden from them

  @happy-path @poll-targeting
  Scenario: Create division poll
    Given division exists
    When I create division poll
    Then only division can vote
    And it should be division-specific

  @happy-path @poll-targeting
  Scenario: Create playoff team poll
    Given playoff teams exist
    When I create playoff poll
    Then only playoff teams can vote
    And it should be playoff-specific

  @happy-path @poll-targeting
  Scenario: View poll audience
    Given poll has targeting
    When I view audience
    Then I should see who can vote
    And count should be shown

  # ============================================================================
  # POLL NOTIFICATIONS
  # ============================================================================

  @happy-path @poll-notifications
  Scenario: Receive poll alert
    Given alerts are enabled
    When new poll is created
    Then I should receive alert
    And I can open poll

  @happy-path @poll-notifications
  Scenario: Receive new poll notification
    Given notifications are enabled
    When poll is published
    Then I should be notified
    And poll details should be shown

  @happy-path @poll-notifications
  Scenario: Receive voting reminder
    Given I haven't voted
    When deadline approaches
    Then I should receive reminder
    And I can vote quickly

  @happy-path @poll-notifications
  Scenario: Receive results notification
    Given poll has ended
    When results are available
    Then I should be notified
    And I can view results

  @happy-path @poll-notifications
  Scenario: Receive deadline alert
    Given deadline is near
    When threshold is reached
    Then I should be alerted
    And time remaining should be shown

  @happy-path @poll-notifications
  Scenario: Configure poll notifications
    Given preferences exist
    When I configure notifications
    Then preferences should be saved
    And notifications should follow them

  @happy-path @poll-notifications
  Scenario: Disable poll notifications
    Given I receive too many
    When I disable notifications
    Then notifications should stop
    And I can re-enable later

  @happy-path @poll-notifications
  Scenario: Receive vote confirmation
    Given I voted
    When vote is recorded
    Then I should receive confirmation
    And my choice should be shown

  @happy-path @poll-notifications
  Scenario: Notify poll creator
    Given I created poll
    When votes come in
    Then I should be notified
    And progress should be shown

  @happy-path @poll-notifications
  Scenario: Receive tie notification
    Given poll has tie
    When tie is detected
    Then creator should be notified
    And tiebreaker should be suggested

  # ============================================================================
  # POLL MANAGEMENT
  # ============================================================================

  @happy-path @poll-management
  Scenario: Edit poll
    Given I created poll
    When I edit poll
    Then changes should be saved
    And voters should be notified

  @happy-path @poll-management
  Scenario: Delete poll
    Given I created poll
    When I delete poll
    Then poll should be removed
    And I should confirm first

  @happy-path @poll-management
  Scenario: Close poll
    Given poll is active
    When I close poll
    Then poll should close
    And no more votes should be accepted

  @happy-path @poll-management
  Scenario: Extend deadline
    Given deadline is near
    When I extend deadline
    Then new deadline should be saved
    And voters should be notified

  @happy-path @poll-management
  Scenario: Reopen poll
    Given poll was closed
    When I reopen poll
    Then poll should be active again
    And voters can vote again

  @happy-path @poll-management
  Scenario: Duplicate poll
    Given poll exists
    When I duplicate poll
    Then copy should be created
    And I can modify it

  @happy-path @poll-management
  Scenario: Add option to poll
    Given poll is active
    When I add option
    Then option should be added
    And voters can select it

  @happy-path @poll-management
  Scenario: Remove option from poll
    Given option exists
    When I remove option
    Then option should be removed
    And votes should be handled

  @happy-path @poll-management
  Scenario: Pin poll
    Given poll is important
    When I pin poll
    Then poll should be pinned
    And it should appear at top

  @commissioner @poll-management
  Scenario: Override poll result
    Given I am commissioner
    When I override result
    Then result should be changed
    And reason should be logged

  # ============================================================================
  # POLL ANALYTICS
  # ============================================================================

  @happy-path @poll-analytics
  Scenario: View poll statistics
    Given poll has votes
    When I view statistics
    Then I should see stats
    And they should be comprehensive

  @happy-path @poll-analytics
  Scenario: View participation rate
    Given poll exists
    When I view participation
    Then I should see participation rate
    And percentage should be shown

  @happy-path @poll-analytics
  Scenario: View vote distribution
    Given votes exist
    When I view distribution
    Then I should see how votes distributed
    And patterns should be visible

  @happy-path @poll-analytics
  Scenario: View trend analysis
    Given multiple polls exist
    When I view trends
    Then I should see voting trends
    And insights should be provided

  @happy-path @poll-analytics
  Scenario: View engagement metrics
    Given polls have been created
    When I view engagement
    Then I should see engagement metrics
    And activity should be tracked

  @happy-path @poll-analytics
  Scenario: Compare poll results
    Given multiple polls exist
    When I compare results
    Then I should see comparison
    And differences should be highlighted

  @happy-path @poll-analytics
  Scenario: View voter demographics
    Given voters have voted
    When I view demographics
    Then I should see voter breakdown
    And patterns should be visible

  @happy-path @poll-analytics
  Scenario: Track voting speed
    Given votes are coming in
    When I track speed
    Then I should see voting rate
    And pace should be shown

  @happy-path @poll-analytics
  Scenario: Export analytics
    Given analytics exist
    When I export analytics
    Then export file should be created
    And data should be complete

  @happy-path @poll-analytics
  Scenario: View analytics dashboard
    Given I want overview
    When I view dashboard
    Then I should see poll dashboard
    And key metrics should be shown

  # ============================================================================
  # POLL HISTORY
  # ============================================================================

  @happy-path @poll-history
  Scenario: View past polls
    Given polls have been created
    When I view past polls
    Then I should see past polls
    And results should be shown

  @happy-path @poll-history
  Scenario: View poll archive
    Given archive exists
    When I view archive
    Then I should see archived polls
    And I can browse them

  @happy-path @poll-history
  Scenario: View historical results
    Given past results exist
    When I view historical
    Then I should see past results
    And trends should be visible

  @happy-path @poll-history
  Scenario: View poll timeline
    Given timeline exists
    When I view timeline
    Then I should see poll history
    And chronology should be clear

  @happy-path @poll-history
  Scenario: View recurring polls
    Given recurring polls exist
    When I view recurring
    Then I should see recurring polls
    And schedule should be shown

  @happy-path @poll-history
  Scenario: Search poll history
    Given history is extensive
    When I search history
    Then I should find matches
    And results should be relevant

  @happy-path @poll-history
  Scenario: Filter poll history
    Given filters exist
    When I filter history
    Then I should see filtered results
    And only matching should show

  @happy-path @poll-history
  Scenario: Export poll history
    Given history exists
    When I export history
    Then export file should be created
    And data should be complete

  @happy-path @poll-history
  Scenario: View my voting history
    Given I have voted
    When I view my history
    Then I should see my votes
    And choices should be shown

  @happy-path @poll-history
  Scenario: Archive poll
    Given poll is old
    When I archive poll
    Then poll should be archived
    And it should be preserved

  # ============================================================================
  # POLL TEMPLATES
  # ============================================================================

  @happy-path @poll-templates
  Scenario: Use saved template
    Given templates exist
    When I use template
    Then poll should be pre-filled
    And I can customize it

  @happy-path @poll-templates
  Scenario: Create quick poll
    Given I need fast poll
    When I create quick poll
    Then poll should be simple
    And creation should be fast

  @happy-path @poll-templates
  Scenario: Use poll presets
    Given presets exist
    When I use preset
    Then settings should be applied
    And I can modify if needed

  @happy-path @poll-templates
  Scenario: Use common questions
    Given common questions exist
    When I use common question
    Then question should be inserted
    And options should be included

  @happy-path @poll-templates
  Scenario: View template library
    Given library exists
    When I view library
    Then I should see all templates
    And I can browse them

  @happy-path @poll-templates
  Scenario: Create new template
    Given I have useful poll
    When I save as template
    Then template should be saved
    And I can reuse it

  @happy-path @poll-templates
  Scenario: Edit template
    Given template exists
    When I edit template
    Then changes should be saved
    And template should update

  @happy-path @poll-templates
  Scenario: Delete template
    Given template exists
    When I delete template
    Then template should be removed
    And I should confirm first

  @happy-path @poll-templates
  Scenario: Share template
    Given template exists
    When I share template
    Then template should be shared
    And others can use it

  @happy-path @poll-templates
  Scenario: Import template
    Given template is shared
    When I import template
    Then template should be added
    And I can use it

