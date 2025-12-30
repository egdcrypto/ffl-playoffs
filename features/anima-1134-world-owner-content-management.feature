@world @content @cms @management
Feature: World Owner Content Management
  As a world owner
  I want to manage all content in my world
  So that I can create rich and engaging experiences

  Background:
    Given I am logged in as the owner of "Epic Fantasy Realm"
    And I have content management permissions
    And my world contains various entities and content
    And the content management system is operational

  # ===========================================================================
  # CONTENT OVERVIEW DASHBOARD
  # ===========================================================================

  @api @content @dashboard
  Scenario: View content dashboard overview
    Given my world has diverse content types
    When I navigate to content management
    Then I should see a response with status 200
    And I should see content overview:
      | content_type  | count | published | draft | review | archived |
      | stories       | 45    | 40        | 3     | 2      | 0        |
      | dialogues     | 230   | 200       | 15    | 10     | 5        |
      | descriptions  | 180   | 175       | 5     | 0      | 0        |
      | tutorials     | 12    | 12        | 0     | 0      | 0        |
      | announcements | 25    | 20        | 2     | 3      | 0        |
    And I should see recent content activity feed
    And I should see content needing review highlighted
    And I should see content health metrics

  @api @content @dashboard
  Scenario: View content by status
    Given I want to find draft content
    When I filter content by status "draft"
    Then I should see all draft content:
      | title               | type      | author      | last_modified    |
      | New Quest Intro     | story     | AuthorAlice | 2024-12-28 10:00 |
      | Dragon Dialogue     | dialogue  | AuthorBob   | 2024-12-27 15:30 |
      | Temple Description  | desc      | AuthorAlice | 2024-12-26 09:00 |
    And I should see author for each item
    And I should see last modified date
    And I should see quick publish options

  @api @content @dashboard
  Scenario: Search content
    Given I am looking for specific content
    When I search for "dragon"
    Then I should see matching content:
      | title                  | type     | match_in      |
      | Dragon's Lair Quest    | story    | title         |
      | Talk to Dragon         | dialogue | title         |
      | Ancient Dragon Lore    | desc     | body          |
    And results should be ranked by relevance
    And I should be able to filter search results
    And I should see content preview snippets

  @api @content @dashboard
  Scenario: View content health metrics
    Given content quality is being monitored
    When I view content health dashboard
    Then I should see health metrics:
      | metric                | value    | status  |
      | average_word_count    | 245      | good    |
      | broken_links          | 5        | warning |
      | missing_translations  | 45       | warning |
      | stale_content         | 12       | info    |
      | policy_violations     | 0        | good    |
    And I should see improvement suggestions
    And I should see health score trend

  # ===========================================================================
  # CONTENT CREATION
  # ===========================================================================

  @api @content @create
  Scenario: Create new content from template
    Given content templates are available
    When I create content from template:
      | field        | value               |
      | template     | Quest Dialogue      |
      | name         | Dragon's Challenge  |
      | category     | Main Story          |
      | language     | English             |
    Then content should be created as draft
    And template structure should be applied:
      | section        | placeholder_text              |
      | introduction   | Enter quest introduction...   |
      | main_dialogue  | Enter main dialogue...        |
      | conclusion     | Enter conclusion...           |
    And I should be in edit mode
    And a ContentCreated event should be published

  @api @content @create
  Scenario: Create content with rich text
    Given I am creating new story content
    When I create rich text content:
      | field        | value                           |
      | title        | Ancient Prophecy                |
      | body         | In times of darkness...         |
      | formatting   | headers, lists, emphasis, links |
      | media        | prophecy_scroll.png             |
    Then content should preserve all formatting
    And media should be embedded inline
    And preview should render correctly
    And content should be validated for structure

  @api @content @create
  Scenario: Create branching dialogue tree
    Given I am creating interactive dialogue
    When I create branching dialogue:
      | node_id  | text                     | options                      |
      | start    | Greetings traveler       | ask_quest, ask_shop, goodbye |
      | ask_quest| I have a task for you    | accept, decline, more_info   |
      | accept   | Excellent! Here's the map| end                          |
      | decline  | Perhaps another time     | end                          |
      | ask_shop | Browse my wares          | buy, sell, goodbye           |
    Then dialogue tree should be created
    And branches should be navigable in editor
    And I should see visual dialogue tree preview
    And orphaned nodes should be highlighted
    And a DialogueCreated event should be published

  @api @content @create
  Scenario: Create content with variables
    Given I want to create dynamic content
    When I create content with variables:
      | variable          | type    | default       |
      | {player_name}     | system  | Adventurer    |
      | {quest_reward}    | number  | 100           |
      | {npc_name}        | custom  | Elder Marcus  |
    And I write: "Hello {player_name}, {npc_name} offers {quest_reward} gold."
    Then variables should be parsed and highlighted
    And preview should show resolved variables
    And I should see variable reference list

  @api @content @create
  Scenario: Create content with conditional text
    Given I want content that adapts to context
    When I create conditional content:
      | condition              | text_if_true          | text_if_false        |
      | player.level >= 10     | Welcome, champion!    | Train harder, novice |
      | player.has_item(key)   | You may enter         | Find the key first   |
    Then conditional blocks should be created
    And preview should allow testing conditions
    And logic should be validated

  # ===========================================================================
  # CONTENT EDITING
  # ===========================================================================

  @api @content @edit
  Scenario: Edit existing content
    Given content "Epic Quest Intro" exists
    When I edit the content:
      | field        | action   | value                  |
      | title        | update   | The Epic Quest Begins  |
      | body         | append   | New paragraph added... |
      | media        | add      | new_image.png          |
      | tags         | add      | featured, main_story   |
    Then changes should be saved
    And version should be incremented from 3 to 4
    And I should see change diff highlighting
    And a ContentUpdated event should be published

  @api @content @edit
  Scenario: Edit with auto-save
    Given I am editing content
    And auto-save is enabled
    When I make changes to the content
    And 30 seconds pass
    Then changes should be auto-saved as draft
    And I should see "Saved" indicator
    And I should be able to continue editing
    And recovery should be available if browser closes

  @api @content @edit
  Scenario: Edit with collaborative editing
    Given content "Shared Story" is being edited
    And author "Bob" is currently editing
    When I open the content
    Then I should see Bob's cursor position
    And I should see Bob's name label at cursor
    And I should see real-time changes as Bob types
    And my cursor should be visible to Bob
    And simultaneous edits to same paragraph should be highlighted
    And I should be able to resolve conflicts

  @api @content @edit
  Scenario: Use visual content editor
    Given I prefer WYSIWYG editing
    When I use the visual editor
    Then I should see WYSIWYG interface
    And I should have formatting toolbar with:
      | tool           | shortcut   |
      | Bold           | Ctrl+B     |
      | Italic         | Ctrl+I     |
      | Heading 1      | Ctrl+1     |
      | Heading 2      | Ctrl+2     |
      | Bullet List    | Ctrl+U     |
      | Link           | Ctrl+K     |
      | Image          | Ctrl+Shift+I |
    And I should be able to drag-drop media
    And I should see live preview panel

  @api @content @edit
  Scenario: Edit in markdown mode
    Given I prefer code editing
    When I switch to markdown mode
    Then I should see raw markdown
    And syntax highlighting should be applied
    And preview pane should update in real-time
    And I should be able to switch back to visual mode

  @api @content @edit
  Scenario: Lock content for exclusive editing
    Given I need uninterrupted editing
    When I lock content "Important Story"
    Then content should be locked to me
    And other users should see locked status
    And lock should expire after 1 hour of inactivity
    And I should be able to release lock manually

  # ===========================================================================
  # BULK OPERATIONS
  # ===========================================================================

  @api @content @bulk
  Scenario: Perform bulk content updates
    Given I have multiple content items to update
    When I select content items:
      | title              |
      | Quest 1            |
      | Quest 2            |
      | Quest 3            |
    And I apply bulk action:
      | action       | value             |
      | add_tag      | seasonal_event    |
      | set_status   | published         |
      | set_category | Events            |
    Then all 3 items should be updated
    And I should see update summary:
      | result    | count |
      | success   | 3     |
      | failed    | 0     |
    And changes should be logged
    And a BulkContentUpdated event should be published

  @api @content @bulk
  Scenario: Bulk publish pending content
    Given 10 content items are in review status
    When I select all and bulk approve and publish
    Then all 10 items should be published
    And I should see publication confirmation
    And players should see new content immediately
    And authors should be notified of publication

  @api @content @bulk
  Scenario: Bulk archive old content
    Given I want to clean up old content
    When I filter content older than 1 year with 0 views in 6 months
    And I select all matching (25 items)
    And I bulk archive
    Then all 25 items should be archived
    And archived content should remain searchable
    And archived content should be hidden from players
    And I should be able to restore if needed

  @api @content @bulk
  Scenario: Bulk delete with confirmation
    Given I need to permanently remove content
    When I select 5 items for deletion
    Then I should see deletion warning
    And I should see list of affected references
    And I should type confirmation phrase
    When I confirm deletion
    Then items should be permanently deleted
    And references should be cleaned up

  # ===========================================================================
  # CONTENT RELATIONSHIPS
  # ===========================================================================

  @api @content @relationships
  Scenario: Manage content relationships
    Given content "Chapter 1: The Beginning" exists
    When I link related content:
      | relationship  | target                    |
      | continues_to  | Chapter 2: The Journey    |
      | references    | Ancient Lore Codex        |
      | requires      | Complete Tutorial Quest   |
      | unlocks       | Secret Area Description   |
    Then relationships should be established
    And navigation should reflect links
    And I should see relationship summary
    And bi-directional links should be created where appropriate

  @api @content @relationships
  Scenario: View content dependency tree
    Given "Main Story Arc" has complex dependencies
    When I view dependencies for "Main Story Arc"
    Then I should see dependency hierarchy:
      | level | content                  | dependency_type |
      | 0     | Main Story Arc           | root            |
      | 1     | Chapter 1                | child           |
      | 1     | Chapter 2                | child           |
      | 2     | Side Quest A             | referenced_by   |
      | 2     | Character Intro          | required_by     |
    And I should see visual dependency graph
    And broken dependencies should be highlighted in red
    And I should be able to fix broken links

  @api @content @relationships
  Scenario: Create content series
    Given I want to group related content
    When I create content series:
      | field         | value                    |
      | series_name   | Dragon Slayer Saga       |
      | description   | The epic dragon adventure|
      | content_order | Chapter 1, 2, 3, Epilogue|
    Then series should be created
    And content should be ordered within series
    And series navigation should be available to players

  # ===========================================================================
  # CONTENT REVIEW WORKFLOW
  # ===========================================================================

  @api @content @review
  Scenario: View content review queue
    Given content items are submitted for review
    When I open review queue
    Then I should see all pending content:
      | title           | author      | submitted    | priority |
      | New Quest       | AuthorAlice | 2 hours ago  | high     |
      | NPC Dialogue    | AuthorBob   | 1 day ago    | normal   |
      | Area Description| AuthorCarl  | 3 days ago   | low      |
    And I should see submission details
    And I should see author notes
    And oldest items should be highlighted

  @api @content @review
  Scenario: Approve content with feedback
    Given content "New Quest" is pending review
    When I review and approve with feedback:
      | field       | value                                |
      | decision    | approved                             |
      | feedback    | Great work! Minor typo on line 5.    |
      | notify      | true                                 |
      | publish_now | true                                 |
    Then content should be published
    And author should receive approval notification
    And feedback should be visible to author
    And review should be logged
    And a ContentApproved event should be published

  @api @content @review
  Scenario: Request content changes
    Given content "NPC Dialogue" has issues
    When I request changes:
      | field       | value                                |
      | issues      | - Ending feels abrupt                |
      |             | - Add more dialogue options          |
      |             | - Fix grammar in paragraph 3         |
      | priority    | high                                 |
      | deadline    | 2025-01-03                           |
    Then content should return to author
    And author should see detailed change requests
    And deadline should be tracked
    And I should see pending changes in dashboard
    And a ContentChangesRequested event should be published

  @api @content @review
  Scenario: Reject content
    Given content violates guidelines
    When I reject content:
      | field       | value                                |
      | decision    | rejected                             |
      | reason      | Contains inappropriate content       |
      | guideline   | Section 3.2 - Appropriate Content    |
      | allow_resubmit | true                              |
    Then content should be rejected
    And author should be notified with reason
    And content should return to draft status
    And rejection should be logged

  @api @content @review
  Scenario: Assign reviewer to content
    Given content needs specialized review
    When I assign reviewer:
      | content     | New Quest                |
      | reviewer    | ReviewerDave             |
      | due_date    | 2025-01-05               |
      | notes       | Please check lore accuracy|
    Then reviewer should be assigned
    And reviewer should be notified
    And content should appear in their queue

  # ===========================================================================
  # VERSION MANAGEMENT
  # ===========================================================================

  @api @content @versions
  Scenario: View content version history
    Given content "Epic Story" has 10 versions
    When I view version history
    Then I should see all versions:
      | version | date             | author      | summary              |
      | 10      | 2024-12-28 10:00 | AuthorAlice | Updated ending       |
      | 9       | 2024-12-25 14:30 | AuthorBob   | Added new chapter    |
      | 8       | 2024-12-20 09:00 | AuthorAlice | Fixed typos          |
    And I should see changes between versions
    And I should see word count changes
    And I should be able to view any version

  @api @content @versions
  Scenario: Restore previous version
    Given version 8 had better content
    When I restore version 8
    Then content should revert to version 8
    And restoration should create new version 11
    And I should see restoration note "Restored from v8"
    And a ContentVersionRestored event should be published

  @api @content @versions
  Scenario: Compare content versions
    Given I want to see what changed
    When I compare version 5 to version 10
    Then I should see side-by-side diff:
      | type      | line | old_text           | new_text            |
      | modified  | 12   | The dragon roared  | The ancient dragon  |
      | added     | 25   | n/a                | New paragraph...    |
      | deleted   | 30   | Old ending text    | n/a                 |
    And additions should be highlighted green
    And deletions should be highlighted red
    And I should be able to cherry-pick specific changes

  @api @content @versions
  Scenario: Create named version snapshot
    Given I want to preserve current state
    When I create named snapshot:
      | name        | Pre-Event Update     |
      | description | State before holiday |
    Then snapshot should be created
    And snapshot should be easily findable
    And snapshot should be restorable

  # ===========================================================================
  # CONTENT ORGANIZATION
  # ===========================================================================

  @api @content @organization
  Scenario: Organize content with tags
    Given I want to categorize content
    When I apply tags to content:
      | content          | tags                        |
      | Dragon Quest     | main, dragon, epic, combat  |
      | Side Adventure   | optional, forest, exploration|
      | Tutorial 1       | beginner, help, onboarding  |
    Then content should be tagged
    And I should be able to browse by tag
    And tag cloud should show popular tags
    And I should see tag usage statistics

  @api @content @organization
  Scenario: Create content folder structure
    Given I want to organize content hierarchically
    When I create folder structure:
      | folder           | parent       | description                |
      | Main Story       | root         | Core storyline content     |
      | Chapter 1        | Main Story   | Opening chapter            |
      | Chapter 2        | Main Story   | Rising action              |
      | Side Content     | root         | Optional adventures        |
      | Tutorials        | root         | Player guides              |
    Then folders should be created
    And I should be able to move content between folders
    And folder permissions should be configurable
    And breadcrumb navigation should work

  @api @content @organization
  Scenario: Set up content workflow states
    Given I want custom content workflow
    When I define workflow states:
      | state      | color   | transitions_to              |
      | draft      | gray    | review                      |
      | review     | yellow  | approved, needs_changes     |
      | needs_changes | orange | review                    |
      | approved   | blue    | published, scheduled        |
      | published  | green   | archived, unpublished       |
      | archived   | black   | draft                       |
    Then workflow should be configured
    And content should follow state transitions
    And invalid transitions should be blocked

  @api @content @organization
  Scenario: Manage content collections
    Given I want to group content thematically
    When I create collection:
      | name        | Holiday Event 2024           |
      | type        | seasonal                     |
      | content     | Event Quest, Event Dialogue  |
      | active_from | 2024-12-20                   |
      | active_until| 2025-01-05                   |
    Then collection should be created
    And content should be grouped
    And collection should auto-activate/deactivate

  # ===========================================================================
  # IMPORT AND EXPORT
  # ===========================================================================

  @api @content @import
  Scenario: Import content from file
    Given I have a JSON content file
    When I upload and import the file
    Then content should be validated:
      | check              | result  |
      | format_valid       | pass    |
      | required_fields    | pass    |
      | references_valid   | warning |
    And I should see import preview:
      | action   | count |
      | create   | 15    |
      | update   | 5     |
      | skip     | 2     |
    And I should resolve conflicts
    When I confirm import
    Then content should be imported
    And import should be logged
    And a ContentImported event should be published

  @api @content @import
  Scenario: Import from external CMS
    Given I want to migrate from WordPress
    When I configure external import:
      | field       | value                    |
      | source      | WordPress                |
      | url         | https://old-cms.example  |
      | content     | posts, pages             |
      | mapping     | custom_field_mapping     |
    Then connection should be tested
    And content should be fetched
    And content should be transformed per mapping
    And I should verify before finalizing

  @api @content @export
  Scenario: Export world content
    Given I want to backup content
    When I export content:
      | selection   | all_published              |
      | format      | JSON                       |
      | include     | media, metadata, versions  |
      | compress    | true                       |
    Then export should be generated
    And file should be downloadable
    And export should include:
      | component        | included |
      | content_text     | yes      |
      | media_files      | yes      |
      | relationships    | yes      |
      | translations     | yes      |
    And export should be reimportable

  @api @content @export
  Scenario: Export content for translation
    Given I need to send content for external translation
    When I export for translation:
      | format      | XLIFF                    |
      | languages   | English (source)         |
      | exclude     | already_translated       |
    Then translation package should be generated
    And translatable strings should be extracted
    And context should be preserved

  # ===========================================================================
  # CONTENT ANALYTICS
  # ===========================================================================

  @api @content @analytics
  Scenario: View content performance metrics
    Given content has been live for 30 days
    When I view content analytics
    Then I should see overall metrics:
      | metric           | value     | trend   |
      | total_views      | 125,000   | +15%    |
      | unique_viewers   | 45,000    | +12%    |
      | avg_read_time    | 2.5 min   | +8%     |
      | completion_rate  | 78%       | +5%     |
      | feedback_score   | 4.2/5     | stable  |
    And I should see trends over time graph
    And I should see top performing content list

  @api @content @analytics
  Scenario: Analyze individual content engagement
    Given content "Dragon Quest" has been active
    When I analyze engagement for "Dragon Quest"
    Then I should see engagement funnel:
      | stage            | users  | drop_off |
      | started_reading  | 10,000 | 0%       |
      | reached_middle   | 7,500  | 25%      |
      | reached_end      | 5,500  | 45%      |
      | took_action      | 4,000  | 60%      |
    And I should see where players drop off
    And I should see most replayed sections
    And I should see player feedback comments

  @api @content @analytics
  Scenario: View content comparison report
    Given I want to compare content performance
    When I compare selected content items
    Then I should see comparison:
      | content       | views  | completion | rating |
      | Quest A       | 5,000  | 85%        | 4.5    |
      | Quest B       | 3,000  | 60%        | 3.8    |
      | Quest C       | 8,000  | 75%        | 4.2    |
    And I should see what makes top content successful
    And I should see improvement recommendations

  @api @content @analytics
  Scenario: Generate content performance report
    Given I need a comprehensive report
    When I generate monthly content report
    Then report should include:
      | section                | content                    |
      | executive_summary      | Key metrics and highlights |
      | top_performers         | Best performing content    |
      | underperformers        | Content needing attention  |
      | engagement_trends      | User interaction patterns  |
      | recommendations        | Suggested improvements     |
    And report should be exportable as PDF

  # ===========================================================================
  # AI CONTENT CREATION
  # ===========================================================================

  @api @content @ai
  Scenario: Use AI for content creation
    Given I want AI assistance creating content
    When I request AI content assistance:
      | field       | value                    |
      | type        | dialogue                 |
      | context     | merchant_negotiation     |
      | tone        | friendly, helpful        |
      | length      | medium (100-200 words)   |
      | style       | fantasy_medieval         |
    Then AI should generate content suggestions:
      | suggestion_id | preview                           |
      | 1             | "Welcome to my shop, traveler..." |
      | 2             | "Ah, a customer! Browse freely..."|
      | 3             | "Good day! Looking for supplies?.."|
    And I should be able to edit suggestions
    And I should be able to regenerate
    And I should select or combine suggestions
    And final content should note AI assistance

  @api @content @ai
  Scenario: AI-powered content enhancement
    Given I have draft content that needs polish
    When I request AI enhancement:
      | action              | description                    |
      | improve_readability | Simplify complex sentences     |
      | add_variety         | Vary sentence structure        |
      | check_consistency   | Ensure consistent tone/voice   |
      | fix_grammar         | Correct grammatical errors     |
    Then AI should analyze content
    And AI should suggest improvements
    And I should see before/after comparison
    And I should choose which suggestions to accept
    And changes should be tracked

  @api @content @ai
  Scenario: Generate content variations
    Given NPC greeting "Hello, traveler!" exists
    When I request AI variations
    Then AI should generate alternatives:
      | variation                                    |
      | "Well met, wanderer!"                        |
      | "Greetings, adventurer!"                     |
      | "Ah, a new face! Welcome!"                   |
      | "Good day to you, stranger!"                 |
    And variations should maintain semantic meaning
    And I should select preferred variations
    And I should be able to use multiple for variety

  @api @content @ai
  Scenario: AI content translation assistance
    Given content exists in English
    When I request AI translation to Spanish
    Then AI should provide translation
    And I should see confidence score
    And difficult phrases should be flagged
    And I should be able to edit translation
    And human review should be recommended

  # ===========================================================================
  # TRANSLATIONS
  # ===========================================================================

  @api @content @translations
  Scenario: View translation status
    Given content exists in English
    When I view translation status
    Then I should see translation coverage:
      | language    | total_strings | translated | reviewed | coverage |
      | Spanish     | 1000          | 850        | 800      | 85%      |
      | French      | 1000          | 700        | 650      | 70%      |
      | German      | 1000          | 600        | 500      | 60%      |
      | Japanese    | 1000          | 300        | 200      | 30%      |
    And I should see untranslated content list
    And I should see translation progress trends

  @api @content @translations
  Scenario: Add translation for content
    Given content "Hello traveler" needs Spanish translation
    When I add translation:
      | field       | value                |
      | original    | Hello traveler       |
      | language    | Spanish              |
      | translated  | Hola viajero         |
      | reviewer    | spanish_reviewer     |
      | notes       | Formal greeting      |
    Then translation should be saved
    And translation should be marked for review
    And players with Spanish locale should see translation
    And a TranslationAdded event should be published

  @api @content @translations
  Scenario: Review translations
    Given translations are pending review
    When I open translation review queue
    Then I should see pending translations:
      | original        | translated     | translator | confidence |
      | Hello           | Hola           | AutoTrans  | 98%        |
      | Ancient dragon  | Dragón antiguo | Translator1| manual     |
    And I should be able to approve, edit, or reject
    And I should see translation memory suggestions

  @api @content @translations
  Scenario: Use machine translation
    Given I need quick translations
    When I request machine translation for French:
      | content_scope | untranslated_only    |
      | service       | best_available       |
    Then content should be auto-translated
    And I should see confidence scores per segment
    And low-confidence segments should be flagged
    And I should be able to edit translations
    And human review should be queued

  @api @content @translations
  Scenario: Export translations for external work
    Given I use external translation services
    When I export for translation:
      | format      | XLIFF 2.0            |
      | language    | Japanese             |
      | scope       | untranslated         |
    Then translation file should be generated
    And context should be preserved
    And I should be able to reimport completed translations

  # ===========================================================================
  # CONTENT TEMPLATES
  # ===========================================================================

  @api @content @templates
  Scenario: Create reusable content template
    Given I want to standardize content creation
    When I create template:
      | field       | value                              |
      | name        | Quest Dialogue Template            |
      | description | Standard quest giver conversation  |
      | structure   | greeting, quest_offer, acceptance, farewell |
      | variables   | {npc_name}, {quest_name}, {reward} |
      | guidelines  | Keep under 100 words per section   |
      | category    | Dialogues                          |
    Then template should be saved
    And template should be reusable
    And template should appear in creation wizard
    And a TemplateCreated event should be published

  @api @content @templates
  Scenario: Use template with variable substitution
    Given template "Quest Dialogue Template" exists
    When I create content from template:
      | variable    | value                |
      | npc_name    | Elder Marcus         |
      | quest_name  | Dragon Hunt          |
      | reward      | 500 gold             |
    Then variables should be substituted throughout
    And I should see placeholders replaced
    And I should be able to customize further
    And template structure should be preserved

  @api @content @templates
  Scenario: Share template with community
    Given I have created a useful template
    When I share template publicly:
      | visibility  | community            |
      | license     | CC-BY                |
      | tags        | quest, dialogue, rpg |
    Then template should be published to library
    And other creators should be able to use it
    And usage statistics should be tracked
    And I should receive attribution

  @api @content @templates
  Scenario: Import community template
    Given community templates are available
    When I browse community templates
    Then I should see popular templates:
      | name             | author    | uses   | rating |
      | Epic Quest Intro | TopAuthor | 5,432  | 4.8    |
      | NPC Shop Dialog  | ProWriter | 3,210  | 4.6    |
    When I import "Epic Quest Intro"
    Then template should be added to my library
    And I should be able to customize it

  # ===========================================================================
  # CONTENT SCHEDULING
  # ===========================================================================

  @api @content @scheduling
  Scenario: Schedule content publication
    Given content "Holiday Event Story" is ready
    When I schedule content:
      | field        | value                    |
      | publish_at   | 2024-12-25 00:00 UTC     |
      | unpublish_at | 2025-01-05 23:59 UTC     |
      | notify       | true                     |
      | timezone     | UTC                      |
    Then content should be scheduled
    And I should see content in scheduled queue
    And content should auto-publish at specified time
    And content should auto-unpublish at end time
    And a ContentScheduled event should be published

  @api @content @scheduling
  Scenario: View content calendar
    Given scheduled content exists
    When I view content calendar
    Then I should see calendar view with:
      | date       | content                  | action    |
      | 2024-12-25 | Holiday Event Story      | publish   |
      | 2024-12-31 | New Year Announcement    | publish   |
      | 2025-01-05 | Holiday Event Story      | unpublish |
    And I should be able to drag to reschedule
    And conflicts should be highlighted
    And I should see different content types color-coded

  @api @content @scheduling
  Scenario: Cancel scheduled publication
    Given content is scheduled for publication
    When I cancel the schedule
    Then scheduling should be removed
    And content should remain in current state
    And I should see confirmation
    And a ContentScheduleCancelled event should be published

  @api @content @scheduling
  Scenario: Schedule recurring content
    Given I have weekly update content
    When I schedule recurring publication:
      | frequency   | weekly                   |
      | day         | Monday                   |
      | time        | 10:00 UTC                |
      | template    | Weekly Update            |
    Then recurring schedule should be created
    And I should see future occurrences
    And I should be able to skip specific dates

  # ===========================================================================
  # CONTENT VALIDATION
  # ===========================================================================

  @api @content @validation
  Scenario: Validate all world content
    Given I want to check content health
    When I run content validation
    Then I should see validation results:
      | issue_type        | count | severity |
      | broken_links      | 5     | error    |
      | missing_media     | 3     | error    |
      | empty_fields      | 8     | warning  |
      | orphaned_content  | 2     | warning  |
      | policy_violations | 0     | n/a      |
      | accessibility     | 12    | info     |
    And I should see fix suggestions for each issue
    And I should be able to auto-fix safe issues
    And I should be able to export validation report

  @api @content @validation
  Scenario: Validate content before publish
    Given content is ready to publish
    When I run pre-publish validation
    Then validation should check:
      | check               | result | details                    |
      | all_links_valid     | pass   | 15/15 links working        |
      | all_media_exists    | pass   | 8/8 media files found      |
      | no_placeholders     | fail   | 2 placeholders remaining   |
      | meets_min_length    | pass   | 500 words (min: 100)       |
      | no_profanity        | pass   | No violations found        |
    And I should see publish readiness score
    And blocking issues should prevent publish

  @api @content @validation
  Scenario: Validate content accessibility
    Given content should be accessible
    When I run accessibility validation
    Then I should see accessibility issues:
      | issue                  | location        | fix                      |
      | image_missing_alt      | paragraph 3     | Add alt text             |
      | low_contrast_text      | header          | Increase contrast        |
      | missing_heading_levels | section 2       | Add proper h2            |
    And I should see WCAG compliance level
    And I should be able to add accessibility metadata

  # ===========================================================================
  # DOMAIN EVENTS
  # ===========================================================================

  @domain-events
  Scenario: ContentPublished triggers player notifications
    Given content is published
    When ContentPublished event is published
    Then the event should contain:
      | field           | description                    |
      | content_id      | Unique content identifier      |
      | content_type    | Type of content                |
      | title           | Content title                  |
      | author          | Content author                 |
    And interested players should be notified
    And content should appear in world
    And analytics tracking should begin
    And search indexes should be updated

  @domain-events
  Scenario: ContentUpdated triggers cache refresh
    Given published content is updated
    When ContentUpdated event is published
    Then the event should contain:
      | field           | description                    |
      | content_id      | Content identifier             |
      | changes         | What was changed               |
      | version         | New version number             |
    And content caches should be invalidated
    And players should see updated content
    And version history should be updated

  @domain-events
  Scenario: ContentTranslationCompleted triggers locale update
    Given translation is completed and reviewed
    When ContentTranslationCompleted event is published
    Then the event should contain:
      | field           | description                    |
      | content_id      | Content identifier             |
      | language        | Target language                |
      | translator      | Who translated                 |
    And players in that locale should see translation
    And translation coverage metrics should update

  # ===========================================================================
  # ERROR HANDLING
  # ===========================================================================

  @api @error
  Scenario: Handle content save conflict
    Given another user edited the same content
    When I try to save my changes
    Then I should see conflict notification:
      | field          | value                           |
      | conflicting_user| AuthorBob                      |
      | changed_at     | 2 minutes ago                   |
      | conflicts      | paragraph 3, title              |
    And I should see their changes
    And I should be able to:
      | option         | description                     |
      | merge          | Combine both changes            |
      | overwrite      | Use my version                  |
      | discard        | Use their version               |
    And conflict resolution should be logged

  @api @error
  Scenario: Handle media upload failure
    Given I am uploading media to content
    When media upload fails due to size limit
    Then I should see error message "File exceeds 10MB limit"
    And content should be saved without media
    And I should be able to resize and retry upload
    And partial content should not be lost

  @api @error
  Scenario: Handle content validation errors
    Given I try to save invalid content
    When validation fails
    Then I should see specific validation errors:
      | field          | error                           |
      | title          | Title is required               |
      | body           | Minimum 50 characters required  |
    And form should highlight error fields
    And I should be able to correct and retry
    And draft should be preserved

  @api @error
  Scenario: Recover from unsaved changes
    Given I was editing and browser crashed
    When I return to the editor
    Then I should see recovery prompt
    And I should see auto-saved draft
    And I should be able to restore draft
    And I should be able to discard draft
