@ANIMA-1012
Feature: Document Preview Functionality
  As a world creator
  I want to preview documents before processing
  So that I can verify content and make informed decisions
Background:
    Given I am authenticated as a world owner
    And I have documents ready for upload
    And the preview service is available
    And I have access to the ingestion context
===========================================
  # PREVIEW GENERATION
  # ===========================================
@preview @generation
  Scenario: Generate document preview for PDF
    Given I have uploaded a PDF document "world_lore.pdf" with 50 pages
    When I request a preview for document "world_lore.pdf"
    Then a preview should be generated within 5 seconds
    And the preview should include the first 3 pages as thumbnails
    And the preview should include document metadata
    And the preview should include a text excerpt from the first page
    And a DocumentPreviewGeneratedEvent should be published
@preview @generation
  Scenario: Generate document preview for text file
    Given I have uploaded a text document "character_backstory.txt"
    When I request a preview for document "character_backstory.txt"
    Then a preview should be generated
    And the preview should include the first 500 characters of content
    And the preview should include word count
    And the preview should include character count
    And the preview should include line count
@preview @generation
  Scenario Outline: Generate preview for supported document types
    Given I have uploaded a document "sample.<extension>" of type "<type>"
    When I request a preview for the document
    Then a preview should be successfully generated
    And the preview format should be appropriate for "<type>"
    And the preview should include "<preview_content>"
Examples:
      | extension | type                    | preview_content              |
      | pdf       | application/pdf         | page thumbnails              |
      | docx      | application/msword      | text excerpt                 |
      | txt       | text/plain              | first 500 characters         |
      | md        | text/markdown           | rendered markdown preview    |
      | html      | text/html               | sanitized HTML preview       |
      | epub      | application/epub+zip    | chapter list and excerpt     |
      | json      | application/json        | formatted JSON tree          |
@preview @generation @images
  Scenario: Generate preview for image documents
    Given I have uploaded an image document "map.png"
    When I request a preview for document "map.png"
    Then a thumbnail preview should be generated
    And the thumbnail should be resized to fit within 400x400 pixels
    And the preview should include image dimensions
    And the preview should include file size
    And the preview should include color profile information
@preview @generation @unsupported
  Scenario: Handle unsupported document type
    Given I have uploaded a document "data.xyz" with unsupported type
    When I request a preview for document "data.xyz"
    Then the preview should indicate "Preview not available"
    And the response should include the file name
    And the response should include the file size
    And the response should include the MIME type
    And a PreviewUnavailableEvent should be published
@preview @generation @corrupted
  Scenario: Handle corrupted document gracefully
    Given I have uploaded a corrupted PDF document "broken.pdf"
    When I request a preview for document "broken.pdf"
    Then the preview request should return a partial result
    And the response should indicate "Document may be corrupted"
    And any extractable metadata should be included
    And a DocumentCorruptionDetectedEvent should be published
@preview @generation @encrypted
  Scenario: Handle password-protected documents
    Given I have uploaded a password-protected PDF "secure.pdf"
    When I request a preview for document "secure.pdf"
    Then the preview should indicate "Password required"
    And the response should prompt for password entry
    And no content should be exposed without authentication
    When I provide the correct password "secret123"
    Then the preview should be generated successfully
@preview @generation @large-file
  Scenario: Generate preview for large documents
    Given I have uploaded a large PDF document "encyclopedia.pdf" with 1000 pages
    When I request a preview for the document
    Then the preview should be generated progressively
    And the first page preview should be available within 2 seconds
    And subsequent pages should load on demand
    And a progress indicator should show generation status
===========================================
  # PREVIEW NAVIGATION
  # ===========================================
@preview @navigation
  Scenario: Navigate through document preview
    Given I have a preview generated for document "world_lore.pdf" with 50 pages
    When I am viewing the preview
    Then I should see navigation controls
    And I should be able to navigate to the next page
    And I should be able to navigate to the previous page
    And I should be able to jump to a specific page number
    And the current page indicator should update
