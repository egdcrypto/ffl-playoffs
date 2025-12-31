@idp @platform
Feature: IDP (Individual Defensive Players)
  As a fantasy football league
  I need IDP functionality
  So that owners can roster and score individual defensive players

  Background:
    Given the IDP system is operational
    And IDP scoring rules are configured

  # ==================== IDP Positions ====================

  @idp-positions @defensive-lineman
  Scenario: Configure defensive lineman position
    Given IDP positions are being set up
    When configuring defensive lineman (DL)
    Then the position should include
      | sub_position        | designation |
      | defensive_end       | DE          |
      | defensive_tackle    | DT          |
      | nose_tackle         | NT          |

  @idp-positions @defensive-lineman
  Scenario: Track DL-specific statistics
    Given a defensive lineman is rostered
    When tracking their statistics
    Then DL-relevant stats should be captured
      | stat_category    | stats                        |
      | pass_rush        | sacks, QB hits, pressures    |
      | run_defense      | tackles, TFL, stuffs         |
      | playmaking       | fumbles forced, recoveries   |

  @idp-positions @linebacker
  Scenario: Configure linebacker position
    Given IDP positions include linebackers
    When configuring linebacker (LB)
    Then the position should include
      | sub_position        | designation |
      | inside_linebacker   | ILB         |
      | outside_linebacker  | OLB         |
      | middle_linebacker   | MLB         |

  @idp-positions @linebacker
  Scenario: Track LB-specific statistics
    Given a linebacker is rostered
    When tracking their statistics
    Then LB-relevant stats should be captured
      | stat_category    | stats                           |
      | tackling         | solo, assisted, total, TFL      |
      | coverage         | passes defended, interceptions  |
      | blitzing         | sacks, QB hits, hurries         |

  @idp-positions @defensive-back
  Scenario: Configure defensive back position
    Given IDP positions include defensive backs
    When configuring defensive back (DB)
    Then the position should include
      | sub_position    | designation |
      | cornerback      | CB          |
      | safety          | S           |
      | free_safety     | FS          |
      | strong_safety   | SS          |

  @idp-positions @defensive-back
  Scenario: Track DB-specific statistics
    Given a defensive back is rostered
    When tracking their statistics
    Then DB-relevant stats should be captured
      | stat_category    | stats                           |
      | coverage         | passes defended, interceptions  |
      | tackling         | solo, assisted, total           |
      | playmaking       | INT return yards, touchdowns    |

  @idp-positions @edge-rusher
  Scenario: Configure edge rusher position
    Given leagues use edge rusher designation
    When configuring edge rusher (EDGE)
    Then hybrid pass rushers should be included
    And both DE and OLB edge rushers should qualify

  @idp-positions @edge-rusher
  Scenario: Handle edge rusher eligibility
    Given edge rusher is a hybrid position
    When determining eligibility
    Then players should qualify based on role
    And positional flexibility should be tracked

  @idp-positions @safety
  Scenario: Configure safety position separately
    Given some leagues separate safeties
    When configuring safety (S)
    Then both FS and SS should be included
    And safety-specific scoring should apply

  @idp-positions @safety
  Scenario: Track safety statistics
    Given a safety is rostered
    When tracking their statistics
    Then safety stats should be captured
    And big play potential should be reflected

  @idp-positions @cornerback
  Scenario: Configure cornerback position separately
    Given some leagues separate cornerbacks
    When configuring cornerback (CB)
    Then CB-specific rules should apply
    And coverage statistics should be emphasized

  @idp-positions @cornerback
  Scenario: Value cornerback contributions
    Given cornerbacks have unique value
    When scoring CB performance
    Then pass breakups should be valued
    And shutdown performances should be recognized

  # ==================== IDP Scoring ====================

  @idp-scoring @tackle-scoring
  Scenario: Configure tackle scoring
    Given tackling is the base IDP stat
    When configuring tackle scoring
    Then point values should be set
      | tackle_type      | points |
      | solo_tackle      | 1.0    |
      | assisted_tackle  | 0.5    |
      | tackle_for_loss  | 2.0    |

  @idp-scoring @tackle-scoring
  Scenario: Differentiate tackle types
    Given tackles have different values
    When a player records tackles
    Then tackle types should be distinguished
    And appropriate points should be awarded

  @idp-scoring @sack-scoring
  Scenario: Configure sack scoring
    Given sacks are high-value plays
    When configuring sack scoring
    Then premium points should be assigned
      | sack_type     | points |
      | full_sack     | 4.0    |
      | half_sack     | 2.0    |
      | sack_yards    | 0.1    |

  @idp-scoring @sack-scoring
  Scenario: Credit split sacks correctly
    Given a sack is shared between players
    When awarding sack points
    Then each player should receive half-sack credit
    And total sack points should be divided

  @idp-scoring @interception-scoring
  Scenario: Configure interception scoring
    Given interceptions are game-changing plays
    When configuring INT scoring
    Then high point values should be set
      | int_component    | points |
      | interception     | 6.0    |
      | return_yards     | 0.1    |
      | return_td        | 6.0    |

  @idp-scoring @interception-scoring
  Scenario: Award interception bonus
    Given an interception occurs
    When calculating points
    Then the base INT points should be awarded
    And return yards and TDs should add bonus

  @idp-scoring @forced-fumble-scoring
  Scenario: Configure forced fumble scoring
    Given forced fumbles create turnovers
    When configuring FF scoring
    Then turnover value should be reflected
      | fumble_stat      | points |
      | forced_fumble    | 4.0    |
      | fumble_recovery  | 2.0    |
      | recovery_td      | 6.0    |

  @idp-scoring @forced-fumble-scoring
  Scenario: Differentiate fumble contributions
    Given fumbles involve multiple players
    When crediting fumble plays
    Then forcer and recoverer should both score
    And each contribution should be valued

  @idp-scoring @defensive-td-scoring
  Scenario: Configure defensive touchdown scoring
    Given defensive TDs are rare and valuable
    When configuring TD scoring
    Then maximum points should be awarded
    And TD type should be tracked

  @idp-scoring @defensive-td-scoring
  Scenario: Award defensive touchdown points
    Given a defensive player scores
    When the TD is recorded
    Then full TD points should be awarded
    And the play type should be noted
      | td_type          | points |
      | interception_td  | 6.0    |
      | fumble_return_td | 6.0    |
      | blocked_kick_td  | 6.0    |

  # ==================== IDP Roster Settings ====================

  @idp-roster @roster-slots
  Scenario: Configure IDP roster slots
    Given IDP leagues need roster configuration
    When setting IDP roster slots
    Then position slots should be defined
      | position | slots |
      | DL       | 2     |
      | LB       | 3     |
      | DB       | 2     |
      | IDP_FLEX | 1     |

  @idp-roster @roster-slots
  Scenario: Adjust IDP slot counts
    Given different leagues have different needs
    When modifying IDP slots
    Then flexible configuration should be allowed
    And total IDP slots should update accordingly

  @idp-roster @flex-idp
  Scenario: Configure IDP flex position
    Given flex allows roster flexibility
    When configuring IDP flex
    Then eligible positions should be defined
    And any IDP player should qualify

  @idp-roster @flex-idp
  Scenario: Fill IDP flex optimally
    Given an IDP flex spot is available
    When setting lineup
    Then any IDP position should be startable
    And owners should choose their best option

  @idp-roster @position-requirements
  Scenario: Enforce position requirements
    Given minimum position requirements exist
    When setting lineup
    Then requirements should be enforced
    And incomplete lineups should be flagged

  @idp-roster @position-requirements
  Scenario: Display position requirements
    Given position requirements are configured
    When viewing roster settings
    Then requirements should be clearly displayed
    And compliance status should be shown

  @idp-roster @idp-bench
  Scenario: Configure IDP bench spots
    Given IDP players need bench depth
    When configuring bench
    Then IDP bench spots should be available
    And bench limits should be enforced

  @idp-roster @idp-bench
  Scenario: Manage IDP on bench
    Given IDP players are on the bench
    When managing the roster
    Then bench IDP should be accessible
    And lineup swaps should be easy

  @idp-roster @roster-balance
  Scenario: Balance offensive and defensive rosters
    Given both offense and IDP matter
    When configuring roster balance
    Then appropriate ratio should be set
      | roster_type    | typical_slots |
      | offensive      | 9             |
      | IDP            | 8             |
      | bench          | 7             |

  @idp-roster @roster-balance
  Scenario: Emphasize IDP in IDP-heavy leagues
    Given IDP-heavy leagues exist
    When configuring for IDP emphasis
    Then IDP slots should exceed offensive
    And scoring should reflect importance

  # ==================== IDP Rankings ====================

  @idp-rankings @defensive-player-rankings
  Scenario: Display overall IDP rankings
    Given IDP players have rankings
    When viewing IDP rankings
    Then all defensive players should be ranked
    And ranking methodology should be clear

  @idp-rankings @defensive-player-rankings
  Scenario: Update rankings based on performance
    Given player performance changes
    When rankings are updated
    Then recent performance should be weighted
    And rankings should reflect current value

  @idp-rankings @position-rankings
  Scenario: View position-specific IDP rankings
    Given each IDP position has rankings
    When filtering by position
    Then position-specific rankings should display
      | position | top_ranked_example     |
      | DL       | elite pass rushers     |
      | LB       | high-tackle producers  |
      | DB       | playmaking secondaries |

  @idp-rankings @position-rankings
  Scenario: Compare across IDP positions
    Given rankings exist for all positions
    When comparing positions
    Then cross-position value should be shown
    And positional scarcity should be reflected

  @idp-rankings @idp-tiers
  Scenario: Display IDP tier rankings
    Given players are grouped in tiers
    When viewing tier rankings
    Then tier assignments should be shown
      | tier    | description              |
      | elite   | top 3-5 at position      |
      | strong  | weekly starters          |
      | average | streaming options        |
      | deep    | bye week fills           |

  @idp-rankings @idp-tiers
  Scenario: Identify tier breaks
    Given tiers have meaningful breaks
    When viewing rankings
    Then tier breaks should be highlighted
    And drop-offs should be visible

  @idp-rankings @weekly-rankings
  Scenario: View weekly IDP rankings
    Given matchups affect weekly value
    When viewing weekly rankings
    Then matchup-adjusted rankings should display
    And weekly upside should be considered

  @idp-rankings @weekly-rankings
  Scenario: Project weekly IDP performance
    Given weekly projections drive rankings
    When generating weekly ranks
    Then matchup data should be incorporated
    And game script should be considered

  @idp-rankings @season-rankings
  Scenario: View season-long IDP rankings
    Given season value differs from weekly
    When viewing season rankings
    Then full-season value should be shown
    And consistency should be factored

  @idp-rankings @season-rankings
  Scenario: Project rest of season value
    Given the season is in progress
    When projecting ROS rankings
    Then remaining schedule should be analyzed
    And injury risk should be considered

  # ==================== IDP Stats ====================

  @idp-stats @defensive-statistics
  Scenario: Track comprehensive defensive stats
    Given IDP requires detailed stats
    When tracking player statistics
    Then all defensive stats should be captured
    And stats should update in real-time

  @idp-stats @defensive-statistics
  Scenario: Display defensive stat categories
    Given defensive stats are varied
    When viewing player stats
    Then categories should be organized
      | category        | stats_included                    |
      | tackling        | solo, assisted, total, TFL, stuff |
      | pass_rush       | sacks, QB hits, hurries, pressures|
      | coverage        | PD, INT, targets, completions     |
      | turnovers       | FF, FR, INT, fumble TD, INT TD    |

  @idp-stats @tackle-stats
  Scenario: Track detailed tackle statistics
    Given tackling is the core IDP stat
    When tracking tackles
    Then tackle breakdown should be available
    And tackle quality should be measured

  @idp-stats @tackle-stats
  Scenario: Measure tackling efficiency
    Given tackling quality varies
    When analyzing tackle stats
    Then missed tackles should be tracked
    And tackle rate should be calculated

  @idp-stats @turnover-stats
  Scenario: Track turnover statistics
    Given turnovers are high-value
    When tracking turnover stats
    Then all turnover types should be captured
    And turnover rate should be calculated

  @idp-stats @turnover-stats
  Scenario: Display turnover opportunities
    Given turnovers have opportunity component
    When viewing turnover stats
    Then opportunities should be shown
    And conversion rate should be calculated

  @idp-stats @big-play-stats
  Scenario: Track big play statistics
    Given big plays impact games
    When tracking big play stats
    Then impactful plays should be identified
      | big_play_type    | definition           |
      | sack             | quarterback takedown |
      | TFL              | tackle behind line   |
      | interception     | caught pass          |
      | forced_fumble    | stripped ball        |
      | defensive_TD     | score on defense     |

  @idp-stats @big-play-stats
  Scenario: Calculate big play rate
    Given big plays are tracked
    When analyzing player value
    Then big play rate should be computed
    And ceiling potential should be shown

  @idp-stats @snap-counts
  Scenario: Track defensive snap counts
    Given playing time affects production
    When tracking snap counts
    Then defensive snaps should be recorded
    And snap percentage should be calculated

  @idp-stats @snap-counts
  Scenario: Analyze snap count trends
    Given snap counts indicate opportunity
    When viewing snap trends
    Then week-over-week changes should be shown
    And role changes should be identified

  # ==================== IDP Drafting ====================

  @idp-drafting @draft-strategy
  Scenario: Apply IDP draft strategy
    Given IDP drafting requires strategy
    When preparing for draft
    Then IDP strategy should be developed
    And position priorities should be set

  @idp-drafting @draft-strategy
  Scenario: Balance IDP with offensive picks
    Given both sides matter in IDP leagues
    When drafting
    Then balance should be maintained
    And value should drive decisions

  @idp-drafting @position-value
  Scenario: Assess IDP position value
    Given positions have different values
    When evaluating IDP positions
    Then relative value should be displayed
      | position | typical_value | scarcity |
      | LB       | highest       | medium   |
      | DL       | medium        | low      |
      | DB       | lower         | high     |

  @idp-drafting @position-value
  Scenario: Identify positional advantages
    Given certain positions score more
    When comparing positions
    Then scoring potential should be shown
    And replacement value should be calculated

  @idp-drafting @idp-adp
  Scenario: Display IDP average draft position
    Given ADP guides draft decisions
    When viewing IDP ADP
    Then current ADP should be shown
    And trends should be visible

  @idp-drafting @idp-adp
  Scenario: Compare player ADP to value
    Given ADP doesn't equal value
    When analyzing draft targets
    Then value vs ADP should be displayed
    And bargains should be identified

  @idp-drafting @rookie-idp
  Scenario: Evaluate rookie IDP players
    Given rookies enter the league annually
    When evaluating rookie IDPs
    Then college production should be shown
    And NFL role projection should be available

  @idp-drafting @rookie-idp
  Scenario: Project rookie IDP impact
    Given rookie impact varies
    When projecting rookies
    Then expected role should be considered
    And opportunity should be factored

  @idp-drafting @sleeper-picks
  Scenario: Identify IDP sleeper picks
    Given sleepers provide value
    When identifying sleepers
    Then undervalued players should be flagged
    And sleeper reasons should be provided

  @idp-drafting @sleeper-picks
  Scenario: Target late-round IDP value
    Given late rounds offer upside
    When drafting late
    Then upside targets should be identified
    And breakout candidates should be shown

  # ==================== IDP Waivers ====================

  @idp-waivers @waiver-wire
  Scenario: Browse IDP waiver wire
    Given waiver options exist
    When viewing IDP waivers
    Then available IDP players should be listed
    And relevant stats should be displayed

  @idp-waivers @waiver-wire
  Scenario: Filter IDP waiver options
    Given many IDPs are available
    When filtering waivers
    Then position filters should work
    And stat thresholds should be available

  @idp-waivers @streaming-defense
  Scenario: Stream IDP players
    Given streaming is viable for IDP
    When identifying streaming options
    Then matchup-based recommendations should appear
    And weekly streamers should be highlighted

  @idp-waivers @streaming-defense
  Scenario: Identify streaming candidates
    Given certain IDPs are matchup-dependent
    When finding streaming plays
    Then favorable matchups should be identified
    And expected production should be projected

  @idp-waivers @waiver-priorities
  Scenario: Set IDP waiver priorities
    Given waiver order matters
    When prioritizing IDP claims
    Then priority rankings should be created
    And claim order should be set

  @idp-waivers @waiver-priorities
  Scenario: Recommend waiver priorities
    Given many options exist
    When viewing waiver recommendations
    Then priority-ordered suggestions should appear
    And reasoning should be provided

  @idp-waivers @adds-drops
  Scenario: Add IDP from waivers
    Given an IDP is available
    When adding to roster
    Then the add should process
    And roster should update

  @idp-waivers @adds-drops
  Scenario: Drop IDP player
    Given an IDP needs to be dropped
    When processing the drop
    Then the player should be released
    And roster spot should be freed

  @idp-waivers @waiver-strategy
  Scenario: Apply IDP waiver strategy
    Given waiver strategy improves teams
    When managing waivers
    Then strategic guidance should be available
    And FAAB recommendations should be provided

  @idp-waivers @waiver-strategy
  Scenario: Evaluate waiver spending
    Given FAAB is limited
    When deciding on spending
    Then value assessments should be shown
    And budget management should be considered

  # ==================== IDP Matchups ====================

  @idp-matchups @matchup-analysis
  Scenario: Analyze defensive matchups
    Given matchups affect IDP production
    When analyzing matchups
    Then opponent tendencies should be shown
    And matchup grades should be assigned

  @idp-matchups @matchup-analysis
  Scenario: Display matchup factors
    Given multiple factors affect matchups
    When viewing matchup details
    Then relevant factors should be shown
      | factor              | impact_on                   |
      | opponent_pass_rate  | DB/pass_rusher opportunity  |
      | opponent_run_rate   | LB/DL tackle opportunity    |
      | pace_of_play        | overall snap opportunity    |
      | scoring_environment | game script impact          |

  @idp-matchups @favorable-matchups
  Scenario: Identify favorable matchups
    Given some matchups are advantageous
    When viewing favorable matchups
    Then good matchups should be highlighted
    And expected boost should be quantified

  @idp-matchups @favorable-matchups
  Scenario: Rank matchups by favorability
    Given matchups can be compared
    When ranking matchups
    Then matchups should be ordered
    And matchup tier should be shown

  @idp-matchups @target-analysis
  Scenario: Analyze opposing target distribution
    Given targets affect DB value
    When analyzing target distribution
    Then receiver matchups should be shown
    And target opportunity should be projected

  @idp-matchups @target-analysis
  Scenario: Project coverage opportunities
    Given DBs benefit from targets
    When projecting coverage
    Then expected coverage snaps should be shown
    And turnover opportunity should be calculated

  @idp-matchups @game-script-impact
  Scenario: Consider game script impact
    Given game script affects defense
    When projecting performance
    Then game script should be factored
    And situational value should be shown

  @idp-matchups @game-script-impact
  Scenario: Project game script scenarios
    Given games unfold differently
    When modeling scenarios
    Then different scripts should be projected
    And impact on IDPs should be shown

  @idp-matchups @matchup-rankings
  Scenario: Generate matchup rankings
    Given matchups need rankings
    When generating matchup ranks
    Then all matchups should be ranked
    And rankings should be position-specific

  @idp-matchups @matchup-rankings
  Scenario: Display weekly matchup rankings
    Given matchups change weekly
    When viewing weekly rankings
    Then current week matchups should be ranked
    And historical accuracy should be tracked

  # ==================== IDP Projections ====================

  @idp-projections @weekly-projections
  Scenario: Generate weekly IDP projections
    Given weekly projections guide decisions
    When generating projections
    Then IDP projections should be created
    And projection methodology should be transparent

  @idp-projections @weekly-projections
  Scenario: Display weekly projection breakdown
    Given projections have components
    When viewing projection details
    Then stat-by-stat projections should be shown
    And total points should be calculated

  @idp-projections @season-projections
  Scenario: Generate season-long IDP projections
    Given season projections aid drafts
    When generating season projections
    Then full-season projections should be created
    And games played should be estimated

  @idp-projections @season-projections
  Scenario: Update season projections
    Given projections need updating
    When the season progresses
    Then projections should be updated
    And changes should be highlighted

  @idp-projections @rest-of-season
  Scenario: Generate rest of season projections
    Given ROS projections matter mid-season
    When generating ROS projections
    Then remaining schedule should be analyzed
    And ROS value should be calculated

  @idp-projections @rest-of-season
  Scenario: Compare current to ROS rankings
    Given rankings shift during season
    When comparing rankings
    Then current vs ROS should be shown
    And major differences should be highlighted

  @idp-projections @projection-accuracy
  Scenario: Track projection accuracy
    Given accuracy builds trust
    When evaluating projections
    Then accuracy metrics should be tracked
    And historical performance should be shown

  @idp-projections @projection-accuracy
  Scenario: Improve projections over time
    Given accuracy can improve
    When refining projection models
    Then feedback should be incorporated
    And accuracy should trend upward

  @idp-projections @projection-sources
  Scenario: Display projection sources
    Given multiple sources project IDPs
    When viewing projections
    Then source should be identified
    And consensus should be available

  @idp-projections @projection-sources
  Scenario: Compare projection sources
    Given sources differ
    When comparing projections
    Then source-by-source comparison should be shown
    And variance should be displayed

  # ==================== IDP Leagues ====================

  @idp-leagues @league-setup
  Scenario: Set up IDP league
    Given a new IDP league is created
    When configuring the league
    Then IDP-specific settings should be available
    And setup wizard should guide configuration

  @idp-leagues @league-setup
  Scenario: Choose IDP league type
    Given different IDP league types exist
    When selecting type
    Then options should be presented
      | league_type     | IDP_emphasis |
      | IDP_lite        | 3-5 IDP      |
      | balanced        | 7-9 IDP      |
      | IDP_heavy       | 11+ IDP      |
      | all_IDP         | defense only |

  @idp-leagues @scoring-configurations
  Scenario: Configure IDP scoring system
    Given scoring drives strategy
    When configuring IDP scoring
    Then all IDP stats should be configurable
    And presets should be available

  @idp-leagues @scoring-configurations
  Scenario: Save custom scoring configuration
    Given custom scoring is set
    When saving configuration
    Then settings should be preserved
    And the configuration should be reusable

  @idp-leagues @balanced-scoring
  Scenario: Implement balanced IDP scoring
    Given balanced scoring improves gameplay
    When setting balanced scoring
    Then IDP and offense should have similar value
    And scoring should be proportional

  @idp-leagues @balanced-scoring
  Scenario: Verify scoring balance
    Given balance is configured
    When analyzing scoring distribution
    Then IDP percentage should be appropriate
    And no side should dominate unfairly

  @idp-leagues @idp-heavy-leagues
  Scenario: Configure IDP-heavy league
    Given some leagues emphasize IDP
    When setting up IDP-heavy league
    Then IDP roster slots should be expanded
    And IDP scoring should be elevated

  @idp-leagues @idp-heavy-leagues
  Scenario: Adjust strategy for IDP-heavy
    Given IDP emphasis changes strategy
    When playing in IDP-heavy league
    Then IDP draft priority should increase
    And IDP waiver activity should be higher

  @idp-leagues @hybrid-leagues
  Scenario: Configure hybrid IDP league
    Given hybrid leagues combine formats
    When setting up hybrid league
    Then both team DST and IDP should be used
    And settings should accommodate both

  @idp-leagues @hybrid-leagues
  Scenario: Balance hybrid scoring
    Given hybrid has both defense types
    When configuring scoring
    Then DST and IDP should be balanced
    And neither should be redundant
