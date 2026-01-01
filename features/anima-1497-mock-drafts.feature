@mock-drafts
Feature: Mock Drafts
  As a fantasy football manager
  I want to practice drafting in mock drafts
  So that I can prepare for my real draft and test strategies

  # --------------------------------------------------------------------------
  # Mock Draft Lobby
  # --------------------------------------------------------------------------

  @mock-draft-lobby
  Scenario: Create a mock draft lobby
    Given I want to practice drafting
    When I create a new mock draft lobby
    Then a lobby should be created
    And I should be the lobby host
    And I should see lobby settings options

  @mock-draft-lobby
  Scenario: Configure lobby settings
    Given I am creating a mock draft lobby
    When I configure lobby settings
    Then I should set number of teams
    And I should set draft format
    And I should set roster positions
    And settings should be saved

  @mock-draft-lobby
  Scenario: Select draft type
    Given I am configuring a mock draft
    When I select draft type
    Then I should choose snake draft
    Or I should choose auction draft
    Or I should choose linear draft
    And draft type should be set

  @mock-draft-lobby
  Scenario: Configure roster positions
    Given I am setting up a mock draft
    When I configure roster positions
    Then I should set QB slots
    And I should set RB slots
    And I should set WR slots
    And I should set flex positions
    And I should set bench size

  @mock-draft-lobby
  Scenario: Set scoring settings
    Given I am configuring a mock draft
    When I set scoring settings
    Then I should choose PPR or standard
    And I should set passing scoring
    And I should set rushing scoring
    And I should set receiving scoring

  @mock-draft-lobby
  Scenario: Configure draft speed settings
    Given I am setting up a mock draft
    When I configure draft speed
    Then I should set pick time limit
    And I should choose fast, normal, or slow
    And I should set auto-pick delay
    And speed should be applied

  @mock-draft-lobby
  Scenario: Send lobby invitations
    Given I have created a mock draft lobby
    When I invite other users
    Then I should send invite links
    And I should invite by username
    And invitees should receive notifications
    And I should track pending invites

  @mock-draft-lobby
  Scenario: Create public vs private lobby
    Given I am creating a mock draft
    When I set lobby visibility
    Then I should make it public for anyone
    Or I should make it private invite-only
    And visibility should be enforced

  @mock-draft-lobby
  Scenario: Search for public lobbies
    Given I want to join a mock draft
    When I search for lobbies
    Then I should see available public lobbies
    And I should filter by draft type
    And I should filter by settings
    And I should join available lobbies

  @mock-draft-lobby
  Scenario: Wait in lobby waiting room
    Given I have joined a mock draft lobby
    When I am in the waiting room
    Then I should see other participants
    And I should see countdown to start
    And I should chat with others
    And I should see when lobby is full

  # --------------------------------------------------------------------------
  # AI Opponents
  # --------------------------------------------------------------------------

  @ai-opponents
  Scenario: Select AI difficulty level
    Given I am setting up a mock draft
    When I add AI opponents
    Then I should choose easy difficulty
    Or I should choose medium difficulty
    Or I should choose hard difficulty
    And AI should draft accordingly

  @ai-opponents
  Scenario: Configure AI draft strategies
    Given I am customizing AI opponents
    When I set AI strategies
    Then I should assign different strategies
    And I should set aggressive AI
    And I should set conservative AI
    And strategies should vary among AI

  @ai-opponents
  Scenario: Customize AI behavior
    Given I want specific AI behavior
    When I customize AI settings
    Then I should set AI tendencies
    And I should set position preferences
    And I should set risk tolerance
    And behavior should be applied

  @ai-opponents
  Scenario: Set AI player preferences
    Given I am configuring AI
    When I set player preferences
    Then AI should have favorite players
    And AI should have players to avoid
    And preferences should influence picks

  @ai-opponents
  Scenario: Configure AI position priorities
    Given I am setting AI strategy
    When I set position priorities
    Then I should set RB priority
    And I should set WR priority
    And I should set QB priority
    And AI should follow priorities

  @ai-opponents
  Scenario: Enable AI value-based drafting
    Given I want realistic AI
    When I enable value-based drafting
    Then AI should consider player value
    And AI should identify value picks
    And AI should avoid reaches
    And drafting should be strategic

  @ai-opponents
  Scenario: Configure AI reach picks
    Given I want varied AI behavior
    When I configure reach settings
    Then AI should sometimes reach for players
    And reach frequency should be configurable
    And reaches should be realistic

  @ai-opponents
  Scenario: Set AI sleeper picks
    Given I want AI to draft sleepers
    When I configure sleeper settings
    Then AI should identify sleepers
    And AI should draft sleepers appropriately
    And sleeper frequency should be set

  @ai-opponents
  Scenario: Configure AI team building logic
    Given I want smart AI opponents
    When I set team building logic
    Then AI should balance roster
    And AI should address needs
    And AI should build complete teams

  @ai-opponents
  Scenario: Set AI response timing
    Given I want realistic draft pace
    When I set AI timing
    Then AI should vary pick times
    And AI should not pick instantly
    And timing should feel natural

  # --------------------------------------------------------------------------
  # Draft Simulation
  # --------------------------------------------------------------------------

  @draft-simulation
  Scenario: Manage draft clock
    Given a mock draft is in progress
    When it is someone's turn to pick
    Then draft clock should count down
    And clock should be visible
    And warnings should appear when low

  @draft-simulation
  Scenario: Enable pick automation
    Given I am in a mock draft
    When I enable auto-pick
    Then picks should be made automatically
    And auto-pick should use my rankings
    And I should be notified of auto-picks

  @draft-simulation
  Scenario: Pause the draft
    Given I am hosting a mock draft
    When I pause the draft
    Then the draft should pause
    And all participants should be notified
    And I should be able to resume

  @draft-simulation
  Scenario: Control draft speed
    Given I am in a mock draft
    When I adjust speed controls
    Then I should speed up the draft
    Or I should slow down the draft
    And pace should change accordingly

  @draft-simulation
  Scenario: View draft order display
    Given a mock draft is in progress
    When I view draft order
    Then I should see all pick positions
    And I should see team assignments
    And I should see snake order if applicable

  @draft-simulation
  Scenario: Track current pick
    Given the mock draft is ongoing
    When I view current pick status
    Then I should see who is picking
    And I should see pick number
    And I should see time remaining

  @draft-simulation
  Scenario: Preview upcoming picks
    Given I am in a mock draft
    When I view upcoming picks
    Then I should see next several picks
    And I should see when my next pick is
    And I should plan accordingly

  @draft-simulation
  Scenario: View draft progress indicators
    Given a mock draft is in progress
    When I view progress
    Then I should see current round
    And I should see picks remaining
    And I should see completion percentage

  @draft-simulation
  Scenario: Handle draft completion
    Given all picks have been made
    When the draft completes
    Then I should see completion notification
    And I should see my final roster
    And I should access results

  @draft-simulation
  Scenario: Restart simulation
    Given a mock draft has ended
    When I restart the simulation
    Then a new draft should begin
    And settings should be preserved
    And I should draft again

  # --------------------------------------------------------------------------
  # Draft Strategy Testing
  # --------------------------------------------------------------------------

  @draft-strategy
  Scenario: Use strategy presets
    Given I want to test a strategy
    When I select a strategy preset
    Then I should choose from common strategies
    And strategy should guide my picks
    And I should see strategy recommendations

  @draft-strategy
  Scenario: Create custom strategy
    Given I have a unique strategy
    When I create a custom strategy
    Then I should define position priorities
    And I should set round targets
    And I should save my strategy

  @draft-strategy
  Scenario: Compare strategies
    Given I have tested multiple strategies
    When I compare strategies
    Then I should see side-by-side comparison
    And I should see win probability
    And I should identify best approach

  @draft-strategy
  Scenario: Test positional strategy
    Given I want to test position timing
    When I test positional strategy
    Then I should track when I draft positions
    And I should see positional outcomes
    And I should refine my approach

  @draft-strategy
  Scenario: Test value-based drafting
    Given I want to maximize value
    When I test VBD strategy
    Then I should see value at each pick
    And I should track value extracted
    And I should optimize selections

  @draft-strategy
  Scenario: Test Zero-RB strategy
    Given I want to try Zero-RB
    When I test Zero-RB approach
    Then I should avoid early RBs
    And I should load up on WRs
    And I should see strategy results

  @draft-strategy
  Scenario: Test Robust-RB strategy
    Given I want to try Robust-RB
    When I test Robust-RB approach
    Then I should draft multiple early RBs
    And I should build RB depth
    And I should see strategy results

  @draft-strategy
  Scenario: Test Hero-RB strategy
    Given I want to try Hero-RB
    When I test Hero-RB approach
    Then I should draft one elite RB
    And I should focus on other positions
    And I should see strategy results

  @draft-strategy
  Scenario: Test late-round QB strategy
    Given I want to try late-round QB
    When I test late QB approach
    Then I should wait on QB
    And I should prioritize other positions early
    And I should see strategy effectiveness

  @draft-strategy
  Scenario: View strategy analytics
    Given I have tested strategies
    When I view strategy analytics
    Then I should see performance data
    And I should see success rates
    And I should get recommendations

  # --------------------------------------------------------------------------
  # Mock Draft Results
  # --------------------------------------------------------------------------

  @mock-draft-results
  Scenario: View results summary
    Given a mock draft has completed
    When I view results summary
    Then I should see my full roster
    And I should see all teams' rosters
    And I should see draft recap

  @mock-draft-results
  Scenario: See team grades
    Given mock draft results are available
    When I view team grades
    Then I should see overall grade
    And I should see grade explanation
    And I should compare to other teams

  @mock-draft-results
  Scenario: View positional grades
    Given I am reviewing my draft
    When I view positional grades
    Then I should see QB grade
    And I should see RB grade
    And I should see WR grade
    And I should see all position grades

  @mock-draft-results
  Scenario: Analyze draft value
    Given I want to assess my draft
    When I view value analysis
    Then I should see value at each pick
    And I should see total value extracted
    And I should see value vs ADP

  @mock-draft-results
  Scenario: Identify reach picks
    Given I am reviewing picks
    When I view reach analysis
    Then I should see picks above ADP
    And I should see reach severity
    And I should understand impact

  @mock-draft-results
  Scenario: Identify steal picks
    Given I want to see good picks
    When I view steal identification
    Then I should see picks below ADP
    And I should see value gained
    And I should see best steals

  @mock-draft-results
  Scenario: Assess roster balance
    Given I want to evaluate my roster
    When I view roster balance
    Then I should see position distribution
    And I should see strengths
    And I should see weaknesses

  @mock-draft-results
  Scenario: Preview strength of schedule
    Given I have a drafted roster
    When I view schedule preview
    Then I should see upcoming matchups
    And I should see favorable weeks
    And I should see tough stretches

  @mock-draft-results
  Scenario: View projected points
    Given my mock draft is complete
    When I view projections
    Then I should see weekly projections
    And I should see season total
    And I should see playoff projections

  @mock-draft-results
  Scenario: Share draft results
    Given I want to share my mock draft
    When I share results
    Then I should generate shareable link
    And I should share to social media
    And others should view my results

  # --------------------------------------------------------------------------
  # Draft History
  # --------------------------------------------------------------------------

  @draft-history
  Scenario: View draft log
    Given I have completed mock drafts
    When I view the draft log
    Then I should see all my mock drafts
    And I should see dates and settings
    And I should access any past draft

  @draft-history
  Scenario: Review picks pick-by-pick
    Given I am reviewing a past draft
    When I view pick-by-pick review
    Then I should see each pick in order
    And I should see pick reasoning
    And I should see alternatives available

  @draft-history
  Scenario: Replay draft
    Given I want to revisit a draft
    When I replay the draft
    Then I should see draft unfold
    And I should control replay speed
    And I should pause at any point

  @draft-history
  Scenario: Access historical mock drafts
    Given I have draft history
    When I access historical drafts
    Then I should see all past drafts
    And I should filter by date range
    And I should search by settings

  @draft-history
  Scenario: Compare drafts
    Given I have multiple mock drafts
    When I compare drafts
    Then I should see side-by-side comparison
    And I should see different picks made
    And I should see outcome differences

  @draft-history
  Scenario: Track improvement over time
    Given I have been practicing
    When I view improvement tracking
    Then I should see grade trends
    And I should see value trends
    And I should see progress over time

  @draft-history
  Scenario: Analyze draft tendencies
    Given I have draft history
    When I view tendencies analysis
    Then I should see my draft patterns
    And I should see position preferences
    And I should see common picks

  @draft-history
  Scenario: Track favorite picks
    Given I often draft certain players
    When I view favorite picks
    Then I should see most drafted players
    And I should see pick frequency
    And I should see round preferences

  @draft-history
  Scenario: View draft statistics
    Given I have extensive draft history
    When I view draft statistics
    Then I should see aggregate stats
    And I should see averages
    And I should see trends

  @draft-history
  Scenario: Export draft history
    Given I want to save my history
    When I export draft history
    Then I should choose export format
    And I should download history
    And export should be complete

  # --------------------------------------------------------------------------
  # Player Rankings Integration
  # --------------------------------------------------------------------------

  @rankings-integration
  Scenario: Compare picks to ADP
    Given I am drafting
    When I view ADP comparison
    Then I should see player ADP
    And I should see my pick position
    And I should see deviation

  @rankings-integration
  Scenario: Import personal rankings
    Given I have my own rankings
    When I import my rankings
    Then rankings should be imported
    And I should use them in drafts
    And rankings should guide auto-pick

  @rankings-integration
  Scenario: View rankings deviation analysis
    Given I have drafted
    When I view deviation analysis
    Then I should see where I deviated from ADP
    And I should see deviation reasoning
    And I should see impact

  @rankings-integration
  Scenario: View consensus rankings
    Given I am drafting
    When I view consensus rankings
    Then I should see aggregated rankings
    And I should see multiple sources
    And I should see consensus position

  @rankings-integration
  Scenario: Access expert rankings
    Given I want expert guidance
    When I view expert rankings
    Then I should see top expert rankings
    And I should see expert analysis
    And I should filter by expert

  @rankings-integration
  Scenario: View positional rankings
    Given I need position-specific rankings
    When I view positional rankings
    Then I should see QB rankings
    And I should see RB rankings
    And I should see all position rankings

  @rankings-integration
  Scenario: Use tier-based rankings
    Given I use tier-based drafting
    When I view tier rankings
    Then I should see players in tiers
    And I should see tier breaks
    And I should identify tier values

  @rankings-integration
  Scenario: See dynamic rankings updates
    Given rankings change over time
    When rankings are updated
    Then I should see updated rankings
    And I should see what changed
    And updates should be timely

  @rankings-integration
  Scenario: Customize rankings display
    Given I want personalized rankings
    When I customize rankings view
    Then I should filter rankings
    And I should sort rankings
    And I should save preferences

  @rankings-integration
  Scenario: Sync rankings across devices
    Given I use multiple devices
    When I sync rankings
    Then rankings should sync
    And I should have consistent view
    And changes should propagate

  # --------------------------------------------------------------------------
  # Practice Modes
  # --------------------------------------------------------------------------

  @practice-modes
  Scenario: Practice with timed picks
    Given I want realistic practice
    When I use timed practice mode
    Then picks should be timed
    And I should feel time pressure
    And I should improve speed

  @practice-modes
  Scenario: Practice with untimed picks
    Given I want to learn without pressure
    When I use untimed practice mode
    Then I should have unlimited time
    And I should study options
    And I should learn at my pace

  @practice-modes
  Scenario: Practice specific rounds
    Given I want to improve certain rounds
    When I practice specific rounds
    Then I should choose rounds to practice
    And I should focus on those rounds
    And I should skip other rounds

  @practice-modes
  Scenario: Practice positional scarcity
    Given I want to learn positional timing
    When I practice positional scarcity
    Then I should see position availability
    And I should learn scarcity points
    And I should optimize timing

  @practice-modes
  Scenario: Practice auction values
    Given I have an auction draft
    When I practice auction values
    Then I should learn player values
    And I should practice bidding
    And I should manage budget

  @practice-modes
  Scenario: Practice trades during draft
    Given my league allows draft trades
    When I practice draft trades
    Then I should propose trades
    And I should evaluate trade offers
    And I should learn trade timing

  @practice-modes
  Scenario: Practice best ball drafting
    Given I play best ball leagues
    When I practice best ball mode
    Then roster settings should be best ball
    And strategy should adjust
    And I should learn best ball approach

  @practice-modes
  Scenario: Practice dynasty rookie draft
    Given I play dynasty leagues
    When I practice rookie drafts
    Then I should draft only rookies
    And I should learn rookie values
    And I should practice dynasty strategy

  @practice-modes
  Scenario: Practice superflex drafting
    Given I play superflex leagues
    When I practice superflex mode
    Then QB values should be higher
    And I should learn superflex strategy
    And I should adjust accordingly

  @practice-modes
  Scenario: Create custom practice scenarios
    Given I want specific practice
    When I create custom scenario
    Then I should set specific conditions
    And I should configure roster state
    And I should practice that scenario

  # --------------------------------------------------------------------------
  # Mock Draft Scheduling
  # --------------------------------------------------------------------------

  @draft-scheduling
  Scenario: Schedule a mock draft
    Given I want to draft at specific time
    When I schedule a mock draft
    Then I should set date and time
    And draft should be scheduled
    And I should receive confirmation

  @draft-scheduling
  Scenario: Set recurring mock drafts
    Given I want regular practice
    When I set recurring schedule
    Then I should set frequency
    And drafts should repeat
    And I should manage recurring drafts

  @draft-scheduling
  Scenario: Receive draft reminders
    Given I have a scheduled draft
    When draft time approaches
    Then I should receive reminder
    And reminder should be timely
    And I should be able to join

  @draft-scheduling
  Scenario: Integrate with calendar
    Given I want calendar integration
    When I sync with calendar
    Then draft should appear in calendar
    And I should receive calendar alerts
    And schedule should stay synced

  @draft-scheduling
  Scenario: Handle timezone correctly
    Given participants are in different timezones
    When viewing draft times
    Then times should show in local timezone
    And conversions should be accurate
    And confusion should be minimized

  @draft-scheduling
  Scenario: Set draft availability
    Given I have limited availability
    When I set availability preferences
    Then I should mark available times
    And scheduling should respect availability
    And conflicts should be avoided

  @draft-scheduling
  Scenario: Configure auto-join preferences
    Given I want automatic joining
    When I set auto-join preferences
    Then I should auto-join scheduled drafts
    And I should set conditions
    And joining should be seamless

  @draft-scheduling
  Scenario: Receive scheduled draft notifications
    Given drafts are scheduled
    When notification time arrives
    Then I should be notified
    And notification should be clear
    And I should act on notification

  @draft-scheduling
  Scenario: Manage draft queue
    Given I have multiple scheduled drafts
    When I manage my queue
    Then I should see all scheduled drafts
    And I should prioritize drafts
    And I should handle conflicts

  @draft-scheduling
  Scenario: Handle scheduling conflicts
    Given I have conflicting schedules
    When conflicts are detected
    Then I should be warned
    And I should resolve conflicts
    And system should help with resolution

  # --------------------------------------------------------------------------
  # Mock Draft Analytics
  # --------------------------------------------------------------------------

  @draft-analytics
  Scenario: View draft tendencies report
    Given I have mock draft history
    When I view tendencies report
    Then I should see my patterns
    And I should see consistent behaviors
    And I should identify biases

  @draft-analytics
  Scenario: Analyze position selection patterns
    Given I have drafting data
    When I view position patterns
    Then I should see when I draft positions
    And I should see position frequencies
    And I should see pattern insights

  @draft-analytics
  Scenario: View round-by-round analysis
    Given I want detailed analysis
    When I view round analysis
    Then I should see each round's performance
    And I should see value by round
    And I should identify strong rounds

  @draft-analytics
  Scenario: Track value extraction metrics
    Given I want to measure value
    When I view value metrics
    Then I should see value extracted
    And I should see value vs ADP
    And I should see value trends

  @draft-analytics
  Scenario: Analyze roster construction patterns
    Given I want to improve roster building
    When I view construction patterns
    Then I should see how I build rosters
    And I should see balance patterns
    And I should see improvement areas

  @draft-analytics
  Scenario: Track improvement trends
    Given I have been practicing
    When I view improvement trends
    Then I should see skill progression
    And I should see grade improvements
    And I should see specific growth areas

  @draft-analytics
  Scenario: Identify drafting weaknesses
    Given I want to improve
    When I view weakness identification
    Then I should see areas to improve
    And I should see specific issues
    And I should get improvement tips

  @draft-analytics
  Scenario: View drafting strengths
    Given I want to leverage strengths
    When I view strength analysis
    Then I should see what I do well
    And I should see consistent successes
    And I should capitalize on strengths

  @draft-analytics
  Scenario: Compare to expert drafts
    Given I want expert comparison
    When I compare to experts
    Then I should see how I compare
    And I should see differences
    And I should learn from experts

  @draft-analytics
  Scenario: Get personalized recommendations
    Given I want to improve
    When I view personalized recommendations
    Then I should see tailored advice
    And recommendations should be actionable
    And I should track implementation

  # --------------------------------------------------------------------------
  # Mock Drafts Accessibility
  # --------------------------------------------------------------------------

  @mock-drafts @accessibility
  Scenario: Draft with screen reader
    Given I use a screen reader
    When I participate in mock draft
    Then draft should be accessible
    And picks should be announced
    And I should navigate effectively

  @mock-drafts @accessibility
  Scenario: Use keyboard for drafting
    Given I use keyboard navigation
    When I draft using keyboard
    Then I should navigate player list
    And I should make picks with keyboard
    And shortcuts should be available

  # --------------------------------------------------------------------------
  # Error Handling and Edge Cases
  # --------------------------------------------------------------------------

  @mock-drafts @error-handling
  Scenario: Handle connection loss during draft
    Given I am in a mock draft
    When I lose connection
    Then auto-pick should activate
    And I should reconnect seamlessly
    And my draft state should be preserved

  @mock-drafts @error-handling
  Scenario: Handle lobby not filling
    Given I am waiting in lobby
    When lobby doesn't fill
    Then AI should fill remaining spots
    And draft should still proceed
    And I should be notified

  @mock-drafts @error-handling
  Scenario: Handle draft data sync issues
    Given draft data has sync issues
    When sync fails
    Then I should see error notification
    And system should retry
    And data should eventually sync

  @mock-drafts @validation
  Scenario: Validate draft settings
    Given I am configuring a mock draft
    When I enter invalid settings
    Then I should see validation errors
    And errors should be clear
    And I should correct settings

  @mock-drafts @performance
  Scenario: Handle large draft history
    Given I have extensive draft history
    When I access history
    Then history should load efficiently
    And pagination should work
    And performance should be good
