@admin @users @management @security @MVP-ADMIN
Feature: Admin User Management
  As a platform administrator
  I want to manage user accounts and permissions
  So that I can maintain platform security and user satisfaction

  Background:
    Given I am logged in as a platform administrator
    And I have user management permissions
    And the user management system is operational

  # ===========================================
  # USER SEARCH AND LISTING
  # ===========================================

  @search @users
  Scenario: Search for users
    Given I am on the admin dashboard
    When I navigate to the user management section
    Then I should see the user search interface
    And I should see a search input field
    And I should see advanced search options
    And I should see recent search history

  @search @basic
  Scenario: Perform basic user search
    Given I am on the user management section
    When I enter a search term in the search field
    Then I should see matching user results
    And results should show user name
    And results should show user email
    And results should show account status
    And results should show registration date
    And I should see the total match count

  @search @email
  Scenario: Search users by email
    Given I am on the user management section
    When I search for a user by email address
    Then I should find the exact email match
    And I should see partial email matches
    And I should see email verification status
    And I should be able to click to view user details

  @search @id
  Scenario: Search users by ID
    Given I am on the user management section
    When I search for a user by user ID
    Then I should find the exact user
    And I should see the user's profile summary
    And I should see quick action buttons
    And I should be able to view full profile

  @search @phone
  Scenario: Search users by phone number
    Given I am on the user management section
    When I search for a user by phone number
    Then I should find users with matching phone
    And I should see phone verification status
    And I should see associated accounts
    And partial matches should be displayed

  @search @advanced
  Scenario: Perform advanced user search
    Given I am on the user management section
    When I click on advanced search
    Then I should see advanced search options
    And I should be able to search by name
    And I should be able to search by location
    And I should be able to search by registration date range
    And I should be able to search by last activity date
    And I should be able to combine multiple criteria

  # ===========================================
  # USER LIST WITH FILTERS
  # ===========================================

  @list @filters
  Scenario: View user list with filters
    Given I am on the user management section
    When I view the user list
    Then I should see a paginated list of users
    And I should see filter options
    And I should see sorting options
    And I should see column customization
    And I should see bulk action options

  @list @status-filter
  Scenario: Filter users by account status
    Given I am viewing the user list
    When I filter by account status
    Then I should be able to filter by active users
    And I should be able to filter by suspended users
    And I should be able to filter by pending verification
    And I should be able to filter by deleted users
    And the list should update accordingly

  @list @role-filter
  Scenario: Filter users by role
    Given I am viewing the user list
    When I filter by user role
    Then I should see available role options
    And I should be able to select multiple roles
    And I should see user count per role
    And the list should show matching users

  @list @date-filter
  Scenario: Filter users by date range
    Given I am viewing the user list
    When I filter by date range
    Then I should be able to filter by registration date
    And I should be able to filter by last login date
    And I should be able to filter by last activity date
    And I should be able to use preset date ranges
    And I should be able to set custom date ranges

  @list @activity-filter
  Scenario: Filter users by activity level
    Given I am viewing the user list
    When I filter by activity level
    Then I should be able to filter by active users
    And I should be able to filter by inactive users
    And I should be able to filter by dormant users
    And I should be able to set inactivity thresholds

  @list @sorting
  Scenario: Sort user list
    Given I am viewing the user list
    When I apply sorting options
    Then I should be able to sort by name
    And I should be able to sort by registration date
    And I should be able to sort by last activity
    And I should be able to sort by status
    And I should be able to toggle ascending/descending

  @list @columns
  Scenario: Customize user list columns
    Given I am viewing the user list
    When I customize the displayed columns
    Then I should see available column options
    And I should be able to add or remove columns
    And I should be able to reorder columns
    And my column preferences should be saved
    And I should be able to reset to default

  @list @export
  Scenario: Export user list
    Given I am viewing a filtered user list
    When I click on export
    Then I should see export format options
    And I should be able to export to CSV
    And I should be able to export to Excel
    And I should be able to select columns to export
    And the export should be audit logged

  # ===========================================
  # DETAILED USER PROFILE
  # ===========================================

  @profile @view
  Scenario: View detailed user profile
    Given I am on the user management section
    And I have found a user
    When I click on the user to view details
    Then I should see the detailed user profile
    And I should see account information section
    And I should see personal information section
    And I should see activity summary section
    And I should see security information section
    And I should see action buttons

  @profile @account
  Scenario: View user account information
    Given I am viewing a user's detailed profile
    When I view the account information section
    Then I should see the user ID
    And I should see the account creation date
    And I should see the account status
    And I should see the email address and verification status
    And I should see the phone number and verification status
    And I should see linked accounts

  @profile @personal
  Scenario: View user personal information
    Given I am viewing a user's detailed profile
    When I view the personal information section
    Then I should see the user's full name
    And I should see the user's profile picture
    And I should see the user's bio
    And I should see the user's location
    And I should see the user's preferences
    And sensitive data should be appropriately masked

  @profile @activity
  Scenario: View user activity summary
    Given I am viewing a user's detailed profile
    When I view the activity summary section
    Then I should see the last login date and time
    And I should see login frequency statistics
    And I should see feature usage summary
    And I should see content engagement metrics
    And I should see transaction summary
    And I should see recent activity timeline

  @profile @security
  Scenario: View user security information
    Given I am viewing a user's detailed profile
    When I view the security information section
    Then I should see password last changed date
    And I should see MFA status and methods
    And I should see active sessions count
    And I should see recent security events
    And I should see failed login attempts
    And I should see security recommendations

  @profile @subscriptions
  Scenario: View user subscription information
    Given I am viewing a user's detailed profile
    When I view the subscription section
    Then I should see current subscription plan
    And I should see subscription start date
    And I should see billing cycle information
    And I should see payment method on file
    And I should see subscription history
    And I should see any pending changes

  # ===========================================
  # EDIT USER INFORMATION
  # ===========================================

  @edit @information
  Scenario: Edit user information
    Given I am viewing a user's detailed profile
    And I have user edit permissions
    When I click on "Edit User"
    Then I should see the edit user form
    And I should see editable fields
    And I should see non-editable fields grayed out
    And I should see field validation rules
    And I should be required to provide a reason

  @edit @personal-info
  Scenario: Edit user personal information
    Given I am editing a user's information
    When I modify personal information fields
    Then I should be able to edit the name
    And I should be able to edit the email
    And I should be able to edit the phone number
    And I should be able to edit the address
    And I should see validation for each field

  @edit @email
  Scenario: Change user email address
    Given I am editing a user's information
    When I change the user's email address
    Then I should be warned about verification implications
    And I should have option to send verification email
    And I should have option to mark as verified
    And I should provide a reason for the change
    And the change should be audit logged

  @edit @validate
  Scenario: Validate user information changes
    Given I have made changes to user information
    When I review the changes
    Then I should see a preview of changes
    And I should see old values and new values
    And I should see any validation warnings
    And I should confirm the changes
    And I should see the change confirmation

  @edit @save
  Scenario: Save user information changes
    Given I have validated user information changes
    When I save the changes
    Then the changes should be applied
    And I should see a success confirmation
    And the user should receive a notification
    And the changes should be audit logged
    And I should see the updated profile

  @edit @history
  Scenario: View user edit history
    Given I am viewing a user's detailed profile
    When I view the edit history
    Then I should see all past modifications
    And I should see who made each change
    And I should see when changes were made
    And I should see change reasons
    And I should see before and after values

  # ===========================================
  # SUSPEND USER ACCOUNT
  # ===========================================

  @suspend @account
  Scenario: Suspend user account
    Given I am viewing a user's detailed profile
    And the user account is active
    When I click on "Suspend Account"
    Then I should see the suspension dialog
    And I should see suspension reason options
    And I should see suspension duration options
    And I should see impact information
    And I should be required to confirm

  @suspend @reason
  Scenario: Provide suspension reason
    Given I am suspending a user account
    When I provide suspension details
    Then I should select a suspension reason category
    And I should be able to add detailed notes
    And I should link to related tickets or incidents
    And I should specify if user should be notified
    And I should specify the suspension type

  @suspend @duration
  Scenario: Set suspension duration
    Given I am suspending a user account
    When I set the suspension duration
    Then I should be able to set indefinite suspension
    And I should be able to set timed suspension
    And I should be able to set a review date
    And I should see the calculated end date
    And I should see auto-reactivation options

  @suspend @confirm
  Scenario: Confirm account suspension
    Given I have configured suspension settings
    When I confirm the suspension
    Then the account should be suspended
    And all active sessions should be terminated
    And the user should receive notification if configured
    And the suspension should be audit logged
    And I should see the suspended status

  @suspend @effects
  Scenario: View suspension effects
    Given a user account has been suspended
    When I view the account status
    Then I should see the suspension reason
    And I should see the suspension date
    And I should see the suspending administrator
    And I should see the expected end date
    And I should see affected features

  # ===========================================
  # REACTIVATE SUSPENDED ACCOUNT
  # ===========================================

  @reactivate @account
  Scenario: Reactivate suspended account
    Given I am viewing a suspended user's profile
    When I click on "Reactivate Account"
    Then I should see the reactivation dialog
    And I should see the suspension history
    And I should be required to provide a reason
    And I should see any conditions for reactivation

  @reactivate @review
  Scenario: Review suspension before reactivation
    Given I am reactivating a suspended account
    When I review the suspension details
    Then I should see the original suspension reason
    And I should see the suspension duration
    And I should see any related incidents
    And I should see user communications during suspension
    And I should see resolution status

  @reactivate @conditions
  Scenario: Set reactivation conditions
    Given I am reactivating a suspended account
    When I configure reactivation conditions
    Then I should be able to require password reset
    And I should be able to require agreement acceptance
    And I should be able to set probation period
    And I should be able to limit certain features
    And I should be able to require identity verification

  @reactivate @confirm
  Scenario: Confirm account reactivation
    Given I have configured reactivation settings
    When I confirm the reactivation
    Then the account should be reactivated
    And the user should receive notification
    And the reactivation should be audit logged
    And any conditions should be applied
    And I should see the active status

  # ===========================================
  # DELETE USER ACCOUNT
  # ===========================================

  @delete @account
  Scenario: Delete user account
    Given I am viewing a user's detailed profile
    And I have account deletion permissions
    When I click on "Delete Account"
    Then I should see the deletion dialog
    And I should see deletion impact warnings
    And I should see data retention information
    And I should be required to provide justification
    And I should see approval requirements

  @delete @impact
  Scenario: View deletion impact
    Given I am deleting a user account
    When I view the deletion impact
    Then I should see data that will be deleted
    And I should see data that will be retained
    And I should see affected related accounts
    And I should see financial implications
    And I should see legal considerations

  @delete @types
  Scenario: Select deletion type
    Given I am deleting a user account
    When I select the deletion type
    Then I should be able to select soft delete
    And I should be able to select hard delete
    And I should see the difference between types
    And I should see data recovery options
    And I should see retention period information

  @delete @approval
  Scenario: Request deletion approval
    Given I am deleting a user account
    And the deletion requires approval
    When I submit the deletion request
    Then the request should be sent for approval
    And I should see the approval workflow
    And I should see the approvers
    And I should receive notification when approved
    And the account should remain active pending approval

  @delete @execute
  Scenario: Execute account deletion
    Given account deletion has been approved
    When the deletion is executed
    Then the account should be marked as deleted
    And user data should be handled per policy
    And the user should receive final notification
    And the deletion should be audit logged
    And recovery should be possible within retention period

  @delete @recover
  Scenario: Recover deleted account
    Given an account was recently deleted
    And the recovery period has not expired
    When I initiate account recovery
    Then I should provide recovery justification
    And the account should be restored
    And the user should be notified
    And the recovery should be audit logged

  # ===========================================
  # MANAGE USER ROLES
  # ===========================================

  @roles @manage
  Scenario: Manage user roles
    Given I am viewing a user's detailed profile
    When I click on "Manage Roles"
    Then I should see the role management interface
    And I should see current assigned roles
    And I should see available roles
    And I should see role descriptions
    And I should see role permissions summary

  @roles @view
  Scenario: View user's current roles
    Given I am managing user roles
    When I view current roles
    Then I should see all assigned roles
    And I should see when each role was assigned
    And I should see who assigned each role
    And I should see role expiration dates if any
    And I should see inherited roles

  @roles @assign
  Scenario: Assign role to user
    Given I am managing user roles
    When I assign a new role to the user
    Then I should select from available roles
    And I should provide assignment reason
    And I should optionally set expiration date
    And the role should be assigned
    And the user should receive notification

  @roles @remove
  Scenario: Remove role from user
    Given I am managing user roles
    And the user has assigned roles
    When I remove a role from the user
    Then I should provide removal reason
    And I should confirm the removal
    And the role should be removed
    And the user should receive notification
    And the removal should be audit logged

  @roles @hierarchy
  Scenario: View role hierarchy and inheritance
    Given I am managing user roles
    When I view role hierarchy
    Then I should see the role inheritance tree
    And I should see parent and child roles
    And I should see inherited permissions
    And I should understand permission accumulation

  @roles @conflicts
  Scenario: Handle role conflicts
    Given I am assigning a role to a user
    When the role conflicts with existing roles
    Then I should see a conflict warning
    And I should see which roles conflict
    And I should see how to resolve the conflict
    And I should choose to proceed or cancel

  # ===========================================
  # CUSTOM PERMISSIONS
  # ===========================================

  @permissions @custom
  Scenario: Set custom permissions
    Given I am viewing a user's detailed profile
    When I click on "Custom Permissions"
    Then I should see the permission management interface
    And I should see current permissions
    And I should see permission categories
    And I should see permission inheritance
    And I should see custom overrides

  @permissions @view
  Scenario: View user's effective permissions
    Given I am managing user permissions
    When I view effective permissions
    Then I should see all permissions the user has
    And I should see the source of each permission
    And I should see role-based permissions
    And I should see custom permission overrides
    And I should see permission conflicts

  @permissions @grant
  Scenario: Grant custom permission
    Given I am managing user permissions
    When I grant a custom permission
    Then I should select the permission to grant
    And I should provide grant reason
    And I should optionally set expiration
    And I should confirm the grant
    And the permission should be applied

  @permissions @revoke
  Scenario: Revoke custom permission
    Given I am managing user permissions
    And the user has custom permissions
    When I revoke a custom permission
    Then I should provide revocation reason
    And I should confirm the revocation
    And the permission should be removed
    And the action should be audit logged

  @permissions @scope
  Scenario: Set permission scope
    Given I am granting a custom permission
    When I configure the permission scope
    Then I should be able to set resource scope
    And I should be able to set time scope
    And I should be able to set action scope
    And I should see the effective scope preview

  @permissions @audit
  Scenario: Audit permission changes
    Given I am managing user permissions
    When I view permission audit log
    Then I should see all permission changes
    And I should see who made each change
    And I should see when changes were made
    And I should see change reasons
    And I should be able to filter the audit log

  # ===========================================
  # BULK USER ACTIONS
  # ===========================================

  @bulk @actions
  Scenario: Perform bulk user actions
    Given I am on the user management section
    When I select multiple users
    Then I should see bulk action options
    And I should see the selected user count
    And I should be able to modify selection
    And I should see action compatibility

  @bulk @select
  Scenario: Select users for bulk action
    Given I am on the user list
    When I select users for bulk action
    Then I should be able to select individual users
    And I should be able to select all on page
    And I should be able to select all matching filter
    And I should see the current selection count
    And I should be able to clear selection

  @bulk @suspend
  Scenario: Bulk suspend users
    Given I have selected multiple users
    When I choose bulk suspend action
    Then I should provide suspension reason
    And I should set suspension duration
    And I should preview affected users
    And I should confirm the bulk action
    And all selected users should be suspended

  @bulk @role-assign
  Scenario: Bulk assign roles
    Given I have selected multiple users
    When I choose bulk role assignment
    Then I should select the role to assign
    And I should provide assignment reason
    And I should preview affected users
    And I should confirm the bulk action
    And the role should be assigned to all

  @bulk @message
  Scenario: Bulk send message
    Given I have selected multiple users
    When I choose bulk message action
    Then I should compose the message
    And I should select delivery method
    And I should preview the message
    And I should confirm sending
    And the message should be sent to all

  @bulk @export
  Scenario: Bulk export user data
    Given I have selected multiple users
    When I choose bulk export action
    Then I should select data to export
    And I should choose export format
    And I should configure data handling
    And I should execute the export
    And the export should be processed

  @bulk @progress
  Scenario: Monitor bulk action progress
    Given I have initiated a bulk action
    When the action is processing
    Then I should see progress indicator
    And I should see processed count
    And I should see success and failure counts
    And I should be able to cancel if needed
    And I should receive completion notification

  # ===========================================
  # USER IMPERSONATION
  # ===========================================

  @impersonation @start
  Scenario: Impersonate user account
    Given I am viewing a user's detailed profile
    And I have impersonation permissions
    When I click on "Impersonate User"
    Then I should see the impersonation confirmation
    And I should see the user details
    And I should be required to provide reason
    And I should acknowledge impersonation policies
    And I should confirm to proceed

  @impersonation @reason
  Scenario: Provide impersonation reason
    Given I am initiating impersonation
    When I provide impersonation details
    Then I should select a reason category
    And I should link to a support ticket
    And I should add detailed notes
    And I should acknowledge time limits
    And I should confirm understanding of restrictions

  @impersonation @session
  Scenario: Conduct impersonation session
    Given I have started impersonation
    When I am in impersonation mode
    Then I should see the platform as the user
    And I should see an impersonation indicator
    And I should see a timer showing session duration
    And I should have access to user features
    But I should not have access to sensitive actions

  @impersonation @restrictions
  Scenario: Enforce impersonation restrictions
    Given I am impersonating a user
    When I attempt restricted actions
    Then I should not be able to change password
    And I should not be able to modify security settings
    And I should not be able to make payments
    And I should not be able to delete the account
    And I should see restriction messages

  @impersonation @logging
  Scenario: Log impersonation activities
    Given I am impersonating a user
    When I perform actions as the user
    Then all actions should be logged
    And logs should identify me as the impersonator
    And logs should show the original user
    And logs should capture all details
    And the session should be fully auditable

  # ===========================================
  # EXIT IMPERSONATION
  # ===========================================

  @impersonation @exit
  Scenario: Exit impersonation mode
    Given I am currently impersonating a user
    When I click "Exit Impersonation"
    Then I should see exit confirmation
    And I should see session summary
    And I should confirm the exit
    And I should return to my admin account
    And the session should be logged as complete

  @impersonation @timeout
  Scenario: Handle impersonation timeout
    Given I am impersonating a user
    When the impersonation session times out
    Then I should see timeout warning before expiry
    And I should be able to extend if allowed
    When the session expires
    Then I should be automatically returned to admin
    And the timeout should be logged

  @impersonation @summary
  Scenario: View impersonation session summary
    Given I have ended an impersonation session
    When I view the session summary
    Then I should see session duration
    And I should see actions performed
    And I should see pages visited
    And I should see any issues encountered
    And I should be able to add notes

  # ===========================================
  # SEND MESSAGE TO USER
  # ===========================================

  @message @send
  Scenario: Send message to user
    Given I am viewing a user's detailed profile
    When I click on "Send Message"
    Then I should see the message composer
    And I should see message templates
    And I should see delivery options
    And I should see message preview

  @message @compose
  Scenario: Compose user message
    Given I am composing a message
    When I write the message content
    Then I should be able to format text
    And I should be able to add links
    And I should be able to add attachments
    And I should be able to use personalization tokens
    And I should see character count

  @message @template
  Scenario: Use message template
    Given I am composing a message
    When I select a message template
    Then the template content should load
    And I should see personalization fields
    And I should be able to customize the template
    And I should preview the personalized message

  @message @delivery
  Scenario: Configure message delivery
    Given I have composed a message
    When I configure delivery options
    Then I should be able to send via in-app notification
    And I should be able to send via email
    And I should be able to send via SMS
    And I should be able to schedule delivery
    And I should be able to set priority level

  @message @send-confirm
  Scenario: Send and confirm message
    Given I have configured the message
    When I send the message
    Then the message should be delivered
    And I should see delivery confirmation
    And the message should be logged
    And I should see in the communication history

  @message @history
  Scenario: View message history with user
    Given I am viewing a user's profile
    When I view message history
    Then I should see all sent messages
    And I should see message timestamps
    And I should see delivery status
    And I should see read status if available
    And I should see user replies if any

  # ===========================================
  # USER ANALYTICS
  # ===========================================

  @analytics @user
  Scenario: View user analytics
    Given I am viewing a user's detailed profile
    When I navigate to user analytics
    Then I should see the user analytics dashboard
    And I should see engagement metrics
    And I should see activity patterns
    And I should see comparison benchmarks
    And I should see trend analysis

  @analytics @engagement
  Scenario: View user engagement metrics
    Given I am viewing user analytics
    When I view engagement metrics
    Then I should see session frequency
    And I should see average session duration
    And I should see feature usage breakdown
    And I should see content interaction rates
    And I should see engagement score

  @analytics @activity
  Scenario: View user activity patterns
    Given I am viewing user analytics
    When I view activity patterns
    Then I should see activity by time of day
    And I should see activity by day of week
    And I should see activity trends over time
    And I should see peak usage periods
    And I should see activity heatmap

  @analytics @comparison
  Scenario: Compare user to benchmarks
    Given I am viewing user analytics
    When I view comparison metrics
    Then I should see user vs platform average
    And I should see user vs cohort average
    And I should see percentile rankings
    And I should see areas of high engagement
    And I should see areas of low engagement

  @analytics @transactions
  Scenario: View user transaction analytics
    Given I am viewing user analytics
    When I view transaction metrics
    Then I should see total transaction value
    And I should see transaction frequency
    And I should see average transaction size
    And I should see payment method preferences
    And I should see transaction trends

  @analytics @export
  Scenario: Export user analytics
    Given I am viewing user analytics
    When I export the analytics data
    Then I should select date range
    And I should select metrics to include
    And I should choose export format
    And the export should be generated
    And the export should be audit logged

  # ===========================================
  # SUPPORT HISTORY
  # ===========================================

  @support @history
  Scenario: View support history
    Given I am viewing a user's detailed profile
    When I navigate to support history
    Then I should see all support interactions
    And I should see ticket history
    And I should see resolution outcomes
    And I should see satisfaction ratings

  @support @tickets
  Scenario: View user's support tickets
    Given I am viewing support history
    When I view support tickets
    Then I should see all tickets created by user
    And I should see ticket status
    And I should see ticket category
    And I should see resolution time
    And I should be able to view ticket details

  @support @interactions
  Scenario: View support interaction details
    Given I am viewing support history
    When I click on a support ticket
    Then I should see the full ticket conversation
    And I should see agent responses
    And I should see user responses
    And I should see internal notes
    And I should see resolution details

  @support @satisfaction
  Scenario: View user satisfaction history
    Given I am viewing support history
    When I view satisfaction metrics
    Then I should see overall satisfaction score
    And I should see satisfaction by interaction
    And I should see feedback comments
    And I should see improvement trends

  @support @notes
  Scenario: View support notes on user
    Given I am viewing support history
    When I view support notes
    Then I should see notes from support agents
    And I should see escalation notes
    And I should see special handling instructions
    And I should be able to add new notes

  # ===========================================
  # DATA REQUESTS
  # ===========================================

  @data @request
  Scenario: Handle data request
    Given I am viewing a user's detailed profile
    When I navigate to data requests
    Then I should see pending data requests
    And I should see completed requests
    And I should see request types
    And I should be able to initiate new requests

  @data @export-request
  Scenario: Handle data export request
    Given there is a data export request
    When I process the export request
    Then I should see data to be exported
    And I should verify user identity
    And I should generate the export
    And I should deliver securely to user
    And I should log the fulfillment

  @data @deletion-request
  Scenario: Handle data deletion request
    Given there is a data deletion request
    When I process the deletion request
    Then I should see data to be deleted
    And I should verify user identity
    And I should check legal retention requirements
    And I should execute deletion
    And I should confirm to user

  @data @access-request
  Scenario: Handle data access request
    Given there is a data access request
    When I process the access request
    Then I should see what data user is requesting
    And I should verify user identity
    And I should compile the data
    And I should provide in readable format
    And I should log the fulfillment

  @data @rectification
  Scenario: Handle data rectification request
    Given there is a data rectification request
    When I process the rectification
    Then I should see the data to be corrected
    And I should verify the correction is accurate
    And I should apply the correction
    And I should notify the user
    And I should log the change

  # ===========================================
  # MERGE DUPLICATE ACCOUNTS
  # ===========================================

  @merge @accounts
  Scenario: Merge duplicate accounts
    Given I am on the user management section
    When I initiate account merge
    Then I should see the merge wizard
    And I should be able to search for accounts
    And I should see merge guidelines
    And I should see merge implications

  @merge @identify
  Scenario: Identify duplicate accounts
    Given I am merging accounts
    When I search for duplicate accounts
    Then I should see potential duplicates
    And I should see matching criteria
    And I should see similarity scores
    And I should be able to select accounts to merge

  @merge @compare
  Scenario: Compare accounts before merge
    Given I have selected accounts to merge
    When I compare the accounts
    Then I should see side-by-side comparison
    And I should see account data differences
    And I should see activity differences
    And I should see subscription differences
    And I should see transaction differences

  @merge @configure
  Scenario: Configure merge settings
    Given I am merging accounts
    When I configure merge settings
    Then I should select the primary account
    And I should choose which data to keep
    And I should resolve conflicts
    And I should set handling for subscriptions
    And I should set handling for transactions

  @merge @execute
  Scenario: Execute account merge
    Given I have configured merge settings
    When I execute the merge
    Then I should confirm the merge action
    And the accounts should be merged
    And the secondary account should be archived
    And the user should be notified
    And the merge should be audit logged

  @merge @verify
  Scenario: Verify merge completion
    Given accounts have been merged
    When I verify the merge
    Then I should see the merged account
    And I should see combined history
    And I should see all data preserved
    And I should see merge audit trail
    And I should be able to undo if within window

  # ===========================================
  # ADMIN NOTES
  # ===========================================

  @notes @add
  Scenario: Add admin notes to user
    Given I am viewing a user's detailed profile
    When I click on "Add Note"
    Then I should see the note editor
    And I should see note categories
    And I should see visibility options
    And I should see existing notes

  @notes @create
  Scenario: Create admin note
    Given I am adding an admin note
    When I write the note content
    Then I should be able to format the text
    And I should be able to categorize the note
    And I should be able to set priority level
    And I should be able to set visibility
    And I should be able to tag other admins

  @notes @categories
  Scenario: Categorize admin notes
    Given I am creating an admin note
    When I select a category
    Then I should see available categories
    And I should be able to select support notes
    And I should be able to select account notes
    And I should be able to select security notes
    And I should be able to select general notes

  @notes @visibility
  Scenario: Set note visibility
    Given I am creating an admin note
    When I set visibility options
    Then I should be able to set as private
    And I should be able to share with team
    And I should be able to share with all admins
    And I should be able to make visible to user

  @notes @view
  Scenario: View admin notes on user
    Given I am viewing a user's detailed profile
    When I view admin notes
    Then I should see all notes for this user
    And I should see note authors
    And I should see note timestamps
    And I should see note categories
    And I should be able to filter notes

  @notes @edit
  Scenario: Edit admin note
    Given I am viewing admin notes
    And I have permission to edit notes
    When I edit an existing note
    Then I should be able to modify content
    And I should see edit history
    And I should save the changes
    And the edit should be logged

  @notes @pin
  Scenario: Pin important note
    Given I am viewing admin notes
    When I pin a note
    Then the note should appear at top
    And the note should be highlighted
    And all admins should see it first
    And I should be able to unpin it

  # ===========================================
  # ERROR HANDLING AND EDGE CASES
  # ===========================================

  @error-handling @user-not-found
  Scenario: Handle user not found
    Given I am searching for a user
    When the user is not found
    Then I should see a "User not found" message
    And I should see search suggestions
    And I should be able to refine search
    And I should see help options

  @error-handling @permission-denied
  Scenario: Handle insufficient permissions
    Given I am attempting a user management action
    When I do not have required permissions
    Then I should see an access denied message
    And I should see what permission is required
    And I should see how to request access
    And the attempt should be logged

  @error-handling @action-failed
  Scenario: Handle action failure
    Given I am performing a user management action
    When the action fails
    Then I should see a clear error message
    And I should see the failure reason
    And I should see suggested resolutions
    And I should be able to retry
    And the failure should be logged

  @error-handling @validation-error
  Scenario: Handle validation errors
    Given I am editing user information
    When I enter invalid data
    Then I should see validation error messages
    And I should see which fields have errors
    And I should see how to correct the errors
    And I should not be able to save until fixed

  @edge-case @self-management
  Scenario: Handle self-management restrictions
    Given I am viewing my own admin account
    When I attempt to modify my own permissions
    Then I should see a restriction notice
    And I should not be able to modify my own roles
    And I should not be able to suspend myself
    And I should be directed to another admin

  @edge-case @protected-account
  Scenario: Handle protected accounts
    Given I am viewing a protected user account
    When I attempt to modify the account
    Then I should see the protection status
    And I should see why it is protected
    And I should see limited action options
    And elevated permissions should be required

  @edge-case @concurrent-edit
  Scenario: Handle concurrent user editing
    Given another admin is editing the same user
    When I attempt to edit the user
    Then I should see a concurrent edit warning
    And I should see who is editing
    And I should be able to view read-only
    And I should be able to request edit access

  @edge-case @large-history
  Scenario: Handle users with large history
    Given I am viewing a user with extensive history
    When I load the user profile
    Then data should load progressively
    And I should see loading indicators
    And I should be able to filter history
    And performance should remain acceptable

  @edge-case @deleted-user-reference
  Scenario: Handle references to deleted users
    Given I am viewing data that references a deleted user
    When I see the deleted user reference
    Then I should see "[Deleted User]" indicator
    And I should see the original user ID
    And I should be able to view archived info if permitted
    And relationships should be preserved
