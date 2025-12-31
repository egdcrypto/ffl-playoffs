@scoring @anima-1397
Feature: Scoring
  As a fantasy football user
  I want comprehensive scoring management
  So that I can track and understand fantasy points

  Background:
    Given I am a logged-in user
    And the scoring system is available

  # ============================================================================
  # SCORING SETTINGS
  # ============================================================================

  @happy-path @scoring-settings
  Scenario: Configure point values
    Given I am commissioner
    When I configure point values
    Then values should be saved
    And scoring should reflect changes

  @happy-path @scoring-settings
  Scenario: View scoring categories
    Given scoring is configured
    When I view categories
    Then I should see all categories
    And point values should be shown

  @happy-path @scoring-settings
  Scenario: Create custom scoring
    Given I want custom rules
    When I create custom scoring
    Then custom rules should be saved
    And they should apply to scoring

  @happy-path @scoring-settings
  Scenario: Enable decimal scoring
    Given decimal is available
    When I enable decimal scoring
    Then decimal points should apply
    And precision should be set

  @happy-path @scoring-settings
  Scenario: Configure negative points
    Given negative scoring exists
    When I configure negative points
    Then negative values should be saved
    And they should apply when earned

  @happy-path @scoring-settings
  Scenario: View default settings
    Given defaults exist
    When I view defaults
    Then I should see default values
    And I can compare to mine

  @happy-path @scoring-settings
  Scenario: Reset to default scoring
    Given I have custom scoring
    When I reset to defaults
    Then defaults should be restored
    And I should confirm first

  @happy-path @scoring-settings
  Scenario: Copy scoring from template
    Given templates exist
    When I copy from template
    Then settings should be applied
    And I can customize further

  @happy-path @scoring-settings
  Scenario: Export scoring settings
    Given settings are configured
    When I export settings
    Then settings should be exported
    And I can share with others

  @happy-path @scoring-settings
  Scenario: Import scoring settings
    Given I have settings file
    When I import settings
    Then settings should be applied
    And I can review before saving

  # ============================================================================
  # SCORING CALCULATIONS
  # ============================================================================

  @happy-path @scoring-calculations
  Scenario: Calculate touchdown points
    Given touchdown scoring is set
    When player scores touchdown
    Then correct points should be awarded
    And score should update

  @happy-path @scoring-calculations
  Scenario: Calculate yardage points
    Given yardage scoring is set
    When player gains yards
    Then correct points should be awarded
    And accumulation should work

  @happy-path @scoring-calculations
  Scenario: Calculate reception points
    Given reception scoring is set
    When player catches pass
    Then correct points should be awarded
    And PPR should apply if enabled

  @happy-path @scoring-calculations
  Scenario: Calculate bonus points
    Given bonuses are configured
    When player reaches bonus threshold
    Then bonus points should be awarded
    And threshold should be clear

  @happy-path @scoring-calculations
  Scenario: Calculate penalty points
    Given penalties are configured
    When player commits turnover
    Then penalty points should be deducted
    And score should decrease

  @happy-path @scoring-calculations
  Scenario: Calculate fractional points
    Given fractional scoring is enabled
    When player gains partial yards
    Then fractional points should apply
    And precision should be correct

  @happy-path @scoring-calculations
  Scenario: Handle multiple scoring events
    Given player has multiple events
    When events are processed
    Then all should be calculated
    And total should be correct

  @happy-path @scoring-calculations
  Scenario: Calculate special teams scoring
    Given special teams scoring exists
    When special teams scores
    Then correct points should be awarded
    And category should be correct

  @happy-path @scoring-calculations
  Scenario: Calculate defensive scoring
    Given defensive scoring exists
    When defense performs
    Then correct points should be awarded
    And categories should apply

  @happy-path @scoring-calculations
  Scenario: Verify calculation accuracy
    Given scoring occurred
    When I verify calculations
    Then all math should be correct
    And I can audit if needed

  # ============================================================================
  # SCORING FORMATS
  # ============================================================================

  @happy-path @scoring-formats
  Scenario: Use standard scoring
    Given standard scoring is selected
    When players perform
    Then standard points should apply
    And no reception bonus

  @happy-path @scoring-formats
  Scenario: Use PPR scoring
    Given PPR scoring is selected
    When player catches pass
    Then full PPR points should apply
    And reception bonus should be added

  @happy-path @scoring-formats
  Scenario: Use half-PPR scoring
    Given half-PPR is selected
    When player catches pass
    Then half-point should be added
    And calculation should be correct

  @happy-path @scoring-formats
  Scenario: Use superflex scoring
    Given superflex is enabled
    When QB is in flex
    Then QB scoring should apply
    And flex rules should work

  @happy-path @scoring-formats
  Scenario: Use IDP scoring
    Given IDP scoring is enabled
    When defensive player performs
    Then IDP points should apply
    And categories should be correct

  @happy-path @scoring-formats
  Scenario: View format comparison
    Given formats exist
    When I compare formats
    Then I should see differences
    And impact should be clear

  @happy-path @scoring-formats
  Scenario: Switch scoring format
    Given I want different format
    When I switch format
    Then new format should apply
    And scores should recalculate

  @happy-path @scoring-formats
  Scenario: Preview format impact
    Given I am considering format
    When I preview impact
    Then I should see projected changes
    And I can decide accordingly

  @happy-path @scoring-formats
  Scenario: Use TE premium scoring
    Given TE premium is enabled
    When tight end catches pass
    Then premium bonus should apply
    And TE should be valued higher

  @happy-path @scoring-formats
  Scenario: Configure custom format
    Given I want custom format
    When I configure format
    Then format should be saved
    And it should apply to scoring

  # ============================================================================
  # LIVE SCORING
  # ============================================================================

  @happy-path @live-scoring
  Scenario: View real-time updates
    Given games are in progress
    When scoring occurs
    Then updates should be real-time
    And scores should refresh automatically

  @happy-path @live-scoring
  Scenario: View play-by-play scoring
    Given game is ongoing
    When I view play-by-play
    Then I should see each scoring play
    And points should be attributed

  @happy-path @live-scoring
  Scenario: Handle stat corrections
    Given correction is made
    When correction is applied
    Then score should update
    And I should be notified

  @happy-path @live-scoring
  Scenario: Receive scoring alerts
    Given alerts are enabled
    When player scores
    Then I should receive alert
    And points should be shown

  @happy-path @live-scoring
  Scenario: Manually refresh scores
    Given I want current scores
    When I refresh
    Then scores should update
    And data should be current

  @happy-path @live-scoring
  Scenario: View scoring as it happens
    Given live scoring is active
    When play occurs
    Then score should update immediately
    And animation should show

  @happy-path @live-scoring
  Scenario: Track my players live
    Given I have active players
    When I track live
    Then I should see my players' scoring
    And updates should be highlighted

  @happy-path @live-scoring
  Scenario: View opponent scoring live
    Given matchup is active
    When opponent scores
    Then I should see their updates
    And comparison should update

  @happy-path @live-scoring
  Scenario: Handle delayed scoring
    Given scoring is delayed
    When delay is resolved
    Then scores should catch up
    And I should be informed

  @happy-path @live-scoring
  Scenario: Configure live scoring preferences
    Given preferences exist
    When I configure preferences
    Then preferences should be saved
    And updates should follow them

  # ============================================================================
  # SCORING BREAKDOWN
  # ============================================================================

  @happy-path @scoring-breakdown
  Scenario: View player scoring details
    Given player has scored
    When I view details
    Then I should see full breakdown
    And each category should be shown

  @happy-path @scoring-breakdown
  Scenario: View category breakdown
    Given scoring has occurred
    When I view by category
    Then I should see points per category
    And totals should match

  @happy-path @scoring-breakdown
  Scenario: View weekly totals
    Given week has games
    When I view weekly totals
    Then I should see week's points
    And all players should be included

  @happy-path @scoring-breakdown
  Scenario: View season totals
    Given season is ongoing
    When I view season totals
    Then I should see accumulated points
    And average should be shown

  @happy-path @scoring-breakdown
  Scenario: View scoring timeline
    Given scoring has occurred
    When I view timeline
    Then I should see when points were scored
    And order should be chronological

  @happy-path @scoring-breakdown
  Scenario: Expand scoring event
    Given scoring event exists
    When I expand event
    Then I should see full details
    And play should be described

  @happy-path @scoring-breakdown
  Scenario: Filter breakdown by position
    Given multiple positions scored
    When I filter by position
    Then I should see that position only
    And totals should adjust

  @happy-path @scoring-breakdown
  Scenario: Export scoring breakdown
    Given breakdown is displayed
    When I export breakdown
    Then I should receive export file
    And data should be complete

  @happy-path @scoring-breakdown
  Scenario: Compare player breakdowns
    Given multiple players exist
    When I compare breakdowns
    Then I should see side-by-side
    And differences should be clear

  @happy-path @scoring-breakdown
  Scenario: View starter vs bench breakdown
    Given lineup exists
    When I view breakdown
    Then I should see starter points
    And bench points should be separate

  # ============================================================================
  # SCORING HISTORY
  # ============================================================================

  @happy-path @scoring-history
  Scenario: View historical scores
    Given history exists
    When I view history
    Then I should see past scores
    And I can browse by date

  @happy-path @scoring-history
  Scenario: View week-by-week history
    Given weeks have passed
    When I view by week
    Then I should see each week
    And scores should be shown

  @happy-path @scoring-history
  Scenario: Compare seasons
    Given multiple seasons exist
    When I compare seasons
    Then I should see comparison
    And trends should be visible

  @happy-path @scoring-history
  Scenario: View career scoring
    Given career data exists
    When I view career scoring
    Then I should see career totals
    And breakdown should be available

  @happy-path @scoring-history
  Scenario: Track scoring records
    Given records are tracked
    When I view records
    Then I should see all records
    And record holders should be shown

  @happy-path @scoring-history
  Scenario: View highest scoring weeks
    Given weeks have occurred
    When I view highest weeks
    Then I should see top weeks
    And scores should be ranked

  @happy-path @scoring-history
  Scenario: View lowest scoring weeks
    Given weeks have occurred
    When I view lowest weeks
    Then I should see worst weeks
    And context should be provided

  @happy-path @scoring-history
  Scenario: Search scoring history
    Given history is extensive
    When I search history
    Then I should find matches
    And results should be relevant

  @happy-path @scoring-history
  Scenario: Export scoring history
    Given history exists
    When I export history
    Then I should receive export
    And data should be complete

  @happy-path @scoring-history
  Scenario: View scoring trends over time
    Given time data exists
    When I view trends
    Then I should see trends
    And trajectory should be clear

  # ============================================================================
  # SCORING PROJECTIONS
  # ============================================================================

  @happy-path @scoring-projections
  Scenario: View projected points
    Given projections exist
    When I view projections
    Then I should see expected points
    And confidence should be indicated

  @happy-path @scoring-projections
  Scenario: View ceiling and floor
    Given range data exists
    When I view ceiling/floor
    Then I should see high and low
    And range should be clear

  @happy-path @scoring-projections
  Scenario: View matchup projections
    Given matchup exists
    When I view matchup projections
    Then I should see projected scores
    And winner should be predicted

  @happy-path @scoring-projections
  Scenario: View rest-of-season projections
    Given ROS data exists
    When I view ROS projections
    Then I should see remaining projections
    And totals should be shown

  @happy-path @scoring-projections
  Scenario: View playoff projections
    Given playoff data exists
    When I view playoff projections
    Then I should see playoff expectations
    And odds should be shown

  @happy-path @scoring-projections
  Scenario: Compare projections to actuals
    Given both exist
    When I compare
    Then I should see accuracy
    And differences should be highlighted

  @happy-path @scoring-projections
  Scenario: View projection sources
    Given sources exist
    When I view sources
    Then I should see projection sources
    And I can compare them

  @happy-path @scoring-projections
  Scenario: Configure projection preferences
    Given preferences exist
    When I configure preferences
    Then preferences should be saved
    And projections should follow them

  @happy-path @scoring-projections
  Scenario: View boom/bust probability
    Given probability exists
    When I view probability
    Then I should see boom/bust odds
    And risk should be indicated

  @happy-path @scoring-projections
  Scenario: Export projections
    Given projections exist
    When I export projections
    Then I should receive export
    And data should be complete

  # ============================================================================
  # SCORING DISPUTES
  # ============================================================================

  @happy-path @scoring-disputes
  Scenario: Report stat correction need
    Given I see incorrect stat
    When I report issue
    Then report should be submitted
    And it should be reviewed

  @happy-path @scoring-disputes
  Scenario: File scoring appeal
    Given I disagree with scoring
    When I file appeal
    Then appeal should be submitted
    And commissioner should be notified

  @commissioner @scoring-disputes
  Scenario: Make manual adjustment
    Given I am commissioner
    When I make adjustment
    Then adjustment should apply
    And members should be notified

  @happy-path @scoring-disputes
  Scenario: View dispute resolution
    Given dispute was filed
    When I view resolution
    Then I should see outcome
    And reasoning should be shown

  @happy-path @scoring-disputes
  Scenario: Receive correction notification
    Given correction was made
    When correction applies
    Then I should be notified
    And impact should be shown

  @happy-path @scoring-disputes
  Scenario: View pending disputes
    Given disputes exist
    When I view pending
    Then I should see all disputes
    And status should be shown

  @happy-path @scoring-disputes
  Scenario: Track dispute history
    Given disputes occurred
    When I view history
    Then I should see past disputes
    And outcomes should be shown

  @commissioner @scoring-disputes
  Scenario: Approve scoring correction
    Given correction is requested
    When I approve correction
    Then correction should apply
    And requester should be notified

  @commissioner @scoring-disputes
  Scenario: Reject scoring correction
    Given correction is requested
    When I reject correction
    Then correction should not apply
    And requester should be notified with reason

  @happy-path @scoring-disputes
  Scenario: View official stat corrections
    Given NFL made corrections
    When I view official corrections
    Then I should see all corrections
    And impact should be shown

  # ============================================================================
  # SCORING REPORTS
  # ============================================================================

  @happy-path @scoring-reports
  Scenario: View scoring summary
    Given scoring occurred
    When I view summary
    Then I should see scoring summary
    And key stats should be highlighted

  @happy-path @scoring-reports
  Scenario: View top performers
    Given scoring occurred
    When I view top performers
    Then I should see highest scorers
    And rankings should be shown

  @happy-path @scoring-reports
  Scenario: View scoring trends
    Given trends exist
    When I view trends
    Then I should see scoring trends
    And patterns should be visible

  @happy-path @scoring-reports
  Scenario: View league averages
    Given averages are calculated
    When I view averages
    Then I should see league averages
    And my comparison should be shown

  @happy-path @scoring-reports
  Scenario: View position scoring
    Given scoring by position exists
    When I view by position
    Then I should see position scoring
    And rankings should be shown

  @happy-path @scoring-reports
  Scenario: Generate weekly report
    Given week completed
    When I generate report
    Then report should be created
    And all stats should be included

  @happy-path @scoring-reports
  Scenario: Generate season report
    Given season is ongoing
    When I generate season report
    Then report should be created
    And cumulative data should be shown

  @happy-path @scoring-reports
  Scenario: Share scoring report
    Given report exists
    When I share report
    Then shareable link should be created
    And others can view

  @happy-path @scoring-reports
  Scenario: Schedule automatic reports
    Given scheduling is available
    When I schedule reports
    Then schedule should be saved
    And reports should be sent automatically

  @happy-path @scoring-reports
  Scenario: Customize report content
    Given customization is available
    When I customize report
    Then preferences should be saved
    And report should reflect them

  # ============================================================================
  # SCORING COMPARISON
  # ============================================================================

  @happy-path @scoring-comparison
  Scenario: Compare team scoring
    Given multiple teams exist
    When I compare teams
    Then I should see team comparison
    And differences should be highlighted

  @happy-path @scoring-comparison
  Scenario: Compare player scoring
    Given multiple players exist
    When I compare players
    Then I should see player comparison
    And stats should be side-by-side

  @happy-path @scoring-comparison
  Scenario: Compare league scoring
    Given league data exists
    When I compare to league
    Then I should see comparison
    And my position should be clear

  @happy-path @scoring-comparison
  Scenario: Compare historical scoring
    Given history exists
    When I compare historically
    Then I should see past comparisons
    And trends should be visible

  @happy-path @scoring-comparison
  Scenario: Run what-if scenario
    Given scenarios are available
    When I run what-if
    Then I should see hypothetical results
    And impact should be shown

  @happy-path @scoring-comparison
  Scenario: Compare actual vs optimal
    Given optimal lineup exists
    When I compare to optimal
    Then I should see difference
    And missed points should be shown

  @happy-path @scoring-comparison
  Scenario: Compare across leagues
    Given I have multiple leagues
    When I compare leagues
    Then I should see cross-league comparison
    And I can identify patterns

  @happy-path @scoring-comparison
  Scenario: Compare to projections
    Given projections exist
    When I compare to projections
    Then I should see actual vs projected
    And accuracy should be shown

  @happy-path @scoring-comparison
  Scenario: Save comparison
    Given comparison is displayed
    When I save comparison
    Then comparison should be saved
    And I can access later

  @happy-path @scoring-comparison
  Scenario: Share comparison
    Given comparison is displayed
    When I share comparison
    Then shareable link should be created
    And others can view

