@ANIMA-1037
Feature: Social Metrics and Scoring Systems
  As a world management system
  I want comprehensive scoring systems for entity relationships
  So that I can make data-driven decisions about world consequences
Background:
    Given a virtual world with tracked entity interactions
    And scoring algorithms are configured
    And the scoring service is operational
REPUTATION SCORING
  @unit @reputation
  Scenario: Calculate multi-dimensional reputation scores
    Given an entity has interaction history
    When reputation scoring calculates their score
    Then compute reputation across dimensions:
      | dimension           | weight | factors                          |
      | trustworthiness     | 25%    | promise_keeping, honesty, secrets |
      | helpfulness         | 20%    | assistance, teaching, healing    |
      | reliability         | 15%    | quest_completion, consistency    |
      | social_standing     | 15%    | endorsements, titles             |
      | combat_honor        | 10%    | fair_fighting, mercy_shown       |
      | economic_reputation | 10%    | debt_repayment, fair_pricing     |
      | cultural_respect    | 5%     | tradition, etiquette             |
    And each dimension scored -100 to +100
@unit @reputation @context
  Scenario: Apply context-specific reputation modifiers
    Given an entity has base reputation of 60
    When calculating in different contexts
    Then apply modifiers for faction_territory, profession_guild, witness_presence
@edge_case @reputation
  Scenario: Handle reputation with insufficient data
    Given a new entity has fewer than 5 interactions
    When calculating reputation
    Then return neutral default, flag uncertainty, use faction defaults as baseline
KARMA SCORING
  @unit @karma
  Scenario: Implement karma scoring with consequences
    Given entities perform actions
    When karma system evaluates
    Then assign karma: heroic(+50-100), helpful(+10-49), neutral(-9-9), selfish(-10-49), villainous(-50-100)
@integration @karma
  Scenario: Apply karma-based world consequences
    Given an entity has karma score
    When reaching thresholds
    Then trigger: saint(>=500) divine_protection, villain(-200-499) bounties, monster(<=-500) universal_hostility
@edge_case @karma
  Scenario: Handle karma for unintended consequences
    Given unintended outcomes occur
    Then factor intent into calculation, collateral_damage reduces karma 50%, self_defense nullifies negative
INFLUENCE METRICS
  @unit @influence
  Scenario: Calculate entity influence metrics
    Given entity has social graph relationships
    When calculating influence
    Then compute: direct_influence, network_influence(PageRank), resource_influence, information_influence, positional_influence
    And provide composite score 0-1000
@integration @influence
  Scenario: Track influence propagation
    Given entity A has influence 800
    When A takes visible action
    Then propagate: 1-degree(80%), 2-degrees(40%), 3-degrees(15%), 4+(5%)
THREAT ASSESSMENT
  @unit @threat
  Scenario: Calculate threat levels
    Given entities have combat history
    When calculating threat
    Then evaluate: combat_ability(30%), aggression_index(25%), resource_access(15%), unpredictability(15%), target_selection(10%), collateral(5%)
    And assign 0-100 threat level
@integration @threat
  Scenario: Trigger responses based on threat
    When threat exceeds thresholds
    Then respond: watch_list(30-49) patrols, known_danger(50-69) bounties, active_threat(70-84) hero_dispatch, existential(85-100) divine_intervention
@edge_case @threat
  Scenario: Handle reformed entities
    Given entity had threat 80 but peaceful for 30 days
    Then apply 5% decay per week, maintain 20% of peak for 90 days
SOCIAL DISTANCE
  @unit @social_distance
  Scenario: Calculate social distances
    Given social graph exists
    When calculating distance A to B
    Then compute: hop_count, weighted_distance, affinity_distance, historical_distance, trust_distance
    And return 0.0(identical) to 1.0(strangers)
@integration @social_distance
  Scenario: Identify social clusters
    Given distances calculated
    Then identify: tight_knit(<0.2), loose_alliances(0.2-0.5), bridge_entities, isolated(>0.8), emerging_factions
