@admin @league-management @ffl-2
Feature: Admin Management
  As a league administrator
  I want to create and manage fantasy football playoff leagues
  So that I can organize competitions with configurable rules and invite players

  Background:
    Given I am authenticated as a user with admin role
    And the fantasy football platform is available
    And the current NFL season is active

  # ==========================================
  # League Creation
  # ==========================================

  @league @creation
  Scenario: Create a new playoff league with basic settings
    Given I am on the league creation page
    When I create a new league with:
      | field           | value                      |
      | name            | Championship Showdown 2024 |
      | type            | playoff                    |
      | max_teams       | 12                         |
      | entry_fee       | 50.00                      |
      | draft_type      | snake                      |
    Then the league should be created successfully
    And I should be assigned as the league commissioner
    And the league should have status "draft"
    And a unique league code should be generated

  @league @creation @detailed
  Scenario: Create league with full configuration
    Given I am creating a new playoff league
    When I provide complete configuration:
      | field                 | value                    |
      | name                  | Pro Bowl Challenge       |
      | description           | Elite playoff competition|
      | max_teams             | 8                        |
      | min_teams             | 6                        |
      | entry_fee             | 100.00                   |
      | prize_pool_type       | winner_take_all          |
      | draft_type            | auction                  |
      | draft_budget          | 200                      |
      | waiver_type           | faab                     |
      | waiver_budget         | 100                      |
      | trade_deadline        | 2024-01-10               |
      | playoff_start_week    | wild_card                |
    And I save the league
    Then all configuration should be saved
    And league should be ready for player invitations

  @league @creation @template
  Scenario: Create league from template
    Given league templates exist:
      | template_name     | description                    |
      | standard_playoff  | Standard playoff scoring       |
      | ppr_playoff       | PPR playoff league             |
      | superflex         | Superflex with 2QB option      |
    When I create league from template "ppr_playoff"
    Then league should inherit template settings
    And I should be able to customize inherited settings
    And template source should be recorded

  @league @creation @validation
  Scenario: Validate league creation requirements
    Given I am creating a new league
    When I attempt to save without required fields:
      | missing_field |
      | name          |
    Then I should see validation error "League name is required"
    And the league should not be created

  @league @creation @duplicate
  Scenario: Prevent duplicate league names for same admin
    Given I already have a league named "My Playoff League"
    When I create another league with name "My Playoff League"
    Then I should see warning about duplicate name
    And I should be prompted to use a different name

  @league @creation @limits
  Scenario: Enforce league creation limits
    Given my account allows maximum 5 active leagues
    And I already have 5 active leagues
    When I attempt to create a new league
    Then creation should be blocked
    And I should see message about league limit
    And upgrade options should be presented

  # ==========================================
  # Configurable Scoring Rules
  # ==========================================

  @scoring @configuration
  Scenario: Configure standard scoring rules
    Given I am configuring scoring for my league
    When I set scoring rules:
      | category          | action              | points |
      | passing           | passing_yard        | 0.04   |
      | passing           | passing_td          | 4      |
      | passing           | interception        | -2     |
      | rushing           | rushing_yard        | 0.1    |
      | rushing           | rushing_td          | 6      |
      | receiving         | reception           | 0      |
      | receiving         | receiving_yard      | 0.1    |
      | receiving         | receiving_td        | 6      |
    Then scoring rules should be saved
    And rules should apply to all league matchups

  @scoring @ppr
  Scenario: Configure PPR scoring
    Given I want PPR scoring for my league
    When I enable PPR with:
      | reception_type    | points |
      | standard          | 1.0    |
      | te_premium        | 1.5    |
    Then receptions should be scored accordingly
    And tight ends should receive bonus if premium enabled

  @scoring @bonuses
  Scenario: Configure performance bonuses
    Given I am setting up bonus scoring
    When I configure bonuses:
      | bonus_type           | threshold | points |
      | rushing_yards_100    | 100       | 3      |
      | rushing_yards_200    | 200       | 5      |
      | receiving_yards_100  | 100       | 3      |
      | passing_yards_300    | 300       | 3      |
      | passing_yards_400    | 400       | 5      |
    Then bonuses should be applied when thresholds met
    And bonus scoring should stack appropriately

  @scoring @defense
  Scenario: Configure defensive scoring
    Given I am configuring team defense scoring
    When I set defensive rules:
      | category              | points |
      | sack                  | 1      |
      | interception          | 2      |
      | fumble_recovery       | 2      |
      | defensive_td          | 6      |
      | safety                | 2      |
      | blocked_kick          | 2      |
      | points_allowed_0      | 10     |
      | points_allowed_1_6    | 7      |
      | points_allowed_7_13   | 4      |
      | points_allowed_14_20  | 1      |
      | points_allowed_21_27  | 0      |
      | points_allowed_28_34  | -1     |
      | points_allowed_35plus | -4     |
    Then defensive scoring should be configured
    And points allowed tiers should be enforced

  @scoring @kicker
  Scenario: Configure kicker scoring
    Given I am configuring kicker scoring
    When I set kicker rules:
      | field_goal_distance | points |
      | 0-39                | 3      |
      | 40-49               | 4      |
      | 50-59               | 5      |
      | 60+                 | 6      |
      | extra_point         | 1      |
      | missed_fg           | -1     |
      | missed_xp           | -2     |
    Then kicker scoring should reflect distance bonuses
    And missed kicks should apply penalties

  @scoring @custom
  Scenario: Create custom scoring category
    Given I want unique scoring for my league
    When I create custom scoring rule:
      | name            | first_down_rushing    |
      | description     | Points for rush 1st down |
      | points          | 0.5                   |
      | stat_category   | rushing               |
    Then custom rule should be added to scoring
    And custom stats should be tracked

  @scoring @presets
  Scenario: Apply scoring preset
    Given scoring presets are available:
      | preset_name   | description                |
      | espn_standard | ESPN default scoring       |
      | yahoo_default | Yahoo default scoring      |
      | sleeper_ppr   | Sleeper PPR settings       |
    When I apply preset "espn_standard"
    Then all scoring rules should match preset
    And I should be able to modify after applying

  @scoring @validation
  Scenario: Validate scoring configuration
    Given I have configured scoring rules
    When scoring validation runs
    Then rules should be checked for:
      | validation              | result     |
      | no_negative_yardage     | warning    |
      | balanced_positions      | info       |
      | extreme_values          | warning    |
    And validation report should be displayed

  # ==========================================
  # Player Invitation
  # ==========================================

  @invitation @email
  Scenario: Invite players via email
    Given my league "Championship League" is created
    When I invite players via email:
      | email                  |
      | player1@example.com    |
      | player2@example.com    |
      | player3@example.com    |
    Then invitation emails should be sent
    And invitations should contain league join link
    And invitation status should be "pending"

  @invitation @code
  Scenario: Share league join code
    Given my league has join code "ABC123XY"
    When a player uses the join code
    Then they should see league details
    And they should be able to request to join
    And I should receive join request notification

  @invitation @link
  Scenario: Generate shareable invite link
    Given I want to share my league publicly
    When I generate invite link
    Then a unique URL should be created
    And link should be valid for configured duration
    And link usage should be trackable

  @invitation @accept
  Scenario: Accept player join request
    Given player "john@example.com" requested to join
    When I accept the join request
    Then player should be added to the league
    And player should receive confirmation
    And league roster should update

  @invitation @reject
  Scenario: Reject player join request
    Given player "spam@example.com" requested to join
    When I reject the join request with reason "Unknown user"
    Then request should be marked as rejected
    And player should be notified of rejection
    And player should not be added to league

  @invitation @revoke
  Scenario: Revoke pending invitation
    Given invitation to "invited@example.com" is pending
    When I revoke the invitation
    Then invitation should be invalidated
    And invite link should no longer work
    And invited user should be notified

  @invitation @capacity
  Scenario: Handle league at capacity
    Given my league has 12 max teams
    And 12 teams have already joined
    When a new player tries to join
    Then join should be blocked
    And player should see "League is full" message
    And waitlist option should be offered

  @invitation @expiration
  Scenario: Handle expired invitations
    Given invitation was sent 30 days ago
    And invitation expiry is 14 days
    When invited user clicks the link
    Then invitation should be marked as expired
    And user should be prompted to request new invitation

  @invitation @bulk
  Scenario: Send bulk invitations
    Given I have a list of 50 email addresses
    When I send bulk invitations
    Then all invitations should be queued
    And invitations should be sent with rate limiting
    And bulk send status should be trackable

  # ==========================================
  # League Activation/Deactivation
  # ==========================================

  @activation @activate
  Scenario: Activate league for play
    Given my league has minimum required teams
    And all configuration is complete
    When I activate the league
    Then league status should change to "active"
    And draft scheduling should be enabled
    And all members should be notified

  @activation @requirements
  Scenario: Verify activation requirements
    Given I am activating my league
    Then the following requirements should be met:
      | requirement           | status   |
      | minimum_teams         | met      |
      | scoring_configured    | met      |
      | roster_slots_set      | met      |
      | draft_scheduled       | optional |
      | entry_fees_collected  | optional |
    And activation should proceed if required items met

  @activation @insufficient-teams
  Scenario: Block activation with insufficient teams
    Given my league requires minimum 6 teams
    And only 4 teams have joined
    When I attempt to activate
    Then activation should be blocked
    And I should see "Need 2 more teams to activate"
    And I should be prompted to invite more players

  @deactivation @pause
  Scenario: Pause active league
    Given my league is active and in-season
    When I pause the league
    Then league status should change to "paused"
    And all scheduled events should be suspended
    And members should be notified
    And league should be resumable

  @deactivation @cancel
  Scenario: Cancel league before draft
    Given my league has not yet drafted
    When I cancel the league
    Then league status should change to "cancelled"
    And all pending invitations should be revoked
    And entry fees should be refunded if collected
    And members should be notified of cancellation

  @deactivation @archive
  Scenario: Archive completed league
    Given my league season has ended
    When I archive the league
    Then league should be moved to archive
    And historical data should be preserved
    And league should be viewable but not editable
    And storage should be optimized

  @activation @restore
  Scenario: Restore archived league as template
    Given I have an archived league "2023 Champions"
    When I restore as template for new season
    Then new league should be created
    And settings should be copied from archived league
    And roster/standings should not be copied
    And I should be prompted to invite returning players

  # ==========================================
  # Configuration Management
  # ==========================================

  @configuration @roster
  Scenario: Configure roster positions
    Given I am setting up roster configuration
    When I configure roster slots:
      | position | slots | bench |
      | QB       | 1     | 0     |
      | RB       | 2     | 0     |
      | WR       | 2     | 0     |
      | TE       | 1     | 0     |
      | FLEX     | 1     | 0     |
      | K        | 1     | 0     |
      | DEF      | 1     | 0     |
      | BENCH    | 6     | 6     |
      | IR       | 1     | 0     |
    Then roster configuration should be saved
    And total roster size should be calculated

  @configuration @superflex
  Scenario: Configure superflex position
    Given I want a superflex league
    When I configure superflex:
      | position   | eligible_positions     |
      | SUPERFLEX  | QB, RB, WR, TE         |
    Then superflex should allow specified positions
    And draft rankings should reflect superflex value

  @configuration @idp
  Scenario: Configure IDP (Individual Defensive Player) league
    Given I want IDP scoring
    When I configure IDP positions:
      | position | slots |
      | DL       | 2     |
      | LB       | 2     |
      | DB       | 2     |
      | IDP_FLEX | 1     |
    And I set IDP scoring:
      | action          | points |
      | tackle          | 1      |
      | sack            | 4      |
      | interception    | 6      |
      | forced_fumble   | 4      |
      | fumble_recovery | 4      |
      | pass_defended   | 2      |
    Then IDP configuration should be complete

  @configuration @trade
  Scenario: Configure trade settings
    Given I am configuring trade rules
    When I set trade configuration:
      | setting                | value        |
      | trade_deadline         | 2024-01-10   |
      | review_period_hours    | 24           |
      | votes_to_veto          | 4            |
      | commissioner_approval  | false        |
      | draft_pick_trading     | true         |
      | max_future_seasons     | 2            |
    Then trade settings should be saved
    And trade functionality should follow rules

  @configuration @waiver
  Scenario: Configure waiver wire settings
    Given I am configuring waivers
    When I set waiver configuration:
      | setting              | value           |
      | waiver_type          | faab            |
      | faab_budget          | 100             |
      | waiver_day           | wednesday       |
      | waiver_time          | 12:00 EST       |
      | continuous_waivers   | true            |
      | injured_reserve_slots| 2               |
    Then waiver configuration should be saved
    And waiver processing should follow schedule

  @configuration @schedule
  Scenario: Configure matchup schedule
    Given my league has 12 teams
    When I generate schedule:
      | setting            | value           |
      | regular_season_weeks| 14             |
      | playoff_teams      | 6               |
      | playoff_weeks      | 3               |
      | bye_weeks          | none            |
      | division_games     | 2_per_opponent  |
    Then schedule should be generated
    And all teams should have equal games
    And playoff bracket should be created

  @configuration @divisions
  Scenario: Configure league divisions
    Given my league has 12 teams
    When I create divisions:
      | division_name | teams |
      | AFC           | 6     |
      | NFC           | 6     |
    Then divisions should be created
    And teams should be assignable to divisions
    And division standings should be trackable

  @configuration @keeper
  Scenario: Configure keeper league settings
    Given I want a keeper league
    When I configure keeper rules:
      | setting              | value    |
      | keepers_per_team     | 3        |
      | keeper_cost          | +1_round |
      | max_years_kept       | 3        |
      | rookie_keeper_exempt | true     |
    Then keeper configuration should be saved
    And keeper eligibility should be calculated

  @configuration @dynasty
  Scenario: Configure dynasty league settings
    Given I want a dynasty league
    When I configure dynasty rules:
      | setting               | value    |
      | roster_size           | 25       |
      | taxi_squad_slots      | 5        |
      | rookie_draft_rounds   | 4        |
      | contract_years        | enabled  |
      | salary_cap            | 300      |
    Then dynasty configuration should be saved
    And long-term roster management should be enabled

  @configuration @import
  Scenario: Import configuration from another platform
    Given I have league settings from ESPN
    When I import configuration:
      | source_platform | ESPN              |
      | import_type     | scoring_and_roster|
    Then configuration should be parsed
    And settings should be mapped to platform format
    And import preview should be shown for review

  @configuration @export
  Scenario: Export league configuration
    Given my league is fully configured
    When I export configuration
    Then configuration file should be generated
    And file should include all settings
    And file should be importable to new league

  # ==========================================
  # Commissioner Tools
  # ==========================================

  @commissioner @override
  Scenario: Commissioner score adjustment
    Given a scoring error occurred in Week 2
    When I apply score adjustment:
      | team          | adjustment | reason               |
      | Team Alpha    | +5.5       | Stat correction      |
    Then score should be adjusted
    And adjustment should be logged
    And affected team should be notified

  @commissioner @lineup
  Scenario: Commissioner lineup override
    Given a team owner missed lineup deadline due to emergency
    When I override lineup for Team Beta:
      | action        | player           | slot    |
      | start         | Patrick Mahomes  | QB      |
      | bench         | Backup QB        | BENCH   |
    Then lineup should be updated retroactively
    And override should be logged
    And league should be notified

  @commissioner @trade
  Scenario: Commissioner push through trade
    Given a trade is pending league approval
    And trade is fair but being vetoed unfairly
    When I push through the trade as commissioner
    Then trade should be processed immediately
    And commissioner action should be logged
    And league should be notified with explanation

  @commissioner @veto
  Scenario: Commissioner veto collusion trade
    Given a trade appears to be collusion
    When I veto the trade with reason "Suspected collusion"
    Then trade should be cancelled
    And involved teams should be notified
    And veto reason should be recorded

  @commissioner @remove-team
  Scenario: Remove inactive team owner
    Given team owner has been inactive for 3 weeks
    When I remove the team owner
    Then owner should be removed from league
    And team should be marked as orphan
    And new owner can be assigned
    And removal should be logged

  @commissioner @co-commissioner
  Scenario: Assign co-commissioner
    Given I want to share administration duties
    When I assign "trusted@example.com" as co-commissioner
    Then user should receive commissioner permissions
    And user should be able to manage league
    And audit trail should track all actions by user

  @commissioner @announcements
  Scenario: Send league announcement
    Given I need to communicate with all league members
    When I send announcement:
      | subject  | Important League Update      |
      | message  | Trade deadline extended...   |
      | priority | high                         |
    Then all members should receive notification
    And announcement should be pinned in league feed
    And read receipts should be tracked

  # ==========================================
  # League Financial Management
  # ==========================================

  @financial @entry-fee
  Scenario: Collect entry fees
    Given my league has $50 entry fee
    When I enable fee collection
    Then payment options should be presented to members
    And payment status should be tracked per team
    And league should not activate until all paid

  @financial @prize-pool
  Scenario: Configure prize distribution
    Given my league has $600 prize pool
    When I configure distribution:
      | place   | percentage | amount |
      | 1st     | 60%        | $360   |
      | 2nd     | 30%        | $180   |
      | 3rd     | 10%        | $60    |
    Then prize structure should be saved
    And payouts should be calculated automatically

  @financial @weekly-prizes
  Scenario: Configure weekly prizes
    Given I want weekly high score prizes
    When I configure weekly prizes:
      | prize_type        | amount |
      | highest_score     | $10    |
      | biggest_blowout   | $5     |
    Then weekly prizes should be tracked
    And winners should be announced each week

  @financial @payout
  Scenario: Process end of season payouts
    Given season has ended
    And final standings are confirmed
    When I process payouts
    Then prize amounts should be calculated
    And payout requests should be generated
    And financial summary should be recorded

  # ==========================================
  # Error Handling and Edge Cases
  # ==========================================

  @error-handling @concurrent-edit
  Scenario: Handle concurrent configuration edits
    Given two admins are editing league settings
    When both save changes simultaneously
    Then conflict should be detected
    And merge options should be presented
    And no data should be lost

  @error-handling @invalid-config
  Scenario: Handle invalid configuration combinations
    Given I configure 0 QB slots
    And I configure superflex that includes QB
    When validation runs
    Then warning should be displayed
    And configuration should still be savable with acknowledgment

  @error-handling @draft-in-progress
  Scenario: Prevent changes during active draft
    Given league draft is in progress
    When I attempt to change roster configuration
    Then change should be blocked
    And message should explain draft must complete first

  @edge-case @mid-season-change
  Scenario: Request mid-season rule change
    Given season is in progress
    When I request scoring change
    Then league vote should be initiated
    And super-majority approval should be required
    And change should be prospective only

  @edge-case @tie-breaker
  Scenario: Configure tie-breaker rules
    Given I need to handle playoff ties
    When I configure tie-breakers:
      | priority | rule                    |
      | 1        | head_to_head            |
      | 2        | total_points_for        |
      | 3        | playoff_seed            |
    Then tie-breakers should apply in order
    And tied games should be resolved

  @edge-case @timezone
  Scenario: Handle multiple timezones
    Given league members are in different timezones
    When I set deadline times
    Then times should be stored in UTC
    And displayed in each user's local timezone
    And deadline should be enforced consistently

  @edge-case @orphan-team
  Scenario: Handle orphan team management
    Given a team owner has left the league
    And the team is now orphan
    When I manage the orphan team
    Then I should be able to set lineups
    And I should be able to manage waiver claims
    And team should remain competitive
    And new owner assignment should be possible
