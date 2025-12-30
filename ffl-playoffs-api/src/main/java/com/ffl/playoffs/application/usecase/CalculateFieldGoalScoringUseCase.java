package com.ffl.playoffs.application.usecase;

import com.ffl.playoffs.application.dto.FieldGoalAttemptDTO;
import com.ffl.playoffs.application.dto.FieldGoalRangeBreakdownDTO;
import com.ffl.playoffs.application.dto.FieldGoalScoringBreakdownDTO;
import com.ffl.playoffs.domain.model.FieldGoalAttempt;
import com.ffl.playoffs.domain.model.FieldGoalDistanceRange;
import com.ffl.playoffs.domain.model.FieldGoalScoringRules;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

/**
 * Use case for calculating field goal scoring based on distance tiers
 */
@Service
@RequiredArgsConstructor
@Slf4j
public class CalculateFieldGoalScoringUseCase {

    /**
     * Calculate total field goal points for a list of attempts using default rules
     * @param attempts list of field goal attempts
     * @return total points earned
     */
    public double calculateTotalPoints(List<FieldGoalAttempt> attempts) {
        return calculateTotalPoints(attempts, FieldGoalScoringRules.defaultRules());
    }

    /**
     * Calculate total field goal points for a list of attempts using custom rules
     * @param attempts list of field goal attempts
     * @param rules the scoring rules to apply
     * @return total points earned
     */
    public double calculateTotalPoints(List<FieldGoalAttempt> attempts, FieldGoalScoringRules rules) {
        if (attempts == null || attempts.isEmpty()) {
            return 0.0;
        }

        double total = rules.calculateTotalPoints(attempts);
        log.debug("Calculated {} total field goal points from {} attempts", total, attempts.size());
        return total;
    }

    /**
     * Calculate detailed breakdown of field goal scoring
     * @param teamName the team name
     * @param week the week number
     * @param attempts list of field goal attempts
     * @return detailed scoring breakdown DTO
     */
    public FieldGoalScoringBreakdownDTO calculateBreakdown(String teamName, int week, List<FieldGoalAttempt> attempts) {
        return calculateBreakdown(teamName, week, attempts, FieldGoalScoringRules.defaultRules());
    }

    /**
     * Calculate detailed breakdown of field goal scoring with custom rules
     * @param teamName the team name
     * @param week the week number
     * @param attempts list of field goal attempts
     * @param rules the scoring rules to apply
     * @return detailed scoring breakdown DTO
     */
    public FieldGoalScoringBreakdownDTO calculateBreakdown(String teamName, int week,
            List<FieldGoalAttempt> attempts, FieldGoalScoringRules rules) {

        log.info("Calculating field goal breakdown for {} in week {}", teamName, week);

        List<FieldGoalAttemptDTO> attemptDTOs = new ArrayList<>();
        int madeCount = 0;
        int attemptedCount = 0;

        if (attempts != null) {
            attemptedCount = attempts.size();
            for (FieldGoalAttempt attempt : attempts) {
                FieldGoalDistanceRange range = attempt.getDistanceRange();
                double points = attempt.isMade() ? rules.getPointsForRange(range) : 0.0;

                if (attempt.isMade()) {
                    madeCount++;
                }

                attemptDTOs.add(FieldGoalAttemptDTO.builder()
                        .distanceYards(attempt.getDistanceYards())
                        .range(range.getDisplayName())
                        .result(attempt.getResult().name())
                        .points(points)
                        .kicker(attempt.getKicker())
                        .quarter(attempt.getQuarter())
                        .build());
            }
        }

        // Calculate range breakdown
        Map<FieldGoalDistanceRange, FieldGoalScoringRules.FieldGoalRangeBreakdown> breakdownMap =
                rules.calculateBreakdown(attempts);

        List<FieldGoalRangeBreakdownDTO> rangeBreakdownDTOs = new ArrayList<>();
        for (FieldGoalDistanceRange range : FieldGoalDistanceRange.values()) {
            FieldGoalScoringRules.FieldGoalRangeBreakdown breakdown = breakdownMap.get(range);
            rangeBreakdownDTOs.add(FieldGoalRangeBreakdownDTO.builder()
                    .range(range.getDisplayName())
                    .count(breakdown.getCount())
                    .pointsPerFieldGoal(breakdown.getPointsPerFg())
                    .total(breakdown.getTotal())
                    .build());
        }

        double totalPoints = rules.calculateTotalPoints(attempts);

        log.info("Calculated {} total FG points ({}/{} made) for {}",
                totalPoints, madeCount, attemptedCount, teamName);

        return FieldGoalScoringBreakdownDTO.builder()
                .teamName(teamName)
                .week(week)
                .fieldGoals(attemptDTOs)
                .rangeBreakdown(rangeBreakdownDTOs)
                .totalFieldGoalPoints(totalPoints)
                .madeFieldGoals(madeCount)
                .attemptedFieldGoals(attemptedCount)
                .build();
    }

    /**
     * Validates a field goal distance
     * @param yards the distance in yards
     * @return true if valid, false otherwise
     */
    public boolean isValidDistance(int yards) {
        return yards >= 0;
    }

    /**
     * Gets the distance range for a given yardage
     * @param yards the distance in yards
     * @return the corresponding distance range
     * @throws IllegalArgumentException if yards is negative
     */
    public FieldGoalDistanceRange getDistanceRange(int yards) {
        return FieldGoalDistanceRange.fromDistance(yards);
    }
}
