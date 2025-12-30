package com.ffl.playoffs.infrastructure.adapter.persistence.mapper;

import com.ffl.playoffs.domain.model.NotificationPreference;
import com.ffl.playoffs.infrastructure.adapter.persistence.document.NotificationPreferenceDocument;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;

import java.time.LocalDateTime;
import java.util.UUID;

import static org.junit.jupiter.api.Assertions.*;

@DisplayName("NotificationPreferenceMapper Tests")
class NotificationPreferenceMapperTest {

    private NotificationPreferenceMapper mapper;

    @BeforeEach
    void setUp() {
        mapper = new NotificationPreferenceMapper();
    }

    @Test
    @DisplayName("toDocument should correctly map domain to document")
    void toDocumentShouldMapCorrectly() {
        // Arrange
        NotificationPreference preference = new NotificationPreference("user-123");
        preference.setId(UUID.randomUUID());
        preference.setScoreMilestones(true);
        preference.setRankChanges(false);
        preference.setIndividualPlayerTDs(true);
        preference.setMatchupLeadChanges(false);
        preference.setGameCompletion(true);
        preference.setQuietHoursEnabled(true);
        preference.setQuietHoursStart(22);
        preference.setQuietHoursEnd(8);

        // Act
        NotificationPreferenceDocument document = mapper.toDocument(preference);

        // Assert
        assertNotNull(document);
        assertEquals(preference.getId().toString(), document.getId());
        assertEquals("user-123", document.getUserId());
        assertTrue(document.isScoreMilestones());
        assertFalse(document.isRankChanges());
        assertTrue(document.isIndividualPlayerTDs());
        assertFalse(document.isMatchupLeadChanges());
        assertTrue(document.isGameCompletion());
        assertTrue(document.isQuietHoursEnabled());
        assertEquals(22, document.getQuietHoursStart());
        assertEquals(8, document.getQuietHoursEnd());
    }

    @Test
    @DisplayName("toDocument should return null for null input")
    void toDocumentShouldReturnNullForNullInput() {
        assertNull(mapper.toDocument(null));
    }

    @Test
    @DisplayName("toDomain should correctly map document to domain")
    void toDomainShouldMapCorrectly() {
        // Arrange
        NotificationPreferenceDocument document = new NotificationPreferenceDocument();
        UUID id = UUID.randomUUID();
        document.setId(id.toString());
        document.setUserId("user-456");
        document.setScoreMilestones(false);
        document.setRankChanges(true);
        document.setIndividualPlayerTDs(false);
        document.setMatchupLeadChanges(true);
        document.setGameCompletion(false);
        document.setQuietHoursEnabled(false);
        document.setQuietHoursStart(23);
        document.setQuietHoursEnd(7);
        document.setCreatedAt(LocalDateTime.now());
        document.setUpdatedAt(LocalDateTime.now());

        // Act
        NotificationPreference preference = mapper.toDomain(document);

        // Assert
        assertNotNull(preference);
        assertEquals(id, preference.getId());
        assertEquals("user-456", preference.getUserId());
        assertFalse(preference.isScoreMilestones());
        assertTrue(preference.isRankChanges());
        assertFalse(preference.isIndividualPlayerTDs());
        assertTrue(preference.isMatchupLeadChanges());
        assertFalse(preference.isGameCompletion());
        assertFalse(preference.isQuietHoursEnabled());
        assertEquals(23, preference.getQuietHoursStart());
        assertEquals(7, preference.getQuietHoursEnd());
    }

    @Test
    @DisplayName("toDomain should return null for null input")
    void toDomainShouldReturnNullForNullInput() {
        assertNull(mapper.toDomain(null));
    }

    @Test
    @DisplayName("roundtrip conversion should preserve all fields")
    void roundtripShouldPreserveAllFields() {
        // Arrange
        NotificationPreference original = new NotificationPreference("user-roundtrip");
        original.setScoreMilestones(true);
        original.setRankChanges(true);
        original.setIndividualPlayerTDs(true);
        original.setMatchupLeadChanges(true);
        original.setGameCompletion(true);
        original.setQuietHoursEnabled(true);
        original.setQuietHoursStart(21);
        original.setQuietHoursEnd(6);

        // Act
        NotificationPreferenceDocument document = mapper.toDocument(original);
        NotificationPreference roundTripped = mapper.toDomain(document);

        // Assert
        assertEquals(original.getId(), roundTripped.getId());
        assertEquals(original.getUserId(), roundTripped.getUserId());
        assertEquals(original.isScoreMilestones(), roundTripped.isScoreMilestones());
        assertEquals(original.isRankChanges(), roundTripped.isRankChanges());
        assertEquals(original.isIndividualPlayerTDs(), roundTripped.isIndividualPlayerTDs());
        assertEquals(original.isMatchupLeadChanges(), roundTripped.isMatchupLeadChanges());
        assertEquals(original.isGameCompletion(), roundTripped.isGameCompletion());
        assertEquals(original.isQuietHoursEnabled(), roundTripped.isQuietHoursEnabled());
        assertEquals(original.getQuietHoursStart(), roundTripped.getQuietHoursStart());
        assertEquals(original.getQuietHoursEnd(), roundTripped.getQuietHoursEnd());
    }
}