@preview @navigation @pagination
  Scenario: Navigate through paginated preview
    Given I am viewing a preview of a 100-page document
    And I am currently on page 1
    When I click "Next Page"
    Then the preview should show page 2
    And the page indicator should show "2 of 100"
    When I enter page number 50 in the page jump field
    Then the preview should navigate to page 50
    And the page indicator should show "50 of 100"
@preview @navigation @zoom
  Scenario: Zoom in and out of preview
    Given I am viewing a preview of document "detailed_map.pdf"
    When I click the zoom in button
    Then the preview should increase in size by 25%
    And the zoom level indicator should update
    When I click the zoom out button
    Then the preview should decrease in size by 25%
    When I click "Fit to Width"
    Then the preview should scale to fit the viewport width
@preview @navigation @scroll
  Scenario: Scroll through continuous preview
    Given I am viewing a continuous preview of "long_story.txt"
    When I scroll down through the preview
    Then additional content should load seamlessly
    And the scroll position should be preserved on refresh
    And a scroll position indicator should show progress
@preview @navigation @search
  Scenario: Search within document preview
    Given I am viewing a preview of document "world_lore.pdf"
    When I search for "dragon"
    Then matching occurrences should be highlighted
    And the result count should be displayed
    And I should be able to navigate between matches
    And the preview should jump to the first match
@preview @navigation @bookmarks
  Scenario: Navigate using document bookmarks
    Given I am viewing a preview of "rulebook.pdf" with bookmarks
    When I open the bookmark panel
    Then I should see a list of document bookmarks
    When I click on bookmark "Chapter 3: Combat"
    Then the preview should navigate to that section
    And the bookmark should be highlighted as active
===========================================
  # DOCUMENT SUITABILITY ANALYSIS
  # ===========================================
@preview @analysis
  Scenario: Analyze document suitability
    Given I am viewing a preview of document "fantasy_novel.pdf"
    When I request suitability analysis
    Then the analysis should evaluate content relevance
    And the analysis should identify key themes
    And the analysis should estimate processing complexity
    And the analysis should provide a suitability score
    And the analysis should suggest optimal extraction settings
@preview @analysis @content-type
  Scenario: Analyze document content type
    Given I am viewing a preview of an uploaded document
    When the content analysis runs
    Then the system should identify the content type
    And categorize it as one of: narrative, reference, dialogue, description
    And provide confidence scores for each category
    And suggest appropriate processing pipelines
@preview @analysis @entities
  Scenario: Preview entity extraction results
    Given I am viewing a preview of "character_sheet.pdf"
    When I request entity extraction preview
    Then the system should identify potential entities
    And highlight character names in the preview
    And highlight location names in the preview
    And highlight item names in the preview
    And show entity counts by category
@preview @analysis @quality
  Scenario: Assess document quality for processing
    Given I am viewing a preview of document "scanned_book.pdf"
    When the quality assessment runs
    Then the system should evaluate text clarity
    And report OCR confidence if applicable
    And identify potential quality issues
    And suggest quality improvement actions
    And provide an overall quality score
@preview @analysis @duplicates
  Scenario: Detect potential duplicate content
    Given I am viewing a preview of a new document
    And similar documents exist in my world
    When duplicate detection runs
    Then the system should identify similar existing documents
    And show similarity percentages
    And highlight overlapping sections
    And warn about potential redundancy
@preview @analysis @language
  Scenario: Detect document language
    Given I am viewing a preview of document "foreign_text.pdf"
    When language detection runs
    Then the detected language should be displayed
    And confidence level should be shown
    And translation options should be offered if not in primary language
    And a LanguageDetectedEvent should be published
@preview @analysis @recommendations
  Scenario Outline: Provide processing recommendations based on content
    Given I am viewing a preview of a document with content type "<content_type>"
    When the recommendation engine analyzes the document
    Then processing recommendation "<recommendation>" should be displayed
    And estimated processing time should be shown
    And suggested extraction depth should be "<depth>"
