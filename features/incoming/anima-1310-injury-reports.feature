@injury-reports @injuries @health
Feature: Injury Reports
  As a fantasy football manager
  I want to track player injuries and their status
  So that I can make informed roster decisions and avoid starting injured players

  Background:
    Given a fantasy football league exists
    And the league has active members with rosters
    And NFL injury data is available

  # ==========================================
  # REAL-TIME INJURY UPDATES
  # ==========================================

  @real-time @happy-path
  Scenario: Receive real-time injury status updates
    Given I am managing my fantasy team
    When a player on my roster has an injury update
    Then I receive the update in real-time
    And my roster displays the current injury status

  @real-time @feed
  Scenario: View live injury news feed
    Given I access the injury reports section
    When I view the live feed
    Then I see the most recent injury updates
    And updates appear as they are reported

  @real-time @refresh
  Scenario: Manually refresh injury data
    Given I am viewing injury reports
    When I manually refresh the data
    Then the latest injury information is fetched
    And any changes are highlighted

  @real-time @timestamp
  Scenario: Display injury update timestamps
    Given injury updates are displayed
    When I view an injury report
    Then I see when the update was reported
    And relative time is shown for recency

  @real-time @source
  Scenario: Show injury report source
    Given an injury update is displayed
    When I view the source information
    Then I see where the report originated
    And official vs unofficial sources are distinguished

  # ==========================================
  # NFL INJURY DESIGNATIONS
  # ==========================================

  @designations @out
  Scenario: Display player designated as Out
    Given a player is designated as "Out"
    When I view their injury status
    Then "Out" is prominently displayed
    And a red indicator shows they will not play

  @designations @doubtful
  Scenario: Display player designated as Doubtful
    Given a player is designated as "Doubtful"
    When I view their injury status
    Then "Doubtful" is displayed with explanation
    And an orange indicator shows low probability of playing

  @designations @questionable
  Scenario: Display player designated as Questionable
    Given a player is designated as "Questionable"
    When I view their injury status
    Then "Questionable" is displayed
    And a yellow indicator shows uncertain availability

  @designations @probable
  Scenario: Display player designated as Probable
    Given a player is designated as "Probable"
    When I view their injury status
    Then "Probable" is displayed
    And a light indicator shows likely to play

  @designations @healthy
  Scenario: Display healthy player status
    Given a player has no injury designation
    When I view their status
    Then they show as healthy
    And no injury indicator is displayed

  @designations @change
  Scenario: Track designation changes
    Given a player's designation changes
    When the update is processed
    Then the new designation is shown
    And the previous designation is noted
    And the change is logged

  # ==========================================
  # PRACTICE PARTICIPATION
  # ==========================================

  @practice @dnp
  Scenario: Track player who did not practice
    Given a player did not practice (DNP)
    When I view their practice status
    Then "DNP" is displayed
    And this is flagged as a concern

  @practice @limited
  Scenario: Track player with limited practice
    Given a player had limited practice participation
    When I view their practice status
    Then "Limited" is displayed
    And this indicates partial participation

  @practice @full
  Scenario: Track player with full practice
    Given a player had full practice participation
    When I view their practice status
    Then "Full" is displayed
    And this indicates likely availability

  @practice @weekly
  Scenario: View weekly practice report
    Given practice data is available for the week
    When I view the weekly practice report
    Then I see Wed/Thu/Fri practice participation
    And trends through the week are visible

  @practice @trend
  Scenario: Analyze practice participation trends
    Given multiple days of practice data exist
    When I view practice trends
    Then I see if participation is increasing or decreasing
    And this informs game day availability

  # ==========================================
  # INJURY HISTORY
  # ==========================================

  @history @happy-path
  Scenario: View player injury history
    Given a player has past injuries
    When I access their injury history
    Then I see all recorded injuries
    And dates and durations are shown

  @history @details
  Scenario: View detailed injury information
    Given I am viewing injury history
    When I select a specific injury
    Then I see the injury type and body part
    And games missed are displayed

  @history @recurring
  Scenario: Identify recurring injuries
    Given a player has recurring injuries
    When I view their injury history
    Then recurring patterns are highlighted
    And the frequency is noted

  @history @career
  Scenario: View career injury summary
    Given a player has played multiple seasons
    When I view their career injury summary
    Then total games missed is shown
    And injury-prone indicators are displayed

  @history @comparison
  Scenario: Compare injury histories between players
    Given I am evaluating two players
    When I compare their injury histories
    Then I see side-by-side injury records
    And durability is compared

  # ==========================================
  # GAME-TIME DECISIONS
  # ==========================================

  @gtd @happy-path
  Scenario: Alert for game-time decision players
    Given a player is listed as a game-time decision
    When game day approaches
    Then I receive a GTD alert
    And I am reminded to have a backup plan

  @gtd @monitoring
  Scenario: Monitor game-time decision status
    Given I have a GTD player in my lineup
    When I access the GTD monitor
    Then I see real-time updates leading to game time
    And any news is immediately displayed

  @gtd @deadline
  Scenario: Set lineup lock deadline reminder
    Given my lineup has GTD players
    When the lineup lock deadline approaches
    Then I receive a reminder to finalize my lineup
    And GTD players are highlighted

  @gtd @inactive
  Scenario: Alert when GTD player is declared inactive
    Given a GTD player is declared inactive
    When the inactive list is published
    Then I receive an immediate alert
    And replacement suggestions are provided

  @gtd @active
  Scenario: Confirm when GTD player is active
    Given a GTD player is confirmed active
    When the active roster is announced
    Then I receive confirmation
    And my lineup is validated

  # ==========================================
  # PUSH NOTIFICATIONS
  # ==========================================

  @notifications @push @happy-path
  Scenario: Receive push notification for injury updates
    Given I have push notifications enabled
    When a rostered player has an injury update
    Then I receive a push notification
    And the notification shows the new status

  @notifications @preferences
  Scenario: Configure injury notification preferences
    Given I access notification settings
    When I configure injury notification preferences
    Then I can choose which statuses trigger notifications
    And I can set quiet hours

  @notifications @starters
  Scenario: Prioritize notifications for starters
    Given I have starters and bench players
    When I configure notification priority
    Then I can prioritize starter injury alerts
    And bench player alerts can be reduced

  @notifications @all-players
  Scenario: Subscribe to all player injury news
    Given I want comprehensive injury updates
    When I enable all-player notifications
    Then I receive updates for any NFL player
    And I can filter by team or position

  @notifications @breaking
  Scenario: Receive breaking injury news
    Given a major injury occurs
    When the news breaks
    Then I receive a priority notification
    And the severity is indicated

  @notifications @mute
  Scenario: Mute notifications temporarily
    Given I want to pause notifications
    When I mute injury notifications
    Then I don't receive alerts for the set period
    And notifications resume automatically

  # ==========================================
  # FANTASY PROJECTION IMPACT
  # ==========================================

  @projections @impact @happy-path
  Scenario: Adjust projections based on injury status
    Given a player has an injury designation
    When projections are calculated
    Then the projection reflects injury probability
    And healthy scratch risk is factored in

  @projections @out
  Scenario: Zero projection for Out players
    Given a player is designated Out
    When I view their projection
    Then the projection shows zero points
    And the injury is cited as the reason

  @projections @questionable
  Scenario: Discount projection for Questionable players
    Given a player is Questionable
    When I view their projection
    Then the projection is discounted
    And the discount percentage is shown

  @projections @snap-count
  Scenario: Project reduced snap count impact
    Given a player may have limited snaps
    When projections account for snap count
    Then reduced opportunity is factored in
    And the projection adjusts accordingly

  @projections @comparison
  Scenario: Compare healthy vs injured projections
    Given a player has an injury
    When I view projection comparison
    Then I see projected points if healthy
    And I see injury-adjusted projection

  # ==========================================
  # REPLACEMENT SUGGESTIONS
  # ==========================================

  @replacements @happy-path
  Scenario: Suggest replacement for injured player
    Given my starter has an injury
    When I view replacement suggestions
    Then bench players at the same position are shown
    And waiver wire options are suggested

  @replacements @ranking
  Scenario: Rank replacement options
    Given multiple replacement options exist
    When I view the suggestions
    Then options are ranked by projected points
    And matchup considerations are included

  @replacements @waiver
  Scenario: Suggest waiver wire replacements
    Given my bench lacks suitable replacements
    When I view waiver suggestions
    Then available players are recommended
    And I can add them directly

  @replacements @trade
  Scenario: Suggest trade targets as replacements
    Given I need a longer-term replacement
    When I view trade suggestions
    Then potential trade targets are shown
    And trade value is estimated

  @replacements @auto-swap
  Scenario: Enable automatic replacement
    Given I want automatic lineup management
    When I enable auto-swap for injuries
    Then injured starters are automatically benched
    And healthy backups are inserted

  # ==========================================
  # IR TRACKING
  # ==========================================

  @ir @happy-path
  Scenario: Track player on Injured Reserve
    Given a player is placed on IR
    When I view their status
    Then IR designation is displayed
    And minimum games to miss is shown

  @ir @roster
  Scenario: Place player on fantasy IR slot
    Given my league has IR slots
    And I have an IR-eligible player
    When I move the player to IR
    Then they occupy the IR slot
    And a roster spot is freed

  @ir @return
  Scenario: Track IR return timeline
    Given a player is on IR
    When their return window approaches
    Then I receive an update
    And expected return date is shown

  @ir @activation
  Scenario: Alert for IR activation
    Given a player is returning from IR
    When they are activated
    Then I receive an alert
    And I am prompted to adjust my roster

  @ir @ineligible
  Scenario: Handle IR-ineligible player in IR slot
    Given a player in my IR slot is no longer eligible
    When roster rules are enforced
    Then I am notified of the issue
    And I must move the player

  # ==========================================
  # PUP LIST TRACKING
  # ==========================================

  @pup @happy-path
  Scenario: Track player on PUP list
    Given a player is on the PUP list
    When I view their status
    Then PUP designation is displayed
    And they are ineligible for early season games

  @pup @activation
  Scenario: Track PUP activation window
    Given a player is on PUP
    When the activation window opens
    Then I receive an update
    And potential return date is indicated

  @pup @practice
  Scenario: Alert when PUP player begins practice
    Given a PUP player returns to practice
    When practice reports are released
    Then I am notified of their return
    And countdown to activation begins

  @pup @preseason
  Scenario: Distinguish preseason PUP
    Given a player is on preseason PUP
    When I view their status
    Then the preseason designation is clear
    And timeline to regular season is shown

  # ==========================================
  # INJURY TREND ANALYSIS
  # ==========================================

  @trends @happy-path
  Scenario: Analyze league-wide injury trends
    Given injury data is available across the NFL
    When I view injury trends
    Then I see patterns by team, position, and type
    And current trends are highlighted

  @trends @position
  Scenario: View injury trends by position
    Given injuries occur at different rates by position
    When I filter trends by position
    Then I see which positions have higher injury rates
    And this informs draft and roster strategy

  @trends @team
  Scenario: View injury trends by team
    Given some teams have more injuries
    When I view team injury summaries
    Then I see total injuries and impact by team
    And injury-prone teams are identified

  @trends @type
  Scenario: Analyze injury types
    Given different injury types have different recovery times
    When I view injury type analysis
    Then I see common injury types
    And average recovery times are shown

  @trends @seasonal
  Scenario: View seasonal injury patterns
    Given injury rates vary through the season
    When I view seasonal trends
    Then I see when injuries typically increase
    And playoff preparation insights are provided

  # ==========================================
  # TEAM INJURY SUMMARIES
  # ==========================================

  @team-summary @happy-path
  Scenario: View NFL team injury summary
    Given an NFL team has multiple injuries
    When I view their injury summary
    Then all injured players are listed
    And overall team health is assessed

  @team-summary @impact
  Scenario: Assess team injury impact
    Given a team has key players injured
    When I view injury impact analysis
    Then the impact on offense/defense is shown
    And fantasy implications are noted

  @team-summary @depth-chart
  Scenario: View injury impact on depth chart
    Given injuries affect the depth chart
    When I view depth chart impact
    Then backups moving into starting roles are shown
    And opportunity changes are highlighted

  @team-summary @opponent
  Scenario: View opponent injury report
    Given I want to assess matchups
    When I view the opponent's injury report
    Then I see their injured players
    And I can assess favorable matchups

  # ==========================================
  # BYE WEEK RECOVERY
  # ==========================================

  @bye-week @recovery
  Scenario: Track injury recovery during bye week
    Given a player is injured before their bye
    When the bye week passes
    Then recovery progress is tracked
    And post-bye expectations are updated

  @bye-week @projections
  Scenario: Project return after bye week
    Given an injured player has an upcoming bye
    When I view return projections
    Then the bye week is factored in
    And likelihood of post-bye return is shown

  @bye-week @alert
  Scenario: Alert for post-bye player status
    Given a player was injured before their bye
    When the bye week ends
    Then I receive an updated status
    And practice participation is reported

  # ==========================================
  # PRE-GAME INJURY TIMELINE
  # ==========================================

  @pre-game @timeline
  Scenario: View pre-game injury report timeline
    Given game day is approaching
    When I view the injury timeline
    Then I see the progression of reports through the week
    And final status is clearly shown

  @pre-game @final
  Scenario: View final injury report
    Given the final injury report is released
    When I view the report
    Then official game status is displayed
    And this is the definitive pre-game status

  @pre-game @warmups
  Scenario: Monitor pre-game warmups
    Given players are in pre-game warmups
    When warmup reports are available
    Then participation in warmups is noted
    And any concerning signs are flagged

  @pre-game @inactive
  Scenario: View inactive list
    Given the inactive list is published
    When I view inactive players
    Then all 7 inactive players per team are shown
    And fantasy implications are noted

  # ==========================================
  # POST-GAME INJURY UPDATES
  # ==========================================

  @post-game @updates
  Scenario: Receive post-game injury updates
    Given games have concluded
    When post-game injury updates are released
    Then I see new injuries that occurred during the game
    And severity assessments are provided

  @post-game @in-game
  Scenario: Track in-game injuries
    Given a player is injured during a game
    When the injury occurs
    Then I receive an immediate update
    And return status is monitored

  @post-game @diagnosis
  Scenario: View post-game injury diagnosis
    Given a player was injured in a game
    When diagnosis information is available
    Then the injury diagnosis is displayed
    And initial recovery timeline is estimated

  @post-game @testing
  Scenario: Track pending injury tests
    Given a player needs further evaluation
    When testing is pending
    Then the pending status is shown
    And expected test timeline is noted

  # ==========================================
  # INJURY SEVERITY
  # ==========================================

  @severity @indicators
  Scenario: Display injury severity indicators
    Given injuries have varying severity
    When I view an injury report
    Then severity is indicated visually
    And severity levels are explained

  @severity @minor
  Scenario: Categorize minor injuries
    Given an injury is minor
    When I view the injury details
    Then it is categorized as minor
    And expected minimal missed time is shown

  @severity @moderate
  Scenario: Categorize moderate injuries
    Given an injury is moderate
    When I view the injury details
    Then it is categorized as moderate
    And expected multi-week absence is shown

  @severity @severe
  Scenario: Categorize severe injuries
    Given an injury is severe
    When I view the injury details
    Then it is categorized as severe
    And season-ending possibility is noted

  @severity @career
  Scenario: Flag career-threatening injuries
    Given an injury may be career-threatening
    When I view the injury details
    Then the severity is clearly flagged
    And long-term prognosis is discussed

  # ==========================================
  # RETURN TIMELINES
  # ==========================================

  @return-timeline @happy-path
  Scenario: Display expected return timeline
    Given a player has an injury with estimated recovery
    When I view return timeline
    Then expected return week is shown
    And confidence level is indicated

  @return-timeline @range
  Scenario: Show return timeline range
    Given recovery time is uncertain
    When I view the timeline
    Then a range of possible return dates is shown
    And best and worst case scenarios are noted

  @return-timeline @update
  Scenario: Update return timeline based on progress
    Given a player is recovering
    When new recovery information is available
    Then the return timeline is updated
    And I am notified of changes

  @return-timeline @ahead
  Scenario: Note player ahead of schedule
    Given a player is recovering faster than expected
    When updates indicate progress
    Then "ahead of schedule" is noted
    And earlier return is projected

  @return-timeline @behind
  Scenario: Note player behind schedule
    Given a player is recovering slower than expected
    When updates indicate delays
    Then "behind schedule" is noted
    And later return is projected

  # ==========================================
  # HISTORICAL INJURY PATTERNS
  # ==========================================

  @patterns @player
  Scenario: Analyze individual player injury patterns
    Given a player has historical injury data
    When I analyze their patterns
    Then recurring injury types are identified
    And injury-prone seasons are noted

  @patterns @age
  Scenario: Factor age into injury risk
    Given player age is known
    When injury risk is calculated
    Then age-related injury risk is factored in
    And older players may show higher risk

  @patterns @position
  Scenario: Analyze position-based injury patterns
    Given positions have different injury rates
    When I view position analysis
    Then I see injury rates by position
    And high-risk positions are identified

  @patterns @workload
  Scenario: Correlate workload with injury risk
    Given workload data is available
    When I analyze injury patterns
    Then high-workload correlation is shown
    And fatigue-related risk is noted

  # ==========================================
  # ROSTER ALERTS
  # ==========================================

  @roster-alerts @happy-path
  Scenario: Alert for injured starter in lineup
    Given my starting lineup includes an injured player
    When lineup is analyzed
    Then I receive an alert about the injured starter
    And I am prompted to review my lineup

  @roster-alerts @deadline
  Scenario: Pre-deadline injury alert
    Given lineup lock deadline is approaching
    And I have an injured starter
    When the deadline approaches
    Then I receive an urgent alert
    And time remaining is displayed

  @roster-alerts @multiple
  Scenario: Alert for multiple injured starters
    Given I have multiple injured starters
    When my roster is analyzed
    Then I receive a consolidated alert
    And all injured starters are listed

  @roster-alerts @auto-check
  Scenario: Automatic lineup health check
    Given I have set my lineup
    When the system performs health check
    Then any injury concerns are flagged
    And I receive a summary

  # ==========================================
  # MOBILE EXPERIENCE
  # ==========================================

  @mobile @notifications
  Scenario: Receive injury notifications on mobile
    Given I have the mobile app
    When an injury update occurs
    Then I receive a push notification
    And I can view details in the app

  @mobile @display
  Scenario: View injury reports on mobile
    Given I am using the mobile app
    When I access injury reports
    Then the interface is mobile-optimized
    And all information is accessible

  @mobile @quick-actions
  Scenario: Take quick actions from mobile
    Given I receive an injury alert on mobile
    When I view the notification
    Then I can quickly swap players
    And roster changes are immediate

  @mobile @widget
  Scenario: Display injury status in widget
    Given I have the injury widget enabled
    When my roster has injured players
    Then the widget shows injury status
    And I can tap for more details

  # ==========================================
  # SOCIAL SHARING
  # ==========================================

  @social @share
  Scenario: Share injury news
    Given significant injury news breaks
    When I share the news
    Then I can post to social media
    And the injury details are formatted

  @social @discussion
  Scenario: Discuss injuries in league chat
    Given an injury affects multiple managers
    When injury news is posted to league chat
    Then discussion can occur
    And reactions are enabled

  @social @breaking
  Scenario: Share breaking injury news
    Given breaking injury news occurs
    When I share immediately
    Then the share indicates breaking news
    And timestamp shows recency

  # ==========================================
  # COMMISSIONER ANNOUNCEMENTS
  # ==========================================

  @commissioner @announcements
  Scenario: Commissioner announces injury-related news
    Given I am the commissioner
    When I create an injury-related announcement
    Then all league members are notified
    And the announcement is pinned

  @commissioner @rules
  Scenario: Commissioner clarifies injury-related rules
    Given injury rules need clarification
    When I post a rule clarification
    Then all members receive the update
    And the clarification is documented

  @commissioner @override
  Scenario: Commissioner adjusts for injury circumstances
    Given special injury circumstances exist
    When I make a commissioner decision
    Then the adjustment is recorded
    And affected managers are notified

  # ==========================================
  # WAIVER SUGGESTIONS
  # ==========================================

  @waiver-suggestions @happy-path
  Scenario: Suggest waiver pickups for injured players
    Given my player is injured
    When I view waiver suggestions
    Then replacement options are shown
    And availability is confirmed

  @waiver-suggestions @handcuff
  Scenario: Suggest handcuff for injured player
    Given my RB is injured
    When I view handcuff suggestions
    Then the backup RB is recommended
    And their projected role is explained

  @waiver-suggestions @similar
  Scenario: Suggest similar players
    Given my player is injured long-term
    When I view similar player suggestions
    Then players with similar profiles are shown
    And comparison stats are provided

  @waiver-suggestions @streaming
  Scenario: Suggest streaming options
    Given I need a short-term replacement
    When I view streaming suggestions
    Then weekly streaming options are shown
    And matchup favorability is noted

  # ==========================================
  # FANTASY SCORING ADJUSTMENTS
  # ==========================================

  @scoring @adjustments
  Scenario: Adjust fantasy scoring for injuries
    Given a player is injured mid-game
    When their game ends early
    Then actual points scored are recorded
    And the early exit is noted

  @scoring @projections
  Scenario: Update projections for backup players
    Given a starter is injured
    When the backup takes over
    Then the backup's projection increases
    And increased opportunity is factored

  @scoring @opportunity
  Scenario: Calculate increased opportunity value
    Given an injury creates opportunity
    When I view affected players
    Then increased touches/targets are projected
    And fantasy value adjustment is shown

  # ==========================================
  # ERROR HANDLING
  # ==========================================

  @error-handling
  Scenario: Handle delayed injury data
    Given injury data is temporarily unavailable
    When I access injury reports
    Then cached data is displayed
    And I am notified of the delay

  @error-handling
  Scenario: Handle conflicting injury reports
    Given multiple sources report different statuses
    When I view the injury report
    Then the discrepancy is noted
    And the most reliable source is indicated

  @error-handling
  Scenario: Handle injury data sync failure
    Given injury sync fails
    When I view injury reports
    Then the last successful update time is shown
    And a retry option is available

  # ==========================================
  # ACCESSIBILITY
  # ==========================================

  @accessibility
  Scenario: Navigate injury reports with screen reader
    Given I am using a screen reader
    When I access injury reports
    Then all content is properly labeled
    And status designations are announced

  @accessibility
  Scenario: View injury status with color blindness
    Given I have color blindness
    When I view injury indicators
    Then icons and text supplement colors
    And status is clear without color reliance

  @accessibility
  Scenario: Access injury reports with keyboard
    Given I navigate with keyboard only
    When I browse injury reports
    Then all interactive elements are reachable
    And focus indicators are visible
