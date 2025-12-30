@export @entities @api @backup @MVP-FOUNDATION
Feature: Export Extracted Entities API
  As a world owner or developer
  I want to export extracted entities in various formats
  So that I can use them in external tools or backup my data

  Background:
    Given I am authenticated with export permissions
    And I have a world with extracted entities
    And the export service is operational

  # ===========================================
  # EXPORT IN MULTIPLE FORMATS
  # ===========================================

  @formats @json
  Scenario: Export entities in JSON format
    Given I have entities to export
    When I request an export in JSON format
    Then the export should be generated in JSON
    And the JSON should be valid and well-formed
    And entities should include all properties
    And the export should include metadata
    And I should receive the download link

  @formats @csv
  Scenario: Export entities in CSV format
    Given I have entities to export
    When I request an export in CSV format
    Then the export should be generated in CSV
    And each entity type should have its own CSV file
    And headers should match entity properties
    And data should be properly escaped
    And I should receive a zip file with all CSVs

  @formats @xml
  Scenario: Export entities in XML format
    Given I have entities to export
    When I request an export in XML format
    Then the export should be generated in XML
    And the XML should be valid and well-formed
    And entities should be properly nested
    And an XSD schema should be included
    And I should receive the download link

  @formats @yaml
  Scenario: Export entities in YAML format
    Given I have entities to export
    When I request an export in YAML format
    Then the export should be generated in YAML
    And the YAML should be valid
    And entities should be human-readable
    And relationships should be represented
    And I should receive the download link

  @formats @parquet
  Scenario: Export entities in Parquet format
    Given I have entities to export
    When I request an export in Parquet format
    Then the export should be generated in Parquet
    And the format should be optimized for analytics
    And data types should be preserved
    And compression should be applied
    And I should receive the download link

  @formats @graphml
  Scenario: Export entities in GraphML format
    Given I have entities with relationships
    When I request an export in GraphML format
    Then the export should be generated in GraphML
    And entities should be represented as nodes
    And relationships should be represented as edges
    And properties should be included as attributes
    And the graph should be valid

  @formats @rdf
  Scenario: Export entities in RDF format
    Given I have entities to export
    When I request an export in RDF format
    Then the export should be generated in RDF/XML
    And entities should have proper URIs
    And relationships should be RDF triples
    And ontology should be included
    And I should receive the download link

  # ===========================================
  # EXPORT SPECIFIC ENTITY SUBSETS
  # ===========================================

  @subsets @filter
  Scenario: Export specific entity subsets
    Given I have multiple entity types
    When I request an export with filters
    Then I should be able to filter by entity type
    And I should be able to filter by date range
    And I should be able to filter by properties
    And only matching entities should be exported

  @subsets @entity-type
  Scenario: Export by entity type
    Given I have characters, locations, and items
    When I request an export of only characters
    Then only character entities should be exported
    And locations should not be included
    And items should not be included
    And the export should confirm the filter applied

  @subsets @date-range
  Scenario: Export entities by date range
    Given I have entities created at different times
    When I request an export with date range filter
    Then only entities within the date range should be exported
    And I should be able to filter by created date
    And I should be able to filter by modified date
    And the date range should be inclusive

  @subsets @properties
  Scenario: Export entities by property values
    Given I have entities with various properties
    When I request an export filtered by property
    Then only entities matching the property filter should be exported
    And I should be able to use equality filters
    And I should be able to use range filters
    And I should be able to use contains filters

  @subsets @tags
  Scenario: Export entities by tags
    Given I have entities with tags assigned
    When I request an export filtered by tags
    Then only entities with matching tags should be exported
    And I should be able to filter by single tag
    And I should be able to filter by multiple tags
    And I should specify AND or OR logic for tags

  @subsets @relationships
  Scenario: Export entities by relationship
    Given I have entities with relationships
    When I request an export filtered by relationship
    Then only entities with matching relationships should be exported
    And I should be able to filter by relationship type
    And I should be able to filter by connected entity
    And related entities should optionally be included

  @subsets @combine
  Scenario: Combine multiple filters
    Given I have diverse entities
    When I request an export with multiple filters
    Then all filters should be applied together
    And I should be able to use AND logic
    And I should be able to use OR logic
    And I should see the effective filter summary

  # ===========================================
  # API ACCESS
  # ===========================================

  @api @endpoint
  Scenario: Access export functionality via API
    Given I have valid API credentials
    When I call the export API endpoint
    Then I should receive a successful response
    And the response should include export job ID
    And I should receive status polling endpoint
    And I should receive download endpoint when complete

  @api @request
  Scenario: Submit export request via API
    Given I have valid API credentials
    When I POST to the export endpoint with parameters
    Then the request should be validated
    And the export job should be created
    And I should receive the job ID
    And I should receive estimated completion time

  @api @status
  Scenario: Check export status via API
    Given I have submitted an export request
    When I GET the export status endpoint
    Then I should see the current status
    And I should see progress percentage
    And I should see estimated time remaining
    And I should see any warnings or errors

  @api @download
  Scenario: Download export via API
    Given my export job is complete
    When I GET the export download endpoint
    Then I should receive the exported file
    And the file should have correct content type
    And the file should be complete
    And the download should be logged

  @api @cancel
  Scenario: Cancel export via API
    Given I have a pending export job
    When I DELETE the export job
    Then the export should be cancelled
    And resources should be released
    And I should receive confirmation
    And partial files should be cleaned up

  @api @pagination
  Scenario: Handle paginated export results
    Given I have many entities to export
    When I request export with pagination
    Then I should receive paginated results
    And each page should have a cursor
    And I should be able to request next page
    And all pages should be consistent

  @api @authentication
  Scenario: Require authentication for export API
    Given I am not authenticated
    When I call the export API endpoint
    Then I should receive an authentication error
    And no export should be created
    And the attempt should be logged

  @api @rate-limiting
  Scenario: Apply rate limiting to export API
    Given I have made many export requests
    When I exceed the rate limit
    Then I should receive a rate limit error
    And I should see when I can retry
    And my existing exports should continue
    And the rate limit should protect the system

  # ===========================================
  # MAINTAIN RELATIONSHIPS
  # ===========================================

  @relationships @preserve
  Scenario: Maintain relationships in exports
    Given I have entities with relationships
    When I export the entities
    Then relationships should be preserved
    And relationship types should be included
    And relationship properties should be included
    And bidirectional relationships should be handled

  @relationships @reference
  Scenario: Export relationship references
    Given I have entities with relationships
    When I export with reference mode
    Then related entities should be referenced by ID
    And references should be resolvable
    And circular references should be handled
    And orphaned references should be flagged

  @relationships @embedded
  Scenario: Export with embedded relationships
    Given I have entities with relationships
    When I export with embedded mode
    Then related entities should be embedded inline
    And nesting depth should be configurable
    And circular references should be detected
    And file size should be manageable

  @relationships @graph
  Scenario: Export relationship graph
    Given I have entities with complex relationships
    When I export the relationship graph
    Then I should receive a graph representation
    And all nodes should be included
    And all edges should be included
    And graph metadata should be included

  @relationships @integrity
  Scenario: Validate relationship integrity on export
    Given I have entities with relationships
    When I export the entities
    Then relationship integrity should be validated
    And broken relationships should be reported
    And I should choose to skip or include broken refs
    And a validation report should be included

  # ===========================================
  # LARGE-SCALE EXPORTS
  # ===========================================

  @large-scale @efficient
  Scenario: Handle large-scale exports efficiently
    Given I have millions of entities
    When I request a large export
    Then the export should be processed in chunks
    And memory usage should be bounded
    And progress should be trackable
    And the system should remain responsive

  @large-scale @streaming
  Scenario: Stream large exports
    Given I have a very large dataset
    When I request a streaming export
    Then data should be streamed as it's processed
    And I should not wait for complete generation
    And connection should be maintained
    And interruptions should be resumable

  @large-scale @chunked
  Scenario: Chunk large exports into multiple files
    Given I have many entities to export
    When the export exceeds size threshold
    Then the export should be split into chunks
    And each chunk should be complete and valid
    And chunks should be numbered sequentially
    And a manifest file should be included

  @large-scale @compression
  Scenario: Compress large exports
    Given I have a large export
    When I request compressed export
    Then the export should be compressed
    And I should choose compression format
    And compression level should be configurable
    And file size should be significantly reduced

  @large-scale @async
  Scenario: Process large exports asynchronously
    Given I request a large export
    When the export will take significant time
    Then the export should be processed asynchronously
    And I should receive a job ID immediately
    And I should be able to poll for status
    And I should be notified when complete

  @large-scale @resume
  Scenario: Resume interrupted large exports
    Given a large export was interrupted
    When I resume the export
    Then processing should continue from checkpoint
    And already processed data should not be reprocessed
    And the final export should be complete
    And resume attempts should be logged

  @large-scale @timeout
  Scenario: Handle export timeout
    Given I request a large export
    When the export exceeds time limit
    Then I should receive a timeout notification
    And I should be able to extend the timeout
    And partial results should be available
    And resources should be properly released

  # ===========================================
  # CUSTOMIZE EXPORT OUTPUT
  # ===========================================

  @customize @output
  Scenario: Customize export output
    Given I have entities to export
    When I configure export customization
    Then I should be able to select fields
    And I should be able to rename fields
    And I should be able to transform values
    And I should be able to add computed fields

  @customize @fields
  Scenario: Select specific fields for export
    Given I have entities with many properties
    When I select specific fields to export
    Then only selected fields should be included
    And field order should be preserved
    And required fields should be validated
    And the export should be smaller

  @customize @rename
  Scenario: Rename fields in export
    Given I have entities to export
    When I configure field renaming
    Then fields should be renamed in output
    And original field names should not appear
    And renaming should be consistent
    And a field mapping should be available

  @customize @transform
  Scenario: Transform field values in export
    Given I have entities to export
    When I configure value transformations
    Then values should be transformed as specified
    And I should be able to format dates
    And I should be able to convert types
    And I should be able to apply functions

  @customize @computed
  Scenario: Add computed fields to export
    Given I have entities to export
    When I add computed fields
    Then computed fields should be included
    And computations should be evaluated
    And dependencies should be resolved
    And errors should be handled gracefully

  @customize @template
  Scenario: Use export template
    Given I have a saved export template
    When I apply the template to an export
    Then all template settings should be applied
    And I should be able to override settings
    And the export should match template configuration
    And template usage should be logged

  @customize @save-template
  Scenario: Save export configuration as template
    Given I have configured an export
    When I save the configuration as template
    Then the template should be saved
    And I should name the template
    And I should be able to reuse the template
    And templates should be shareable

  # ===========================================
  # SECURE ENTITY EXPORTS
  # ===========================================

  @security @secure
  Scenario: Secure entity exports
    Given I have entities with sensitive data
    When I export the entities
    Then exports should be encrypted
    And access should require authentication
    And downloads should be logged
    And exports should expire after time limit

  @security @encryption
  Scenario: Encrypt exported files
    Given I request an encrypted export
    When the export is generated
    Then the file should be encrypted
    And I should provide or receive encryption key
    And encryption algorithm should be configurable
    And decryption instructions should be included

  @security @password
  Scenario: Password protect exports
    Given I request a password-protected export
    When I set the export password
    Then the export should require password to open
    And password strength should be validated
    And password should not be stored
    And I should receive the password securely

  @security @expiry
  Scenario: Set export download expiry
    Given I have completed an export
    When I set a download expiry
    Then the download link should expire after set time
    And expired links should return an error
    And expiry should be enforced
    And expiry time should be visible

  @security @access-control
  Scenario: Control who can access exports
    Given I have completed an export
    When I configure access control
    Then only authorized users should access the export
    And I should specify allowed users or roles
    And unauthorized access should be denied
    And access attempts should be logged

  @security @audit
  Scenario: Audit export access
    Given exports are being accessed
    When I view the audit log
    Then I should see who accessed exports
    And I should see when access occurred
    And I should see what was accessed
    And I should see access outcomes

  @security @redact
  Scenario: Redact sensitive data in exports
    Given I have entities with sensitive fields
    When I configure redaction rules
    Then sensitive fields should be redacted
    And redaction patterns should be configurable
    And redacted data should be clearly marked
    And original data should remain secure

  @security @watermark
  Scenario: Watermark exported data
    Given I request an export
    When I enable watermarking
    Then exports should include watermark
    And watermark should identify the exporter
    And watermark should include timestamp
    And watermark should be difficult to remove

  # ===========================================
  # SCHEDULE RECURRING EXPORTS
  # ===========================================

  @schedule @recurring
  Scenario: Schedule recurring exports
    Given I have export configuration
    When I schedule a recurring export
    Then exports should run on schedule
    And I should specify the schedule
    And I should configure retention
    And I should receive notifications

  @schedule @create
  Scenario: Create export schedule
    Given I have an export configuration
    When I create a schedule
    Then I should set the frequency
    And I should set the start time
    And I should set the end time if needed
    And the schedule should be created

  @schedule @frequency
  Scenario: Configure schedule frequency
    Given I am creating an export schedule
    When I configure the frequency
    Then I should be able to set hourly exports
    And I should be able to set daily exports
    And I should be able to set weekly exports
    And I should be able to set monthly exports
    And I should be able to set custom cron expression

  @schedule @notifications
  Scenario: Configure schedule notifications
    Given I have a scheduled export
    When I configure notifications
    Then I should receive success notifications
    And I should receive failure notifications
    And I should choose notification channels
    And I should configure notification recipients

  @schedule @retention
  Scenario: Configure export retention
    Given I have a scheduled export
    When I configure retention
    Then I should set number of exports to keep
    And I should set age limit for exports
    And old exports should be automatically deleted
    And retention should be enforced

  @schedule @manage
  Scenario: Manage scheduled exports
    Given I have scheduled exports
    When I manage schedules
    Then I should view all schedules
    And I should be able to pause schedules
    And I should be able to resume schedules
    And I should be able to delete schedules

  @schedule @history
  Scenario: View schedule execution history
    Given I have a scheduled export
    When I view execution history
    Then I should see past executions
    And I should see success and failure status
    And I should see execution duration
    And I should see output file locations

  @schedule @manual
  Scenario: Manually trigger scheduled export
    Given I have a scheduled export
    When I manually trigger the export
    Then the export should run immediately
    And it should use the schedule configuration
    And regular schedule should not be affected
    And the manual run should be logged

  # ===========================================
  # EXPORT MANAGEMENT
  # ===========================================

  @management @list
  Scenario: List all exports
    Given I have created multiple exports
    When I list my exports
    Then I should see all my exports
    And I should see export status
    And I should see export dates
    And I should see file sizes

  @management @delete
  Scenario: Delete export files
    Given I have completed exports
    When I delete an export
    Then the export file should be deleted
    And the export record should be updated
    And storage should be freed
    And the deletion should be logged

  @management @storage
  Scenario: View export storage usage
    Given I have multiple exports
    When I view storage usage
    Then I should see total storage used
    And I should see storage by export
    And I should see storage quota
    And I should see recommendations

  @management @share
  Scenario: Share export with others
    Given I have a completed export
    When I share the export
    Then I should generate a share link
    And I should set access permissions
    And I should set expiry
    And the share should be logged

  # ===========================================
  # ERROR HANDLING AND EDGE CASES
  # ===========================================

  @error-handling @no-entities
  Scenario: Handle export with no matching entities
    Given I request an export with filters
    When no entities match the filters
    Then I should receive an empty result notification
    And I should see the filters applied
    And I should be able to adjust filters
    And no export file should be created

  @error-handling @permission-denied
  Scenario: Handle insufficient export permissions
    Given I do not have export permissions
    When I request an export
    Then I should receive a permission error
    And I should see what permission is required
    And no export should be created
    And the attempt should be logged

  @error-handling @format-error
  Scenario: Handle unsupported export format
    Given I request an export
    When I specify an unsupported format
    Then I should receive a format error
    And I should see supported formats
    And no export should be created

  @error-handling @disk-space
  Scenario: Handle insufficient disk space
    Given disk space is limited
    When I request a large export
    Then I should receive a space error
    And I should see available space
    And I should be offered alternatives
    And the system should remain stable

  @error-handling @entity-error
  Scenario: Handle entity processing errors
    Given some entities have errors
    When I export entities
    Then I should be notified of errors
    And I should see which entities failed
    And I should choose to skip or fail
    And valid entities should be exportable

  @edge-case @special-characters
  Scenario: Handle special characters in entity data
    Given entities contain special characters
    When I export the entities
    Then special characters should be properly encoded
    And export should be valid
    And data should be preservable on re-import
    And character encoding should be documented

  @edge-case @unicode
  Scenario: Handle unicode content in exports
    Given entities contain unicode text
    When I export the entities
    Then unicode should be properly preserved
    And encoding should be UTF-8
    And all scripts should be supported
    And export should be readable

  @edge-case @empty-fields
  Scenario: Handle empty and null fields
    Given entities have empty or null fields
    When I export the entities
    Then empty fields should be handled consistently
    And null values should be represented correctly
    And distinction between empty and null should be clear
    And import should reconstruct correctly

  @edge-case @circular-relations
  Scenario: Handle circular relationships
    Given entities have circular relationships
    When I export the entities
    Then circular references should be detected
    And infinite loops should be prevented
    And references should be resolvable
    And a warning should be included

  @edge-case @very-large-field
  Scenario: Handle very large field values
    Given an entity has a very large text field
    When I export the entities
    Then large fields should be handled
    And chunking should be applied if needed
    And field integrity should be maintained
    And performance should be acceptable
