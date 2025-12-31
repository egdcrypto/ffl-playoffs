@scoring-rules @ANIMA-1337
Feature: Scoring Rules
  As a fantasy football application user
  I want comprehensive scoring rules functionality
  So that I can understand, configure, and manage fantasy point calculations

  Background:
    Given the fantasy football playoffs application is running
    And I am logged in as a registered user

  # ============================================================================
  # STANDARD SCORING - HAPPY PATH
  # ============================================================================

  @happy-path @standard-scoring
  Scenario: View standard scoring rules
    Given my league uses standard scoring
    When I view scoring rules
    Then I should see standard point values
    And I should see all scoring categories
    And rules should be clearly displayed

  @happy-path @standard-scoring
  Scenario: View passing scoring in standard
    Given I am viewing standard scoring
    When I check passing rules
    Then I should see points per passing yard
    And I should see passing touchdown points
    And I should see interception penalties

  @happy-path @standard-scoring
  Scenario: View rushing scoring in standard
    Given I am viewing standard scoring
    When I check rushing rules
    Then I should see points per rushing yard
    And I should see rushing touchdown points
    And I should see fumble penalties

  @happy-path @standard-scoring
  Scenario: View receiving scoring in standard
    Given I am viewing standard scoring
    When I check receiving rules
    Then I should see points per receiving yard
    And I should see receiving touchdown points
    And I should see no reception points

  @happy-path @standard-scoring
  Scenario: View kicking scoring in standard
    Given I am viewing standard scoring
    When I check kicking rules
    Then I should see field goal points by distance
    And I should see extra point values
    And I should see missed kick penalties

  @happy-path @standard-scoring
  Scenario: View defense/ST scoring in standard
    Given I am viewing standard scoring
    When I check defense rules
    Then I should see points allowed tiers
    And I should see turnover points
    And I should see defensive touchdown points

  # ============================================================================
  # PPR SCORING
  # ============================================================================

  @happy-path @ppr-scoring
  Scenario: View PPR scoring rules
    Given my league uses PPR scoring
    When I view scoring rules
    Then I should see point per reception
    And I should see receiving categories
    And PPR should be clearly indicated

  @happy-path @ppr-scoring
  Scenario: Understand PPR reception points
    Given I am in a PPR league
    When I check reception scoring
    Then I should see 1 point per reception
    And I should see this applies to all catches
    And I should understand the impact

  @happy-path @ppr-scoring
  Scenario: Compare PPR to standard
    Given I want to understand PPR
    When I compare to standard scoring
    Then I should see the difference
    And I should see reception point addition
    And I should see player value changes

  @happy-path @ppr-scoring
  Scenario: View PPR impact on player rankings
    Given PPR scoring is active
    When I view player rankings
    Then rankings should reflect PPR value
    And reception-heavy players should rank higher
    And I should see PPR-adjusted projections

  @happy-path @ppr-scoring
  Scenario: Calculate PPR fantasy points
    Given a player has receptions
    When I calculate their score
    Then receptions should add points
    And receiving yards should add points
    And total should be accurate

  # ============================================================================
  # HALF-PPR SCORING
  # ============================================================================

  @happy-path @half-ppr-scoring
  Scenario: View half-PPR scoring rules
    Given my league uses half-PPR
    When I view scoring rules
    Then I should see 0.5 points per reception
    And I should see other standard rules
    And format should be clear

  @happy-path @half-ppr-scoring
  Scenario: Understand half-PPR balance
    Given I am in a half-PPR league
    When I assess player values
    Then value should be between standard and PPR
    And balance should be evident
    And I should factor in decisions

  @happy-path @half-ppr-scoring
  Scenario: Calculate half-PPR points
    Given a player has receptions
    When I calculate their score
    Then each reception should add 0.5 points
    And calculation should be accurate
    And I should see breakdown

  @happy-path @half-ppr-scoring
  Scenario: Compare half-PPR to full PPR
    Given I want to understand differences
    When I compare formats
    Then I should see point differences
    And I should see player ranking shifts
    And I should understand implications

  # ============================================================================
  # CUSTOM SCORING RULES
  # ============================================================================

  @happy-path @custom-scoring @commissioner
  Scenario: Create custom scoring rules
    Given I am a league commissioner
    When I create custom scoring rules
    Then I should set custom point values
    And I should create new categories
    And rules should be saved

  @happy-path @custom-scoring @commissioner
  Scenario: Modify point values
    Given I am configuring scoring
    When I modify point values
    Then I should change any category value
    And changes should be validated
    And I should see preview

  @happy-path @custom-scoring @commissioner
  Scenario: Add custom scoring category
    Given I want unique scoring
    When I add a custom category
    Then I should define the category
    And I should set point value
    And category should be active

  @happy-path @custom-scoring @commissioner
  Scenario: Remove scoring category
    Given a category exists
    When I remove it
    Then the category should be removed
    And scoring should update
    And I should confirm removal

  @happy-path @custom-scoring @commissioner
  Scenario: Set fractional scoring
    Given I want precise scoring
    When I enable fractional points
    Then partial yards should count
    And scoring should be more granular
    And I should set decimal places

  @happy-path @custom-scoring @commissioner
  Scenario: Copy scoring from template
    Given I want to use a template
    When I select a scoring template
    Then template rules should apply
    And I should modify from template
    And setup should be faster

  @happy-path @custom-scoring
  Scenario: View custom league rules
    Given my league has custom rules
    When I view scoring settings
    Then I should see all custom rules
    And differences should be highlighted
    And I should understand unique aspects

  # ============================================================================
  # POSITION-SPECIFIC SCORING
  # ============================================================================

  @happy-path @position-scoring
  Scenario: View quarterback scoring
    Given I want QB scoring details
    When I view QB scoring rules
    Then I should see passing categories
    And I should see rushing categories
    And I should see QB-specific bonuses

  @happy-path @position-scoring
  Scenario: View running back scoring
    Given I want RB scoring details
    When I view RB scoring rules
    Then I should see rushing categories
    And I should see receiving categories
    And I should see RB-specific rules

  @happy-path @position-scoring
  Scenario: View wide receiver scoring
    Given I want WR scoring details
    When I view WR scoring rules
    Then I should see receiving categories
    And I should see rushing categories
    And I should see return yard rules

  @happy-path @position-scoring
  Scenario: View tight end scoring
    Given I want TE scoring details
    When I view TE scoring rules
    Then I should see receiving categories
    And I should see TE premium if applicable
    And I should see blocking bonuses

  @happy-path @position-scoring
  Scenario: View kicker scoring
    Given I want K scoring details
    When I view kicker scoring rules
    Then I should see field goal tiers
    And I should see extra point values
    And I should see missed kick penalties

  @happy-path @position-scoring
  Scenario: View defense/ST scoring
    Given I want DST scoring details
    When I view DST scoring rules
    Then I should see points allowed tiers
    And I should see turnover values
    And I should see special teams scores

  @happy-path @position-scoring @commissioner
  Scenario: Configure TE premium
    Given I want to boost TE value
    When I set TE premium
    Then TEs should receive bonus reception points
    And premium should be configurable
    And I should see impact preview

  # ============================================================================
  # BONUS POINTS
  # ============================================================================

  @happy-path @bonus-points
  Scenario: View bonus point rules
    Given my league has bonuses
    When I view bonus rules
    Then I should see all bonus categories
    And I should see bonus thresholds
    And I should see bonus values

  @happy-path @bonus-points
  Scenario: View yardage bonuses
    Given yardage bonuses exist
    When I check bonus thresholds
    Then I should see 100-yard bonuses
    And I should see 200-yard bonuses
    And I should see bonus amounts

  @happy-path @bonus-points
  Scenario: View long play bonuses
    Given long play bonuses exist
    When I check bonus rules
    Then I should see long TD bonuses
    And I should see long reception bonuses
    And I should see distance thresholds

  @happy-path @bonus-points @commissioner
  Scenario: Configure yardage bonuses
    Given I am setting up bonuses
    When I configure yardage bonuses
    Then I should set threshold amounts
    And I should set bonus values
    And I should preview impact

  @happy-path @bonus-points @commissioner
  Scenario: Configure performance bonuses
    Given I want performance rewards
    When I set performance bonuses
    Then I should define criteria
    And I should set bonus amounts
    And bonuses should trigger correctly

  @happy-path @bonus-points
  Scenario: View bonus in player scoring
    Given a player earned a bonus
    When I view their score breakdown
    Then I should see bonus points
    And I should see bonus reason
    And total should include bonus

  # ============================================================================
  # NEGATIVE SCORING
  # ============================================================================

  @happy-path @negative-scoring
  Scenario: View negative scoring rules
    Given my league has negative scoring
    When I view negative categories
    Then I should see turnover penalties
    And I should see fumble points
    And I should see interception points

  @happy-path @negative-scoring
  Scenario: View fumble penalties
    Given fumbles lose points
    When I check fumble rules
    Then I should see fumble point deduction
    And I should see lost fumble specifics
    And penalties should be clear

  @happy-path @negative-scoring
  Scenario: View interception penalties
    Given interceptions lose points
    When I check INT rules
    Then I should see interception penalty
    And I should see pick-six impact
    And penalties should be accurate

  @happy-path @negative-scoring
  Scenario: View missed kick penalties
    Given missed kicks lose points
    When I check kicker penalties
    Then I should see missed FG penalty
    And I should see missed XP penalty
    And distance factors should show

  @happy-path @negative-scoring @commissioner
  Scenario: Configure negative point values
    Given I am setting penalties
    When I configure negative points
    Then I should set penalty amounts
    And I should choose which stats penalize
    And values should be saved

  @happy-path @negative-scoring
  Scenario: View negative points in breakdown
    Given a player lost points
    When I view their score
    Then I should see negative points
    And I should see the reason
    And total should reflect deductions

  # ============================================================================
  # SCORING CATEGORIES
  # ============================================================================

  @happy-path @scoring-categories
  Scenario: View all scoring categories
    Given I want complete scoring info
    When I view all categories
    Then I should see passing categories
    And I should see rushing/receiving
    And I should see special teams/defense

  @happy-path @scoring-categories
  Scenario: View passing categories
    Given I want passing details
    When I view passing scoring
    Then I should see yards per point
    And I should see TD values
    And I should see completion bonuses

  @happy-path @scoring-categories
  Scenario: View rushing categories
    Given I want rushing details
    When I view rushing scoring
    Then I should see yards per point
    And I should see TD values
    And I should see carry bonuses

  @happy-path @scoring-categories
  Scenario: View receiving categories
    Given I want receiving details
    When I view receiving scoring
    Then I should see yards per point
    And I should see TD values
    And I should see reception points

  @happy-path @scoring-categories
  Scenario: View special teams categories
    Given I want ST details
    When I view special teams scoring
    Then I should see return TD values
    And I should see return yard points
    And I should see fumble recovery points

  @happy-path @scoring-categories
  Scenario: View defensive categories
    Given I want defensive details
    When I view defensive scoring
    Then I should see sack values
    And I should see turnover values
    And I should see points allowed tiers

  # ============================================================================
  # SCORING PREVIEWS
  # ============================================================================

  @happy-path @scoring-previews
  Scenario: Preview player scoring
    Given I want to see potential points
    When I preview a player's scoring
    Then I should see projected points
    And I should see scoring breakdown
    And preview should use my rules

  @happy-path @scoring-previews
  Scenario: Preview weekly scoring
    Given I have a lineup set
    When I preview weekly scoring
    Then I should see projected team total
    And I should see per-player projections
    And I should see matchup context

  @happy-path @scoring-previews
  Scenario: Preview scoring rule changes
    Given I am modifying rules
    When I preview the changes
    Then I should see impact on scores
    And I should see historical re-calculation
    And I should assess the change

  @happy-path @scoring-previews
  Scenario: Compare scoring formats
    Given I want to compare formats
    When I preview different scoring
    Then I should see standard points
    And I should see PPR points
    And I should see differences

  @happy-path @scoring-previews
  Scenario: Preview bonus impact
    Given bonuses are configured
    When I preview with bonuses
    Then I should see bonus scenarios
    And I should see threshold requirements
    And I should understand bonus impact

  # ============================================================================
  # SCORING HISTORY
  # ============================================================================

  @happy-path @scoring-history
  Scenario: View historical scoring
    Given games have been played
    When I view scoring history
    Then I should see past scores
    And I should see weekly breakdowns
    And history should be complete

  @happy-path @scoring-history
  Scenario: View player scoring history
    Given I want player history
    When I view their scoring
    Then I should see game-by-game points
    And I should see scoring trends
    And I should see season totals

  @happy-path @scoring-history
  Scenario: View team scoring history
    Given I want my team's history
    When I view team scoring
    Then I should see weekly totals
    And I should see player contributions
    And I should see season progression

  @happy-path @scoring-history
  Scenario: Export scoring history
    Given I want scoring records
    When I export history
    Then I should receive a file
    And data should be complete
    And format should be usable

  @happy-path @scoring-history
  Scenario: Compare scoring across weeks
    Given I want weekly comparison
    When I compare week scores
    Then I should see week-over-week
    And I should see trends
    And I should identify patterns

  @happy-path @scoring-history
  Scenario: View scoring rule change history
    Given rules have changed
    When I view rule history
    Then I should see past configurations
    And I should see when changes occurred
    And I should see who made changes

  # ============================================================================
  # LEAGUE SCORING SETTINGS
  # ============================================================================

  @happy-path @league-settings @commissioner
  Scenario: Access scoring settings
    Given I am a commissioner
    When I access scoring settings
    Then I should see current configuration
    And I should see modification options
    And I should see impact preview

  @happy-path @league-settings @commissioner
  Scenario: Modify league scoring
    Given I want to change scoring
    When I modify settings
    Then I should update point values
    And I should add or remove categories
    And changes should be saved

  @happy-path @league-settings @commissioner
  Scenario: Lock scoring settings
    Given the season has started
    When I check settings
    Then some settings may be locked
    And I should see what can change
    And I should understand restrictions

  @happy-path @league-settings @commissioner
  Scenario: Apply scoring template
    Given I want standard configuration
    When I apply a template
    Then template settings should apply
    And I should customize further
    And setup should be simplified

  @happy-path @league-settings @commissioner
  Scenario: Notify league of scoring changes
    Given I changed scoring rules
    When changes are saved
    Then league members should be notified
    And they should see what changed
    And notification should be clear

  @happy-path @league-settings
  Scenario: View league scoring summary
    Given I am a league member
    When I view scoring summary
    Then I should see key rules
    And I should see unique aspects
    And summary should be accessible

  # ============================================================================
  # SCORING CALCULATIONS
  # ============================================================================

  @happy-path @scoring-calculations
  Scenario: Calculate player game score
    Given a player has game stats
    When I calculate their score
    Then each stat should contribute
    And calculation should be accurate
    And I should see the breakdown

  @happy-path @scoring-calculations
  Scenario: Calculate team weekly score
    Given my team has played
    When I view team score
    Then all player scores should sum
    And bench should not count
    And total should be correct

  @happy-path @scoring-calculations
  Scenario: Handle decimal scoring
    Given fractional scoring is enabled
    When scores are calculated
    Then decimals should be accurate
    And rounding should be consistent
    And precision should be maintained

  @happy-path @scoring-calculations
  Scenario: Verify scoring accuracy
    Given scores have been calculated
    When I verify the math
    Then each category should be correct
    And sum should match total
    And I should find no errors

  @happy-path @scoring-calculations
  Scenario: Handle stat corrections
    Given stats are corrected
    When corrections are applied
    Then scores should update
    And I should see the change
    And corrections should be noted

  # ============================================================================
  # SCORING DISPLAY
  # ============================================================================

  @happy-path @scoring-display
  Scenario: View scoring breakdown
    Given a player has scored
    When I view their breakdown
    Then I should see each category
    And I should see points per category
    And I should see total

  @happy-path @scoring-display
  Scenario: View live scoring updates
    Given games are in progress
    When I view live scoring
    Then scores should update in real-time
    And I should see point changes
    And updates should be immediate

  @happy-path @scoring-display
  Scenario: View projected vs actual
    Given the week is complete
    When I compare projections
    Then I should see projected points
    And I should see actual points
    And I should see the difference

  @happy-path @scoring-display
  Scenario: View scoring leaders
    Given the week has scoring
    When I view leaders
    Then I should see top scorers
    And I should see their totals
    And I should see rankings

  # ============================================================================
  # ERROR HANDLING
  # ============================================================================

  @error
  Scenario: Invalid scoring value
    Given I am configuring scoring
    When I enter an invalid value
    Then I should see an error
    And I should be guided to fix it
    And invalid values should not save

  @error
  Scenario: Scoring calculation error
    Given a calculation fails
    When an error occurs
    Then I should see error message
    And I should see fallback data
    And I should report the issue

  @error
  Scenario: Missing stat data
    Given stats are unavailable
    When I view scoring
    Then I should see appropriate message
    And available data should display
    And I should understand limitation

  @error
  Scenario: Conflicting scoring rules
    Given rules conflict
    When I save configuration
    Then I should see conflict warning
    And I should resolve the conflict
    And valid configuration should save

  @error
  Scenario: Locked settings modification attempt
    Given settings are locked
    When I try to modify
    Then I should see locked message
    And I should understand why
    And I should see when unlock occurs

  # ============================================================================
  # MOBILE EXPERIENCE
  # ============================================================================

  @mobile
  Scenario: View scoring rules on mobile
    Given I am using the mobile app
    When I view scoring rules
    Then rules should be mobile-optimized
    And I should scroll through categories
    And display should be readable

  @mobile
  Scenario: View scoring breakdown on mobile
    Given I am on mobile
    When I view player scoring
    Then breakdown should be mobile-friendly
    And categories should be clear
    And I should expand details

  @mobile
  Scenario: Configure scoring on mobile
    Given I am a commissioner on mobile
    When I configure scoring
    Then interface should work on mobile
    And I should modify settings
    And changes should save

  @mobile
  Scenario: View live scoring on mobile
    Given games are in progress
    When I check scores on mobile
    Then scores should update on mobile
    And display should be compact
    And updates should be real-time

  # ============================================================================
  # ACCESSIBILITY
  # ============================================================================

  @accessibility
  Scenario: Navigate scoring with keyboard
    Given I am using keyboard navigation
    When I browse scoring rules
    Then I should navigate with keyboard
    And I should access all settings
    And focus should be visible

  @accessibility
  Scenario: Screen reader scoring access
    Given I am using a screen reader
    When I view scoring information
    Then rules should be announced
    And values should be read correctly
    And structure should be clear

  @accessibility
  Scenario: High contrast scoring display
    Given I have high contrast enabled
    When I view scoring
    Then text should be visible
    And numbers should be readable
    And categories should be clear

  @accessibility
  Scenario: Scoring with reduced motion
    Given I have reduced motion enabled
    When I view live scoring
    Then updates should not animate excessively
    And changes should be visible
    And functionality should work
