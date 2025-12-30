Feature: Admin Dashboard
  As a platform administrator
  I want to access a comprehensive admin dashboard
  So that I can monitor platform health and manage operations effectively

  Background:
    Given I am logged in as a platform administrator
    And I have full admin permissions

  # ============================================
  # DASHBOARD OVERVIEW
  # ============================================

  @api @dashboard @overview
  Scenario: View admin dashboard overview
    When I send a GET request to "/api/v1/admin/dashboard"
    Then the response status should be 200
    And the response should contain:
      | section              | description                              |
      | system_status        | Overall platform health indicator        |
      | key_metrics          | Critical KPIs and statistics             |
      | recent_activity      | Last 10 admin actions                    |
      | pending_actions      | Items requiring attention                |
      | quick_stats          | User counts, content counts, etc.        |
      | alerts_summary       | Active alerts count by severity          |

  @api @dashboard @overview
  Scenario: View dashboard with date range filter
    When I send a GET request to "/api/v1/admin/dashboard?from=2024-01-01&to=2024-01-31"
    Then the response status should be 200
    And all metrics should reflect the specified date range
    And comparison with previous period should be included

  @api @dashboard @overview @performance
  Scenario: Dashboard loads within performance threshold
    When I request the admin dashboard
    Then the response time should be under 2 seconds
    And critical widgets should load first
    And non-critical widgets should load asynchronously

  # ============================================
  # WIDGET CUSTOMIZATION
  # ============================================

  @api @dashboard @widgets
  Scenario: View available dashboard widgets
    When I send a GET request to "/api/v1/admin/dashboard/widgets/available"
    Then the response status should be 200
    And the response should contain available widgets:
      | widget_id            | name                    | category       |
      | user_stats           | User Statistics         | users          |
      | content_metrics      | Content Metrics         | content        |
      | revenue_chart        | Revenue Overview        | billing        |
      | system_health        | System Health           | infrastructure |
      | recent_signups       | Recent Signups          | users          |
      | error_rate           | Error Rate Trend        | infrastructure |
      | active_sessions      | Active Sessions         | users          |
      | pipeline_status      | Pipeline Status         | data           |

  @api @dashboard @widgets
  Scenario: Customize dashboard layout
    When I send a PUT request to "/api/v1/admin/dashboard/layout" with:
      """json
      {
        "widgets": [
          {"id": "system_health", "position": {"row": 0, "col": 0}, "size": "large"},
          {"id": "user_stats", "position": {"row": 0, "col": 1}, "size": "medium"},
          {"id": "recent_signups", "position": {"row": 1, "col": 0}, "size": "small"},
          {"id": "error_rate", "position": {"row": 1, "col": 1}, "size": "medium"}
        ]
      }
      """
    Then the response status should be 200
    And my dashboard layout should be saved
    And layout should persist across sessions

  @api @dashboard @widgets
  Scenario: Add widget to dashboard
    When I send a POST request to "/api/v1/admin/dashboard/widgets" with:
      """json
      {
        "widget_id": "revenue_chart",
        "position": {"row": 2, "col": 0},
        "size": "large",
        "config": {
          "chart_type": "line",
          "time_range": "30d"
        }
      }
      """
    Then the response status should be 201
    And widget should be added to my dashboard

  @api @dashboard @widgets
  Scenario: Remove widget from dashboard
    Given widget "pipeline_status" is on my dashboard
    When I send a DELETE request to "/api/v1/admin/dashboard/widgets/pipeline_status"
    Then the response status should be 200
    And widget should be removed from my dashboard
    And other widgets should remain unaffected

  @api @dashboard @widgets
  Scenario: Configure individual widget settings
    Given widget "user_stats" is on my dashboard
    When I send a PUT request to "/api/v1/admin/dashboard/widgets/user_stats/config" with:
      """json
      {
        "refresh_interval_seconds": 30,
        "show_trend": true,
        "time_range": "7d",
        "metrics": ["total_users", "active_users", "new_signups"]
      }
      """
    Then the response status should be 200
    And widget configuration should be updated

  @api @dashboard @widgets
  Scenario: Reset dashboard to default layout
    Given I have customized my dashboard
    When I send a POST request to "/api/v1/admin/dashboard/reset"
    Then the response status should be 200
    And dashboard should return to default layout
    And custom configurations should be removed

  # ============================================
  # QUICK ADMINISTRATIVE ACTIONS
  # ============================================

  @api @dashboard @actions
  Scenario: Access quick administrative actions
    When I send a GET request to "/api/v1/admin/dashboard/quick-actions"
    Then the response status should be 200
    And the response should contain available actions:
      | action_id            | name                    | category       |
      | invite_admin         | Invite Admin            | users          |
      | create_announcement  | Create Announcement     | content        |
      | enable_maintenance   | Enable Maintenance Mode | system         |
      | clear_cache          | Clear System Cache      | infrastructure |
      | export_report        | Export Report           | reports        |
      | trigger_backup       | Trigger Backup          | data           |

  @api @dashboard @actions
  Scenario: Execute quick action from dashboard
    When I send a POST request to "/api/v1/admin/dashboard/quick-actions/clear_cache"
    Then the response status should be 200
    And the action should be executed
    And confirmation should be returned
    And action should be logged in audit trail

  @api @dashboard @actions @error
  Scenario: Quick action requires confirmation for destructive operations
    When I send a POST request to "/api/v1/admin/dashboard/quick-actions/enable_maintenance"
    Then the response status should be 428
    And the response should require confirmation token
    When I resend with confirmation token
    Then the action should execute

  # ============================================
  # SYSTEM HEALTH INDICATORS
  # ============================================

  @api @dashboard @health
  Scenario: Monitor system health indicators
    When I send a GET request to "/api/v1/admin/dashboard/health"
    Then the response status should be 200
    And the response should contain health indicators:
      | indicator            | status  | details                          |
      | api_gateway          | healthy | Response time: 45ms              |
      | database_primary     | healthy | Connections: 45/100              |
      | database_replica     | healthy | Replication lag: 0.5s            |
      | cache_cluster        | healthy | Hit rate: 94%                    |
      | message_queue        | warning | Queue depth: 15000               |
      | storage              | healthy | Usage: 65%                       |
      | external_apis        | healthy | All integrations operational     |
    And overall status should be calculated from individual indicators

  @api @dashboard @health
  Scenario: View health indicator history
    Given health indicator "database_primary" exists
    When I send a GET request to "/api/v1/admin/dashboard/health/database_primary/history?period=24h"
    Then the response status should be 200
    And the response should contain historical data points
    And trend should be indicated (improving/stable/degrading)

  @api @dashboard @health
  Scenario: Health indicator shows degraded status
    Given service "message_queue" is experiencing issues
    When I view the system health dashboard
    Then the message_queue indicator should show "warning" or "critical"
    And the indicator should include:
      | field           | description                              |
      | status          | Current health status                    |
      | message         | Human-readable description               |
      | since           | When issue started                       |
      | affected_users  | Estimated user impact                    |
      | action_link     | Link to troubleshooting                  |

  # ============================================
  # SERVICE HEALTH DRILL DOWN
  # ============================================

  @api @dashboard @health @drilldown
  Scenario: Drill down into service health
    Given health indicator "api_gateway" exists
    When I send a GET request to "/api/v1/admin/dashboard/health/api_gateway/details"
    Then the response status should be 200
    And the response should contain detailed metrics:
      | metric               | description                              |
      | response_time_p50    | 50th percentile response time            |
      | response_time_p95    | 95th percentile response time            |
      | response_time_p99    | 99th percentile response time            |
      | requests_per_second  | Current request rate                     |
      | error_rate           | Percentage of 5xx responses              |
      | active_connections   | Current connection count                 |
      | cpu_usage            | CPU utilization percentage               |
      | memory_usage         | Memory utilization percentage            |

  @api @dashboard @health @drilldown
  Scenario: View service dependencies
    Given service "api_gateway" has dependencies
    When I send a GET request to "/api/v1/admin/dashboard/health/api_gateway/dependencies"
    Then the response status should be 200
    And the response should show dependency tree
    And each dependency should include health status

  # ============================================
  # REAL-TIME PLATFORM ACTIVITY
  # ============================================

  @api @dashboard @activity
  Scenario: View real-time platform activity
    When I send a GET request to "/api/v1/admin/dashboard/activity/realtime"
    Then the response status should be 200
    And the response should contain:
      | metric               | description                              |
      | active_users         | Users currently online                   |
      | requests_per_minute  | Current request rate                     |
      | active_sessions      | Total active sessions                    |
      | geographic_dist      | User distribution by region              |
      | top_endpoints        | Most accessed endpoints                  |
      | error_stream         | Recent errors (last 5 minutes)           |

  @api @dashboard @activity @websocket
  Scenario: Subscribe to real-time activity updates
    When I establish WebSocket connection to "/ws/admin/dashboard/activity"
    Then I should receive real-time updates including:
      | event_type           | description                              |
      | user_login           | New user login events                    |
      | user_logout          | User logout events                       |
      | error_occurred       | System error events                      |
      | threshold_breach     | Metric threshold breaches                |
      | admin_action         | Admin actions performed                  |
    And updates should be received within 1 second of occurrence

  @api @dashboard @activity
  Scenario: View activity timeline
    When I send a GET request to "/api/v1/admin/dashboard/activity/timeline?limit=50"
    Then the response status should be 200
    And the response should contain recent activities:
      | field           | description                              |
      | timestamp       | When event occurred                      |
      | event_type      | Type of event                            |
      | actor           | Who performed action (if applicable)     |
      | description     | Human-readable description               |
      | severity        | info/warning/error                       |
      | details_link    | Link to full details                     |

  # ============================================
  # ALERTS MANAGEMENT
  # ============================================

  @api @dashboard @alerts
  Scenario: View and manage platform alerts
    When I send a GET request to "/api/v1/admin/dashboard/alerts"
    Then the response status should be 200
    And the response should contain active alerts:
      | field           | description                              |
      | alert_id        | Unique alert identifier                  |
      | severity        | critical/warning/info                    |
      | title           | Alert title                              |
      | message         | Detailed alert message                   |
      | source          | Which system generated alert             |
      | created_at      | When alert was raised                    |
      | acknowledged    | Whether alert has been acknowledged      |
      | acknowledged_by | Who acknowledged (if applicable)         |

  @api @dashboard @alerts
  Scenario: Acknowledge alert
    Given alert "alert-123" is active and unacknowledged
    When I send a POST request to "/api/v1/admin/dashboard/alerts/alert-123/acknowledge" with:
      """json
      {
        "note": "Investigating the issue"
      }
      """
    Then the response status should be 200
    And alert should be marked as acknowledged
    And acknowledgment should be logged

  @api @dashboard @alerts
  Scenario: Resolve alert
    Given alert "alert-123" is acknowledged
    When I send a POST request to "/api/v1/admin/dashboard/alerts/alert-123/resolve" with:
      """json
      {
        "resolution": "Increased queue worker count",
        "root_cause": "Traffic spike from marketing campaign"
      }
      """
    Then the response status should be 200
    And alert should be marked as resolved
    And resolution should be logged for future reference

  @api @dashboard @alerts
  Scenario: Snooze alert temporarily
    Given alert "alert-456" is active
    When I send a POST request to "/api/v1/admin/dashboard/alerts/alert-456/snooze" with:
      """json
      {
        "duration_minutes": 30,
        "reason": "Known issue, fix deploying soon"
      }
      """
    Then the response status should be 200
    And alert should be hidden for 30 minutes
    And alert should reappear after snooze period

  @api @dashboard @alerts
  Scenario: Filter alerts by severity
    When I send a GET request to "/api/v1/admin/dashboard/alerts?severity=critical"
    Then the response status should be 200
    And all returned alerts should have severity "critical"

  # ============================================
  # GLOBAL ADMIN SEARCH
  # ============================================

  @api @dashboard @search
  Scenario: Use global admin search
    When I send a GET request to "/api/v1/admin/search?q=john"
    Then the response status should be 200
    And the response should contain results grouped by type:
      | type           | description                              |
      | users          | Users matching "john"                    |
      | admins         | Admins matching "john"                   |
      | content        | Content matching "john"                  |
      | settings       | Settings matching "john"                 |
      | logs           | Audit logs matching "john"               |
    And each result should include link to full resource

  @api @dashboard @search
  Scenario: Search with type filter
    When I send a GET request to "/api/v1/admin/search?q=example.com&type=users"
    Then the response status should be 200
    And results should only include users
    And users with "example.com" in email should be returned

  @api @dashboard @search
  Scenario: Search returns relevant suggestions
    When I send a GET request to "/api/v1/admin/search/suggest?q=conf"
    Then the response status should be 200
    And the response should contain suggestions:
      | suggestion           | type                                    |
      | configuration        | settings                                 |
      | confirm email        | action                                   |
      | config.yaml          | file                                     |

  @api @dashboard @search @error
  Scenario: Search with too short query
    When I send a GET request to "/api/v1/admin/search?q=a"
    Then the response status should be 400
    And the response should contain error "Search query must be at least 2 characters"

  # ============================================
  # ADMIN BREADCRUMBS
  # ============================================

  @api @dashboard @navigation
  Scenario: Navigate using admin breadcrumbs
    When I navigate to "/admin/users/user-123/activity"
    Then the breadcrumb should show:
      | level    | label          | link                    |
      | 1        | Dashboard      | /admin                  |
      | 2        | Users          | /admin/users            |
      | 3        | John Doe       | /admin/users/user-123   |
      | 4        | Activity       | (current page)          |
    And each breadcrumb level should be clickable except current

  @api @dashboard @navigation
  Scenario: Breadcrumb reflects deep navigation
    When I navigate through multiple admin sections
    Then breadcrumb should update in real-time
    And browser back button should work correctly
    And deep links should be shareable

  # ============================================
  # ANALYTICS SUMMARY
  # ============================================

  @api @dashboard @analytics
  Scenario: View dashboard analytics summary
    When I send a GET request to "/api/v1/admin/dashboard/analytics"
    Then the response status should be 200
    And the response should contain:
      | metric               | description                              |
      | total_users          | Total registered users                   |
      | active_users_today   | Users active in last 24h                 |
      | new_users_week       | New signups this week                    |
      | total_content        | Total content items                      |
      | revenue_mtd          | Revenue month-to-date                    |
      | conversion_rate      | Signup to paid conversion                |
      | churn_rate           | Monthly churn rate                       |
      | nps_score            | Net Promoter Score                       |

  @api @dashboard @analytics
  Scenario: View analytics with comparison
    When I send a GET request to "/api/v1/admin/dashboard/analytics?compare=previous_period"
    Then the response status should be 200
    And each metric should include:
      | field           | description                              |
      | current_value   | Value for current period                 |
      | previous_value  | Value for comparison period              |
      | change_percent  | Percentage change                        |
      | trend           | up/down/stable                           |

  @api @dashboard @analytics
  Scenario: Export analytics data
    When I send a POST request to "/api/v1/admin/dashboard/analytics/export" with:
      """json
      {
        "format": "csv",
        "metrics": ["total_users", "active_users", "revenue"],
        "date_range": {
          "from": "2024-01-01",
          "to": "2024-01-31"
        }
      }
      """
    Then the response status should be 202
    And export should be queued
    And download link should be provided when ready

  # ============================================
  # MOBILE RESPONSIVE
  # ============================================

  @integration @dashboard @mobile
  Scenario: Access dashboard on mobile device
    Given I am using a mobile device with viewport 375x667
    When I access the admin dashboard
    Then the dashboard should render in mobile-friendly layout
    And critical widgets should be visible without scrolling
    And navigation should collapse to hamburger menu
    And touch interactions should be properly sized

  @integration @dashboard @mobile
  Scenario: Mobile dashboard prioritizes critical information
    Given I am using a mobile device
    When I view the admin dashboard
    Then I should see:
      | priority | content                                  |
      | 1        | System health status                     |
      | 2        | Active alerts count                      |
      | 3        | Quick action buttons                     |
      | 4        | Key metrics summary                      |
    And detailed charts should be accessible via drill-down

  # ============================================
  # ROLE-BASED ACCESS
  # ============================================

  @api @dashboard @authorization
  Scenario: View dashboard with limited admin role
    Given I am logged in as a Content Admin
    When I access the admin dashboard
    Then I should only see widgets relevant to my role:
      | visible              | not_visible                              |
      | content_metrics      | revenue_chart                            |
      | content_activity     | system_health                            |
      | content_alerts       | user_management                          |
    And unauthorized widgets should not be rendered
    And no error should be shown for hidden widgets

  @api @dashboard @authorization
  Scenario: Dashboard adapts to admin permissions
    Given I am logged in with custom permissions
    When I send a GET request to "/api/v1/admin/dashboard"
    Then the response should only include data I'm authorized to see
    And quick actions should only include permitted actions
    And search results should be filtered by permission

  @api @dashboard @authorization @error
  Scenario: Unauthorized widget access is blocked
    Given I am logged in as a Content Admin
    When I attempt to access the revenue widget directly
    Then the response status should be 403
    And the response should contain error "Access denied to this widget"

  # ============================================
  # DASHBOARD PREFERENCES
  # ============================================

  @api @dashboard @preferences
  Scenario: Save dashboard preferences
    When I send a PUT request to "/api/v1/admin/dashboard/preferences" with:
      """json
      {
        "theme": "dark",
        "default_time_range": "7d",
        "refresh_interval_seconds": 60,
        "compact_mode": false,
        "show_notifications": true
      }
      """
    Then the response status should be 200
    And preferences should be saved
    And preferences should apply on next dashboard load

  @api @dashboard @preferences
  Scenario: Dashboard respects saved preferences
    Given I have saved dashboard preferences with theme "dark"
    When I load the admin dashboard
    Then the dashboard should render with dark theme
    And all widgets should respect the theme preference

  # ============================================
  # DOMAIN EVENTS
  # ============================================

  @domain @events
  Scenario: Emit domain events for dashboard interactions
    Given dashboard operations occur
    Then the following domain events should be emitted:
      | event_type                      | payload                               |
      | DashboardViewedEvent            | admin_id, timestamp                   |
      | DashboardLayoutChangedEvent     | admin_id, old_layout, new_layout      |
      | WidgetAddedEvent                | admin_id, widget_id, position         |
      | WidgetRemovedEvent              | admin_id, widget_id                   |
      | AlertAcknowledgedEvent          | admin_id, alert_id, note              |
      | AlertResolvedEvent              | admin_id, alert_id, resolution        |
      | QuickActionExecutedEvent        | admin_id, action_id, result           |
      | DashboardExportRequestedEvent   | admin_id, format, metrics             |
    And events should be published for analytics
