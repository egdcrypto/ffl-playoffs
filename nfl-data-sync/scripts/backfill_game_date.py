#!/usr/bin/env python3
"""
Migration script to backfill game_date field for existing NFL games.

This script:
1. Connects to MongoDB
2. Finds all games missing game_date field
3. Extracts game_date from game_time (if available)
4. Updates records with game_date

Usage:
    python scripts/backfill_game_date.py

FFL-36: Add Game Date to NFL Games Data Model
"""
import asyncio
import logging
import sys
from datetime import datetime
from pathlib import Path

# Add src to path so we can import our modules
sys.path.insert(0, str(Path(__file__).parent.parent))

from motor.motor_asyncio import AsyncIOMotorClient
from src.config.settings import get_settings

logging.basicConfig(
    level=logging.INFO,
    format='%(asctime)s - %(name)s - %(levelname)s - %(message)s'
)
logger = logging.getLogger(__name__)


async def backfill_game_dates():
    """Backfill game_date for all existing game records."""
    settings = get_settings()

    # Connect to MongoDB
    logger.info(f"Connecting to MongoDB: {settings.mongo.url}")
    client = AsyncIOMotorClient(settings.mongo.url)
    db = client[settings.mongo.database]
    collection = db["nfl_games"]

    try:
        # Find all games without game_date
        games_without_date = await collection.count_documents({"game_date": {"$exists": False}})
        logger.info(f"Found {games_without_date} games without game_date field")

        if games_without_date == 0:
            logger.info("No games to update. All games already have game_date.")
            return

        # Process games in batches
        updated_count = 0
        failed_count = 0

        cursor = collection.find({"game_date": {"$exists": False}})
        async for game in cursor:
            try:
                game_id = game.get("game_id")
                game_time = game.get("game_time")

                if game_time:
                    # Extract just the date part from game_time
                    if isinstance(game_time, datetime):
                        game_date = game_time.replace(hour=0, minute=0, second=0, microsecond=0)
                    else:
                        # If game_time is a string, try to parse it
                        logger.warning(f"game_time is not a datetime for game {game_id}: {type(game_time)}")
                        continue

                    # Update the game with game_date
                    result = await collection.update_one(
                        {"game_id": game_id},
                        {"$set": {"game_date": game_date}}
                    )

                    if result.modified_count > 0:
                        updated_count += 1
                        logger.debug(f"Updated game {game_id} with game_date: {game_date}")
                else:
                    logger.warning(f"Game {game_id} has no game_time, cannot set game_date")
                    failed_count += 1

            except Exception as e:
                logger.error(f"Error processing game {game.get('game_id')}: {e}")
                failed_count += 1
                continue

        logger.info(f"Migration complete!")
        logger.info(f"  - Updated: {updated_count} games")
        logger.info(f"  - Failed: {failed_count} games")

        # Verify the migration
        remaining = await collection.count_documents({"game_date": {"$exists": False}})
        logger.info(f"  - Remaining games without game_date: {remaining}")

    finally:
        client.close()
        logger.info("MongoDB connection closed")


async def verify_migration():
    """Verify that all games have game_date field."""
    settings = get_settings()

    logger.info("Verifying migration...")
    client = AsyncIOMotorClient(settings.mongo.url)
    db = client[settings.mongo.database]
    collection = db["nfl_games"]

    try:
        total_games = await collection.count_documents({})
        games_with_date = await collection.count_documents({"game_date": {"$exists": True}})
        games_without_date = await collection.count_documents({"game_date": {"$exists": False}})

        logger.info(f"Verification Results:")
        logger.info(f"  - Total games: {total_games}")
        logger.info(f"  - Games with game_date: {games_with_date}")
        logger.info(f"  - Games without game_date: {games_without_date}")

        if games_without_date == 0:
            logger.info("SUCCESS: All games have game_date field!")
        else:
            logger.warning(f"WARNING: {games_without_date} games still missing game_date")

    finally:
        client.close()


async def main():
    """Main entry point."""
    logger.info("=" * 60)
    logger.info("FFL-36: Backfill game_date Migration Script")
    logger.info("=" * 60)

    # Run the backfill
    await backfill_game_dates()

    # Verify the results
    await verify_migration()

    logger.info("=" * 60)
    logger.info("Migration script complete!")
    logger.info("=" * 60)


if __name__ == "__main__":
    asyncio.run(main())
