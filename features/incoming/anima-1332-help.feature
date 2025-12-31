@help @ANIMA-1332
Feature: Help
  As a fantasy football application user
  I want access to comprehensive help resources
  So that I can learn the application and resolve issues

  Background:
    Given the fantasy football playoffs application is running
    And I am logged in as a registered user

  # ============================================================================
  # HELP CENTER - HAPPY PATH
  # ============================================================================

  @happy-path @help-center
  Scenario: Access help center
    Given I am on any page
    When I access the help center
    Then I should see the help center home
    And I should see help categories
    And I should see popular articles

  @happy-path @help-center
  Scenario: Browse help categories
    Given I am in the help center
    When I browse categories
    Then I should see all help categories
    And I should see article counts
    And I should navigate into categories

  @happy-path @help-center
  Scenario: View popular help articles
    Given I am in the help center
    When I view popular articles
    Then I should see frequently accessed articles
    And I should see view counts
    And I should access any article

  @happy-path @help-center
  Scenario: View recently updated articles
    Given I am in the help center
    When I view recent updates
    Then I should see recently updated content
    And I should see update dates
    And I should see what changed

  @happy-path @help-center
  Scenario: Navigate help breadcrumbs
    Given I am viewing a help article
    When I use breadcrumb navigation
    Then I should see my location
    And I should navigate to parent sections
    And navigation should be clear

  # ============================================================================
  # FAQs
  # ============================================================================

  @happy-path @faqs
  Scenario: View FAQs page
    Given I am in the help center
    When I access FAQs
    Then I should see frequently asked questions
    And they should be organized by topic
    And I should expand answers

  @happy-path @faqs
  Scenario: Expand FAQ answer
    Given I am viewing FAQs
    When I click on a question
    Then the answer should expand
    And I should see the full response
    And I should collapse it again

  @happy-path @faqs
  Scenario: Search within FAQs
    Given I am viewing FAQs
    When I search for a topic
    Then matching FAQs should be shown
    And search terms should be highlighted
    And I should find my answer

  @happy-path @faqs
  Scenario: View FAQs by category
    Given I am viewing FAQs
    When I filter by category
    Then only that category's FAQs should show
    And I should clear the filter
    And counts should update

  @happy-path @faqs
  Scenario: Rate FAQ helpfulness
    Given I have read an FAQ answer
    When I rate its helpfulness
    Then my rating should be recorded
    And I should provide optional feedback
    And the rating should be acknowledged

  # ============================================================================
  # TUTORIALS
  # ============================================================================

  @happy-path @tutorials
  Scenario: View available tutorials
    Given I am in the help center
    When I access tutorials
    Then I should see all tutorials
    And I should see tutorial descriptions
    And I should see completion status

  @happy-path @tutorials
  Scenario: Start a tutorial
    Given I am viewing tutorials
    When I start a tutorial
    Then the tutorial should begin
    And I should see step-by-step instructions
    And I should navigate through steps

  @happy-path @tutorials
  Scenario: Complete tutorial step
    Given I am in a tutorial
    When I complete a step
    Then progress should be saved
    And I should advance to next step
    And completion should be marked

  @happy-path @tutorials
  Scenario: Resume interrupted tutorial
    Given I started a tutorial previously
    When I return to tutorials
    Then I should see my progress
    And I should resume where I left off
    And I should start over if desired

  @happy-path @tutorials
  Scenario: View tutorial completion certificate
    Given I completed a tutorial
    When I view my achievements
    Then I should see completion badge
    And I should see completion date
    And I should share achievement

  @happy-path @tutorials
  Scenario: Replay completed tutorial
    Given I completed a tutorial
    When I choose to replay
    Then the tutorial should restart
    And I should go through steps again
    And completion should be preserved

  # ============================================================================
  # USER GUIDES
  # ============================================================================

  @happy-path @user-guides
  Scenario: Access user guides
    Given I am in the help center
    When I view user guides
    Then I should see comprehensive guides
    And I should see guide sections
    And I should navigate guides

  @happy-path @user-guides
  Scenario: View guide table of contents
    Given I am reading a user guide
    When I view table of contents
    Then I should see all sections
    And I should jump to any section
    And my position should be highlighted

  @happy-path @user-guides
  Scenario: Print user guide
    Given I am viewing a user guide
    When I print the guide
    Then a print-friendly version should generate
    And formatting should be appropriate
    And I should print or save as PDF

  @happy-path @user-guides
  Scenario: Download user guide
    Given I am viewing a user guide
    When I download the guide
    Then I should receive a PDF
    And the PDF should be complete
    And it should be viewable offline

  @happy-path @user-guides
  Scenario: Bookmark guide section
    Given I am reading a user guide
    When I bookmark a section
    Then the bookmark should be saved
    And I should access my bookmarks
    And I should return to that section

  # ============================================================================
  # CONTEXTUAL HELP
  # ============================================================================

  @happy-path @contextual-help
  Scenario: View contextual help on page
    Given I am on a feature page
    When I click the help icon
    Then I should see help specific to that page
    And I should see relevant tips
    And I should access full documentation

  @happy-path @contextual-help
  Scenario: View help for specific element
    Given I am interacting with a feature
    When I request help for that element
    Then I should see targeted help
    And I should see examples
    And I should see related topics

  @happy-path @contextual-help
  Scenario: Access help from error message
    Given I encounter an error
    When I click help on the error
    Then I should see troubleshooting steps
    And I should see common causes
    And I should resolve the issue

  @happy-path @contextual-help
  Scenario: Contextual help in forms
    Given I am filling out a form
    When I access field help
    Then I should see field requirements
    And I should see examples
    And I should understand the field

  @happy-path @contextual-help
  Scenario: Dismiss contextual help
    Given contextual help is showing
    When I dismiss the help
    Then it should close
    And my preference should be remembered
    And I should reopen if needed

  # ============================================================================
  # TOOLTIPS
  # ============================================================================

  @happy-path @tooltips
  Scenario: View tooltip on hover
    Given I am viewing a page with tooltips
    When I hover over an element
    Then a tooltip should appear
    And it should explain the element
    And it should be positioned correctly

  @happy-path @tooltips
  Scenario: View tooltip with keyboard
    Given I am navigating with keyboard
    When I focus on an element
    Then the tooltip should appear
    And I should read the information
    And it should dismiss on blur

  @happy-path @tooltips
  Scenario: Configure tooltip preferences
    Given I want to control tooltips
    When I configure tooltip settings
    Then I should enable or disable tooltips
    And I should set display delay
    And preferences should be saved

  @happy-path @tooltips
  Scenario: View extended tooltip information
    Given I see a basic tooltip
    When I want more information
    Then I should expand the tooltip
    And I should see detailed help
    And I should access full article

  # ============================================================================
  # ONBOARDING WALKTHROUGHS
  # ============================================================================

  @happy-path @onboarding
  Scenario: Complete new user onboarding
    Given I am a new user
    When I log in for the first time
    Then I should see onboarding walkthrough
    And it should guide me through features
    And I should complete or skip

  @happy-path @onboarding
  Scenario: Progress through onboarding steps
    Given I am in the onboarding flow
    When I complete each step
    Then I should advance through the flow
    And I should see progress indicator
    And I should go back if needed

  @happy-path @onboarding
  Scenario: Skip onboarding
    Given I am in onboarding
    When I choose to skip
    Then onboarding should end
    And I should access the app
    And I should restart onboarding later

  @happy-path @onboarding
  Scenario: Restart onboarding later
    Given I skipped or completed onboarding
    When I want to revisit it
    Then I should access it from help
    And it should restart from beginning
    And I should go through it again

  @happy-path @onboarding
  Scenario: Feature-specific onboarding
    Given I access a new feature
    When I see the feature for the first time
    Then I should get feature onboarding
    And it should explain the feature
    And I should complete or dismiss

  @happy-path @onboarding
  Scenario: Interactive onboarding highlights
    Given I am in onboarding
    When a step highlights an element
    Then the element should be spotlighted
    And I should interact with it
    And the walkthrough should proceed

  # ============================================================================
  # VIDEO TUTORIALS
  # ============================================================================

  @happy-path @video-tutorials
  Scenario: View video tutorial library
    Given I am in the help center
    When I access video tutorials
    Then I should see available videos
    And I should see thumbnails and durations
    And I should filter by topic

  @happy-path @video-tutorials
  Scenario: Play video tutorial
    Given I am viewing video library
    When I play a video
    Then the video should start playing
    And I should have playback controls
    And I should watch in various quality

  @happy-path @video-tutorials
  Scenario: Navigate video chapters
    Given I am watching a video
    When I view chapters
    Then I should see chapter list
    And I should jump to any chapter
    And my position should be tracked

  @happy-path @video-tutorials
  Scenario: View video transcript
    Given I am watching a video
    When I view the transcript
    Then I should see full transcript
    And it should sync with video
    And I should search the transcript

  @happy-path @video-tutorials
  Scenario: Save video for later
    Given I found a useful video
    When I save it for later
    Then it should be added to my list
    And I should access saved videos
    And I should watch later

  @happy-path @video-tutorials
  Scenario: Rate video tutorial
    Given I finished watching a video
    When I rate the video
    Then my rating should be recorded
    And I should add a review
    And feedback should be acknowledged

  # ============================================================================
  # SEARCH FUNCTIONALITY
  # ============================================================================

  @happy-path @help-search
  Scenario: Search help content
    Given I am in the help center
    When I search for a topic
    Then I should see search results
    And results should be relevant
    And I should see result snippets

  @happy-path @help-search
  Scenario: Filter search results
    Given I have search results
    When I filter by content type
    Then results should be filtered
    And I should filter by articles, videos, FAQs
    And counts should update

  @happy-path @help-search
  Scenario: Search with autocomplete
    Given I am typing a search query
    When suggestions appear
    Then I should see autocomplete options
    And I should select a suggestion
    And search should execute

  @happy-path @help-search
  Scenario: No search results found
    Given I search for something obscure
    When no results are found
    Then I should see no results message
    And I should see suggestions
    And I should try different terms

  @happy-path @help-search
  Scenario: View search history
    Given I have searched before
    When I view search history
    Then I should see recent searches
    And I should click to search again
    And I should clear history

  # ============================================================================
  # SUPPORT TICKETS
  # ============================================================================

  @happy-path @support-tickets
  Scenario: Create support ticket
    Given I need assistance
    When I create a support ticket
    Then I should describe my issue
    And I should select a category
    And the ticket should be submitted

  @happy-path @support-tickets
  Scenario: Attach files to ticket
    Given I am creating a ticket
    When I attach files
    Then files should be uploaded
    And they should be visible on ticket
    And support should access them

  @happy-path @support-tickets
  Scenario: View my support tickets
    Given I have submitted tickets
    When I view my tickets
    Then I should see all my tickets
    And I should see status of each
    And I should view ticket details

  @happy-path @support-tickets
  Scenario: Reply to support ticket
    Given I have an open ticket
    When I receive a response
    Then I should be notified
    And I should view the response
    And I should reply back

  @happy-path @support-tickets
  Scenario: Close support ticket
    Given my issue is resolved
    When I close the ticket
    Then the ticket should be closed
    And I should rate the support
    And I should provide feedback

  @happy-path @support-tickets
  Scenario: Escalate support ticket
    Given my issue is not resolved
    When I escalate the ticket
    Then it should be escalated
    And higher support should review
    And I should be notified of update

  # ============================================================================
  # LIVE CHAT SUPPORT
  # ============================================================================

  @happy-path @live-chat
  Scenario: Start live chat session
    Given I need immediate help
    When I start live chat
    Then I should connect to support
    And I should see chat interface
    And I should communicate in real-time

  @happy-path @live-chat
  Scenario: View agent availability
    Given I want to chat
    When I check availability
    Then I should see if agents are online
    And I should see wait time
    And I should queue or leave message

  @happy-path @live-chat
  Scenario: Chat with support agent
    Given I am in a chat session
    When I exchange messages
    Then messages should send instantly
    And I should see typing indicators
    And the conversation should flow

  @happy-path @live-chat
  Scenario: Share screen in chat
    Given I need to show an issue
    When I share my screen
    Then the agent should see my screen
    And they should guide me visually
    And I should stop sharing

  @happy-path @live-chat
  Scenario: Request chat transcript
    Given my chat session ended
    When I request transcript
    Then I should receive chat history
    And it should be emailed or downloaded
    And I should keep for reference

  @happy-path @live-chat
  Scenario: Rate chat support experience
    Given my chat session ended
    When I rate the experience
    Then my rating should be recorded
    And I should provide comments
    And feedback should improve service

  # ============================================================================
  # FEEDBACK SUBMISSION
  # ============================================================================

  @happy-path @feedback
  Scenario: Submit general feedback
    Given I have feedback to share
    When I submit feedback
    Then I should describe my feedback
    And I should categorize it
    And feedback should be submitted

  @happy-path @feedback
  Scenario: Submit feature request
    Given I have a feature idea
    When I submit a request
    Then I should describe the feature
    And I should explain the benefit
    And the request should be logged

  @happy-path @feedback
  Scenario: Report a bug
    Given I found a bug
    When I report the bug
    Then I should describe the issue
    And I should provide reproduction steps
    And the bug should be submitted

  @happy-path @feedback
  Scenario: Submit feedback with screenshot
    Given I am providing feedback
    When I attach a screenshot
    Then the image should upload
    And it should be included with feedback
    And support should see it

  @happy-path @feedback
  Scenario: Track feedback status
    Given I submitted feedback
    When I check feedback status
    Then I should see if it's reviewed
    And I should see any responses
    And I should see if implemented

  # ============================================================================
  # KNOWLEDGE BASE
  # ============================================================================

  @happy-path @knowledge-base
  Scenario: Browse knowledge base
    Given I am in the help center
    When I access knowledge base
    Then I should see all documentation
    And I should browse by category
    And I should find detailed articles

  @happy-path @knowledge-base
  Scenario: View knowledge base article
    Given I am browsing knowledge base
    When I open an article
    Then I should see full content
    And I should see related articles
    And I should navigate easily

  @happy-path @knowledge-base
  Scenario: Share knowledge base article
    Given I found a helpful article
    When I share the article
    Then I should copy the link
    And I should share via email
    And I should share socially

  @happy-path @knowledge-base
  Scenario: Subscribe to article updates
    Given I am viewing an article
    When I subscribe to updates
    Then I should be notified of changes
    And I should receive update notifications
    And I should unsubscribe later

  # ============================================================================
  # GLOSSARY OF TERMS
  # ============================================================================

  @happy-path @glossary
  Scenario: View glossary
    Given I am in the help center
    When I access the glossary
    Then I should see fantasy football terms
    And they should be alphabetized
    And I should navigate by letter

  @happy-path @glossary
  Scenario: Search glossary
    Given I am viewing glossary
    When I search for a term
    Then matching terms should show
    And I should see definitions
    And related terms should appear

  @happy-path @glossary
  Scenario: View term definition
    Given I am in the glossary
    When I click on a term
    Then I should see the definition
    And I should see examples
    And I should see related terms

  @happy-path @glossary
  Scenario: Link to glossary from content
    Given I am reading an article
    When I see a glossary term
    Then it should be linked
    And clicking should show definition
    And I should return to article

  # ============================================================================
  # TROUBLESHOOTING GUIDES
  # ============================================================================

  @happy-path @troubleshooting
  Scenario: Access troubleshooting guides
    Given I am having an issue
    When I access troubleshooting
    Then I should see common issues
    And I should see step-by-step solutions
    And I should find my issue

  @happy-path @troubleshooting
  Scenario: Follow troubleshooting steps
    Given I am in a troubleshooting guide
    When I follow the steps
    Then steps should be clear
    And I should mark steps complete
    And I should resolve the issue

  @happy-path @troubleshooting
  Scenario: Troubleshoot with decision tree
    Given I have a complex issue
    When I use the decision tree
    Then I should answer questions
    And the tree should guide me
    And I should reach a solution

  @happy-path @troubleshooting
  Scenario: Report unresolved issue
    Given troubleshooting didn't help
    When I report the issue
    Then I should create a ticket
    And troubleshooting steps should be included
    And support should have context

  # ============================================================================
  # ERROR HANDLING
  # ============================================================================

  @error
  Scenario: Help content fails to load
    Given I try to access help
    When content fails to load
    Then I should see an error message
    And I should be able to retry
    And I should contact support directly

  @error
  Scenario: Search returns error
    Given I search for help
    When search fails
    Then I should see an error
    And I should try again
    And alternate search should be offered

  @error
  Scenario: Video fails to play
    Given I try to play a video
    When playback fails
    Then I should see an error
    And I should retry playback
    And alternate format should be offered

  @error
  Scenario: Chat connection fails
    Given I try to start chat
    When connection fails
    Then I should see connection error
    And I should retry or leave message
    And ticket option should be available

  # ============================================================================
  # MOBILE EXPERIENCE
  # ============================================================================

  @mobile
  Scenario: Access help on mobile
    Given I am using the mobile app
    When I access help center
    Then the layout should be mobile-optimized
    And navigation should be touch-friendly
    And content should be readable

  @mobile
  Scenario: Watch video tutorials on mobile
    Given I am on mobile
    When I watch tutorials
    Then videos should play properly
    And controls should work on touch
    And quality should adapt to connection

  @mobile
  Scenario: Use live chat on mobile
    Given I am on mobile
    When I use live chat
    Then chat should work on mobile
    And keyboard should not obstruct
    And notifications should work

  @mobile
  Scenario: Submit feedback on mobile
    Given I am on mobile
    When I submit feedback
    Then the form should work on mobile
    And I should attach screenshots
    And submission should complete

  # ============================================================================
  # ACCESSIBILITY
  # ============================================================================

  @accessibility
  Scenario: Navigate help with keyboard
    Given I am using keyboard navigation
    When I navigate help center
    Then all content should be accessible
    And focus should move logically
    And I should access all features

  @accessibility
  Scenario: Screen reader help access
    Given I am using a screen reader
    When I use help features
    Then content should be announced
    And navigation should be clear
    And videos should have descriptions

  @accessibility
  Scenario: High contrast help display
    Given I have high contrast enabled
    When I view help content
    Then text should be readable
    And images should be visible
    And links should be distinguishable

  @accessibility
  Scenario: Captions on video tutorials
    Given I need captions
    When I watch videos
    Then captions should be available
    And they should be accurate
    And I should customize display
