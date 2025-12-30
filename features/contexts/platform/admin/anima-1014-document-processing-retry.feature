@ANIMA-1014
Feature: Document Processing Retry
  As a world creator
  I want to retry failed document processing
  So that I can recover from temporary failures without re-uploading
Background:
    Given I am authenticated as a valid user
    And I have an active world named "Story World"
    And the document processing service is available
===========================================
  # CORE RETRY SCENARIOS
  # ===========================================
@retry @text-extraction
  Scenario: Retry a document that failed during text extraction
    Given document "chapter1.pdf" has status "FAILED"
    And the failure occurred during "TEXT_EXTRACTION" stage
    And the failure reason is "OCR service timeout"
    When I request to retry processing for "chapter1.pdf"
    Then the document status should change to "PENDING"
    And all previous extraction data should be cleared
    And the document should be re-queued for processing
    And a DocumentRetryInitiatedEvent should be published
    And text extraction should start from the beginning
@retry @entity-extraction
  Scenario: Retry a document that failed during entity extraction
    Given document "worldmap.docx" has status "FAILED"
    And the failure occurred during "ENTITY_EXTRACTION" stage
    And text extraction was previously successful
    When I request to retry processing for "worldmap.docx"
    Then the document status should change to "PENDING"
    And extracted text should be preserved
    And entity extraction should restart
    And a DocumentRetryInitiatedEvent should be published
@retry @embedding
  Scenario: Retry a document that failed during embedding generation
    Given document "lore.txt" has status "FAILED"
    And the failure occurred during "EMBEDDING_GENERATION" stage
    When I request to retry processing for "lore.txt"
    Then the document status should change to "PENDING"
    And previously extracted entities should be preserved
    And embedding generation should restart
    And the retry should use the latest embedding model
===========================================
  # VALIDATION SCENARIOS
  # ===========================================
@validation @processing-state
  Scenario: Cannot retry a document in processing state
    Given document "active.pdf" has status "PROCESSING"
    When I request to retry processing for "active.pdf"
    Then the request should be rejected with status code 409
    And the error message should indicate "Document is currently being processed"
    And the document status should remain "PROCESSING"
@validation @completed
  Scenario: Cannot retry a completed document
    Given document "finished.pdf" has status "COMPLETED"
    When I request to retry processing for "finished.pdf"
    Then the request should be rejected with status code 400
    And the error message should indicate "Cannot retry a successfully completed document"
    And the document status should remain "COMPLETED"
    And I should be offered the option to reprocess instead
@validation @cancelled
  Scenario: Cannot retry a cancelled document
    Given document "abandoned.pdf" has status "CANCELLED"
    When I request to retry processing for "abandoned.pdf"
    Then the request should be rejected with status code 400
    And the error message should indicate "Cannot retry a cancelled document"
    And I should be offered the option to re-upload
@validation @not-found
  Scenario: Cannot retry a non-existent document
    Given document with ID "non-existent-doc-123" does not exist
    When I request to retry processing for document ID "non-existent-doc-123"
    Then the request should be rejected with status code 404
    And the error message should indicate "Document not found"
@validation @authorization
  Scenario: Cannot retry another user's document
    Given document "other-user-doc.pdf" belongs to user "other@example.com"
    And I am authenticated as "me@example.com"
    When I request to retry processing for "other-user-doc.pdf"
    Then the request should be rejected with status code 403
    And the error message should indicate "Access denied"
    And no retry event should be published
@validation @world-deleted
  Scenario: Cannot retry document when parent world is deleted
    Given document "orphan.pdf" has status "FAILED"
    And the parent world "Story World" has been deleted
    When I request to retry processing for "orphan.pdf"
    Then the request should be rejected with status code 400
    And the error message should indicate "Parent world no longer exists"
    And the document should be flagged for cleanup
===========================================
  # RETRY LIMITS
  # ===========================================
