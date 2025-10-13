# Kubernetes Deployment

This directory contains Kubernetes manifests for deploying the FFL Playoffs API with Envoy sidecar pattern.

## Architecture

The deployment uses a **three-container pod** pattern:

1. **Envoy Sidecar** (port 443) - External entry point with TLS termination and auth
2. **Auth Service** (port 9191, localhost-only) - Token validation service
3. **Main API** (port 8080, localhost-only) - Business logic API

**Security Model**: ALL traffic flows through Envoy → Auth Service → Main API. The Main API and Auth Service bind to localhost only and cannot be accessed directly from outside the pod.

## Prerequisites

- Kubernetes cluster (v1.24+)
- kubectl configured
- cert-manager (for TLS certificates)
- Ingress controller (e.g., nginx-ingress)
- MongoDB database

## Deployment Order

Deploy in this order to satisfy dependencies:

### 1. Create Namespace

```bash
kubectl apply -f namespace.yaml
```

### 2. Create Secrets

#### MongoDB Credentials

```bash
# Create MongoDB connection string secret
kubectl create secret generic mongodb-credentials \
  --from-literal=MONGODB_URI='mongodb://ffl_user:password@mongodb.default.svc:27017/ffl_playoffs' \
  -n ffl-playoffs
```

#### Google OAuth Credentials

```bash
# Create Google OAuth client ID secret
kubectl create secret generic google-oauth \
  --from-literal=CLIENT_ID='your-google-client-id.apps.googleusercontent.com' \
  -n ffl-playoffs
```

#### TLS Certificates

For production with Let's Encrypt:

```bash
# cert-manager will automatically create this secret when Ingress is deployed
# Ensure cert-manager and cluster-issuer are configured first
```

For development (self-signed certificate):

```bash
# Generate self-signed certificate
openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
  -keyout tls.key -out tls.crt \
  -subj "/CN=api.ffl-playoffs.com"

# Create TLS secret
kubectl create secret tls envoy-tls \
  --cert=tls.crt --key=tls.key \
  -n ffl-playoffs

# Clean up local files
rm tls.key tls.crt
```

#### NFL API Credentials (Optional)

```bash
kubectl create secret generic nfl-api-credentials \
  --from-literal=API_KEY='your-nfl-api-key' \
  -n ffl-playoffs
```

### 3. Create ConfigMaps

#### Envoy Configuration

```bash
kubectl apply -f envoy-configmap.yaml
```

#### Application Configuration (Optional)

```bash
kubectl create configmap app-config \
  --from-literal=NFL_API_URL='https://api.nfl.com/v1' \
  -n ffl-playoffs
```

### 4. Deploy Application

```bash
kubectl apply -f deployment.yaml
```

### 5. Create Service

```bash
kubectl apply -f service.yaml
```

### 6. Create Ingress (Optional)

```bash
kubectl apply -f ingress.yaml
```

### 7. Apply Network Policy (Optional but Recommended)

```bash
kubectl apply -f network-policy.yaml
```

## Verification

### Check Pod Status

```bash
kubectl get pods -n ffl-playoffs
```

Expected output:
```
NAME                                READY   STATUS    RESTARTS   AGE
ffl-playoffs-api-<hash>-<id>        3/3     Running   0          2m
ffl-playoffs-api-<hash>-<id>        3/3     Running   0          2m
ffl-playoffs-api-<hash>-<id>        3/3     Running   0          2m
```

### Check Logs

```bash
# Envoy logs
kubectl logs -n ffl-playoffs <pod-name> -c envoy

# Auth Service logs
kubectl logs -n ffl-playoffs <pod-name> -c auth-service

# Main API logs
kubectl logs -n ffl-playoffs <pod-name> -c api
```

### Test Health Endpoints

```bash
# Get pod IP
POD_NAME=$(kubectl get pods -n ffl-playoffs -l app=ffl-playoffs-api -o jsonpath='{.items[0].metadata.name}')

# Test Envoy admin (from within pod)
kubectl exec -n ffl-playoffs $POD_NAME -c envoy -- curl http://127.0.0.1:9901/ready

# Test Auth Service health (from within pod)
kubectl exec -n ffl-playoffs $POD_NAME -c auth-service -- curl http://127.0.0.1:9191/health

# Test Main API health (from within pod)
kubectl exec -n ffl-playoffs $POD_NAME -c api -- curl http://127.0.0.1:8081/actuator/health
```

### Test External Access

```bash
# Test through Ingress (if configured)
curl https://api.ffl-playoffs.com/api/v1/public/health

# Test through Service (from within cluster)
kubectl run test-pod --rm -it --image=curlimages/curl -- \
  curl https://ffl-playoffs-api.ffl-playoffs.svc.cluster.local/api/v1/public/health
```

## Security Verification

### Verify Localhost-Only Binding

