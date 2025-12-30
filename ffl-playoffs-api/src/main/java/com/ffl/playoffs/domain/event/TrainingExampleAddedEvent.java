package com.ffl.playoffs.domain.event;

import com.ffl.playoffs.domain.model.TrainingExampleType;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDateTime;
import java.util.List;
import java.util.UUID;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class TrainingExampleAddedEvent {
    private UUID exampleId;
    private UUID conversationId;
    private UUID characterId;
    private TrainingExampleType type;
    private int qualityRating;
    private List<String> tags;
    private UUID addedBy;
    private LocalDateTime timestamp;
}
