"""
NFL Data Sync Job

Scheduled job that polls nfl_data_py every minute during active games
and pushes deltas via WebSocket to connected clients.
"""
import logging
import uuid
from datetime import datetime
from typing import Optional

from apscheduler.schedulers.asyncio import AsyncIOScheduler
from apscheduler.triggers.interval import IntervalTrigger
from apscheduler.triggers.cron import CronTrigger

from src.config.settings import NflSyncSettings
from src.domain.models import SyncJob, SyncJobStatus, SyncJobType
from src.domain.ports import NflDataProvider
from src.infrastructure.adapters.redis_delta_service import DeltaDetectionService
from src.infrastructure.adapters.websocket_service import ws_manager
from src.application.services.fantasy_scoring_engine import scoring_engine

logger = logging.getLogger(__name__)


class NflDataSyncJob:
    """
    Scheduled job that polls nflverse data and pushes deltas via WebSocket.

    Responsibilities:
    - Poll nfl_data_py every minute during games
    - Detect changes using Redis delta service
    - Calculate fantasy points for changed stats
    - Push updates via WebSocket
    """

    def __init__(
        self,
        settings: NflSyncSettings,
        nfl_provider: NflDataProvider,
        delta_service: DeltaDetectionService,
    ):
        """
        Initialize the sync job.

        Args:
            settings: Sync configuration settings
            nfl_provider: NFL data provider adapter
            delta_service: Delta detection service
        """
        self.settings = settings
        self.nfl_provider = nfl_provider
        self.delta_service = delta_service
        self.scheduler = AsyncIOScheduler()
        self._current_job: Optional[SyncJob] = None
        self._sync_history: list[SyncJob] = []

    def start(self):
        """Start the sync scheduler."""
        if not self.settings.enabled:
            logger.info("NFL data sync is disabled")
            return

        # Schedule live data sync (every minute during games)
        self.scheduler.add_job(
            self.sync_nfl_data,
            trigger=IntervalTrigger(seconds=self.settings.interval_seconds),
            id="nfl_data_sync",
            replace_existing=True,
            max_instances=1,
        )

        # Schedule daily player sync at 6 AM
        self.scheduler.add_job(
            self.sync_players,
            trigger=CronTrigger.from_crontab("0 6 * * *"),
            id="nfl_player_sync",
            replace_existing=True,
            max_instances=1,
        )

        # Schedule weekly schedule sync on Monday
        self.scheduler.add_job(
            self.sync_schedules,
            trigger=CronTrigger.from_crontab("0 0 * * 1"),
            id="nfl_schedule_sync",
            replace_existing=True,
            max_instances=1,
        )

        self.scheduler.start()
        logger.info(
            f"NFL data sync started (live interval: {self.settings.interval_seconds}s)"
        )

    def stop(self):
        """Stop the sync scheduler."""
        self.scheduler.shutdown()
        logger.info("NFL data sync stopped")

    async def sync_nfl_data(self) -> Optional[SyncJob]:
        """
        Main sync job - runs every minute during active games.

        Fetches latest stats and game scores, detects deltas,
        calculates fantasy points, and pushes via WebSocket.

        Returns:
            SyncJob with results
        """
        job = SyncJob(
            job_id=str(uuid.uuid4()),
            job_type=SyncJobType.LIVE_SCORES,
            status=SyncJobStatus.IN_PROGRESS,
            started_at=datetime.utcnow(),
        )
        self._current_job = job

        try:
            logger.info("Starting NFL data sync...")

            current_season = self.nfl_provider.get_current_season()
            current_week = self.nfl_provider.get_current_week()

            # 1. Fetch latest player stats from nfl_data_py
            player_stats = self.nfl_provider.get_player_stats(current_season, current_week)

            # 2. Detect deltas using Redis
            player_deltas = self.delta_service.detect_player_deltas(player_stats)

            # 3. Calculate fantasy points for changed players
            for delta in player_deltas:
                points = scoring_engine.calculate_all_formats(delta.current_stats)
                delta.fantasy_points = points["standard"]
                delta.fantasy_points_ppr = points["ppr"]
                delta.fantasy_points_half_ppr = points["half_ppr"]

            # 4. Push deltas to clients via WebSocket
            await ws_manager.broadcast_player_deltas(player_deltas)

            # 5. Fetch and push game score updates
            games = self.nfl_provider.get_schedule(current_season)
            current_week_games = [g for g in games if g.week == current_week]

            game_deltas = self.delta_service.detect_game_deltas(current_week_games)
            await ws_manager.broadcast_game_deltas(game_deltas)

            # Update job status
            job.status = SyncJobStatus.COMPLETED
            job.completed_at = datetime.utcnow()
            job.records_processed = len(player_stats) + len(current_week_games)
            job.records_updated = len(player_deltas) + len(game_deltas)

            logger.info(
                f"NFL data sync complete. Player deltas: {len(player_deltas)}, "
                f"Game deltas: {len(game_deltas)}"
            )

            # Broadcast sync status
            await ws_manager.broadcast_sync_status({
                "job_id": job.job_id,
                "status": job.status.value,
                "player_updates": len(player_deltas),
                "game_updates": len(game_deltas),
            })

        except Exception as e:
            logger.error(f"NFL data sync failed: {e}", exc_info=True)
            job.status = SyncJobStatus.FAILED
            job.error_message = str(e)
            job.completed_at = datetime.utcnow()

        self._sync_history.append(job)
        self._current_job = None

        # Keep only last 100 jobs in history
        if len(self._sync_history) > 100:
            self._sync_history = self._sync_history[-100:]

        return job

    async def sync_players(self) -> Optional[SyncJob]:
        """
        Sync NFL player roster data.

        Runs daily at 6 AM to update player profiles.

        Returns:
            SyncJob with results
        """
        job = SyncJob(
            job_id=str(uuid.uuid4()),
            job_type=SyncJobType.PLAYERS,
            status=SyncJobStatus.IN_PROGRESS,
            started_at=datetime.utcnow(),
        )

        try:
            logger.info("Starting player sync...")

            current_season = self.nfl_provider.get_current_season()
            players = self.nfl_provider.get_rosters(current_season)

            job.status = SyncJobStatus.COMPLETED
            job.completed_at = datetime.utcnow()
            job.records_processed = len(players)
            job.records_updated = len(players)

            logger.info(f"Player sync complete. Processed {len(players)} players")

        except Exception as e:
            logger.error(f"Player sync failed: {e}", exc_info=True)
            job.status = SyncJobStatus.FAILED
            job.error_message = str(e)
            job.completed_at = datetime.utcnow()

        self._sync_history.append(job)
        return job

    async def sync_schedules(self) -> Optional[SyncJob]:
        """
        Sync NFL game schedules.

        Runs weekly on Monday to update game times.

        Returns:
            SyncJob with results
        """
        job = SyncJob(
            job_id=str(uuid.uuid4()),
            job_type=SyncJobType.SCHEDULES,
            status=SyncJobStatus.IN_PROGRESS,
            started_at=datetime.utcnow(),
        )

        try:
            logger.info("Starting schedule sync...")

            current_season = self.nfl_provider.get_current_season()
            games = self.nfl_provider.get_schedule(current_season)

            job.status = SyncJobStatus.COMPLETED
            job.completed_at = datetime.utcnow()
            job.records_processed = len(games)
            job.records_updated = len(games)

            logger.info(f"Schedule sync complete. Processed {len(games)} games")

        except Exception as e:
            logger.error(f"Schedule sync failed: {e}", exc_info=True)
            job.status = SyncJobStatus.FAILED
            job.error_message = str(e)
            job.completed_at = datetime.utcnow()

        self._sync_history.append(job)
        return job

    async def trigger_manual_sync(self, job_type: SyncJobType) -> SyncJob:
        """
        Manually trigger a sync job.

        Args:
            job_type: Type of sync to trigger

        Returns:
            SyncJob with results
        """
        if job_type == SyncJobType.PLAYERS:
            return await self.sync_players()
        elif job_type == SyncJobType.SCHEDULES:
            return await self.sync_schedules()
        elif job_type == SyncJobType.LIVE_SCORES:
            return await self.sync_nfl_data()
        elif job_type == SyncJobType.PLAYER_STATS:
            return await self.sync_nfl_data()
        else:
            raise ValueError(f"Unknown job type: {job_type}")

    def get_sync_history(self, limit: int = 10) -> list[SyncJob]:
        """Get recent sync job history."""
        return self._sync_history[-limit:]

    def get_current_job(self) -> Optional[SyncJob]:
        """Get currently running sync job."""
        return self._current_job
