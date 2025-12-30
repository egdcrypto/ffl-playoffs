package com.ffl.playoffs.infrastructure.adapter.persistence;

import com.ffl.playoffs.domain.model.NotificationPreference;
import com.ffl.playoffs.infrastructure.adapter.persistence.document.NotificationPreferenceDocument;
import com.ffl.playoffs.infrastructure.adapter.persistence.mapper.NotificationPreferenceMapper;
import com.ffl.playoffs.infrastructure.adapter.persistence.repository.NotificationPreferenceMongoRepository;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;

import java.util.Optional;
import java.util.UUID;

import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.Mockito.*;

@ExtendWith(MockitoExtension.class)
@DisplayName("NotificationPreferenceRepositoryImpl Tests")
class NotificationPreferenceRepositoryImplTest {

    @Mock
    private NotificationPreferenceMongoRepository mongoRepository;

    @Mock
    private NotificationPreferenceMapper mapper;

    @InjectMocks
    private NotificationPreferenceRepositoryImpl repository;

    private NotificationPreference testPreference;
    private NotificationPreferenceDocument testDocument;
    private String testUserId;
    private UUID testId;

    @BeforeEach
    void setUp() {
        testUserId = "user-123";
        testId = UUID.randomUUID();

        testPreference = new NotificationPreference(testUserId);
        testPreference.setId(testId);
        testPreference.setScoreMilestones(true);
        testPreference.setRankChanges(true);
        testPreference.setIndividualPlayerTDs(false);

        testDocument = new NotificationPreferenceDocument();
        testDocument.setId(testId.toString());
        testDocument.setUserId(testUserId);
        testDocument.setScoreMilestones(true);
        testDocument.setRankChanges(true);
        testDocument.setIndividualPlayerTDs(false);
    }

    @Test
    @DisplayName("save should persist preference and return saved entity")
    void saveShouldPersistAndReturnSaved() {
        // Arrange
        when(mapper.toDocument(testPreference)).thenReturn(testDocument);
        when(mongoRepository.save(testDocument)).thenReturn(testDocument);
        when(mapper.toDomain(testDocument)).thenReturn(testPreference);

        // Act
        NotificationPreference result = repository.save(testPreference);

        // Assert
        assertNotNull(result);
        assertEquals(testUserId, result.getUserId());
        verify(mongoRepository).save(testDocument);
    }

    @Test
    @DisplayName("findByUserId should return preference when found")
    void findByUserIdShouldReturnPreferenceWhenFound() {
        // Arrange
        when(mongoRepository.findByUserId(testUserId)).thenReturn(Optional.of(testDocument));
        when(mapper.toDomain(testDocument)).thenReturn(testPreference);

        // Act
        Optional<NotificationPreference> result = repository.findByUserId(testUserId);

        // Assert
        assertTrue(result.isPresent());
        assertEquals(testUserId, result.get().getUserId());
    }

    @Test
    @DisplayName("findByUserId should return empty when not found")
    void findByUserIdShouldReturnEmptyWhenNotFound() {
        // Arrange
        when(mongoRepository.findByUserId("nonexistent")).thenReturn(Optional.empty());

        // Act
        Optional<NotificationPreference> result = repository.findByUserId("nonexistent");

        // Assert
        assertTrue(result.isEmpty());
    }

    @Test
    @DisplayName("findById should return preference when found")
    void findByIdShouldReturnPreferenceWhenFound() {
        // Arrange
        when(mongoRepository.findById(testId.toString())).thenReturn(Optional.of(testDocument));
        when(mapper.toDomain(testDocument)).thenReturn(testPreference);

        // Act
        Optional<NotificationPreference> result = repository.findById(testId);

        // Assert
        assertTrue(result.isPresent());
        assertEquals(testId, result.get().getId());
    }

    @Test
    @DisplayName("findById should return empty when not found")
    void findByIdShouldReturnEmptyWhenNotFound() {
        // Arrange
        UUID unknownId = UUID.randomUUID();
        when(mongoRepository.findById(unknownId.toString())).thenReturn(Optional.empty());

        // Act
        Optional<NotificationPreference> result = repository.findById(unknownId);

        // Assert
        assertTrue(result.isEmpty());
    }

    @Test
    @DisplayName("deleteByUserId should call mongo repository")
    void deleteByUserIdShouldCallMongoRepository() {
        // Act
        repository.deleteByUserId(testUserId);

        // Assert
        verify(mongoRepository).deleteByUserId(testUserId);
    }

    @Test
    @DisplayName("existsByUserId should return true when exists")
    void existsByUserIdShouldReturnTrueWhenExists() {
        // Arrange
        when(mongoRepository.existsByUserId(testUserId)).thenReturn(true);

        // Act
        boolean result = repository.existsByUserId(testUserId);

        // Assert
        assertTrue(result);
    }

    @Test
    @DisplayName("existsByUserId should return false when not exists")
    void existsByUserIdShouldReturnFalseWhenNotExists() {
        // Arrange
        when(mongoRepository.existsByUserId("nonexistent")).thenReturn(false);

        // Act
        boolean result = repository.existsByUserId("nonexistent");

        // Assert
        assertFalse(result);
    }
}
