package com.ffl.playoffs.domain.model;

import java.time.Instant;
import java.time.LocalDateTime;
import java.time.LocalTime;
import java.time.ZoneId;
import java.util.Objects;

/**
 * Value object representing time zone information for scheduling.
 */
public class TimeZoneRegion {

    private final String zoneId;
    private final String displayName;
    private final String abbreviation;
    private final Integer utcOffset;
    private final LocalTime typicalGameTime;

    private TimeZoneRegion(String zoneId, String displayName, String abbreviation,
                           Integer utcOffset, LocalTime typicalGameTime) {
        this.zoneId = zoneId;
        this.displayName = displayName;
        this.abbreviation = abbreviation;
        this.utcOffset = utcOffset;
        this.typicalGameTime = typicalGameTime;
    }

    // Factory methods for NFL time zones

    public static TimeZoneRegion eastern() {
        return new TimeZoneRegion("America/New_York", "Eastern Time", "ET", -5,
                LocalTime.of(13, 0));
    }

    public static TimeZoneRegion central() {
        return new TimeZoneRegion("America/Chicago", "Central Time", "CT", -6,
                LocalTime.of(12, 0));
    }

    public static TimeZoneRegion mountain() {
        return new TimeZoneRegion("America/Denver", "Mountain Time", "MT", -7,
                LocalTime.of(11, 0));
    }

    public static TimeZoneRegion pacific() {
        return new TimeZoneRegion("America/Los_Angeles", "Pacific Time", "PT", -8,
                LocalTime.of(10, 0));
    }

    public static TimeZoneRegion arizona() {
        // Arizona doesn't observe DST
        return new TimeZoneRegion("America/Phoenix", "Mountain Time (no DST)", "MST", -7,
                LocalTime.of(11, 0));
    }

    public static TimeZoneRegion london() {
        return new TimeZoneRegion("Europe/London", "Greenwich Mean Time", "GMT", 0,
                LocalTime.of(14, 30)); // 9:30 AM ET
    }

    public static TimeZoneRegion fromZoneId(String zoneIdStr) {
        return switch (zoneIdStr) {
            case "America/New_York" -> eastern();
            case "America/Chicago" -> central();
            case "America/Denver" -> mountain();
            case "America/Los_Angeles" -> pacific();
            case "America/Phoenix" -> arizona();
            case "Europe/London" -> london();
            default -> new TimeZoneRegion(zoneIdStr, zoneIdStr, zoneIdStr.substring(zoneIdStr.lastIndexOf('/') + 1),
                    0, LocalTime.of(13, 0));
        };
    }

    /**
     * Returns hour difference between this zone and another.
     */
    public int hoursDifference(TimeZoneRegion other) {
        return other.utcOffset - this.utcOffset;
    }

    /**
     * Converts an instant to local date/time in this zone.
     */
    public LocalDateTime toLocal(Instant instant) {
        return LocalDateTime.ofInstant(instant, ZoneId.of(zoneId));
    }

    /**
     * Returns true if this zone is east of the other zone.
     */
    public boolean isEastOf(TimeZoneRegion other) {
        return this.utcOffset > other.utcOffset;
    }

    /**
     * Gets the Java ZoneId for this region.
     */
    public ZoneId getZoneIdObj() {
        return ZoneId.of(zoneId);
    }

    public String getZoneId() {
        return zoneId;
    }

    public String getDisplayName() {
        return displayName;
    }

    public String getAbbreviation() {
        return abbreviation;
    }

    public Integer getUtcOffset() {
        return utcOffset;
    }

    public LocalTime getTypicalGameTime() {
        return typicalGameTime;
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;
        TimeZoneRegion that = (TimeZoneRegion) o;
        return Objects.equals(zoneId, that.zoneId);
    }

    @Override
    public int hashCode() {
        return Objects.hash(zoneId);
    }

    @Override
    public String toString() {
        return displayName + " (" + abbreviation + ")";
    }
}
