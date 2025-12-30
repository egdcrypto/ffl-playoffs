@copyright @content-moderation @legal-compliance @intellectual-property
Feature: Copyright Material Detection
  As a platform operator
  I want to detect and handle copyrighted material
  So that I can ensure legal compliance and protect intellectual property rights

  Background:
    Given I am authenticated as a user with ADMIN role
    And the copyright detection service is enabled
    And the system has a database of known copyrighted works
    And detection thresholds are configured to default values

  # ==========================================
  # Detect Copyrighted Content During Document Upload
  # ==========================================

  @upload @detection
  Scenario: Detect copyrighted content during document upload
    Given a document contains text from a copyrighted book "The Lord of the Rings"
    When the document is uploaded to the platform
    Then the copyright detection service should analyze the content
    And a copyright match should be identified
    And the document should be flagged for review
    And the match details should include:
      | field           | value                                |
      | source_work     | The Lord of the Rings                |
      | author          | J.R.R. Tolkien                       |
      | copyright_owner | Tolkien Estate                       |
      | match_percentage| 85%                                  |

  @upload @blocking
  Scenario: Block upload of heavily copyrighted content
    Given copyright policy is set to "strict"
    And a document contains 80% copyrighted content
    When the document upload is attempted
    Then the upload should be blocked
    And user should receive error "Document contains excessive copyrighted material"
    And the blocked attempt should be logged for audit

  @upload @async
  Scenario: Asynchronous copyright check for large documents
    Given a large document of 500 pages is being uploaded
    When the upload is initiated
    Then the upload should complete immediately
    And copyright checking should proceed asynchronously
    And document status should show "Copyright check in progress"
    And user should be notified when check completes

  @upload @batch
  Scenario: Batch copyright check for multiple documents
    Given 10 documents are uploaded simultaneously
    When batch copyright analysis is triggered
    Then all 10 documents should be queued for analysis
    And analysis should process in parallel where possible
    And batch status should show progress
    And summary report should be generated on completion

  @upload @metadata
  Scenario: Extract and verify copyright metadata
    Given a document has embedded copyright metadata
    When the document is uploaded
    Then metadata should be extracted:
      | metadata_field  | value                    |
      | copyright_year  | 2020                     |
      | license_type    | All Rights Reserved      |
      | author          | Jane Smith               |
    And metadata should be stored with document
    And metadata should be used in copyright assessment

  # ==========================================
  # Detect Substantial Portions of Copyrighted Work
  # ==========================================

  @substantial @threshold
  Scenario: Detect substantial portion exceeding threshold
    Given copyright threshold for substantial portion is 10%
    And a document contains 15% text from "Harry Potter"
    When copyright analysis runs
    Then a substantial portion violation should be flagged
    And the match should be marked as "substantial"
    And specific matched sections should be highlighted

  @substantial @consecutive
  Scenario: Detect consecutive text matching copyrighted work
    Given a document contains 500 consecutive words from a copyrighted novel
    When copyright analysis runs
    Then the consecutive match should be flagged
    And match type should be "consecutive_block"
    And start and end positions should be recorded

  @substantial @distributed
  Scenario: Detect distributed matches across document
    Given a document has copyrighted text distributed in multiple sections:
      | section | matched_words | source_work        |
      | intro   | 150           | Copyrighted Book A |
      | middle  | 200           | Copyrighted Book A |
      | end     | 175           | Copyrighted Book A |
    When copyright analysis runs
    Then total distributed match should be calculated as 525 words
    And aggregated match should trigger substantial portion flag

  @substantial @paraphrase
  Scenario: Detect paraphrased copyrighted content
    Given a document contains paraphrased versions of copyrighted text
    And paraphrase detection is enabled
    When copyright analysis runs with semantic matching
    Then paraphrased content should be identified
    And similarity score should be calculated
    And flagging should occur if similarity exceeds 70%

  @substantial @translation
  Scenario: Detect translated copyrighted content
    Given a document contains English translation of French copyrighted work
    And cross-language detection is enabled
    When copyright analysis runs
    Then translated content should be matched to original
    And translation match should be flagged
    And original language work should be identified

  # ==========================================
  # Allow Limited Quotations Under Fair Use
  # ==========================================

  @fair-use @quotation
  Scenario: Allow short quotations with attribution
    Given fair use quotation limit is 300 words
    And a document contains a 200 word quote from a copyrighted work
    And the quote is properly attributed
    When copyright analysis runs
    Then the quotation should be identified
    And it should be marked as "fair_use_permitted"
    And no violation should be flagged

  @fair-use @academic
  Scenario: Allow academic fair use for criticism
    Given document is marked as academic content type
    And it contains copyrighted excerpts for critical analysis
    And excerpts are used for commentary purpose
    When copyright analysis runs
    Then academic fair use should be recognized
    And content should be permitted with fair use notation
    And usage purpose should be logged as "criticism"

  @fair-use @educational
  Scenario: Allow educational fair use
    Given user account is marked as educational institution
    And document is for classroom use
    And copyrighted content is within educational guidelines:
      | content_type | max_allowed          |
      | prose        | 1000 words or 10%    |
      | poetry       | 250 words            |
      | music        | 30 seconds           |
      | images       | 5 per work           |
    When copyright analysis runs
    Then educational fair use should apply
    And content within limits should be permitted

  @fair-use @parody
  Scenario: Recognize parody as fair use
    Given document is marked as parody content
    And it contains recognizable elements from copyrighted work
    And transformative nature is evident
    When copyright analysis runs
    Then parody fair use should be evaluated
    And if transformative, should be permitted
    And parody classification should be logged

  @fair-use @news
  Scenario: Allow fair use for news reporting
    Given document is news article type
    And it quotes copyrighted material for reporting purposes
    And quotes are limited and attributed
    When copyright analysis runs
    Then news reporting fair use should apply
    And limited quotations should be permitted
    And reporting context should be documented

  @fair-use @exceeded
  Scenario: Flag when fair use limits are exceeded
    Given fair use quotation limit is 300 words
    And a document contains a 500 word quote from copyrighted work
    When copyright analysis runs
    Then fair use limit exceedance should be flagged
    And excess amount should be calculated as 200 words
    And remediation options should be suggested

  # ==========================================
  # Allow Public Domain Content
  # ==========================================

  @public-domain @recognition
  Scenario: Recognize public domain works
    Given the public domain database contains:
      | work                    | author           | pd_date    |
      | Pride and Prejudice     | Jane Austen      | 1817       |
      | The Odyssey             | Homer            | ancient    |
      | Frankenstein            | Mary Shelley     | 1818       |
    When a document containing text from "Pride and Prejudice" is analyzed
    Then the work should be identified as public domain
    And no copyright violation should be flagged
    And source should be noted for attribution purposes

  @public-domain @expired
  Scenario: Identify works with expired copyright
    Given copyright expiration rules:
      | jurisdiction | rule                           |
      | US           | life + 70 years                |
      | EU           | life + 70 years                |
      | Canada       | life + 50 years                |
    And a work's author died in 1940
    When copyright status is evaluated for US jurisdiction
    Then copyright should be calculated as expired (1940 + 70 = 2010)
    And work should be treated as public domain

  @public-domain @government
  Scenario: Recognize government works as public domain
    Given a document contains US government publication text
    And government works database is populated
    When copyright analysis runs
    Then government work should be identified
    And it should be marked as public domain
    And source agency should be noted

  @public-domain @creative-commons
  Scenario: Handle Creative Commons licensed content
    Given a document contains Creative Commons licensed content
    And the license type is "CC BY 4.0"
    When copyright analysis runs
    Then the license should be recognized
    And usage should be permitted per license terms
    And attribution requirements should be noted:
      | requirement    | value                    |
      | attribution    | required                 |
      | commercial_use | permitted                |
      | derivatives    | permitted                |

  @public-domain @dedication
  Scenario: Recognize public domain dedication
    Given content has explicit public domain dedication (CC0)
    When copyright analysis runs
    Then CC0 dedication should be recognized
    And content should be treated as public domain
    And no restrictions should apply

  # ==========================================
  # Process Original Content Without Copyright Checks
  # ==========================================

  @original @verification
  Scenario: Verify and process original content
    Given a document is authored by the uploading user
    And user declares content as original work
    When copyright analysis runs
    Then no matches to known works should be found
    And content should be marked as "original"
    And processing should proceed without restrictions

  @original @attestation
  Scenario: Process content with originality attestation
    Given user provides originality attestation
    And attestation includes:
      | field           | value                    |
      | declaration     | I am the original author |
      | date            | 2024-01-15               |
      | signature       | digital_signature_hash   |
    When document is uploaded with attestation
    Then attestation should be recorded
    And expedited processing should be enabled
    And attestation should be verifiable

  @original @self-published
  Scenario: Handle self-published works
    Given user uploads their own published work
    And they provide proof of authorship:
      | proof_type        | document              |
      | publication_link  | amazon.com/book/123   |
      | isbn              | 978-0-123456-78-9     |
      | author_bio_match  | verified              |
    When copyright analysis runs
    Then self-publishing should be verified
    And user should be recognized as copyright holder
    And full usage rights should be granted

  @original @false-claim
  Scenario: Detect false originality claims
    Given user claims content as original
    But content matches known copyrighted work at 95%
    When copyright analysis runs
    Then false claim should be detected
    And user should be flagged for policy violation
    And content should be blocked
    And incident should be escalated for review

  # ==========================================
  # Handle Documents with Mixed Original and Copyrighted Content
  # ==========================================

  @mixed @identification
  Scenario: Identify mixed content sections
    Given a document contains both original and copyrighted content
    When copyright analysis runs
    Then content should be segmented:
      | section      | type        | percentage |
      | pages 1-10   | original    | 100%       |
      | pages 11-15  | copyrighted | 85%        |
      | pages 16-30  | original    | 95%        |
      | pages 31-35  | copyrighted | 70%        |
    And each section should be analyzed separately
    And detailed breakdown should be provided

  @mixed @redaction
  Scenario: Offer redaction of copyrighted portions
    Given document has copyrighted sections identified
    When user is presented with options
    Then redaction option should be available
    And user can select sections to redact
    And redacted document should be re-analyzed
    And clean version should be processable

  @mixed @replacement
  Scenario: Suggest replacement for copyrighted content
    Given copyrighted quotation is detected
    When replacement suggestions are requested
    Then alternative public domain quotes should be suggested
    And paraphrase suggestions should be provided
    And user can apply replacements

  @mixed @partial-approval
  Scenario: Partially approve mixed content document
    Given a document with:
      | content_type | word_count | status      |
      | original     | 8000       | approved    |
      | fair_use     | 500        | approved    |
      | copyrighted  | 1500       | blocked     |
    When partial approval is processed
    Then approved sections should be extractable
    And blocked sections should be marked
    And document should proceed with partial content

  @mixed @annotation
  Scenario: Annotate document with copyright findings
    Given copyright analysis has completed on mixed document
    When annotation is generated
    Then document should have inline markers for:
      | marker_type      | count |
      | copyright_match  | 5     |
      | fair_use         | 3     |
      | public_domain    | 2     |
      | original         | 15    |
    And annotations should be exportable

  # ==========================================
  # Integrate with External Copyright Detection API
  # ==========================================

  @external-api @integration
  Scenario: Integrate with external copyright detection service
    Given external API "CopyrightChecker Pro" is configured
    And API credentials are valid
    When a document is submitted for analysis
    Then content should be sent to external API
    And response should be received within SLA
    And results should be merged with internal analysis

  @external-api @multiple
  Scenario: Use multiple external detection services
    Given multiple external APIs are configured:
      | api_name         | specialization       |
      | TextMatch API    | text content         |
      | ImageRights      | image content        |
      | AudioFingerprint | audio content        |
    When multimodal document is analyzed
    Then appropriate API should be used for each content type
    And results should be aggregated
    And confidence should be calculated across sources

  @external-api @fallback
  Scenario: Fallback when external API is unavailable
    Given primary external API is down
    And fallback API is configured
    When document analysis is requested
    Then system should switch to fallback API
    And analysis should complete successfully
    And API failure should be logged for monitoring

  @external-api @rate-limit
  Scenario: Handle external API rate limits
    Given external API has rate limit of 100 requests/minute
    And current request rate is approaching limit
    When multiple documents need analysis
    Then requests should be queued and throttled
    And rate limit should not be exceeded
    And queue status should be visible

  @external-api @caching
  Scenario: Cache external API results
    Given a document has been previously analyzed externally
    And cache TTL is 24 hours
    When the same document is re-analyzed within TTL
    Then cached results should be used
    And external API should not be called
    And cache hit should be logged

  @external-api @webhook
  Scenario: Receive results via webhook
    Given external API uses async webhook for results
    When document is submitted for analysis
    Then submission acknowledgment should be received
    And system should await webhook callback
    And on webhook receipt, results should be processed
    And document status should be updated

  # ==========================================
  # Notify Content Owners of Potential Violations
  # ==========================================

  @notification @owner
  Scenario: Notify copyright owner of detected violation
    Given a copyright violation is detected
    And copyright owner "Acme Publishing" is in the registry
    And owner has notification preferences configured
    When violation is confirmed
    Then notification should be sent to owner
    And notification should include:
      | field           | value                      |
      | violation_type  | substantial_copying        |
      | matched_work    | "The Great Novel"          |
      | match_percent   | 45%                        |
      | document_id     | doc-12345                  |
      | action_required | review_and_respond         |

  @notification @dmca
  Scenario: Generate DMCA takedown notice template
    Given a confirmed copyright violation exists
    When owner requests DMCA action
    Then DMCA notice template should be generated
    And template should include all required elements:
      | element                  |
      | identification_of_work   |
      | infringing_material      |
      | contact_information      |
      | good_faith_statement     |
      | accuracy_statement       |
      | signature                |

  @notification @uploader
  Scenario: Notify content uploader of violation
    Given copyright violation is detected in uploaded content
    When notification is triggered
    Then uploader should receive alert
    And alert should explain the violation
    And remediation options should be provided:
      | option          | description                    |
      | remove_content  | Delete the infringing material |
      | provide_license | Upload license documentation   |
      | dispute         | File counter-claim             |

  @notification @escalation
  Scenario: Escalate repeated violations
    Given user has 3 previous copyright violations
    And a new violation is detected
    When escalation rules are evaluated
    Then escalation should be triggered
    And legal team should be notified
    And user account should be flagged
    And additional restrictions should apply

  @notification @digest
  Scenario: Send daily violation digest to rights holders
    Given multiple violations detected for copyright owner
    When daily digest is generated
    Then single consolidated notification should be sent
    And digest should summarize all violations
    And owner should be able to take bulk action

  @notification @resolution
  Scenario: Notify parties of violation resolution
    Given a copyright violation was under review
    And resolution has been reached
    When resolution is recorded
    Then all parties should be notified:
      | party           | notification_type      |
      | copyright_owner | resolution_notification|
      | uploader        | action_taken_notice    |
      | platform_admin  | case_closed_summary    |

  # ==========================================
  # Allow Whitelisted Content Partners
  # ==========================================

  @whitelist @partner
  Scenario: Configure whitelisted content partner
    Given I am configuring partner whitelist
    When I add partner "Licensed Publisher Inc":
      | field             | value                    |
      | partner_id        | partner-12345            |
      | license_type      | full_catalog             |
      | start_date        | 2024-01-01               |
      | end_date          | 2025-12-31               |
      | allowed_works     | all                      |
    Then partner should be added to whitelist
    And license terms should be recorded
    And partner content should bypass copyright flags

  @whitelist @specific-works
  Scenario: Whitelist specific works for partner
    Given partner "Indie Author Collective" exists
    When I configure specific work permissions:
      | work_title          | license_type | permissions        |
      | "Adventure Novel"   | exclusive    | full reproduction  |
      | "Mystery Series"    | non-exclusive| excerpts only      |
      | "Poetry Collection" | limited      | 10% maximum        |
    Then specific work permissions should be recorded
    And matching should respect per-work limits

  @whitelist @verification
  Scenario: Verify partner upload against whitelist
    Given partner "Licensed Publisher Inc" uploads content
    And content matches their licensed catalog
    When copyright analysis runs
    Then partner license should be verified
    And content should be approved without violation
    And license usage should be logged

  @whitelist @expiration
  Scenario: Handle expired partner license
    Given partner license expired on 2024-01-01
    And current date is 2024-02-15
    When partner uploads previously licensed content
    Then license expiration should be detected
    And content should be flagged for review
    And partner should be notified of expiration
    And renewal options should be provided

  @whitelist @audit
  Scenario: Audit partner whitelist usage
    Given partner has active whitelist
    When I request usage audit for partner
    Then audit report should show:
      | metric              | value    |
      | total_uploads       | 150      |
      | approved_by_license | 145      |
      | exceeded_limits     | 5        |
      | license_value_used  | 72%      |

  @whitelist @revocation
  Scenario: Revoke partner whitelist access
    Given partner "Problematic Publisher" has active whitelist
    And policy violations have been identified
    When I revoke whitelist access
    Then partner should be removed from whitelist
    And future uploads should undergo standard checks
    And existing approved content should be re-evaluated
    And partner should be notified of revocation

  # ==========================================
  # Ensure Copyright Checking Performance
  # ==========================================

  @performance @sla
  Scenario: Meet copyright check SLA for standard documents
    Given performance SLA is 5 seconds for documents under 50 pages
    When a 30-page document is submitted for analysis
    Then analysis should complete within 5 seconds
    And SLA compliance should be logged

  @performance @large-document
  Scenario: Handle large document analysis efficiently
    Given a 500-page document is submitted
    When copyright analysis begins
    Then document should be processed in chunks
    And parallel processing should be utilized
    And progress should be reported incrementally
    And total time should be reasonable (< 60 seconds)

  @performance @caching
  Scenario: Utilize caching for repeated content patterns
    Given common content patterns are cached
    When document contains previously analyzed patterns
    Then cached results should be used
    And analysis time should be significantly reduced
    And cache hit rate should be monitored

  @performance @queue
  Scenario: Queue management during high load
    Given 100 documents are submitted simultaneously
    When queue processes submissions
    Then documents should be queued fairly
    And priority documents should be processed first
    And queue depth should be monitored
    And alerts should trigger if queue exceeds threshold

  @performance @degradation
  Scenario: Graceful degradation under extreme load
    Given system is under extreme load
    And copyright service is overwhelmed
    When new analysis requests arrive
    Then requests should be accepted with extended SLA
    And users should be notified of delays
    And critical checks should maintain priority
    And system should not crash

  @performance @monitoring
  Scenario: Monitor copyright service performance
    Given performance monitoring is enabled
    When I view performance dashboard
    Then I should see:
      | metric                    | visibility |
      | average_analysis_time     | yes        |
      | throughput_per_minute     | yes        |
      | queue_depth               | yes        |
      | cache_hit_rate            | yes        |
      | external_api_latency      | yes        |
      | error_rate                | yes        |

  # ==========================================
  # Configure Copyright Detection Sensitivity
  # ==========================================

  @sensitivity @thresholds
  Scenario: Configure detection sensitivity thresholds
    Given I am configuring copyright detection settings
    When I set sensitivity thresholds:
      | parameter                | value |
      | minimum_match_length     | 50    |
      | substantial_portion_pct  | 10    |
      | similarity_threshold     | 0.85  |
      | fair_use_word_limit      | 300   |
    Then thresholds should be saved
    And new analyses should use updated thresholds

  @sensitivity @profiles
  Scenario: Create sensitivity profiles for different use cases
    Given I create sensitivity profiles:
      | profile_name  | purpose           | strictness |
      | academic      | educational use   | low        |
      | commercial    | business use      | high       |
      | creative      | derivative works  | medium     |
    When a document is analyzed with specific profile
    Then profile thresholds should be applied
    And results should reflect profile sensitivity

  @sensitivity @content-type
  Scenario: Configure sensitivity by content type
    Given different content types have different risks
    When I configure per-type sensitivity:
      | content_type | sensitivity | rationale                |
      | prose        | medium      | standard detection       |
      | poetry       | high        | short works, high value  |
      | code         | low         | functional, limited      |
      | lyrics       | very_high   | heavily protected        |
    Then analyses should apply type-specific rules

  @sensitivity @testing
  Scenario: Test sensitivity configuration
    Given I have updated sensitivity settings
    When I run sensitivity test with sample documents
    Then test should analyze with old and new settings
    And comparison report should be generated:
      | metric              | old_settings | new_settings |
      | true_positives      | 85           | 92           |
      | false_positives     | 15           | 8            |
      | false_negatives     | 10           | 5            |
    And I should be able to accept or reject changes

  @sensitivity @per-user
  Scenario: Allow per-user sensitivity adjustments
    Given user has verified educational institution status
    When sensitivity adjustment is requested
    Then user can receive adjusted thresholds
    And adjustments should be logged
    And periodic verification should be required

  # ==========================================
  # Generate Copyright Compliance Report
  # ==========================================

  @reporting @compliance
  Scenario: Generate comprehensive compliance report
    Given copyright analysis has been running for the period
    When I generate compliance report for Q1 2024
    Then report should include:
      | section                  | details                    |
      | executive_summary        | key metrics and findings   |
      | violation_statistics     | counts by type and severity|
      | resolution_outcomes      | how violations were handled|
      | partner_activity         | licensed usage summary     |
      | recommendations          | suggested improvements     |

  @reporting @scheduled
  Scenario: Schedule automated compliance reports
    Given I configure scheduled reporting
    When I set schedule:
      | frequency  | weekly               |
      | day        | Monday               |
      | recipients | legal@company.com    |
      | format     | PDF                  |
    Then reports should be generated automatically
    And reports should be emailed to recipients
    And report history should be maintained

  @reporting @audit-trail
  Scenario: Generate audit trail report
    Given auditor requests copyright activity audit
    When I generate audit trail for specific period
    Then report should include all copyright actions:
      | action_type        | details_included          |
      | detection          | timestamp, document, match|
      | notification       | recipient, content, status|
      | resolution         | action, approver, date    |
      | appeals            | claim, evidence, outcome  |

  @reporting @rights-holder
  Scenario: Generate rights holder activity report
    Given rights holder "Major Publisher" requests report
    When I generate rights holder report
    Then report should show:
      | metric                  | value    |
      | total_detections        | 250      |
      | confirmed_violations    | 180      |
      | resolved_violations     | 175      |
      | pending_actions         | 5        |
      | licensed_usage          | 500      |

  @reporting @trends
  Scenario: Analyze copyright violation trends
    Given 12 months of copyright data exists
    When I generate trend analysis report
    Then report should include:
      | analysis                | visualization          |
      | monthly_violation_count | line_chart             |
      | violation_by_category   | pie_chart              |
      | top_infringed_works     | bar_chart              |
      | resolution_time_trend   | line_chart             |
      | repeat_offender_trend   | stacked_bar            |

  @reporting @export
  Scenario: Export compliance data for external analysis
    Given compliance data needs external analysis
    When I export copyright data
    Then data should be available in formats:
      | format | description                    |
      | CSV    | tabular data for spreadsheets  |
      | JSON   | structured data for systems    |
      | XML    | standard interchange format    |
    And data should be properly anonymized
    And export should be logged for compliance

  # ==========================================
  # Copyright Database Management
  # ==========================================

  @database @update
  Scenario: Update copyright works database
    Given new copyrighted works are registered weekly
    When database update is triggered
    Then new works should be added to detection database
    And existing entries should be updated if changed
    And deprecated entries should be marked
    And update statistics should be logged

  @database @import
  Scenario: Import copyright registry data
    Given external copyright registry data is available
    When I import registry data:
      | registry         | format | records |
      | ISBN Database    | XML    | 50000   |
      | Music Registry   | JSON   | 100000  |
      | Film Database    | CSV    | 25000   |
    Then records should be parsed and validated
    And duplicates should be detected and merged
    And import summary should be generated

  @database @search
  Scenario: Search copyright database
    Given I need to look up a specific work
    When I search with criteria:
      | field    | value             |
      | title    | "The Great Gatsby"|
      | author   | Fitzgerald        |
      | year     | 1925              |
    Then matching records should be returned
    And copyright status should be displayed
    And related works should be suggested

  @database @maintenance
  Scenario: Perform database maintenance
    Given database maintenance is scheduled
    When maintenance runs
    Then expired entries should be archived
    And indexes should be optimized
    And statistics should be updated
    And maintenance log should be generated

  # ==========================================
  # Appeal and Dispute Resolution
  # ==========================================

  @appeals @submit
  Scenario: Submit copyright dispute appeal
    Given user's content was flagged for copyright violation
    And user believes this is in error
    When user submits appeal:
      | field           | value                              |
      | reason          | fair_use                           |
      | evidence        | academic_paper_citation.pdf        |
      | explanation     | Used for educational criticism     |
    Then appeal should be recorded
    And case should be assigned for review
    And user should receive acknowledgment

  @appeals @review
  Scenario: Review copyright dispute
    Given an appeal is pending review
    When reviewer examines the case
    Then reviewer should see:
      | information         |
      | original_detection  |
      | user_appeal         |
      | supporting_evidence |
      | similar_precedents  |
    And reviewer can make determination
    And determination should be recorded

  @appeals @counter-notification
  Scenario: Process DMCA counter-notification
    Given content was removed due to DMCA takedown
    And user files counter-notification
    When counter-notification is received
    Then notification should be validated
    And original complainant should be notified
    And waiting period should begin
    And content may be restored after period

  @appeals @resolution
  Scenario: Record appeal resolution
    Given appeal has been decided
    When resolution is recorded:
      | field           | value                    |
      | decision        | appeal_granted           |
      | reason          | fair_use_confirmed       |
      | reviewer        | legal_team_001           |
      | date            | 2024-01-20               |
    Then content flag should be removed
    And user should be notified
    And resolution should be logged for precedent

  # ==========================================
  # Error Handling and Edge Cases
  # ==========================================

  @error-handling @service-unavailable
  Scenario: Handle copyright service unavailability
    Given the copyright detection service is temporarily unavailable
    When a document is submitted for analysis
    Then submission should be queued
    And user should be informed of delay
    And analysis should proceed when service recovers

  @error-handling @corrupt-document
  Scenario: Handle corrupt or unreadable document
    Given a document is corrupted or in unsupported format
    When copyright analysis is attempted
    Then appropriate error should be returned
    And user should be asked to resubmit
    And failure should be logged for debugging

  @error-handling @timeout
  Scenario: Handle analysis timeout
    Given analysis takes longer than timeout threshold
    When timeout is reached
    Then partial results should be saved
    And analysis should be retryable
    And user should be notified of timeout

  @edge-case @identical-works
  Scenario: Handle identical public domain and copyrighted versions
    Given a work exists in both public domain and copyrighted editions
    When analysis detects a match
    Then both versions should be identified
    And user should be prompted to specify source
    And appropriate rules should apply

  @edge-case @multilingual
  Scenario: Handle multilingual copyright detection
    Given document contains text in multiple languages
    When copyright analysis runs
    Then each language section should be analyzed
    And language-appropriate databases should be used
    And results should be consolidated

  @edge-case @special-characters
  Scenario: Handle documents with special characters
    Given document contains unicode, symbols, and special formatting
    When copyright analysis runs
    Then text should be properly normalized
    And matching should account for formatting variations
    And results should be accurate

  @edge-case @empty-document
  Scenario: Handle empty or minimal content document
    Given document has less than 10 words of content
    When copyright analysis is requested
    Then analysis should complete quickly
    And result should indicate insufficient content
    And no violation should be flagged
