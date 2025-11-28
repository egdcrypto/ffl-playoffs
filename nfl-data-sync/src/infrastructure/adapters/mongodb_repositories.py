"""
MongoDB Repository Implementations

Implements the repository ports for persisting NFL data to MongoDB.
Uses Motor for async MongoDB operations.
"""
import logging
from typing import List, Optional
from motor.motor_asyncio import AsyncIOMotorClient, AsyncIOMotorDatabase
from pymongo import UpdateOne

from src.domain.models import NFLGame, NFLPlayer, PlayerStats
from src.domain.ports import NFLGameRepository, NFLPlayerRepository, PlayerStatsRepository
from src.config.settings import get_settings

logger = logging.getLogger(__name__)


class MongoDBConnection:
    """Manages MongoDB connection lifecycle"""

    _client: Optional[AsyncIOMotorClient] = None
    _db: Optional[AsyncIOMotorDatabase] = None

    @classmethod
    async def connect(cls) -> AsyncIOMotorDatabase:
        """Connect to MongoDB and return the database"""
        if cls._client is None:
            settings = get_settings()
            cls._client = AsyncIOMotorClient(settings.mongo.url)
            cls._db = cls._client[settings.mongo.database]
            logger.info(f"Connected to MongoDB: {settings.mongo.database}")
        return cls._db

    @classmethod
    async def disconnect(cls):
        """Close MongoDB connection"""
        if cls._client:
            cls._client.close()
            cls._client = None
            cls._db = None
            logger.info("Disconnected from MongoDB")

    @classmethod
    async def get_database(cls) -> AsyncIOMotorDatabase:
        """Get the database, connecting if necessary"""
        if cls._db is None:
            await cls.connect()
        return cls._db


class MongoNFLPlayerRepository(NFLPlayerRepository):
    """MongoDB implementation of NFL Player repository"""

    COLLECTION_NAME = "nfl_players"

    def __init__(self, db: AsyncIOMotorDatabase = None):
        self._db = db

    async def _get_collection(self):
        if self._db is None:
            self._db = await MongoDBConnection.get_database()
        return self._db[self.COLLECTION_NAME]

    async def save(self, player: NFLPlayer) -> NFLPlayer:
        """Save an NFL player (upsert)"""
        collection = await self._get_collection()
        await collection.update_one(
            {"player_id": player.player_id},
            {"$set": player.model_dump()},
            upsert=True
        )
        logger.debug(f"Saved player: {player.player_id} - {player.name}")
        return player

    async def save_all(self, players: List[NFLPlayer]) -> List[NFLPlayer]:
        """Save multiple NFL players (bulk upsert)"""
        if not players:
            return []

        collection = await self._get_collection()
        operations = [
            UpdateOne(
                {"player_id": p.player_id},
                {"$set": p.model_dump()},
                upsert=True
            )
            for p in players
        ]
        result = await collection.bulk_write(operations)
        logger.info(
            f"Bulk saved {len(players)} players: "
            f"{result.upserted_count} inserted, {result.modified_count} updated"
        )
        return players

    async def find_by_id(self, player_id: str) -> Optional[NFLPlayer]:
        """Find a player by ID"""
        collection = await self._get_collection()
        doc = await collection.find_one({"player_id": player_id})
        if doc:
            doc.pop("_id", None)
            return NFLPlayer(**doc)
        return None

    async def find_all(self) -> List[NFLPlayer]:
        """Find all players"""
        collection = await self._get_collection()
        cursor = collection.find({})
        players = []
        async for doc in cursor:
            doc.pop("_id", None)
            players.append(NFLPlayer(**doc))
        return players

    async def find_by_team(self, team: str) -> List[NFLPlayer]:
        """Find players by team"""
        collection = await self._get_collection()
        cursor = collection.find({"team": team})
        players = []
        async for doc in cursor:
            doc.pop("_id", None)
            players.append(NFLPlayer(**doc))
        return players

    async def count(self) -> int:
        """Count total players"""
        collection = await self._get_collection()
        return await collection.count_documents({})


