package com.ffl.playoffs.infrastructure.adapter.notification;

import com.ffl.playoffs.domain.port.PushNotificationPort;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Component;

import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;

/**
 * Infrastructure adapter for push notifications
 * Placeholder implementation - replace with actual push service (FCM, APNs, etc.)
 */
@Slf4j
@Component
@RequiredArgsConstructor
public class PushNotificationAdapter implements PushNotificationPort {

    // Store registered device tokens per user
    private final Map<String, Map<String, String>> userDevices = new ConcurrentHashMap<>();

    // Queue for delayed notifications
    private final Map<String, QueuedNotification> notificationQueue = new ConcurrentHashMap<>();

    @Override
    public boolean sendNotification(String userId, String title, String body, Map<String, Object> data) {
        log.info("Sending push notification to user {}: {} - {}", userId, title, body);

        Map<String, String> devices = userDevices.get(userId);
        if (devices == null || devices.isEmpty()) {
            log.debug("No registered devices for user {}", userId);
            return false;
        }

        // TODO: Implement actual push delivery using FCM/APNs
        // For now, just log the notification
        for (Map.Entry<String, String> device : devices.entrySet()) {
            log.debug("Would send to device {} ({}): {} - {}",
                    device.getKey(), device.getValue(), title, body);
        }

        return true;
    }

    @Override
    public Map<String, Boolean> sendBulkNotification(List<String> userIds, String title, String body, Map<String, Object> data) {
        Map<String, Boolean> results = new HashMap<>();

        for (String userId : userIds) {
            boolean success = sendNotification(userId, title, body, data);
            results.put(userId, success);
        }

        log.info("Sent bulk notification to {} users, {} successful",
                userIds.size(), results.values().stream().filter(v -> v).count());

        return results;
    }

    @Override
    public String queueNotification(String userId, String title, String body, Map<String, Object> data, long deliveryTime) {
        String jobId = userId + "-" + System.currentTimeMillis();

        QueuedNotification notification = new QueuedNotification(
                jobId, userId, title, body, data, deliveryTime
        );
        notificationQueue.put(jobId, notification);

        log.info("Queued notification {} for user {} at {}",
                jobId, userId, deliveryTime);

        return jobId;
    }

    @Override
    public void registerDevice(String userId, String deviceToken, String platform) {
        userDevices.computeIfAbsent(userId, k -> new ConcurrentHashMap<>())
                .put(deviceToken, platform);

        log.info("Registered device for user {}: {} ({})", userId, deviceToken, platform);
    }

    @Override
    public void removeDevice(String userId, String deviceToken) {
        Map<String, String> devices = userDevices.get(userId);
        if (devices != null) {
            devices.remove(deviceToken);
            log.info("Removed device {} for user {}", deviceToken, userId);
        }
    }

    @Override
    public boolean hasRegisteredDevices(String userId) {
        Map<String, String> devices = userDevices.get(userId);
        return devices != null && !devices.isEmpty();
    }

    /**
     * Process queued notifications (called by scheduler)
     */
    public void processQueue() {
        long now = System.currentTimeMillis();

        notificationQueue.entrySet().removeIf(entry -> {
            QueuedNotification notification = entry.getValue();
            if (notification.deliveryTime() <= now) {
                sendNotification(
                        notification.userId(),
                        notification.title(),
                        notification.body(),
                        notification.data()
                );
                return true;
            }
            return false;
        });
    }

    private record QueuedNotification(
            String jobId,
            String userId,
            String title,
            String body,
            Map<String, Object> data,
            long deliveryTime
    ) {}
}
