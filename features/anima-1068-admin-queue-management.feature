@admin @queue @messaging @platform
Feature: Admin Queue Management
  As a platform administrator
  I want to manage message queues and workflow systems
  So that I can ensure reliable asynchronous processing

  Background:
    Given I am logged in as a platform administrator
    And I have queue management permissions
    And the messaging infrastructure is operational
    And the following queue namespaces are configured:
      | namespace    | cluster   | status  | topics | subscriptions |
      | production   | us-east   | healthy | 45     | 128           |
      | staging      | us-east   | healthy | 32     | 64            |
      | development  | us-west   | healthy | 25     | 48            |
      | analytics    | us-east   | healthy | 18     | 35            |

  # ============================================
  # QUEUE DASHBOARD
  # ============================================

  Scenario: View comprehensive message queue dashboard
    When I navigate to the queue management dashboard
    Then I should see all configured queues organized by namespace:
      | namespace    | topics | healthy | degraded | critical |
      | production   | 45     | 43      | 2        | 0        |
      | staging      | 32     | 32      | 0        | 0        |
      | development  | 25     | 25      | 0        | 0        |
      | analytics    | 18     | 17      | 1        | 0        |
    And I should see message throughput metrics:
      | metric                | value       | trend    |
      | messages_in_per_sec   | 125,000     | +15%     |
      | messages_out_per_sec  | 124,500     | +14%     |
      | avg_message_size      | 2.4 KB      | stable   |
      | total_storage_used    | 850 GB      | +5%      |
    And I should see queue depth by topic:
      | topic                  | depth      | trend    | status  |
      | events.user-actions    | 1,250      | stable   | healthy |
      | events.orders          | 45,000     | +500%    | warning |
      | events.notifications   | 500        | -20%     | healthy |
      | events.analytics       | 125,000    | +50%     | warning |
    And I should see consumer lag indicators:
      | subscription              | lag        | lag_time | status   |
      | order-processor           | 12,500     | 2 min    | warning  |
      | notification-sender       | 150        | 5 sec    | healthy  |
      | analytics-aggregator      | 85,000     | 15 min   | critical |

  Scenario: Dashboard real-time updates with anomaly detection
    Given the queue dashboard is open
    And current message rate is 125,000/sec
    When message volume suddenly increases to 250,000/sec
    Then metrics should update within 5 seconds
    And I should see the spike reflected in the throughput graph
    And an anomaly alert should appear:
      | alert_type    | severity | message                              |
      | Traffic spike | warning  | Message rate increased 100% in 1 min |
    And the affected topics should be highlighted
    And I should see suggested actions:
      | action                    | description                    |
      | Scale consumers           | Add capacity to handle load    |
      | Enable rate limiting      | Protect downstream systems     |
      | Investigate source        | Check producer behavior        |

  Scenario: Filter and search queue dashboard
    When I filter the dashboard by namespace "production"
    Then I should only see production topics
    When I search for topic "order"
    Then I should see matching topics:
      | topic                  | namespace   | depth   |
      | events.orders          | production  | 45,000  |
      | events.order-updates   | production  | 2,500   |
      | events.order-completed | production  | 850     |

  # ============================================
  # PULSAR STREAMING
  # ============================================

  Scenario: View Pulsar cluster status with detailed health
    When I view Pulsar cluster status
    Then I should see broker health:
      | broker_id | status  | cpu   | memory | connections | topics_served |
      | broker-1  | healthy | 45%   | 62%    | 2,500       | 32            |
      | broker-2  | healthy | 52%   | 58%    | 2,800       | 35            |
      | broker-3  | warning | 78%   | 75%    | 3,200       | 38            |
      | broker-4  | healthy | 48%   | 60%    | 2,600       | 30            |
    And I should see topic partition distribution:
      | topic                  | partitions | leader_broker | replicas      |
      | events.user-actions    | 6          | broker-1      | broker-2,3    |
      | events.orders          | 12         | broker-2      | broker-1,4    |
      | events.notifications   | 4          | broker-3      | broker-1,2    |
    And I should see subscription status:
      | subscription         | type     | consumers | backlog  | msg_rate_out |
      | order-processor      | shared   | 5         | 12,500   | 5,000/s      |
      | notification-sender  | exclusive| 1         | 150      | 2,500/s      |
      | analytics-writer     | failover | 2         | 85,000   | 1,200/s      |
    And I should see storage utilization:
      | storage_type   | used    | available | utilization |
      | Journal        | 120 GB  | 500 GB    | 24%         |
      | Ledger         | 850 GB  | 2 TB      | 42%         |
      | Offload (S3)   | 2.5 TB  | Unlimited | N/A         |

  Scenario: Create Pulsar topic with full configuration
    When I create Pulsar topic with the following configuration:
      | field                    | value                    |
      | namespace                | production               |
      | name                     | events.user-actions      |
      | partitions               | 6                        |
      | replication_factor       | 3                        |
      | retention_time           | 7 days                   |
      | retention_size           | 50 GB                    |
      | schema_type              | avro                     |
      | schema_compatibility     | BACKWARD                 |
      | compaction_enabled       | true                     |
      | compaction_threshold     | 50%                      |
      | deduplication            | enabled                  |
      | max_message_size         | 5 MB                     |
      | ttl                      | 24 hours                 |
    Then the topic should be created successfully
    And schema should be registered in the schema registry:
      | schema_field     | value                    |
      | schema_id        | generated                |
      | version          | 1                        |
      | type             | AVRO                     |
      | compatibility    | BACKWARD                 |
    And a TopicCreated domain event should be published with:
      | field            | value                    |
      | topic_name       | events.user-actions      |
      | namespace        | production               |
      | partitions       | 6                        |
      | created_by       | current_user_id          |
    And the topic should appear in the dashboard within 10 seconds

  Scenario: Manage topic partitions with rebalancing
    Given topic "events.user-actions" exists with 6 partitions
    And current consumer assignments are:
      | consumer   | partitions     |
      | consumer-1 | 0, 1           |
      | consumer-2 | 2, 3           |
      | consumer-3 | 4, 5           |
    When I increase partitions from 6 to 12
    Then I should see partition creation progress:
      | step                    | status      |
      | Create new partitions   | completed   |
      | Update metadata         | completed   |
      | Trigger rebalance       | in_progress |
    And consumers should rebalance:
      | consumer   | old_partitions | new_partitions     |
      | consumer-1 | 0, 1           | 0, 1, 6, 7         |
      | consumer-2 | 2, 3           | 2, 3, 8, 9         |
      | consumer-3 | 4, 5           | 4, 5, 10, 11       |
    And no data should be lost during rebalancing
    And a PartitionsIncreased event should be published

  Scenario: Configure topic retention with tiered storage
    When I configure retention for topic "events.audit":
      | setting              | value                    |
      | time_retention       | 30 days                  |
      | size_retention       | 100 GB                   |
      | compaction           | enabled                  |
      | compaction_threshold | 40%                      |
      | offload_threshold    | 7 days                   |
      | offload_destination  | s3://ffl-archive/pulsar  |
      | offload_deletion     | enabled                  |
    Then retention policies should be applied:
      | policy               | behavior                           |
      | Time-based deletion  | Messages > 30 days deleted         |
      | Size-based deletion  | Oldest messages deleted if > 100GB |
      | Compaction           | Duplicate keys removed at 40% ratio|
      | Offload              | Data > 7 days moved to S3          |
    And old messages should be cleaned according to policy
    And storage costs should be optimized

  Scenario: View and manage subscriptions with detailed metrics
    When I view subscriptions for topic "events.orders"
    Then I should see all active subscriptions:
      | subscription         | type      | consumers | backlog  | msg_rate | created_at          |
      | order-processor      | shared    | 5         | 12,500   | 5,000/s  | 2024-01-15 10:00:00 |
      | order-analytics      | exclusive | 1         | 2,500    | 1,500/s  | 2024-02-20 14:30:00 |
      | fraud-detector       | failover  | 2         | 500      | 2,000/s  | 2024-03-10 09:15:00 |
      | notification-trigger | shared    | 3         | 150      | 3,500/s  | 2024-04-05 11:45:00 |
    And I should see consumer details per subscription:
      | subscription    | consumer_id    | connected_since     | msg_rate | unacked |
      | order-processor | consumer-1     | 2024-12-29 08:00:00 | 1,200/s  | 50      |
      | order-processor | consumer-2     | 2024-12-29 08:00:00 | 1,100/s  | 45      |
      | order-processor | consumer-3     | 2024-12-29 08:05:00 | 950/s    | 60      |
    And I should see message backlog age distribution:
      | age_bucket   | message_count | percentage |
      | < 1 minute   | 5,000         | 40%        |
      | 1-5 minutes  | 4,500         | 36%        |
      | 5-15 minutes | 2,000         | 16%        |
      | > 15 minutes | 1,000         | 8%         |

  Scenario: Force subscription reset with safety checks
    Given subscription "analytics-writer" has significant backlog of 85,000 messages
    And the backlog contains messages from the last 2 hours
    When I request to reset subscription to "earliest"
    Then I should see a warning:
      | warning_type     | message                                    |
      | Data reprocessing| All 85,000 messages will be reprocessed    |
      | Duplicate risk   | May cause duplicate processing             |
      | Consumer impact  | 2 consumers will be disconnected           |
    And I should confirm the reset action
    When I confirm the reset
    Then consumers should be disconnected gracefully
    And subscription cursor should reset to earliest position
    And consumers should restart from the beginning
    And backlog should show full topic depth
    And an audit log entry should be created:
      | field          | value                    |
      | action         | subscription_reset       |
      | subscription   | analytics-writer         |
      | reset_position | earliest                 |
      | user           | current_user_id          |

  # ============================================
  # TEMPORAL WORKFLOWS
  # ============================================

  Scenario: View Temporal workflow dashboard with comprehensive metrics
    When I view Temporal workflow dashboard
    Then I should see running workflows count by type:
      | workflow_type         | running | avg_duration | oldest_running     |
      | order-processing      | 125     | 2.5 min      | 15 min ago         |
      | payment-processing    | 45      | 1.2 min      | 5 min ago          |
      | user-registration     | 12      | 30 sec       | 2 min ago          |
      | score-calculation     | 250     | 45 sec       | 3 min ago          |
    And I should see completed workflows (last 24 hours):
      | workflow_type         | completed | success_rate | avg_duration |
      | order-processing      | 15,250    | 99.2%        | 2.3 min      |
      | payment-processing    | 8,450     | 98.5%        | 1.1 min      |
      | user-registration     | 2,150     | 99.8%        | 28 sec       |
      | score-calculation     | 125,000   | 99.9%        | 42 sec       |
    And I should see failed workflows requiring attention:
      | workflow_id                | type              | failed_at           | failure_reason         |
      | order-proc-12345           | order-processing  | 2024-12-29 09:15:00 | Payment timeout        |
      | payment-789                | payment-processing| 2024-12-29 09:10:00 | External service error |
      | score-calc-999             | score-calculation | 2024-12-29 09:05:00 | Data validation failed |
    And I should see workflow execution time percentiles:
      | workflow_type         | p50    | p90    | p99    |
      | order-processing      | 1.8min | 3.5min | 8.2min |
      | payment-processing    | 45sec  | 1.5min | 4.0min |
      | score-calculation     | 35sec  | 55sec  | 1.5min |

  Scenario: View detailed workflow execution history
    When I search for workflow "order-processing-12345"
    Then I should see workflow summary:
      | field              | value                              |
      | workflow_id        | order-processing-12345             |
      | run_id             | run-abc-123                        |
      | type               | order-processing                   |
      | status             | Running                            |
      | started_at         | 2024-12-29 09:00:00                |
      | current_duration   | 30 minutes                         |
      | parent_workflow    | None                               |
    And I should see workflow history:
      | event_id | event_type           | timestamp           | details                    |
      | 1        | WorkflowStarted      | 09:00:00            | Input: order_id=12345      |
      | 2        | ActivityScheduled    | 09:00:01            | ValidateOrder              |
      | 3        | ActivityStarted      | 09:00:01            | worker-1                   |
      | 4        | ActivityCompleted    | 09:00:05            | Validation passed          |
      | 5        | ActivityScheduled    | 09:00:05            | ReserveInventory           |
      | 6        | ActivityStarted      | 09:00:06            | worker-2                   |
      | 7        | ActivityCompleted    | 09:00:15            | Inventory reserved         |
      | 8        | ActivityScheduled    | 09:00:15            | ProcessPayment             |
      | 9        | ActivityStarted      | 09:00:16            | worker-3                   |
      | 10       | ActivityTaskTimedOut | 09:30:00            | Timeout after 30 min       |
    And I should see pending activities:
      | activity           | scheduled_at | attempts | last_failure           |
      | ProcessPayment     | 09:00:15     | 3        | Connection timeout     |
    And I should see retry configuration:
      | setting              | value                    |
      | max_attempts         | 5                        |
      | initial_interval     | 1 second                 |
      | backoff_coefficient  | 2.0                      |
      | max_interval         | 5 minutes                |

  Scenario: Debug stuck workflow with detailed diagnostics
    Given workflow "payment-workflow-789" has been running for 2 hours
    And the expected duration is 5 minutes
    When I analyze the stuck workflow
    Then I should see diagnostic information:
      | diagnostic           | finding                            |
      | Current state        | Waiting on external signal         |
      | Last activity        | SendPaymentRequest (completed)     |
      | Pending signal       | payment_confirmed                  |
      | Signal wait time     | 1 hour 55 minutes                  |
    And I should see related system status:
      | system               | status    | last_communication   |
      | Payment gateway      | Healthy   | 5 seconds ago        |
      | Webhook endpoint     | Healthy   | 10 seconds ago       |
      | Database             | Healthy   | 1 second ago         |
    And I should see recommended actions:
      | action               | description                        |
      | Check payment status | Query payment provider directly    |
      | Send manual signal   | Manually confirm or reject         |
      | Terminate workflow   | Cancel and trigger compensation    |
    And I should be able to:
      | capability           | available |
      | Send signal          | yes       |
      | Terminate            | yes       |
      | Query state          | yes       |
      | Reset workflow       | no        |

  Scenario: Terminate stuck workflow with compensation
    Given workflow "payment-workflow-789" has been stuck for over 24 hours
    And the workflow has completed activities that need compensation
    When I terminate workflow with reason "Manual intervention - payment timeout"
    Then I should see termination confirmation dialog:
      | warning                                                      |
      | Workflow will be terminated immediately                      |
      | Completed activities: ReserveInventory, InitiatePayment      |
      | Compensation may be required for these activities            |
    When I confirm termination
    Then workflow should be terminated:
      | field              | value                              |
      | status             | Terminated                         |
      | terminated_at      | current_timestamp                  |
      | terminated_by      | current_user_id                    |
      | reason             | Manual intervention - payment timeout |
    And compensation workflow should be triggered:
      | compensation_workflow | status    |
      | ReleaseInventory      | Running   |
      | RefundPayment         | Scheduled |
    And a WorkflowTerminated domain event should be published

  Scenario: Signal running workflow to continue execution
    Given workflow "approval-flow-456" is waiting for signal "manager_decision"
    And the workflow has been waiting for 30 minutes
    When I signal workflow with:
      | signal_name    | manager_decision           |
      | signal_data    | {"approved": true, "approver": "manager@company.com"} |
    Then workflow should receive the signal
    And workflow should continue execution
    And signal should be recorded in history:
      | event_type       | SignalReceived           |
      | signal_name      | manager_decision         |
      | signal_data      | approved=true            |
      | timestamp        | current_timestamp        |
    And subsequent activities should execute

  Scenario: Retry failed workflow from last checkpoint
    Given workflow "score-calc-999" failed at activity "CalculateBonus"
    And the failure was due to transient database error
    And 3 of 5 activities have completed successfully
    When I retry workflow from last failed activity
    Then retry should be initiated:
      | field                | value                    |
      | retry_run_id         | new_run_id               |
      | resume_from          | CalculateBonus           |
      | preserved_results    | 3 activities             |
    And previously completed activities should not re-run
    And workflow should resume from CalculateBonus
    And a WorkflowRetried event should be published

  # ============================================
  # QUEUE HEALTH METRICS
  # ============================================

  Scenario: Monitor comprehensive queue health metrics
    When I view queue health dashboard
    Then I should see key metrics with thresholds:
      | metric              | current_value | threshold | status   |
      | message_rate_in     | 125,000/s     | 200,000/s | healthy  |
      | message_rate_out    | 124,500/s     | 200,000/s | healthy  |
      | consumer_lag_total  | 150,000       | 100,000   | warning  |
      | processing_latency  | 45ms (p99)    | 100ms     | healthy  |
      | error_rate          | 0.02%         | 1%        | healthy  |
      | dlq_message_count   | 1,250         | 5,000     | healthy  |
      | storage_utilization | 42%           | 80%       | healthy  |
    And I should see metric trends over time:
      | metric           | 1_hour_ago | 6_hours_ago | 24_hours_ago |
      | message_rate     | 120,000/s  | 95,000/s    | 85,000/s     |
      | consumer_lag     | 125,000    | 80,000      | 45,000       |
      | error_rate       | 0.02%      | 0.01%       | 0.015%       |
    And I should see per-topic breakdown for degraded topics

  Scenario: Configure health alerts with escalation
    When I create queue alert rules:
      | alert_name           | condition              | threshold | severity | action              |
      | High consumer lag    | consumer_lag           | > 100,000 | critical | page_oncall         |
      | Elevated error rate  | error_rate             | > 1%      | high     | slack_and_email     |
      | Processing slowdown  | processing_latency_p99 | > 500ms   | warning  | email_team          |
      | DLQ accumulation     | dlq_count              | > 5,000   | high     | slack_alert         |
      | Storage warning      | storage_utilization    | > 80%     | warning  | email_ops           |
    Then alerts should be configured with:
      | alert_name        | check_interval | cooldown | escalation_after |
      | High consumer lag | 30 seconds     | 5 min    | 15 min           |
      | Elevated error rate| 1 minute      | 10 min   | 30 min           |
      | DLQ accumulation  | 5 minutes      | 30 min   | 2 hours          |
    And conditions should be monitored continuously
    And alert history should be maintained

  Scenario: View and acknowledge queue alerts
    Given alert "High consumer lag" has triggered
    When I view active alerts
    Then I should see alert details:
      | field              | value                              |
      | alert_name         | High consumer lag                  |
      | triggered_at       | 2024-12-29 09:15:00                |
      | current_value      | 150,000 messages                   |
      | threshold          | 100,000 messages                   |
      | affected_topics    | events.orders, events.analytics    |
      | suggested_actions  | Scale consumers, check downstream  |
    When I acknowledge the alert with comment "Scaling consumers"
    Then alert should be marked as acknowledged
    And escalation should be paused
    And resolution should be tracked

  # ============================================
  # DEAD LETTER QUEUES
  # ============================================

  Scenario: View comprehensive DLQ dashboard
    When I view DLQ dashboard
    Then I should see all DLQ topics:
      | dlq_topic              | source_topic        | message_count | oldest_message | failure_types                |
      | events.orders.dlq      | events.orders       | 450           | 2 hours ago    | Validation, Timeout          |
      | events.payments.dlq    | events.payments     | 125           | 45 min ago     | External service, Validation |
      | events.notifications.dlq| events.notifications| 25           | 15 min ago     | Delivery failure             |
    And I should see message accumulation trends:
      | dlq_topic           | last_hour | last_24h | last_7d |
      | events.orders.dlq   | +50       | +200     | +450    |
      | events.payments.dlq | +20       | +80      | +125    |
    And I should see failure reason breakdown:
      | failure_reason       | count | percentage |
      | Validation error     | 280   | 47%        |
      | Timeout              | 150   | 25%        |
      | External service     | 100   | 17%        |
      | Deserialization      | 45    | 7%         |
      | Unknown              | 25    | 4%         |

  Scenario: Inspect DLQ message with full context
    When I inspect message "msg-12345" in DLQ "events.orders.dlq"
    Then I should see message details:
      | field              | value                              |
      | message_id         | msg-12345                          |
      | original_topic     | events.orders                      |
      | published_at       | 2024-12-29 08:30:00                |
      | dlq_entry_at       | 2024-12-29 08:35:00                |
      | size               | 2.4 KB                             |
    And I should see message payload:
      | field              | value                              |
      | order_id           | ORD-98765                          |
      | user_id            | USR-12345                          |
      | amount             | 150.00                             |
      | status             | pending                            |
    And I should see failure information:
      | field              | value                              |
      | failure_reason     | Validation error                   |
      | error_message      | Invalid shipping address format    |
      | failed_at_consumer | order-processor-3                  |
      | stack_trace        | available (expandable)             |
    And I should see retry history:
      | attempt | timestamp           | result  | error                    |
      | 1       | 2024-12-29 08:31:00 | Failed  | Invalid address format   |
      | 2       | 2024-12-29 08:32:00 | Failed  | Invalid address format   |
      | 3       | 2024-12-29 08:34:00 | Failed  | Invalid address format   |
      | 4       | 2024-12-29 08:35:00 | Sent to DLQ | Max retries exceeded |

  Scenario: Process DLQ messages with multiple actions
    When I select messages in "events.orders.dlq" for processing
    Then I should be able to perform the following actions:
      | action     | description                         | confirmation_required |
      | Replay     | Send back to original topic         | Yes                   |
      | Redirect   | Send to specified topic             | Yes                   |
      | Delete     | Permanently remove from DLQ         | Yes (with reason)     |
      | Archive    | Move to cold storage                | No                    |
      | Export     | Download as JSON/CSV                | No                    |
    When I select "Replay" for 50 messages
    Then I should see replay configuration:
      | option                | default    | available_values     |
      | Delay between messages| 100ms      | 0-5000ms             |
      | Batch size            | 10         | 1-100                |
      | Skip validation       | false      | true/false           |
    When I confirm replay
    Then messages should be sent to original topic
    And replay progress should be visible:
      | metric           | value    |
      | Total messages   | 50       |
      | Replayed         | 35       |
      | In progress      | 5        |
      | Remaining        | 10       |

  Scenario: Bulk replay all DLQ messages with monitoring
    When I initiate bulk replay for all 450 messages in "events.orders.dlq"
    Then I should see estimated completion time
    And I should see resource impact warning:
      | warning                                              |
      | This will increase load on events.orders consumers   |
      | Current consumer capacity: 5,000 msg/s               |
      | Replay rate: 1,000 msg/s                             |
    When I confirm bulk replay
    Then messages should be sent to original topic at configured rate
    And I should see real-time progress:
      | metric           | value    |
      | Replayed         | 250/450  |
      | Success rate     | 98%      |
      | Failed (re-DLQ)  | 5        |
      | Elapsed time     | 5 min    |
      | ETA              | 4 min    |
    And DLQ should be cleared as messages are successfully replayed
    And a DLQBulkReplay event should be published

  Scenario: Configure DLQ policies for topic
    When I configure DLQ policies for topic "events.critical":
      | setting              | value                    |
      | max_retries          | 5                        |
      | initial_retry_delay  | 1 second                 |
      | max_retry_delay      | 5 minutes                |
      | retry_backoff        | exponential (2x)         |
      | dlq_retention        | 14 days                  |
      | alert_threshold      | 100 messages             |
      | auto_replay          | disabled                 |
      | archive_after        | 7 days                   |
    Then policies should be applied to the topic
    And failed messages should follow the retry policy:
      | attempt | delay_before_retry |
      | 1       | 1 second           |
      | 2       | 2 seconds          |
      | 3       | 4 seconds          |
      | 4       | 8 seconds          |
      | 5       | 16 seconds         |
      | 6       | Sent to DLQ        |
    And alerts should trigger when threshold is reached

  # ============================================
  # AUTO-SCALING
  # ============================================

  Scenario: Configure consumer auto-scaling rules
    When I configure auto-scaling for subscription "order-processor":
      | setting                | value                    |
      | min_consumers          | 2                        |
      | max_consumers          | 20                       |
      | target_lag             | 1,000 messages           |
      | scale_up_threshold     | lag > 5,000 for 2 min    |
      | scale_up_increment     | 2 consumers              |
      | scale_down_threshold   | lag < 500 for 5 min      |
      | scale_down_increment   | 1 consumer               |
      | cooldown_period        | 5 minutes                |
      | metric_window          | 2 minutes                |
    Then auto-scaling should be activated
    And current consumer count should be monitored
    And a ScalingConfigured domain event should be published
    And scaling rules should be visible in the dashboard

  Scenario: View auto-scaling history and decisions
    When I view scaling history for "order-processor"
    Then I should see recent scaling events:
      | timestamp           | action    | from | to | trigger_reason              | lag_at_decision |
      | 2024-12-29 09:30:00 | Scale Up  | 5    | 7  | Lag exceeded 5,000 for 2min | 6,500           |
      | 2024-12-29 09:15:00 | Scale Up  | 3    | 5  | Lag exceeded 5,000 for 2min | 8,200           |
      | 2024-12-29 08:00:00 | Scale Down| 5    | 3  | Lag below 500 for 5min      | 250             |
      | 2024-12-28 22:00:00 | Scale Down| 8    | 5  | Lag below 500 for 5min      | 180             |
    And I should see scaling effectiveness metrics:
      | metric                    | value    |
      | Avg time to scale up      | 2.5 min  |
      | Avg lag reduction after up| 75%      |
      | Scale events (24h)        | 8        |
      | Failed scale attempts     | 0        |
    And I should see cost impact:
      | period   | consumer_hours | estimated_cost |
      | Today    | 85             | $12.75         |
      | This week| 450            | $67.50         |

  Scenario: Manual scaling override with auto-scaling pause
    Given auto-scaling is configured for "order-processor"
    And current consumer count is 5
    When I manually set consumer count to 10
    Then consumer count should adjust to 10
    And auto-scaling should pause:
      | pause_duration | 30 minutes          |
      | resume_at      | automatic           |
    And I should see manual override indicator
    And override should be logged:
      | field          | value                    |
      | action         | manual_scale             |
      | previous_count | 5                        |
      | new_count      | 10                       |
      | user           | current_user_id          |
      | reason         | (optional user comment)  |

  # ============================================
  # MESSAGE ROUTING
  # ============================================

  Scenario: Configure message routing rules
    When I create routing rules for namespace "production":
      | rule_id | condition                    | destination           | priority |
      | R1      | header.priority = 'critical' | queue.priority-high   | 1        |
      | R2      | header.priority = 'high'     | queue.priority-medium | 2        |
      | R3      | header.region = 'EU'         | queue.eu-processing   | 3        |
      | R4      | header.region = 'APAC'       | queue.apac-processing | 3        |
      | R5      | body.amount > 10000          | queue.high-value      | 4        |
      | DEFAULT | true                         | queue.standard        | 100      |
    Then routing rules should be applied in priority order
    And messages should route according to rules:
      | message_example          | matched_rule | destination           |
      | priority=critical        | R1           | queue.priority-high   |
      | priority=high, region=EU | R2           | queue.priority-medium |
      | region=EU                | R3           | queue.eu-processing   |
      | amount=15000             | R5           | queue.high-value      |
      | amount=500               | DEFAULT      | queue.standard        |
    And routing metrics should be tracked

  Scenario: Configure topic fanout with filters
    When I configure fanout for topic "events.orders":
      | subscriber         | subscription_type | filter_expression        | description              |
      | analytics-pipeline | shared            | true                     | All messages             |
      | notification-svc   | exclusive         | status IN ('completed', 'shipped') | Completion events |
      | fraud-detection    | shared            | amount > 10000           | High-value orders        |
      | inventory-service  | failover          | action = 'reserve'       | Inventory reservations   |
    Then fanout configuration should be applied
    And messages should be delivered per filter:
      | message_content              | delivered_to                           |
      | status=pending, amount=500   | analytics-pipeline                     |
      | status=completed, amount=200 | analytics-pipeline, notification-svc   |
      | status=pending, amount=15000 | analytics-pipeline, fraud-detection    |
      | action=reserve, amount=100   | analytics-pipeline, inventory-service  |
    And delivery metrics should be tracked per subscriber

  # ============================================
  # QUEUE SECURITY
  # ============================================

  Scenario: Configure comprehensive queue security
    When I configure security for namespace "production":
      | security_setting         | value                    |
      | authentication_method    | JWT                      |
      | jwt_issuer               | auth.fflplayoffs.com     |
      | jwt_audience             | pulsar.fflplayoffs.com   |
      | authorization_model      | RBAC                     |
      | encryption_at_rest       | AES-256                  |
      | encryption_in_transit    | TLS 1.3                  |
      | certificate_validation   | strict                   |
      | ip_allowlist             | enabled                  |
    Then security should be applied:
      | check                    | status    |
      | JWT validation           | enabled   |
      | Role-based access        | enabled   |
      | TLS enforcement          | enabled   |
      | IP filtering             | enabled   |
    And unauthorized access should be blocked:
      | scenario                 | result    |
      | Invalid JWT              | Rejected  |
      | Expired JWT              | Rejected  |
      | Missing permissions      | Rejected  |
      | Non-allowlisted IP       | Rejected  |
    And security events should be audited

  Scenario: Manage granular queue access control
    When I configure access for service "order-processor":
      | topic                | namespace  | permission | description            |
      | events.orders        | production | consume    | Process incoming orders|
      | events.order-updates | production | produce    | Publish order updates  |
      | events.inventory     | production | produce    | Reserve inventory      |
      | events.notifications | production | produce    | Trigger notifications  |
    Then permissions should be applied:
      | operation                      | result    |
      | Consume from events.orders     | Allowed   |
      | Produce to events.order-updates| Allowed   |
      | Consume from events.payments   | Denied    |
      | Produce to events.orders       | Denied    |
    And access should be audited:
      | audit_field      | captured  |
      | Service identity | yes       |
      | Topic accessed   | yes       |
      | Operation type   | yes       |
      | Timestamp        | yes       |
      | Result           | yes       |

  # ============================================
  # PERFORMANCE OPTIMIZATION
  # ============================================

  Scenario: Run queue performance analysis
    When I run performance analysis for namespace "production"
    Then I should see optimization recommendations:
      | area               | current        | recommended    | impact           |
      | batch_size         | 100 messages   | 500 messages   | +40% throughput  |
      | prefetch_count     | 1,000          | 2,000          | +15% throughput  |
      | partition_count    | 6              | 12             | Better parallelism|
      | consumer_count     | 5              | 8              | +60% throughput  |
      | compression        | none           | lz4            | -30% bandwidth   |
    And I should see bottleneck analysis:
      | bottleneck         | location       | severity | fix_suggestion          |
      | Consumer processing| order-processor| high     | Scale consumers         |
      | Network latency    | eu-west region | medium   | Add regional cluster    |
      | Serialization      | avro schema    | low      | Consider simpler schema |
    And I should see estimated improvements:
      | if_implemented     | throughput_gain | latency_reduction |
      | All recommendations| +85%            | -45%              |
      | Top 3 only         | +60%            | -30%              |

  Scenario: Configure producer batching for throughput
    When I configure producer batching for topic "events.analytics":
      | setting              | value                    |
      | batch_enabled        | true                     |
      | max_batch_size       | 1,000 messages           |
      | max_batch_bytes      | 1 MB                     |
      | linger_ms            | 100                      |
      | compression_type     | lz4                      |
      | compression_level    | 6                        |
    Then batching should be enabled
    And I should see performance improvement:
      | metric               | before    | after     | improvement |
      | Messages/sec         | 50,000    | 85,000    | +70%        |
      | Latency (p99)        | 25ms      | 35ms      | -40%        |
      | Network bandwidth    | 120 MB/s  | 84 MB/s   | -30%        |
    And trade-off should be displayed:
      | trade_off            | impact                   |
      | Increased latency    | +10ms average            |
      | Message ordering     | Per-partition only       |

  # ============================================
  # BACKUP AND RECOVERY
  # ============================================

  Scenario: Configure automated queue backup
    When I configure backup for namespace "critical":
      | setting              | value                    |
      | backup_frequency     | hourly                   |
      | retention_period     | 30 days                  |
      | destination          | s3://ffl-backups/pulsar  |
      | encryption           | AES-256                  |
      | encryption_key       | AWS KMS                  |
      | include_schemas      | true                     |
      | include_subscriptions| true                     |
      | consistency_level    | topic                    |
    Then backup schedule should be created
    And backup job should run hourly
    And a BackupConfigured domain event should be published
    And I should see backup history:
      | backup_id    | timestamp           | size   | duration | status    |
      | BKP-2024-001 | 2024-12-29 09:00:00 | 15 GB  | 3 min    | Completed |
      | BKP-2024-002 | 2024-12-29 08:00:00 | 14 GB  | 3 min    | Completed |

  Scenario: Restore topic from backup with validation
    Given a backup exists for topic "events.orders" from 2024-12-28
    When I initiate restore for topic "events.orders":
      | setting              | value                    |
      | backup_id            | BKP-2024-098             |
      | restore_point        | 2024-12-28 23:00:00      |
      | target_topic         | events.orders.restored   |
      | include_subscriptions| no                       |
    Then restore process should start:
      | step                 | status      |
      | Validate backup      | completed   |
      | Pause consumers      | completed   |
      | Create target topic  | completed   |
      | Restore messages     | in_progress |
      | Verify integrity     | pending     |
      | Resume consumers     | pending     |
    And I should see restore progress:
      | metric               | value       |
      | Messages restored    | 1.2M / 2.5M |
      | Elapsed time         | 5 min       |
      | Estimated remaining  | 5 min       |
    And data integrity should be validated after restore
    And a TopicRestored event should be published

  # ============================================
  # GEO-REPLICATION
  # ============================================

  Scenario: Configure geo-replication for global topic
    When I configure geo-replication for topic "events.global":
      | setting              | value                    |
      | primary_cluster      | us-east                  |
      | replica_clusters     | eu-west, ap-south        |
      | replication_mode     | async                    |
      | max_replication_lag  | 5 seconds                |
      | conflict_resolution  | last-write-wins          |
    Then replication should be established:
      | replica    | status    | initial_sync | lag      |
      | eu-west    | Syncing   | 45%          | N/A      |
      | ap-south   | Syncing   | 32%          | N/A      |
    And after initial sync:
      | replica    | status    | lag      |
      | eu-west    | Active    | 1.2 sec  |
      | ap-south   | Active    | 2.5 sec  |
    And replication lag should be monitored continuously

  Scenario: Handle geo-replication failover
    Given topic "events.global" is replicated to eu-west and ap-south
    And primary cluster us-east becomes unavailable
    When failover is triggered (automatic or manual)
    Then eu-west should be promoted to primary:
      | step                 | status      |
      | Detect failure       | completed   |
      | Elect new primary    | completed   |
      | Update routing       | completed   |
      | Notify consumers     | completed   |
    And consumers should reconnect to eu-west
    And producers should redirect to eu-west
    And ap-south should replicate from eu-west
    And no messages should be lost (within RPO)
    And a ReplicationFailover event should be published

  # ============================================
  # COST MONITORING
  # ============================================

  Scenario: View queue cost dashboard
    When I view queue cost dashboard
    Then I should see costs by dimension:
      | dimension    | cost_mtd  | projected_month | trend   |
      | production   | $2,500    | $3,800          | +15%    |
      | staging      | $450      | $680            | stable  |
      | development  | $200      | $300            | stable  |
      | analytics    | $800      | $1,200          | +20%    |
    And I should see cost breakdown by category:
      | category     | cost_mtd  | percentage |
      | Storage      | $1,800    | 45%        |
      | Throughput   | $1,400    | 35%        |
      | Compute      | $600      | 15%        |
      | Network      | $200      | 5%         |
    And I should see top cost drivers:
      | topic                  | cost_mtd | driver              |
      | events.analytics       | $800     | High storage        |
      | events.orders          | $450     | High throughput     |
      | events.user-actions    | $350     | High storage        |

  Scenario: Configure cost alerts and budgets
    When I configure cost management:
      | setting              | value                    |
      | monthly_budget       | $5,000                   |
      | alert_at_50          | email_ops                |
      | alert_at_75          | email_ops, slack         |
      | alert_at_90          | email_all, page_oncall   |
      | auto_throttle_at_100 | enabled                  |
    Then budget tracking should be active
    And I should receive alerts at configured thresholds
    And I should see cost optimization suggestions:
      | suggestion                      | potential_savings |
      | Enable compression              | $200/month        |
      | Reduce retention on dev topics  | $150/month        |
      | Archive cold data to S3         | $300/month        |

  # ============================================
  # MAINTENANCE
  # ============================================

  Scenario: Schedule queue maintenance window
    When I schedule maintenance for "production" namespace:
      | setting              | value                    |
      | start_time           | 2025-01-05 02:00 UTC     |
      | duration             | 2 hours                  |
      | maintenance_type     | Broker upgrade           |
      | drain_timeout        | 30 minutes               |
      | notification_lead    | 7 days                   |
    Then maintenance window should be scheduled
    And notifications should be sent to stakeholders
    And at maintenance start:
      | step                 | action                   |
      | Drain consumers      | Graceful disconnect      |
      | Pause producers      | Return backpressure      |
      | Perform maintenance  | Execute upgrade          |
      | Resume producers     | Accept messages          |
      | Resume consumers     | Reconnect                |
    And maintenance should complete safely without data loss

  Scenario: Trigger topic compaction
    When I trigger compaction for topic "events.state":
      | setting              | value                    |
      | compaction_type      | Key-based                |
      | preserve_latest      | true                     |
      | target_segment_size  | 100 MB                   |
    Then compaction should start
    And I should see progress:
      | metric               | value       |
      | Segments to compact  | 45          |
      | Segments compacted   | 23          |
      | Keys processed       | 1.2M        |
      | Duplicates removed   | 850K        |
      | Space reclaimed      | 2.5 GB      |
    And compaction should complete without affecting reads

  # ============================================
  # INTEGRATION TESTING
  # ============================================

  Scenario: Run queue integration test
    When I run integration test for pipeline "order-pipeline":
      | test_config          | value                    |
      | test_message_count   | 100                      |
      | validate_ordering    | true                     |
      | validate_delivery    | exactly-once             |
      | timeout              | 5 minutes                |
      | cleanup_after        | true                     |
    Then test messages should flow through pipeline:
      | stage                | status    | messages_processed |
      | Producer             | completed | 100                |
      | Topic ingestion      | completed | 100                |
      | Consumer processing  | completed | 100                |
      | Output validation    | completed | 100                |
    And test report should be generated:
      | metric               | result    |
      | Messages sent        | 100       |
      | Messages received    | 100       |
      | Ordering preserved   | yes       |
      | Duplicates           | 0         |
      | Test duration        | 45 sec    |
    And test data should be cleaned up

  Scenario: Validate schema compatibility before deployment
    Given topic "events.orders" has schema version 5
    When I deploy new schema version 6 with changes:
      | change_type    | field           | description           |
      | Add field      | shipping_method | New optional field    |
      | Deprecate field| legacy_id       | Marked for removal    |
    Then compatibility check should run:
      | check                | result  | details                    |
      | Backward compatible  | passed  | Old consumers can read new |
      | Forward compatible   | passed  | New consumers can read old |
      | Full compatible      | passed  | Both directions work       |
    And schema should be registered
    And consumers should continue working
    When I try to deploy breaking change (remove required field)
    Then compatibility check should fail
    And deployment should be blocked
    And error should explain the breaking change

  # ============================================
  # DOMAIN EVENTS
  # ============================================

  Scenario: QueueHealthDegraded event triggers automated response
    When consumer lag exceeds 100,000 messages for topic "events.orders"
    Then QueueHealthDegraded event should be published:
      | field              | value                    |
      | topic              | events.orders            |
      | metric             | consumer_lag             |
      | current_value      | 150,000                  |
      | threshold          | 100,000                  |
      | severity           | warning                  |
    And automated responses should trigger:
      | response           | action                           |
      | Alert on-call      | PagerDuty notification sent      |
      | Scale consumers    | Initiated (if auto-scale on)    |
      | Create incident    | INCIDENT-2024-1234 created       |
    And if issue persists for 15 minutes:
      | escalation         | action                   |
      | Escalate alert     | Page secondary on-call   |
      | Increase severity  | warning -> critical      |

  # ============================================
  # ERROR SCENARIOS
  # ============================================

  Scenario: Handle broker unavailability with producer buffering
    Given Pulsar broker "broker-2" becomes temporarily unavailable
    And producer is connected to broker-2
    When producer attempts to publish messages
    Then messages should be buffered locally:
      | buffer_setting     | value                    |
      | max_buffer_size    | 10,000 messages          |
      | buffer_timeout     | 30 seconds               |
    And retry should occur with exponential backoff:
      | attempt | delay    |
      | 1       | 100ms    |
      | 2       | 200ms    |
      | 3       | 400ms    |
      | 4       | 800ms    |
    And when broker recovers:
      | action             | result                   |
      | Reconnect          | Automatic                |
      | Flush buffer       | All messages sent        |
      | Resume normal ops  | Immediate                |
    And no messages should be lost

  Scenario: Handle consumer crash with message redelivery
    Given consumer "order-processor-3" is processing message batch
    And consumer has 50 unacknowledged messages
    When consumer crashes unexpectedly
    Then crash should be detected within ack timeout
    And unacknowledged messages should be marked for redelivery
    And consumer group should rebalance:
      | consumer           | old_partitions | new_partitions |
      | order-processor-1  | 0, 1           | 0, 1, 4        |
      | order-processor-2  | 2, 3           | 2, 3, 5        |
      | (crashed)          | 4, 5           | N/A            |
    And redelivered messages should be processed by remaining consumers
    And processing should continue without message loss
    And a ConsumerCrashDetected event should be published
