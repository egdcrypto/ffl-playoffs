package com.ffl.playoffs.domain.model;

import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Nested;
import org.junit.jupiter.api.Test;

import java.math.BigDecimal;

import static org.assertj.core.api.Assertions.*;

@DisplayName("Price Value Object Tests")
class PriceTest {

    @Nested
    @DisplayName("Construction")
    class Construction {

        @Test
        @DisplayName("should create price with BigDecimal and currency")
        void shouldCreatePriceWithBigDecimalAndCurrency() {
            // When
            Price price = new Price(BigDecimal.valueOf(9.99), "USD");

            // Then
            assertThat(price.getAmount()).isEqualByComparingTo(BigDecimal.valueOf(9.99));
            assertThat(price.getCurrency()).isEqualTo("USD");
        }

        @Test
        @DisplayName("should create price with double and currency")
        void shouldCreatePriceWithDoubleAndCurrency() {
            // When
            Price price = new Price(19.99, "USD");

            // Then
            assertThat(price.getAmount()).isEqualByComparingTo(BigDecimal.valueOf(19.99));
            assertThat(price.getCurrency()).isEqualTo("USD");
        }

        @Test
        @DisplayName("should normalize currency to uppercase")
        void shouldNormalizeCurrencyToUppercase() {
            // When
            Price price = new Price(10.00, "usd");

            // Then
            assertThat(price.getCurrency()).isEqualTo("USD");
        }

        @Test
        @DisplayName("should round amount to 2 decimal places")
        void shouldRoundAmountTo2DecimalPlaces() {
            // When
            Price price = new Price(BigDecimal.valueOf(9.999), "USD");

            // Then
            assertThat(price.getAmount()).isEqualByComparingTo(BigDecimal.valueOf(10.00));
        }

        @Test
        @DisplayName("should throw exception for negative amount")
        void shouldThrowExceptionForNegativeAmount() {
            assertThatThrownBy(() -> new Price(BigDecimal.valueOf(-1.00), "USD"))
                .isInstanceOf(IllegalArgumentException.class)
                .hasMessageContaining("non-negative");
        }

        @Test
        @DisplayName("should throw exception for null amount")
        void shouldThrowExceptionForNullAmount() {
            assertThatThrownBy(() -> new Price((BigDecimal) null, "USD"))
                .isInstanceOf(IllegalArgumentException.class);
        }

        @Test
        @DisplayName("should throw exception for null currency")
        void shouldThrowExceptionForNullCurrency() {
            assertThatThrownBy(() -> new Price(BigDecimal.TEN, null))
                .isInstanceOf(IllegalArgumentException.class)
                .hasMessageContaining("Currency is required");
        }

        @Test
        @DisplayName("should throw exception for blank currency")
        void shouldThrowExceptionForBlankCurrency() {
            assertThatThrownBy(() -> new Price(BigDecimal.TEN, "  "))
                .isInstanceOf(IllegalArgumentException.class)
                .hasMessageContaining("Currency is required");
        }
    }

    @Nested
    @DisplayName("Factory Methods")
    class FactoryMethods {

        @Test
        @DisplayName("should create USD price")
        void shouldCreateUsdPrice() {
            // When
            Price price = Price.usd(29.99);

            // Then
            assertThat(price.getAmount()).isEqualByComparingTo(BigDecimal.valueOf(29.99));
            assertThat(price.getCurrency()).isEqualTo("USD");
        }

        @Test
        @DisplayName("should create free price")
        void shouldCreateFreePrice() {
            // When
            Price price = Price.free();

            // Then
            assertThat(price.getAmount()).isEqualByComparingTo(BigDecimal.ZERO);
            assertThat(price.getCurrency()).isEqualTo("USD");
            assertThat(price.isFree()).isTrue();
        }
    }

    @Nested
    @DisplayName("isFree")
    class IsFree {

        @Test
        @DisplayName("should return true for zero amount")
        void shouldReturnTrueForZeroAmount() {
            Price price = new Price(BigDecimal.ZERO, "USD");
            assertThat(price.isFree()).isTrue();
        }

        @Test
        @DisplayName("should return false for non-zero amount")
        void shouldReturnFalseForNonZeroAmount() {
            Price price = new Price(0.01, "USD");
            assertThat(price.isFree()).isFalse();
        }
    }

    @Nested
    @DisplayName("Arithmetic Operations")
    class ArithmeticOperations {

