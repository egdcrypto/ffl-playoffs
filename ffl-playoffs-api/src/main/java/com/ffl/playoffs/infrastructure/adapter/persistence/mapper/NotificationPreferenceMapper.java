package com.ffl.playoffs.infrastructure.adapter.persistence.mapper;

import com.ffl.playoffs.domain.model.NotificationPreference;
import com.ffl.playoffs.infrastructure.adapter.persistence.document.NotificationPreferenceDocument;
import org.springframework.stereotype.Component;

import java.util.UUID;

/**
 * Mapper to convert between NotificationPreference domain model and NotificationPreferenceDocument
 * Infrastructure layer
 */
@Component
public class NotificationPreferenceMapper {

    /**
     * Converts NotificationPreference domain entity to NotificationPreferenceDocument
     * @param preference the domain entity
     * @return the MongoDB document
     */
    public NotificationPreferenceDocument toDocument(NotificationPreference preference) {
        if (preference == null) {
            return null;
        }

        NotificationPreferenceDocument document = new NotificationPreferenceDocument();
        document.setId(preference.getId() != null ? preference.getId().toString() : null);
        document.setUserId(preference.getUserId());
        document.setScoreMilestones(preference.isScoreMilestones());
        document.setRankChanges(preference.isRankChanges());
        document.setIndividualPlayerTDs(preference.isIndividualPlayerTDs());
        document.setMatchupLeadChanges(preference.isMatchupLeadChanges());
        document.setGameCompletion(preference.isGameCompletion());
        document.setQuietHoursEnabled(preference.isQuietHoursEnabled());
        document.setQuietHoursStart(preference.getQuietHoursStart());
        document.setQuietHoursEnd(preference.getQuietHoursEnd());
        document.setCreatedAt(preference.getCreatedAt());
        document.setUpdatedAt(preference.getUpdatedAt());

        return document;
    }

    /**
     * Converts NotificationPreferenceDocument to NotificationPreference domain entity
     * @param document the MongoDB document
     * @return the domain entity
     */
    public NotificationPreference toDomain(NotificationPreferenceDocument document) {
        if (document == null) {
            return null;
        }

        NotificationPreference preference = new NotificationPreference();
        preference.setId(document.getId() != null ? UUID.fromString(document.getId()) : null);
        preference.setUserId(document.getUserId());
        preference.setScoreMilestones(document.isScoreMilestones());
        preference.setRankChanges(document.isRankChanges());
        preference.setIndividualPlayerTDs(document.isIndividualPlayerTDs());
        preference.setMatchupLeadChanges(document.isMatchupLeadChanges());
        preference.setGameCompletion(document.isGameCompletion());
        preference.setQuietHoursEnabled(document.isQuietHoursEnabled());
        preference.setQuietHoursStart(document.getQuietHoursStart());
        preference.setQuietHoursEnd(document.getQuietHoursEnd());
        preference.setCreatedAt(document.getCreatedAt());
        preference.setUpdatedAt(document.getUpdatedAt());

        return preference;
    }
}
