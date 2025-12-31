@ANIMA-1418 @backend @priority_2 @help
Feature: Help System
  As a fantasy football playoffs platform user
  I want to access help resources, documentation, and support
  So that I can find answers to my questions and resolve issues

  Background:
    Given the help system is enabled
    And help content is available in the user's language

  # ==================== HELP CENTER ====================

  Scenario: Access help center
    Given a user navigates to the help center
    When the help center loads
    Then the user sees:
      | Section             | Content                           |
      | Search Bar          | Prominent search input            |
      | Popular Topics      | Most accessed help articles       |
      | Categories          | Organized help categories         |
      | Quick Links         | Common actions and guides         |
      | Contact Support     | Link to support options           |
    And the help center is accessible from all pages

  Scenario: Browse help categories
    Given the user is on the help center
    When the user views categories
    Then categories are displayed:
      | Category            | Article Count | Description              |
      | Getting Started     | 12            | New user guides          |
      | Roster Management   | 18            | Managing your team       |
      | Scoring & Rules     | 15            | How scoring works        |
      | League Management   | 20            | Commissioner tools       |
      | Account & Settings  | 10            | Profile and preferences  |
      | Troubleshooting     | 25            | Common issues            |
    And each category is clickable

  Scenario: View help article
    Given the user selects an article "How to Set Your Lineup"
    When the article loads
    Then the article displays:
      | Element             | Content                           |
      | Title               | How to Set Your Lineup            |
      | Last Updated        | January 15, 2025                  |
      | Content             | Step-by-step instructions         |
      | Images              | Screenshots if applicable         |
      | Related Articles    | Links to similar topics           |
      | Helpfulness Rating  | "Was this helpful?" prompt        |
    And table of contents is shown for long articles

  Scenario: Rate article helpfulness
    Given the user reads a help article
    When the user rates the article
    Then rating options include:
      | Rating              | Action                            |
      | Helpful             | Record positive feedback          |
      | Not Helpful         | Prompt for improvement feedback   |
    And feedback is stored for analytics
    And thank you message is displayed

  Scenario: Navigate help center breadcrumbs
    Given the user is viewing a nested help article
    When breadcrumbs are displayed
    Then navigation shows:
      | Level               | Link                              |
      | Help Center         | Return to main help               |
      | Roster Management   | Parent category                   |
      | Setting Lineups     | Current article                   |
    And breadcrumbs are clickable for navigation

  # ==================== FAQ SECTION ====================

  Scenario: View frequently asked questions
    Given the user accesses the FAQ section
    When the FAQ page loads
    Then FAQs are organized:
      | Category            | Questions                         |
      | General             | What is FFL Playoffs?             |
      | Scoring             | How are points calculated?        |
      | Roster              | When is the roster deadline?      |
      | Leagues             | How do I join a league?           |
      | Payments            | Are there entry fees?             |
    And questions are expandable/collapsible

  Scenario: Expand FAQ answer
    Given the user sees a FAQ question
    When the user clicks on the question
    Then the answer expands with:
      | Element             | Content                           |
      | Answer Text         | Detailed response                 |
      | Related Links       | Links to full articles            |
      | Last Updated        | Date of last revision             |
    And other FAQs remain collapsed
    And clicking again collapses the answer

  Scenario: Filter FAQs by category
    Given the user wants specific FAQ category
    When the user selects "Scoring" category
    Then only scoring-related FAQs are shown:
      | Question                                  |
      | How are points calculated?                |
      | What is PPR scoring?                      |
      | How do bonus points work?                 |
      | When do scores update?                    |
    And category filter is visible
    And "Show All" option is available

  Scenario: Search within FAQs
    Given the user wants to search FAQs
    When the user enters "deadline"
    Then matching FAQs are highlighted:
      | Question                                  | Match         |
      | When is the roster deadline?              | deadline      |
      | What happens after trade deadline?        | deadline      |
    And search term is highlighted in results
    And "No results" message if none match

  Scenario: Submit new FAQ suggestion
    Given the user doesn't find their question
    When the user clicks "Suggest a Question"
    Then the suggestion form shows:
      | Field               | Required | Validation              |
      | Your Question       | Yes      | Min 10 characters       |
      | Category            | Yes      | Dropdown selection      |
      | Email               | No       | Valid email if provided |
    And suggestion is submitted to content team
    And confirmation is shown

  # ==================== CONTACT SUPPORT ====================

  Scenario: Access support options
    Given the user needs to contact support
    When the user accesses contact support
    Then support options are displayed:
      | Option              | Availability    | Response Time    |
      | Live Chat           | 9AM-9PM EST     | < 5 minutes      |
      | Email Support       | 24/7            | < 24 hours       |
      | Phone Support       | 9AM-5PM EST     | Immediate        |
      | Submit Ticket       | 24/7            | < 48 hours       |
    And current wait times are shown
    And hours are displayed in user's timezone

  Scenario: Start live chat
    Given live chat is available
    When the user clicks "Start Chat"
    Then the chat interface shows:
      | Element             | Content                           |
      | Chat Window         | Expandable chat interface         |
      | Agent Status        | "Connecting to agent..."          |
      | Queue Position      | If applicable                     |
      | Pre-chat Form       | Name, issue category              |
    And chat history is preserved during session

  Scenario: Chat with support agent
    Given the user is connected to an agent
    When the conversation is active
    Then chat features include:
      | Feature             | Description                       |
      | Text Messages       | Send and receive messages         |
      | File Attachments    | Share screenshots                 |
      | Emoji Support       | Express sentiment                 |
      | Typing Indicator    | Shows when agent is typing        |
      | Chat Transcript     | Option to email transcript        |
    And agent can transfer to specialist if needed

  Scenario: Submit support ticket
    Given the user chooses to submit a ticket
    When the ticket form loads
    Then required fields include:
      | Field               | Type            | Required        |
      | Subject             | Text            | Yes             |
      | Category            | Dropdown        | Yes             |
      | Description         | Textarea        | Yes             |
      | Priority            | Dropdown        | No (auto-set)   |
      | Attachments         | File upload     | No              |
      | Affected League     | Dropdown        | No              |
    And ticket number is generated on submission

  Scenario: Track support ticket status
    Given the user has submitted a ticket
    When the user checks ticket status
    Then status information shows:
      | Ticket #            | 12345                             |
      | Status              | In Progress                       |
      | Created             | January 20, 2025 2:30 PM          |
      | Last Updated        | January 20, 2025 4:15 PM          |
      | Agent Assigned      | Support Agent Name                |
      | Responses           | Threaded conversation             |
    And user can add follow-up messages

  Scenario: Email support directly
    Given the user chooses email support
    When the email option is selected
    Then the system provides:
      | Element             | Content                           |
      | Email Address       | support@fflplayoffs.com           |
      | Template            | Pre-filled subject if from app    |
      | Instructions        | What to include in email          |
      | Alternative         | Open in email client button       |
    And email includes user context if logged in

  # ==================== DOCUMENTATION ====================

  Scenario: Access documentation library
    Given the user accesses documentation
    When the documentation page loads
    Then documentation is organized:
      | Section             | Content                           |
      | User Guides         | Step-by-step tutorials            |
      | Rule Book           | Official rules and policies       |
      | API Documentation   | For developers (if applicable)    |
      | Release Notes       | Version history and changes       |
    And documentation is searchable

  Scenario: View user guide
    Given the user selects "Complete User Guide"
    When the guide loads
    Then the guide includes:
      | Chapter             | Topics                            |
      | 1. Introduction     | Platform overview                 |
      | 2. Getting Started  | Registration, profile setup       |
      | 3. Leagues          | Joining, creating, managing       |
      | 4. Rosters          | Building and managing teams       |
      | 5. Scoring          | Understanding point systems       |
      | 6. Playoffs         | Bracket and elimination           |
    And chapters are navigable via sidebar
    And progress can be tracked

  Scenario: View rules and policies
    Given the user accesses the rule book
    When rules are displayed
    Then rules cover:
      | Section             | Content                           |
      | Scoring Rules       | Point values for all stats        |
      | Roster Rules        | Position limits, deadlines        |
      | Trading Rules       | Trade windows, veto process       |
      | Fair Play Policy    | Collusion, tanking prevention     |
      | Privacy Policy      | Data handling practices           |
      | Terms of Service    | Legal agreements                  |
    And rules are versioned with effective dates

  Scenario: Download documentation
    Given the user wants offline documentation
    When download options are shown
    Then formats available include:
      | Format              | Description                       |
      | PDF                 | Complete guide in PDF             |
      | Print Version       | Printer-friendly format           |
      | Offline App         | In-app offline mode               |
    And downloads include current version date
    And file size is indicated

  Scenario: View release notes
    Given the user checks release notes
    When release history loads
    Then versions are listed:
      | Version  | Date       | Highlights                       |
      | 2.5.0    | 2025-01-15 | New scoring options              |
      | 2.4.2    | 2025-01-08 | Bug fixes                        |
      | 2.4.0    | 2024-12-20 | Playoff bracket improvements     |
    And each version expands to show full details
    And "What's New" banner highlights latest changes

  # ==================== VIDEO TUTORIALS ====================

  Scenario: Access video tutorial library
    Given the user accesses video tutorials
    When the tutorial library loads
    Then videos are organized:
      | Category            | Video Count | Total Duration   |
      | Getting Started     | 5           | 15 minutes       |
      | Roster Management   | 8           | 25 minutes       |
      | Scoring Explained   | 4           | 12 minutes       |
      | Advanced Strategies | 6           | 30 minutes       |
    And videos have thumbnails
    And difficulty level is indicated

  Scenario: Watch video tutorial
    Given the user selects a tutorial video
    When the video player loads
    Then player features include:
      | Feature             | Description                       |
      | Play/Pause          | Video controls                    |
      | Progress Bar        | Seekable timeline                 |
      | Playback Speed      | 0.5x, 1x, 1.5x, 2x               |
      | Closed Captions     | Toggle on/off                     |
      | Full Screen         | Expand to full screen             |
      | Quality Settings    | Auto, 720p, 1080p                 |
    And video remembers playback position

  Scenario: Track video progress
    Given the user is watching tutorials
    When progress is tracked
    Then the user sees:
      | Video Title              | Progress | Status      |
      | Introduction to FFL      | 100%     | Completed   |
      | Setting Your First Lineup| 50%      | In Progress |
      | Understanding Scoring    | 0%       | Not Started |
    And completion badges are awarded
    And "Continue Watching" section is available

  Scenario: Search video tutorials
    Given the user searches for a topic
    When the user enters "waiver wire"
    Then matching videos are shown:
      | Video Title                  | Duration | Relevance |
      | Waiver Wire Strategies       | 5:30     | High      |
      | Weekly Roster Adjustments    | 4:15     | Medium    |
    And search highlights matching content
    And timestamp links to relevant sections

  Scenario: Share video tutorial
    Given the user wants to share a video
    When share options are displayed
    Then sharing methods include:
      | Method              | Action                            |
      | Copy Link           | Copy URL to clipboard             |
      | Email               | Send via email                    |
      | Social Media        | Share to Twitter, Facebook        |
      | Embed Code          | For websites/blogs                |
    And share includes timestamp option

  # ==================== TROUBLESHOOTING ====================

  Scenario: Access troubleshooting guide
    Given the user has an issue
    When the troubleshooting section loads
    Then common issues are listed:
      | Issue Category      | Common Problems                   |
      | Login Issues        | Can't log in, forgot password     |
      | Roster Problems     | Can't add player, lineup locked   |
      | Scoring Errors      | Points not updating, wrong score  |
      | League Issues       | Can't join, commissioner problems |
      | App Performance     | Slow loading, crashes             |
    And each category links to solutions

  Scenario: Use guided troubleshooter
    Given the user starts guided troubleshooting
    When the troubleshooter loads
    Then step-by-step guidance shows:
      | Step | Question                          | Options           |
      | 1    | What type of issue?               | Login, Roster, etc|
      | 2    | When did it start?                | Today, This week  |
      | 3    | What have you tried?              | Checkbox options  |
      | 4    | Device and browser?               | Auto-detected     |
    And solutions are suggested based on answers
    And escalation to support if unresolved

  Scenario: View known issues
    Given the user checks for known issues
    When the known issues page loads
    Then current issues are displayed:
      | Issue               | Status      | Workaround        | ETA       |
      | Score delay         | Investigating| Refresh page     | 2 hours   |
      | iOS app crash       | Fix deployed | Update app       | Resolved  |
      | Trade notifications | Known       | Check manually    | Next week |
    And users can subscribe to updates
    And resolved issues move to history

  Scenario: Report a new issue
    Given the issue isn't in known issues
    When the user reports a problem
    Then the report form includes:
      | Field               | Purpose                           |
      | Issue Description   | What's happening                  |
      | Steps to Reproduce  | How to trigger the issue          |
      | Expected Behavior   | What should happen                |
      | Screenshots         | Visual evidence                   |
      | System Info         | Auto-captured device details      |
    And issue is logged in tracking system

  Scenario: Self-service fixes
    Given common issues have quick fixes
    When self-service options are shown
    Then available actions include:
      | Issue               | Self-Service Fix                  |
      | Cache issues        | "Clear Cache" button              |
      | Session expired     | "Re-authenticate" link            |
      | Sync problems       | "Force Sync" button               |
      | Display issues      | "Reset Display Settings"          |
    And actions execute immediately
    And confirmation of success/failure shown

  # ==================== CONTEXTUAL HELP ====================

  Scenario: Display contextual help tooltips
    Given the user hovers over a feature
    When a tooltip is triggered
    Then the tooltip shows:
      | Element             | Content                           |
      | Brief Explanation   | One-line description              |
      | Learn More Link     | Link to full documentation        |
      | Dismiss Option      | "Don't show again" checkbox       |
    And tooltips are non-intrusive
    And consistent across the platform

  Scenario: Show help for form fields
    Given the user is filling out a form
    When help icons are present
    Then clicking help icon shows:
      | Field               | Help Content                      |
      | Username            | "3-20 characters, letters/numbers"|
      | Roster Deadline     | "Last time to change lineup"      |
      | Scoring Type        | "PPR adds 1 point per reception"  |
    And help appears inline or as popup
    And doesn't obstruct form input

  Scenario: Contextual help in roster view
    Given the user is viewing their roster
    When contextual help is available
    Then help appears for:
      | Element             | Help Content                      |
      | Player Status       | "Q = Questionable, O = Out"       |
      | Bye Week            | "Player's team not playing"       |
      | Projected Points    | "Estimated points for this week"  |
      | Position Lock       | "Position locks when game starts" |
    And help adapts to user's experience level

  Scenario: First-time feature introduction
    Given the user encounters a new feature
    When the feature is first accessed
    Then an introduction shows:
      | Element             | Content                           |
      | Feature Name        | Name of the feature               |
      | Description         | What the feature does             |
      | Quick Tutorial      | 3-step visual guide               |
      | Try It Now          | Interactive prompt                |
    And introduction can be skipped
    And can be accessed again from help

  Scenario: Contextual help based on user state
    Given the user's context affects help
    When help is displayed
    Then help is personalized:
      | User State          | Help Focus                        |
      | New User            | Basic concepts, getting started   |
      | Playoff Bound       | Playoff strategies, bracket info  |
      | Commissioner        | League management tips            |
      | Eliminated          | Next season prep, stats review    |
    And personalization improves relevance

  # ==================== FEEDBACK SUBMISSION ====================

  Scenario: Submit general feedback
    Given the user wants to provide feedback
    When the feedback form loads
    Then the form includes:
      | Field               | Type            | Required        |
      | Feedback Type       | Dropdown        | Yes             |
      | Message             | Textarea        | Yes             |
      | Rating              | 1-5 stars       | No              |
      | Contact Preference  | Checkbox        | No              |
    And feedback is anonymous by default
    And submission is confirmed

  Scenario: Submit feature request
    Given the user has a feature idea
    When the feature request form loads
    Then the form includes:
      | Field               | Description                       |
      | Feature Title       | Brief name for the feature        |
      | Description         | Detailed explanation              |
      | Use Case            | Why this would be useful          |
      | Priority            | How important to the user         |
    And similar requests are shown
    And users can vote on existing requests

  Scenario: Report a bug
    Given the user encounters a bug
    When the bug report form loads
    Then required information includes:
      | Field               | Auto-filled     | User Input      |
      | Browser/Device      | Yes             | Editable        |
      | App Version         | Yes             | Display only    |
      | Current Page        | Yes             | Display only    |
      | Bug Description     | No              | Required        |
      | Steps to Reproduce  | No              | Required        |
      | Screenshots         | No              | Optional        |
    And bug is assigned tracking number

  Scenario: View feedback status
    Given the user has submitted feedback
    When the user checks status
    Then feedback status shows:
      | Feedback            | Status          | Response        |
      | Add dark mode       | Under Review    | -               |
      | Fix scoring bug     | Resolved        | Fixed in v2.5   |
      | New stat columns    | Planned         | Q2 2025         |
    And users receive notifications on updates

  Scenario: Participate in user surveys
    Given a survey is available
    When the survey prompt appears
    Then survey features include:
      | Element             | Description                       |
      | Survey Length       | Estimated time shown              |
      | Progress Indicator  | Shows completion percentage       |
      | Skip Option         | Can skip individual questions     |
      | Save Progress       | Resume later if needed            |
    And survey responses are confidential
    And incentives may be offered

  # ==================== COMMUNITY FORUM ====================

  Scenario: Access community forum
    Given the user navigates to the forum
    When the forum loads
    Then forum structure shows:
      | Section             | Description                       |
      | General Discussion  | Open fantasy football topics      |
      | Strategy & Tips     | Advice and recommendations        |
      | League Help         | Commissioner and league questions |
      | Bug Reports         | Technical issue discussions       |
      | Feature Requests    | Ideas and suggestions             |
    And recent activity is highlighted

  Scenario: View forum thread
    Given the user selects a thread
    When the thread loads
    Then the display includes:
      | Element             | Content                           |
      | Original Post       | Thread starter's message          |
      | Replies             | Chronological responses           |
      | Author Info         | Username, join date, post count   |
      | Voting              | Upvote/downvote buttons           |
      | Reply Button        | Option to respond                 |
    And thread is paginated if long

  Scenario: Create forum post
    Given the user wants to start a discussion
    When the post creation form loads
    Then the form includes:
      | Field               | Description                       |
      | Title               | Thread title                      |
      | Category            | Forum section                     |
      | Content             | Rich text editor                  |
      | Tags                | Relevant keywords                 |
      | Poll Option         | Optional poll creation            |
    And post is previewed before submission
    And guidelines are displayed

  Scenario: Reply to forum post
    Given the user wants to reply
    When the reply form is shown
    Then reply features include:
      | Feature             | Description                       |
      | Rich Text           | Formatting options                |
      | Quote               | Quote previous message            |
      | Mention             | @mention other users              |
      | Attachments         | Images and files                  |
    And reply appears after submission
    And author is notified

  Scenario: Search forum
    Given the user searches the forum
    When the search is executed
    Then results show:
      | Result              | Metadata                          |
      | Thread Title        | With highlighted match            |
      | Post Excerpt        | Relevant content snippet          |
      | Author              | Who posted it                     |
      | Date                | When it was posted                |
    And filters for date, author, category
    And sort by relevance or date

  Scenario: Moderate forum content
    Given a user has moderation privileges
    When moderation tools are accessed
    Then available actions include:
      | Action              | Description                       |
      | Edit Post           | Modify content                    |
      | Delete Post         | Remove content                    |
      | Lock Thread         | Prevent new replies               |
      | Move Thread         | Change category                   |
      | Warn User           | Issue warning to author           |
    And actions are logged
    And appeals process exists

  # ==================== HELP SEARCH ====================

  Scenario: Search help content
    Given the user uses help search
    When the user enters "roster deadline"
    Then search results include:
      | Type                | Result                            |
      | FAQ                 | When is the roster deadline?      |
      | Article             | Understanding Roster Deadlines    |
      | Video               | Deadline Strategies Tutorial      |
      | Forum               | Deadline question threads         |
    And results are ranked by relevance
    And content type icons are shown

  Scenario: Search with autocomplete
    Given the user types in search
    When characters are entered
    Then autocomplete suggests:
      | Input   | Suggestions                       |
      | "sco"   | scoring, score update, scout      |
      | "ros"   | roster, roster deadline, roster lock |
      | "lea"   | league, league settings, leave    |
    And suggestions update in real-time
    And keyboard navigation works

  Scenario: Filter search results
    Given search returns mixed results
    When the user applies filters
    Then filter options include:
      | Filter Type         | Options                           |
      | Content Type        | Articles, FAQs, Videos, Forum     |
      | Date                | Last week, month, year, all       |
      | Category            | All help categories               |
    And filters combine with search
    And filter counts are shown

  Scenario: Search finds no results
    Given the user searches for obscure term
    When no results are found
    Then the system displays:
      | Element             | Content                           |
      | Message             | "No results for 'obscure term'"   |
      | Suggestions         | Similar search terms              |
      | Popular Topics      | Common help articles              |
      | Contact Support     | Link to get help                  |
    And search analytics record failed search

  Scenario: Search with synonyms
    Given the user uses informal terms
    When searching for "add player"
    Then results also match:
      | Synonym Term        | Matched Content                   |
      | "roster move"       | Making Roster Changes article     |
      | "pickup"            | Waiver Wire guide                 |
      | "claim player"      | Player Claims FAQ                 |
    And synonym matching improves results
    And exact matches appear first

  Scenario: Voice search in help
    Given voice search is enabled
    When the user activates voice input
    Then the system:
      | Shows listening indicator               |
      | Transcribes spoken query                |
      | Executes search with transcript         |
      | Allows correction if misheard           |
    And voice search works on mobile
    And privacy notice is shown

  # ==================== HELP ACCESSIBILITY ====================

  Scenario: Accessible help content
    Given the user has accessibility needs
    When accessing help
    Then accessibility features include:
      | Feature             | Implementation                    |
      | Screen Reader       | All content readable              |
      | Keyboard Navigation | Full keyboard access              |
      | High Contrast       | Enhanced visibility mode          |
      | Text Scaling        | Responsive font sizes             |
      | Alt Text            | All images described              |
    And WCAG 2.1 AA compliance maintained

  Scenario: Multi-language help
    Given the user prefers non-English
    When language is selected
    Then help content shows:
      | Content             | Availability                      |
      | Core Articles       | Fully translated                  |
      | FAQs                | Fully translated                  |
      | Videos              | Subtitles available               |
      | Forum               | User language, auto-translate     |
    And language preference is saved
    And fallback to English if unavailable

  # ==================== HELP ANALYTICS ====================

  Scenario: Track help usage
    Given help analytics are enabled
    When help is accessed
    Then tracking includes:
      | Metric              | Purpose                           |
      | Page Views          | Popular content identification    |
      | Search Terms        | Content gap analysis              |
      | Time on Page        | Content effectiveness             |
      | Exit Points         | Where users leave                 |
    And data improves help content
    And privacy is respected

  Scenario: Identify help content gaps
    Given analytics are reviewed
    When content gaps are identified
    Then insights show:
      | Gap Type            | Evidence                          |
      | Missing Topics      | High-volume failed searches       |
      | Unclear Content     | Low helpfulness ratings           |
      | Outdated Content    | Low engagement, old dates         |
    And recommendations are generated
    And content team is notified

  # ==================== ERROR HANDLING ====================

  Scenario: Handle help system unavailable
    Given the help system is down
    When the user accesses help
    Then fallback options show:
      | Option              | Content                           |
      | Cached Content      | Previously loaded articles        |
      | Contact Info        | Direct support contact            |
      | Status Page         | System status information         |
    And error is logged
    And auto-retry when available

  Scenario: Handle video playback error
    Given a video fails to load
    When playback error occurs
    Then the system shows:
      | Element             | Content                           |
      | Error Message       | "Video unavailable"               |
      | Retry Button        | Attempt to reload                 |
      | Alternative         | Text transcript of video          |
      | Report Issue        | Link to report problem            |
    And error is logged for investigation
