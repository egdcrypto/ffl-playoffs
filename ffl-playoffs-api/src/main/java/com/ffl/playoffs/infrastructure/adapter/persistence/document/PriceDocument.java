package com.ffl.playoffs.infrastructure.adapter.persistence.document;

import java.math.BigDecimal;

/**
 * Embedded MongoDB document for Price value object
 * Infrastructure layer persistence model
 */
public class PriceDocument {

    private BigDecimal amount;
    private String currency;

    public PriceDocument() {
    }

    public PriceDocument(BigDecimal amount, String currency) {
        this.amount = amount;
        this.currency = currency;
    }

    public BigDecimal getAmount() {
        return amount;
    }

    public void setAmount(BigDecimal amount) {
        this.amount = amount;
    }

    public String getCurrency() {
        return currency;
    }

    public void setCurrency(String currency) {
        this.currency = currency;
    }
}
