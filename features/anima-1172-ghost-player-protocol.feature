@ghost-player @protocol @activity-monitoring
Feature: Ghost Player Protocol
  As a world simulation system
  I need to manage player inactivity and character continuity
  So that the narrative can continue smoothly when players become inactive

  Background:
    Given a world "realm-of-legends" exists with ghost player protocol enabled
    And the following activity thresholds are configured:
      | status    | days_inactive | description                    |
      | ACTIVE    | 0             | Player actively participating  |
      | INACTIVE  | 3             | Brief absence, minimal impact  |
      | DORMANT   | 7             | Extended absence, decay begins |
      | GHOST     | 14            | Long absence, resolution needed|
      | RESOLVED  | 30            | Character fate determined      |

  # ============================================================================
  # ACTIVITY MONITORING
  # ============================================================================

  @api @activity-monitoring
  Scenario: Monitor player activity in real-time
    Given a player "player-123" controls character "Sir Aldric" in world "realm-of-legends"
    And the player's last activity was 0 hours ago
    When I request the player activity status via "GET /api/v1/worlds/realm-of-legends/players/player-123/activity"
    Then the response status should be 200
    And the response should contain:
      | field              | value        |
      | player_id          | player-123   |
      | character_id       | char-aldric  |
      | status             | ACTIVE       |
      | last_activity      | <timestamp>  |
      | hours_since_active | 0            |
      | days_until_decay   | 7            |

  @api @activity-monitoring
  Scenario: Detect transition from ACTIVE to INACTIVE status
    Given a player "player-456" controls character "Lady Seraphina" in world "realm-of-legends"
    And the player's last activity was 4 days ago
    When the activity monitor runs its scheduled check
    Then the player status should be "INACTIVE"
    And no relationship decay should be triggered
    And a domain event "PlayerStatusChanged" should be emitted with:
      | field         | value        |
      | player_id     | player-456   |
      | old_status    | ACTIVE       |
      | new_status    | INACTIVE     |
      | triggered_at  | <timestamp>  |

  @api @activity-monitoring
  Scenario: Detect transition from INACTIVE to DORMANT status
    Given a player "player-789" controls character "Thorin Blackforge" in world "realm-of-legends"
    And the player's current status is "INACTIVE"
    And the player's last activity was 8 days ago
    When the activity monitor runs its scheduled check
    Then the player status should be "DORMANT"
    And relationship decay should begin for character "Thorin Blackforge"
    And a domain event "RelationshipDecayStarted" should be emitted with:
      | field         | value              |
      | character_id  | char-thorin        |
      | decay_rate    | standard           |
      | started_at    | <timestamp>        |

  @api @activity-monitoring
  Scenario: Detect transition from DORMANT to GHOST status
    Given a player "player-321" controls character "Mira Nightshade" in world "realm-of-legends"
    And the player's current status is "DORMANT"
    And the player's last activity was 15 days ago
    When the activity monitor runs its scheduled check
    Then the player status should be "GHOST"
    And the character should be flagged for resolution
    And a domain event "GhostPlayerDetected" should be emitted with:
      | field             | value            |
      | player_id         | player-321       |
      | character_id      | char-mira        |
      | days_inactive     | 15               |
      | resolution_needed | true             |

  @api @activity-monitoring
  Scenario: Track multiple activity types for comprehensive monitoring
    Given a player "player-activity" controls character "Marcus the Wise" in world "realm-of-legends"
    When the player performs the following activities:
      | activity_type      | timestamp            | details                    |
      | MESSAGE_SENT       | 2024-01-15T10:00:00Z | In-character dialogue      |
      | ACTION_PERFORMED   | 2024-01-15T11:30:00Z | Combat engagement          |
      | SCENE_PARTICIPATED | 2024-01-15T14:00:00Z | Council meeting            |
      | LOGIN              | 2024-01-15T09:00:00Z | Session start              |
    Then the player's activity log should contain 4 entries
    And the last activity timestamp should be "2024-01-15T14:00:00Z"
    And the activity type "SCENE_PARTICIPATED" should be recorded as most recent

  @api @activity-monitoring
  Scenario: List all players by activity status in a world
    Given the following players exist in world "realm-of-legends":
      | player_id   | character_name    | last_activity_days_ago | current_status |
      | player-a    | Knight Valor      | 1                      | ACTIVE         |
      | player-b    | Sage Elara        | 5                      | INACTIVE       |
      | player-c    | Rogue Shade       | 10                     | DORMANT        |
      | player-d    | Wizard Merlyn     | 16                     | GHOST          |
      | player-e    | Archer Swift      | 35                     | RESOLVED       |
    When I request the activity report via "GET /api/v1/worlds/realm-of-legends/players/activity-report"
    Then the response status should be 200
    And the response should contain:
      | status    | count |
      | ACTIVE    | 1     |
      | INACTIVE  | 1     |
      | DORMANT   | 1     |
      | GHOST     | 1     |
      | RESOLVED  | 1     |

  @api @activity-monitoring
  Scenario: Configure custom activity thresholds for a world
    Given I am a world owner for world "realm-of-legends"
    When I update the activity thresholds via "PUT /api/v1/worlds/realm-of-legends/ghost-protocol/thresholds" with:
      | status    | days_inactive |
      | INACTIVE  | 5             |
      | DORMANT   | 10            |
      | GHOST     | 21            |
      | RESOLVED  | 45            |
    Then the response status should be 200
    And the new thresholds should be applied to all future activity checks
    And a domain event "ActivityThresholdsUpdated" should be emitted

  # ============================================================================
  # RELATIONSHIP DECAY
  # ============================================================================

  @domain @relationship-decay
  Scenario: Apply standard relationship decay for dormant player
    Given a player "player-decay" controls character "Lord Byron" in world "realm-of-legends"
    And the player's status is "DORMANT"
    And character "Lord Byron" has the following relationships:
      | related_character | relationship_type | strength | trust |
      | Lady Helena       | ROMANTIC          | 85       | 90    |
      | Sir Galahad       | ALLY              | 70       | 75    |
      | Duke Mortimer     | RIVAL             | 60       | 20    |
    When 7 days pass with no player activity
    Then the relationships should decay as follows:
      | related_character | relationship_type | new_strength | new_trust |
      | Lady Helena       | ROMANTIC          | 78           | 83        |
      | Sir Galahad       | ALLY              | 63           | 68        |
      | Duke Mortimer     | RIVAL             | 60           | 20        |
    And a domain event "RelationshipsDecayed" should be emitted with decay details

  @domain @relationship-decay
  Scenario: Apply accelerated decay for ghost player
    Given a player "player-ghost" controls character "Captain Flint" in world "realm-of-legends"
    And the player's status is "GHOST"
    And character "Captain Flint" has the following relationships:
      | related_character | relationship_type | strength | trust |
      | First Mate Jones  | ALLY              | 90       | 85    |
      | Crew Member Pike  | SUBORDINATE       | 75       | 70    |
    When 7 days pass with no player activity
    Then the relationships should decay at 2x the standard rate:
      | related_character | relationship_type | new_strength | new_trust |
      | First Mate Jones  | ALLY              | 76           | 71        |
      | Crew Member Pike  | SUBORDINATE       | 61           | 56        |

  @domain @relationship-decay
  Scenario: Preserve critical relationships during decay
    Given a player "player-critical" controls character "Queen Regent" in world "realm-of-legends"
    And the player's status is "DORMANT"
    And character "Queen Regent" has the following critical relationships:
      | related_character | relationship_type | strength | trust | critical |
      | Prince Heir       | FAMILY            | 95       | 98    | true     |
      | Royal Advisor     | ALLY              | 80       | 85    | false    |
    When 14 days pass with no player activity
    Then the critical relationship with "Prince Heir" should not decay
    And the non-critical relationship with "Royal Advisor" should decay normally
    And a domain event "CriticalRelationshipPreserved" should be emitted

  @domain @relationship-decay
  Scenario: Relationship decay affects character narrative standing
    Given a player "player-standing" controls character "Guild Master Thorne" in world "realm-of-legends"
    And the player's status is "DORMANT"
    And character "Guild Master Thorne" has leadership relationships with:
      | guild_member      | loyalty_score |
      | Apprentice Finn   | 80            |
      | Journeyman Clara  | 75            |
      | Master Smith Oren | 70            |
    When significant relationship decay occurs
    Then the character's narrative standing should be affected:
      | aspect          | original | current |
      | influence       | HIGH     | MEDIUM  |
      | trust_rating    | 85       | 70      |
      | leadership_grip | FIRM     | WEAKENING |
    And plot hooks for leadership challenge should be generated

  @domain @relationship-decay
  Scenario: Apply relationship decay based on relationship type
    Given a player "player-types" controls character "Diplomat Vance" in world "realm-of-legends"
    And the player's status is "DORMANT"
    And character "Diplomat Vance" has various relationship types:
      | related_character | relationship_type | strength | decay_modifier |
      | Ambassador Chen   | PROFESSIONAL      | 70       | 1.5x           |
      | Wife Elena        | ROMANTIC          | 90       | 0.5x           |
      | Brother Marcus    | FAMILY            | 85       | 0.25x          |
      | Rival Senator     | ENEMY             | 50       | 0.1x           |
    When 7 days pass with no player activity
    Then relationships should decay according to their type modifiers
    And professional relationships should decay fastest
    And family relationships should decay slowest

  @domain @relationship-decay
  Scenario: Track cumulative decay over time
    Given a player "player-cumulative" controls character "Merchant Aldous" in world "realm-of-legends"
    And the player's status is "DORMANT"
    And character "Merchant Aldous" has a relationship with "Partner Benedict" at strength 100
    When the following time periods pass:
      | period  | days | status  |
      | week_1  | 7    | DORMANT |
      | week_2  | 7    | DORMANT |
      | week_3  | 7    | GHOST   |
      | week_4  | 7    | GHOST   |
    Then the relationship strength should be tracked as:
      | after   | strength | cumulative_decay |
      | week_1  | 93       | 7                |
      | week_2  | 86       | 14               |
      | week_3  | 72       | 28               |
      | week_4  | 58       | 42               |

  @api @relationship-decay
  Scenario: Retrieve relationship decay history
    Given a player "player-history" controls character "Baron Cromwell" in world "realm-of-legends"
    And the player has been inactive for 21 days
    And relationship decay has been applied multiple times
    When I request the decay history via "GET /api/v1/worlds/realm-of-legends/characters/char-cromwell/decay-history"
    Then the response status should be 200
    And the response should contain a timeline of decay events
    And each decay event should include:
      | field              | description                    |
      | timestamp          | When decay was applied         |
      | relationships_affected | Number of relationships decayed |
      | total_decay        | Sum of strength lost           |
      | player_status      | Status at time of decay        |

  # ============================================================================
  # RESOLUTION STRATEGIES
  # ============================================================================

  @domain @resolution
  Scenario: Apply TRAGEDY resolution strategy
    Given a player "player-tragedy" controls character "Hero Achilles" in world "realm-of-legends"
    And the player's status is "GHOST" for 30 days
    And the character is flagged for resolution
    When the resolution strategy "TRAGEDY" is selected
    Then the character should be marked as "narratively deceased"
    And a tragic event should be generated for the character:
      | aspect          | value                              |
      | death_type      | HEROIC_SACRIFICE                   |
      | narrative_impact| HIGH                               |
      | mourning_period | 7 days                             |
    And related characters should receive grief narratives
    And a domain event "CharacterResolvedByTragedy" should be emitted

  @domain @resolution
  Scenario: Apply BETRAYAL resolution strategy
    Given a player "player-betrayal" controls character "Advisor Brutus" in world "realm-of-legends"
    And the player's status is "GHOST" for 30 days
    And the character is flagged for resolution
    When the resolution strategy "BETRAYAL" is selected
    Then the character should be marked as "turned antagonist"
    And a betrayal narrative should be generated:
      | aspect             | value                         |
      | betrayal_type      | FACTION_SWITCH                |
      | new_allegiance     | opposing_faction              |
      | reveal_method      | DRAMATIC_CONFRONTATION        |
    And the character should become an NPC antagonist
    And former allies should receive betrayal reaction narratives
    And a domain event "CharacterResolvedByBetrayal" should be emitted

  @domain @resolution
  Scenario: Apply STASIS resolution strategy
    Given a player "player-stasis" controls character "Wizard Chronos" in world "realm-of-legends"
    And the player's status is "GHOST" for 30 days
    And the character is flagged for resolution
    When the resolution strategy "STASIS" is selected
    Then the character should be placed in narrative stasis:
      | aspect           | value                          |
      | stasis_type      | MAGICAL_SLUMBER                |
      | location         | hidden_sanctuary               |
      | wake_condition   | player_return                  |
      | time_frozen      | true                           |
    And the character should be preserved for potential return
    And relationships should be frozen without further decay
    And a domain event "CharacterResolvedByStasis" should be emitted

  @domain @resolution
  Scenario: Apply MYSTERY resolution strategy
    Given a player "player-mystery" controls character "Scout Phantom" in world "realm-of-legends"
    And the player's status is "GHOST" for 30 days
    And the character is flagged for resolution
    When the resolution strategy "MYSTERY" is selected
    Then the character should "disappear mysteriously":
      | aspect              | value                         |
      | disappearance_type  | VANISHED_WITHOUT_TRACE        |
      | last_known_location | frontier_outpost              |
      | clues_left          | 3                             |
      | investigation_hook  | true                          |
    And a mystery subplot should be generated
    And other characters may investigate the disappearance
    And a domain event "CharacterResolvedByMystery" should be emitted

  @api @resolution
  Scenario: Select resolution strategy via API
    Given a player "player-resolve" controls character "Warrior Rex" in world "realm-of-legends"
    And the player's status is "GHOST" for 30 days
    And I am a world owner for world "realm-of-legends"
    When I request resolution via "POST /api/v1/worlds/realm-of-legends/ghost-protocol/resolve" with:
      | field            | value          |
      | player_id        | player-resolve |
      | character_id     | char-rex       |
      | strategy         | TRAGEDY        |
      | narrative_flavor | heroic_last_stand |
    Then the response status should be 200
    And the resolution should be applied
    And the player status should change to "RESOLVED"

  @api @resolution
  Scenario: Auto-select resolution strategy based on character archetype
    Given a player "player-auto" controls character "Sage Wisdom" in world "realm-of-legends"
    And the character has archetype "MENTOR"
    And the player's status is "GHOST" for 30 days
    When auto-resolution is triggered
    Then the system should recommend resolution strategy "MYSTERY"
    And the recommendation should be based on:
      | factor           | weight | reason                              |
      | archetype        | 0.4    | Mentors often vanish mysteriously   |
      | narrative_role   | 0.3    | Supporting character                |
      | relationship_web | 0.2    | Many dependent relationships        |
      | story_position   | 0.1    | Not in critical arc                 |

  @domain @resolution
  Scenario: Resolution strategy affects world narrative
    Given a player "player-impact" controls character "King Regent" in world "realm-of-legends"
    And the character holds the narrative role "FACTION_LEADER"
    And the player's status is "GHOST" for 30 days
    When the resolution strategy "TRAGEDY" is applied
    Then the world narrative should be affected:
      | narrative_element | change                         |
      | power_structure   | succession_crisis_begins       |
      | faction_stability | decreased_by_30_percent        |
      | plot_hooks        | throne_vacant_hook_generated   |
      | npc_reactions     | mourning_and_opportunism       |
    And related players should receive narrative notifications

  @domain @resolution
  Scenario: Defer resolution for characters in critical story moments
    Given a player "player-defer" controls character "Chosen One" in world "realm-of-legends"
    And the character is currently in a "CLIMACTIC_BATTLE" story moment
    And the player's status is "GHOST"
    When resolution is attempted
    Then the resolution should be deferred with reason "CRITICAL_STORY_MOMENT"
    And the character should receive temporary AI control
    And a domain event "ResolutionDeferred" should be emitted with:
      | field          | value                   |
      | reason         | CRITICAL_STORY_MOMENT   |
      | deferred_until | story_moment_resolved   |
      | ai_control     | true                    |

  # ============================================================================
  # PLAYER RETURN HANDLING
  # ============================================================================

  @api @player-return
  Scenario: Handle player return from INACTIVE status
    Given a player "player-return-1" controls character "Knight Errant" in world "realm-of-legends"
    And the player's status is "INACTIVE"
    And no relationship decay has occurred
    When the player logs in and performs an action
    Then the player status should immediately change to "ACTIVE"
    And the character should be fully restored with no penalties
    And a domain event "PlayerReturned" should be emitted with:
      | field        | value        |
      | player_id    | player-return-1 |
      | from_status  | INACTIVE     |
      | to_status    | ACTIVE       |
      | decay_amount | 0            |

  @api @player-return
  Scenario: Handle player return from DORMANT status
    Given a player "player-return-2" controls character "Sailor Drake" in world "realm-of-legends"
    And the player's status is "DORMANT"
    And relationship decay has reduced relationships by 15%
    When the player logs in and performs an action
    Then the player status should change to "ACTIVE"
    And a return narrative should be generated explaining the absence
    And the player should receive a "relationship recovery" option
    And a domain event "PlayerReturnedFromDormancy" should be emitted

  @api @player-return
  Scenario: Handle player return from GHOST status before resolution
    Given a player "player-return-3" controls character "Wanderer Kai" in world "realm-of-legends"
    And the player's status is "GHOST"
    And the character has not yet been resolved
    And relationship decay has reduced relationships by 35%
    When the player logs in and performs an action
    Then the player status should change to "ACTIVE"
    And a significant return narrative should be generated:
      | narrative_element | description                          |
      | return_hook       | dramatic_reappearance                |
      | explanation_type  | mysterious_journey                   |
      | relationship_work | trust_rebuilding_required            |
    And the player should have options to explain their character's absence
    And a domain event "PlayerReturnedFromGhost" should be emitted

  @api @player-return
  Scenario: Handle player return after STASIS resolution
    Given a player "player-return-4" controls character "Frozen Mage" in world "realm-of-legends"
    And the player's status is "RESOLVED"
    And the resolution strategy was "STASIS"
    When the player requests to return via "POST /api/v1/worlds/realm-of-legends/ghost-protocol/return" with:
      | field       | value            |
      | player_id   | player-return-4  |
      | character_id| char-frozen-mage |
    Then the response status should be 200
    And the character should be awakened from stasis
    And a dramatic return narrative should be generated:
      | narrative_element | value                     |
      | awakening_type    | magical_unfreezing        |
      | time_disorientation| true                     |
      | relationship_state| frozen_at_stasis_time     |
    And the player status should change to "ACTIVE"
    And a domain event "CharacterAwakenedFromStasis" should be emitted

  @api @player-return @error
  Scenario: Reject return after permanent resolution
    Given a player "player-return-5" controls character "Fallen Hero" in world "realm-of-legends"
    And the player's status is "RESOLVED"
    And the resolution strategy was "TRAGEDY"
    When the player requests to return via "POST /api/v1/worlds/realm-of-legends/ghost-protocol/return" with:
      | field       | value           |
      | player_id   | player-return-5 |
      | character_id| char-fallen     |
    Then the response status should be 409
    And the response should contain error:
      | field   | value                              |
      | code    | PERMANENT_RESOLUTION               |
      | message | Character cannot return after permanent resolution |
    And the player should be offered to create a new character

  @api @player-return
  Scenario: Handle player return with new character after resolution
    Given a player "player-return-6" previously controlled character "Dead Knight" in world "realm-of-legends"
    And the character was resolved via "TRAGEDY"
    When the player requests a new character via "POST /api/v1/worlds/realm-of-legends/players/player-return-6/new-character" with:
      | field            | value              |
      | character_name   | Squire Renewal     |
      | inherit_knowledge| false              |
      | connection_to_old| former_squire      |
    Then the response status should be 201
    And a new character should be created
    And the new character may have narrative connections to the old one
    And the player status should change to "ACTIVE"

  @domain @player-return
  Scenario: Apply relationship recovery mechanic on return
    Given a player "player-recover" controls character "Absent Lord" in world "realm-of-legends"
    And the player is returning from "GHOST" status
    And character "Absent Lord" has decayed relationships:
      | related_character | original_strength | current_strength |
      | Lady Wife         | 90                | 60               |
      | Loyal Knight      | 85                | 55               |
      | Trading Partner   | 70                | 40               |
    When the player initiates relationship recovery
    Then recovery options should be presented:
      | recovery_method     | cost      | recovery_rate |
      | GRAND_GESTURE       | HIGH      | 50%           |
      | GRADUAL_REBUILDING  | LOW       | 10% per week  |
      | NARRATIVE_QUEST     | MEDIUM    | 30%           |
    And the player should choose a recovery path

  # ============================================================================
  # CRITICAL CHARACTER PROTECTION
  # ============================================================================

  @domain @critical-protection
  Scenario: Protect protagonist characters from resolution
    Given a player "player-protag" controls character "Chosen Hero" in world "realm-of-legends"
    And the character has the narrative role "PROTAGONIST"
    And the player's status is "GHOST" for 30 days
    When resolution is attempted
    Then the resolution should be blocked with reason "PROTAGONIST_PROTECTION"
    And the character should receive extended AI control
    And the world owner should be notified of the situation
    And a domain event "ProtagonistProtectionActivated" should be emitted

  @domain @critical-protection
  Scenario: Protect characters during active plot arcs
    Given a player "player-arc" controls character "Arc Central" in world "realm-of-legends"
    And the character is central to the active plot arc "Dragon Siege"
    And the player's status is "GHOST"
    When resolution is attempted
    Then the resolution should be deferred until the plot arc completes
    And the character should receive plot-appropriate AI control
    And the AI should maintain character consistency during the arc
    And a domain event "PlotProtectionActivated" should be emitted

  @domain @critical-protection
  Scenario: Protect faction leaders from sudden resolution
    Given a player "player-faction" controls character "Faction Commander" in world "realm-of-legends"
    And the character leads faction "Northern Alliance" with 15 member characters
    And the player's status is "GHOST" for 30 days
    When resolution is considered
    Then a succession preparation period should be initiated:
      | phase           | duration | activities                    |
      | ANNOUNCEMENT    | 7 days   | Notify faction members        |
      | SUCCESSION      | 14 days  | Allow leadership transition   |
      | RESOLUTION      | after    | Apply chosen strategy         |
    And faction members should be able to claim leadership
    And a domain event "FactionLeadershipTransitionStarted" should be emitted

  @domain @critical-protection
  Scenario: Maintain character consistency during AI control
    Given a player "player-ai-control" controls character "Temporary AI" in world "realm-of-legends"
    And the character is under AI control due to ghost player protection
    When the AI controls the character for interactions
    Then the AI should maintain:
      | aspect           | requirement                           |
      | personality      | Match established traits              |
      | relationships    | Preserve existing dynamics            |
      | goals            | Continue established objectives       |
      | speech_patterns  | Mimic player's writing style          |
    And AI actions should be logged for player review
    And the player can review and retcon AI decisions on return

  @api @critical-protection
  Scenario: Mark character as critical for protection
    Given a player "player-mark" controls character "Important NPC" in world "realm-of-legends"
    And I am a world owner for world "realm-of-legends"
    When I mark the character as critical via "POST /api/v1/worlds/realm-of-legends/characters/char-important/critical" with:
      | field           | value                    |
      | reason          | CENTRAL_TO_MAIN_PLOT     |
      | protection_level| FULL                     |
      | ai_control_auth | true                     |
    Then the response status should be 200
    And the character should be added to the critical protection list
    And the character cannot be resolved without world owner override

  # ============================================================================
  # EDGE CASES
  # ============================================================================

  @domain @edge-case
  Scenario: Handle partial activity during ghost period
    Given a player "player-partial" controls character "Occasional Visitor" in world "realm-of-legends"
    And the player's activity pattern shows:
      | week  | activity_count | status_at_end |
      | 1     | 5              | ACTIVE        |
      | 2     | 0              | INACTIVE      |
      | 3     | 1              | ACTIVE        |
      | 4     | 0              | INACTIVE      |
      | 5     | 0              | DORMANT       |
    When the activity monitor evaluates the pattern
    Then the player should be flagged as "INTERMITTENT"
    And relationship decay should be applied at reduced rate
    And no resolution should be triggered until consecutive ghost period

  @domain @edge-case
  Scenario: Handle simultaneous ghost status for connected characters
    Given the following players are in "GHOST" status in world "realm-of-legends":
      | player_id   | character_name | relationship_to_others        |
      | player-g1   | Twin Alpha     | SIBLING to Twin Beta          |
      | player-g2   | Twin Beta      | SIBLING to Twin Alpha         |
    When resolution is considered for both characters
    Then the system should recognize the connected ghost situation
    And resolution should be coordinated:
      | strategy   | applies_to | notes                    |
      | MYSTERY    | both       | Disappeared together     |
    And a single narrative event should cover both characters
    And a domain event "CoordinatedResolution" should be emitted

  @domain @edge-case
  Scenario: Handle ghost player during critical narrative moment
    Given a player "player-critical-moment" controls character "Key Witness" in world "realm-of-legends"
    And the character is the only witness to a "murder mystery" plot
    And the player's status changes to "GHOST"
    When the narrative engine detects the critical dependency
    Then the character should receive priority AI control
    And the AI should preserve the critical knowledge:
      | knowledge_type | preserved | notes                          |
      | witness_info   | true      | Cannot be lost                 |
      | testimony      | true      | May be given by AI             |
    And the plot should be allowed to continue
    And a domain event "CriticalKnowledgePreserved" should be emitted

  @domain @edge-case
  Scenario: Handle leadership transfer during ghost period
    Given a player "player-leader" controls character "Guild Master" in world "realm-of-legends"
    And the character leads guild "Merchant's Alliance" with hierarchy:
      | role           | character       | player_status |
      | MASTER         | Guild Master    | GHOST         |
      | SECOND         | Vice Master     | ACTIVE        |
      | TREASURER      | Gold Counter    | ACTIVE        |
    When the ghost player threshold is reached
    Then leadership should automatically transfer:
      | new_role       | character       |
      | ACTING_MASTER  | Vice Master     |
    And the original leader should retain "MASTER_EMERITUS" status
    And the transfer should be reversible on player return

  @domain @edge-case
  Scenario: Handle ghost player with pending obligations
    Given a player "player-obligated" controls character "Sworn Knight" in world "realm-of-legends"
    And the character has pending obligations:
      | obligation_type | to_character    | deadline      | importance |
      | OATH            | King Regent     | in 7 days     | HIGH       |
      | DEBT            | Merchant Guild  | in 14 days    | MEDIUM     |
      | DUEL            | Rival Baron     | in 3 days     | HIGH       |
    And the player's status is "GHOST"
    When obligations come due
    Then obligation outcomes should be determined:
      | obligation_type | outcome          | narrative_effect          |
      | DUEL            | FORFEIT          | Honor decreased           |
      | OATH            | AI_FULFILLMENT   | Maintained with AI        |
      | DEBT            | DEFAULTED        | Merchant hostility        |
    And consequences should be applied to the character

  @domain @edge-case
  Scenario: Handle world-wide activity anomaly
    Given world "realm-of-legends" has 50 active players
    When player activity drops significantly:
      | time_period | active_players | ghost_players |
      | week_1      | 50             | 0             |
      | week_2      | 35             | 10            |
      | week_3      | 20             | 25            |
    Then the system should detect a "MASS_INACTIVITY_EVENT"
    And ghost protocol thresholds should be automatically extended
    And world owner should be alerted with recommendations
    And a domain event "MassInactivityDetected" should be emitted

  # ============================================================================
  # STATE SYNCHRONIZATION
  # ============================================================================

  @domain @state-sync
  Scenario: Synchronize character state on player return
    Given a player "player-sync" controls character "Time Traveler" in world "realm-of-legends"
    And the player was absent for 21 days
    And the following world events occurred during absence:
      | event_type      | description                  | affects_character |
      | WAR_STARTED     | Northern conflict began      | yes               |
      | FACTION_MERGED  | Two guilds combined          | no                |
      | ECONOMY_CRASH   | Market prices dropped 40%    | yes               |
    When the player returns
    Then a state synchronization should occur:
      | sync_element    | description                          |
      | WORLD_EVENTS    | Summary of missed events             |
      | CHARACTER_STATE | Current status and position          |
      | RELATIONSHIPS   | Changed relationship status          |
      | INVENTORY       | Any changes to possessions           |
    And the player should receive a "catch-up" briefing

  @domain @state-sync
  Scenario: Reconcile timeline for returning player
    Given a player "player-timeline" controls character "Historian" in world "realm-of-legends"
    And the player was absent for 28 days
    And 14 in-world days passed during the absence
    When the player returns
    Then timeline reconciliation should occur:
      | aspect              | value                           |
      | real_days_absent    | 28                              |
      | world_days_passed   | 14                              |
      | character_timeline  | narrative_gap_filled            |
      | explanation_type    | character_was_traveling         |
    And the character's personal timeline should be synchronized

  @domain @state-sync
  Scenario: Handle conflicting state on return
    Given a player "player-conflict" controls character "Dual Agent" in world "realm-of-legends"
    And the player was absent during a "faction war" event
    And AI made decisions that conflict with player intentions:
      | ai_decision        | player_preference    | conflict    |
      | Sided with North   | Prefers South        | HIGH        |
      | Sold rare item     | Wanted to keep       | MEDIUM      |
    When the player returns and reviews AI decisions
    Then conflict resolution options should be provided:
      | option           | consequence                     |
      | ACCEPT           | Keep AI decisions               |
      | RETCON_MINOR     | Undo low-impact decisions       |
      | RETCON_MAJOR     | Undo all, narrative explanation |
    And the player should choose how to proceed

  @api @state-sync
  Scenario: Request state synchronization report
    Given a player "player-report" controls character "Merchant Prince" in world "realm-of-legends"
    And the player is returning after absence
    When I request the sync report via "GET /api/v1/worlds/realm-of-legends/players/player-report/sync-report"
    Then the response status should be 200
    And the response should contain:
      | section           | content                          |
      | absence_summary   | Duration and status changes      |
      | world_changes     | Major events during absence      |
      | character_changes | State changes to character       |
      | ai_decisions      | Actions taken by AI if any       |
      | relationship_delta| Relationship changes             |
      | recommended_actions| Suggested next steps            |

  # ============================================================================
  # MULTI-PLAYER IMPACT
  # ============================================================================

  @domain @multi-player
  Scenario: Notify related players of ghost status
    Given a player "player-notif" controls character "Central Hub" in world "realm-of-legends"
    And the character has strong relationships with 5 other player characters
    When the player's status changes to "DORMANT"
    Then related players should receive notifications:
      | player_id   | character_name | notification_type         |
      | player-r1   | Allied Knight  | ALLY_BECOMING_INACTIVE    |
      | player-r2   | Love Interest  | PARTNER_BECOMING_INACTIVE |
      | player-r3   | Rival Lord     | RIVAL_BECOMING_INACTIVE   |
    And notifications should include suggested narrative responses

  @domain @multi-player
  Scenario: Coordinate plot adjustments for ghost player
    Given a player "player-plot" controls character "Plot Driver" in world "realm-of-legends"
    And the character is involved in shared plots with:
      | plot_name        | other_players        | character_role |
      | Dragon Hunt      | player-a, player-b   | LEADER         |
      | Trade Negotiation| player-c             | PRIMARY        |
    When the player's status becomes "GHOST"
    Then plot adjustments should be coordinated:
      | plot_name         | adjustment                        |
      | Dragon Hunt       | Leadership transferred to player-a|
      | Trade Negotiation | Put on hold, awaiting return      |
    And affected players should be notified of adjustments

  @domain @multi-player
  Scenario: Handle group activity with ghost player
    Given a group "Adventuring Party" in world "realm-of-legends" has members:
      | player_id   | character_name | status   |
      | player-1    | Warrior        | ACTIVE   |
      | player-2    | Mage           | ACTIVE   |
      | player-3    | Healer         | GHOST    |
      | player-4    | Rogue          | ACTIVE   |
    When the group attempts a group activity "Dungeon Raid"
    Then the ghost player's character should be handled:
      | option           | description                      |
      | AI_PARTICIPATION | AI controls healer in combat     |
      | NARRATIVE_ABSENCE| Healer stayed behind (story)     |
      | REDUCED_PARTY    | Party proceeds without healer    |
    And active players should vote on the approach

  @api @multi-player
  Scenario: View ghost player impact on world
    Given world "realm-of-legends" has ghost players affecting narratives
    When I request the impact report via "GET /api/v1/worlds/realm-of-legends/ghost-protocol/impact-report"
    Then the response status should be 200
    And the response should contain:
      | metric                    | value                    |
      | total_ghost_players       | count                    |
      | plots_affected            | list of affected plots   |
      | relationships_decaying    | count and details        |
      | pending_resolutions       | characters awaiting      |
      | ai_controlled_characters  | count currently active   |

  # ============================================================================
  # NOTIFICATIONS AND ALERTS
  # ============================================================================

  @api @notifications
  Scenario: Send inactivity warning to player
    Given a player "player-warn" controls character "Warned Hero" in world "realm-of-legends"
    And the player's status is about to change to "DORMANT"
    When the warning threshold is reached (1 day before status change)
    Then a notification should be sent to the player:
      | notification_type | INACTIVITY_WARNING                |
      | channel           | email, in_app                     |
      | message           | Your character will become dormant|
      | action_required   | Log in to prevent decay           |
    And the notification should include return instructions

  @api @notifications
  Scenario: Send resolution warning to player
    Given a player "player-resolve-warn" controls character "Resolution Pending" in world "realm-of-legends"
    And the player's status is about to change to "RESOLVED"
    When the resolution threshold approaches (7 days before)
    Then escalating notifications should be sent:
      | day_before | notification_type      | urgency |
      | 7          | RESOLUTION_APPROACHING | LOW     |
      | 3          | RESOLUTION_IMMINENT    | MEDIUM  |
      | 1          | FINAL_WARNING          | HIGH    |
    And notifications should explain resolution consequences

  @api @notifications
  Scenario: Notify world owner of ghost player situations
    Given I am a world owner for world "realm-of-legends"
    And multiple ghost player situations exist
    When I request the ghost protocol dashboard via "GET /api/v1/worlds/realm-of-legends/ghost-protocol/dashboard"
    Then the response status should be 200
    And the response should contain actionable information:
      | section              | content                         |
      | requiring_attention  | Characters needing resolution   |
      | ai_controlled        | Characters under AI control     |
      | decay_report         | Relationship decay summary      |
      | recommendations      | Suggested actions               |

  @domain @notifications
  Scenario: Generate activity reminder based on player patterns
    Given a player "player-pattern" controls character "Habitual Player" in world "realm-of-legends"
    And the player typically logs in on weekends
    And it's been 10 days since last activity (missing 2 weekends)
    When the pattern-based reminder system activates
    Then a personalized reminder should be sent:
      | reminder_type    | PATTERN_BASED                     |
      | message          | We noticed you usually play on weekends |
      | tone             | friendly, non-pushy               |
      | character_update | Brief on what's happening in-world|

  # ============================================================================
  # ERROR HANDLING AND RECOVERY
  # ============================================================================

  @error @recovery
  Scenario: Handle failed resolution gracefully
    Given a player "player-fail-resolve" controls character "Resolution Failed" in world "realm-of-legends"
    And the resolution process encounters an error
    When resolution fails during execution
    Then the character should remain in pre-resolution state
    And the error should be logged with details
    And a retry should be scheduled
    And world owner should be notified of the failure
    And a domain event "ResolutionFailed" should be emitted with:
      | field       | value                    |
      | character_id| char-resolution-failed   |
      | error_type  | RESOLUTION_ERROR         |
      | retry_at    | <timestamp>              |

  @error @recovery
  Scenario: Recover from activity monitor failure
    Given the activity monitor service experiences an outage
    And activity was not tracked for 6 hours
    When the service recovers
    Then all player activities during outage should be reconciled
    And no false status transitions should occur
    And a domain event "ActivityMonitorRecovered" should be emitted
    And any affected status calculations should be recalculated

  @error @recovery
  Scenario: Handle relationship decay calculation errors
    Given a decay calculation fails for character "Decay Error" in world "realm-of-legends"
    When the error is detected
    Then the relationship state should be preserved
    And the decay should be marked for retry
    And an alert should be generated for investigation
    And the system should continue processing other characters

  @error @recovery
  Scenario: Recover from AI control handoff failure
    Given character "AI Handoff Failed" requires AI control
    And the AI control initialization fails
    When the failure is detected
    Then the character should be marked as "AI_PENDING"
    And manual intervention should be requested
    And the character should not participate in active scenes
    And a fallback narrative should be generated explaining absence

  @api @error
  Scenario: Handle invalid resolution strategy request
    Given a player "player-invalid" controls character "Invalid Request" in world "realm-of-legends"
    When I request resolution via "POST /api/v1/worlds/realm-of-legends/ghost-protocol/resolve" with:
      | field            | value           |
      | player_id        | player-invalid  |
      | character_id     | char-invalid    |
      | strategy         | INVALID_STRATEGY|
    Then the response status should be 400
    And the response should contain error:
      | field   | value                           |
      | code    | INVALID_RESOLUTION_STRATEGY     |
      | message | Strategy must be one of: TRAGEDY, BETRAYAL, STASIS, MYSTERY |
      | valid_strategies | ["TRAGEDY", "BETRAYAL", "STASIS", "MYSTERY"] |

  @api @error
  Scenario: Handle resolution for non-ghost player
    Given a player "player-active" controls character "Active Character" in world "realm-of-legends"
    And the player's status is "ACTIVE"
    When I request resolution via "POST /api/v1/worlds/realm-of-legends/ghost-protocol/resolve" with:
      | field            | value         |
      | player_id        | player-active |
      | character_id     | char-active   |
      | strategy         | TRAGEDY       |
    Then the response status should be 409
    And the response should contain error:
      | field   | value                              |
      | code    | PLAYER_NOT_GHOST                   |
      | message | Cannot resolve character of active player |

  # ============================================================================
  # DOMAIN EVENTS
  # ============================================================================

  @domain-events
  Scenario: Emit domain events for activity status changes
    Given the ghost player protocol is monitoring player activity
    When player status transitions occur
    Then the following domain events should be emitted:
      | status_transition      | event_type                |
      | ACTIVE -> INACTIVE     | PlayerBecameInactive      |
      | INACTIVE -> DORMANT    | PlayerBecameDormant       |
      | DORMANT -> GHOST       | PlayerBecameGhost         |
      | GHOST -> RESOLVED      | PlayerResolved            |
      | * -> ACTIVE            | PlayerReactivated         |
    And each event should contain:
      | field         | description                    |
      | player_id     | The affected player            |
      | character_id  | The player's character         |
      | timestamp     | When the transition occurred   |
      | world_id      | The world context              |

  @domain-events
  Scenario: Emit domain events for relationship decay
    Given relationship decay is being applied
    When decay affects relationships
    Then the following domain events should be emitted:
      | event_type              | trigger                        |
      | RelationshipDecayStarted| First decay for a character    |
      | RelationshipDecayed     | Each decay application         |
      | RelationshipCritical    | Relationship drops below 20%   |
      | RelationshipBroken      | Relationship drops to 0        |
    And related characters should receive appropriate notifications

  @domain-events
  Scenario: Emit domain events for resolution process
    Given a character resolution is being processed
    When the resolution completes
    Then the following domain events should be emitted:
      | event_type                  | scenario                    |
      | ResolutionStarted           | Process begins              |
      | CharacterResolvedByTragedy  | TRAGEDY strategy applied    |
      | CharacterResolvedByBetrayal | BETRAYAL strategy applied   |
      | CharacterResolvedByStasis   | STASIS strategy applied     |
      | CharacterResolvedByMystery  | MYSTERY strategy applied    |
      | ResolutionCompleted         | Process completes           |
    And downstream systems should react appropriately

  @domain-events
  Scenario: Emit domain events for player return
    Given a player is returning from ghost status
    When the return process completes
    Then the following domain events should be emitted:
      | event_type               | content                        |
      | PlayerReturnInitiated    | Return request received        |
      | CharacterStateRestored   | Character state synchronized   |
      | RelationshipRecoveryStart| Recovery process begins        |
      | PlayerReturnCompleted    | Full return processed          |
    And interested systems should update their state

  @domain-events
  Scenario: Emit domain events for AI control transitions
    Given AI control is being managed for ghost player characters
    When AI control transitions occur
    Then the following domain events should be emitted:
      | event_type            | trigger                         |
      | AIControlActivated    | AI takes control of character   |
      | AIActionPerformed     | AI performs character action    |
      | AIControlDeactivated  | Player returns, AI releases     |
      | AIDecisionLogged      | Significant AI decision made    |
    And AI actions should be available for player review

  # ============================================================================
  # INTEGRATION SCENARIOS
  # ============================================================================

  @integration
  Scenario: Full ghost player lifecycle
    Given a new player "player-lifecycle" joins world "realm-of-legends" with character "Lifecycle Hero"
    When the player goes through the complete ghost lifecycle:
      | phase          | duration | actions                           |
      | ACTIVE         | 30 days  | Regular participation             |
      | INACTIVE       | 5 days   | No activity                       |
      | DORMANT        | 10 days  | Relationship decay begins         |
      | GHOST          | 20 days  | Character flagged for resolution  |
      | RESOLUTION     | 1 day    | STASIS strategy applied           |
      | RETURN         | 1 day    | Player returns, awakens           |
      | ACTIVE         | ongoing  | Regular participation resumes     |
    Then the complete lifecycle should be handled correctly
    And all domain events should be properly emitted
    And relationships should reflect the journey

  @integration
  Scenario: Ghost protocol interaction with world events
    Given world "realm-of-legends" has an active "World War" event
    And multiple players are in ghost status
    When the world event affects ghost player characters
    Then ghost characters should be handled appropriately:
      | character_type    | handling                          |
      | GHOST_LEADER      | Temporary AI assumes command      |
      | GHOST_SOLDIER     | Listed as missing in action       |
      | GHOST_CIVILIAN    | Evacuated to safety (narrative)   |
    And returning players should receive war update briefings

  @integration
  Scenario: Ghost protocol with relationship system
    Given character "Central Figure" has complex relationships
    And the controlling player becomes a ghost
    When relationships are processed during ghost period
    Then relationship decay should integrate with relationship events:
      | related_event          | ghost_protocol_action              |
      | RELATIONSHIP_MILESTONE | Milestone delayed, not cancelled   |
      | RELATIONSHIP_CONFLICT  | Conflict paused pending return     |
      | RELATIONSHIP_BOND      | Bond preserved at current level    |
    And relationship system should respect ghost protocol states

  @integration
  Scenario: Ghost protocol with narrative engine
    Given the narrative engine is generating story content
    And ghost player characters exist in the world
    When narratives are generated
    Then ghost characters should be handled narratively:
      | narrative_element | ghost_handling                     |
      | SCENE_GENERATION  | Ghost characters in background     |
      | DIALOGUE          | AI responses or absence explained  |
      | PLOT_ADVANCEMENT  | Ghost plots on hold or adapted     |
    And returning players should have smooth narrative reintegration
