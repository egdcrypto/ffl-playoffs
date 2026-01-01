@league-activity
Feature: League Activity
  As a fantasy football league member
  I want comprehensive league activity functionality
  So that I can stay informed about all league happenings in real-time

  Background:
    Given I am logged in as a league member
    And I have an active fantasy football league
    And I am on the league activity page

  # --------------------------------------------------------------------------
  # Activity Feed Scenarios
  # --------------------------------------------------------------------------
  @activity-feed
  Scenario: View real-time activity stream
    Given the league has ongoing activity
    When I access the activity feed
    Then I should see activities streaming in real-time
    And new activities should appear without refresh
    And activities should be clearly timestamped

  @activity-feed
  Scenario: View chronological activity updates
    Given multiple activities have occurred
    When I view the activity feed
    Then activities should be displayed in chronological order
    And the most recent activities should appear first
    And I should be able to reverse the order if desired

  @activity-feed
  Scenario: Filter activity feed by type
    Given I want to see specific activity types
    When I apply activity type filters
    Then only selected activity types should display
    And I should be able to select multiple types
    And the filter should persist during my session

  @activity-feed
  Scenario: Refresh activity feed manually
    Given I want to ensure I have the latest activities
    When I click the refresh button
    Then the feed should update with any new activities
    And a loading indicator should be shown
    And the refresh timestamp should update

  @activity-feed
  Scenario: View activity details
    Given there is an activity in the feed
    When I click on the activity
    Then I should see expanded activity details
    And related information should be displayed
    And I should be able to take relevant actions

  @activity-feed
  Scenario: Collapse and expand activity feed
    Given I am viewing the activity feed
    When I collapse a section of activities
    Then the section should minimize
    And I should be able to expand it again
    And collapse state should persist during session

  @activity-feed
  Scenario: View activity feed on dashboard
    Given the dashboard includes an activity widget
    When I view the dashboard
    Then I should see a condensed activity feed
    And I should be able to expand to full feed
    And the widget should update in real-time

  @activity-feed
  Scenario: Mark activities as read
    Given I have unread activities
    When I view the activities
    Then they should be marked as read
    And the unread count should decrease
    And I should be able to mark all as read

  # --------------------------------------------------------------------------
  # Transaction Activity Scenarios
  # --------------------------------------------------------------------------
  @transaction-activity
  Scenario: View trade activity
    Given a trade has been completed
    When the trade is processed
    Then a trade activity should appear in the feed
    And the activity should show all parties involved
    And trade details should be accessible

  @transaction-activity
  Scenario: View waiver claim activity
    Given waiver claims have been processed
    When waivers are awarded
    Then waiver activities should appear in the feed
    And successful claims should show player and team
    And FAAB amounts should be included if applicable

  @transaction-activity
  Scenario: View add/drop activity
    Given a team has added or dropped a player
    When the transaction is completed
    Then an add/drop activity should appear
    And the player and team should be shown
    And the timestamp should be accurate

  @transaction-activity
  Scenario: View roster move activity
    Given lineup changes have been made
    When I view transaction activity
    Then roster moves should be displayed
    And the players involved should be shown
    And the context (start/bench) should be clear

  @transaction-activity
  Scenario: View pending transaction activity
    Given there are pending transactions
    When I view the activity feed
    Then pending transactions should be indicated
    And their pending status should be clear
    And I should see expected processing time

  @transaction-activity
  Scenario: Filter transactions by team
    Given I want to see one team's transactions
    When I filter by team
    Then only that team's transactions should show
    And all transaction types should be included
    And the filter should be clearly indicated

  @transaction-activity
  Scenario: View transaction volume summary
    Given many transactions have occurred
    When I view the transaction summary
    Then I should see transaction counts by type
    And I should see activity trends
    And I should be able to drill into details

  @transaction-activity
  Scenario: Receive transaction activity alerts
    Given I have subscribed to transaction alerts
    When a significant transaction occurs
    Then I should receive an alert
    And the alert should summarize the transaction
    And I should be able to view full details

  # --------------------------------------------------------------------------
  # Lineup Activity Scenarios
  # --------------------------------------------------------------------------
  @lineup-activity
  Scenario: View lineup change activity
    Given a team has changed their lineup
    When the change is saved
    Then a lineup activity should appear
    And the players moved should be shown
    And the timing should be noted

  @lineup-activity
  Scenario: View start/sit decision activity
    Given an owner has made start/sit decisions
    When decisions are finalized
    Then the activity should reflect the choices
    And affected players should be listed
    And position context should be provided

  @lineup-activity
  Scenario: View last-minute swap activity
    Given a swap occurred close to game time
    When the swap is made
    Then it should be flagged as last-minute
    And the timing relative to kickoff should show
    And the swap details should be clear

  @lineup-activity
  Scenario: View lineup lock activity
    Given lineups have been locked
    When the lock occurs
    Then a lineup lock activity should appear
    And the locked teams should be indicated
    And final lineup snapshots should be available

  @lineup-activity
  Scenario: View optimal vs actual lineup activity
    Given a week has been scored
    When lineup analysis is available
    Then activity should show lineup efficiency
    And missed opportunities should be noted
    And optimal lineup comparison should be accessible

  @lineup-activity
  Scenario: View injured player lineup activity
    Given an owner started an injured player
    When the injury affects scoring
    Then an injury-related activity should appear
    And the impact should be noted
    And alternative options should be shown

  @lineup-activity
  Scenario: Track lineup setting patterns
    Given lineup activities are tracked over time
    When I view lineup patterns
    Then I should see when owners typically set lineups
    And last-minute tendencies should be shown
    And patterns should be visualized

  @lineup-activity
  Scenario: View lineup change notifications
    Given I want to know about opponent lineup changes
    When my opponent changes their lineup
    Then I should see an activity notification
    And the change should be summarized
    And full lineup should be accessible

  # --------------------------------------------------------------------------
  # Chat Activity Scenarios
  # --------------------------------------------------------------------------
  @chat-activity
  Scenario: View recent message activity
    Given messages have been posted in chat
    When I view chat activity
    Then I should see recent messages
    And message previews should be shown
    And I should be able to open full chat

  @chat-activity
  Scenario: View mention activity
    Given I have been mentioned in chat
    When I view my activity
    Then mentions should be highlighted
    And the context should be shown
    And I should be able to respond directly

  @chat-activity
  Scenario: View important announcement activity
    Given the commissioner has posted an announcement
    When the announcement is made
    Then it should appear prominently in activity
    And it should be flagged as important
    And it should persist until acknowledged

  @chat-activity
  Scenario: View trash talk activity
    Given trash talk has occurred
    When I view chat activity
    Then trash talk should be shown
    And matchup context should be provided
    And I should be able to respond

  @chat-activity
  Scenario: Filter chat activity by channel
    Given chat has multiple channels
    When I filter by channel
    Then only that channel's activity should show
    And the filter should be clearly indicated
    And I should be able to combine filters

  @chat-activity
  Scenario: View reaction activity
    Given messages have received reactions
    When I view chat activity
    Then popular reactions should be highlighted
    And reaction summaries should be shown
    And I should be able to add reactions

  @chat-activity
  Scenario: View poll activity
    Given a poll has been created or completed
    When I view activity
    Then poll activity should be shown
    And current results should be visible
    And I should be able to vote if active

  @chat-activity
  Scenario: Aggregate chat activity summary
    Given extensive chat activity exists
    When I view the chat summary
    Then I should see activity highlights
    And active discussions should be featured
    And participation metrics should be shown

  # --------------------------------------------------------------------------
  # Scoring Activity Scenarios
  # --------------------------------------------------------------------------
  @scoring-activity
  Scenario: View live scoring updates
    Given games are in progress
    When scoring events occur
    Then live scoring updates should appear
    And point values should be shown
    And affected teams should be highlighted

  @scoring-activity
  Scenario: View big play activity
    Given a big play has occurred
    When the play is scored
    Then a big play alert should appear
    And the play details should be shown
    And fantasy points should be displayed

  @scoring-activity
  Scenario: View milestone alert activity
    Given a player reaches a milestone
    When the milestone is achieved
    Then a milestone activity should appear
    And the achievement should be highlighted
    And historical context should be provided

  @scoring-activity
  Scenario: View lead change activity
    Given a matchup lead has changed
    When the lead change occurs
    Then a lead change activity should appear
    And current scores should be shown
    And the margin should be displayed

  @scoring-activity
  Scenario: View scoring correction activity
    Given a scoring correction has been applied
    When the correction is processed
    Then a correction activity should appear
    And the before and after should be shown
    And affected matchups should be noted

  @scoring-activity
  Scenario: View touchdown activity
    Given a touchdown has been scored
    When the TD is registered
    Then a touchdown activity should appear
    And the player and type should be shown
    And fantasy impact should be displayed

  @scoring-activity
  Scenario: View turnover activity
    Given a turnover has occurred
    When the turnover is scored
    Then a turnover activity should appear
    And the fantasy impact should be shown
    And affected owners should be noted

  @scoring-activity
  Scenario: View weekly scoring recap activity
    Given the week has concluded
    When scores are finalized
    Then a weekly recap activity should appear
    And winners and losers should be shown
    And notable performances should be highlighted

  # --------------------------------------------------------------------------
  # Owner Activity Scenarios
  # --------------------------------------------------------------------------
  @owner-activity
  Scenario: Track owner login activity
    Given owner logins are tracked
    When I view owner activity
    Then I should see recent login times
    And login frequency should be shown
    And last active time should be displayed

  @owner-activity
  Scenario: View engagement metrics
    Given owner engagement is measured
    When I view engagement data
    Then I should see participation metrics
    And activity levels should be ranked
    And trends should be visualized

  @owner-activity
  Scenario: Track activity streaks
    Given owners maintain activity streaks
    When I view streak data
    Then current streaks should be displayed
    And streak records should be shown
    And streak milestones should be celebrated

  @owner-activity
  Scenario: View owner participation summary
    Given owners participate in various activities
    When I view participation summary
    Then I should see activity breakdown by type
    And comparison to league average should show
    And improvement suggestions should be offered

  @owner-activity
  Scenario: Identify inactive owners
    Given some owners may be inactive
    When I view inactivity report
    Then inactive owners should be identified
    And inactivity duration should be shown
    And contact options should be available

  @owner-activity
  Scenario: View owner activity timeline
    Given an owner has activity history
    When I view their timeline
    Then I should see all their activities
    And activities should be chronological
    And I should be able to filter by type

  @owner-activity
  Scenario: Compare owner activity levels
    Given multiple owners have activity data
    When I compare activity levels
    Then I should see side-by-side comparison
    And rankings should be displayed
    And activity types should be compared

  @owner-activity
  Scenario: Reward active owners
    Given the league rewards activity
    When activity milestones are reached
    Then reward notifications should appear
    And badges or achievements should be granted
    And the rewards should be visible on profiles

  # --------------------------------------------------------------------------
  # Activity Notifications Scenarios
  # --------------------------------------------------------------------------
  @activity-notifications
  Scenario: Receive push notifications
    Given I have push notifications enabled
    When significant activity occurs
    Then I should receive a push notification
    And the notification should be actionable
    And I should be able to dismiss or view

  @activity-notifications
  Scenario: Receive email digests
    Given I have email digests configured
    When the digest period arrives
    Then I should receive an email summary
    And the digest should include key activities
    And I should be able to customize content

  @activity-notifications
  Scenario: View in-app alerts
    Given I am using the application
    When important activity occurs
    Then I should see an in-app alert
    And the alert should be noticeable
    And I should be able to take action

  @activity-notifications
  Scenario: Configure notification preferences
    Given I want to customize notifications
    When I access notification settings
    And I adjust my preferences
    Then notifications should follow my settings
    And I should only receive what I opted into

  @activity-notifications
  Scenario: Set notification quiet hours
    Given I don't want notifications at certain times
    When I configure quiet hours
    Then notifications should be suppressed during those times
    And urgent notifications can override if configured
    And notifications should resume after quiet hours

  @activity-notifications
  Scenario: Enable notification bundling
    Given I want fewer, consolidated notifications
    When I enable notification bundling
    Then related activities should be grouped
    And bundle summaries should be clear
    And I should be able to expand bundles

  @activity-notifications
  Scenario: View notification history
    Given I have received notifications
    When I access notification history
    Then I should see all past notifications
    And I should be able to search history
    And notification status should be shown

  @activity-notifications
  Scenario: Snooze notifications
    Given I want to temporarily pause notifications
    When I snooze notifications
    Then notifications should be paused
    And snooze duration should be configurable
    And notifications should resume after snooze

  # --------------------------------------------------------------------------
  # Activity Filtering Scenarios
  # --------------------------------------------------------------------------
  @activity-filtering
  Scenario: Filter activities by type
    Given I want to see specific activity types
    When I select activity type filters
    Then only selected types should display
    And I should be able to select multiple types
    And clear all filters should be available

  @activity-filtering
  Scenario: Filter activities by team
    Given I want to see one team's activities
    When I filter by team
    Then only that team's activities should show
    And all activity types should be included
    And the team filter should be clearly shown

  @activity-filtering
  Scenario: Filter activities by date range
    Given I want to see activities from a specific period
    When I set a date range filter
    Then only activities in that range should show
    And the date range should be adjustable
    And preset ranges should be available

  @activity-filtering
  Scenario: Filter activities by owner
    Given I want to see a specific owner's activities
    When I filter by owner
    Then only that owner's activities should display
    And I should be able to select multiple owners
    And the filter should be clearly indicated

  @activity-filtering
  Scenario: Combine multiple filters
    Given I want to apply complex filtering
    When I combine multiple filter types
    Then activities matching all criteria should show
    And the combined filters should be displayed
    And I should be able to modify each filter

  @activity-filtering
  Scenario: Save filter presets
    Given I frequently use certain filters
    When I save a filter preset
    Then the preset should be stored
    And I should be able to apply it quickly
    And I should be able to manage saved presets

  @activity-filtering
  Scenario: Search within filtered results
    Given I have filtered activities displayed
    When I search within results
    Then matching activities should be highlighted
    And non-matching should be hidden or dimmed
    And search should work with filters

  @activity-filtering
  Scenario: Reset all filters
    Given I have multiple filters applied
    When I reset all filters
    Then all activities should be displayed
    And filter indicators should be cleared
    And the reset should be immediate

  # --------------------------------------------------------------------------
  # Activity Analytics Scenarios
  # --------------------------------------------------------------------------
  @activity-analytics
  Scenario: View most active owners
    Given owner activity is tracked
    When I view active owner rankings
    Then owners should be ranked by activity level
    And activity counts should be displayed
    And trends should be shown

  @activity-analytics
  Scenario: Generate engagement reports
    Given engagement data is collected
    When I generate an engagement report
    Then comprehensive metrics should be shown
    And the report should be exportable
    And insights should be highlighted

  @activity-analytics
  Scenario: View participation trends
    Given participation is tracked over time
    When I view participation trends
    Then trends should be visualized
    And I should see week-over-week changes
    And seasonal patterns should be visible

  @activity-analytics
  Scenario: Analyze activity by day and time
    Given activity timing is tracked
    When I view activity timing analysis
    Then I should see peak activity periods
    And heat maps should display patterns
    And optimal timing insights should be provided

  @activity-analytics
  Scenario: View activity breakdown by type
    Given different activity types are tracked
    When I view activity breakdown
    Then I should see distribution by type
    And comparisons to league norms should show
    And trends by type should be available

  @activity-analytics
  Scenario: Generate league engagement score
    Given overall engagement is measured
    When I view the league engagement score
    Then an aggregate score should be displayed
    And score components should be explained
    And improvement tips should be offered

  @activity-analytics
  Scenario: Compare to previous seasons
    Given historical activity data exists
    When I compare to previous seasons
    Then year-over-year comparisons should show
    And growth or decline should be highlighted
    And contributing factors should be noted

  @activity-analytics
  Scenario: View activity predictions
    Given activity patterns are analyzed
    When I view activity predictions
    Then expected future activity should be shown
    And predictions should be reasonably accurate
    And confidence levels should be indicated

  # --------------------------------------------------------------------------
  # Activity Exports Scenarios
  # --------------------------------------------------------------------------
  @activity-exports
  Scenario: Download activity logs
    Given I want to export activity data
    When I initiate an activity log download
    Then the log should be generated
    And I should be able to choose the format
    And the download should complete successfully

  @activity-exports
  Scenario: Access activity via API
    Given API access is enabled
    When I query the activity API
    Then I should receive activity data
    And the response should be properly formatted
    And rate limiting should be respected

  @activity-exports
  Scenario: Configure webhook integrations
    Given I want real-time activity webhooks
    When I configure a webhook endpoint
    Then activities should be pushed to my endpoint
    And the payload should include relevant data
    And webhook health should be monitored

  @activity-exports
  Scenario: Export filtered activity data
    Given I have filters applied
    When I export the filtered results
    Then only filtered activities should export
    And the filter criteria should be noted
    And the export should be complete

  @activity-exports
  Scenario: Schedule recurring exports
    Given I want regular activity exports
    When I schedule recurring exports
    Then exports should occur on schedule
    And I should be notified of completions
    And exports should be stored appropriately

  @activity-exports
  Scenario: Export activity for date range
    Given I need activity for a specific period
    When I export for a date range
    Then only that period's activities should export
    And the range should be clearly noted
    And all activity types should be included

  @activity-exports
  Scenario: Generate activity summary export
    Given I want a summarized export
    When I generate a summary export
    Then aggregated data should be exported
    And summaries should be clearly formatted
    And detail should be available if needed

  @activity-exports
  Scenario: Export to third-party integrations
    Given third-party integrations are available
    When I export to an integration
    Then data should be sent to the third party
    And the export should be successful
    And confirmation should be provided

  # --------------------------------------------------------------------------
  # Error Handling Scenarios
  # --------------------------------------------------------------------------
  @error-handling
  Scenario: Handle real-time connection loss
    Given I am viewing the real-time activity feed
    And the connection is lost
    When the disconnection occurs
    Then I should see a connection status indicator
    And the feed should pause updates
    And reconnection should be attempted automatically

  @error-handling
  Scenario: Handle activity load failure
    Given I am loading activity data
    And the load fails
    When the error occurs
    Then I should see a clear error message
    And I should be able to retry
    And cached data should be shown if available

  @error-handling
  Scenario: Handle filter application error
    Given I am applying filters
    And the filter query fails
    When the error occurs
    Then I should see an error notification
    And the previous filter state should be preserved
    And I should be able to try again

  @error-handling
  Scenario: Handle notification delivery failure
    Given a notification fails to deliver
    When the failure is detected
    Then the notification should be queued for retry
    And I should be informed if repeated failures occur
    And alternative delivery should be attempted

  @error-handling
  Scenario: Handle export generation failure
    Given I am generating an export
    And the generation fails
    When the error occurs
    Then I should see an error message
    And partial data should be saved if possible
    And I should be able to retry

  @error-handling
  Scenario: Handle webhook delivery failure
    Given a webhook call fails
    When the failure is detected
    Then the webhook should be retried
    And failures should be logged
    And I should be notified of persistent failures

  @error-handling
  Scenario: Handle missing activity data
    Given some activity data is unavailable
    When I try to access it
    Then I should see a clear indication
    And available data should still be shown
    And the issue should be logged

  @error-handling
  Scenario: Handle concurrent activity updates
    Given multiple updates arrive simultaneously
    When the updates are processed
    Then all updates should be displayed correctly
    And order should be maintained
    And no activities should be duplicated

  # --------------------------------------------------------------------------
  # Accessibility Scenarios
  # --------------------------------------------------------------------------
  @accessibility
  Scenario: Navigate activity feed with keyboard
    Given I am on the activity page
    When I navigate using only keyboard
    Then all activities should be accessible
    And focus indicators should be visible
    And I should be able to interact with activities

  @accessibility
  Scenario: Use activity feed with screen reader
    Given I am using a screen reader
    When I access the activity feed
    Then activities should be announced properly
    And new activities should trigger announcements
    And navigation should be clear

  @accessibility
  Scenario: View activity feed in high contrast
    Given I have high contrast mode enabled
    When I view the activity feed
    Then all elements should be clearly visible
    And activity types should be distinguishable
    And timestamps should be readable

  @accessibility
  Scenario: Access activity on mobile device
    Given I am using a mobile device
    When I access the activity feed
    Then all features should be accessible
    And touch interactions should work properly
    And the layout should be responsive

  @accessibility
  Scenario: View activity with text scaling
    Given I have increased text size
    When I view activities
    Then text should scale appropriately
    And layouts should adapt
    And no content should be cut off

  @accessibility
  Scenario: Receive accessible notifications
    Given I receive activity notifications
    When notifications appear
    Then they should be announced to assistive technology
    And they should be visually prominent
    And they should be dismissible via keyboard

  @accessibility
  Scenario: Use activity filters accessibly
    Given I need to filter activities
    When I use filter controls
    Then controls should be keyboard accessible
    And filter states should be announced
    And clear feedback should be provided

  @accessibility
  Scenario: Navigate analytics with reduced motion
    Given I have reduced motion preferences
    When I view activity analytics
    Then charts should minimize animation
    And transitions should be subtle
    And the experience should be complete

  # --------------------------------------------------------------------------
  # Performance Scenarios
  # --------------------------------------------------------------------------
  @performance
  Scenario: Load activity feed quickly
    Given I am accessing the activity feed
    When the page loads
    Then the feed should be usable within 2 seconds
    And recent activities should appear immediately
    And older activities should load on scroll

  @performance
  Scenario: Handle high activity volume
    Given the league has very high activity
    When many activities occur simultaneously
    Then all activities should be captured
    And the feed should remain responsive
    And no activities should be lost

  @performance
  Scenario: Stream real-time updates efficiently
    Given I am viewing real-time updates
    When updates stream continuously
    Then updates should appear with low latency
    And memory usage should remain stable
    And the interface should not slow down

  @performance
  Scenario: Filter large activity datasets
    Given the activity history is extensive
    When I apply filters
    Then filtered results should appear within 2 seconds
    And the interface should remain responsive
    And pagination should be smooth

  @performance
  Scenario: Generate analytics reports efficiently
    Given I am generating activity analytics
    When the report is generated
    Then it should complete within reasonable time
    And progress should be shown
    And the system should remain usable

  @performance
  Scenario: Handle concurrent users viewing activity
    Given many users view activity simultaneously
    When all users access the feed
    Then all should see consistent data
    And performance should not degrade significantly
    And real-time updates should work for all

  @performance
  Scenario: Export large activity datasets
    Given I am exporting extensive activity data
    When the export is generated
    Then it should complete efficiently
    And I should see progress updates
    And the export should be properly formatted

  @performance
  Scenario: Cache frequently accessed activity
    Given I access certain activities repeatedly
    When I return to viewed content
    Then it should load from cache instantly
    And cache should be invalidated appropriately
    And freshness should be maintained
