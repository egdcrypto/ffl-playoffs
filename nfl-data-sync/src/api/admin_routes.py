"""
Admin API Routes

REST endpoints for admin operations:
- Manual sync triggers
- Sync status and history
- Metrics and monitoring
"""
import logging
from datetime import datetime
from typing import List, Optional

from fastapi import APIRouter, HTTPException, Depends, Query
from pydantic import BaseModel

from src.domain.models import SyncJob, SyncJobType, SyncJobStatus

logger = logging.getLogger(__name__)

router = APIRouter(prefix="/admin", tags=["admin"])


class SyncTriggerRequest(BaseModel):
    """Request to trigger a manual sync"""
    job_type: SyncJobType


class SyncJobResponse(BaseModel):
    """Response for sync job status"""
    job_id: str
    job_type: str
    status: str
    started_at: Optional[datetime]
    completed_at: Optional[datetime]
    records_processed: int
    records_updated: int
    error_message: Optional[str]
    duration_seconds: Optional[float]


class SyncHistoryResponse(BaseModel):
    """Response for sync history"""
    jobs: List[SyncJobResponse]
    total_count: int


class HealthResponse(BaseModel):
    """Health check response"""
    status: str
    timestamp: datetime
    components: dict


# Dependency for sync job instance (injected by main app)
_sync_job_instance = None


def get_sync_job():
    """Get the sync job instance."""
    if _sync_job_instance is None:
        raise HTTPException(status_code=503, detail="Sync service not initialized")
    return _sync_job_instance


def set_sync_job(sync_job):
    """Set the sync job instance (called during app startup)."""
    global _sync_job_instance
    _sync_job_instance = sync_job


def _job_to_response(job: SyncJob) -> SyncJobResponse:
    """Convert SyncJob to API response."""
    duration = None
    if job.started_at and job.completed_at:
        duration = (job.completed_at - job.started_at).total_seconds()

    return SyncJobResponse(
        job_id=job.job_id,
        job_type=job.job_type.value,
        status=job.status.value,
        started_at=job.started_at,
        completed_at=job.completed_at,
        records_processed=job.records_processed,
        records_updated=job.records_updated,
        error_message=job.error_message,
        duration_seconds=duration,
    )


@router.post("/sync/players", response_model=SyncJobResponse)
async def trigger_player_sync(sync_job=Depends(get_sync_job)):
    """
    Trigger a manual player data sync.

    Returns the sync job status and ID for tracking.
    """
    logger.info("Manual player sync triggered")
    job = await sync_job.trigger_manual_sync(SyncJobType.PLAYERS)
    return _job_to_response(job)


@router.post("/sync/schedules", response_model=SyncJobResponse)
async def trigger_schedule_sync(sync_job=Depends(get_sync_job)):
    """
    Trigger a manual schedule sync.

    Returns the sync job status and ID for tracking.
    """
    logger.info("Manual schedule sync triggered")
    job = await sync_job.trigger_manual_sync(SyncJobType.SCHEDULES)
    return _job_to_response(job)


@router.post("/sync/live-scores", response_model=SyncJobResponse)
async def trigger_live_scores_sync(sync_job=Depends(get_sync_job)):
    """
    Trigger a manual live scores sync.

    Returns the sync job status and ID for tracking.
    """
    logger.info("Manual live scores sync triggered")
    job = await sync_job.trigger_manual_sync(SyncJobType.LIVE_SCORES)
    return _job_to_response(job)


@router.get("/sync/{job_id}", response_model=SyncJobResponse)
async def get_sync_status(job_id: str, sync_job=Depends(get_sync_job)):
    """
    Get status of a specific sync job.

    Args:
        job_id: The sync job ID to look up

    Returns:
        SyncJobResponse with job status
    """
    # Check current job
    current = sync_job.get_current_job()
    if current and current.job_id == job_id:
        return _job_to_response(current)

    # Check history
    history = sync_job.get_sync_history(limit=100)
    for job in history:
        if job.job_id == job_id:
            return _job_to_response(job)

    raise HTTPException(status_code=404, detail=f"Sync job {job_id} not found")


@router.get("/sync/history", response_model=SyncHistoryResponse)
async def get_sync_history(
    limit: int = Query(default=10, ge=1, le=100),
    job_type: Optional[SyncJobType] = None,
    sync_job=Depends(get_sync_job),
):
    """
    Get sync job history.

    Args:
        limit: Maximum number of jobs to return (default: 10)
        job_type: Filter by job type (optional)

    Returns:
        SyncHistoryResponse with job list
    """
    history = sync_job.get_sync_history(limit=limit)

    if job_type:
        history = [j for j in history if j.job_type == job_type]

    return SyncHistoryResponse(
        jobs=[_job_to_response(j) for j in history],
        total_count=len(history),
    )


@router.get("/health", response_model=HealthResponse)
async def health_check(sync_job=Depends(get_sync_job)):
    """
    Health check endpoint.

    Returns service health status and component states.
    """
    # Check if sync is running
    current_job = sync_job.get_current_job()
    sync_status = "busy" if current_job else "idle"

    # Get recent history to determine health
    recent_jobs = sync_job.get_sync_history(limit=5)
    failed_count = sum(1 for j in recent_jobs if j.status == SyncJobStatus.FAILED)
    sync_health = "healthy" if failed_count < 3 else "degraded"

    return HealthResponse(
        status="healthy" if sync_health == "healthy" else "degraded",
        timestamp=datetime.utcnow(),
        components={
            "sync_scheduler": {
                "status": sync_status,
                "health": sync_health,
                "recent_failures": failed_count,
            },
            "current_job": {
                "job_id": current_job.job_id if current_job else None,
                "type": current_job.job_type.value if current_job else None,
            },
        },
    )


@router.get("/metrics")
async def get_metrics(sync_job=Depends(get_sync_job)):
    """
    Get sync metrics for monitoring.

    Returns counts and performance metrics.
    """
    history = sync_job.get_sync_history(limit=100)

    # Calculate metrics
    total_jobs = len(history)
    completed_jobs = sum(1 for j in history if j.status == SyncJobStatus.COMPLETED)
    failed_jobs = sum(1 for j in history if j.status == SyncJobStatus.FAILED)

    # Calculate average duration
    durations = []
    for job in history:
        if job.started_at and job.completed_at:
            duration = (job.completed_at - job.started_at).total_seconds()
            durations.append(duration)

    avg_duration = sum(durations) / len(durations) if durations else 0

    # Records processed
    total_records = sum(j.records_processed for j in history)
    total_updates = sum(j.records_updated for j in history)

    return {
        "nfl_sync_jobs_total": total_jobs,
        "nfl_sync_jobs_completed": completed_jobs,
        "nfl_sync_jobs_failed": failed_jobs,
        "nfl_sync_duration_avg_seconds": round(avg_duration, 2),
        "nfl_sync_records_processed_total": total_records,
        "nfl_sync_records_updated_total": total_updates,
        "nfl_sync_success_rate": (
            round(completed_jobs / total_jobs * 100, 2) if total_jobs > 0 else 100.0
        ),
    }
