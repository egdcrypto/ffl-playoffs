@backend @priority_2 @tutorials
Feature: Tutorials System
  As a fantasy football playoffs user
  I want access to comprehensive tutorials and learning resources
  So that I can understand how to play effectively and maximize my playoff experience

  Background:
    Given I am a registered user
    And the tutorials system is available

  # ==================== INTERACTIVE TUTORIALS ====================

  Scenario: Start an interactive tutorial for first-time users
    Given I am a new user who has never completed any tutorials
    When I access the tutorial section
    Then I am presented with the "Getting Started" interactive tutorial
    And the tutorial includes step-by-step instructions
    And each step requires my interaction before proceeding
    And my progress is saved automatically

  Scenario: Complete an interactive tutorial step
    Given I am in an interactive tutorial "Setting Your Lineup"
    And I am on step 3 of 8
    And the step requires me to select a player
    When I select a player as instructed
    Then the tutorial validates my action
    And I am advanced to step 4
    And a checkmark appears next to the completed step

  Scenario: Retry a failed interactive tutorial step
    Given I am in an interactive tutorial "Making a Trade"
    And I performed the wrong action on the current step
    When the tutorial detects the incorrect action
    Then I receive a helpful hint about what went wrong
    And I am given the option to retry the step
    And my progress on previous steps is maintained

  Scenario: Skip an interactive tutorial
    Given I am in an interactive tutorial "Draft Strategy Basics"
    And I am an experienced user who understands the content
    When I click the "Skip Tutorial" button
    Then I am asked to confirm skipping
    And upon confirmation the tutorial is marked as skipped
    And I can return to it later if desired

  Scenario: Resume an interrupted interactive tutorial
    Given I previously started the tutorial "Roster Management"
    And I completed 5 of 10 steps before leaving
    When I return to the tutorials section
    Then I see the option to "Resume" the tutorial
    And clicking resume takes me to step 6
    And all previous progress is preserved

  # ==================== VIDEO TUTORIALS ====================

  Scenario: Browse video tutorial library
    Given I am in the tutorials section
    When I select "Video Tutorials"
    Then I see a library of video tutorials organized by category:
      | Category        | Count |
      | Getting Started | 5     |
      | Draft Strategy  | 8     |
      | Trading         | 6     |
      | Lineup Tips     | 7     |
      | Playoffs        | 10    |
    And each video shows its duration and difficulty level

  Scenario: Watch a video tutorial
    Given I am viewing the video tutorial "Understanding PPR Scoring"
    When I click play on the video
    Then the video plays in an embedded player
    And I can pause, rewind, and fast-forward
    And I can toggle fullscreen mode
    And my watch progress is tracked

  Scenario: Resume watching a video tutorial
    Given I previously watched 3 minutes of the 10-minute video "Draft Day Preparation"
    When I return to that video tutorial
    Then the video resumes from where I left off
    And I see a "Start Over" option if I prefer

  Scenario: View video tutorial transcript
    Given I am watching the video "Trade Negotiation Tips"
    When I click on "View Transcript"
    Then a text transcript appears alongside the video
    And the transcript highlights the current spoken section
    And I can click on transcript sections to jump to that point

  Scenario: Rate a video tutorial
    Given I completed watching the video "Playoff Bracket Strategy"
    When I am prompted to rate the video
    Then I can select a rating from 1 to 5 stars
    And I can optionally leave a written review
    And my feedback is submitted for quality improvement

  Scenario: Filter video tutorials by difficulty
    Given I am in the video tutorials section
    When I filter by difficulty level "Advanced"
    Then only videos tagged as "Advanced" are displayed
    And videos for "Beginner" and "Intermediate" are hidden

  # ==================== GUIDED WALKTHROUGHS ====================

  Scenario: Access guided walkthrough for a feature
    Given I am on the roster management page
    And I have not used this feature before
    When I click the "Take a Tour" button
    Then a guided walkthrough overlay appears
    And the first element is highlighted with an explanation tooltip
    And I see navigation controls to proceed through the tour

  Scenario: Navigate through guided walkthrough steps
    Given I am in a guided walkthrough of the "Trade Center"
    And I am viewing step 2 of 6
    When I click "Next"
    Then the highlight moves to the next UI element
    And the explanation tooltip updates
    And the step indicator shows "3 of 6"

  Scenario: Exit guided walkthrough early
    Given I am in a guided walkthrough of the "Scoring Settings"
    When I click the "Exit Tour" button
    Then the walkthrough overlay is dismissed
    And I can interact with the page normally
    And the walkthrough is marked as incomplete

  Scenario: Trigger contextual guided help
    Given I am on a feature page for the first time
    And I appear confused (no actions for 30 seconds)
    When the system detects potential confusion
    Then a subtle prompt appears offering guided help
    And I can accept or dismiss the offer
    And declining is remembered for that feature

  Scenario: Complete guided walkthrough and earn badge
    Given I am in the guided walkthrough "Understanding Your Dashboard"
    And I am on the final step
    When I click "Finish Tour"
    Then I receive a completion notification
    And I earn the "Dashboard Explorer" badge
    And the walkthrough is marked as completed in my profile

  # ==================== BEGINNER GUIDES ====================

  Scenario: Access beginner's guide for new users
    Given I am a new user who just registered
    When I access the tutorials section
    Then I see a prominent "Beginner's Guide" section
    And it contains fundamental topics:
      | Topic                        | Estimated Time |
      | What is Fantasy Football?    | 5 min          |
      | How Playoffs Work            | 8 min          |
      | Building Your First Roster   | 10 min         |
      | Scoring Basics               | 7 min          |
      | Making Your First Trade      | 6 min          |

  Scenario: Complete beginner's guide chapter
    Given I am reading the beginner's guide chapter "Scoring Basics"
    When I finish reading and click "Mark as Complete"
    Then the chapter is marked with a checkmark
    And I am taken to the next chapter
    And my overall beginner's guide progress updates

  Scenario: Take beginner's guide quiz
    Given I completed the chapter "How Playoffs Work"
    When I am presented with a 5-question quiz
    Then I answer questions about playoff concepts
    And upon completion I see my score
    And incorrect answers show the correct explanation
    And passing unlocks the next section

  Scenario: Access beginner's glossary
    Given I am reading any tutorial content
    When I encounter a highlighted term like "PPR"
    Then I can hover or click to see the definition
    And the glossary entry includes:
      | Term       | PPR                                |
      | Definition | Points Per Reception scoring       |
      | Example    | Each catch = 1 additional point    |
      | Related    | Standard Scoring, Half-PPR         |

  Scenario: Track beginner's guide completion
    Given I am progressing through the beginner's guide
    When I view my profile
    Then I see a progress bar for the beginner's guide
    And it shows "3 of 5 chapters complete (60%)"
    And completing all chapters awards a "Rookie Graduate" badge

  # ==================== ADVANCED TUTORIALS ====================

  Scenario: Access advanced strategy tutorials
    Given I have completed the beginner's guide
    When I navigate to "Advanced Tutorials"
    Then I see advanced topics:
      | Topic                           | Prerequisite           |
      | Advanced Trade Analytics        | Basic Trading Complete |
      | Matchup Exploitation            | Playoffs Basics        |
      | Tiebreaker Optimization         | Scoring Basics         |
      | Multi-Week Strategy Planning    | Roster Management      |
      | Statistical Analysis Deep Dive  | Scoring Advanced       |

  Scenario: View advanced tutorial with prerequisite not met
    Given I have not completed "Basic Trading"
    When I try to access "Advanced Trade Analytics"
    Then I see a message that prerequisites are required
    And I see a link to the prerequisite tutorial
    And I can request to skip prerequisites if desired

  Scenario: Access advanced data analysis tutorial
    Given I am in the "Statistical Analysis Deep Dive" tutorial
    When I view the content
    Then I see advanced concepts like:
      | Topic                         |
      | Variance and standard deviation |
      | Expected value calculations    |
      | Regression analysis for players|
      | Monte Carlo simulations        |
    And each concept includes practical examples

  Scenario: Practice advanced concepts in sandbox
    Given I am in an advanced tutorial "Matchup Exploitation"
    When I reach the practice section
    Then I can access a sandbox environment
    And I can experiment with different strategies
    And the sandbox uses historical data
    And my actions don't affect my real roster

  Scenario: Earn advanced certification
    Given I completed all advanced tutorials in a category
    When I pass the final comprehensive assessment
    Then I earn the "Strategy Master" certification
    And the certification is displayed on my public profile
    And I unlock exclusive advanced features

  # ==================== DRAFT TUTORIALS ====================

  Scenario: Access draft preparation tutorial
    Given the draft is 5 days away
    When I access draft tutorials
    Then I see topics including:
      | Topic                         | Duration |
      | Draft Day Preparation         | 15 min   |
      | Reading Draft Rankings        | 10 min   |
      | Mock Draft Practice           | 20 min   |
      | Positional Value Strategy     | 12 min   |
      | Late Round Sleepers           | 8 min    |

  Scenario: Complete mock draft tutorial
    Given I am in the "Mock Draft Practice" tutorial
    When I start the mock draft simulation
    Then I practice drafting against AI opponents
    And I receive real-time feedback on my picks
    And the tutorial explains why picks are good or bad
    And I can restart with different draft positions

  Scenario: Learn draft position strategies
    Given I have draft position 8 of 10
    When I access the "Position-Based Strategy" tutorial
    Then I see strategies specific to my draft position:
      | Strategy               | Explanation                           |
      | Best Player Available  | Focus on value over position need     |
      | RB Heavy               | Secure running backs in early rounds  |
      | Zero RB                | Wait on RBs, load up on WRs early     |
      | Balanced Approach      | Alternate positions strategically     |

  Scenario: Receive draft reminder with tutorial link
    Given the draft is in 24 hours
    And I haven't completed draft tutorials
    When I receive a notification
    Then the notification suggests completing draft tutorials
    And it links directly to the draft preparation content
    And it shows estimated time to complete

  Scenario: Review draft performance tutorial
    Given the draft has completed
    When I access post-draft tutorials
    Then I can review my draft with analysis:
      | Section              | Content                              |
      | Draft Grade          | Overall assessment of picks          |
      | Best Picks           | Highlight value selections           |
      | Missed Opportunities | Players you could have drafted       |
      | Improvement Tips     | Suggestions for next time            |

  # ==================== TRADE TUTORIALS ====================

  Scenario: Access trade negotiation tutorial
    Given I am in the trading section
    When I click "Learn How to Trade"
    Then I am taken to trade tutorials including:
      | Topic                       | Level        |
      | Trade Basics                | Beginner     |
      | Evaluating Trade Value      | Intermediate |
      | Negotiation Tactics         | Intermediate |
      | Identifying Trade Targets   | Advanced     |
      | Multi-Player Trades         | Advanced     |

  Scenario: Use trade value calculator tutorial
    Given I am in the "Evaluating Trade Value" tutorial
    When I reach the calculator section
    Then I learn how to use the trade value calculator
    And I can practice with sample trades
    And the tutorial explains the underlying methodology
    And I can compare pre and post-trade roster strength

  Scenario: Practice trade proposals in simulation
    Given I am in the trade tutorial simulation mode
    When I create a practice trade proposal
    Then the AI evaluates my proposal
    And provides feedback on fairness:
      | Trade Aspect    | Feedback                              |
      | Value Balance   | Slightly favors the other team        |
      | Position Needs  | Addresses your WR weakness            |
      | Timing          | Good timing, playoffs approaching     |
      | Counter Offer   | Suggested improvement to your offer   |

  Scenario: Learn to identify trade targets
    Given I am in the "Identifying Trade Targets" tutorial
    When I view the content
    Then I learn strategies including:
      | Strategy                      |
      | Finding undervalued players   |
      | Targeting teams with roster holes |
      | Buy-low opportunities         |
      | Sell-high candidates          |
      | Playoff schedule analysis     |

  Scenario: Understand trade deadlines tutorial
    Given the trade deadline is approaching
    When I access trade deadline tutorial
    Then I learn about deadline strategies:
      | Topic                              |
      | Making deadline decisions          |
      | Last-minute trade opportunities    |
      | Post-deadline roster adjustments   |

  # ==================== LINEUP TUTORIALS ====================

  Scenario: Access weekly lineup tutorial
    Given it is Tuesday before the playoff games
    When I access lineup tutorials
    Then I see weekly lineup topics:
      | Topic                           | Relevance          |
      | Setting Your Optimal Lineup     | This week's guide  |
      | Matchup Analysis                | Current opponents  |
      | Injury Report Impact            | Latest updates     |
      | Weather Considerations          | Game-time factors  |
      | Start/Sit Decisions             | Position-specific  |

  Scenario: Use start/sit decision tutorial
    Given I am unsure whether to start player A or player B
    When I access the "Start/Sit Decisions" tutorial
    Then I learn decision-making factors:
      | Factor                  | Weight |
      | Historical performance  | High   |
      | Opponent matchup        | High   |
      | Recent form             | Medium |
      | Weather conditions      | Medium |
      | Expert consensus        | Medium |

  Scenario: Learn about position-specific lineup strategies
    Given I am in the lineup tutorials
    When I select "Flex Position Strategy"
    Then I learn about flex decisions:
      | Concept                               |
      | RB vs WR vs TE in flex               |
      | Ceiling vs floor considerations       |
      | Game script predictions               |
      | Correlation with other starters       |

  Scenario: Practice lineup optimization in simulator
    Given I am in lineup tutorial simulator mode
    When I set a practice lineup
    Then the tutorial evaluates my choices
    And shows projected points with explanations
    And suggests alternatives with reasoning
    And I can compare multiple lineup configurations

  Scenario: Receive pre-game lineup tutorial tips
    Given my lineup is set but contains risky choices
    And games start in 4 hours
    When I receive a notification
    Then the notification highlights concerns:
      | Concern                     | Suggestion                    |
      | Player questionable status  | Monitor and have backup ready |
      | Bad weather expected        | Consider pivot options        |
      | Suboptimal matchup          | Review alternatives           |

  # ==================== PLAYOFFS TUTORIALS ====================

  Scenario: Access playoffs-specific strategy tutorials
    Given playoffs are 2 weeks away
    When I access playoff tutorials
    Then I see playoff-specific content:
      | Topic                              | Priority |
      | Playoff Bracket Explained          | High     |
      | Survival Strategy                  | High     |
      | Week-to-Week Planning              | Medium   |
      | Championship Path Analysis         | Medium   |
      | Managing Elimination Risk          | High     |

  Scenario: Learn bracket navigation strategy
    Given I am in the playoff bracket tutorial
    When I study bracket progression
    Then I learn concepts including:
      | Concept                                  |
      | Understanding matchup implications       |
      | Planning for multiple scenarios          |
      | When to play safe vs take risks          |
      | Evaluating opponent rosters              |

  Scenario: Complete playoff scenario analysis tutorial
    Given I am in the "Managing Elimination Risk" tutorial
    When I view the interactive scenario section
    Then I analyze different playoff scenarios:
      | Scenario                  | Strategy Recommendation        |
      | Must-win matchup          | Play high-ceiling players      |
      | Comfortable lead          | Prioritize consistent players  |
      | Down significantly        | Take calculated risks          |
      | Close matchup             | Balance floor and ceiling      |

  Scenario: Learn Super Bowl preparation tutorial
    Given I advanced to the championship round
    When I access championship tutorials
    Then I see specialized content:
      | Topic                                |
      | Championship roster optimization     |
      | One-week playoff strategy            |
      | Pressure management                  |
      | Maximizing your championship odds    |

  Scenario: Access post-playoffs review tutorial
    Given the playoffs have ended
    When I access post-season tutorials
    Then I can review my playoff performance:
      | Section                     | Content                        |
      | Season Recap                | How you performed overall      |
      | Key Decisions Analysis      | Right and wrong choices        |
      | Lessons Learned             | Improvement areas              |
      | Preparing for Next Season   | Off-season to-do list          |

  # ==================== TUTORIAL PROGRESS TRACKING ====================

  Scenario: View overall tutorial progress dashboard
    Given I have completed some tutorials
    When I access my tutorial progress dashboard
    Then I see comprehensive progress information:
      | Category          | Completed | Total | Percentage |
      | Beginner Guide    | 5         | 5     | 100%       |
      | Draft Tutorials   | 3         | 5     | 60%        |
      | Trade Tutorials   | 2         | 5     | 40%        |
      | Lineup Tutorials  | 4         | 5     | 80%        |
      | Playoff Tutorials | 1         | 5     | 20%        |
      | Advanced          | 0         | 5     | 0%         |

  Scenario: Track tutorial completion milestones
    Given I complete a major tutorial section
    When I finish all "Draft Tutorials"
    Then I receive a completion notification
    And I earn the "Draft Expert" milestone badge
    And my profile shows the achievement date
    And I unlock related advanced content

  Scenario: View tutorial learning path
    Given I am new to the platform
    When I view my recommended learning path
    Then I see a structured progression:
      | Phase | Focus Area          | Tutorials     | Status     |
      | 1     | Getting Started     | 3 tutorials   | Complete   |
      | 2     | Core Concepts       | 5 tutorials   | In Progress|
      | 3     | Strategy Building   | 8 tutorials   | Locked     |
      | 4     | Advanced Mastery    | 10 tutorials  | Locked     |

  Scenario: Reset tutorial progress
    Given I want to retake tutorials from the beginning
    When I click "Reset Progress" for a category
    Then I am asked to confirm the reset
    And upon confirmation all progress in that category is cleared
    And my earned badges for that category are retained

  Scenario: Share tutorial progress on profile
    Given I have completed 85% of all tutorials
    When I enable "Show Tutorial Progress" on my profile
    Then other users can see my tutorial achievements
    And they see my earned badges
    And they see my completion statistics

  Scenario: Receive tutorial recommendations based on activity
    Given I recently struggled with lineup decisions
    When I access the tutorials section
    Then I see personalized recommendations:
      | Recommendation                     | Reason                        |
      | Start/Sit Decision Making          | Based on recent lineups       |
      | Matchup Analysis Deep Dive         | Improve your weekly decisions |
      | Flex Position Optimization         | You often change flex spot    |

  Scenario: Export tutorial completion certificate
    Given I completed all tutorials in a category
    When I request a completion certificate
    Then a PDF certificate is generated with:
      | Field               | Value                        |
      | Name                | My username                  |
      | Category            | Draft Strategy Master        |
      | Completion Date     | Current date                 |
      | Tutorials Completed | List of all tutorials        |
      | Badge Earned        | Category badge image         |

  # ==================== TUTORIAL CONTENT MANAGEMENT ====================

  Scenario: Bookmark a tutorial for later
    Given I am viewing a tutorial "Advanced Trade Analytics"
    When I click the bookmark icon
    Then the tutorial is added to my bookmarks
    And I can access it later from "My Bookmarks"
    And the bookmark includes my current position

  Scenario: Search for tutorials by keyword
    Given I am looking for tutorials about "scoring"
    When I search for "scoring" in the tutorials section
    Then I see all tutorials mentioning scoring:
      | Tutorial                      | Category       |
      | Scoring Basics                | Beginner       |
      | Understanding PPR Scoring     | Beginner       |
      | Scoring Optimization          | Advanced       |
      | Bonus Point Strategies        | Intermediate   |

  Scenario: View recently accessed tutorials
    Given I have accessed multiple tutorials this week
    When I view "Recent Tutorials"
    Then I see my recently accessed tutorials:
      | Tutorial                  | Last Accessed    | Progress |
      | Draft Strategy Basics     | Today            | 100%     |
      | Trade Value Calculator    | Yesterday        | 75%      |
      | Playoff Survival Guide    | 3 days ago       | 50%      |

  Scenario: Rate and review a tutorial
    Given I completed the tutorial "Matchup Analysis"
    When I am prompted to provide feedback
    Then I can rate the tutorial from 1 to 5 stars
    And I can indicate if it was helpful
    And I can suggest improvements
    And my feedback is submitted anonymously

  # ==================== ERROR HANDLING ====================

  Scenario: Handle tutorial content unavailable
    Given I try to access a tutorial that is temporarily unavailable
    When the system cannot load the content
    Then I see a friendly error message
    And I am offered alternative related tutorials
    And I can report the issue

  Scenario: Handle video playback failure
    Given I am watching a video tutorial
    When the video fails to load or play
    Then I see a video unavailable message
    And I am offered to:
      | Option                              |
      | Try again                           |
      | Download video for offline viewing  |
      | View transcript instead             |
      | Report the issue                    |

  Scenario: Handle incomplete tutorial data save
    Given I completed a tutorial step
    When the progress fails to save
    Then I see a save failure notification
    And the system automatically retries
    And if retry fails, I can manually save progress
    And my local progress is preserved
