@contract-leagues
Feature: Contract Leagues
  As a fantasy football manager
  I want to compete in contract-based leagues
  So that I can manage player contracts with realistic salary and term considerations

  Background:
    Given the fantasy football platform is available
    And I am logged in as a registered user
    And I am a member of a contract league

  # ============================================================================
  # MULTI-YEAR CONTRACTS
  # ============================================================================

  @multi-year-contracts
  Scenario: Sign player to multi-year contract
    Given I have a player I want to retain long-term
    When I sign them to a multi-year contract
    Then the contract should span multiple seasons
    And the terms should be recorded
    And the player should be committed to my team

  @multi-year-contracts
  Scenario: View contract duration
    Given a player has a multi-year contract
    When I view their contract details
    Then I should see total contract years
    And I should see years remaining
    And I should see contract end date

  @multi-year-contracts
  Scenario: Track contract years across seasons
    Given a player is in year one of a three-year deal
    When the season ends
    Then the contract should advance to year two
    And remaining years should decrease
    And I should see updated contract status

  @multi-year-contracts
  Scenario: Handle contract expiration
    Given a player's contract is in final year
    When the season ends
    Then the contract should expire
    And the player should become a free agent
    And I should be notified of the expiration

  @multi-year-contracts
  Scenario: View all team contracts
    Given I have multiple players under contract
    When I view my contract summary
    Then I should see all active contracts
    And I should see years remaining for each
    And I should see total salary committed

  @multi-year-contracts
  Scenario: Compare contract lengths
    Given I am evaluating player contracts
    When I compare contract durations
    Then I should see short-term vs long-term deals
    And I should understand commitment levels
    And I should make informed decisions

  @multi-year-contracts
  Scenario: Sign player to maximum contract length
    Given contract length limits exist
    When I sign a player to max length
    Then the contract should be at maximum years
    And the commitment should be significant
    And I should understand the implications

  @multi-year-contracts
  Scenario: View league-wide contract lengths
    Given I want to see league contracts
    When I view league contract summary
    Then I should see average contract lengths
    And I should see longest contracts
    And I should see league-wide trends

  @multi-year-contracts
  Scenario: Handle mid-season contract signing
    Given I acquire a player mid-season
    When I sign them to a multi-year deal
    Then the contract should start immediately
    And years should be counted appropriately
    And the contract should be valid

  # ============================================================================
  # CONTRACT EXTENSIONS
  # ============================================================================

  @contract-extensions
  Scenario: Extend expiring contract
    Given a player's contract is expiring
    When I offer a contract extension
    Then additional years should be added
    And new terms should apply
    And the player should remain on my team

  @contract-extensions
  Scenario: View extension eligibility
    Given I want to extend a player's contract
    When I check extension eligibility
    Then I should see if extensions are allowed
    And I should see extension window timing
    And I should understand the rules

  @contract-extensions
  Scenario: Negotiate extension terms
    Given I am extending a contract
    When I set extension terms
    Then I should specify additional years
    And I should specify salary
    And terms should be recorded

  @contract-extensions
  Scenario: Handle extension during season
    Given extensions are allowed mid-season
    When I extend a player's contract
    Then the extension should take effect
    And my cap should be adjusted
    And the contract should be updated

  @contract-extensions
  Scenario: View extension history
    Given a player has been extended before
    When I view their contract history
    Then I should see original contract
    And I should see extension details
    And I should see the full history

  @contract-extensions
  Scenario: Decline extension offer
    Given I no longer want to extend a player
    When I decline to extend
    Then the original contract should remain
    And it should expire as scheduled
    And the player may become a free agent

  @contract-extensions
  Scenario: Handle extension limits
    Given extension rules have limits
    When I attempt to extend beyond limits
    Then the system should enforce limits
    And I should see restriction message
    And I should adjust my approach

  @contract-extensions
  Scenario: Calculate extension value
    Given I want to know extension cost
    When I view extension projections
    Then I should see salary impact
    And I should see cap implications
    And I should make informed decisions

  @contract-extensions
  Scenario: Compare extension to new contract
    Given I am deciding between extend or re-sign
    When I compare the options
    Then I should see cost differences
    And I should see flexibility differences
    And I should choose the best option

  # ============================================================================
  # SALARY ESCALATION
  # ============================================================================

  @salary-escalation
  Scenario: Apply annual salary escalation
    Given a contract has salary escalation
    When a new season begins
    Then the salary should increase
    And the escalation should match contract terms
    And my cap should reflect the increase

  @salary-escalation
  Scenario: View escalation schedule
    Given a player has escalating salary
    When I view their contract details
    Then I should see salary by year
    And I should see escalation percentage
    And I should see future salaries

  @salary-escalation
  Scenario: Configure escalation rate
    Given I am signing a contract
    When I set escalation terms
    Then I should choose escalation rate
    And I should see total contract value
    And terms should be saved

  @salary-escalation
  Scenario: Handle fixed vs percentage escalation
    Given different escalation types exist
    When I compare escalation methods
    Then I should understand fixed increases
    And I should understand percentage increases
    And I should choose appropriately

  @salary-escalation
  Scenario: Project future salary obligations
    Given I have escalating contracts
    When I view future projections
    Then I should see future year salaries
    And I should see cap implications
    And I should plan ahead

  @salary-escalation
  Scenario: Compare escalation across contracts
    Given I have multiple escalating contracts
    When I compare escalation schedules
    Then I should see how salaries grow
    And I should see total escalation impact
    And I should manage my cap

  @salary-escalation
  Scenario: Handle de-escalation clauses
    Given a contract has de-escalation
    When conditions are met
    Then salary should decrease
    And the reduction should be applied
    And my cap should be updated

  @salary-escalation
  Scenario: View escalation impact on cap
    Given escalation affects my cap
    When I analyze cap projections
    Then I should see year-over-year changes
    And I should see escalation contribution
    And I should plan accordingly

  @salary-escalation
  Scenario: Negotiate escalation in extension
    Given I am extending a contract
    When I include escalation terms
    Then new escalation should apply
    And it should combine with existing terms
    And the full schedule should be clear

  # ============================================================================
  # CONTRACT NEGOTIATIONS
  # ============================================================================

  @contract-negotiations
  Scenario: Initiate contract negotiation
    Given I want to sign a free agent
    When I start contract negotiations
    Then I should propose terms
    And I should see negotiation interface
    And the process should begin

  @contract-negotiations
  Scenario: Propose contract terms
    Given I am negotiating with a player
    When I make an offer
    Then I should specify salary
    And I should specify years
    And I should include any bonuses

  @contract-negotiations
  Scenario: Receive counter-offer
    Given negotiations are simulated
    When the player counters
    Then I should see new proposed terms
    And I should evaluate the counter
    And I should respond accordingly

  @contract-negotiations
  Scenario: Accept negotiated terms
    Given terms have been agreed upon
    When I accept the final offer
    Then the contract should be finalized
    And the player should be signed
    And my roster should update

  @contract-negotiations
  Scenario: Reject negotiation terms
    Given I cannot agree on terms
    When I reject and walk away
    Then negotiations should end
    And the player should remain unsigned
    And I should pursue other options

  @contract-negotiations
  Scenario: Handle negotiation deadline
    Given a negotiation has a deadline
    When the deadline approaches
    Then I should see time remaining
    And I should be warned
    And I should act before expiration

  @contract-negotiations
  Scenario: Compare multiple offers
    Given I am negotiating with multiple players
    When I compare offers
    Then I should see side-by-side terms
    And I should evaluate options
    And I should prioritize negotiations

  @contract-negotiations
  Scenario: Include incentives in negotiations
    Given incentive clauses are available
    When I include incentives
    Then bonus terms should be specified
    And conditions should be clear
    And potential earnings should show

  @contract-negotiations
  Scenario: View negotiation history
    Given I have completed negotiations
    When I view negotiation history
    Then I should see past negotiations
    And I should see final terms reached
    And I should learn from history

  # ============================================================================
  # GUARANTEED MONEY
  # ============================================================================

  @guaranteed-money
  Scenario: Include guaranteed money in contract
    Given I am signing a contract
    When I structure guaranteed money
    Then I should specify guaranteed amount
    And I should specify guarantee type
    And the guarantee should be recorded

  @guaranteed-money
  Scenario: View guaranteed vs non-guaranteed salary
    Given a contract has mixed guarantees
    When I view contract breakdown
    Then I should see guaranteed portion
    And I should see non-guaranteed portion
    And I should understand the structure

  @guaranteed-money
  Scenario: Handle fully guaranteed contracts
    Given a contract is fully guaranteed
    When I view the contract
    Then all salary should show as guaranteed
    And dead cap should equal total value
    And I should understand the commitment

  @guaranteed-money
  Scenario: Calculate dead cap from guarantees
    Given guaranteed money creates dead cap
    When I consider cutting a player
    Then I should see dead cap amount
    And it should reflect guarantees
    And I should factor this into decisions

  @guaranteed-money
  Scenario: Release player with guaranteed money
    Given a player has remaining guarantees
    When I release the player
    Then guaranteed money becomes dead cap
    And my cap should be charged
    And the player should be released

  @guaranteed-money
  Scenario: View guarantee expiration
    Given some guarantees are vesting
    When I view guarantee schedule
    Then I should see when guarantees vest
    And I should see timing implications
    And I should plan cuts accordingly

  @guaranteed-money
  Scenario: Compare guarantee structures
    Given I am evaluating contracts
    When I compare guarantee levels
    Then I should see guarantee percentages
    And I should see dead cap implications
    And I should make informed choices

  @guaranteed-money
  Scenario: Structure signing bonus as guaranteed
    Given signing bonuses are guaranteed
    When I include a signing bonus
    Then it should be fully guaranteed
    And it should prorate for cap purposes
    And dead cap should reflect it

  @guaranteed-money
  Scenario: Handle injury guarantees
    Given a contract has injury guarantees
    When a player is injured
    Then injury guarantees should protect salary
    And the player should remain on payroll
    And I should understand the protection

  # ============================================================================
  # DEAD CAP PENALTIES
  # ============================================================================

  @dead-cap-penalties
  Scenario: Incur dead cap when cutting player
    Given a player has remaining guaranteed money
    When I cut the player
    Then dead cap should be charged
    And my available cap should decrease
    And the penalty should be visible

  @dead-cap-penalties
  Scenario: View dead cap projections
    Given I am considering roster moves
    When I view dead cap scenarios
    Then I should see dead cap for each option
    And I should understand the penalties
    And I should make informed decisions

  @dead-cap-penalties
  Scenario: Track dead cap on roster
    Given I have incurred dead cap
    When I view my cap summary
    Then I should see dead cap charges
    And they should be separate from active salaries
    And total cap usage should be accurate

  @dead-cap-penalties
  Scenario: Spread dead cap over years
    Given dead cap can be spread
    When I designate a post-cut
    Then dead cap should split across years
    And I should see the distribution
    And my current cap should be relieved

  @dead-cap-penalties
  Scenario: View dead cap history
    Given I have historical dead cap charges
    When I view dead cap history
    Then I should see past dead cap amounts
    And I should see the players involved
    And I should learn from past decisions

  @dead-cap-penalties
  Scenario: Minimize dead cap in trades
    Given I want to trade a player
    When I complete the trade
    Then dead cap should transfer to new team
    Or be split based on trade terms
    And I should minimize my dead cap

  @dead-cap-penalties
  Scenario: Calculate dead cap before action
    Given I am considering cutting a player
    When I preview the cut
    Then I should see dead cap in advance
    And I should understand the impact
    And I should decide to proceed or not

  @dead-cap-penalties
  Scenario: Handle accelerated dead cap
    Given a player is cut with remaining prorated bonus
    When dead cap is calculated
    Then remaining prorated amounts accelerate
    And full dead cap hits immediately
    And I should be prepared for the charge

  @dead-cap-penalties
  Scenario: Plan around dead cap
    Given dead cap affects my flexibility
    When I plan roster moves
    Then I should factor in dead cap
    And I should time cuts strategically
    And I should manage cap efficiently

  # ============================================================================
  # CONTRACT RESTRUCTURING
  # ============================================================================

  @contract-restructuring
  Scenario: Restructure contract for cap relief
    Given I need cap space
    When I restructure a player's contract
    Then salary should convert to bonus
    And bonus should prorate
    And I should gain immediate cap relief

  @contract-restructuring
  Scenario: View restructure options
    Given restructuring is available
    When I view restructure options for a player
    Then I should see potential cap savings
    And I should see future cap implications
    And I should understand the trade-offs

  @contract-restructuring
  Scenario: Handle restructure limits
    Given restructuring has limits
    When I attempt to restructure
    Then limits should be enforced
    And I should see available amount
    And I should stay within limits

  @contract-restructuring
  Scenario: Calculate future cap impact
    Given restructuring creates future obligations
    When I view projections
    Then I should see how restructuring affects future caps
    And I should see the pushed-out money
    And I should plan accordingly

  @contract-restructuring
  Scenario: Multiple restructures on same contract
    Given I have restructured before
    When I attempt another restructure
    Then eligibility should be checked
    And new restructure should be processed
    And cumulative impact should be tracked

  @contract-restructuring
  Scenario: Restructure for void year strategy
    Given void years can be added
    When I restructure with void years
    Then cap hit should spread further
    And void years should be added
    And dead cap risk should be noted

  @contract-restructuring
  Scenario: Compare restructure to extension
    Given I need cap relief
    When I compare restructure vs extension
    Then I should see immediate relief difference
    And I should see long-term impact
    And I should choose the best approach

  @contract-restructuring
  Scenario: View restructured contracts summary
    Given I have restructured multiple contracts
    When I view my cap summary
    Then I should see all restructured deals
    And I should see future obligations created
    And I should understand my cap situation

  @contract-restructuring
  Scenario: Undo restructure if allowed
    Given restructure reversal is permitted
    When I undo a restructure
    Then the contract should revert
    And my cap should adjust accordingly
    And the change should be recorded

  # ============================================================================
  # FRANCHISE TAGS
  # ============================================================================

  @franchise-tags
  Scenario: Apply franchise tag to player
    Given my franchise tag is available
    When I apply it to an expiring player
    Then the player should be tagged
    And they should remain on my team
    And their salary should be set accordingly

  @franchise-tags
  Scenario: View franchise tag salary
    Given franchise tag salary is calculated
    When I view the tag cost
    Then I should see the tag salary
    And I should see how it is calculated
    And I should understand the cost

  @franchise-tags
  Scenario: Use exclusive vs non-exclusive tag
    Given different tag types exist
    When I choose a tag type
    Then the rules should differ
    And exclusive should prevent offers
    And non-exclusive should allow matching

  @franchise-tags
  Scenario: Handle tag salary by position
    Given tag salary varies by position
    When I view position tag values
    Then I should see each position's tag salary
    And I should see market-based values
    And I should make informed decisions

  @franchise-tags
  Scenario: Negotiate long-term deal with tagged player
    Given a player is franchise tagged
    When I negotiate a long-term deal
    Then the tag should be replaced by contract
    And long-term terms should apply
    And the player should be locked up

  @franchise-tags
  Scenario: Handle consecutive tag penalties
    Given a player was tagged previously
    When I tag them again
    Then the tag salary should increase
    And the penalty should apply
    And I should see the higher cost

  @franchise-tags
  Scenario: View franchise tag deadline
    Given franchise tag has a deadline
    When the deadline approaches
    Then I should be notified
    And I should see time remaining
    And I should make my decision

  @franchise-tags
  Scenario: Release franchised player
    Given I no longer want to keep tagged player
    When I remove the tag
    Then the player should become a free agent
    And my cap should be relieved
    And the tag should be returned

  @franchise-tags
  Scenario: Track franchise tag usage
    Given franchise tags are limited
    When I view tag history
    Then I should see past tag usage
    And I should see remaining tags
    And I should manage tags carefully

  # ============================================================================
  # TRANSITION TAGS
  # ============================================================================

  @transition-tags
  Scenario: Apply transition tag to player
    Given my transition tag is available
    When I apply it to an expiring player
    Then the player should be tagged
    And I should have right of first refusal
    And their salary should be set

  @transition-tags
  Scenario: View transition tag salary
    Given transition tag salary differs from franchise
    When I view the tag cost
    Then I should see the lower salary
    And I should see calculation method
    And I should understand the value

  @transition-tags
  Scenario: Receive offer sheet on transition player
    Given my player is transition tagged
    When another team makes an offer
    Then I should receive the offer sheet
    And I should have time to match
    And I should decide whether to match

  @transition-tags
  Scenario: Match offer sheet
    Given I have received an offer sheet
    When I choose to match
    Then the player should remain with me
    And I should assume the offered terms
    And the player should be retained

  @transition-tags
  Scenario: Decline to match offer
    Given matching is not worthwhile
    When I decline to match
    Then the player should go to offering team
    And I should not receive compensation
    And the player should leave

  @transition-tags
  Scenario: Compare transition vs franchise tag
    Given I am deciding which tag to use
    When I compare the options
    Then I should see cost differences
    And I should see right differences
    And I should choose appropriately

  @transition-tags
  Scenario: View transition tag deadline
    Given transition tag has a deadline
    When the deadline approaches
    Then I should be notified
    And I should act accordingly
    And timing should be clear

  @transition-tags
  Scenario: Handle transition tag negotiation window
    Given tagged player can negotiate
    When the negotiation window is open
    Then I should attempt to sign long-term
    And terms should be negotiable
    And we should try to reach agreement

  @transition-tags
  Scenario: Track transition tag usage history
    Given I want to see tag history
    When I view transition tag history
    Then I should see past usages
    And I should see outcomes
    And I should learn from history

  # ============================================================================
  # CONTRACT LEAGUE SETTINGS
  # ============================================================================

  @contract-league-settings
  Scenario: Configure salary cap
    Given I am the commissioner
    When I set salary cap settings
    Then I should set cap amount
    And I should set floor if applicable
    And cap should be enforced

  @contract-league-settings
  Scenario: Configure contract length limits
    Given contract terms need limits
    When I set length settings
    Then I should set maximum years
    And I should set minimum if applicable
    And limits should be enforced

  @contract-league-settings
  Scenario: Configure franchise tag rules
    Given franchise tags need configuration
    When I set tag rules
    Then I should enable or disable tags
    And I should set tag limits
    And rules should be clear

  @contract-league-settings
  Scenario: Configure dead cap rules
    Given dead cap rules need setting
    When I configure dead cap
    Then I should set how dead cap works
    And I should set spreading rules
    And rules should be documented

  @contract-league-settings
  Scenario: Configure contract escalation rules
    Given escalation rules need setting
    When I configure escalation
    Then I should set allowable escalation
    And I should set limits
    And rules should apply to all contracts

  @contract-league-settings
  Scenario: Configure restructure rules
    Given restructuring needs rules
    When I set restructure settings
    Then I should enable or disable
    And I should set frequency limits
    And rules should be enforced

  @contract-league-settings
  Scenario: Set guaranteed money rules
    Given guarantee rules need configuration
    When I set guarantee settings
    Then I should set minimum or maximum guarantees
    And rules should be clear
    And they should apply league-wide

  @contract-league-settings
  Scenario: View all contract settings
    Given settings are configured
    When I view settings summary
    Then I should see all contract rules
    And I should see cap settings
    And I should understand the league structure

  @contract-league-settings
  Scenario: Import contract league template
    Given templates exist
    When I import a template
    Then settings should be pre-configured
    And I should be able to customize
    And setup should be faster

  # ============================================================================
  # ERROR HANDLING
  # ============================================================================

  @error-handling
  Scenario: Handle cap violation attempt
    Given I am over the salary cap
    When I try to add a player
    Then the system should prevent the action
    And I should see a cap violation error
    And I should be guided to free cap space

  @error-handling
  Scenario: Handle invalid contract terms
    Given contract terms are invalid
    When I submit the contract
    Then validation should fail
    And I should see error message
    And I should correct the terms

  @error-handling
  Scenario: Handle contract calculation error
    Given a calculation error occurs
    When the error is detected
    Then the system should recalculate
    And if unresolved, admin should be notified
    And accurate data should be restored

  @error-handling
  Scenario: Handle tag application failure
    Given franchise tag application fails
    When the failure occurs
    Then an error message should appear
    And I should be able to retry
    And the tag should not be lost

  @error-handling
  Scenario: Handle restructure error
    Given restructure processing fails
    When the error occurs
    Then the contract should remain unchanged
    And I should be notified
    And I should be able to retry

  @error-handling
  Scenario: Handle dead cap calculation error
    Given dead cap calculation has an error
    When the error is detected
    Then recalculation should occur
    And accurate dead cap should be shown
    And the issue should be logged

  @error-handling
  Scenario: Handle contract expiration error
    Given contract expiration processing fails
    When the error occurs
    Then manual intervention should be possible
    And contracts should be resolved
    And data integrity should be maintained

  @error-handling
  Scenario: Handle negotiation timeout
    Given a negotiation times out
    When the timeout occurs
    Then the negotiation should end
    And the user should be notified
    And they should be able to restart

  @error-handling
  Scenario: Handle duplicate contract attempt
    Given a player already has a contract
    When I try to sign a duplicate
    Then the system should prevent it
    And an error should be displayed
    And I should use appropriate action

  # ============================================================================
  # ACCESSIBILITY
  # ============================================================================

  @accessibility
  Scenario: Navigate contracts with screen reader
    Given I am using a screen reader
    When I access contract management
    Then all elements should be labeled
    And contract details should be announced
    And I should manage contracts effectively

  @accessibility
  Scenario: Use keyboard for contract actions
    Given I am using keyboard navigation
    When I perform contract actions
    Then all controls should be focusable
    And actions should be completable
    And the experience should be accessible

  @accessibility
  Scenario: View contract data in high contrast
    Given I use high contrast display
    When I view contract information
    Then all text should be readable
    And financial data should be clear
    And the experience should be accessible

  @accessibility
  Scenario: Access contracts on mobile
    Given I am using a mobile device
    When I access contract features
    Then the interface should be responsive
    And touch targets should be appropriate
    And all features should work

  @accessibility
  Scenario: View cap information accessibly
    Given I need accessible cap data
    When I view salary cap information
    Then numbers should be clearly readable
    And totals should be announced
    And I should understand my cap situation

  @accessibility
  Scenario: Navigate negotiation interface
    Given negotiations require interaction
    When I use the negotiation interface
    Then it should be accessible
    And offers should be clear
    And I should be able to respond

  @accessibility
  Scenario: View contract history accessibly
    Given I need to review contract history
    When I access historical data
    Then history should be navigable
    And details should be accessible
    And I should find needed information

  @accessibility
  Scenario: Receive contract notifications accessibly
    Given I have accessibility preferences
    When I receive contract notifications
    Then they should be compatible with assistive tech
    And important details should be conveyed
    And preferences should be respected

  @accessibility
  Scenario: Configure settings accessibly
    Given I need to configure contract settings
    When I access settings
    Then forms should be accessible
    And options should be clear
    And I should save changes successfully

  # ============================================================================
  # PERFORMANCE
  # ============================================================================

  @performance
  Scenario: Load contract data quickly
    Given I am accessing contract information
    When the page loads
    Then contract data should appear within 2 seconds
    And calculations should be complete
    And the experience should be responsive

  @performance
  Scenario: Calculate cap efficiently
    Given cap calculations are complex
    When I view my cap summary
    Then calculations should complete quickly
    And all contracts should be factored
    And accuracy should be maintained

  @performance
  Scenario: Process contract transactions quickly
    Given I am signing or restructuring
    When the transaction processes
    Then it should complete quickly
    And all updates should be applied
    And no delays should occur

  @performance
  Scenario: Handle large contract databases
    Given many contracts exist league-wide
    When I access contract data
    Then data should load efficiently
    And queries should be fast
    And performance should be good

  @performance
  Scenario: Update projections in real-time
    Given contract projections update frequently
    When I view projections
    Then they should update promptly
    And changes should reflect immediately
    And the experience should be smooth

  @performance
  Scenario: Process end-of-season contracts
    Given many contracts expire at season end
    When end-of-season processing runs
    Then all contracts should be processed
    And expirations should be handled
    And performance should be acceptable

  @performance
  Scenario: Cache contract calculations
    Given certain calculations are repeated
    When data is requested
    Then cached results should be used
    And cache should update on changes
    And performance should benefit

  @performance
  Scenario: Handle concurrent contract operations
    Given multiple users update contracts
    When concurrent operations occur
    Then all operations should succeed
    And data should remain consistent
    And no conflicts should occur

  @performance
  Scenario: Generate contract reports quickly
    Given I request contract reports
    When reports are generated
    Then generation should be fast
    And reports should be complete
    And the experience should be smooth
