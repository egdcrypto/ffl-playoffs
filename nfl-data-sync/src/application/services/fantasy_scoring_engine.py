"""
Fantasy Scoring Engine

Calculates fantasy points from raw player statistics.
Supports multiple scoring formats: Standard, PPR, and Half-PPR.
"""
from decimal import Decimal, ROUND_HALF_UP
from typing import Optional

from src.domain.models import PlayerStats


class FantasyScoringEngine:
    """
    Calculate fantasy points from raw stats.

    Scoring Rules:
    - Passing: 1 pt per 25 yards, 4 pts per TD, -2 pts per INT
    - Rushing: 1 pt per 10 yards, 6 pts per TD
    - Receiving: 1 pt per 10 yards, 6 pts per TD
    - Receptions: 1 pt (PPR), 0.5 pt (Half-PPR), 0 (Standard)
    - 2PT Conversions: 2 pts
    - Fumbles Lost: -2 pts
    - Field Goals: 3-5 pts based on distance
    - Extra Points: 1 pt
    """

    def calculate_standard(self, stats: PlayerStats) -> Decimal:
        """
        Calculate standard fantasy points (no PPR bonus).

        Args:
            stats: Player stats for a game/week

        Returns:
            Fantasy points as Decimal
        """
        points = Decimal("0")

        # Passing
        points += self._divide(stats.passing_yards, 25)  # 1 pt per 25 yards
        points += self._multiply(stats.passing_tds, 4)  # 4 pts per TD
        points -= self._multiply(stats.interceptions, 2)  # -2 pts per INT

        # Rushing
        points += self._divide(stats.rushing_yards, 10)  # 1 pt per 10 yards
        points += self._multiply(stats.rushing_tds, 6)  # 6 pts per TD

        # Receiving (no reception bonus in standard)
        points += self._divide(stats.receiving_yards, 10)  # 1 pt per 10 yards
        points += self._multiply(stats.receiving_tds, 6)  # 6 pts per TD

        # Other
        points += self._multiply(stats.two_point_conversions, 2)  # 2 pts per 2PT
        points -= self._multiply(stats.fumbles_lost, 2)  # -2 pts per fumble

        # Kicking
        points += self._multiply(stats.fg_made_0_19, 3)
        points += self._multiply(stats.fg_made_20_29, 3)
        points += self._multiply(stats.fg_made_30_39, 3)
        points += self._multiply(stats.fg_made_40_49, 4)
        points += self._multiply(stats.fg_made_50_plus, 5)
        points += self._multiply(stats.extra_points_made, 1)

        return self._round(points)

    def calculate_ppr(self, stats: PlayerStats) -> Decimal:
        """
        Calculate PPR (Point Per Reception) fantasy points.

        Args:
            stats: Player stats for a game/week

        Returns:
            Fantasy points as Decimal
        """
        points = self.calculate_standard(stats)
        points += self._multiply(stats.receptions, 1)  # 1 pt per reception
        return self._round(points)

    def calculate_half_ppr(self, stats: PlayerStats) -> Decimal:
        """
        Calculate Half-PPR fantasy points.

        Args:
            stats: Player stats for a game/week

        Returns:
            Fantasy points as Decimal
        """
        points = self.calculate_standard(stats)
        points += Decimal(str(stats.receptions)) * Decimal("0.5")  # 0.5 pts per reception
        return self._round(points)

    def calculate_all_formats(self, stats: PlayerStats) -> dict:
        """
        Calculate fantasy points for all scoring formats.

        Args:
            stats: Player stats for a game/week

        Returns:
            Dictionary with points for each format
        """
        return {
            "standard": self.calculate_standard(stats),
            "ppr": self.calculate_ppr(stats),
            "half_ppr": self.calculate_half_ppr(stats),
        }

    def _divide(self, value: Optional[int], divisor: int) -> Decimal:
        """Divide value by divisor, handling None."""
        if value is None or value == 0:
            return Decimal("0")
        return Decimal(str(value)) / Decimal(str(divisor))

    def _multiply(self, value: Optional[int], multiplier: int) -> Decimal:
        """Multiply value by multiplier, handling None."""
        if value is None or value == 0:
            return Decimal("0")
        return Decimal(str(value * multiplier))

    def _round(self, value: Decimal) -> Decimal:
        """Round to 2 decimal places using half-up rounding."""
        return value.quantize(Decimal("0.01"), rounding=ROUND_HALF_UP)


# Singleton instance
scoring_engine = FantasyScoringEngine()
