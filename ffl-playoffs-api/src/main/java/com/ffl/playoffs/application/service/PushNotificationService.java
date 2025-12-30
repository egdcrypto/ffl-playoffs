package com.ffl.playoffs.application.service;

import com.ffl.playoffs.application.dto.NotificationPreferencesDTO;
import com.ffl.playoffs.domain.event.GameCompletedEvent;
import com.ffl.playoffs.domain.event.LeaderboardRankChangedEvent;
import com.ffl.playoffs.domain.event.PlayerStatsUpdatedEvent;
import com.ffl.playoffs.domain.event.RosterScoreChangedEvent;
import com.ffl.playoffs.domain.model.RankChange;
import com.ffl.playoffs.domain.port.PushNotificationPort;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.time.LocalTime;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;

/**
 * Service for sending push notifications based on live scoring events
 * Implements batching and user preference handling
 */
@Slf4j
@Service
@RequiredArgsConstructor
public class PushNotificationService {

    private final PushNotificationPort notificationPort;

    // Cache for notification preferences
    private final Map<String, NotificationPreferencesDTO> preferencesCache = new ConcurrentHashMap<>();

    // Batching: track pending notifications per user
    private final Map<String, List<PendingNotification>> pendingNotifications = new ConcurrentHashMap<>();
    private static final int BATCH_WINDOW_SECONDS = 120; // 2 minutes
    private static final int MAX_BATCH_SIZE = 5;

    // Score milestones
    private static final List<Integer> MILESTONES = List.of(50, 100, 150, 200, 250, 300);

    /**
     * Handle score change event and send appropriate notifications
     */
    public void handleScoreChange(RosterScoreChangedEvent event) {
        String userId = getUserIdForLeaguePlayer(event.getLeaguePlayerId());
        NotificationPreferencesDTO prefs = getPreferences(userId);

        // Check for score milestones
        if (prefs.isScoreMilestones()) {
            for (int milestone : MILESTONES) {
                if (event.crossedMilestone(milestone)) {
                    queueNotification(userId, new PendingNotification(
                            "Score Milestone!",
                            String.format("Your roster just hit %d points!", milestone),
                            Map.of(
                                    "currentScore", event.getNewScore(),
                                    "milestone", milestone
                            ),
                            NotificationType.MILESTONE
                    ));
                    break; // Only notify for the highest crossed milestone
                }
            }
        }
    }

    /**
     * Handle rank change event and send notifications
     */
    public void handleRankChange(LeaderboardRankChangedEvent event) {
        for (RankChange change : event.getRankChanges()) {
            String userId = getUserIdForLeaguePlayer(change.getLeaguePlayerId());
            NotificationPreferencesDTO prefs = getPreferences(userId);

            if (!prefs.isRankChanges()) {
                continue;
            }

            // Check for top 3 entry
            if (change.enteredTopThree()) {
                String title = change.getNewRank() == 1 ? "You're in the Lead!" :
                               String.format("You're in the Top %d!", change.getNewRank());
                String body = String.format("You moved up to %s place", ordinal(change.getNewRank()));

                queueNotification(userId, new PendingNotification(
                        title,
                        body,
                        Map.of(
                                "previousRank", change.getPreviousRank(),
                                "newRank", change.getNewRank(),
                                "currentScore", change.getCurrentScore()
                        ),
                        NotificationType.RANK_CHANGE
                ));
            } else if (change.isSignificant() && change.movedUp()) {
                // Significant upward movement
                queueNotification(userId, new PendingNotification(
                        "Rank Improvement!",
                        String.format("You moved up %d spots to %s place",
                                change.getRankDelta(), ordinal(change.getNewRank())),
                        Map.of(
                                "previousRank", change.getPreviousRank(),
                                "newRank", change.getNewRank(),
                                "pointsBehindLeader", change.getPointsBehindLeader()
                        ),
                        NotificationType.RANK_CHANGE
                ));
            }
        }
    }

    /**
     * Handle individual player scoring event (touchdowns, etc.)
     */
    public void handlePlayerScoring(String leaguePlayerId, PlayerStatsUpdatedEvent event) {
        String userId = getUserIdForLeaguePlayer(leaguePlayerId);
        NotificationPreferencesDTO prefs = getPreferences(userId);

        if (!prefs.isIndividualPlayerTDs()) {
            return;
        }

        // Only notify for touchdowns (significant positive point changes)
        if (event.getPointsDelta() >= 6) {
            queueNotification(userId, new PendingNotification(
                    String.format("%s Touchdown!", event.getNflPlayerName()),
                    String.format("%s TD! +%.0f pts", event.getNflPlayerName(), event.getPointsDelta()),
                    Map.of(
                            "nflPlayer", event.getNflPlayerName(),
                            "points", event.getPointsDelta(),
                            "playType", event.getStatUpdate()
                    ),
                    NotificationType.PLAYER_TD
            ));
        }
    }

    /**
     * Handle game completion notification
     */
    public void handleGameCompleted(GameCompletedEvent event, List<String> affectedLeaguePlayerIds) {
        for (String leaguePlayerId : affectedLeaguePlayerIds) {
            String userId = getUserIdForLeaguePlayer(leaguePlayerId);
            NotificationPreferencesDTO prefs = getPreferences(userId);

            if (!prefs.isGameCompletion()) {
                continue;
            }

            sendNotification(userId, new PendingNotification(
                    "Game Complete",
                    event.getGameSummary(),
                    Map.of(
                            "gameId", event.getNflGameId(),
                            "isOvertime", event.isOvertime()
                    ),
                    NotificationType.GAME_COMPLETE
            ));
        }
    }

