package com.ffl.playoffs.domain.aggregate;

import com.ffl.playoffs.domain.model.TestCaseStatus;

import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;
import java.util.Objects;
import java.util.UUID;

/**
 * Test suite aggregate root
 * Represents a collection of conversation test cases that can be executed together
 */
public class TestSuite {
    private UUID id;
    private String name;
    private String description;
    private UUID characterId;
    private List<TestCase> testCases;
    private String schedule;
    private boolean notifyOnFailure;
    private List<String> notificationEmails;
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;
    private LocalDateTime lastRunAt;
    private UUID createdBy;

    public TestSuite() {
        this.id = UUID.randomUUID();
        this.testCases = new ArrayList<>();
        this.notificationEmails = new ArrayList<>();
        this.notifyOnFailure = true;
        this.createdAt = LocalDateTime.now();
        this.updatedAt = LocalDateTime.now();
    }

    public TestSuite(String name, UUID characterId) {
        this();
        this.name = name;
        this.characterId = characterId;
    }

    /**
     * Adds a test case to the suite
     * @param testCase the test case to add
     */
    public void addTestCase(TestCase testCase) {
        Objects.requireNonNull(testCase, "Test case cannot be null");
        this.testCases.add(testCase);
        this.updatedAt = LocalDateTime.now();
    }

    /**
     * Removes a test case from the suite
     * @param testCaseId the test case id to remove
     * @return true if removed
     */
    public boolean removeTestCase(UUID testCaseId) {
        boolean removed = this.testCases.removeIf(tc -> tc.getId().equals(testCaseId));
        if (removed) {
            this.updatedAt = LocalDateTime.now();
        }
        return removed;
    }

    /**
     * Sets the execution schedule (cron expression)
     * @param cronExpression cron schedule
     */
    public void setSchedule(String cronExpression) {
        this.schedule = cronExpression;
        this.updatedAt = LocalDateTime.now();
    }

    /**
     * Adds a notification email
     * @param email the email to notify on failure
     */
    public void addNotificationEmail(String email) {
        if (email != null && !email.isBlank() && !this.notificationEmails.contains(email)) {
            this.notificationEmails.add(email);
            this.updatedAt = LocalDateTime.now();
        }
    }

    /**
     * Records that the suite was executed
     */
    public void recordExecution() {
        this.lastRunAt = LocalDateTime.now();
    }

    /**
     * Gets the total number of test cases
     * @return test case count
     */
    public int getTestCaseCount() {
        return this.testCases.size();
    }

    /**
     * Checks if the suite is scheduled
     * @return true if has a schedule
     */
    public boolean isScheduled() {
        return this.schedule != null && !this.schedule.isBlank();
    }

    // Getters and Setters

    public UUID getId() {
        return id;
    }

    public void setId(UUID id) {
        this.id = id;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public UUID getCharacterId() {
        return characterId;
    }

    public void setCharacterId(UUID characterId) {
        this.characterId = characterId;
    }

    public List<TestCase> getTestCases() {
        return new ArrayList<>(testCases);
    }

    public void setTestCases(List<TestCase> testCases) {
        this.testCases = testCases != null ? new ArrayList<>(testCases) : new ArrayList<>();
    }

    public String getSchedule() {
        return schedule;
    }

    public boolean isNotifyOnFailure() {
        return notifyOnFailure;
    }

    public void setNotifyOnFailure(boolean notifyOnFailure) {
        this.notifyOnFailure = notifyOnFailure;
    }

    public List<String> getNotificationEmails() {
        return new ArrayList<>(notificationEmails);
    }

    public void setNotificationEmails(List<String> notificationEmails) {
        this.notificationEmails = notificationEmails != null ? new ArrayList<>(notificationEmails) : new ArrayList<>();
    }

    public LocalDateTime getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(LocalDateTime createdAt) {
        this.createdAt = createdAt;
    }

    public LocalDateTime getUpdatedAt() {
        return updatedAt;
    }

    public void setUpdatedAt(LocalDateTime updatedAt) {
        this.updatedAt = updatedAt;
    }

    public LocalDateTime getLastRunAt() {
        return lastRunAt;
    }

    public void setLastRunAt(LocalDateTime lastRunAt) {
        this.lastRunAt = lastRunAt;
    }

    public UUID getCreatedBy() {
        return createdBy;
    }

    public void setCreatedBy(UUID createdBy) {
        this.createdBy = createdBy;
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;
        TestSuite testSuite = (TestSuite) o;
        return Objects.equals(id, testSuite.id);
    }

    @Override
    public int hashCode() {
        return Objects.hash(id);
    }

    /**
     * Inner class representing a single test case within a suite
     */
    public static class TestCase {
        private UUID id;
        private String name;
        private UUID conversationId;
        private String expectedBehavior;
        private TestCaseStatus status;
        private String actualResult;
        private String failureReason;

        public TestCase() {
            this.id = UUID.randomUUID();
            this.status = TestCaseStatus.PENDING;
        }

        public TestCase(String name, UUID conversationId, String expectedBehavior) {
            this();
            this.name = name;
            this.conversationId = conversationId;
            this.expectedBehavior = expectedBehavior;
        }

        public void markPassed(String result) {
            this.status = TestCaseStatus.PASSED;
            this.actualResult = result;
            this.failureReason = null;
        }

        public void markFailed(String result, String reason) {
            this.status = TestCaseStatus.FAILED;
            this.actualResult = result;
            this.failureReason = reason;
        }

        public void markSkipped(String reason) {
            this.status = TestCaseStatus.SKIPPED;
            this.failureReason = reason;
        }

        public void markError(String error) {
            this.status = TestCaseStatus.ERROR;
            this.failureReason = error;
        }

        public void reset() {
            this.status = TestCaseStatus.PENDING;
            this.actualResult = null;
            this.failureReason = null;
        }

        public boolean isPassed() {
            return this.status == TestCaseStatus.PASSED;
        }

        // Getters and Setters
        public UUID getId() { return id; }
        public void setId(UUID id) { this.id = id; }
        public String getName() { return name; }
        public void setName(String name) { this.name = name; }
        public UUID getConversationId() { return conversationId; }
        public void setConversationId(UUID conversationId) { this.conversationId = conversationId; }
        public String getExpectedBehavior() { return expectedBehavior; }
        public void setExpectedBehavior(String expectedBehavior) { this.expectedBehavior = expectedBehavior; }
        public TestCaseStatus getStatus() { return status; }
        public void setStatus(TestCaseStatus status) { this.status = status; }
        public String getActualResult() { return actualResult; }
        public void setActualResult(String actualResult) { this.actualResult = actualResult; }
        public String getFailureReason() { return failureReason; }
        public void setFailureReason(String failureReason) { this.failureReason = failureReason; }
    }
}
