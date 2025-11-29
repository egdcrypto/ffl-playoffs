"""
Integration Test: NFL Data Extraction and MongoDB Persistence

This test extracts real NFL data using nfl_data_py and persists it to MongoDB.
Run with: pytest tests/integration/test_nfl_data_extraction.py -v -s
"""
import asyncio
import logging
import pytest
from datetime import datetime

# Configure logging
logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)


class TestNFLDataExtraction:
    """Integration tests for NFL data extraction and persistence"""

    @pytest.fixture(autouse=True)
    def setup(self):
        """Setup test environment"""
        # Import here to avoid issues if dependencies aren't installed
        import nfl_data_py as nfl
        self.nfl = nfl

    @pytest.mark.asyncio
    async def test_extract_and_persist_player_stats(self):
        """
        Test extracting player stats from nfl_data_py and persisting to MongoDB.

        This test:
        1. Fetches weekly player stats from nfl_data_py
        2. Transforms to domain models
        3. Persists to MongoDB
        4. Verifies data was saved correctly
        """
        from src.infrastructure.adapters.mongodb_repositories import (
            MongoDBConnection,
            MongoPlayerStatsRepository
        )
        from src.domain.models import PlayerStats

        # Connect to MongoDB
        db = await MongoDBConnection.connect()
        repo = MongoPlayerStatsRepository(db)

        try:
            # Get current season (2024 is most recent with data)
            season = 2024
            week = 15  # Use a completed week with data

            logger.info(f"Fetching player stats for {season} week {week}...")

            # Fetch weekly stats from nfl_data_py
            weekly_df = self.nfl.import_weekly_data([season])

            # Filter to specific week
            week_stats = weekly_df[weekly_df['week'] == week]

            logger.info(f"Retrieved {len(week_stats)} player records for week {week}")

            # Transform to domain models
            stats_list = []
            for _, row in week_stats.iterrows():
                try:
                    stats = PlayerStats(
                        player_id=str(row.get('player_id', row.get('player_name', 'unknown'))),
                        player_name=str(row.get('player_name', row.get('player_display_name', 'Unknown'))),
                        week=int(row.get('week', week)),
                        season=int(row.get('season', season)),
                        team=str(row.get('recent_team', '')) if row.get('recent_team') else None,
                        position=str(row.get('position', '')) if row.get('position') else None,
                        # Passing
                        passing_yards=int(row.get('passing_yards', 0) or 0),
                        passing_tds=int(row.get('passing_tds', 0) or 0),
                        interceptions=int(row.get('interceptions', 0) or 0),
                        passing_attempts=int(row.get('attempts', 0) or 0),
                        passing_completions=int(row.get('completions', 0) or 0),
                        # Rushing
                        rushing_yards=int(row.get('rushing_yards', 0) or 0),
                        rushing_tds=int(row.get('rushing_tds', 0) or 0),
                        rushing_attempts=int(row.get('carries', 0) or 0),
                        # Receiving
                        receptions=int(row.get('receptions', 0) or 0),
                        receiving_yards=int(row.get('receiving_yards', 0) or 0),
                        receiving_tds=int(row.get('receiving_tds', 0) or 0),
                        targets=int(row.get('targets', 0) or 0),
                        # Other
                        fumbles_lost=int(row.get('sack_fumbles_lost', 0) or 0),
                    )
                    stats_list.append(stats)
                except Exception as e:
                    logger.warning(f"Error parsing row: {e}")
                    continue

            logger.info(f"Transformed {len(stats_list)} records to domain models")

            # Persist to MongoDB
            logger.info("Persisting to MongoDB...")
            saved = await repo.save_all(stats_list)
            logger.info(f"Saved {len(saved)} player stats records to MongoDB")

            # Verify persistence
            retrieved = await repo.find_by_week(season, week)
            logger.info(f"Retrieved {len(retrieved)} records from MongoDB")

            assert len(retrieved) > 0, "Expected to retrieve persisted stats"

            # Verify some data integrity
            sample = retrieved[0]
            assert sample.season == season
            assert sample.week == week
            assert sample.player_name is not None

            logger.info(f"Sample record: {sample.player_name} - {sample.team}")
            logger.info("✅ Integration test passed!")

        finally:
            await MongoDBConnection.disconnect()

    @pytest.mark.asyncio
    async def test_extract_and_persist_schedule(self):
        """
        Test extracting NFL schedule and persisting to MongoDB.
        """
        from src.infrastructure.adapters.mongodb_repositories import (
            MongoDBConnection,
            MongoNFLGameRepository
        )
        from src.domain.models import NFLGame, GameStatus

        db = await MongoDBConnection.connect()
        repo = MongoNFLGameRepository(db)

        try:
            season = 2024

            logger.info(f"Fetching schedule for {season}...")

            # Fetch schedule
            schedule_df = self.nfl.import_schedules([season])

            logger.info(f"Retrieved {len(schedule_df)} games")

            # Transform to domain models
            games_list = []
            for _, row in schedule_df.iterrows():
                try:
                    # Determine game status based on result
                    status = GameStatus.SCHEDULED
                    if row.get('result') is not None and str(row.get('result')) != 'nan':
                        status = GameStatus.FINAL

                    game = NFLGame(
                        game_id=str(row.get('game_id', f"{season}_{row.get('week', 0)}_{row.get('home_team', '')}_{row.get('away_team', '')}")),
                        season=int(row.get('season', season)),
                        week=int(row.get('week', 0)),
                        home_team=str(row.get('home_team', '')),
                        away_team=str(row.get('away_team', '')),
                        home_score=int(row.get('home_score', 0) or 0) if row.get('home_score') and str(row.get('home_score')) != 'nan' else None,
                        away_score=int(row.get('away_score', 0) or 0) if row.get('away_score') and str(row.get('away_score')) != 'nan' else None,
                        status=status,
                        venue=str(row.get('stadium', '')) if row.get('stadium') else None,
                    )
                    games_list.append(game)
                except Exception as e:
                    logger.warning(f"Error parsing game row: {e}")
                    continue

            logger.info(f"Transformed {len(games_list)} games to domain models")

            # Persist to MongoDB
            logger.info("Persisting games to MongoDB...")
            saved = await repo.save_all(games_list)
            logger.info(f"Saved {len(saved)} games to MongoDB")

            # Verify persistence - get week 15 games
            week_games = await repo.find_by_week(season, 15)
            logger.info(f"Retrieved {len(week_games)} games for week 15")

            assert len(week_games) > 0, "Expected to retrieve games for week 15"

            # Print sample
            for game in week_games[:3]:
                logger.info(f"  {game.away_team} @ {game.home_team}: {game.away_score}-{game.home_score}")

            logger.info("✅ Schedule integration test passed!")

        finally:
            await MongoDBConnection.disconnect()

    @pytest.mark.asyncio
    async def test_extract_and_persist_rosters(self):
        """
        Test extracting NFL rosters and persisting to MongoDB.
        """
        from src.infrastructure.adapters.mongodb_repositories import (
            MongoDBConnection,
            MongoNFLPlayerRepository
        )
        from src.domain.models import NFLPlayer

        db = await MongoDBConnection.connect()
        repo = MongoNFLPlayerRepository(db)

        try:
            season = 2024

            logger.info(f"Fetching rosters for {season}...")

            # Fetch rosters
            roster_df = self.nfl.import_seasonal_rosters([season])

            logger.info(f"Retrieved {len(roster_df)} roster entries")

            # Transform to domain models (deduplicate by player_id)
            players_dict = {}
            for _, row in roster_df.iterrows():
                try:
                    player_id = str(row.get('player_id', row.get('gsis_id', '')))
                    if not player_id or player_id == 'nan':
                        continue

                    player = NFLPlayer(
                        player_id=player_id,
                        name=str(row.get('player_name', row.get('full_name', 'Unknown'))),
                        first_name=str(row.get('first_name', '')) if row.get('first_name') else None,
                        last_name=str(row.get('last_name', '')) if row.get('last_name') else None,
                        position=str(row.get('position', '')) if row.get('position') else None,
                        team=str(row.get('team', '')) if row.get('team') else None,
                        jersey_number=int(row.get('jersey_number', 0) or 0) if row.get('jersey_number') and str(row.get('jersey_number')) != 'nan' else None,
                        status=str(row.get('status', 'ACTIVE')),
                    )
                    players_dict[player_id] = player
                except Exception as e:
                    logger.warning(f"Error parsing roster row: {e}")
                    continue

            players_list = list(players_dict.values())
            logger.info(f"Transformed {len(players_list)} unique players")

            # Persist to MongoDB
            logger.info("Persisting players to MongoDB...")
            saved = await repo.save_all(players_list)
            logger.info(f"Saved {len(saved)} players to MongoDB")

            # Verify persistence
            count = await repo.count()
            logger.info(f"Total players in MongoDB: {count}")

            # Get players by team
            chiefs = await repo.find_by_team("KC")
            logger.info(f"Kansas City Chiefs players: {len(chiefs)}")

            if chiefs:
                for p in chiefs[:5]:
                    logger.info(f"  {p.name} - {p.position} #{p.jersey_number}")

            assert count > 0, "Expected to have players in MongoDB"

            logger.info("✅ Roster integration test passed!")

        finally:
            await MongoDBConnection.disconnect()


