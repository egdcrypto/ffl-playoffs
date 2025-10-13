package com.ffl.playoffs.domain.model;

import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Nested;
import org.junit.jupiter.api.Test;

import static org.assertj.core.api.Assertions.*;

@DisplayName("Position Enum Tests")
class PositionTest {

    @Nested
    @DisplayName("Display Names")
    class DisplayNames {

        @Test
        @DisplayName("QB should have correct display name")
        void qbShouldHaveCorrectDisplayName() {
            assertThat(Position.QB.getDisplayName()).isEqualTo("Quarterback");
        }

        @Test
        @DisplayName("RB should have correct display name")
        void rbShouldHaveCorrectDisplayName() {
            assertThat(Position.RB.getDisplayName()).isEqualTo("Running Back");
        }

        @Test
        @DisplayName("WR should have correct display name")
        void wrShouldHaveCorrectDisplayName() {
            assertThat(Position.WR.getDisplayName()).isEqualTo("Wide Receiver");
        }

        @Test
        @DisplayName("TE should have correct display name")
        void teShouldHaveCorrectDisplayName() {
            assertThat(Position.TE.getDisplayName()).isEqualTo("Tight End");
        }

        @Test
        @DisplayName("K should have correct display name")
        void kShouldHaveCorrectDisplayName() {
            assertThat(Position.K.getDisplayName()).isEqualTo("Kicker");
        }

        @Test
        @DisplayName("DEF should have correct display name")
        void defShouldHaveCorrectDisplayName() {
            assertThat(Position.DEF.getDisplayName()).isEqualTo("Defense/Special Teams");
        }

        @Test
        @DisplayName("FLEX should have correct display name")
        void flexShouldHaveCorrectDisplayName() {
            assertThat(Position.FLEX.getDisplayName()).isEqualTo("Flex (RB/WR/TE)");
        }

        @Test
        @DisplayName("SUPERFLEX should have correct display name")
        void superflexShouldHaveCorrectDisplayName() {
            assertThat(Position.SUPERFLEX.getDisplayName()).isEqualTo("Superflex (QB/RB/WR/TE)");
        }
    }

    @Nested
    @DisplayName("FLEX Eligibility")
    class FlexEligibility {

        @Test
        @DisplayName("RB should be FLEX eligible")
        void rbShouldBeFlexEligible() {
            assertThat(Position.isFlexEligible(Position.RB)).isTrue();
        }

        @Test
        @DisplayName("WR should be FLEX eligible")
        void wrShouldBeFlexEligible() {
            assertThat(Position.isFlexEligible(Position.WR)).isTrue();
        }

        @Test
        @DisplayName("TE should be FLEX eligible")
        void teShouldBeFlexEligible() {
            assertThat(Position.isFlexEligible(Position.TE)).isTrue();
        }

        @Test
        @DisplayName("QB should not be FLEX eligible")
        void qbShouldNotBeFlexEligible() {
            assertThat(Position.isFlexEligible(Position.QB)).isFalse();
        }

        @Test
        @DisplayName("K should not be FLEX eligible")
        void kShouldNotBeFlexEligible() {
            assertThat(Position.isFlexEligible(Position.K)).isFalse();
        }

        @Test
        @DisplayName("DEF should not be FLEX eligible")
        void defShouldNotBeFlexEligible() {
            assertThat(Position.isFlexEligible(Position.DEF)).isFalse();
        }
    }

    @Nested
    @DisplayName("SUPERFLEX Eligibility")
    class SuperflexEligibility {

        @Test
        @DisplayName("QB should be SUPERFLEX eligible")
        void qbShouldBeSuperflexEligible() {
            assertThat(Position.isSuperflexEligible(Position.QB)).isTrue();
        }

        @Test
        @DisplayName("RB should be SUPERFLEX eligible")
        void rbShouldBeSuperflexEligible() {
            assertThat(Position.isSuperflexEligible(Position.RB)).isTrue();
        }

