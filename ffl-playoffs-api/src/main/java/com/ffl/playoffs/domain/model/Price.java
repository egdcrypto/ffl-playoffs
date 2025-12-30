package com.ffl.playoffs.domain.model;

import java.math.BigDecimal;
import java.math.RoundingMode;
import java.util.Objects;

/**
 * Value object representing a price with currency.
 * Immutable and provides price calculations.
 */
public class Price {

    private final BigDecimal amount;
    private final String currency;

    public Price(BigDecimal amount, String currency) {
        if (amount == null || amount.compareTo(BigDecimal.ZERO) < 0) {
            throw new IllegalArgumentException("Amount must be non-negative");
        }
        if (currency == null || currency.isBlank()) {
            throw new IllegalArgumentException("Currency is required");
        }
        this.amount = amount.setScale(2, RoundingMode.HALF_UP);
        this.currency = currency.toUpperCase();
    }

    public Price(double amount, String currency) {
        this(BigDecimal.valueOf(amount), currency);
    }

    public BigDecimal getAmount() {
        return amount;
    }

    public String getCurrency() {
        return currency;
    }

    /**
     * Create a price in USD
     */
    public static Price usd(double amount) {
        return new Price(amount, "USD");
    }

    /**
     * Create a free/zero price
     */
    public static Price free() {
        return new Price(BigDecimal.ZERO, "USD");
    }

    /**
     * Check if this price is free (zero)
     */
    public boolean isFree() {
        return amount.compareTo(BigDecimal.ZERO) == 0;
    }

    /**
     * Add two prices together
     */
    public Price add(Price other) {
        validateSameCurrency(other);
        return new Price(this.amount.add(other.amount), this.currency);
    }

    /**
     * Subtract price from this price
     */
    public Price subtract(Price other) {
        validateSameCurrency(other);
        BigDecimal result = this.amount.subtract(other.amount);
        if (result.compareTo(BigDecimal.ZERO) < 0) {
            throw new IllegalArgumentException("Result cannot be negative");
        }
        return new Price(result, this.currency);
    }

    /**
     * Apply a discount percentage
     */
    public Price applyDiscount(int discountPercent) {
        if (discountPercent < 0 || discountPercent > 100) {
            throw new IllegalArgumentException("Discount must be between 0 and 100");
        }
        BigDecimal multiplier = BigDecimal.ONE.subtract(
                BigDecimal.valueOf(discountPercent).divide(BigDecimal.valueOf(100))
        );
        return new Price(this.amount.multiply(multiplier), this.currency);
    }

    private void validateSameCurrency(Price other) {
        if (!this.currency.equals(other.currency)) {
            throw new IllegalArgumentException("Cannot operate on different currencies");
        }
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;
        Price price = (Price) o;
        return amount.compareTo(price.amount) == 0 && currency.equals(price.currency);
    }

    @Override
    public int hashCode() {
        return Objects.hash(amount, currency);
    }

    @Override
    public String toString() {
        return currency + " " + amount.toPlainString();
    }
}