        @Test
        @DisplayName("should add two prices")
        void shouldAddTwoPrices() {
            Price price1 = Price.usd(10.00);
            Price price2 = Price.usd(5.50);

            Price result = price1.add(price2);

            assertThat(result.getAmount()).isEqualByComparingTo(BigDecimal.valueOf(15.50));
        }

        @Test
        @DisplayName("should subtract price")
        void shouldSubtractPrice() {
            Price price1 = Price.usd(10.00);
            Price price2 = Price.usd(3.50);

            Price result = price1.subtract(price2);

            assertThat(result.getAmount()).isEqualByComparingTo(BigDecimal.valueOf(6.50));
        }

        @Test
        @DisplayName("should throw exception when subtracting results in negative")
        void shouldThrowExceptionWhenSubtractingResultsInNegative() {
            Price price1 = Price.usd(5.00);
            Price price2 = Price.usd(10.00);

            assertThatThrownBy(() -> price1.subtract(price2))
                .isInstanceOf(IllegalArgumentException.class)
                .hasMessageContaining("cannot be negative");
        }

        @Test
        @DisplayName("should throw exception when operating on different currencies")
        void shouldThrowExceptionWhenOperatingOnDifferentCurrencies() {
            Price usd = new Price(10.00, "USD");
            Price eur = new Price(10.00, "EUR");

            assertThatThrownBy(() -> usd.add(eur))
                .isInstanceOf(IllegalArgumentException.class)
                .hasMessageContaining("different currencies");
        }
    }

    @Nested
    @DisplayName("Discount")
    class Discount {

        @Test
        @DisplayName("should apply percentage discount")
        void shouldApplyPercentageDiscount() {
            Price price = Price.usd(100.00);

            Price discounted = price.applyDiscount(20);

            assertThat(discounted.getAmount()).isEqualByComparingTo(BigDecimal.valueOf(80.00));
        }

        @Test
        @DisplayName("should apply 100% discount resulting in zero")
        void shouldApply100PercentDiscount() {
            Price price = Price.usd(50.00);

            Price discounted = price.applyDiscount(100);

            assertThat(discounted.getAmount()).isEqualByComparingTo(BigDecimal.ZERO);
        }

        @Test
        @DisplayName("should apply 0% discount resulting in same price")
        void shouldApply0PercentDiscount() {
            Price price = Price.usd(50.00);

            Price discounted = price.applyDiscount(0);

            assertThat(discounted.getAmount()).isEqualByComparingTo(BigDecimal.valueOf(50.00));
        }

        @Test
        @DisplayName("should throw exception for negative discount")
        void shouldThrowExceptionForNegativeDiscount() {
            Price price = Price.usd(100.00);

            assertThatThrownBy(() -> price.applyDiscount(-10))
                .isInstanceOf(IllegalArgumentException.class)
                .hasMessageContaining("between 0 and 100");
        }

        @Test
        @DisplayName("should throw exception for discount over 100")
        void shouldThrowExceptionForDiscountOver100() {
            Price price = Price.usd(100.00);

            assertThatThrownBy(() -> price.applyDiscount(101))
                .isInstanceOf(IllegalArgumentException.class)
                .hasMessageContaining("between 0 and 100");
        }
    }

    @Nested
    @DisplayName("Equality")
    class Equality {

        @Test
        @DisplayName("should be equal when amount and currency match")
        void shouldBeEqualWhenAmountAndCurrencyMatch() {
            Price price1 = Price.usd(10.00);
            Price price2 = Price.usd(10.00);

            assertThat(price1).isEqualTo(price2);
            assertThat(price1.hashCode()).isEqualTo(price2.hashCode());
        }

        @Test
        @DisplayName("should not be equal when amounts differ")
        void shouldNotBeEqualWhenAmountsDiffer() {
            Price price1 = Price.usd(10.00);
            Price price2 = Price.usd(20.00);

            assertThat(price1).isNotEqualTo(price2);
        }

        @Test
        @DisplayName("should not be equal when currencies differ")
        void shouldNotBeEqualWhenCurrenciesDiffer() {
            Price usd = new Price(10.00, "USD");
            Price eur = new Price(10.00, "EUR");

            assertThat(usd).isNotEqualTo(eur);
        }
    }

    @Nested
    @DisplayName("toString")
    class ToString {

        @Test
        @DisplayName("should format price correctly")
        void shouldFormatPriceCorrectly() {
            Price price = Price.usd(29.99);

            assertThat(price.toString()).isEqualTo("USD 29.99");
        }
    }
}
