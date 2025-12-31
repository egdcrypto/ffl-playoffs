@schedule @anima-1400
Feature: Schedule
  As a fantasy football user
  I want comprehensive schedule management
  So that I can track games and plan my lineup

  Background:
    Given I am a logged-in user
    And the schedule system is available

  # ============================================================================
  # SCHEDULE VIEW
  # ============================================================================

  @happy-path @schedule-view
  Scenario: View schedule
    Given schedule exists
    When I view schedule
    Then I should see the schedule
    And games should be listed

  @happy-path @schedule-view
  Scenario: View weekly schedule
    Given week is selected
    When I view weekly schedule
    Then I should see that week's games
    And matchups should be shown

  @happy-path @schedule-view
  Scenario: View full season schedule
    Given season is scheduled
    When I view full schedule
    Then I should see all weeks
    And I can scroll through season

  @happy-path @schedule-view
  Scenario: View current week
    Given season is in progress
    When I view current week
    Then I should see this week's games
    And current week should be highlighted

  @happy-path @schedule-view
  Scenario: View upcoming games
    Given future games exist
    When I view upcoming
    Then I should see upcoming games
    And they should be in order

  @happy-path @schedule-view
  Scenario: View schedule on mobile
    Given I am on mobile device
    When I view schedule
    Then schedule should be mobile-friendly
    And all info should be accessible

  @happy-path @schedule-view
  Scenario: Refresh schedule
    Given schedule may have changed
    When I refresh schedule
    Then schedule should update
    And current data should be shown

  @happy-path @schedule-view
  Scenario: View schedule in list format
    Given list view is available
    When I use list view
    Then schedule should show as list
    And I can see more games

  @happy-path @schedule-view
  Scenario: View schedule in calendar format
    Given calendar view is available
    When I use calendar view
    Then schedule should show as calendar
    And days should be visible

  @happy-path @schedule-view
  Scenario: View my matchups only
    Given I have matchups
    When I filter to my matchups
    Then I should see only my games
    And opponent should be shown

  # ============================================================================
  # SCHEDULE DETAILS
  # ============================================================================

  @happy-path @schedule-details
  Scenario: View game details
    Given game exists
    When I view game details
    Then I should see full details
    And all info should be shown

  @happy-path @schedule-details
  Scenario: View opponent info
    Given matchup exists
    When I view opponent
    Then I should see opponent details
    And their record should be shown

  @happy-path @schedule-details
  Scenario: View game time
    Given game is scheduled
    When I view time
    Then I should see game time
    And timezone should be clear

  @happy-path @schedule-details
  Scenario: View venue information
    Given venue info exists
    When I view venue
    Then I should see stadium info
    And location should be shown

  @happy-path @schedule-details
  Scenario: View broadcast info
    Given broadcast info exists
    When I view broadcast
    Then I should see network info
    And where to watch should be clear

  @happy-path @schedule-details
  Scenario: View weather for game
    Given weather data exists
    When I view weather
    Then I should see game weather
    And conditions should be shown

  @happy-path @schedule-details
  Scenario: View game preview
    Given preview is available
    When I view preview
    Then I should see game preview
    And analysis should be shown

  @happy-path @schedule-details
  Scenario: View injury report for game
    Given injuries exist
    When I view injury report
    Then I should see player injuries
    And status should be shown

  @happy-path @schedule-details
  Scenario: View betting lines
    Given betting info exists
    When I view lines
    Then I should see betting lines
    And odds should be shown

  @happy-path @schedule-details
  Scenario: View game importance
    Given importance is calculated
    When I view importance
    Then I should see how important game is
    And playoff implications should be shown

  # ============================================================================
  # SCHEDULE NAVIGATION
  # ============================================================================

  @happy-path @schedule-navigation
  Scenario: Navigate to next week
    Given more weeks exist
    When I go to next week
    Then I should see next week
    And navigation should be smooth

  @happy-path @schedule-navigation
  Scenario: Navigate to previous week
    Given previous weeks exist
    When I go to previous week
    Then I should see previous week
    And I can go back further

  @happy-path @schedule-navigation
  Scenario: Jump to specific week
    Given I want specific week
    When I jump to week
    Then I should see that week
    And it should load quickly

  @happy-path @schedule-navigation
  Scenario: View current week highlight
    Given I am browsing schedule
    When I view current week
    Then current week should be highlighted
    And I can identify it easily

  @happy-path @schedule-navigation
  Scenario: Use week selector
    Given selector is available
    When I use week selector
    Then I should see all weeks
    And I can choose any week

  @happy-path @schedule-navigation
  Scenario: View season timeline
    Given timeline is available
    When I view timeline
    Then I should see full season
    And progress should be shown

  @happy-path @schedule-navigation
  Scenario: Navigate to playoffs
    Given playoffs are scheduled
    When I go to playoffs
    Then I should see playoff schedule
    And bracket should be shown

  @happy-path @schedule-navigation
  Scenario: Use keyboard navigation
    Given keyboard nav is enabled
    When I use arrow keys
    Then I should navigate weeks
    And focus should be visible

  @happy-path @schedule-navigation
  Scenario: Swipe to navigate on mobile
    Given I am on mobile
    When I swipe left or right
    Then I should navigate weeks
    And gesture should be smooth

  @happy-path @schedule-navigation
  Scenario: Return to current week
    Given I am viewing other week
    When I click today/current
    Then I should return to current week
    And it should be centered

  # ============================================================================
  # SCHEDULE FILTERS
  # ============================================================================

  @happy-path @schedule-filters
  Scenario: Filter by team
    Given I want specific team
    When I filter by team
    Then I should see that team's games
    And others should be hidden

  @happy-path @schedule-filters
  Scenario: Filter by week
    Given I want specific week
    When I filter by week
    Then I should see that week only
    And other weeks should be hidden

  @happy-path @schedule-filters
  Scenario: Filter by matchup type
    Given matchup types exist
    When I filter by type
    Then I should see that type only
    And filter should apply

  @happy-path @schedule-filters
  Scenario: Filter bye weeks
    Given bye weeks exist
    When I filter bye weeks
    Then I should see bye week schedule
    And players on bye should be shown

  @happy-path @schedule-filters
  Scenario: Filter division games
    Given divisions exist
    When I filter division games
    Then I should see division matchups
    And importance should be indicated

  @happy-path @schedule-filters
  Scenario: Clear all filters
    Given filters are applied
    When I clear filters
    Then all filters should reset
    And full schedule should show

  @happy-path @schedule-filters
  Scenario: Apply multiple filters
    Given multiple filters exist
    When I apply multiple
    Then all filters should combine
    And results should match all

  @happy-path @schedule-filters
  Scenario: Save filter preferences
    Given I have useful filters
    When I save preferences
    Then preferences should be saved
    And I can reuse later

  @happy-path @schedule-filters
  Scenario: Filter rivalry games
    Given rivalries exist
    When I filter rivalries
    Then I should see rivalry matchups
    And history should be indicated

  @happy-path @schedule-filters
  Scenario: Filter prime time games
    Given prime time exists
    When I filter prime time
    Then I should see prime time games
    And broadcast should be shown

  # ============================================================================
  # SCHEDULE ALERTS
  # ============================================================================

  @happy-path @schedule-alerts
  Scenario: Set game reminder
    Given game is upcoming
    When I set reminder
    Then reminder should be saved
    And I will be notified

  @happy-path @schedule-alerts
  Scenario: Receive lineup lock alert
    Given lock time approaches
    When threshold is reached
    Then I should receive alert
    And I should set lineup

  @happy-path @schedule-alerts
  Scenario: Receive injury update before game
    Given injury occurs
    When game is approaching
    Then I should be alerted
    And I can adjust lineup

  @happy-path @schedule-alerts
  Scenario: Receive weather alert
    Given weather is concerning
    When game is approaching
    Then I should be alerted
    And impact should be explained

  @happy-path @schedule-alerts
  Scenario: Receive schedule change alert
    Given schedule changed
    When change occurs
    Then I should be notified
    And new time should be shown

  @happy-path @schedule-alerts
  Scenario: Configure alert timing
    Given timing options exist
    When I configure timing
    Then preferences should be saved
    And alerts should follow timing

  @happy-path @schedule-alerts
  Scenario: Receive game start alert
    Given game is starting
    When start time arrives
    Then I should receive alert
    And I can follow along

  @happy-path @schedule-alerts
  Scenario: Receive inactive player alert
    Given player is inactive
    When roster is revealed
    Then I should be alerted
    And I should bench player

  @happy-path @schedule-alerts
  Scenario: Disable schedule alerts
    Given I receive too many
    When I disable alerts
    Then alerts should stop
    And I can re-enable later

  @happy-path @schedule-alerts
  Scenario: View alert history
    Given alerts have occurred
    When I view history
    Then I should see past alerts
    And I can review them

  # ============================================================================
  # SCHEDULE EXPORT
  # ============================================================================

  @happy-path @schedule-export
  Scenario: Export schedule
    Given schedule exists
    When I export schedule
    Then I should receive export file
    And format should be selectable

  @happy-path @schedule-export
  Scenario: Sync with calendar
    Given calendar sync is available
    When I sync calendar
    Then games should appear in calendar
    And they should stay updated

  @happy-path @schedule-export
  Scenario: Add single game to calendar
    Given game exists
    When I add to calendar
    Then event should be created
    And reminder should be set

  @happy-path @schedule-export
  Scenario: Share schedule
    Given schedule exists
    When I share schedule
    Then shareable link should be created
    And others can view

  @happy-path @schedule-export
  Scenario: Print schedule
    Given schedule is displayed
    When I print schedule
    Then printable version should open
    And formatting should be clean

  @happy-path @schedule-export
  Scenario: Export to Google Calendar
    Given Google Calendar is connected
    When I export to Google
    Then events should be created
    And sync should work

  @happy-path @schedule-export
  Scenario: Export to Apple Calendar
    Given Apple Calendar is available
    When I export to Apple
    Then events should be created
    And iCal should work

  @happy-path @schedule-export
  Scenario: Download ICS file
    Given ICS export is available
    When I download ICS
    Then file should be downloaded
    And I can import anywhere

  @happy-path @schedule-export
  Scenario: Share to social media
    Given schedule exists
    When I share to social
    Then post should be created
    And schedule should be formatted

  @happy-path @schedule-export
  Scenario: Email schedule
    Given schedule exists
    When I email schedule
    Then email should be sent
    And schedule should be included

  # ============================================================================
  # SCHEDULE ANALYSIS
  # ============================================================================

  @happy-path @schedule-analysis
  Scenario: View strength of schedule
    Given SOS is calculated
    When I view SOS
    Then I should see schedule strength
    And ranking should be shown

  @happy-path @schedule-analysis
  Scenario: View remaining schedule difficulty
    Given games remain
    When I view difficulty
    Then I should see remaining difficulty
    And comparison should be shown

  @happy-path @schedule-analysis
  Scenario: View upcoming matchups analysis
    Given matchups exist
    When I view analysis
    Then I should see matchup analysis
    And projections should be shown

  @happy-path @schedule-analysis
  Scenario: View playoff schedule
    Given playoffs are set
    When I view playoff schedule
    Then I should see playoff games
    And bracket should be clear

  @happy-path @schedule-analysis
  Scenario: Plan for bye weeks
    Given bye weeks exist
    When I view bye planning
    Then I should see bye coverage
    And gaps should be identified

  @happy-path @schedule-analysis
  Scenario: Compare schedules
    Given multiple teams exist
    When I compare schedules
    Then I should see comparison
    And advantages should be highlighted

  @happy-path @schedule-analysis
  Scenario: View favorable matchups
    Given matchup data exists
    When I view favorable
    Then I should see best matchups
    And I can target players

  @happy-path @schedule-analysis
  Scenario: View tough matchups
    Given matchup data exists
    When I view tough
    Then I should see hard matchups
    And I can plan accordingly

  @happy-path @schedule-analysis
  Scenario: View schedule trends
    Given trends exist
    When I view trends
    Then I should see scheduling patterns
    And insights should be provided

  @happy-path @schedule-analysis
  Scenario: Export schedule analysis
    Given analysis exists
    When I export analysis
    Then I should receive export file
    And data should be complete

  # ============================================================================
  # SCHEDULE HISTORY
  # ============================================================================

  @happy-path @schedule-history
  Scenario: View past games
    Given games have been played
    When I view past games
    Then I should see completed games
    And results should be shown

  @happy-path @schedule-history
  Scenario: View game results
    Given game completed
    When I view results
    Then I should see final score
    And stats should be available

  @happy-path @schedule-history
  Scenario: View historical matchups
    Given history exists
    When I view historical
    Then I should see past matchups
    And records should be shown

  @happy-path @schedule-history
  Scenario: View season record
    Given season is ongoing
    When I view season record
    Then I should see my record
    And breakdown should be available

  @happy-path @schedule-history
  Scenario: View head-to-head history
    Given H2H history exists
    When I view H2H
    Then I should see all meetings
    And record should be shown

  @happy-path @schedule-history
  Scenario: View game recaps
    Given recaps are available
    When I view recaps
    Then I should see game summaries
    And highlights should be shown

  @happy-path @schedule-history
  Scenario: Compare to past seasons
    Given past seasons exist
    When I compare seasons
    Then I should see comparison
    And trends should be visible

  @happy-path @schedule-history
  Scenario: View win/loss streaks
    Given streaks are tracked
    When I view streaks
    Then I should see current streak
    And history should be shown

  @happy-path @schedule-history
  Scenario: Search schedule history
    Given history is extensive
    When I search history
    Then I should find matches
    And results should be relevant

  @happy-path @schedule-history
  Scenario: Export schedule history
    Given history exists
    When I export history
    Then I should receive export file
    And data should be complete

  # ============================================================================
  # SCHEDULE SYNC
  # ============================================================================

  @happy-path @schedule-sync
  Scenario: Sync with NFL schedule
    Given NFL schedule exists
    When I sync schedule
    Then games should align
    And times should be correct

  @happy-path @schedule-sync
  Scenario: Receive real-time updates
    Given updates are available
    When schedule changes
    Then I should see update
    And schedule should reflect changes

  @happy-path @schedule-sync
  Scenario: Handle game postponement
    Given game is postponed
    When postponement occurs
    Then schedule should update
    And I should be notified

  @happy-path @schedule-sync
  Scenario: Handle flex scheduling
    Given flex occurs
    When time changes
    Then schedule should update
    And new time should be shown

  @happy-path @schedule-sync
  Scenario: Handle time zone differences
    Given different timezones
    When I view schedule
    Then times should be in my timezone
    And conversion should be accurate

  @happy-path @schedule-sync
  Scenario: Auto-sync schedule
    Given auto-sync is enabled
    When changes occur
    Then schedule should update automatically
    And I stay current

  @happy-path @schedule-sync
  Scenario: View sync status
    Given sync is configured
    When I view status
    Then I should see sync status
    And last sync should be shown

  @happy-path @schedule-sync
  Scenario: Force manual sync
    Given I want current data
    When I force sync
    Then schedule should update
    And latest data should appear

  @happy-path @schedule-sync
  Scenario: Handle sync errors
    Given sync fails
    When error occurs
    Then I should see error message
    And I can retry

  @happy-path @schedule-sync
  Scenario: Configure sync preferences
    Given preferences exist
    When I configure sync
    Then preferences should be saved
    And sync should follow them

  # ============================================================================
  # SCHEDULE CUSTOMIZATION
  # ============================================================================

  @happy-path @schedule-customization
  Scenario: Set display preferences
    Given preferences exist
    When I set preferences
    Then preferences should be saved
    And schedule should reflect them

  @happy-path @schedule-customization
  Scenario: Set week start day
    Given options exist
    When I set start day
    Then week should start on that day
    And calendar should adjust

  @happy-path @schedule-customization
  Scenario: Set time format
    Given formats exist
    When I set format
    Then times should display in format
    And it should be consistent

  @happy-path @schedule-customization
  Scenario: Configure notification preferences
    Given preferences exist
    When I configure notifications
    Then preferences should be saved
    And notifications should follow them

  @happy-path @schedule-customization
  Scenario: Add schedule widget
    Given widgets are available
    When I add widget
    Then widget should be added
    And it should display schedule

  @happy-path @schedule-customization
  Scenario: Configure widget
    Given widget exists
    When I configure widget
    Then settings should be saved
    And widget should behave accordingly

  @happy-path @schedule-customization
  Scenario: Set default view
    Given views exist
    When I set default
    Then default should be saved
    And schedule should open to that view

  @happy-path @schedule-customization
  Scenario: Customize columns
    Given columns exist
    When I customize columns
    Then customization should be saved
    And schedule should reflect it

  @happy-path @schedule-customization
  Scenario: Reset to default settings
    Given I have custom settings
    When I reset to default
    Then defaults should be restored
    And I should confirm first

  @happy-path @schedule-customization
  Scenario: Save custom view
    Given I have customized view
    When I save view
    Then view should be saved
    And I can load it later

