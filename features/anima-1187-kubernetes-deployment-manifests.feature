@kubernetes @k8s @deployment @helm @infrastructure
Feature: Kubernetes Deployment Manifests
  As a DevOps engineer
  I want to create Kubernetes deployment manifests and Helm charts
  So that I can deploy the FFL Playoffs application to Kubernetes clusters

  Background:
    Given Kubernetes cluster is available
    And kubectl is configured with appropriate context
    And Helm 3 is installed

  # ==========================================
  # Deployment Manifests
  # ==========================================

  @deployment @api
  Scenario: Create API Deployment manifest
    Given I am creating the API deployment
    When I define the deployment manifest:
      | field                    | value                      |
      | apiVersion               | apps/v1                    |
      | kind                     | Deployment                 |
      | name                     | ffl-playoffs-api           |
      | namespace                | ffl-playoffs               |
      | replicas                 | 3                          |
      | strategy                 | RollingUpdate              |
    Then the deployment should be valid
    And it should reference the correct container image

  @deployment @containers
  Scenario: Configure container specifications
    Given I am configuring the API container
    When I define container specs:
      | field                    | value                      |
      | name                     | api                        |
      | image                    | ffl-playoffs-api:latest    |
      | imagePullPolicy          | IfNotPresent               |
      | containerPort            | 8080                       |
      | protocol                 | TCP                        |
    Then container should be properly configured
    And port mapping should be correct

  @deployment @resources
  Scenario: Configure resource limits and requests
    Given I am setting resource constraints
    When I define resource specifications:
      | resource_type | cpu_request | cpu_limit | memory_request | memory_limit |
      | api           | 250m        | 1000m     | 512Mi          | 1Gi          |
      | worker        | 100m        | 500m      | 256Mi          | 512Mi        |
    Then resources should be properly allocated
    And QoS class should be Burstable

  @deployment @probes
  Scenario: Configure health check probes
    Given I am configuring health probes
    When I define probe specifications:
      | probe_type    | path           | port | initial_delay | period | timeout |
      | livenessProbe | /health/live   | 8080 | 30            | 10     | 5       |
      | readinessProbe| /health/ready  | 8080 | 10            | 5      | 3       |
      | startupProbe  | /health/startup| 8080 | 5             | 5      | 3       |
    Then probes should monitor container health
    And unhealthy pods should be restarted

  @deployment @env-vars
  Scenario: Configure environment variables
    Given I am setting environment variables
    When I define environment configuration:
      | source         | name                  | reference                    |
      | value          | SPRING_PROFILES_ACTIVE| production                   |
      | configMapKeyRef| MONGODB_URI           | ffl-config/mongodb-uri       |
      | secretKeyRef   | MONGODB_PASSWORD      | ffl-secrets/mongodb-password |
    Then environment variables should be injected
    And secrets should not be exposed in manifests

  @deployment @rolling-update
  Scenario: Configure rolling update strategy
    Given I am setting update strategy
    When I configure rolling update:
      | field                    | value                      |
      | maxSurge                 | 25%                        |
      | maxUnavailable           | 25%                        |
      | minReadySeconds          | 10                         |
      | progressDeadlineSeconds  | 600                        |
    Then updates should roll out gradually
    And zero downtime should be maintained

  @deployment @affinity
  Scenario: Configure pod affinity rules
    Given I want high availability across nodes
    When I configure affinity:
      | type                    | rule                           |
      | podAntiAffinity         | Prefer different nodes         |
      | nodeAffinity            | Prefer nodes with SSD          |
      | topologySpreadConstraints| Spread across zones           |
    Then pods should be distributed appropriately
    And single node failure should not affect all replicas

  @deployment @volumes
  Scenario: Configure volume mounts
    Given containers need persistent storage
    When I configure volumes:
      | volume_name    | type           | mount_path         |
      | config-volume  | configMap      | /app/config        |
      | secret-volume  | secret         | /app/secrets       |
      | tmp-volume     | emptyDir       | /tmp               |
    Then volumes should be mounted correctly
    And data should be accessible to containers

  # ==========================================
  # Service Manifests
  # ==========================================

  @service @clusterip
  Scenario: Create ClusterIP Service
    Given I am creating internal service
    When I define ClusterIP service:
      | field          | value                      |
      | name           | ffl-api-internal           |
      | type           | ClusterIP                  |
      | port           | 80                         |
      | targetPort     | 8080                       |
      | selector       | app: ffl-playoffs-api      |
    Then internal service should be accessible
    And pods should be load balanced

  @service @nodeport
  Scenario: Create NodePort Service for development
    Given I need external access for development
    When I define NodePort service:
      | field          | value                      |
      | name           | ffl-api-nodeport           |
      | type           | NodePort                   |
      | port           | 80                         |
      | targetPort     | 8080                       |
      | nodePort       | 30080                      |
    Then service should be accessible on node IP
    And port should be in valid range

  @service @loadbalancer
  Scenario: Create LoadBalancer Service for production
    Given I need cloud load balancer
    When I define LoadBalancer service:
      | field                  | value                      |
      | name                   | ffl-api-lb                 |
      | type                   | LoadBalancer               |
      | port                   | 443                        |
      | targetPort             | 8080                       |
      | annotations            | cloud provider specific    |
    Then cloud load balancer should be provisioned
    And external IP should be assigned

  @service @headless
  Scenario: Create Headless Service for StatefulSet
    Given I need direct pod access
    When I define headless service:
      | field          | value                      |
      | name           | mongodb-headless           |
      | clusterIP      | None                       |
      | port           | 27017                      |
    Then DNS should resolve to pod IPs directly
    And stateful workloads should be addressable

  @service @multiple-ports
  Scenario: Configure multi-port service
    Given application exposes multiple ports
    When I define multi-port service:
      | port_name | port | target_port | protocol |
      | http      | 80   | 8080        | TCP      |
      | https     | 443  | 8443        | TCP      |
      | metrics   | 9090 | 9090        | TCP      |
    Then all ports should be accessible
    And port names should be valid

  # ==========================================
  # ConfigMap Manifests
  # ==========================================

  @configmap @creation
  Scenario: Create ConfigMap for application configuration
    Given I need externalized configuration
    When I create ConfigMap:
      | field          | value                      |
      | name           | ffl-api-config             |
      | namespace      | ffl-playoffs               |
    And I add configuration data:
      | key                    | value                      |
      | application.yml        | Spring configuration       |
      | log4j2.xml             | Logging configuration      |
      | feature-flags.json     | Feature toggle settings    |
    Then ConfigMap should be created
    And data should be accessible to pods

  @configmap @from-file
  Scenario: Create ConfigMap from files
    Given I have configuration files
    When I create ConfigMap from files:
      """
      kubectl create configmap app-config \
        --from-file=config/application.yml \
        --from-file=config/log4j2.xml
      """
    Then ConfigMap should contain file contents
    And keys should be file names

  @configmap @from-literal
  Scenario: Create ConfigMap from literals
    Given I have simple key-value configs
    When I create ConfigMap from literals:
      """
      kubectl create configmap app-settings \
        --from-literal=LOG_LEVEL=INFO \
        --from-literal=MAX_CONNECTIONS=100
      """
    Then ConfigMap should contain literal values
    And values should be usable as env vars

  @configmap @immutable
  Scenario: Create immutable ConfigMap
    Given configuration should not change
    When I set ConfigMap as immutable:
      | field          | value                      |
      | immutable      | true                       |
    Then ConfigMap cannot be modified after creation
    And pods must be recreated to get new config

  @configmap @env-injection
  Scenario: Inject ConfigMap as environment variables
    Given ConfigMap contains environment settings
    When I configure envFrom in deployment:
      """
      envFrom:
        - configMapRef:
            name: ffl-api-config
      """
    Then all ConfigMap keys become env vars
    And application should read configuration

  # ==========================================
  # Secret Manifests
  # ==========================================

  @secret @creation
  Scenario: Create Secret for sensitive data
    Given I have sensitive configuration
    When I create Secret:
      | field          | value                      |
      | name           | ffl-api-secrets            |
      | type           | Opaque                     |
      | namespace      | ffl-playoffs               |
    And I add secret data:
      | key                    | encoded_value              |
      | mongodb-password       | base64 encoded             |
      | jwt-signing-key        | base64 encoded             |
      | oauth-client-secret    | base64 encoded             |
    Then Secret should be created
    And data should be base64 encoded

  @secret @tls
  Scenario: Create TLS Secret
    Given I have TLS certificate and key
    When I create TLS Secret:
      """
      kubectl create secret tls ffl-tls-secret \
        --cert=tls.crt \
        --key=tls.key
      """
    Then TLS Secret should be created
    And it should be usable by Ingress

  @secret @docker-registry
  Scenario: Create Docker registry Secret
    Given I need to pull from private registry
    When I create registry Secret:
      """
      kubectl create secret docker-registry regcred \
        --docker-server=registry.example.com \
        --docker-username=user \
        --docker-password=pass
      """
    Then registry Secret should be created
    And pods can pull private images

  @secret @sealed-secrets
  Scenario: Use Sealed Secrets for GitOps
    Given I want to store secrets in Git
    When I create SealedSecret:
      | step                   | action                     |
      | encrypt                | Use kubeseal CLI           |
      | store                  | Commit encrypted secret    |
      | decrypt                | Controller decrypts in cluster |
    Then encrypted secret can be stored in Git
    And only cluster can decrypt

  @secret @external-secrets
  Scenario: Sync secrets from external vault
    Given secrets are stored in AWS Secrets Manager
    When I configure ExternalSecret:
      | field              | value                      |
      | secretStoreRef     | aws-secrets-manager        |
      | target.name        | ffl-api-secrets            |
      | data.remoteRef     | ffl/production/api-secrets |
    Then secrets should sync from external store
    And rotation should be automatic

  @secret @volume-mount
  Scenario: Mount Secret as volume
    Given Secret contains certificate files
    When I mount as volume:
      """
      volumes:
        - name: certs
          secret:
            secretName: ffl-tls-secret
      volumeMounts:
        - name: certs
          mountPath: /etc/certs
          readOnly: true
      """
    Then files should be available in container
    And permissions should be restricted

  # ==========================================
  # Ingress Manifests
  # ==========================================

  @ingress @basic
  Scenario: Create basic Ingress resource
    Given I need HTTP routing
    When I create Ingress:
      | field              | value                      |
      | name               | ffl-ingress                |
      | ingressClassName   | nginx                      |
      | host               | api.fflplayoffs.com        |
      | path               | /                          |
      | pathType           | Prefix                     |
      | service.name       | ffl-api                    |
      | service.port       | 80                         |
    Then Ingress should route traffic to service
    And host-based routing should work

  @ingress @tls
  Scenario: Configure TLS termination
    Given I need HTTPS support
    When I configure Ingress TLS:
      """
      tls:
        - hosts:
            - api.fflplayoffs.com
          secretName: ffl-tls-secret
      """
    Then TLS should terminate at Ingress
    And HTTP should redirect to HTTPS

  @ingress @multiple-hosts
  Scenario: Configure multiple hosts
    Given I have multiple subdomains
    When I configure multi-host Ingress:
      | host                    | service          | path   |
      | api.fflplayoffs.com     | ffl-api          | /      |
      | admin.fflplayoffs.com   | ffl-admin        | /      |
      | ws.fflplayoffs.com      | ffl-websocket    | /      |
    Then each host should route correctly
    And virtual hosting should work

  @ingress @path-based
  Scenario: Configure path-based routing
    Given I need path-based routing
    When I configure paths:
      | path        | pathType | service       |
      | /api        | Prefix   | ffl-api       |
      | /admin      | Prefix   | ffl-admin     |
      | /health     | Exact    | ffl-health    |
    Then paths should route to correct services
    And path matching should be correct

  @ingress @annotations
  Scenario: Configure Ingress annotations
    Given I need custom Ingress behavior
    When I add annotations:
      | annotation                                    | value      |
      | nginx.ingress.kubernetes.io/rewrite-target   | /          |
      | nginx.ingress.kubernetes.io/ssl-redirect     | true       |
      | nginx.ingress.kubernetes.io/proxy-body-size  | 10m        |
      | nginx.ingress.kubernetes.io/rate-limit       | 100        |
    Then Ingress controller should apply settings
    And behavior should match annotations

  @ingress @cert-manager
  Scenario: Automatic TLS with cert-manager
    Given cert-manager is installed
    When I configure automatic TLS:
      """
      annotations:
        cert-manager.io/cluster-issuer: letsencrypt-prod
      tls:
        - hosts:
            - api.fflplayoffs.com
          secretName: ffl-tls-auto
      """
    Then certificate should be automatically issued
    And renewal should be automatic

  # ==========================================
  # Helm Charts
  # ==========================================

  @helm @structure
  Scenario: Create Helm chart structure
    Given I am creating a Helm chart
    When I scaffold the chart:
      | file/directory     | purpose                      |
      | Chart.yaml         | Chart metadata               |
      | values.yaml        | Default values               |
      | templates/         | K8s manifest templates       |
      | charts/            | Subcharts                    |
      | .helmignore        | Ignored files                |
    Then chart structure should be valid
    And helm lint should pass

  @helm @chart-yaml
  Scenario: Configure Chart.yaml
    Given I am defining chart metadata
    When I configure Chart.yaml:
      | field           | value                        |
      | apiVersion      | v2                           |
      | name            | ffl-playoffs                 |
      | version         | 1.0.0                        |
      | appVersion      | 1.0.0                        |
      | description     | FFL Playoffs Application     |
      | type            | application                  |
    Then chart metadata should be complete
    And semantic versioning should be used

  @helm @values
  Scenario: Define values.yaml with defaults
    Given I am setting default values
    When I define values.yaml:
      """
      replicaCount: 3

      image:
        repository: ffl-playoffs-api
        tag: latest
        pullPolicy: IfNotPresent

      service:
        type: ClusterIP
        port: 80

      resources:
        limits:
          cpu: 1000m
          memory: 1Gi
        requests:
          cpu: 250m
          memory: 512Mi

      ingress:
        enabled: true
        host: api.fflplayoffs.com
      """
    Then defaults should be sensible
    And all values should be overridable

  @helm @templates
  Scenario: Create templated manifests
    Given I am creating templates
    When I template the deployment:
      """
      apiVersion: apps/v1
      kind: Deployment
      metadata:
        name: {{ include "ffl-playoffs.fullname" . }}
        labels:
          {{- include "ffl-playoffs.labels" . | nindent 4 }}
      spec:
        replicas: {{ .Values.replicaCount }}
        selector:
          matchLabels:
            {{- include "ffl-playoffs.selectorLabels" . | nindent 6 }}
      """
    Then templates should use Go templating
    And values should be substituted correctly

  @helm @helpers
  Scenario: Create template helpers
    Given I need reusable template functions
    When I define _helpers.tpl:
      """
      {{- define "ffl-playoffs.fullname" -}}
      {{- printf "%s-%s" .Release.Name .Chart.Name | trunc 63 | trimSuffix "-" }}
      {{- end }}

      {{- define "ffl-playoffs.labels" -}}
      helm.sh/chart: {{ .Chart.Name }}-{{ .Chart.Version }}
      app.kubernetes.io/name: {{ .Chart.Name }}
      app.kubernetes.io/instance: {{ .Release.Name }}
      {{- end }}
      """
    Then helpers should be reusable
    And naming should be consistent

  @helm @dependencies
  Scenario: Configure chart dependencies
    Given I need MongoDB as dependency
    When I configure dependencies in Chart.yaml:
      """
      dependencies:
        - name: mongodb
          version: 13.x.x
          repository: https://charts.bitnami.com/bitnami
          condition: mongodb.enabled
      """
    Then dependencies should be fetched
    And subcharts should be installed

  @helm @environments
  Scenario: Create environment-specific values
    Given I have multiple environments
    When I create values files:
      | file                    | environment    |
      | values.yaml             | defaults       |
      | values-dev.yaml         | development    |
      | values-staging.yaml     | staging        |
      | values-prod.yaml        | production     |
    Then environment values should override defaults
    And helm install can use specific values

  @helm @install
  Scenario: Install Helm release
    Given Helm chart is ready
    When I install the release:
      """
      helm install ffl-playoffs ./charts/ffl-playoffs \
        --namespace ffl-playoffs \
        --create-namespace \
        --values values-prod.yaml
      """
    Then release should be installed
    And all resources should be created

  @helm @upgrade
  Scenario: Upgrade Helm release
    Given release is installed
    When I upgrade with new values:
      """
      helm upgrade ffl-playoffs ./charts/ffl-playoffs \
        --namespace ffl-playoffs \
        --set replicaCount=5 \
        --set image.tag=v1.1.0
      """
    Then release should upgrade
    And rolling update should occur

  @helm @rollback
  Scenario: Rollback Helm release
    Given upgrade caused issues
    When I rollback to previous revision:
      """
      helm rollback ffl-playoffs 1 \
        --namespace ffl-playoffs
      """
    Then previous version should be restored
    And application should stabilize

  @helm @hooks
  Scenario: Configure Helm hooks
    Given I need pre/post install actions
    When I create hook job:
      """
      annotations:
        "helm.sh/hook": pre-install,pre-upgrade
        "helm.sh/hook-weight": "-5"
        "helm.sh/hook-delete-policy": hook-succeeded
      """
    Then hooks should run at appropriate times
    And database migrations should complete before deployment

  # ==========================================
  # Namespace and RBAC
  # ==========================================

  @namespace @creation
  Scenario: Create namespace for application
    Given I need isolated environment
    When I create namespace:
      | field              | value                      |
      | name               | ffl-playoffs               |
      | labels             | environment: production    |
      | annotations        | owner: platform-team       |
    Then namespace should be created
    And resources should be isolated

  @rbac @service-account
  Scenario: Create ServiceAccount
    Given pods need specific permissions
    When I create ServiceAccount:
      | field              | value                      |
      | name               | ffl-api-sa                 |
      | namespace          | ffl-playoffs               |
    Then ServiceAccount should be created
    And pods can use this identity

  @rbac @role
  Scenario: Create Role with permissions
    Given I need namespace-scoped permissions
    When I create Role:
      """
      rules:
        - apiGroups: [""]
          resources: ["configmaps", "secrets"]
          verbs: ["get", "list", "watch"]
        - apiGroups: [""]
          resources: ["pods"]
          verbs: ["get", "list"]
      """
    Then Role should define permissions
    And permissions should be least-privilege

  @rbac @role-binding
  Scenario: Create RoleBinding
    Given Role and ServiceAccount exist
    When I create RoleBinding:
      | field              | value                      |
      | name               | ffl-api-binding            |
      | roleRef.name       | ffl-api-role               |
      | subjects           | ffl-api-sa ServiceAccount  |
    Then ServiceAccount should have Role permissions
    And pods should access permitted resources

  # ==========================================
  # Resource Quotas and Limits
  # ==========================================

  @quota @resource-quota
  Scenario: Configure ResourceQuota
    Given I need to limit namespace resources
    When I create ResourceQuota:
      | resource           | limit                      |
      | requests.cpu       | 10                         |
      | requests.memory    | 20Gi                       |
      | limits.cpu         | 20                         |
      | limits.memory      | 40Gi                       |
      | pods               | 50                         |
    Then namespace should have resource limits
    And quota should be enforced

  @quota @limit-range
  Scenario: Configure LimitRange
    Given I need default resource limits
    When I create LimitRange:
      | type      | default.cpu | default.memory | max.cpu | max.memory |
      | Container | 500m        | 512Mi          | 2       | 2Gi        |
    Then defaults should apply to containers
    And maximums should be enforced

  # ==========================================
  # Validation and Testing
  # ==========================================

  @validation @lint
  Scenario: Validate manifests with kubeval
    Given manifests are created
    When I run validation:
      """
      kubeval --strict k8s/*.yaml
      helm lint charts/ffl-playoffs
      """
    Then all manifests should be valid
    And no schema errors should exist

  @validation @dry-run
  Scenario: Test deployment with dry-run
    Given manifests are ready
    When I apply with dry-run:
      """
      kubectl apply -f k8s/ --dry-run=server
      helm install --dry-run ffl-playoffs ./charts/ffl-playoffs
      """
    Then server should validate resources
    And no errors should occur

  @validation @diff
  Scenario: Preview changes before apply
    Given changes are pending
    When I diff the changes:
      """
      kubectl diff -f k8s/
      helm diff upgrade ffl-playoffs ./charts/ffl-playoffs
      """
    Then differences should be displayed
    And changes can be reviewed

  @testing @kind
  Scenario: Test deployment in local cluster
    Given Kind cluster is available
    When I deploy to Kind:
      """
      kind create cluster --name ffl-test
      kubectl apply -f k8s/
      """
    Then deployment should succeed locally
    And application should be accessible

  # ==========================================
  # GitOps and Continuous Deployment
  # ==========================================

  @gitops @argocd
  Scenario: Configure ArgoCD Application
    Given ArgoCD is installed
    When I create ArgoCD Application:
      | field              | value                      |
      | project            | default                    |
      | source.repoURL     | git repo URL               |
      | source.path        | k8s/                       |
      | destination.server | https://kubernetes.default |
      | destination.namespace | ffl-playoffs            |
      | syncPolicy         | automated                  |
    Then ArgoCD should sync manifests
    And changes should auto-deploy

  @gitops @flux
  Scenario: Configure Flux GitOps
    Given Flux is installed
    When I create Flux resources:
      | resource           | purpose                    |
      | GitRepository      | Source repository          |
      | Kustomization      | Deploy manifests           |
      | HelmRelease        | Deploy Helm charts         |
    Then Flux should reconcile state
    And drift should be corrected

  @gitops @kustomize
  Scenario: Use Kustomize for overlays
    Given I need environment overlays
    When I create Kustomize structure:
      | directory              | purpose                |
      | base/                  | Base manifests         |
      | overlays/dev/          | Dev patches            |
      | overlays/staging/      | Staging patches        |
      | overlays/production/   | Production patches     |
    Then overlays should customize base
    And kustomize build should work
