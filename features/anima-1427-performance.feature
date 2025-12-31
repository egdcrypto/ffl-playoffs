Feature: Performance Optimization
  As a platform operator
  I want comprehensive performance optimization across all system layers
  So that users experience fast, responsive, and reliable application performance

  Background:
    Given the system is deployed in a production environment
    And performance monitoring is enabled
    And baseline metrics have been established

  # ============================================================================
  # Page Load Optimization
  # ============================================================================

  Scenario: Initial page load completes within target time
    Given a user with a broadband connection (50+ Mbps)
    When the user navigates to the application home page
    Then the First Contentful Paint (FCP) occurs within 1.8 seconds
    And the Largest Contentful Paint (LCP) occurs within 2.5 seconds
    And the Time to Interactive (TTI) is within 3.8 seconds
    And the Cumulative Layout Shift (CLS) is below 0.1
    And the First Input Delay (FID) is below 100 milliseconds

  Scenario: Critical rendering path is optimized
    Given the application serves a page with multiple resources
    When the page is loaded
    Then critical CSS is inlined in the document head
    And non-critical CSS is loaded asynchronously
    And JavaScript bundles are loaded with defer or async attributes
    And render-blocking resources are minimized
    And the critical path length is under 14 KB compressed

  Scenario: Above-the-fold content loads first
    Given a page with content below the fold
    When the page is rendered
    Then above-the-fold content is prioritized
    And below-the-fold images are lazy loaded
    And below-the-fold components are code-split
    And the user perceives instant page load

  Scenario: Page load performance on slow connections
    Given a user with a 3G connection (1.5 Mbps)
    When the user navigates to the application
    Then the First Contentful Paint occurs within 4 seconds
    And a meaningful loading state is displayed immediately
    And progressive rendering shows content as it loads
    And the page remains usable during loading

  Scenario: Subsequent page navigations are faster
    Given a user has loaded the initial page
    And application resources are cached
    When the user navigates to another page
    Then cached resources are reused
    And only new data is fetched
    And navigation completes within 500 milliseconds
    And the navigation feels instant

  # ============================================================================
  # Caching Strategy
  # ============================================================================

  Scenario: Browser caching is properly configured
    Given static assets are served by the application
    When assets are requested
    Then the following cache headers are applied:
      | Asset Type   | Cache-Control Header                    |
      | HTML         | no-cache, must-revalidate               |
      | CSS/JS       | public, max-age=31536000, immutable     |
      | Images       | public, max-age=2592000                 |
      | Fonts        | public, max-age=31536000, immutable     |
      | API Response | private, max-age=0, must-revalidate     |
    And ETags are generated for all cacheable resources

  Scenario: Service worker caches critical assets
    Given a service worker is registered
    When the application is installed
    Then critical assets are cached in the service worker:
      | App shell HTML        |
      | Core CSS bundle       |
      | Core JavaScript bundle|
      | Essential fonts       |
      | Placeholder images    |
    And the cache is updated on new deployments
    And stale cache entries are purged

  Scenario: API response caching with stale-while-revalidate
    Given an API endpoint returns cacheable data
    When the data is fetched
    Then the response is cached locally
    And subsequent requests return cached data immediately
    And a background refresh is triggered
    When fresh data is available
    Then the cache is updated silently
    And the user sees updated data on next interaction

  Scenario: Cache invalidation on data mutations
    Given data is cached in the browser
    When the user performs a mutation (create, update, delete)
    Then related cached data is invalidated
    And affected queries are refetched
    And the UI reflects the mutation immediately
    And cache consistency is maintained

  Scenario: CDN caching for static assets
    Given static assets are served through a CDN
    When an asset is requested from a new region
    Then the CDN fetches from origin
    And caches the asset at edge locations
    When the same asset is requested from the same region
    Then it is served from the edge cache
    And latency is reduced by 50% or more

  Scenario: Redis caching for session data
    Given user session data needs to be stored
    When the user authenticates
    Then session data is stored in Redis
    And session TTL is set to 24 hours
    And session is accessible across all application instances
    And session lookup takes less than 5 milliseconds

  # ============================================================================
  # Database Performance
  # ============================================================================

  Scenario: Database queries are optimized
    Given a database query is executed
    When the query runs
    Then query execution time is under 100 milliseconds
    And appropriate indexes are used
    And no full table scans occur for large tables
    And the query plan is optimal

  Scenario: Database connection pooling is configured
    Given the application requires database connections
    When the application starts
    Then a connection pool is initialized with:
      | Minimum connections | 10                |
      | Maximum connections | 100               |
      | Connection timeout  | 30 seconds        |
      | Idle timeout        | 10 minutes        |
    And connections are reused efficiently
    And connection exhaustion is prevented

  Scenario: N+1 query problem is prevented
    Given an endpoint fetches entities with relationships
    When the data is loaded
    Then related entities are fetched with JOIN or batch queries
    And the total number of queries is constant (not proportional to results)
    And query count is logged and monitored
    And alerts trigger on N+1 patterns

  Scenario: Database read replicas handle read traffic
    Given the system has high read traffic
    When read queries are executed
    Then queries are routed to read replicas
    And write queries go to the primary database
    And replica lag is monitored
    And consistency requirements are respected

  Scenario: Slow query detection and alerting
    Given query monitoring is enabled
    When a query exceeds 500 milliseconds
    Then the query is logged with full details:
      | Query SQL           |
      | Execution time      |
      | Query plan          |
      | Calling endpoint    |
    And an alert is sent to the development team
    And the query is added to optimization backlog

  Scenario: Database migrations are non-blocking
    Given a schema migration needs to be applied
    When the migration runs in production
    Then the migration does not lock tables
    And the application remains available
    And migrations are applied in background
    And rollback procedures are documented

  # ============================================================================
  # API Performance
  # ============================================================================

  Scenario: API response times meet SLA
    Given an API endpoint is called
    When the request is processed
    Then the response is returned within:
      | Endpoint Type     | Target Latency |
      | Read endpoints    | 100ms (p95)    |
      | Write endpoints   | 200ms (p95)    |
      | Complex queries   | 500ms (p95)    |
      | Bulk operations   | 2000ms (p95)   |
    And latency percentiles are tracked

  Scenario: API pagination prevents large responses
    Given an endpoint returns a collection of resources
    When more than 100 items would be returned
    Then results are paginated with:
      | Default page size | 50    |
      | Maximum page size | 100   |
      | Cursor-based      | true  |
    And total count is included in response metadata
    And next/previous page links are provided

  Scenario: API response compression is enabled
    Given an API response is larger than 1 KB
    When the client accepts gzip or brotli encoding
    Then the response is compressed
    And compression reduces payload by 60-80%
    And Content-Encoding header is set
    And compression overhead is under 10 milliseconds

  Scenario: GraphQL query complexity is limited
    Given a GraphQL query is submitted
    When the query complexity is calculated
    Then queries exceeding complexity limit are rejected:
      | Maximum depth       | 10          |
      | Maximum complexity  | 1000 points |
      | Maximum aliases     | 50          |
    And an error is returned explaining the limit
    And complex queries are logged for analysis

  Scenario: API rate limiting protects resources
    Given rate limiting is configured
    When a client exceeds rate limits
    Then requests are rejected with 429 status
    And rate limit headers are included:
      | X-RateLimit-Limit     |
      | X-RateLimit-Remaining |
      | X-RateLimit-Reset     |
    And legitimate traffic is not impacted
    And rate limits are applied per user and IP

  Scenario: API circuit breaker prevents cascade failures
    Given a downstream service is failing
    When error rate exceeds 50% over 10 seconds
    Then the circuit breaker opens
    And requests return fallback responses
    And the failing service is given time to recover
    When the service recovers
    Then the circuit breaker closes gradually
    And normal operation resumes

  # ============================================================================
  # Image Optimization
  # ============================================================================

  Scenario: Images are served in next-gen formats
    Given the application displays images
    When an image is requested
    Then WebP format is served to supporting browsers
    And AVIF format is served when supported
    And fallback formats are provided for older browsers
    And format selection is automatic via Accept header

  Scenario: Responsive images are served
    Given an image is displayed at various viewport sizes
    When the image is requested
    Then srcset with multiple resolutions is provided
    And sizes attribute specifies layout widths
    And the browser selects optimal resolution
    And unnecessary bandwidth is not consumed

  Scenario: Images are lazy loaded
    Given images exist below the fold
    When the page initially loads
    Then below-fold images are not loaded
    And placeholder elements preserve layout
    When the user scrolls toward an image
    Then the image is loaded before entering viewport
    And loading is perceived as seamless

  Scenario: Image CDN transforms images on-the-fly
    Given an image needs to be displayed at specific dimensions
    When the image URL includes transformation parameters
    Then the CDN resizes the image server-side
    And appropriate quality settings are applied
    And transformed images are cached
    And original high-resolution images are preserved

  Scenario: Critical images are preloaded
    Given the page has a hero image above the fold
    When the page is loaded
    Then the hero image is preloaded in the document head
    And LCP is not delayed by image loading
    And preload hint uses correct format and dimensions

  # ============================================================================
  # Frontend Performance
  # ============================================================================

  Scenario: JavaScript bundles are optimized
    Given the application has multiple JavaScript modules
    When the application is built
    Then code splitting separates vendor and application code
    And route-based splitting creates separate chunks
    And tree shaking removes unused code
    And total JavaScript is under 300 KB compressed

  Scenario: CSS is optimized for performance
    Given the application uses CSS stylesheets
    When the application is built
    Then unused CSS is purged
    And CSS is minified
    And critical CSS is extracted and inlined
    And total CSS is under 100 KB compressed

  Scenario: Web fonts are optimized
    Given custom fonts are used in the application
    When fonts are loaded
    Then font-display: swap prevents invisible text
    And fonts are subset to include only used characters
    And fonts are preloaded for critical text
    And system fonts are used as fallback

  Scenario: Long tasks are broken up
    Given a JavaScript operation takes more than 50 milliseconds
    When the operation runs
    Then it is broken into smaller chunks
    And control is yielded to the browser between chunks
    And the UI remains responsive during the operation
    And Total Blocking Time (TBT) is minimized

  Scenario: Virtual scrolling handles large lists
    Given a list contains more than 100 items
    When the list is rendered
    Then only visible items are rendered in the DOM
    And items are recycled as the user scrolls
    And scroll performance remains smooth (60 FPS)
    And memory usage is constant regardless of list size

  Scenario: Animations are GPU-accelerated
    Given the UI includes animations
    When animations run
    Then animations use transform and opacity properties
    And animations are promoted to compositor layer
    And main thread is not blocked
    And animations maintain 60 FPS

  # ============================================================================
  # Backend Performance
  # ============================================================================

  Scenario: Application server handles concurrent requests
    Given the application server is under load
    When 1000 concurrent requests are received
    Then all requests are handled without errors
    And response times remain within SLA
    And CPU utilization stays below 80%
    And memory usage remains stable

  Scenario: Async operations are non-blocking
    Given an API endpoint performs I/O operations
    When the endpoint is called
    Then I/O operations are non-blocking
    And worker threads are not tied up waiting
    And throughput scales with concurrent requests
    And thread pool is efficiently utilized

  Scenario: Background job processing is efficient
    Given background jobs need to be processed
    When jobs are enqueued
    Then jobs are processed by dedicated workers
    And job processing does not impact API performance
    And failed jobs are retried with exponential backoff
    And job queue depth is monitored

  Scenario: Memory usage is optimized
    Given the application runs under load
    When memory is allocated
    Then memory is efficiently garbage collected
    And no memory leaks occur over time
    And heap size remains within configured limits
    And OutOfMemory errors do not occur

  Scenario: CPU-intensive operations are offloaded
    Given a CPU-intensive operation is requested
    When the operation is processed
    Then the operation runs on a separate thread pool
    And request handling threads are not blocked
    And operation results are cached when possible
    And timeout limits prevent runaway operations

  Scenario: Microservices communicate efficiently
    Given services communicate with each other
    When inter-service calls are made
    Then gRPC is used for internal communication
    And connection pooling is enabled
    And requests are batched where possible
    And network round trips are minimized

  # ============================================================================
  # Monitoring and Metrics
  # ============================================================================

  Scenario: Real User Monitoring (RUM) captures performance
    Given RUM is enabled in the application
    When users interact with the application
    Then performance metrics are captured:
      | Navigation timing     |
      | Resource timing       |
      | User timing marks     |
      | Web Vitals (LCP, FID, CLS) |
      | JavaScript errors     |
    And metrics are aggregated by page and user segment
    And dashboards display real-time performance

  Scenario: Application Performance Monitoring (APM) is configured
    Given APM agents are installed
    When requests are processed
    Then distributed traces are captured
    And trace context propagates across services
    And slow transactions are identified
    And error rates are tracked per endpoint

  Scenario: Performance budgets are enforced
    Given performance budgets are defined
    When the application is built or deployed
    Then budgets are checked:
      | JavaScript bundle size | < 300 KB |
      | CSS bundle size        | < 100 KB |
      | Total page weight      | < 1.5 MB |
      | LCP                    | < 2.5s   |
    And builds fail if budgets are exceeded
    And budget violations trigger alerts

  Scenario: Performance regression detection
    Given baseline performance metrics exist
    When new code is deployed
    Then performance tests run automatically
    And results are compared to baseline
    When performance regresses by more than 10%
    Then deployment is flagged for review
    And regression details are reported

  Scenario: Alerting on performance degradation
    Given performance thresholds are configured
    When metrics exceed thresholds
    Then alerts are sent to on-call engineers:
      | P95 latency > 500ms    | High severity   |
      | Error rate > 1%        | High severity   |
      | LCP > 4s               | Medium severity |
      | Memory usage > 90%     | High severity   |
    And alerts include relevant context
    And runbooks are linked for remediation

  Scenario: Performance dashboards provide visibility
    Given monitoring systems collect metrics
    When operators view dashboards
    Then they see real-time metrics:
      | Request throughput    |
      | Response latency (p50, p95, p99) |
      | Error rates           |
      | Resource utilization  |
      | Database query times  |
    And historical trends are available
    And drill-down to specific endpoints is possible

  # ============================================================================
  # Stress Testing
  # ============================================================================

  Scenario: Load testing validates capacity
    Given load testing is scheduled
    When load tests execute
    Then the system is tested at:
      | Expected load     | 100% of projected traffic  |
      | Peak load         | 200% of projected traffic  |
      | Breaking point    | Until degradation occurs   |
    And capacity limits are documented
    And scaling thresholds are identified

  Scenario: Soak testing validates stability
    Given soak testing is configured
    When the application runs under sustained load for 24 hours
    Then response times remain consistent
    And memory usage does not grow
    And no resource exhaustion occurs
    And the system remains stable

  Scenario: Spike testing validates elasticity
    Given the system has auto-scaling enabled
    When traffic spikes 5x within 5 minutes
    Then auto-scaling triggers new instances
    And request queue depth increases briefly
    And no requests are dropped
    And performance recovers within 2 minutes

  Scenario: Chaos testing validates resilience
    Given chaos engineering tests are configured
    When infrastructure failures are simulated:
      | Service instance failure |
      | Database failover        |
      | Network partition        |
      | Cache unavailability     |
    Then the system degrades gracefully
    And critical functionality remains available
    And recovery is automatic
    And MTTR is within acceptable limits

  Scenario: Synthetic monitoring validates availability
    Given synthetic monitors are deployed
    When monitors run every minute
    Then key user journeys are tested:
      | Home page load      |
      | User authentication |
      | Core feature usage  |
      | API health check    |
    And availability is tracked (target: 99.9%)
    And alerts fire on availability drops

  # ============================================================================
  # Progressive Enhancement
  # ============================================================================

  Scenario: Core functionality works without JavaScript
    Given JavaScript is disabled in the browser
    When the user accesses the application
    Then the page renders with content
    And navigation links work
    And forms submit successfully
    And core information is accessible

  Scenario: Application enhances with JavaScript
    Given JavaScript is enabled
    When the application loads
    Then interactive features are activated
    And client-side routing is enabled
    And real-time updates are enabled
    And the experience is enhanced progressively

  Scenario: Graceful degradation on older browsers
    Given a user accesses from an older browser
    When modern features are not supported
    Then polyfills are loaded for critical features
    And unsupported enhancements are skipped
    And core functionality remains available
    And users see a functional experience

  Scenario: Network resilience with offline support
    Given the service worker is active
    When the network becomes unavailable
    Then cached pages are served
    And users can view previously loaded content
    And queued actions are stored locally
    When the network is restored
    Then queued actions are synchronized
    And users receive confirmation

  Scenario: Reduced motion for accessibility
    Given a user has reduced motion preference
    When animations would normally play
    Then animations are disabled or minimized
    And transitions are instant or very short
    And the user's preference is respected
    And functionality is preserved

  Scenario: Low bandwidth mode optimizes data usage
    Given the Save-Data header is present
    When the application renders
    Then images are served at lower quality
    And non-essential resources are deferred
    And data transfer is minimized
    And functionality is preserved with reduced fidelity

  Scenario: Feature detection enables progressive enhancement
    Given browsers have varying capabilities
    When a feature is about to be used
    Then feature detection checks for support
    And supported features are utilized
    And unsupported features fall back gracefully
    And no JavaScript errors occur on older browsers