POPULARITY VOLATILITY
  @unit @popularity
  Scenario: Track popularity volatility
    Given entity has popularity history
    Then track: standard_deviation, trend_direction, peak_trough_ratio, stability_index, momentum
    And flag volatility > 30% as unstable
@integration @popularity
  Scenario: Predict future popularity
    Given historical data
    Then predict: short_term_24h(80% confidence), medium_term_7d(70%), event_impact(60%), trend_reversal(75%)
FACTION STANDING
  @unit @faction
  Scenario: Maintain faction standing
    Given entity interacts with faction
    Then track: direct_actions, indirect_actions, quest_completion, resource_contribution, member_treatment
    And range -1000(mortal_enemy) to +1000(exalted)
@integration @faction
  Scenario: Apply cascading faction effects
    Given faction relationships defined
    When standing with A changes
    Then cascade: allied(+0.5), friendly(+0.25), rival(-0.25), enemy(-0.5)
    And limit cascade to 2 hops
@edge_case @faction
  Scenario: Handle faction conflicts
    Given conflicting allegiances
    Then resolve: double_agent(separate standings), forced_betrayal(50% reduction), faction_merger(average+100)
BEHAVIORAL PREDICTION
  @unit @behavior
  Scenario: Score likelihood of behaviors
    Given behavioral history exists
    Then predict probability 0-100% of: aggression, cooperation, betrayal, trade, flight, leadership
@integration @behavior
  Scenario: Trigger interventions
    When predictions exceed thresholds
    Then intervene: imminent_violence(80%) spawn_peacekeepers, mass_exodus(70%) retention_events, faction_war(85%) diplomacy
COMPOSITE SCORING
  @unit @composite
  Scenario: Create composite scores
    Given multiple scores exist
    Then combine: world_citizen(rep:30%,karma:25%,influence:20%,threat:-25%), economic_actor, social_value, narrative_interest
    And normalize to 0-100
SCORE DECAY
  @unit @decay
  Scenario: Implement score decay
    Given scores change over time
    Then implement: linear_decay, exponential_decay, momentum_boost, floor_ceiling, half_life
@integration @decay
  Scenario: Configure decay by type
    Then set: reputation(0.5%/day,90d half-life), karma(0.1%/day,180d), threat(1.0%/day,30d), faction(0.2%/day,120d)
ALERT THRESHOLDS
  @unit @threshold
  Scenario: Set alert thresholds
    Given monitoring active
    Then support: absolute_value, rate_of_change, percentile_drop, volatility_spike, composite_trigger
@integration @threshold
  Scenario: Execute threshold responses
    When breach occurs
    Then: notify, automatic_action, escalate, log, apply_cooldown
SCORE AUDITING
  @unit @audit
  Scenario: Maintain score history
    Given changes occur
    Then capture: timestamp, previous_value, new_value, delta, cause_action, cause_entity, witnesses
    And history is immutable append-only
CONCURRENCY
  @unit @concurrency
  Scenario: Handle concurrent updates
    Given simultaneous updates
    Then use: atomic_updates, optimistic_locking, merge_compatible, order_by_timestamp
API CONTRACT
  @api @contract
  Scenario: Score API returns correct format
    Then response includes: entity_id, score_type, value, confidence, timestamp, components, metadata
@api @validation
  Scenario: API validates requests
    Then check: entity_exists(404), score_type_valid(400), required_fields(400), rate_limit(429)
ERROR HANDLING
  @error @resilience
  Scenario: Handle failures gracefully
    Given errors occur
    Then: database_unavailable use cached, timeout return last_known, invalid_input reject with error, cascade_loop break after 10
@error @validation
  Scenario: Validate score integrity
    Then detect: score_tampering(checksum), impossible_changes(rate_limit), missing_audit, statistical_anomaly(z>4)
    And quarantine suspicious scores