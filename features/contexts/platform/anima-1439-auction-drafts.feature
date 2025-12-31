@auction-drafts @platform
Feature: Auction Drafts
  As a fantasy football league
  I need comprehensive auction draft functionality
  So that owners can bid on and acquire players through an auction format

  Background:
    Given the auction draft system is operational
    And auction rules are configured

  # ==================== Auction Budget Management ====================

  @budget-management @salary-cap
  Scenario: Configure league salary cap
    Given an auction draft league is being set up
    When configuring the salary cap
    Then the total budget per team should be configurable
    And default values should be available
      | league_size | default_budget |
      | 10 teams    | $200           |
      | 12 teams    | $200           |
      | 14 teams    | $200           |

  @budget-management @salary-cap
  Scenario: Enforce salary cap limits
    Given a team has a budget limit
    When attempting to exceed the budget
    Then the bid should be rejected
    And remaining budget should be displayed

  @budget-management @budget-tracking
  Scenario: Track budget in real-time
    Given an auction is in progress
    When a team wins a bid
    Then their remaining budget should update immediately
    And the budget change should be visible

  @budget-management @budget-tracking
  Scenario: Display budget breakdown
    Given a team has acquired players
    When viewing their budget status
    Then the breakdown should show
      | category          | display    |
      | total_budget      | $200       |
      | amount_spent      | $145       |
      | remaining_budget  | $55        |
      | roster_spots_left | 5          |
      | max_bid           | $51        |

  @budget-management @remaining-funds
  Scenario: Calculate maximum bid available
    Given a team has remaining budget and roster needs
    When calculating maximum bid
    Then the max bid should reserve $1 per empty roster spot
    And the calculation should be displayed

  @budget-management @remaining-funds
  Scenario: Display remaining funds prominently
    Given the auction is in progress
    When viewing the auction room
    Then remaining funds should be clearly visible
    And low budget warnings should appear when appropriate

  @budget-management @budget-allocation
  Scenario: Suggest budget allocation strategy
    Given an owner is planning their auction
    When viewing allocation suggestions
    Then position-based allocations should be shown
      | position | suggested_percentage |
      | QB       | 10-15%               |
      | RB       | 35-40%               |
      | WR       | 30-35%               |
      | TE       | 5-10%                |
      | K/DEF    | 2-5%                 |

  @budget-management @budget-allocation
  Scenario: Track spending versus allocation plan
    Given a budget allocation plan is set
    When players are acquired
    Then actual vs planned spending should be tracked
    And variance should be displayed

  # ==================== Nomination System ====================

  @nomination @player-nominations
  Scenario: Nominate player for auction
    Given it is an owner's turn to nominate
    When they select a player to nominate
    Then the player should be put up for auction
    And bidding should begin

  @nomination @player-nominations
  Scenario: Search and nominate player
    Given an owner is nominating
    When they search for a player
    Then search results should appear
    And the player can be selected for nomination

  @nomination @nomination-order
  Scenario: Establish nomination order
    Given the auction is starting
    When determining nomination order
    Then a rotation should be established
    And the order should cycle through all teams

  @nomination @nomination-order
  Scenario: Display current nominator
    Given the auction is in progress
    When viewing the auction room
    Then the current nominator should be highlighted
    And upcoming nominators should be shown

  @nomination @nomination-timers
  Scenario: Enforce nomination time limit
    Given an owner has the nomination
    When the nomination timer expires
    Then an auto-nomination should occur
    And the next owner should get their turn

  @nomination @nomination-timers
  Scenario: Configure nomination timer
    Given the auction settings are being configured
    When setting the nomination timer
    Then timer duration should be adjustable
      | setting      | duration |
      | fast         | 30 sec   |
      | standard     | 60 sec   |
      | slow         | 120 sec  |

  @nomination @auto-nominations
  Scenario: Auto-nominate when timer expires
    Given the nomination timer expires
    When auto-nomination occurs
    Then the highest-ranked available player should be nominated
    And the auction should continue

  @nomination @auto-nominations
  Scenario: Configure auto-nomination preferences
    Given an owner sets preferences
    When auto-nomination is needed
    Then their preferred positions should be considered
    And avoid nominating their own targets

  # ==================== Bidding Mechanics ====================

  @bidding @bid-increments
  Scenario: Configure bid increments
    Given the auction settings are being configured
    When setting bid increments
    Then increment options should be available
      | increment_type | amount |
      | minimum        | $1     |
      | standard       | $1     |
      | custom         | $2-$5  |

  @bidding @bid-increments
  Scenario: Enforce minimum bid increment
    Given a player is being auctioned
    When a bid is placed
    Then it must meet the minimum increment
    And lower bids should be rejected

  @bidding @bid-timers
  Scenario: Manage bid timer
    Given bidding is in progress
    When a new bid is placed
    Then the timer should reset
    And countdown should continue

  @bidding @bid-timers
  Scenario: Configure bid timer duration
    Given auction settings are being set
    When configuring bid timer
    Then timer options should be available
      | timer_type | duration |
      | fast       | 10 sec   |
      | standard   | 15 sec   |
      | slow       | 30 sec   |

  @bidding @maximum-bids
  Scenario: Set maximum bid
    Given an owner wants to set a max bid
    When they enter their maximum
    Then the system should auto-bid up to that amount
    And other owners should not see the max

  @bidding @maximum-bids
  Scenario: Auto-bid using maximum bid
    Given a max bid is set
    When another owner places a bid
    Then the system should automatically counter
    And bidding should continue until max is exceeded

  @bidding @bid-history
  Scenario: Track bid history for player
    Given a player is being auctioned
    When bids are placed
    Then bid history should be recorded
      | bidder        | amount | time      |
      | Team Alpha    | $25    | 12:01:15  |
      | Team Beta     | $26    | 12:01:22  |
      | Team Alpha    | $28    | 12:01:30  |

  @bidding @bid-history
  Scenario: View auction-wide bid history
    Given the auction is in progress
    When viewing bid history
    Then all bids should be accessible
    And filtering by team should be available

  @bidding @outbid-notifications
  Scenario: Notify owner when outbid
    Given an owner has the high bid
    When another owner places a higher bid
    Then the outbid owner should be notified
    And the notification should be immediate

  @bidding @outbid-notifications
  Scenario: Configure notification preferences
    Given notification settings are available
    When configuring preferences
    Then sound and visual alerts should be customizable
    And notification types should be selectable

  # ==================== Auction Room Interface ====================

  @auction-room @live-auction-board
  Scenario: Display live auction board
    Given the auction is in progress
    When viewing the auction room
    Then the current player should be displayed prominently
    And bid information should update in real-time

  @auction-room @live-auction-board
  Scenario: Show player information on board
    Given a player is nominated
    When viewing the auction board
    Then player details should be displayed
      | detail          | displayed |
      | name            | yes       |
      | position        | yes       |
      | team            | yes       |
      | projected_points| yes       |
      | auction_value   | yes       |
      | current_bid     | yes       |

  @auction-room @player-queue
  Scenario: Display player queue
    Given owners have created nomination lists
    When viewing the queue
    Then upcoming nominations should be visible
    And queue management should be available

  @auction-room @player-queue
  Scenario: Manage personal nomination queue
    Given an owner has targets
    When managing their queue
    Then they can add and remove players
    And priority order can be set

  @auction-room @team-rosters
  Scenario: Display all team rosters
    Given teams are acquiring players
    When viewing team rosters
    Then all teams' rosters should be visible
    And current spending should be shown

  @auction-room @team-rosters
  Scenario: Highlight roster needs
    Given teams have position requirements
    When viewing rosters
    Then unfilled positions should be highlighted
    And roster completion status should be shown

  @auction-room @bid-activity-feed
  Scenario: Display bid activity feed
    Given bids are being placed
    When viewing the activity feed
    Then recent bids should stream live
    And timestamps should be included

  @auction-room @bid-activity-feed
  Scenario: Filter activity feed
    Given the activity feed is active
    When filtering the feed
    Then filters should include
      | filter_type     | options              |
      | by_team         | specific team        |
      | by_position     | QB, RB, WR, TE       |
      | by_price_range  | $1-$10, $11-$25, etc |

  # ==================== Player Valuation ====================

  @player-valuation @auction-values
  Scenario: Display player auction values
    Given auction values are calculated
    When viewing player values
    Then projected auction prices should be shown
    And value sources should be indicated

  @player-valuation @auction-values
  Scenario: Compare value to current bid
    Given a player is being auctioned
    When viewing valuation
    Then current bid vs projected value should be shown
    And value indicator should display (over/under)

  @player-valuation @value-rankings
  Scenario: Rank players by auction value
    Given auction values are available
    When viewing value rankings
    Then players should be ranked by value
    And position filters should be available

  @player-valuation @value-rankings
  Scenario: Display value by position
    Given position-specific values exist
    When viewing position rankings
    Then auction values by position should be shown
    And tier breaks should be highlighted

  @player-valuation @value-based-drafting
  Scenario: Apply value-based drafting principles
    Given VBD principles apply to auctions
    When evaluating players
    Then value over replacement should be shown
    And dollar values should be assigned

  @player-valuation @value-based-drafting
  Scenario: Calculate value relative to budget
    Given budget constraints exist
    When calculating relative value
    Then value as percentage of budget should be shown
    And efficiency metrics should be displayed

  @player-valuation @dollar-per-point
  Scenario: Calculate dollar-per-point metrics
    Given projected points are available
    When calculating efficiency
    Then dollars per projected point should be computed
    And efficiency rankings should be shown

  @player-valuation @dollar-per-point
  Scenario: Display value efficiency
    Given dollar-per-point is calculated
    When viewing player values
    Then efficiency should be displayed
      | player         | auction_value | projected_pts | $/pt  |
      | Player A       | $45           | 300           | $0.15 |
      | Player B       | $30           | 250           | $0.12 |

  # ==================== Auction Strategy Tools ====================

  @strategy-tools @target-lists
  Scenario: Create auction target list
    Given an owner is preparing for auction
    When creating their target list
    Then players can be added with target prices
    And priority can be set

  @strategy-tools @target-lists
  Scenario: Track targets during auction
    Given a target list is created
    When targets are won or lost
    Then the list should update automatically
    And alerts should notify when targets are nominated

  @strategy-tools @budget-planner
  Scenario: Use budget allocation planner
    Given an owner is planning budget
    When using the planner
    Then position budgets can be set
    And total should match available budget

  @strategy-tools @budget-planner
  Scenario: Adjust budget plan in real-time
    Given the auction is in progress
    When spending deviates from plan
    Then adjustments should be suggested
    And rebalancing options should be shown

  @strategy-tools @spending-guides
  Scenario: Access positional spending guides
    Given spending guides are available
    When viewing guides
    Then position-specific recommendations should be shown
    And strategy tips should be provided

  @strategy-tools @spending-guides
  Scenario: Customize spending strategy
    Given default strategies exist
    When customizing strategy
    Then spending percentages can be adjusted
    And custom strategies can be saved

  @strategy-tools @nomination-strategy
  Scenario: Plan nomination strategy
    Given nominations affect auction dynamics
    When planning nominations
    Then strategic tips should be provided
      | strategy              | description                      |
      | nominate_non_targets  | save targets for later           |
      | force_spending        | nominate studs early             |
      | position_runs         | trigger position runs            |
      | budget_drain          | target big spenders' needs       |

  @strategy-tools @nomination-strategy
  Scenario: Execute nomination strategy
    Given a nomination strategy is planned
    When it's time to nominate
    Then strategy-aligned suggestions should appear
    And execution should be tracked

  # ==================== Roster Construction ====================

  @roster-construction @position-limits
  Scenario: Enforce position limits during auction
    Given position limits are configured
    When a team reaches a position limit
    Then they should be unable to bid on that position
    And a notification should be displayed

  @roster-construction @position-limits
  Scenario: Display position limits status
    Given the auction is in progress
    When viewing roster status
    Then current vs limit should be shown
      | position | current | limit |
      | QB       | 1       | 2     |
      | RB       | 3       | 6     |
      | WR       | 2       | 6     |
      | TE       | 1       | 2     |

  @roster-construction @roster-requirements
  Scenario: Enforce roster requirements
    Given minimum roster requirements exist
    When the auction progresses
    Then requirements should be enforced
    And owners should be alerted to unfilled needs

  @roster-construction @roster-requirements
  Scenario: Display roster completion status
    Given roster requirements are set
    When viewing roster status
    Then completion percentage should be shown
    And missing positions should be highlighted

  @roster-construction @budget-reserves
  Scenario: Calculate required budget reserve
    Given roster spots remain unfilled
    When calculating reserves
    Then minimum $1 per spot should be reserved
    And max bid should account for reserves

  @roster-construction @budget-reserves
  Scenario: Display reserve requirements
    Given reserves are calculated
    When viewing budget status
    Then reserved amount should be shown
    And available for bidding should be clear

  @roster-construction @flex-considerations
  Scenario: Consider flex position in roster building
    Given flex positions provide flexibility
    When building roster
    Then flex eligibility should be factored
    And position versatility should be valued

  @roster-construction @flex-considerations
  Scenario: Optimize roster for flex value
    Given flex can be RB/WR/TE
    When constructing roster
    Then flex-eligible depth should be prioritized
    And optimal flex usage should be suggested

  # ==================== Keeper Auction Integration ====================

  @keeper-auction @keeper-costs
  Scenario: Apply keeper costs to auction
    Given keepers have assigned values
    When the auction begins
    Then keeper costs should be deducted from budget
    And keepers should be assigned to rosters

  @keeper-auction @keeper-costs
  Scenario: Display keeper impact on budget
    Given a team has keepers
    When viewing budget
    Then keeper costs should be itemized
    And remaining draft budget should be shown

  @keeper-auction @keeper-inflation
  Scenario: Calculate keeper inflation
    Given keepers remove top players
    When calculating inflation
    Then remaining player pool value should increase
    And inflation rate should be displayed

  @keeper-auction @keeper-inflation
  Scenario: Adjust values for inflation
    Given inflation is calculated
    When viewing player values
    Then inflation-adjusted values should be available
    And both raw and adjusted values should be shown

  @keeper-auction @contract-years
  Scenario: Track keeper contract years
    Given keepers have multi-year contracts
    When viewing keeper status
    Then contract years should be displayed
    And expiration should be noted

  @keeper-auction @contract-years
  Scenario: Factor contracts into value
    Given contract length affects value
    When evaluating keepers
    Then contract value should be calculated
    And comparison to auction should be shown

  @keeper-auction @franchise-tags
  Scenario: Apply franchise tag to keeper
    Given franchise tags are available
    When using a franchise tag
    Then the player should be kept at tag cost
    And tag rules should be enforced

  @keeper-auction @franchise-tags
  Scenario: Calculate franchise tag cost
    Given franchise tag costs are defined
    When calculating tag cost
    Then position-based cost should be applied
    And cost should be displayed

  # ==================== Auction Draft Results ====================

  @auction-results @draft-recap
  Scenario: Generate auction draft recap
    Given the auction has completed
    When viewing the recap
    Then all picks should be listed
    And spending summaries should be shown

  @auction-results @draft-recap
  Scenario: Display recap by team
    Given the recap is generated
    When filtering by team
    Then team-specific results should be shown
      | player       | position | price |
      | Player A     | RB       | $55   |
      | Player B     | WR       | $42   |
      | Player C     | QB       | $25   |

  @auction-results @spending-analysis
  Scenario: Analyze auction spending
    Given the auction is complete
    When analyzing spending
    Then spending patterns should be shown
    And position breakdown should be available

  @auction-results @spending-analysis
  Scenario: Compare spending to league average
    Given all teams have spent their budgets
    When comparing spending
    Then team vs average should be displayed
    And outliers should be identified

  @auction-results @team-grades
  Scenario: Generate team grades
    Given auction results are available
    When grading teams
    Then grades should be assigned
    And grading methodology should be explained

  @auction-results @team-grades
  Scenario: Display grade breakdown
    Given grades are calculated
    When viewing grade details
    Then category breakdowns should be shown
      | category          | grade | notes                    |
      | value_picks       | A     | got 3 players below value|
      | position_balance  | B+    | solid at all positions   |
      | budget_efficiency | A-    | minimal unused budget    |

  @auction-results @value-picks
  Scenario: Identify value picks
    Given auction prices are compared to projections
    When identifying value picks
    Then players acquired below value should be highlighted
    And value differential should be shown

  @auction-results @value-picks
  Scenario: Identify overpays
    Given prices are compared to value
    When identifying overpays
    Then overpriced acquisitions should be flagged
    And overpay amount should be calculated

  # ==================== Mock Auction Drafts ====================

  @mock-auctions @practice-auctions
  Scenario: Join practice auction
    Given practice auctions are available
    When joining a practice auction
    Then the owner should be placed in a mock lobby
    And the auction should proceed as normal

  @mock-auctions @practice-auctions
  Scenario: Configure practice auction settings
    Given practice auctions can be customized
    When setting up practice
    Then settings should match league configuration
    And custom scenarios should be available

  @mock-auctions @auction-simulations
  Scenario: Run auction simulation
    Given simulation capabilities exist
    When running a simulation
    Then the auction should simulate to completion
    And results should be displayed

  @mock-auctions @auction-simulations
  Scenario: Simulate multiple scenarios
    Given different strategies exist
    When simulating scenarios
    Then multiple outcomes should be generated
    And strategy comparisons should be available

  @mock-auctions @ai-bidding
  Scenario: Compete against AI bidding opponents
    Given AI opponents are available
    When practicing against AI
    Then AI should bid realistically
    And difficulty levels should be available

  @mock-auctions @ai-bidding
  Scenario: Configure AI bidding behavior
    Given AI behavior can be adjusted
    When configuring AI
    Then aggressiveness can be set
      | difficulty | behavior                    |
      | easy       | passive, predictable        |
      | medium     | balanced, strategic         |
      | hard       | aggressive, optimal bidding |

  @mock-auctions @strategy-testing
  Scenario: Test auction strategies
    Given strategies need validation
    When testing a strategy
    Then simulation should apply the strategy
    And outcomes should be analyzed

  @mock-auctions @strategy-testing
  Scenario: Compare strategy outcomes
    Given multiple strategies are tested
    When comparing results
    Then outcome comparisons should be shown
    And best strategy should be identified
