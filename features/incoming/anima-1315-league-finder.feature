@league-finder @discovery @join
Feature: League Finder
  As a fantasy football player
  I want to discover and join leagues that match my preferences
  So that I can find competitive and enjoyable fantasy football experiences

  Background:
    Given a fantasy football platform exists
    And public leagues are available for discovery
    And I am a registered user

  # ==========================================
  # PUBLIC LEAGUE DIRECTORY
  # ==========================================

  @directory @happy-path
  Scenario: Browse public league directory
    Given public leagues are listed
    When I access the league directory
    Then I see available public leagues
    And key details are displayed for each

  @directory @browse
  Scenario: Browse leagues by category
    Given leagues are categorized
    When I browse by category
    Then I see leagues grouped accordingly
    And I can explore each category

  @directory @featured
  Scenario: View featured leagues
    Given some leagues are featured
    When I view featured leagues
    Then I see highlighted leagues
    And reasons for featuring are shown

  @directory @new
  Scenario: View newly created leagues
    Given new leagues are created regularly
    When I filter for new leagues
    Then I see recently created leagues
    And they are sorted by creation date

  @directory @popular
  Scenario: View popular leagues
    Given popularity metrics are tracked
    When I view popular leagues
    Then I see leagues with high engagement
    And popularity indicators are shown

  # ==========================================
  # LEAGUE SEARCH
  # ==========================================

  @search @happy-path
  Scenario: Search for leagues by keyword
    Given I want to find specific leagues
    When I enter a search term
    Then matching leagues are returned
    And results are ranked by relevance

  @search @name
  Scenario: Search by league name
    Given leagues have names
    When I search for a league name
    Then leagues with matching names appear
    And partial matches are included

  @search @advanced
  Scenario: Use advanced search options
    Given I need precise search
    When I use advanced search
    Then I can combine multiple criteria
    And results match all criteria

  @search @save
  Scenario: Save search for later
    Given I have a useful search
    When I save the search
    Then I can rerun it later
    And I receive updates for new matches

  @search @history
  Scenario: View search history
    Given I have searched before
    When I view search history
    Then I see past searches
    And I can quickly rerun them

  # ==========================================
  # BUY-IN AMOUNT FILTERING
  # ==========================================

  @filter @buy-in @happy-path
  Scenario: Filter leagues by buy-in amount
    Given leagues have various buy-ins
    When I filter by buy-in range
    Then only leagues within range appear
    And buy-in amounts are displayed

  @filter @buy-in @free
  Scenario: Filter for free leagues
    Given I want free leagues only
    When I filter for $0 buy-in
    Then only free leagues appear
    And no payment is required

  @filter @buy-in @high-stakes
  Scenario: Filter for high-stakes leagues
    Given I want competitive buy-ins
    When I filter for high buy-in
    Then high-stakes leagues appear
    And prize pools are displayed

  @filter @buy-in @range
  Scenario: Set custom buy-in range
    Given I have a specific budget
    When I set min and max buy-in
    Then leagues within my range appear
    And the filter is applied

  # ==========================================
  # LEAGUE SIZE FILTERING
  # ==========================================

  @filter @size @happy-path
  Scenario: Filter leagues by size
    Given leagues have various sizes
    When I filter by league size
    Then leagues matching the size appear
    And current enrollment is shown

  @filter @size @small
  Scenario: Filter for small leagues
    Given I prefer intimate leagues
    When I filter for 8-10 teams
    Then small leagues appear
    And team count is displayed

  @filter @size @large
  Scenario: Filter for large leagues
    Given I want larger competition
    When I filter for 14+ teams
    Then large leagues appear
    And available spots are shown

  @filter @size @specific
  Scenario: Filter for exact size
    Given I want a specific size
    When I select exact team count
    Then only matching leagues appear
    And the count is verified

  # ==========================================
  # SCORING FORMAT FILTERING
  # ==========================================

  @filter @scoring @happy-path
  Scenario: Filter by scoring format
    Given leagues use different scoring
    When I filter by scoring format
    Then leagues with that format appear
    And scoring rules are summarized

  @filter @scoring @ppr
  Scenario: Filter for PPR leagues
    Given I prefer PPR scoring
    When I filter for PPR
    Then PPR leagues appear
    And point-per-reception is confirmed

  @filter @scoring @standard
  Scenario: Filter for standard leagues
    Given I prefer standard scoring
    When I filter for Standard
    Then standard scoring leagues appear
    And no reception points are included

  @filter @scoring @half-ppr
  Scenario: Filter for half-PPR leagues
    Given I prefer half-PPR
    When I filter for Half-PPR
    Then half-PPR leagues appear
    And scoring details are shown

  @filter @scoring @custom
  Scenario: Filter for custom scoring
    Given I want unique scoring
    When I filter for custom scoring
    Then leagues with custom rules appear
    And unique rules are highlighted

  # ==========================================
  # DRAFT TYPE FILTERING
  # ==========================================

  @filter @draft @happy-path
  Scenario: Filter by draft type
    Given leagues use different draft types
    When I filter by draft type
    Then matching leagues appear
    And draft format is displayed

  @filter @draft @snake
  Scenario: Filter for snake drafts
    Given I prefer snake drafts
    When I filter for Snake
    Then snake draft leagues appear
    And draft order info is shown

  @filter @draft @auction
  Scenario: Filter for auction drafts
    Given I prefer auction drafts
    When I filter for Auction
    Then auction draft leagues appear
    And budget information is shown

  @filter @draft @keeper
  Scenario: Filter for keeper leagues
    Given I want keeper leagues
    When I filter for Keeper
    Then keeper leagues appear
    And keeper rules are summarized

  @filter @draft @dynasty
  Scenario: Filter for dynasty leagues
    Given I want dynasty format
    When I filter for Dynasty
    Then dynasty leagues appear
    And dynasty rules are explained

  # ==========================================
  # EXPERIENCE LEVEL MATCHING
  # ==========================================

  @experience @happy-path
  Scenario: Filter by experience level
    Given leagues target different skill levels
    When I filter by experience level
    Then leagues matching my level appear
    And experience expectations are shown

  @experience @beginner
  Scenario: Find beginner-friendly leagues
    Given I am new to fantasy football
    When I filter for beginner leagues
    Then welcoming leagues appear
    And learning resources are mentioned

  @experience @intermediate
  Scenario: Find intermediate leagues
    Given I have some experience
    When I filter for intermediate
    Then moderately competitive leagues appear
    And expectations are appropriate

  @experience @expert
  Scenario: Find expert/competitive leagues
    Given I want high competition
    When I filter for expert leagues
    Then highly competitive leagues appear
    And serious competition is expected

  @experience @casual
  Scenario: Find casual leagues
    Given I want casual fun
    When I filter for casual
    Then relaxed leagues appear
    And low-pressure environment is noted

  # ==========================================
  # GEOGRAPHIC/TIMEZONE PREFERENCES
  # ==========================================

  @location @timezone @happy-path
  Scenario: Filter by timezone
    Given leagues operate in different timezones
    When I filter by timezone
    Then leagues in my timezone appear
    And draft times are convenient

  @location @region
  Scenario: Filter by geographic region
    Given I prefer regional leagues
    When I filter by region
    Then leagues in my region appear
    And local flavor is available

  @location @international
  Scenario: Find international leagues
    Given I want global competition
    When I filter for international
    Then worldwide leagues appear
    And timezone considerations are noted

  @location @local
  Scenario: Find local leagues
    Given I want local community
    When I filter by city/state
    Then nearby leagues appear
    And potential for in-person events exists

  # ==========================================
  # LEAGUE RATINGS AND REVIEWS
  # ==========================================

  @ratings @happy-path
  Scenario: View league ratings
    Given leagues are rated
    When I view a league's rating
    Then I see the overall rating
    And rating breakdown is available

  @ratings @review
  Scenario: Read league reviews
    Given past members have reviewed
    When I read reviews
    Then I see member feedback
    And reviews are helpful for decision

  @ratings @write
  Scenario: Write a league review
    Given I have been in a league
    When I write a review
    Then my review is submitted
    And it helps future members

  @ratings @categories
  Scenario: View rating categories
    Given ratings cover multiple aspects
    When I view rating breakdown
    Then I see competitiveness, fairness, activity ratings
    And I can assess what matters to me

  @ratings @sort
  Scenario: Sort leagues by rating
    Given I want highly-rated leagues
    When I sort by rating
    Then best-rated leagues appear first
    And I can find quality leagues

  # ==========================================
  # COMMISSIONER REPUTATION
  # ==========================================

  @commissioner @reputation @happy-path
  Scenario: View commissioner reputation score
    Given commissioners have reputation
    When I view commissioner info
    Then I see their reputation score
    And history is available

  @commissioner @history
  Scenario: View commissioner history
    Given commissioners have run leagues before
    When I view their history
    Then I see past leagues managed
    And track record is visible

  @commissioner @verified
  Scenario: Identify verified commissioners
    Given some commissioners are verified
    When I view commissioner info
    Then verification status is shown
    And verified means trustworthy

  @commissioner @feedback
  Scenario: Read commissioner feedback
    Given members rate commissioners
    When I read commissioner feedback
    Then I see member opinions
    And I can assess reliability

  # ==========================================
  # OPEN SPOT NOTIFICATIONS
  # ==========================================

  @notifications @openings @happy-path
  Scenario: Subscribe to opening notifications
    Given I want to know about openings
    When I subscribe to notifications
    Then I am alerted when spots open
    And I can act quickly

  @notifications @specific
  Scenario: Subscribe to specific league openings
    Given a league I want is full
    When I subscribe to that league
    Then I am notified when a spot opens
    And I can join immediately

  @notifications @criteria
  Scenario: Subscribe to criteria-based openings
    Given I have specific preferences
    When I set notification criteria
    Then I am notified for matching leagues
    And only relevant openings alert me

  @notifications @manage
  Scenario: Manage opening notifications
    Given I have multiple subscriptions
    When I manage notifications
    Then I can enable/disable each
    And I control notification volume

  # ==========================================
  # LEAGUE INVITATION SYSTEM
  # ==========================================

  @invitations @receive @happy-path
  Scenario: Receive league invitation
    Given a commissioner invites me
    When I receive the invitation
    Then I see invitation details
    And I can accept or decline

  @invitations @send
  Scenario: Send league invitation to friend
    Given I am in a league with openings
    When I send an invitation
    Then my friend receives it
    And they can join easily

  @invitations @bulk
  Scenario: Send bulk invitations
    Given I am a commissioner
    When I send bulk invitations
    Then multiple people are invited
    And tracking is provided

  @invitations @expire
  Scenario: Handle expired invitations
    Given an invitation has expired
    When I try to use it
    Then I see it has expired
    And I can request a new one

  @invitations @decline
  Scenario: Decline league invitation
    Given I received an invitation
    When I decline it
    Then my decision is recorded
    And I can change my mind later

  # ==========================================
  # QUICK JOIN FUNCTIONALITY
  # ==========================================

  @quick-join @happy-path
  Scenario: Quick join an open league
    Given a league has open spots
    When I click quick join
    Then I am added to the league
    And onboarding begins

  @quick-join @requirements
  Scenario: Meet join requirements
    Given a league has requirements
    When I attempt to join
    Then requirements are checked
    And I am informed of any issues

  @quick-join @payment
  Scenario: Complete payment during quick join
    Given the league has a buy-in
    When I quick join
    Then payment is processed
    And I join after payment

  @quick-join @confirmation
  Scenario: Receive join confirmation
    Given I have joined a league
    When the join is complete
    Then I receive confirmation
    And league details are provided

  # ==========================================
  # LEAGUE PREVIEW
  # ==========================================

  @preview @happy-path
  Scenario: Preview league before joining
    Given I am considering a league
    When I view the preview
    Then I see league details
    And I can assess if it fits my needs

  @preview @rules
  Scenario: View league rules in preview
    Given I want to understand rules
    When I view rules in preview
    Then I see scoring, roster, and policies
    And I can make informed decision

  @preview @members
  Scenario: View current members in preview
    Given I want to know who is in the league
    When I view member preview
    Then I see current members
    And their experience is shown

  @preview @schedule
  Scenario: View league schedule in preview
    Given I want to know key dates
    When I view schedule preview
    Then I see draft date and season schedule
    And I can check my availability

  @preview @history
  Scenario: View league history in preview
    Given the league has history
    When I view history preview
    Then I see past seasons and champions
    And I assess league stability

  # ==========================================
  # WAITLIST
  # ==========================================

  @waitlist @happy-path
  Scenario: Join waitlist for full league
    Given a league I want is full
    When I join the waitlist
    Then I am added to the queue
    And my position is shown

  @waitlist @position
  Scenario: View waitlist position
    Given I am on a waitlist
    When I check my position
    Then I see where I stand
    And estimated wait is shown

  @waitlist @notification
  Scenario: Receive notification when spot opens
    Given I am on a waitlist
    When a spot opens
    Then I am notified immediately
    And I have priority to join

  @waitlist @leave
  Scenario: Leave waitlist
    Given I no longer want to wait
    When I leave the waitlist
    Then I am removed
    And others move up

  @waitlist @multiple
  Scenario: Join multiple waitlists
    Given I am flexible on leagues
    When I join multiple waitlists
    Then I am queued for each
    And I can manage all from one place

  # ==========================================
  # FRIEND REFERRAL SYSTEM
  # ==========================================

  @referral @happy-path
  Scenario: Refer a friend to the platform
    Given I have a friend who should join
    When I send a referral
    Then my friend receives an invitation
    And we both may receive rewards

  @referral @code
  Scenario: Use referral code
    Given I have a referral code
    When I use it during signup
    Then the referral is tracked
    And benefits are applied

  @referral @rewards
  Scenario: Earn referral rewards
    Given I have referred friends
    When they join and are active
    Then I earn referral rewards
    And rewards are credited

  @referral @track
  Scenario: Track referral status
    Given I have sent referrals
    When I check referral status
    Then I see who has joined
    And pending referrals are shown

  # ==========================================
  # LEAGUE RECOMMENDATIONS
  # ==========================================

  @recommendations @happy-path
  Scenario: Receive personalized league recommendations
    Given I have set my preferences
    When I view recommendations
    Then I see leagues matching my preferences
    And recommendations are ranked

  @recommendations @preferences
  Scenario: Set recommendation preferences
    Given I want tailored suggestions
    When I configure preferences
    Then I set buy-in, format, size preferences
    And recommendations adjust

  @recommendations @history
  Scenario: Recommendations based on history
    Given I have joined leagues before
    When I view recommendations
    Then past preferences are considered
    And similar leagues are suggested

  @recommendations @friends
  Scenario: Recommendations from friends' leagues
    Given my friends are in leagues
    When I view recommendations
    Then friends' leagues are highlighted
    And I can join friends

  @recommendations @refresh
  Scenario: Refresh recommendations
    Given I want new suggestions
    When I refresh recommendations
    Then new options appear
    And the list is updated

  # ==========================================
  # RECENTLY VIEWED LEAGUES
  # ==========================================

  @recent @happy-path
  Scenario: View recently viewed leagues
    Given I have browsed leagues
    When I access recently viewed
    Then I see leagues I looked at
    And they are ordered by recency

  @recent @clear
  Scenario: Clear recently viewed history
    Given I want to clear history
    When I clear recently viewed
    Then the history is erased
    And I start fresh

  @recent @continue
  Scenario: Continue from recently viewed
    Given I was considering a league
    When I return to recently viewed
    Then I can continue my evaluation
    And my progress is retained

  # ==========================================
  # SAVED/FAVORITED LEAGUES
  # ==========================================

  @favorites @save @happy-path
  Scenario: Save a league to favorites
    Given I find an interesting league
    When I save it to favorites
    Then it is added to my list
    And I can access it easily

  @favorites @view
  Scenario: View saved leagues
    Given I have saved leagues
    When I access my favorites
    Then I see all saved leagues
    And current status is shown

  @favorites @remove
  Scenario: Remove from favorites
    Given I no longer want a saved league
    When I remove it from favorites
    Then it is removed from my list
    And the league is not deleted

  @favorites @organize
  Scenario: Organize saved leagues
    Given I have many saved leagues
    When I organize them
    Then I can create folders or tags
    And organization is easy

  @favorites @alerts
  Scenario: Receive alerts for favorite leagues
    Given I have favorited leagues
    When status changes occur
    Then I am notified
    And I can stay informed

  # ==========================================
  # LEAGUE COMPARISON TOOL
  # ==========================================

  @compare @happy-path
  Scenario: Compare multiple leagues
    Given I am deciding between leagues
    When I compare them
    Then I see side-by-side comparison
    And differences are highlighted

  @compare @criteria
  Scenario: Compare on specific criteria
    Given I care about certain aspects
    When I select comparison criteria
    Then those aspects are compared
    And I can focus on what matters

  @compare @add-remove
  Scenario: Add and remove leagues from comparison
    Given I am comparing leagues
    When I add or remove leagues
    Then the comparison updates
    And up to 4 leagues can be compared

  @compare @export
  Scenario: Export league comparison
    Given I have a comparison
    When I export it
    Then I receive a summary
    And I can share or save it

  # ==========================================
  # SOCIAL INTEGRATION
  # ==========================================

  @social @friends @happy-path
  Scenario: Find friends on the platform
    Given my friends use the platform
    When I connect social accounts
    Then I find friends automatically
    And I can see their leagues

  @social @connect
  Scenario: Connect social media accounts
    Given I want to find friends
    When I connect my social accounts
    Then contacts are imported
    And matches are found

  @social @friends-leagues
  Scenario: View friends' leagues
    Given I have friends on the platform
    When I view their leagues
    Then I see leagues they are in
    And I can request to join

  @social @invite
  Scenario: Invite friends to join leagues
    Given I am in a league with openings
    When I invite friends
    Then they receive invitations
    And they can easily join

  # ==========================================
  # MOBILE EXPERIENCE
  # ==========================================

  @mobile @browse @happy-path
  Scenario: Browse leagues on mobile
    Given I am using the mobile app
    When I access league finder
    Then the interface is mobile-optimized
    And all features are accessible

  @mobile @filter
  Scenario: Apply filters on mobile
    Given I am filtering on mobile
    When I use filter controls
    Then filters work smoothly
    And results update quickly

  @mobile @swipe
  Scenario: Swipe through leagues on mobile
    Given I am browsing on mobile
    When I swipe through leagues
    Then I can quickly review options
    And the experience is fluid

  @mobile @quick-actions
  Scenario: Use quick actions on mobile
    Given I see a league card
    When I use quick actions
    Then I can save, compare, or join
    And actions are fast

  # ==========================================
  # PUSH NOTIFICATIONS
  # ==========================================

  @push @openings @happy-path
  Scenario: Receive push notification for openings
    Given I have subscribed to alerts
    When a matching league opens
    Then I receive a push notification
    And I can act immediately

  @push @configure
  Scenario: Configure push notification preferences
    Given I want to control alerts
    When I configure preferences
    Then I set what triggers notifications
    And I control frequency

  @push @disable
  Scenario: Disable push notifications
    Given I want fewer interruptions
    When I disable notifications
    Then I no longer receive alerts
    And I can re-enable anytime

  # ==========================================
  # VERIFIED LEAGUE BADGES
  # ==========================================

  @verified @badge @happy-path
  Scenario: View verified league badge
    Given some leagues are verified
    When I see a verified badge
    Then I know the league meets standards
    And verification criteria are explained

  @verified @criteria
  Scenario: Understand verification criteria
    Given I want to know what verified means
    When I view verification info
    Then I see the criteria
    And I understand the benefits

  @verified @apply
  Scenario: Apply for league verification
    Given I am a commissioner
    When I apply for verification
    Then my league is reviewed
    And I am notified of the result

  @verified @filter
  Scenario: Filter for verified leagues only
    Given I want trusted leagues
    When I filter for verified
    Then only verified leagues appear
    And I can trust the quality

  # ==========================================
  # ANTI-COLLUSION RATINGS
  # ==========================================

  @anti-collusion @happy-path
  Scenario: View anti-collusion rating
    Given leagues are rated for fairness
    When I view the anti-collusion rating
    Then I see the league's score
    And methodology is explained

  @anti-collusion @factors
  Scenario: Understand rating factors
    Given I want to know how ratings work
    When I view rating factors
    Then I see what contributes to the score
    And I can assess league fairness

  @anti-collusion @report
  Scenario: Report collusion concerns
    Given I suspect collusion in a league
    When I report my concern
    Then the report is submitted
    And investigation may occur

  @anti-collusion @filter
  Scenario: Filter for high-fairness leagues
    Given I want fair competition
    When I filter for high anti-collusion scores
    Then leagues with strong policies appear
    And I can trust fair play

  # ==========================================
  # ERROR HANDLING
  # ==========================================

  @error-handling
  Scenario: Handle no search results
    Given my search has no matches
    When I see no results
    Then I receive helpful suggestions
    And I can adjust my criteria

  @error-handling
  Scenario: Handle join failure
    Given I try to join a league
    When the join fails
    Then I see an error message
    And I am given options to resolve

  @error-handling
  Scenario: Handle payment failure during join
    Given I am joining a paid league
    When payment fails
    Then I am informed of the issue
    And I can retry payment

  # ==========================================
  # ACCESSIBILITY
  # ==========================================

  @accessibility
  Scenario: Navigate league finder with screen reader
    Given I am using a screen reader
    When I browse leagues
    Then all content is properly labeled
    And navigation is accessible

  @accessibility
  Scenario: View leagues with high contrast
    Given I have high contrast enabled
    When I view the league finder
    Then all elements are visible
    And badges are distinguishable

  @accessibility
  Scenario: Use league finder with keyboard
    Given I navigate with keyboard
    When I use the league finder
    Then all features are accessible
    And focus indicators are clear
