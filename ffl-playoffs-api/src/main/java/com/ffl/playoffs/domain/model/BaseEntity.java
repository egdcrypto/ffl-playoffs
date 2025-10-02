package com.ffl.playoffs.domain.model;

import java.time.Instant;
import java.util.UUID;

/**
 * Base entity class for domain models.
 * Note: This class should NOT have JPA annotations to maintain domain purity.
 * Persistence concerns should be handled in the infrastructure layer.
 */
public abstract class BaseEntity {
    
    protected UUID id;
    protected Instant createdAt;
    protected Instant updatedAt;
    
    protected BaseEntity() {
        this.id = UUID.randomUUID();
        this.createdAt = Instant.now();
        this.updatedAt = Instant.now();
    }
    
    public UUID getId() {
        return id;
    }
    
    public Instant getCreatedAt() {
        return createdAt;
    }
    
    public Instant getUpdatedAt() {
        return updatedAt;
    }
    
    protected void markUpdated() {
        this.updatedAt = Instant.now();
    }
    
    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;
        BaseEntity that = (BaseEntity) o;
        return id != null && id.equals(that.id);
    }
    
    @Override
    public int hashCode() {
        return id != null ? id.hashCode() : 0;
    }
}