Examples:
      | content_type   | recommendation                      | depth    |
      | narrative      | Full story extraction               | deep     |
      | dialogue       | Character dialogue extraction       | medium   |
      | reference      | Fact and entity extraction          | shallow  |
      | mixed          | Multi-pass extraction               | adaptive |
===========================================
  # BATCH PREVIEW
  # ===========================================
@preview @batch
  Scenario: Preview multiple documents efficiently
    Given I have uploaded 10 documents for batch preview
    When I request batch preview generation
    Then previews should be generated in parallel
    And progress should be shown for each document
    And completed previews should be immediately viewable
    And the batch should complete within reasonable time
@preview @batch @grid
  Scenario: View multiple document previews in grid layout
    Given I have previews generated for 20 documents
    When I select grid view mode
    Then document thumbnails should be displayed in a grid
    And I should be able to sort by name, date, or size
    And I should be able to filter by document type
    And clicking a thumbnail should open the full preview
@preview @batch @comparison
  Scenario: Compare two document previews side by side
    Given I have previews for documents "version1.pdf" and "version2.pdf"
    When I select both documents for comparison
    Then the previews should display side by side
    And synchronized scrolling should be enabled
    And differences should be highlighted if detected
    And I should be able to swap left and right positions
@preview @batch @selection
  Scenario: Select documents from preview for processing
    Given I am viewing batch previews of 10 documents
    When I select documents "doc1.pdf", "doc3.pdf", and "doc7.pdf"
    Then the selected documents should be highlighted
    And a selection count should display "3 documents selected"
    And I should see options to process selected documents
    And I should be able to clear selection
@preview @batch @prioritization
  Scenario: Prioritize preview generation for specific documents
    Given I have 50 documents queued for preview generation
    And previews are generating in order
    When I request priority preview for "urgent_doc.pdf"
    Then "urgent_doc.pdf" should be moved to front of queue
    And its preview should be generated next
    And a PreviewPrioritizedEvent should be published
===========================================
  # PREVIEW CACHING
  # ===========================================
@preview @cache
  Scenario: Cache previews for performance
    Given I have requested a preview for document "world_lore.pdf"
    And the preview has been generated and cached
    When I request the same preview again
    Then the cached preview should be returned
    And the response time should be under 100ms
    And no regeneration should occur
@preview @cache @invalidation
  Scenario: Invalidate cache when document is updated
    Given I have a cached preview for document "draft.pdf"
    When the document "draft.pdf" is updated with new content
    Then the cached preview should be invalidated
    And a new preview should be generated on next request
    And a PreviewCacheInvalidatedEvent should be published
@preview @cache @expiration
  Scenario: Expire old preview cache entries
    Given preview caches are configured to expire after 24 hours
    And a preview was cached 25 hours ago
    When I request the preview
    Then the expired cache should be cleared
    And a fresh preview should be generated
    And the new preview should be cached
@preview @cache @storage
  Scenario: Manage preview cache storage limits
    Given the preview cache is configured with 10GB limit
    And the cache is at 95% capacity
    When a new preview is generated
    Then the least recently used previews should be evicted
    And the new preview should be cached
    And cache metrics should be updated
@preview @cache @prewarming
  Scenario: Pre-warm cache for frequently accessed documents
    Given document "popular_rules.pdf" is accessed frequently
    When the cache pre-warming job runs
    Then the preview should be regenerated proactively
    And the cache should be refreshed before expiration
    And access statistics should be tracked
===========================================
  # ACCESS CONTROL
  # ===========================================
@preview @security @permissions
  Scenario: Enforce document access permissions on preview
    Given document "confidential.pdf" has restricted access
    And I do not have permission to view this document
    When I request a preview for "confidential.pdf"
    Then the request should be rejected with status code 403
    And the response should indicate "Access denied"
    And no preview content should be exposed
@preview @security @sharing
  Scenario: Share preview with collaborators
    Given I have a preview generated for "world_map.pdf"
    And I want to share it with collaborator "alice@example.com"
    When I generate a shareable preview link
    Then the link should have configurable expiration
    And the link should enforce view-only access
    And access through the link should be logged
    And a PreviewSharedEvent should be published
