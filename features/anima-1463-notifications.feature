@backend @priority_1 @notifications @communication
Feature: Comprehensive Notifications System
  As a fantasy football playoffs application
  I want to provide timely and relevant notifications across multiple channels
  So that users stay informed and engaged throughout the playoff competition

  Background:
    Given a league "2025 NFL Playoffs Pool" exists
    And user "john_doe" is a registered member
    And notification services are configured and active

  # ==================== PUSH NOTIFICATIONS ====================

  Scenario: Send push notification for touchdown
    Given john_doe has push notifications enabled
    And john_doe has Patrick Mahomes on their roster
    When Patrick Mahomes scores a touchdown
    Then a push notification is sent:
      | Field       | Value                              |
      | Title       | Mahomes Touchdown!                 |
      | Body        | Patrick Mahomes TD! +6 pts         |
      | Icon        | Football icon                      |
      | Sound       | Score sound                        |
    And notification is delivered within 30 seconds

  Scenario: Send push notification for matchup lead change
    Given john_doe is in an active matchup
    And john_doe was trailing by 5 points
    When john_doe takes the lead
    Then a push notification is sent:
      | Title       | You Took the Lead!                 |
      | Body        | Now ahead by 2.5 pts vs opponent   |
      | Action      | View Matchup                       |

  Scenario: Send push notification for roster lock reminder
    Given roster lock is 1 hour away
    And john_doe has not submitted lineup
    When reminder trigger fires
    Then a push notification is sent:
      | Title       | Roster Locks in 1 Hour!            |
      | Body        | Submit your lineup before 4:25 PM  |
      | Priority    | High                               |
      | Action      | Set Lineup                         |

  Scenario: Send push notification for game start
    Given john_doe has players in the Chiefs vs Dolphins game
    When game kickoff is 30 minutes away
    Then a push notification is sent:
      | Title       | Game Starting Soon                 |
      | Body        | KC vs MIA kicks off in 30 min      |
      | Players     | Mahomes, Kelce, Hill               |

  Scenario: Register device for push notifications
    Given john_doe opens the mobile app
    When john_doe grants push notification permission
    Then device token is registered:
      | Field       | Value                              |
      | Platform    | iOS/Android                        |
      | Token       | Device push token                  |
      | User        | john_doe                           |
    And john_doe can receive push notifications

  Scenario: Handle push notification delivery failure
    Given john_doe's device token is invalid
    When a push notification is sent
    Then delivery fails with "INVALID_TOKEN"
    And token is marked as invalid
    And john_doe is prompted to re-enable notifications

  Scenario: Batch push notifications to prevent spam
    Given 5 scoring events occur in 2 minutes
    When notifications would be sent
    Then notifications are batched:
      | Title       | Multiple Scoring Updates           |
      | Body        | 5 plays! +18.5 total pts           |
      | Summary     | Tap to see details                 |
    And individual notifications are suppressed

  Scenario: Send silent push for background data update
    Given score data needs background refresh
    When silent push is sent
    Then app data updates silently
    And no user-visible notification appears
    And scores are current when app opens

  # ==================== EMAIL NOTIFICATIONS ====================

  Scenario: Send weekly matchup preview email
    Given it is Thursday before Wild Card weekend
    When weekly preview emails are generated
    Then john_doe receives email:
      | Subject     | Wild Card Matchup Preview          |
      | Content     | Your matchup vs opponent_team      |
      | Includes    | Projected scores, key players      |
      | Call to Action | Set Your Lineup                 |

  Scenario: Send matchup result email
    Given Wild Card matchup has completed
    And john_doe won their matchup
    When result emails are sent
    Then john_doe receives email:
      | Subject     | You Won Wild Card!                 |
      | Content     | Final: 165.5 - 148.0              |
      | Includes    | Score breakdown, next opponent     |

  Scenario: Send trade notification email
    Given john_doe receives a trade offer
    When trade is proposed
    Then john_doe receives email:
      | Subject     | New Trade Offer                    |
      | Content     | Team B offers: Josh Allen          |
      | For         | Patrick Mahomes                    |
      | Action      | Review Trade                       |
      | Expiration  | Offer expires in 48 hours          |

  Scenario: Send commissioner announcement email
    Given commissioner posts important announcement
    When announcement is published
    Then all members receive email:
      | Subject     | League Announcement                |
      | From        | commissioner_joe                   |
      | Content     | Playoff rules reminder...          |
      | Priority    | High                               |

  Scenario: Send payment reminder email
    Given payment deadline is approaching
    And john_doe has not paid
    When reminder is triggered
    Then john_doe receives email:
      | Subject     | Payment Reminder                   |
      | Content     | $50 entry fee due by Jan 5         |
      | Late Fee    | $10 after deadline                 |
      | Pay Link    | Secure payment link                |

  Scenario: Send digest email for notification summary
    Given john_doe prefers daily digest
    When daily digest is generated
    Then john_doe receives email:
      | Subject     | Daily Fantasy Digest               |
      | Sections    | Scores, News, Transactions         |
      | Time        | 7:00 AM user local time            |

  Scenario: Handle email unsubscribe
    Given john_doe clicks unsubscribe link
    When unsubscribe is processed
    Then john_doe is removed from:
      | Email Type           | Unsubscribed |
      | Marketing            | Yes          |
      | Digest               | Yes          |
      | Critical alerts      | No (required)|
    And preferences are updated

  Scenario: Validate email delivery
    Given email is sent to john_doe
    When delivery is tracked
    Then status is recorded:
      | Status      | Delivered/Bounced/Opened           |
      | Timestamp   | Delivery time                      |
      | Opens       | Track if opened                    |
      | Clicks      | Track link clicks                  |

  # ==================== IN-APP NOTIFICATIONS ====================

  Scenario: Display in-app notification badge
    Given john_doe has unread notifications
    When john_doe views the app
    Then notification badge shows count:
      | Badge       | 5 unread                           |
      | Location    | Bell icon in header                |
      | Color       | Red indicator                      |

  Scenario: Display notification center
    Given john_doe taps notification bell
    When notification center opens
    Then notifications are displayed:
      | Time        | Type           | Message                    | Read  |
      | 2 min ago   | Score          | Mahomes TD +6 pts          | No    |
      | 1 hour ago  | Trade          | New trade offer            | No    |
      | 3 hours ago | Matchup        | You took the lead          | Yes   |
    And notifications are grouped by type

  Scenario: Mark notification as read
    Given john_doe views a notification
    When notification is opened
    Then notification is marked as read
    And badge count decreases by 1
    And visual styling changes to read state

  Scenario: Mark all notifications as read
    Given john_doe has 10 unread notifications
    When john_doe selects "Mark all as read"
    Then all notifications are marked read
    And badge count becomes 0

  Scenario: Delete notification
    Given john_doe wants to clear a notification
    When john_doe swipes to delete
    Then notification is removed
    And deletion is confirmed
    And notification is archived

  Scenario: Display real-time in-app notification
    Given john_doe is using the app
    When a scoring event occurs
    Then toast notification appears:
      | Position    | Top of screen                      |
      | Duration    | 5 seconds                          |
      | Action      | Tap to view details                |
      | Dismiss     | Swipe or auto-dismiss              |

  Scenario: Display notification with action buttons
    Given trade offer notification is shown
    When notification displays
    Then action buttons are available:
      | Button      | Action                             |
      | Accept      | Accept trade directly              |
      | Decline     | Decline trade                      |
      | View        | Open trade details                 |

  Scenario: Group related notifications
    Given multiple score updates from same game
    When notifications are displayed
    Then they are grouped:
      | Group       | Chiefs vs Dolphins                 |
      | Items       | Mahomes TD, Kelce catch, Hill TD   |
      | Expandable  | Tap to see all                     |

  # ==================== TRANSACTION ALERTS ====================

  Scenario: Send alert for trade offer received
    Given team_b offers trade to john_doe
    When trade is submitted
    Then john_doe receives alert:
      | Type        | Trade Offer                        |
      | From        | team_b                             |
      | Offering    | Josh Allen, 2nd round pick         |
      | Requesting  | Patrick Mahomes                    |
      | Expires     | 48 hours                           |

  Scenario: Send alert for trade accepted
    Given john_doe's trade offer was accepted
    When acceptance is confirmed
    Then john_doe receives alert:
      | Type        | Trade Accepted                     |
      | Message     | Your trade with team_b is complete |
      | Roster      | Updated immediately                |

  Scenario: Send alert for trade rejected
    Given john_doe's trade offer was rejected
    When rejection is processed
    Then john_doe receives alert:
      | Type        | Trade Declined                     |
      | Message     | team_b declined your offer         |
      | Option      | Modify and resend                  |

  Scenario: Send alert for trade vetoed
    Given a trade was vetoed by commissioner
    When veto is processed
    Then both parties receive alert:
      | Type        | Trade Vetoed                       |
      | Reason      | Commissioner determined unfair     |
      | Appeal      | Contact commissioner               |

  Scenario: Send alert for waiver claim result
    Given john_doe submitted waiver claim
    When waivers process
    Then john_doe receives alert:
      | Type        | Waiver Results                     |
      | Claimed     | Rashee Rice - Successful           |
      | Failed      | Jaylen Warren - Outbid             |
      | Budget      | $85 FAAB remaining                 |

  Scenario: Send alert for player added
    Given john_doe adds a free agent
    When add is processed
    Then john_doe receives confirmation:
      | Type        | Player Added                       |
      | Player      | Tank Dell                          |
      | Roster      | Now at 15/15 players               |

  Scenario: Send alert for player dropped
    Given john_doe drops a player
    When drop is processed
    Then john_doe receives confirmation:
      | Type        | Player Dropped                     |
      | Player      | Stefon Diggs                       |
      | Waiver      | Available in 24 hours              |

  # ==================== GAME ALERTS ====================

  Scenario: Send game start alert
    Given john_doe has roster players in upcoming game
    When game starts
    Then john_doe receives alert:
      | Type        | Game Started                       |
      | Game        | Chiefs vs Dolphins                 |
      | Your Players| Mahomes, Kelce, Hill               |
      | Live Link   | Watch live scores                  |

  Scenario: Send halftime score update
    Given game reaches halftime
    When halftime triggers
    Then john_doe receives alert:
      | Type        | Halftime Update                    |
      | Game        | KC 21 - MIA 14                     |
      | Your Points | 28.5 from this game                |

  Scenario: Send game final alert
    Given game has ended
    When final whistle blows
    Then john_doe receives alert:
      | Type        | Game Final                         |
      | Game        | KC 35 - MIA 24                     |
      | Final Points| 52.5 from this game                |
      | Status      | Scores are now FINAL               |

  Scenario: Send big play alert
    Given john_doe has big play alerts enabled
    When roster player scores 40+ yard TD
    Then john_doe receives alert:
      | Type        | Big Play!                          |
      | Player      | Tyreek Hill                        |
      | Play        | 65-yard TD reception               |
      | Points      | +12.5 points                       |

  Scenario: Send injury alert during game
    Given john_doe's player is injured in game
    When injury is reported
    Then john_doe receives alert:
      | Type        | Injury Alert                       |
      | Player      | Travis Kelce                       |
      | Status      | Questionable - Knee                |
      | Update      | Being evaluated                    |
      | Priority    | High                               |

  Scenario: Send overtime alert
    Given game goes to overtime
    When OT begins
    Then john_doe receives alert:
      | Type        | Overtime!                          |
      | Game        | KC vs MIA going to OT              |
      | Your Players| Still active, more points possible |

  Scenario: Send weather delay alert
    Given game is delayed
    When delay is announced
    Then john_doe receives alert:
      | Type        | Game Delay                         |
      | Game        | KC vs MIA                          |
      | Reason      | Weather - Lightning                |
      | New Time    | TBD                                |

  # ==================== LEAGUE ALERTS ====================

  Scenario: Send commissioner announcement alert
    Given commissioner posts announcement
    When announcement is published
    Then all members receive alert:
      | Type        | Commissioner Update                |
      | From        | commissioner_joe                   |
      | Title       | Playoff Rules Reminder             |
      | Priority    | Based on announcement setting      |

  Scenario: Send league standings update
    Given weekly scoring is complete
    When standings update
    Then members receive alert:
      | Type        | Standings Update                   |
      | Your Rank   | 3rd place                          |
      | Movement    | Up 2 spots                         |
      | Next        | Divisional matchup preview         |

  Scenario: Send playoff bracket update
    Given round has completed
    When bracket advances
    Then members receive alert:
      | Type        | Bracket Update                     |
      | Round       | Wild Card Complete                 |
      | Your Status | Advanced to Divisional             |
      | Next Opponent| Bills Mafia                       |

  Scenario: Send deadline reminder
    Given trade deadline is approaching
    When 24 hours remain
    Then members receive alert:
      | Type        | Deadline Reminder                  |
      | Deadline    | Trade deadline in 24 hours         |
      | Action      | Complete pending trades            |

  Scenario: Send prize payout notification
    Given season has concluded
    When prizes are distributed
    Then winners receive alert:
      | Type        | Prize Awarded                      |
      | Amount      | $400                               |
      | Reason      | League Champion                    |
      | Payout      | Via League Safe                    |

  Scenario: Send member joined notification
    Given new member joins league
    When join is confirmed
    Then members receive alert:
      | Type        | New Member                         |
      | Member      | new_user has joined                |
      | Team Name   | The Newcomers                      |

  Scenario: Send rule change notification
    Given commissioner changes a rule
    When change is published
    Then members receive alert:
      | Type        | Rule Change                        |
      | Change      | Trade deadline extended            |
      | Effective   | Immediately                        |
      | Details     | Link to full rules                 |

  # ==================== PLAYER ALERTS ====================

  Scenario: Send player injury status change
    Given john_doe has Travis Kelce on roster
    When Kelce's status changes to "Out"
    Then john_doe receives alert:
      | Type        | Injury Update                      |
      | Player      | Travis Kelce                       |
      | Previous    | Questionable                       |
      | Current     | Out                                |
      | Impact      | Find replacement TE                |

  Scenario: Send player news alert
    Given john_doe follows player news
    When significant news breaks for roster player
    Then john_doe receives alert:
      | Type        | Player News                        |
      | Player      | Patrick Mahomes                    |
      | Headline    | Mahomes practicing in full         |
      | Fantasy Impact| Positive - full workload expected|

  Scenario: Send projection change alert
    Given john_doe has projection alerts enabled
    When player projection changes significantly
    Then john_doe receives alert:
      | Type        | Projection Update                  |
      | Player      | Tyreek Hill                        |
      | Previous    | 18.5 points                        |
      | New         | 14.0 points                        |
      | Reason      | Tough CB matchup                   |

  Scenario: Send player activation alert
    Given john_doe has player on IR
    When player is activated
    Then john_doe receives alert:
      | Type        | Player Activated                   |
      | Player      | Davante Adams                      |
      | Status      | Active - Ready to play             |
      | Action      | Move to active roster              |

  Scenario: Send watchlist player alert
    Given john_doe has players on watchlist
    When watchlist player is added by another team
    Then john_doe receives alert:
      | Type        | Watchlist Alert                    |
      | Player      | Rashee Rice                        |
      | Event       | Added by team_c                    |
      | Action      | Player no longer available         |

  Scenario: Send practice report alert
    Given practice reports are released
    When roster player's status is updated
    Then john_doe receives alert:
      | Type        | Practice Report                    |
      | Player      | Travis Kelce                       |
      | Wednesday   | Limited                            |
      | Projection  | Likely to play                     |

  # ==================== NOTIFICATION PREFERENCES ====================

  Scenario: Configure notification channel preferences
    Given john_doe accesses notification settings
    When john_doe configures preferences:
      | Notification Type    | Push  | Email | In-App |
      | Score updates        | Yes   | No    | Yes    |
      | Trade offers         | Yes   | Yes   | Yes    |
      | Injury alerts        | Yes   | Yes   | Yes    |
      | Commissioner updates | Yes   | Yes   | Yes    |
      | League chat          | No    | No    | Yes    |
    Then preferences are saved
    And notifications respect settings

  Scenario: Configure notification frequency
    Given john_doe wants less frequent updates
    When john_doe sets frequency:
      | Setting              | Value              |
      | Score updates        | Batch every 15 min |
      | Trade notifications  | Immediate          |
      | Daily digest         | Yes, 7 AM          |
    Then notifications are batched per setting

  Scenario: Configure quiet hours
    Given john_doe sets quiet hours
    When john_doe configures:
      | Setting              | Value              |
      | Quiet hours start    | 11:00 PM           |
      | Quiet hours end      | 7:00 AM            |
      | Timezone             | America/New_York   |
      | Emergency override   | Yes                |
    Then notifications are held during quiet hours
    And delivered after quiet hours end

  Scenario: Configure game day preferences
    Given game day has different needs
    When john_doe sets game day preferences:
      | Setting              | Value              |
      | During games         | All alerts enabled |
      | Score threshold      | 5+ points          |
      | Milestone alerts     | 100+ yards, TDs    |
    Then game day alerts are more frequent

  Scenario: Mute notifications temporarily
    Given john_doe needs focus time
    When john_doe mutes for 2 hours
    Then all non-critical notifications are held
    And countdown shows mute duration
    And notifications resume after 2 hours

  Scenario: Configure per-player alert preferences
    Given john_doe has player-specific needs
    When john_doe sets player preferences:
      | Player          | Injury | News  | Score |
      | Patrick Mahomes | Yes    | Yes   | Yes   |
      | Backup RB       | Yes    | No    | No    |
    Then alerts follow player-specific settings

  Scenario: Sync preferences across devices
    Given john_doe uses multiple devices
    When preferences are changed on one device
    Then preferences sync to all devices
    And same notification behavior everywhere

  # ==================== NOTIFICATION HISTORY ====================

  Scenario: View notification history
    Given john_doe wants to review past notifications
    When john_doe accesses notification history
    Then history displays:
      | Time        | Type           | Message                    | Status |
      | 2 min ago   | Score          | Mahomes TD +6 pts          | Read   |
      | 1 hour ago  | Trade          | New trade offer            | Read   |
      | Yesterday   | Matchup        | You won Wild Card!         | Read   |
    And history is paginated

  Scenario: Search notification history
    Given john_doe searches for specific notification
    When john_doe searches "trade"
    Then matching notifications are shown
    And results highlight search term
    And date range filter is available

  Scenario: Filter notification history
    Given john_doe wants specific types
    When john_doe filters by:
      | Filter       | Value              |
      | Type         | Transactions       |
      | Date range   | Last 7 days        |
      | Read status  | Unread only        |
    Then filtered results are displayed

  Scenario: Export notification history
    Given john_doe needs notification records
    When john_doe exports history
    Then export includes:
      | Field        | Included           |
      | Timestamp    | Yes                |
      | Type         | Yes                |
      | Message      | Yes                |
      | Delivery     | Yes                |
    And export formats: CSV, JSON

  Scenario: View notification delivery status
    Given john_doe checks delivery status
    When viewing notification details
    Then status shows:
      | Channel      | Status             |
      | Push         | Delivered          |
      | Email        | Opened             |
      | In-App       | Read               |

  Scenario: Retain notification history
    Given retention policy is configured
    When notifications age
    Then retention rules apply:
      | Age          | Action             |
      | < 30 days    | Retain full        |
      | 30-90 days   | Archive            |
      | > 90 days    | Delete             |

  Scenario: Recover deleted notification
    Given john_doe accidentally deleted notification
    When deletion was within 24 hours
    Then notification can be recovered
    And recovery option is shown
    And notification returns to history

  # ==================== SMART NOTIFICATIONS ====================

  Scenario: Prioritize notifications by importance
    Given multiple notifications are pending
    When notifications are queued
    Then priority order is:
      | Priority     | Examples                         |
      | Critical     | Roster lock, game start          |
      | High         | Injury, score milestone          |
      | Normal       | Score updates, news              |
      | Low          | Chat messages, minor updates     |

  Scenario: Deduplicate similar notifications
    Given multiple similar events occur
    When player scores 3 TDs in 10 minutes
    Then notifications are consolidated:
      | Original     | 3 separate TD notifications      |
      | Consolidated | Mahomes 3 TDs! +18 pts           |
    And redundancy is avoided

  Scenario: Context-aware notification timing
    Given notification context is analyzed
    When timing is optimized
    Then notifications consider:
      | Context      | Timing                           |
      | Game in progress | Immediate                     |
      | User in app  | Toast instead of push            |
      | Quiet hours  | Hold for morning                 |
      | High activity| Batch together                   |

  Scenario: Personalize notification content
    Given user engagement is tracked
    When notification is generated
    Then content is personalized:
      | Element      | Personalization                  |
      | Tone         | Match user preference            |
      | Detail level | Based on engagement              |
      | Emojis       | User preference                  |
      | Actions      | Most used actions first          |

  Scenario: Predict notification value
    Given engagement data is analyzed
    When notification would be sent
    Then value is predicted:
      | High Value   | Send immediately                 |
      | Medium Value | Include in batch                 |
      | Low Value    | Include in digest or skip        |
    And engagement improves over time

  Scenario: Adapt to user behavior
    Given user dismisses certain notifications
    When pattern is detected
    Then system adapts:
      | Pattern               | Adaptation                    |
      | Always dismiss chat   | Reduce chat notifications     |
      | Always open trades    | Prioritize trade alerts       |
      | Ignore during games   | Batch non-critical            |

  Scenario: Smart game day alerts
    Given it is game day
    When john_doe's matchup is close
    Then alert frequency increases
    And alerts include:
      | Alert Type           | When                          |
      | Big play             | Immediately                   |
      | Lead change          | Immediately                   |
      | Score milestone      | Every 25 points               |
      | Matchup clinched     | When mathematically certain   |

  Scenario: Notification effectiveness tracking
    Given notifications are sent
    When effectiveness is measured
    Then metrics are tracked:
      | Metric               | Measurement                   |
      | Open rate            | % of notifications opened     |
      | Action rate          | % leading to app action       |
      | Opt-out rate         | % of users disabling          |
      | Time to action       | Seconds until user acts       |
    And low-performing notifications are improved

  Scenario: A/B test notification content
    Given notification optimization is active
    When new notification format is tested
    Then A/B test runs:
      | Variant A            | Variant B                     |
      | "Mahomes TD!"        | "Patrick Mahomes Touchdown!"  |
      | Short message        | Detailed message              |
    And winner becomes default

  Scenario: Cross-platform notification sync
    Given john_doe uses mobile and web
    When notification is sent
    Then it appears on active device
    And reading on one marks read everywhere
    And duplicate delivery is prevented
