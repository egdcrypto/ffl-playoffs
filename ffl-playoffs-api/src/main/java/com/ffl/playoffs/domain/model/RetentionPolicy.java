package com.ffl.playoffs.domain.model;

import java.util.Objects;

/**
 * Value object representing a data retention policy
 * Defines retention and archival periods for observability data
 */
public class RetentionPolicy {
    private final String dataType;
    private final int retentionDays;
    private final int archiveDays;
    private final String archiveStorage;

    public RetentionPolicy(String dataType, int retentionDays, int archiveDays, String archiveStorage) {
        if (dataType == null || dataType.isBlank()) {
            throw new IllegalArgumentException("Data type cannot be null or blank");
        }
        if (retentionDays < 0) {
            throw new IllegalArgumentException("Retention days must be non-negative");
        }
        if (archiveDays < 0) {
            throw new IllegalArgumentException("Archive days must be non-negative");
        }
        this.dataType = dataType;
        this.retentionDays = retentionDays;
        this.archiveDays = archiveDays;
        this.archiveStorage = archiveStorage;
    }

    /**
     * Calculates total data lifetime in days
     * @return total days data is retained including archive
     */
    public int getTotalLifetimeDays() {
        return retentionDays + archiveDays;
    }

    /**
     * Checks if archiving is enabled
     * @return true if archive days is greater than 0
     */
    public boolean isArchivingEnabled() {
        return archiveDays > 0 && archiveStorage != null && !archiveStorage.isBlank();
    }

    public String getDataType() {
        return dataType;
    }

    public int getRetentionDays() {
        return retentionDays;
    }

    public int getArchiveDays() {
        return archiveDays;
    }

    public String getArchiveStorage() {
        return archiveStorage;
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;
        RetentionPolicy that = (RetentionPolicy) o;
        return retentionDays == that.retentionDays &&
               archiveDays == that.archiveDays &&
               Objects.equals(dataType, that.dataType) &&
               Objects.equals(archiveStorage, that.archiveStorage);
    }

    @Override
    public int hashCode() {
        return Objects.hash(dataType, retentionDays, archiveDays, archiveStorage);
    }

    @Override
    public String toString() {
        return dataType + ": retain " + retentionDays + "d, archive " + archiveDays + "d";
    }
}
