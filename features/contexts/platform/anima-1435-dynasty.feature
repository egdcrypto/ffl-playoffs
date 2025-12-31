@dynasty @platform
Feature: Dynasty
  As a fantasy football dynasty league
  I need comprehensive dynasty management features
  So that owners can build and maintain long-term competitive teams

  Background:
    Given a dynasty league is configured
    And dynasty rules are established

  # ==================== Dynasty Rosters ====================

  @dynasty-rosters @expanded-rosters
  Scenario: Configure expanded dynasty roster size
    Given a dynasty league is being set up
    When configuring roster settings
    Then expanded roster sizes should be available
      | roster_component | standard_size | dynasty_size |
      | active_roster    | 15            | 25           |
      | bench            | 6             | 10           |
      | taxi_squad       | 0             | 5            |
      | IR_slots         | 1             | 3            |

  @dynasty-rosters @expanded-rosters
  Scenario: Support larger roster capacities
    Given a dynasty league with expanded rosters
    When an owner manages their roster
    Then they should be able to roster up to the dynasty limit
    And all roster spots should be trackable

  @dynasty-rosters @roster-limits
  Scenario: Enforce dynasty roster limits
    Given roster limits are configured
    When an owner attempts to exceed limits
    Then the action should be blocked
    And the limit violation should be displayed

  @dynasty-rosters @roster-limits
  Scenario: Configure position limits for dynasty
    Given dynasty position limits are set
    When managing roster composition
    Then position limits should be enforced
      | position | min | max |
      | QB       | 1   | 4   |
      | RB       | 2   | 8   |
      | WR       | 2   | 8   |
      | TE       | 1   | 4   |
      | K        | 0   | 2   |
      | DEF      | 0   | 2   |

  @dynasty-rosters @roster-management
  Scenario: Manage dynasty roster year-round
    Given dynasty leagues operate year-round
    When accessing roster management in the offseason
    Then full roster functionality should be available
    And trades and acquisitions should be possible

  @dynasty-rosters @roster-management
  Scenario: Track roster changes over time
    Given roster transactions occur throughout the year
    When viewing roster history
    Then all changes should be documented
    And transaction dates should be recorded

  @dynasty-rosters @active-roster
  Scenario: Set active roster for game week
    Given an owner has an expanded roster
    When setting their active lineup
    Then they must choose from all rostered players
    And active roster limits should apply

  @dynasty-rosters @active-roster
  Scenario: Distinguish active vs inactive players
    Given players have different roster designations
    When viewing the roster
    Then active and inactive players should be clearly marked
    And starting eligibility should be indicated

  @dynasty-rosters @bench-depth
  Scenario: Utilize deep bench for dynasty
    Given dynasty benches are deeper than redraft
    When managing bench players
    Then all bench spots should be usable
    And bench players should be trade-eligible

  @dynasty-rosters @bench-depth
  Scenario: Strategize with bench depth
    Given an owner has deep bench options
    When evaluating roster moves
    Then bench depth should be considered
    And handcuff and depth values should be visible

  # ==================== Rookie Drafts ====================

  @rookie-drafts @draft-order
  Scenario: Determine rookie draft order
    Given the previous season has concluded
    When calculating rookie draft order
    Then non-playoff teams should pick first
    And order should be based on standings
      | finish_position | draft_pick |
      | 12th (worst)    | 1st        |
      | 11th            | 2nd        |
      | 10th            | 3rd        |
      | playoff_loser   | 7th-10th   |
      | champion        | 12th       |

  @rookie-drafts @draft-order
  Scenario: Use lottery for rookie draft order
    Given a lottery system is configured
    When determining draft order
    Then lottery odds should be applied
    And results should be randomized fairly

  @rookie-drafts @rookie-picks
  Scenario: Select rookies in draft
    Given the rookie draft is in progress
    When an owner makes their pick
    Then only eligible rookies should be selectable
    And the pick should be recorded

  @rookie-drafts @rookie-picks
  Scenario: Display rookie information during draft
    Given a rookie is available for selection
    When viewing the rookie's profile
    Then college stats should be displayed
    And draft projections should be shown

  @rookie-drafts @draft-pick-trading
  Scenario: Trade rookie draft picks
    Given owners can trade draft picks
    When a pick trade is proposed
    Then the trade should include pick details
      | detail       | included |
      | year         | yes      |
      | round        | yes      |
      | original_owner| yes     |
      | current_owner | yes     |

  @rookie-drafts @draft-pick-trading
  Scenario: Trade future rookie picks
    Given future picks are tradeable
    When trading picks from future years
    Then picks up to 3 years ahead should be available
    And pick ownership should be tracked

  @rookie-drafts @supplemental-drafts
  Scenario: Conduct supplemental draft
    Given players become available mid-season
    When a supplemental draft is held
    Then newly eligible players should be available
    And draft order should follow league rules

  @rookie-drafts @supplemental-drafts
  Scenario: Handle late-entry rookies
    Given a rookie enters the league late
    When they become available
    Then they should be added to supplemental draft
    Or become free agents per league rules

  @rookie-drafts @rookie-scouting
  Scenario: Access rookie scouting reports
    Given rookie evaluation is important
    When viewing scouting information
    Then combine results should be available
    And expert rankings should be displayed

  @rookie-drafts @rookie-scouting
  Scenario: Compare rookie prospects
    Given multiple rookies are being evaluated
    When using comparison tools
    Then side-by-side comparisons should be available
    And relevant metrics should be displayed

  # ==================== Taxi Squad ====================

  @taxi-squad @taxi-slots
  Scenario: Configure taxi squad size
    Given a dynasty league has taxi squad
    When configuring taxi settings
    Then taxi squad size should be adjustable
    And typical sizes should be supported
      | size_option | slots |
      | small       | 3     |
      | standard    | 5     |
      | large       | 7     |

  @taxi-squad @taxi-slots
  Scenario: Assign player to taxi squad
    Given a player is taxi squad eligible
    When assigning them to taxi squad
    Then they should be moved to taxi slots
    And active roster spot should be freed

  @taxi-squad @taxi-eligibility
  Scenario: Determine taxi squad eligibility
    Given taxi eligibility rules exist
    When evaluating a player
    Then eligibility should be based on criteria
      | criteria        | requirement           |
      | experience      | 2 years or fewer      |
      | draft_status    | drafted by team       |
      | games_played    | varies by league      |

  @taxi-squad @taxi-eligibility
  Scenario: Restrict taxi to rookies only
    Given a league limits taxi to first-year players
    When assigning players to taxi
    Then only rookies should be eligible
    And veterans should be rejected

  @taxi-squad @taxi-promotion
  Scenario: Promote player from taxi squad
    Given a taxi squad player is ready
    When promoting to active roster
    Then the player should move to bench
    And taxi spot should become available

  @taxi-squad @taxi-promotion
  Scenario: Enforce promotion deadlines
    Given taxi squad has promotion rules
    When a deadline approaches
    Then owners should be notified
    And mandatory promotions should occur

  @taxi-squad @taxi-protection
  Scenario: Protect taxi squad players
    Given taxi players have protection
    When another owner attempts to claim
    Then protected players should be safe
    And claim should be rejected

  @taxi-squad @taxi-protection
  Scenario: Handle taxi poaching rules
    Given some leagues allow taxi poaching
    When a poach attempt is made
    Then league rules should determine outcome
    And compensation may be required

  @taxi-squad @taxi-rules
  Scenario: Display taxi squad rules
    Given taxi rules vary by league
    When viewing taxi information
    Then all applicable rules should be displayed
    And clarifications should be available

  @taxi-squad @taxi-rules
  Scenario: Enforce taxi squad limitations
    Given taxi limitations are configured
    When managing taxi players
    Then limitations should be enforced
    And violations should be prevented

  # ==================== Contract System ====================

  @contracts @player-contracts
  Scenario: Assign contract to player
    Given a contract system is enabled
    When a player is acquired
    Then a contract should be assigned
    And contract terms should be recorded

  @contracts @player-contracts
  Scenario: Display contract details
    Given a player has a contract
    When viewing player information
    Then contract details should be shown
      | detail          | displayed |
      | salary          | yes       |
      | years_remaining | yes       |
      | guaranteed_money| yes       |
      | cap_hit         | yes       |

  @contracts @contract-length
  Scenario: Configure contract length options
    Given contracts have length limits
    When signing a player
    Then length options should be available
      | contract_type | length_options |
      | rookie        | 4 years        |
      | veteran       | 1-5 years      |
      | extension     | 1-4 years      |

  @contracts @contract-length
  Scenario: Track contract years remaining
    Given players have active contracts
    When viewing roster
    Then years remaining should be displayed
    And expiring contracts should be highlighted

  @contracts @salary-cap
  Scenario: Enforce salary cap
    Given a salary cap is configured
    When an owner exceeds the cap
    Then transactions should be blocked
    And cap space should be displayed

  @contracts @salary-cap
  Scenario: Calculate cap space
    Given player salaries are assigned
    When calculating cap space
    Then total salary should be summed
    And available cap should be shown

  @contracts @contract-extensions
  Scenario: Extend player contract
    Given a player's contract is expiring
    When negotiating an extension
    Then extension terms should be offered
    And new contract should be recorded

  @contracts @contract-extensions
  Scenario: Calculate extension cost
    Given an extension is being negotiated
    When calculating the cost
    Then market value should be considered
    And extension premium should be applied

  @contracts @contract-restructuring
  Scenario: Restructure player contract
    Given cap space is needed
    When restructuring a contract
    Then guaranteed money can be converted
    And cap relief should be provided

  @contracts @contract-restructuring
  Scenario: Limit restructuring options
    Given restructuring has limits
    When attempting to restructure
    Then limits should be enforced
    And valid options should be presented

  # ==================== Franchise Tags ====================

  @franchise-tags @franchise-designation
  Scenario: Apply franchise tag to player
    Given franchise tags are available
    When an owner uses their franchise tag
    Then the player should be designated
    And tag cost should be applied

  @franchise-tags @franchise-designation
  Scenario: Display franchise tag options
    Given tag options exist
    When viewing tag possibilities
    Then eligible players should be shown
    And tag costs should be calculated

  @franchise-tags @tag-cost
  Scenario: Calculate franchise tag cost
    Given franchise tag costs are defined
    When calculating tag cost
    Then position-based costs should apply
      | position | tag_cost_formula           |
      | QB       | top 5 average salary       |
      | RB       | top 5 average salary       |
      | WR       | top 5 average salary       |
      | TE       | top 5 average salary       |

  @franchise-tags @tag-cost
  Scenario: Apply repeat tag penalty
    Given a player was tagged last year
    When applying tag again
    Then a cost increase should apply
    And the penalty should be displayed

  @franchise-tags @tag-limits
  Scenario: Enforce tag usage limits
    Given tag limits are configured
    When an owner has used their tags
    Then additional tags should be blocked
    And limit status should be displayed

  @franchise-tags @tag-limits
  Scenario: Limit consecutive tags on player
    Given a player has been tagged multiple times
    When evaluating tag eligibility
    Then consecutive tag limits should apply
    And the player may become ineligible

  @franchise-tags @exclusive-tags
  Scenario: Apply exclusive franchise tag
    Given exclusive tags prevent negotiation
    When an exclusive tag is applied
    Then the player cannot negotiate with others
    And the tag cost should reflect exclusivity

  @franchise-tags @exclusive-tags
  Scenario: Differentiate exclusive vs non-exclusive
    Given different tag types exist
    When applying a tag
    Then the owner should choose the type
    And implications should be displayed

  @franchise-tags @transition-tags
  Scenario: Apply transition tag
    Given transition tags are available
    When applying a transition tag
    Then the player can receive offers
    And the original team has right of first refusal

  @franchise-tags @transition-tags
  Scenario: Match transition tag offer
    Given a transition tagged player receives an offer
    When the original owner reviews it
    Then they can match the offer
    And matching retains the player

  # ==================== Draft Pick Trading ====================

  @pick-trading @future-picks
  Scenario: Trade future draft picks
    Given future picks are tradeable assets
    When including picks in a trade
    Then picks from future years should be available
    And pick details should be displayed

  @pick-trading @future-picks
  Scenario: Limit future pick trading
    Given pick trading limits exist
    When attempting to trade picks
    Then limits should be enforced
    And teams must maintain minimum picks

  @pick-trading @pick-values
  Scenario: Display pick values
    Given picks have relative values
    When evaluating a trade
    Then pick values should be shown
    And value comparisons should be available

  @pick-trading @pick-values
  Scenario: Calculate pick value based on position
    Given pick value varies by round and position
    When calculating pick value
    Then early picks should be valued higher
    And lottery implications should be considered

  @pick-trading @pick-swaps
  Scenario: Arrange pick swap
    Given teams want to swap picks
    When creating a pick swap agreement
    Then the better pick goes to one team
    And the swap should be recorded

  @pick-trading @pick-swaps
  Scenario: Execute conditional pick swap
    Given a pick swap has conditions
    When conditions are evaluated
    Then the swap executes if conditions are met
    And results should be communicated

  @pick-trading @conditional-picks
  Scenario: Trade conditional picks
    Given picks can have conditions
    When creating a conditional pick trade
    Then conditions should be specified
      | condition_type    | example                      |
      | performance       | if player scores X points    |
      | playoff           | if team makes playoffs       |
      | pick_position     | if pick is top 3             |

  @pick-trading @conditional-picks
  Scenario: Resolve conditional pick
    Given a conditional pick's condition is met
    When the condition is triggered
    Then the pick should transfer
    And both teams should be notified

  @pick-trading @pick-tracking
  Scenario: Track pick ownership
    Given picks are traded frequently
    When viewing pick ownership
    Then current owner should be displayed
    And trade history should be available

  @pick-trading @pick-tracking
  Scenario: Display pick trading history
    Given a pick has been traded multiple times
    When viewing pick history
    Then all trades should be listed
    And original owner should be shown

  # ==================== Devy Players ====================

  @devy @college-players
  Scenario: Add college players to devy pool
    Given devy leagues include college players
    When populating the devy pool
    Then college players should be available
    And class year should be displayed

  @devy @college-players
  Scenario: Track college player statistics
    Given college players are in the devy pool
    When viewing player profiles
    Then college stats should be shown
    And projection data should be available

  @devy @devy-draft
  Scenario: Conduct devy draft
    Given a devy draft is scheduled
    When the draft occurs
    Then college players can be selected
    And selections should be recorded

  @devy @devy-draft
  Scenario: Integrate devy picks with rookie draft
    Given devy and rookie drafts are related
    When managing draft picks
    Then integration should be seamless
    And pick values should be consistent

  @devy @devy-roster
  Scenario: Manage devy roster spots
    Given devy rosters are separate
    When managing devy players
    Then dedicated devy slots should be used
    And devy limits should be enforced

  @devy @devy-roster
  Scenario: Track devy player development
    Given devy players are being developed
    When viewing devy roster
    Then expected NFL entry year should be shown
    And development notes should be available

  @devy @devy-eligibility
  Scenario: Determine devy eligibility
    Given players must meet devy criteria
    When evaluating eligibility
    Then college status should be verified
    And NFL draft eligibility should be considered

  @devy @devy-eligibility
  Scenario: Handle early NFL entrants
    Given a devy player declares early for NFL
    When updating their status
    Then they should become rookie eligible
    And devy owner should retain rights

  @devy @devy-promotion
  Scenario: Promote devy player to NFL roster
    Given a devy player enters the NFL
    When they are drafted or signed
    Then they should move to main roster
    And devy spot should be freed

  @devy @devy-promotion
  Scenario: Handle undrafted devy players
    Given a devy player goes undrafted in NFL
    When evaluating their status
    Then league rules should determine outcome
    And owner options should be presented

  # ==================== IR Slots ====================

  @ir-slots @injured-reserve
  Scenario: Place player on injured reserve
    Given a player is injured
    When placing them on IR
    Then they should be moved to IR slot
    And roster spot should be freed

  @ir-slots @injured-reserve
  Scenario: Display IR roster
    Given players are on IR
    When viewing the roster
    Then IR players should be clearly marked
    And injury details should be available

  @ir-slots @ir-eligibility
  Scenario: Verify IR eligibility
    Given IR has eligibility requirements
    When placing a player on IR
    Then eligibility should be verified
      | status           | eligible |
      | injured          | yes      |
      | suspended        | depends  |
      | healthy_scratch  | no       |
      | COVID_list       | yes      |

  @ir-slots @ir-eligibility
  Scenario: Handle ineligible IR placement
    Given a player is not IR eligible
    When attempting IR placement
    Then the action should be blocked
    And eligibility rules should be displayed

  @ir-slots @ir-rules
  Scenario: Enforce IR rules
    Given IR usage has rules
    When managing IR players
    Then rules should be enforced
    And violations should be prevented

  @ir-slots @ir-rules
  Scenario: Configure IR designation types
    Given different IR types exist
    When placing a player on IR
    Then designation type should be selected
      | designation | return_timeline |
      | IR          | season-ending   |
      | IR-R        | can return      |
      | PUP         | 6 weeks minimum |

  @ir-slots @ir-limits
  Scenario: Enforce IR slot limits
    Given IR slots are limited
    When all IR slots are full
    Then additional IR placements should be blocked
    And the owner should manage existing IR

  @ir-slots @ir-limits
  Scenario: Expand IR slots for dynasty
    Given dynasty leagues need more IR
    When configuring IR settings
    Then expanded IR options should be available
    And limits should be adjustable

  @ir-slots @ir-management
  Scenario: Activate player from IR
    Given a player is ready to return
    When activating from IR
    Then they should return to active roster
    And IR spot should be available

  @ir-slots @ir-management
  Scenario: Handle IR and roster limits
    Given roster is full when activating from IR
    When attempting activation
    Then a roster move should be required
    And options should be presented

  # ==================== Orphan Teams ====================

  @orphan-teams @team-abandonment
  Scenario: Handle team abandonment
    Given an owner abandons their team
    When abandonment is detected
    Then the team should be marked as orphan
    And league should be notified

  @orphan-teams @team-abandonment
  Scenario: Detect inactive owners
    Given owner activity is tracked
    When an owner is inactive
    Then warnings should be issued
    And eventual orphan status may result

  @orphan-teams @orphan-adoption
  Scenario: Adopt orphan team
    Given an orphan team is available
    When a new owner wants to adopt
    Then adoption process should be initiated
    And team should transfer to new owner

  @orphan-teams @orphan-adoption
  Scenario: Set orphan team price
    Given orphan teams have varying value
    When setting adoption price
    Then team value should be considered
    And fair pricing should be established

  @orphan-teams @team-valuation
  Scenario: Calculate orphan team value
    Given orphan teams need valuation
    When calculating team value
    Then dynasty player values should be used
    And future assets should be included

  @orphan-teams @team-valuation
  Scenario: Display orphan team details
    Given an orphan team is available
    When viewing team details
    Then roster should be displayed
    And draft picks should be shown

  @orphan-teams @orphan-draft
  Scenario: Conduct orphan dispersal draft
    Given multiple orphan teams exist
    When a dispersal draft is needed
    Then all orphan players enter the pool
    And remaining teams draft from pool

  @orphan-teams @orphan-draft
  Scenario: Determine dispersal draft order
    Given a dispersal draft is scheduled
    When setting draft order
    Then order method should be selected
      | method        | description              |
      | lottery       | random weighted by finish|
      | reverse_finish| worst teams pick first   |
      | auction       | bid on players           |

  @orphan-teams @league-continuity
  Scenario: Maintain league continuity
    Given an orphan situation threatens the league
    When managing the situation
    Then league history should be preserved
    And continuity should be prioritized

  @orphan-teams @league-continuity
  Scenario: Prevent league collapse from orphans
    Given too many orphan teams exist
    When evaluating league viability
    Then contingency plans should be available
    And league preservation options should be presented

  # ==================== Dynasty Rankings ====================

  @dynasty-rankings @player-values
  Scenario: Display dynasty player values
    Given dynasty values differ from redraft
    When viewing player rankings
    Then dynasty-specific values should be shown
    And age-adjusted values should be included

  @dynasty-rankings @player-values
  Scenario: Factor age into dynasty value
    Given player age affects dynasty value
    When calculating values
    Then younger players should have premium
    And aging curves should be applied

  @dynasty-rankings @trade-calculator
  Scenario: Use dynasty trade calculator
    Given trade evaluation is needed
    When using the trade calculator
    Then dynasty values should be applied
    And trade fairness should be assessed

  @dynasty-rankings @trade-calculator
  Scenario: Include picks in trade calculations
    Given draft picks have value
    When calculating trade value
    Then pick values should be included
    And future picks should be discounted appropriately

  @dynasty-rankings @roster-rankings
  Scenario: Rank dynasty rosters
    Given all teams have rosters
    When generating roster rankings
    Then total roster value should be calculated
    And teams should be ranked by value

  @dynasty-rankings @roster-rankings
  Scenario: Break down roster value by component
    Given rosters have multiple components
    When viewing roster breakdown
    Then value by position should be shown
    And depth value should be included

  @dynasty-rankings @future-projections
  Scenario: Project future dynasty value
    Given players have career trajectories
    When projecting future value
    Then multi-year projections should be available
    And confidence levels should be included

  @dynasty-rankings @future-projections
  Scenario: Model aging and decline
    Given players age and decline
    When projecting long-term value
    Then aging curves should be applied
    And decline projections should be shown

  @dynasty-rankings @dynasty-tiers
  Scenario: Display dynasty value tiers
    Given players fall into value tiers
    When viewing rankings
    Then tier assignments should be shown
      | tier        | description              |
      | elite       | cornerstone assets       |
      | blue_chip   | high-value starters      |
      | solid       | reliable contributors    |
      | depth       | roster fillers           |
      | cut         | replacement level        |

  @dynasty-rankings @dynasty-tiers
  Scenario: Track tier movements
    Given player values change over time
    When viewing tier history
    Then tier movements should be tracked
    And significant changes should be highlighted
