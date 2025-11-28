"""
NFL Data Sync Service - Main Application

FastAPI application entry point for the NFL Data Sync microservice.
Provides scheduled data synchronization from nflverse and real-time
WebSocket updates to connected clients.
"""
import logging
import sys
from contextlib import asynccontextmanager

import structlog
from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware

from src.api import admin_routes, websocket_routes
from src.api.admin_routes import set_sync_job
from src.config.settings import get_settings
from src.infrastructure.adapters.nfl_data_py_adapter import NflDataPyAdapter
from src.infrastructure.adapters.redis_delta_service import DeltaDetectionService
from src.infrastructure.scheduler.nfl_data_sync_job import NflDataSyncJob

# Configure logging
structlog.configure(
    processors=[
        structlog.stdlib.filter_by_level,
        structlog.stdlib.add_logger_name,
        structlog.stdlib.add_log_level,
        structlog.processors.TimeStamper(fmt="iso"),
        structlog.processors.StackInfoRenderer(),
        structlog.processors.format_exc_info,
        structlog.processors.JSONRenderer()
    ],
    wrapper_class=structlog.stdlib.BoundLogger,
    context_class=dict,
    logger_factory=structlog.stdlib.LoggerFactory(),
    cache_logger_on_first_use=True,
)

logging.basicConfig(
    format="%(message)s",
    stream=sys.stdout,
    level=logging.INFO,
)

logger = structlog.get_logger(__name__)

# Global instances
settings = get_settings()
nfl_provider = None
delta_service = None
sync_job = None


@asynccontextmanager
async def lifespan(app: FastAPI):
    """
    Application lifespan manager.

    Sets up and tears down resources on startup and shutdown.
    """
    global nfl_provider, delta_service, sync_job

    logger.info("Starting NFL Data Sync Service...")

    # Initialize NFL data provider
    nfl_provider = NflDataPyAdapter()
    logger.info("NFL data provider initialized")

    # Initialize delta detection service
    delta_service = DeltaDetectionService(
        redis_url=settings.redis.url,
        ttl_seconds=settings.redis.delta_ttl_seconds,
    )
    logger.info("Delta detection service initialized")

    # Initialize and start sync job scheduler
    sync_job = NflDataSyncJob(
        settings=settings.nfl_sync,
        nfl_provider=nfl_provider,
        delta_service=delta_service,
    )
    set_sync_job(sync_job)
    sync_job.start()
    logger.info("Sync scheduler started")

    yield

    # Shutdown
    logger.info("Shutting down NFL Data Sync Service...")
    if sync_job:
        sync_job.stop()
    if delta_service:
        delta_service.close()
    logger.info("Shutdown complete")


# Create FastAPI application
app = FastAPI(
    title="NFL Data Sync Service",
    description=(
        "Microservice for synchronizing NFL data from nflverse and "
        "broadcasting real-time updates via WebSocket."
    ),
    version="0.1.0",
    lifespan=lifespan,
)

# Configure CORS
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],  # Configure appropriately for production
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# Include routers
app.include_router(admin_routes.router, prefix="/api/v1")
app.include_router(websocket_routes.router)


@app.get("/")
async def root():
    """Root endpoint - service info"""
    return {
        "service": "NFL Data Sync Service",
        "version": "0.1.0",
        "status": "running",
        "docs": "/docs",
        "websocket": "/ws",
    }


@app.get("/health")
async def health():
    """Health check endpoint"""
    return {"status": "healthy"}


if __name__ == "__main__":
    import uvicorn

    uvicorn.run(
        "src.main:app",
        host=settings.server.host,
        port=settings.server.port,
        reload=settings.server.debug,
        log_level=settings.server.log_level.lower(),
    )
