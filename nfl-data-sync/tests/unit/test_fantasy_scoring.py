"""
Fantasy Scoring Engine Unit Tests

Tests for fantasy point calculations across different scoring formats.
"""
from decimal import Decimal

import pytest

from src.application.services.fantasy_scoring_engine import FantasyScoringEngine
from src.domain.models import PlayerStats


class TestFantasyScoringEngine:
    """Test suite for FantasyScoringEngine."""

    @pytest.fixture
    def scoring_engine(self):
        """Create scoring engine instance."""
        return FantasyScoringEngine()

    def test_calculate_qb_standard_points(self, scoring_engine, sample_player_stats):
        """Test QB standard scoring calculation."""
        # Patrick Mahomes: 325 passing yards, 3 TDs, 1 INT, 28 rushing yards
        # Expected: (325/25) + (3*4) + (-1*2) + (28/10) = 13 + 12 - 2 + 2.8 = 23.8
        points = scoring_engine.calculate_standard(sample_player_stats)
        assert points == Decimal("23.80")

    def test_calculate_rb_standard_points(self, scoring_engine, sample_rb_stats):
        """Test RB standard scoring calculation."""
        # Travis Etienne: 112 rushing yards, 2 TDs, 45 receiving yards
        # Expected: (112/10) + (2*6) + (45/10) = 11.2 + 12 + 4.5 = 27.7
        points = scoring_engine.calculate_standard(sample_rb_stats)
        assert points == Decimal("27.70")

    def test_calculate_rb_ppr_points(self, scoring_engine, sample_rb_stats):
        """Test RB PPR scoring (with reception bonus)."""
        # Standard: 27.7 + 5 receptions = 32.7
        points = scoring_engine.calculate_ppr(sample_rb_stats)
        assert points == Decimal("32.70")

    def test_calculate_rb_half_ppr_points(self, scoring_engine, sample_rb_stats):
        """Test RB Half-PPR scoring."""
        # Standard: 27.7 + (5 * 0.5) = 30.2
        points = scoring_engine.calculate_half_ppr(sample_rb_stats)
        assert points == Decimal("30.20")

    def test_calculate_wr_standard_points(self, scoring_engine, sample_wr_stats):
        """Test WR standard scoring calculation."""
        # Ja'Marr Chase: 132 receiving yards, 2 TDs, 5 rushing yards
        # Expected: (132/10) + (2*6) + (5/10) = 13.2 + 12 + 0.5 = 25.7
        points = scoring_engine.calculate_standard(sample_wr_stats)
        assert points == Decimal("25.70")

    def test_calculate_wr_ppr_points(self, scoring_engine, sample_wr_stats):
        """Test WR PPR scoring."""
        # Standard: 25.7 + 8 receptions = 33.7
        points = scoring_engine.calculate_ppr(sample_wr_stats)
        assert points == Decimal("33.70")

    def test_calculate_kicker_points(self, scoring_engine, sample_kicker_stats):
        """Test kicker scoring calculation."""
        # Justin Tucker: 1x20-29 (3), 2x30-39 (6), 1x40-49 (4), 1x50+ (5), 3 XP (3)
        # Expected: 3 + 6 + 4 + 5 + 3 = 21
        points = scoring_engine.calculate_standard(sample_kicker_stats)
        assert points == Decimal("21.00")

    def test_calculate_all_formats(self, scoring_engine, sample_rb_stats):
        """Test all scoring formats calculation."""
        result = scoring_engine.calculate_all_formats(sample_rb_stats)

        assert "standard" in result
        assert "ppr" in result
        assert "half_ppr" in result

        assert result["standard"] == Decimal("27.70")
        assert result["ppr"] == Decimal("32.70")
        assert result["half_ppr"] == Decimal("30.20")

    def test_interception_penalty(self, scoring_engine):
        """Test interception penalty is applied."""
        stats = PlayerStats(
            player_id="test",
            player_name="Test QB",
            week=1,
            season=2024,
            interceptions=3,
        )
        points = scoring_engine.calculate_standard(stats)
        assert points == Decimal("-6.00")  # 3 * -2 = -6

    def test_fumbles_lost_penalty(self, scoring_engine):
        """Test fumbles lost penalty is applied."""
        stats = PlayerStats(
            player_id="test",
            player_name="Test Player",
            week=1,
            season=2024,
            fumbles_lost=2,
        )
        points = scoring_engine.calculate_standard(stats)
        assert points == Decimal("-4.00")  # 2 * -2 = -4

    def test_two_point_conversions(self, scoring_engine):
        """Test 2-point conversion bonus."""
        stats = PlayerStats(
            player_id="test",
            player_name="Test Player",
            week=1,
            season=2024,
            two_point_conversions=2,
        )
        points = scoring_engine.calculate_standard(stats)
        assert points == Decimal("4.00")  # 2 * 2 = 4

    def test_zero_stats(self, scoring_engine):
        """Test zero stats returns zero points."""
        stats = PlayerStats(
            player_id="test",
            player_name="Test Player",
            week=1,
            season=2024,
        )
        points = scoring_engine.calculate_standard(stats)
        assert points == Decimal("0.00")

    def test_ppr_bonus_only_for_receptions(self, scoring_engine):
        """Test PPR only adds bonus for receptions, not targets."""
        stats = PlayerStats(
            player_id="test",
            player_name="Test Player",
            week=1,
            season=2024,
            targets=10,
            receptions=0,
        )
        standard_points = scoring_engine.calculate_standard(stats)
        ppr_points = scoring_engine.calculate_ppr(stats)

        # No receptions means no PPR bonus
        assert standard_points == ppr_points
