@weekly-recaps @recaps @content
Feature: Weekly Recaps
  As a fantasy football league member
  I want to receive comprehensive weekly recaps
  So that I can stay informed about league happenings and relive the week's excitement

  Background:
    Given a fantasy football league exists
    And the league has active members
    And a week of games has been completed

  # ==========================================
  # AUTOMATED RECAP GENERATION
  # ==========================================

  @generation @happy-path
  Scenario: Automatically generate weekly recap after games complete
    Given all matchups for the week have final scores
    When the recap generation process runs
    Then a comprehensive weekly recap is created
    And all league members are notified
    And the recap is available in the league feed

  @generation @timing
  Scenario: Configure recap generation timing
    Given I am the commissioner
    When I configure recap generation settings
    Then I can choose when recaps are generated
    And options include immediate, next morning, or custom time

  @generation @partial
  Scenario: Generate partial recap for Monday night games
    Given Sunday games have completed
    And Monday night games are pending
    When members request an early preview
    Then a partial recap is generated
    And it is marked as preliminary

  @generation @manual
  Scenario: Commissioner manually triggers recap generation
    Given I am the commissioner
    And the automatic recap has not generated
    When I manually trigger recap generation
    Then the recap is created immediately
    And members are notified

  @generation @regenerate
  Scenario: Regenerate recap after stat corrections
    Given a weekly recap has been published
    And stat corrections have occurred
    When the system detects significant changes
    Then an updated recap is generated
    And members are notified of the corrections

  # ==========================================
  # MATCHUP SUMMARIES
  # ==========================================

  @matchup-summary @happy-path
  Scenario: Include all matchup summaries in recap
    Given 6 matchups occurred during the week
    When the recap is generated
    Then all 6 matchup summaries are included
    And each shows final score and winner

  @matchup-summary @narrative
  Scenario: Generate narrative for each matchup
    Given a matchup had a close finish
    When the recap describes the matchup
    Then a narrative summary is included
    And key moments and turning points are highlighted

  @matchup-summary @mvp
  Scenario: Identify matchup MVP
    Given a matchup has been completed
    When the recap analyzes the matchup
    Then the player with the biggest impact is identified as matchup MVP
    And their statistics are highlighted

  @matchup-summary @key-plays
  Scenario: Highlight key plays in matchup
    Given a matchup had decisive plays
    When the recap is generated
    Then key plays like long touchdowns are highlighted
    And their impact on the outcome is explained

  @matchup-summary @head-to-head
  Scenario: Include head-to-head history
    Given two teams have played before
    When their matchup summary is generated
    Then historical head-to-head record is shown
    And any notable streaks are mentioned

  # ==========================================
  # TOP PERFORMERS
  # ==========================================

  @top-performers @happy-path
  Scenario: List top performers of the week
    Given all player scores are finalized
    When the recap identifies top performers
    Then the top 5 scoring players are listed
    And their scores and key statistics are shown

  @top-performers @position
  Scenario: Show top performer at each position
    Given player data is organized by position
    When the recap highlights top performers
    Then the best player at each position is featured
    And their performance is contextualized

  @top-performers @breakout
  Scenario: Highlight breakout performances
    Given a player significantly exceeded their average
    When the recap analyzes performances
    Then breakout performances are called out
    And the deviation from average is shown

  @top-performers @owned
  Scenario: Show which teams owned top performers
    Given top performers have been identified
    When the recap lists them
    Then the owning team is displayed
    And the manager is credited

  @top-performers @waiver
  Scenario: Highlight top performers available on waivers
    Given some top performers were on waivers
    When the recap identifies them
    Then they are featured as "waiver wire gems"
    And pickup recommendations are implied

  # ==========================================
  # SURPRISES AND UPSETS
  # ==========================================

  @surprises @happy-path
  Scenario: Identify biggest surprises of the week
    Given some results were unexpected based on projections
    When the recap analyzes surprises
    Then the most surprising outcomes are highlighted
    And the deviation from expectations is quantified

  @upsets @happy-path
  Scenario: Highlight upset victories
    Given an underdog team defeated a favorite
    When the recap identifies upsets
    Then the upset is prominently featured
    And the projected point differential is shown

  @surprises @bust
  Scenario: Identify player busts of the week
    Given some highly-projected players underperformed
    When the recap analyzes performances
    Then notable busts are called out
    And their expected vs actual points are compared

  @surprises @sleeper
  Scenario: Identify sleeper performances
    Given some low-projected players overperformed
    When the recap analyzes performances
    Then sleeper performances are highlighted
    And managers who started them are credited

  @upsets @streak-breaker
  Scenario: Highlight streak-breaking results
    Given a team's winning streak was snapped
    When the recap identifies notable outcomes
    Then the streak-breaking result is featured
    And the length of the broken streak is mentioned

  # ==========================================
  # CLOSE GAMES
  # ==========================================

  @close-games @happy-path
  Scenario: Create narrative for close games
    Given a matchup was decided by less than 5 points
    When the recap describes the game
    Then a dramatic narrative is generated
    And the tension of the close finish is conveyed

  @close-games @monday-night
  Scenario: Highlight Monday Night Miracles
    Given a game was won on Monday night
    And the margin was less than 10 points
    When the recap is generated
    Then the Monday night drama is featured
    And the pivotal player is highlighted

  @close-games @comeback
  Scenario: Describe comeback victories
    Given a team was trailing significantly and came back to win
    When the recap describes the game
    Then the comeback narrative is featured
    And the turning point is identified

  @close-games @heartbreak
  Scenario: Describe heartbreaking losses
    Given a team lost by less than 1 point
    When the recap describes the game
    Then the heartbreaking nature is conveyed
    And the single play that could have changed it is identified

  @close-games @final-play
  Scenario: Highlight games decided on final plays
    Given a game was decided by a late-night player
    When the recap is generated
    Then the final play drama is featured
    And the suspense is conveyed in the narrative

  # ==========================================
  # BLOWOUT GAMES
  # ==========================================

  @blowout @happy-path
  Scenario: Comment on blowout victories
    Given a matchup was won by more than 40 points
    When the recap describes the game
    Then the dominance is highlighted
    And the blowout is appropriately characterized

  @blowout @historic
  Scenario: Identify historically large margins
    Given a blowout exceeded historical league records
    When the recap analyzes the result
    Then the historical significance is noted
    And it is compared to previous large margins

  @blowout @mercy-rule
  Scenario: Apply humor to lopsided results
    Given the recap style allows for humor
    And a severe blowout occurred
    When the recap describes the game
    Then tasteful humor about the margin is included
    And the losing team is not excessively mocked

  @blowout @analysis
  Scenario: Analyze what went wrong in blowout loss
    Given a team lost in a blowout
    When the recap analyzes the matchup
    Then contributing factors are identified
    And areas for improvement are suggested

  # ==========================================
  # BENCH POINTS ANALYSIS
  # ==========================================

  @bench-points @happy-path
  Scenario: Analyze points left on bench
    Given bench scoring data is available
    When the recap analyzes bench points
    Then total bench points per team are calculated
    And the highest bench point totals are highlighted

  @bench-points @would-have-won
  Scenario: Identify games where bench would have changed outcome
    Given a team lost
    And their bench scored more than the margin of defeat
    When the recap analyzes the situation
    Then this near-miss is highlighted
    And the specific bench player is identified

  @bench-points @optimal-swap
  Scenario: Show optimal lineup swap for each team
    Given actual and optimal lineups can be compared
    When the recap analyzes lineups
    Then the single swap that would have helped most is shown
    And the point improvement is calculated

  @bench-points @league-leader
  Scenario: Identify team with most bench points
    Given all bench points are calculated
    When the recap summarizes bench analysis
    Then the team with most bench points is identified
    And they receive the "Benchwarmer Blues" mention

  # ==========================================
  # OPTIMAL LINEUP COMPARISON
  # ==========================================

  @optimal-lineup @happy-path
  Scenario: Compare actual vs optimal lineup for each team
    Given all player scores are final
    When the recap calculates optimal lineups
    Then each team's actual vs optimal score is shown
    And the efficiency percentage is calculated

  @optimal-lineup @perfect
  Scenario: Highlight team with perfect lineup
    Given a team started their optimal lineup
    When the recap identifies perfect decisions
    Then the team is congratulated
    And their decision-making is praised

  @optimal-lineup @worst
  Scenario: Identify team with worst lineup decisions
    Given lineup efficiency data is available
    When the recap identifies poor decisions
    Then the team with lowest efficiency is noted
    And the points left on table are quantified

  @optimal-lineup @hindsight
  Scenario: Provide hindsight analysis
    Given optimal lineups are calculated
    When the recap provides analysis
    Then "hindsight is 20/20" insights are shared
    And difficult start/sit decisions are acknowledged

  # ==========================================
  # INJURY IMPACT
  # ==========================================

  @injury-impact @happy-path
  Scenario: Summarize injury impacts on matchups
    Given injuries occurred during the week
    When the recap analyzes injury impact
    Then affected matchups are identified
    And the point impact is estimated

  @injury-impact @mid-game
  Scenario: Highlight mid-game injuries
    Given a player was injured during a game
    And this affected a fantasy matchup
    When the recap describes the impact
    Then the injury timing and impact are noted
    And sympathy for the affected manager is conveyed

  @injury-impact @projections
  Scenario: Update injury status for next week
    Given injury reports are available
    When the recap provides forward-looking info
    Then current injury statuses are listed
    And projected return timelines are included

  @injury-impact @replacement
  Scenario: Highlight successful injury replacements
    Given a manager successfully replaced an injured player
    When the recap analyzes decisions
    Then the smart replacement is credited
    And the points gained are highlighted

  # ==========================================
  # WAIVER WIRE MOVES
  # ==========================================

  @waiver-moves @happy-path
  Scenario: Summarize waiver wire activity
    Given waiver claims were processed during the week
    When the recap analyzes waiver activity
    Then top pickups are highlighted
    And the teams making moves are listed

  @waiver-moves @impact
  Scenario: Identify high-impact waiver pickups
    Given a waiver pickup scored significant points
    When the recap evaluates pickups
    Then the pickup is featured
    And the FAAB spent or priority used is noted

  @waiver-moves @trends
  Scenario: Show waiver wire trends
    Given pickup data is available
    When the recap analyzes trends
    Then popular position targets are identified
    And emerging trends are discussed

  @waiver-moves @faab
  Scenario: Analyze FAAB spending
    Given the league uses FAAB
    When the recap summarizes spending
    Then top spenders are identified
    And remaining budget standings are shown

  @waiver-moves @steals
  Scenario: Highlight waiver wire steals
    Given a low-cost pickup performed well
    When the recap identifies steals
    Then the steal is featured
    And the value gained is calculated

  # ==========================================
  # TRADE ANALYSIS
  # ==========================================

  @trade-recap @happy-path
  Scenario: Summarize trades made during the week
    Given trades were completed during the week
    When the recap summarizes trades
    Then each trade is described
    And initial analysis is provided

  @trade-recap @winners
  Scenario: Identify early trade winners
    Given traded players have now played
    When the recap analyzes trade outcomes
    Then early winners are identified
    And performance comparisons are shown

  @trade-recap @impact
  Scenario: Show trade impact on matchups
    Given traded players affected matchup outcomes
    When the recap analyzes impact
    Then the trade's matchup impact is highlighted
    And "what if" scenarios are mentioned

  @trade-recap @blockbuster
  Scenario: Feature blockbuster trades
    Given a significant trade was made
    When the recap highlights trades
    Then the blockbuster trade is prominently featured
    And expert analysis is provided

  # ==========================================
  # POWER RANKINGS
  # ==========================================

  @power-rankings @happy-path
  Scenario: Include power ranking changes in recap
    Given power rankings are calculated
    When the recap includes standings info
    Then current power rankings are shown
    And changes from last week are highlighted

  @power-rankings @movers
  Scenario: Highlight biggest movers
    Given power rankings have changed
    When the recap identifies movers
    Then biggest risers are featured
    And biggest fallers are noted

  @power-rankings @top-bottom
  Scenario: Feature top and bottom ranked teams
    Given power rankings are finalized
    When the recap discusses rankings
    Then the top team is praised
    And the bottom team is discussed

  @power-rankings @trend
  Scenario: Show power ranking trends
    Given multiple weeks of rankings exist
    When the recap analyzes trends
    Then teams trending up or down are identified
    And the trajectory is visualized

  # ==========================================
  # PLAYOFF PICTURE
  # ==========================================

  @playoff-picture @happy-path
  Scenario: Update playoff picture in recap
    Given the regular season is in progress
    When the recap includes playoff info
    Then current playoff standings are shown
    And clinching scenarios are listed

  @playoff-picture @clinch
  Scenario: Highlight playoff clinches
    Given a team clinched a playoff spot
    When the recap covers standings
    Then the clinching is celebrated
    And the path to clinching is summarized

  @playoff-picture @elimination
  Scenario: Note playoff eliminations
    Given a team has been eliminated from playoffs
    When the recap discusses standings
    Then the elimination is noted
    And their season is summarized

  @playoff-picture @bubble
  Scenario: Analyze bubble teams
    Given several teams are on the playoff bubble
    When the recap analyzes the picture
    Then bubble team scenarios are discussed
    And remaining schedules are compared

  @playoff-picture @projections
  Scenario: Show playoff probability projections
    Given simulation data is available
    When the recap includes projections
    Then each team's playoff probability is shown
    And changes from last week are noted

  # ==========================================
  # TRASH TALK HIGHLIGHTS
  # ==========================================

  @trash-talk @happy-path
  Scenario: Include trash talk highlights in recap
    Given league chat had notable banter
    When the recap curates content
    Then the best trash talk is featured
    And it is attributed to the speaker

  @trash-talk @predictions
  Scenario: Track trash talk predictions
    Given members made bold predictions
    When outcomes are known
    Then accurate predictions are credited
    And failed predictions are playfully noted

  @trash-talk @quotes
  Scenario: Feature quote of the week
    Given memorable quotes were made
    When the recap selects highlights
    Then a "quote of the week" is featured
    And context is provided

  @trash-talk @filter
  Scenario: Filter inappropriate trash talk
    Given some content may be too harsh
    When the recap curates content
    Then inappropriate content is filtered
    And only league-appropriate banter is included

  @trash-talk @consent
  Scenario: Allow opting out of trash talk features
    Given a member prefers privacy
    When they opt out of trash talk features
    Then their quotes are not featured
    And they are excluded from this section

  # ==========================================
  # LEAGUE-WIDE STATISTICS
  # ==========================================

  @league-stats @happy-path
  Scenario: Include league-wide statistics in recap
    Given all weekly data is available
    When the recap compiles statistics
    Then league-wide metrics are included
    And comparisons to previous weeks are shown

  @league-stats @scoring
  Scenario: Show league scoring summary
    Given all scores are final
    When the recap summarizes scoring
    Then total league points are shown
    And average score per team is calculated

  @league-stats @records
  Scenario: Note new league records
    Given a record was broken this week
    When the recap checks records
    Then the new record is prominently featured
    And the previous record holder is mentioned

  @league-stats @comparison
  Scenario: Compare to league historical averages
    Given historical data is available
    When the recap provides context
    Then current week is compared to historical norms
    And notable deviations are highlighted

  @league-stats @positions
  Scenario: Show position scoring breakdown
    Given position-level data is available
    When the recap analyzes scoring
    Then scoring by position is shown
    And league-wide position trends are noted

  # ==========================================
  # PHOTO/MEME INTEGRATION
  # ==========================================

  @photo-meme @happy-path
  Scenario: Include photo of the week
    Given the commissioner has enabled photo features
    When the recap is assembled
    Then a section for photos is included
    And members can submit photos

  @photo-meme @submission
  Scenario: Submit meme for weekly recap
    Given I am a league member
    When I submit a meme before the deadline
    Then my submission is considered for the recap
    And I am notified if selected

  @photo-meme @voting
  Scenario: Vote on best meme
    Given multiple memes were submitted
    When voting is open
    Then members can vote for their favorite
    And the winner is featured in the recap

  @photo-meme @auto-generate
  Scenario: Auto-generate meme for notable events
    Given a notable event occurred
    And meme templates are available
    When the recap is generated
    Then a relevant meme is auto-generated
    And it is included in the recap

  @photo-meme @moderation
  Scenario: Moderate submitted content
    Given I am the commissioner
    When I review submitted content
    Then I can approve or reject submissions
    And rejected content is not published

  # ==========================================
  # COMMISSIONER COMMENTARY
  # ==========================================

  @commissioner @happy-path
  Scenario: Include commissioner commentary
    Given I am the commissioner
    When I add commentary to the recap
    Then my comments appear in a dedicated section
    And they are clearly attributed to me

  @commissioner @preview
  Scenario: Commissioner previews recap before publishing
    Given the recap is ready for review
    When I preview the recap as commissioner
    Then I see the full recap before it goes live
    And I can make edits or additions

  @commissioner @edit
  Scenario: Commissioner edits generated content
    Given the recap has auto-generated content
    When I edit sections as commissioner
    Then my edits are saved
    And the original content is replaced

  @commissioner @sticky
  Scenario: Commissioner adds sticky notes
    Given I want to highlight something important
    When I add a sticky note to the recap
    Then it appears prominently
    And it can be marked as urgent

  @commissioner @schedule
  Scenario: Commissioner schedules recap release
    Given the recap is ready
    When I schedule the release time
    Then the recap is held until the scheduled time
    And it auto-publishes at the specified time

  # ==========================================
  # EMAIL AND PUSH NOTIFICATIONS
  # ==========================================

  @notifications @email @happy-path
  Scenario: Send recap via email
    Given members have email notifications enabled
    When the recap is published
    Then an email with the full recap is sent
    And the email is mobile-friendly

  @notifications @push @happy-path
  Scenario: Send push notification for new recap
    Given members have push notifications enabled
    When the recap is published
    Then a push notification is sent
    And tapping the notification opens the recap

  @notifications @digest
  Scenario: Configure recap notification preferences
    Given I am a league member
    When I access notification settings
    Then I can choose email, push, both, or none
    And I can set preferred delivery time

  @notifications @preview
  Scenario: Include recap preview in notification
    Given a recap notification is being sent
    When the notification is composed
    Then a teaser preview is included
    And key highlights are mentioned

  @notifications @unsubscribe
  Scenario: Unsubscribe from recap notifications
    Given I no longer want recap notifications
    When I unsubscribe
    Then I stop receiving recap notifications
    But I can still view recaps in the app

  # ==========================================
  # SOCIAL MEDIA SHARING
  # ==========================================

  @social @happy-path
  Scenario: Share recap on social media
    Given a recap has been published
    When I click share
    Then I see options for major social platforms
    And a formatted share message is created

  @social @highlights
  Scenario: Share specific highlights
    Given I want to share a specific part of the recap
    When I select a highlight to share
    Then only that content is shared
    And it includes appropriate context

  @social @image
  Scenario: Generate shareable recap graphic
    Given I want to share visually
    When I generate a recap graphic
    Then an attractive summary image is created
    And it includes key statistics

  @social @league-feed
  Scenario: Auto-post to league social feed
    Given the league has a social feed enabled
    When the recap is published
    Then it is automatically posted to the feed
    And members can react and comment

  @social @privacy
  Scenario: Control sharing privacy
    Given I want to share a recap
    When I configure sharing options
    Then I can hide team names or scores
    And league privacy is respected

  # ==========================================
  # HISTORICAL ARCHIVE
  # ==========================================

  @archive @happy-path
  Scenario: Access historical recap archive
    Given multiple weeks of recaps exist
    When I access the recap archive
    Then all past recaps are listed chronologically
    And I can browse by season and week

  @archive @search
  Scenario: Search recap archive
    Given extensive recap history exists
    When I search for specific content
    Then relevant recaps are returned
    And search terms are highlighted

  @archive @compare
  Scenario: Compare recaps across weeks
    Given I want to see progression
    When I select weeks to compare
    Then side-by-side comparisons are shown
    And trends are visualized

  @archive @favorite
  Scenario: Bookmark favorite recaps
    Given a recap is particularly memorable
    When I bookmark the recap
    Then it is saved to my favorites
    And I can easily access it later

  @archive @export
  Scenario: Export recap history
    Given I want to preserve recaps
    When I export recap history
    Then a downloadable file is generated
    And all recap content is included

  # ==========================================
  # MOBILE EXPERIENCE
  # ==========================================

  @mobile @happy-path
  Scenario: View recap on mobile device
    Given I am using a mobile device
    When I view the weekly recap
    Then the recap is optimized for mobile
    And all content is easily readable

  @mobile @swipe
  Scenario: Navigate recap with swipe gestures
    Given I am viewing a recap on mobile
    When I swipe through sections
    Then I can easily navigate the recap
    And progress indicators are shown

  @mobile @collapsible
  Scenario: Expand and collapse recap sections
    Given the recap has multiple sections
    When I tap a section header
    Then the section expands or collapses
    And I can focus on content I care about

  @mobile @offline
  Scenario: View recap offline
    Given I viewed a recap while online
    When I lose internet connection
    Then I can still access the cached recap
    And core content is available

  @mobile @widget
  Scenario: Display recap in home screen widget
    Given I have the recap widget enabled
    When a new recap is published
    Then key highlights appear in my widget
    And I can tap to see the full recap

  # ==========================================
  # AUDIO AND PODCAST
  # ==========================================

  @audio @happy-path
  Scenario: Generate audio version of recap
    Given text-to-speech is enabled
    When the recap is generated
    Then an audio version is created
    And members can listen to the recap

  @audio @podcast
  Scenario: Subscribe to recap podcast feed
    Given audio recaps are generated
    When I subscribe to the podcast feed
    Then new episodes appear automatically
    And I can listen in my podcast app

  @audio @voice
  Scenario: Configure audio voice preferences
    Given audio recaps are available
    When I configure voice settings
    Then I can choose voice style and speed
    And my preferences are saved

  @audio @highlights
  Scenario: Generate audio highlights only
    Given I prefer shorter audio content
    When I request highlight audio
    Then a condensed audio version is created
    And only key points are included

  @audio @background
  Scenario: Listen to recap in background
    Given I am listening to the audio recap
    When I switch to another app
    Then the audio continues playing
    And playback controls are accessible

  # ==========================================
  # VIDEO HIGHLIGHTS
  # ==========================================

  @video @happy-path
  Scenario: Integrate video highlights into recap
    Given video highlights are available
    When the recap includes video content
    Then videos are embedded in the recap
    And they play inline when tapped

  @video @auto-compile
  Scenario: Auto-compile video highlight reel
    Given multiple highlight clips are available
    When the recap is generated
    Then a compiled highlight reel is created
    And transitions are smooth

  @video @player-highlights
  Scenario: Link to player highlight videos
    Given a player had a notable performance
    When their stats are shown in the recap
    Then a link to their highlights is included
    And the video is from a reliable source

  @video @gif
  Scenario: Include animated GIFs in recap
    Given the recap includes visual content
    When notable plays occurred
    Then relevant GIFs are embedded
    And they auto-play on scroll

  # ==========================================
  # PERSONALIZED RECAPS
  # ==========================================

  @personalized @happy-path
  Scenario: Generate personalized team recap
    Given I am a league member with a team
    When I access my personalized recap
    Then the content focuses on my team
    And my matchup is prominently featured

  @personalized @insights
  Scenario: Provide personalized insights
    Given my team has specific patterns
    When my personalized recap is generated
    Then insights about my team are included
    And suggestions for improvement are made

  @personalized @comparison
  Scenario: Compare my team to league average
    Given league-wide data is available
    When I view my personalized recap
    Then my team is compared to averages
    And strengths and weaknesses are noted

  @personalized @goals
  Scenario: Track personal goals in recap
    Given I have set personal goals
    When the recap is generated
    Then progress toward goals is shown
    And milestones are celebrated

  @personalized @rival
  Scenario: Include rival team updates
    Given I have designated a rival
    When my personalized recap is generated
    Then my rival's performance is noted
    And head-to-head comparison is included

  # ==========================================
  # INTERACTIVE ELEMENTS
  # ==========================================

  @interactive @polls
  Scenario: Include polls in recap
    Given the commissioner has enabled polls
    When the recap is published
    Then interactive polls are included
    And members can vote directly in the recap

  @interactive @predictions
  Scenario: Include next week predictions
    Given the next week's matchups are set
    When the recap is generated
    Then prediction prompts are included
    And members can make predictions

  @interactive @reactions
  Scenario: React to recap sections
    Given I am viewing a recap section
    When I tap a reaction button
    Then my reaction is recorded
    And reaction counts are visible

  @interactive @comments
  Scenario: Comment on recap sections
    Given I want to discuss a recap item
    When I add a comment
    Then my comment appears in context
    And other members can reply

  @interactive @quizzes
  Scenario: Include trivia quizzes
    Given quiz content is enabled
    When the recap includes a quiz
    Then members can answer questions
    And scores are tracked

  # ==========================================
  # ERROR HANDLING
  # ==========================================

  @error-handling
  Scenario: Handle missing game data gracefully
    Given some game data is unavailable
    When the recap is generated
    Then available sections are included
    And missing sections are noted
    And the recap still publishes

  @error-handling
  Scenario: Handle failed audio generation
    Given audio generation fails
    When the recap is published
    Then the text recap is still available
    And users are notified audio is unavailable

  @error-handling
  Scenario: Handle network errors during recap load
    Given I am viewing a recap
    When a network error occurs
    Then cached content is displayed if available
    And a retry option is presented

  @error-handling
  Scenario: Handle unsupported video formats
    Given a video in an unsupported format exists
    When the recap tries to include it
    Then a fallback image or link is shown
    And users can access the video externally

  # ==========================================
  # ACCESSIBILITY
  # ==========================================

  @accessibility
  Scenario: Navigate recap with screen reader
    Given I am using a screen reader
    When I access the weekly recap
    Then all content is properly labeled
    And navigation is intuitive

  @accessibility
  Scenario: View recap with high contrast
    Given I have high contrast mode enabled
    When I view the recap
    Then all content has sufficient contrast
    And charts are still readable

  @accessibility
  Scenario: Access recap with keyboard only
    Given I navigate with keyboard only
    When I browse the recap
    Then all interactive elements are reachable
    And focus indicators are visible

  @accessibility
  Scenario: View recap with reduced motion
    Given I have reduced motion preferences
    When I view the recap
    Then animations are minimized
    And auto-playing content is paused

  @accessibility
  Scenario: Use recap with voice control
    Given I use voice control
    When I navigate the recap
    Then voice commands work correctly
    And all sections are accessible
