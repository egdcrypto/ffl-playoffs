package com.ffl.playoffs.domain.model;

import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Nested;
import org.junit.jupiter.api.Test;

import static org.assertj.core.api.Assertions.*;

@DisplayName("BillingCycle Enum Tests")
class BillingCycleTest {

    @Nested
    @DisplayName("Display Name")
    class DisplayNameTests {

        @Test
        @DisplayName("ONE_TIME should have correct display name")
        void oneTimeShouldHaveCorrectDisplayName() {
            assertThat(BillingCycle.ONE_TIME.getDisplayName()).isEqualTo("One-Time");
        }

        @Test
        @DisplayName("MONTHLY should have correct display name")
        void monthlyShouldHaveCorrectDisplayName() {
            assertThat(BillingCycle.MONTHLY.getDisplayName()).isEqualTo("Monthly");
        }

        @Test
        @DisplayName("QUARTERLY should have correct display name")
        void quarterlyShouldHaveCorrectDisplayName() {
            assertThat(BillingCycle.QUARTERLY.getDisplayName()).isEqualTo("Quarterly");
        }

        @Test
        @DisplayName("ANNUAL should have correct display name")
        void annualShouldHaveCorrectDisplayName() {
            assertThat(BillingCycle.ANNUAL.getDisplayName()).isEqualTo("Annual");
        }
    }

    @Nested
    @DisplayName("Months Per Cycle")
    class MonthsPerCycle {

        @Test
        @DisplayName("ONE_TIME should have 0 months")
        void oneTimeShouldHave0Months() {
            assertThat(BillingCycle.ONE_TIME.getMonthsPerCycle()).isEqualTo(0);
        }

        @Test
        @DisplayName("MONTHLY should have 1 month")
        void monthlyShouldHave1Month() {
            assertThat(BillingCycle.MONTHLY.getMonthsPerCycle()).isEqualTo(1);
        }

        @Test
        @DisplayName("QUARTERLY should have 3 months")
        void quarterlyShouldHave3Months() {
            assertThat(BillingCycle.QUARTERLY.getMonthsPerCycle()).isEqualTo(3);
        }

        @Test
        @DisplayName("ANNUAL should have 12 months")
        void annualShouldHave12Months() {
            assertThat(BillingCycle.ANNUAL.getMonthsPerCycle()).isEqualTo(12);
        }
    }

    @Nested
    @DisplayName("isRecurring")
    class IsRecurring {

        @Test
        @DisplayName("ONE_TIME should not be recurring")
        void oneTimeShouldNotBeRecurring() {
            assertThat(BillingCycle.ONE_TIME.isRecurring()).isFalse();
        }

        @Test
        @DisplayName("MONTHLY should be recurring")
        void monthlyShouldBeRecurring() {
            assertThat(BillingCycle.MONTHLY.isRecurring()).isTrue();
        }

        @Test
        @DisplayName("QUARTERLY should be recurring")
        void quarterlyShouldBeRecurring() {
            assertThat(BillingCycle.QUARTERLY.isRecurring()).isTrue();
        }

        @Test
        @DisplayName("ANNUAL should be recurring")
        void annualShouldBeRecurring() {
            assertThat(BillingCycle.ANNUAL.isRecurring()).isTrue();
        }
    }
}