class MongoNFLGameRepository(NFLGameRepository):
    """MongoDB implementation of NFL Game repository"""

    COLLECTION_NAME = "nfl_games"

    def __init__(self, db: AsyncIOMotorDatabase = None):
        self._db = db

    async def _get_collection(self):
        if self._db is None:
            self._db = await MongoDBConnection.get_database()
        return self._db[self.COLLECTION_NAME]

    async def save(self, game: NFLGame) -> NFLGame:
        """Save an NFL game (upsert)"""
        collection = await self._get_collection()
        await collection.update_one(
            {"game_id": game.game_id},
            {"$set": game.model_dump()},
            upsert=True
        )
        logger.debug(f"Saved game: {game.game_id}")
        return game

    async def save_all(self, games: List[NFLGame]) -> List[NFLGame]:
        """Save multiple NFL games (bulk upsert)"""
        if not games:
            return []

        collection = await self._get_collection()
        operations = [
            UpdateOne(
                {"game_id": g.game_id},
                {"$set": g.model_dump()},
                upsert=True
            )
            for g in games
        ]
        result = await collection.bulk_write(operations)
        logger.info(
            f"Bulk saved {len(games)} games: "
            f"{result.upserted_count} inserted, {result.modified_count} updated"
        )
        return games

    async def find_by_id(self, game_id: str) -> Optional[NFLGame]:
        """Find a game by ID"""
        collection = await self._get_collection()
        doc = await collection.find_one({"game_id": game_id})
        if doc:
            doc.pop("_id", None)
            return NFLGame(**doc)
        return None

    async def find_by_week(self, season: int, week: int) -> List[NFLGame]:
        """Find games for a specific week"""
        collection = await self._get_collection()
        cursor = collection.find({"season": season, "week": week})
        games = []
        async for doc in cursor:
            doc.pop("_id", None)
            games.append(NFLGame(**doc))
        return games

    async def find_active_games(self) -> List[NFLGame]:
        """Find games currently in progress"""
        collection = await self._get_collection()
        cursor = collection.find({
            "status": {"$in": ["IN_PROGRESS", "HALFTIME"]}
        })
        games = []
        async for doc in cursor:
            doc.pop("_id", None)
            games.append(NFLGame(**doc))
        return games


class MongoPlayerStatsRepository(PlayerStatsRepository):
    """MongoDB implementation of Player Stats repository"""

    COLLECTION_NAME = "player_stats"

    def __init__(self, db: AsyncIOMotorDatabase = None):
        self._db = db

    async def _get_collection(self):
        if self._db is None:
            self._db = await MongoDBConnection.get_database()
        return self._db[self.COLLECTION_NAME]

    async def save(self, stats: PlayerStats) -> PlayerStats:
        """Save player stats (upsert by player/season/week)"""
        collection = await self._get_collection()
        await collection.update_one(
            {
                "player_id": stats.player_id,
                "season": stats.season,
                "week": stats.week
            },
            {"$set": stats.model_dump()},
            upsert=True
        )
        logger.debug(f"Saved stats: {stats.player_id} week {stats.week}")
        return stats

    async def save_all(self, stats: List[PlayerStats]) -> List[PlayerStats]:
        """Save multiple player stats (bulk upsert)"""
        if not stats:
            return []

        collection = await self._get_collection()
        operations = [
            UpdateOne(
                {
                    "player_id": s.player_id,
                    "season": s.season,
                    "week": s.week
                },
                {"$set": s.model_dump()},
                upsert=True
            )
            for s in stats
        ]
        result = await collection.bulk_write(operations)
        logger.info(
            f"Bulk saved {len(stats)} stats records: "
            f"{result.upserted_count} inserted, {result.modified_count} updated"
        )
        return stats

    async def find_by_player_and_week(
        self, player_id: str, season: int, week: int
    ) -> Optional[PlayerStats]:
        """Find stats for a specific player and week"""
        collection = await self._get_collection()
        doc = await collection.find_one({
            "player_id": player_id,
            "season": season,
            "week": week
        })
        if doc:
            doc.pop("_id", None)
            return PlayerStats(**doc)
        return None

    async def find_by_week(self, season: int, week: int) -> List[PlayerStats]:
        """Find all stats for a specific week"""
        collection = await self._get_collection()
        cursor = collection.find({"season": season, "week": week})
        stats = []
        async for doc in cursor:
            doc.pop("_id", None)
            stats.append(PlayerStats(**doc))
        return stats
