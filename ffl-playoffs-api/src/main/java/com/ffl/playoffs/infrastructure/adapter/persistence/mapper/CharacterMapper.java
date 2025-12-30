package com.ffl.playoffs.infrastructure.adapter.persistence.mapper;

import com.ffl.playoffs.domain.model.character.Character;
import com.ffl.playoffs.domain.model.character.CharacterStatus;
import com.ffl.playoffs.infrastructure.adapter.persistence.document.CharacterDocument;
import org.springframework.stereotype.Component;

import java.util.UUID;

/**
 * Mapper for converting between Character domain model and CharacterDocument
 */
@Component
public class CharacterMapper {

    /**
     * Convert domain model to document
     * @param character the domain model
     * @return the document
     */
    public CharacterDocument toDocument(Character character) {
        if (character == null) {
            return null;
        }

        CharacterDocument doc = new CharacterDocument();
        doc.setId(character.getId() != null ? character.getId().toString() : null);
        doc.setUserId(character.getUserId() != null ? character.getUserId().toString() : null);
        doc.setLeagueId(character.getLeagueId() != null ? character.getLeagueId().toString() : null);
        doc.setName(character.getName());
        doc.setAvatarUrl(character.getAvatarUrl());
        doc.setStatus(character.getStatus() != null ? character.getStatus().getCode() : null);
        doc.setTotalScore(character.getTotalScore());
        doc.setWeeklyRank(character.getWeeklyRank());
        doc.setOverallRank(character.getOverallRank());
        doc.setEliminationWeek(character.getEliminationWeek());
        doc.setEliminationScore(character.getEliminationScore());
        doc.setEliminationRank(character.getEliminationRank());
        doc.setEliminationReason(character.getEliminationReason());
        doc.setCreatedAt(character.getCreatedAt());
        doc.setActivatedAt(character.getActivatedAt());
        doc.setEliminatedAt(character.getEliminatedAt());
        doc.setUpdatedAt(character.getUpdatedAt());

        return doc;
    }

    /**
     * Convert document to domain model
     * @param doc the document
     * @return the domain model
     */
    public Character toDomain(CharacterDocument doc) {
        if (doc == null) {
            return null;
        }

        return Character.builder()
                .id(doc.getId() != null ? UUID.fromString(doc.getId()) : null)
                .userId(doc.getUserId() != null ? UUID.fromString(doc.getUserId()) : null)
                .leagueId(doc.getLeagueId() != null ? UUID.fromString(doc.getLeagueId()) : null)
                .name(doc.getName())
                .avatarUrl(doc.getAvatarUrl())
                .status(doc.getStatus() != null ? CharacterStatus.fromCode(doc.getStatus()) : null)
                .totalScore(doc.getTotalScore())
                .weeklyRank(doc.getWeeklyRank())
                .overallRank(doc.getOverallRank())
                .eliminationWeek(doc.getEliminationWeek())
                .eliminationScore(doc.getEliminationScore())
                .eliminationRank(doc.getEliminationRank())
                .eliminationReason(doc.getEliminationReason())
                .createdAt(doc.getCreatedAt())
                .activatedAt(doc.getActivatedAt())
                .eliminatedAt(doc.getEliminatedAt())
                .updatedAt(doc.getUpdatedAt())
                .build();
    }
}
