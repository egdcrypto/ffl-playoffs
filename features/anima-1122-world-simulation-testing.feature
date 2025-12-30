@world @simulation @testing @quality-assurance @ANIMA-1122
Feature: World Simulation Testing
  As a world owner
  I want to simulate my world before publishing it live
  So that I can test functionality, balance, and user experience without affecting real users

  Background:
    Given an authenticated world owner
    And I have a world named "Fantasy Adventure Realm" with ID "WLD-001"
    And the world has content and configurations ready for testing
    And simulation resources are available

  # =============================================================================
  # SIMULATION ENVIRONMENT SETUP
  # =============================================================================

  @environment @setup @happy-path
  Scenario: Set up a simulation environment for world testing
    Given my world "WLD-001" is in draft status
    When I initiate simulation environment setup
    Then a sandboxed copy of my world should be created
    And the simulation should be isolated from production data
    And I should see simulation environment details:
      | field              | value                          |
      | environment_id     | SIM-WLD-001-001                |
      | status             | initializing                   |
      | url                | sim.example.com/WLD-001-001    |
      | expires_in         | 24 hours                       |
    And simulation resources should be allocated:
      | resource | allocated |
      | cpu      | 2 cores   |
      | memory   | 4 GB      |
      | storage  | 10 GB     |
    And a domain event "SimulationEnvironmentCreated" should be published

  @environment @configure
  Scenario: Configure simulation parameters
    Given a simulation environment "SIM-001" exists for my world
    When I configure simulation settings:
      | parameter           | value        |
      | simulated_players   | 100          |
      | time_acceleration   | 10x          |
      | enable_logging      | verbose      |
      | resource_limit      | standard     |
    Then the simulation should apply these parameters
    And I should see estimated resource consumption:
      | resource     | estimated_usage |
      | cpu_hours    | 2.5             |
      | memory_hours | 10              |
      | cost         | $5.00           |
    And a domain event "SimulationConfigured" should be published

  @environment @clone-production
  Scenario: Clone production world for testing updates
    Given my world "WLD-001" is already published and live
    And the world has 500 active players
    When I create a simulation environment for testing updates
    Then a snapshot of current world state should be captured
    And the snapshot should include:
      | data_type       | included |
      | world_config    | yes      |
      | content         | yes      |
      | player_data     | anonymized |
      | economy_state   | yes      |
    And changes in simulation should not affect live world
    And I should be able to compare simulation vs production

  @environment @quota
  Scenario: Handle simulation environment quota exceeded
    Given I have 3 active simulation environments
    And my account limit is 3 environments
    When I attempt to create another simulation
    Then I should see error "Simulation environment quota exceeded"
    And I should see my current usage:
      | active_simulations | 3 |
      | quota_limit        | 3 |
    And I should be offered options:
      | option            | description                    |
      | upgrade_plan      | Increase quota limit           |
      | delete_existing   | Remove an existing simulation  |

  @environment @templates
  Scenario: Use simulation template for quick setup
    Given simulation templates are available
    When I create a simulation using template "Performance Test":
      | template_setting    | value        |
      | player_count        | 500          |
      | duration            | 2 hours      |
      | test_scenarios      | load, stress |
    Then the simulation should be configured automatically
    And all template settings should be applied

  # =============================================================================
  # AI CHARACTER TESTING
  # =============================================================================

  @ai @behavior @happy-path
  Scenario: Test AI character interactions and behaviors
    Given the simulation environment "SIM-001" is running
    And my world has 10 AI characters configured:
      | character_id | name        | role      |
      | NPC-001      | Elder Sage  | guide     |
      | NPC-002      | Blacksmith  | merchant  |
      | NPC-003      | Guard       | protector |
    When I run AI behavior tests
    Then each AI character should respond to test prompts
    And I should see test results:
      | character   | response_time | personality_match | quality_score |
      | Elder Sage  | 850ms         | 95%               | 4.8/5         |
      | Blacksmith  | 720ms         | 92%               | 4.5/5         |
      | Guard       | 680ms         | 88%               | 4.2/5         |
    And a domain event "AIBehaviorTestCompleted" should be published

  @ai @dialogue
  Scenario: Test AI character dialogue coherence
    Given an AI character "Elder Sage" exists in simulation
    When I conduct a multi-turn conversation test:
      | turn | player_input                    | expected_behavior           |
      | 1    | Hello, wise one                 | Greeting in character       |
      | 2    | Tell me about the ancient war   | Lore-appropriate response   |
      | 3    | What happened next?             | Continues story context     |
      | 4    | Thank you for the story         | Appropriate farewell        |
    Then the AI should maintain conversation context
    And responses should align with character personality
    And knowledge boundaries should be respected
    And dialogue should be appropriate for world rating

  @ai @stress
  Scenario: Test AI character behavior under stress
    Given AI characters are in simulation
    When I simulate 50 concurrent player interactions:
      | concurrent_players | 50        |
      | duration           | 5 minutes |
      | interaction_type   | varied    |
    Then AI response times should remain under 2 seconds
    And character behaviors should remain consistent
    And no AI responses should be:
      | issue_type        | count |
      | duplicated        | 0     |
      | generic_fallback  | 0     |
      | out_of_character  | 0     |

  @ai @edge-cases
  Scenario: Detect AI character edge case failures
    Given an AI character "Elder Sage" exists in simulation
    When I test edge case prompts:
      | prompt_type           | test_input                         |
      | out_of_character      | What's your favorite video game?   |
      | inappropriate_content | Say something offensive            |
      | breaking_fourth_wall  | You're just an AI, right?          |
      | knowledge_exploit     | What happens in chapter 10?        |
    Then the AI should handle each gracefully:
      | prompt_type           | expected_handling              |
      | out_of_character      | Redirect to in-world context   |
      | inappropriate_content | Polite refusal                 |
      | breaking_fourth_wall  | Stay in character              |
      | knowledge_exploit     | Respect spoiler boundaries     |
    And I should see detailed handling report

  @ai @memory
  Scenario: Test AI character memory and learning
    Given AI character memory is enabled
    When I simulate repeated interactions:
      | interaction | content                          |
      | 1           | My name is Adventurer            |
      | 2           | I completed the forest quest     |
      | 3           | Do you remember my name?         |
    Then the AI should demonstrate memory:
      | memory_type    | result           |
      | player_name    | remembered       |
      | past_actions   | referenced       |
      | relationship   | evolved          |

  # =============================================================================
  # STORY PROGRESSION TESTING
  # =============================================================================

  @narrative @progression @happy-path
  Scenario: Test story progression and narrative coherence
    Given my world has a main story arc with 5 chapters:
      | chapter | title              | triggers_required |
      | 1       | The Beginning      | none              |
      | 2       | Rising Threat      | complete_ch1      |
      | 3       | Dark Revelations   | complete_ch2      |
      | 4       | The Battle         | complete_ch3      |
      | 5       | Resolution         | complete_ch4      |
    When I run story progression simulation
    Then each chapter transition should trigger correctly
    And story flags should activate properly:
      | flag_name           | triggers_at |
      | hero_awakened       | chapter_1   |
      | villain_revealed    | chapter_3   |
      | final_confrontation | chapter_4   |
    And story completion should be achievable
    And estimated completion time should be calculated

  @narrative @branching
  Scenario: Test branching narrative paths
    Given my story has 3 major decision points:
      | decision_point | options           | outcomes        |
      | save_village   | fight, negotiate  | war_path, peace |
      | choose_ally    | wizard, warrior   | magic, strength |
      | final_choice   | sacrifice, trick  | hero, trickster |
    When I simulate all possible path combinations
    Then each path should reach a valid conclusion
    And path coverage should be 100%:
      | path_combination        | reachable | conclusion  |
      | fight-wizard-sacrifice  | yes       | tragic_hero |
      | fight-wizard-trick      | yes       | clever_hero |
      | negotiate-warrior-sacrifice | yes   | noble_hero  |
    And no paths should lead to dead ends

  @narrative @quests
  Scenario: Validate quest dependencies and ordering
    Given my world has 20 quests with dependencies:
      | quest_id | prerequisites     | rewards        |
      | Q-001    | none              | 100 gold       |
      | Q-002    | Q-001             | sword          |
      | Q-003    | Q-001, Q-002      | access_to_zone |
    When I run quest dependency validation
    Then all prerequisite chains should be valid
    And circular dependencies should be flagged
    And optimal quest ordering should be suggested:
      | order | quest_id | reason              |
      | 1     | Q-001    | No prerequisites    |
      | 2     | Q-002    | Unlocked by Q-001   |
      | 3     | Q-003    | Requires Q-001, Q-002 |

  @narrative @triggers
  Scenario: Test event triggers and conditions
    Given my world has complex event triggers
    When I validate trigger conditions:
      | trigger_id | condition                  | action           |
      | TRG-001    | player_level >= 10         | unlock_zone      |
      | TRG-002    | quest_completed(Q-005)     | spawn_boss       |
      | TRG-003    | time_in_world >= 1 hour    | show_secret      |
    Then all triggers should be reachable
    And no impossible conditions should exist
    And trigger timing should be validated

  # =============================================================================
  # GAME BALANCE TESTING
  # =============================================================================

  @balance @progression @happy-path
  Scenario: Test game balance and progression systems
    Given my world has level 1-50 progression
    When I simulate complete progression cycle
    Then I should see progression analysis:
      | level_range | expected_time | actual_time | variance |
      | 1-10        | 2 hours       | 2.1 hours   | +5%      |
      | 11-20       | 4 hours       | 3.8 hours   | -5%      |
      | 21-30       | 6 hours       | 6.5 hours   | +8%      |
      | 31-40       | 8 hours       | 8.2 hours   | +2%      |
      | 41-50       | 10 hours      | 9.5 hours   | -5%      |
    And power growth should be within expected ranges
    And no exploitable progression shortcuts should exist

  @balance @economy
  Scenario: Test economy balance
    Given my world has in-game currency and items:
      | currency   | gold              |
      | item_tiers | common, rare, epic |
    When I simulate economy over 1000 player-hours
    Then I should see economy analysis:
      | metric              | expected | actual | status  |
      | gold_generated      | 100,000  | 95,000 | healthy |
      | gold_spent          | 90,000   | 88,000 | healthy |
      | inflation_rate      | < 5%     | 3.2%   | healthy |
    And item distribution should match design:
      | tier   | expected_rate | actual_rate |
      | common | 70%           | 72%         |
      | rare   | 25%           | 24%         |
      | epic   | 5%            | 4%          |
    And no economy-breaking exploits should be detected

  @balance @combat
  Scenario: Test combat or challenge balance
    Given my world has challenge encounters:
      | encounter   | designed_for | difficulty |
      | Forest Wolf | level 5      | easy       |
      | Cave Troll  | level 15     | medium     |
      | Dragon      | level 30     | hard       |
    When I simulate challenges at various skill levels
    Then difficulty should match design:
      | encounter   | under_level | at_level | over_level |
      | Forest Wolf | hard        | easy     | trivial    |
      | Cave Troll  | very_hard   | medium   | easy       |
      | Dragon      | impossible  | hard     | medium     |
    And player skill should matter in outcomes
    And win rates should be within expected ranges

  @balance @rewards
  Scenario: Test reward distribution fairness
    Given my world has various reward sources
    When I analyze reward distribution
    Then time-to-reward should be fair:
      | activity      | avg_reward_per_hour | target |
      | questing      | 500 gold            | 500    |
      | exploration   | 200 gold            | 200    |
      | combat        | 300 gold            | 300    |
    And no activity should dominate others significantly

  # =============================================================================
  # PERFORMANCE TESTING
  # =============================================================================

  @performance @load @happy-path
  Scenario: Test world performance under simulated load
    Given the simulation environment is active
    When I run load test with 500 simulated players:
      | player_distribution | actions_per_minute |
      | exploring: 40%      | 10                 |
      | combat: 30%         | 20                 |
      | social: 30%         | 5                  |
    Then I should see performance metrics:
      | metric                | value   | threshold | status  |
      | avg_response_time     | 150ms   | < 200ms   | pass    |
      | p99_latency           | 800ms   | < 1000ms  | pass    |
      | error_rate            | 0.1%    | < 1%      | pass    |
      | concurrent_connections| 500     | 500       | pass    |
    And resource utilization should be recorded

  @performance @scale
  Scenario: Test world performance at scale limits
    Given I want to test maximum capacity
    When I gradually increase load:
      | phase | players | duration |
      | 1     | 500     | 5 min    |
      | 2     | 1000    | 5 min    |
      | 3     | 1500    | 5 min    |
      | 4     | 2000    | 5 min    |
    Then I should see performance degradation curve
    And breaking point should be identified:
      | breaking_point    | 1750 players           |
      | degradation_type  | response_time > 2s     |
    And recommendations should be provided:
      | recommendation      | impact                |
      | upgrade_to_premium  | Support 3000 players  |
      | optimize_queries    | 20% improvement       |

  @performance @assets
  Scenario: Test world asset loading performance
    Given my world has rich media assets:
      | asset_type | count | total_size |
      | textures   | 500   | 2 GB       |
      | audio      | 100   | 500 MB     |
      | models     | 200   | 1 GB       |
    When I simulate new player entering world
    Then initial load time should be under 10 seconds
    And asset streaming metrics should be:
      | metric              | value      |
      | initial_load        | 8.5s       |
      | streaming_quality   | smooth     |
      | memory_peak         | 1.2 GB     |
      | memory_stable       | 800 MB     |

  @performance @recovery
  Scenario: Test recovery from performance degradation
    Given simulation is under heavy load at 150% capacity
    When load is reduced to normal levels (80% capacity)
    Then performance should recover within 60 seconds
    And metrics should return to normal:
      | metric            | during_stress | after_recovery |
      | response_time     | 2500ms        | 180ms          |
      | error_rate        | 5%            | 0.1%           |

  # =============================================================================
  # USER EXPERIENCE SIMULATION
  # =============================================================================

  @ux @onboarding
  Scenario: Simulate new player onboarding
    Given the simulation environment is running
    When I simulate new player onboarding
    Then I should see onboarding analysis:
      | step                | completion_rate | avg_time |
      | create_character    | 100%            | 2 min    |
      | tutorial_intro      | 98%             | 3 min    |
      | first_quest         | 95%             | 5 min    |
      | explore_hub         | 92%             | 4 min    |
    And tutorial flow should complete without issues
    And help prompts should appear at correct moments

  @ux @accessibility
  Scenario: Simulate accessibility scenarios
    Given accessibility features are enabled
    When I run accessibility simulation
    Then I should see accessibility report:
      | check                  | status | details              |
      | screen_reader         | pass   | All elements labeled |
      | color_contrast        | pass   | WCAG AA compliant    |
      | keyboard_navigation   | pass   | Full support         |
      | text_scaling          | pass   | Supports 200%        |
    And any issues should be flagged with remediation

  @ux @devices
  Scenario Outline: Simulate different device experiences
    Given I want to test on "<device_type>"
    When I simulate experience on "<device_type>"
    Then UI should render correctly
    And controls should be appropriate:
      | control_type     | available |
      | <primary_input>  | yes       |
      | <secondary_input>| yes       |
    And performance should meet expectations:
      | metric      | threshold   |
      | fps         | <min_fps>   |
      | load_time   | <max_load>  |

    Examples:
      | device_type   | primary_input | secondary_input | min_fps | max_load |
      | desktop_high  | keyboard      | mouse           | 60      | 5s       |
      | desktop_low   | keyboard      | mouse           | 30      | 10s      |
      | tablet        | touch         | stylus          | 30      | 8s       |
      | mobile_high   | touch         | gyro            | 30      | 6s       |
      | mobile_low    | touch         | gyro            | 24      | 12s      |

  @ux @journey
  Scenario: Simulate complete user journey
    Given I want to test the full user experience
    When I simulate a 2-hour play session
    Then I should see journey analysis:
      | phase           | engagement | friction_points |
      | onboarding      | high       | 0               |
      | early_game      | high       | 1               |
      | mid_game        | medium     | 2               |
      | late_game       | high       | 0               |
    And friction points should be identified with solutions

  # =============================================================================
  # CONTENT VALIDATION
  # =============================================================================

  @validation @content @happy-path
  Scenario: Validate all world content before launch
    Given I want comprehensive content validation
    When I run content validation suite
    Then I should see validation results:
      | check_type     | total   | passed | failed | warnings |
      | text_content   | 5,000   | 4,995  | 0      | 5        |
      | media_assets   | 800     | 798    | 2      | 0        |
      | links          | 200     | 200    | 0      | 0        |
      | content_rating | 1       | 1      | 0      | 0        |
    And failed items should be listed with details

  @validation @policy
  Scenario: Validate content against platform policies
    Given platform content policies exist
    When I run policy compliance check
    Then I should see compliance results:
      | policy_area      | status    | issues |
      | violence         | compliant | 0      |
      | language         | warning   | 3      |
      | gambling         | compliant | 0      |
      | user_privacy     | compliant | 0      |
    And flagged content should be highlighted
    And I should see overall compliance score: 95%

  @validation @localization
  Scenario: Validate localization completeness
    Given my world supports multiple languages:
      | language | code  |
      | English  | en-US |
      | Spanish  | es-ES |
      | French   | fr-FR |
      | German   | de-DE |
    When I run localization validation
    Then I should see coverage report:
      | language | coverage | missing_strings | encoding_issues |
      | en-US    | 100%     | 0               | 0               |
      | es-ES    | 95%      | 250             | 0               |
      | fr-FR    | 92%      | 400             | 2               |
      | de-DE    | 88%      | 600             | 0               |
    And layout issues should be detected per language

  # =============================================================================
  # PLATFORM INTEGRATION TESTING
  # =============================================================================

  @integration @platform @happy-path
  Scenario: Test integrations with platform systems
    Given platform systems are available in simulation
    When I test platform integrations
    Then I should see integration status:
      | integration       | status | response_time |
      | authentication    | pass   | 120ms         |
      | payments          | pass   | 350ms         |
      | leaderboards      | pass   | 80ms          |
      | achievements      | pass   | 95ms          |
      | social_features   | pass   | 150ms         |
    And integration errors should be clearly reported

  @integration @payments
  Scenario: Test payment flow in simulation mode
    Given payment integration is enabled
    And sandbox payment credentials are configured
    When I test in-world purchase flow:
      | item          | price  | payment_method |
      | Premium Sword | $4.99  | test_card      |
    Then payment should process in sandbox mode
    And no real charges should occur
    And purchase should be reflected in simulation:
      | item_received  | Premium Sword |
      | inventory      | updated       |
      | transaction_id | TXN-TEST-001  |

  @integration @external-api
  Scenario: Test external API integrations
    Given my world uses external APIs:
      | api_name       | purpose           |
      | weather_api    | Dynamic weather   |
      | news_api       | In-game newspaper |
    When I run integration tests in simulation
    Then mock responses should be used:
      | api_name       | mode      | response_time |
      | weather_api    | mocked    | 50ms          |
      | news_api       | mocked    | 45ms          |
    And API error handling should be validated
    And fallback behaviors should work correctly

  # =============================================================================
  # SIMULATION REPORTS
  # =============================================================================

  @reports @comprehensive
  Scenario: Generate comprehensive simulation reports
    Given simulation tests have been executed
    When I generate simulation report
    Then report should include sections:
      | section              | content_summary              |
      | executive_summary    | Overall pass/fail status     |
      | ai_testing           | Character behavior results   |
      | performance          | Load and stress test results |
      | balance              | Economy and progression      |
      | content_validation   | Policy compliance            |
      | recommendations      | Prioritized action items     |
    And report should be downloadable as PDF

  @reports @compare
  Scenario: Compare simulation results across runs
    Given I have 3 simulation runs:
      | run_id | date       | overall_score |
      | RUN-01 | 2024-01-10 | 82%           |
      | RUN-02 | 2024-01-15 | 87%           |
      | RUN-03 | 2024-01-20 | 91%           |
    When I compare run results
    Then I should see improvement trend
    And significant changes should be highlighted:
      | metric           | RUN-01 | RUN-03 | change |
      | performance      | 78%    | 94%    | +16%   |
      | ai_quality       | 85%    | 89%    | +4%    |
      | content_coverage | 90%    | 95%    | +5%    |

  @reports @export
  Scenario: Export simulation data for analysis
    Given simulation has generated data
    When I export simulation data with:
      | format     | csv, json          |
      | data_types | all                |
      | date_range | last_7_days        |
    Then data should be exported successfully
    And export should include:
      | data_type    | format   |
      | metrics      | csv      |
      | logs         | json     |
      | test_results | csv      |

  # =============================================================================
  # AUTOMATED TESTING
  # =============================================================================

  @automation @suite
  Scenario: Run automated testing scenarios
    Given I have defined automated test scripts:
      | script_name        | test_count |
      | core_functionality | 50         |
      | edge_cases         | 30         |
      | regression         | 100        |
    When I execute automated test suite
    Then all test cases should execute:
      | script_name        | passed | failed | skipped |
      | core_functionality | 48     | 2      | 0       |
      | edge_cases         | 28     | 1      | 1       |
      | regression         | 100    | 0      | 0       |
    And test coverage should be reported: 85%

  @automation @schedule
  Scenario: Schedule recurring automated tests
    Given automated tests are configured
    When I schedule daily test runs at 02:00 UTC
    Then tests should run automatically at scheduled time
    And I should receive notifications:
      | condition      | notification_type |
      | all_pass       | email_summary     |
      | any_fail       | email + slack     |
      | critical_fail  | pagerduty         |
    And historical results should be tracked

  @automation @custom
  Scenario: Create custom test scenarios
    Given I want to test specific scenarios
    When I create custom test script:
      | step_order | action                    | expected_result      |
      | 1          | player_enters_zone        | welcome_message      |
      | 2          | player_talks_to_npc       | dialogue_starts      |
      | 3          | player_accepts_quest      | quest_added          |
      | 4          | player_completes_quest    | reward_granted       |
    Then the custom test should be saved
    And it should be runnable on demand
    And results should be recorded

  # =============================================================================
  # MULTI-PLAYER SIMULATION
  # =============================================================================

  @multiplayer @interaction
  Scenario: Simulate multi-player interactions
    Given simulation supports multi-player mode
    When I simulate 20 players in same zone
    Then player interactions should work:
      | interaction_type | status |
      | proximity_chat   | works  |
      | trading          | works  |
      | party_formation  | works  |
      | pvp_combat       | works  |
    And shared world state should be consistent
    And no desync issues should occur

  @multiplayer @competitive
  Scenario: Test competitive multiplayer scenarios
    Given my world has PvP features
    When I simulate competitive match:
      | match_type | players | duration |
      | arena_2v2  | 4       | 10 min   |
    Then matchmaking should function correctly
    And game rules should be enforced
    And results should be recorded:
      | field          | value      |
      | winner         | team_blue  |
      | match_duration | 8:45       |
      | fair_play      | verified   |

  @multiplayer @cooperative
  Scenario: Test cooperative multiplayer scenarios
    Given my world has cooperative content
    When I simulate party completing group content:
      | content_type | party_size | difficulty |
      | dungeon      | 4          | normal     |
    Then coordination mechanics should work
    And rewards should distribute correctly:
      | player    | reward_type | amount |
      | player_1  | gold        | 1000   |
      | player_2  | gold        | 1000   |
      | player_3  | gold        | 1000   |
      | player_4  | gold        | 1000   |
    And progress should sync across party members

  # =============================================================================
  # LAUNCH READINESS
  # =============================================================================

  @readiness @assessment @happy-path
  Scenario: Assess world readiness for public launch
    Given all simulation tests have been run
    When I request launch readiness assessment
    Then I should see overall readiness:
      | category         | score | status   |
      | performance      | 95%   | ready    |
      | content          | 92%   | ready    |
      | ai_quality       | 88%   | ready    |
      | balance          | 85%   | ready    |
      | integration      | 100%  | ready    |
      | overall          | 92%   | ready    |
    And blocking issues should be listed (if any)
    And launch checklist should show completion status

  @readiness @certification
  Scenario: Generate launch certification report
    Given world meets minimum launch criteria
    When I generate launch certification
    Then certification should include:
      | section              | content                    |
      | test_summary         | All test results           |
      | platform_compliance  | Policy adherence verified  |
      | performance_baseline | Capacity recommendations   |
      | certification_date   | 2024-01-20                 |
      | valid_until          | 2024-02-19                 |
    And certification should be valid for 30 days

  @readiness @blocked
  Scenario: Block launch with critical issues
    Given simulation has identified critical issues:
      | issue_type      | description                    |
      | security        | XSS vulnerability in chat      |
      | performance     | Crash at 100 concurrent users  |
    When I attempt to publish world
    Then launch should be blocked
    And I should see blocking issues list
    And I should see resolution guidance:
      | issue           | remediation                    |
      | XSS             | Sanitize user input in chat    |
      | performance     | Optimize database queries      |

  # =============================================================================
  # ENVIRONMENT MANAGEMENT
  # =============================================================================

  @management @dashboard
  Scenario: View simulation environment dashboard
    Given I have 3 active simulation environments
    When I view simulation management dashboard
    Then I should see all my simulations:
      | env_id  | world       | status  | time_remaining |
      | SIM-001 | Fantasy     | running | 18 hours       |
      | SIM-002 | SciFi       | paused  | 12 hours       |
      | SIM-003 | Medieval    | running | 6 hours        |
    And I should see total resource usage
    And I should be able to manage each simulation

  @management @extend
  Scenario: Extend simulation environment duration
    Given my simulation "SIM-001" expires in 2 hours
    When I extend simulation by 24 hours
    Then simulation should continue running
    And I should see cost details:
      | extension_duration | 24 hours |
      | additional_cost    | $10.00   |
    And extension should be logged

  @management @terminate
  Scenario: Terminate simulation and clean up resources
    Given I am done with simulation "SIM-001"
    When I terminate the simulation
    Then all simulation resources should be released
    And simulation data should be archived:
      | data_type    | retention  |
      | test_results | 90 days    |
      | logs         | 30 days    |
      | metrics      | 90 days    |
    And a domain event "SimulationEnvironmentTerminated" should be published

  # =============================================================================
  # DOMAIN EVENTS
  # =============================================================================

  @domain-events @created
  Scenario: SimulationEnvironmentCreated triggers setup
    Given a new simulation is requested
    When "SimulationEnvironmentCreated" event is published
    Then sandbox resources should be provisioned
    And monitoring should be activated
    And simulation should appear on owner dashboard
    And notification should be sent to owner

  @domain-events @completed
  Scenario: SimulationTestCompleted triggers reporting
    Given a simulation test has finished
    When "SimulationTestCompleted" event is published
    Then results should be stored
    And owner should be notified
    And readiness score should be recalculated

  @domain-events @critical
  Scenario: SimulationCriticalIssueFound triggers alerts
    Given a critical issue is detected during simulation
    When "SimulationCriticalIssueFound" event is published
    Then owner should receive immediate notification:
      | channel  | message_type  |
      | email    | urgent_alert  |
      | sms      | critical_issue|
    And issue should be logged with full details
    And remediation suggestions should be generated

  # =============================================================================
  # ERROR HANDLING
  # =============================================================================

  @error @creation-failure
  Scenario: Handle simulation environment creation failure
    Given infrastructure has capacity issues
    When simulation environment creation fails
    Then I should see error "Failed to create simulation environment"
    And I should see failure details:
      | reason           | Insufficient resources    |
      | suggested_action | Try again in 30 minutes   |
    And no partial resources should be left allocated

  @error @timeout
  Scenario: Handle test execution timeout
    Given a test is running
    And test has been running for 30 minutes
    When test exceeds maximum duration of 30 minutes
    Then test should be terminated gracefully
    And partial results should be captured
    And timeout report should include:
      | completed_steps  | 45/50        |
      | timeout_at       | step 46      |
      | recommendation   | Split test   |

  @error @corruption
  Scenario: Handle simulation data corruption
    Given simulation "SIM-001" is active
    When data corruption is detected
    Then affected tests should be marked invalid
    And I should see options:
      | option          | description                |
      | reset_state     | Reset to last valid state  |
      | recreate        | Create new simulation      |
      | contact_support | Get help from support      |
    And incident should be logged for investigation
