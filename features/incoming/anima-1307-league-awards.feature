@league-awards @awards @recognition
Feature: League Awards
  As a fantasy football league member
  I want to participate in a comprehensive awards system
  So that individual and team achievements are recognized and celebrated throughout the season

  Background:
    Given a fantasy football league exists
    And the league has active members
    And the awards system is enabled

  # ==========================================
  # WEEKLY AWARDS
  # ==========================================

  @weekly-awards @highest-scorer @happy-path
  Scenario: Award weekly highest scorer
    Given the current week has completed
    And all team scores have been finalized
    When the system calculates weekly awards
    Then the team with the highest score receives the "Weekly High Scorer" award
    And the award includes the exact point total
    And all league members are notified of the winner

  @weekly-awards @highest-scorer
  Scenario: Handle tied weekly high scores
    Given the current week has completed
    And two teams have identical highest scores
    When the system calculates weekly awards
    Then both teams receive the "Weekly High Scorer" award
    And the tie is noted in the award description

  @weekly-awards @blowout @happy-path
  Scenario: Award largest margin of victory
    Given the current week has completed
    And all matchup results are available
    When the system calculates weekly awards
    Then the team with the largest winning margin receives the "Blowout" award
    And the award shows the point differential

  @weekly-awards @blowout
  Scenario: Calculate blowout with minimum threshold
    Given the league has configured a minimum margin for blowout awards as 30 points
    And a team wins by 25 points
    When the system calculates weekly awards
    Then no "Blowout" award is given for that matchup

  @weekly-awards @narrow-victory @happy-path
  Scenario: Award narrowest victory
    Given the current week has completed
    And a team wins by less than 1 point
    When the system calculates weekly awards
    Then the winning team receives the "Photo Finish" award
    And the award highlights the narrow margin

  @weekly-awards @narrow-victory
  Scenario: Award closest game of the week
    Given the current week has completed
    And the closest matchup was decided by 0.5 points
    When the system calculates weekly awards
    Then both teams in the matchup are recognized
    And the loser receives a "Heartbreaker" mention

  @weekly-awards @low-scorer
  Scenario: Award weekly lowest scorer
    Given the current week has completed
    And the league has enabled dubious awards
    When the system calculates weekly awards
    Then the team with the lowest score receives the "Participation Trophy" award

  @weekly-awards @overachiever
  Scenario: Award team that most exceeded projections
    Given the current week has completed
    And projection data is available for all teams
    When the system calculates weekly awards
    Then the team that most exceeded projections receives the "Overachiever" award
    And the award shows projected vs actual points

  @weekly-awards @underachiever
  Scenario: Award team that most underperformed projections
    Given the current week has completed
    And the league has enabled dubious awards
    When the system calculates weekly awards
    Then the team that most underperformed receives the "Underachiever" award

  @weekly-awards @comeback
  Scenario: Award biggest comeback victory
    Given the current week has completed
    And a team was trailing by 20+ points at halftime
    And that team won the matchup
    When the system calculates weekly awards
    Then that team receives the "Comeback Kid" award

  @weekly-awards @bench-points
  Scenario: Award most points left on bench
    Given the current week has completed
    And bench scoring data is available
    When the system calculates weekly awards
    Then the team with most bench points receives the "Benchwarmer Blues" award
    And the award shows how many additional points were available

  # ==========================================
  # SEASON-END AWARDS
  # ==========================================

  @season-awards @mvp @happy-path
  Scenario: Award season MVP
    Given the regular season has ended
    And all team statistics are calculated
    When the system determines season awards
    Then the top performing team receives the "League MVP" award
    And the award is based on total points scored

  @season-awards @mvp @voting
  Scenario: Award MVP through member voting
    Given the regular season has ended
    And the league uses voting for MVP selection
    When all members have submitted their votes
    Then the team with the most votes receives the "League MVP" award
    And vote totals are displayed

  @season-awards @most-improved @happy-path
  Scenario: Award most improved team
    Given the regular season has ended
    And prior season data is available
    When the system compares season-over-season performance
    Then the team with greatest improvement receives the "Most Improved" award
    And the award shows the improvement statistics

  @season-awards @most-improved
  Scenario: Calculate most improved for first-year teams
    Given a team is in their first season
    When the system calculates improvement awards
    Then first-year teams are evaluated based on first half vs second half performance

  @season-awards @rookie @happy-path
  Scenario: Award rookie of the year
    Given the regular season has ended
    And there are first-year managers in the league
    When the system determines season awards
    Then the best performing first-year manager receives "Rookie of the Year"

  @season-awards @consistency
  Scenario: Award most consistent team
    Given the regular season has ended
    And weekly scoring data is available
    When the system calculates scoring variance
    Then the team with lowest variance receives the "Mr. Consistent" award

  @season-awards @streaky
  Scenario: Award streakiest team
    Given the regular season has ended
    When the system analyzes win/loss patterns
    Then the team with the longest win or loss streak receives the "Streaky" award

  @season-awards @transactions
  Scenario: Award most active manager
    Given the regular season has ended
    And transaction history is available
    When the system counts all transactions
    Then the manager with most transactions receives the "Waiver Wire Warrior" award

  @season-awards @lucky
  Scenario: Award luckiest team
    Given the regular season has ended
    And all possible outcomes data is available
    When the system calculates expected vs actual wins
    Then the team that most outperformed expectations receives the "Lucky" award

  @season-awards @unlucky
  Scenario: Award unluckiest team
    Given the regular season has ended
    And all possible outcomes data is available
    When the system calculates expected vs actual wins
    Then the team that most underperformed expectations receives the "Unlucky" award

  # ==========================================
  # DUBIOUS AWARDS
  # ==========================================

  @dubious-awards @happy-path
  Scenario: Enable dubious awards for the league
    Given I am the commissioner
    When I enable dubious awards in league settings
    Then negative achievement awards become active
    And members can opt out of receiving them

  @dubious-awards @sacko
  Scenario: Award last place finish
    Given the regular season has ended
    And the league has dubious awards enabled
    When final standings are determined
    Then the last place team receives the "Sacko" award
    And appropriate shame notifications are sent

  @dubious-awards @worst-trade
  Scenario: Award worst trade of the season
    Given the regular season has ended
    And trade outcome data is available
    When the system analyzes all trades
    Then the most lopsided losing trade receives the "Trade Fail" award

  @dubious-awards @boom-bust
  Scenario: Award most inconsistent team
    Given the regular season has ended
    When the system calculates scoring variance
    Then the team with highest variance receives the "Boom or Bust" award

  @dubious-awards @cursed
  Scenario: Award team that faced highest opponent scores
    Given the regular season has ended
    And opponent scoring data is available
    When the system calculates points against
    Then the team with highest points against receives the "Cursed" award

  @dubious-awards @opt-out
  Scenario: Member opts out of dubious awards
    Given I am a league member
    And dubious awards are enabled
    When I choose to opt out of dubious awards
    Then I will not receive any negative achievement awards
    And my name will be anonymized in dubious award announcements

  # ==========================================
  # CUSTOM AWARDS
  # ==========================================

  @custom-awards @happy-path
  Scenario: Commissioner creates custom award
    Given I am the commissioner
    When I create a custom award named "Best Team Name"
    And I set the award criteria as "Most creative team name"
    And I set the award icon and colors
    Then the custom award is added to the league awards
    And it appears in the awards dashboard

  @custom-awards @criteria
  Scenario: Create custom award with automatic criteria
    Given I am the commissioner
    When I create a custom award for "Most QB Points"
    And I select automatic calculation based on position scoring
    Then the system automatically determines the winner each week
    And no manual selection is required

  @custom-awards @manual
  Scenario: Commissioner manually assigns custom award
    Given a custom award exists that requires manual selection
    And I am the commissioner
    When I select a member to receive the award
    And I add a personalized message
    Then the award is assigned to that member
    And the notification includes the commissioner's message

  @custom-awards @edit
  Scenario: Edit existing custom award
    Given I am the commissioner
    And a custom award exists
    When I modify the award name, criteria, or icon
    Then the changes are saved
    And past recipients retain the original award version

  @custom-awards @delete
  Scenario: Delete custom award
    Given I am the commissioner
    And a custom award exists with recipients
    When I delete the custom award
    Then I receive a warning about existing recipients
    And upon confirmation the award is removed
    But historical records are preserved

  @custom-awards @limit
  Scenario: Enforce maximum custom awards limit
    Given the league has reached the maximum of 20 custom awards
    When the commissioner tries to create another award
    Then the system displays an error message
    And suggests removing an existing award

  # ==========================================
  # MEMBER VOTING
  # ==========================================

  @voting @happy-path
  Scenario: Open voting for an award
    Given I am the commissioner
    And a votable award is configured
    When I open voting for the award
    Then all eligible members can submit votes
    And the voting deadline is displayed

  @voting @submit
  Scenario: Member submits vote for award
    Given voting is open for an award
    And I am an eligible voter
    When I select my choice from the candidates
    And I submit my vote
    Then my vote is recorded
    And I cannot vote again for this award

  @voting @anonymous
  Scenario: Configure anonymous voting
    Given I am the commissioner
    When I enable anonymous voting for an award
    Then member votes are hidden from other members
    And only the commissioner can see individual votes

  @voting @public
  Scenario: Configure public voting
    Given I am the commissioner
    When I enable public voting for an award
    Then all members can see who voted for whom
    And vote counts are visible in real-time

  @voting @deadline
  Scenario: Enforce voting deadline
    Given voting is open with a deadline
    When the deadline passes
    Then no more votes can be submitted
    And the winner is automatically announced

  @voting @tie
  Scenario: Handle voting tie
    Given voting has ended
    And two candidates have equal votes
    When the system determines the winner
    Then the commissioner is prompted to break the tie
    Or the award is given to both candidates

  @voting @recuse
  Scenario: Voter recuses from self-voting
    Given voting is open for an award
    And I am a candidate
    When the system displays voting options
    Then I cannot vote for myself
    Unless self-voting is explicitly enabled

  @voting @reminder
  Scenario: Send voting reminders
    Given voting is open
    And some members have not voted
    When the deadline is approaching
    Then reminder notifications are sent to non-voters

  # ==========================================
  # AWARD CEREMONY
  # ==========================================

  @ceremony @happy-path
  Scenario: Schedule end of season award ceremony
    Given the season has ended
    And I am the commissioner
    When I schedule the award ceremony
    Then all members receive calendar invitations
    And a countdown appears on the league homepage

  @ceremony @virtual
  Scenario: Host virtual award ceremony
    Given the award ceremony is scheduled
    When the ceremony time arrives
    Then a virtual ceremony page becomes available
    And awards are revealed one by one with animations

  @ceremony @reveal
  Scenario: Reveal awards with dramatic effect
    Given the virtual ceremony is active
    When an award is being revealed
    Then the nominees are shown first
    And the winner is revealed with fanfare
    And confetti animations play

  @ceremony @acceptance
  Scenario: Winner gives acceptance speech
    Given an award has been revealed
    And I am the winner
    When I am prompted for an acceptance speech
    Then I can type or record a brief message
    And the speech is displayed to all attendees

  @ceremony @replay
  Scenario: View ceremony replay
    Given the award ceremony has concluded
    When I access the ceremony archive
    Then I can replay the entire ceremony
    And skip to specific award reveals

  @ceremony @live-chat
  Scenario: Participate in ceremony chat
    Given the virtual ceremony is active
    When I send a message in the ceremony chat
    Then all attendees can see my message
    And reactions and emojis are supported

  # ==========================================
  # HISTORICAL ARCHIVE
  # ==========================================

  @archive @happy-path
  Scenario: View historical award winners
    Given awards have been given in previous seasons
    When I access the awards archive
    Then I see all past award winners organized by season
    And I can filter by award type

  @archive @member-history
  Scenario: View member's award history
    Given a member has won awards in the past
    When I view that member's profile
    Then all their awards are displayed
    And the awards are organized chronologically

  @archive @statistics
  Scenario: View award statistics
    Given multiple seasons of awards exist
    When I access award statistics
    Then I see who has won the most awards
    And I see which awards have been most competitive
    And I see award trends over time

  @archive @search
  Scenario: Search award history
    Given extensive award history exists
    When I search for "MVP" awards
    Then all MVP winners across all seasons are displayed
    And the search results include relevant details

  @archive @export
  Scenario: Export award history
    Given I want to preserve award records
    When I export award history
    Then I receive a downloadable file
    And the export includes all award details and dates

  # ==========================================
  # BADGES AND TROPHIES
  # ==========================================

  @badges @happy-path
  Scenario: Award badge for achievement
    Given a member has earned an award
    When the award is finalized
    Then a corresponding badge is added to their profile
    And the badge is visible to all league members

  @badges @display
  Scenario: Display badges on member profile
    Given a member has earned multiple badges
    When anyone views their profile
    Then all badges are prominently displayed
    And hovering over a badge shows details

  @badges @rarity
  Scenario: Show badge rarity levels
    Given different badges have different rarity
    When I view badge information
    Then common, rare, and legendary badges are distinguished
    And the rarity reflects difficulty of achievement

  @trophies @3d
  Scenario: Display 3D trophy for championship
    Given a member has won the championship
    When I view their trophy case
    Then a 3D rendered trophy is displayed
    And I can rotate and zoom the trophy

  @trophies @case
  Scenario: View virtual trophy case
    Given a member has won multiple championships
    When I access their trophy case
    Then all championship trophies are displayed
    And each trophy shows the season and league name

  @trophies @physical
  Scenario: Order physical trophy
    Given the league has a championship winner
    When the commissioner orders a physical trophy
    Then the order is placed with the trophy vendor
    And tracking information is provided

  @badges @unlock
  Scenario: Unlock hidden badge
    Given hidden achievement badges exist
    When a member completes a hidden achievement
    Then the badge is unlocked with a surprise animation
    And the achievement criteria is revealed

  # ==========================================
  # NOTIFICATIONS
  # ==========================================

  @notifications @happy-path
  Scenario: Notify winner of award
    Given a member has won an award
    When the award is finalized
    Then the winner receives a notification
    And the notification includes award details

  @notifications @league-wide
  Scenario: Announce award to entire league
    Given an award has been given
    When the award is made public
    Then all league members receive an announcement
    And the announcement appears in the league feed

  @notifications @push
  Scenario: Send push notification for major awards
    Given a major award is being announced
    And members have push notifications enabled
    When the award is finalized
    Then push notifications are sent to all members
    And the notification includes a celebratory message

  @notifications @email
  Scenario: Send email digest of weekly awards
    Given weekly awards have been calculated
    And members have email notifications enabled
    When the weekly awards digest is sent
    Then members receive an email summary
    And the email includes all award winners

  @notifications @preferences
  Scenario: Configure award notification preferences
    Given I am a league member
    When I access notification settings
    Then I can choose which award types trigger notifications
    And I can set notification channels for each type

  @notifications @mute
  Scenario: Mute award notifications temporarily
    Given I am receiving too many award notifications
    When I mute award notifications for a period
    Then I don't receive notifications during that time
    But awards are still logged in my history

  # ==========================================
  # SOCIAL SHARING
  # ==========================================

  @sharing @happy-path
  Scenario: Share award on social media
    Given I have won an award
    When I click share
    Then I see options for major social platforms
    And a pre-formatted message with award details is created

  @sharing @image
  Scenario: Generate shareable award image
    Given I have won an award
    When I generate a shareable image
    Then an attractive graphic is created
    And it includes the award, my team name, and league name

  @sharing @twitter
  Scenario: Share award to Twitter/X
    Given I have won an award
    When I share to Twitter
    Then a tweet is composed with award details
    And appropriate hashtags are included

  @sharing @instagram
  Scenario: Share award to Instagram Stories
    Given I have won an award
    When I share to Instagram Stories
    Then a story-formatted graphic is created
    And I can add stickers and text

  @sharing @privacy
  Scenario: Control sharing visibility
    Given I want to share an award
    When I configure sharing options
    Then I can choose to hide league name
    And I can hide other member names

  @sharing @league-branding
  Scenario: Include league branding in shares
    Given the league has custom branding
    When I share an award
    Then the league logo is included
    And league colors are used in the design

  # ==========================================
  # LEADERBOARDS
  # ==========================================

  @leaderboards @happy-path
  Scenario: View award leaderboard
    Given awards have been distributed
    When I access the award leaderboard
    Then I see members ranked by total awards
    And I can filter by award type

  @leaderboards @all-time
  Scenario: View all-time award leaders
    Given multiple seasons of awards exist
    When I view the all-time leaderboard
    Then I see cumulative award totals
    And historical champions are highlighted

  @leaderboards @category
  Scenario: View category-specific leaderboard
    Given I want to see weekly award leaders
    When I filter the leaderboard by weekly awards
    Then only weekly award counts are shown
    And the ranking reflects weekly performance

  @leaderboards @competition
  Scenario: Track award race throughout season
    Given the season is in progress
    When I view the current award race
    Then I see who is leading for each award
    And projections for end of season are shown

  @leaderboards @rivalry
  Scenario: View head-to-head award comparison
    Given I want to compare with another member
    When I select a member for comparison
    Then our award totals are shown side by side
    And categories where each leads are highlighted

  # ==========================================
  # STREAK AWARDS
  # ==========================================

  @streak-awards @happy-path
  Scenario: Award winning streak achievement
    Given a team has won 5 consecutive matchups
    When the streak reaches the threshold
    Then the team receives a "Hot Streak" award
    And the streak count is tracked

  @streak-awards @losing
  Scenario: Track losing streak
    Given the league has dubious awards enabled
    And a team has lost 4 consecutive matchups
    When the streak reaches the threshold
    Then the team receives a "Cold Streak" award

  @streak-awards @scoring
  Scenario: Award consecutive high-scoring weeks
    Given a team has scored 100+ points for 6 weeks straight
    When the streak is achieved
    Then the team receives the "Scoring Machine" award
    And the exact streak length is recorded

  @streak-awards @all-time
  Scenario: Track all-time streak records
    Given streak data is tracked historically
    When a team breaks an all-time streak record
    Then special recognition is given
    And the record books are updated

  # ==========================================
  # TRANSACTION AWARDS
  # ==========================================

  @transaction-awards @happy-path
  Scenario: Award best waiver pickup
    Given the season has ended
    And player performance data is available
    When the system analyzes waiver transactions
    Then the best waiver pickup receives the "Diamond in the Rough" award
    And the player's stats and acquisition cost are shown

  @transaction-awards @trade-win
  Scenario: Award best trade of the season
    Given the season has ended
    And trade outcome data is available
    When the system analyzes all trades
    Then the most beneficial trade receives the "Trade Master" award

  @transaction-awards @faab-bargain
  Scenario: Award best FAAB bargain
    Given the league uses FAAB
    And the season has ended
    When the system analyzes FAAB spending efficiency
    Then the best value pickup receives the "Bargain Hunter" award

  @transaction-awards @activity
  Scenario: Award most active manager
    Given the season has ended
    When total transactions are counted
    Then the most active manager receives the "Always Working" award

  # ==========================================
  # PLAYOFF AWARDS
  # ==========================================

  @playoff-awards @happy-path
  Scenario: Award playoff MVP
    Given the playoffs have concluded
    When playoff performance is analyzed
    Then the best playoff performer receives "Playoff MVP"

  @playoff-awards @cinderella
  Scenario: Award Cinderella story
    Given a low seed has made a deep playoff run
    When the playoffs conclude
    Then that team receives the "Cinderella" award

  @playoff-awards @upset
  Scenario: Award biggest upset
    Given an upset occurred in the playoffs
    When the playoffs conclude
    Then the upsetting team receives the "Giant Killer" award

  @playoff-awards @championship
  Scenario: Award championship winner
    Given the championship game has concluded
    When the winner is determined
    Then the champion receives the "League Champion" award
    And the championship trophy is awarded

  @playoff-awards @runner-up
  Scenario: Recognize championship runner-up
    Given the championship game has concluded
    When awards are distributed
    Then the runner-up receives the "Silver Medal" award
    And their achievement is recognized

  @playoff-awards @consolation
  Scenario: Award consolation bracket winner
    Given the consolation bracket has concluded
    When the winner is determined
    Then they receive the "Consolation Champion" award

  # ==========================================
  # ALL-STAR TEAM
  # ==========================================

  @all-star @happy-path
  Scenario: Generate end of season all-star team
    Given the season has ended
    And player performance data is available
    When the system selects the all-star team
    Then the best player at each position is chosen
    And the all-star team is published

  @all-star @roster
  Scenario: Display all-star roster
    Given the all-star team has been selected
    When I view the all-star team
    Then I see players at each position
    And their season statistics are displayed
    And the managers who rostered them are credited

  @all-star @voting
  Scenario: Allow member voting for all-stars
    Given the league uses voting for all-star selection
    When voting is open
    Then members can vote for players at each position
    And vote tallies are tracked

  @all-star @honorable-mention
  Scenario: Include honorable mentions
    Given the all-star team has been selected
    When the selection is published
    Then honorable mention players are also recognized
    And they appear in a secondary list

  @all-star @historical
  Scenario: View historical all-star teams
    Given all-star teams have been selected in past seasons
    When I access all-star history
    Then I can view all-star teams from previous years
    And compare player selections across seasons

  # ==========================================
  # PREDICTIONS AND CONTESTS
  # ==========================================

  @predictions @happy-path
  Scenario: Create award prediction contest
    Given the season is beginning
    And I am the commissioner
    When I create a prediction contest
    Then members can predict award winners
    And predictions are locked before the season starts

  @predictions @submit
  Scenario: Submit award predictions
    Given a prediction contest is open
    When I submit my predictions for each award
    Then my predictions are saved
    And I can modify until the deadline

  @predictions @scoring
  Scenario: Score prediction accuracy
    Given predictions were submitted
    And awards have been finalized
    When the system scores predictions
    Then points are awarded for correct predictions
    And the prediction leaderboard is updated

  @predictions @winner
  Scenario: Award best predictor
    Given prediction scoring is complete
    When the best predictor is determined
    Then they receive the "Oracle" award
    And their prediction accuracy is highlighted

  @predictions @view
  Scenario: View member predictions after reveal
    Given awards have been revealed
    When I view member predictions
    Then all predictions are visible
    And correct predictions are highlighted

  # ==========================================
  # ACCEPTANCE SPEECHES
  # ==========================================

  @speeches @happy-path
  Scenario: Record acceptance speech
    Given I have won an award
    When I choose to record an acceptance speech
    Then I can type a message up to 500 characters
    And the speech is attached to my award

  @speeches @video
  Scenario: Upload video acceptance speech
    Given I have won a major award
    When I upload a video acceptance speech
    Then the video is processed and attached
    And other members can view it

  @speeches @display
  Scenario: Display acceptance speeches in ceremony
    Given an award has an acceptance speech
    When the award is revealed in the ceremony
    Then the speech is displayed after the reveal
    And members can react to it

  @speeches @archive
  Scenario: Access historical acceptance speeches
    Given acceptance speeches exist from past seasons
    When I browse the speech archive
    Then I can read or view past speeches
    And they are linked to their respective awards

  # ==========================================
  # CERTIFICATES
  # ==========================================

  @certificates @happy-path
  Scenario: Generate award certificate
    Given I have won an award
    When I request a certificate
    Then a professional certificate is generated
    And it includes the award name, date, and league

  @certificates @download
  Scenario: Download certificate as PDF
    Given a certificate has been generated
    When I download the certificate
    Then I receive a high-resolution PDF
    And the file is print-ready

  @certificates @customize
  Scenario: Customize certificate design
    Given I am the commissioner
    When I customize certificate templates
    Then I can add league logo and colors
    And I can modify the certificate text

  @certificates @print
  Scenario: Order printed certificates
    Given I want physical certificates
    When I place a print order
    Then certificates are printed and shipped
    And tracking information is provided

  # ==========================================
  # STATISTICS AND ANALYTICS
  # ==========================================

  @statistics @happy-path
  Scenario: View award statistics dashboard
    Given awards have been distributed
    When I access the statistics dashboard
    Then I see comprehensive award analytics
    And visualizations show trends and distributions

  @statistics @member
  Scenario: View individual member statistics
    Given a member has received awards
    When I view their statistics
    Then I see their award breakdown by type
    And comparison to league average is shown

  @statistics @trends
  Scenario: Analyze award trends over time
    Given multiple seasons of data exist
    When I view award trends
    Then I see how award distributions have changed
    And I can identify patterns

  @statistics @probability
  Scenario: View award probability projections
    Given the season is in progress
    When I view award projections
    Then I see probability of each member winning each award
    And projections update weekly

  # ==========================================
  # MOBILE EXPERIENCE
  # ==========================================

  @mobile @notifications
  Scenario: Receive mobile award notifications
    Given I have the mobile app installed
    When an award is announced
    Then I receive a rich push notification
    And I can view award details directly from the notification

  @mobile @display
  Scenario: View awards on mobile device
    Given I am using a mobile device
    When I access the awards section
    Then the interface is optimized for mobile
    And all award features are accessible

  @mobile @share
  Scenario: Share awards from mobile app
    Given I have won an award
    And I am on the mobile app
    When I share the award
    Then native sharing options are presented
    And the share includes a mobile-optimized graphic

  @mobile @widgets
  Scenario: Display awards in home screen widget
    Given I have the mobile app widget enabled
    When I view my home screen
    Then my recent awards are displayed
    And I can tap to see details

  # ==========================================
  # CHAMPIONSHIP TROPHY
  # ==========================================

  @championship @trophy
  Scenario: Award championship trophy
    Given the championship game has been won
    When the champion is crowned
    Then a virtual championship trophy is awarded
    And it appears prominently on their profile

  @championship @engraving
  Scenario: Engrave trophy with winner details
    Given a championship trophy exists
    When a new champion is crowned
    Then the winner's name and year are added to the trophy
    And historical winners are visible on the trophy

  @championship @traveling
  Scenario: Track traveling trophy possession
    Given the league has a traveling trophy
    When the championship is won
    Then trophy possession transfers to the new champion
    And possession history is tracked

  @championship @physical
  Scenario: Order physical championship trophy
    Given the champion wants a physical trophy
    When I access trophy ordering
    Then I see trophy options and pricing
    And I can customize engraving

  @championship @celebration
  Scenario: Display championship celebration animation
    Given a team has won the championship
    When the victory is finalized
    Then a celebration animation plays
    And confetti and fireworks are displayed

  # ==========================================
  # HALL OF FAME
  # ==========================================

  @hall-of-fame @happy-path
  Scenario: View league hall of fame
    Given the league has historical data
    When I access the hall of fame
    Then I see legendary achievements and members
    And all-time records are displayed

  @hall-of-fame @induction
  Scenario: Induct member into hall of fame
    Given I am the commissioner
    And a member meets hall of fame criteria
    When I induct them into the hall of fame
    Then they receive permanent recognition
    And a hall of fame badge is added to their profile

  @hall-of-fame @criteria
  Scenario: Define hall of fame criteria
    Given I am the commissioner
    When I configure hall of fame criteria
    Then I can set championship requirements
    And I can set award thresholds
    And I can enable voting for induction

  @hall-of-fame @voting
  Scenario: Vote for hall of fame induction
    Given hall of fame voting is enabled
    When a candidate is nominated
    Then members can vote on their induction
    And a percentage threshold must be met

  @hall-of-fame @display
  Scenario: Display hall of fame shrine
    Given members have been inducted
    When I view the hall of fame
    Then I see plaques for each inductee
    And their career achievements are summarized

  @hall-of-fame @records
  Scenario: Track hall of fame records
    Given the hall of fame exists
    When I view records
    Then I see all-time records for various categories
    And current leaders are compared to records

  # ==========================================
  # COMMISSIONER CONTROLS
  # ==========================================

  @commissioner @override
  Scenario: Commissioner overrides award winner
    Given I am the commissioner
    And an automatic award has been calculated
    When I override the winner selection
    Then the new winner is recorded
    And the override is logged for transparency

  @commissioner @manual
  Scenario: Commissioner manually awards recognition
    Given I am the commissioner
    When I manually award a recognition
    Then I can select any member
    And I can add a custom message
    And the award is distributed

  @commissioner @disable
  Scenario: Commissioner disables specific awards
    Given I am the commissioner
    When I disable an award type
    Then that award is not calculated or given
    And members are notified of the change

  @commissioner @schedule
  Scenario: Commissioner schedules award distribution
    Given I am the commissioner
    When I configure award distribution timing
    Then I can choose immediate or scheduled release
    And scheduled awards are held until the set time

  @commissioner @audit
  Scenario: View award distribution audit log
    Given I am the commissioner
    When I access the audit log
    Then I see all award distributions
    And any manual overrides are flagged
    And timestamps are recorded

  # ==========================================
  # ERROR HANDLING
  # ==========================================

  @error-handling
  Scenario: Handle missing data for award calculation
    Given award calculation requires complete data
    When data is missing for some teams
    Then the award calculation handles missing data gracefully
    And affected awards are marked as pending
    And an alert is sent to the commissioner

  @error-handling
  Scenario: Handle tie in automatic award selection
    Given an automatic award has multiple winners
    When the tie cannot be broken automatically
    Then the commissioner is notified
    And they can choose to award multiple winners or break the tie

  @error-handling
  Scenario: Handle network error during ceremony
    Given a virtual ceremony is in progress
    When a network error occurs
    Then the ceremony state is preserved
    And attendees can rejoin seamlessly
    And missed reveals can be replayed

  @error-handling
  Scenario: Handle deleted member with awards
    Given a member with awards leaves the league
    When their profile is removed
    Then their awards are preserved in history
    And they appear as "Former Member" in records

  # ==========================================
  # ACCESSIBILITY
  # ==========================================

  @accessibility
  Scenario: Navigate awards with screen reader
    Given I am using a screen reader
    When I browse the awards section
    Then all award content is properly labeled
    And navigation is intuitive with keyboard

  @accessibility
  Scenario: View awards with high contrast
    Given I have high contrast mode enabled
    When I view awards and badges
    Then all elements have sufficient contrast
    And award icons are distinguishable

  @accessibility
  Scenario: Experience ceremony with reduced motion
    Given I have reduced motion preferences set
    When I attend a virtual ceremony
    Then animations are simplified or disabled
    And award reveals are still clear