@limits @max-attempts
  Scenario: Maximum retry attempts reached
    Given document "problematic.pdf" has status "FAILED"
    And the document has been retried 3 times
    And the maximum retry limit is 3
    When I request to retry processing for "problematic.pdf"
    Then the request should be rejected with status code 400
    And the error message should indicate "Maximum retry attempts (3) exceeded"
    And I should be offered the option to force retry with admin approval
    And a MaxRetryAttemptsReachedEvent should be published
@limits @override
  Scenario: Administrator can override retry limit
    Given document "critical.pdf" has status "FAILED"
    And the document has exceeded the maximum retry limit
    And I have administrator privileges
    When I request a force retry for "critical.pdf"
    Then the retry should be allowed
    And the force retry should be logged for audit
    And a ForcedRetryEvent should be published
===========================================
  # CLEANUP AND STATE MANAGEMENT
  # ===========================================
@cleanup @failure-types
  Scenario Outline: Retry with cleanup of different failure types
    Given document "test.pdf" has status "FAILED"
    And the failure occurred during "<stage>" stage
    When I request to retry processing
    Then "<cleanup_action>" should be performed
    And processing should restart from "<restart_point>"
Examples:
      | stage                | cleanup_action           | restart_point        |
      | VALIDATION           | clear validation results | VALIDATION           |
      | TEXT_EXTRACTION      | clear extracted text     | TEXT_EXTRACTION      |
      | ENTITY_EXTRACTION    | clear entity data        | ENTITY_EXTRACTION    |
      | EMBEDDING_GENERATION | clear embeddings         | EMBEDDING_GENERATION |
      | VECTOR_STORAGE       | remove partial vectors   | VECTOR_STORAGE       |
@audit @trail
  Scenario: Track retry audit trail
    Given document "tracked.pdf" has been retried multiple times
    When I view the retry history for "tracked.pdf"
    Then I should see a complete audit trail including:
      | field             | displayed |
      | retry_number      | yes       |
      | timestamp         | yes       |
      | initiated_by      | yes       |
      | failure_reason    | yes       |
      | cleanup_performed | yes       |
      | outcome           | yes       |
    And each retry attempt should be individually viewable
@state @reset
  Scenario: Retry resets document to initial state
    Given document "reset-test.pdf" has status "FAILED"
    And the document has partial processing data
    When I request to retry processing
    Then the document status should change to "PENDING"
    And processing_started_at should be cleared
    And processing_completed_at should be cleared
    And error_message should be cleared
    And error_code should be cleared
    And the original upload metadata should be preserved
@workflow @clear
  Scenario: Retry clears workflow information
    Given document "workflow-test.pdf" has status "FAILED"
    And the document has workflow_id "wf-12345"
    And the document has workflow_run_id "run-67890"
    When I request to retry processing
    Then workflow_id should be cleared
    And workflow_run_id should be cleared
    And a new workflow should be created upon processing
    And the old workflow should be marked as superseded
===========================================
  # COUNTER MANAGEMENT
  # ===========================================
@counter @increment
  Scenario: Retry increments attempt counter correctly
    Given document "counter-test.pdf" has status "FAILED"
    And the document has attempt_count of 1
    When I request to retry processing
    Then the attempt_count should be incremented to 2
    And the retry should be logged with attempt number
    And remaining attempts should be calculated correctly
@counter @first-attempt
  Scenario: First retry from initial failure
    Given document "first-retry.pdf" has status "FAILED"
    And the document has never been retried
    And attempt_count is 1
    When I request to retry processing
    Then attempt_count should become 2
    And retry_count should become 1
    And the document should show "1 of 3 retries used"
===========================================
  # EVENT PROCESSING
  # ===========================================
@events @workflow-trigger
  Scenario: Event processing triggers new workflow
    Given document "event-test.pdf" has status "FAILED"
    When I request to retry processing
    And a DocumentRetryInitiatedEvent is published
    Then the event processor should receive the event
    And a new processing workflow should be started
    And the workflow should process from the appropriate stage
    And workflow status should be trackable
