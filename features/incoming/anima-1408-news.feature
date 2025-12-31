@news @anima-1408
Feature: News
  As a fantasy football user
  I want comprehensive news capabilities
  So that I can stay informed about players, teams, and the league

  Background:
    Given I am a logged-in user
    And the news system is available

  # ============================================================================
  # NEWS FEED
  # ============================================================================

  @happy-path @news-feed
  Scenario: View news stream
    Given news exists
    When I view news stream
    Then I should see news articles
    And they should be current

  @happy-path @news-feed
  Scenario: View latest news
    Given recent news exists
    When I view latest
    Then I should see most recent news
    And they should be chronological

  @happy-path @news-feed
  Scenario: View news timeline
    Given news spans time
    When I view timeline
    Then I should see news over time
    And dates should be clear

  @happy-path @news-feed
  Scenario: View breaking news
    Given breaking news exists
    When I view breaking
    Then I should see breaking news first
    And urgency should be indicated

  @happy-path @news-feed
  Scenario: View news updates
    Given updates are available
    When I view updates
    Then I should see latest updates
    And changes should be highlighted

  @happy-path @news-feed
  Scenario: Refresh news feed
    Given feed may have new items
    When I refresh feed
    Then feed should update
    And new articles should appear

  @happy-path @news-feed
  Scenario: Load more news
    Given more news exists
    When I scroll down
    Then more news should load
    And pagination should work

  @happy-path @news-feed
  Scenario: View news on mobile
    Given I am on mobile
    When I view news
    Then display should be mobile-friendly
    And articles should be readable

  @happy-path @news-feed
  Scenario: Auto-refresh news
    Given auto-refresh is enabled
    When new news arrives
    Then feed should update automatically
    And notification should appear

  @happy-path @news-feed
  Scenario: View trending news
    Given trending exists
    When I view trending
    Then I should see popular news
    And engagement should be shown

  # ============================================================================
  # NEWS CATEGORIES
  # ============================================================================

  @happy-path @news-categories
  Scenario: View player news
    Given player news exists
    When I view player news
    Then I should see player-related news
    And players should be identified

  @happy-path @news-categories
  Scenario: View team news
    Given team news exists
    When I view team news
    Then I should see team-related news
    And teams should be identified

  @happy-path @news-categories
  Scenario: View league news
    Given league news exists
    When I view league news
    Then I should see my league news
    And league activity should be shown

  @happy-path @news-categories
  Scenario: View fantasy news
    Given fantasy news exists
    When I view fantasy news
    Then I should see fantasy-focused news
    And impact should be explained

  @happy-path @news-categories
  Scenario: View NFL news
    Given NFL news exists
    When I view NFL news
    Then I should see league-wide news
    And all teams should be covered

  @happy-path @news-categories
  Scenario: Filter by category
    Given categories exist
    When I filter by category
    Then I should see category news
    And others should be hidden

  @happy-path @news-categories
  Scenario: View injury news
    Given injury news exists
    When I view injury news
    Then I should see injury updates
    And status should be shown

  @happy-path @news-categories
  Scenario: View trade news
    Given trade news exists
    When I view trade news
    Then I should see trade updates
    And parties should be shown

  @happy-path @news-categories
  Scenario: View transaction news
    Given transaction news exists
    When I view transactions
    Then I should see transaction news
    And moves should be detailed

  @happy-path @news-categories
  Scenario: View roster news
    Given roster news exists
    When I view roster news
    Then I should see roster changes
    And impacts should be explained

  # ============================================================================
  # NEWS DETAILS
  # ============================================================================

  @happy-path @news-details
  Scenario: View full article
    Given article exists
    When I view full article
    Then I should see complete article
    And content should be readable

  @happy-path @news-details
  Scenario: View news content
    Given news is selected
    When I view content
    Then I should see full content
    And formatting should be proper

  @happy-path @news-details
  Scenario: View news source
    Given source is attributed
    When I view source
    Then I should see news source
    And credibility should be shown

  @happy-path @news-details
  Scenario: View publication date
    Given article has date
    When I view date
    Then I should see publication date
    And time should be shown

  @happy-path @news-details
  Scenario: View related news
    Given related articles exist
    When I view related
    Then I should see related news
    And connections should be clear

  @happy-path @news-details
  Scenario: View article author
    Given author is credited
    When I view author
    Then I should see author info
    And their other articles should be available

  @happy-path @news-details
  Scenario: View article images
    Given article has images
    When I view images
    Then I should see images
    And they should be relevant

  @happy-path @news-details
  Scenario: View article tags
    Given article is tagged
    When I view tags
    Then I should see tags
    And I can click to see more

  @happy-path @news-details
  Scenario: View read time
    Given read time is calculated
    When I view article
    Then I should see estimated read time
    And it should be accurate

  @happy-path @news-details
  Scenario: View article summary
    Given summary exists
    When I view summary
    Then I should see quick summary
    And key points should be clear

  # ============================================================================
  # NEWS SEARCH
  # ============================================================================

  @happy-path @news-search
  Scenario: Search news
    Given news exists
    When I search news
    Then I should find matches
    And results should be relevant

  @happy-path @news-search
  Scenario: Filter by topic
    Given topics exist
    When I filter by topic
    Then I should see topic news
    And others should be hidden

  @happy-path @news-search
  Scenario: Filter by date
    Given dates vary
    When I filter by date
    Then I should see date range
    And only matching should show

  @happy-path @news-search
  Scenario: Filter by player
    Given player news exists
    When I filter by player
    Then I should see player's news
    And others should be hidden

  @happy-path @news-search
  Scenario: Keyword search
    Given keywords exist
    When I search keyword
    Then I should find matches
    And keyword should be highlighted

  @happy-path @news-search
  Scenario: Search by team
    Given team news exists
    When I search by team
    Then I should find team news
    And all related should show

  @happy-path @news-search
  Scenario: Advanced search
    Given advanced options exist
    When I use advanced search
    Then I should see detailed options
    And results should match criteria

  @happy-path @news-search
  Scenario: Save search
    Given search is useful
    When I save search
    Then search should be saved
    And I can reuse later

  @happy-path @news-search
  Scenario: Clear search
    Given search is active
    When I clear search
    Then search should reset
    And all news should show

  @happy-path @news-search
  Scenario: View search history
    Given I have searched
    When I view history
    Then I should see past searches
    And I can reuse them

  # ============================================================================
  # NEWS ALERTS
  # ============================================================================

  @happy-path @news-alerts
  Scenario: Receive news notifications
    Given alerts are enabled
    When news is published
    Then I should receive notification
    And I can open article

  @happy-path @news-alerts
  Scenario: Receive breaking alerts
    Given breaking news occurs
    When news breaks
    Then I should receive alert immediately
    And urgency should be clear

  @happy-path @news-alerts
  Scenario: Configure custom alerts
    Given I want specific alerts
    When I configure alerts
    Then custom alerts should be saved
    And I should receive matching

  @happy-path @news-alerts
  Scenario: Receive push notifications
    Given push is enabled
    When news arrives
    Then I should receive push
    And it should be timely

  @happy-path @news-alerts
  Scenario: Receive email alerts
    Given email is enabled
    When news is published
    Then I should receive email
    And it should contain summary

  @happy-path @news-alerts
  Scenario: Set alert frequency
    Given frequency options exist
    When I set frequency
    Then alerts should follow frequency
    And I won't be overwhelmed

  @happy-path @news-alerts
  Scenario: Set quiet hours
    Given I need quiet time
    When I set quiet hours
    Then alerts should pause
    And they should resume after

  @happy-path @news-alerts
  Scenario: Disable news alerts
    Given I receive too many
    When I disable alerts
    Then alerts should stop
    And I can re-enable later

  @happy-path @news-alerts
  Scenario: View alert history
    Given alerts have been sent
    When I view history
    Then I should see past alerts
    And I can review them

  @happy-path @news-alerts
  Scenario: Set priority alerts
    Given priorities exist
    When I set priority
    Then only priority should alert
    And others should be silent

  # ============================================================================
  # NEWS PERSONALIZATION
  # ============================================================================

  @happy-path @news-personalization
  Scenario: View personalized feed
    Given I have preferences
    When I view feed
    Then feed should be personalized
    And relevant news should appear first

  @happy-path @news-personalization
  Scenario: Follow players
    Given players are followable
    When I follow player
    Then I should see their news
    And it should be prioritized

  @happy-path @news-personalization
  Scenario: Follow teams
    Given teams are followable
    When I follow team
    Then I should see their news
    And it should be prioritized

  @happy-path @news-personalization
  Scenario: Set interests
    Given interests are available
    When I set interests
    Then news should match interests
    And recommendations should improve

  @happy-path @news-personalization
  Scenario: View recommendations
    Given recommendations exist
    When I view recommendations
    Then I should see suggested news
    And they should be relevant

  @happy-path @news-personalization
  Scenario: Unfollow player
    Given I follow player
    When I unfollow
    Then player should be unfollowed
    And news priority should change

  @happy-path @news-personalization
  Scenario: Unfollow team
    Given I follow team
    When I unfollow
    Then team should be unfollowed
    And news priority should change

  @happy-path @news-personalization
  Scenario: Hide news source
    Given I don't like source
    When I hide source
    Then source should be hidden
    And news from them won't appear

  @happy-path @news-personalization
  Scenario: Reset personalization
    Given I have preferences
    When I reset
    Then preferences should reset
    And I should confirm first

  @happy-path @news-personalization
  Scenario: Import roster follows
    Given I have roster
    When I import follows
    Then roster players should be followed
    And their news should appear

  # ============================================================================
  # NEWS BOOKMARKS
  # ============================================================================

  @happy-path @news-bookmarks
  Scenario: Save article
    Given article exists
    When I save article
    Then article should be saved
    And I can access later

  @happy-path @news-bookmarks
  Scenario: View reading list
    Given I have saved articles
    When I view reading list
    Then I should see saved articles
    And I can read them

  @happy-path @news-bookmarks
  Scenario: Add to favorites
    Given article exists
    When I add to favorites
    Then article should be favorited
    And I can access quickly

  @happy-path @news-bookmarks
  Scenario: View bookmarked news
    Given bookmarks exist
    When I view bookmarks
    Then I should see bookmarked news
    And they should be organized

  @happy-path @news-bookmarks
  Scenario: Save for later
    Given article exists
    When I save for later
    Then article should be saved
    And I will be reminded

  @happy-path @news-bookmarks
  Scenario: Remove bookmark
    Given article is bookmarked
    When I remove bookmark
    Then bookmark should be removed
    And article should be unsaved

  @happy-path @news-bookmarks
  Scenario: Organize bookmarks
    Given bookmarks exist
    When I organize bookmarks
    Then they should be organized
    And I can create folders

  @happy-path @news-bookmarks
  Scenario: Search bookmarks
    Given bookmarks exist
    When I search bookmarks
    Then I should find matches
    And results should be relevant

  @happy-path @news-bookmarks
  Scenario: Export bookmarks
    Given bookmarks exist
    When I export bookmarks
    Then export should be created
    And data should be complete

  @happy-path @news-bookmarks
  Scenario: Mark as read
    Given saved article exists
    When I mark as read
    Then article should be marked
    And I can track progress

  # ============================================================================
  # NEWS SHARING
  # ============================================================================

  @happy-path @news-sharing
  Scenario: Share news
    Given article exists
    When I share news
    Then share options should appear
    And I can choose method

  @happy-path @news-sharing
  Scenario: Share to social media
    Given social is connected
    When I share to social
    Then post should be created
    And article should be linked

  @happy-path @news-sharing
  Scenario: Send to league
    Given I have league
    When I send to league
    Then league should receive
    And they can discuss

  @happy-path @news-sharing
  Scenario: Copy link
    Given article has link
    When I copy link
    Then link should be copied
    And I can paste elsewhere

  @happy-path @news-sharing
  Scenario: Share with team
    Given I have team
    When I share with team
    Then team should receive
    And they can view article

  @happy-path @news-sharing
  Scenario: Email article
    Given I want to email
    When I email article
    Then email should be sent
    And article should be included

  @happy-path @news-sharing
  Scenario: Share to chat
    Given chat exists
    When I share to chat
    Then article should appear in chat
    And we can discuss

  @happy-path @news-sharing
  Scenario: Share via text
    Given I want to text
    When I share via text
    Then message should open
    And link should be included

  @happy-path @news-sharing
  Scenario: View share count
    Given article has shares
    When I view count
    Then I should see share count
    And popularity should be shown

  @happy-path @news-sharing
  Scenario: Share with comment
    Given I want to comment
    When I share with comment
    Then comment should be included
    And recipients can see it

  # ============================================================================
  # NEWS SOURCES
  # ============================================================================

  @happy-path @news-sources
  Scenario: View trusted sources
    Given trusted sources exist
    When I view trusted
    Then I should see trusted sources
    And credibility should be shown

  @happy-path @news-sources
  Scenario: View verified news
    Given verification exists
    When I view verified
    Then I should see verified news
    And authenticity should be clear

  @happy-path @news-sources
  Scenario: Track rumors
    Given rumors exist
    When I view rumors
    Then I should see rumors
    And they should be marked as unverified

  @happy-path @news-sources
  Scenario: View source credibility
    Given credibility is rated
    When I view credibility
    Then I should see rating
    And track record should be shown

  @happy-path @news-sources
  Scenario: View official sources
    Given official sources exist
    When I view official
    Then I should see official news
    And authority should be clear

  @happy-path @news-sources
  Scenario: Compare sources
    Given multiple sources exist
    When I compare sources
    Then I should see comparison
    And differences should be shown

  @happy-path @news-sources
  Scenario: Report inaccurate news
    Given news is inaccurate
    When I report news
    Then report should be submitted
    And it should be reviewed

  @happy-path @news-sources
  Scenario: View source details
    Given source exists
    When I view source details
    Then I should see source info
    And history should be shown

  @happy-path @news-sources
  Scenario: Follow source
    Given source is trustworthy
    When I follow source
    Then source should be followed
    And their news should appear

  @happy-path @news-sources
  Scenario: Block source
    Given I don't trust source
    When I block source
    Then source should be blocked
    And their news won't appear

  # ============================================================================
  # NEWS ANALYSIS
  # ============================================================================

  @happy-path @news-analysis
  Scenario: View expert analysis
    Given analysis exists
    When I view expert analysis
    Then I should see expert opinions
    And reasoning should be clear

  @happy-path @news-analysis
  Scenario: View fantasy impact
    Given impact is analyzed
    When I view impact
    Then I should see fantasy impact
    And projections should be shown

  @happy-path @news-analysis
  Scenario: View player analysis
    Given player analysis exists
    When I view player analysis
    Then I should see player insights
    And recommendations should be made

  @happy-path @news-analysis
  Scenario: View trade implications
    Given trade news exists
    When I view implications
    Then I should see trade impact
    And affected players should be listed

  @happy-path @news-analysis
  Scenario: View start/sit advice
    Given advice is available
    When I view advice
    Then I should see start/sit recommendations
    And reasoning should be provided

  @happy-path @news-analysis
  Scenario: View matchup impact
    Given matchup is affected
    When I view matchup impact
    Then I should see matchup changes
    And projections should update

  @happy-path @news-analysis
  Scenario: View waiver impact
    Given waivers are affected
    When I view waiver impact
    Then I should see pickup targets
    And priority should be suggested

  @happy-path @news-analysis
  Scenario: View historical context
    Given history is relevant
    When I view context
    Then I should see historical context
    And patterns should be shown

  @happy-path @news-analysis
  Scenario: View consensus opinion
    Given multiple experts exist
    When I view consensus
    Then I should see consensus view
    And agreement should be shown

  @happy-path @news-analysis
  Scenario: Export analysis
    Given analysis exists
    When I export analysis
    Then export should be created
    And data should be complete

