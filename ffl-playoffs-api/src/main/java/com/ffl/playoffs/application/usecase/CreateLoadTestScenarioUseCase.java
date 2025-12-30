package com.ffl.playoffs.application.usecase;

import com.ffl.playoffs.domain.aggregate.LoadTestScenario;
import com.ffl.playoffs.domain.model.loadtest.LoadTestConfiguration;
import com.ffl.playoffs.domain.model.loadtest.LoadTestType;
import com.ffl.playoffs.domain.port.LoadTestScenarioRepository;
import lombok.Builder;
import lombok.Getter;

import java.util.List;
import java.util.UUID;

/**
 * Use case for creating a new load test scenario.
 */
public class CreateLoadTestScenarioUseCase {

    private final LoadTestScenarioRepository scenarioRepository;

    public CreateLoadTestScenarioUseCase(LoadTestScenarioRepository scenarioRepository) {
        this.scenarioRepository = scenarioRepository;
    }

    /**
     * Creates a new load test scenario.
     *
     * @param command The create scenario command
     * @return The created LoadTestScenario
     */
    public LoadTestScenario execute(CreateLoadTestScenarioCommand command) {
        // Create scenario
        LoadTestScenario scenario = LoadTestScenario.create(
                command.getWorldId(),
                command.getName(),
                command.getTestType()
        );

        // Set optional fields
        if (command.getDescription() != null) {
            scenario.updateDescription(command.getDescription());
        }

        if (command.getConfiguration() != null) {
            scenario.updateConfiguration(command.getConfiguration());
        }

        if (command.getTags() != null) {
            command.getTags().forEach(scenario::addTag);
        }

        if (command.getPriority() != null) {
            scenario.setPriority(command.getPriority());
        }

        if (command.getCreatedBy() != null) {
            scenario.setCreatedBy(command.getCreatedBy());
        }

        // Save and return
        return scenarioRepository.save(scenario);
    }

    @Getter
    @Builder
    public static class CreateLoadTestScenarioCommand {
        private final UUID worldId;
        private final String name;
        private final LoadTestType testType;
        private final String description;
        private final LoadTestConfiguration configuration;
        private final List<String> tags;
        private final Integer priority;
        private final String createdBy;
    }
}