===========================================
  # CONCURRENCY HANDLING
  # ===========================================
@concurrency @duplicate-requests
  Scenario: Concurrent retry requests are handled safely
    Given document "concurrent.pdf" has status "FAILED"
    When two retry requests are submitted simultaneously
    Then only one retry should be processed
    And the second request should receive status code 409
    And the error should indicate "Retry already in progress"
    And no duplicate workflows should be created
@concurrency @race-condition
  Scenario: Handle race condition between retry and status change
    Given document "race.pdf" has status "FAILED"
    When a retry request is submitted
    And the document status changes to "PROCESSING" before retry completes
    Then the retry should be cancelled
    And an appropriate error should be returned
    And system state should remain consistent
@concurrency @idempotency
  Scenario: Idempotent retry request handling
    Given document "idempotent.pdf" has status "FAILED"
    And I submit a retry request with idempotency key "retry-key-12345"
    And the retry is successfully initiated
    When I submit the same retry request with idempotency key "retry-key-12345"
    Then the response should match the original retry response
    And no additional retry should be created
    And attempt_count should not be incremented again
===========================================
  # CLEANUP VERIFICATION
  # ===========================================
@cleanup @verification
  Scenario: Retry with automatic cleanup verification
    Given document "cleanup-verify.pdf" has status "FAILED"
    And the document has data in vector store
    When I request to retry processing
    Then the system should verify cleanup completion
    And vector store entries should be removed
    And cleanup should be confirmed before restart
    And a CleanupCompletedEvent should be published
@cleanup @failure
  Scenario: Handle cleanup failure during retry
    Given document "cleanup-fail.pdf" has status "FAILED"
    And cleanup of previous data fails
    When I request to retry processing
    Then the retry should be aborted
    And an error should indicate cleanup failure
    And the document should remain in FAILED state
    And manual intervention should be flagged
===========================================
  # API ENDPOINTS
  # ===========================================
@api @endpoint
  Scenario: API endpoint for document retry
    Given document "api-test.pdf" has status "FAILED"
    When I send a POST request to "/api/v1/documents/{documentId}/retry"
    Then I should receive status code 202 Accepted
    And the response should include:
      | field          | value               |
      | document_id    | the document ID     |
      | retry_number   | incremented count   |
      | status         | PENDING             |
      | estimated_time | processing estimate |
    And the Location header should point to status endpoint
@api @with-reason
  Scenario: API endpoint accepts retry reason
    Given document "documented.pdf" has status "FAILED"
    When I send a POST request to "/api/v1/documents/{documentId}/retry" with body:
      | field    | value                           |
      | reason   | Retrying after service recovery |
      | priority | HIGH                            |
    Then the retry should be initiated
    And the reason should be recorded in audit log
    And priority should affect queue position
@api @timeout
  Scenario: Handle retry request timeout
    Given document "timeout-test.pdf" has status "FAILED"
    And the retry initiation takes longer than the request timeout
    When I send a POST request to "/api/v1/documents/{documentId}/retry"
    Then I should receive status code 202 Accepted
    And the retry should continue processing asynchronously
    And I should be able to poll the status endpoint for updates
@optional @reason
  Scenario: Retry reason is optional
    Given document "no-reason.pdf" has status "FAILED"
    When I request to retry without providing a reason
    Then the retry should proceed successfully
    And the audit log should record "No reason provided"
    And all other retry behaviors should work normally
===========================================
  # METADATA PRESERVATION
  # ===========================================
@metadata @preservation
  Scenario: Retry preserves document metadata
    Given document "metadata-test.pdf" has status "FAILED"
    And the document has the following metadata:
      | field         | value                |
      | original_name | my-document.pdf      |
      | file_size     | 1048576              |
      | mime_type     | application/pdf      |
      | uploaded_by   | user@example.com     |
      | uploaded_at   | 2024-01-15T10:00:00Z |
      | world_id      | world-123            |
      | tags          | lore, characters     |
    When I request to retry processing
    Then all original metadata should be preserved
    And no metadata should be modified
    And tags and associations should remain intact
