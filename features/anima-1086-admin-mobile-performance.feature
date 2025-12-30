@admin @mobile-performance @ANIMA-1086
Feature: Admin Mobile Performance
  As a platform administrator
  I want to monitor and optimize mobile application performance
  So that I can ensure fast, responsive, and efficient mobile experiences

  Background:
    Given I am logged in as a platform administrator
    And I have mobile performance management permissions
    And the mobile performance monitoring system is active

  # =============================================================================
  # MOBILE PERFORMANCE DASHBOARD
  # =============================================================================

  @dashboard @overview
  Scenario: View mobile performance overview
    When I navigate to the mobile performance dashboard
    Then I should see overall performance metrics:
      | metric                | value    | status  |
      | avg_launch_time       | 1.8s     | good    |
      | avg_response_time     | 245ms    | good    |
      | crash_free_rate       | 99.2%    | warning |
      | frame_rate            | 58 fps   | good    |
      | memory_usage          | 145 MB   | good    |
    And I should see performance trends over time
    And I should see platform breakdown (iOS vs Android)

  @dashboard @real-time
  Scenario: View real-time performance metrics
    Given I am on the mobile performance dashboard
    When I enable real-time monitoring mode
    Then I should see live performance updates
    And metrics should refresh every 5 seconds
    And I should see active user session count: 12,450
    And I should see current error rate
    And I should see geographic performance distribution

  @dashboard @comparison
  Scenario: Compare performance across app versions
    Given I am on the mobile performance dashboard
    When I compare versions:
      | version | release_date |
      | 3.2.1   | 2024-06-01   |
      | 3.2.0   | 2024-05-15   |
      | 3.1.5   | 2024-05-01   |
    Then I should see performance comparison:
      | metric        | v3.2.1 | v3.2.0 | v3.1.5 |
      | launch_time   | 1.8s   | 2.1s   | 2.3s   |
      | crash_rate    | 0.8%   | 1.2%   | 1.5%   |
      | memory_usage  | 145 MB | 155 MB | 160 MB |
    And I should see improvement trends highlighted

  @dashboard @filtering
  Scenario: Filter performance data by platform
    Given I am on the mobile performance dashboard
    When I filter by platform "iOS"
    Then I should see iOS-specific metrics
    And I should see device breakdown by iPhone model
    And I should see iOS version distribution
    And Android data should be excluded

  @dashboard @alerts
  Scenario: View performance alerts on dashboard
    Given there are active performance issues
    When I view the alerts section
    Then I should see active alerts:
      | severity | issue                        | affected_users |
      | critical | High crash rate on Android 14| 2,340          |
      | warning  | Slow launch on iPhone 12     | 1,120          |
      | info     | Memory spike detected        | 450            |
    And I should be able to acknowledge alerts

  # =============================================================================
  # APP LAUNCH PERFORMANCE
  # =============================================================================

  @launch @monitoring
  Scenario: Monitor app launch performance
    When I navigate to app launch performance section
    Then I should see launch time metrics:
      | metric              | value  |
      | cold_start_avg      | 2.1s   |
      | warm_start_avg      | 0.8s   |
      | hot_start_avg       | 0.3s   |
      | time_to_interactive | 2.8s   |
    And I should see launch time distribution
    And I should see percentile breakdown (p50, p90, p99)

  @launch @breakdown
  Scenario: View launch time breakdown
    When I analyze launch time breakdown
    Then I should see phase-by-phase timing:
      | phase                  | duration | percentage |
      | process_initialization | 450ms    | 21%        |
      | framework_loading      | 380ms    | 18%        |
      | dependency_injection   | 290ms    | 14%        |
      | initial_data_fetch     | 520ms    | 25%        |
      | ui_rendering           | 460ms    | 22%        |
    And I should see optimization opportunities highlighted

  @launch @optimization
  Scenario: Configure launch optimization settings
    When I configure launch optimizations:
      | optimization           | enabled | priority |
      | lazy_loading           | true    | high     |
      | prefetch_critical_data | true    | high     |
      | defer_analytics_init   | true    | medium   |
      | cache_ui_components    | true    | medium   |
      | compress_assets        | true    | low      |
    Then optimizations should be applied
    And I should see projected improvement estimates

  @launch @cold-start
  Scenario: Analyze cold start performance
    When I analyze cold start performance
    Then I should see cold start details:
      | device_tier | avg_cold_start | target  | status  |
      | high_end    | 1.5s           | 2.0s    | passing |
      | mid_range   | 2.4s           | 3.0s    | passing |
      | low_end     | 4.2s           | 4.0s    | failing |
    And I should see recommendations for low-end devices

  @launch @startup-trace
  Scenario: View startup trace analysis
    Given I want to debug slow launch times
    When I view startup trace for a sample session
    Then I should see detailed trace:
      | trace_event              | start_time | duration | blocking |
      | main_thread_init         | 0ms        | 150ms    | yes      |
      | load_shared_preferences  | 150ms      | 80ms     | yes      |
      | database_migration       | 230ms      | 200ms    | yes      |
      | network_init             | 430ms      | 50ms     | no       |
      | render_splash_screen     | 480ms      | 100ms    | yes      |
    And I should see main thread blocking issues highlighted

  # =============================================================================
  # MEMORY PERFORMANCE
  # =============================================================================

  @memory @monitoring
  Scenario: Monitor mobile memory performance
    When I navigate to memory performance section
    Then I should see memory metrics:
      | metric              | ios_value | android_value |
      | avg_memory_usage    | 145 MB    | 168 MB        |
      | peak_memory_usage   | 280 MB    | 320 MB        |
      | memory_warnings     | 12/day    | 25/day        |
      | oom_crashes         | 0.2%      | 0.5%          |
    And I should see memory usage trends over time

  @memory @allocation
  Scenario: View memory allocation breakdown
    When I analyze memory allocation
    Then I should see allocation by category:
      | category        | allocation | percentage |
      | images          | 65 MB      | 45%        |
      | data_cache      | 35 MB      | 24%        |
      | view_hierarchy  | 22 MB      | 15%        |
      | network_buffers | 12 MB      | 8%         |
      | other           | 11 MB      | 8%         |
    And I should see high memory consumers identified

  @memory @leaks
  Scenario: Detect memory leaks
    Given memory monitoring is active
    When I run memory leak detection
    Then I should see leak analysis:
      | leak_type           | occurrences | severity | location              |
      | retained_views      | 45          | high     | PlayerDetailFragment  |
      | unclosed_cursors    | 12          | medium   | RosterRepository      |
      | listener_leaks      | 8           | medium   | ScoreUpdateService    |
    And I should see stack traces for each leak
    And I should see remediation suggestions

  @memory @optimization
  Scenario: Configure memory optimization
    When I configure memory optimizations:
      | optimization           | setting      |
      | image_cache_size       | 50 MB        |
      | aggressive_gc          | disabled     |
      | bitmap_pooling         | enabled      |
      | view_recycling         | enabled      |
      | max_retained_fragments | 3            |
    Then memory optimizations should be applied
    And I should see expected memory reduction

  @memory @pressure
  Scenario: Monitor memory pressure events
    When I view memory pressure events
    Then I should see pressure history:
      | timestamp           | level    | action_taken        | outcome       |
      | 2024-06-15 14:30:00 | warning  | cleared_image_cache | memory_freed  |
      | 2024-06-15 14:25:00 | critical | evicted_activities  | app_survived  |
      | 2024-06-15 13:00:00 | warning  | reduced_cache       | memory_freed  |
    And I should see memory pressure frequency trends

  @memory @heap
  Scenario: Analyze heap usage
    When I analyze heap usage patterns
    Then I should see heap statistics:
      | metric              | value   |
      | heap_size           | 256 MB  |
      | heap_allocated      | 180 MB  |
      | heap_free           | 76 MB   |
      | gc_frequency        | 2.3/min |
      | gc_pause_time_avg   | 8ms     |
    And I should see object allocation hotspots
    And I should see GC impact analysis

  # =============================================================================
  # NETWORK PERFORMANCE
  # =============================================================================

  @network @monitoring
  Scenario: Monitor network performance
    When I navigate to network performance section
    Then I should see network metrics:
      | metric               | value    |
      | avg_request_time     | 245ms    |
      | avg_download_speed   | 8.5 Mbps |
      | request_success_rate | 98.5%    |
      | timeout_rate         | 0.8%     |
      | retry_rate           | 1.2%     |
    And I should see network performance by connection type

  @network @requests
  Scenario: Analyze API request performance
    When I analyze API request performance
    Then I should see request breakdown:
      | endpoint            | avg_time | p99_time | calls/min | errors |
      | /api/v1/scores      | 120ms    | 450ms    | 1,200     | 0.2%   |
      | /api/v1/players     | 180ms    | 650ms    | 800       | 0.5%   |
      | /api/v1/rosters     | 150ms    | 500ms    | 400       | 0.3%   |
      | /api/v1/live-updates| 80ms     | 200ms    | 2,500     | 0.1%   |
    And I should see slow endpoints highlighted

  @network @optimization
  Scenario: Configure network optimizations
    When I configure network optimizations:
      | optimization           | enabled | config              |
      | request_batching       | true    | batch_window: 100ms |
      | response_compression   | true    | gzip                |
      | connection_pooling     | true    | max_connections: 6  |
      | prefetch_data          | true    | on_wifi_only        |
      | offline_mode           | true    | cache_first         |
    Then optimizations should be applied
    And I should see network efficiency improvements

  @network @bandwidth
  Scenario: Analyze bandwidth usage
    When I analyze bandwidth consumption
    Then I should see bandwidth breakdown:
      | category        | data_volume | percentage |
      | api_responses   | 45 MB/day   | 35%        |
      | images          | 55 MB/day   | 43%        |
      | video           | 15 MB/day   | 12%        |
      | analytics       | 8 MB/day    | 6%         |
      | other           | 5 MB/day    | 4%         |
    And I should see bandwidth optimization opportunities

  @network @latency
  Scenario: View latency by geographic region
    When I analyze latency by region
    Then I should see regional performance:
      | region          | avg_latency | p99_latency | users  |
      | North America   | 180ms       | 450ms       | 45,000 |
      | Europe          | 220ms       | 550ms       | 12,000 |
      | Asia Pacific    | 350ms       | 800ms       | 8,000  |
      | South America   | 280ms       | 650ms       | 3,000  |
    And I should see CDN effectiveness analysis

  @network @connection-quality
  Scenario: Monitor connection quality impact
    When I analyze performance by connection quality
    Then I should see connection impact:
      | connection_type | users  | avg_load_time | failure_rate |
      | wifi            | 60%    | 1.2s          | 0.5%         |
      | 4g_lte          | 30%    | 2.1s          | 1.2%         |
      | 3g              | 8%     | 4.5s          | 3.5%         |
      | 2g              | 2%     | 12.0s         | 8.0%         |
    And I should see adaptive content recommendations

  # =============================================================================
  # CPU PERFORMANCE
  # =============================================================================

  @cpu @monitoring
  Scenario: Monitor CPU usage and performance
    When I navigate to CPU performance section
    Then I should see CPU metrics:
      | metric              | value    |
      | avg_cpu_usage       | 25%      |
      | peak_cpu_usage      | 85%      |
      | cpu_intensive_ops   | 45/hour  |
      | main_thread_usage   | 18%      |
      | background_usage    | 7%       |
    And I should see CPU usage over time

  @cpu @hotspots
  Scenario: Identify CPU hotspots
    When I analyze CPU hotspots
    Then I should see CPU-intensive operations:
      | operation              | avg_cpu | duration | frequency | impact   |
      | image_processing       | 65%     | 120ms    | 50/min    | high     |
      | json_parsing           | 45%     | 80ms     | 200/min   | medium   |
      | animation_rendering    | 55%     | 16ms     | 60/sec    | medium   |
      | database_queries       | 35%     | 45ms     | 100/min   | low      |
    And I should see optimization recommendations

  @cpu @thread-analysis
  Scenario: Analyze thread performance
    When I analyze thread usage
    Then I should see thread breakdown:
      | thread_type       | count | avg_cpu | blocking_time |
      | main_thread       | 1     | 18%     | 5%            |
      | render_thread     | 1     | 12%     | 2%            |
      | io_threads        | 4     | 8%      | 15%           |
      | worker_threads    | 2     | 10%     | 3%            |
      | background_threads| 3     | 5%      | 8%            |
    And I should see thread contention issues

  @cpu @jank
  Scenario: Detect UI jank and dropped frames
    When I analyze frame rendering performance
    Then I should see frame metrics:
      | metric              | value    | target  |
      | avg_frame_time      | 14ms     | 16ms    |
      | dropped_frames      | 2.5%     | < 1%    |
      | janky_frames        | 1.8%     | < 0.5%  |
      | frozen_frames       | 0.3%     | < 0.1%  |
    And I should see jank occurrences by screen
    And I should see frame time distribution

  @cpu @background
  Scenario: Monitor background CPU usage
    When I analyze background CPU activity
    Then I should see background operations:
      | operation           | cpu_usage | frequency | battery_impact |
      | sync_service        | 5%        | every 15m | medium         |
      | push_processing     | 2%        | on_receive| low            |
      | location_updates    | 8%        | every 5m  | high           |
      | analytics_upload    | 3%        | every 30m | low            |
    And I should see recommendations for reducing background CPU

  # =============================================================================
  # BATTERY PERFORMANCE
  # =============================================================================

  @battery @monitoring
  Scenario: Monitor battery consumption
    When I navigate to battery performance section
    Then I should see battery metrics:
      | metric                  | value    |
      | avg_battery_drain       | 3.2%/hr  |
      | foreground_drain        | 2.8%/hr  |
      | background_drain        | 0.4%/hr  |
      | battery_complaints      | 45/week  |
      | low_battery_crashes     | 12/week  |
    And I should see battery drain trends

  @battery @breakdown
  Scenario: View battery usage breakdown
    When I analyze battery consumption breakdown
    Then I should see consumption by category:
      | category        | percentage | trend   |
      | cpu             | 35%        | stable  |
      | display         | 28%        | stable  |
      | network         | 22%        | +5%     |
      | gps             | 10%        | -2%     |
      | other           | 5%         | stable  |
    And I should see feature-level battery impact

  @battery @optimization
  Scenario: Configure battery optimizations
    When I configure battery optimizations:
      | optimization             | setting          |
      | background_refresh       | reduced          |
      | location_accuracy        | balanced         |
      | sync_frequency           | adaptive         |
      | animation_quality        | auto             |
      | dark_mode_preference     | system_default   |
    Then optimizations should be applied
    And I should see estimated battery savings

  @battery @sessions
  Scenario: Analyze battery drain by session type
    When I analyze battery by session type
    Then I should see session impact:
      | session_type    | avg_duration | battery_drain | users  |
      | active_game     | 45 min       | 8%            | 35%    |
      | roster_editing  | 15 min       | 2%            | 25%    |
      | browsing_stats  | 20 min       | 3%            | 30%    |
      | background_sync | continuous   | 0.4%/hr       | 100%   |
    And I should see optimization opportunities by session

  @battery @thermal
  Scenario: Monitor thermal throttling
    When I monitor device thermal state
    Then I should see thermal metrics:
      | metric                  | value    |
      | thermal_throttle_events | 45/day   |
      | avg_throttle_duration   | 2.5 min  |
      | performance_reduction   | 25%      |
      | affected_devices        | 5%       |
    And I should see devices most affected by throttling
    And I should see thermal mitigation recommendations

  # =============================================================================
  # STORAGE PERFORMANCE
  # =============================================================================

  @storage @monitoring
  Scenario: Manage mobile storage performance
    When I navigate to storage performance section
    Then I should see storage metrics:
      | metric              | ios_value | android_value |
      | app_size            | 85 MB     | 92 MB         |
      | cache_size          | 120 MB    | 145 MB        |
      | user_data           | 45 MB     | 52 MB         |
      | total_footprint     | 250 MB    | 289 MB        |
    And I should see storage growth trends

  @storage @breakdown
  Scenario: View storage breakdown
    When I analyze storage usage breakdown
    Then I should see storage by category:
      | category          | size    | percentage |
      | app_binary        | 85 MB   | 34%        |
      | images_cache      | 65 MB   | 26%        |
      | database          | 35 MB   | 14%        |
      | offline_content   | 40 MB   | 16%        |
      | logs_analytics    | 15 MB   | 6%         |
      | other             | 10 MB   | 4%         |
    And I should see storage optimization opportunities

  @storage @io
  Scenario: Monitor storage I/O performance
    When I analyze storage I/O performance
    Then I should see I/O metrics:
      | metric              | value      |
      | read_operations     | 1,200/min  |
      | write_operations    | 350/min    |
      | avg_read_time       | 5ms        |
      | avg_write_time      | 12ms       |
      | io_wait_time        | 2%         |
    And I should see I/O patterns over time

  @storage @optimization
  Scenario: Configure storage optimizations
    When I configure storage optimizations:
      | optimization           | setting     |
      | cache_max_size         | 100 MB      |
      | cache_eviction_policy  | lru         |
      | image_compression      | aggressive  |
      | auto_cleanup_threshold | 80%         |
      | offline_content_limit  | 50 MB       |
    Then optimizations should be applied
    And I should see storage savings estimate

  @storage @database
  Scenario: Analyze database performance
    When I analyze database performance
    Then I should see database metrics:
      | metric              | value    |
      | db_size             | 35 MB    |
      | query_count         | 500/min  |
      | avg_query_time      | 8ms      |
      | slow_queries        | 2%       |
      | index_usage         | 85%      |
    And I should see slow query details
    And I should see index optimization suggestions

  # =============================================================================
  # REAL-TIME PERFORMANCE METRICS
  # =============================================================================

  @real-time @monitoring
  Scenario: Monitor real-time performance metrics
    When I enable real-time performance monitoring
    Then I should see live metrics dashboard:
      | metric            | current  | avg_1hr  | trend   |
      | active_sessions   | 12,450   | 11,800   | +5.5%   |
      | requests_per_sec  | 2,340    | 2,100    | +11%    |
      | error_rate        | 0.3%     | 0.4%     | -25%    |
      | avg_latency       | 180ms    | 195ms    | -8%     |
    And metrics should update every 5 seconds

  @real-time @sessions
  Scenario: View real-time session analytics
    When I view real-time session data
    Then I should see session metrics:
      | metric              | value    |
      | active_sessions     | 12,450   |
      | new_sessions_1hr    | 2,340    |
      | avg_session_length  | 8.5 min  |
      | bounce_rate         | 15%      |
    And I should see session distribution by platform
    And I should see geographic session map

  @real-time @errors
  Scenario: Monitor real-time errors
    When I view real-time error stream
    Then I should see current error data:
      | error_type          | count_1hr | trend   | severity |
      | network_timeout     | 45        | stable  | medium   |
      | api_error_500       | 12        | -20%    | high     |
      | parse_exception     | 8         | +15%    | medium   |
      | null_pointer        | 3         | stable  | high     |
    And I should see error details on click
    And I should see affected user count

  @real-time @alerts
  Scenario: Configure real-time performance alerts
    When I configure real-time alerts:
      | metric            | threshold | window  | severity |
      | error_rate        | > 1%      | 5 min   | critical |
      | avg_latency       | > 500ms   | 5 min   | warning  |
      | crash_rate        | > 0.5%    | 1 hr    | critical |
      | cpu_usage         | > 80%     | 10 min  | warning  |
    Then alerts should be configured
    And I should receive notifications when thresholds are breached

  @real-time @anomaly
  Scenario: Detect real-time anomalies
    Given normal performance patterns are established
    When an anomaly is detected:
      | metric      | expected | actual | deviation |
      | error_rate  | 0.3%     | 2.5%   | +733%     |
    Then an anomaly alert should be triggered
    And I should see correlation analysis
    And potential root causes should be suggested

  # =============================================================================
  # AUTOMATED PERFORMANCE TESTING
  # =============================================================================

  @testing @automation
  Scenario: Configure automated performance testing
    When I configure automated performance tests:
      | test_type           | frequency | devices              |
      | startup_time        | daily     | reference_devices    |
      | ui_responsiveness   | daily     | all_tiers            |
      | memory_stress       | weekly    | low_end_devices      |
      | battery_drain       | weekly    | reference_devices    |
    Then automated tests should be scheduled
    And I should see test schedule calendar

  @testing @execution
  Scenario: View automated test execution
    When I view test execution results
    Then I should see recent test runs:
      | test_name       | date       | status  | duration | findings |
      | startup_test    | 2024-06-15 | passed  | 45 min   | 0        |
      | memory_stress   | 2024-06-14 | failed  | 2 hr     | 3        |
      | ui_responsive   | 2024-06-15 | passed  | 1.5 hr   | 1        |
    And I should see detailed results for each test

  @testing @benchmarks
  Scenario: Run performance benchmarks
    When I initiate a benchmark suite
    Then benchmarks should execute:
      | benchmark           | result   | baseline | change  |
      | cold_start_time     | 2.1s     | 2.0s     | +5%     |
      | scroll_fps          | 58       | 60       | -3%     |
      | memory_footprint    | 150 MB   | 145 MB   | +3%     |
      | api_latency         | 180ms    | 175ms    | +3%     |
    And I should see pass/fail status against targets

  @testing @regression
  Scenario: Detect performance regressions in CI/CD
    Given a new build is submitted for testing
    When performance regression tests run
    Then I should see regression analysis:
      | metric          | previous | current | status    |
      | startup_time    | 2.0s     | 2.5s    | regressed |
      | memory_usage    | 145 MB   | 148 MB  | acceptable|
      | frame_rate      | 60 fps   | 58 fps  | acceptable|
    And regressions should block release if critical
    And I should see regression root cause analysis

  @testing @devices
  Scenario: Manage test device farm
    When I view the test device farm
    Then I should see available devices:
      | device           | os_version | status     | last_used   |
      | iPhone 15 Pro    | iOS 17.2   | available  | 1 hour ago  |
      | Pixel 8          | Android 14 | in_use     | now         |
      | Samsung S24      | Android 14 | available  | 3 hours ago |
      | iPhone 12        | iOS 16.5   | maintenance| yesterday   |
    And I should be able to allocate devices for testing

  # =============================================================================
  # DEVICE CATEGORY OPTIMIZATION
  # =============================================================================

  @devices @categories
  Scenario: View performance by device category
    When I view device category performance
    Then I should see performance by tier:
      | device_tier | users  | avg_launch | avg_memory | satisfaction |
      | high_end    | 35%    | 1.5s       | 160 MB     | 4.8/5        |
      | mid_range   | 45%    | 2.2s       | 145 MB     | 4.5/5        |
      | low_end     | 20%    | 3.8s       | 120 MB     | 3.9/5        |
    And I should see specific device performance

  @devices @optimization
  Scenario: Configure device-specific optimizations
    When I configure optimizations for low-end devices:
      | optimization           | setting          |
      | image_quality          | reduced          |
      | animation_complexity   | simplified       |
      | prefetch_limit         | 50%              |
      | cache_size             | 50 MB            |
      | background_sync        | disabled         |
    Then optimizations should target low-end devices
    And I should see expected performance improvements

  @devices @targeting
  Scenario: Configure performance targeting rules
    When I configure targeting rules:
      | condition              | optimization               |
      | ram < 3 GB             | enable_low_memory_mode     |
      | cpu_cores < 4          | reduce_parallel_processing |
      | storage_free < 1 GB    | aggressive_cache_cleanup   |
      | battery < 20%          | enable_battery_saver       |
    Then targeting rules should be active
    And optimizations should apply dynamically

  @devices @compatibility
  Scenario: Monitor device compatibility issues
    When I view device compatibility report
    Then I should see compatibility status:
      | device_model    | os_version | issues      | affected_users |
      | Pixel 3a        | Android 12 | ui_glitch   | 450            |
      | iPhone 8        | iOS 16.0   | memory_warn | 820            |
      | Samsung A32     | Android 11 | slow_launch | 1,200          |
    And I should see issue details and workarounds

  @devices @fragmentation
  Scenario: Analyze device fragmentation
    When I analyze device fragmentation
    Then I should see fragmentation metrics:
      | category        | unique_values | coverage_80% |
      | device_models   | 2,500         | top 50       |
      | os_versions     | 25            | top 5        |
      | screen_sizes    | 150           | top 10       |
      | cpu_types       | 45            | top 8        |
    And I should see testing coverage recommendations

  # =============================================================================
  # PERFORMANCE OPTIMIZATION TECHNIQUES
  # =============================================================================

  @optimization @lazy-loading
  Scenario: Configure lazy loading strategies
    When I configure lazy loading:
      | content_type    | strategy       | threshold    |
      | images          | viewport_based | 500px ahead  |
      | list_items      | pagination     | 20 items     |
      | heavy_views     | on_demand      | user_action  |
      | analytics       | deferred       | after_render |
    Then lazy loading should be configured
    And I should see load time improvements

  @optimization @caching
  Scenario: Configure caching strategies
    When I configure caching:
      | cache_type      | strategy    | ttl      | max_size |
      | api_responses   | stale_while | 5 min    | 50 MB    |
      | images          | disk_cache  | 7 days   | 100 MB   |
      | user_data       | memory_first| 1 hour   | 10 MB    |
      | static_assets   | permanent   | unlimited| 30 MB    |
    Then caching strategies should be applied
    And cache hit rates should be tracked

  @optimization @compression
  Scenario: Configure data compression
    When I configure compression:
      | data_type       | compression | level    |
      | api_responses   | gzip        | balanced |
      | images          | webp        | quality_80|
      | offline_data    | lz4         | fast     |
      | logs            | zstd        | high     |
    Then compression should be applied
    And I should see bandwidth reduction metrics

  @optimization @prefetching
  Scenario: Configure intelligent prefetching
    When I configure prefetching:
      | trigger              | prefetch_action           | conditions     |
      | app_launch           | critical_data             | always         |
      | tab_hover            | tab_content               | wifi_only      |
      | list_scroll          | next_page_data            | 80% scroll     |
      | user_idle            | predicted_next_screen     | ml_based       |
    Then prefetching should be configured
    And prefetch hit rate should be tracked

  @optimization @code-splitting
  Scenario: Analyze code splitting effectiveness
    When I analyze code splitting
    Then I should see bundle metrics:
      | bundle           | size   | load_timing | usage_rate |
      | core             | 2.5 MB | initial     | 100%       |
      | roster_module    | 800 KB | on_navigate | 65%        |
      | analytics_module | 400 KB | deferred    | 100%       |
      | admin_module     | 600 KB | on_demand   | 5%         |
    And I should see splitting optimization suggestions

  # =============================================================================
  # PERFORMANCE ANALYTICS REPORTS
  # =============================================================================

  @analytics @reports
  Scenario: Generate performance analytics reports
    When I generate a performance analytics report:
      | parameter     | value                |
      | date_range    | last 30 days         |
      | platforms     | iOS, Android         |
      | metrics       | all                  |
      | format        | PDF                  |
    Then the report should be generated
    And I should see executive summary
    And I should see detailed metrics by section

  @analytics @trends
  Scenario: View performance trends analysis
    When I analyze performance trends over 90 days
    Then I should see trend analysis:
      | metric          | 90d_ago | 60d_ago | 30d_ago | current | trend    |
      | launch_time     | 2.5s    | 2.3s    | 2.0s    | 1.8s    | improving|
      | crash_rate      | 1.5%    | 1.2%    | 1.0%    | 0.8%    | improving|
      | memory_usage    | 160 MB  | 155 MB  | 150 MB  | 145 MB  | improving|
    And I should see improvement attribution

  @analytics @comparison
  Scenario: Compare performance with industry benchmarks
    When I compare with industry benchmarks
    Then I should see benchmark comparison:
      | metric          | our_app | industry_avg | percentile |
      | cold_start      | 2.1s    | 2.8s         | top 25%    |
      | crash_rate      | 0.8%    | 1.2%         | top 30%    |
      | frame_rate      | 58 fps  | 55 fps       | top 20%    |
    And I should see competitive positioning

  @analytics @user-impact
  Scenario: Analyze performance impact on user behavior
    When I analyze performance impact on users
    Then I should see correlation analysis:
      | performance_factor | user_metric      | correlation |
      | launch_time        | session_length   | -0.65       |
      | crash_rate         | retention        | -0.82       |
      | response_time      | engagement       | -0.58       |
      | frame_rate         | satisfaction     | +0.71       |
    And I should see business impact estimates

  @analytics @segments
  Scenario: Segment performance by user cohorts
    When I segment performance by user type
    Then I should see segmented metrics:
      | user_segment    | launch_time | crashes | satisfaction |
      | new_users       | 2.3s        | 1.2%    | 4.2/5        |
      | returning_users | 1.8s        | 0.6%    | 4.6/5        |
      | power_users     | 1.5s        | 0.4%    | 4.8/5        |
    And I should see segment-specific recommendations

  # =============================================================================
  # PERFORMANCE BUDGETS
  # =============================================================================

  @budgets @configuration
  Scenario: Configure mobile performance budgets
    When I configure performance budgets:
      | metric          | budget   | warning_at | critical_at |
      | cold_start      | 2.5s     | 2.0s       | 3.0s        |
      | memory_usage    | 150 MB   | 130 MB     | 180 MB      |
      | app_size        | 100 MB   | 90 MB      | 120 MB      |
      | crash_rate      | 1%       | 0.8%       | 1.5%        |
    Then performance budgets should be set
    And monitoring should track budget status

  @budgets @monitoring
  Scenario: Monitor performance budget status
    When I view performance budget dashboard
    Then I should see budget status:
      | metric          | current  | budget   | status   | headroom |
      | cold_start      | 2.1s     | 2.5s     | healthy  | 16%      |
      | memory_usage    | 145 MB   | 150 MB   | warning  | 3%       |
      | app_size        | 92 MB    | 100 MB   | healthy  | 8%       |
      | crash_rate      | 0.8%     | 1%       | healthy  | 20%      |
    And I should see budget trend over time

  @budgets @alerts
  Scenario: Receive budget violation alerts
    Given performance budgets are configured
    When a budget threshold is breached:
      | metric       | budget  | current | severity |
      | memory_usage | 150 MB  | 165 MB  | critical |
    Then an alert should be triggered
    And responsible team should be notified
    And I should see budget violation in dashboard

  @budgets @enforcement
  Scenario: Enforce budgets in CI/CD pipeline
    Given performance budgets are linked to CI/CD
    When a build exceeds budget:
      | metric     | budget | actual | overage |
      | app_size   | 100 MB | 115 MB | 15%     |
    Then the build should be flagged
    And I should see which changes caused the increase
    And options for proceeding should be presented

  @budgets @allocation
  Scenario: Allocate performance budget to features
    When I allocate budget to features:
      | feature          | size_budget | memory_budget | launch_impact |
      | core_app         | 40 MB       | 80 MB         | 1.0s          |
      | roster_manager   | 15 MB       | 25 MB         | 0.3s          |
      | live_scoring     | 20 MB       | 30 MB         | 0.5s          |
      | analytics        | 10 MB       | 15 MB         | 0.2s          |
    Then feature budgets should be tracked
    And teams should be accountable for their budgets

  # =============================================================================
  # REGRESSION DETECTION AND PREVENTION
  # =============================================================================

  @regression @detection
  Scenario: Detect performance regressions automatically
    Given baseline performance metrics are established
    When a new release shows degradation:
      | metric       | baseline | current | regression |
      | launch_time  | 2.0s     | 2.8s    | +40%       |
    Then regression should be detected automatically
    And alert should be sent to development team
    And I should see regression analysis in dashboard

  @regression @root-cause
  Scenario: Analyze regression root cause
    Given a performance regression is detected
    When I analyze the regression
    Then I should see root cause analysis:
      | factor                    | impact | confidence |
      | new_analytics_sdk         | +0.5s  | 95%        |
      | increased_image_sizes     | +0.2s  | 80%        |
      | additional_network_calls  | +0.1s  | 70%        |
    And I should see specific commits associated
    And I should see recommended fixes

  @regression @prevention
  Scenario: Configure regression prevention rules
    When I configure regression prevention:
      | rule                     | threshold | action           |
      | launch_time_increase     | > 10%     | block_release    |
      | memory_increase          | > 15%     | require_approval |
      | crash_rate_increase      | > 0.5%    | block_release    |
      | app_size_increase        | > 5 MB    | warn             |
    Then prevention rules should be active
    And CI/CD should enforce these rules

  @regression @baseline
  Scenario: Manage performance baselines
    When I view performance baselines
    Then I should see baseline history:
      | version | baseline_date | launch_time | memory | crashes |
      | 3.2.0   | 2024-06-01    | 2.0s        | 145 MB | 0.8%    |
      | 3.1.0   | 2024-05-01    | 2.2s        | 150 MB | 1.0%    |
      | 3.0.0   | 2024-04-01    | 2.5s        | 160 MB | 1.2%    |
    And I should be able to update baselines
    And I should be able to compare against any baseline

  @regression @tracking
  Scenario: Track regression fixes
    Given regressions have been identified
    When I view regression tracking
    Then I should see regression status:
      | regression_id | issue              | status      | assignee    | eta       |
      | REG-001       | slow_launch        | in_progress | dev_team_a  | 2024-06-18|
      | REG-002       | memory_leak        | fixed       | dev_team_b  | resolved  |
      | REG-003       | frame_drops        | investigating| dev_team_a | TBD       |
    And I should see fix verification status

  # =============================================================================
  # ERROR HANDLING AND EDGE CASES
  # =============================================================================

  @error-handling @monitoring-failure
  Scenario: Handle performance monitoring failure
    Given performance monitoring agents are deployed
    When a monitoring agent fails to report
    Then I should see agent status alert
    And affected devices should be identified
    And fallback monitoring should activate
    And I should see gap in metrics acknowledged

  @error-handling @data-inconsistency
  Scenario: Handle inconsistent performance data
    Given performance data is being aggregated
    When data inconsistency is detected:
      | source      | metric      | value  |
      | agent_1     | launch_time | 2.0s   |
      | agent_2     | launch_time | 15.0s  |
    Then outliers should be flagged
    And data should be validated before inclusion
    And I should see data quality indicators

  @edge-case @no-data
  Scenario: Handle no performance data available
    Given a new app version is just released
    When insufficient performance data exists
    Then I should see "Insufficient data" indicators
    And projected metrics based on testing should be shown
    And data collection progress should be displayed

  @edge-case @extreme-conditions
  Scenario: Handle extreme performance conditions
    Given devices are in extreme conditions:
      | condition           | impact              |
      | very_low_memory     | aggressive_gc       |
      | poor_network        | request_timeouts    |
      | thermal_throttling  | reduced_performance |
    Then performance adjustments should be tracked
    And I should see condition-aware metrics
    And user experience adaptations should be logged

  @edge-case @cross-platform
  Scenario: Handle cross-platform metric discrepancies
    Given iOS and Android report different metric formats
    When I view unified performance dashboard
    Then metrics should be normalized:
      | metric      | ios_raw    | android_raw | normalized |
      | memory      | bytes      | KB          | MB         |
      | cpu         | percentage | cores       | percentage |
    And platform differences should be annotated
    And comparison should be meaningful

  @edge-case @historical-data
  Scenario: Handle missing historical performance data
    Given historical data retention is 90 days
    When I request data older than 90 days
    Then I should see data unavailable message
    And archived summary statistics should be shown if available
    And I should see recommendation to adjust retention
