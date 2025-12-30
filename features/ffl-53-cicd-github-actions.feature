@cicd @github-actions @devops @automation
Feature: CI/CD Pipeline with GitHub Actions
  As a DevOps engineer
  I want to set up GitHub Actions workflows for build, test, lint, security scan, and deployment
  So that I can automate the software delivery pipeline with staging and production environments

  Background:
    Given the project is hosted on GitHub
    And GitHub Actions is enabled for the repository
    And required secrets are configured in GitHub repository settings
    And the project has valid build configurations

  # =============================================================================
  # WORKFLOW STRUCTURE
  # =============================================================================

  @workflow @structure
  Scenario: Define core workflow files
    Given I am setting up GitHub Actions
    When I create workflow files
    Then the following workflows should exist:
      | Workflow File           | Purpose                              |
      | ci.yml                  | Build and test on every push/PR      |
      | deploy-staging.yml      | Deploy to staging environment        |
      | deploy-production.yml   | Deploy to production environment     |
      | security-scan.yml       | Security and vulnerability scanning  |
      | release.yml             | Release and version management       |
    And workflows should be in .github/workflows directory

  @workflow @triggers
  Scenario: Configure workflow triggers
    Given workflows need appropriate triggers
    When I configure workflow triggers
    Then triggers should be defined as:
      | Workflow           | Trigger Events                         |
      | ci.yml             | push, pull_request to main/develop     |
      | deploy-staging.yml | push to develop, workflow_dispatch     |
      | deploy-production.yml | push to main, workflow_dispatch     |
      | security-scan.yml  | schedule (daily), pull_request         |
      | release.yml        | push tags v*, workflow_dispatch        |

  @workflow @concurrency
  Scenario: Configure workflow concurrency
    Given multiple workflow runs may occur simultaneously
    When I configure concurrency settings
    Then each workflow should:
      | Setting                 | Configuration                    |
      | Concurrency group       | Based on branch/PR               |
      | Cancel in-progress      | Cancel previous runs on same ref |
      | Queue deployments       | Only one deploy at a time        |

  # =============================================================================
  # BUILD WORKFLOW
  # =============================================================================

  @build @java
  Scenario: Build Java API in CI workflow
    Given the CI workflow is triggered
    When the Java API build job runs
    Then the job should:
      | Step                    | Action                           |
      | Checkout code           | actions/checkout@v4              |
      | Set up Java             | actions/setup-java@v4 (JDK 21)   |
      | Cache Gradle            | Cache ~/.gradle directory        |
      | Build with Gradle       | ./gradlew build                  |
      | Upload artifacts        | Upload JAR and test reports      |
    And build should fail fast on errors

  @build @frontend
  Scenario: Build frontend in CI workflow
    Given the CI workflow is triggered
    When the frontend build job runs
    Then the job should:
      | Step                    | Action                           |
      | Checkout code           | actions/checkout@v4              |
      | Set up Node.js          | actions/setup-node@v4 (Node 20)  |
      | Cache npm               | Cache node_modules               |
      | Install dependencies    | npm ci                           |
      | Build application       | npm run build                    |
      | Upload artifacts        | Upload build output              |
    And build should fail fast on errors

  @build @docker
  Scenario: Build Docker images in CI workflow
    Given the CI workflow is triggered
    When the Docker build job runs
    Then the job should:
      | Step                    | Action                           |
      | Set up Docker Buildx    | docker/setup-buildx-action       |
      | Login to registry       | docker/login-action              |
      | Build API image         | docker/build-push-action         |
      | Build frontend image    | docker/build-push-action         |
      | Tag images              | Use git SHA and branch           |
    And images should use layer caching

  @build @caching
  Scenario: Optimize build with caching
    Given builds need to be fast
    When I configure caching
    Then caching should include:
      | Cache Target            | Key Strategy                     |
      | Gradle dependencies     | Hash of build.gradle files       |
      | npm dependencies        | Hash of package-lock.json        |
      | Docker layers           | BuildKit inline cache            |
      | Build outputs           | Artifacts between jobs           |
    And cache hit rate should be monitored

  # =============================================================================
  # TEST WORKFLOW
  # =============================================================================

  @test @unit
  Scenario: Run unit tests in CI workflow
    Given the CI workflow is triggered
    When the unit test job runs
    Then the job should:
      | Step                    | Action                           |
      | Run Java tests          | ./gradlew test                   |
      | Run frontend tests      | npm run test                     |
      | Generate coverage       | JaCoCo and Istanbul              |
      | Upload coverage         | Upload to Codecov                |
      | Upload test reports     | Store as artifacts               |

  @test @integration
  Scenario: Run integration tests in CI workflow
    Given the CI workflow is triggered
    When the integration test job runs
    Then the job should:
      | Step                    | Action                           |
      | Start dependencies      | Docker compose for MongoDB       |
      | Wait for services       | Health check wait                |
      | Run integration tests   | ./gradlew integrationTest        |
      | Collect logs            | On failure, capture logs         |
      | Cleanup                 | Stop containers                  |

  @test @e2e
  Scenario: Run end-to-end tests
    Given the application is deployed to staging
    When the E2E test job runs
    Then the job should:
      | Step                    | Action                           |
      | Set up Playwright       | Install Playwright browsers      |
      | Run E2E tests           | npx playwright test              |
      | Generate report         | HTML and video artifacts         |
      | Upload screenshots      | On failure                       |

  @test @coverage
  Scenario: Enforce test coverage thresholds
    Given tests have been executed
    When coverage is reported
    Then coverage should meet thresholds:
      | Metric                  | Minimum                          |
      | Line coverage           | 80%                              |
      | Branch coverage         | 75%                              |
      | Function coverage       | 80%                              |
    And PR should fail if below threshold

  @test @reporting
  Scenario: Publish test results to PR
    Given tests have completed
    When test results are published
    Then the PR should show:
      | Information             | Format                           |
      | Test summary            | Pass/fail count                  |
      | Coverage report         | Coverage percentage              |
      | Failed test details     | Test names and errors            |
      | Test duration           | Time taken                       |

  # =============================================================================
  # LINT AND CODE QUALITY
  # =============================================================================

  @lint @java
  Scenario: Lint Java code
    Given the CI workflow is triggered
    When the Java lint job runs
    Then the job should:
      | Step                    | Action                           |
      | Run Checkstyle          | ./gradlew checkstyleMain         |
      | Run SpotBugs            | ./gradlew spotbugsMain           |
      | Run PMD                 | ./gradlew pmdMain                |
      | Upload reports          | Store as artifacts               |
    And violations should be reported on PR

  @lint @frontend
  Scenario: Lint frontend code
    Given the CI workflow is triggered
    When the frontend lint job runs
    Then the job should:
      | Step                    | Action                           |
      | Run ESLint              | npm run lint                     |
      | Run Prettier            | npm run format:check             |
      | Run TypeScript check    | npm run typecheck                |
      | Report issues           | Annotations on PR                |

  @lint @commit
  Scenario: Validate commit messages
    Given a pull request is opened
    When the commit lint job runs
    Then commit messages should follow:
      | Convention              | Example                          |
      | Conventional commits    | feat: add new feature            |
      | Ticket reference        | ANIMA-123 or FFL-123             |
      | Max subject length      | 72 characters                    |
    And invalid commits should fail the check

  @lint @pr-title
  Scenario: Validate PR title
    Given a pull request is opened
    When the PR title check runs
    Then the title should:
      | Requirement             | Example                          |
      | Follow convention       | feat: description                |
      | Include ticket          | [ANIMA-123] description          |
      | Be descriptive          | Not just "fix"                   |

  # =============================================================================
  # SECURITY SCANNING
  # =============================================================================

  @security @dependency
  Scenario: Scan dependencies for vulnerabilities
    Given the security scan workflow runs
    When dependency scanning executes
    Then the following scans should run:
      | Scanner                 | Target                           |
      | Dependabot              | All dependencies                 |
      | npm audit               | Node.js dependencies             |
      | OWASP Dependency Check  | Java dependencies                |
      | Snyk                    | Container images                 |
    And critical vulnerabilities should fail the build

  @security @sast
  Scenario: Run static application security testing
    Given the security scan workflow runs
    When SAST scanning executes
    Then the following should be checked:
      | Check                   | Tool                             |
      | Code vulnerabilities    | CodeQL                           |
      | Secrets detection       | GitLeaks                         |
      | Security misconfig      | Semgrep                          |
    And findings should be reported to GitHub Security

  @security @container
  Scenario: Scan container images
    Given Docker images are built
    When container scanning runs
    Then the scan should check:
      | Check                   | Tool                             |
      | Image vulnerabilities   | Trivy                            |
      | Base image CVEs         | Trivy                            |
      | Misconfigurations       | Trivy                            |
    And high/critical findings should block deployment

  @security @scheduled
  Scenario: Run scheduled security scans
    Given security scans are scheduled
    When the scheduled workflow runs daily
    Then the scan should:
      | Action                  | Description                      |
      | Scan all dependencies   | Check for new vulnerabilities    |
      | Scan images             | Check deployed images            |
      | Create issues           | For new findings                 |
      | Notify team             | Slack/email notification         |

  # =============================================================================
  # STAGING DEPLOYMENT
  # =============================================================================

  @deploy @staging
  Scenario: Deploy to staging environment
    Given code is pushed to develop branch
    When the staging deployment workflow runs
    Then the deployment should:
      | Step                    | Action                           |
      | Run CI checks           | Build and test must pass         |
      | Build images            | Create deployment images         |
      | Push to registry        | Push to container registry       |
      | Deploy to staging       | Update staging environment       |
      | Run smoke tests         | Verify deployment                |
      | Notify team             | Slack notification               |

  @deploy @staging @approval
  Scenario: Manual approval for staging deployment
    Given staging deployment is configured
    When manual approval is required
    Then the workflow should:
      | Step                    | Action                           |
      | Create review request   | Request approval from reviewers  |
      | Wait for approval       | Pause until approved             |
      | Timeout after 24 hours  | Auto-cancel if not approved      |
      | Proceed on approval     | Continue deployment              |

  @deploy @staging @environment
  Scenario: Configure staging environment in GitHub
    Given staging environment exists
    When I configure environment settings
    Then the environment should have:
      | Setting                 | Configuration                    |
      | Environment name        | staging                          |
      | Protection rules        | Required reviewers (optional)    |
      | Secrets                 | Staging-specific secrets         |
      | Variables               | Staging configuration            |
      | Deployment URL          | https://staging.example.com      |

  # =============================================================================
  # PRODUCTION DEPLOYMENT
  # =============================================================================

  @deploy @production
  Scenario: Deploy to production environment
    Given code is pushed to main branch
    When the production deployment workflow runs
    Then the deployment should:
      | Step                    | Action                           |
      | Verify staging tested   | Staging deployment succeeded     |
      | Require approval        | Manual approval required         |
      | Build images            | Create production images         |
      | Push to registry        | Push to production registry      |
      | Deploy to production    | Rolling deployment               |
      | Run smoke tests         | Verify production deployment     |
      | Notify team             | Slack notification               |

  @deploy @production @approval
  Scenario: Require approval for production deployment
    Given production deployment is triggered
    When approval is required
    Then the workflow should:
      | Step                    | Action                           |
      | Notify approvers        | Send approval request            |
      | Require 2 approvals     | Minimum 2 reviewers              |
      | Block auto-approval     | Author cannot approve            |
      | Log approval            | Record who approved              |

  @deploy @production @environment
  Scenario: Configure production environment in GitHub
    Given production environment exists
    When I configure environment settings
    Then the environment should have:
      | Setting                 | Configuration                    |
      | Environment name        | production                       |
      | Protection rules        | 2 required reviewers             |
      | Secrets                 | Production secrets               |
      | Branch restrictions     | Only main branch                 |
      | Wait timer              | 10 minute delay (optional)       |

  @deploy @production @rollback
  Scenario: Rollback production deployment
    Given a production deployment has issues
    When rollback is triggered
    Then the rollback should:
      | Step                    | Action                           |
      | Identify previous       | Find last successful deployment  |
      | Redeploy previous       | Deploy previous version          |
      | Verify rollback         | Run smoke tests                  |
      | Notify team             | Alert about rollback             |
      | Create incident         | Track rollback reason            |

  # =============================================================================
  # RELEASE MANAGEMENT
  # =============================================================================

  @release @versioning
  Scenario: Automate semantic versioning
    Given a release is being prepared
    When version is determined
    Then versioning should:
      | Convention              | Trigger                          |
      | Major bump (1.0.0)      | Breaking changes                 |
      | Minor bump (0.1.0)      | New features                     |
      | Patch bump (0.0.1)      | Bug fixes                        |
    And version should be derived from commits

  @release @changelog
  Scenario: Generate changelog automatically
    Given a release is being created
    When the changelog is generated
    Then the changelog should include:
      | Section                 | Content                          |
      | Features                | New feature commits              |
      | Bug fixes               | Fix commits                      |
      | Breaking changes        | Breaking change commits          |
      | Contributors            | Authors of commits               |

  @release @github
  Scenario: Create GitHub release
    Given a version tag is pushed
    When the release workflow runs
    Then a GitHub release should be created with:
      | Component               | Content                          |
      | Release name            | Version number                   |
      | Release notes           | Generated changelog              |
      | Assets                  | Build artifacts                  |
      | Docker images           | Image tags                       |

  @release @notification
  Scenario: Notify on release
    Given a release is published
    When notification is triggered
    Then notifications should be sent to:
      | Channel                 | Content                          |
      | Slack                   | Release announcement             |
      | Email                   | Release notes                    |
      | GitHub discussions      | Release thread                   |

  # =============================================================================
  # SECRETS MANAGEMENT
  # =============================================================================

  @secrets @configuration
  Scenario: Configure repository secrets
    Given workflows need sensitive data
    When I configure secrets
    Then the following secrets should exist:
      | Secret Name             | Purpose                          |
      | DOCKER_USERNAME         | Container registry login         |
      | DOCKER_PASSWORD         | Container registry password      |
      | AWS_ACCESS_KEY_ID       | AWS deployment                   |
      | AWS_SECRET_ACCESS_KEY   | AWS deployment                   |
      | CODECOV_TOKEN           | Code coverage upload             |
      | SLACK_WEBHOOK_URL       | Slack notifications              |
      | MONGODB_URI             | Database connection              |

  @secrets @environments
  Scenario: Configure environment-specific secrets
    Given different environments need different secrets
    When I configure environment secrets
    Then each environment should have:
      | Environment    | Secret Scope                      |
      | staging        | Staging database, API keys        |
      | production     | Production database, API keys     |
    And production secrets should be more restricted

  @secrets @rotation
  Scenario: Rotate secrets periodically
    Given secrets need rotation
    When secret rotation is due
    Then the following should happen:
      | Step                    | Action                           |
      | Generate new secret     | Create new credential            |
      | Update GitHub secret    | Via API or UI                    |
      | Verify workflow         | Test secret works                |
      | Revoke old secret       | Disable old credential           |

  # =============================================================================
  # NOTIFICATIONS
  # =============================================================================

  @notification @slack
  Scenario: Send Slack notifications
    Given workflow events occur
    When notification should be sent
    Then Slack messages should be sent for:
      | Event                   | Channel        | Content             |
      | Build failure           | #builds        | Error details       |
      | Deploy success          | #deployments   | Deployment info     |
      | Deploy failure          | #deployments   | Error and rollback  |
      | Security alert          | #security      | Vulnerability info  |

  @notification @pr-comment
  Scenario: Comment on pull requests
    Given a PR workflow completes
    When results are available
    Then PR should receive comments for:
      | Check                   | Comment Content                  |
      | Build status            | Success/failure summary          |
      | Test coverage           | Coverage report link             |
      | Security findings       | Vulnerability summary            |
      | Deploy preview          | Preview URL                      |

  @notification @status-checks
  Scenario: Update commit status checks
    Given workflow jobs complete
    When status is reported
    Then commit status should show:
      | Check Name              | Status                           |
      | build                   | success/failure/pending          |
      | test                    | success/failure/pending          |
      | lint                    | success/failure/pending          |
      | security                | success/failure/pending          |
      | deploy                  | success/failure/pending          |

  # =============================================================================
  # WORKFLOW OPTIMIZATION
  # =============================================================================

  @optimization @parallel
  Scenario: Run jobs in parallel where possible
    Given workflow has multiple jobs
    When jobs are independent
    Then the following should run in parallel:
      | Parallel Group          | Jobs                             |
      | Build                   | API build, frontend build        |
      | Test                    | Unit tests, integration tests    |
      | Lint                    | Java lint, frontend lint         |
      | Scan                    | Dependency scan, SAST scan       |

  @optimization @conditional
  Scenario: Skip unnecessary jobs
    Given changes are limited to certain files
    When workflow triggers
    Then jobs should be skipped when:
      | Change                  | Skipped Jobs                     |
      | Only docs changed       | Build, test, deploy              |
      | Only frontend changed   | Backend build, backend test      |
      | Only backend changed    | Frontend build, frontend test    |

  @optimization @matrix
  Scenario: Use matrix strategy for testing
    Given multiple versions need testing
    When matrix strategy is used
    Then tests should run across:
      | Dimension               | Values                           |
      | Java version            | 17, 21                           |
      | Node version            | 18, 20                           |
      | OS                      | ubuntu-latest                    |

  @optimization @artifacts
  Scenario: Share artifacts between jobs
    Given jobs depend on build outputs
    When artifacts are uploaded
    Then subsequent jobs should:
      | Action                  | Configuration                    |
      | Download artifacts      | Use actions/download-artifact    |
      | Use cached builds       | Avoid rebuilding                 |
      | Expire artifacts        | 7 days retention                 |

  # =============================================================================
  # ERROR HANDLING
  # =============================================================================

  @error @retry
  Scenario: Retry failed jobs
    Given a job fails due to transient error
    When retry is configured
    Then the job should:
      | Configuration           | Value                            |
      | Max attempts            | 3                                |
      | Retry delay             | 30 seconds                       |
      | Retry condition         | Transient failures only          |

  @error @timeout
  Scenario: Configure job timeouts
    Given jobs may hang
    When timeouts are configured
    Then the following timeouts should apply:
      | Job Type                | Timeout                          |
      | Build                   | 15 minutes                       |
      | Unit tests              | 10 minutes                       |
      | Integration tests       | 20 minutes                       |
      | E2E tests               | 30 minutes                       |
      | Deployment              | 20 minutes                       |

  @error @failure-handling
  Scenario: Handle workflow failures
    Given a workflow fails
    When failure is detected
    Then the following should happen:
      | Action                  | Description                      |
      | Stop dependent jobs     | Fail fast                        |
      | Collect logs            | Artifact upload                  |
      | Send notification       | Alert team                       |
      | Create issue            | For recurring failures           |

  # =============================================================================
  # BRANCH PROTECTION
  # =============================================================================

  @protection @main
  Scenario: Configure main branch protection
    Given main branch is the production branch
    When branch protection is configured
    Then the following rules should apply:
      | Rule                    | Configuration                    |
      | Require PR              | Direct push blocked              |
      | Required reviews        | 1 approval minimum               |
      | Required checks         | CI must pass                     |
      | Dismiss stale reviews   | On new commits                   |
      | Up-to-date branch       | Branch must be current           |

  @protection @develop
  Scenario: Configure develop branch protection
    Given develop branch is the staging branch
    When branch protection is configured
    Then the following rules should apply:
      | Rule                    | Configuration                    |
      | Require PR              | Direct push blocked              |
      | Required reviews        | 1 approval minimum               |
      | Required checks         | CI must pass                     |

  # =============================================================================
  # SELF-HOSTED RUNNERS
  # =============================================================================

  @runners @self-hosted
  Scenario: Configure self-hosted runners
    Given specific hardware is needed
    When I configure self-hosted runners
    Then runners should be:
      | Configuration           | Description                      |
      | Labeled                 | gpu, high-memory, etc.           |
      | Secure                  | Isolated environment             |
      | Auto-scaling            | Scale based on demand            |
      | Ephemeral               | Clean state after each job       |

  @runners @labels
  Scenario: Use runner labels for job routing
    Given different jobs need different runners
    When jobs specify runner requirements
    Then jobs should route:
      | Job Type                | Runner Label                     |
      | Standard build          | ubuntu-latest                    |
      | GPU tests               | self-hosted, gpu                 |
      | High memory             | self-hosted, high-memory         |

  # =============================================================================
  # MONITORING AND OBSERVABILITY
  # =============================================================================

  @monitoring @metrics
  Scenario: Track CI/CD metrics
    Given workflows are running
    When metrics are collected
    Then the following should be tracked:
      | Metric                  | Description                      |
      | Build time              | Average build duration           |
      | Success rate            | Percentage of successful builds  |
      | Deploy frequency        | Deployments per day/week         |
      | Lead time               | Commit to production time        |
      | MTTR                    | Mean time to recovery            |

  @monitoring @dashboard
  Scenario: Create CI/CD dashboard
    Given metrics are being collected
    When dashboard is configured
    Then dashboard should show:
      | Panel                   | Content                          |
      | Build status            | Current and recent builds        |
      | Test results            | Pass/fail trends                 |
      | Coverage trends         | Coverage over time               |
      | Deploy history          | Recent deployments               |
      | Failure analysis        | Common failure reasons           |
