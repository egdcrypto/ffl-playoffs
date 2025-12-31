@help @anima-1373
Feature: Help
  As a fantasy football user
  I want comprehensive help and support options
  So that I can get assistance when I need it

  Background:
    Given I am a logged-in user
    And the help system is available

  # ============================================================================
  # HELP CENTER
  # ============================================================================

  @happy-path @help-center
  Scenario: Access help center
    Given I need help
    When I access the help center
    Then I should see the help center homepage
    And I should see help categories

  @happy-path @help-center
  Scenario: Browse help articles
    Given I am in the help center
    When I browse help articles
    Then I should see available articles
    And articles should be organized by topic

  @happy-path @help-center
  Scenario: View FAQ section
    Given I am in the help center
    When I access the FAQ section
    Then I should see frequently asked questions
    And I should be able to expand answers

  @happy-path @help-center
  Scenario: Search knowledge base
    Given I am in the help center
    When I search for help
    Then I should see relevant results
    And results should match my query

  @happy-path @help-center
  Scenario: View article details
    Given I find a helpful article
    When I open the article
    Then I should see the full content
    And I should see related articles

  @happy-path @help-center
  Scenario: Rate article helpfulness
    Given I read a help article
    When I rate its helpfulness
    Then my rating should be recorded
    And I should see confirmation

  @happy-path @help-center
  Scenario: Print help article
    Given I am viewing an article
    When I print the article
    Then a printable version should open
    And formatting should be clean

  @mobile @help-center
  Scenario: Access help center on mobile
    Given I am on a mobile device
    When I access help center
    Then help center should be mobile-friendly
    And navigation should work on touch

  # ============================================================================
  # CONTEXTUAL HELP
  # ============================================================================

  @happy-path @contextual-help
  Scenario: View tooltips on hover
    Given I am using the application
    When I hover over an element with help
    Then I should see a tooltip
    And tooltip should explain the feature

  @happy-path @contextual-help
  Scenario: View inline help
    Given I am on a complex page
    Then I should see inline help text
    And help should be relevant to the context

  @happy-path @contextual-help
  Scenario: See contextual hints
    Given I am performing an action
    When hints are available
    Then I should see contextual hints
    And hints should guide me

  @happy-path @contextual-help
  Scenario: Click info icons for help
    Given I see an info icon
    When I click the info icon
    Then I should see help information
    And I can dismiss the help

  @happy-path @contextual-help
  Scenario: Disable contextual hints
    Given I am an experienced user
    When I disable contextual hints
    Then hints should not appear
    And my preference should be saved

  @happy-path @contextual-help
  Scenario: Access help from any screen
    Given I am anywhere in the app
    When I access the help button
    Then I should see relevant help
    And help should match my current screen

  # ============================================================================
  # TUTORIALS
  # ============================================================================

  @happy-path @tutorials
  Scenario: Start guided tutorial
    Given I want to learn a feature
    When I start a guided tutorial
    Then I should see step-by-step guidance
    And I should be able to follow along

  @happy-path @tutorials
  Scenario: Complete walkthrough
    Given I am in a walkthrough
    When I complete each step
    Then my progress should be tracked
    And I should see completion status

  @happy-path @tutorials
  Scenario: Watch video tutorial
    Given video tutorials are available
    When I watch a video tutorial
    Then the video should play
    And I should see video controls

  @happy-path @tutorials
  Scenario: Access interactive guides
    Given interactive guides exist
    When I access an interactive guide
    Then I should practice the feature
    And feedback should be provided

  @happy-path @tutorials
  Scenario: Pause and resume tutorial
    Given I am in a tutorial
    When I pause the tutorial
    Then my progress should be saved
    And I can resume later

  @happy-path @tutorials
  Scenario: Skip tutorial sections
    Given I am in a tutorial
    When I skip a section
    Then I should move forward
    And I can return to skipped sections

  @happy-path @tutorials
  Scenario: View tutorial list
    Given I want to learn
    When I view available tutorials
    Then I should see all tutorials
    And I should see my completion status

  @happy-path @tutorials
  Scenario: Replay completed tutorial
    Given I completed a tutorial
    When I want to replay it
    Then I should be able to restart
    And the tutorial should play again

  # ============================================================================
  # FAQ
  # ============================================================================

  @happy-path @faq
  Scenario: Browse FAQ by category
    Given I am in the FAQ section
    When I browse by category
    Then I should see categorized questions
    And I can filter by category

  @happy-path @faq
  Scenario: Search FAQs
    Given I have a specific question
    When I search the FAQs
    Then I should see matching questions
    And search should be fast

  @happy-path @faq
  Scenario: View popular questions
    Given I am in the FAQ section
    Then I should see popular questions
    And popular questions should be highlighted

  @happy-path @faq
  Scenario: Expand FAQ answer
    Given I see an FAQ question
    When I click to expand
    Then I should see the full answer
    And I can collapse it again

  @happy-path @faq
  Scenario: Suggest new FAQ
    Given I have an unanswered question
    When I submit a question suggestion
    Then my suggestion should be recorded
    And I should see confirmation

  @happy-path @faq
  Scenario: Share FAQ answer
    Given I find a helpful FAQ
    When I share it
    Then a shareable link should be created
    And others can view the FAQ

  # ============================================================================
  # CONTACT SUPPORT
  # ============================================================================

  @happy-path @contact-support
  Scenario: Submit support ticket
    Given I need help from support
    When I submit a support ticket
    Then my ticket should be created
    And I should receive confirmation

  @happy-path @contact-support
  Scenario: Start live chat
    Given live chat is available
    When I start a chat session
    Then I should connect to support
    And I can chat in real-time

  @happy-path @contact-support
  Scenario: Send email support request
    Given I prefer email support
    When I send an email request
    Then my request should be sent
    And I should see confirmation

  @happy-path @contact-support
  Scenario: Request callback
    Given I need phone support
    When I request a callback
    Then my request should be submitted
    And I should see estimated wait time

  @happy-path @contact-support
  Scenario: View ticket status
    Given I submitted a ticket
    When I check ticket status
    Then I should see current status
    And I should see any responses

  @happy-path @contact-support
  Scenario: Reply to support ticket
    Given I have an open ticket
    When I reply to the ticket
    Then my reply should be added
    And support should be notified

  @happy-path @contact-support
  Scenario: Close support ticket
    Given my issue is resolved
    When I close the ticket
    Then the ticket should be closed
    And I should be asked for feedback

  @happy-path @contact-support
  Scenario: View support hours
    Given I need to contact support
    Then I should see support hours
    And I should see availability status

  # ============================================================================
  # DOCUMENTATION
  # ============================================================================

  @happy-path @documentation
  Scenario: Access user guides
    Given I need detailed instructions
    When I access user guides
    Then I should see comprehensive guides
    And guides should be well-organized

  @happy-path @documentation
  Scenario: View feature documentation
    Given I want to learn about a feature
    When I view feature documentation
    Then I should see detailed explanation
    And screenshots should be included

  @happy-path @documentation
  Scenario: Access glossary
    Given I encounter unfamiliar terms
    When I access the glossary
    Then I should see term definitions
    And I can search for terms

  @happy-path @documentation
  Scenario: View release notes
    Given new features were released
    When I view release notes
    Then I should see what's new
    And changes should be explained

  @happy-path @documentation
  Scenario: Download documentation
    Given I want offline access
    When I download documentation
    Then I should receive a PDF
    And documentation should be complete

  @happy-path @documentation
  Scenario: View version history
    Given I want to see past changes
    When I view version history
    Then I should see all releases
    And I can view any version's notes

  # ============================================================================
  # TROUBLESHOOTING
  # ============================================================================

  @happy-path @troubleshooting
  Scenario: View common issues
    Given I have a problem
    When I view common issues
    Then I should see known issues
    And solutions should be provided

  @happy-path @troubleshooting
  Scenario: Follow error resolution steps
    Given I encountered an error
    When I follow resolution steps
    Then I should be guided to fix it
    And the issue should be resolved

  @happy-path @troubleshooting
  Scenario: Use diagnostic tools
    Given I need to diagnose a problem
    When I use diagnostic tools
    Then the system should check for issues
    And I should see a report

  @happy-path @troubleshooting
  Scenario: Apply self-service fix
    Given a self-service fix is available
    When I apply the fix
    Then the fix should be applied
    And the issue should be resolved

  @happy-path @troubleshooting
  Scenario: Clear cache and data
    Given I need to reset app state
    When I clear cache and data
    Then cached data should be cleared
    And the app should refresh

  @happy-path @troubleshooting
  Scenario: Report unresolved issue
    Given troubleshooting did not help
    When I report the issue
    Then my report should be submitted
    And I should get a ticket number

  # ============================================================================
  # FEEDBACK
  # ============================================================================

  @happy-path @feedback
  Scenario: Submit feature request
    Given I have a feature idea
    When I submit a feature request
    Then my request should be recorded
    And I should see confirmation

  @happy-path @feedback
  Scenario: Report a bug
    Given I found a bug
    When I report the bug
    Then my report should be submitted
    And I should see a reference number

  @happy-path @feedback
  Scenario: Submit user suggestion
    Given I have a suggestion
    When I submit my suggestion
    Then my suggestion should be recorded
    And I should see thank you message

  @happy-path @feedback
  Scenario: Complete satisfaction survey
    Given I am asked for feedback
    When I complete the survey
    Then my responses should be recorded
    And I should see confirmation

  @happy-path @feedback
  Scenario: Vote on feature requests
    Given there are feature requests
    When I vote on a request
    Then my vote should be counted
    And vote count should update

  @happy-path @feedback
  Scenario: Track my feedback status
    Given I submitted feedback
    When I check feedback status
    Then I should see my submissions
    And I should see their status

  # ============================================================================
  # COMMUNITY SUPPORT
  # ============================================================================

  @happy-path @community-support
  Scenario: Access community forums
    Given community forums exist
    When I access the forums
    Then I should see forum categories
    And I should see recent discussions

  @happy-path @community-support
  Scenario: Post question in forum
    Given I have a question
    When I post in the forum
    Then my question should be posted
    And community members can respond

  @happy-path @community-support
  Scenario: Answer community question
    Given I can help someone
    When I answer their question
    Then my answer should be posted
    And the asker should be notified

  @happy-path @community-support
  Scenario: Get peer help
    Given I need help from peers
    When I ask for help
    Then community members can assist
    And I should receive responses

  @happy-path @community-support
  Scenario: View expert answers
    Given experts participate
    When I view expert answers
    Then expert answers should be highlighted
    And I should trust their guidance

  @happy-path @community-support
  Scenario: Mark answer as helpful
    Given I received helpful answer
    When I mark it as helpful
    Then my feedback should be recorded
    And the helper should be recognized

  @happy-path @community-support
  Scenario: Search community discussions
    Given I want to find discussions
    When I search the community
    Then I should see matching discussions
    And search should be comprehensive

  # ============================================================================
  # ACCESSIBILITY HELP
  # ============================================================================

  @accessibility @accessibility-help
  Scenario: View accessibility features guide
    Given I need accessibility help
    When I view accessibility features
    Then I should see available features
    And usage instructions should be clear

  @accessibility @accessibility-help
  Scenario: Get screen reader support info
    Given I use a screen reader
    When I view screen reader support
    Then I should see compatibility info
    And I should see usage tips

  @accessibility @accessibility-help
  Scenario: View keyboard navigation help
    Given I use keyboard navigation
    When I view keyboard help
    Then I should see keyboard shortcuts
    And navigation instructions should be provided

  @accessibility @accessibility-help
  Scenario: Learn about visual adjustments
    Given I need visual accommodations
    When I view visual adjustment help
    Then I should see available adjustments
    And I should learn how to enable them

  @accessibility @accessibility-help
  Scenario: Access accessibility statement
    Given I want to know about accessibility
    When I view accessibility statement
    Then I should see our commitment
    And I should see compliance info

  @accessibility @accessibility-help
  Scenario: Report accessibility issue
    Given I encounter accessibility barrier
    When I report the issue
    Then my report should be prioritized
    And I should receive follow-up

  @accessibility @accessibility-help
  Scenario: Request accessibility accommodation
    Given I need special accommodation
    When I request accommodation
    Then my request should be recorded
    And support should contact me
