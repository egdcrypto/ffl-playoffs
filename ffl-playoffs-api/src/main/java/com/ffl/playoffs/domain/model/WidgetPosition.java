package com.ffl.playoffs.domain.model;

import java.util.Objects;

/**
 * Value object representing a widget's position on the dashboard grid
 * Immutable position with row and column coordinates
 */
public class WidgetPosition {
    private final int row;
    private final int col;

    public WidgetPosition(int row, int col) {
        if (row < 0) {
            throw new IllegalArgumentException("Row must be non-negative");
        }
        if (col < 0) {
            throw new IllegalArgumentException("Column must be non-negative");
        }
        this.row = row;
        this.col = col;
    }

    public int getRow() {
        return row;
    }

    public int getCol() {
        return col;
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;
        WidgetPosition that = (WidgetPosition) o;
        return row == that.row && col == that.col;
    }

    @Override
    public int hashCode() {
        return Objects.hash(row, col);
    }

    @Override
    public String toString() {
        return "WidgetPosition{row=" + row + ", col=" + col + "}";
    }
}
