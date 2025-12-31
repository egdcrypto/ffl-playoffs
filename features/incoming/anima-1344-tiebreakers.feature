@tiebreakers @ANIMA-1344
Feature: Tiebreakers
  As a fantasy football playoffs application user
  I want comprehensive tiebreaker functionality
  So that I understand how ties are resolved and can strategize accordingly

  Background:
    Given the fantasy football playoffs application is running
    And I am logged in as a registered user
    And tiebreaker rules are configured for the league

  # ============================================================================
  # REGULAR SEASON TIEBREAKERS - HAPPY PATH
  # ============================================================================

  @happy-path @regular-season-tiebreakers
  Scenario: Apply head-to-head record tiebreaker
    Given two teams are tied in record
    When head-to-head tiebreaker is applied
    Then the team with better H2H record should win
    And H2H results should be displayed
    And tiebreaker should be clear

  @happy-path @regular-season-tiebreakers
  Scenario: Apply total points for tiebreaker
    Given teams are tied after H2H
    When points for tiebreaker is applied
    Then the team with more total points should win
    And point totals should be displayed
    And ranking should adjust

  @happy-path @regular-season-tiebreakers
  Scenario: Apply points against differential
    Given teams are still tied
    When point differential tiebreaker is applied
    Then the team with better differential should win
    And differential should be calculated
    And result should be displayed

  @happy-path @regular-season-tiebreakers
  Scenario: Apply division record comparison
    Given teams are in same division
    When division record tiebreaker is applied
    Then the team with better division record should win
    And division records should be shown
    And tiebreaker should resolve

  @happy-path @regular-season-tiebreakers
  Scenario: Apply conference record comparison
    Given conference records differ
    When conference tiebreaker is applied
    Then the team with better conference record should win
    And conference records should be displayed
    And ranking should be determined

  @happy-path @regular-season-tiebreakers
  Scenario: Calculate strength of schedule
    Given teams are still tied
    When strength of schedule is calculated
    Then SOS should be compared
    And harder schedule should favor team
    And calculation should be transparent

  @happy-path @regular-season-tiebreakers
  Scenario: Apply common opponents record
    Given teams have common opponents
    When common opponents tiebreaker is applied
    Then record against common opponents should compare
    And common opponents should be listed
    And result should be clear

  @happy-path @regular-season-tiebreakers
  Scenario: Apply coin flip fallback
    Given all tiebreakers are exhausted
    When coin flip is needed
    Then random selection should determine order
    And coin flip should be documented
    And result should be final

  # ============================================================================
  # PLAYOFF SEEDING TIEBREAKERS
  # ============================================================================

  @happy-path @playoff-seeding
  Scenario: Apply division winner priority
    Given teams are tied for playoff seed
    When division winner tiebreaker is applied
    Then division winner should get higher seed
    And non-winners should seed below
    And priority should be clear

  @happy-path @playoff-seeding
  Scenario: Determine wild card positioning
    Given wild card spots are contested
    When wild card tiebreakers apply
    Then wild card seeding should be determined
    And seeds should be assigned
    And order should be correct

  @happy-path @playoff-seeding
  Scenario: Handle multi-team tiebreaker scenario
    Given three or more teams are tied
    When multi-team tiebreaker is applied
    Then all tied teams should be evaluated
    And order should be determined for all
    And process should be documented

  @happy-path @playoff-seeding
  Scenario: Apply cascading tiebreaker rules
    Given first tiebreaker doesn't resolve
    When cascading rules are applied
    Then next tiebreaker should apply
    And cascade should continue until resolved
    And all steps should be shown

  @happy-path @playoff-seeding
  Scenario: Assign seeds after tiebreaker
    Given tiebreaker has resolved
    When seeds are assigned
    Then correct seeds should be given
    And standings should reflect seeds
    And bracket should populate

  @happy-path @playoff-seeding
  Scenario: Display tiebreaker explanation
    Given tiebreaker was applied
    When I view seeding explanation
    Then I should see why I got my seed
    And each step should be explained
    And I should understand the result

  # ============================================================================
  # MATCHUP TIEBREAKERS
  # ============================================================================

  @happy-path @matchup-tiebreakers
  Scenario: Apply bench points comparison
    Given matchup ends in a tie
    When bench points tiebreaker is applied
    Then team with more bench points should win
    And bench scores should be displayed
    And winner should be determined

  @happy-path @matchup-tiebreakers
  Scenario: Apply highest individual scorer wins
    Given matchup is tied after bench points
    When highest scorer tiebreaker is applied
    Then team with highest individual scorer should win
    And top scorers should be compared
    And result should be clear

  @happy-path @matchup-tiebreakers
  Scenario: Apply most positions with positive scores
    Given tie still exists
    When positive positions tiebreaker is applied
    Then team with more positive positions should win
    And position counts should be shown
    And winner should be declared

  @happy-path @matchup-tiebreakers
  Scenario: Apply quarterback points comparison
    Given QB tiebreaker is configured
    When QB points are compared
    Then team with more QB points should win
    And QB scores should be displayed
    And tiebreaker should resolve

  @happy-path @matchup-tiebreakers
  Scenario: Apply home team advantage
    Given home advantage tiebreaker is enabled
    When tie occurs
    Then home team should win the tie
    And home designation should be noted
    And result should be documented

  @happy-path @matchup-tiebreakers @commissioner
  Scenario: Allow commissioner decision
    Given no automatic tiebreaker resolves
    When commissioner makes decision
    Then commissioner should determine winner
    And decision should be logged
    And both teams should be notified

  @happy-path @matchup-tiebreakers
  Scenario: Apply overtime tiebreaker week
    Given overtime option is enabled
    When matchup ties
    Then additional week should be played
    And overtime matchup should be created
    And winner of OT should advance

  # ============================================================================
  # TIEBREAKER CONFIGURATION
  # ============================================================================

  @happy-path @tiebreaker-config @commissioner
  Scenario: Customize tiebreaker order
    Given I am configuring tiebreakers
    When I set custom order
    Then tiebreakers should apply in my order
    And order should be saved
    And league should use my configuration

  @happy-path @tiebreaker-config @commissioner
  Scenario: Enable specific tiebreakers
    Given tiebreaker options exist
    When I enable specific tiebreakers
    Then only enabled tiebreakers should apply
    And disabled ones should be skipped
    And configuration should save

  @happy-path @tiebreaker-config @commissioner
  Scenario: Disable specific tiebreakers
    Given tiebreakers are enabled
    When I disable a tiebreaker
    Then that tiebreaker should not apply
    And cascade should skip it
    And other tiebreakers should still work

  @happy-path @tiebreaker-config @commissioner
  Scenario: Configure league-specific rules
    Given I want custom rules
    When I configure league-specific tiebreakers
    Then custom rules should apply to my league
    And configuration should be unique
    And settings should persist

  @happy-path @tiebreaker-config @commissioner
  Scenario: Set different playoff vs regular season rules
    Given playoff and regular season differ
    When I configure separate rules
    Then regular season should use its rules
    And playoffs should use playoff rules
    And distinction should be clear

  @happy-path @tiebreaker-config @commissioner
  Scenario: Apply tiebreaker template
    Given tiebreaker templates exist
    When I apply a template
    Then template rules should load
    And I should modify from template
    And setup should be faster

  @happy-path @tiebreaker-config @commissioner
  Scenario: Configure rule precedence
    Given multiple rules could apply
    When I set precedence
    Then rules should apply in precedence order
    And conflicts should resolve correctly
    And precedence should be clear

  # ============================================================================
  # TIEBREAKER RESOLUTION
  # ============================================================================

  @happy-path @tiebreaker-resolution
  Scenario: Apply automatic tiebreaker
    Given tie occurs
    When automatic resolution is triggered
    Then tiebreaker should apply automatically
    And result should be determined
    And standings should update

  @happy-path @tiebreaker-resolution @commissioner
  Scenario: Override tiebreaker manually
    Given automatic result exists
    When commissioner overrides
    Then manual result should apply
    And override should be logged
    And affected teams should be notified

  @happy-path @tiebreaker-resolution
  Scenario: View tiebreaker audit trail
    Given tiebreakers have been applied
    When I view audit trail
    Then I should see all tiebreaker actions
    And timestamps should be shown
    And details should be complete

  @happy-path @tiebreaker-resolution
  Scenario: Receive resolution notification
    Given tiebreaker affects me
    When tiebreaker is resolved
    Then I should receive notification
    And I should see the result
    And I should understand the outcome

  @happy-path @tiebreaker-resolution
  Scenario: Alert affected teams
    Given tiebreaker changes standings
    When resolution completes
    Then affected teams should be alerted
    And impact should be explained
    And new standings should be shown

  @happy-path @tiebreaker-resolution
  Scenario: Display standing adjustment
    Given tiebreaker changed order
    When I view standings
    Then I should see adjusted standings
    And tiebreaker indicator should show
    And explanation should be available

  # ============================================================================
  # MULTI-WAY TIES
  # ============================================================================

  @happy-path @multi-way-ties
  Scenario: Handle three-way tie
    Given three teams are tied
    When three-way tiebreaker is applied
    Then all three should be evaluated together
    And order for all three should be determined
    And process should be transparent

  @happy-path @multi-way-ties
  Scenario: Handle four or more team tie
    Given four+ teams are tied
    When multi-team tiebreaker logic applies
    Then all tied teams should be evaluated
    And complete order should be determined
    And complexity should be handled

  @happy-path @multi-way-ties
  Scenario: Apply round-robin comparisons
    Given multi-team tie exists
    When round-robin is calculated
    Then all H2H matchups should be considered
    And aggregate record should determine order
    And calculation should be shown

  @happy-path @multi-way-ties
  Scenario: Calculate aggregate statistics
    Given multi-team tie needs resolution
    When aggregate stats are calculated
    Then combined statistics should compare
    And totals should be accurate
    And ranking should emerge

  @happy-path @multi-way-ties
  Scenario: Apply sequential elimination process
    Given complex tie exists
    When sequential elimination is used
    Then teams should be eliminated one by one
    And process should continue until resolved
    And each step should be documented

  @happy-path @multi-way-ties
  Scenario: Determine final order
    Given multi-way tie is being resolved
    When final order is determined
    Then all teams should have final rank
    And no ties should remain
    And order should be complete

  # ============================================================================
  # TIEBREAKER TRANSPARENCY
  # ============================================================================

  @happy-path @tiebreaker-transparency
  Scenario: View tiebreaker explanation UI
    Given tiebreaker was applied
    When I view explanation
    Then I should see clear explanation UI
    And each step should be visible
    And I should understand resolution

  @happy-path @tiebreaker-transparency
  Scenario: View step-by-step resolution display
    Given complex tiebreaker occurred
    When I view details
    Then I should see step-by-step breakdown
    And each tiebreaker should be shown
    And progression should be clear

  @happy-path @tiebreaker-transparency
  Scenario: View historical tiebreaker records
    Given past tiebreakers occurred
    When I view history
    Then I should see past tiebreakers
    And I should see how they resolved
    And patterns should be visible

  @happy-path @tiebreaker-transparency
  Scenario: View tiebreaker statistics
    Given tiebreaker data exists
    When I view statistics
    Then I should see tiebreaker frequency
    And I should see common scenarios
    And I should see my involvement

  @happy-path @tiebreaker-transparency
  Scenario: Explore what-if tiebreaker scenarios
    Given I want to understand scenarios
    When I explore what-if
    Then I should see hypothetical outcomes
    And I should understand implications
    And I should strategize accordingly

  @happy-path @tiebreaker-transparency
  Scenario: Preview pre-emptive tiebreaker
    Given tie is possible
    When I preview potential tiebreaker
    Then I should see who would win
    And I should see what I need
    And I should plan accordingly

  # ============================================================================
  # EDGE CASES
  # ============================================================================

  @happy-path @edge-cases
  Scenario: Handle identical records and points
    Given teams have identical everything
    When resolution is needed
    Then fallback tiebreaker should apply
    And some method should determine order
    And result should be documented

  @happy-path @edge-cases @commissioner
  Scenario: Handle mid-season rule changes
    Given rules change during season
    When new rules are applied
    Then effective date should be respected
    And retroactive impact should be handled
    And communication should be clear

  @happy-path @edge-cases
  Scenario: Apply retroactive tiebreaker
    Given retroactive application is needed
    When retroactive tiebreaker applies
    Then past standings should recalculate
    And changes should be documented
    And notifications should be sent

  @happy-path @edge-cases
  Scenario: Handle incomplete game data
    Given game data is incomplete
    When tiebreaker needs data
    Then available data should be used
    And missing data should be noted
    And best effort should be made

  @happy-path @edge-cases
  Scenario: Consider bye week in tiebreakers
    Given teams have different bye weeks
    When bye weeks affect comparison
    Then bye week should be factored appropriately
    And comparison should be fair
    And adjustment should be transparent

  @happy-path @edge-cases
  Scenario: Handle injury-adjusted scenarios
    Given injuries affected outcomes
    When tiebreaker considers context
    Then standard rules should apply
    And no injury adjustments should affect tiebreaker
    And consistency should be maintained

  # ============================================================================
  # TIEBREAKER DISPLAY
  # ============================================================================

  @happy-path @tiebreaker-display
  Scenario: Show tiebreaker indicator in standings
    Given tiebreaker determined order
    When I view standings
    Then I should see tiebreaker indicator
    And indicator should be subtle but visible
    And I should click for details

  @happy-path @tiebreaker-display
  Scenario: Show tiebreaker in matchup result
    Given matchup ended in tie
    When I view result
    Then I should see how tie was resolved
    And tiebreaker method should be shown
    And winner should be clear

  @happy-path @tiebreaker-display
  Scenario: Show pending tiebreaker status
    Given tiebreaker is being processed
    When I view status
    Then I should see pending indicator
    And I should know resolution is coming
    And I should wait for result

  # ============================================================================
  # ERROR HANDLING
  # ============================================================================

  @error
  Scenario: Handle tiebreaker calculation error
    Given tiebreaker calculation is attempted
    When calculation fails
    Then I should see error message
    And fallback should be available
    And commissioner should be notified

  @error
  Scenario: Handle missing tiebreaker data
    Given data is needed for tiebreaker
    When data is missing
    Then I should see appropriate message
    And available data should be used
    And issue should be flagged

  @error
  Scenario: Handle tiebreaker rule conflict
    Given rules conflict
    When conflict is detected
    Then conflict should be flagged
    And resolution should be suggested
    And commissioner should decide

  @error
  Scenario: Handle unresolvable tie
    Given no tiebreaker resolves tie
    When all options exhausted
    Then commissioner should be notified
    And manual resolution should be required
    And tie should not remain indefinitely

  # ============================================================================
  # MOBILE EXPERIENCE
  # ============================================================================

  @mobile
  Scenario: View tiebreaker on mobile
    Given I am using the mobile app
    When I view tiebreaker information
    Then display should be mobile-optimized
    And explanation should be readable
    And navigation should work

  @mobile
  Scenario: Receive tiebreaker notification on mobile
    Given tiebreaker affects me
    When notification is sent
    Then I should receive mobile push
    And I should tap to view details
    And experience should be smooth

  @mobile
  Scenario: Configure tiebreakers on mobile
    Given I am commissioner on mobile
    When I configure tiebreakers
    Then configuration should work on mobile
    And interface should be usable
    And changes should save

  # ============================================================================
  # ACCESSIBILITY
  # ============================================================================

  @accessibility
  Scenario: Navigate tiebreaker info with keyboard
    Given I am using keyboard navigation
    When I browse tiebreaker information
    Then I should navigate with keyboard
    And all content should be accessible
    And focus should be visible

  @accessibility
  Scenario: Screen reader tiebreaker access
    Given I am using a screen reader
    When I view tiebreaker information
    Then content should be announced
    And explanations should be read clearly
    And structure should be understandable

  @accessibility
  Scenario: High contrast tiebreaker display
    Given I have high contrast enabled
    When I view tiebreaker information
    Then text should be readable
    And indicators should be visible
    And content should be clear

  @accessibility
  Scenario: Tiebreaker with reduced motion
    Given I have reduced motion enabled
    When tiebreaker updates occur
    Then animations should be minimal
    And updates should still be visible
    And functionality should work
