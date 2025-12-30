@docker @containerization @devops @infrastructure
Feature: Docker Containerization
  As a DevOps engineer
  I want to containerize Java API and frontend applications with multi-stage Dockerfiles
  So that I can deploy and run applications consistently across environments

  Background:
    Given Docker is installed and running
    And the project has a valid build configuration
    And container registry credentials are configured

  # =============================================================================
  # JAVA API DOCKERFILE
  # =============================================================================

  @dockerfile @java-api
  Scenario: Create multi-stage Dockerfile for Java API
    Given the Java API project uses Gradle
    When I create a multi-stage Dockerfile
    Then the Dockerfile should have stages:
      | Stage         | Base Image          | Purpose                        |
      | builder       | eclipse-temurin:21  | Build the application          |
      | runtime       | eclipse-temurin:21-jre | Run the application        |
    And the builder stage should:
      | Action                  | Description                      |
      | Copy Gradle files       | Copy build configuration         |
      | Download dependencies   | Cache dependencies layer         |
      | Copy source code        | Copy application source          |
      | Build application       | Run Gradle build                 |
    And the runtime stage should:
      | Action                  | Description                      |
      | Copy JAR only           | Copy built artifact              |
      | Set entrypoint          | Java -jar command                |
      | Expose port             | Application port 8080            |

  @dockerfile @java-api @optimization
  Scenario: Optimize Java API Docker image size
    Given the multi-stage Dockerfile is created
    When I build the Docker image
    Then the final image should:
      | Optimization            | Description                      |
      | Use JRE not JDK         | Smaller runtime image            |
      | Exclude build tools     | No Gradle in final image         |
      | Layer caching           | Dependencies cached separately   |
      | Minimal base            | Alpine or distroless if possible |
    And the image size should be under 300MB

  @dockerfile @java-api @configuration
  Scenario: Configure Java API container runtime
    Given the Java API Dockerfile is created
    When I define runtime configuration
    Then the container should support:
      | Configuration           | Method                           |
      | JVM heap size           | JAVA_OPTS environment variable   |
      | Spring profiles         | SPRING_PROFILES_ACTIVE env var   |
      | Database URL            | Environment variable injection   |
      | Port configuration      | SERVER_PORT env var              |
      | Timezone                | TZ environment variable          |

  @dockerfile @java-api @health
  Scenario: Define health check for Java API container
    Given the Java API container is running
    When I configure health checks
    Then the Dockerfile should include:
      | Health Check            | Configuration                    |
      | Endpoint                | /actuator/health                 |
      | Interval                | 30 seconds                       |
      | Timeout                 | 10 seconds                       |
      | Retries                 | 3                                |
      | Start period            | 60 seconds                       |

  @dockerfile @java-api @security
  Scenario: Apply security best practices to Java API image
    Given the Java API Dockerfile is created
    When I apply security hardening
    Then the image should:
      | Security Practice       | Implementation                   |
      | Non-root user           | Run as unprivileged user         |
      | Read-only filesystem    | Where possible                   |
      | No shell                | Distroless or remove shell       |
      | Minimal packages        | Only required dependencies       |
      | Vulnerability scanning  | Pass security scan               |

  # =============================================================================
  # FRONTEND DOCKERFILE
  # =============================================================================

  @dockerfile @frontend
  Scenario: Create multi-stage Dockerfile for frontend
    Given the frontend project uses Node.js and React
    When I create a multi-stage Dockerfile
    Then the Dockerfile should have stages:
      | Stage         | Base Image          | Purpose                        |
      | builder       | node:20-alpine      | Build the application          |
      | runtime       | nginx:alpine        | Serve static files             |
    And the builder stage should:
      | Action                  | Description                      |
      | Copy package files      | Copy package.json, lock file     |
      | Install dependencies    | npm ci for reproducible builds   |
      | Copy source code        | Copy application source          |
      | Build application       | npm run build                    |
    And the runtime stage should:
      | Action                  | Description                      |
      | Copy build output       | Copy dist/build folder           |
      | Copy nginx config       | Custom nginx configuration       |
      | Expose port             | Port 80                          |

  @dockerfile @frontend @nginx
  Scenario: Configure nginx for frontend serving
    Given the frontend Dockerfile uses nginx
    When I configure nginx
    Then the nginx configuration should include:
      | Configuration           | Purpose                          |
      | Gzip compression        | Reduce transfer size             |
      | Cache headers           | Static asset caching             |
      | SPA routing             | Fallback to index.html           |
      | Security headers        | X-Frame-Options, CSP, etc.       |
      | API proxy               | Proxy /api to backend            |

  @dockerfile @frontend @optimization
  Scenario: Optimize frontend Docker image
    Given the frontend multi-stage Dockerfile is created
    When I build the Docker image
    Then the final image should:
      | Optimization            | Description                      |
      | No node_modules         | Build artifacts only             |
      | Minimal nginx           | Alpine-based nginx               |
      | Compressed assets       | Gzip pre-compression             |
      | Layer caching           | Dependencies cached separately   |
    And the image size should be under 50MB

  @dockerfile @frontend @environment
  Scenario: Configure frontend for different environments
    Given the frontend application needs environment configuration
    When I configure environment handling
    Then the container should support:
      | Configuration           | Method                           |
      | API URL                 | Environment variable at runtime  |
      | Feature flags           | Environment-based configuration  |
      | Analytics               | Environment-specific keys        |
    And environment variables should be injected at container start

  # =============================================================================
  # DOCKER COMPOSE FOR LOCAL DEVELOPMENT
  # =============================================================================

  @compose @local-development
  Scenario: Create docker-compose for local development
    Given I need a local development environment
    When I create docker-compose.yml
    Then the compose file should define services:
      | Service         | Image/Build           | Purpose                    |
      | api             | ./api                 | Java API application       |
      | frontend        | ./frontend            | React frontend             |
      | mongodb         | mongo:7               | MongoDB database           |
      | mongo-express   | mongo-express         | MongoDB admin UI           |
    And each service should have appropriate configuration

  @compose @mongodb
  Scenario: Configure MongoDB service in docker-compose
    Given the docker-compose includes MongoDB
    When I configure the MongoDB service
    Then the configuration should include:
      | Setting                 | Value/Purpose                    |
      | Image                   | mongo:7                          |
      | Port mapping            | 27017:27017                      |
      | Volume                  | Persistent data storage          |
      | Environment             | Root username and password       |
      | Init scripts            | Database initialization          |
      | Health check            | MongoDB ping command             |

  @compose @mongodb @initialization
  Scenario: Initialize MongoDB with seed data
    Given MongoDB container is starting
    When initialization scripts run
    Then the database should be configured with:
      | Configuration           | Description                      |
      | Database creation       | Create application database      |
      | User creation           | Create application user          |
      | Collections             | Create required collections      |
      | Indexes                 | Create necessary indexes         |
      | Seed data               | Optional development data        |

  @compose @networking
  Scenario: Configure docker-compose networking
    Given multiple services need to communicate
    When I configure networking
    Then the compose file should define:
      | Network Configuration   | Purpose                          |
      | Custom network          | Isolated network for services    |
      | Service discovery       | Services reachable by name       |
      | Port exposure           | Only necessary ports exposed     |
      | Internal communication  | Services communicate internally  |

  @compose @volumes
  Scenario: Configure docker-compose volumes
    Given services need persistent storage
    When I configure volumes
    Then the compose file should define:
      | Volume                  | Purpose                          |
      | mongodb-data            | MongoDB data persistence         |
      | api-logs                | Application log storage          |
      | gradle-cache            | Gradle dependency cache          |
      | node-modules            | Node.js dependency cache         |

  @compose @environment
  Scenario: Configure environment variables in docker-compose
    Given services need environment configuration
    When I configure environment variables
    Then the compose file should support:
      | Method                  | Use Case                         |
      | .env file               | Default development values       |
      | environment section     | Service-specific variables       |
      | env_file                | External environment files       |
      | Variable interpolation  | Dynamic configuration            |

  @compose @development
  Scenario: Configure hot reload for development
    Given developers need fast feedback
    When I configure development mode
    Then the compose file should support:
      | Feature                 | Configuration                    |
      | Source mounting         | Mount source code as volume      |
      | Hot reload              | Enable file watching             |
      | Debug ports             | Expose debug ports               |
      | Development profiles    | Separate dev configuration       |

  @compose @dependencies
  Scenario: Configure service dependencies
    Given services have startup dependencies
    When I configure depends_on
    Then the compose file should define:
      | Service         | Depends On        | Condition            |
      | api             | mongodb           | service_healthy      |
      | frontend        | api               | service_started      |
      | mongo-express   | mongodb           | service_healthy      |

  # =============================================================================
  # BUILD AND PUSH
  # =============================================================================

  @build @java-api
  Scenario: Build Java API Docker image
    Given the Java API Dockerfile exists
    When I run docker build
    Then the build should:
      | Step                    | Verification                     |
      | Download dependencies   | Use cached layers when possible  |
      | Compile source          | Successful compilation           |
      | Run tests               | All tests pass                   |
      | Create JAR              | Executable JAR created           |
      | Create image            | Image tagged correctly           |

  @build @frontend
  Scenario: Build frontend Docker image
    Given the frontend Dockerfile exists
    When I run docker build
    Then the build should:
      | Step                    | Verification                     |
      | Install dependencies    | npm ci succeeds                  |
      | Build assets            | Production build created         |
      | Optimize assets         | Minified and compressed          |
      | Create image            | Image tagged correctly           |

  @build @tagging
  Scenario: Tag Docker images appropriately
    Given Docker images are built
    When I tag images
    Then tags should follow convention:
      | Tag Format              | Example                          |
      | Latest                  | app:latest                       |
      | Git SHA                 | app:abc1234                      |
      | Semantic version        | app:1.2.3                        |
      | Branch name             | app:feature-xyz                  |
      | Timestamp               | app:20240115-120000              |

  @build @registry
  Scenario: Push images to container registry
    Given Docker images are built and tagged
    When I push to container registry
    Then the push should:
      | Action                  | Verification                     |
      | Authenticate            | Login to registry succeeds       |
      | Push layers             | All layers uploaded              |
      | Push manifest           | Image manifest uploaded          |
      | Verify                  | Image pullable from registry     |

  @build @caching
  Scenario: Optimize build with layer caching
    Given I am building Docker images frequently
    When I configure build caching
    Then the build should use:
      | Caching Strategy        | Benefit                          |
      | BuildKit cache          | Faster incremental builds        |
      | Dependency layer        | Reuse unchanged dependencies     |
      | Multi-stage artifacts   | Share between stages             |
      | Registry cache          | Pull cached layers               |

  # =============================================================================
  # CONTAINER RUNTIME
  # =============================================================================

  @runtime @startup
  Scenario: Container startup behavior
    Given a container is starting
    When the container initializes
    Then startup should:
      | Behavior                | Description                      |
      | Log startup             | Clear startup logging            |
      | Wait for dependencies   | Check required services          |
      | Load configuration      | Read environment variables       |
      | Initialize application  | Complete app initialization      |
      | Report healthy          | Health check passes              |

  @runtime @shutdown
  Scenario: Container graceful shutdown
    Given a container is running
    When the container receives SIGTERM
    Then shutdown should:
      | Behavior                | Description                      |
      | Stop accepting requests | Close incoming connections       |
      | Complete in-flight      | Finish current requests          |
      | Close connections       | Close database connections       |
      | Flush logs              | Write remaining logs             |
      | Exit cleanly            | Exit code 0                      |

  @runtime @logging
  Scenario: Container logging configuration
    Given containers are running
    When I configure logging
    Then logs should:
      | Configuration           | Description                      |
      | Write to stdout         | Docker logging driver captures   |
      | JSON format             | Structured log output            |
      | Include context         | Request ID, user ID, etc.        |
      | Log level               | Configurable via environment     |
      | No sensitive data       | Mask passwords, tokens           |

  @runtime @resources
  Scenario: Container resource limits
    Given containers need resource management
    When I configure resource limits
    Then containers should have:
      | Resource                | Configuration                    |
      | Memory limit            | Prevent OOM issues               |
      | Memory reservation      | Guaranteed memory                |
      | CPU limit               | Fair CPU sharing                 |
      | CPU reservation         | Guaranteed CPU                   |

  # =============================================================================
  # DOCKER COMPOSE COMMANDS
  # =============================================================================

  @compose @commands
  Scenario: Common docker-compose operations
    Given docker-compose.yml is configured
    When I use docker-compose
    Then I should be able to:
      | Command                 | Purpose                          |
      | docker-compose up       | Start all services               |
      | docker-compose up -d    | Start in background              |
      | docker-compose down     | Stop and remove containers       |
      | docker-compose logs     | View service logs                |
      | docker-compose ps       | List running services            |
      | docker-compose exec     | Execute command in container     |
      | docker-compose build    | Rebuild images                   |

  @compose @profiles
  Scenario: Use docker-compose profiles
    Given different development scenarios exist
    When I configure profiles
    Then profiles should support:
      | Profile                 | Services Included                |
      | default                 | api, frontend, mongodb           |
      | full                    | All services including tools     |
      | backend-only            | api, mongodb                     |
      | debug                   | Services with debug configuration|

  @compose @override
  Scenario: Override docker-compose for environments
    Given base docker-compose.yml exists
    When I need environment-specific configuration
    Then I should use:
      | File                           | Purpose                    |
      | docker-compose.yml             | Base configuration         |
      | docker-compose.override.yml    | Local development overrides|
      | docker-compose.prod.yml        | Production configuration   |
      | docker-compose.test.yml        | Testing configuration      |

  # =============================================================================
  # SECURITY
  # =============================================================================

  @security @secrets
  Scenario: Manage secrets in Docker
    Given containers need sensitive configuration
    When I configure secrets
    Then secrets should be handled:
      | Method                  | Use Case                         |
      | Docker secrets          | Production secret management     |
      | Environment variables   | Development (not production)     |
      | .env file               | Local development only           |
      | External secret manager | Production integration           |

  @security @scanning
  Scenario: Scan Docker images for vulnerabilities
    Given Docker images are built
    When I run security scanning
    Then the scan should:
      | Check                   | Description                      |
      | Base image CVEs         | Known vulnerabilities            |
      | Dependency CVEs         | Application dependencies         |
      | Configuration issues    | Dockerfile best practices        |
      | Secrets detection       | No hardcoded secrets             |
    And critical vulnerabilities should fail the build

  @security @network
  Scenario: Secure container networking
    Given containers are networked
    When I configure network security
    Then the configuration should:
      | Security Measure        | Implementation                   |
      | Minimal port exposure   | Only required ports              |
      | Internal network        | Backend not directly accessible  |
      | TLS communication       | Encrypted internal communication |
      | Network policies        | Restrict container communication |

  # =============================================================================
  # MONITORING AND OBSERVABILITY
  # =============================================================================

  @monitoring @health
  Scenario: Monitor container health
    Given containers are running
    When I check health status
    Then I should see:
      | Health Information      | Source                           |
      | Container status        | Docker inspect                   |
      | Health check result     | HEALTHCHECK output               |
      | Resource usage          | Docker stats                     |
      | Uptime                  | Container start time             |

  @monitoring @metrics
  Scenario: Expose container metrics
    Given containers need monitoring
    When I configure metrics
    Then containers should expose:
      | Metric Type             | Endpoint/Method                  |
      | JVM metrics             | /actuator/prometheus             |
      | Application metrics     | Custom metrics endpoint          |
      | Container metrics       | Docker stats API                 |
      | Nginx metrics           | nginx-prometheus-exporter        |

  @monitoring @logging-aggregation
  Scenario: Aggregate container logs
    Given multiple containers are running
    When I configure log aggregation
    Then logs should be:
      | Configuration           | Description                      |
      | Centralized             | Sent to logging service          |
      | Searchable              | Indexed for queries              |
      | Correlated              | Request ID across services       |
      | Retained                | Appropriate retention period     |

  # =============================================================================
  # CI/CD INTEGRATION
  # =============================================================================

  @cicd @build
  Scenario: Integrate Docker build in CI/CD
    Given CI/CD pipeline exists
    When I configure Docker build step
    Then the pipeline should:
      | Step                    | Configuration                    |
      | Build images            | docker build command             |
      | Run tests               | In container or during build     |
      | Scan images             | Security scanning                |
      | Push images             | To container registry            |
      | Tag appropriately       | Based on branch/version          |

  @cicd @deploy
  Scenario: Deploy containers from CI/CD
    Given CI/CD pipeline builds images
    When deployment is triggered
    Then the pipeline should:
      | Step                    | Action                           |
      | Pull latest image       | From container registry          |
      | Stop old containers     | Graceful shutdown                |
      | Start new containers    | With new image                   |
      | Verify health           | Wait for healthy status          |
      | Rollback if needed      | On failure, revert               |

  # =============================================================================
  # ERROR HANDLING
  # =============================================================================

  @error @build-failure
  Scenario: Handle Docker build failures
    Given a Docker build fails
    When I analyze the failure
    Then I should see:
      | Information             | Description                      |
      | Failed step             | Which stage/step failed          |
      | Error message           | Clear error description          |
      | Build context           | What was being built             |
      | Suggestions             | How to fix common issues         |

  @error @runtime-failure
  Scenario: Handle container runtime failures
    Given a container fails to start
    When I troubleshoot
    Then I should check:
      | Check                   | Command/Method                   |
      | Container logs          | docker logs <container>          |
      | Exit code               | docker inspect                   |
      | Health check            | HEALTHCHECK status               |
      | Resource constraints    | Memory/CPU limits                |
      | Dependencies            | Required services available      |

  @error @network-failure
  Scenario: Handle container network issues
    Given containers cannot communicate
    When I troubleshoot networking
    Then I should verify:
      | Check                   | Method                           |
      | Network exists          | docker network ls                |
      | Containers connected    | docker network inspect           |
      | DNS resolution          | Ping service by name             |
      | Port exposure           | Port mapping correct             |
      | Firewall rules          | No blocking rules                |

  # =============================================================================
  # DOCUMENTATION
  # =============================================================================

  @documentation @readme
  Scenario: Document Docker usage
    Given Docker configuration is complete
    When I create documentation
    Then documentation should include:
      | Section                 | Content                          |
      | Prerequisites           | Docker, docker-compose versions  |
      | Quick start             | Commands to run locally          |
      | Configuration           | Environment variables            |
      | Troubleshooting         | Common issues and solutions      |
      | Development             | Hot reload, debugging            |

  @documentation @makefile
  Scenario: Create Makefile for Docker commands
    Given Docker commands are complex
    When I create a Makefile
    Then the Makefile should include targets:
      | Target                  | Command                          |
      | build                   | Build all images                 |
      | up                      | Start all services               |
      | down                    | Stop all services                |
      | logs                    | View logs                        |
      | clean                   | Remove containers and volumes    |
      | shell-api               | Shell into API container         |
      | shell-mongo             | Shell into MongoDB               |
