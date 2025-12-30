@admin @localization @i18n @ANIMA-1071
Feature: Admin Language Management
  As a platform administrator
  I want to manage multiple languages and localization
  So that I can provide global accessibility and user experience

  Background:
    Given an authenticated administrator with "language_management" permissions
    And the localization system is operational
    And the following languages are configured:
      | code  | locale | native_name | status  | coverage |
      | en    | en-US  | English     | active  | 100%     |
      | es    | es-ES  | Español     | active  | 95%      |
      | fr    | fr-FR  | Français    | active  | 92%      |
      | de    | de-DE  | Deutsch     | beta    | 78%      |
      | ja    | ja-JP  | 日本語      | beta    | 65%      |

  # =============================================================================
  # LANGUAGE DASHBOARD AND OVERVIEW
  # =============================================================================

  @dashboard @happy-path
  Scenario: View language support dashboard
    Given the platform supports 5 languages
    And there are 250 pending translation items
    When I access the language management dashboard
    Then I should see overview metrics:
      | metric                  | value              |
      | supported_languages     | 5                  |
      | translation_coverage    | 86%                |
      | pending_translations    | 250                |
      | active_translators      | 8                  |
      | recent_updates          | 45 (last 7 days)   |
    And I should see language-by-language breakdown
    And I should see translation quality scores

  @dashboard @languages-list
  Scenario: View supported languages list
    Given the platform has configured languages
    When I view the supported languages
    Then I should see each language with:
      | language | locale | native_name | direction | status | coverage |
      | en       | en-US  | English     | LTR       | active | 100%     |
      | es       | es-ES  | Español     | LTR       | active | 95%      |
      | fr       | fr-FR  | Français    | LTR       | active | 92%      |
      | de       | de-DE  | Deutsch     | LTR       | beta   | 78%      |
      | ja       | ja-JP  | 日本語      | LTR       | beta   | 65%      |
    And I should be able to sort by any column
    And I should be able to filter by status

  @dashboard @metrics
  Scenario: View translation progress metrics
    Given translation work is ongoing
    When I view the progress metrics
    Then I should see:
      | metric                | value    | trend   |
      | translations_today    | 125      | +15%    |
      | avg_turnaround_time   | 4.5 hours| -20%    |
      | quality_score         | 4.6/5    | +0.2    |
      | reviewer_approval_rate| 94%      | stable  |
    And I should see trend charts for each metric

  # =============================================================================
  # LANGUAGE CONFIGURATION
  # =============================================================================

  @language @add
  Scenario: Add new supported language
    Given I want to expand language support
    When I add a new language with:
      | field           | value                |
      | language_code   | ja                   |
      | locale          | ja-JP                |
      | native_name     | 日本語               |
      | english_name    | Japanese             |
      | direction       | LTR                  |
      | fallback        | en-US                |
    Then the language should be added in "beta" status
    And translation templates should be created
    And a domain event "LanguageAdded" should be published

  @language @configure
  Scenario: Configure language settings
    Given language "es-ES" is active
    When I update language settings:
      | setting              | value                |
      | display_name         | Spanish (Spain)      |
      | fallback_language    | en-US                |
      | translation_priority | high                 |
      | auto_translate       | enabled              |
    Then the settings should be saved
    And a domain event "LanguageConfigured" should be published

  @language @activate
  Scenario: Activate beta language
    Given language "de-DE" is in beta status
    And translation coverage is above 80%
    When I activate the language
    Then the language status should change to "active"
    And users should be able to select the language
    And a domain event "LanguageActivated" should be published

  @language @disable
  Scenario: Disable a language
    Given language "fr-FR" is currently active
    And 500 users have it as their preferred language
    When I disable the language
    Then I should see a warning about affected users
    And be prompted to select a fallback language
    When I confirm with fallback "en-US"
    Then the language should be marked as "disabled"
    And affected users should be migrated to fallback
    And a domain event "LanguageDisabled" should be published

  @language @rtl
  Scenario: Configure right-to-left language
    Given I am adding an RTL language
    When I configure Arabic with:
      | field           | value                |
      | language_code   | ar                   |
      | locale          | ar-SA                |
      | native_name     | العربية              |
      | direction       | RTL                  |
    Then RTL support should be enabled for this language
    And UI mirroring should be configured
    And BiDi text handling should be activated

  @language @variants
  Scenario: Manage language variants
    Given language "es" has regional variants
    When I configure variants:
      | variant | locale | region          | differences        |
      | es-ES   | es-ES  | Spain           | Base Spanish       |
      | es-MX   | es-MX  | Mexico          | Regional terms     |
      | es-AR   | es-AR  | Argentina       | Voseo, local terms |
    Then each variant should have separate translations
    And shared translations should be inherited from base
    And variant-specific overrides should take precedence

  # =============================================================================
  # TRANSLATION MANAGEMENT
  # =============================================================================

  @translation @view
  Scenario: View translation content by category
    Given I am managing translations for "es-ES"
    When I view translations by category
    Then I should see content organized as:
      | category          | total_strings | translated | pending |
      | ui_strings        | 1,500         | 1,450      | 50      |
      | error_messages    | 300           | 285        | 15      |
      | notifications     | 200           | 190        | 10      |
      | email_templates   | 50            | 45         | 5       |
      | help_content      | 400           | 350        | 50      |
      | legal_content     | 25            | 25         | 0       |
    And I should be able to drill down into each category

  @translation @edit
  Scenario: Edit translation string
    Given I am editing translations for "es-ES"
    When I update a translation string:
      | key                | source           | translation       |
      | button.submit      | Submit           | Enviar            |
    Then the translation should be saved
    And marked for review if review workflow is enabled
    And a domain event "TranslationUpdated" should be published

  @translation @search
  Scenario: Search translations
    Given I need to find specific translations
    When I search with:
      | criterion     | value          |
      | keyword       | error          |
      | language      | es-ES          |
      | status        | pending        |
    Then matching translations should be displayed
    And I should see context for each result
    And be able to edit directly from search results

  @translation @bulk-edit
  Scenario: Bulk edit translations
    Given I have selected 10 translation strings
    When I apply bulk action "mark_as_reviewed"
    Then all selected strings should be marked as reviewed
    And the review timestamp should be updated
    And reviewers should be notified

  @translation @import
  Scenario: Import translations from file
    Given I have translations in an XLIFF file
    When I import translations for "de-DE"
    Then the system should:
      | step                    | result                         |
      | validate_format         | XLIFF 2.0 validated            |
      | parse_content           | 500 strings parsed             |
      | match_keys              | 480 keys matched               |
      | report_new_keys         | 20 new keys found              |
      | apply_translations      | 480 translations applied       |
    And a domain event "TranslationsBulkImported" should be published

  @translation @export
  Scenario: Export translations for external work
    Given translators need to work offline
    When I export translations for "de-DE" with:
      | format     | XLIFF                |
      | categories | ui_strings, help     |
      | status     | pending              |
    Then I should receive a downloadable file
    And the export should be tracked for re-import matching
    And include context and character limits

  @translation @memory
  Scenario: Use translation memory
    Given translation memory is enabled
    And previous translations exist
    When a translator encounters a new string "Click to continue"
    Then the system should suggest similar translations:
      | original           | translation         | match  |
      | Click to proceed   | Haga clic para...   | 85%    |
      | Click to confirm   | Haga clic para...   | 80%    |
    And allow applying suggestions with modification
    And update translation memory with new translations

  @translation @glossary
  Scenario: Manage translation glossary
    Given consistent terminology is required
    When I add a glossary term:
      | term        | translation    | context          | forbidden_alternatives |
      | Dashboard   | Panel          | Main navigation  | Tablero, Cuadro        |
    Then the term should be added to the glossary
    And translations using forbidden terms should be flagged
    And translators should see glossary suggestions

  @translation @placeholder
  Scenario: Handle translation placeholders
    Given a source string with placeholders:
      """
      Hello {username}, you have {count} new messages
      """
    When I translate to Spanish
    Then the translation must preserve placeholders:
      """
      Hola {username}, tienes {count} mensajes nuevos
      """
    And the system should validate placeholder preservation
    And warn if placeholders are missing or modified

  # =============================================================================
  # REGIONAL SETTINGS
  # =============================================================================

  @regional @formats
  Scenario: Configure regional date and time formats
    Given I am configuring regional settings for "de-DE"
    When I set date and time formats:
      | setting             | value              |
      | date_format         | DD.MM.YYYY         |
      | time_format         | 24-hour            |
      | first_day_of_week   | Monday             |
      | calendar_type       | Gregorian          |
    Then the formats should be saved
    And all date/time displays should use these formats
    And a domain event "RegionalSettingsUpdated" should be published

  @regional @numbers
  Scenario: Configure number and currency formats
    Given I am configuring regional settings for "de-DE"
    When I set number formats:
      | setting             | value              |
      | decimal_separator   | ,                  |
      | thousands_separator | .                  |
      | currency_code       | EUR                |
      | currency_symbol     | €                  |
      | currency_position   | after              |
    Then numbers should display as "1.234,56 €"
    And all monetary values should use these formats

  @regional @timezone
  Scenario: Configure timezone handling
    Given users are in different timezones
    When I configure timezone settings:
      | setting              | value              |
      | default_timezone     | Europe/Berlin      |
      | user_timezone_detect | enabled            |
      | display_format       | local_with_abbrev  |
      | dst_handling         | automatic          |
    Then timezone conversions should work correctly
    And users should see times in their local zone

  @regional @units
  Scenario: Configure measurement units
    Given I am configuring units for "en-US"
    When I set measurement preferences:
      | measurement     | unit        |
      | distance        | miles       |
      | weight          | pounds      |
      | temperature     | fahrenheit  |
      | volume          | gallons     |
    Then all measurements should display in these units
    And conversion should happen automatically

  # =============================================================================
  # AUTOMATED TRANSLATION
  # =============================================================================

  @automation @configure
  Scenario: Configure automated translation provider
    Given I want machine translation assistance
    When I configure automated translation:
      | setting              | value              |
      | provider             | DeepL              |
      | api_key              | configured         |
      | quality_threshold    | 0.85               |
      | auto_approve         | ui_strings only    |
      | human_review         | legal, marketing   |
    Then the provider should be validated
    And test translation should confirm connectivity
    And a domain event "AutoTranslationConfigured" should be published

  @automation @trigger
  Scenario: Trigger machine translation for new content
    Given new content needs translation to 4 languages
    When machine translation is triggered
    Then the system should:
      | step                 | result                         |
      | queue_content        | 50 strings queued              |
      | send_to_provider     | Submitted to DeepL             |
      | receive_translations | All languages received         |
      | calculate_confidence | Scores calculated              |
      | route_by_confidence  | 40 auto-approved, 10 for review|
    And translation costs should be logged

  @automation @hybrid
  Scenario: Configure hybrid translation workflow
    Given different content requires different approaches
    When I configure hybrid translation rules:
      | content_type         | approach                       |
      | ui_strings           | Machine with human review      |
      | marketing_content    | Human translation only         |
      | user_comments        | Machine translation only       |
      | legal_content        | Professional human translation |
    Then content should be routed accordingly
    And appropriate workflows should be triggered

  @automation @cost
  Scenario: Monitor machine translation costs
    Given machine translation is in use
    When I view translation costs
    Then I should see:
      | period     | characters | cost     | languages |
      | today      | 50,000     | $12.50   | 4         |
      | this_week  | 250,000    | $62.50   | 4         |
      | this_month | 1,000,000  | $250.00  | 4         |
    And I should see cost projections
    And set budget alerts

  # =============================================================================
  # TRANSLATION TEAM MANAGEMENT
  # =============================================================================

  @team @overview
  Scenario: View translation team overview
    Given I have a translation team
    When I access team management
    Then I should see:
      | translator   | languages    | workload | quality_score |
      | Maria G.     | es-ES, es-MX | 75%      | 4.8           |
      | Hans M.      | de-DE        | 60%      | 4.6           |
      | Yuki T.      | ja-JP        | 90%      | 4.9           |
    And I should see overall team capacity

  @team @roles
  Scenario: Assign translator roles and permissions
    Given I am configuring a new translator
    When I assign role and permissions:
      | field           | value                    |
      | user            | translator@example.com   |
      | role            | translator               |
      | languages       | es-ES, es-MX             |
      | categories      | ui_strings, notifications|
      | can_approve     | false                    |
    Then the translator should have appropriate access
    And be notified of their assignment

  @team @workflow
  Scenario: Configure translation review workflow
    Given translations need quality control
    When I configure the review workflow:
      | stage               | required | assignee          |
      | initial_translation | yes      | any_translator    |
      | peer_review         | yes      | another_translator|
      | lead_approval       | yes      | language_lead     |
      | qa_check            | auto     | system            |
    Then translations should follow this workflow
    And progress should be tracked at each stage

  @team @assignment
  Scenario: Assign translation tasks
    Given 100 new strings need translation to Spanish
    When I create a translation task:
      | field           | value                |
      | language        | es-ES                |
      | category        | ui_strings           |
      | deadline        | 2024-01-20           |
      | priority        | high                 |
      | assignee        | Maria G.             |
    Then the task should be created
    And the translator should be notified
    And deadline reminders should be scheduled

  @team @workload
  Scenario: Balance translator workload
    Given translators have varying workloads
    When I view workload distribution
    Then I should see:
      | translator | current_items | capacity | recommendation      |
      | Maria G.   | 150           | 200      | Can take more       |
      | Hans M.    | 120           | 150      | Near capacity       |
      | Yuki T.    | 180           | 150      | Overloaded - reassign|
    And be able to rebalance assignments

  # =============================================================================
  # TRANSLATION QUALITY
  # =============================================================================

  @quality @check
  Scenario: Run translation quality checks
    Given translations have been submitted
    When I run quality checks on "es-ES" translations
    Then the system should verify:
      | check                | passed | failed | warnings |
      | placeholder_preserved| 495    | 5      | 0        |
      | glossary_compliance  | 480    | 10     | 10       |
      | formatting_preserved | 498    | 2      | 0        |
      | length_appropriate   | 490    | 0      | 10       |
      | grammar_check        | 495    | 3      | 2        |
    And issues should be flagged for correction

  @quality @consistency
  Scenario: Check translation consistency
    Given the same term appears multiple times
    When I run consistency check
    Then I should see inconsistencies:
      | term      | translation_1 | translation_2 | occurrences |
      | Settings  | Configuración | Ajustes       | 15, 8       |
      | Cancel    | Cancelar      | Anular        | 20, 5       |
    And be able to bulk-fix inconsistencies

  @quality @feedback
  Scenario: Process user translation feedback
    Given a user reports a translation issue
    When feedback is submitted:
      | string_key    | button.save                    |
      | language      | es-ES                          |
      | issue         | Incorrect translation          |
      | suggestion    | Use "Guardar" instead          |
    Then the feedback should be logged
    And routed to the Spanish translation team
    And tracked for resolution
    And a domain event "TranslationFeedbackReceived" should be published

  @quality @scoring
  Scenario: Calculate translation quality scores
    Given quality metrics are tracked
    When I view quality scores for "es-ES"
    Then I should see:
      | metric               | score | benchmark |
      | accuracy             | 4.7   | 4.5       |
      | consistency          | 4.5   | 4.5       |
      | fluency              | 4.6   | 4.5       |
      | terminology          | 4.8   | 4.5       |
      | overall              | 4.65  | 4.5       |
    And see trends over time

  # =============================================================================
  # LOCALIZATION TESTING
  # =============================================================================

  @testing @ui
  Scenario: Test UI string rendering
    Given translations exist for "de-DE"
    When I run UI rendering tests
    Then the system should check:
      | test_type            | passed | failed |
      | string_truncation    | 145    | 5      |
      | character_rendering  | 150    | 0      |
      | button_overflow      | 48     | 2      |
      | menu_alignment       | 25     | 0      |
    And generate a detailed report with screenshots

  @testing @pseudo
  Scenario: Run pseudo-localization testing
    Given I want to identify localization issues early
    When I enable pseudo-localization mode
    Then strings should be transformed:
      | original        | pseudo                     |
      | Submit          | [Śübmït~~~~]               |
      | Welcome         | [Wélçömé~~~~~~~~]          |
    And I should see hardcoded strings (not transformed)
    And layout issues should be highlighted

  @testing @rtl
  Scenario: Test RTL layout rendering
    Given Arabic translations exist
    When I run RTL layout tests
    Then the system should verify:
      | element              | expected         | result  |
      | text_alignment       | right            | pass    |
      | layout_direction     | mirrored         | pass    |
      | number_direction     | LTR (preserved)  | pass    |
      | icon_mirroring       | directional only | pass    |
    And generate visual comparison screenshots

  @testing @screenshots
  Scenario: Generate localized screenshots
    Given I need visual verification across languages
    When I generate localized screenshots for key screens
    Then screenshots should be captured for:
      | screen          | languages                    |
      | login           | en, es, fr, de, ja           |
      | dashboard       | en, es, fr, de, ja           |
      | settings        | en, es, fr, de, ja           |
    And differences should be highlighted
    And stored for review

  # =============================================================================
  # USER LANGUAGE SETTINGS
  # =============================================================================

  @user-settings @preferences
  Scenario: Configure user language preferences
    Given a user wants to set language preferences
    When I configure user language options
    Then users should be able to set:
      | setting              | options                    |
      | preferred_language   | Any active language        |
      | fallback_language    | Any active language        |
      | auto_detect          | Enable/disable             |
      | date_format_override | Use locale or custom       |
    And preferences should persist across sessions

  @user-settings @detection
  Scenario: Configure language auto-detection
    Given users may not set explicit preferences
    When I configure auto-detection priority:
      | source               | priority |
      | user_profile         | 1        |
      | browser_header       | 2        |
      | ip_geolocation       | 3        |
      | device_locale        | 4        |
      | default_fallback     | 5        |
    Then detection should follow this priority
    And users should be able to override

  @user-settings @fallback
  Scenario: Handle missing translations gracefully
    Given user has selected "de-DE" (78% coverage)
    When content is not available in German
    Then the system should:
      | step                 | action                       |
      | check_fallback       | Try en-US (user's fallback)  |
      | display_content      | Show English content         |
      | indicate_language    | Show subtle language indicator|
      | log_for_priority     | Track for translation queue  |
    And never show raw translation keys

  # =============================================================================
  # CONTENT LOCALIZATION
  # =============================================================================

  @content @status
  Scenario: View content localization status
    Given content exists across multiple languages
    When I view localization status for a content item
    Then I should see:
      | language | status     | last_updated | sync_status   |
      | en-US    | source     | 2024-01-15   | -             |
      | es-ES    | translated | 2024-01-14   | outdated      |
      | fr-FR    | translated | 2024-01-15   | current       |
      | de-DE    | pending    | -            | needs_work    |
    And be able to trigger translation for pending languages

  @content @sync
  Scenario: Synchronize translations after source update
    Given source content in English has been updated
    When I trigger content synchronization
    Then the system should:
      | action               | result                       |
      | detect_changes       | 5 strings modified           |
      | flag_stale           | 4 languages flagged          |
      | show_diff            | Display what changed         |
      | notify_translators   | Alerts sent to language teams|
    And stale translations should be marked for update

  @content @pluralization
  Scenario: Handle pluralization rules
    Given different languages have different plural forms
    When I configure a pluralized string:
      | key                  | you_have_messages            |
      | source               | You have {count} message(s)  |
    Then translations should include all required forms:
      | language | forms                              |
      | en       | one: "1 message", other: "N messages" |
      | ru       | one, few, many, other              |
      | ar       | zero, one, two, few, many, other   |
    And validation should ensure all forms are provided

  @content @context
  Scenario: Provide translation context
    Given translators need context for accurate translation
    When I add context to a translation key:
      | key         | button.reserve                     |
      | context     | Button to reserve a game slot      |
      | max_length  | 15 characters                      |
      | screenshot  | reserve_button.png                 |
    Then translators should see this context
    And be warned if translation exceeds max length

  # =============================================================================
  # MULTILINGUAL PUBLISHING
  # =============================================================================

  @publishing @release
  Scenario: Publish translations to production
    Given translations are ready for release
    When I publish translations for "es-ES"
    Then the system should:
      | step                 | result                       |
      | validate_all         | All checks passed            |
      | create_snapshot      | Version 2024.01.15 created   |
      | deploy_to_cdn        | CDN updated                  |
      | invalidate_cache     | Cache cleared                |
    And a domain event "TranslationPublished" should be published

  @publishing @staged
  Scenario: Stage translations for review before publish
    Given translations need final review
    When I stage translations for "de-DE"
    Then the translations should be available at staging URL
    And reviewers should be notified
    And I should be able to promote to production or rollback

  @publishing @rollback
  Scenario: Rollback translations to previous version
    Given a translation issue is discovered after publish
    When I rollback "es-ES" to version 2024.01.10
    Then the previous translation version should be restored
    And the rollback should be logged
    And users should see the previous translations

  @publishing @scheduled
  Scenario: Schedule translation publication
    Given translations are ready but need coordinated release
    When I schedule publication for:
      | language | scheduled_time       |
      | es-ES    | 2024-01-20 09:00 UTC |
      | fr-FR    | 2024-01-20 09:00 UTC |
      | de-DE    | 2024-01-20 09:00 UTC |
    Then publications should be queued
    And execute at the scheduled time
    And notifications should be sent on completion

  # =============================================================================
  # COMPLIANCE AND CULTURAL SENSITIVITY
  # =============================================================================

  @compliance @cultural
  Scenario: Configure cultural sensitivity rules
    Given content must be culturally appropriate
    When I configure cultural rules:
      | rule_type            | examples                       |
      | color_sensitivity    | White = mourning in some cultures |
      | gesture_icons        | Thumbs up offensive in some regions |
      | date_formats         | Month/Day vs Day/Month         |
      | name_order           | Family name first in some cultures |
    Then translations should be checked against rules
    And violations should be flagged for review

  @compliance @legal
  Scenario: Manage locale-specific legal content
    Given legal requirements vary by region
    When I configure legal content for "de-DE":
      | content_type         | requirement                    |
      | privacy_policy       | GDPR compliant version         |
      | terms_of_service     | German law compliant           |
      | cookie_consent       | EU cookie law specific         |
      | imprint              | Required by German law         |
    Then locale-specific versions should be served
    And compliance should be tracked

  @compliance @review
  Scenario: Conduct cultural sensitivity review
    Given content has been flagged for cultural review
    When a cultural expert reviews the content
    Then they should be able to:
      | action               | description                    |
      | approve              | Content is appropriate         |
      | reject               | Content needs changes          |
      | suggest              | Provide alternatives           |
      | escalate             | Needs higher review            |
    And the decision should be documented

  # =============================================================================
  # PERFORMANCE AND ROI
  # =============================================================================

  @performance @metrics
  Scenario: Track localization performance metrics
    Given localization is ongoing
    When I view performance metrics
    Then I should see:
      | metric               | value    | target  |
      | translation_coverage | 86%      | 90%     |
      | avg_turnaround_time  | 4.5 hours| 8 hours |
      | quality_score        | 4.6/5    | 4.5/5   |
      | cost_per_word        | $0.12    | $0.15   |
    And compare metrics across languages

  @performance @sla
  Scenario: Monitor translation SLA compliance
    Given translation SLAs are defined
    When I monitor SLA compliance
    Then I should see:
      | priority | target        | actual    | compliance |
      | urgent   | 4 hours       | 3.5 hours | 100%       |
      | high     | 24 hours      | 20 hours  | 95%        |
      | normal   | 72 hours      | 65 hours  | 92%        |
    And breaches should be highlighted

  @roi @analysis
  Scenario: Analyze localization ROI
    Given I need to justify localization investment
    When I view ROI analysis
    Then I should see:
      | language | investment | user_growth | revenue_lift | roi    |
      | es-ES    | $15,000    | +25,000     | +$50,000     | 233%   |
      | fr-FR    | $12,000    | +18,000     | +$35,000     | 192%   |
      | de-DE    | $10,000    | +12,000     | +$22,000     | 120%   |
    And recommendations for language prioritization

  @roi @forecast
  Scenario: Forecast localization impact
    Given I am considering adding a new language
    When I request impact forecast for "pt-BR"
    Then I should see projections:
      | metric               | projected_value |
      | translation_cost     | $18,000         |
      | time_to_complete     | 6 weeks         |
      | potential_users      | +30,000         |
      | potential_revenue    | +$60,000        |
      | projected_roi        | 233%            |

  # =============================================================================
  # API SCENARIOS
  # =============================================================================

  @api @list-languages
  Scenario: List supported languages via API
    Given I have a valid API token
    When I send a GET request to /api/v1/admin/languages
    Then the response status should be 200 OK
    And the response should contain:
      """
      {
        "languages": [
          {
            "code": "en",
            "locale": "en-US",
            "name": "English",
            "status": "active",
            "coverage": 100
          }
        ]
      }
      """

  @api @get-translations
  Scenario: Get translations for a language via API
    Given I have a valid API token
    When I send a GET request to /api/v1/admin/translations/es-ES?category=ui_strings
    Then the response status should be 200 OK
    And the response should contain translation key-value pairs
    And support pagination

  @api @update-translation
  Scenario: Update translation via API
    Given I have a valid API token with translation permissions
    When I send a PUT request to /api/v1/admin/translations/es-ES/button.submit:
      """
      {
        "value": "Enviar",
        "context": "Form submit button"
      }
      """
    Then the response status should be 200 OK
    And the translation should be updated
    And review workflow should be triggered if required

  @api @import-translations
  Scenario: Import translations via API
    Given I have a valid API token with import permissions
    When I send a POST request to /api/v1/admin/translations/import with XLIFF file
    Then the response status should be 202 Accepted
    And the response should contain:
      | field    | value              |
      | job_id   | import-job-123     |
      | status   | processing         |

  @api @webhook
  Scenario: Configure translation webhook
    Given I want to receive translation notifications
    When I configure a webhook:
      """
      {
        "url": "https://example.com/webhooks/translations",
        "events": ["translation.updated", "translation.published"],
        "secret": "webhook-secret"
      }
      """
    Then the webhook should be registered
    And events should be delivered with HMAC signature

  # =============================================================================
  # ERROR SCENARIOS
  # =============================================================================

  @error @invalid-import
  Scenario: Handle invalid translation file import
    Given I am importing translations
    When the file format is invalid
    Then the import should be rejected
    And display specific parsing errors:
      | line | error                          |
      | 15   | Invalid XML structure          |
      | 28   | Missing target element         |
    And suggest correct format

  @error @default-language
  Scenario: Prevent deletion of default language
    Given English is the default platform language
    When I attempt to delete English
    Then the deletion should be prevented
    And display "Cannot delete default platform language"
    And suggest setting a new default first

  @error @missing-placeholder
  Scenario: Detect missing placeholders in translation
    Given source string is "Hello {username}, welcome!"
    When translator submits "¡Hola, bienvenido!"
    Then validation should fail
    And display "Missing placeholder: {username}"
    And prevent save until corrected

  @error @unauthorized
  Scenario: Prevent unauthorized translation changes
    Given I am a translator for Spanish only
    When I attempt to edit French translations
    Then the request should be denied with 403 Forbidden
    And display "Not authorized for this language"
    And log the unauthorized attempt

  @error @concurrent-edit
  Scenario: Handle concurrent translation edits
    Given two translators are editing the same string
    When both submit changes simultaneously
    Then the second submission should be rejected
    And display conflict resolution options:
      | option       | action                         |
      | keep_mine    | Overwrite with my changes      |
      | keep_theirs  | Discard my changes             |
      | merge        | Show both for manual merge     |

  @error @rate-limit
  Scenario: Handle translation API rate limiting
    Given machine translation has rate limits
    When rate limit is exceeded
    Then requests should be queued
    And display estimated wait time
    And process when capacity is available

  # =============================================================================
  # DOMAIN EVENTS
  # =============================================================================

  @domain-events
  Scenario: Publish domain events for language management
    Given the event bus is configured
    When language management events occur
    Then the following events should be published:
      | event_type                  | payload_includes                  |
      | LanguageAdded               | language_code, locale, added_by   |
      | LanguageActivated           | language_code, coverage           |
      | LanguageDisabled            | language_code, affected_users     |
      | TranslationUpdated          | key, language, old_value, new_value|
      | TranslationsBulkImported    | language, count, source_format    |
      | TranslationPublished        | language, version, published_by   |
      | TranslationFeedbackReceived | key, language, feedback_type      |
      | TranslationQualityAlert     | language, score, threshold        |
