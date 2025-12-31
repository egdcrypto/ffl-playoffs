@supplemental-drafts @platform
Feature: Supplemental Drafts
  As a fantasy football league
  I need comprehensive supplemental draft functionality
  So that owners can acquire players who become available mid-season

  Background:
    Given the supplemental draft system is operational
    And supplemental draft rules are configured

  # ==================== Supplemental Draft Triggers ====================

  @draft-triggers @mid-season-additions
  Scenario: Trigger supplemental draft for mid-season additions
    Given new players become available mid-season
    When the triggering conditions are met
    Then a supplemental draft should be initiated
    And eligible owners should be notified

  @draft-triggers @mid-season-additions
  Scenario: Configure mid-season trigger conditions
    Given trigger settings are configurable
    When setting conditions
    Then options should include
      | trigger_type         | description                    |
      | player_count         | X new players available        |
      | time_based           | weekly/bi-weekly scheduled     |
      | commissioner_manual  | on-demand by commissioner      |

  @draft-triggers @emergency-replacements
  Scenario: Initiate emergency replacement draft
    Given a significant injury occurs
    When emergency replacement is needed
    Then a targeted supplemental draft may be triggered
    And affected owners should have priority

  @draft-triggers @emergency-replacements
  Scenario: Define emergency replacement criteria
    Given emergency criteria exist
    When evaluating the situation
    Then criteria should include
      | criteria              | example                       |
      | injury_severity       | season-ending                 |
      | player_significance   | starter/key player            |
      | timing                | after trade deadline          |

  @draft-triggers @expansion-drafts
  Scenario: Conduct expansion draft
    Given the league is expanding
    When an expansion draft is needed
    Then existing rosters should provide player pool
    And new teams should draft from pool

  @draft-triggers @expansion-drafts
  Scenario: Configure expansion draft rules
    Given expansion rules are needed
    When configuring rules
    Then settings should include
      | setting               | options                       |
      | protected_players     | 3-5 per team                  |
      | rounds                | 1-3 rounds                    |
      | selection_order       | rotation, snake               |

  @draft-triggers @dispersal-drafts
  Scenario: Conduct dispersal draft
    Given orphan teams exist
    When dispersal is required
    Then orphan players should enter pool
    And remaining teams should draft from pool

  @draft-triggers @dispersal-drafts
  Scenario: Determine dispersal draft order
    Given dispersal order is needed
    When setting order
    Then order methods should include
      | method                | description                   |
      | reverse_standings     | worst teams pick first        |
      | lottery               | randomized with weights       |
      | auction               | FAAB-style bidding            |

  # ==================== Eligible Player Pool ====================

  @player-pool @unsigned-free-agents
  Scenario: Include unsigned free agents
    Given players are unsigned
    When populating the pool
    Then unsigned players should be included
    And their status should be indicated

  @player-pool @unsigned-free-agents
  Scenario: Track free agent signings
    Given free agents may sign
    When a signing occurs
    Then player status should update
    And they should move to appropriate pool

  @player-pool @waiver-exclusions
  Scenario: Exclude waiver wire players
    Given some players are on waivers
    When building supplemental pool
    Then waiver players should be excluded
    And waiver process should take precedence

  @player-pool @waiver-exclusions
  Scenario: Handle waiver-to-supplemental transition
    Given a player clears waivers
    When they become eligible
    Then they should enter supplemental pool
    And transition should be automatic

  @player-pool @trade-deadline-acquisitions
  Scenario: Include post-deadline acquisitions
    Given trades occur after deadline
    When NFL players are acquired
    Then they should be supplemental eligible
    And their new team should be noted

  @player-pool @trade-deadline-acquisitions
  Scenario: Track NFL transaction timing
    Given timing affects eligibility
    When evaluating players
    Then transaction dates should be considered
    And eligibility should be determined

  @player-pool @ir-returns
  Scenario: Include IR return players
    Given players return from IR
    When they become active
    Then they should be evaluable for pool
    And return timing should be tracked

  @player-pool @ir-returns
  Scenario: Monitor IR designations
    Given IR status changes
    When designations update
    Then pool eligibility should be reassessed
    And owners should be notified

  # ==================== Supplemental Draft Order ====================

  @draft-order @claim-priority
  Scenario: Establish claim priority order
    Given priority determines order
    When setting priority
    Then order should be established
    And priority should be transparent

  @draft-order @claim-priority
  Scenario: Apply priority system
    Given priority system is configured
    When processing claims
    Then priority should determine selection order
    And ties should be resolved by rules

  @draft-order @faab-integration
  Scenario: Use FAAB for supplemental bidding
    Given FAAB is enabled
    When bidding on players
    Then FAAB budget should apply
    And highest bidder should win

  @draft-order @faab-integration
  Scenario: Configure supplemental FAAB settings
    Given FAAB settings exist
    When configuring
    Then options should include
      | setting               | values                        |
      | shared_budget         | yes, separate                 |
      | minimum_bid           | $0, $1, $5                    |
      | tie_breaker           | waiver priority, split        |

  @draft-order @rotating-order
  Scenario: Use rotating draft order
    Given rotation is preferred
    When applying rotation
    Then order should rotate each round
    And fair distribution should occur

  @draft-order @rotating-order
  Scenario: Track rotation position
    Given rotation changes over time
    When tracking position
    Then current position should be displayed
    And history should be available

  @draft-order @need-based-order
  Scenario: Apply need-based ordering
    Given need affects priority
    When determining order
    Then teams with greater need should pick earlier
    And need criteria should be defined

  @draft-order @need-based-order
  Scenario: Define need criteria
    Given need is subjective
    When defining criteria
    Then factors should include
      | factor                | weight                        |
      | roster_size           | fewer players = higher need   |
      | injuries              | more injuries = higher need   |
      | standings             | lower standing = higher need  |

  # ==================== Draft Window Management ====================

  @draft-window @limited-windows
  Scenario: Enforce limited draft windows
    Given drafts have time limits
    When a window opens
    Then the window duration should be enforced
    And claims must be made within window

  @draft-window @limited-windows
  Scenario: Display window countdown
    Given a window is active
    When viewing the draft
    Then time remaining should be displayed
    And warnings should appear as time expires

  @draft-window @commissioner-initiated
  Scenario: Commissioner initiates draft
    Given commissioner control is enabled
    When commissioner starts draft
    Then the draft should begin immediately
    And all owners should be notified

  @draft-window @commissioner-initiated
  Scenario: Schedule commissioner draft
    Given advance notice is preferred
    When scheduling a draft
    Then a future date/time can be set
    And reminders should be sent

  @draft-window @scheduled-rounds
  Scenario: Conduct scheduled supplemental rounds
    Given regular schedules exist
    When a scheduled round occurs
    Then the round should run automatically
    And results should be processed

  @draft-window @scheduled-rounds
  Scenario: Configure round schedule
    Given schedules are configurable
    When setting schedule
    Then options should include
      | schedule_type         | frequency                     |
      | weekly                | every Tuesday                 |
      | bi-weekly             | every other week              |
      | monthly               | first of month                |
      | on-demand             | as needed                     |

  # ==================== Roster Considerations ====================

  @roster @spot-requirements
  Scenario: Verify roster spot availability
    Given rosters have limits
    When making a claim
    Then roster space should be verified
    And claims should fail if no space

  @roster @spot-requirements
  Scenario: Require roster move with claim
    Given roster is full
    When making a claim
    Then a corresponding drop should be required
    And the claim should be contingent

  @roster @position-needs
  Scenario: Assess position needs
    Given position analysis is available
    When evaluating claims
    Then position needs should be considered
    And recommendations should be provided

  @roster @position-needs
  Scenario: Display position roster status
    Given rosters have position composition
    When viewing needs
    Then current vs required should be shown
    And gaps should be highlighted

  @roster @cap-validation
  Scenario: Validate salary cap space
    Given salary cap exists
    When making a claim
    Then cap space should be verified
    And claims should fail if insufficient

  @roster @cap-validation
  Scenario: Display cap implications
    Given cap impact matters
    When viewing claim options
    Then cap impact should be shown
    And affordability should be clear

  @roster @taxi-squad-moves
  Scenario: Include taxi squad in considerations
    Given taxi squad exists
    When making roster decisions
    Then taxi moves should be options
    And taxi eligibility should be checked

  @roster @taxi-squad-moves
  Scenario: Move player to taxi for supplemental
    Given taxi space is available
    When making room for claim
    Then taxi demotion should be an option
    And the move should be processed

  # ==================== Claim Processing ====================

  @claim-processing @simultaneous-claims
  Scenario: Handle simultaneous claims
    Given multiple owners claim same player
    When processing claims
    Then priority should determine winner
    And losing claims should be handled

  @claim-processing @simultaneous-claims
  Scenario: Notify claim results
    Given claims are processed
    When results are determined
    Then all claimants should be notified
    And reasons should be provided

  @claim-processing @tiebreaker-rules
  Scenario: Apply tiebreaker rules
    Given a tie occurs in priority
    When resolving the tie
    Then tiebreaker rules should apply
      | tiebreaker            | application                   |
      | waiver_priority       | lower priority wins           |
      | standings             | worse record wins             |
      | coin_flip             | random selection              |
      | bid_amount            | higher bid wins (FAAB)        |

  @claim-processing @tiebreaker-rules
  Scenario: Configure tiebreaker order
    Given tiebreakers are configurable
    When setting order
    Then multiple tiebreakers can be chained
    And order should be saved

  @claim-processing @claim-confirmation
  Scenario: Confirm claim before processing
    Given confirmation is required
    When submitting a claim
    Then confirmation should be requested
    And the claim should wait for confirmation

  @claim-processing @claim-confirmation
  Scenario: Set claim confirmation deadline
    Given deadlines exist
    When confirmation is pending
    Then deadline should be displayed
    And unconfirmed claims should expire

  @claim-processing @failed-claims
  Scenario: Handle failed claims
    Given claims can fail
    When a claim fails
    Then the owner should be notified
    And the reason should be provided
      | failure_reason        | notification                  |
      | roster_full           | "Insufficient roster space"   |
      | cap_exceeded          | "Salary cap exceeded"         |
      | outbid                | "Outbid by another owner"     |
      | player_unavailable    | "Player no longer available"  |

  @claim-processing @failed-claims
  Scenario: Allow claim retry after failure
    Given a claim failed
    When the issue is resolved
    Then the owner should be able to retry
    And the new claim should be processed

  # ==================== Supplemental Draft Types ====================

  @draft-types @injury-replacement
  Scenario: Conduct emergency injury replacement draft
    Given a key player is injured
    When emergency draft is triggered
    Then targeted player pool should be created
    And affected owners should have first access

  @draft-types @injury-replacement
  Scenario: Define injury replacement eligibility
    Given injury triggers replacement
    When evaluating eligibility
    Then criteria should include
      | criteria              | requirement                   |
      | injury_status         | IR designated                 |
      | expected_absence      | 4+ weeks                      |
      | position_match        | same position as injured      |

  @draft-types @mid-season-rookies
  Scenario: Draft mid-season rookie additions
    Given rookies sign mid-season
    When they become NFL active
    Then they should enter supplemental pool
    And rookie designation should be noted

  @draft-types @mid-season-rookies
  Scenario: Track mid-season rookie signings
    Given signings occur throughout season
    When tracking signings
    Then new rookies should be identified
    And their status should update

  @draft-types @international-players
  Scenario: Include international players
    Given international programs exist
    When international players join NFL
    Then they should be supplemental eligible
    And their origin should be noted

  @draft-types @international-players
  Scenario: Handle international player pathways
    Given multiple pathways exist
    When evaluating players
    Then pathways should include
      | pathway               | description                   |
      | NFL_International     | international pathway program |
      | CFL_signings          | Canadian league transfers     |
      | XFL_USFL              | alternative league signings   |

  @draft-types @practice-squad
  Scenario: Include practice squad players
    Given practice squad elevations occur
    When a player is elevated
    Then they may become supplemental eligible
    And elevation status should be tracked

  @draft-types @practice-squad
  Scenario: Monitor practice squad moves
    Given moves happen weekly
    When monitoring moves
    Then elevations should be detected
    And pool should update accordingly

  # ==================== Integration with Waivers ====================

  @waiver-integration @coordination
  Scenario: Coordinate with waiver wire
    Given both systems operate
    When processing claims
    Then coordination should prevent conflicts
    And timing should be managed

  @waiver-integration @coordination
  Scenario: Define system precedence
    Given precedence matters
    When both systems claim a player
    Then precedence rules should apply
    And the appropriate system should win

  @waiver-integration @claim-overlap
  Scenario: Handle claim period overlap
    Given periods may overlap
    When overlap occurs
    Then rules should determine handling
    And owners should be informed

  @waiver-integration @claim-overlap
  Scenario: Configure overlap rules
    Given overlap handling is configurable
    When setting rules
    Then options should include
      | rule                  | behavior                      |
      | waiver_priority       | waivers process first         |
      | supplemental_priority | supplemental processes first  |
      | simultaneous          | process together              |

  @waiver-integration @priority-impact
  Scenario: Track priority impact across systems
    Given priority usage affects future claims
    When priority is used
    Then the impact should be recorded
    And future priority should adjust

  @waiver-integration @priority-impact
  Scenario: Display unified priority status
    Given priority spans systems
    When viewing priority
    Then unified status should be shown
    And impact from both systems should be visible

  @waiver-integration @budget-sharing
  Scenario: Share FAAB budget across systems
    Given FAAB may be shared
    When budget is used
    Then both systems should draw from same pool
    And balance should update accordingly

  @waiver-integration @budget-sharing
  Scenario: Configure budget sharing
    Given sharing is optional
    When configuring budget
    Then options should include
      | option                | behavior                      |
      | shared                | single budget for both        |
      | separate              | independent budgets           |
      | percentage            | X% for waivers, Y% for supp   |

  # ==================== Commissioner Controls ====================

  @commissioner @draft-initiation
  Scenario: Commissioner initiates supplemental draft
    Given commissioner has control
    When initiating a draft
    Then the draft should start
    And all settings should apply

  @commissioner @draft-initiation
  Scenario: Configure initiation options
    Given options exist
    When initiating
    Then options should include
      | option                | description                   |
      | immediate             | starts right away             |
      | scheduled             | starts at specified time      |
      | conditional           | starts when conditions met    |

  @commissioner @pool-curation
  Scenario: Curate player pool
    Given pool curation is allowed
    When commissioner curates pool
    Then players can be added or removed
    And changes should be logged

  @commissioner @pool-curation
  Scenario: Add player to pool manually
    Given a player should be included
    When commissioner adds player
    Then the player should appear in pool
    And the addition should be noted

  @commissioner @eligibility-overrides
  Scenario: Override eligibility rules
    Given edge cases occur
    When commissioner overrides eligibility
    Then the override should take effect
    And documentation should be required

  @commissioner @eligibility-overrides
  Scenario: Document eligibility override
    Given an override is made
    When documenting
    Then reason should be recorded
    And the record should be accessible

  @commissioner @draft-cancellation
  Scenario: Cancel supplemental draft
    Given cancellation is needed
    When commissioner cancels draft
    Then the draft should be terminated
    And pending claims should be cleared

  @commissioner @draft-cancellation
  Scenario: Notify of cancellation
    Given cancellation occurs
    When notifying owners
    Then all affected parties should be informed
    And reason should be communicated

  # ==================== Supplemental Draft History ====================

  @draft-history @claim-records
  Scenario: Record all claims
    Given claims are made
    When recording history
    Then all claims should be logged
    And claim details should be preserved

  @draft-history @claim-records
  Scenario: View claim history
    Given history exists
    When viewing history
    Then records should be searchable
    And filtering should be available

  @draft-history @participation
  Scenario: Track draft participation
    Given participation varies
    When tracking participation
    Then participation should be recorded
    And engagement should be measurable

  @draft-history @participation
  Scenario: Display participation metrics
    Given metrics are tracked
    When viewing metrics
    Then metrics should include
      | metric                | description                   |
      | claims_made           | total claims by owner         |
      | claims_won            | successful claims             |
      | participation_rate    | percentage of drafts active   |

  @draft-history @historical-analysis
  Scenario: Analyze historical trends
    Given historical data exists
    When analyzing trends
    Then patterns should be identified
    And insights should be generated

  @draft-history @historical-analysis
  Scenario: Compare across seasons
    Given multi-season data exists
    When comparing seasons
    Then season-over-season should be available
    And trends should be visible

  @draft-history @trend-tracking
  Scenario: Track supplemental trends
    Given trends are valuable
    When tracking trends
    Then trends should include
      | trend_type            | examples                      |
      | popular_positions     | most claimed positions        |
      | timing_patterns       | when claims are made          |
      | success_patterns      | claim success by priority     |

  @draft-history @trend-tracking
  Scenario: Generate trend reports
    Given trends are tracked
    When generating reports
    Then reports should summarize trends
    And visualizations should be available
