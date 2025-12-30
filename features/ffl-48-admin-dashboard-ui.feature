@ui @admin @dashboard @cloudscape @frontend
Feature: Admin Dashboard UI
  As a league admin
  I want to manage my leagues through an intuitive dashboard interface
  So that I can create leagues, configure settings, invite players, and manage my leagues effectively

  Background:
    Given I am authenticated as an admin user
    And I have access to the admin dashboard
    And the Cloudscape design system is loaded

  # =============================================================================
  # DASHBOARD LAYOUT
  # =============================================================================

  @layout @structure
  Scenario: Display admin dashboard layout
    Given I navigate to the admin dashboard
    When the dashboard loads
    Then I should see the Cloudscape layout with:
      | Component             | Description                          |
      | App layout            | Main application structure           |
      | Side navigation       | League and feature navigation        |
      | Header                | Logo, user menu, notifications       |
      | Content area          | Main content region                  |
      | Breadcrumbs           | Navigation trail                     |

  @layout @navigation
  Scenario: Display side navigation menu
    Given I am on the admin dashboard
    When I view the side navigation
    Then I should see navigation items:
      | Item                  | Icon     | Destination                    |
      | Dashboard             | home     | Dashboard overview             |
      | My Leagues            | folder   | League list                    |
      | Create League         | add      | League creation wizard         |
      | Player Management     | users    | Invitation and player list     |
      | Settings              | settings | Account settings               |

  @layout @header
  Scenario: Display header with user menu
    Given I am on the admin dashboard
    When I view the header
    Then I should see:
      | Element               | Description                          |
      | Logo                  | Application logo                     |
      | Search                | Global search (optional)             |
      | Notifications         | Bell icon with badge                 |
      | User menu             | Profile dropdown                     |
    And clicking user menu should show:
      | Option                | Action                               |
      | Profile               | View/edit profile                    |
      | Help                  | Documentation/support                |
      | Sign out              | Logout                               |

  @layout @responsive
  Scenario: Dashboard is responsive
    Given I am on the admin dashboard
    When I view on different screen sizes
    Then the layout should adapt:
      | Screen Size    | Navigation                         |
      | Desktop        | Full side navigation visible       |
      | Tablet         | Collapsible side navigation        |
      | Mobile         | Hamburger menu navigation          |

  # =============================================================================
  # DASHBOARD OVERVIEW
  # =============================================================================

  @overview @summary
  Scenario: Display dashboard summary cards
    Given I am on the dashboard overview
    When the data loads
    Then I should see summary cards:
      | Card                  | Content                              |
      | Total Leagues         | Count of leagues I own               |
      | Active Players        | Total players across leagues         |
      | Current Week          | Current NFL week status              |
      | Pending Actions       | Items requiring attention            |

  @overview @leagues
  Scenario: Display league quick view
    Given I have leagues
    When I view the dashboard
    Then I should see a league overview section with:
      | Information           | Description                          |
      | League cards          | Card for each league                 |
      | League name           | Name of the league                   |
      | Player count          | X/Y players                          |
      | Status                | Active, Draft, Completed             |
      | Quick actions         | View, Edit, Manage Players           |

  @overview @alerts
  Scenario: Display action alerts
    Given there are pending actions
    When I view the dashboard
    Then I should see an alerts panel with:
      | Alert Type            | Example                              |
      | Pending invitations   | 3 invitations awaiting response      |
      | Incomplete rosters    | League A has 2 incomplete rosters    |
      | Approaching deadline  | Roster lock in 2 hours               |
      | Configuration needed  | Complete League B setup              |

  # =============================================================================
  # LEAGUE CREATION WIZARD
  # =============================================================================

  @wizard @league-creation
  Scenario: Display league creation wizard
    Given I click "Create League"
    When the wizard opens
    Then I should see a Cloudscape wizard with steps:
      | Step | Name                | Description                    |
      | 1    | League Details      | Name, description, type        |
      | 2    | Scoring Settings    | Scoring rules configuration    |
      | 3    | Roster Settings     | Position slots and limits      |
      | 4    | Schedule Settings   | Season dates and playoffs      |
      | 5    | Review & Create     | Summary and confirmation       |

  @wizard @step1
  Scenario: Complete league details step
    Given I am on step 1 of the league creation wizard
    When I fill out the league details form
    Then I should provide:
      | Field                 | Type        | Validation                   |
      | League Name           | Input       | Required, max 50 chars       |
      | Description           | Textarea    | Optional, max 500 chars      |
      | League Type           | Select      | Standard, Playoff Challenge  |
      | Season Year           | Select      | Current or next year         |
      | Max Players           | Number      | 4-16                         |
    And I can proceed to step 2

  @wizard @step2
  Scenario: Complete scoring settings step
    Given I am on step 2 of the league creation wizard
    When I configure scoring settings
    Then I should see scoring form with:
      | Setting               | Options                              |
      | Scoring format        | Standard, PPR, Half-PPR              |
      | Passing TD            | Points per passing TD                |
      | Rushing TD            | Points per rushing TD                |
      | Receiving TD          | Points per receiving TD              |
      | Field Goal            | Points by distance                   |
      | Defense/ST            | Points for sacks, INTs, etc.         |
    And I can select a preset or customize values

  @wizard @step3
  Scenario: Complete roster settings step
    Given I am on step 3 of the league creation wizard
    When I configure roster settings
    Then I should configure:
      | Position              | Slots | Description                    |
      | QB                    | 1     | Quarterbacks                   |
      | RB                    | 2     | Running Backs                  |
      | WR                    | 2     | Wide Receivers                 |
      | TE                    | 1     | Tight Ends                     |
      | FLEX                  | 1     | RB/WR/TE                       |
      | K                     | 1     | Kicker                         |
      | DEF                   | 1     | Team Defense                   |
      | Bench                 | 6     | Bench spots                    |

  @wizard @step4
  Scenario: Complete schedule settings step
    Given I am on step 4 of the league creation wizard
    When I configure schedule settings
    Then I should set:
      | Setting               | Description                          |
      | Start week            | Which NFL week to start              |
      | End week              | Which NFL week to end                |
      | Playoff weeks         | Weeks for playoffs                   |
      | Roster lock           | When rosters lock each week          |
      | Trade deadline        | If trades are enabled                |

  @wizard @step5
  Scenario: Review and create league
    Given I am on step 5 of the league creation wizard
    When I review my settings
    Then I should see a summary of:
      | Section               | Content                              |
      | League Details        | Name, type, max players              |
      | Scoring               | Key scoring settings                 |
      | Roster                | Position breakdown                   |
      | Schedule              | Date range and playoffs              |
    And I can click "Create League" to finish
    And I can go back to edit any section

  @wizard @navigation
  Scenario: Navigate through wizard steps
    Given I am in the league creation wizard
    When I navigate between steps
    Then I should be able to:
      | Action                | Behavior                             |
      | Click Next            | Move to next step if valid           |
      | Click Previous        | Return to previous step              |
      | Click step indicator  | Jump to completed step               |
      | Click Cancel          | Exit wizard with confirmation        |
    And incomplete steps should be disabled

  @wizard @validation
  Scenario: Validate wizard form inputs
    Given I am filling out the wizard
    When I enter invalid data
    Then I should see:
      | Validation            | Display                              |
      | Required field error  | "League name is required"            |
      | Format error          | "Enter a valid number"               |
      | Range error           | "Must be between 4 and 16"           |
      | Inline error          | Error message below field            |
    And Next button should be disabled until valid

  @wizard @draft-save
  Scenario: Save wizard progress as draft
    Given I am partially through the wizard
    When I click "Save as Draft"
    Then my progress should be saved
    And I should see a confirmation message
    And I can return to complete the wizard later

  # =============================================================================
  # LEAGUE CONFIGURATION
  # =============================================================================

  @config @edit
  Scenario: Edit existing league configuration
    Given I have an existing league
    When I click "Edit" on the league
    Then I should see the configuration page with:
      | Tab                   | Settings                             |
      | General               | Name, description, status            |
      | Scoring               | Scoring rules                        |
      | Roster                | Position settings                    |
      | Schedule              | Season dates                         |
      | Advanced              | Trade settings, waivers              |

  @config @general
  Scenario: Edit general league settings
    Given I am on the general settings tab
    When I edit league settings
    Then I should be able to modify:
      | Setting               | Constraints                          |
      | League Name           | Always editable                      |
      | Description           | Always editable                      |
      | Status                | Active, Paused, Completed            |
      | Visibility            | Public, Private                      |
    And changes should save automatically or on submit

  @config @scoring
  Scenario: Edit scoring settings
    Given I am on the scoring settings tab
    When I modify scoring rules
    Then I should see:
      | Setting               | Edit Constraints                     |
      | Scoring format        | Locked after season starts           |
      | Point values          | Editable before first game           |
      | Preview               | Show example player scores           |

  @config @lock
  Scenario: Configuration lock after season starts
    Given the season has started
    When I try to edit certain settings
    Then I should see:
      | Setting               | State                                |
      | League name           | Editable                             |
      | Scoring format        | Locked with icon                     |
      | Roster positions      | Locked with icon                     |
    And locked settings should show "Cannot modify after season starts"

  # =============================================================================
  # PLAYER INVITATIONS
  # =============================================================================

  @invitations @send
  Scenario: Send player invitations
    Given I am managing a league
    When I navigate to Player Management
    Then I should see an invitation form with:
      | Field                 | Description                          |
      | Email addresses       | Multi-email input                    |
      | Custom message        | Optional personalized message        |
      | Role                  | Player (default)                     |
      | Send button           | Send invitations                     |

  @invitations @bulk
  Scenario: Send bulk invitations
    Given I want to invite multiple players
    When I enter multiple email addresses
    Then I should be able to:
      | Action                | Behavior                             |
      | Paste list            | Parse comma/newline separated        |
      | Add one by one        | Add button for each email            |
      | Remove email          | X button on each email chip          |
      | Validate all          | Check format before sending          |
    And send all invitations at once

  @invitations @status
  Scenario: View invitation status
    Given I have sent invitations
    When I view the invitations list
    Then I should see invitation status:
      | Column                | Description                          |
      | Email                 | Invited email address                |
      | Status                | Pending, Accepted, Expired           |
      | Sent date             | When invitation was sent             |
      | Actions               | Resend, Cancel                       |

  @invitations @resend
  Scenario: Resend invitation
    Given a player hasn't accepted their invitation
    When I click "Resend" on their invitation
    Then a new invitation email should be sent
    And the sent date should update
    And I should see a success notification

  @invitations @revoke
  Scenario: Revoke pending invitation
    Given a pending invitation exists
    When I click "Revoke" on the invitation
    Then I should see a confirmation dialog
    And confirming should invalidate the invitation
    And the status should change to "Revoked"

  # =============================================================================
  # PLAYER MANAGEMENT
  # =============================================================================

  @players @list
  Scenario: View player list
    Given I am managing a league with players
    When I view the player list
    Then I should see a Cloudscape table with:
      | Column                | Description                          |
      | Player Name           | Display name                         |
      | Email                 | Player email                         |
      | Joined Date           | When they joined                     |
      | Roster Status         | Complete, Incomplete                 |
      | Last Active           | Last activity timestamp              |
      | Actions               | View, Remove                         |

  @players @search
  Scenario: Search and filter players
    Given I have many players
    When I use search and filters
    Then I should be able to:
      | Filter                | Options                              |
      | Search by name        | Text search                          |
      | Filter by status      | Active, Inactive                     |
      | Filter by roster      | Complete, Incomplete                 |
      | Sort by column        | Click column headers                 |

  @players @view
  Scenario: View player details
    Given I click on a player
    When the player details open
    Then I should see:
      | Section               | Information                          |
      | Profile               | Name, email, joined date             |
      | Roster                | Current roster selections            |
      | Activity              | Recent activity log                  |
      | Performance           | Points scored by week                |

  @players @remove
  Scenario: Remove player from league
    Given I want to remove a player
    When I click "Remove" on a player
    Then I should see a confirmation dialog:
      | Element               | Content                              |
      | Warning               | This action cannot be undone         |
      | Impact                | Player's roster will be cleared      |
      | Confirmation          | Type player name to confirm          |
    And confirming should remove the player

  # =============================================================================
  # LEAGUE MANAGEMENT
  # =============================================================================

  @management @list
  Scenario: View my leagues list
    Given I have multiple leagues
    When I view "My Leagues"
    Then I should see a Cloudscape table with:
      | Column                | Description                          |
      | League Name           | Name with link to details            |
      | Season                | Year                                 |
      | Players               | X/Y count                            |
      | Status                | Badge (Active, Draft, Completed)     |
      | Actions               | View, Edit, Delete                   |

  @management @actions
  Scenario: Perform league actions
    Given I am viewing my leagues
    When I use the actions menu on a league
    Then I should see options:
      | Action                | Description                          |
      | View Dashboard        | Go to league dashboard               |
      | Edit Settings         | Open configuration                   |
      | Manage Players        | Go to player management              |
      | Duplicate             | Create copy of league                |
      | Delete                | Delete league (with confirmation)    |

  @management @delete
  Scenario: Delete a league
    Given I want to delete a league
    When I click "Delete"
    Then I should see a confirmation modal:
      | Element               | Content                              |
      | Warning icon          | Alert indicator                      |
      | Message               | Explain permanent deletion           |
      | Affected data         | Players, rosters, history            |
      | Confirmation input    | Type league name to confirm          |
    And I must type the league name to enable delete

  @management @duplicate
  Scenario: Duplicate a league
    Given I want to create a similar league
    When I click "Duplicate"
    Then I should see:
      | Behavior              | Description                          |
      | Copy settings         | All configuration copied             |
      | New name              | Prompted for new league name         |
      | No players            | Players not copied                   |
      | Editable              | Can modify before creating           |

  # =============================================================================
  # CLOUDSCAPE FORMS
  # =============================================================================

  @forms @components
  Scenario: Use Cloudscape form components
    Given I am filling out forms in the dashboard
    Then I should interact with:
      | Component             | Usage                                |
      | Input                 | Text fields                          |
      | Textarea              | Long text input                      |
      | Select                | Dropdown selection                   |
      | Multiselect           | Multiple selection                   |
      | Radio group           | Single choice options                |
      | Checkbox              | Boolean toggles                      |
      | Toggle                | On/off switches                      |
      | Date picker           | Date selection                       |
      | Form field            | Label, hint, error wrapper           |

  @forms @validation
  Scenario: Display form validation
    Given I submit a form with errors
    When validation runs
    Then I should see Cloudscape validation:
      | Validation            | Display                              |
      | Required field        | Red border, error message            |
      | Invalid format        | Inline error text                    |
      | Form-level error      | Alert at top of form                 |
      | Success               | Green checkmark                      |

  @forms @help
  Scenario: Display form help text
    Given I am viewing a form
    When I look at form fields
    Then I should see:
      | Help Type             | Display                              |
      | Description           | Help text below label                |
      | Info icon             | Tooltip on hover                     |
      | Constraint hint       | "Max 50 characters"                  |
      | Example               | Placeholder text                     |

  # =============================================================================
  # NOTIFICATIONS
  # =============================================================================

  @notifications @display
  Scenario: Display notification center
    Given I have notifications
    When I click the notification bell
    Then I should see:
      | Element               | Description                          |
      | Notification list     | Recent notifications                 |
      | Unread badge          | Count of unread                      |
      | Mark all read         | Clear unread status                  |
      | View all link         | Go to notifications page             |

  @notifications @types
  Scenario: Display notification types
    Given various events have occurred
    Then I should see notifications for:
      | Event                 | Notification                         |
      | Player joined         | "{Player} joined {League}"           |
      | Roster submitted      | "{Player} submitted roster"          |
      | Week ended            | "Week 15 results are in"             |
      | Deadline approaching  | "Roster lock in 1 hour"              |

  @notifications @actions
  Scenario: Interact with notifications
    Given I have a notification
    When I interact with it
    Then I should be able to:
      | Action                | Behavior                             |
      | Click notification    | Navigate to relevant page            |
      | Dismiss               | Remove single notification           |
      | Mark as read          | Update read status                   |

  # =============================================================================
  # ERROR HANDLING
  # =============================================================================

  @error @display
  Scenario: Display error states
    Given an error occurs
    When I view the error
    Then I should see Cloudscape error patterns:
      | Error Type            | Display                              |
      | API error             | Alert banner with retry option       |
      | Form error            | Inline field errors                  |
      | Permission error      | Access denied message                |
      | Not found             | Empty state with guidance            |

  @error @recovery
  Scenario: Recover from errors
    Given an error occurred
    When I try to recover
    Then I should have options:
      | Recovery              | Action                               |
      | Retry                 | Retry failed operation               |
      | Go back               | Return to previous page              |
      | Contact support       | Link to help resources               |
      | Refresh               | Reload the page                      |

  @error @empty-states
  Scenario: Display empty states
    Given I have no data
    When I view an empty section
    Then I should see:
      | Element               | Content                              |
      | Illustration          | Relevant empty state image           |
      | Message               | "No leagues yet"                     |
      | Call to action        | "Create your first league"           |

  # =============================================================================
  # LOADING STATES
  # =============================================================================

  @loading @skeleton
  Scenario: Display loading skeletons
    Given data is loading
    When I view the dashboard
    Then I should see:
      | Component             | Loading State                        |
      | Summary cards         | Skeleton cards                       |
      | League list           | Skeleton table rows                  |
      | Player list           | Skeleton list items                  |
    And content should replace skeletons when loaded

  @loading @spinner
  Scenario: Display loading spinners
    Given an action is in progress
    When I wait for completion
    Then I should see:
      | Action                | Loading Indicator                    |
      | Form submit           | Button spinner                       |
      | Data fetch            | Inline spinner                       |
      | Page load             | Full page spinner                    |

  # =============================================================================
  # ACCESSIBILITY
  # =============================================================================

  @accessibility @navigation
  Scenario: Navigate with keyboard
    Given I am using keyboard navigation
    When I navigate the dashboard
    Then I should be able to:
      | Action                | Keys                                 |
      | Navigate menu         | Arrow keys, Tab                      |
      | Open dropdowns        | Enter, Space                         |
      | Close modals          | Escape                               |
      | Submit forms          | Enter                                |
      | Skip to content       | Skip link                            |

  @accessibility @aria
  Scenario: Support screen readers
    Given I am using a screen reader
    When I navigate the dashboard
    Then elements should have:
      | Element               | ARIA Support                         |
      | Navigation            | Role, aria-current                   |
      | Buttons               | Accessible labels                    |
      | Forms                 | Label associations                   |
      | Status messages       | aria-live regions                    |
      | Modals                | Focus trap, role=dialog              |

  @accessibility @color
  Scenario: Support color accessibility
    Given I view the dashboard
    Then the design should support:
      | Requirement           | Implementation                       |
      | Color contrast        | WCAG AA compliance                   |
      | Not color only        | Icons/text with colors               |
      | Focus visible         | Clear focus indicators               |
      | Dark mode             | Optional dark theme                  |

  # =============================================================================
  # PERFORMANCE
  # =============================================================================

  @performance @loading
  Scenario: Dashboard loads efficiently
    Given I navigate to the dashboard
    When the page loads
    Then loading should meet:
      | Metric                | Target                               |
      | First paint           | < 1 second                           |
      | Time to interactive   | < 2 seconds                          |
      | Largest contentful    | < 2.5 seconds                        |

  @performance @caching
  Scenario: Cache dashboard data
    Given I have loaded dashboard data
    When I navigate away and return
    Then cached data should:
      | Behavior              | Description                          |
      | Display immediately   | Show cached data first               |
      | Background refresh    | Fetch updates in background          |
      | Stale indicator       | Show if data is stale                |

  # =============================================================================
  # SETTINGS
  # =============================================================================

  @settings @account
  Scenario: Manage account settings
    Given I navigate to Settings
    When I view account settings
    Then I should be able to:
      | Setting               | Action                               |
      | Display name          | Edit my display name                 |
      | Email                 | View (not edit) email                |
      | Notifications         | Configure notification preferences   |
      | Theme                 | Light/Dark/System                    |

  @settings @notifications
  Scenario: Configure notification preferences
    Given I am in notification settings
    When I configure preferences
    Then I should be able to toggle:
      | Notification          | Channels                             |
      | Player joined         | Email, In-app                        |
      | Roster submitted      | In-app only                          |
      | Week results          | Email, In-app                        |
      | Deadline reminders    | Email, In-app, Push                  |
