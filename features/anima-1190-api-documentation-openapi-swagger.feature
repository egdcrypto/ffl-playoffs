@openapi @swagger @api-documentation @springboot
Feature: API Documentation with OpenAPI/Swagger
  As an API consumer
  I want comprehensive API documentation
  So that I can understand and integrate with the FFL Playoffs API

  Background:
    Given the Spring Boot application is running
    And SpringDoc OpenAPI is configured
    And Swagger UI is enabled

  # ==========================================
  # OpenAPI 3.0 Specification Generation
  # ==========================================

  @openapi @generation
  Scenario: Generate OpenAPI 3.0 specification
    Given the application has REST controllers annotated
    When the OpenAPI spec is generated
    Then the specification should conform to OpenAPI 3.0 format
    And the spec should be available at "/v3/api-docs"
    And the spec should be valid JSON or YAML

  @openapi @info
  Scenario: Configure API information
    Given I configure OpenAPI info:
      | field           | value                              |
      | title           | FFL Playoffs API                   |
      | version         | 1.0.0                              |
      | description     | Fantasy Football Playoff Manager API |
      | contact.name    | FFL Playoffs Team                  |
      | contact.email   | api@fflplayoffs.com                |
      | license.name    | Apache 2.0                         |
    Then the API info should appear in the spec
    And consumers should understand the API purpose

  @openapi @servers
  Scenario: Configure server URLs
    Given I configure server URLs:
      | url                              | description        |
      | https://api.fflplayoffs.com      | Production server  |
      | https://staging-api.fflplayoffs.com | Staging server  |
      | http://localhost:8080            | Development server |
    Then servers should be listed in the spec
    And consumers can select target environment

  @openapi @paths
  Scenario: Document API paths
    Given controllers define REST endpoints
    When OpenAPI processes the controllers
    Then all paths should be documented:
      | path                    | methods        |
      | /api/v1/leagues         | GET, POST      |
      | /api/v1/leagues/{id}    | GET, PUT, DELETE |
      | /api/v1/teams           | GET, POST      |
      | /api/v1/teams/{id}      | GET, PUT, DELETE |
      | /api/v1/matchups        | GET            |
    And each path should have operation details

  @openapi @components
  Scenario: Document API components/schemas
    Given DTOs are defined with annotations
    When OpenAPI processes the schemas
    Then schemas should be documented:
      | schema          | type    | properties            |
      | League          | object  | id, name, teams, etc  |
      | Team            | object  | id, name, roster, etc |
      | Player          | object  | id, name, stats, etc  |
      | ErrorResponse   | object  | code, message, details|
    And schemas should include property types and constraints

  @openapi @security
  Scenario: Document API security schemes
    Given the API uses JWT authentication
    When I configure security schemes:
      """
      @SecurityScheme(
          name = "bearerAuth",
          type = SecuritySchemeType.HTTP,
          bearerFormat = "JWT",
          scheme = "bearer"
      )
      """
    Then security scheme should appear in spec
    And endpoints should reference the security scheme

  # ==========================================
  # Spring Boot Annotations
  # ==========================================

  @annotations @operation
  Scenario: Document operations with @Operation
    Given I annotate controller methods:
      """
      @Operation(
          summary = "Get all leagues",
          description = "Retrieves a paginated list of all leagues the user has access to",
          operationId = "getLeagues"
      )
      @GetMapping("/leagues")
      public Page<LeagueDTO> getLeagues(Pageable pageable) { ... }
      """
    Then operation summary should appear in docs
    And operation description should be detailed

  @annotations @parameter
  Scenario: Document parameters with @Parameter
    Given I annotate parameters:
      """
      @Operation(summary = "Get league by ID")
      @GetMapping("/leagues/{id}")
      public LeagueDTO getLeague(
          @Parameter(description = "League unique identifier", required = true)
          @PathVariable String id
      ) { ... }
      """
    Then parameter should be documented
    And required flag should be set

  @annotations @request-body
  Scenario: Document request body with @RequestBody
    Given I annotate request body:
      """
      @Operation(summary = "Create new league")
      @PostMapping("/leagues")
      public LeagueDTO createLeague(
          @io.swagger.v3.oas.annotations.parameters.RequestBody(
              description = "League creation request",
              required = true,
              content = @Content(schema = @Schema(implementation = CreateLeagueRequest.class))
          )
          @RequestBody CreateLeagueRequest request
      ) { ... }
      """
    Then request body schema should be documented
    And content type should be specified

  @annotations @responses
  Scenario: Document responses with @ApiResponses
    Given I annotate responses:
      """
      @ApiResponses({
          @ApiResponse(responseCode = "200", description = "Successfully retrieved league",
              content = @Content(schema = @Schema(implementation = LeagueDTO.class))),
          @ApiResponse(responseCode = "404", description = "League not found",
              content = @Content(schema = @Schema(implementation = ErrorResponse.class))),
          @ApiResponse(responseCode = "401", description = "Unauthorized")
      })
      """
    Then all response codes should be documented
    And response schemas should be linked

  @annotations @schema
  Scenario: Document DTOs with @Schema
    Given I annotate DTO classes:
      """
      @Schema(description = "League data transfer object")
      public class LeagueDTO {
          @Schema(description = "Unique identifier", example = "league-123")
          private String id;

          @Schema(description = "League name", example = "Championship League", required = true)
          private String name;

          @Schema(description = "Maximum number of teams", minimum = "4", maximum = "20")
          private Integer maxTeams;
      }
      """
    Then schema properties should be documented
    And examples should be included

  @annotations @hidden
  Scenario: Hide internal endpoints
    Given some endpoints are internal only
    When I annotate with @Hidden:
      """
      @Hidden
      @GetMapping("/internal/health")
      public HealthStatus internalHealth() { ... }
      """
    Then hidden endpoints should not appear in docs
    And only public API should be documented

  @annotations @tags
  Scenario: Organize endpoints with @Tag
    Given endpoints need logical grouping
    When I annotate controllers with @Tag:
      """
      @Tag(name = "Leagues", description = "League management operations")
      @RestController
      @RequestMapping("/api/v1/leagues")
      public class LeagueController { ... }
      """
    Then endpoints should be grouped by tag
    And tag descriptions should appear

  # ==========================================
  # Swagger UI Configuration
  # ==========================================

  @swagger-ui @access
  Scenario: Access Swagger UI
    Given Swagger UI is enabled
    When I navigate to "/swagger-ui.html"
    Then Swagger UI should load
    And it should display the API documentation
    And interactive features should work

  @swagger-ui @customization
  Scenario: Customize Swagger UI appearance
    Given I configure Swagger UI:
      | setting              | value                    |
      | docExpansion         | none                     |
      | operationsSorter     | alpha                    |
      | tagsSorter           | alpha                    |
      | displayRequestDuration| true                    |
      | filter               | true                     |
    Then UI should reflect customizations
    And user experience should be improved

  @swagger-ui @try-it-out
  Scenario: Execute API calls from Swagger UI
    Given I am viewing an endpoint in Swagger UI
    When I click "Try it out"
    And I provide required parameters
    And I execute the request
    Then the request should be sent to the server
    And the response should be displayed
    And response headers should be visible

  @swagger-ui @authentication
  Scenario: Authenticate in Swagger UI
    Given I have a JWT token
    When I click "Authorize" button
    And I enter the bearer token
    And I apply authorization
    Then subsequent requests should include the token
    And authenticated endpoints should work

  @swagger-ui @models
  Scenario: View model schemas in Swagger UI
    Given I am using Swagger UI
    When I expand the "Schemas" section
    Then all DTO schemas should be displayed
    And schema properties should be visible
    And I can expand nested schemas

  @swagger-ui @deep-linking
  Scenario: Deep link to specific operations
    Given Swagger UI supports deep linking
    When I navigate to "/swagger-ui.html#/Leagues/getLeagues"
    Then the specific operation should be expanded
    And I should see the operation details
    And I can share this link

  # ==========================================
  # API Versioning Documentation
  # ==========================================

  @versioning @url-path
  Scenario: Document URL path versioning
    Given API uses path-based versioning
    When endpoints are defined:
      | path               | version |
      | /api/v1/leagues    | v1      |
      | /api/v2/leagues    | v2      |
    Then both versions should be documented
    And version differences should be clear

  @versioning @multiple-specs
  Scenario: Generate separate specs per version
    Given I configure multiple OpenAPI groups:
      """
      @Bean
      public GroupedOpenApi v1Api() {
          return GroupedOpenApi.builder()
              .group("v1")
              .pathsToMatch("/api/v1/**")
              .build();
      }

      @Bean
      public GroupedOpenApi v2Api() {
          return GroupedOpenApi.builder()
              .group("v2")
              .pathsToMatch("/api/v2/**")
              .build();
      }
      """
    Then separate specs should be available
    And Swagger UI should have version selector

  @versioning @deprecation
  Scenario: Document deprecated endpoints
    Given some endpoints are deprecated
    When I annotate with @Deprecated:
      """
      @Deprecated
      @Operation(
          summary = "Get leagues (deprecated)",
          deprecated = true,
          description = "Use /api/v2/leagues instead"
      )
      @GetMapping("/api/v1/leagues")
      public List<LeagueDTO> getLeaguesV1() { ... }
      """
    Then deprecated endpoints should be marked
    And migration guidance should be provided

  @versioning @changelog
  Scenario: Include version changelog
    Given API versions have changes
    When I document version differences:
      | version | changes                              |
      | v2.0    | Added pagination to all list endpoints |
      | v1.1    | Added team roster management         |
      | v1.0    | Initial API release                  |
    Then changelog should be accessible
    And developers should understand changes

  # ==========================================
  # Example Requests and Responses
  # ==========================================

  @examples @request
  Scenario: Provide request examples
    Given I annotate with request examples:
      """
      @io.swagger.v3.oas.annotations.parameters.RequestBody(
          content = @Content(
              examples = @ExampleObject(
                  name = "Create League",
                  value = """
                      {
                          "name": "Championship League",
                          "maxTeams": 12,
                          "scoringType": "PPR",
                          "draftType": "SNAKE"
                      }
                      """
              )
          )
      )
      """
    Then request example should appear in docs
    And consumers can copy the example

  @examples @response
  Scenario: Provide response examples
    Given I annotate with response examples:
      """
      @ApiResponse(
          responseCode = "200",
          content = @Content(
              examples = @ExampleObject(
                  name = "League Response",
                  value = """
                      {
                          "id": "league-123",
                          "name": "Championship League",
                          "maxTeams": 12,
                          "currentTeams": 8,
                          "status": "ACTIVE"
                      }
                      """
              )
          )
      )
      """
    Then response example should appear in docs
    And expected format should be clear

  @examples @multiple
  Scenario: Provide multiple examples per endpoint
    Given endpoint has different use cases
    When I provide multiple examples:
      """
      @Content(
          examples = {
              @ExampleObject(name = "Success", value = "..."),
              @ExampleObject(name = "Validation Error", value = "..."),
              @ExampleObject(name = "Not Found", value = "...")
          }
      )
      """
    Then all examples should be selectable
    And different scenarios should be demonstrated

  @examples @external
  Scenario: Reference external example files
    Given examples are in separate files
    When I reference external examples:
      | file                              | content      |
      | examples/create-league.json       | Request body |
      | examples/league-response.json     | Response     |
    Then examples should load from files
    And maintenance should be easier

  @examples @generated
  Scenario: Auto-generate examples from schemas
    Given schemas have example annotations
    When OpenAPI generates the spec
    Then examples should be created from schema examples
    And combined examples should be realistic

  # ==========================================
  # Error Response Documentation
  # ==========================================

  @errors @standard
  Scenario: Document standard error responses
    Given standard error format is defined
    When I document error responses:
      | code | description                | schema        |
      | 400  | Bad Request - Invalid input| ErrorResponse |
      | 401  | Unauthorized              | ErrorResponse |
      | 403  | Forbidden                 | ErrorResponse |
      | 404  | Resource Not Found        | ErrorResponse |
      | 500  | Internal Server Error     | ErrorResponse |
    Then common errors should be documented globally
    And error schema should be consistent

  @errors @validation
  Scenario: Document validation error details
    Given validation errors have specific format
    When I document validation response:
      """
      @Schema(description = "Validation error response")
      public class ValidationErrorResponse {
          @Schema(description = "Error code", example = "VALIDATION_ERROR")
          private String code;

          @Schema(description = "List of field errors")
          private List<FieldError> errors;
      }

      public class FieldError {
          @Schema(description = "Field name", example = "name")
          private String field;

          @Schema(description = "Error message", example = "Name is required")
          private String message;
      }
      """
    Then validation error format should be clear
    And field-level errors should be documented

  @errors @business
  Scenario: Document business-specific errors
    Given domain has specific error codes
    When I document business errors:
      | code              | description                    | http_status |
      | LEAGUE_FULL       | League has reached max teams   | 400         |
      | DRAFT_IN_PROGRESS | Cannot modify during draft     | 409         |
      | PLAYER_LOCKED     | Player is locked for gameday   | 400         |
    Then business errors should be documented
    And consumers should understand error handling

  # ==========================================
  # Pagination Documentation
  # ==========================================

  @pagination @parameters
  Scenario: Document pagination parameters
    Given list endpoints support pagination
    When I document pagination:
      """
      @Parameter(name = "page", description = "Page number (0-indexed)", example = "0")
      @Parameter(name = "size", description = "Page size", example = "20")
      @Parameter(name = "sort", description = "Sort field and direction", example = "name,asc")
      """
    Then pagination parameters should be documented
    And default values should be shown

  @pagination @response
  Scenario: Document paginated response format
    Given paginated responses follow Spring format
    When I document Page response:
      """
      @Schema(description = "Paginated response")
      public class PageResponse<T> {
          @Schema(description = "Content items")
          private List<T> content;

          @Schema(description = "Total elements", example = "100")
          private long totalElements;

          @Schema(description = "Total pages", example = "5")
          private int totalPages;

          @Schema(description = "Current page", example = "0")
          private int number;
      }
      """
    Then pagination response format should be clear
    And consumers should understand navigation

  # ==========================================
  # Authentication Documentation
  # ==========================================

  @auth @oauth2
  Scenario: Document OAuth2 flow
    Given API uses OAuth2 with Google
    When I configure OAuth2 documentation:
      """
      @SecurityScheme(
          name = "oauth2",
          type = SecuritySchemeType.OAUTH2,
          flows = @OAuthFlows(
              authorizationCode = @OAuthFlow(
                  authorizationUrl = "https://accounts.google.com/o/oauth2/auth",
                  tokenUrl = "https://oauth2.googleapis.com/token",
                  scopes = {
                      @OAuthScope(name = "openid", description = "OpenID Connect"),
                      @OAuthScope(name = "email", description = "Email address")
                  }
              )
          )
      )
      """
    Then OAuth2 flow should be documented
    And scopes should be described

  @auth @api-key
  Scenario: Document API key authentication
    Given some endpoints accept API keys
    When I configure API key documentation:
      """
      @SecurityScheme(
          name = "apiKey",
          type = SecuritySchemeType.APIKEY,
          in = SecuritySchemeIn.HEADER,
          paramName = "X-API-Key"
      )
      """
    Then API key usage should be documented
    And header name should be specified

  @auth @per-endpoint
  Scenario: Document per-endpoint security
    Given endpoints have different auth requirements
    When I document security requirements:
      | endpoint           | security      | description              |
      | GET /leagues       | bearerAuth    | Requires JWT             |
      | GET /health        | none          | Public endpoint          |
      | POST /admin/*      | bearerAuth + admin | Requires admin role  |
    Then security requirements should be per-endpoint
    And public endpoints should be marked

  # ==========================================
  # Export and Integration
  # ==========================================

  @export @json
  Scenario: Export OpenAPI spec as JSON
    Given OpenAPI spec is generated
    When I request "/v3/api-docs"
    Then JSON spec should be returned
    And spec should be downloadable
    And spec should be valid OpenAPI 3.0

  @export @yaml
  Scenario: Export OpenAPI spec as YAML
    Given YAML export is configured
    When I request "/v3/api-docs.yaml"
    Then YAML spec should be returned
    And spec should be human-readable
    And spec should be equivalent to JSON

  @export @static
  Scenario: Generate static spec at build time
    Given I want spec in source control
    When I configure Maven/Gradle plugin:
      """
      <plugin>
          <groupId>org.springdoc</groupId>
          <artifactId>springdoc-openapi-maven-plugin</artifactId>
          <executions>
              <execution>
                  <phase>integration-test</phase>
                  <goals>
                      <goal>generate</goal>
                  </goals>
              </execution>
          </executions>
      </plugin>
      """
    Then spec should be generated during build
    And spec should be committed to repo

  @integration @postman
  Scenario: Import into Postman
    Given OpenAPI spec is available
    When I import into Postman
    Then collection should be created
    And all endpoints should be imported
    And examples should become requests

  @integration @code-gen
  Scenario: Generate client SDKs
    Given OpenAPI spec is available
    When I use OpenAPI Generator:
      | language    | output                    |
      | typescript  | TypeScript/Axios client   |
      | java        | Java client               |
      | python      | Python client             |
    Then client code should be generated
    And clients should be usable

  # ==========================================
  # Validation and Quality
  # ==========================================

  @validation @spec
  Scenario: Validate OpenAPI spec
    Given OpenAPI spec is generated
    When I validate with tools:
      | tool              | check                    |
      | swagger-parser    | Schema validation        |
      | spectral          | Linting rules            |
      | openapi-diff      | Breaking change detection|
    Then spec should pass validation
    And no linting errors should exist

  @validation @coverage
  Scenario: Verify documentation coverage
    Given all endpoints should be documented
    When I check documentation coverage
    Then all controllers should have @Operation
    And all parameters should have @Parameter
    And all responses should have @ApiResponse
    And coverage report should be generated

  @validation @breaking-changes
  Scenario: Detect breaking API changes
    Given previous spec version exists
    When I compare with current spec
    Then breaking changes should be detected:
      | change_type           | severity  |
      | removed_endpoint      | breaking  |
      | removed_field         | breaking  |
      | added_required_field  | breaking  |
      | changed_type          | breaking  |
    And report should list all changes

  # ==========================================
  # Configuration and Customization
  # ==========================================

  @config @springdoc
  Scenario: Configure SpringDoc properties
    Given I am customizing SpringDoc
    When I set application properties:
      """
      springdoc.api-docs.enabled=true
      springdoc.swagger-ui.enabled=true
      springdoc.swagger-ui.path=/swagger-ui.html
      springdoc.api-docs.path=/v3/api-docs
      springdoc.packages-to-scan=com.ffl.playoffs.api
      springdoc.paths-to-match=/api/**
      """
    Then SpringDoc should use custom configuration
    And only specified packages should be scanned

  @config @security
  Scenario: Secure API documentation in production
    Given documentation should be protected
    When I configure security:
      | environment | swagger_enabled | docs_path    |
      | development | true            | public       |
      | production  | false           | authenticated|
    Then documentation should be appropriately secured
    And production should not expose swagger-ui publicly

  @config @cors
  Scenario: Configure CORS for Swagger UI
    Given Swagger UI is on different origin
    When I configure CORS:
      """
      springdoc.swagger-ui.csrf.enabled=true
      springdoc.swagger-ui.urls-primary-name=API
      """
    Then Swagger UI should work cross-origin
    And security should not be compromised
