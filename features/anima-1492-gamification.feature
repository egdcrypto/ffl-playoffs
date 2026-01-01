@gamification
Feature: Gamification
  As a fantasy football user
  I want engaging gamification features
  So that I can earn rewards and stay motivated throughout the season

  # --------------------------------------------------------------------------
  # Experience Points
  # --------------------------------------------------------------------------

  @experience-points
  Scenario: Earn XP for actions
    Given I am logged in
    When I complete an action that earns XP
    Then I should receive experience points
    And I should see XP earned notification
    And my total XP should increase

  @experience-points
  Scenario: View XP earning mechanics
    Given I am viewing the gamification section
    When I view XP earning opportunities
    Then I should see actions that earn XP
    And I should see XP values for each action
    And I should see bonus XP opportunities

  @experience-points
  Scenario: Benefit from point multipliers
    Given there is an XP multiplier event active
    When I earn XP during the event
    Then XP should be multiplied by the bonus rate
    And I should see multiplier indicator
    And multiplied XP should be awarded

  @experience-points
  Scenario: Participate in bonus XP events
    Given a bonus XP event is running
    When I participate in the event
    Then I should earn bonus XP
    And I should see event progress
    And I should see event duration remaining

  @experience-points
  Scenario: View XP history
    Given I have earned XP over time
    When I view my XP history
    Then I should see XP earned by date
    And I should see XP source breakdown
    And I should see total accumulated XP

  @experience-points
  Scenario: Receive level-up rewards
    Given I am close to leveling up
    When I earn enough XP to level up
    Then I should level up
    And I should receive level-up rewards
    And I should see celebration animation

  @experience-points
  Scenario: View XP leaderboards
    Given I am in a league
    When I view XP leaderboards
    Then I should see XP rankings
    And I should see my position
    And I should see friend rankings

  @experience-points
  Scenario: Respect daily XP caps
    Given there is a daily XP cap
    When I reach the daily cap
    Then I should be notified of cap reached
    And additional XP should not be awarded
    And I should see when cap resets

  @experience-points
  Scenario: Prevent XP decay
    Given I have been inactive
    When XP decay would apply
    Then I should be warned about decay
    And I should have grace period
    And activity should prevent decay

  @experience-points
  Scenario: View XP milestones
    Given I am earning XP
    When I view milestones
    Then I should see upcoming XP milestones
    And I should see rewards for milestones
    And I should see progress toward each

  # --------------------------------------------------------------------------
  # Achievement System
  # --------------------------------------------------------------------------

  @achievements
  Scenario: Unlock achievement
    Given I meet achievement criteria
    When I complete the achievement
    Then the achievement should unlock
    And I should see unlock notification
    And the achievement should appear in my collection

  @achievements
  Scenario: View achievement tiers
    Given I am viewing an achievement
    When I see the achievement tiers
    Then I should see bronze, silver, gold, platinum tiers
    And I should see requirements for each tier
    And I should see my current tier progress

  @achievements
  Scenario: Discover secret achievements
    Given there are secret achievements
    When I unlock a secret achievement
    Then I should see surprise notification
    And the achievement should be revealed
    And I should see how I unlocked it

  @achievements
  Scenario: Track achievement progress
    Given I am working toward an achievement
    When I view achievement progress
    Then I should see current progress
    And I should see remaining requirements
    And I should see estimated time to complete

  @achievements
  Scenario: Receive achievement notifications
    Given I unlock an achievement
    When the achievement unlocks
    Then I should receive push notification
    And I should see in-app notification
    And I should be able to share it

  @achievements
  Scenario: Share achievements
    Given I have unlocked an achievement
    When I share the achievement
    Then I should share to social media
    And I should share to league
    And shared content should look appealing

  @achievements
  Scenario: Browse achievement categories
    Given I am viewing achievements
    When I browse by category
    Then I should see achievement categories
    And I should filter by category
    And I should see progress in each category

  @achievements
  Scenario: View rare achievements
    Given there are rare achievements
    When I view rare achievements
    Then I should see rarity indicators
    And I should see unlock percentage
    And I should see special rewards

  @achievements
  Scenario: Complete achievement collections
    Given I am collecting related achievements
    When I complete a collection
    Then I should earn collection bonus
    And I should see collection complete notification
    And collection should be showcased

  @achievements
  Scenario: Receive achievement rewards
    Given I unlock an achievement
    When I claim the reward
    Then I should receive the associated reward
    And reward should be added to my inventory
    And I should see reward confirmation

  # --------------------------------------------------------------------------
  # Badge Collection
  # --------------------------------------------------------------------------

  @badges
  Scenario: Earn badge based on criteria
    Given I meet badge earning criteria
    When the criteria are met
    Then I should earn the badge
    And badge should appear in my collection
    And I should see earning animation

  @badges
  Scenario: Customize badge display
    Given I have multiple badges
    When I customize badge display
    Then I should choose featured badges
    And I should arrange badge order
    And display should update on my profile

  @badges
  Scenario: View badge rarity levels
    Given I am viewing badges
    When I see badge rarity
    Then I should see common, uncommon, rare, epic, legendary
    And I should see rarity distribution
    And rare badges should be highlighted

  @badges
  Scenario: Earn limited edition badges
    Given there is a limited edition badge available
    When I earn the limited badge
    Then the badge should be marked as limited
    And I should see edition number
    And badge should show exclusivity

  @badges
  Scenario: Collect seasonal badges
    Given it is a specific season or holiday
    When I complete seasonal criteria
    Then I should earn seasonal badge
    And badge should reflect the season
    And badge should be time-limited

  @badges
  Scenario: View badge showcase
    Given I have badges to showcase
    When I view my badge showcase
    Then I should see featured badges prominently
    And I should see badge statistics
    And others should see my showcase

  @badges
  Scenario: Trade badges with others
    Given badge trading is enabled
    When I propose a badge trade
    Then I should select badges to trade
    And other user should receive offer
    And trade should complete on acceptance

  @badges
  Scenario: Complete badge sets
    Given I am collecting a badge set
    When I complete the set
    Then I should earn set completion bonus
    And set should be marked complete
    And I should receive special reward

  @badges
  Scenario: View badge unlock animations
    Given I earn a new badge
    When the badge unlocks
    Then I should see unlock animation
    And animation should match badge rarity
    And I should be able to replay animation

  @badges
  Scenario: View badge statistics
    Given I am viewing my badges
    When I view badge statistics
    Then I should see total badges earned
    And I should see badges by category
    And I should see rarity breakdown

  # --------------------------------------------------------------------------
  # Level Progression
  # --------------------------------------------------------------------------

  @level-progression
  Scenario: View level thresholds
    Given I am at a certain level
    When I view level progression
    Then I should see XP needed for next level
    And I should see level thresholds
    And I should see my current progress

  @level-progression
  Scenario: Achieve prestige levels
    Given I have reached maximum level
    When I prestige
    Then I should reset to level 1
    And I should earn prestige badge
    And I should unlock prestige rewards

  @level-progression
  Scenario: Unlock level benefits
    Given I level up
    When I reach a level with benefits
    Then I should unlock new features
    And I should see what I unlocked
    And benefits should be immediately available

  @level-progression
  Scenario: Access level-gated features
    Given a feature requires certain level
    When I reach that level
    Then the feature should unlock
    And I should see unlock notification
    And I should be able to use the feature

  @level-progression
  Scenario: View level display
    Given I have a level
    When I view my profile
    Then my level should be displayed
    And level should have visual indicator
    And others should see my level

  @level-progression
  Scenario: Compare levels with others
    Given I am viewing other users
    When I compare levels
    Then I should see level comparison
    And I should see level difference
    And I should see who is higher level

  @level-progression
  Scenario: View level history
    Given I have leveled up over time
    When I view level history
    Then I should see level progression over time
    And I should see when I reached each level
    And I should see level graph

  @level-progression
  Scenario: Reach level milestones
    Given I am progressing in levels
    When I reach a milestone level
    Then I should receive milestone reward
    And I should see celebration
    And milestone should be recorded

  @level-progression
  Scenario: Claim level rewards
    Given I have leveled up
    When I claim level rewards
    Then rewards should be added to my account
    And I should see reward summary
    And I should be able to use rewards

  @level-progression
  Scenario: View level leaderboards
    Given I am comparing levels
    When I view level leaderboards
    Then I should see highest level users
    And I should see my rank
    And I should see friend rankings

  # --------------------------------------------------------------------------
  # Daily Challenges
  # --------------------------------------------------------------------------

  @daily-challenges
  Scenario: Receive generated daily challenges
    Given it is a new day
    When I view daily challenges
    Then I should see today's challenges
    And challenges should be fresh
    And I should see challenge rewards

  @daily-challenges
  Scenario: Experience challenge difficulty scaling
    Given I complete challenges regularly
    When new challenges are generated
    Then difficulty should scale appropriately
    And rewards should match difficulty
    And challenges should remain achievable

  @daily-challenges
  Scenario: Complete daily challenge
    Given I have an active daily challenge
    When I complete the challenge
    Then the challenge should be marked complete
    And I should receive the reward
    And progress should update

  @daily-challenges
  Scenario: Receive challenge rewards
    Given I complete a challenge
    When I claim the reward
    Then the reward should be granted
    And I should see reward notification
    And reward should be added to inventory

  @daily-challenges
  Scenario: Maintain challenge streaks
    Given I complete challenges daily
    When I complete today's challenge
    Then my streak should increase
    And I should see streak counter
    And I should earn streak bonus

  @daily-challenges
  Scenario: Skip a challenge
    Given I have a challenge I cannot complete
    When I skip the challenge
    Then a new challenge should be offered
    And skip should be limited
    And streak may be affected

  @daily-challenges
  Scenario: View challenge refresh timer
    Given I am viewing challenges
    When I check refresh time
    Then I should see when challenges refresh
    And timer should count down
    And I should be notified before refresh

  @daily-challenges
  Scenario: Access bonus challenges
    Given I have completed regular challenges
    When bonus challenges become available
    Then I should see bonus challenge
    And bonus should offer extra rewards
    And bonus should be time-limited

  @daily-challenges
  Scenario: Browse challenge categories
    Given I am viewing challenges
    When I browse by category
    Then I should see challenge categories
    And I should filter challenges
    And I should see category progress

  @daily-challenges
  Scenario: View challenge history
    Given I have completed challenges
    When I view challenge history
    Then I should see past challenges
    And I should see completion rate
    And I should see rewards earned

  # --------------------------------------------------------------------------
  # Weekly Missions
  # --------------------------------------------------------------------------

  @weekly-missions
  Scenario: View mission objectives
    Given it is a new week
    When I view weekly missions
    Then I should see mission objectives
    And I should see mission requirements
    And I should see mission rewards

  @weekly-missions
  Scenario: Track mission progress
    Given I am working on a mission
    When I make progress
    Then progress should be tracked
    And I should see progress bar
    And I should see remaining requirements

  @weekly-missions
  Scenario: Complete multi-step missions
    Given I have a multi-step mission
    When I complete each step
    Then step should be marked complete
    And next step should be revealed
    And final completion should trigger reward

  @weekly-missions
  Scenario: Receive mission rewards
    Given I complete a mission
    When I claim rewards
    Then rewards should be granted
    And I should see reward summary
    And mission should be marked complete

  @weekly-missions
  Scenario: Handle mission expiration
    Given a mission is about to expire
    When the mission expires
    Then I should be warned beforehand
    And expired missions should be removed
    And progress should be lost

  @weekly-missions
  Scenario: Choose mission difficulty
    Given I have mission options
    When I select difficulty
    Then I should choose easy, medium, or hard
    And rewards should scale with difficulty
    And requirements should match difficulty

  @weekly-missions
  Scenario: Complete collaborative missions
    Given there is a collaborative mission
    When the league works together
    Then everyone's progress should count
    And league should see combined progress
    And everyone should receive reward on completion

  @weekly-missions
  Scenario: Follow mission chains
    Given I complete a mission in a chain
    When I complete it
    Then next mission in chain should unlock
    And I should see chain progress
    And chain completion should give bonus

  @weekly-missions
  Scenario: Complete mission bonus objectives
    Given a mission has bonus objectives
    When I complete bonus objectives
    Then I should earn bonus rewards
    And bonus should be indicated
    And main mission should still complete

  @weekly-missions
  Scenario: View mission completion statistics
    Given I have completed missions
    When I view statistics
    Then I should see completion rate
    And I should see missions completed
    And I should see rewards earned

  # --------------------------------------------------------------------------
  # Seasonal Events
  # --------------------------------------------------------------------------

  @seasonal-events
  Scenario: View event scheduling
    Given there are seasonal events
    When I view event calendar
    Then I should see upcoming events
    And I should see event dates
    And I should see event details

  @seasonal-events
  Scenario: Earn event-exclusive rewards
    Given I am participating in an event
    When I complete event tasks
    Then I should earn exclusive rewards
    And rewards should be event-themed
    And rewards should indicate exclusivity

  @seasonal-events
  Scenario: Track event participation
    Given I am in a seasonal event
    When I participate
    Then my participation should be tracked
    And I should see my event progress
    And I should see event rankings

  @seasonal-events
  Scenario: View event leaderboards
    Given a seasonal event is active
    When I view event leaderboard
    Then I should see event rankings
    And I should see my position
    And I should see top participants

  @seasonal-events
  Scenario: Reach event milestones
    Given I am progressing in an event
    When I reach a milestone
    Then I should receive milestone reward
    And I should see milestone completion
    And next milestone should be shown

  @seasonal-events
  Scenario: Experience event themes
    Given a themed event is active
    When I use the app during event
    Then I should see themed UI
    And content should be event-themed
    And theme should enhance experience

  @seasonal-events
  Scenario: Receive event notifications
    Given a seasonal event is starting
    When the event begins
    Then I should receive notification
    And I should see event announcement
    And I should be able to join immediately

  @seasonal-events
  Scenario: View event countdown
    Given an event is upcoming
    When I view event countdown
    Then I should see time until event
    And countdown should be accurate
    And I should be notified when it starts

  @seasonal-events
  Scenario: View past event archives
    Given events have occurred in the past
    When I view event archives
    Then I should see past events
    And I should see my participation
    And I should see rewards earned

  @seasonal-events
  Scenario: Participate in event comeback
    Given I missed an event
    When comeback mechanics are available
    Then I should be able to earn some rewards
    And comeback should be limited
    And I should be encouraged to participate live

  # --------------------------------------------------------------------------
  # Reward System
  # --------------------------------------------------------------------------

  @rewards
  Scenario: Earn different reward types
    Given I complete reward-earning actions
    When I earn rewards
    Then I may earn coins
    And I may earn gems
    And I may earn items

  @rewards
  Scenario: Claim rewards
    Given I have unclaimed rewards
    When I claim rewards
    Then rewards should be added to my account
    And I should see claim animation
    And I should see reward summary

  @rewards
  Scenario: Receive reward notifications
    Given I earn a reward
    When the reward is granted
    Then I should receive notification
    And notification should show reward
    And I should be able to view details

  @rewards
  Scenario: View reward history
    Given I have earned rewards
    When I view reward history
    Then I should see all rewards earned
    And I should see reward sources
    And I should see reward dates

  @rewards
  Scenario: Receive bonus rewards
    Given I qualify for bonus rewards
    When bonus rewards are granted
    Then I should receive extra rewards
    And bonus should be highlighted
    And I should see why I got bonus

  @rewards
  Scenario: Earn streak rewards
    Given I maintain a streak
    When I receive streak rewards
    Then rewards should increase with streak
    And I should see streak bonus
    And streak should be encouraged

  @rewards
  Scenario: Earn referral rewards
    Given I refer a friend
    When they sign up and are active
    Then I should receive referral reward
    And they should receive welcome bonus
    And referral should be tracked

  @rewards
  Scenario: Receive milestone rewards
    Given I reach a milestone
    When I complete the milestone
    Then I should receive milestone reward
    And reward should match achievement
    And milestone should be recorded

  @rewards
  Scenario: Receive random reward drops
    Given random drops are enabled
    When I receive a random drop
    Then I should see surprise reward
    And reward rarity should vary
    And drops should feel exciting

  @rewards
  Scenario: Redeem rewards
    Given I have redeemable rewards
    When I redeem rewards
    Then I should select what to redeem for
    And redemption should process
    And I should receive redeemed item

  # --------------------------------------------------------------------------
  # Streaks and Combos
  # --------------------------------------------------------------------------

  @streaks-combos
  Scenario: Maintain login streak
    Given I log in daily
    When I log in each day
    Then my login streak should increase
    And I should see streak count
    And I should earn streak rewards

  @streaks-combos
  Scenario: Maintain activity streak
    Given I am active regularly
    When I complete activities daily
    Then my activity streak should increase
    And I should see streak progress
    And streak should unlock rewards

  @streaks-combos
  Scenario: Use streak protection
    Given I have streak protection available
    When I miss a day
    Then my streak should be protected
    And I should use a protection
    And I should be warned about protection

  @streaks-combos
  Scenario: Recover broken streak
    Given my streak was broken
    When I try to recover
    Then I should have recovery options
    And recovery may cost resources
    And streak should be restored

  @streaks-combos
  Scenario: Benefit from combo multipliers
    Given I am on a combo streak
    When I continue the combo
    Then multiplier should increase
    And rewards should be multiplied
    And I should see combo indicator

  @streaks-combos
  Scenario: Reach streak milestones
    Given I have a long streak
    When I reach a milestone
    Then I should earn bonus reward
    And milestone should be celebrated
    And I should see next milestone

  @streaks-combos
  Scenario: View streak leaderboards
    Given I am maintaining streaks
    When I view streak leaderboard
    Then I should see longest streaks
    And I should see my ranking
    And I should see friend streaks

  @streaks-combos
  Scenario: Receive streak notifications
    Given I have an active streak
    When streak is at risk
    Then I should receive reminder notification
    And I should be warned before streak breaks
    And notification should encourage action

  @streaks-combos
  Scenario: Earn streak rewards
    Given I maintain a streak
    When streak rewards are given
    Then rewards should match streak length
    And longer streaks should give more
    And I should see reward preview

  @streaks-combos
  Scenario: View streak statistics
    Given I have streak history
    When I view streak statistics
    Then I should see current streaks
    And I should see longest streaks ever
    And I should see streak patterns

  # --------------------------------------------------------------------------
  # Leaderboard Gamification
  # --------------------------------------------------------------------------

  @leaderboards
  Scenario: View XP leaderboards
    Given I am competing for XP
    When I view XP leaderboard
    Then I should see XP rankings
    And I should see my position
    And I should see points difference

  @leaderboards
  Scenario: View achievement leaderboards
    Given I am collecting achievements
    When I view achievement leaderboard
    Then I should see achievement counts
    And I should see rare achievement counts
    And I should see my ranking

  @leaderboards
  Scenario: View time-based rankings
    Given I am viewing leaderboards
    When I select time period
    Then I should see weekly rankings
    And I should see monthly rankings
    And I should see all-time rankings

  @leaderboards
  Scenario: View league tiers
    Given there are competitive tiers
    When I view my tier
    Then I should see my current tier
    And I should see tier requirements
    And I should see tier benefits

  @leaderboards
  Scenario: Experience promotion and relegation
    Given the ranking period ends
    When my rank qualifies for promotion
    Then I should be promoted to higher tier
    And I should see promotion celebration
    And I should access tier benefits

  @leaderboards
  Scenario: Earn leaderboard rewards
    Given the ranking period ends
    When I finish in reward position
    Then I should receive leaderboard reward
    And reward should match my position
    And I should see reward notification

  @leaderboards
  Scenario: View friend leaderboards
    Given I have friends in the app
    When I view friend leaderboard
    Then I should see friend rankings
    And I should see my position among friends
    And competition should be friendly

  @leaderboards
  Scenario: Compare global vs regional rankings
    Given I am on a leaderboard
    When I toggle between global and regional
    Then I should see global rankings
    And I should see regional rankings
    And I should see my position in each

  @leaderboards
  Scenario: Participate in leaderboard seasons
    Given a new season starts
    When I participate in the season
    Then rankings should reset appropriately
    And I should compete fresh
    And season should have timeline

  @leaderboards
  Scenario: View leaderboard celebrations
    Given I achieve a notable position
    When the celebration triggers
    Then I should see celebration animation
    And achievement should be highlighted
    And others should see my achievement

  # --------------------------------------------------------------------------
  # Error Handling and Edge Cases
  # --------------------------------------------------------------------------

  @gamification @error-handling
  Scenario: Handle reward claiming failure
    Given I am claiming a reward
    When the claim fails
    Then I should see error message
    And reward should not be lost
    And I should be able to retry

  @gamification @error-handling
  Scenario: Handle sync issues with progress
    Given my progress needs to sync
    When sync fails
    Then I should see sync error
    And progress should be preserved locally
    And sync should retry automatically

  @gamification @validation
  Scenario: Validate achievement progress
    Given I am tracking achievement progress
    When progress is recorded
    Then progress should be validated
    And cheating should be prevented
    And legitimate progress should be counted
