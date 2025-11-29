"""
NFL Data Py Adapter

Implements the NflDataProvider port using nfl_data_py library.
This adapter fetches data from the nflverse ecosystem (FREE).

nfl_data_py provides access to:
- Player stats
- Game schedules
- Rosters
- Play-by-play data
"""
import logging
from datetime import datetime
from typing import List, Optional

import nfl_data_py as nfl

from src.domain.models import GameStatus, NFLGame, NFLPlayer, PlayerStats
from src.domain.ports import NflDataProvider

logger = logging.getLogger(__name__)


class NflDataPyAdapter(NflDataProvider):
    """
    Adapter for nfl_data_py - FREE NFL data from nflverse.

    Data updates:
    - Schedules: Every 5 minutes
    - Player stats: Nightly (3-5 AM ET)
    - Rosters: Daily (7 AM UTC)
    """

    def __init__(self):
        """Initialize the adapter."""
        self._cache = {}

    def get_player_stats(self, season: int, week: int) -> List[PlayerStats]:
        """
        Get player stats for a specific week.

        Args:
            season: NFL season year
            week: Week number (1-18 regular season, 19+ playoffs)

        Returns:
            List of PlayerStats for all players in that week
        """
        try:
            logger.info(f"Fetching player stats for season={season}, week={week}")

            # Load weekly player stats
            stats_df = nfl.import_weekly_data([season])

            if stats_df is None or stats_df.empty:
                logger.warning(f"No stats data found for season {season}")
                return []

            # Filter by week
            week_stats = stats_df[stats_df["week"] == week]

            stats_list = []
            for _, row in week_stats.iterrows():
                try:
                    stats = PlayerStats(
                        player_id=str(row.get("player_id", "")),
                        player_name=row.get("player_display_name", row.get("player_name", "")),
                        week=int(row.get("week", week)),
                        season=int(row.get("season", season)),
                        team=row.get("recent_team", None),
                        position=row.get("position", None),
                        # Passing
                        passing_yards=int(row.get("passing_yards", 0) or 0),
                        passing_tds=int(row.get("passing_tds", 0) or 0),
                        interceptions=int(row.get("interceptions", 0) or 0),
                        passing_attempts=int(row.get("attempts", 0) or 0),
                        passing_completions=int(row.get("completions", 0) or 0),
                        # Rushing
                        rushing_yards=int(row.get("rushing_yards", 0) or 0),
                        rushing_tds=int(row.get("rushing_tds", 0) or 0),
                        rushing_attempts=int(row.get("carries", 0) or 0),
                        # Receiving
                        receptions=int(row.get("receptions", 0) or 0),
                        receiving_yards=int(row.get("receiving_yards", 0) or 0),
                        receiving_tds=int(row.get("receiving_tds", 0) or 0),
                        targets=int(row.get("targets", 0) or 0),
                        # Other
                        two_point_conversions=int(
                            (row.get("passing_2pt_conversions", 0) or 0)
                            + (row.get("rushing_2pt_conversions", 0) or 0)
                            + (row.get("receiving_2pt_conversions", 0) or 0)
                        ),
                        fumbles_lost=int(row.get("sack_fumbles_lost", 0) or 0),
                    )
                    stats_list.append(stats)
                except Exception as e:
                    logger.warning(f"Error parsing player stats row: {e}")
                    continue

            logger.info(f"Loaded {len(stats_list)} player stats for week {week}")
            return stats_list

        except Exception as e:
            logger.error(f"Error fetching player stats: {e}", exc_info=True)
            return []

    def get_schedule(self, season: int) -> List[NFLGame]:
        """
        Get season schedule.

        Args:
            season: NFL season year

        Returns:
            List of NFLGame for the entire season
        """
        try:
            logger.info(f"Fetching schedule for season={season}")

            schedules_df = nfl.import_schedules([season])

            if schedules_df is None or schedules_df.empty:
                logger.warning(f"No schedule data found for season {season}")
                return []

            games = []
            for _, row in schedules_df.iterrows():
                try:
                    # Parse game time and game date
                    game_time = None
                    game_date = None
                    gameday = row.get("gameday")
                    gametime = row.get("gametime")
                    if gameday:
                        try:
                            # Parse game_date (just the date without time)
                            game_date = datetime.strptime(gameday, "%Y-%m-%d")

                            # Parse game_time (date + time if available)
                            if gametime:
                                game_time = datetime.strptime(
                                    f"{gameday} {gametime}", "%Y-%m-%d %H:%M"
                                )
                            else:
                                game_time = game_date
                        except ValueError:
                            pass

                    # Determine game status
                    game_type = row.get("game_type", "REG")
                    home_score = row.get("home_score")
                    away_score = row.get("away_score")

                    if home_score is not None and away_score is not None:
                        status = GameStatus.FINAL
                    elif game_time and game_time < datetime.now():
                        status = GameStatus.IN_PROGRESS
                    else:
                        status = GameStatus.SCHEDULED

                    game = NFLGame(
                        game_id=str(row.get("game_id", "")),
                        season=int(row.get("season", season)),
                        week=int(row.get("week", 0)),
                        home_team=row.get("home_team", ""),
                        away_team=row.get("away_team", ""),
                        home_score=int(home_score) if home_score is not None else None,
                        away_score=int(away_score) if away_score is not None else None,
                        game_time=game_time,
                        game_date=game_date,  # FFL-36: Add game_date field
                        status=status,
                        venue=row.get("stadium", None),
                    )
                    games.append(game)
                except Exception as e:
                    logger.warning(f"Error parsing schedule row: {e}")
                    continue

            logger.info(f"Loaded {len(games)} games for season {season}")
            return games

        except Exception as e:
            logger.error(f"Error fetching schedule: {e}", exc_info=True)
            return []

    def get_rosters(self, season: int) -> List[NFLPlayer]:
        """
        Get team rosters.

        Args:
            season: NFL season year

        Returns:
            List of NFLPlayer for all teams
        """
        try:
            logger.info(f"Fetching rosters for season={season}")

            rosters_df = nfl.import_rosters([season])

            if rosters_df is None or rosters_df.empty:
                logger.warning(f"No roster data found for season {season}")
                return []

            players = []
            for _, row in rosters_df.iterrows():
                try:
                    player = NFLPlayer(
                        player_id=str(row.get("player_id", row.get("gsis_id", ""))),
                        name=row.get("player_name", ""),
                        first_name=row.get("first_name", None),
                        last_name=row.get("last_name", None),
                        position=row.get("position", None),
                        team=row.get("team", None),
                        jersey_number=(
                            int(row.get("jersey_number"))
                            if row.get("jersey_number") is not None
                            else None
                        ),
                        status=row.get("status", "ACTIVE"),
                    )
                    players.append(player)
                except Exception as e:
                    logger.warning(f"Error parsing roster row: {e}")
                    continue

            logger.info(f"Loaded {len(players)} players for season {season}")
            return players

        except Exception as e:
            logger.error(f"Error fetching rosters: {e}", exc_info=True)
            return []

    def get_current_week(self) -> int:
        """
        Get current NFL week.

        Returns:
            Current week number (1-18 regular season, 19+ playoffs)
        """
        try:
            # nfl_data_py doesn't have a direct current week function
            # We calculate based on schedule
            now = datetime.now()
            current_season = self.get_current_season()
            schedule = self.get_schedule(current_season)

            if not schedule:
                return 1

            # Find the current week based on game times
            current_week = 1
            for game in sorted(schedule, key=lambda g: g.game_time or datetime.max):
                if game.game_time and game.game_time > now:
                    return max(1, game.week)
                current_week = game.week

            return current_week

        except Exception as e:
            logger.error(f"Error getting current week: {e}")
            return 1

    def get_current_season(self) -> int:
        """
        Get current NFL season.

        Returns:
            Current season year
        """
        now = datetime.now()
        # NFL season spans calendar years
        # Season starts in September, so if before September, use previous year
        if now.month < 3:  # Jan-Feb are still previous season
            return now.year - 1
        return now.year
