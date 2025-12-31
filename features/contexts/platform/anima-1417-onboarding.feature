@ANIMA-1417 @backend @priority_1 @onboarding
Feature: User Onboarding System
  As a new fantasy football playoffs platform user
  I want a guided onboarding experience
  So that I can quickly get started and understand the platform

  Background:
    Given the onboarding system is enabled
    And onboarding content is configured

  # ==================== WELCOME FLOW ====================

  Scenario: Display welcome screen for new user
    Given a new user has just registered
    When the user first accesses the platform
    Then the welcome screen displays:
      | Element             | Content                           |
      | Welcome Message     | "Welcome to FFL Playoffs!"        |
      | Platform Logo       | Animated logo display             |
      | Value Proposition   | Key benefits of the platform      |
      | Get Started Button  | Primary CTA to begin onboarding   |
      | Skip Option         | "Skip for now" link               |
    And the welcome screen is visually engaging

  Scenario: Show personalized welcome for returning incomplete user
    Given a user started but did not complete onboarding
    When the user logs in again
    Then the system displays:
      | Message             | "Welcome back! Let's pick up where you left off" |
      | Progress Indicator  | Shows completed steps                             |
      | Continue Button     | Resumes from last incomplete step                 |
      | Start Over Option   | Option to restart onboarding                      |
    And previous progress is preserved

  Scenario: Welcome flow for invited user
    Given a user was invited to join a specific league
    When the user completes registration
    Then the welcome flow is customized:
      | Element             | Content                           |
      | Inviter Name        | "john_doe invited you!"           |
      | League Name         | "FFL Championship League"         |
      | League Details      | Brief league description          |
      | Accept Invitation   | Primary CTA to join league        |
    And league joining is prioritized in onboarding

  Scenario: Welcome flow for mobile users
    Given a new user accesses via mobile device
    When the welcome screen loads
    Then mobile-optimized experience shows:
      | Element             | Optimization                      |
      | Layout              | Single column, touch-friendly     |
      | Buttons             | Large tap targets                 |
      | Text                | Concise, scannable                |
      | Progress            | Minimal steps visible             |
    And gestures are supported (swipe to continue)

  Scenario: Animated welcome introduction
    Given the user begins onboarding
    When the introduction plays
    Then the animation shows:
      | Sequence            | Content                           |
      | Step 1              | Platform overview (3 seconds)     |
      | Step 2              | Key features highlight            |
      | Step 3              | Success stories/testimonials      |
      | Step 4              | Call to action                    |
    And animation can be skipped
    And audio is muted by default

  # ==================== ACCOUNT SETUP ====================

  Scenario: Complete basic profile setup
    Given the user is on the account setup step
    When the setup form loads
    Then the user can enter:
      | Field               | Required | Validation                  |
      | Display Name        | Yes      | 2-50 characters             |
      | Username            | Yes      | Unique, alphanumeric        |
      | Profile Picture     | No       | Upload or skip              |
      | Timezone            | Yes      | Auto-detected, editable     |
    And progress is saved after each field

  Scenario: Validate username availability
    Given the user enters a username
    When the username is typed
    Then real-time validation shows:
      | Username        | Status      | Message                     |
      | john_doe        | Taken       | "Username already taken"    |
      | john_doe_2025   | Available   | "Username available!"       |
      | a               | Invalid     | "Must be 3+ characters"     |
      | john doe        | Invalid     | "No spaces allowed"         |
    And suggestions are offered for taken usernames

  Scenario: Upload profile picture during setup
    Given the user wants to add a profile picture
    When upload options are shown
    Then the user can:
      | Option              | Description                     |
      | Upload Photo        | Select from device              |
      | Take Photo          | Use camera                      |
      | Choose Avatar       | Select pre-made avatar          |
      | Skip                 | Use default, add later         |
    And image is cropped to square format
    And upload size is limited to 5MB

  Scenario: Set notification preferences during setup
    Given the user reaches notification preferences
    When preferences are displayed
    Then the user can configure:
      | Notification Type   | Options             | Default   |
      | Email Notifications | On/Off              | On        |
      | Push Notifications  | On/Off              | On        |
      | Score Alerts        | All/Important/None  | Important |
      | League Updates      | On/Off              | On        |
    And preferences can be changed later
    And privacy explanation is provided

  Scenario: Auto-detect user timezone
    Given the user is setting up their account
    When timezone detection runs
    Then the system:
      | Detects browser timezone            |
      | Shows detected timezone             |
      | Allows manual override              |
      | Explains why timezone matters       |
    And timezone affects game schedules display

  # ==================== LEAGUE JOINING ====================

  Scenario: Browse available leagues to join
    Given the user is on the league joining step
    When available leagues are displayed
    Then the user sees:
      | League Name         | Type           | Spots | Entry Fee | Join    |
      | Public Championship | Head-to-Head   | 3     | Free      | Join    |
      | Pro Money League    | Points Only    | 5     | $25       | Request |
      | Beginner Friendly   | Head-to-Head   | 8     | Free      | Join    |
    And leagues can be filtered and sorted
    And league details are expandable

  Scenario: Join a public league
    Given the user selects a public league "Beginner Friendly"
    When the user clicks "Join League"
    Then the system:
      | Validates spots available               |
      | Creates team in league                  |
      | Shows confirmation message              |
      | Updates onboarding progress             |
    And the user proceeds to team creation

  Scenario: Request to join private league
    Given the user selects a private league
    When the user clicks "Request to Join"
    Then the system:
      | Sends join request to commissioner      |
      | Shows pending status                    |
      | Offers to continue onboarding           |
      | Notifies when request is answered       |
    And the user can join other leagues meanwhile

  Scenario: Join league via invitation code
    Given the user has an invitation code
    When the user enters the code
    Then validation occurs:
      | Code Status     | Result                              |
      | Valid           | League details shown, join enabled  |
      | Expired         | "This invitation has expired"       |
      | Invalid         | "Invalid code. Please check."       |
      | Already Used    | "You've already joined this league" |
    And valid codes immediately add user to league

  Scenario: Skip league joining
    Given the user wants to skip joining a league
    When the user clicks "Join Later"
    Then the system:
      | Records skip preference                 |
      | Shows reminder about joining            |
      | Continues to next onboarding step       |
      | Adds "Join League" to dashboard tasks   |
    And user can join leagues from main app

  Scenario: Create a new league during onboarding
    Given the user wants to create their own league
    When the user clicks "Create League"
    Then the quick create flow shows:
      | Step            | Configuration                       |
      | League Name     | Required text field                 |
      | League Type     | Head-to-Head, Points Only           |
      | Player Count    | 8, 10, 12, 14 options               |
      | Visibility      | Public or Private                   |
    And advanced settings are available
    And user becomes commissioner

  # ==================== TEAM CREATION ====================

  Scenario: Create fantasy team
    Given the user has joined a league
    When the team creation step begins
    Then the user can configure:
      | Element             | Options                         |
      | Team Name           | Text input (2-30 chars)         |
      | Team Logo           | Upload, gallery, or generate    |
      | Team Motto          | Optional tagline                |
      | Team Colors         | Primary and secondary colors    |
    And preview shows how team will appear

  Scenario: Generate team name suggestions
    Given the user needs team name ideas
    When the user clicks "Suggest Names"
    Then suggestions are generated:
      | Category            | Examples                        |
      | Pun-based           | "Mahomes Alone", "Kelce Issues" |
      | Fierce              | "Gridiron Warriors", "Blitz"    |
      | Classic             | "All-Stars", "Dream Team"       |
      | Random              | AI-generated creative names     |
    And the user can regenerate suggestions
    And selected name auto-fills

  Scenario: Upload team logo
    Given the user wants a custom team logo
    When upload options are displayed
    Then the user can:
      | Option              | Description                     |
      | Upload Image        | JPG, PNG, GIF (max 2MB)         |
      | Choose from Gallery | Pre-made logos                  |
      | Generate Logo       | AI-generated based on team name |
      | Use Initials        | Auto-generated from team name   |
    And logo is resized to standard dimensions

  Scenario: Team creation with league template
    Given the league has team creation requirements
    When the user creates a team
    Then league-specific rules apply:
      | Rule                    | Enforcement                   |
      | Name Restrictions       | No profanity, unique names    |
      | Logo Requirements       | Optional or required          |
      | Salary Cap              | If dynasty/keeper format      |
    And violations are flagged before submission

  Scenario: Quick team creation
    Given the user wants to create a team quickly
    When the user clicks "Quick Create"
    Then the system:
      | Generates random team name              |
      | Assigns default logo                    |
      | Uses user's display name for motto     |
      | Completes team creation                 |
    And the user can edit details later

  # ==================== TUTORIAL SYSTEM ====================

  Scenario: Interactive tutorial for new users
    Given the user begins the tutorial
    When tutorial steps are displayed
    Then the interactive guide covers:
      | Step | Topic                | Interaction Type        |
      | 1    | Dashboard Overview   | Highlight & explain     |
      | 2    | Roster Management    | Guided action           |
      | 3    | Matchup Understanding| Visual walkthrough      |
      | 4    | Scoring System       | Interactive quiz        |
      | 5    | Making Roster Moves  | Practice action         |
    And each step has clear instructions

  Scenario: Highlight key features with tooltips
    Given the user is viewing a screen for the first time
    When tooltips are triggered
    Then feature highlights show:
      | Element             | Tooltip Content                 |
      | Add Player Button   | "Click to browse available players" |
      | Matchup Tab         | "View your weekly matchup here" |
      | Standings Link      | "See how you rank in your league" |
    And tooltips can be dismissed permanently
    And "Show All Tips" option is available

  Scenario: Video tutorials
    Given the user accesses video tutorials
    When the tutorial library loads
    Then videos are available:
      | Video Title                 | Duration | Category      |
      | Getting Started             | 2:30     | Basics        |
      | Setting Your Lineup         | 3:15     | Roster        |
      | Understanding Scoring       | 4:00     | Scoring       |
      | Playoff Strategy Tips       | 5:45     | Advanced      |
    And videos have captions
    And progress is tracked

  Scenario: Contextual help during actions
    Given the user is performing an action
    When help is needed
    Then contextual assistance shows:
      | Context                 | Help Provided                   |
      | Adding first player     | "Choose players for your roster"|
      | Viewing empty matchup   | "Matchup starts when week begins"|
      | Checking standings      | "Rankings update after games"   |
    And help adapts to user's current state
    And "Learn More" links to full documentation

  Scenario: Tutorial for experienced users
    Given the user indicates prior fantasy experience
    When onboarding adapts
    Then the tutorial is streamlined:
      | Skipped Content         | Reason                          |
      | Basic scoring           | User knows fantasy basics       |
      | Roster concepts         | User has experience             |
    And platform-specific features are highlighted
    And advanced tips are emphasized

  Scenario: Gamified tutorial with rewards
    Given the tutorial includes gamification
    When the user completes tutorial steps
    Then rewards are earned:
      | Milestone               | Reward                          |
      | Complete profile        | 10 points                       |
      | Join first league       | 25 points                       |
      | Create team             | 15 points                       |
      | Finish tutorial         | 50 points + badge               |
    And rewards are displayed prominently
    And points contribute to achievements

  # ==================== PROGRESS TRACKING ====================

  Scenario: Display onboarding progress bar
    Given the user is in onboarding
    When progress is shown
    Then the progress indicator displays:
      | Element             | Content                         |
      | Current Step        | Step 3 of 6                     |
      | Progress Bar        | 50% complete visual             |
      | Step Names          | Clickable navigation            |
      | Time Estimate       | "About 2 minutes remaining"     |
    And completed steps show checkmarks

  Scenario: Track completion status
    Given the user has partially completed onboarding
    When status is checked
    Then completion tracking shows:
      | Step                | Status      | Action            |
      | Welcome             | Complete    | -                 |
      | Account Setup       | Complete    | Edit              |
      | Join League         | Complete    | View League       |
      | Create Team         | In Progress | Continue          |
      | Tutorial            | Pending     | -                 |
      | Verification        | Pending     | -                 |
    And resume point is highlighted

  Scenario: Save progress automatically
    Given the user is mid-onboarding
    When the user closes the browser
    Then progress is saved:
      | All completed steps preserved         |
      | Current step data saved               |
      | Form fields auto-saved                |
      | Resume point stored                   |
    And the user resumes on next login

  Scenario: Show completion summary
    Given the user completes onboarding
    When the summary screen loads
    Then the summary shows:
      | Section             | Content                         |
      | Profile             | Display name, avatar            |
      | Leagues Joined      | List of leagues                 |
      | Teams Created       | Team names and leagues          |
      | Next Steps          | Recommended actions             |
    And celebration animation plays
    And "Go to Dashboard" CTA is prominent

  Scenario: Calculate onboarding completion percentage
    Given the user has various steps completed
    When completion is calculated
    Then percentage reflects weighted steps:
      | Step                | Weight  | Complete |
      | Account Setup       | 25%     | Yes      |
      | League Join         | 25%     | Yes      |
      | Team Creation       | 20%     | No       |
      | Tutorial            | 15%     | No       |
      | Verification        | 15%     | No       |
    And overall completion is 50%

  # ==================== SKIP OPTIONS ====================

  Scenario: Skip individual onboarding steps
    Given the user is on an onboarding step
    When skip options are available
    Then skip behavior is:
      | Step                | Skip Allowed | Consequence             |
      | Profile Picture     | Yes          | Uses default avatar     |
      | Join League         | Yes          | Must join before playing|
      | Team Creation       | Conditional  | Must have league first  |
      | Tutorial            | Yes          | Can access later        |
      | Verification        | Yes          | Limited features        |
    And skip consequences are explained

  Scenario: Skip entire onboarding
    Given the user wants to skip all onboarding
    When the user clicks "Skip All"
    Then the system:
      | Shows warning about missing setup       |
      | Lists required actions for full access  |
      | Offers one-click setup alternative      |
      | Allows proceeding with limitations      |
    And dashboard shows pending setup tasks

  Scenario: Remind about skipped steps
    Given the user skipped onboarding steps
    When the user accesses the dashboard
    Then reminders are shown:
      | Reminder Type       | Content                         |
      | Banner              | "Complete your profile setup"   |
      | Task List           | Incomplete onboarding items     |
      | Tooltip             | Feature-specific reminders      |
    And reminders can be dismissed temporarily
    And "Complete Now" links to onboarding

  Scenario: Complete skipped steps later
    Given the user skipped verification
    When the user accesses settings
    Then the option to complete is available:
      | Section             | Action                          |
      | Verification        | "Verify Email Now"              |
      | Profile Completion  | "Add Missing Information"       |
      | Tutorial            | "Start Tutorial"                |
    And completing updates overall progress

  Scenario: Consequences of skipping
    Given the user skipped email verification
    When the user tries to access restricted features
    Then limitations apply:
      | Feature             | Limitation                      |
      | Create League       | Requires verification           |
      | Password Reset      | May be unavailable              |
      | Email Notifications | Not functional                  |
    And clear message explains requirement
    And quick verify option is provided

  # ==================== PERSONALIZATION ====================

  Scenario: Collect user preferences
    Given the user is in personalization step
    When preference collection begins
    Then the user can set:
      | Preference              | Options                       |
      | Favorite NFL Team       | All 32 teams or "None"        |
      | Experience Level        | Beginner, Intermediate, Expert|
      | Playing Style           | Casual, Competitive           |
      | Notification Frequency  | Real-time, Daily Digest, Minimal |
    And preferences are optional but recommended

  Scenario: Personalize based on experience level
    Given the user selects "Beginner" experience
    When personalization applies
    Then the experience adapts:
      | Adaptation              | Effect                        |
      | Tutorial Depth          | Full, detailed tutorials      |
      | Terminology             | Simplified explanations       |
      | Recommendations         | Conservative, safe picks      |
      | Help Prompts            | More frequent                 |
    And experience level can be changed anytime

  Scenario: Personalize content based on favorite team
    Given the user selects "Chiefs" as favorite team
    When personalization applies
    Then content is customized:
      | Content Type            | Customization                 |
      | Player Suggestions      | Chiefs players highlighted    |
      | News Feed               | Chiefs news prioritized       |
      | Theme Options           | Chiefs colors available       |
      | Notifications           | Chiefs game alerts            |
    And other content remains accessible

  Scenario: Adaptive onboarding flow
    Given the user exhibits certain behaviors
    When the system analyzes patterns
    Then onboarding adapts:
      | Behavior                | Adaptation                    |
      | Quick form completion   | Reduce step count             |
      | Frequent help clicks    | Add more guidance             |
      | Multiple skips          | Offer quick-start option      |
      | Slow progress           | Check-in prompt               |
    And adaptations improve user experience

  Scenario: Personalized recommendations
    Given the user has set preferences
    When recommendations are generated
    Then suggestions include:
      | Category                | Personalized Content          |
      | Leagues to Join         | Matches experience level      |
      | Players to Watch        | Based on favorite team        |
      | Features to Explore     | Based on playing style        |
    And recommendations update based on activity

  # ==================== VERIFICATION ====================

  Scenario: Email verification during onboarding
    Given the user needs to verify their email
    When verification step is reached
    Then the process shows:
      | Step                | Content                         |
      | Send Code           | "Check your email for code"     |
      | Enter Code          | 6-digit verification input      |
      | Resend Option       | "Didn't receive? Resend"        |
      | Alternative         | "Verify later" option           |
    And verification unlocks full features

  Scenario: Verify email with code
    Given the user has received a verification code
    When the user enters the code
    Then validation occurs:
      | Code Status         | Result                          |
      | Correct             | Email verified, success message |
      | Incorrect           | "Invalid code. Try again."      |
      | Expired             | "Code expired. Request new one" |
    And verified status is permanent

  Scenario: Resend verification code
    Given the user didn't receive the code
    When the user clicks "Resend Code"
    Then the system:
      | Invalidates previous code             |
      | Sends new code to email               |
      | Shows cooldown timer (60 seconds)     |
      | Limits resend attempts (5 per hour)   |
    And spam folder check reminder is shown

  Scenario: Phone number verification
    Given the user adds a phone number
    When phone verification is offered
    Then the process includes:
      | Step                | Content                         |
      | Enter Phone         | Phone number input with country |
      | Send SMS            | Verification code via SMS       |
      | Enter Code          | 6-digit code input              |
      | Verify              | Confirm and save                |
    And phone verification is optional

  Scenario: Identity verification for premium features
    Given the user wants premium access
    When identity verification is required
    Then verification options include:
      | Method              | Description                     |
      | Government ID       | Upload ID document              |
      | Credit Card         | Verify via payment method       |
      | Third-Party         | Use trusted verification service|
    And privacy notice explains data handling
    And verification is processed securely

  # ==================== SOCIAL CONNECTION ====================

  Scenario: Find friends on the platform
    Given the user reaches social connection step
    When friend finding options load
    Then the user can:
      | Method              | Description                     |
      | Search Username     | Find by username search         |
      | Import Contacts     | From phone or email (opt-in)    |
      | Connect Social      | Link Facebook, Twitter          |
      | Invite via Link     | Generate shareable invite       |
    And privacy is respected throughout

  Scenario: Connect social media accounts
    Given the user wants to link social accounts
    When social connection options are shown
    Then available platforms include:
      | Platform            | Benefits                        |
      | Facebook            | Find friends, easy login        |
      | Twitter/X           | Share achievements              |
      | Google              | Contact import, login           |
      | Apple               | Secure login option             |
    And OAuth flow is initiated on selection
    And data sharing is explained clearly

  Scenario: Import contacts to find friends
    Given the user chooses to import contacts
    When import permission is granted
    Then the system:
      | Reads contacts (with permission)        |
      | Matches against existing users          |
      | Shows found friends list                |
      | Allows selective friend requests        |
    And contacts are not stored permanently
    And privacy notice is displayed

  Scenario: Send friend requests during onboarding
    Given potential friends are found
    When the user sends friend requests
    Then the system:
      | Sends request to selected users         |
      | Shows pending status                    |
      | Limits requests to prevent spam (10/day)|
      | Notifies recipients                     |
    And batch request option is available

  Scenario: Skip social connection
    Given the user prefers not to connect socially
    When the user clicks "Skip"
    Then the system:
      | Allows skipping without penalty         |
      | Notes preference for later              |
      | Continues to next step                  |
      | Doesn't repeatedly prompt               |
    And social features remain available later

  Scenario: Invite friends to join platform
    Given the user wants to invite others
    When invite options are shown
    Then invite methods include:
      | Method              | Content                         |
      | Email Invite        | Personalized email invitation   |
      | SMS Invite          | Text with invite link           |
      | Share Link          | Copyable referral link          |
      | Social Share        | One-click social post           |
    And referral rewards are explained
    And invite tracking is enabled

  # ==================== ONBOARDING COMPLETION ====================

  Scenario: Complete onboarding successfully
    Given the user has finished all steps
    When onboarding completes
    Then the system:
      | Shows celebration animation             |
      | Displays completion badge               |
      | Summarizes what was set up              |
      | Provides next steps guidance            |
    And user is redirected to dashboard
    And welcome notification is sent

  Scenario: Onboarding exit survey
    Given the user completes onboarding
    When exit survey is offered
    Then the survey asks:
      | Question                        | Type            |
      | How was your setup experience?  | 1-5 rating      |
      | What could be improved?         | Optional text   |
      | Would you recommend us?         | NPS scale       |
    And survey is optional
    And feedback is used to improve onboarding

  Scenario: First-time dashboard experience
    Given the user completes onboarding
    When the dashboard loads for first time
    Then first-time experience includes:
      | Element                 | Purpose                       |
      | Welcome banner          | Personalized greeting         |
      | Quick start checklist   | Immediate next actions        |
      | Feature highlights      | New user tooltips             |
      | Help widget             | Easy access to support        |
    And first-time elements can be dismissed

  # ==================== ERROR HANDLING ====================

  Scenario: Handle onboarding step failure
    Given an onboarding step encounters an error
    When the error occurs
    Then the system:
      | Shows user-friendly error message       |
      | Preserves entered data                  |
      | Offers retry option                     |
      | Provides alternative actions            |
    And technical details are logged
    And support contact is available

  Scenario: Handle network disconnection
    Given the user loses network during onboarding
    When disconnection is detected
    Then the system:
      | Shows offline indicator                 |
      | Saves progress locally                  |
      | Auto-resumes when reconnected           |
      | Prevents data loss                      |
    And user is notified of connection status

  Scenario: Handle duplicate account attempt
    Given the user tries to create duplicate account
    When duplicate is detected
    Then the system:
      | Identifies existing account             |
      | Offers login option                     |
      | Provides password reset link            |
      | Prevents duplicate registration         |
    And security is not compromised

  # ==================== ACCESSIBILITY ====================

  Scenario: Accessible onboarding experience
    Given the user has accessibility needs
    When onboarding is accessed
    Then accessibility features include:
      | Feature                 | Implementation                |
      | Screen Reader Support   | All elements labeled          |
      | Keyboard Navigation     | Full keyboard access          |
      | High Contrast Mode      | Enhanced visibility           |
      | Text Scaling            | Responsive to font size       |
      | Reduced Motion          | Optional animation disable    |
    And WCAG 2.1 AA compliance is maintained

  Scenario: Onboarding in multiple languages
    Given the user prefers a non-English language
    When language is detected or selected
    Then onboarding is localized:
      | Element                 | Localization                  |
      | All text content        | Translated                    |
      | Date/time formats       | Locale-specific               |
      | Currency displays       | User's currency               |
      | Help content            | Translated or English fallback|
    And language can be changed during onboarding
