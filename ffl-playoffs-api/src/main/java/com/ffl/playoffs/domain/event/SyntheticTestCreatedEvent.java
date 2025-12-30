package com.ffl.playoffs.domain.event;

import com.ffl.playoffs.domain.model.SyntheticTestType;
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
public class SyntheticTestCreatedEvent {
    private UUID testId;
    private String name;
    private SyntheticTestType type;
    private String url;
    private List<String> locations;
    private UUID createdBy;
    private LocalDateTime timestamp;
}
