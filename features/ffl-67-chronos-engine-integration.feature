@chronos @engine @narrative @procedural @epic
Feature: Chronos Engine Integration
  As a system architect
  I want to incorporate the Chronos Engine architecture into ANIMA
  So that I can create a Procedural Narrative Generation Engine

  Background:
    Given the ANIMA system is initialized
    And the Chronos Engine components are configured
    And Neo4j graph database is running

  # =============================================================================
  # DIMENSIONAL CONFIGURATION (WORLD DIALS)
  # =============================================================================

  @dimensions @configuration
  Scenario: Configure world dimensions via dials
    Given a new world is being created
    When I configure dimensional dials
    Then I should be able to set:
      | Dimension           | Range     | Description                        |
      | Technology Level    | 0-10      | From primitive to futuristic       |
      | Magic Prevalence    | 0-10      | From mundane to high fantasy       |
      | Social Structure    | 0-10      | From anarchic to rigid hierarchy   |
      | Conflict Level      | 0-10      | From peaceful to war-torn          |
      | Moral Ambiguity     | 0-10      | From black/white to grey           |
      | Supernatural        | 0-10      | From realistic to supernatural     |
    And each dimension affects world generation

  @dimensions @locking
  Scenario: Lock dimensions after world launch
    Given a world with configured dimensions
    When the world is launched
    Then dimensional settings should be locked
    And attempts to modify dimensions should be rejected
    And the lock status should be recorded:
      | Field               | Value                              |
      | lockedAt            | Launch timestamp                   |
      | lockedBy            | System or user ID                  |
      | reason              | WORLD_LAUNCHED                     |

  @dimensions @presets
  Scenario: Apply dimensional presets
    Given predefined dimension presets exist:
      | Preset              | Tech | Magic | Social | Conflict |
      | Medieval Fantasy    | 2    | 8     | 7      | 6        |
      | Cyberpunk           | 9    | 1     | 4      | 8        |
      | Space Opera         | 10   | 3     | 6      | 7        |
      | Victorian Mystery   | 5    | 2     | 8      | 4        |
    When I apply preset "Medieval Fantasy"
    Then all dimensions should be set to preset values
    And I should be able to fine-tune individual dials

  @dimensions @validation
  Scenario: Validate dimension combinations
    Given dimensions are being configured
    When I set incompatible dimension values
    Then the system should warn about:
      | Conflict Type       | Example                            |
      | Logical conflict    | High tech + primitive society      |
      | Narrative conflict  | No conflict + war story            |
      | Genre mismatch      | Settings incompatible with genre   |
    And suggestions should be provided

  @dimensions @effects
  Scenario: Dimensions affect entity generation
    Given a world with specific dimensional settings
    When entities are generated for the world
    Then entity attributes should reflect dimensions:
      | Dimension           | Entity Effect                      |
      | Technology Level    | Available tools, weapons, transport|
      | Magic Prevalence    | Magical abilities, artifacts       |
      | Social Structure    | Titles, relationships, power       |
      | Conflict Level      | Tensions, alliances, enemies       |

  # =============================================================================
  # NEO4J GRAPH DATABASE
  # =============================================================================

  @neo4j @connection
  Scenario: Connect to self-hosted Neo4j instance
    Given Neo4j is configured as self-hosted
    When the system initializes database connection
    Then connection should be established with:
      | Setting             | Description                        |
      | uri                 | Neo4j bolt protocol URI            |
      | username            | Database username                  |
      | password            | Encrypted password                 |
      | database            | Target database name               |
      | connectionPool      | Connection pool settings           |
    And connection health should be verified

  @neo4j @schema
  Scenario: Define graph schema for narrative elements
    Given Neo4j is connected
    When I define the narrative schema
    Then the following node types should exist:
      | Node Type           | Properties                         |
      | Character           | id, name, traits, role             |
      | Location            | id, name, type, coordinates        |
      | Event               | id, name, timestamp, significance  |
      | Object              | id, name, type, properties         |
      | Concept             | id, name, category, meaning        |
    And relationship types should include:
      | Relationship        | Description                        |
      | KNOWS               | Character knows character          |
      | LOCATED_AT          | Entity at location                 |
      | PARTICIPATED_IN     | Character in event                 |
      | OWNS                | Character owns object              |
      | CAUSES              | Event causes event                 |

  @neo4j @queries
  Scenario: Query narrative graph efficiently
    Given a populated narrative graph
    When I query for character relationships
    Then I should use optimized Cypher queries
    And query performance should meet:
      | Query Type          | Max Response Time                  |
      | Direct relationships| < 50ms                             |
      | 2-hop relationships | < 100ms                            |
      | Path finding        | < 200ms                            |
      | Aggregations        | < 500ms                            |

  @neo4j @indexing
  Scenario: Create indexes for narrative queries
    Given the narrative schema is defined
    When I configure indexes
    Then indexes should be created for:
      | Node Type           | Indexed Properties                 |
      | Character           | id, name, worldId                  |
      | Location            | id, name, worldId                  |
      | Event               | id, timestamp, worldId             |
    And full-text search indexes should be created

  @neo4j @transactions
  Scenario: Manage graph transactions for narrative updates
    Given narrative elements are being modified
    When I update multiple related nodes
    Then transactions should:
      | Requirement         | Description                        |
      | Atomicity           | All or nothing updates             |
      | Consistency         | Maintain graph constraints         |
      | Isolation           | Concurrent access handling         |
      | Durability          | Persist after commit               |

  @neo4j @backup
  Scenario: Backup and restore narrative graph
    Given a narrative graph with critical data
    When I configure backup strategy
    Then backups should:
      | Feature             | Description                        |
      | Scheduled           | Regular automated backups          |
      | Incremental         | Only changes since last backup     |
      | Point-in-time       | Restore to specific moment         |
      | Verification        | Validate backup integrity          |

  # =============================================================================
  # CAUSALITY DAG (DIRECTED ACYCLIC GRAPH)
  # =============================================================================

  @causality @structure
  Scenario: Define causality DAG structure
    Given a narrative requires causal relationships
    When I model causality
    Then the DAG should support:
      | Element             | Description                        |
      | Cause nodes         | Events that cause effects          |
      | Effect nodes        | Events caused by other events      |
      | Causal edges        | Directed cause-effect links        |
      | Probability weights | Likelihood of causal chain         |
      | Time constraints    | Temporal ordering requirements     |

  @causality @creation
  Scenario: Create causal relationships between events
    Given events exist in the narrative:
      | Event ID   | Event Name              |
      | evt-001    | Romeo meets Juliet      |
      | evt-002    | Romeo and Juliet fall in love |
      | evt-003    | Families discover romance |
      | evt-004    | Tragic conclusion       |
    When I define causal relationships
    Then the DAG should connect:
      | Cause Event | Effect Event            | Probability |
      | evt-001     | evt-002                 | 0.85        |
      | evt-002     | evt-003                 | 0.90        |
      | evt-003     | evt-004                 | 0.75        |

  @causality @validation
  Scenario: Validate DAG has no cycles
    Given a causality graph is being constructed
    When I add a causal relationship
    Then the system should:
      | Check               | Action                             |
      | Detect cycles       | Prevent circular causality         |
      | Verify direction    | Ensure causes precede effects      |
      | Check consistency   | Validate temporal ordering         |
    And cycle violations should be rejected with clear errors

  @causality @traversal
  Scenario: Traverse causal chains for narrative generation
    Given a populated causality DAG
    When I traverse causal chains
    Then I should be able to:
      | Traversal Type      | Description                        |
      | Forward             | Find all effects of an event       |
      | Backward            | Find all causes of an event        |
      | Critical path       | Find most likely causal chain      |
      | Alternative paths   | Find branching possibilities       |

  @causality @probability
  Scenario: Calculate narrative probability through DAG
    Given causal chains with probability weights
    When I calculate narrative likelihood
    Then the system should:
      | Calculation         | Description                        |
      | Chain probability   | Product of edge probabilities      |
      | Branching factor    | Alternative outcome likelihood     |
      | Surprise factor     | Low probability event impact       |
    And probability thresholds should filter narratives

  @causality @branching
  Scenario: Support narrative branching via causality
    Given a causal decision point
    When multiple outcomes are possible
    Then the DAG should support:
      | Feature             | Description                        |
      | Multiple effects    | Single cause, multiple effects     |
      | Conditional edges   | Context-dependent causality        |
      | Probability split   | Divide probability across branches |
      | Branch tracking     | Track which branch was taken       |

  # =============================================================================
  # CHARACTER-AI (SHARED CORTEX MODEL)
  # =============================================================================

  @character-ai @cortex
  Scenario: Implement shared cortex model for characters
    Given multiple characters exist in a world
    When I configure the shared cortex
    Then the cortex should:
      | Feature             | Description                        |
      | Base model          | Shared foundation for all characters |
      | Character vectors   | Per-character personality embeddings |
      | Memory integration  | Access to character memories       |
      | Context awareness   | Understand current narrative state |

  @character-ai @personality
  Scenario: Model character personality via embeddings
    Given a character with defined traits
    When I generate personality embedding
    Then the embedding should capture:
      | Trait Category      | Dimensions                         |
      | Temperament         | Calm/volatile, optimistic/pessimistic |
      | Values              | Honor, loyalty, ambition, compassion |
      | Intelligence        | Cunning, wisdom, emotional IQ      |
      | Social style        | Introvert/extrovert, leader/follower |
    And embeddings should influence behavior generation

  @character-ai @behavior
  Scenario: Generate character behavior from AI
    Given a character in a narrative situation
    When the character needs to act
    Then the AI should generate behavior that:
      | Requirement         | Description                        |
      | Consistent          | Matches character personality      |
      | Contextual          | Appropriate to situation           |
      | Memorable           | Reflects character history         |
      | Surprising          | Occasionally unexpected but valid  |

  @character-ai @dialogue
  Scenario: Generate character dialogue
    Given a character needs to speak
    When generating dialogue
    Then the AI should produce speech that:
      | Aspect              | Description                        |
      | Voice               | Unique speaking style              |
      | Vocabulary          | Appropriate word choice            |
      | Subtext             | Hidden meanings and intentions     |
      | Emotion             | Reflects current emotional state   |

  @character-ai @memory
  Scenario: Integrate character memory into AI decisions
    Given a character has accumulated memories
    When the character makes decisions
    Then memories should influence:
      | Memory Type         | Influence                          |
      | Past relationships  | Trust/distrust of others           |
      | Traumatic events    | Avoidance or fear responses        |
      | Successes           | Confidence in similar situations   |
      | Learned lessons     | Changed behavior patterns          |

  @character-ai @lora
  Scenario: Configure LoRA training for character fine-tuning
    Given characters need specialized behavior
    When I configure LoRA training
    Then training should be:
      | Setting             | Value                              |
      | Mode                | Async/Offline                      |
      | Trigger             | Sufficient character interactions  |
      | Data source         | Character dialogue and actions     |
      | Update frequency    | Configurable interval              |
    And training should not interrupt real-time operations

  @character-ai @lora-application
  Scenario: Apply LoRA adaptations to character AI
    Given LoRA training has completed for a character
    When the character's AI is invoked
    Then the system should:
      | Action              | Description                        |
      | Load base model     | Shared cortex foundation           |
      | Apply LoRA weights  | Character-specific adaptations     |
      | Merge embeddings    | Combine with personality vectors   |
      | Generate response   | Character-appropriate output       |

  # =============================================================================
  # AI DIRECTOR
  # =============================================================================

  @ai-director @orchestration
  Scenario: AI Director orchestrates narrative flow
    Given an active narrative session
    When the AI Director manages the story
    Then it should orchestrate:
      | Responsibility      | Description                        |
      | Pacing              | Control narrative speed            |
      | Tension             | Manage dramatic tension            |
      | Character arcs      | Guide character development        |
      | Plot progression    | Move story toward goals            |
      | Balance             | Balance player agency vs story     |

  @ai-director @tension
  Scenario: Manage narrative tension curves
    Given a narrative is in progress
    When the AI Director analyzes tension
    Then it should:
      | Action              | Description                        |
      | Track tension level | Current dramatic tension (0-10)    |
      | Plan beats          | Upcoming tension changes           |
      | Insert conflicts    | Add tension when too low           |
      | Provide relief      | Add calm moments when too high     |
    And tension should follow dramatic arc patterns

  @ai-director @pacing
  Scenario: Control narrative pacing
    Given narrative events are occurring
    When the AI Director manages pacing
    Then it should balance:
      | Pace Element        | Description                        |
      | Action scenes       | High-energy moments                |
      | Dialogue scenes     | Character interaction              |
      | Exposition          | World and plot information         |
      | Reflection          | Character introspection            |
    And pacing should match genre expectations

  @ai-director @goals
  Scenario: Define and track narrative goals
    Given a narrative has story objectives
    When the AI Director tracks goals
    Then goals should be managed:
      | Goal Type           | Description                        |
      | Main plot           | Primary story objective            |
      | Subplots            | Secondary story threads            |
      | Character goals     | Individual character objectives    |
      | World events        | Background happening               |
    And goal progress should influence direction

  @ai-director @intervention
  Scenario: AI Director intervention in narrative
    Given the narrative is drifting off course
    When intervention is needed
    Then the AI Director can:
      | Intervention        | Description                        |
      | Introduce NPC       | Add character to redirect          |
      | Trigger event       | Cause event to force direction     |
      | Reveal information  | Expose plot-relevant info          |
      | Create obstacle     | Block unwanted narrative path      |
    And interventions should feel organic

  @ai-director @adaptation
  Scenario: Adapt narrative to player choices
    Given players make unexpected choices
    When the AI Director adapts
    Then adaptation should:
      | Principle           | Description                        |
      | Preserve agency     | Honor player decisions             |
      | Maintain coherence  | Keep story logical                 |
      | Adjust goals        | Modify achievable objectives       |
      | Create consequences | Meaningful results from choices    |

  # =============================================================================
  # GHOST PLAYER PROTOCOL
  # =============================================================================

  @ghost-player @activation
  Scenario: Activate ghost player when player is absent
    Given a player is part of an active narrative
    When the player becomes unavailable
    Then the ghost player should:
      | Action              | Description                        |
      | Activate            | Take over player character         |
      | Mimic behavior      | Match player's decision patterns   |
      | Preserve state      | Maintain character consistency     |
      | Log actions         | Record all ghost player actions    |

  @ghost-player @behavior
  Scenario: Ghost player mimics player behavior
    Given ghost player is active
    When the character needs to act
    Then ghost player should:
      | Behavior Source     | Description                        |
      | Historical actions  | Past player decisions              |
      | Stated preferences  | Explicit player preferences        |
      | Character traits    | In-character behavior              |
      | Safe choices        | Conservative when uncertain        |

  @ghost-player @handoff
  Scenario: Hand control back to returning player
    Given ghost player is controlling a character
    When the player returns
    Then handoff should:
      | Step                | Description                        |
      | Notify player       | Summarize ghost player actions     |
      | Sync state          | Ensure player has current state    |
      | Transfer control    | Seamless control return            |
      | Offer review        | Allow player to review decisions   |

  @ghost-player @limitations
  Scenario: Ghost player respects limitations
    Given ghost player is active
    When making decisions
    Then ghost player should NOT:
      | Restriction         | Description                        |
      | Major commitments   | No permanent life changes          |
      | Relationship changes| No major relationship decisions    |
      | Resource spending   | No significant resource use        |
      | Story-critical      | No irreversible plot decisions     |
    And restricted situations should pause or defer

  @ghost-player @transparency
  Scenario: Ghost player actions are transparent
    Given ghost player has taken actions
    When player reviews session
    Then they should see:
      | Information         | Description                        |
      | Action log          | All actions taken                  |
      | Decision reasoning  | Why decisions were made            |
      | Alternatives        | Other options considered           |
      | Impact summary      | Effects of ghost player actions    |

  # =============================================================================
  # PROCEDURAL NARRATIVE GENERATION
  # =============================================================================

  @procedural @generation
  Scenario: Generate narrative procedurally
    Given world dimensions and entities are defined
    When I request narrative generation
    Then the engine should:
      | Step                | Description                        |
      | Analyze context     | Current world and character state  |
      | Query causality     | Possible events from DAG           |
      | Apply AI Director   | Filter for pacing and tension      |
      | Generate content    | Create narrative text and events   |
      | Update graph        | Record new narrative elements      |

  @procedural @coherence
  Scenario: Maintain narrative coherence
    Given ongoing procedural generation
    When generating new content
    Then coherence should be maintained:
      | Coherence Type      | Validation                         |
      | Temporal            | Events in chronological order      |
      | Causal              | Effects follow causes              |
      | Character           | Actions match personalities        |
      | World               | Respects dimensional constraints   |

  @procedural @emergence
  Scenario: Support emergent narrative
    Given complex character and event interactions
    When the narrative develops
    Then emergence should be allowed:
      | Emergent Feature    | Description                        |
      | Unexpected alliances| Characters form unlikely bonds     |
      | Plot twists         | Surprising but logical developments|
      | Character growth    | Natural character evolution        |
      | World evolution     | World changes from events          |

  @procedural @seeding
  Scenario: Seed narrative with initial conditions
    Given a new narrative is starting
    When I provide seed elements
    Then the engine should incorporate:
      | Seed Type           | Description                        |
      | Inciting incident   | Event that starts the story        |
      | Initial conflict    | Central tension to develop         |
      | Key characters      | Important characters to feature    |
      | Setting             | Initial location and time          |

  # =============================================================================
  # INTEGRATION ARCHITECTURE
  # =============================================================================

  @integration @components
  Scenario: Integrate all Chronos Engine components
    Given all components are implemented
    When the engine operates
    Then components should interact:
      | Source              | Target              | Interaction          |
      | Dimensions          | Entity Generation   | Constrain attributes |
      | Neo4j               | Causality DAG       | Store relationships  |
      | Causality DAG       | AI Director         | Inform decisions     |
      | Character-AI        | Narrative Generation| Generate content     |
      | AI Director         | Ghost Player        | Coordinate actions   |

  @integration @event-flow
  Scenario: Define event flow between components
    Given the engine is processing a narrative moment
    When an event occurs
    Then the flow should be:
      | Step | Component           | Action                           |
      | 1    | Event Trigger       | New event initiated              |
      | 2    | Causality DAG       | Determine valid effects          |
      | 3    | AI Director         | Select appropriate effect        |
      | 4    | Character-AI        | Generate character responses     |
      | 5    | Neo4j               | Persist new state                |
      | 6    | Narrative Output    | Present to players               |

  @integration @api
  Scenario: Expose Chronos Engine via API
    Given the engine is running
    When I access the API
    Then I should be able to:
      | Endpoint            | Function                           |
      | /worlds             | Manage world dimensions            |
      | /characters         | Manage character AI                |
      | /narrative          | Generate narrative content         |
      | /causality          | Query causal relationships         |
      | /director           | Configure AI Director              |
      | /ghost-player       | Manage ghost player settings       |

  # =============================================================================
  # PERFORMANCE AND SCALING
  # =============================================================================

  @performance @realtime
  Scenario: Support real-time narrative generation
    Given players are in an active session
    When narrative generation is requested
    Then response should be:
      | Metric              | Requirement                        |
      | Latency             | < 500ms for simple generation      |
      | Latency             | < 2000ms for complex generation    |
      | Throughput          | 100+ concurrent sessions           |
      | Consistency         | Stable response times              |

  @performance @caching
  Scenario: Cache frequently accessed narrative data
    Given narrative queries are repetitive
    When I configure caching
    Then caching should apply to:
      | Cache Target        | TTL                                |
      | Character profiles  | 5 minutes                          |
      | Relationship graph  | 1 minute                           |
      | Causality paths     | 30 seconds                         |
      | Generated content   | Context-dependent                  |

  @performance @scaling
  Scenario: Scale engine horizontally
    Given load increases beyond single instance
    When I scale the engine
    Then scaling should support:
      | Component           | Scaling Strategy                   |
      | API layer           | Horizontal pod scaling             |
      | Neo4j               | Read replicas                      |
      | Character-AI        | GPU instance scaling               |
      | AI Director         | Stateless horizontal scaling       |

  # =============================================================================
  # ERROR HANDLING
  # =============================================================================

  @error @generation-failure
  Scenario: Handle narrative generation failure
    Given narrative generation is attempted
    When generation fails
    Then the system should:
      | Action              | Description                        |
      | Log error           | Record failure details             |
      | Fallback            | Use simpler generation             |
      | Notify              | Alert operators                    |
      | Recover             | Resume from last good state        |

  @error @database-failure
  Scenario: Handle Neo4j connection failure
    Given Neo4j becomes unavailable
    When database operations fail
    Then the system should:
      | Action              | Description                        |
      | Detect failure      | Identify connection loss           |
      | Queue operations    | Buffer pending writes              |
      | Use cache           | Serve reads from cache             |
      | Reconnect           | Attempt automatic reconnection     |
      | Alert               | Notify operators                   |

  @error @ai-failure
  Scenario: Handle Character-AI failure
    Given Character-AI model fails
    When AI generation fails
    Then the system should:
      | Action              | Description                        |
      | Fallback model      | Use backup/simpler model           |
      | Template response   | Use pre-defined responses          |
      | Log failure         | Record for investigation           |
      | Graceful degrade    | Maintain narrative flow            |

  # =============================================================================
  # MONITORING AND OBSERVABILITY
  # =============================================================================

  @monitoring @metrics
  Scenario: Monitor Chronos Engine metrics
    Given the engine is running
    When I access monitoring
    Then I should see metrics for:
      | Metric Category     | Specific Metrics                   |
      | Generation          | Latency, throughput, error rate    |
      | Neo4j               | Query time, connection pool        |
      | Character-AI        | Inference time, model usage        |
      | AI Director         | Decision count, intervention rate  |
      | Ghost Player        | Activation count, handoff success  |

  @monitoring @tracing
  Scenario: Trace narrative generation requests
    Given narrative generation is requested
    When I trace the request
    Then trace should show:
      | Span                | Information                        |
      | Request received    | Timestamp, parameters              |
      | Causality query     | DAG traversal time                 |
      | AI Director decision| Decision made, reason              |
      | Character-AI call   | Model, latency, tokens             |
      | Neo4j update        | Write operations, duration         |
      | Response sent       | Total time, content size           |

  @monitoring @alerts
  Scenario: Configure alerting for engine issues
    Given monitoring is active
    When I configure alerts
    Then alerts should trigger for:
      | Condition           | Severity | Action                     |
      | High latency        | Warning  | Notify team                |
      | Generation errors   | Error    | Page on-call               |
      | Neo4j down          | Critical | Immediate escalation       |
      | AI model failure    | Error    | Fallback + notify          |
