package com.ffl.playoffs.application.usecase;

import com.ffl.playoffs.domain.model.narrative.AIDirector;
import com.ffl.playoffs.domain.model.narrative.CuratorAction;
import com.ffl.playoffs.domain.model.narrative.CuratorActionType;
import com.ffl.playoffs.domain.port.AIDirectorRepository;
import com.ffl.playoffs.domain.port.CuratorActionRepository;
import lombok.Builder;
import lombok.Getter;
import lombok.RequiredArgsConstructor;

import java.util.*;

/**
 * Use case for executing curator actions
 */
@RequiredArgsConstructor
public class ExecuteCuratorActionUseCase {

    private final AIDirectorRepository directorRepository;
    private final CuratorActionRepository curatorActionRepository;

    /**
     * Create and queue a curator action
     * @param command the creation command
     * @return the created curator action
     */
    public CuratorAction createAction(CreateActionCommand command) {
        AIDirector director = findDirector(command.getLeagueId());

        CuratorAction action;
        if (command.isAutomated()) {
            action = CuratorAction.createAutomated(
                    command.getLeagueId(),
                    command.getType(),
                    command.getDescription()
            );
        } else {
            action = CuratorAction.createManual(
                    command.getLeagueId(),
                    command.getType(),
                    command.getDescription(),
                    command.getInitiatedBy()
            );
        }

        // Add optional context
        if (command.getRelatedStallConditionId() != null) {
            action = CuratorAction.builder()
                    .leagueId(command.getLeagueId())
                    .type(command.getType())
                    .description(command.getDescription())
                    .automated(command.isAutomated())
                    .initiatedBy(command.getInitiatedBy())
                    .relatedStallConditionId(command.getRelatedStallConditionId())
                    .relatedStoryArcId(command.getRelatedStoryArcId())
                    .targetPlayerIds(command.getTargetPlayerIds())
                    .parameters(command.getParameters())
                    .build();
        }

        action = curatorActionRepository.save(action);

        // Queue the action with the director
        director.queueAction(action.getId());
        directorRepository.save(director);

        return action;
    }

    /**
     * Execute a pending curator action
     * @param actionId the action ID
     * @return the executing action
     */
    public CuratorAction startExecution(UUID actionId) {
        CuratorAction action = findAction(actionId);

        action.startExecution();

        return curatorActionRepository.save(action);
    }

    /**
     * Complete a curator action
     * @param command the completion command
     * @return the completed action
     */
    public CuratorAction completeAction(CompleteActionCommand command) {
        CuratorAction action = findAction(command.getActionId());
        AIDirector director = findDirector(action.getLeagueId());

        action.complete(command.getResults());
        action = curatorActionRepository.save(action);

        director.completeAction(action.getId());
        directorRepository.save(director);

        return action;
    }

    /**
     * Fail a curator action
     * @param actionId the action ID
     * @param reason the failure reason
     * @return the failed action
     */
    public CuratorAction failAction(UUID actionId, String reason) {
        CuratorAction action = findAction(actionId);
        AIDirector director = findDirector(action.getLeagueId());

        action.fail(reason);
        action = curatorActionRepository.save(action);

        director.completeAction(action.getId());
        directorRepository.save(director);

        return action;
    }

    /**
     * Cancel a pending curator action
     * @param actionId the action ID
     * @param reason the cancellation reason
     * @return the cancelled action
     */
    public CuratorAction cancelAction(UUID actionId, String reason) {
        CuratorAction action = findAction(actionId);
        AIDirector director = findDirector(action.getLeagueId());

        action.cancel(reason);
        action = curatorActionRepository.save(action);

        director.completeAction(action.getId());
        directorRepository.save(director);

        return action;
    }

    /**
     * Get pending actions for a league
     * @param leagueId the league ID
     * @return list of pending actions
     */
    public List<CuratorAction> getPendingActions(UUID leagueId) {
        return curatorActionRepository.findPendingByLeagueId(leagueId);
    }

    /**
     * Get recent actions for a league
     * @param leagueId the league ID
     * @param limit max number of actions
     * @return list of recent actions
     */
    public List<CuratorAction> getRecentActions(UUID leagueId, int limit) {
        return curatorActionRepository.findRecentByLeagueId(leagueId, limit);
    }

    /**
     * Get action history for a stall condition
     * @param stallConditionId the stall condition ID
     * @return list of related actions
     */
    public List<CuratorAction> getActionsForStall(UUID stallConditionId) {
        return curatorActionRepository.findByRelatedStallConditionId(stallConditionId);
    }

    private AIDirector findDirector(UUID leagueId) {
        return directorRepository.findByLeagueId(leagueId)
                .orElseThrow(() -> new IllegalArgumentException("AI Director not found for league: " + leagueId));
    }

    private CuratorAction findAction(UUID actionId) {
        return curatorActionRepository.findById(actionId)
                .orElseThrow(() -> new IllegalArgumentException("Curator action not found: " + actionId));
    }

    @Getter
    @Builder
    public static class CreateActionCommand {
        private final UUID leagueId;
        private final CuratorActionType type;
        private final String description;
        private final boolean automated;
        private final UUID initiatedBy;
        private final UUID relatedStallConditionId;
        private final UUID relatedStoryArcId;
        @Builder.Default
        private final Set<UUID> targetPlayerIds = new HashSet<>();
        @Builder.Default
        private final Map<String, Object> parameters = new HashMap<>();
    }

    @Getter
    @RequiredArgsConstructor
    public static class CompleteActionCommand {
        private final UUID actionId;
        private final Map<String, Object> results;
    }
}
