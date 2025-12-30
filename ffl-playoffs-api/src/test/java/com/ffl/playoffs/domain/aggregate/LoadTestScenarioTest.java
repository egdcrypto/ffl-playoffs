package com.ffl.playoffs.domain.aggregate;

import com.ffl.playoffs.domain.model.loadtest.LoadTestConfiguration;
import com.ffl.playoffs.domain.model.loadtest.LoadTestType;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;

import java.util.UUID;

import static org.assertj.core.api.Assertions.*;

@DisplayName("LoadTestScenario Aggregate Tests")
class LoadTestScenarioTest {

    @Test
    @DisplayName("should create scenario with required fields")
    void shouldCreateScenarioWithRequiredFields() {
        UUID worldId = UUID.randomUUID();

        LoadTestScenario scenario = LoadTestScenario.create(worldId, "API Stress Test", LoadTestType.STRESS);

        assertThat(scenario.getId()).isNotNull();
        assertThat(scenario.getWorldId()).isEqualTo(worldId);
        assertThat(scenario.getName()).isEqualTo("API Stress Test");
        assertThat(scenario.getTestType()).isEqualTo(LoadTestType.STRESS);
        assertThat(scenario.isEnabled()).isTrue();
        assertThat(scenario.getPriority()).isEqualTo(5);
        assertThat(scenario.getConfiguration()).isNotNull();
        assertThat(scenario.getTags()).isEmpty();
        assertThat(scenario.getCreatedAt()).isNotNull();
        assertThat(scenario.getUpdatedAt()).isNotNull();
    }

    @Test
    @DisplayName("should default to STRESS type when null provided")
    void shouldDefaultToStressTypeWhenNull() {
        LoadTestScenario scenario = LoadTestScenario.create(UUID.randomUUID(), "Default Test", null);

        assertThat(scenario.getTestType()).isEqualTo(LoadTestType.STRESS);
    }

    @Test
    @DisplayName("should throw when world ID is null")
    void shouldThrowWhenWorldIdIsNull() {
        assertThatNullPointerException()
                .isThrownBy(() -> LoadTestScenario.create(null, "Test", LoadTestType.STRESS))
                .withMessage("World ID is required");
    }

    @Test
    @DisplayName("should throw when name is null")
    void shouldThrowWhenNameIsNull() {
        assertThatNullPointerException()
                .isThrownBy(() -> LoadTestScenario.create(UUID.randomUUID(), null, LoadTestType.STRESS))
                .withMessage("Name is required");
    }

    @Test
    @DisplayName("should update configuration")
    void shouldUpdateConfiguration() {
        LoadTestScenario scenario = LoadTestScenario.create(UUID.randomUUID(), "Test", LoadTestType.SOAK);
        LoadTestConfiguration newConfig = LoadTestConfiguration.create("New Config", LoadTestType.SOAK);

        scenario.updateConfiguration(newConfig);

        assertThat(scenario.getConfiguration()).isEqualTo(newConfig);
    }

    @Test
    @DisplayName("should throw when updating with null configuration")
    void shouldThrowWhenUpdatingWithNullConfiguration() {
        LoadTestScenario scenario = LoadTestScenario.create(UUID.randomUUID(), "Test", LoadTestType.STRESS);

        assertThatNullPointerException()
                .isThrownBy(() -> scenario.updateConfiguration(null))
                .withMessage("Configuration is required");
    }

    @Test
    @DisplayName("should enable and disable scenario")
    void shouldEnableAndDisableScenario() {
        LoadTestScenario scenario = LoadTestScenario.create(UUID.randomUUID(), "Test", LoadTestType.STRESS);
        assertThat(scenario.isEnabled()).isTrue();

        scenario.disable();
        assertThat(scenario.isEnabled()).isFalse();

        scenario.enable();
        assertThat(scenario.isEnabled()).isTrue();
    }

    @Test
    @DisplayName("should set valid priority")
    void shouldSetValidPriority() {
        LoadTestScenario scenario = LoadTestScenario.create(UUID.randomUUID(), "Test", LoadTestType.STRESS);

        scenario.setPriority(1);
        assertThat(scenario.getPriority()).isEqualTo(1);

        scenario.setPriority(10);
        assertThat(scenario.getPriority()).isEqualTo(10);
    }

    @Test
    @DisplayName("should throw when priority is out of range")
    void shouldThrowWhenPriorityIsOutOfRange() {
        LoadTestScenario scenario = LoadTestScenario.create(UUID.randomUUID(), "Test", LoadTestType.STRESS);

        assertThatIllegalArgumentException()
                .isThrownBy(() -> scenario.setPriority(0))
                .withMessage("Priority must be between 1 and 10");

        assertThatIllegalArgumentException()
                .isThrownBy(() -> scenario.setPriority(11))
                .withMessage("Priority must be between 1 and 10");
    }

    @Test
    @DisplayName("should add and remove tags")
    void shouldAddAndRemoveTags() {
        LoadTestScenario scenario = LoadTestScenario.create(UUID.randomUUID(), "Test", LoadTestType.STRESS);

        scenario.addTag("critical");
        scenario.addTag("api");
        assertThat(scenario.getTags()).containsExactly("critical", "api");
        assertThat(scenario.hasTag("critical")).isTrue();
        assertThat(scenario.hasTag("nonexistent")).isFalse();

        scenario.removeTag("critical");
        assertThat(scenario.getTags()).containsExactly("api");
        assertThat(scenario.hasTag("critical")).isFalse();
    }

    @Test
    @DisplayName("should not add duplicate tags")
    void shouldNotAddDuplicateTags() {
        LoadTestScenario scenario = LoadTestScenario.create(UUID.randomUUID(), "Test", LoadTestType.STRESS);

        scenario.addTag("critical");
        scenario.addTag("critical");

        assertThat(scenario.getTags()).containsExactly("critical");
    }

    @Test
    @DisplayName("should update description")
    void shouldUpdateDescription() {
        LoadTestScenario scenario = LoadTestScenario.create(UUID.randomUUID(), "Test", LoadTestType.STRESS);
        assertThat(scenario.getDescription()).isNull();

        scenario.updateDescription("This is a test scenario");
        assertThat(scenario.getDescription()).isEqualTo("This is a test scenario");
    }
}