        @Test
        @DisplayName("WR should be SUPERFLEX eligible")
        void wrShouldBeSuperflexEligible() {
            assertThat(Position.isSuperflexEligible(Position.WR)).isTrue();
        }

        @Test
        @DisplayName("TE should be SUPERFLEX eligible")
        void teShouldBeSuperflexEligible() {
            assertThat(Position.isSuperflexEligible(Position.TE)).isTrue();
        }

        @Test
        @DisplayName("K should not be SUPERFLEX eligible")
        void kShouldNotBeSuperflexEligible() {
            assertThat(Position.isSuperflexEligible(Position.K)).isFalse();
        }

        @Test
        @DisplayName("DEF should not be SUPERFLEX eligible")
        void defShouldNotBeSuperflexEligible() {
            assertThat(Position.isSuperflexEligible(Position.DEF)).isFalse();
        }
    }

    @Nested
    @DisplayName("Slot Filling")
    class SlotFilling {

        @Test
        @DisplayName("QB can fill QB slot")
        void qbCanFillQBSlot() {
            assertThat(Position.canFillSlot(Position.QB, Position.QB)).isTrue();
        }

        @Test
        @DisplayName("RB can fill RB slot")
        void rbCanFillRBSlot() {
            assertThat(Position.canFillSlot(Position.RB, Position.RB)).isTrue();
        }

        @Test
        @DisplayName("RB can fill FLEX slot")
        void rbCanFillFlexSlot() {
            assertThat(Position.canFillSlot(Position.RB, Position.FLEX)).isTrue();
        }

        @Test
        @DisplayName("WR can fill FLEX slot")
        void wrCanFillFlexSlot() {
            assertThat(Position.canFillSlot(Position.WR, Position.FLEX)).isTrue();
        }

        @Test
        @DisplayName("TE can fill FLEX slot")
        void teCanFillFlexSlot() {
            assertThat(Position.canFillSlot(Position.TE, Position.FLEX)).isTrue();
        }

        @Test
        @DisplayName("QB cannot fill FLEX slot")
        void qbCannotFillFlexSlot() {
            assertThat(Position.canFillSlot(Position.QB, Position.FLEX)).isFalse();
        }

        @Test
        @DisplayName("QB can fill SUPERFLEX slot")
        void qbCanFillSuperflexSlot() {
            assertThat(Position.canFillSlot(Position.QB, Position.SUPERFLEX)).isTrue();
        }

        @Test
        @DisplayName("RB can fill SUPERFLEX slot")
        void rbCanFillSuperflexSlot() {
            assertThat(Position.canFillSlot(Position.RB, Position.SUPERFLEX)).isTrue();
        }

        @Test
        @DisplayName("WR can fill SUPERFLEX slot")
        void wrCanFillSuperflexSlot() {
            assertThat(Position.canFillSlot(Position.WR, Position.SUPERFLEX)).isTrue();
        }

        @Test
        @DisplayName("TE can fill SUPERFLEX slot")
        void teCanFillSuperflexSlot() {
            assertThat(Position.canFillSlot(Position.TE, Position.SUPERFLEX)).isTrue();
        }

        @Test
        @DisplayName("K cannot fill SUPERFLEX slot")
        void kCannotFillSuperflexSlot() {
            assertThat(Position.canFillSlot(Position.K, Position.SUPERFLEX)).isFalse();
        }

        @Test
        @DisplayName("DEF cannot fill SUPERFLEX slot")
        void defCannotFillSuperflexSlot() {
            assertThat(Position.canFillSlot(Position.DEF, Position.SUPERFLEX)).isFalse();
        }

        @Test
        @DisplayName("RB cannot fill WR slot")
        void rbCannotFillWRSlot() {
            assertThat(Position.canFillSlot(Position.RB, Position.WR)).isFalse();
        }

        @Test
        @DisplayName("QB cannot fill K slot")
        void qbCannotFillKSlot() {
            assertThat(Position.canFillSlot(Position.QB, Position.K)).isFalse();
        }
    }
}
