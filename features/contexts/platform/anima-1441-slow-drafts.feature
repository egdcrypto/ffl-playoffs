@slow-drafts @platform
Feature: Slow Drafts
  As a fantasy football league
  I need comprehensive slow draft functionality
  So that owners can draft players over extended periods with flexible timing

  Background:
    Given the slow draft system is operational
    And slow draft rules are configured

  # ==================== Extended Timer Settings ====================

  @extended-timers @hours-days-per-pick
  Scenario: Configure hours per pick timer
    Given a slow draft is being configured
    When setting the pick timer in hours
    Then hour-based options should be available
      | timer_option | duration  |
      | quick        | 4 hours   |
      | standard     | 8 hours   |
      | relaxed      | 12 hours  |
      | extended     | 24 hours  |

  @extended-timers @hours-days-per-pick
  Scenario: Configure days per pick timer
    Given longer timers are needed
    When setting the pick timer in days
    Then day-based options should be available
    And timers up to 7 days should be supported

  @extended-timers @customizable-limits
  Scenario: Set custom time limits
    Given default options don't fit
    When configuring custom timer
    Then any duration can be specified
    And the custom timer should be saved

  @extended-timers @customizable-limits
  Scenario: Set different timers per round
    Given early rounds need more time
    When configuring round-specific timers
    Then each round can have a different timer
    And transitions should be smooth

  @extended-timers @weekend-weekday-timers
  Scenario: Configure weekend vs weekday timers
    Given availability differs on weekends
    When setting differential timers
    Then weekend timers can be longer
    And weekday timers can be shorter
      | day_type | timer_duration |
      | weekday  | 8 hours        |
      | weekend  | 12 hours       |

  @extended-timers @weekend-weekday-timers
  Scenario: Automatically switch timer types
    Given weekend/weekday timers are configured
    When the day type changes
    Then the appropriate timer should activate
    And transitions should be seamless

  @extended-timers @holiday-pauses
  Scenario: Configure holiday pauses
    Given holidays affect availability
    When setting holiday pauses
    Then specific dates can be designated
    And the draft should pause during holidays

  @extended-timers @holiday-pauses
  Scenario: Resume draft after holiday
    Given a holiday pause is ending
    When the holiday period ends
    Then the draft should automatically resume
    And owners should be notified

  # ==================== Pick Notification System ====================

  @notifications @email-alerts
  Scenario: Send email alerts for pick turn
    Given an owner's turn is approaching
    When their pick is up
    Then an email alert should be sent
    And the email should include pick details

  @notifications @email-alerts
  Scenario: Configure email notification preferences
    Given email preferences are customizable
    When setting preferences
    Then options should include
      | preference          | options                    |
      | on_the_clock        | immediately, 1hr delay     |
      | reminder            | 2hr before, 4hr before     |
      | pick_made           | every pick, my picks only  |

  @notifications @push-notifications
  Scenario: Send push notifications
    Given mobile app is installed
    When the owner's turn arrives
    Then a push notification should be sent
    And the notification should be actionable

  @notifications @push-notifications
  Scenario: Configure push notification settings
    Given push settings are available
    When configuring push alerts
    Then notification types can be toggled
    And quiet hours can be set

  @notifications @pick-reminders
  Scenario: Send pick reminders
    Given time is running out on a pick
    When the reminder threshold is reached
    Then a reminder should be sent
    And urgency should be conveyed

  @notifications @pick-reminders
  Scenario: Configure reminder timing
    Given reminder preferences vary
    When setting reminder timing
    Then multiple reminder options should exist
      | reminder_type     | timing             |
      | first_reminder    | 50% time remaining |
      | urgent_reminder   | 25% time remaining |
      | final_reminder    | 1 hour remaining   |

  @notifications @upcoming-turn-warnings
  Scenario: Warn of upcoming turn
    Given picks are being made
    When an owner's turn is approaching
    Then a warning should be sent
    And estimated time to pick should be included

  @notifications @upcoming-turn-warnings
  Scenario: Calculate time to turn
    Given picks have average duration
    When calculating time to turn
    Then the estimate should be based on history
    And the warning should be appropriately timed

  # ==================== Draft Progress Tracking ====================

  @progress-tracking @current-pick-display
  Scenario: Display current pick information
    Given the draft is in progress
    When viewing the draft
    Then current pick details should be shown
      | detail           | displayed |
      | pick_number      | yes       |
      | round            | yes       |
      | owner_on_clock   | yes       |
      | time_remaining   | yes       |

  @progress-tracking @current-pick-display
  Scenario: Highlight owner on the clock
    Given an owner is on the clock
    When viewing the draft board
    Then that owner should be prominently highlighted
    And their timer should be visible

  @progress-tracking @completion-percentage
  Scenario: Display draft completion percentage
    Given picks are being made
    When viewing draft progress
    Then completion percentage should be shown
    And a progress bar should be visible

  @progress-tracking @completion-percentage
  Scenario: Calculate completion metrics
    Given draft progress is tracked
    When calculating completion
    Then metrics should include
      | metric          | calculation               |
      | percent_complete| picks made / total picks  |
      | rounds_complete | fully completed rounds    |
      | picks_remaining | total - picks made        |

  @progress-tracking @estimated-completion
  Scenario: Estimate draft completion time
    Given picks have a time history
    When estimating completion
    Then projected end date/time should be shown
    And the estimate should update dynamically

  @progress-tracking @estimated-completion
  Scenario: Factor in timer settings for estimate
    Given timer settings affect duration
    When calculating estimates
    Then timer durations should be factored
    And weekend/holiday pauses should be included

  @progress-tracking @pick-history
  Scenario: Display pick history
    Given picks have been made
    When viewing pick history
    Then all picks should be listed
    And timestamps should be included

  @progress-tracking @pick-history
  Scenario: Filter and search pick history
    Given extensive pick history exists
    When filtering history
    Then filters should include team, position, and round
    And search should find specific players

  # ==================== Asynchronous Draft Board ====================

  @async-board @real-time-updates
  Scenario: Update board in real-time
    Given owners are viewing the draft board
    When a pick is made
    Then the board should update immediately
    And no refresh should be required

  @async-board @real-time-updates
  Scenario: Handle connection interruptions
    Given a connection is interrupted
    When connection is restored
    Then the board should sync automatically
    And any missed picks should appear

  @async-board @offline-submission
  Scenario: Submit pick while offline
    Given an owner is temporarily offline
    When they queue a pick
    Then the pick should submit when back online
    And confirmation should be sent

  @async-board @offline-submission
  Scenario: Sync offline picks
    Given picks were queued offline
    When connection is restored
    Then queued picks should sync
    And conflicts should be resolved

  @async-board @status-indicators
  Scenario: Display draft status indicators
    Given the draft has various states
    When viewing the board
    Then status indicators should show
      | status          | indicator        |
      | active          | green - live     |
      | paused          | yellow - paused  |
      | waiting         | blue - waiting   |
      | completed       | gray - done      |

  @async-board @status-indicators
  Scenario: Show owner activity status
    Given owners have varying activity levels
    When viewing the draft
    Then owner status should be indicated
    And last seen time should be shown

  @async-board @last-activity-timestamps
  Scenario: Display last activity timestamps
    Given activity is tracked
    When viewing owner information
    Then last activity time should be shown
    And activity type should be indicated

  @async-board @last-activity-timestamps
  Scenario: Track activity types
    Given various activities occur
    When tracking activity
    Then activity types should include
      | activity_type    | description            |
      | pick_made        | owner made a selection |
      | queue_updated    | owner modified queue   |
      | viewed_board     | owner viewed draft     |
      | sent_message     | owner sent chat message|

  # ==================== Queue Management ====================

  @queue-management @pre-set-queues
  Scenario: Create pre-set pick queue
    Given an owner won't be available
    When setting up their queue
    Then players can be added in priority order
    And the queue should be saved

  @queue-management @pre-set-queues
  Scenario: Manage queue remotely
    Given a queue is set
    When modifying the queue remotely
    Then changes should sync immediately
    And the queue should update

  @queue-management @auto-pick-from-queue
  Scenario: Auto-pick from queue when timer expires
    Given a queue is configured
    When the owner's timer expires
    Then the top available queued player should be picked
    And the owner should be notified

  @queue-management @auto-pick-from-queue
  Scenario: Skip drafted players in queue
    Given queued players may be drafted
    When a queued player is taken
    Then they should be skipped
    And the next available should be used

  @queue-management @queue-reordering
  Scenario: Reorder queue priorities
    Given a queue exists
    When reordering priorities
    Then drag-and-drop should work
    And new order should save immediately

  @queue-management @queue-reordering
  Scenario: Update queue based on draft flow
    Given the draft is progressing
    When evaluating the queue
    Then adjustments should be suggested
    And outdated choices should be flagged

  @queue-management @conditional-picks
  Scenario: Set conditional picks
    Given strategy depends on availability
    When setting conditional picks
    Then conditions can be specified
      | condition            | action                    |
      | if_player_available  | pick specified player     |
      | if_position_needed   | pick best at position     |
      | if_value_threshold   | pick if value exceeds X   |

  @queue-management @conditional-picks
  Scenario: Execute conditional pick
    Given a conditional pick is configured
    When conditions are met
    Then the conditional pick should execute
    And the logic should be logged

  # ==================== Draft Scheduling ====================

  @scheduling @start-date-time
  Scenario: Set draft start date and time
    Given a slow draft is being scheduled
    When setting the start time
    Then date and time should be configurable
    And timezone should be specified

  @scheduling @start-date-time
  Scenario: Notify owners of draft start
    Given the start time approaches
    When the draft is about to begin
    Then all owners should be notified
    And the first pick should be activated

  @scheduling @draft-window-hours
  Scenario: Configure active draft hours
    Given drafts have active windows
    When setting draft hours
    Then active hours can be specified
    And picks should only be required during active hours

  @scheduling @draft-window-hours
  Scenario: Pause timer outside active hours
    Given active hours are configured
    When outside active hours
    Then the timer should pause
    And resume when active hours return

  @scheduling @blackout-periods
  Scenario: Configure blackout periods
    Given certain times should be excluded
    When setting blackout periods
    Then specific dates/times can be blocked
    And the draft should pause during blackouts

  @scheduling @blackout-periods
  Scenario: Handle picks during blackout approach
    Given a blackout is approaching
    When a pick is in progress
    Then the owner should be warned
    And the timer should handle the transition

  @scheduling @pause-resume-controls
  Scenario: Pause the draft
    Given the draft needs to be paused
    When the commissioner pauses
    Then the timer should stop
    And all owners should be notified

  @scheduling @pause-resume-controls
  Scenario: Resume the draft
    Given the draft is paused
    When the commissioner resumes
    Then the timer should restart
    And normal operations should continue

  # ==================== Commissioner Controls ====================

  @commissioner @timer-adjustments
  Scenario: Adjust timer settings mid-draft
    Given timer settings need changing
    When the commissioner adjusts timers
    Then new settings should apply to future picks
    And owners should be notified of changes

  @commissioner @timer-adjustments
  Scenario: Apply timer changes retroactively
    Given current pick needs more time
    When extending the current timer
    Then additional time should be added
    And the countdown should update

  @commissioner @deadline-extensions
  Scenario: Extend pick deadline
    Given an owner needs more time
    When the commissioner extends the deadline
    Then extra time should be added
    And the extension should be logged

  @commissioner @deadline-extensions
  Scenario: Grant time extension request
    Given an owner requests extension
    When the commissioner approves
    Then the extension should be applied
    And both parties should be notified

  @commissioner @draft-resets
  Scenario: Reset draft to earlier point
    Given a reset is needed
    When the commissioner resets
    Then the draft should revert to specified point
    And affected picks should be undone

  @commissioner @draft-resets
  Scenario: Confirm reset action
    Given reset is destructive
    When initiating a reset
    Then confirmation should be required
    And the scope of reset should be displayed

  @commissioner @manual-pick-entry
  Scenario: Make pick for absent owner
    Given an owner is unresponsive
    When the commissioner makes the pick
    Then the pick should be recorded
    And it should be marked as commissioner-entered

  @commissioner @manual-pick-entry
  Scenario: Correct erroneous pick
    Given a pick was made in error
    When the commissioner corrects it
    Then the pick should be updated
    And the correction should be logged

  # ==================== Mobile Draft Experience ====================

  @mobile @mobile-optimized-interface
  Scenario: Access mobile-optimized draft interface
    Given an owner is on mobile
    When accessing the draft
    Then a mobile-friendly interface should load
    And all features should be accessible

  @mobile @mobile-optimized-interface
  Scenario: Navigate draft on mobile
    Given the mobile interface is loaded
    When navigating the draft
    Then navigation should be touch-friendly
    And gestures should be supported

  @mobile @quick-pick-actions
  Scenario: Make quick picks on mobile
    Given it's the owner's turn on mobile
    When making a pick
    Then quick pick options should be available
    And the process should be streamlined

  @mobile @quick-pick-actions
  Scenario: Access pick shortcuts
    Given speed is important
    When viewing pick options
    Then shortcuts should be available
      | shortcut         | action                    |
      | one_tap_pick     | select player directly    |
      | queue_pick       | pick from pre-set queue   |
      | best_available   | auto-select best available|

  @mobile @offline-queue-management
  Scenario: Manage queue while offline
    Given mobile connectivity varies
    When managing queue offline
    Then changes should be cached
    And sync when connected

  @mobile @offline-queue-management
  Scenario: View queue status offline
    Given the owner is offline
    When viewing their queue
    Then cached queue should display
    And last sync time should be shown

  @mobile @instant-notifications
  Scenario: Receive instant mobile notifications
    Given push notifications are enabled
    When draft events occur
    Then notifications should arrive instantly
    And they should be actionable

  @mobile @instant-notifications
  Scenario: Take action from notification
    Given a notification is received
    When interacting with it
    Then draft actions should be possible
    And the full app shouldn't be required

  # ==================== Draft Communication ====================

  @communication @in-draft-messaging
  Scenario: Send messages during draft
    Given the draft is in progress
    When an owner sends a message
    Then the message should appear in chat
    And all participants should see it

  @communication @in-draft-messaging
  Scenario: Use draft chat asynchronously
    Given owners are in different timezones
    When messages are sent
    Then they should persist
    And owners can read when available

  @communication @trade-discussions
  Scenario: Discuss trades during draft
    Given trading is allowed
    When owners discuss trades
    Then trade chat should be available
    And discussions should be private

  @communication @trade-discussions
  Scenario: Propose trade during slow draft
    Given a trade is being discussed
    When a trade proposal is sent
    Then the proposal should be formalized
    And both parties should be notified

  @communication @pick-announcements
  Scenario: Announce picks to league
    Given picks are being made
    When a pick occurs
    Then an announcement should be posted
    And key details should be included

  @communication @pick-announcements
  Scenario: Configure announcement preferences
    Given announcement settings exist
    When configuring preferences
    Then options should include
      | option              | description              |
      | all_picks           | announce every pick      |
      | notable_only        | only significant picks   |
      | my_turns            | only my pick turns       |

  @communication @chat-history
  Scenario: View draft room chat history
    Given messages have been sent
    When viewing chat history
    Then all messages should be accessible
    And they should be timestamped

  @communication @chat-history
  Scenario: Search chat history
    Given extensive chat history exists
    When searching chat
    Then search should find messages
    And context should be displayed

  # ==================== Slow Draft Results ====================

  @draft-results @draft-recap
  Scenario: Generate slow draft recap
    Given the draft has completed
    When viewing the recap
    Then all picks should be summarized
    And the draft journey should be captured

  @draft-results @draft-recap
  Scenario: Display recap timeline
    Given the draft occurred over time
    When viewing the timeline
    Then the draft progression should be visualized
    And key moments should be highlighted

  @draft-results @duration-statistics
  Scenario: Display draft duration statistics
    Given duration data is available
    When viewing statistics
    Then duration metrics should include
      | metric              | value_example      |
      | total_duration      | 5 days 3 hours     |
      | average_pick_time   | 3 hours 15 minutes |
      | fastest_pick        | 12 minutes         |
      | slowest_pick        | 23 hours 58 minutes|

  @draft-results @duration-statistics
  Scenario: Compare to league average duration
    Given league averages exist
    When comparing draft duration
    Then comparison should be shown
    And percentile should be indicated

  @draft-results @timing-analysis
  Scenario: Analyze pick timing patterns
    Given pick timing data exists
    When analyzing timing
    Then patterns should be identified
    And insights should be provided

  @draft-results @timing-analysis
  Scenario: Identify time-of-day patterns
    Given picks occur at various times
    When analyzing time patterns
    Then peak pick times should be identified
    And owner-specific patterns should be shown

  @draft-results @participation-metrics
  Scenario: Display participation metrics
    Given participation varies by owner
    When viewing participation
    Then metrics should include
      | metric              | description                |
      | picks_on_time       | picks before timer expired |
      | queue_usage         | picks from queue           |
      | engagement_score    | overall participation      |
      | response_time_avg   | average time to pick       |

  @draft-results @participation-metrics
  Scenario: Recognize active participants
    Given participation is tracked
    When generating recognition
    Then awards should be given
      | award               | criteria                    |
      | fastest_drafter     | lowest average pick time    |
      | most_engaged        | highest engagement score    |
      | night_owl           | most late-night picks       |
      | early_bird          | most early-morning picks    |
