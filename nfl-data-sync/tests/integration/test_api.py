"""
API Integration Tests

Tests for FastAPI endpoints using TestClient.
"""
from unittest.mock import MagicMock, patch, AsyncMock
from datetime import datetime

import pytest
from fastapi.testclient import TestClient

from src.domain.models import SyncJob, SyncJobStatus, SyncJobType


# Patch dependencies before importing app
@pytest.fixture
def mock_dependencies():
    """Mock external dependencies."""
    with patch('src.main.NflDataPyAdapter') as mock_nfl, \
         patch('src.main.DeltaDetectionService') as mock_delta, \
         patch('src.main.NflDataSyncJob') as mock_sync:

        # Configure mocks
        mock_nfl_instance = MagicMock()
        mock_nfl.return_value = mock_nfl_instance

        mock_delta_instance = MagicMock()
        mock_delta.return_value = mock_delta_instance

        mock_sync_instance = MagicMock()
        mock_sync_instance.get_current_job.return_value = None
        mock_sync_instance.get_sync_history.return_value = []
        mock_sync.return_value = mock_sync_instance

        yield {
            'nfl': mock_nfl_instance,
            'delta': mock_delta_instance,
            'sync': mock_sync_instance,
        }


@pytest.fixture
def client(mock_dependencies):
    """Create test client with mocked dependencies."""
    from src.main import app
    from src.api.admin_routes import set_sync_job

    set_sync_job(mock_dependencies['sync'])

    with TestClient(app) as client:
        yield client


class TestRootEndpoints:
    """Test root and health endpoints."""

    def test_root_endpoint(self, client):
        """Test root endpoint returns service info."""
        response = client.get("/")

        assert response.status_code == 200
        data = response.json()
        assert data["service"] == "NFL Data Sync Service"
        assert "version" in data
        assert data["status"] == "running"

    def test_health_endpoint(self, client):
        """Test health endpoint returns healthy status."""
        response = client.get("/health")

        assert response.status_code == 200
        data = response.json()
        assert data["status"] == "healthy"


class TestAdminEndpoints:
    """Test admin sync endpoints."""

    def test_trigger_player_sync(self, client, mock_dependencies):
        """Test triggering manual player sync."""
        # Setup mock to return a completed job
        job = SyncJob(
            job_id="test-job-123",
            job_type=SyncJobType.PLAYERS,
            status=SyncJobStatus.COMPLETED,
            started_at=datetime.utcnow(),
            completed_at=datetime.utcnow(),
            records_processed=1800,
            records_updated=5,
        )
        mock_dependencies['sync'].trigger_manual_sync = AsyncMock(return_value=job)

        response = client.post("/api/v1/admin/sync/players")

        assert response.status_code == 200
        data = response.json()
        assert data["job_id"] == "test-job-123"
        assert data["job_type"] == "PLAYERS"
        assert data["status"] == "COMPLETED"
        assert data["records_processed"] == 1800

    def test_trigger_schedule_sync(self, client, mock_dependencies):
        """Test triggering manual schedule sync."""
        job = SyncJob(
            job_id="test-job-456",
            job_type=SyncJobType.SCHEDULES,
            status=SyncJobStatus.COMPLETED,
            records_processed=272,
        )
        mock_dependencies['sync'].trigger_manual_sync = AsyncMock(return_value=job)

        response = client.post("/api/v1/admin/sync/schedules")

        assert response.status_code == 200
        data = response.json()
        assert data["job_type"] == "SCHEDULES"

    def test_trigger_live_scores_sync(self, client, mock_dependencies):
        """Test triggering manual live scores sync."""
        job = SyncJob(
            job_id="test-job-789",
            job_type=SyncJobType.LIVE_SCORES,
            status=SyncJobStatus.COMPLETED,
            records_processed=100,
            records_updated=8,
        )
        mock_dependencies['sync'].trigger_manual_sync = AsyncMock(return_value=job)

        response = client.post("/api/v1/admin/sync/live-scores")

        assert response.status_code == 200
        data = response.json()
        assert data["job_type"] == "LIVE_SCORES"

    def test_get_sync_status(self, client, mock_dependencies):
        """Test getting sync job status."""
        job = SyncJob(
            job_id="lookup-job-123",
            job_type=SyncJobType.PLAYERS,
            status=SyncJobStatus.COMPLETED,
        )
        mock_dependencies['sync'].get_sync_history.return_value = [job]

        response = client.get("/api/v1/admin/sync/lookup-job-123")

        assert response.status_code == 200
        data = response.json()
        assert data["job_id"] == "lookup-job-123"

    def test_get_sync_status_not_found(self, client, mock_dependencies):
        """Test getting non-existent sync job."""
        mock_dependencies['sync'].get_current_job.return_value = None
        mock_dependencies['sync'].get_sync_history.return_value = []

        response = client.get("/api/v1/admin/sync/nonexistent")

        assert response.status_code == 404

    def test_get_sync_history(self, client, mock_dependencies):
        """Test getting sync history."""
        jobs = [
            SyncJob(job_id="job-1", job_type=SyncJobType.PLAYERS, status=SyncJobStatus.COMPLETED),
            SyncJob(job_id="job-2", job_type=SyncJobType.SCHEDULES, status=SyncJobStatus.COMPLETED),
        ]
        mock_dependencies['sync'].get_sync_history.return_value = jobs

        response = client.get("/api/v1/admin/sync/history?limit=10")

        assert response.status_code == 200
        data = response.json()
        assert data["total_count"] == 2

    def test_get_metrics(self, client, mock_dependencies):
        """Test getting sync metrics."""
        jobs = [
            SyncJob(
                job_id="job-1",
                job_type=SyncJobType.PLAYERS,
                status=SyncJobStatus.COMPLETED,
                started_at=datetime.utcnow(),
                completed_at=datetime.utcnow(),
                records_processed=100,
                records_updated=10,
            ),
        ]
        mock_dependencies['sync'].get_sync_history.return_value = jobs

        response = client.get("/api/v1/admin/metrics")

        assert response.status_code == 200
        data = response.json()
        assert "nfl_sync_jobs_total" in data
        assert "nfl_sync_success_rate" in data


class TestWebSocketEndpoints:
    """Test WebSocket statistics endpoint."""

    def test_websocket_stats(self, client):
        """Test getting WebSocket statistics."""
        response = client.get("/ws/stats")

        assert response.status_code == 200
        data = response.json()
        assert "active_connections" in data
        assert "league_subscriptions" in data
        assert "player_subscriptions" in data
