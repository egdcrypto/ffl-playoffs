@mock-drafts @drafts @simulation
Feature: Mock Drafts
  As a fantasy football player
  I want to practice drafting in mock draft simulations
  So that I can refine my strategy and prepare for my real draft

  Background:
    Given a fantasy football platform exists
    And mock draft functionality is enabled
    And current player data and rankings are available

  # ==========================================
  # SOLO MOCK DRAFT VS AI
  # ==========================================

  @solo-mock @ai @happy-path
  Scenario: Start solo mock draft against AI opponents
    Given I am a registered user
    When I start a new solo mock draft
    Then I am placed in a draft room with AI opponents
    And the draft begins when I am ready
    And AI teams make intelligent picks

  @solo-mock @ai-difficulty
  Scenario: Configure AI difficulty level
    Given I am starting a solo mock draft
    When I select AI difficulty level
    Then I can choose from easy, medium, or hard
    And the AI drafting behavior adjusts accordingly

  @solo-mock @ai-behavior
  Scenario: AI drafts based on realistic strategies
    Given a solo mock draft is in progress
    When an AI team is on the clock
    Then they consider team needs and ADP
    And they may reach for players or take BPA
    And their picks simulate real drafters

  @solo-mock @pause
  Scenario: Pause solo mock draft
    Given a solo mock draft is in progress
    When I pause the draft
    Then the draft timer stops
    And I can resume when ready
    And my progress is saved

  @solo-mock @speed
  Scenario: Adjust AI pick speed
    Given I am starting a solo mock draft
    When I configure pick speed settings
    Then I can set how fast AI teams pick
    And options range from instant to realistic timing

  # ==========================================
  # MULTI-PLAYER MOCK LOBBIES
  # ==========================================

  @multiplayer @lobby @happy-path
  Scenario: Join public mock draft lobby
    Given public mock draft lobbies are available
    When I browse available lobbies
    Then I see lobbies with open spots
    And I can join a lobby that fits my preferences

  @multiplayer @create
  Scenario: Create private mock draft lobby
    Given I want to practice with friends
    When I create a private mock draft lobby
    Then I receive a shareable invite link
    And only invited users can join
    And I can set lobby parameters

  @multiplayer @fill
  Scenario: Fill empty spots with AI
    Given a mock draft lobby has empty spots
    When the draft start time arrives
    Then empty spots are filled with AI drafters
    And the draft proceeds normally

  @multiplayer @ready
  Scenario: All players ready up before draft
    Given a mock draft lobby is full
    When all players indicate they are ready
    Then the draft countdown begins
    And the draft starts when countdown ends

  @multiplayer @leave
  Scenario: Handle player leaving mid-draft
    Given a multiplayer mock draft is in progress
    When a player leaves the draft
    Then their team is taken over by AI
    And other players are notified
    And the draft continues

  @multiplayer @reconnect
  Scenario: Reconnect to mock draft after disconnect
    Given I was disconnected from a mock draft
    When I reconnect within the timeout window
    Then I rejoin my draft position
    And I see current draft state
    And I can continue drafting

  # ==========================================
  # DRAFT POSITION
  # ==========================================

  @draft-position @happy-path
  Scenario: Select preferred draft position
    Given I am joining a mock draft
    When I select my preferred draft position
    Then I am assigned that position if available
    And the draft order reflects my selection

  @draft-position @random
  Scenario: Randomize draft position
    Given I want a random draft position
    When I choose random position assignment
    Then I am assigned a random position
    And my position is revealed at draft start

  @draft-position @specific
  Scenario: Practice from specific draft slot
    Given I want to practice from pick 7
    When I select position 7 specifically
    Then I am placed in the 7th draft slot
    And I practice strategies for that position

  @draft-position @preference
  Scenario: Set position preference with fallback
    Given I prefer positions 1-3
    When I set my position preference range
    Then I am assigned within that range if available
    And I get the closest available position otherwise

  # ==========================================
  # DRAFT BOARD DISPLAY
  # ==========================================

  @draft-board @happy-path
  Scenario: View real-time draft board
    Given a mock draft is in progress
    When I view the draft board
    Then I see all picks made in order
    And available players are clearly shown
    And my upcoming picks are highlighted

  @draft-board @filters
  Scenario: Filter draft board by position
    Given the draft board is displayed
    When I filter by a specific position
    Then only players at that position are shown
    And I can quickly find position-specific targets

  @draft-board @search
  Scenario: Search for specific player on draft board
    Given the draft board is displayed
    When I search for a player by name
    Then matching players are highlighted
    And their availability status is shown

  @draft-board @columns
  Scenario: Customize draft board columns
    Given I am viewing the draft board
    When I customize column display
    Then I can add or remove stat columns
    And my preferences are saved

  @draft-board @team-view
  Scenario: View any team's roster during draft
    Given a mock draft is in progress
    When I click on another team
    Then I see their current roster
    And I can assess their needs and strategy

  @draft-board @grid-vs-list
  Scenario: Toggle between grid and list view
    Given I am viewing the draft board
    When I toggle view mode
    Then I can switch between grid and list layouts
    And both views show essential information

  # ==========================================
  # PICK TIMER
  # ==========================================

  @pick-timer @happy-path
  Scenario: Enforce pick timer during draft
    Given a mock draft is configured with timers
    When a team is on the clock
    Then a countdown timer is displayed
    And the team must pick before time expires

  @pick-timer @configure
  Scenario: Configure pick timer duration
    Given I am setting up a mock draft
    When I configure the pick timer
    Then I can set duration from 30 seconds to 5 minutes
    And the timer applies to all picks

  @pick-timer @no-timer
  Scenario: Disable pick timer for casual drafting
    Given I want a relaxed mock draft experience
    When I disable the pick timer
    Then there is no time limit on picks
    And I can take as long as needed

  @pick-timer @warning
  Scenario: Display timer warning when time is low
    Given I am on the clock
    When my time drops below 10 seconds
    Then a warning indicator appears
    And an audio alert plays if enabled

  @pick-timer @pause-timer
  Scenario: Pause timer in solo mock draft
    Given I am in a solo mock draft with timers
    When I pause the draft
    Then my timer pauses
    And it resumes when I continue

  # ==========================================
  # AUTO-DRAFT
  # ==========================================

  @auto-draft @happy-path
  Scenario: Auto-draft when timer expires
    Given I am on the clock
    And my timer expires
    When auto-draft activates
    Then the best available player is selected based on my rankings
    And the draft continues to the next team

  @auto-draft @enable
  Scenario: Enable auto-draft mode
    Given I need to step away from the draft
    When I enable auto-draft mode
    Then my picks are made automatically
    And picks follow my pre-draft rankings

  @auto-draft @disable
  Scenario: Disable auto-draft to resume manual picking
    Given I am in auto-draft mode
    When I disable auto-draft
    Then I resume manual control
    And my next pick is made by me

  @auto-draft @queue
  Scenario: Auto-draft follows my queue
    Given I have set up a player queue
    When auto-draft makes a pick
    Then it selects the highest available player from my queue
    And falls back to rankings if queue is empty

  @auto-draft @settings
  Scenario: Configure auto-draft preferences
    Given I am setting up auto-draft
    When I configure preferences
    Then I can set position limits
    And I can exclude specific players
    And I can prioritize certain positions

  # ==========================================
  # PLAYER RANKINGS
  # ==========================================

  @rankings @happy-path
  Scenario: View player rankings during draft
    Given a mock draft is in progress
    When I view player rankings
    Then I see players ranked by projected value
    And rankings are updated as players are drafted

  @rankings @custom
  Scenario: Create custom player rankings
    Given I want to use my own rankings
    When I create custom rankings
    Then I can reorder players as I prefer
    And my rankings are used for auto-draft

  @rankings @import
  Scenario: Import rankings from external source
    Given I have rankings from another source
    When I import the rankings file
    Then my rankings are updated
    And conflicts are highlighted for review

  @rankings @tiers
  Scenario: View players by tier
    Given rankings include tier information
    When I view tiered rankings
    Then players are grouped by tier
    And I can easily see tier breaks

  @rankings @compare
  Scenario: Compare multiple ranking sources
    Given multiple ranking sources are available
    When I view comparison mode
    Then I see rankings from different experts
    And I can see consensus and outliers

  # ==========================================
  # PROJECTIONS
  # ==========================================

  @projections @happy-path
  Scenario: View player projections
    Given I am viewing a player
    When I check their projections
    Then I see projected stats and points
    And projections use league scoring settings

  @projections @league-specific
  Scenario: Apply league-specific scoring to projections
    Given my league has custom scoring
    When projections are calculated
    Then they reflect my league's scoring system
    And player values adjust accordingly

  @projections @weekly
  Scenario: View weekly projections breakdown
    Given I want detailed projections
    When I view weekly breakdown
    Then I see projected points by week
    And bye weeks are highlighted

  @projections @comparison
  Scenario: Compare projections between players
    Given I am deciding between two players
    When I compare their projections
    Then I see side-by-side projections
    And key differences are highlighted

  # ==========================================
  # ADP DATA
  # ==========================================

  @adp @happy-path
  Scenario: Display ADP for each player
    Given player ADP data is available
    When I view a player's information
    Then their ADP is displayed
    And I see their typical draft round

  @adp @trends
  Scenario: Show ADP trends over time
    Given historical ADP data exists
    When I view ADP trends
    Then I see how a player's ADP has changed
    And rising and falling players are identified

  @adp @platform
  Scenario: View ADP by platform
    Given ADP varies by platform
    When I filter ADP by platform
    Then I see platform-specific ADP data
    And I can compare across platforms

  @adp @value
  Scenario: Identify value picks based on ADP
    Given current draft position is known
    When the system analyzes available players
    Then players available below their ADP are flagged
    And value opportunities are highlighted

  @adp @reach
  Scenario: Warn about reaching for players
    Given I am about to draft a player
    And the player's ADP is significantly later
    When I confirm the pick
    Then I see a warning about reaching
    And I can proceed or reconsider

  # ==========================================
  # DRAFT STRATEGY
  # ==========================================

  @strategy @suggestions
  Scenario: Receive strategy suggestions
    Given a mock draft is in progress
    When I am on the clock
    Then I receive strategy suggestions
    And suggestions consider my team needs and ADP

  @strategy @position-runs
  Scenario: Alert for position runs
    Given multiple teams are drafting a position
    When a position run is detected
    Then I receive an alert about the run
    And suggestions to address the position are made

  @strategy @zero-rb
  Scenario: Practice Zero RB strategy
    Given I want to practice Zero RB
    When I configure my draft strategy
    Then I can select Zero RB approach
    And suggestions align with that strategy

  @strategy @hero-rb
  Scenario: Practice Hero RB strategy
    Given I want to practice Hero RB
    When I select Hero RB strategy
    Then suggestions prioritize one elite RB
    And later RBs are deprioritized

  @strategy @robust-rb
  Scenario: Practice Robust RB strategy
    Given I want to practice Robust RB
    When I select Robust RB strategy
    Then suggestions prioritize multiple RBs early
    And RB depth is emphasized

  # ==========================================
  # POSITION GUIDANCE
  # ==========================================

  @position-guidance @happy-path
  Scenario: Receive position-based drafting guidance
    Given I am on the clock
    When I view position guidance
    Then I see recommended positions to target
    And guidance considers scarcity and team needs

  @position-guidance @scarcity
  Scenario: Highlight positional scarcity
    Given certain positions are being drafted quickly
    When I view available players
    Then scarcity warnings are displayed
    And I can plan accordingly

  @position-guidance @balance
  Scenario: Suggest roster balance
    Given my roster is imbalanced
    When I receive guidance
    Then suggestions address weak positions
    And optimal roster construction is recommended

  @position-guidance @streaming
  Scenario: Identify streaming positions
    Given certain positions can be streamed
    When I view position guidance
    Then streamable positions are noted
    And I can deprioritize them in the draft

  # ==========================================
  # SLEEPER AND BUST ALERTS
  # ==========================================

  @sleepers @happy-path
  Scenario: Receive sleeper alerts
    Given sleeper candidates are identified
    When a sleeper is available at value
    Then I receive a sleeper alert
    And the case for the sleeper is explained

  @sleepers @criteria
  Scenario: Customize sleeper criteria
    Given I have my own sleeper definition
    When I configure sleeper criteria
    Then I can set ADP differential thresholds
    And I can add manual sleeper picks

  @busts @happy-path
  Scenario: Receive bust warnings
    Given bust candidates are identified
    When I am about to draft a potential bust
    Then I receive a bust warning
    And the risk factors are explained

  @busts @injury
  Scenario: Flag injury-risk players
    Given a player has injury history
    When I view their information
    Then injury risk is flagged
    And past injuries are listed

  @busts @situation
  Scenario: Flag concerning situations
    Given a player's situation has changed
    When I view their information
    Then situational concerns are noted
    And impact on value is explained

  # ==========================================
  # BEST PLAYER AVAILABLE
  # ==========================================

  @bpa @happy-path
  Scenario: Display best player available
    Given a mock draft is in progress
    When I view BPA recommendations
    Then I see the highest-ranked available player
    And BPA is shown regardless of position

  @bpa @positional
  Scenario: Display best available by position
    Given I need a specific position
    When I view best available by position
    Then I see top available player at each position
    And I can quickly compare options

  @bpa @value
  Scenario: Calculate value above replacement
    Given VORP data is available
    When I view player values
    Then value above replacement is shown
    And I can compare positional value

  @bpa @customize
  Scenario: Customize BPA algorithm
    Given I have ranking preferences
    When I configure BPA settings
    Then BPA reflects my custom weights
    And my preferences influence recommendations

  # ==========================================
  # TEAM NEED ANALYSIS
  # ==========================================

  @team-needs @happy-path
  Scenario: Analyze team needs during draft
    Given my roster has been partially drafted
    When I view team needs analysis
    Then I see positions I still need to fill
    And urgency of each need is indicated

  @team-needs @starting-lineup
  Scenario: Ensure starting lineup is fillable
    Given I must fill starting positions
    When the system analyzes my roster
    Then it prioritizes unfilled starting spots
    And warns if a position is dangerously thin

  @team-needs @depth
  Scenario: Analyze roster depth
    Given starters are filled
    When I view depth analysis
    Then I see backup needs by position
    And bye week conflicts are highlighted

  @team-needs @opponents
  Scenario: Analyze opponent team needs
    Given I want to understand the draft
    When I view opponent needs
    Then I see what positions other teams need
    And I can predict their likely picks

  # ==========================================
  # MOCK DRAFT HISTORY
  # ==========================================

  @history @happy-path
  Scenario: View mock draft history
    Given I have completed mock drafts
    When I access my mock draft history
    Then I see all past mock drafts
    And I can review each draft's details

  @history @analytics
  Scenario: Analyze drafting patterns
    Given multiple mock drafts exist
    When I view pattern analytics
    Then I see positions I typically draft early
    And common picks are identified

  @history @performance
  Scenario: Track mock draft performance
    Given mock drafts can be scored
    When I view performance history
    Then I see grades for past mocks
    And improvement trends are shown

  @history @compare
  Scenario: Compare mock drafts
    Given I have multiple mock drafts
    When I select drafts to compare
    Then I see side-by-side comparisons
    And differences are highlighted

  @history @delete
  Scenario: Delete old mock drafts
    Given I want to clean up history
    When I delete selected mock drafts
    Then they are removed from my history
    And deleted drafts cannot be recovered

  # ==========================================
  # DRAFT GRADES
  # ==========================================

  @draft-grade @happy-path
  Scenario: Receive draft grade after completion
    Given a mock draft has completed
    When I view my draft grade
    Then I receive an overall letter grade
    And grades are provided for each pick

  @draft-grade @breakdown
  Scenario: View grade breakdown by category
    Given I have received a draft grade
    When I view the breakdown
    Then I see grades for value, need, and upside
    And each category is explained

  @draft-grade @comparison
  Scenario: Compare my grade to other teams
    Given all teams have been graded
    When I view the grade comparison
    Then I see how my grade compares
    And I see the best and worst drafts

  @draft-grade @suggestions
  Scenario: Receive improvement suggestions
    Given I have completed a mock draft
    When I view suggestions
    Then I receive tips for improvement
    And specific picks are critiqued

  @draft-grade @methodology
  Scenario: Understand grading methodology
    Given I want to understand my grade
    When I view grading methodology
    Then the criteria are explained
    And I understand what makes a good grade

  # ==========================================
  # EXPORT RESULTS
  # ==========================================

  @export @happy-path
  Scenario: Export mock draft results
    Given a mock draft has completed
    When I export the results
    Then I receive a downloadable file
    And all picks and rosters are included

  @export @format
  Scenario: Choose export format
    Given I am exporting draft results
    When I select export format
    Then I can choose CSV, PDF, or JSON
    And the export is generated in that format

  @export @share
  Scenario: Share draft results
    Given I want to share my mock draft
    When I generate a shareable link
    Then others can view my draft results
    And the link has configurable permissions

  @export @analysis
  Scenario: Export with analysis included
    Given I want detailed export
    When I include analysis in export
    Then grades and suggestions are included
    And the export is comprehensive

  # ==========================================
  # LEAGUE-SPECIFIC SCORING
  # ==========================================

  @league-scoring @happy-path
  Scenario: Apply league scoring to mock draft
    Given I have a league with custom scoring
    When I start a mock draft
    Then I can apply my league's scoring settings
    And player values reflect that scoring

  @league-scoring @import
  Scenario: Import league settings from platform
    Given my league is on a supported platform
    When I import league settings
    Then scoring, roster, and rules are imported
    And the mock draft mirrors my real league

  @league-scoring @ppr
  Scenario: Toggle between scoring formats
    Given I want to practice different formats
    When I switch between PPR, half-PPR, and standard
    Then player values adjust accordingly
    And I can practice for any format

  @league-scoring @custom
  Scenario: Manually configure scoring
    Given my league has unique scoring
    When I manually set scoring rules
    Then all point values are customizable
    And projections recalculate

  # ==========================================
  # ROSTER SETTINGS
  # ==========================================

  @roster-settings @happy-path
  Scenario: Configure roster settings for mock
    Given I am setting up a mock draft
    When I configure roster settings
    Then I can set number of each position
    And bench spots are configurable

  @roster-settings @superflex
  Scenario: Enable Superflex roster
    Given I play in a Superflex league
    When I enable Superflex in settings
    Then QB values increase appropriately
    And the draft strategy adjusts

  @roster-settings @idp
  Scenario: Enable IDP roster positions
    Given I play in an IDP league
    When I enable IDP positions
    Then defensive players are draftable
    And IDP rankings are included

  @roster-settings @te-premium
  Scenario: Enable TE Premium scoring
    Given my league has TE premium
    When I enable TE premium settings
    Then tight end values increase
    And strategy suggestions adjust

  # ==========================================
  # KEEPER AND DYNASTY
  # ==========================================

  @keeper @happy-path
  Scenario: Configure keepers for mock draft
    Given I have keeper players
    When I configure my keepers
    Then those players are removed from the pool
    And I cannot draft them again

  @keeper @rounds
  Scenario: Set keeper round costs
    Given keepers have round costs
    When I configure round costs
    Then I skip picks in those rounds
    And my keeper is assigned to that round

  @dynasty @rookie-draft
  Scenario: Practice dynasty rookie draft
    Given I want to practice rookie drafts
    When I start a rookie-only mock
    Then only rookies are in the player pool
    And dynasty rookie values are used

  @dynasty @startup
  Scenario: Practice dynasty startup draft
    Given I want to practice a startup
    When I start a dynasty startup mock
    Then rookie picks are included as draftable assets
    And dynasty-specific rankings are used

  @dynasty @devy
  Scenario: Include devy players
    Given I play in a devy league
    When I enable devy players
    Then college players are draftable
    And devy rankings are available

  # ==========================================
  # AUCTION MOCK DRAFT
  # ==========================================

  @auction @happy-path
  Scenario: Participate in auction mock draft
    Given I want to practice auction drafts
    When I join an auction mock draft
    Then I receive a starting budget
    And I can bid on any player

  @auction @nominate
  Scenario: Nominate player for auction
    Given it is my turn to nominate
    When I nominate a player
    Then bidding opens on that player
    And all teams can bid

  @auction @bid
  Scenario: Place bid on player
    Given a player is up for auction
    When I place a bid
    Then my bid is recorded
    And I am notified if outbid

  @auction @budget
  Scenario: Track remaining budget
    Given an auction is in progress
    When I view my budget
    Then I see remaining dollars
    And I see maximum bid for remaining roster

  @auction @values
  Scenario: View auction values for players
    Given auction values are calculated
    When I view a player's value
    Then I see their projected auction price
    And I can assess value opportunities

  @auction @strategy
  Scenario: Receive auction strategy tips
    Given an auction is in progress
    When I request strategy help
    Then I receive budget management tips
    And nomination strategy is suggested

  # ==========================================
  # DRAFT FORMATS
  # ==========================================

  @format @snake
  Scenario: Participate in snake draft
    Given I am in a snake format mock
    When the draft order reverses each round
    Then I pick appropriately in each round
    And the snake pattern continues

  @format @linear
  Scenario: Participate in linear draft
    Given I am in a linear format mock
    When each round has the same order
    Then my pick position is consistent
    And I draft in the same slot each round

  @format @third-round-reversal
  Scenario: Participate in third round reversal draft
    Given I am in a third round reversal mock
    When the third round reverses the order
    Then the reversal balances early picks
    And subsequent rounds follow snake pattern

  @format @slow-draft
  Scenario: Participate in slow draft
    Given I want an extended draft timeline
    When I join a slow mock draft
    Then pick timers are extended to hours
    And the draft takes multiple days

  # ==========================================
  # TRADE PICK SIMULATION
  # ==========================================

  @trade-picks @happy-path
  Scenario: Trade draft picks during mock
    Given the mock allows pick trading
    When I propose a pick trade
    Then I can offer picks for other picks
    And trades can be accepted or declined

  @trade-picks @value
  Scenario: View draft pick trade values
    Given pick trade values are calculated
    When I consider a trade
    Then I see relative values of picks
    And fair trades are suggested

  @trade-picks @future
  Scenario: Trade future picks in dynasty mock
    Given I am in a dynasty mock
    When I trade future draft picks
    Then future picks can be exchanged
    And pick ownership is tracked

  @trade-picks @restrictions
  Scenario: Enforce pick trading restrictions
    Given pick trading rules exist
    When I attempt an invalid trade
    Then the trade is blocked
    And the restriction is explained

  # ==========================================
  # POST-DRAFT ANALYSIS
  # ==========================================

  @post-draft @roster-analysis
  Scenario: Analyze drafted roster
    Given my mock draft is complete
    When I view roster analysis
    Then I see strengths and weaknesses
    And positional grades are given

  @post-draft @projection
  Scenario: View season projection
    Given my roster is complete
    When I view season projection
    Then projected wins are shown
    And playoff probability is calculated

  @post-draft @comparison
  Scenario: Compare roster to league
    Given all teams have drafted
    When I compare rosters
    Then I see how my team ranks
    And position-by-position comparisons are available

  @post-draft @improvement
  Scenario: Identify improvement areas
    Given my roster has weaknesses
    When I view improvement suggestions
    Then trade targets are suggested
    And waiver wire targets are identified

  # ==========================================
  # MOBILE EXPERIENCE
  # ==========================================

  @mobile @happy-path
  Scenario: Draft on mobile device
    Given I am using a mobile device
    When I participate in a mock draft
    Then the interface is touch-optimized
    And all draft features are accessible

  @mobile @portrait
  Scenario: Draft in portrait mode
    Given I am drafting in portrait orientation
    When I view the draft board
    Then the layout adjusts appropriately
    And I can see essential information

  @mobile @landscape
  Scenario: Draft in landscape mode
    Given I prefer landscape view
    When I rotate my device
    Then the draft board expands
    And more information is visible

  @mobile @notifications
  Scenario: Receive pick notifications on mobile
    Given I have the mobile app
    When it is my turn to pick
    Then I receive a push notification
    And I can draft directly from the notification

  @mobile @offline
  Scenario: Handle offline during draft
    Given I lose internet connection during draft
    When connection is restored
    Then I rejoin the draft seamlessly
    And any auto-picks are shown

  # ==========================================
  # DRAFT CHAT
  # ==========================================

  @chat @happy-path
  Scenario: Participate in draft chat
    Given a mock draft is in progress
    When I send a chat message
    Then all participants see my message
    And messages appear in real-time

  @chat @reactions
  Scenario: React to picks in chat
    Given a pick has been made
    When I react to the pick
    Then my reaction is displayed
    And others can see reactions

  @chat @mentions
  Scenario: Mention other drafters
    Given I want to address someone
    When I mention another drafter
    Then they receive a notification
    And the mention is highlighted

  @chat @mute
  Scenario: Mute draft chat
    Given I want to focus on drafting
    When I mute the chat
    Then I don't see chat messages
    And I can unmute at any time

  @chat @moderation
  Scenario: Report inappropriate chat
    Given someone posts inappropriate content
    When I report the message
    Then the report is logged
    And the message may be removed

  # ==========================================
  # ERROR HANDLING
  # ==========================================

  @error-handling
  Scenario: Handle connection loss during draft
    Given I am actively drafting
    When my connection is lost
    Then auto-draft takes over if needed
    And I am notified upon reconnection

  @error-handling
  Scenario: Handle server issues during draft
    Given the draft server has issues
    When picks cannot be processed
    Then the draft pauses automatically
    And participants are notified

  @error-handling
  Scenario: Handle invalid pick attempt
    Given a player has already been drafted
    When I try to draft that player
    Then the pick is rejected
    And I am prompted to select another player

  @error-handling
  Scenario: Recover from crashed draft
    Given a draft crashed unexpectedly
    When the system recovers
    Then the draft state is restored
    And drafting can continue

  # ==========================================
  # ACCESSIBILITY
  # ==========================================

  @accessibility
  Scenario: Navigate draft with screen reader
    Given I am using a screen reader
    When I participate in the draft
    Then all elements are properly labeled
    And pick announcements are read aloud

  @accessibility
  Scenario: Draft with keyboard only
    Given I navigate with keyboard
    When I participate in the draft
    Then all actions are keyboard accessible
    And focus indicators are clear

  @accessibility
  Scenario: View draft with high contrast
    Given I have high contrast mode enabled
    When I view the draft board
    Then all elements have sufficient contrast
    And team colors are distinguishable

  @accessibility
  Scenario: Extend pick timer for accessibility needs
    Given I need more time for picks
    When I enable accessibility timer extension
    Then my pick timer is extended
    And I have adequate time to decide
