"""
Domain Ports (Interfaces) for NFL Data Sync Service

These define the contracts that infrastructure adapters must implement.
Following hexagonal architecture, the domain defines what it needs,
and infrastructure provides the implementation.
"""
from abc import ABC, abstractmethod
from typing import List, Optional

from .models import NFLGame, NFLPlayer, PlayerStats


class NflDataProvider(ABC):
    """
    Port for fetching NFL data from external sources.
    Implementations: NflReadPyAdapter, MockNflDataProvider
    """

    @abstractmethod
    def get_player_stats(self, season: int, week: int) -> List[PlayerStats]:
        """Get player stats for a specific week."""
        pass

    @abstractmethod
    def get_schedule(self, season: int) -> List[NFLGame]:
        """Get season schedule."""
        pass

    @abstractmethod
    def get_rosters(self, season: int) -> List[NFLPlayer]:
        """Get team rosters."""
        pass

    @abstractmethod
    def get_current_week(self) -> int:
        """Get current NFL week."""
        pass

    @abstractmethod
    def get_current_season(self) -> int:
        """Get current NFL season."""
        pass


class NFLPlayerRepository(ABC):
    """
    Port for NFL Player persistence.
    Implementations: MongoNFLPlayerRepository
    """

    @abstractmethod
    async def save(self, player: NFLPlayer) -> NFLPlayer:
        """Save an NFL player."""
        pass

    @abstractmethod
    async def save_all(self, players: List[NFLPlayer]) -> List[NFLPlayer]:
        """Save multiple NFL players."""
        pass

    @abstractmethod
    async def find_by_id(self, player_id: str) -> Optional[NFLPlayer]:
        """Find a player by ID."""
        pass

    @abstractmethod
    async def find_all(self) -> List[NFLPlayer]:
        """Find all players."""
        pass

    @abstractmethod
    async def find_by_team(self, team: str) -> List[NFLPlayer]:
        """Find players by team."""
        pass

    @abstractmethod
    async def count(self) -> int:
        """Count total players."""
        pass


class NFLGameRepository(ABC):
    """
    Port for NFL Game persistence.
    Implementations: MongoNFLGameRepository
    """

    @abstractmethod
    async def save(self, game: NFLGame) -> NFLGame:
        """Save an NFL game."""
        pass

    @abstractmethod
    async def save_all(self, games: List[NFLGame]) -> List[NFLGame]:
        """Save multiple NFL games."""
        pass

    @abstractmethod
    async def find_by_id(self, game_id: str) -> Optional[NFLGame]:
        """Find a game by ID."""
        pass

    @abstractmethod
    async def find_by_week(self, season: int, week: int) -> List[NFLGame]:
        """Find games for a specific week."""
        pass

    @abstractmethod
    async def find_active_games(self) -> List[NFLGame]:
        """Find games currently in progress."""
        pass


class PlayerStatsRepository(ABC):
    """
    Port for Player Stats persistence.
    Implementations: MongoPlayerStatsRepository
    """

    @abstractmethod
    async def save(self, stats: PlayerStats) -> PlayerStats:
        """Save player stats."""
        pass

    @abstractmethod
    async def save_all(self, stats: List[PlayerStats]) -> List[PlayerStats]:
        """Save multiple player stats."""
        pass

    @abstractmethod
    async def find_by_player_and_week(
        self, player_id: str, season: int, week: int
    ) -> Optional[PlayerStats]:
        """Find stats for a specific player and week."""
        pass

    @abstractmethod
    async def find_by_week(self, season: int, week: int) -> List[PlayerStats]:
        """Find all stats for a specific week."""
        pass