===========================================
  # BATCH OPERATIONS
  # ===========================================
@batch @retry
  Scenario: Batch retry multiple failed documents
    Given the following documents have status "FAILED":
      | document_name |
      | doc1.pdf      |
      | doc2.pdf      |
      | doc3.pdf      |
    When I request batch retry for all failed documents
    Then all documents should be queued for retry
    And each should receive its own retry event
    And batch progress should be trackable
    And a BatchRetryInitiatedEvent should be published
@batch @partial-failure
  Scenario: Batch retry with some ineligible documents
    Given the following documents exist:
      | document_name | status     | retry_count |
      | eligible.pdf  | FAILED     | 1           |
      | maxed.pdf     | FAILED     | 3           |
      | active.pdf    | PROCESSING | 0           |
    When I request batch retry for all documents
    Then only "eligible.pdf" should be retried
    And the response should indicate partial success
    And reasons for skipped documents should be provided
@batch @limit
  Scenario: Batch retry respects maximum batch size
    Given 100 documents have status "FAILED"
    And the maximum batch size is 50
    When I request batch retry for all failed documents
    Then only the first 50 documents should be queued
    And the response should indicate more documents are pending
    And I should be provided a continuation token for remaining documents
===========================================
  # NOTIFICATIONS
  # ===========================================
@notification @user
  Scenario: User is notified of retry outcome
    Given document "notify-test.pdf" has status "FAILED"
    And I have enabled notifications
    When I request to retry processing
    And the retry completes successfully
    Then I should receive a success notification
    And the notification should include processing summary
@notification @failure
  Scenario: User is notified of retry failure
    Given document "notify-fail.pdf" has status "FAILED"
    And I have enabled notifications
    When I request to retry processing
    And the retry fails again
    Then I should receive a failure notification
    And the notification should include the new error
    And remaining retry attempts should be shown
===========================================
  # ERROR HANDLING AND EDGE CASES
  # ===========================================
@error-handling @service-unavailable
  Scenario: Handle retry when processing service unavailable
    Given document "service-down.pdf" has status "FAILED"
    And the processing service is temporarily unavailable
    When I request to retry processing
    Then the retry request should be queued
    And I should receive status code 202 with delayed processing
    And the retry should execute when service recovers
@edge-case @deleted-file
  Scenario: Handle retry when source file is missing
    Given document "missing.pdf" has status "FAILED"
    And the source file has been deleted from storage
    When I request to retry processing
    Then the retry should fail with status code 404
    And the error should indicate "Source file not found"
    And the document should be marked for manual review
@edge-case @corrupted-file
  Scenario: Handle retry when source file is corrupted
    Given document "corrupted.pdf" has status "FAILED"
    And the source file has become corrupted in storage
    When I request to retry processing
    Then text extraction should fail with validation error
    And the error should indicate "File integrity check failed"
    And the document should be marked as "PERMANENTLY_FAILED"
    And the user should be notified to re-upload
@edge-case @storage-quota
  Scenario: Handle retry when storage quota is exceeded
    Given document "quota-test.pdf" has status "FAILED"
    And the user's storage quota has been exceeded
    When I request to retry processing
    Then the retry should fail with status code 507
    And the error should indicate "Storage quota exceeded"
    And the user should be prompted to free up space or upgrade
@priority @queue
  Scenario: Priority affects retry queue position
    Given the following documents have status "FAILED":
      | document_name | priority |
      | low.pdf       | LOW      |
      | high.pdf      | HIGH     |
      | normal.pdf    | NORMAL   |
    When all documents are queued for retry at the same time
    Then "high.pdf" should be processed first
    And "normal.pdf" should be processed second
    And "low.pdf" should be processed last