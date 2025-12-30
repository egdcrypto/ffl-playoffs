@admin @conversation @testing @narrative-engine
Feature: Admin Conversation Testing
  As a world administrator
  I want to test character conversations using real player interactions
  So that I can validate character behavior and improve conversation quality

  Background:
    Given I am logged in as a world administrator
    And I have access to stored player conversations
    And I have characters with configured personalities and settings
    And the conversation testing framework is available

  # ============================================
  # CONVERSATION REPLAY
  # ============================================

  @api @conversation @replay
  Scenario: Load historical player conversation for testing
    When I send a GET request to "/api/v1/admin/conversations/conv-12345"
    Then the response status should be 200
    And the response should contain:
      | field                | description                              |
      | conversation_id      | Unique conversation identifier           |
      | transcript           | Full conversation transcript             |
      | player_messages      | All player messages with timestamps      |
      | character_responses  | All character responses with timestamps  |
      | context              | Conversation context at each point       |
      | character_settings   | Character settings used at that time     |

  @api @conversation @replay
  Scenario: Replay conversation with current character settings
    Given I have loaded conversation "conv-12345"
    When I send a POST request to "/api/v1/admin/conversations/conv-12345/replay" with:
      """json
      {
        "use_current_settings": true,
        "generate_comparison": true
      }
      """
    Then the response status should be 200
    And the response should contain:
      | field                | description                              |
      | original_responses   | Original character responses             |
      | new_responses        | Newly generated responses                |
      | comparison           | Side-by-side comparison                  |
      | quality_delta        | Quality score difference                 |
    And a ConversationReplayedEvent should be published

  @api @conversation @replay
  Scenario: Test conversation with modified character settings
    Given I have loaded conversation "conv-12345"
    When I send a POST request to "/api/v1/admin/conversations/conv-12345/replay" with:
      """json
      {
        "modified_settings": {
          "traits": {
            "patience": 0.8,
            "wisdom": 0.9
          }
        },
        "generate_comparison": true
      }
      """
    Then the response status should be 200
    And responses should reflect modified trait values
    And quality metrics comparison should be included

  @api @conversation @replay @batch
  Scenario: Batch replay multiple conversations
    When I send a POST request to "/api/v1/admin/conversations/batch-replay" with:
      """json
      {
        "conversation_ids": ["conv-001", "conv-002", "conv-003", "conv-004", "conv-005"],
        "use_current_settings": true
      }
      """
    Then the response status should be 202
    And batch job should be created
    And I should receive:
      | field                | description                              |
      | job_id               | Batch job identifier                     |
      | total_conversations  | Number of conversations to process       |
      | estimated_time       | Estimated completion time                |

  @api @conversation @replay @batch
  Scenario: Get batch replay results
    Given batch replay job "job-123" has completed
    When I send a GET request to "/api/v1/admin/conversations/batch-replay/job-123/results"
    Then the response status should be 200
    And the response should contain:
      | field                | description                              |
      | aggregate_metrics    | Overall quality metrics                  |
      | individual_results   | Results per conversation                 |
      | success_count        | Number of successful replays             |
      | failure_count        | Number of failed replays                 |

  # ============================================
  # MESSAGE VALIDATION
  # ============================================

  @api @conversation @validation
  Scenario: Validate response format
    When I send a POST request to "/api/v1/admin/conversations/validate/format" with:
      """json
      {
        "character_id": "char-123",
        "test_messages": [
          {"role": "player", "content": "Hello there!"},
          {"role": "player", "content": "Tell me about the quest."}
        ]
      }
      """
    Then the response status should be 200
    And the response should contain:
      | field                | description                              |
      | format_compliance    | Whether format rules are followed        |
      | length_compliance    | Whether length limits are respected      |
      | style_compliance     | Whether language style is appropriate    |
      | violations           | List of any format violations            |

  @api @conversation @validation
  Scenario: Validate response consistency
    When I send a POST request to "/api/v1/admin/conversations/validate/consistency" with:
      """json
      {
        "conversation_id": "conv-12345",
        "replay_count": 5
      }
      """
    Then the response status should be 200
    And the response should contain:
      | field                | description                              |
      | tone_consistency     | Consistency score for tone (0-1)         |
      | information_preserved| Key info preservation percentage         |
      | personality_stability| Personality consistency score            |
      | variance_analysis    | Analysis of response variations          |

  @api @conversation @validation @safety
  Scenario: Validate message safety filters
    When I send a POST request to "/api/v1/admin/conversations/validate/safety" with:
      """json
      {
        "character_id": "char-123",
        "test_inputs": [
          {"content": "Normal question about the game"},
          {"content": "[potentially harmful input]", "expected_filter": true}
        ]
      }
      """
    Then the response status should be 200
    And the response should contain:
      | field                | description                              |
      | filter_activations   | Which inputs triggered filters           |
      | response_safety      | Safety rating of responses               |
      | violations_logged    | Whether violations were logged           |

  @api @conversation @validation
  Scenario: Validate response coherence
    When I send a POST request to "/api/v1/admin/conversations/validate/coherence" with:
      """json
      {
        "conversation_id": "conv-12345"
      }
      """
    Then the response status should be 200
    And the response should contain:
      | field                | description                              |
      | contextual_relevance | Score for contextual relevance           |
      | reference_accuracy   | Accuracy of references to previous msgs  |
      | contradiction_check  | List of any contradictions found         |
      | coherence_score      | Overall coherence score (0-1)            |

  # ============================================
  # INTENT RECOGNITION TESTING
  # ============================================

  @api @conversation @intent
  Scenario: Test intent recognition accuracy
    When I send a POST request to "/api/v1/admin/conversations/test/intent" with:
      """json
      {
        "test_cases": [
          {"message": "Where can I find the sword", "expected_intent": "location_query"},
          {"message": "Tell me about the dragon", "expected_intent": "information_request"},
          {"message": "I want to buy potions", "expected_intent": "purchase_intent"}
        ]
      }
      """
    Then the response status should be 200
    And the response should contain:
      | field                | description                              |
      | accuracy             | Overall accuracy percentage              |
      | results              | Per-case results with actual vs expected |
      | misclassifications   | List of incorrectly classified intents   |

  @api @conversation @intent
  Scenario: Test ambiguous intent handling
    When I send a POST request to "/api/v1/admin/conversations/test/intent/ambiguous" with:
      """json
      {
        "ambiguous_messages": [
          "I need that thing we talked about",
          "Can you help me with the thing?"
        ],
        "character_id": "char-123"
      }
      """
    Then the response status should be 200
    And character responses should seek clarification
    And responses should acknowledge ambiguity

  @api @conversation @intent
  Scenario: Test multi-intent messages
    When I send a POST request to "/api/v1/admin/conversations/test/intent/multi" with:
      """json
      {
        "messages": [
          "I want to buy a sword and also find the blacksmith",
          "Tell me about dragons and where can I fight one?"
        ],
        "character_id": "char-123"
      }
      """
    Then the response status should be 200
    And all intents should be recognized for each message
    And responses should address each intent appropriately

  @api @conversation @intent
  Scenario: Generate intent confusion matrix
    When I send a POST request to "/api/v1/admin/conversations/test/intent/analysis"
    Then the response status should be 200
    And the response should contain:
      | field                | description                              |
      | confusion_matrix     | Matrix of predicted vs actual intents    |
      | precision_per_intent | Precision score per intent type          |
      | recall_per_intent    | Recall score per intent type             |
      | f1_scores            | F1 score per intent type                 |
      | weak_categories      | Intent categories needing improvement    |

  # ============================================
  # RESPONSE QUALITY EVALUATION
  # ============================================

  @api @conversation @quality
  Scenario: Evaluate response quality metrics
    When I send a POST request to "/api/v1/admin/conversations/evaluate/quality" with:
      """json
      {
        "conversation_id": "conv-12345"
      }
      """
    Then the response status should be 200
    And the response should contain:
      | metric               | description                              |
      | relevance_score      | How relevant responses are (0-1)         |
      | coherence_score      | Logical flow score (0-1)                 |
      | personality_adherence| How well character stays in persona (0-1)|
      | engagement_score     | How engaging responses are (0-1)         |
      | overall_quality      | Weighted overall quality score           |

  @api @conversation @quality
  Scenario: Compare quality across character versions
    When I send a POST request to "/api/v1/admin/conversations/evaluate/compare" with:
      """json
      {
        "character_versions": ["v1", "v2"],
        "test_conversation_ids": ["conv-001", "conv-002", "conv-003"]
      }
      """
    Then the response status should be 200
    And the response should contain:
      | field                | description                              |
      | version_comparison   | Quality metrics per version              |
      | winner               | Which version performs better overall    |
      | improvements         | Specific improvements in newer version   |
      | regressions          | Any regressions in newer version         |

  @api @conversation @quality
  Scenario: Evaluate emotional appropriateness
    When I send a POST request to "/api/v1/admin/conversations/evaluate/emotional" with:
      """json
      {
        "conversation_id": "conv-12345",
        "character_id": "char-123"
      }
      """
    Then the response status should be 200
    And the response should contain:
      | field                | description                              |
      | emotional_tone       | Detected emotional tone per response     |
      | personality_match    | How emotions match character personality |
      | inappropriate_flags  | Any flagged inappropriate emotions       |

  @api @conversation @quality @human
  Scenario: Submit responses for human evaluation
    When I send a POST request to "/api/v1/admin/conversations/evaluate/human" with:
      """json
      {
        "conversation_id": "conv-12345",
        "evaluator_emails": ["eval1@example.com", "eval2@example.com"],
        "criteria": ["relevance", "naturalness", "helpfulness"]
      }
      """
    Then the response status should be 201
    And evaluation requests should be sent to evaluators
    And a HumanEvaluationRequestedEvent should be published

  @api @conversation @quality @human
  Scenario: Get human evaluation results
    Given human evaluation "eval-123" is complete
    When I send a GET request to "/api/v1/admin/conversations/evaluate/human/eval-123"
    Then the response status should be 200
    And the response should contain:
      | field                | description                              |
      | aggregated_ratings   | Aggregated scores per criterion          |
      | individual_ratings   | Each evaluator's ratings                 |
      | inter_rater_reliability| Cohen's kappa or similar metric         |
      | comments             | Evaluator comments                       |

  # ============================================
  # EDGE CASE TESTING
  # ============================================

  @api @conversation @edge-cases
  Scenario: Test conversation edge cases
    When I send a POST request to "/api/v1/admin/conversations/test/edge-cases" with:
      """json
      {
        "character_id": "char-123",
        "test_cases": [
          {"case": "empty_message", "input": ""},
          {"case": "very_long_message", "input": "[5000 character message]"},
          {"case": "special_characters", "input": "!@#$%^&*()"},
          {"case": "multiple_languages", "input": "Hello, Bonjour, Hola"},
          {"case": "emoji_only", "input": "😀🎮🗡️"}
        ]
      }
      """
    Then the response status should be 200
    And each case should be handled gracefully
    And no errors should occur
    And appropriate responses should be generated for each

  @api @conversation @edge-cases
  Scenario: Test out-of-context requests
    When I send a POST request to "/api/v1/admin/conversations/test/out-of-context" with:
      """json
      {
        "character_id": "char-123",
        "world_id": "world-456",
        "out_of_context_messages": [
          "What's the weather like in New York?",
          "Can you help me with my homework?",
          "What's the latest news?"
        ]
      }
      """
    Then the response status should be 200
    And character should stay in character
    And responses should redirect appropriately
    And immersion should be maintained

  @api @conversation @edge-cases
  Scenario: Test rapid message sequences
    When I send a POST request to "/api/v1/admin/conversations/test/rapid-sequence" with:
      """json
      {
        "character_id": "char-123",
        "messages": [
          "Message 1", "Message 2", "Message 3", "Message 4", "Message 5",
          "Message 6", "Message 7", "Message 8", "Message 9", "Message 10"
        ],
        "interval_ms": 100
      }
      """
    Then the response status should be 200
    And all messages should be processed
    And context should be maintained across messages
    And responses should remain coherent

  # ============================================
  # CHARACTER CONFIGURATION TESTING
  # ============================================

  @api @conversation @config
  Scenario: Compare different character configurations
    When I send a POST request to "/api/v1/admin/conversations/test/config-compare" with:
      """json
      {
        "configurations": [
          {"name": "A", "traits": {"wisdom": 0.9, "patience": 0.8}, "tone": "formal"},
          {"name": "B", "traits": {"wisdom": 0.5, "patience": 0.3}, "tone": "casual"}
        ],
        "test_conversation_id": "conv-12345"
      }
      """
    Then the response status should be 200
    And the response should contain:
      | field                | description                              |
      | response_differences | How responses differ between configs     |
      | quality_per_config   | Quality metrics for each configuration   |
      | recommendation       | Which config is recommended              |

  @api @conversation @config @ab-test
  Scenario: Set up A/B test for character configurations
    When I send a POST request to "/api/v1/admin/conversations/ab-test" with:
      """json
      {
        "name": "Patience Level Test",
        "character_id": "char-123",
        "variants": [
          {"name": "control", "config": {"patience": 0.5}, "weight": 50},
          {"name": "treatment", "config": {"patience": 0.8}, "weight": 50}
        ],
        "success_metric": "user_satisfaction",
        "duration_days": 14
      }
      """
    Then the response status should be 201
    And A/B test should be created
    And traffic should be split according to weights
    And an ABTestCreatedEvent should be published

  @api @conversation @config @ab-test
  Scenario: Get A/B test results
    Given A/B test "ab-123" has sufficient data
    When I send a GET request to "/api/v1/admin/conversations/ab-test/ab-123/results"
    Then the response status should be 200
    And the response should contain:
      | field                | description                              |
      | variant_metrics      | Metrics per variant                      |
      | statistical_significance| P-value and confidence interval        |
      | winner               | Statistically significant winner (if any)|
      | recommendation       | Recommendation based on results          |

  @api @conversation @config
  Scenario: Test configuration boundary values
    When I send a POST request to "/api/v1/admin/conversations/test/config-boundaries" with:
      """json
      {
        "character_id": "char-123",
        "trait_tests": [
          {"trait": "patience", "values": [0.0, 0.5, 1.0]},
          {"trait": "wisdom", "values": [0.0, 0.5, 1.0]}
        ],
        "test_conversation_id": "conv-12345"
      }
      """
    Then the response status should be 200
    And behavior at extreme values should be predictable
    And no unexpected behavior should occur

  # ============================================
  # MEMORY AND CONTEXT TESTING
  # ============================================

  @api @conversation @memory
  Scenario: Test conversation memory consistency
    When I send a POST request to "/api/v1/admin/conversations/test/memory" with:
      """json
      {
        "character_id": "char-123",
        "player_id": "player-456",
        "memory_facts": [
          {"fact": "Player name is Dragonslayer", "session": "previous"}
        ],
        "test_messages": [
          "Do you remember who I am?"
        ]
      }
      """
    Then the response status should be 200
    And character should remember stored facts
    And response should reference previous interactions appropriately

  @api @conversation @memory
  Scenario: Test long-term memory retrieval
    When I send a POST request to "/api/v1/admin/conversations/test/memory/long-term" with:
      """json
      {
        "character_id": "char-123",
        "player_id": "player-456",
        "sessions_to_test": 5
      }
      """
    Then the response status should be 200
    And the response should contain:
      | field                | description                              |
      | facts_retained       | Important facts remembered               |
      | retrieval_accuracy   | Accuracy of memory retrieval             |
      | conflict_handling    | How memory conflicts are handled         |

  @api @conversation @memory
  Scenario: Test context window handling
    When I send a POST request to "/api/v1/admin/conversations/test/context-window" with:
      """json
      {
        "character_id": "char-123",
        "conversation_length": 100,
        "critical_information": [
          {"position": 5, "info": "Player is allergic to potions"},
          {"position": 95, "info": "Player needs potion help"}
        ]
      }
      """
    Then the response status should be 200
    And important context should be preserved
    And summarization should be accurate
    And critical information should not be lost

  # ============================================
  # LOAD TESTING
  # ============================================

  @api @conversation @load
  Scenario: Load test character responses
    When I send a POST request to "/api/v1/admin/conversations/test/load" with:
      """json
      {
        "character_id": "char-123",
        "concurrent_conversations": 100,
        "messages_per_conversation": 5,
        "target_latency_ms": 2000,
        "max_error_rate_percent": 1
      }
      """
    Then the response status should be 202
    And load test should be initiated
    And a LoadTestStartedEvent should be published

  @api @conversation @load
  Scenario: Get load test results
    Given load test "load-123" has completed
    When I send a GET request to "/api/v1/admin/conversations/test/load/load-123/results"
    Then the response status should be 200
    And the response should contain:
      | field                | description                              |
      | avg_latency_ms       | Average response latency                 |
      | p50_latency_ms       | 50th percentile latency                  |
      | p95_latency_ms       | 95th percentile latency                  |
      | p99_latency_ms       | 99th percentile latency                  |
      | error_rate           | Percentage of errors                     |
      | quality_degradation  | Quality impact under load                |
      | passed               | Whether test passed criteria             |

  @api @conversation @load
  Scenario: Stress test with sustained load
    When I send a POST request to "/api/v1/admin/conversations/test/stress" with:
      """json
      {
        "character_id": "char-123",
        "concurrent_conversations": 50,
        "duration_minutes": 60,
        "monitor_metrics": ["memory", "latency", "quality"]
      }
      """
    Then the response status should be 202
    And stress test should be initiated

  # ============================================
  # TRAINING DATA MANAGEMENT
  # ============================================

  @api @conversation @training
  Scenario: Mark conversation as training example
    When I send a POST request to "/api/v1/admin/conversations/conv-12345/training" with:
      """json
      {
        "type": "positive",
        "quality_rating": 5,
        "tags": ["ideal_greeting", "good_tone"],
        "notes": "Exemplary merchant greeting"
      }
      """
    Then the response status should be 201
    And conversation should be added to training dataset
    And a TrainingExampleAddedEvent should be published

  @api @conversation @training
  Scenario: Mark conversation as negative example
    When I send a POST request to "/api/v1/admin/conversations/conv-67890/training" with:
      """json
      {
        "type": "negative",
        "quality_rating": 1,
        "issues": ["broke_character", "inappropriate_tone"],
        "notes": "Character broke immersion"
      }
      """
    Then the response status should be 201
    And conversation should be flagged for improvement
    And a TrainingExampleAddedEvent should be published

  @api @conversation @training
  Scenario: View and curate training dataset
    When I send a GET request to "/api/v1/admin/conversations/training/dataset?character_id=char-123"
    Then the response status should be 200
    And the response should contain:
      | field                | description                              |
      | positive_examples    | List of positive training examples       |
      | negative_examples    | List of negative training examples       |
      | total_count          | Total examples in dataset                |
      | balance_metrics      | Dataset balance (positive/negative ratio)|
      | tag_distribution     | Distribution of tags                     |

  @api @conversation @training
  Scenario: Update training example labels
    When I send a PUT request to "/api/v1/admin/conversations/training/example-123" with:
      """json
      {
        "type": "positive",
        "quality_rating": 4,
        "tags": ["good_tone"],
        "notes": "Updated assessment"
      }
      """
    Then the response status should be 200
    And training example should be updated

  # ============================================
  # TEST SUITE MANAGEMENT
  # ============================================

  @api @conversation @test-suite
  Scenario: Create conversation test suite
    When I send a POST request to "/api/v1/admin/conversations/test-suites" with:
      """json
      {
        "name": "Merchant Character Tests",
        "character_id": "char-123",
        "test_cases": [
          {"name": "Greeting", "conversation_id": "conv-001", "expected_behavior": "Warm welcome"},
          {"name": "Price negotiation", "conversation_id": "conv-002", "expected_behavior": "Firm but fair"},
          {"name": "Out of stock", "conversation_id": "conv-003", "expected_behavior": "Apologetic, alternatives"}
        ]
      }
      """
    Then the response status should be 201
    And test suite should be saved
    And a TestSuiteCreatedEvent should be published

  @api @conversation @test-suite
  Scenario: Run automated test suite
    When I send a POST request to "/api/v1/admin/conversations/test-suites/suite-123/run"
    Then the response status should be 202
    And test suite execution should be initiated

  @api @conversation @test-suite
  Scenario: Get test suite execution results
    Given test suite run "run-123" has completed
    When I send a GET request to "/api/v1/admin/conversations/test-suites/runs/run-123"
    Then the response status should be 200
    And the response should contain:
      | field                | description                              |
      | passed_count         | Number of passed tests                   |
      | failed_count         | Number of failed tests                   |
      | pass_rate            | Percentage of passed tests               |
      | detailed_results     | Per-test-case results                    |
      | execution_time       | Total execution time                     |

  @api @conversation @test-suite
  Scenario: Schedule test suite execution
    When I send a POST request to "/api/v1/admin/conversations/test-suites/suite-123/schedule" with:
      """json
      {
        "schedule": "0 0 * * *",
        "notify_on_failure": true,
        "notification_emails": ["team@example.com"]
      }
      """
    Then the response status should be 200
    And test suite should be scheduled
    And regressions should trigger alerts

  # ============================================
  # PRIVACY AND COMPLIANCE
  # ============================================

  @api @conversation @privacy
  Scenario: Load conversation with privacy protection
    Given conversation "conv-12345" contains player PII
    When I send a GET request to "/api/v1/admin/conversations/conv-12345?anonymize=true"
    Then the response status should be 200
    And PII should be redacted or anonymized
    And original data should not be exposed
    And a ConversationAccessedEvent should be logged

  @api @conversation @privacy @audit
  Scenario: View conversation access audit log
    When I send a GET request to "/api/v1/admin/conversations/audit?conversation_id=conv-12345"
    Then the response status should be 200
    And the response should contain:
      | field                | description                              |
      | access_logs          | List of access events                    |
      | accessor_id          | Who accessed the data                    |
      | access_time          | When data was accessed                   |
      | access_purpose       | Why data was accessed                    |

  # ============================================
  # EXPORT AND REPORTING
  # ============================================

  @api @conversation @export
  Scenario: Export test results
    When I send a POST request to "/api/v1/admin/conversations/export/results" with:
      """json
      {
        "test_run_ids": ["run-001", "run-002", "run-003"],
        "format": "pdf",
        "include_recommendations": true
      }
      """
    Then the response status should be 202
    And export job should be created
    And download link should be provided when ready

  @api @conversation @export
  Scenario: Generate test coverage report
    When I send a GET request to "/api/v1/admin/conversations/coverage?character_id=char-123"
    Then the response status should be 200
    And the response should contain:
      | field                | description                              |
      | conversation_types   | Types of conversations tested            |
      | untested_scenarios   | Scenarios not yet tested                 |
      | coverage_percentage  | Overall test coverage percentage         |
      | recommendations      | Suggested areas to test                  |

  # ============================================
  # WORLD ELEMENT INTERACTIONS
  # ============================================

  @api @conversation @world
  Scenario: Test character interactions with world elements
    When I send a POST request to "/api/v1/admin/conversations/test/world-elements" with:
      """json
      {
        "character_id": "char-123",
        "world_id": "world-456",
        "elements_to_test": [
          {"type": "item", "id": "magic-sword", "questions": ["Tell me about this sword", "Where did it come from?"]},
          {"type": "location", "id": "dark-forest", "questions": ["What dangers lurk here?"]}
        ]
      }
      """
    Then the response status should be 200
    And character should provide accurate information about elements
    And world lore should be consistent
    And element properties should be correctly referenced

  @api @conversation @world
  Scenario: Test location-aware responses
    When I send a POST request to "/api/v1/admin/conversations/test/location-awareness" with:
      """json
      {
        "character_id": "char-123",
        "locations": [
          {"id": "dark-forest", "expected_atmosphere": "mysterious, dangerous"},
          {"id": "tavern", "expected_atmosphere": "warm, welcoming"}
        ],
        "test_messages": ["What do you think of this place?"]
      }
      """
    Then the response status should be 200
    And responses should reference current location
    And atmosphere should be appropriate for each location

  # ============================================
  # THRESHOLD COMPLIANCE
  # ============================================

  @api @conversation @threshold
  Scenario: Validate threshold compliance in conversations
    When I send a POST request to "/api/v1/admin/conversations/validate/thresholds" with:
      """json
      {
        "conversation_id": "conv-12345",
        "thresholds": {
          "violence": 3,
          "romance": 2,
          "language": 2
        }
      }
      """
    Then the response status should be 200
    And the response should contain:
      | field                | description                              |
      | compliance_status    | Overall compliance (pass/fail)           |
      | violations           | List of threshold violations             |
      | content_ratings      | Rating per category per response         |
      | compliance_percentage| Percentage of compliant responses        |

  # ============================================
  # ANALYTICS
  # ============================================

  @api @conversation @analytics
  Scenario: View conversation testing analytics
    When I send a GET request to "/api/v1/admin/conversations/analytics?period=30d"
    Then the response status should be 200
    And the response should contain:
      | field                | description                              |
      | test_execution_trends| Test runs over time                      |
      | quality_score_trends | Quality scores over time                 |
      | failure_patterns     | Common failure patterns                  |
      | improvement_areas    | Areas needing improvement                |

  # ============================================
  # ERROR SCENARIOS
  # ============================================

  @api @conversation @error
  Scenario: Handle test execution failure
    Given LLM service is temporarily unavailable
    When I send a POST request to "/api/v1/admin/conversations/conv-12345/replay"
    Then the response status should be 503
    And the response should contain error "Test execution failed - service unavailable"
    And partial results should be saved if any
    And retry information should be provided

  @api @conversation @error
  Scenario: Handle corrupted conversation data
    Given conversation "conv-corrupted" has corrupted data
    When I send a GET request to "/api/v1/admin/conversations/conv-corrupted"
    Then the response status should be 422
    And the response should contain error "Conversation data unavailable"
    And I should be able to report the issue

  @api @conversation @error @authorization
  Scenario: Unauthorized access to conversation testing
    Given I am logged in as a regular player without admin permissions
    When I send a GET request to "/api/v1/admin/conversations/conv-12345"
    Then the response status should be 403
    And the response should contain error "Access denied to conversation testing"

  # ============================================
  # DOMAIN EVENTS
  # ============================================

  @domain @events
  Scenario: Emit domain events for conversation testing operations
    Given conversation testing operations occur
    Then the following domain events should be emitted:
      | event_type                      | payload                               |
      | ConversationReplayedEvent       | conversation_id, admin_id, settings   |
      | TrainingExampleAddedEvent       | conversation_id, type, quality_rating |
      | TestSuiteCreatedEvent           | suite_id, name, test_count            |
      | TestSuiteExecutedEvent          | suite_id, run_id, pass_count, fail_count|
      | ABTestCreatedEvent              | test_id, variants, success_metric     |
      | ABTestConcludedEvent            | test_id, winner, statistical_sig      |
      | HumanEvaluationRequestedEvent   | conversation_id, evaluators, criteria |
      | HumanEvaluationCompletedEvent   | evaluation_id, aggregated_scores      |
      | LoadTestStartedEvent            | test_id, concurrent_users, duration   |
      | LoadTestCompletedEvent          | test_id, results, passed              |
      | ConversationAccessedEvent       | conversation_id, admin_id, purpose    |
    And events should be published for analytics and audit