    /**
     * Handle matchup lead change
     */
    public void handleMatchupLeadChange(String leaguePlayerId, String opponentId,
                                         BigDecimal yourScore, BigDecimal theirScore,
                                         boolean youTookLead) {
        String userId = getUserIdForLeaguePlayer(leaguePlayerId);
        NotificationPreferencesDTO prefs = getPreferences(userId);

        if (!prefs.isMatchupLeadChanges()) {
            return;
        }

        BigDecimal margin = yourScore.subtract(theirScore).abs();
        String title = youTookLead ? "You Took the Lead!" : "You Lost the Lead!";
        String body = youTookLead ?
                String.format("You're now ahead by %.1f pts", margin) :
                String.format("You're now behind by %.1f pts", margin);

        queueNotification(userId, new PendingNotification(
                title,
                body,
                Map.of(
                        "opponent", opponentId,
                        "yourScore", yourScore,
                        "theirScore", theirScore,
                        "youTookLead", youTookLead
                ),
                NotificationType.MATCHUP_LEAD
        ));
    }

    /**
     * Queue a notification for batching
     */
    private void queueNotification(String userId, PendingNotification notification) {
        NotificationPreferencesDTO prefs = getPreferences(userId);
        int currentHour = LocalTime.now().getHour();

        if (prefs.isInQuietHours(currentHour)) {
            // Schedule for delivery after quiet hours
            int deliveryHour = prefs.getQuietHoursEnd();
            LocalDateTime deliveryTime = LocalDateTime.now()
                    .withHour(deliveryHour)
                    .withMinute(0);
            if (deliveryTime.isBefore(LocalDateTime.now())) {
                deliveryTime = deliveryTime.plusDays(1);
            }

            notificationPort.queueNotification(
                    userId,
                    notification.title(),
                    notification.body(),
                    notification.data(),
                    java.time.ZoneOffset.UTC.getRules().getOffset(deliveryTime).getTotalSeconds() * 1000L
            );
            return;
        }

        List<PendingNotification> pending = pendingNotifications.computeIfAbsent(userId, k -> new ArrayList<>());
        pending.add(notification);

        // Check if we should send batched notification
        if (pending.size() >= MAX_BATCH_SIZE) {
            sendBatchedNotifications(userId);
        }
    }

    /**
     * Send notification immediately
     */
    private void sendNotification(String userId, PendingNotification notification) {
        NotificationPreferencesDTO prefs = getPreferences(userId);
        int currentHour = LocalTime.now().getHour();

        if (prefs.isInQuietHours(currentHour)) {
            // Queue for later
            queueNotification(userId, notification);
            return;
        }

        boolean success = notificationPort.sendNotification(
                userId,
                notification.title(),
                notification.body(),
                notification.data()
        );

        if (!success) {
            log.warn("Failed to send notification to user {}", userId);
        }
    }

    /**
     * Send batched notifications as a summary
     */
    public void sendBatchedNotifications(String userId) {
        List<PendingNotification> pending = pendingNotifications.remove(userId);
        if (pending == null || pending.isEmpty()) {
            return;
        }

        // Calculate total point delta
        BigDecimal totalDelta = pending.stream()
                .filter(n -> n.data().containsKey("points"))
                .map(n -> (BigDecimal) n.data().get("points"))
                .reduce(BigDecimal.ZERO, BigDecimal::add);

        String title = "Scoring Update";
        String body = String.format("%d scoring plays! +%.1f total pts", pending.size(), totalDelta);

        notificationPort.sendNotification(
                userId,
                title,
                body,
                Map.of(
                        "playCount", pending.size(),
                        "totalDelta", totalDelta
                )
        );

        log.debug("Sent batched notification to user {}: {} events", userId, pending.size());
    }

    /**
     * Flush all pending notifications (called periodically)
     */
    public void flushPendingNotifications() {
        for (String userId : pendingNotifications.keySet()) {
            sendBatchedNotifications(userId);
        }
    }

    /**
     * Get or load notification preferences for a user
     */
    public NotificationPreferencesDTO getPreferences(String userId) {
        return preferencesCache.computeIfAbsent(userId, k -> {
            // TODO: Load from repository
            NotificationPreferencesDTO defaults = new NotificationPreferencesDTO();
            defaults.setUserId(userId);
            return defaults;
        });
    }

    /**
     * Update notification preferences
     */
    public void updatePreferences(String userId, NotificationPreferencesDTO preferences) {
        preferences.setUserId(userId);
        preferencesCache.put(userId, preferences);
        // TODO: Persist to repository
    }

    /**
     * Register a device for push notifications
     */
    public void registerDevice(String userId, String deviceToken, String platform) {
        notificationPort.registerDevice(userId, deviceToken, platform);
        log.info("Registered device for user {}: {}", userId, platform);
    }

    /**
     * Get user ID for a league player
     */
    private String getUserIdForLeaguePlayer(String leaguePlayerId) {
        // TODO: Look up user ID from league player repository
        return leaguePlayerId;
    }

    private String ordinal(int i) {
        String[] suffixes = new String[]{"th", "st", "nd", "rd", "th", "th", "th", "th", "th", "th"};
        return switch (i % 100) {
            case 11, 12, 13 -> i + "th";
            default -> i + suffixes[i % 10];
        };
    }

    private record PendingNotification(
            String title,
            String body,
            Map<String, Object> data,
            NotificationType type
    ) {}

    private enum NotificationType {
        MILESTONE, RANK_CHANGE, PLAYER_TD, GAME_COMPLETE, MATCHUP_LEAD
    }
}