The Main API and Auth Service should NOT be accessible from outside the pod:

```bash
# Get pod IP
POD_IP=$(kubectl get pod -n ffl-playoffs $POD_NAME -o jsonpath='{.status.podIP}')

# Try to access Main API directly (should FAIL)
kubectl run test-pod --rm -it --image=curlimages/curl -- \
  curl -m 5 http://$POD_IP:8080/actuator/health

# Expected: Connection refused or timeout

# Try to access Auth Service directly (should FAIL)
kubectl run test-pod --rm -it --image=curlimages/curl -- \
  curl -m 5 http://$POD_IP:9191/health

# Expected: Connection refused or timeout

# Access through Envoy should work
kubectl run test-pod --rm -it --image=curlimages/curl -- \
  curl -k https://$POD_IP:443/api/v1/public/health

# Expected: Success
```

## Scaling

### Manual Scaling

```bash
# Scale to 5 replicas
kubectl scale deployment ffl-playoffs-api --replicas=5 -n ffl-playoffs

# Verify
kubectl get pods -n ffl-playoffs
```

### Horizontal Pod Autoscaler (HPA)

```bash
# Create HPA (requires metrics-server)
kubectl autoscale deployment ffl-playoffs-api \
  --cpu-percent=70 \
  --min=3 \
  --max=10 \
  -n ffl-playoffs

# Check HPA status
kubectl get hpa -n ffl-playoffs
```

## Updating

### Rolling Update

```bash
# Update image version
kubectl set image deployment/ffl-playoffs-api \
  api=ffl-playoffs/api:v1.1.0 \
  -n ffl-playoffs

# Watch rollout status
kubectl rollout status deployment/ffl-playoffs-api -n ffl-playoffs
```

### Rollback

```bash
# View rollout history
kubectl rollout history deployment/ffl-playoffs-api -n ffl-playoffs

# Rollback to previous version
kubectl rollout undo deployment/ffl-playoffs-api -n ffl-playoffs

# Rollback to specific revision
kubectl rollout undo deployment/ffl-playoffs-api --to-revision=2 -n ffl-playoffs
```

## Troubleshooting

### Pod Not Starting

```bash
# Describe pod to see events
kubectl describe pod -n ffl-playoffs $POD_NAME

# Common issues:
# - ImagePullBackOff: Check image name and registry credentials
# - CrashLoopBackOff: Check application logs
# - Pending: Check resource quotas and node capacity
```

### Container Fails Health Checks

```bash
# Check specific container logs
kubectl logs -n ffl-playoffs $POD_NAME -c api

# Exec into container to debug
kubectl exec -it -n ffl-playoffs $POD_NAME -c api -- /bin/bash

# Test health endpoint manually
curl http://127.0.0.1:8081/actuator/health
```

### Envoy Not Forwarding Requests

```bash
# Check Envoy logs
kubectl logs -n ffl-playoffs $POD_NAME -c envoy

# Check Envoy admin interface
kubectl exec -n ffl-playoffs $POD_NAME -c envoy -- \
  curl http://127.0.0.1:9901/stats

# Verify Envoy configuration
kubectl exec -n ffl-playoffs $POD_NAME -c envoy -- \
  curl http://127.0.0.1:9901/config_dump
```

### Auth Service Returns 403

```bash
# Check Auth Service logs
kubectl logs -n ffl-playoffs $POD_NAME -c auth-service

# Verify MongoDB connectivity from auth service
kubectl exec -it -n ffl-playoffs $POD_NAME -c auth-service -- /bin/bash
# Then test MongoDB connection
```

### Network Policy Blocking Traffic

```bash
# Temporarily remove network policy for testing
kubectl delete networkpolicy ffl-playoffs-network-policy -n ffl-playoffs

# Test connectivity
# ...

# Reapply network policy
kubectl apply -f network-policy.yaml
```

## Cleanup

### Delete All Resources

```bash
kubectl delete namespace ffl-playoffs
```

### Delete Individual Resources

```bash
kubectl delete -f ingress.yaml
kubectl delete -f service.yaml
kubectl delete -f deployment.yaml
kubectl delete -f envoy-configmap.yaml
kubectl delete -f network-policy.yaml
kubectl delete -f namespace.yaml
```

## Additional Resources

- [Deployment Guide](../docs/DEPLOYMENT.md) - Detailed deployment documentation
- [API Documentation](../docs/API.md) - API endpoints and authentication
- [PAT Management](../docs/PAT_MANAGEMENT.md) - Personal Access Token setup
- [Architecture](../docs/ARCHITECTURE.md) - System architecture overview

## Support

For issues or questions:
1. Check pod events: `kubectl describe pod -n ffl-playoffs <pod-name>`
2. Check logs: `kubectl logs -n ffl-playoffs <pod-name> -c <container-name>`
3. Review documentation in `/docs`
