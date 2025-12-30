@world @entities @aggregation @mvp-foundation
Feature: World Entities Aggregation
  As a world creator
  I want entities from multiple documents to be intelligently aggregated
  So that I have a unified view of each entity across my world

  Background:
    Given I am authenticated as a user
    And a world exists with id "test-world-123"
    And the following documents have been processed in the world:
      | documentId | title              | entitiesCount |
      | doc-001    | Romeo and Juliet   | 15            |
      | doc-002    | Merchant of Venice | 12            |
      | doc-003    | Hamlet             | 20            |

  # =============================================================================
  # SAME ENTITY AGGREGATION
  # =============================================================================

  @aggregation @same-entity
  Scenario: Aggregate same entity appearing in multiple documents
    Given entity "Romeo" appears in the following documents:
      | documentId | occurrences | context                              |
      | doc-001    | 150         | Protagonist of Romeo and Juliet      |
      | doc-005    | 25          | Referenced in comparative analysis   |
    When the system aggregates entities for world "test-world-123"
    Then a single aggregated entity "Romeo" should exist
    And the aggregated entity should have:
      | Field               | Value                          |
      | documentIds         | [doc-001, doc-005]             |
      | totalOccurrences    | 175                            |
      | primaryDocumentId   | doc-001                        |
      | aggregationStatus   | AGGREGATED                     |
    And the entity should have occurrence breakdown by document

  @aggregation @merge-descriptions
  Scenario: Merge entity descriptions from multiple sources
    Given entity "Juliet" has descriptions from multiple documents:
      | documentId | description                                      |
      | doc-001    | Daughter of Capulet, Romeo's love interest       |
      | doc-006    | Young noblewoman of Verona                       |
      | doc-007    | Tragic heroine who defies her family             |
    When the system aggregates entity descriptions
    Then the aggregated description should combine all sources
    And the aggregated description should:
      | Requirement              | Description                          |
      | Be coherent              | No contradictions or repetitions     |
      | Preserve key details     | All important facts included         |
      | Cite sources             | Reference document origins           |
      | Prioritize by relevance  | Primary document weighted higher     |

  @aggregation @cross-document
  Scenario: Track entity mentions across documents
    Given entity "Verona" appears in multiple documents:
      | documentId | mentions | type        |
      | doc-001    | 45       | Location    |
      | doc-002    | 12       | Location    |
      | doc-008    | 8        | Location    |
    When the system aggregates cross-document mentions
    Then the aggregated entity should show:
      | Metric              | Value                          |
      | totalMentions       | 65                             |
      | documentCoverage    | 3 documents                    |
      | averagePerDocument  | 21.67                          |
    And I should see mention distribution across documents

  @aggregation @primary-source
  Scenario: Determine primary source document for entity
    Given entity "Hamlet" appears in documents with varying relevance:
      | documentId | occurrences | isProtagonist | narrativeWeight |
      | doc-003    | 500         | true          | 0.95            |
      | doc-009    | 15          | false         | 0.20            |
      | doc-010    | 8           | false         | 0.10            |
    When the system determines primary source
    Then doc-003 should be designated as primary source
    And the primary source selection should be based on:
      | Factor              | Weight                         |
      | Occurrence count    | 0.30                           |
      | Protagonist status  | 0.35                           |
      | Narrative weight    | 0.35                           |

  # =============================================================================
  # NAME VARIATION HANDLING
  # =============================================================================

  @name-variations @detection
  Scenario: Detect and link name variations
    Given the following entities exist in world "test-world-123":
      | entityId    | name              | documentId |
      | ent-001     | Romeo             | doc-001    |
      | ent-002     | Romeo Montague    | doc-005    |
      | ent-003     | Young Montague    | doc-006    |
      | ent-004     | The Montague boy  | doc-007    |
    When the system detects name variations
    Then entities should be linked as variations:
      | Canonical Name | Variations                                    |
      | Romeo          | Romeo Montague, Young Montague, The Montague boy |
    And a single canonical entity should be created
    And variations should be preserved for reference

  @name-variations @aliases
  Scenario: Track entity aliases and nicknames
    Given entity "Richard III" has various references:
      | alias                | documentId | context                    |
      | Richard              | doc-011    | Formal reference           |
      | The Duke of Gloucester| doc-012   | Title before coronation    |
      | Crookback            | doc-013    | Derogatory nickname        |
      | King Richard         | doc-014    | Post-coronation title      |
    When the system aggregates aliases
    Then the entity should have:
      | Field         | Value                                          |
      | canonicalName | Richard III                                    |
      | aliases       | [Richard, Duke of Gloucester, Crookback, King Richard] |
      | aliasCount    | 4                                              |
    And each alias should retain its source context

  @name-variations @fuzzy-matching
  Scenario: Use fuzzy matching for name variations
    Given the following potentially related entities:
      | entityId    | name           | documentId |
      | ent-010     | Mercutio       | doc-001    |
      | ent-011     | Mercucio       | doc-015    |
      | ent-012     | Mertucio       | doc-016    |
    When the system applies fuzzy matching with threshold 0.85
    Then entities should be matched based on:
      | Algorithm           | Weight                         |
      | Levenshtein distance| 0.40                           |
      | Phonetic similarity | 0.30                           |
      | Context similarity  | 0.30                           |
    And matched entities should be flagged for review
    And match confidence should be recorded

  @name-variations @disambiguation
  Scenario: Disambiguate entities with same name
    Given multiple entities named "John" exist:
      | entityId    | context                     | documentId |
      | ent-020     | King John of England        | doc-017    |
      | ent-021     | John the Baptist            | doc-018    |
      | ent-022     | John Falstaff               | doc-019    |
    When the system processes disambiguation
    Then entities should remain separate based on:
      | Factor              | Description                    |
      | Context analysis    | Different roles and settings   |
      | Type classification | Different entity sub-types     |
      | Relationship graphs | Different relationship networks|
    And each "John" should be a distinct entity
    And disambiguation reasoning should be recorded

  @name-variations @cultural
  Scenario: Handle cultural naming conventions
    Given entities with cultural naming variations:
      | entityId    | name              | culture    | documentId |
      | ent-030     | Othello           | Venetian   | doc-020    |
      | ent-031     | The Moor          | European   | doc-020    |
      | ent-032     | General Othello   | Military   | doc-021    |
    When the system applies cultural name normalization
    Then variations should be properly linked
    And cultural context should be preserved
    And the system should recognize:
      | Pattern             | Examples                       |
      | Title + Name        | General Othello = Othello      |
      | Descriptor          | The Moor = Othello             |
      | Role-based names    | The General = Othello          |

  # =============================================================================
  # ATTRIBUTE AGGREGATION
  # =============================================================================

  @attributes @merge
  Scenario: Aggregate entity attributes from multiple sources
    Given entity "Macbeth" has attributes from different documents:
      | documentId | attribute     | value                    |
      | doc-022    | title         | Thane of Glamis          |
      | doc-023    | title         | Thane of Cawdor          |
      | doc-024    | title         | King of Scotland         |
      | doc-022    | trait         | Ambitious                |
      | doc-023    | trait         | Superstitious            |
      | doc-024    | trait         | Guilt-ridden             |
    When the system aggregates attributes
    Then the entity should have merged attributes:
      | Attribute    | Values                                          |
      | titles       | [Thane of Glamis, Thane of Cawdor, King of Scotland] |
      | traits       | [Ambitious, Superstitious, Guilt-ridden]        |
    And attribute sources should be tracked

  @attributes @evolution
  Scenario: Track attribute evolution across documents
    Given entity "Hamlet" has evolving attributes:
      | documentId | attribute     | value           | narrativePosition |
      | doc-003    | mood          | Melancholic     | Act 1             |
      | doc-003    | mood          | Feigning madness| Act 2             |
      | doc-003    | mood          | Resolved        | Act 5             |
    When the system tracks attribute evolution
    Then the entity should have:
      | Field              | Value                          |
      | attributeTimeline  | Chronological attribute changes|
      | currentState       | Most recent attribute values   |
      | evolutionHistory   | Full history of changes        |

  @attributes @confidence
  Scenario: Weight attributes by extraction confidence
    Given entity "Ophelia" has attributes with varying confidence:
      | documentId | attribute     | value           | confidence |
      | doc-003    | relationship  | Hamlet's beloved| 0.95       |
      | doc-025    | relationship  | Hamlet's friend | 0.45       |
      | doc-003    | fate          | Drowning        | 0.98       |
    When the system aggregates with confidence weighting
    Then high-confidence attributes should take precedence
    And low-confidence conflicts should be flagged for review
    And the aggregated entity should show:
      | Attribute    | Value           | Confidence |
      | relationship | Hamlet's beloved| 0.95       |
      | fate         | Drowning        | 0.98       |

  @attributes @deduplication
  Scenario: Deduplicate redundant attributes
    Given entity "Lady Macbeth" has redundant attributes:
      | documentId | attribute     | value                    |
      | doc-022    | role          | Queen of Scotland        |
      | doc-023    | role          | Scottish Queen           |
      | doc-024    | role          | Macbeth's Queen          |
    When the system deduplicates attributes
    Then semantically equivalent values should be merged
    And a canonical value should be selected
    And the system should record:
      | Field              | Value                          |
      | canonicalValue     | Queen of Scotland              |
      | equivalentValues   | [Scottish Queen, Macbeth's Queen] |
      | deduplicationMethod| Semantic similarity            |

  # =============================================================================
  # CONFLICTING TYPE RESOLUTION
  # =============================================================================

  @conflict @type
  Scenario: Handle conflicting entity type classifications
    Given entity "Venice" is classified differently across documents:
      | documentId | entityType   | confidence |
      | doc-002    | Location     | 0.92       |
      | doc-020    | Organization | 0.65       |
      | doc-026    | Location     | 0.88       |
    When the system resolves type conflicts
    Then the primary type should be "Location" based on:
      | Resolution Factor   | Value                          |
      | Majority vote       | 2 Location vs 1 Organization   |
      | Confidence weighted | Higher confidence for Location |
    And secondary types should be preserved
    And conflict resolution should be documented

  @conflict @attributes
  Scenario: Resolve conflicting attribute values
    Given entity "Shylock" has conflicting attributes:
      | documentId | attribute     | value           | confidence |
      | doc-002    | occupation    | Money lender    | 0.90       |
      | doc-027    | occupation    | Merchant        | 0.75       |
      | doc-002    | religion      | Jewish          | 0.95       |
    When the system resolves attribute conflicts
    Then the higher confidence value should be primary
    And conflicting values should be preserved as alternatives
    And the resolution should include:
      | Field              | Value                          |
      | primaryValue       | Money lender                   |
      | alternativeValues  | [Merchant]                     |
      | conflictType       | SEMANTIC_OVERLAP               |
      | resolutionMethod   | CONFIDENCE_WEIGHTED            |

  @conflict @manual-review
  Scenario: Flag irreconcilable conflicts for manual review
    Given entity "Portia" has irreconcilable conflicts:
      | documentId | attribute     | value           | confidence |
      | doc-002    | origin        | Belmont         | 0.88       |
      | doc-028    | origin        | Venice          | 0.85       |
    When the system cannot automatically resolve conflicts
    Then the conflict should be flagged for manual review
    And the review request should include:
      | Field              | Value                          |
      | entityId           | Entity identifier              |
      | conflictType       | ATTRIBUTE_CONFLICT             |
      | values             | Conflicting values             |
      | sources            | Document sources               |
      | suggestedAction    | Recommended resolution         |

  @conflict @hierarchy
  Scenario: Apply conflict resolution hierarchy
    Given multiple conflicts exist for entity "Claudius"
    When the system applies resolution hierarchy
    Then conflicts should be resolved in order:
      | Priority | Resolution Method                |
      | 1        | Explicit user override           |
      | 2        | Primary document takes precedence|
      | 3        | Higher confidence wins           |
      | 4        | More recent extraction wins      |
      | 5        | Flag for manual review           |
    And each resolution should be logged with method used

  # =============================================================================
  # IMPORTANCE SCORE CALCULATION
  # =============================================================================

  @importance @calculation
  Scenario: Calculate entity importance scores
    Given entity "Hamlet" exists in world "test-world-123"
    When the system calculates importance score
    Then the importance should be based on:
      | Factor                | Weight | Description                    |
      | occurrenceFrequency   | 0.25   | How often entity appears       |
      | documentCoverage      | 0.15   | Number of documents containing |
      | relationshipCount     | 0.20   | Connections to other entities  |
      | narrativeRole         | 0.25   | Protagonist/antagonist status  |
      | userInteraction       | 0.15   | User engagement with entity    |
    And the importance score should be normalized to 0-1 range

  @importance @ranking
  Scenario: Rank entities by importance within world
    Given the following entities exist with calculated importance:
      | entityName    | type      | importanceScore |
      | Hamlet        | Character | 0.98            |
      | Claudius      | Character | 0.85            |
      | Ophelia       | Character | 0.72            |
      | Elsinore      | Location  | 0.65            |
      | Ghost         | Character | 0.58            |
    When I request entity ranking for world "test-world-123"
    Then entities should be ranked by importance score
    And I should be able to filter by:
      | Filter         | Description                      |
      | Top N          | Top N most important entities    |
      | By type        | Importance within entity type    |
      | Threshold      | Above importance threshold       |

  @importance @relative
  Scenario: Calculate relative importance within document
    Given document "doc-003" contains entities:
      | entityName    | documentOccurrences | isProtagonist |
      | Hamlet        | 500                 | true          |
      | Claudius      | 200                 | false         |
      | Gertrude      | 150                 | false         |
      | Polonius      | 120                 | false         |
    When the system calculates document-relative importance
    Then each entity should have:
      | Field              | Description                      |
      | worldImportance    | Importance across all documents  |
      | documentImportance | Importance within this document  |
      | relativeRanking    | Rank within document             |

  @importance @recalculation
  Scenario: Recalculate importance after new document addition
    Given entity "Romeo" has importance score 0.85
    When a new document is added containing "Romeo" with high prominence
    Then the system should trigger importance recalculation
    And the new importance score should reflect:
      | Change              | Impact                           |
      | Increased coverage  | More documents = higher score    |
      | New relationships   | More connections discovered      |
      | Updated occurrences | More mentions = higher score     |
    And importance history should be maintained

  # =============================================================================
  # RELATIONSHIP TRACKING
  # =============================================================================

  @relationships @aggregation
  Scenario: Aggregate entity relationships across documents
    Given entity "Romeo" has relationships in multiple documents:
      | documentId | relatedEntity | relationshipType | confidence |
      | doc-001    | Juliet        | ROMANTIC         | 0.98       |
      | doc-001    | Mercutio      | FRIEND           | 0.92       |
      | doc-001    | Tybalt        | ENEMY            | 0.95       |
      | doc-005    | Rosaline      | FORMER_ROMANTIC  | 0.75       |
    When the system aggregates relationships
    Then the entity should have unified relationship graph
    And relationships should be categorized by type
    And each relationship should include:
      | Field              | Value                          |
      | relatedEntityId    | Related entity identifier      |
      | relationshipType   | Type of relationship           |
      | sources            | Documents containing evidence  |
      | confidence         | Aggregated confidence          |
      | bidirectional      | Whether relationship is mutual |

  @relationships @discovery
  Scenario: Discover implicit relationships through co-occurrence
    Given entities frequently appear together:
      | entity1        | entity2        | coOccurrences |
      | Rosencrantz    | Guildenstern   | 85            |
      | Romeo          | Juliet         | 250           |
      | Macbeth        | Banquo         | 120           |
    When the system analyzes co-occurrence patterns
    Then implicit relationships should be discovered
    And discovered relationships should have:
      | Field              | Description                      |
      | type               | ASSOCIATED (implicit)            |
      | confidence         | Based on co-occurrence frequency |
      | discoveryMethod    | CO_OCCURRENCE_ANALYSIS           |
      | suggestedType      | Suggested relationship type      |

  @relationships @hierarchy
  Scenario: Build relationship hierarchy
    Given entities have hierarchical relationships:
      | parent         | child          | relationshipType |
      | Capulet Family | Lord Capulet   | FAMILY_HEAD      |
      | Capulet Family | Lady Capulet   | FAMILY_MEMBER    |
      | Capulet Family | Juliet         | FAMILY_MEMBER    |
      | Capulet Family | Tybalt         | FAMILY_MEMBER    |
    When the system builds relationship hierarchy
    Then I should see hierarchical structure
    And I should be able to traverse:
      | Direction      | Description                      |
      | Top-down       | From family to members           |
      | Bottom-up      | From member to family            |
      | Siblings       | Between family members           |

  @relationships @strength
  Scenario: Calculate relationship strength
    Given entities "Romeo" and "Juliet" have relationship data:
      | factor              | value                          |
      | coOccurrences       | 250                            |
      | sharedScenes        | 15                             |
      | explicitMentions    | 45                             |
      | emotionalValence    | POSITIVE                       |
    When the system calculates relationship strength
    Then the relationship should have strength score
    And strength calculation should consider:
      | Factor              | Weight                         |
      | Frequency           | How often they interact        |
      | Proximity           | How close they appear in text  |
      | Explicit references | Direct mentions of relationship|
      | Sentiment           | Emotional tone of interactions |

  @relationships @network
  Scenario: Generate entity relationship network
    Given world "test-world-123" contains multiple entities with relationships
    When I request the relationship network
    Then I should receive:
      | Component          | Description                      |
      | Nodes              | All entities as network nodes    |
      | Edges              | Relationships as connections     |
      | Clusters           | Strongly connected entity groups |
      | Central nodes      | Most connected entities          |
    And the network should be exportable in graph formats

  # =============================================================================
  # TIMELINE GENERATION
  # =============================================================================

  @timeline @entity
  Scenario: Generate timeline for entity appearances
    Given entity "Hamlet" appears across narrative:
      | event                  | narrativePosition | documentId |
      | First appearance       | Act 1, Scene 2    | doc-003    |
      | Encounters ghost       | Act 1, Scene 5    | doc-003    |
      | To be or not to be     | Act 3, Scene 1    | doc-003    |
      | Confronts Gertrude     | Act 3, Scene 4    | doc-003    |
      | Final duel             | Act 5, Scene 2    | doc-003    |
    When the system generates entity timeline
    Then the timeline should show chronological appearances
    And each timeline entry should include:
      | Field              | Description                      |
      | position           | Narrative position               |
      | event              | What happens at this point       |
      | relatedEntities    | Other entities involved          |
      | significance       | Importance of this moment        |

  @timeline @cross-document
  Scenario: Generate timeline across multiple documents
    Given entity "Falstaff" appears in multiple plays:
      | documentId | narrativeOrder | events                     |
      | doc-029    | 1              | Henry IV Part 1 events     |
      | doc-030    | 2              | Henry IV Part 2 events     |
      | doc-031    | 3              | Merry Wives of Windsor     |
    When the system generates cross-document timeline
    Then the timeline should span all documents
    And documents should be ordered by:
      | Factor              | Description                      |
      | Explicit ordering   | User-defined document order      |
      | Publication date    | When documents were written      |
      | Internal references | Cross-references between docs    |

  @timeline @events
  Scenario: Track significant events for entity
    Given entity "Macbeth" has significant events:
      | event                  | type        | impact           |
      | Becomes Thane of Cawdor| PROMOTION   | Character change |
      | Kills Duncan           | MURDER      | Major plot point |
      | Becomes King           | CORONATION  | Status change    |
      | Sees Banquo's ghost    | SUPERNATURAL| Psychological    |
      | Dies in battle         | DEATH       | Story conclusion |
    When the system tracks entity events
    Then events should be categorized and ordered
    And I should be able to query:
      | Query Type         | Description                      |
      | By event type      | All promotions, all deaths, etc. |
      | By impact level    | Major vs minor events            |
      | By time range      | Events within narrative range    |

  # =============================================================================
  # DUPLICATE DETECTION AND MERGE
  # =============================================================================

  @duplicates @detection
  Scenario: Detect potential duplicate entities
    Given the following entities exist:
      | entityId    | name           | type      | documentId |
      | ent-100     | Romeo          | Character | doc-001    |
      | ent-101     | Romeo Montague | Character | doc-005    |
      | ent-102     | Young Romeo    | Character | doc-006    |
    When the system runs duplicate detection
    Then potential duplicates should be identified based on:
      | Detection Method    | Description                      |
      | Name similarity     | Fuzzy matching on names          |
      | Type matching       | Same entity type                 |
      | Context overlap     | Similar descriptions/attributes  |
      | Relationship overlap| Shared relationships             |
    And duplicates should be flagged with confidence score

  @duplicates @auto-merge
  Scenario: Automatically merge high-confidence duplicates
    Given duplicates detected with high confidence:
      | entity1     | entity2     | confidence | matchReason        |
      | ent-100     | ent-101     | 0.98       | Name variation     |
    When the system auto-merges high-confidence duplicates
    Then a single merged entity should be created
    And the merge should:
      | Action              | Description                      |
      | Combine attributes  | Merge all non-conflicting attrs  |
      | Link relationships  | Combine relationship graphs      |
      | Preserve history    | Track original entities          |
      | Set canonical name  | Choose best name representation  |

  @duplicates @manual-merge
  Scenario: Flag low-confidence duplicates for manual review
    Given duplicates detected with lower confidence:
      | entity1     | entity2     | confidence | matchReason        |
      | ent-200     | ent-201     | 0.72       | Possible variation |
    When the system processes duplicate candidates
    Then low-confidence matches should require manual review
    And the review interface should show:
      | Field              | Description                      |
      | entities           | Both entity details side by side |
      | matchReasons       | Why they might be duplicates     |
      | differences        | How they differ                  |
      | suggestedAction    | Merge or keep separate           |

  @duplicates @merge-rules
  Scenario: Apply merge rules for entity combination
    Given entities are being merged:
      | source1     | source2     |
      | ent-100     | ent-101     |
    When the merge is executed
    Then merge rules should be applied:
      | Rule                | Description                      |
      | Name selection      | Most complete/canonical name     |
      | Description merge   | Combine descriptions             |
      | Attribute union     | All unique attributes            |
      | Conflict resolution | Handle conflicting values        |
      | Relationship merge  | Combine relationships            |
    And merge audit trail should be created

  @duplicates @unmerge
  Scenario: Unmerge incorrectly merged entities
    Given entity "ent-merged-001" was created from merging two entities
    When I request to unmerge the entity
    Then the original entities should be restored
    And the system should:
      | Action              | Description                      |
      | Restore originals   | Recreate source entities         |
      | Redistribute attrs  | Return attributes to sources     |
      | Restore relationships| Reconnect original relationships|
      | Update references   | Fix any entity references        |
    And unmerge should be logged in history

  # =============================================================================
  # SENTIMENT AGGREGATION
  # =============================================================================

  @sentiment @aggregation
  Scenario: Aggregate sentiment associated with entity
    Given entity "Iago" has sentiment data from multiple sources:
      | documentId | sentimentScore | sentimentLabel | context                |
      | doc-020    | -0.85          | NEGATIVE       | Described as villain   |
      | doc-032    | -0.92          | NEGATIVE       | Plotting and scheming  |
      | doc-033    | -0.78          | NEGATIVE       | Betrayal scenes        |
    When the system aggregates sentiment
    Then the entity should have:
      | Field              | Value                          |
      | overallSentiment   | -0.85 (weighted average)       |
      | sentimentLabel     | NEGATIVE                       |
      | sentimentVariance  | Consistency measure            |
      | sourceCount        | 3                              |

  @sentiment @evolution
  Scenario: Track sentiment evolution across narrative
    Given entity "Hamlet" has changing sentiment:
      | narrativePosition | sentimentScore | context                    |
      | Act 1             | -0.40          | Mourning father            |
      | Act 2             | -0.65          | Feigning madness           |
      | Act 3             | -0.80          | Confronting truth          |
      | Act 4             | -0.50          | Resolved action            |
      | Act 5             | -0.20          | Acceptance                 |
    When the system tracks sentiment evolution
    Then I should see sentiment trajectory
    And the trajectory should show:
      | Field              | Description                      |
      | trendDirection     | Overall sentiment trend          |
      | inflectionPoints   | Major sentiment changes          |
      | narrativeCorrelation| Linked to plot events          |

  @sentiment @relationships
  Scenario: Analyze sentiment in entity relationships
    Given relationships have associated sentiment:
      | entity1    | entity2    | relationship | sentiment |
      | Romeo      | Juliet     | ROMANTIC     | 0.95      |
      | Romeo      | Tybalt     | ENEMY        | -0.88     |
      | Hamlet     | Claudius   | ANTAGONISTIC | -0.92     |
      | Hamlet     | Horatio    | FRIEND       | 0.85      |
    When the system analyzes relationship sentiment
    Then I should see sentiment-coded relationship map
    And I should be able to query:
      | Query              | Description                      |
      | Positive relations | All positive sentiment relationships |
      | Negative relations | All negative sentiment relationships |
      | Neutral relations  | Low sentiment intensity relationships|

  @sentiment @context
  Scenario: Preserve sentiment context from sources
    Given entity "Lady Macbeth" has contextual sentiment:
      | source              | sentiment | context                        |
      | Narrator            | -0.70     | Described as ambitious         |
      | Macbeth             | 0.60      | Affectionate references        |
      | Malcolm             | -0.90     | "Fiend-like queen"             |
    When the system preserves sentiment context
    Then sentiment should be attributed to source
    And I should understand:
      | Aspect             | Description                      |
      | Who                | Who expresses the sentiment      |
      | Context            | In what situation                |
      | Reliability        | Source reliability               |

  # =============================================================================
  # AGGREGATION STATISTICS
  # =============================================================================

  @statistics @summary
  Scenario: Generate aggregation statistics for world
    Given world "test-world-123" has undergone entity aggregation
    When I request aggregation statistics
    Then I should see:
      | Statistic              | Description                      |
      | totalDocuments         | Documents processed              |
      | totalEntitiesExtracted | Entities before aggregation      |
      | uniqueEntities         | Entities after aggregation       |
      | duplicatesMerged       | Number of merges performed       |
      | conflictsResolved      | Conflicts auto-resolved          |
      | conflictsPending       | Conflicts awaiting review        |
      | avgEntityCoverage      | Avg documents per entity         |

  @statistics @by-type
  Scenario: Get aggregation statistics by entity type
    When I request aggregation statistics by entity type
    Then I should see breakdown:
      | EntityType   | Extracted | Unique | MergeRate |
      | Character    | 150       | 85     | 43%       |
      | Location     | 45        | 38     | 16%       |
      | Object       | 30        | 28     | 7%        |
      | Event        | 25        | 22     | 12%       |
      | Organization | 20        | 18     | 10%       |

  @statistics @quality
  Scenario: Report aggregation quality metrics
    When I request aggregation quality report
    Then I should see:
      | Metric                 | Description                      |
      | avgConfidence          | Average aggregation confidence   |
      | manualReviewRate       | Percentage requiring review      |
      | autoResolveRate        | Percentage auto-resolved         |
      | mergeAccuracy          | Accuracy of auto-merges          |
      | falsePositiveRate      | Incorrect duplicate detections   |

  # =============================================================================
  # REAL-TIME AGGREGATION
  # =============================================================================

  @realtime @incremental
  Scenario: Incrementally aggregate new document entities
    Given world "test-world-123" has existing aggregated entities
    When a new document is processed with entities:
      | entityId    | name           | type      |
      | ent-new-001 | Romeo          | Character |
      | ent-new-002 | Benvolio       | Character |
      | ent-new-003 | New Character  | Character |
    Then incremental aggregation should:
      | Action              | Description                      |
      | Match existing      | Link Romeo to existing entity    |
      | Add new             | Create entry for New Character   |
      | Update stats        | Recalculate importance scores    |
      | Preserve history    | Track aggregation changes        |

  @realtime @events
  Scenario: Emit events during aggregation
    When entity aggregation occurs
    Then the following events should be emitted:
      | Event Type                    | Trigger                      |
      | EntityAggregationStarted      | Aggregation begins           |
      | DuplicateDetected             | Potential duplicate found    |
      | EntityMerged                  | Entities combined            |
      | ConflictDetected              | Irreconcilable conflict      |
      | AggregationCompleted          | Process finished             |
    And events should include relevant metadata

  # =============================================================================
  # ERROR HANDLING
  # =============================================================================

  @error @world-not-found
  Scenario: Handle aggregation for non-existent world
    When I request aggregation for world "non-existent-world"
    Then the response should return 404 Not Found
    And the error message should be "World not found"

  @error @no-entities
  Scenario: Handle aggregation for world with no entities
    Given world "empty-world" has no extracted entities
    When I request entity aggregation
    Then the response should indicate:
      | Field              | Value                          |
      | status             | SKIPPED                        |
      | reason             | No entities to aggregate       |
      | recommendation     | Process documents first        |

  @error @circular-merge
  Scenario: Prevent circular merge references
    Given an attempt to merge entity A into B and B into A
    When the merge is attempted
    Then the system should detect circular reference
    And the merge should be rejected
    And error should explain the issue

  @error @invalid-merge
  Scenario: Handle invalid merge requests
    Given entity "ent-001" of type Character
    And entity "ent-002" of type Location
    When I attempt to merge incompatible types
    Then the merge should be rejected
    And the error should indicate:
      | Field              | Value                          |
      | errorType          | INCOMPATIBLE_TYPES             |
      | message            | Cannot merge Character with Location |
      | suggestedAction    | Review entity classifications  |

  # =============================================================================
  # AUTHORIZATION
  # =============================================================================

  @auth @ownership
  Scenario: Restrict aggregation to world owner
    Given user "user-A" owns world "world-A"
    And user "user-B" does not have access
    When user "user-B" attempts aggregation on "world-A"
    Then the request should be denied with 403 Forbidden
    And the error should be "Access denied to this world"

  @auth @shared-access
  Scenario: Allow aggregation for shared world with write access
    Given world "shared-world" is shared with user "user-B" with "write" access
    When user "user-B" triggers entity aggregation
    Then aggregation should proceed successfully
    And aggregation history should record user "user-B" as actor

  @auth @read-only
  Scenario: Prevent aggregation modifications with read-only access
    Given world "shared-world" is shared with user "user-C" with "read" access
    When user "user-C" attempts to merge entities
    Then the request should be denied
    And the error should indicate read-only access
