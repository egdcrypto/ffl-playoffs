@admin @notifications @templates @communication
Feature: Admin Notification Templates
  As a platform administrator
  I want to manage notification templates
  So that I can ensure consistent and effective communication

  Background:
    Given I am logged in as a platform administrator
    And I have notification management permissions
    And the notification template system is operational

  # ===========================================
  # TEMPLATE OVERVIEW
  # ===========================================

  @overview @list
  Scenario: View notification templates
    Given I am on the admin dashboard
    When I navigate to the notification templates section
    Then I should see the templates overview page
    And I should see a list of all notification templates
    And I should see template categories
    And I should see search and filter options
    And I should see template statistics summary

  @overview @summary
  Scenario: View templates summary statistics
    Given I am on the notification templates section
    When I view the summary panel
    Then I should see total template count
    And I should see active template count
    And I should see templates by category
    And I should see recently modified templates
    And I should see templates pending review

  @overview @search
  Scenario: Search notification templates
    Given I am on the notification templates section
    When I enter a search term
    Then I should see matching templates
    And results should match template name
    And results should match template content
    And results should match template tags
    And I should see the total match count

  @overview @filter
  Scenario: Filter notification templates
    Given I am on the notification templates section
    When I apply filters
    Then I should be able to filter by category
    And I should be able to filter by channel
    And I should be able to filter by status
    And I should be able to filter by language
    And I should be able to combine multiple filters

  @overview @sort
  Scenario: Sort notification templates
    Given I am on the notification templates section
    When I apply sorting
    Then I should be able to sort by name
    And I should be able to sort by last modified
    And I should be able to sort by usage count
    And I should be able to sort by performance
    And I should toggle ascending/descending

  # ===========================================
  # TEMPLATE DETAILS
  # ===========================================

  @details @view
  Scenario: View template details
    Given I am on the notification templates section
    And there are notification templates available
    When I click on a template to view details
    Then I should see the template details page
    And I should see the template name and description
    And I should see the template content
    And I should see template metadata
    And I should see template usage statistics

  @details @content
  Scenario: View template content
    Given I am viewing a template's details
    When I view the content section
    Then I should see the subject line
    And I should see the body content
    And I should see the preview text
    And I should see call-to-action buttons
    And I should see the footer content

  @details @metadata
  Scenario: View template metadata
    Given I am viewing a template's details
    When I view the metadata section
    Then I should see the template ID
    And I should see the creation date
    And I should see the last modified date
    And I should see the template owner
    And I should see the template category
    And I should see associated tags

  @details @preview
  Scenario: Preview template rendering
    Given I am viewing a template's details
    When I click on "Preview"
    Then I should see the rendered template
    And I should see how it looks on different devices
    And I should be able to toggle between channels
    And I should see sample data populated
    And I should be able to customize preview data

  @details @channels
  Scenario: View template channel configurations
    Given I am viewing a template's details
    When I view channel configurations
    Then I should see email configuration
    And I should see push notification configuration
    And I should see SMS configuration
    And I should see in-app notification configuration
    And I should see channel-specific content

  # ===========================================
  # EDIT NOTIFICATION TEMPLATE
  # ===========================================

  @edit @template
  Scenario: Edit notification template
    Given I am viewing a template's details
    And I have template edit permissions
    When I click on "Edit Template"
    Then I should see the template editor
    And I should see the content editing area
    And I should see formatting options
    And I should see variable insertion options
    And I should see preview panel

  @edit @content
  Scenario: Edit template content
    Given I am editing a notification template
    When I edit the content
    Then I should be able to edit the subject line
    And I should be able to edit the body content
    And I should be able to use rich text formatting
    And I should be able to insert images
    And I should be able to insert links

  @edit @wysiwyg
  Scenario: Use WYSIWYG editor
    Given I am editing a notification template
    When I use the WYSIWYG editor
    Then I should see formatting toolbar
    And I should be able to apply bold and italic
    And I should be able to add lists
    And I should be able to add headings
    And I should be able to add tables
    And I should see real-time preview

  @edit @html
  Scenario: Edit template HTML directly
    Given I am editing a notification template
    When I switch to HTML mode
    Then I should see the raw HTML content
    And I should have syntax highlighting
    And I should be able to edit HTML directly
    And I should see validation warnings
    And I should be able to switch back to WYSIWYG

  @edit @save
  Scenario: Save template changes
    Given I have made changes to a template
    When I save the template
    Then the changes should be saved
    And I should see a success confirmation
    And the last modified date should update
    And the change should be audit logged
    And I should see version history updated

  @edit @validation
  Scenario: Validate template before saving
    Given I have made changes to a template
    When I attempt to save
    Then the template should be validated
    And I should see any validation errors
    And I should see missing variable warnings
    And I should see broken link warnings
    And I should fix issues before saving

  @edit @draft
  Scenario: Save template as draft
    Given I am editing a notification template
    When I click "Save as Draft"
    Then the template should be saved as draft
    And the draft should not be active
    And I should be able to continue editing later
    And I should see draft indicator
    And I should be able to publish when ready

  # ===========================================
  # TEMPLATE TRANSLATIONS
  # ===========================================

  @translations @manage
  Scenario: Manage template translations
    Given I am viewing a template's details
    When I navigate to translations
    Then I should see available languages
    And I should see translation status per language
    And I should see missing translations highlighted
    And I should be able to add new translations

  @translations @view
  Scenario: View translation status
    Given I am managing template translations
    When I view translation status
    Then I should see which languages are complete
    And I should see which languages are pending
    And I should see translation coverage percentage
    And I should see last translation update dates
    And I should see translation quality indicators

  @translations @add
  Scenario: Add new translation
    Given I am managing template translations
    When I click "Add Translation"
    Then I should select the target language
    And I should see the original content
    And I should have a translation editor
    And I should be able to use machine translation
    And I should be able to save the translation

  @translations @edit
  Scenario: Edit existing translation
    Given I am managing template translations
    And a translation exists
    When I edit a translation
    Then I should see the original content for reference
    And I should be able to modify the translation
    And I should see translation memory suggestions
    And I should be able to flag for review
    And I should save the updated translation

  @translations @sync
  Scenario: Sync translations with original
    Given the original template has been updated
    When I sync translations
    Then I should see which translations need updates
    And I should see what changed in the original
    And I should be able to update translations
    And I should be able to mark as reviewed
    And outdated translations should be flagged

  @translations @import
  Scenario: Import translations from file
    Given I am managing template translations
    When I import translations
    Then I should be able to upload a translation file
    And I should see import preview
    And I should see validation results
    And I should be able to confirm import
    And translations should be applied

  # ===========================================
  # TEMPLATE VARIABLES
  # ===========================================

  @variables @configure
  Scenario: Configure template variables
    Given I am editing a notification template
    When I navigate to variable configuration
    Then I should see available variables
    And I should see variable categories
    And I should see variable descriptions
    And I should be able to insert variables

  @variables @list
  Scenario: View available variables
    Given I am configuring template variables
    When I view the variable list
    Then I should see user variables
    And I should see system variables
    And I should see custom variables
    And I should see variable data types
    And I should see example values

  @variables @insert
  Scenario: Insert variable into template
    Given I am editing a notification template
    When I insert a variable
    Then I should see variable picker
    And I should be able to search variables
    And I should be able to select a variable
    And the variable should be inserted at cursor
    And I should see variable placeholder

  @variables @format
  Scenario: Format variable output
    Given I am inserting a variable
    When I configure variable formatting
    Then I should be able to set date format
    And I should be able to set number format
    And I should be able to set text case
    And I should be able to set default value
    And I should see formatted preview

  @variables @fallback
  Scenario: Configure variable fallbacks
    Given I am configuring a variable
    When I set fallback values
    Then I should provide fallback for missing data
    And I should set conditional display rules
    And I should handle null values gracefully
    And I should see fallback preview

  @variables @custom
  Scenario: Create custom variable
    Given I am configuring template variables
    When I create a custom variable
    Then I should define variable name
    And I should define variable source
    And I should define variable type
    And I should set validation rules
    And the variable should be available for use

  # ===========================================
  # TEST NOTIFICATION TEMPLATE
  # ===========================================

  @test @template
  Scenario: Test notification template
    Given I am viewing a template's details
    When I click on "Test Template"
    Then I should see the test dialog
    And I should see test recipient options
    And I should see sample data configuration
    And I should see channel selection
    And I should be able to send test

  @test @recipient
  Scenario: Configure test recipient
    Given I am testing a notification template
    When I configure the recipient
    Then I should be able to send to myself
    And I should be able to enter custom email
    And I should be able to enter custom phone
    And I should be able to select test users
    And I should see recipient validation

  @test @data
  Scenario: Configure test data
    Given I am testing a notification template
    When I configure test data
    Then I should see required variables
    And I should be able to use sample data
    And I should be able to enter custom values
    And I should be able to load real user data
    And I should see data validation

  @test @send
  Scenario: Send test notification
    Given I have configured test settings
    When I send the test notification
    Then the notification should be sent
    And I should see sending confirmation
    And I should see delivery status
    And I should be able to view the sent content
    And test sends should be logged

  @test @preview
  Scenario: Preview before sending test
    Given I am testing a notification template
    When I preview the test
    Then I should see exactly what will be sent
    And I should see all variables populated
    And I should see the final rendered content
    And I should confirm before sending

  # ===========================================
  # A/B TESTING
  # ===========================================

  @ab-test @configure
  Scenario: Configure A/B test for template
    Given I am viewing a template's details
    And I have A/B testing permissions
    When I click on "Create A/B Test"
    Then I should see the A/B test configuration
    And I should see variant creation options
    And I should see audience configuration
    And I should see success metrics selection

  @ab-test @variants
  Scenario: Create test variants
    Given I am configuring an A/B test
    When I create test variants
    Then I should be able to create variant A
    And I should be able to create variant B
    And I should be able to create additional variants
    And I should set traffic allocation per variant
    And I should see variant preview

  @ab-test @elements
  Scenario: Configure variant elements
    Given I am creating A/B test variants
    When I configure variant differences
    Then I should be able to vary subject line
    And I should be able to vary body content
    And I should be able to vary call-to-action
    And I should be able to vary send time
    And I should be able to vary from name

  @ab-test @audience
  Scenario: Configure test audience
    Given I am configuring an A/B test
    When I configure the test audience
    Then I should be able to set sample size
    And I should be able to set audience segments
    And I should be able to set exclusion rules
    And I should see estimated audience size
    And I should see statistical power preview

  @ab-test @metrics
  Scenario: Select success metrics
    Given I am configuring an A/B test
    When I select success metrics
    Then I should be able to select open rate
    And I should be able to select click rate
    And I should be able to select conversion rate
    And I should be able to set primary metric
    And I should see metric definitions

  @ab-test @launch
  Scenario: Launch A/B test
    Given I have configured an A/B test
    When I launch the test
    Then the test should start
    And I should see test status
    And I should see variant distribution
    And I should see real-time results
    And I should be able to pause if needed

  # ===========================================
  # A/B TEST RESULTS
  # ===========================================

  @ab-test @results
  Scenario: View A/B test results
    Given an A/B test is running or complete
    When I view test results
    Then I should see the results dashboard
    And I should see performance by variant
    And I should see statistical significance
    And I should see winning variant
    And I should see confidence level

  @ab-test @comparison
  Scenario: Compare variant performance
    Given I am viewing A/B test results
    When I compare variants
    Then I should see side-by-side comparison
    And I should see open rate comparison
    And I should see click rate comparison
    And I should see conversion comparison
    And I should see lift percentage

  @ab-test @significance
  Scenario: View statistical significance
    Given I am viewing A/B test results
    When I view significance analysis
    Then I should see p-value
    And I should see confidence interval
    And I should see sample size achieved
    And I should see time to significance
    And I should see recommendation

  @ab-test @winner
  Scenario: Declare test winner
    Given an A/B test has reached significance
    When I declare a winner
    Then I should select the winning variant
    And I should confirm the selection
    And the winner should become the active template
    And losing variants should be archived
    And the action should be logged

  @ab-test @report
  Scenario: Generate A/B test report
    Given an A/B test is complete
    When I generate a report
    Then I should see comprehensive results
    And I should see methodology details
    And I should see variant content
    And I should see statistical analysis
    And I should be able to export the report

  # ===========================================
  # NOTIFICATION CHANNELS
  # ===========================================

  @channels @configure
  Scenario: Configure notification channels
    Given I am editing a notification template
    When I navigate to channel configuration
    Then I should see available channels
    And I should see channel-specific settings
    And I should be able to enable/disable channels
    And I should see channel preview

  @channels @email
  Scenario: Configure email channel
    Given I am configuring channels for a template
    When I configure the email channel
    Then I should set the from address
    And I should set the reply-to address
    And I should configure email headers
    And I should set tracking options
    And I should configure attachments

  @channels @push
  Scenario: Configure push notification channel
    Given I am configuring channels for a template
    When I configure push notifications
    Then I should set the notification title
    And I should set the notification body
    And I should set the icon
    And I should set action buttons
    And I should set deep link destination

  @channels @sms
  Scenario: Configure SMS channel
    Given I am configuring channels for a template
    When I configure the SMS channel
    Then I should set the message content
    And I should see character count
    And I should see segment count
    And I should configure sender ID
    And I should set opt-out instructions

  @channels @inapp
  Scenario: Configure in-app notification channel
    Given I am configuring channels for a template
    When I configure in-app notifications
    Then I should set notification type
    And I should set notification priority
    And I should set display duration
    And I should set action configuration
    And I should set dismissal behavior

  @channels @priority
  Scenario: Set channel priority
    Given I am configuring multiple channels
    When I set channel priorities
    Then I should order channels by preference
    And I should set fallback rules
    And I should configure delivery timing
    And I should set channel-specific conditions

  # ===========================================
  # TEMPLATE PERFORMANCE
  # ===========================================

  @performance @view
  Scenario: View template performance
    Given I am viewing a template's details
    When I navigate to performance metrics
    Then I should see the performance dashboard
    And I should see delivery metrics
    And I should see engagement metrics
    And I should see conversion metrics
    And I should see trend analysis

  @performance @delivery
  Scenario: View delivery metrics
    Given I am viewing template performance
    When I view delivery metrics
    Then I should see total sends
    And I should see delivery rate
    And I should see bounce rate
    And I should see spam complaint rate
    And I should see delivery by channel

  @performance @engagement
  Scenario: View engagement metrics
    Given I am viewing template performance
    When I view engagement metrics
    Then I should see open rate
    And I should see click rate
    And I should see unique clicks
    And I should see click-to-open rate
    And I should see engagement by device

  @performance @conversion
  Scenario: View conversion metrics
    Given I am viewing template performance
    When I view conversion metrics
    Then I should see conversion rate
    And I should see revenue attributed
    And I should see conversion by segment
    And I should see conversion funnel
    And I should see time to conversion

  @performance @trends
  Scenario: Analyze performance trends
    Given I am viewing template performance
    When I analyze trends
    Then I should see performance over time
    And I should see comparison to benchmarks
    And I should see seasonal patterns
    And I should see improvement opportunities
    And I should see historical comparison

  @performance @compare
  Scenario: Compare template performance
    Given I am viewing template performance
    When I compare with other templates
    Then I should see side-by-side comparison
    And I should see relative performance
    And I should see best practices alignment
    And I should see recommendation for improvement

  # ===========================================
  # SCHEDULE TEMPLATE SENDS
  # ===========================================

  @schedule @sends
  Scenario: Schedule template sends
    Given I am viewing a template's details
    When I navigate to scheduling
    Then I should see scheduling options
    And I should see existing schedules
    And I should see schedule calendar
    And I should be able to create new schedule

  @schedule @create
  Scenario: Create scheduled send
    Given I am scheduling a template send
    When I create a new schedule
    Then I should set the send date and time
    And I should select the target audience
    And I should configure send options
    And I should set timezone handling
    And I should confirm the schedule

  @schedule @recurring
  Scenario: Set up recurring schedule
    Given I am scheduling a template send
    When I configure recurring schedule
    Then I should set recurrence pattern
    And I should set recurrence end date
    And I should set send time
    And I should handle timezone differences
    And I should see scheduled occurrences

  @schedule @audience
  Scenario: Configure scheduled audience
    Given I am scheduling a template send
    When I configure the audience
    Then I should select audience segments
    And I should set inclusion criteria
    And I should set exclusion criteria
    And I should see estimated audience size
    And I should validate the audience

  @schedule @manage
  Scenario: Manage scheduled sends
    Given there are scheduled sends
    When I manage schedules
    Then I should see all scheduled sends
    And I should be able to pause schedules
    And I should be able to cancel schedules
    And I should be able to modify schedules
    And I should see schedule status

  @schedule @optimize
  Scenario: Optimize send timing
    Given I am scheduling a template send
    When I use send time optimization
    Then I should see recommended send times
    And I should see optimal times by segment
    And I should see timezone-based optimization
    And I should be able to enable AI optimization
    And I should see expected improvement

  # ===========================================
  # TEMPLATE COMPLIANCE
  # ===========================================

  @compliance @ensure
  Scenario: Ensure template compliance
    Given I am editing a notification template
    When I check compliance status
    Then I should see compliance requirements
    And I should see current compliance status
    And I should see any compliance violations
    And I should see remediation suggestions

  @compliance @check
  Scenario: Run compliance check
    Given I am editing a notification template
    When I run a compliance check
    Then I should check for required elements
    And I should check for prohibited content
    And I should check for accessibility
    And I should check for legal requirements
    And I should see compliance score

  @compliance @unsubscribe
  Scenario: Verify unsubscribe compliance
    Given I am checking template compliance
    When I verify unsubscribe requirements
    Then I should check for unsubscribe link
    And I should check link visibility
    And I should check link functionality
    And I should check one-click unsubscribe
    And I should see compliance status

  @compliance @gdpr
  Scenario: Verify GDPR compliance
    Given I am checking template compliance
    When I verify GDPR requirements
    Then I should check for data collection notice
    And I should check for consent language
    And I should check for privacy policy link
    And I should check for data rights information
    And I should see GDPR compliance status

  @compliance @accessibility
  Scenario: Check accessibility compliance
    Given I am checking template compliance
    When I verify accessibility
    Then I should check for alt text on images
    And I should check for color contrast
    And I should check for screen reader compatibility
    And I should check for font size requirements
    And I should see accessibility score

  @compliance @approval
  Scenario: Submit template for compliance approval
    Given a template requires compliance review
    When I submit for approval
    Then the template should enter review queue
    And I should see the assigned reviewer
    And I should see expected review time
    And I should receive notification on decision
    And I should be able to track status

  # ===========================================
  # TEMPLATE VERSIONS
  # ===========================================

  @versions @manage
  Scenario: Manage template versions
    Given I am viewing a template's details
    When I navigate to version history
    Then I should see all template versions
    And I should see version timestamps
    And I should see version authors
    And I should see change summaries
    And I should be able to compare versions

  @versions @view
  Scenario: View version details
    Given I am viewing version history
    When I click on a specific version
    Then I should see the version content
    And I should see what changed from previous
    And I should see version metadata
    And I should be able to preview this version
    And I should be able to restore this version

  @versions @compare
  Scenario: Compare template versions
    Given I am viewing version history
    When I compare two versions
    Then I should see side-by-side comparison
    And I should see highlighted differences
    And I should see additions and deletions
    And I should see change statistics
    And I should understand the evolution

  @versions @restore
  Scenario: Restore previous version
    Given I am viewing a previous version
    When I click "Restore This Version"
    Then I should confirm the restoration
    And the version should be restored
    And it should become the current version
    And a new version entry should be created
    And the restoration should be logged

  @versions @branching
  Scenario: Create version branch
    Given I am viewing a template version
    When I create a branch
    Then I should name the branch
    And the branch should be created
    And I should be able to edit independently
    And I should be able to merge later
    And I should see branch relationship

  # ===========================================
  # DYNAMIC CONTENT BLOCKS
  # ===========================================

  @dynamic @blocks
  Scenario: Configure dynamic content blocks
    Given I am editing a notification template
    When I configure dynamic content
    Then I should see dynamic block options
    And I should see existing dynamic blocks
    And I should be able to add new blocks
    And I should see block preview

  @dynamic @create
  Scenario: Create dynamic content block
    Given I am configuring dynamic content
    When I create a new dynamic block
    Then I should name the block
    And I should define content variants
    And I should set display conditions
    And I should set default content
    And I should save the block

  @dynamic @conditions
  Scenario: Set content display conditions
    Given I am creating a dynamic block
    When I set display conditions
    Then I should be able to use user attributes
    And I should be able to use behavioral data
    And I should be able to use segment membership
    And I should be able to combine conditions
    And I should see condition logic preview

  @dynamic @variants
  Scenario: Create content variants
    Given I am creating a dynamic block
    When I create content variants
    Then I should add multiple variants
    And each variant should have conditions
    And each variant should have content
    And I should set variant priority
    And I should test variant selection

  @dynamic @personalization
  Scenario: Add personalization to blocks
    Given I am editing a dynamic block
    When I add personalization
    Then I should insert user variables
    And I should insert recommendation data
    And I should insert real-time data
    And I should see personalization preview
    And I should set fallback content

  @dynamic @test
  Scenario: Test dynamic content
    Given I have configured dynamic content
    When I test the dynamic content
    Then I should select test user profiles
    And I should see which variants display
    And I should verify condition logic
    And I should see all possible variations
    And I should validate content completeness

  # ===========================================
  # TEMPLATE CATEGORIES
  # ===========================================

  @categories @manage
  Scenario: Manage template categories
    Given I am on the notification templates section
    When I navigate to category management
    Then I should see existing categories
    And I should see templates per category
    And I should be able to create categories
    And I should be able to organize categories

  @categories @create
  Scenario: Create template category
    Given I am managing categories
    When I create a new category
    Then I should name the category
    And I should set category description
    And I should set category icon
    And I should set category permissions
    And the category should be created

  @categories @organize
  Scenario: Organize templates into categories
    Given I am managing categories
    When I organize templates
    Then I should be able to drag templates
    And I should be able to assign categories
    And I should be able to move between categories
    And I should see category counts update
    And organization should be saved

  @categories @hierarchy
  Scenario: Create category hierarchy
    Given I am managing categories
    When I create subcategories
    Then I should be able to nest categories
    And I should see the hierarchy tree
    And I should be able to expand/collapse
    And templates should inherit from parent
    And I should be able to reorganize hierarchy

  @categories @permissions
  Scenario: Set category permissions
    Given I am managing a category
    When I configure permissions
    Then I should set who can view
    And I should set who can edit
    And I should set who can create templates
    And I should set who can delete
    And permissions should be enforced

  # ===========================================
  # EMERGENCY NOTIFICATIONS
  # ===========================================

  @emergency @send
  Scenario: Send emergency notification
    Given I am on the notification templates section
    And I have emergency notification permissions
    When I click "Emergency Notification"
    Then I should see the emergency notification interface
    And I should see pre-approved templates
    And I should see urgent delivery options
    And I should see confirmation requirements

  @emergency @compose
  Scenario: Compose emergency notification
    Given I am sending an emergency notification
    When I compose the message
    Then I should select an emergency template
    And I should customize the message
    And I should select affected audience
    And I should see delivery preview
    And I should see approval workflow

  @emergency @approve
  Scenario: Approve emergency notification
    Given an emergency notification requires approval
    When I review the notification
    Then I should see the message content
    And I should see the target audience
    And I should verify the urgency
    And I should approve or reject
    And the decision should be logged

  @emergency @deliver
  Scenario: Deliver emergency notification
    Given an emergency notification is approved
    When the notification is sent
    Then it should bypass normal queues
    And it should use priority delivery
    And it should go through all channels
    And delivery should be tracked in real-time
    And I should see delivery confirmation

  @emergency @tracking
  Scenario: Track emergency notification delivery
    Given an emergency notification was sent
    When I track delivery
    Then I should see real-time delivery status
    And I should see delivery by channel
    And I should see read confirmations
    And I should see any delivery failures
    And I should be able to retry failures

  # ===========================================
  # EXPORT TEMPLATES
  # ===========================================

  @export @templates
  Scenario: Export templates
    Given I am on the notification templates section
    When I click "Export Templates"
    Then I should see export options
    And I should be able to select templates
    And I should choose export format
    And I should configure export settings

  @export @select
  Scenario: Select templates for export
    Given I am exporting templates
    When I select templates
    Then I should be able to select individual templates
    And I should be able to select by category
    And I should be able to select all templates
    And I should see selected count
    And I should see estimated export size

  @export @format
  Scenario: Choose export format
    Given I am exporting templates
    When I select export format
    Then I should be able to export as JSON
    And I should be able to export as XML
    And I should be able to export as ZIP archive
    And I should see format descriptions
    And I should see compatibility notes

  @export @options
  Scenario: Configure export options
    Given I am exporting templates
    When I configure options
    Then I should be able to include translations
    And I should be able to include versions
    And I should be able to include analytics data
    And I should be able to include images
    And I should see what will be included

  @export @execute
  Scenario: Execute template export
    Given I have configured export settings
    When I execute the export
    Then the export should be generated
    And I should see export progress
    And I should be able to download the export
    And the export should be audit logged
    And I should receive completion notification

  # ===========================================
  # IMPORT TEMPLATES
  # ===========================================

  @import @templates
  Scenario: Import templates
    Given I am on the notification templates section
    When I click "Import Templates"
    Then I should see the import interface
    And I should see supported formats
    And I should see import guidelines
    And I should be able to upload files

  @import @upload
  Scenario: Upload template file
    Given I am importing templates
    When I upload a template file
    Then the file should be validated
    And I should see file contents preview
    And I should see validation results
    And I should see any warnings or errors
    And I should be able to proceed or cancel

  @import @preview
  Scenario: Preview import contents
    Given I have uploaded a template file
    When I preview the import
    Then I should see templates to be imported
    And I should see existing template conflicts
    And I should see translation content
    And I should see image references
    And I should configure conflict resolution

  @import @conflicts
  Scenario: Resolve import conflicts
    Given there are import conflicts
    When I resolve conflicts
    Then I should choose to skip duplicates
    Or I should choose to overwrite existing
    Or I should choose to create new versions
    Or I should choose to merge content
    And I should see resolution preview

  @import @execute
  Scenario: Execute template import
    Given I have resolved all import issues
    When I execute the import
    Then templates should be imported
    And I should see import progress
    And I should see success and failure counts
    And I should see imported template list
    And the import should be audit logged

  # ===========================================
  # ERROR HANDLING AND EDGE CASES
  # ===========================================

  @error-handling @save-failed
  Scenario: Handle template save failure
    Given I am editing a notification template
    When the save operation fails
    Then I should see an error message
    And I should see the failure reason
    And my changes should be preserved
    And I should be able to retry
    And I should be able to save as draft

  @error-handling @test-failed
  Scenario: Handle test send failure
    Given I am testing a notification template
    When the test send fails
    Then I should see failure notification
    And I should see the failure reason
    And I should see troubleshooting steps
    And I should be able to retry
    And the failure should be logged

  @error-handling @variable-missing
  Scenario: Handle missing variables
    Given I am previewing a template
    When required variables are missing
    Then I should see missing variable warnings
    And I should see which variables are missing
    And I should see fallback content if configured
    And I should be able to provide values
    And I should see updated preview

  @error-handling @channel-unavailable
  Scenario: Handle unavailable channel
    Given I am sending a notification
    When a channel is unavailable
    Then I should see channel status
    And I should see fallback channel options
    And I should be able to skip the channel
    And the issue should be logged
    And I should be notified when restored

  @edge-case @large-template
  Scenario: Handle large template content
    Given I am creating a template with large content
    When the content exceeds size limits
    Then I should see size warning
    And I should see content size metrics
    And I should see optimization suggestions
    And I should be guided to reduce size
    And I should see channel-specific limits

  @edge-case @special-characters
  Scenario: Handle special characters in content
    Given I am editing template content
    When I include special characters
    Then characters should be properly encoded
    And I should see character rendering preview
    And I should see compatibility warnings
    And emojis should display correctly
    And HTML entities should be handled

  @edge-case @concurrent-edit
  Scenario: Handle concurrent template editing
    Given another user is editing the same template
    When I attempt to edit
    Then I should see a concurrent edit warning
    And I should see who is editing
    And I should be able to view read-only
    And I should be able to request edit access
    And I should be notified when available

  @edge-case @broken-images
  Scenario: Handle broken image references
    Given a template has image references
    When images are not accessible
    Then I should see broken image indicators
    And I should see which images are affected
    And I should be able to replace images
    And I should see alt text display
    And I should be warned before sending
