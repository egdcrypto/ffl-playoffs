package com.ffl.playoffs.domain.model;

import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;

import java.math.BigDecimal;

import static org.assertj.core.api.Assertions.*;

@DisplayName("Price Value Object Tests")
class PriceTest {

    @Test
    @DisplayName("should create price with USD")
    void shouldCreatePriceWithUsd() {
        Price price = Price.usd(29.99);
        assertThat(price.getAmount()).isEqualByComparingTo(BigDecimal.valueOf(29.99));
        assertThat(price.getCurrency()).isEqualTo("USD");
    }

    @Test
    @DisplayName("should create free price")
    void shouldCreateFreePrice() {
        Price price = Price.free();
        assertThat(price.isFree()).isTrue();
    }

    @Test
    @DisplayName("should add two prices")
    void shouldAddTwoPrices() {
        Price result = Price.usd(10.00).add(Price.usd(5.50));
        assertThat(result.getAmount()).isEqualByComparingTo(BigDecimal.valueOf(15.50));
    }

    @Test
    @DisplayName("should apply discount")
    void shouldApplyDiscount() {
        Price discounted = Price.usd(100.00).applyDiscount(20);
        assertThat(discounted.getAmount()).isEqualByComparingTo(BigDecimal.valueOf(80.00));
    }
}
