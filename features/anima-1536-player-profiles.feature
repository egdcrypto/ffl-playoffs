@player-profiles
Feature: Player Profiles
  As a fantasy football manager
  I want to access comprehensive player profiles
  So that I can learn about players and make informed roster decisions

  Background:
    Given I am a registered user
    And I am logged into the platform
    And I have access to player profiles functionality

  # --------------------------------------------------------------------------
  # Basic Player Info Scenarios
  # --------------------------------------------------------------------------
  @basic-info
  Scenario: View player name and team information
    Given I want to learn about a player
    When I access a player's profile
    Then I should see their full name
    And their current NFL team should display
    And their position should be clearly shown

  @basic-info
  Scenario: Access player jersey number
    Given I am viewing a player profile
    When I look at basic information
    Then I should see their jersey number
    And historical jersey numbers should be available
    And team-specific numbers should show

  @basic-info
  Scenario: View player physical attributes
    Given I want to evaluate physical traits
    When I view player measurements
    Then I should see height and weight
    And BMI or size category should calculate
    And position-relative size should indicate

  @basic-info
  Scenario: Access player age information
    Given age matters for fantasy value
    When I view age details
    Then I should see the player's current age
    And birthdate should display
    And age relative to position average should show

  @basic-info
  Scenario: View player experience level
    Given experience affects reliability
    When I view experience information
    Then I should see years in the league
    And rookie status should be clearly indicated
    And experience tier should categorize

  @basic-info
  Scenario: Access player status information
    Given status affects availability
    When I view player status
    Then I should see active or inactive status
    And injury designation should display
    And practice squad status should indicate

  @basic-info
  Scenario: View player handedness and traits
    Given physical traits provide context
    When I access trait information
    Then I should see relevant physical traits
    And throwing hand for QBs should display
    And special abilities should note

  @basic-info
  Scenario: Access player identification numbers
    Given unique IDs enable data integration
    When I view player IDs
    Then I should see platform-specific IDs
    And NFL official ID should be available
    And cross-platform linking should work

  # --------------------------------------------------------------------------
  # Player Photos Scenarios
  # --------------------------------------------------------------------------
  @player-photos
  Scenario: View player headshot photo
    Given photos help identify players
    When I access a player profile
    Then I should see their official headshot
    And the photo should be current season
    And team uniform should be visible

  @player-photos
  Scenario: Access action photos
    Given action shots show players in play
    When I view the photo gallery
    Then I should see game action photos
    And photos should be recent
    And I can enlarge photos

  @player-photos
  Scenario: View team uniform photos
    Given uniforms change by team
    When I view uniform photos
    Then I should see current team uniform
    And historical team photos should be available
    And uniform details should be clear

  @player-photos
  Scenario: Browse player photo gallery
    Given multiple photos may be available
    When I access the photo gallery
    Then I should see all available photos
    And I can navigate through the gallery
    And photo captions should display

  @player-photos
  Scenario: View photos from different seasons
    Given players change over time
    When I filter photos by season
    Then I should see season-specific photos
    And I can compare across seasons
    And team changes should be reflected

  @player-photos
  Scenario: Access high-resolution photos
    Given I may need larger images
    When I request high-res versions
    Then larger images should be available
    And download options should exist
    And image quality should be maintained

  @player-photos
  Scenario: View celebration and highlight photos
    Given memorable moments are valuable
    When I access highlight photos
    Then I should see celebration photos
    And touchdown photos should be available
    And career highlight photos should show

  @player-photos
  Scenario: Access photos with attribution
    Given photo credits matter
    When I view photo details
    Then photographer credit should display
    And usage rights should be indicated
    And source should be attributed

  # --------------------------------------------------------------------------
  # Contract Details Scenarios
  # --------------------------------------------------------------------------
  @contract-details
  Scenario: View player salary information
    Given salary impacts dynasty and keeper value
    When I access contract details
    Then I should see current salary
    And cap hit should display
    And dead cap should be available

  @contract-details
  Scenario: Access contract years remaining
    Given contract length affects value
    When I view contract duration
    Then I should see years remaining
    And contract end date should display
    And option years should be noted

  @contract-details
  Scenario: View free agency status
    Given free agency changes situations
    When I check free agency status
    Then I should see upcoming free agency year
    And free agent type should indicate
    And market value estimate should show

  @contract-details
  Scenario: Access franchise tag eligibility
    Given franchise tags affect moves
    When I view tag eligibility
    Then I should see tag status
    And tag salary should display if applicable
    And tag history should be available

  @contract-details
  Scenario: View contract guarantees
    Given guarantees affect job security
    When I access guarantee details
    Then I should see guaranteed money
    And guarantee structure should display
    And remaining guarantees should calculate

  @contract-details
  Scenario: Access contract history
    Given past contracts provide context
    When I view contract history
    Then I should see all career contracts
    And contract values should display
    And team by team breakdown should show

  @contract-details
  Scenario: View restructure and extension potential
    Given contracts can change
    When I analyze contract flexibility
    Then I should see restructure potential
    And cap savings should estimate
    And extension likelihood should assess

  @contract-details
  Scenario: Compare contract to position market
    Given market context matters
    When I compare to market
    Then I should see positional rankings
    And value assessment should provide
    And comparable contracts should list

  # --------------------------------------------------------------------------
  # Draft History Scenarios
  # --------------------------------------------------------------------------
  @draft-history
  Scenario: View NFL draft position
    Given draft capital indicates investment
    When I access draft history
    Then I should see draft round and pick
    And drafting team should display
    And draft class should be noted

  @draft-history
  Scenario: Access NFL Combine results
    Given combine shows athletic ability
    When I view combine results
    Then I should see all combine metrics
    And 40-yard dash should display
    And position-relative percentiles should show

  @draft-history
  Scenario: View college statistics
    Given college production indicates potential
    When I access college stats
    Then I should see college career stats
    And season by season breakdown should show
    And conference level should note

  @draft-history
  Scenario: Access pre-draft scouting reports
    Given scouting provides evaluation
    When I view scouting reports
    Then I should see pre-draft analysis
    And strengths and weaknesses should list
    And NFL comparison should be included

  @draft-history
  Scenario: View pro day results
    Given pro days provide additional data
    When I access pro day results
    Then I should see pro day metrics
    And comparison to combine should show
    And improvement should be noted

  @draft-history
  Scenario: Access college accolades
    Given college awards indicate success
    When I view college accolades
    Then I should see awards received
    And All-American status should display
    And conference honors should list

  @draft-history
  Scenario: View undrafted free agent details
    Given UDFAs have different paths
    When I access UDFA information
    Then I should see signing details
    And signing bonus should display
    And team history should show

  @draft-history
  Scenario: Compare draft profile to career
    Given draft projection vs reality matters
    When I compare draft to career
    Then I should see projected vs actual
    And draft value assessment should provide
    And similar draft picks should compare

  # --------------------------------------------------------------------------
  # Player Bio Scenarios
  # --------------------------------------------------------------------------
  @player-bio
  Scenario: View college attended information
    Given college background matters
    When I access education info
    Then I should see college attended
    And years attended should display
    And degree earned should note if applicable

  @player-bio
  Scenario: Access hometown information
    Given hometown provides background
    When I view hometown details
    Then I should see city and state
    And high school should display
    And local team connections should note

  @player-bio
  Scenario: View detailed birthdate information
    Given exact birthdate matters for analysis
    When I access birthdate details
    Then I should see full birthdate
    And zodiac sign can display optionally
    And age calculation should be accurate

  @player-bio
  Scenario: Access career highlights summary
    Given highlights showcase achievements
    When I view career highlights
    Then I should see major accomplishments
    And records should be listed
    And milestone games should highlight

  @player-bio
  Scenario: View awards and honors
    Given awards indicate excellence
    When I access awards section
    Then I should see Pro Bowl selections
    And All-Pro honors should display
    And MVP votes should show if applicable

  @player-bio
  Scenario: Access personal background
    Given personal details add context
    When I view personal background
    Then I should see family information if public
    And charitable work should highlight
    And personal interests should note

  @player-bio
  Scenario: View career timeline
    Given timelines show progression
    When I access career timeline
    Then I should see chronological career events
    And major milestones should mark
    And team changes should highlight

  @player-bio
  Scenario: Access player quotes and interviews
    Given player words provide insight
    When I view quotes section
    Then I should see notable quotes
    And interview excerpts should display
    And source attribution should include

  # --------------------------------------------------------------------------
  # Ownership Data Scenarios
  # --------------------------------------------------------------------------
  @ownership-data
  Scenario: View roster percentage across platforms
    Given ownership indicates popularity
    When I access ownership data
    Then I should see roster percentage
    And platform breakdown should display
    And trending direction should indicate

  @ownership-data
  Scenario: Access start percentage data
    Given start rate shows confidence
    When I view start percentage
    Then I should see start rate
    And position-relative start rate should show
    And weekly trends should display

  @ownership-data
  Scenario: View add/drop trends
    Given transactions show sentiment
    When I access add/drop data
    Then I should see recent transaction activity
    And net adds should calculate
    And trend visualization should show

  @ownership-data
  Scenario: Access trade activity data
    Given trade volume indicates value
    When I view trade activity
    Then I should see trade frequency
    And common trade partners should list
    And trade value trends should show

  @ownership-data
  Scenario: View ownership by league type
    Given different formats value differently
    When I filter by league type
    Then I should see format-specific ownership
    And redraft vs dynasty should compare
    And PPR vs standard should differ

  @ownership-data
  Scenario: Access ownership history
    Given historical ownership shows trajectory
    When I view ownership history
    Then I should see ownership over time
    And peak ownership should identify
    And correlation to performance should analyze

  @ownership-data
  Scenario: View ownership compared to projections
    Given ownership should match value
    When I compare ownership to rank
    Then I should see over/underowned status
    And value discrepancies should highlight
    And buying opportunities should identify

  @ownership-data
  Scenario: Access expert roster rates
    Given expert ownership matters
    When I view expert ownership
    Then I should see expert roster rates
    And comparison to public should show
    And expert consensus should indicate

  # --------------------------------------------------------------------------
  # Player Comparisons Scenarios
  # --------------------------------------------------------------------------
  @player-comparisons
  Scenario: View similar players analysis
    Given player comps aid evaluation
    When I access similar players
    Then I should see statistically similar players
    And similarity score should display
    And key comparable traits should highlight

  @player-comparisons
  Scenario: Access historical player comparisons
    Given historical comps provide context
    When I view historical comparisons
    Then I should see similar historical players
    And career trajectory comparison should show
    And outcome analysis should provide

  @player-comparisons
  Scenario: View peer rankings
    Given peer context matters
    When I access peer rankings
    Then I should see ranking among peers
    And draft class comparison should show
    And age-matched comparison should display

  @player-comparisons
  Scenario: Compare to position archetypes
    Given archetypes define roles
    When I view archetype comparison
    Then I should see player archetype
    And archetype characteristics should list
    And fit percentage should calculate

  @player-comparisons
  Scenario: Access physical comparison tools
    Given physical traits can compare
    When I compare physical attributes
    Then I should see measurements side by side
    And athletic testing should compare
    And percentile differences should show

  @player-comparisons
  Scenario: View production comparison
    Given production is most important
    When I compare production
    Then I should see stat comparisons
    And efficiency comparisons should include
    And fantasy point comparisons should show

  @player-comparisons
  Scenario: Compare career trajectories
    Given trajectories predict futures
    When I compare career paths
    Then I should see career arcs overlaid
    And peak timing should compare
    And longevity should analyze

  @player-comparisons
  Scenario: Generate comparison reports
    Given detailed comparisons are valuable
    When I generate a comparison report
    Then I should receive comprehensive analysis
    And all comparison dimensions should include
    And I can export the report

  # --------------------------------------------------------------------------
  # Schedule Info Scenarios
  # --------------------------------------------------------------------------
  @schedule-info
  Scenario: View upcoming opponents
    Given matchups matter for decisions
    When I access schedule information
    Then I should see upcoming opponents
    And opponent strength should indicate
    And matchup ratings should display

  @schedule-info
  Scenario: Access bye week information
    Given bye weeks affect availability
    When I view bye week details
    Then I should see bye week clearly
    And bye week should highlight in schedule
    And replacement planning should be noted

  @schedule-info
  Scenario: View strength of schedule analysis
    Given schedule difficulty varies
    When I access strength of schedule
    Then I should see overall SOS rating
    And remaining SOS should calculate
    And position-specific SOS should show

  @schedule-info
  Scenario: Access playoff schedule preview
    Given fantasy playoffs matter most
    When I view playoff schedule
    Then I should see playoff week opponents
    And matchup quality should rate
    And playoff value should assess

  @schedule-info
  Scenario: View weekly matchup details
    Given each matchup has details
    When I access matchup details
    Then I should see opponent defense stats
    And historical performance vs team should show
    And game time and location should display

  @schedule-info
  Scenario: Access division and conference schedule
    Given division games are different
    When I view schedule breakdown
    Then I should see division games marked
    And conference breakdown should show
    And rivalry games should highlight

  @schedule-info
  Scenario: View prime time game schedule
    Given prime time affects visibility
    When I access prime time schedule
    Then I should see all prime time games
    And game broadcast should display
    And national TV indicator should show

  @schedule-info
  Scenario: Compare schedule to other players
    Given relative schedule matters
    When I compare schedules
    Then I should see schedules side by side
    And easier weeks should highlight
    And schedule advantage should calculate

  # --------------------------------------------------------------------------
  # Player Notes Scenarios
  # --------------------------------------------------------------------------
  @player-notes
  Scenario: Add personal notes to player profile
    Given I want to track my observations
    When I add a personal note
    Then my note should save to the player
    And I can view my notes later
    And notes should be private by default

  @player-notes
  Scenario: View analyst notes and insights
    Given analyst notes provide expert context
    When I access analyst notes
    Then I should see expert observations
    And note attribution should display
    And note date should show

  @player-notes
  Scenario: Access injury history notes
    Given injury history matters
    When I view injury notes
    Then I should see past injuries documented
    And recovery notes should include
    And injury patterns should identify

  @player-notes
  Scenario: Manage watchlist notes
    Given watchlist context is valuable
    When I add watchlist notes
    Then notes should attach to watchlist
    And I can see why I'm watching
    And reminder notes should be possible

  @player-notes
  Scenario: Edit and update notes
    Given notes need maintenance
    When I edit existing notes
    Then the note should update
    And edit history should be available
    And original note should be recoverable

  @player-notes
  Scenario: Organize notes with tags
    Given organization helps retrieval
    When I tag my notes
    Then I can filter by tags
    And tag suggestions should be available
    And I can search by tag

  @player-notes
  Scenario: Share notes with league mates
    Given sharing insights helps leagues
    When I share a note
    Then league mates can view it
    And sharing permissions should control
    And attribution should maintain

  @player-notes
  Scenario: Export notes for external use
    Given notes may be needed externally
    When I export my notes
    Then I should receive exportable format
    And all notes should include
    And format should be readable

  # --------------------------------------------------------------------------
  # Social Links Scenarios
  # --------------------------------------------------------------------------
  @social-links
  Scenario: Access official social media profiles
    Given social media provides updates
    When I view social links
    Then I should see official accounts
    And platform icons should display
    And links should open in new tabs

  @social-links
  Scenario: View player website if available
    Given some players have websites
    When a player has a website
    Then the link should display
    And website type should indicate
    And link should be verified

  @social-links
  Scenario: Access verified account indicators
    Given verification matters for authenticity
    When I view social accounts
    Then verified status should display
    And verification badges should show
    And unverified accounts should be noted

  @social-links
  Scenario: View recent media appearances
    Given media appearances provide content
    When I access media section
    Then I should see recent appearances
    And interview links should provide
    And podcast appearances should list

  @social-links
  Scenario: Access charity and foundation links
    Given players support causes
    When I view charitable links
    Then I should see foundation links
    And cause descriptions should provide
    And donation options should be available

  @social-links
  Scenario: View endorsement and sponsor links
    Given endorsements show marketability
    When I access endorsement info
    Then I should see brand partnerships
    And sponsor links should provide
    And endorsement history should show

  @social-links
  Scenario: Access agent and representation info
    Given agents handle business
    When I view representation info
    Then agent information should display
    And agency should be noted
    And contact method should provide if public

  @social-links
  Scenario: View fantasy-relevant social activity
    Given social posts can impact value
    When I view fantasy-relevant posts
    Then I should see relevant social activity
    And posts affecting value should highlight
    And sentiment should analyze

  # --------------------------------------------------------------------------
  # Error Handling Scenarios
  # --------------------------------------------------------------------------
  @error-handling
  Scenario: Handle player profile unavailable
    Given profile service may have issues
    When profile is unavailable
    Then I should see an appropriate error
    And cached profile should display if available
    And I should know when to retry

  @error-handling
  Scenario: Handle missing player photos
    Given some players may lack photos
    When photos are unavailable
    Then a placeholder should display
    And the profile should still be usable
    And photo availability should note

  @error-handling
  Scenario: Handle contract data unavailable
    Given contract data may be incomplete
    When contract data is missing
    Then I should see an indication
    And available data should still show
    And data source should be noted

  @error-handling
  Scenario: Handle social link failures
    Given social links may break
    When a social link fails
    Then I should see a helpful message
    And other links should still work
    And broken link should be reported

  @error-handling
  Scenario: Handle note save failures
    Given notes may fail to save
    When a note save fails
    Then I should see an error message
    And the note should not be lost
    And retry should be available

  @error-handling
  Scenario: Handle ownership data timeout
    Given ownership data may take time
    When ownership data times out
    Then I should see timeout message
    And cached data should serve
    And retry should be available

  @error-handling
  Scenario: Handle schedule data discrepancies
    Given schedule changes occur
    When schedule data conflicts
    Then most recent data should show
    And discrepancy should be noted
    And source should be indicated

  @error-handling
  Scenario: Handle player search failures
    Given search may fail
    When player search fails
    Then I should see a helpful message
    And alternative suggestions should provide
    And the UI should not break

  @error-handling
  Scenario: Handle photo loading failures
    Given photos may fail to load
    When a photo fails to load
    Then a placeholder should display
    And retry should be automatic
    And loading state should indicate

  @error-handling
  Scenario: Handle unauthorized profile access
    Given some content may be restricted
    When I access restricted content
    Then I should see access restriction
    And available content should still show
    And upgrade options should present

  @error-handling
  Scenario: Handle corrupted profile cache
    Given cache may become corrupted
    When corruption is detected
    Then cache should be invalidated
    And fresh data should fetch
    And user should be minimally impacted

  @error-handling
  Scenario: Handle concurrent profile updates
    Given profiles may update frequently
    When updates conflict
    Then conflicts should resolve gracefully
    And most recent data should prevail
    And user should be notified

  @error-handling
  Scenario: Handle external data source failures
    Given external sources may fail
    When an external source fails
    Then I should be informed
    And internal data should still show
    And source status should indicate

  # --------------------------------------------------------------------------
  # Accessibility Scenarios
  # --------------------------------------------------------------------------
  @accessibility
  Scenario: Navigate profiles with keyboard only
    Given I rely on keyboard navigation
    When I use profiles without a mouse
    Then I should be able to access all features
    And focus indicators should be clear
    And shortcuts should be available

  @accessibility
  Scenario: Use profiles with screen reader
    Given I use a screen reader
    When I access player profiles
    Then all content should be properly announced
    And images should have alt text
    And structure should be semantic

  @accessibility
  Scenario: View profiles in high contrast mode
    Given I need high contrast visuals
    When I enable high contrast mode
    Then all profile elements should be visible
    And photos should remain clear
    And no information should be lost

  @accessibility
  Scenario: Access profiles on mobile devices
    Given I access profiles on a phone
    When I view profiles on mobile
    Then the interface should be responsive
    And touch targets should be adequate
    And all features should be accessible

  @accessibility
  Scenario: Customize profile display font size
    Given I need larger text
    When I increase font size
    Then all profile text should scale
    And layout should remain usable
    And no content should be cut off

  @accessibility
  Scenario: Use profiles with reduced motion
    Given I am sensitive to motion
    When I have reduced motion enabled
    Then animations should be minimized
    And transitions should be simple
    And functionality should be preserved

  @accessibility
  Scenario: Access player photos accessibly
    Given photos convey information
    When I access photos
    Then alt text should describe content
    And gallery should be navigable
    And captions should be accessible

  @accessibility
  Scenario: Print profiles with accessible formatting
    Given I need to print profiles
    When I print a player profile
    Then print layout should be optimized
    And all content should be readable
    And important info should highlight

  # --------------------------------------------------------------------------
  # Performance Scenarios
  # --------------------------------------------------------------------------
  @performance
  Scenario: Load player profile quickly
    Given I open a player profile
    When profile data loads
    Then initial load should complete within 2 seconds
    And critical content should load first
    And perceived performance should be optimized

  @performance
  Scenario: Load player photos efficiently
    Given photos can be large
    When photos load
    Then images should lazy load
    And thumbnails should load first
    And full resolution should load on demand

  @performance
  Scenario: Navigate between profile sections quickly
    Given profiles have multiple sections
    When I switch sections
    Then section should load within 200ms
    And transitions should be smooth
    And content should not reload unnecessarily

  @performance
  Scenario: Search player profiles quickly
    Given I search for players
    When I enter a search query
    Then results should appear within 500ms
    And suggestions should be instant
    And search should be indexed

  @performance
  Scenario: Cache profile data for quick access
    Given I may revisit profiles
    When I access cached profiles
    Then cached data should load instantly
    And cache freshness should maintain
    And updates should sync when available

  @performance
  Scenario: Handle multiple profile comparisons
    Given I may compare many players
    When I load multiple profiles
    Then all profiles should load in parallel
    And memory should be managed
    And performance should scale

  @performance
  Scenario: Load ownership data efficiently
    Given ownership data comes from external sources
    When ownership data loads
    Then it should load asynchronously
    And it should not block profile render
    And updates should be background

  @performance
  Scenario: Export profile data efficiently
    Given I may export profile information
    When I export profile data
    Then export should complete promptly
    And progress should indicate
    And browser should remain responsive