class TestFullDataPipeline:
    """Test the complete data extraction and persistence pipeline"""

    @pytest.fixture(autouse=True)
    def setup(self):
        """Setup test environment"""
        import nfl_data_py as nfl
        self.nfl = nfl

    @pytest.mark.asyncio
    async def test_full_sync_pipeline(self):
        """
        Test the complete sync pipeline:
        1. Extract rosters
        2. Extract schedule
        3. Extract player stats
        4. Persist all to MongoDB
        5. Query and display summary
        """
        from src.infrastructure.adapters.mongodb_repositories import (
            MongoDBConnection,
            MongoNFLPlayerRepository,
            MongoNFLGameRepository,
            MongoPlayerStatsRepository
        )
        from src.domain.models import NFLPlayer, NFLGame, PlayerStats, GameStatus

        db = await MongoDBConnection.connect()

        player_repo = MongoNFLPlayerRepository(db)
        game_repo = MongoNFLGameRepository(db)
        stats_repo = MongoPlayerStatsRepository(db)

        try:
            season = 2024
            week = 15

            logger.info("=" * 60)
            logger.info(f"FULL SYNC PIPELINE TEST - Season {season}")
            logger.info("=" * 60)

            # Step 1: Sync rosters
            logger.info("\n📋 Step 1: Syncing rosters...")
            roster_df = self.nfl.import_seasonal_rosters([season])
            players_dict = {}
            for _, row in roster_df.iterrows():
                player_id = str(row.get('player_id', ''))
                if player_id and player_id != 'nan':
                    players_dict[player_id] = NFLPlayer(
                        player_id=player_id,
                        name=str(row.get('player_name', 'Unknown')),
                        position=str(row.get('position', '')) if row.get('position') else None,
                        team=str(row.get('team', '')) if row.get('team') else None,
                    )
            await player_repo.save_all(list(players_dict.values()))
            player_count = await player_repo.count()
            logger.info(f"   ✅ Synced {player_count} players")

            # Step 2: Sync schedule
            logger.info("\n📅 Step 2: Syncing schedule...")
            schedule_df = self.nfl.import_schedules([season])
            games_list = []
            for _, row in schedule_df.iterrows():
                status = GameStatus.FINAL if row.get('result') and str(row.get('result')) != 'nan' else GameStatus.SCHEDULED
                games_list.append(NFLGame(
                    game_id=str(row.get('game_id', '')),
                    season=season,
                    week=int(row.get('week', 0)),
                    home_team=str(row.get('home_team', '')),
                    away_team=str(row.get('away_team', '')),
                    home_score=int(row.get('home_score') or 0) if str(row.get('home_score')) != 'nan' else None,
                    away_score=int(row.get('away_score') or 0) if str(row.get('away_score')) != 'nan' else None,
                    status=status,
                ))
            await game_repo.save_all(games_list)
            logger.info(f"   ✅ Synced {len(games_list)} games")

            # Step 3: Sync player stats for week
            logger.info(f"\n📊 Step 3: Syncing player stats (week {week})...")
            weekly_df = self.nfl.import_weekly_data([season])
            week_stats = weekly_df[weekly_df['week'] == week]
            stats_list = []
            for _, row in week_stats.iterrows():
                stats_list.append(PlayerStats(
                    player_id=str(row.get('player_id', '')),
                    player_name=str(row.get('player_name', 'Unknown')),
                    week=week,
                    season=season,
                    team=str(row.get('recent_team', '')) if row.get('recent_team') else None,
                    position=str(row.get('position', '')) if row.get('position') else None,
                    passing_yards=int(row.get('passing_yards', 0) or 0),
                    passing_tds=int(row.get('passing_tds', 0) or 0),
                    rushing_yards=int(row.get('rushing_yards', 0) or 0),
                    rushing_tds=int(row.get('rushing_tds', 0) or 0),
                    receptions=int(row.get('receptions', 0) or 0),
                    receiving_yards=int(row.get('receiving_yards', 0) or 0),
                    receiving_tds=int(row.get('receiving_tds', 0) or 0),
                ))
            await stats_repo.save_all(stats_list)
            logger.info(f"   ✅ Synced {len(stats_list)} stat records")

            # Step 4: Summary
            logger.info("\n" + "=" * 60)
            logger.info("SYNC SUMMARY")
            logger.info("=" * 60)

            final_player_count = await player_repo.count()
            logger.info(f"   Players in MongoDB: {final_player_count}")

            week_games = await game_repo.find_by_week(season, week)
            logger.info(f"   Games for week {week}: {len(week_games)}")

            week_stats = await stats_repo.find_by_week(season, week)
            logger.info(f"   Stats for week {week}: {len(week_stats)}")

            # Show top performers
            logger.info("\n📈 Top Performers (Week 15):")
            # Sort by fantasy-relevant stats
            top_passers = sorted(
                [s for s in week_stats if s.passing_yards > 0],
                key=lambda x: x.passing_yards,
                reverse=True
            )[:3]

            for p in top_passers:
                logger.info(f"   QB: {p.player_name} - {p.passing_yards} yds, {p.passing_tds} TD")

            top_rushers = sorted(
                [s for s in week_stats if s.rushing_yards > 0],
                key=lambda x: x.rushing_yards,
                reverse=True
            )[:3]

            for p in top_rushers:
                logger.info(f"   RB: {p.player_name} - {p.rushing_yards} yds, {p.rushing_tds} TD")

            top_receivers = sorted(
                [s for s in week_stats if s.receiving_yards > 0],
                key=lambda x: x.receiving_yards,
                reverse=True
            )[:3]

            for p in top_receivers:
                logger.info(f"   WR: {p.player_name} - {p.receptions} rec, {p.receiving_yards} yds, {p.receiving_tds} TD")

            logger.info("\n" + "=" * 60)
            logger.info("✅ FULL SYNC PIPELINE TEST PASSED!")
            logger.info("=" * 60)

            assert final_player_count > 0
            assert len(week_games) > 0
            assert len(week_stats) > 0

        finally:
            await MongoDBConnection.disconnect()


if __name__ == "__main__":
    # Run the full pipeline test directly
    asyncio.run(TestFullDataPipeline().test_full_sync_pipeline())
