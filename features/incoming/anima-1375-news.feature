@news @anima-1375
Feature: News
  As a fantasy football user
  I want comprehensive news and content coverage
  So that I can stay informed about players, teams, and the league

  Background:
    Given I am a logged-in user
    And the news system is available

  # ============================================================================
  # NEWS FEED
  # ============================================================================

  @happy-path @news-feed
  Scenario: View news feed
    Given I access the news section
    When I view the news feed
    Then I should see recent news articles
    And articles should be sorted by recency

  @happy-path @news-feed
  Scenario: View headlines
    Given I am viewing the news feed
    Then I should see top headlines
    And headlines should be prominently displayed

  @happy-path @news-feed
  Scenario: View breaking news
    Given there is breaking news
    Then I should see breaking news alerts
    And breaking news should be highlighted

  @happy-path @news-feed
  Scenario: View featured stories
    Given I am viewing the news feed
    Then I should see featured stories
    And featured content should stand out

  @happy-path @news-feed
  Scenario: View trending news
    Given I am viewing the news feed
    When I check trending
    Then I should see trending topics
    And trending should be based on engagement

  @happy-path @news-feed
  Scenario: Refresh news feed
    Given I am viewing the news feed
    When I refresh the feed
    Then I should see updated news
    And new articles should appear

  @happy-path @news-feed
  Scenario: Load more news
    Given I am viewing the news feed
    When I scroll to load more
    Then I should see additional articles
    And loading should be smooth

  @mobile @news-feed
  Scenario: View news feed on mobile
    Given I am on a mobile device
    When I view the news feed
    Then the feed should be mobile-optimized
    And I should be able to scroll easily

  # ============================================================================
  # PLAYER NEWS
  # ============================================================================

  @happy-path @player-news
  Scenario: View player updates
    Given I am viewing a player
    When I check their news
    Then I should see player-specific updates
    And updates should be recent

  @happy-path @player-news
  Scenario: View injury reports
    Given a player has an injury
    When I view injury reports
    Then I should see injury status
    And I should see expected return timeline

  @happy-path @player-news
  Scenario: View transaction news
    Given there are player transactions
    When I view transaction news
    Then I should see trades, signings, releases
    And transactions should be timely

  @happy-path @player-news
  Scenario: View contract updates
    Given there are contract updates
    When I view contract news
    Then I should see contract details
    And impact on fantasy should be noted

  @happy-path @player-news
  Scenario: View practice reports
    Given practice has occurred
    When I view practice reports
    Then I should see participation status
    And injury designations should be shown

  @happy-path @player-news
  Scenario: Filter news by player
    Given I want specific player news
    When I filter by player name
    Then I should see only that player's news
    And filter should be clearable

  @happy-path @player-news
  Scenario: Subscribe to player news
    Given I want updates on a player
    When I subscribe to their news
    Then I should receive updates
    And I can unsubscribe later

  # ============================================================================
  # TEAM NEWS
  # ============================================================================

  @happy-path @team-news
  Scenario: View NFL team news
    Given I select an NFL team
    When I view team news
    Then I should see team-specific news
    And news should be recent

  @happy-path @team-news
  Scenario: View roster moves
    Given a team makes roster moves
    When I view roster moves
    Then I should see additions and releases
    And moves should affect fantasy

  @happy-path @team-news
  Scenario: View coaching changes
    Given there are coaching changes
    When I view coaching news
    Then I should see staff changes
    And impact should be analyzed

  @happy-path @team-news
  Scenario: View organizational updates
    Given there are organizational changes
    When I view org updates
    Then I should see front office news
    And implications should be explained

  @happy-path @team-news
  Scenario: View game previews
    Given games are upcoming
    When I view game previews
    Then I should see matchup analysis
    And fantasy implications should be noted

  @happy-path @team-news
  Scenario: View game recaps
    Given games have concluded
    When I view game recaps
    Then I should see game summaries
    And standout performances should be highlighted

  @happy-path @team-news
  Scenario: Follow NFL team
    Given I want to follow a team
    When I follow the team
    Then I should receive their news
    And I can unfollow later

  # ============================================================================
  # LEAGUE NEWS
  # ============================================================================

  @happy-path @league-news
  Scenario: View fantasy league updates
    Given I am in a fantasy league
    When I view league news
    Then I should see league activity
    And updates should be relevant

  @happy-path @league-news
  Scenario: View commissioner announcements
    Given the commissioner posted an announcement
    When I view league news
    Then I should see announcements
    And they should be highlighted

  @happy-path @league-news
  Scenario: View league activity feed
    Given there is league activity
    When I view the activity feed
    Then I should see transactions and trades
    And activity should be chronological

  @happy-path @league-news
  Scenario: View trade news
    Given trades have occurred
    When I view trade news
    Then I should see trade details
    And trade analysis should be available

  @happy-path @league-news
  Scenario: View waiver activity
    Given waivers have processed
    When I view waiver news
    Then I should see waiver pickups
    And hot pickups should be noted

  @happy-path @league-news
  Scenario: Configure league news preferences
    Given I am in league settings
    When I configure news preferences
    Then I should choose which updates to see
    And preferences should be saved

  # ============================================================================
  # PERSONALIZED NEWS
  # ============================================================================

  @happy-path @personalized-news
  Scenario: View customized feed
    Given I have preferences set
    When I view my news feed
    Then I should see personalized content
    And content should match my interests

  @happy-path @personalized-news
  Scenario: See followed players news
    Given I follow players
    When I view my feed
    Then I should see news about followed players
    And they should be prioritized

  @happy-path @personalized-news
  Scenario: See followed teams news
    Given I follow teams
    When I view my feed
    Then I should see news about followed teams
    And they should be prioritized

  @happy-path @personalized-news
  Scenario: View interests-based content
    Given I have set interests
    When I view content recommendations
    Then content should match my interests
    And recommendations should be relevant

  @happy-path @personalized-news
  Scenario: Get content recommendations
    Given I use the platform
    Then I should see recommended content
    And recommendations should improve over time

  @happy-path @personalized-news
  Scenario: Update personalization preferences
    Given I want to change preferences
    When I update my preferences
    Then my feed should reflect changes
    And new preferences should be saved

  @happy-path @personalized-news
  Scenario: Reset personalization
    Given I want a fresh start
    When I reset personalization
    Then preferences should be cleared
    And I should see default feed

  # ============================================================================
  # NEWS CATEGORIES
  # ============================================================================

  @happy-path @news-categories
  Scenario: Filter by category
    Given I am viewing news
    When I filter by category
    Then I should see only that category
    And filter should be clearable

  @happy-path @news-categories
  Scenario: Browse sport sections
    Given I want specific sport content
    When I browse sections
    Then I should see organized sections
    And I can navigate between them

  @happy-path @news-categories
  Scenario: Filter by news type
    Given I want specific news types
    When I filter by type
    Then I should see only that type
    And types should be clear

  @happy-path @news-categories
  Scenario: Browse by topic tags
    Given articles have topic tags
    When I browse by tag
    Then I should see tagged content
    And related tags should be shown

  @happy-path @news-categories
  Scenario: View content organization
    Given I am browsing news
    Then content should be well-organized
    And I can easily find what I need

  @happy-path @news-categories
  Scenario: Combine multiple filters
    Given I want specific content
    When I apply multiple filters
    Then results should match all filters
    And I can clear individual filters

  # ============================================================================
  # NEWS NOTIFICATIONS
  # ============================================================================

  @happy-path @news-notifications
  Scenario: Receive breaking news alerts
    Given breaking news occurs
    Then I should receive an alert
    And alert should be timely

  @happy-path @news-notifications
  Scenario: Receive push notifications
    Given I have push enabled
    When important news occurs
    Then I should receive push notification
    And I can tap to read more

  @happy-path @news-notifications
  Scenario: Receive email digests
    Given I am subscribed to digests
    When digest time arrives
    Then I should receive email digest
    And digest should summarize news

  @happy-path @news-notifications
  Scenario: Configure alert settings
    Given I am in notification settings
    When I configure news alerts
    Then I should choose alert types
    And preferences should be saved

  @happy-path @news-notifications
  Scenario: Set quiet hours for alerts
    Given I want quiet hours
    When I set quiet hours
    Then alerts should be suppressed
    And they should queue for later

  @happy-path @news-notifications
  Scenario: Disable news notifications
    Given I receive too many alerts
    When I disable news notifications
    Then I should stop receiving alerts
    And I can re-enable later

  # ============================================================================
  # NEWS SOURCES
  # ============================================================================

  @happy-path @news-sources
  Scenario: View news from multiple sources
    Given news comes from multiple sources
    When I view news
    Then I should see source attribution
    And sources should be credible

  @happy-path @news-sources
  Scenario: View source credibility
    Given I am viewing an article
    Then I should see source credibility
    And trusted sources should be indicated

  @happy-path @news-sources
  Scenario: View expert analysis
    Given experts provide analysis
    When I view expert content
    Then I should see expert insights
    And expert credentials should be shown

  @happy-path @news-sources
  Scenario: View beat reporter content
    Given beat reporters cover teams
    When I view their content
    Then I should see insider info
    And reporter should be identified

  @happy-path @news-sources
  Scenario: Filter by verified sources
    Given I trust certain sources
    When I filter by verified sources
    Then I should see verified content only
    And verification should be clear

  @happy-path @news-sources
  Scenario: Block specific sources
    Given I dislike certain sources
    When I block a source
    Then their content should not appear
    And I can unblock later

  # ============================================================================
  # NEWS SHARING
  # ============================================================================

  @happy-path @news-sharing
  Scenario: Share article
    Given I am reading an article
    When I share the article
    Then sharing options should appear
    And I can choose how to share

  @happy-path @news-sharing
  Scenario: Share to social media
    Given I want to share socially
    When I share to social media
    Then the article should be shared
    And it should link back

  @happy-path @news-sharing
  Scenario: Bookmark article
    Given I want to save an article
    When I bookmark it
    Then the article should be saved
    And I can access it later

  @happy-path @news-sharing
  Scenario: View reading list
    Given I have bookmarked articles
    When I view my reading list
    Then I should see saved articles
    And I can manage the list

  @happy-path @news-sharing
  Scenario: Save for later
    Given I want to read later
    When I save an article
    Then it should be saved for later
    And I can access it offline

  @happy-path @news-sharing
  Scenario: Copy article link
    Given I want to share a link
    When I copy the link
    Then the link should be copied
    And I can paste it elsewhere

  @happy-path @news-sharing
  Scenario: Remove from bookmarks
    Given I bookmarked an article
    When I remove the bookmark
    Then it should be removed from list
    And I should see confirmation

  # ============================================================================
  # NEWS SEARCH
  # ============================================================================

  @happy-path @news-search
  Scenario: Search news articles
    Given I want to find specific news
    When I search for keywords
    Then I should see matching articles
    And search should be fast

  @happy-path @news-search
  Scenario: Filter search by date
    Given I am searching news
    When I filter by date range
    Then I should see articles from that period
    And date filter should be clear

  @happy-path @news-search
  Scenario: Use keyword search
    Given I have specific keywords
    When I search with keywords
    Then articles with those keywords should appear
    And keywords should be highlighted

  @happy-path @news-search
  Scenario: Use advanced filters
    Given I need specific results
    When I use advanced filters
    Then I should combine multiple criteria
    And results should be precise

  @happy-path @news-search
  Scenario: View search history
    Given I have searched before
    When I view search history
    Then I should see past searches
    And I can repeat a search

  @happy-path @news-search
  Scenario: Clear search history
    Given I have search history
    When I clear history
    Then history should be deleted
    And I should see confirmation

  @happy-path @news-search
  Scenario: Save search query
    Given I want to repeat a search
    When I save the search
    Then the query should be saved
    And I can run it again
