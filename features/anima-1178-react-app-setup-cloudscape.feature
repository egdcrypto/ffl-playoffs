@react @typescript @cloudscape @vite @frontend @foundation
Feature: React App Setup with Cloudscape Design System
  As a frontend developer
  I want to set up a React application with TypeScript and AWS Cloudscape Design System
  So that I can build a consistent, accessible, and professional user interface

  Background:
    Given the project repository is initialized
    And Node.js version 18+ is available
    And npm or yarn package manager is configured

  # ==========================================
  # Vite Configuration
  # ==========================================

  @vite @setup
  Scenario: Initialize Vite with React and TypeScript
    Given I am setting up the frontend project
    When I initialize Vite with React TypeScript template
    Then the following files should be created:
      | file                | purpose                    |
      | vite.config.ts      | Vite configuration         |
      | tsconfig.json       | TypeScript configuration   |
      | tsconfig.node.json  | Node TypeScript config     |
      | index.html          | Entry HTML file            |
      | src/main.tsx        | Application entry point    |
      | src/App.tsx         | Root component             |
    And the development server should start successfully

  @vite @configuration
  Scenario: Configure Vite build settings
    Given Vite is initialized
    When I configure vite.config.ts:
      | setting           | value                    |
      | base              | /                        |
      | build.outDir      | dist                     |
      | build.sourcemap   | true                     |
      | server.port       | 3000                     |
      | server.proxy      | /api -> backend          |
    Then build configuration should be applied
    And development proxy should route API calls

  @vite @plugins
  Scenario: Configure Vite plugins
    Given Vite is configured
    When I add plugins:
      | plugin              | purpose                    |
      | @vitejs/plugin-react| React Fast Refresh         |
      | vite-plugin-svgr    | SVG as React components    |
      | vite-tsconfig-paths | TypeScript path aliases    |
    Then plugins should be registered
    And plugin functionality should work

  @vite @environment
  Scenario: Configure environment variables
    Given Vite environment handling is needed
    When I create environment files:
      | file              | purpose                    |
      | .env              | Default variables          |
      | .env.development  | Development overrides      |
      | .env.production   | Production values          |
      | .env.local        | Local overrides (gitignored)|
    Then variables prefixed with VITE_ should be accessible
    And sensitive values should not be exposed

  @vite @build
  Scenario: Build production bundle
    Given the application is ready for production
    When I run the production build
    Then optimized bundle should be created in dist/
    And assets should be hashed for cache busting
    And bundle size should be analyzed
    And source maps should be generated

  @vite @hot-reload
  Scenario: Verify hot module replacement
    Given development server is running
    When I modify a React component
    Then the change should reflect immediately
    And component state should be preserved
    And full page reload should not occur

  # ==========================================
  # TypeScript Configuration
  # ==========================================

  @typescript @strict
  Scenario: Configure strict TypeScript settings
    Given TypeScript is initialized
    When I configure tsconfig.json:
      | option                    | value   |
      | strict                    | true    |
      | noImplicitAny             | true    |
      | strictNullChecks          | true    |
      | noUnusedLocals            | true    |
      | noUnusedParameters        | true    |
      | noImplicitReturns         | true    |
      | esModuleInterop           | true    |
      | skipLibCheck              | true    |
    Then strict type checking should be enforced
    And build should fail on type errors

  @typescript @paths
  Scenario: Configure path aliases
    Given I want cleaner imports
    When I configure path aliases:
      | alias         | path                    |
      | @components   | src/components          |
      | @pages        | src/pages               |
      | @hooks        | src/hooks               |
      | @services     | src/services            |
      | @utils        | src/utils               |
      | @types        | src/types               |
      | @assets       | src/assets              |
    Then imports should use aliases
    And IDE should resolve paths correctly

  @typescript @types
  Scenario: Define global type declarations
    Given custom types are needed
    When I create type declaration files:
      | file                  | content                    |
      | src/types/api.d.ts    | API response types         |
      | src/types/models.d.ts | Domain model types         |
      | src/types/env.d.ts    | Environment variable types |
      | src/vite-env.d.ts     | Vite environment types     |
    Then types should be available globally
    And type inference should work correctly

  @typescript @jsx
  Scenario: Configure JSX handling
    Given React JSX is used
    When I configure JSX settings:
      | option        | value         |
      | jsx           | react-jsx     |
      | jsxImportSource| react        |
    Then JSX should compile correctly
    And React import should not be required in every file

  # ==========================================
  # AWS Cloudscape Design System
  # ==========================================

  @cloudscape @installation
  Scenario: Install Cloudscape Design System
    Given I am adding Cloudscape to the project
    When I install Cloudscape packages:
      | package                           | purpose              |
      | @cloudscape-design/components     | UI components        |
      | @cloudscape-design/global-styles  | Global CSS styles    |
      | @cloudscape-design/design-tokens  | Design tokens        |
      | @cloudscape-design/collection-hooks| Collection utilities|
    Then packages should be installed
    And components should be importable

  @cloudscape @global-styles
  Scenario: Apply Cloudscape global styles
    Given Cloudscape is installed
    When I import global styles in main.tsx:
      """
      import '@cloudscape-design/global-styles/index.css';
      """
    Then Cloudscape base styles should apply
    And typography should be correct
    And color scheme should be applied

  @cloudscape @app-layout
  Scenario: Implement Cloudscape AppLayout
    Given I am creating the main layout
    When I implement AppLayout:
      | section         | component                    |
      | navigation      | SideNavigation               |
      | breadcrumbs     | BreadcrumbGroup              |
      | content         | Page content area            |
      | tools           | Help panel                   |
      | notifications   | Flashbar                     |
    Then layout should render correctly
    And navigation should be responsive
    And all sections should be accessible

  @cloudscape @navigation
  Scenario: Configure side navigation
    Given AppLayout is implemented
    When I configure SideNavigation:
      | item            | type      | href           |
      | Dashboard       | link      | /dashboard     |
      | Leagues         | section   | -              |
      | My Leagues      | link      | /leagues       |
      | Join League     | link      | /leagues/join  |
      | Teams           | section   | -              |
      | My Team         | link      | /team          |
      | Roster          | link      | /roster        |
    Then navigation should display correctly
    And active item should be highlighted
    And sections should be collapsible

  @cloudscape @table
  Scenario: Implement data table with Cloudscape Table
    Given I need to display tabular data
    When I implement Cloudscape Table:
      | feature             | configuration          |
      | columns             | defined with headers   |
      | sorting             | client or server side  |
      | pagination          | with page size options |
      | filtering           | with filter controls   |
      | selection           | single or multi-select |
      | empty_state         | custom empty message   |
      | loading_state       | skeleton loading       |
    Then table should render with all features
    And interactions should work correctly

  @cloudscape @forms
  Scenario: Implement forms with Cloudscape components
    Given I need form inputs
    When I use Cloudscape form components:
      | component       | usage                    |
      | FormField       | Label and validation     |
      | Input           | Text input               |
      | Select          | Dropdown selection       |
      | Multiselect     | Multiple selection       |
      | DatePicker      | Date selection           |
      | Textarea        | Multi-line text          |
      | Checkbox        | Boolean toggle           |
      | RadioGroup      | Single choice            |
    Then forms should render correctly
    And validation should display properly

  @cloudscape @modal
  Scenario: Implement modal dialogs
    Given I need modal functionality
    When I implement Cloudscape Modal:
      | feature         | configuration          |
      | header          | Modal title            |
      | content         | Modal body             |
      | footer          | Action buttons         |
      | size            | small/medium/large     |
      | dismissible     | close button behavior  |
    Then modal should open and close correctly
    And focus should be trapped within modal
    And escape key should close modal

  @cloudscape @flashbar
  Scenario: Implement notifications with Flashbar
    Given I need notification system
    When I implement Flashbar:
      | notification_type | color    | dismissible |
      | success           | green    | true        |
      | error             | red      | true        |
      | warning           | yellow   | true        |
      | info              | blue     | true        |
    Then notifications should display correctly
    And auto-dismiss should work if configured
    And dismiss action should work

  @cloudscape @theming
  Scenario: Configure Cloudscape theming
    Given I want custom theming
    When I apply visual mode:
      | mode            | description            |
      | light           | Light color scheme     |
      | dark            | Dark color scheme      |
    Then theme should apply consistently
    And user preference should be respected
    And theme toggle should work

  @cloudscape @accessibility
  Scenario: Verify Cloudscape accessibility
    Given Cloudscape components are implemented
    When accessibility audit runs
    Then all components should pass WCAG 2.1 AA
    And keyboard navigation should work
    And screen reader support should be complete
    And focus indicators should be visible

  # ==========================================
  # React Router Configuration
  # ==========================================

  @router @setup
  Scenario: Configure React Router
    Given routing is needed
    When I install and configure React Router:
      | package             | version |
      | react-router-dom    | ^6.x    |
    Then BrowserRouter should be configured
    And routes should be defined
    And navigation should work

  @router @routes
  Scenario: Define application routes
    Given React Router is configured
    When I define routes:
      | path              | component        | auth_required |
      | /                 | Home             | false         |
      | /login            | Login            | false         |
      | /dashboard        | Dashboard        | true          |
      | /leagues          | LeagueList       | true          |
      | /leagues/:id      | LeagueDetail     | true          |
      | /team             | TeamManagement   | true          |
      | /roster           | RosterManagement | true          |
      | /draft            | DraftRoom        | true          |
      | /settings         | Settings         | true          |
      | /*                | NotFound         | false         |
    Then routes should resolve to correct components
    And URL parameters should be accessible

  @router @protected
  Scenario: Implement protected routes
    Given some routes require authentication
    When I implement ProtectedRoute component
    Then unauthenticated users should be redirected to login
    And authenticated users should access protected routes
    And return URL should be preserved after login

  @router @lazy-loading
  Scenario: Configure lazy loading for routes
    Given I want code splitting
    When I configure lazy loading:
      """
      const Dashboard = React.lazy(() => import('./pages/Dashboard'));
      const LeagueList = React.lazy(() => import('./pages/LeagueList'));
      """
    Then route components should load on demand
    And loading fallback should display
    And bundle should be split per route

  @router @navigation
  Scenario: Implement programmatic navigation
    Given I need to navigate programmatically
    When I use navigation hooks:
      | hook           | purpose                    |
      | useNavigate    | Programmatic navigation    |
      | useLocation    | Current location info      |
      | useParams      | URL parameters             |
      | useSearchParams| Query string parameters    |
    Then navigation should work from code
    And location state should be accessible

  @router @breadcrumbs
  Scenario: Generate breadcrumbs from routes
    Given I need breadcrumb navigation
    When breadcrumbs are generated from route config
    Then breadcrumbs should reflect current path
    And each breadcrumb should be clickable
    And Cloudscape BreadcrumbGroup should be used

  # ==========================================
  # API Client Configuration
  # ==========================================

  @api-client @setup
  Scenario: Configure API client with Axios
    Given API communication is needed
    When I configure Axios client:
      | setting           | value                    |
      | baseURL           | from environment         |
      | timeout           | 30000                    |
      | headers           | Content-Type: application/json |
    Then API client should be configured
    And base configuration should apply to all requests

  @api-client @interceptors
  Scenario: Configure request/response interceptors
    Given I need to modify requests and responses
    When I configure interceptors:
      | interceptor       | purpose                    |
      | request.auth      | Add authentication token   |
      | request.logging   | Log outgoing requests      |
      | response.transform| Transform response data    |
      | response.error    | Handle error responses     |
    Then interceptors should process requests
    And error handling should be centralized

  @api-client @authentication
  Scenario: Handle authentication in API client
    Given API requires authentication
    When authentication interceptor is configured
    Then JWT token should be added to headers
    And 401 responses should trigger token refresh
    And failed refresh should redirect to login

  @api-client @error-handling
  Scenario: Implement API error handling
    Given API errors need handling
    When error interceptor is configured
    Then errors should be parsed consistently
    And error messages should be extracted
    And network errors should be handled
    And error notifications should display

  @api-client @retry
  Scenario: Configure request retry logic
    Given transient failures may occur
    When retry logic is configured:
      | setting           | value    |
      | retries           | 3        |
      | retryDelay        | 1000     |
      | retryCondition    | network_error, 5xx |
    Then failed requests should retry
    And exponential backoff should apply
    And max retries should be respected

  @api-client @caching
  Scenario: Implement request caching
    Given some API responses are cacheable
    When caching is configured:
      | endpoint_pattern  | cache_duration |
      | /api/config/*     | 1 hour         |
      | /api/players/*    | 5 minutes      |
    Then cacheable responses should be stored
    And cache should be used for subsequent requests
    And cache invalidation should work

  @api-client @react-query
  Scenario: Integrate React Query for data fetching
    Given I want declarative data fetching
    When I configure React Query:
      | setting               | value        |
      | staleTime             | 5 minutes    |
      | cacheTime             | 30 minutes   |
      | refetchOnWindowFocus  | true         |
      | retry                 | 3            |
    Then queries should use React Query
    And caching should be automatic
    And loading/error states should be managed

  @api-client @hooks
  Scenario: Create custom API hooks
    Given I want reusable data fetching
    When I create custom hooks:
      | hook              | purpose                    |
      | useLeagues        | Fetch user leagues         |
      | useLeague         | Fetch single league        |
      | useTeam           | Fetch team data            |
      | useRoster         | Fetch roster data          |
      | usePlayers        | Fetch player list          |
    Then hooks should encapsulate API logic
    And hooks should return loading/error states
    And data should be typed correctly

  # ==========================================
  # Base Component Library
  # ==========================================

  @components @structure
  Scenario: Establish component directory structure
    Given I am organizing components
    When I create component structure:
      | directory                 | purpose                    |
      | src/components/common     | Reusable UI components     |
      | src/components/layout     | Layout components          |
      | src/components/forms      | Form components            |
      | src/components/tables     | Table components           |
      | src/components/modals     | Modal dialogs              |
      | src/components/navigation | Navigation components      |
    Then structure should be organized
    And components should be discoverable

  @components @patterns
  Scenario: Implement component patterns
    Given consistent patterns are needed
    When I establish patterns:
      | pattern           | implementation           |
      | composition       | Children and slots       |
      | controlled        | Value and onChange       |
      | forwarded_refs    | forwardRef usage         |
      | compound          | Parent.Child pattern     |
    Then patterns should be consistent
    And components should be composable

  @components @loading
  Scenario: Create loading state components
    Given loading states are needed
    When I create loading components:
      | component         | usage                    |
      | Spinner           | Inline loading indicator |
      | PageLoader        | Full page loading        |
      | SkeletonCard      | Content placeholder      |
      | SkeletonTable     | Table placeholder        |
    Then loading states should display correctly
    And Cloudscape Spinner should be used

  @components @error-boundary
  Scenario: Implement error boundaries
    Given I need to catch rendering errors
    When I implement ErrorBoundary component
    Then component errors should be caught
    And fallback UI should display
    And error should be logged
    And recovery option should be provided

  @components @empty-states
  Scenario: Create empty state components
    Given empty states need consistent display
    When I create EmptyState component:
      | prop              | purpose                  |
      | title             | Empty state heading      |
      | description       | Explanation text         |
      | icon              | Visual indicator         |
      | action            | Call to action button    |
    Then empty states should be reusable
    And Cloudscape Box should be used

  @components @confirmation
  Scenario: Create confirmation dialog component
    Given confirmations are needed for destructive actions
    When I create ConfirmationDialog:
      | prop              | purpose                  |
      | title             | Dialog title             |
      | message           | Confirmation message     |
      | confirmLabel      | Confirm button text      |
      | cancelLabel       | Cancel button text       |
      | variant           | normal/warning/danger    |
    Then dialog should request confirmation
    And Cloudscape Modal should be used

  # ==========================================
  # State Management
  # ==========================================

  @state @context
  Scenario: Implement React Context for global state
    Given global state is needed
    When I create contexts:
      | context           | purpose                  |
      | AuthContext       | Authentication state     |
      | ThemeContext      | Theme preferences        |
      | NotificationContext| Notification management |
    Then contexts should provide state
    And consumers should access state
    And updates should trigger re-renders

  @state @auth
  Scenario: Implement authentication state
    Given authentication state is needed
    When I implement AuthContext:
      | state             | type                     |
      | user              | User object or null      |
      | isAuthenticated   | boolean                  |
      | isLoading         | boolean                  |
      | login             | async function           |
      | logout            | async function           |
    Then auth state should be accessible globally
    And login/logout should update state

  @state @persistence
  Scenario: Persist state to local storage
    Given some state should persist
    When I implement state persistence:
      | state             | storage        |
      | theme             | localStorage   |
      | user_preferences  | localStorage   |
      | session           | sessionStorage |
    Then state should persist across sessions
    And state should be restored on load

  # ==========================================
  # Testing Setup
  # ==========================================

  @testing @setup
  Scenario: Configure testing environment
    Given testing is needed
    When I configure testing tools:
      | tool              | purpose                  |
      | vitest            | Test runner              |
      | @testing-library/react | Component testing   |
      | @testing-library/jest-dom | DOM matchers     |
      | msw               | API mocking              |
    Then testing environment should work
    And tests should run successfully

  @testing @component
  Scenario: Write component tests
    Given components need testing
    When I write component tests:
      | test_type         | description              |
      | render            | Component renders        |
      | interaction       | User interactions work   |
      | props             | Props affect rendering   |
      | accessibility     | A11y requirements met    |
    Then tests should pass
    And coverage should be tracked

  @testing @mocking
  Scenario: Configure API mocking with MSW
    Given API calls need mocking
    When I configure MSW handlers:
      | endpoint          | response               |
      | GET /api/leagues  | Mock league list       |
      | GET /api/team     | Mock team data         |
      | POST /api/login   | Mock auth response     |
    Then API calls should be intercepted
    And mock responses should be returned

  # ==========================================
  # Development Experience
  # ==========================================

  @dx @linting
  Scenario: Configure ESLint for code quality
    Given code quality enforcement is needed
    When I configure ESLint:
      | config                  | purpose              |
      | eslint:recommended      | Base rules           |
      | @typescript-eslint      | TypeScript rules     |
      | react-hooks             | Hooks rules          |
      | jsx-a11y                | Accessibility rules  |
    Then linting should catch issues
    And rules should be enforced

  @dx @formatting
  Scenario: Configure Prettier for code formatting
    Given consistent formatting is needed
    When I configure Prettier:
      | option            | value    |
      | semi              | true     |
      | singleQuote       | true     |
      | tabWidth          | 2        |
      | trailingComma     | es5      |
    Then code should be formatted consistently
    And format on save should work

  @dx @husky
  Scenario: Configure pre-commit hooks
    Given pre-commit validation is needed
    When I configure Husky hooks:
      | hook              | action               |
      | pre-commit        | lint-staged          |
      | commit-msg        | commitlint           |
    Then commits should be validated
    And lint errors should block commits

  # ==========================================
  # Error Handling and Edge Cases
  # ==========================================

  @error-handling @network
  Scenario: Handle network errors gracefully
    Given network may be unavailable
    When network error occurs
    Then user-friendly error should display
    And retry option should be available
    And offline mode should be considered

  @error-handling @404
  Scenario: Handle 404 routes
    Given user may navigate to invalid routes
    When 404 route is matched
    Then NotFound component should render
    And navigation options should be provided
    And user should not see raw error

  @edge-case @slow-connection
  Scenario: Handle slow connections
    Given connection may be slow
    When response takes long time
    Then loading indicator should show
    And timeout should eventually trigger
    And user should be able to cancel

  @edge-case @concurrent-requests
  Scenario: Handle concurrent API requests
    Given multiple requests may fire
    When same request fires multiple times
    Then requests should be deduplicated
    And latest response should be used
    And race conditions should be avoided

  @edge-case @stale-data
  Scenario: Handle stale data scenarios
    Given data may become stale
    When component remounts
    Then data should be refetched if stale
    And cache should be invalidated appropriately
    And user should see fresh data
