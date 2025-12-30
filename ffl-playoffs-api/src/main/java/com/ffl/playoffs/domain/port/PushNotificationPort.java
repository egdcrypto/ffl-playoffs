package com.ffl.playoffs.domain.port;

import java.util.List;
import java.util.Map;

/**
 * Port for sending push notifications to users
 * Infrastructure adapter will implement actual push delivery
 */
public interface PushNotificationPort {

    /**
     * Send a push notification to a specific user
     * @param userId the user ID
     * @param title the notification title
     * @param body the notification body text
     * @param data additional data payload
     * @return true if notification was queued successfully
     */
    boolean sendNotification(String userId, String title, String body, Map<String, Object> data);

    /**
     * Send notifications to multiple users
     * @param userIds the list of user IDs
     * @param title the notification title
     * @param body the notification body text
     * @param data additional data payload
     * @return map of userId to success status
     */
    Map<String, Boolean> sendBulkNotification(List<String> userIds, String title, String body, Map<String, Object> data);

    /**
     * Queue a notification for delayed delivery (e.g., quiet hours)
     * @param userId the user ID
     * @param title the notification title
     * @param body the notification body text
     * @param data additional data payload
     * @param deliveryTime when to deliver (epoch millis)
     * @return the queue job ID
     */
    String queueNotification(String userId, String title, String body, Map<String, Object> data, long deliveryTime);

    /**
     * Register a device token for a user
     * @param userId the user ID
     * @param deviceToken the device push token
     * @param platform the platform (ios, android, web)
     */
    void registerDevice(String userId, String deviceToken, String platform);

    /**
     * Remove an invalid device token
     * @param userId the user ID
     * @param deviceToken the invalid token to remove
     */
    void removeDevice(String userId, String deviceToken);

    /**
     * Check if user has any registered devices
     * @param userId the user ID
     * @return true if user has registered devices
     */
    boolean hasRegisteredDevices(String userId);
}
