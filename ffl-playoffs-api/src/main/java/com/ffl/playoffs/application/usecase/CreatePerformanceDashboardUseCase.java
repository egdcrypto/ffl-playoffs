package com.ffl.playoffs.application.usecase;

import com.ffl.playoffs.domain.aggregate.PerformanceDashboard;
import com.ffl.playoffs.domain.port.PerformanceDashboardRepository;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

import java.util.UUID;

/**
 * Use case for creating performance dashboards.
 */
@Slf4j
@RequiredArgsConstructor
public class CreatePerformanceDashboardUseCase {

    private final PerformanceDashboardRepository dashboardRepository;

    public PerformanceDashboard execute(Command command) {
        log.info("Creating performance dashboard: {} for user: {}", command.name(), command.ownerId());

        // Check for duplicate name
        if (dashboardRepository.existsByNameAndOwnerId(command.name(), command.ownerId())) {
            throw new IllegalArgumentException("Dashboard with name '" + command.name() + "' already exists");
        }

        // Create dashboard
        PerformanceDashboard dashboard;
        if (command.useDefaultLayout()) {
            dashboard = PerformanceDashboard.createDefault(command.ownerId());
            dashboard.updateName(command.name());
        } else {
            dashboard = PerformanceDashboard.create(command.name(), command.ownerId());
        }

        if (command.description() != null) {
            dashboard.updateDescription(command.description());
        }

        if (command.makeDefault()) {
            // Unmark any existing default dashboard
            dashboardRepository.findDefaultByOwnerId(command.ownerId())
                    .ifPresent(existing -> {
                        existing.unmarkAsDefault();
                        dashboardRepository.save(existing);
                    });
            dashboard.markAsDefault();
        }

        // Save and return
        PerformanceDashboard saved = dashboardRepository.save(dashboard);
        log.info("Created performance dashboard with ID: {}", saved.getId());

        return saved;
    }

    public record Command(
            String name,
            String description,
            UUID ownerId,
            boolean useDefaultLayout,
            boolean makeDefault
    ) {}
}
