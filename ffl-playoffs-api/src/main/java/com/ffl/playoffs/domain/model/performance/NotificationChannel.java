package com.ffl.playoffs.domain.model.performance;

import lombok.Getter;
import lombok.RequiredArgsConstructor;

/**
 * Channels through which alert notifications can be sent.
 */
@Getter
@RequiredArgsConstructor
public enum NotificationChannel {
    EMAIL("email", "Email"),
    SLACK("slack", "Slack"),
    PAGERDUTY("pagerduty", "PagerDuty"),
    WEBHOOK("webhook", "Webhook"),
    SMS("sms", "SMS");

    private final String code;
    private final String displayName;

    public static NotificationChannel fromCode(String code) {
        for (NotificationChannel channel : values()) {
            if (channel.code.equals(code)) {
                return channel;
            }
        }
        throw new IllegalArgumentException("Unknown notification channel code: " + code);
    }
}
