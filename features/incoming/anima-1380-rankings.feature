@rankings @anima-1380
Feature: Rankings
  As a fantasy football user
  I want comprehensive player and team rankings
  So that I can make informed decisions about my fantasy team

  Background:
    Given I am a logged-in user
    And the rankings system is available

  # ============================================================================
  # PLAYER RANKINGS
  # ============================================================================

  @happy-path @player-rankings
  Scenario: View overall rankings
    Given players are ranked
    When I view overall rankings
    Then I should see all players ranked
    And rankings should be ordered by value

  @happy-path @player-rankings
  Scenario: View position rankings
    Given I want position-specific rankings
    When I filter by position
    Then I should see position rankings
    And only that position should be shown

  @happy-path @player-rankings
  Scenario: View weekly rankings
    Given it is a specific week
    When I view weekly rankings
    Then I should see rankings for that week
    And matchup context should be included

  @happy-path @player-rankings
  Scenario: View rest-of-season rankings
    Given we are mid-season
    When I view ROS rankings
    Then I should see remaining value rankings
    And season context should be factored

  @happy-path @player-rankings
  Scenario: View rankings by scoring format
    Given different scoring formats exist
    When I select a scoring format
    Then rankings should adjust accordingly
    And format impact should be visible

  @happy-path @player-rankings
  Scenario: View top 100 players
    Given I want elite players
    When I view top 100
    Then I should see top 100 ranked
    And rankings should be accurate

  @happy-path @player-rankings
  Scenario: View rookie rankings
    Given rookies are ranked
    When I filter for rookies
    Then I should see rookie rankings
    And experience should be noted

  @happy-path @player-rankings
  Scenario: Search player rankings
    Given I want a specific player
    When I search rankings
    Then I should find the player
    And their rank should be shown

  @happy-path @player-rankings
  Scenario: View rankings with stats
    Given stats are available
    When I view rankings with stats
    Then I should see supporting stats
    And stats should justify ranking

  @mobile @player-rankings
  Scenario: View rankings on mobile
    Given I am on a mobile device
    When I view rankings
    Then rankings should be mobile-friendly
    And I should be able to scroll easily

  # ============================================================================
  # TEAM RANKINGS
  # ============================================================================

  @happy-path @team-rankings
  Scenario: View fantasy team rankings
    Given I am in a league
    When I view team rankings
    Then I should see all teams ranked
    And my team should be highlighted

  @happy-path @team-rankings
  Scenario: View power rankings
    Given power rankings are calculated
    When I view power rankings
    Then I should see teams by strength
    And ranking methodology should be clear

  @happy-path @team-rankings
  Scenario: View league rankings
    Given league standings exist
    When I view league rankings
    Then I should see standings-based rankings
    And tiebreakers should be applied

  @happy-path @team-rankings
  Scenario: View playoff rankings
    Given playoffs are approaching
    When I view playoff rankings
    Then I should see playoff odds by team
    And seeding should be projected

  @happy-path @team-rankings
  Scenario: View weekly team rankings
    Given a week has completed
    When I view weekly team rankings
    Then I should see teams ranked by week
    And weekly scores should be shown

  @happy-path @team-rankings
  Scenario: View roster strength rankings
    Given roster values exist
    When I view roster strength
    Then I should see teams by roster value
    And position strengths should be shown

  @happy-path @team-rankings
  Scenario: View schedule-adjusted rankings
    Given schedules affect rankings
    When I view adjusted rankings
    Then rankings should account for schedule
    And remaining strength should be factored

  @happy-path @team-rankings
  Scenario: View championship odds
    Given odds are calculated
    When I view championship rankings
    Then I should see championship probability
    And favorites should be clear

  @happy-path @team-rankings
  Scenario: Compare team rankings over time
    Given rankings change weekly
    When I compare over time
    Then I should see ranking trends
    And trajectory should be visible

  @happy-path @team-rankings
  Scenario: View team rankings explanation
    Given rankings have methodology
    When I view explanation
    Then I should understand the ranking
    And factors should be explained

  # ============================================================================
  # EXPERT RANKINGS
  # ============================================================================

  @happy-path @expert-rankings
  Scenario: View expert consensus
    Given multiple experts rank
    When I view consensus rankings
    Then I should see aggregated rankings
    And consensus should be weighted

  @happy-path @expert-rankings
  Scenario: View analyst rankings
    Given analysts provide rankings
    When I view analyst rankings
    Then I should see individual analyst picks
    And analyst credentials should be shown

  @happy-path @expert-rankings
  Scenario: View site rankings
    Given sites have their own rankings
    When I view site rankings
    Then I should see site-specific rankings
    And source should be attributed

  @happy-path @expert-rankings
  Scenario: View aggregate rankings
    Given multiple sources exist
    When I view aggregate
    Then I should see combined rankings
    And sources should be listed

  @happy-path @expert-rankings
  Scenario: Compare expert rankings
    Given experts disagree
    When I compare experts
    Then I should see differences
    And variance should be highlighted

  @happy-path @expert-rankings
  Scenario: View expert accuracy
    Given experts have track records
    When I view accuracy
    Then I should see historical accuracy
    And most accurate should be ranked

  @happy-path @expert-rankings
  Scenario: Filter by expert
    Given I prefer certain experts
    When I filter by expert
    Then I should see their rankings
    And filter should be clearable

  @happy-path @expert-rankings
  Scenario: View expert reasoning
    Given experts explain rankings
    When I view reasoning
    Then I should see analysis
    And justification should be clear

  @happy-path @expert-rankings
  Scenario: Subscribe to expert updates
    Given I want expert alerts
    When I subscribe to an expert
    Then I should get their updates
    And I can unsubscribe later

  @happy-path @expert-rankings
  Scenario: View expert bold predictions
    Given experts make bold calls
    When I view bold predictions
    Then I should see contrarian takes
    And risk should be acknowledged

  # ============================================================================
  # CUSTOM RANKINGS
  # ============================================================================

  @happy-path @custom-rankings
  Scenario: Create user rankings
    Given I want my own rankings
    When I create custom rankings
    Then I should rank players my way
    And my rankings should be saved

  @happy-path @custom-rankings
  Scenario: Create personal tiers
    Given I want tiered rankings
    When I create personal tiers
    Then I should group players by tier
    And tier labels should be customizable

  @happy-path @custom-rankings
  Scenario: Create custom lists
    Given I want custom lists
    When I create a list
    Then I should organize players
    And list should be named

  @happy-path @custom-rankings
  Scenario: Make ranking adjustments
    Given default rankings exist
    When I adjust rankings
    Then my adjustments should be saved
    And original should be visible

  @happy-path @custom-rankings
  Scenario: Import custom rankings
    Given I have rankings elsewhere
    When I import rankings
    Then my rankings should be imported
    And format should be validated

  @happy-path @custom-rankings
  Scenario: Export custom rankings
    Given I created custom rankings
    When I export rankings
    Then I should receive export file
    And data should be complete

  @happy-path @custom-rankings
  Scenario: Share custom rankings
    Given I want to share rankings
    When I share my rankings
    Then others can view them
    And attribution should be maintained

  @happy-path @custom-rankings
  Scenario: Reset to default rankings
    Given I have customized rankings
    When I reset to defaults
    Then default rankings should be restored
    And customizations should be cleared

  @happy-path @custom-rankings
  Scenario: Track custom ranking accuracy
    Given I use custom rankings
    When results are in
    Then I should see my accuracy
    And comparison to defaults should be shown

  @happy-path @custom-rankings
  Scenario: Use custom rankings in draft
    Given I have custom rankings
    When I draft
    Then my rankings should be available
    And draft board should use my rankings

  # ============================================================================
  # RANKING HISTORY
  # ============================================================================

  @happy-path @ranking-history
  Scenario: View historical rankings
    Given rankings exist from past
    When I view historical rankings
    Then I should see past rankings
    And I can select any time period

  @happy-path @ranking-history
  Scenario: View ranking trends
    Given rankings change over time
    When I view trends
    Then I should see ranking movement
    And trends should be visualized

  @happy-path @ranking-history
  Scenario: View ranking changes over time
    Given a player's rank has changed
    When I view their history
    Then I should see rank over time
    And key changes should be noted

  @happy-path @ranking-history
  Scenario: View ranking archives
    Given archives are available
    When I access archives
    Then I should see past season rankings
    And I can browse any season

  @happy-path @ranking-history
  Scenario: Compare current to past rankings
    Given current and past exist
    When I compare rankings
    Then I should see differences
    And changes should be highlighted

  @happy-path @ranking-history
  Scenario: View preseason vs current
    Given preseason rankings exist
    When I compare to current
    Then I should see how rankings changed
    And risers and fallers should be shown

  @happy-path @ranking-history
  Scenario: View weekly ranking changes
    Given rankings update weekly
    When I view weekly changes
    Then I should see week-over-week movement
    And big movers should be highlighted

  @happy-path @ranking-history
  Scenario: Export ranking history
    Given I want historical data
    When I export history
    Then I should receive export file
    And data should be comprehensive

  # ============================================================================
  # DYNASTY RANKINGS
  # ============================================================================

  @happy-path @dynasty-rankings
  Scenario: View dynasty rankings
    Given dynasty format exists
    When I view dynasty rankings
    Then I should see long-term value rankings
    And age should be factored

  @happy-path @dynasty-rankings
  Scenario: View keeper rankings
    Given keeper leagues exist
    When I view keeper rankings
    Then I should see keeper value rankings
    And cost should be considered

  @happy-path @dynasty-rankings
  Scenario: View rookie dynasty rankings
    Given rookies enter the league
    When I view rookie rankings
    Then I should see rookie dynasty value
    And projection should be long-term

  @happy-path @dynasty-rankings
  Scenario: View trade value charts
    Given trade values exist
    When I view trade chart
    Then I should see trade values
    And relative values should be clear

  @happy-path @dynasty-rankings
  Scenario: Compare dynasty to redraft rankings
    Given both formats exist
    When I compare rankings
    Then I should see format differences
    And young players should differ

  @happy-path @dynasty-rankings
  Scenario: View aging curve analysis
    Given players age
    When I view aging curves
    Then I should see value by age
    And decline should be projected

  @happy-path @dynasty-rankings
  Scenario: View contract-adjusted rankings
    Given contracts exist
    When I view with contracts
    Then rankings should adjust for cost
    And value should be relative

  @happy-path @dynasty-rankings
  Scenario: View startup draft rankings
    Given startup drafts occur
    When I view startup rankings
    Then I should see startup values
    And picks should be valued

  @happy-path @dynasty-rankings
  Scenario: View devy rankings
    Given devy players exist
    When I view devy rankings
    Then I should see college player rankings
    And NFL projection should be shown

  @happy-path @dynasty-rankings
  Scenario: View IDP dynasty rankings
    Given IDP is used
    When I view IDP dynasty
    Then I should see defensive player values
    And longevity should be considered

  # ============================================================================
  # RANKING COMPARISON
  # ============================================================================

  @happy-path @ranking-comparison
  Scenario: Compare multiple rankings
    Given multiple rankings exist
    When I compare rankings
    Then I should see side-by-side view
    And differences should be highlighted

  @happy-path @ranking-comparison
  Scenario: Compare expert vs expert
    Given experts have rankings
    When I compare two experts
    Then I should see their differences
    And disagreements should be clear

  @happy-path @ranking-comparison
  Scenario: View side-by-side rankings
    Given I select rankings to compare
    When I view side-by-side
    Then I should see parallel views
    And scrolling should be synced

  @happy-path @ranking-comparison
  Scenario: View ranking differences
    Given rankings differ
    When I analyze differences
    Then I should see biggest gaps
    And players with variance should be shown

  @happy-path @ranking-comparison
  Scenario: Compare my rankings to consensus
    Given I have custom rankings
    When I compare to consensus
    Then I should see my divergences
    And contrarian picks should be highlighted

  @happy-path @ranking-comparison
  Scenario: View ranking overlap
    Given multiple sources exist
    When I view overlap
    Then I should see agreement areas
    And consensus picks should be clear

  @happy-path @ranking-comparison
  Scenario: Save ranking comparison
    Given I created a comparison
    When I save it
    Then comparison should be saved
    And I can access it later

  @happy-path @ranking-comparison
  Scenario: Share ranking comparison
    Given I created a comparison
    When I share it
    Then a shareable link should be generated
    And others can view the comparison

  # ============================================================================
  # RANKING ALERTS
  # ============================================================================

  @happy-path @ranking-alerts
  Scenario: Receive ranking change alerts
    Given I have alerts enabled
    When a ranking changes significantly
    Then I should receive an alert
    And change magnitude should be shown

  @happy-path @ranking-alerts
  Scenario: Receive movement alerts
    Given players move in rankings
    When significant movement occurs
    Then I should be notified
    And reason should be explained

  @happy-path @ranking-alerts
  Scenario: Receive significant move alerts
    Given big moves happen
    When a player jumps/falls many spots
    Then I should receive alert
    And impact should be noted

  @happy-path @ranking-alerts
  Scenario: Receive breakout alerts
    Given players break out
    When a player trends up
    Then I should receive breakout alert
    And opportunity should be highlighted

  @happy-path @ranking-alerts
  Scenario: Configure alert thresholds
    Given I want custom thresholds
    When I set thresholds
    Then alerts should trigger at my levels
    And preferences should be saved

  @happy-path @ranking-alerts
  Scenario: Set player-specific alerts
    Given I track specific players
    When I set player alerts
    Then I should get alerts for those players
    And I can configure per player

  @happy-path @ranking-alerts
  Scenario: View alert history
    Given I have received alerts
    When I view history
    Then I should see past alerts
    And alerts should be searchable

  @happy-path @ranking-alerts
  Scenario: Disable ranking alerts
    Given I receive too many alerts
    When I disable alerts
    Then alerts should stop
    And I can re-enable later

  # ============================================================================
  # RANKING TIERS
  # ============================================================================

  @happy-path @ranking-tiers
  Scenario: View tiered rankings
    Given rankings have tiers
    When I view tiered rankings
    Then I should see tier groupings
    And tiers should be labeled

  @happy-path @ranking-tiers
  Scenario: View tier breaks
    Given tiers have breaks
    When I view tier breaks
    Then I should see where tiers divide
    And gaps should be visible

  @happy-path @ranking-tiers
  Scenario: Analyze tier drops
    Given tier analysis exists
    When I analyze tiers
    Then I should see tier drop analysis
    And draft strategy should be suggested

  @happy-path @ranking-tiers
  Scenario: View value tiers
    Given value tiers exist
    When I view value tiers
    Then I should see relative value groupings
    And bargains should be identified

  @happy-path @ranking-tiers
  Scenario: Visualize tier rankings
    Given visualization is available
    When I view tier visualization
    Then I should see graphical tiers
    And gaps should be visual

  @happy-path @ranking-tiers
  Scenario: Customize tier labels
    Given I want custom labels
    When I customize tier labels
    Then my labels should be applied
    And preferences should be saved

  @happy-path @ranking-tiers
  Scenario: View tier movement
    Given players move between tiers
    When I view tier changes
    Then I should see tier transitions
    And promotions/demotions should be clear

  @happy-path @ranking-tiers
  Scenario: Export tiered rankings
    Given I want tiered data
    When I export tiers
    Then I should receive tiered export
    And tier info should be included

  # ============================================================================
  # RANKING INTEGRATION
  # ============================================================================

  @happy-path @ranking-integration
  Scenario: Use rankings in draft
    Given I am drafting
    When I view draft board
    Then rankings should be integrated
    And I can sort by ranking

  @happy-path @ranking-integration
  Scenario: Use rankings in trade analyzer
    Given I am analyzing a trade
    When I view trade values
    Then rankings should inform values
    And trade impact should be shown

  @happy-path @ranking-integration
  Scenario: Use rankings in waiver decisions
    Given waivers are available
    When I view waiver wire
    Then rankings should prioritize pickups
    And value should be indicated

  @happy-path @ranking-integration
  Scenario: Use rankings in lineup decisions
    Given I am setting my lineup
    When I view start/sit advice
    Then rankings should inform decisions
    And matchup-adjusted ranks should be shown

  @happy-path @ranking-integration
  Scenario: View rankings with projections
    Given projections exist
    When I view rankings
    Then projections should be integrated
    And I can toggle projection view

  @happy-path @ranking-integration
  Scenario: Use rankings in auction draft
    Given I am in an auction
    When I view player values
    Then rankings should inform auction values
    And dollar values should be shown

  @happy-path @ranking-integration
  Scenario: Sync rankings across devices
    Given I use multiple devices
    When I access rankings
    Then rankings should sync
    And preferences should persist

  @happy-path @ranking-integration
  Scenario: View rankings on mobile
    Given I am on mobile
    When I view rankings
    Then rankings should be mobile-friendly
    And all features should work

  @happy-path @ranking-integration
  Scenario: Print rankings
    Given I want printed rankings
    When I print rankings
    Then printable version should open
    And formatting should be clean

  @happy-path @ranking-integration
  Scenario: Use rankings API
    Given API access is available
    When I query rankings API
    Then I should receive ranking data
    And response should be formatted
