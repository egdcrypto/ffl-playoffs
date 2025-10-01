package com.ffl.playoffs.domain.model;

import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;

import static org.assertj.core.api.Assertions.*;

@DisplayName("PATScope Enum Tests")
class PATScopeTest {

    @Test
    @DisplayName("should have exactly three scopes")
    void shouldHaveExactlyThreeScopes() {
        assertThat(PATScope.values()).hasSize(3);
    }

    @Test
    @DisplayName("should have READ_ONLY scope")
    void shouldHaveReadOnlyScope() {
        assertThat(PATScope.READ_ONLY).isNotNull();
        assertThat(PATScope.valueOf("READ_ONLY")).isEqualTo(PATScope.READ_ONLY);
    }

    @Test
    @DisplayName("should have WRITE scope")
    void shouldHaveWriteScope() {
        assertThat(PATScope.WRITE).isNotNull();
        assertThat(PATScope.valueOf("WRITE")).isEqualTo(PATScope.WRITE);
    }

    @Test
    @DisplayName("should have ADMIN scope")
    void shouldHaveAdminScope() {
        assertThat(PATScope.ADMIN).isNotNull();
        assertThat(PATScope.valueOf("ADMIN")).isEqualTo(PATScope.ADMIN);
    }

    @Test
    @DisplayName("scopes should maintain consistent ordering")
    void scopesShouldMaintainConsistentOrdering() {
        PATScope[] scopes = PATScope.values();
        assertThat(scopes[0]).isEqualTo(PATScope.READ_ONLY);
        assertThat(scopes[1]).isEqualTo(PATScope.WRITE);
        assertThat(scopes[2]).isEqualTo(PATScope.ADMIN);
    }
}