@preview @security @watermark
  Scenario: Apply watermark to shared previews
    Given I am sharing a preview of document "draft_story.pdf"
    And watermarking is enabled for shared previews
    When the preview is accessed via shared link
    Then the preview should display a watermark
    And the watermark should include viewer identification
    And the watermark should not be removable
===========================================
  # ERROR HANDLING
  # ===========================================
@preview @error
  Scenario: Handle preview generation timeout
    Given I request a preview for a very complex document
    When the preview generation exceeds the timeout of 30 seconds
    Then a timeout error should be returned
    And partial results should be provided if available
    And the user should be offered retry options
    And a PreviewTimeoutEvent should be published
@preview @error @service-unavailable
  Scenario: Handle preview service unavailability
    Given the preview generation service is temporarily unavailable
    When I request a preview for any document
    Then the request should return status code 503
    And the response should indicate "Preview service temporarily unavailable"
    And retry-after header should be included
    And a graceful fallback message should be displayed
@preview @error @memory
  Scenario: Handle out of memory during preview generation
    Given a very large document "massive_archive.pdf" is being previewed
    When preview generation exhausts available memory
    Then the operation should fail gracefully
    And partial results should be preserved
    And the user should be advised to try with a smaller document
    And a ResourceExhaustionEvent should be logged
@preview @error @format
  Scenario: Handle malformed document format
    Given I have uploaded a document with incorrect file extension
    And the file claims to be PDF but is actually a ZIP
    When I request a preview
    Then the system should detect the format mismatch
    And an appropriate error message should be displayed
    And the actual file type should be identified if possible
    And a FormatMismatchEvent should be published
===========================================
  # MOBILE AND RESPONSIVE PREVIEW
  # ===========================================
@preview @mobile
  Scenario: Provide mobile-optimized preview
    Given I am accessing the preview from a mobile device
    When I request a preview for document "guide.pdf"
    Then the preview should be optimized for mobile viewport
    And touch-friendly navigation should be enabled
    And preview quality should adapt to connection speed
    And gesture controls should be available for zoom and scroll
@preview @mobile @offline
  Scenario: Support offline preview access
    Given I have previously viewed preview for "reference.pdf"
    And the preview is cached locally on my device
    When I lose network connectivity
    Then I should still be able to view the cached preview
    And an offline indicator should be displayed
    And editing or processing options should be disabled
===========================================
  # PREVIEW ANNOTATIONS
  # ===========================================
@preview @annotations
  Scenario: Add annotations to document preview
    Given I am viewing a preview of "story_draft.pdf"
    When I highlight a section of text
    And I add a note "Need to expand this scene"
    Then the annotation should be saved
    And the annotation should be visible on subsequent views
    And annotations should not modify the original document
@preview @annotations @collaborative
  Scenario: View annotations from collaborators
    Given document "shared_doc.pdf" has annotations from multiple users
    When I view the preview
    Then I should see annotations from all collaborators
    And annotations should be color-coded by author
    And I should be able to filter annotations by author
    And I should be able to reply to annotations
@preview @annotations @export
  Scenario: Export preview with annotations
    Given I have added annotations to preview of "reviewed_doc.pdf"
    When I request to export the annotated preview
    Then a new PDF should be generated with annotations embedded
    And the export should include all annotations with author info
    And the original document should remain unchanged
===========================================
  # ANALYTICS AND TELEMETRY
  # ===========================================
@preview @analytics
  Scenario: Track preview usage analytics
    Given users are actively using the preview feature
    When preview analytics are collected
    Then total preview generations should be tracked
    And average preview time should be measured
    And most previewed document types should be identified
    And preview abandonment rate should be calculated
@preview @analytics @performance
  Scenario: Monitor preview performance metrics
    Given the preview system is under active use
    When performance metrics are collected
    Then average generation time by document type should be tracked
    And cache hit rate should be measured
    And error rate should be monitored
    And resource utilization should be logged