@ANIMA-1049
Feature: Authentication and Authorization via Envoy Sidecar

As a platform user
I want to authenticate securely through the Envoy sidecar
So that I can access the platform with proper permissions
Background:
Given the Envoy sidecar is configured with Google OAuth2
And the sidecar handles mTLS communication to the API
And Personal Access Tokens (PAT) are supported
# Google OAuth2 Authentication
- Scenario: Login with Google OAuth2
- Scenario: First-time Google OAuth2 login
- Scenario: Handle expired Google OAuth2 session
- Scenario: Generate personal access token
- Scenario: Use PAT for API authentication
- Scenario: Revoke personal access token
- Scenario: View my permissions
- Scenario: Request additional permissions
- Scenario: View mTLS certificate status
- Scenario: View active sessions
- Scenario: Force logout from all devices
- Scenario: Handle unauthorized access attempt
- Scenario: Handle malformed authentication
- Scenario: Respect rate limits per authentication type
- Scenario: View authentication logs as admin
- Scenario: Configure workspace authentication policies
- Scenario: Create service account with PAT