@injuries @anima-1407
Feature: Injuries
  As a fantasy football user
  I want comprehensive injury tracking capabilities
  So that I can stay informed and adjust my roster accordingly

  Background:
    Given I am a logged-in user
    And the injury system is available

  # ============================================================================
  # INJURY REPORTS
  # ============================================================================

  @happy-path @injury-reports
  Scenario: View injury list
    Given injuries exist
    When I view injury list
    Then I should see all injuries
    And they should be organized

  @happy-path @injury-reports
  Scenario: View injury status
    Given player is injured
    When I view injury status
    Then I should see current status
    And designation should be clear

  @happy-path @injury-reports
  Scenario: View injury updates
    Given updates are available
    When I view updates
    Then I should see latest updates
    And timestamps should be shown

  @happy-path @injury-reports
  Scenario: View injury news
    Given injury news exists
    When I view injury news
    Then I should see news articles
    And sources should be shown

  @happy-path @injury-reports
  Scenario: View injury feed
    Given injuries are tracked
    When I view injury feed
    Then I should see live feed
    And updates should stream

  @happy-path @injury-reports
  Scenario: View my roster injuries
    Given my players are injured
    When I view roster injuries
    Then I should see my injured players
    And impact should be shown

  @happy-path @injury-reports
  Scenario: View league injuries
    Given league players are injured
    When I view league injuries
    Then I should see all league injuries
    And teams should be indicated

  @happy-path @injury-reports
  Scenario: View NFL injuries
    Given NFL injuries exist
    When I view NFL injuries
    Then I should see league-wide injuries
    And all teams should be covered

  @happy-path @injury-reports
  Scenario: Refresh injury reports
    Given reports may have changed
    When I refresh reports
    Then reports should update
    And latest info should show

  @happy-path @injury-reports
  Scenario: View injuries on mobile
    Given I am on mobile
    When I view injuries
    Then display should be mobile-friendly
    And all info should be accessible

  # ============================================================================
  # INJURY DETAILS
  # ============================================================================

  @happy-path @injury-details
  Scenario: View injury type
    Given injury exists
    When I view injury type
    Then I should see type of injury
    And body part should be indicated

  @happy-path @injury-details
  Scenario: View injury severity
    Given injury exists
    When I view severity
    Then I should see severity level
    And impact should be explained

  @happy-path @injury-details
  Scenario: View recovery timeline
    Given recovery is estimated
    When I view timeline
    Then I should see expected timeline
    And milestones should be shown

  @happy-path @injury-details
  Scenario: View return date
    Given return is estimated
    When I view return date
    Then I should see expected return
    And confidence should be indicated

  @happy-path @injury-details
  Scenario: View injury history
    Given player has injury history
    When I view history
    Then I should see past injuries
    And patterns should be visible

  @happy-path @injury-details
  Scenario: View injury description
    Given details are available
    When I view description
    Then I should see full description
    And context should be provided

  @happy-path @injury-details
  Scenario: View treatment info
    Given treatment is known
    When I view treatment
    Then I should see treatment details
    And prognosis should be shown

  @happy-path @injury-details
  Scenario: View injury progression
    Given injury is progressing
    When I view progression
    Then I should see recovery progress
    And updates should be chronological

  @happy-path @injury-details
  Scenario: View comparable injuries
    Given similar injuries exist
    When I view comparables
    Then I should see similar cases
    And outcomes should be shown

  @happy-path @injury-details
  Scenario: View expert analysis
    Given analysis is available
    When I view analysis
    Then I should see expert opinions
    And sources should be credible

  # ============================================================================
  # INJURY ALERTS
  # ============================================================================

  @happy-path @injury-alerts
  Scenario: Receive injury notification
    Given alerts are enabled
    When injury is reported
    Then I should receive notification
    And player should be identified

  @happy-path @injury-alerts
  Scenario: Receive injury updates
    Given I am tracking player
    When status changes
    Then I should receive update
    And new status should be shown

  @happy-path @injury-alerts
  Scenario: Receive status change alert
    Given player status changes
    When change occurs
    Then I should be alerted
    And change should be explained

  @happy-path @injury-alerts
  Scenario: Receive breaking news alert
    Given breaking news occurs
    When news breaks
    Then I should be alerted immediately
    And I can read details

  @happy-path @injury-alerts
  Scenario: Receive push alerts
    Given push is enabled
    When injury occurs
    Then I should receive push
    And it should be timely

  @happy-path @injury-alerts
  Scenario: Configure injury alerts
    Given preferences exist
    When I configure alerts
    Then preferences should be saved
    And alerts should follow them

  @happy-path @injury-alerts
  Scenario: Receive game-time decision alert
    Given GTD exists
    When decision is made
    Then I should be alerted
    And status should be final

  @happy-path @injury-alerts
  Scenario: Receive practice report alert
    Given practice occurs
    When report is released
    Then I should be alerted
    And participation should be shown

  @happy-path @injury-alerts
  Scenario: Disable injury alerts
    Given I receive too many
    When I disable alerts
    Then alerts should stop
    And I can re-enable later

  @happy-path @injury-alerts
  Scenario: Set alert priority
    Given priority options exist
    When I set priority
    Then only priority should alert
    And others should be silent

  # ============================================================================
  # INJURY IMPACT
  # ============================================================================

  @happy-path @injury-impact
  Scenario: View fantasy impact
    Given injury affects fantasy
    When I view impact
    Then I should see fantasy impact
    And projections should adjust

  @happy-path @injury-impact
  Scenario: View lineup impact
    Given injury affects lineup
    When I view lineup impact
    Then I should see affected positions
    And holes should be identified

  @happy-path @injury-impact
  Scenario: View roster adjustments
    Given adjustments are needed
    When I view adjustments
    Then I should see suggested changes
    And options should be ranked

  @happy-path @injury-impact
  Scenario: View replacement suggestions
    Given replacements are available
    When I view suggestions
    Then I should see replacement options
    And they should be comparable

  @happy-path @injury-impact
  Scenario: View trade impact
    Given injury affects value
    When I view trade impact
    Then I should see value change
    And implications should be explained

  @happy-path @injury-impact
  Scenario: View waiver impact
    Given handcuffs exist
    When I view waiver impact
    Then I should see pickup targets
    And priority should be suggested

  @happy-path @injury-impact
  Scenario: View matchup impact
    Given injury affects matchup
    When I view matchup impact
    Then I should see projected change
    And win probability should update

  @happy-path @injury-impact
  Scenario: View team impact
    Given NFL team is affected
    When I view team impact
    Then I should see offensive/defensive impact
    And other players should be shown

  @happy-path @injury-impact
  Scenario: View season impact
    Given injury is long-term
    When I view season impact
    Then I should see season outlook
    And strategy should be suggested

  @happy-path @injury-impact
  Scenario: Calculate point loss
    Given player was projected
    When I calculate loss
    Then I should see expected point loss
    And comparison should be shown

  # ============================================================================
  # INJURY TRACKING
  # ============================================================================

  @happy-path @injury-tracking
  Scenario: Track injuries
    Given I want to track player
    When I track injury
    Then player should be tracked
    And I will receive updates

  @happy-path @injury-tracking
  Scenario: View watchlist
    Given I have watchlist
    When I view watchlist
    Then I should see tracked players
    And statuses should be current

  @happy-path @injury-tracking
  Scenario: View monitored players
    Given I monitor players
    When I view monitored
    Then I should see all monitored
    And updates should be available

  @happy-path @injury-tracking
  Scenario: View injury log
    Given log exists
    When I view injury log
    Then I should see all tracked changes
    And history should be complete

  @happy-path @injury-tracking
  Scenario: View status history
    Given history exists
    When I view status history
    Then I should see status changes
    And timeline should be clear

  @happy-path @injury-tracking
  Scenario: Add player to watchlist
    Given player is injured
    When I add to watchlist
    Then player should be added
    And I will be notified of changes

  @happy-path @injury-tracking
  Scenario: Remove from watchlist
    Given player is on watchlist
    When I remove from watchlist
    Then player should be removed
    And notifications should stop

  @happy-path @injury-tracking
  Scenario: Set tracking preferences
    Given preferences exist
    When I set preferences
    Then preferences should be saved
    And tracking should follow them

  @happy-path @injury-tracking
  Scenario: View tracking dashboard
    Given I track players
    When I view dashboard
    Then I should see tracking overview
    And statuses should be summarized

  @happy-path @injury-tracking
  Scenario: Export tracking data
    Given tracking data exists
    When I export data
    Then export should be created
    And data should be complete

  # ============================================================================
  # INJURY SEARCH
  # ============================================================================

  @happy-path @injury-search
  Scenario: Search injuries
    Given injuries exist
    When I search injuries
    Then I should find matches
    And results should be relevant

  @happy-path @injury-search
  Scenario: Filter by team
    Given teams have injuries
    When I filter by team
    Then I should see team injuries
    And others should be hidden

  @happy-path @injury-search
  Scenario: Filter by position
    Given positions have injuries
    When I filter by position
    Then I should see position injuries
    And others should be hidden

  @happy-path @injury-search
  Scenario: Filter by status
    Given statuses vary
    When I filter by status
    Then I should see that status only
    And count should be shown

  @happy-path @injury-search
  Scenario: Filter by severity
    Given severities vary
    When I filter by severity
    Then I should see that severity only
    And impact should be clear

  @happy-path @injury-search
  Scenario: Search by player name
    Given player exists
    When I search by name
    Then I should find player
    And injury info should be shown

  @happy-path @injury-search
  Scenario: Search by injury type
    Given injury types vary
    When I search by type
    Then I should find matches
    And similar injuries should show

  @happy-path @injury-search
  Scenario: Apply multiple filters
    Given filters exist
    When I apply multiple
    Then results should combine
    And only matching should show

  @happy-path @injury-search
  Scenario: Clear search filters
    Given filters are applied
    When I clear filters
    Then filters should reset
    And all injuries should show

  @happy-path @injury-search
  Scenario: Save search filters
    Given filters are useful
    When I save filters
    Then filters should be saved
    And I can reuse later

  # ============================================================================
  # INJURY DESIGNATIONS
  # ============================================================================

  @happy-path @injury-designations
  Scenario: View IR designation
    Given player is on IR
    When I view designation
    Then I should see IR status
    And return timeline should be shown

  @happy-path @injury-designations
  Scenario: View questionable status
    Given player is questionable
    When I view status
    Then I should see questionable
    And game-time decision should be noted

  @happy-path @injury-designations
  Scenario: View doubtful status
    Given player is doubtful
    When I view status
    Then I should see doubtful
    And unlikelihood should be clear

  @happy-path @injury-designations
  Scenario: View out status
    Given player is out
    When I view status
    Then I should see out
    And expected return should be shown

  @happy-path @injury-designations
  Scenario: View probable status
    Given player is probable
    When I view status
    Then I should see probable
    And likelihood should be clear

  @happy-path @injury-designations
  Scenario: View day-to-day status
    Given player is day-to-day
    When I view status
    Then I should see day-to-day
    And monitoring should be indicated

  @happy-path @injury-designations
  Scenario: View PUP designation
    Given player is on PUP
    When I view designation
    Then I should see PUP status
    And eligibility should be shown

  @happy-path @injury-designations
  Scenario: View NFI designation
    Given player is on NFI
    When I view designation
    Then I should see NFI status
    And reason should be indicated

  @happy-path @injury-designations
  Scenario: View designation change
    Given designation changed
    When I view change
    Then I should see new designation
    And change should be highlighted

  @happy-path @injury-designations
  Scenario: Understand designation meanings
    Given designations are shown
    When I view meanings
    Then I should see explanations
    And percentages should be provided

  # ============================================================================
  # INJURY REPORTS SOURCE
  # ============================================================================

  @happy-path @injury-reports-source
  Scenario: View official reports
    Given official report exists
    When I view official
    Then I should see official report
    And it should be authoritative

  @happy-path @injury-reports-source
  Scenario: View team sources
    Given team provided info
    When I view team source
    Then I should see team info
    And credibility should be high

  @happy-path @injury-reports-source
  Scenario: View beat reporter info
    Given beat reporter tweeted
    When I view reporter info
    Then I should see their report
    And source should be credited

  @happy-path @injury-reports-source
  Scenario: View practice reports
    Given practice occurred
    When I view practice report
    Then I should see participation
    And levels should be shown

  @happy-path @injury-reports-source
  Scenario: View game-day updates
    Given game day is here
    When I view game-day updates
    Then I should see latest updates
    And active/inactive should be clear

  @happy-path @injury-reports-source
  Scenario: View source credibility
    Given sources are rated
    When I view credibility
    Then I should see reliability
    And track record should be shown

  @happy-path @injury-reports-source
  Scenario: View multiple sources
    Given multiple report
    When I view all sources
    Then I should see all reports
    And I can compare them

  @happy-path @injury-reports-source
  Scenario: View source timestamps
    Given timing matters
    When I view timestamps
    Then I should see when reported
    And recency should be clear

  @happy-path @injury-reports-source
  Scenario: Filter by source type
    Given source types vary
    When I filter by type
    Then I should see that type
    And others should be hidden

  @happy-path @injury-reports-source
  Scenario: Follow trusted sources
    Given I trust certain sources
    When I follow source
    Then I should get their updates
    And they should be prioritized

  # ============================================================================
  # INJURY ANALYSIS
  # ============================================================================

  @happy-path @injury-analysis
  Scenario: View injury trends
    Given trends exist
    When I view trends
    Then I should see injury trends
    And patterns should be visible

  @happy-path @injury-analysis
  Scenario: View team injury report
    Given team has injuries
    When I view team report
    Then I should see team injury report
    And all injured should be listed

  @happy-path @injury-analysis
  Scenario: View position injury analysis
    Given position has injuries
    When I view position analysis
    Then I should see position impact
    And depth should be assessed

  @happy-path @injury-analysis
  Scenario: View historical patterns
    Given history exists
    When I view patterns
    Then I should see historical patterns
    And predictions should be made

  @happy-path @injury-analysis
  Scenario: View risk assessment
    Given risk is calculated
    When I view risk assessment
    Then I should see injury risk
    And factors should be explained

  @happy-path @injury-analysis
  Scenario: View league-wide analysis
    Given league data exists
    When I view league analysis
    Then I should see league-wide trends
    And comparisons should be shown

  @happy-path @injury-analysis
  Scenario: View seasonal analysis
    Given season data exists
    When I view seasonal
    Then I should see seasonal patterns
    And timing should be considered

  @happy-path @injury-analysis
  Scenario: View injury correlation
    Given correlations exist
    When I view correlations
    Then I should see related factors
    And patterns should be identified

  @happy-path @injury-analysis
  Scenario: Export injury analysis
    Given analysis exists
    When I export analysis
    Then export should be created
    And data should be complete

  @happy-path @injury-analysis
  Scenario: View injury predictions
    Given predictions are available
    When I view predictions
    Then I should see injury predictions
    And confidence should be shown

  # ============================================================================
  # INJURY ROSTER ACTIONS
  # ============================================================================

  @happy-path @injury-roster-actions
  Scenario: Move to IR
    Given player is IR-eligible
    When I move to IR
    Then player should be on IR
    And roster spot should open

  @happy-path @injury-roster-actions
  Scenario: Activate from IR
    Given player is on IR
    When I activate from IR
    Then player should be active
    And roster should adjust

  @happy-path @injury-roster-actions
  Scenario: View IR-eligible players
    Given eligibility is tracked
    When I view eligible
    Then I should see eligible players
    And I can move them

  @happy-path @injury-roster-actions
  Scenario: Make roster moves
    Given injury affects roster
    When I make move
    Then roster should update
    And change should be logged

  @happy-path @injury-roster-actions
  Scenario: View waiver implications
    Given move affects waivers
    When I view implications
    Then I should see waiver impact
    And priority should be explained

  @happy-path @injury-roster-actions
  Scenario: Drop injured player
    Given player is injured long-term
    When I drop player
    Then player should be dropped
    And roster spot should open

  @happy-path @injury-roster-actions
  Scenario: View IR slot availability
    Given IR slots exist
    When I view availability
    Then I should see available slots
    And limits should be shown

  @happy-path @injury-roster-actions
  Scenario: Swap IR players
    Given multiple IR-eligible
    When I swap players
    Then swap should occur
    And rosters should update

  @happy-path @injury-roster-actions
  Scenario: View roster impact preview
    Given move is planned
    When I preview impact
    Then I should see roster impact
    And I can proceed or cancel

  @happy-path @injury-roster-actions
  Scenario: Receive IR action reminder
    Given player is returning
    When return is imminent
    Then I should be reminded
    And action should be suggested

