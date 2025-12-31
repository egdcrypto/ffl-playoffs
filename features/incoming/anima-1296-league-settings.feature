@league-settings @configuration
Feature: League Settings
  As a league commissioner
  I want to configure my league settings
  So that I can customize the fantasy football experience for my league

  Background:
    Given I am logged in as the league commissioner
    And the league "Playoff Champions" exists

  # ============================================================================
  # SCORING RULES
  # ============================================================================

  @happy-path @scoring
  Scenario: View current scoring rules
    When I view the league scoring settings
    Then I should see all scoring categories:
      | Category            | Points |
      | Passing Yard        | 0.04   |
      | Passing TD          | 4      |
      | Interception        | -2     |
      | Rushing Yard        | 0.1    |
      | Rushing TD          | 6      |
      | Reception           | 1      |
      | Receiving Yard      | 0.1    |
      | Receiving TD        | 6      |

  @happy-path @scoring
  Scenario: Configure PPR scoring
    Given the league uses standard scoring
    When I enable PPR (Points Per Reception)
    And I set reception points to 1.0
    Then receptions should be worth 1.0 points
    And all team projections should update

  @happy-path @scoring
  Scenario: Configure half-PPR scoring
    When I set reception points to 0.5
    Then the league should use half-PPR scoring
    And I should see "Half-PPR" in the scoring summary

  @happy-path @scoring
  Scenario: Configure passing touchdown points
    When I change passing TD points from 4 to 6
    Then passing touchdowns should be worth 6 points
    And I should see a warning about QB value increase

  @happy-path @scoring
  Scenario: Configure defensive scoring
    When I view defensive scoring settings
    Then I should be able to set points for:
      | Category        | Default Points |
      | Sack            | 1              |
      | Interception    | 2              |
      | Fumble Recovery | 2              |
      | Defensive TD    | 6              |
      | Safety          | 2              |
      | Points Allowed  | Variable       |

  @happy-path @scoring
  Scenario: Configure points allowed tiers
    When I configure points allowed scoring
    Then I should set tiers:
      | Points Allowed | Fantasy Points |
      | 0              | 10             |
      | 1-6            | 7              |
      | 7-13           | 4              |
      | 14-20          | 1              |
      | 21-27          | 0              |
      | 28-34          | -1             |
      | 35+            | -4             |

  @happy-path @scoring
  Scenario: Configure kicker scoring
    When I view kicker scoring settings
    Then I should be able to set:
      | Field Goal Distance | Points |
      | 0-39 yards          | 3      |
      | 40-49 yards         | 4      |
      | 50+ yards           | 5      |
      | Extra Point         | 1      |
      | Missed FG           | -1     |

  # ============================================================================
  # ROSTER POSITIONS
  # ============================================================================

  @happy-path @roster
  Scenario: View roster position settings
    When I view roster settings
    Then I should see position requirements:
      | Position  | Starters | Bench |
      | QB        | 1        | -     |
      | RB        | 2        | -     |
      | WR        | 2        | -     |
      | TE        | 1        | -     |
      | FLEX      | 1        | -     |
      | K         | 1        | -     |
      | DEF       | 1        | -     |
      | Bench     | -        | 6     |

  @happy-path @roster
  Scenario: Add superflex position
    When I add a SUPERFLEX position to the starting lineup
    Then the lineup should require an additional starter
    And SUPERFLEX should accept QB, RB, WR, or TE

  @happy-path @roster
  Scenario: Configure bench size
    When I change bench size from 6 to 8
    Then teams should be able to roster 8 bench players
    And existing rosters should have 2 additional open spots

  @happy-path @roster
  Scenario: Add IR slots
    When I add 2 IR slots to the league
    Then teams should have 2 IR positions available
    And only IR-eligible players should be placeable in IR

  @happy-path @roster
  Scenario: Configure position limits
    When I set position limits:
      | Position | Maximum |
      | QB       | 3       |
      | RB       | 6       |
      | WR       | 6       |
      | TE       | 3       |
      | K        | 2       |
      | DEF      | 2       |
    Then teams cannot exceed these position limits

  @happy-path @roster
  Scenario: Add taxi squad slots
    Given this is a dynasty league
    When I enable taxi squad with 4 slots
    Then teams should have 4 taxi squad positions
    And I should configure taxi squad eligibility rules

  @validation @roster
  Scenario: Cannot reduce roster below current player count
    Given all teams have 16 players rostered
    When I attempt to reduce max roster to 14
    Then I should see "Cannot reduce - teams have more players"
    And the change should be blocked

  # ============================================================================
  # PLAYOFF FORMAT
  # ============================================================================

  @happy-path @playoffs
  Scenario: Configure playoff teams count
    When I set playoff teams to 6
    Then 6 teams should qualify for playoffs
    And I should see the updated bracket structure

  @happy-path @playoffs
  Scenario: Configure playoff weeks
    When I configure playoff schedule:
      | Round       | Week    |
      | Wild Card   | Week 15 |
      | Semifinals  | Week 16 |
      | Championship| Week 17 |
    Then the playoff schedule should be set
    And regular season should end Week 14

  @happy-path @playoffs
  Scenario: Configure bye weeks for top seeds
    When I enable playoff byes for top 2 seeds
    Then seeds 1 and 2 should skip Wild Card round
    And they should enter in Semifinals

  @happy-path @playoffs
  Scenario: Configure consolation bracket
    When I enable consolation bracket
    And I set consolation prize for winner
    Then non-playoff teams should compete in consolation
    And consolation winner should receive the prize

  @happy-path @playoffs
  Scenario: Configure two-week playoff matchups
    When I enable 2-week playoff matchups
    Then each playoff round should span 2 weeks
    And combined scores should determine winners

  @happy-path @playoffs
  Scenario: Configure playoff seeding tiebreakers
    When I set playoff seeding tiebreakers:
      | Priority | Tiebreaker           |
      | 1        | Head-to-Head Record  |
      | 2        | Total Points For     |
      | 3        | Points Against       |
    Then ties should be broken in this order

  @happy-path @playoffs
  Scenario: Configure toilet bowl bracket
    When I enable "Toilet Bowl" for last place
    Then bottom teams should compete to avoid last place
    And last place should receive designated punishment

  # ============================================================================
  # TRADE SETTINGS
  # ============================================================================

  @happy-path @trade
  Scenario: Configure trade deadline
    When I set trade deadline to Week 11
    Then trades should be blocked after Week 11
    And members should see the deadline prominently

  @happy-path @trade
  Scenario: Configure trade review period
    When I set trade review period to 24 hours
    Then trades should be pending for 24 hours before processing
    And league members should be able to review during this period

  @happy-path @trade
  Scenario: Configure trade approval method
    When I set trade approval to "Commissioner Approval"
    Then all trades should require commissioner approval
    And I should receive notifications for pending trades

  @happy-path @trade
  Scenario: Enable league vote for trades
    When I set trade approval to "League Vote"
    And I set required votes to veto at 4
    Then trades should require 4 veto votes to be blocked
    And league members should be able to vote on trades

  @happy-path @trade
  Scenario: Disable trades entirely
    When I disable trading for the league
    Then no trade offers should be allowed
    And trade menu should be hidden from members

  @happy-path @trade
  Scenario: Allow trades during playoffs
    When I enable playoff trading
    Then trades should be allowed during playoff weeks
    And only active playoff teams can trade

  @happy-path @trade
  Scenario: Configure draft pick trading
    Given this is a keeper/dynasty league
    When I enable draft pick trading
    And I allow trading picks up to 3 years in advance
    Then future draft picks should be tradeable
    And pick tracking should be enabled

  # ============================================================================
  # WAIVER RULES
  # ============================================================================

  @happy-path @waiver
  Scenario: Configure waiver type
    When I set waiver type to "FAAB"
    And I set FAAB budget to $100
    Then all teams should have $100 FAAB
    And blind bidding should be enabled

  @happy-path @waiver
  Scenario: Configure waiver priority
    When I set waiver priority to "Reverse Standings"
    Then worst-record team should have first priority
    And priority should update weekly based on standings

  @happy-path @waiver
  Scenario: Configure waiver processing schedule
    When I set waiver processing to:
      | Day       | Time        |
      | Wednesday | 12:00 AM ET |
      | Saturday  | 12:00 AM ET |
    Then waivers should process on these days
    And members should see processing countdown

  @happy-path @waiver
  Scenario: Configure waiver period for dropped players
    When I set waiver period to 2 days
    Then dropped players should be on waivers for 2 days
    And the period should start from drop time

  @happy-path @waiver
  Scenario: Enable continuous waivers
    When I enable continuous waivers
    Then claims should process immediately
    And no waiver period should be required

  @happy-path @waiver
  Scenario: Configure FAAB minimum bid
    Given the league uses FAAB
    When I set minimum bid to $0
    Then $0 bids should be allowed
    And free agent pickups should be possible

  # ============================================================================
  # DRAFT SETTINGS
  # ============================================================================

  @happy-path @draft
  Scenario: Configure draft type
    When I set draft type to "Snake"
    Then draft order should reverse each round
    And I should see snake draft visualization

  @happy-path @draft
  Scenario: Configure auction draft
    When I set draft type to "Auction"
    And I set auction budget to $200
    Then all teams should have $200 budget
    And auction interface should be enabled

  @happy-path @draft
  Scenario: Configure draft date and time
    When I schedule draft for "September 1, 2024 7:00 PM ET"
    Then the draft should be scheduled
    And all members should receive calendar invites

  @happy-path @draft
  Scenario: Configure pick time limit
    When I set pick time limit to 90 seconds
    Then each pick should have 90 second timer
    And auto-pick should trigger when time expires

  @happy-path @draft
  Scenario: Configure keeper settings
    Given this is a keeper league
    When I configure keeper rules:
      | Setting              | Value |
      | Max Keepers          | 3     |
      | Keeper Cost          | Round drafted - 1 |
      | Years to Keep        | 3     |
    Then keeper rules should be applied to draft

  @happy-path @draft
  Scenario: Configure draft order
    When I set draft order to "Randomized"
    And I set randomization date to 1 day before draft
    Then draft order should randomize automatically
    And all members should be notified of their position

  @happy-path @draft
  Scenario: Configure slow draft
    When I enable slow draft mode
    And I set pick window to 8 hours
    Then each team should have 8 hours per pick
    And draft should span multiple days

  # ============================================================================
  # PRIVACY OPTIONS
  # ============================================================================

  @happy-path @privacy
  Scenario: Configure league visibility
    When I set league visibility to "Private"
    Then the league should not appear in public searches
    And only invited members can view league details

  @happy-path @privacy
  Scenario: Configure public league
    When I set league visibility to "Public"
    Then the league should appear in league searches
    And non-members can view standings and rosters

  @happy-path @privacy
  Scenario: Hide league from platform search
    When I disable "Show in League Directory"
    Then the league should be unlisted
    And only direct links should access the league

  @happy-path @privacy
  Scenario: Configure roster visibility
    When I set roster visibility to "League Members Only"
    Then only league members can see team rosters
    And public visitors should see limited information

  @happy-path @privacy
  Scenario: Configure transaction visibility
    When I set transaction history to "Delayed 24 Hours"
    Then transactions should be hidden for 24 hours
    And this should apply to waiver claims and trades

  # ============================================================================
  # INVITATION CONTROLS
  # ============================================================================

  @happy-path @invitations
  Scenario: Generate league invitation link
    When I generate an invitation link
    Then I should receive a unique shareable link
    And the link should have configurable expiration

  @happy-path @invitations
  Scenario: Invite members via email
    When I send invitations to:
      | Email                    |
      | member1@example.com      |
      | member2@example.com      |
    Then invitation emails should be sent
    And I should see pending invitation status

  @happy-path @invitations
  Scenario: Configure invitation approval
    When I require commissioner approval for new members
    Then join requests should require my approval
    And I should receive notifications for requests

  @happy-path @invitations
  Scenario: Set maximum league size
    When I set maximum members to 12
    And we have 12 members
    Then new invitations should be blocked
    And I should see "League is full"

  @happy-path @invitations
  Scenario: Revoke pending invitation
    Given I have a pending invitation for "member@example.com"
    When I revoke the invitation
    Then the invitation link should be invalidated
    And the email recipient should not be able to join

  @happy-path @invitations
  Scenario: Enable open registration
    When I enable open registration
    Then anyone with the league link can join
    And no approval should be required

  # ============================================================================
  # COMMISSIONER PERMISSIONS
  # ============================================================================

  @happy-path @permissions
  Scenario: Add co-commissioner
    When I add "John Smith" as co-commissioner
    Then "John Smith" should have commissioner privileges
    And "John Smith" should be able to modify league settings

  @happy-path @permissions
  Scenario: Remove co-commissioner
    Given "John Smith" is a co-commissioner
    When I remove commissioner privileges from "John Smith"
    Then "John Smith" should become a regular member
    And "John Smith" should lose access to settings

  @happy-path @permissions
  Scenario: View commissioner action log
    When I view the commissioner audit log
    Then I should see all commissioner actions:
      | Action                 | Commissioner | Date       |
      | Changed scoring rules  | Me           | 2024-08-15 |
      | Approved trade         | John Smith   | 2024-08-14 |
      | Added member           | Me           | 2024-08-10 |

  @happy-path @permissions
  Scenario: Commissioner roster edit
    When I edit a team's roster as commissioner
    Then the change should be applied
    And an audit log entry should be created
    And the team owner should be notified

  @happy-path @permissions
  Scenario: Commissioner score adjustment
    When I adjust a team's score for a week
    And I provide a reason for the adjustment
    Then the score should be updated
    And the adjustment should be visible in the audit log

  @validation @permissions
  Scenario: Cannot remove only commissioner
    Given I am the only commissioner
    When I attempt to remove myself as commissioner
    Then I should see "Must assign another commissioner first"
    And my privileges should remain

  # ============================================================================
  # SCHEDULING
  # ============================================================================

  @happy-path @scheduling
  Scenario: Configure regular season length
    When I set regular season to 14 weeks
    Then 14 weeks of matchups should be generated
    And playoff weeks should follow

  @happy-path @scheduling
  Scenario: Configure matchup schedule
    When I set schedule type to "Balanced"
    Then each team should play divisional opponents twice
    And non-divisional opponents once

  @happy-path @scheduling
  Scenario: View full season schedule
    When I view the season schedule
    Then I should see all weekly matchups
    And I should be able to navigate by week

  @happy-path @scheduling
  Scenario: Regenerate schedule
    Given the schedule has been generated
    When I regenerate the schedule
    Then a new randomized schedule should be created
    And all members should be notified

  @happy-path @scheduling
  Scenario: Configure rivalry weeks
    When I designate Week 10 as "Rivalry Week"
    And I set specific matchups for rivalries
    Then Week 10 should use custom matchups
    And those matchups should override normal schedule

  @happy-path @scheduling
  Scenario: Handle bye week considerations
    When I enable "NFL bye week balancing"
    Then the schedule should consider NFL bye weeks
    And teams should face balanced bye week disadvantages

  # ============================================================================
  # DIVISIONS
  # ============================================================================

  @happy-path @divisions
  Scenario: Create divisions
    When I create divisions:
      | Division Name | Teams                              |
      | East          | Team A, Team B, Team C             |
      | West          | Team D, Team E, Team F             |
    Then the league should have 2 divisions
    And standings should show divisional groupings

  @happy-path @divisions
  Scenario: Configure division winners in playoffs
    When I guarantee division winners a playoff spot
    Then each division winner should automatically qualify
    And remaining spots should go to best records

  @happy-path @divisions
  Scenario: Move team between divisions
    Given "Team A" is in "East" division
    When I move "Team A" to "West" division
    Then "Team A" should appear in "West" standings
    And the schedule should update accordingly

  @happy-path @divisions
  Scenario: Delete a division
    Given the league has 2 divisions
    When I delete the "West" division
    Then all teams should be in a single division
    And the schedule should regenerate

  @happy-path @divisions
  Scenario: View division standings
    When I view standings
    Then I should see teams grouped by division
    And I should see overall league standings

  # ============================================================================
  # CUSTOM SCORING
  # ============================================================================

  @happy-path @custom-scoring
  Scenario: Add custom scoring category
    When I add a custom scoring category:
      | Name               | Points | Description              |
      | 40+ Yard TD        | 2      | Bonus for long TDs       |
      | 100+ Rushing Yards | 3      | Bonus for 100+ yard game |
    Then these bonuses should be added to scoring
    And they should apply to all relevant plays

  @happy-path @custom-scoring
  Scenario: Configure passing yard thresholds
    When I add passing bonuses:
      | Threshold | Bonus Points |
      | 300 yards | 2            |
      | 400 yards | 4            |
    Then QBs reaching thresholds should receive bonuses

  @happy-path @custom-scoring
  Scenario: Configure fractional scoring
    When I enable fractional scoring
    Then partial yards should count toward points
    And 53 rushing yards should earn 5.3 points

  @happy-path @custom-scoring
  Scenario: Configure negative scoring categories
    When I add negative scoring:
      | Category      | Points |
      | Fumble Lost   | -2     |
      | Interception  | -2     |
      | Missed FG     | -1     |
    Then these plays should deduct points

  @happy-path @custom-scoring
  Scenario: Preview scoring impact
    Given I have made scoring changes
    When I preview the scoring impact
    Then I should see how last week's scores would change
    And I should see top affected players

  @happy-path @custom-scoring
  Scenario: Copy scoring from another league
    Given I have access to another league's settings
    When I import scoring settings from that league
    Then all scoring categories should be copied
    And I should review before applying

  # ============================================================================
  # SETTING VALIDATION
  # ============================================================================

  @validation @settings
  Scenario: Validate roster positions total starters
    When I configure roster with 15 starting positions
    Then I should see a warning about excessive starters
    And I should be prompted to confirm

  @validation @settings
  Scenario: Validate playoff teams don't exceed league size
    Given the league has 10 teams
    When I attempt to set playoff teams to 12
    Then I should see "Playoff teams cannot exceed league size"
    And the setting should not be saved

  @validation @settings
  Scenario: Validate draft date is in the future
    When I attempt to set draft date to yesterday
    Then I should see "Draft date must be in the future"
    And the setting should not be saved

  @validation @settings
  Scenario: Validate scoring rules are numeric
    When I attempt to enter "ten" for passing TD points
    Then I should see "Please enter a valid number"
    And the field should reject the input

  @validation @settings
  Scenario: Validate FAAB budget is positive
    When I attempt to set FAAB budget to -50
    Then I should see "Budget must be positive"
    And the setting should not be saved

  @validation @settings
  Scenario: Warn about mid-season setting changes
    Given the season is in Week 5
    When I attempt to change scoring rules
    Then I should see a warning about mid-season changes
    And I should confirm "Apply retroactively" or "Apply from now"

  # ============================================================================
  # SETTINGS HISTORY
  # ============================================================================

  @happy-path @history
  Scenario: View settings change history
    When I view settings history
    Then I should see all past setting changes:
      | Setting           | Old Value | New Value | Changed By | Date       |
      | PPR Points        | 0         | 1         | Me         | 2024-08-15 |
      | Playoff Teams     | 4         | 6         | Me         | 2024-08-10 |
      | Trade Deadline    | Week 10   | Week 11   | Co-Commish | 2024-08-05 |

  @happy-path @history
  Scenario: Revert to previous settings
    Given I made a scoring change that was unpopular
    When I select to revert to previous settings
    Then the old settings should be restored
    And a reversion entry should be logged

  @happy-path @history
  Scenario: Export settings configuration
    When I export league settings
    Then I should receive a JSON file with all settings
    And I should be able to import to another league

  @happy-path @history
  Scenario: Compare settings between seasons
    When I compare this season's settings to last season
    Then I should see a diff of changed settings
    And unchanged settings should be hidden by default

  @happy-path @history
  Scenario: Lock settings after draft
    When I enable "Lock settings after draft"
    Then scoring and roster settings should be locked post-draft
    And only schedule and trade settings should be editable

  # ============================================================================
  # MOBILE / RESPONSIVE
  # ============================================================================

  @mobile @responsive
  Scenario: Configure settings on mobile
    Given I am using a mobile device
    When I access league settings
    Then I should see a mobile-optimized settings interface
    And all settings should be accessible via touch

  @mobile @responsive
  Scenario: Save settings on mobile
    Given I am using a mobile device
    When I change a setting and save
    Then the setting should save successfully
    And I should see a confirmation message

  # ============================================================================
  # ACCESSIBILITY
  # ============================================================================

  @accessibility @a11y
  Scenario: Screen reader support for settings
    Given I am using a screen reader
    When I navigate league settings
    Then all settings should be labeled clearly
    And form fields should announce their purpose

  @accessibility @a11y
  Scenario: Keyboard navigation for settings
    Given I am using keyboard navigation
    When I configure settings
    Then I should be able to tab through all fields
    And I should be able to save with keyboard only

  # ============================================================================
  # ERROR HANDLING
  # ============================================================================

  @error @resilience
  Scenario: Handle network error during settings save
    Given I am saving settings
    And network connectivity is lost
    When the save fails
    Then I should see "Unable to save - please try again"
    And my changes should be preserved locally

  @error @resilience
  Scenario: Handle concurrent settings edits
    Given another commissioner is editing settings
    When we both save simultaneously
    Then one save should succeed
    And the other should show "Settings were modified - please refresh"

  @error @validation
  Scenario: Handle invalid settings import
    Given I have a malformed settings JSON file
    When I attempt to import settings
    Then I should see "Invalid settings file format"
    And the import should be blocked
