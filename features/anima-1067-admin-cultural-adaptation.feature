@admin @cultural @localization @platform
Feature: Admin Cultural Adaptation
  As a platform administrator
  I want to manage cultural adaptation and regional customization
  So that I can provide culturally appropriate experiences for global users

  Background:
    Given I am logged in as a platform administrator
    And I have cultural adaptation permissions
    And the following locales are configured in the system:
      | locale_code | locale_name           | region          | status  | direction | coverage |
      | en-US       | English (US)          | North America   | active  | LTR       | 100%     |
      | en-GB       | English (UK)          | Europe          | active  | LTR       | 100%     |
      | es-ES       | Spanish (Spain)       | Europe          | active  | LTR       | 95%      |
      | es-MX       | Spanish (Mexico)      | Latin America   | active  | LTR       | 92%      |
      | zh-CN       | Chinese (Simplified)  | Asia Pacific    | active  | LTR       | 88%      |
      | zh-TW       | Chinese (Traditional) | Asia Pacific    | active  | LTR       | 85%      |
      | ar-SA       | Arabic (Saudi Arabia) | Middle East     | active  | RTL       | 82%      |
      | ja-JP       | Japanese              | Asia Pacific    | active  | LTR       | 90%      |
      | de-DE       | German                | Europe          | active  | LTR       | 94%      |
      | fr-FR       | French                | Europe          | active  | LTR       | 93%      |

  # ============================================
  # CULTURAL ADAPTATION DASHBOARD
  # ============================================

  Scenario: View comprehensive cultural adaptation dashboard
    When I navigate to the cultural adaptation dashboard
    Then I should see localization coverage by region:
      | region          | locales | avg_coverage | status    |
      | North America   | 2       | 100%         | complete  |
      | Europe          | 5       | 94%          | good      |
      | Asia Pacific    | 4       | 86%          | attention |
      | Middle East     | 2       | 82%          | attention |
      | Latin America   | 3       | 88%          | good      |
    And I should see translation completion status:
      | content_type    | total_strings | translated | pending | in_review |
      | UI strings      | 2,500         | 2,380      | 80      | 40        |
      | Marketing copy  | 850           | 780        | 50      | 20        |
      | Help articles   | 450           | 390        | 40      | 20        |
      | Legal documents | 125           | 125        | 0       | 0         |
      | Error messages  | 320           | 305        | 10      | 5         |
    And I should see cultural compliance scores:
      | region          | compliance_score | issues_open | last_audit      |
      | North America   | 98%              | 2           | 2024-12-15      |
      | Europe          | 96%              | 5           | 2024-12-10      |
      | Asia Pacific    | 92%              | 12          | 2024-12-20      |
      | Middle East     | 94%              | 8           | 2024-12-18      |
    And I should see pending adaptations requiring attention:
      | adaptation_id | type              | locale | priority | deadline   |
      | ADP-001       | Content review    | ar-SA  | high     | 2025-01-05 |
      | ADP-002       | Image replacement | zh-CN  | medium   | 2025-01-10 |
      | ADP-003       | Legal update      | de-DE  | high     | 2025-01-03 |

  Scenario: View detailed regional adaptation status
    When I select region "Asia Pacific"
    Then I should see locales in that region:
      | locale | name                  | users   | coverage | quality_score |
      | zh-CN  | Chinese (Simplified)  | 125,000 | 88%      | 94%           |
      | zh-TW  | Chinese (Traditional) | 45,000  | 85%      | 92%           |
      | ja-JP  | Japanese              | 85,000  | 90%      | 96%           |
      | ko-KR  | Korean                | 62,000  | 78%      | 88%           |
    And I should see adaptation progress per locale:
      | locale | ui_complete | content_complete | legal_complete | cultural_review |
      | zh-CN  | 92%         | 85%              | 100%           | 80%             |
      | zh-TW  | 88%         | 82%              | 100%           | 75%             |
      | ja-JP  | 95%         | 88%              | 100%           | 90%             |
      | ko-KR  | 82%         | 75%              | 95%            | 70%             |
    And I should see cultural issues flagged:
      | issue_id | locale | type           | severity | description                    |
      | CUL-101  | zh-CN  | Political      | critical | Map display issue              |
      | CUL-102  | ja-JP  | Imagery        | medium   | Inappropriate hand gesture     |
      | CUL-103  | ko-KR  | Color          | low      | Red/blue political association |

  Scenario: Compare adaptation metrics across regions
    When I view the regional comparison dashboard
    Then I should see side-by-side metrics:
      | metric                 | NA     | Europe | APAC   | MENA   | LATAM  |
      | Translation coverage   | 100%   | 94%    | 86%    | 82%    | 88%    |
      | Cultural compliance    | 98%    | 96%    | 92%    | 94%    | 95%    |
      | User satisfaction      | 4.5/5  | 4.3/5  | 4.1/5  | 4.2/5  | 4.4/5  |
      | Support tickets/locale | 45     | 78     | 125    | 95     | 62     |
    And I should be able to drill down into any region for details

  # ============================================
  # LOCALE MANAGEMENT
  # ============================================

  Scenario: Add new locale with full configuration
    When I add new locale with the following details:
      | field              | value                        |
      | locale_code        | pt-BR                        |
      | locale_name        | Portuguese (Brazil)          |
      | region             | Latin America                |
      | country            | Brazil                       |
      | direction          | LTR                          |
      | date_format        | dd/MM/yyyy                   |
      | time_format        | HH:mm                        |
      | number_format      | 1.234,56                     |
      | currency_code      | BRL                          |
      | currency_symbol    | R$                           |
      | currency_position  | before                       |
      | first_day_of_week  | Sunday                       |
      | timezone           | America/Sao_Paulo            |
    Then the locale should be created with status "pending_setup"
    And translation workflow should initialize:
      | workflow_step           | status    |
      | Base translation import | pending   |
      | UI string translation   | pending   |
      | Content adaptation      | pending   |
      | Legal document review   | pending   |
      | Cultural review         | pending   |
      | QA testing              | pending   |
    And a LocaleAdded domain event should be published with:
      | field         | value                    |
      | locale_code   | pt-BR                    |
      | region        | Latin America            |
      | created_by    | current_user_id          |
      | timestamp     | current_timestamp        |
    And the regional content team should be notified

  Scenario: Configure comprehensive locale settings
    When I configure locale "ja-JP" with the following settings:
      | category        | setting               | value                    |
      | Date/Time       | date_format           | yyyy年MM月dd日            |
      | Date/Time       | time_format           | HH:mm                    |
      | Date/Time       | datetime_format       | yyyy年MM月dd日 HH:mm      |
      | Date/Time       | relative_time         | Japanese style           |
      | Numbers         | decimal_separator     | .                        |
      | Numbers         | thousands_separator   | ,                        |
      | Numbers         | number_format         | #,###.##                 |
      | Currency        | currency_code         | JPY                      |
      | Currency        | currency_symbol       | ¥                        |
      | Currency        | decimals              | 0                        |
      | Calendar        | first_day_of_week     | Sunday                   |
      | Calendar        | calendar_type         | Gregorian + Japanese Era |
      | Text            | text_direction        | LTR                      |
      | Text            | writing_mode          | horizontal-tb            |
      | Text            | word_break            | break-all                |
    Then settings should be saved and validated
    And content should render according to these settings
    And a preview should be available for verification

  Scenario: Configure RTL locale with full mirroring
    When I configure locale "ar-SA" as RTL with the following:
      | setting               | value                    |
      | text_direction        | RTL                      |
      | ui_mirroring          | full                     |
      | navigation_position   | right                    |
      | scrollbar_position    | left                     |
      | icon_mirroring        | contextual               |
      | number_direction      | LTR (within RTL context) |
      | mixed_content_handling| bidi-override            |
    Then UI should mirror for Arabic users:
      | element               | behavior                 |
      | Navigation menu       | Aligned to right         |
      | Text alignment        | Right-to-left            |
      | Icons (directional)   | Mirrored                 |
      | Icons (symmetric)     | Unchanged                |
      | Progress bars         | Right-to-left fill       |
      | Form labels           | Right of inputs          |
    And bidirectional text should render correctly
    And mixed LTR/RTL content should display properly

  Scenario: Configure locale fallback chain for regional variants
    When I configure fallback chain for "es-MX":
      | priority | fallback_locale | usage_condition                    |
      | 1        | es-419          | Latin American Spanish available   |
      | 2        | es-ES           | European Spanish available         |
      | 3        | en-US           | Ultimate fallback                  |
    Then fallback behavior should be configured:
      | scenario                          | displayed_locale |
      | Mexican Spanish available         | es-MX            |
      | Mexican missing, LATAM available  | es-419           |
      | Both missing, Spain available     | es-ES            |
      | All Spanish missing               | en-US            |
    And fallback usage should be tracked:
      | metric                     | tracked |
      | Fallback frequency         | yes     |
      | Strings using fallback     | yes     |
      | User impact                | yes     |
    And a warning should display when fallback content is shown

  Scenario: Manage locale activation and deactivation
    Given locale "hi-IN" exists with status "draft"
    When I activate locale "hi-IN" after completing prerequisites:
      | prerequisite               | status    |
      | Core UI translation > 90%  | completed |
      | Legal documents complete   | completed |
      | Cultural review passed     | completed |
      | QA testing passed          | completed |
    Then locale should become active
    And users should be able to select Hindi
    And analytics should begin tracking Hindi usage
    When I later deactivate locale "hi-IN"
    Then users should be migrated to fallback locale
    And content should remain for potential reactivation
    And a LocaleDeactivated event should be published

  # ============================================
  # TRANSLATION WORKFLOWS
  # ============================================

  Scenario: View translation management dashboard
    When I view the translation dashboard
    Then I should see pending translations:
      | job_id    | content_type  | source | targets         | strings | deadline   | status    |
      | TRN-001   | UI v3.2       | en-US  | es-ES, fr-FR    | 150     | 2025-01-10 | in_progress|
      | TRN-002   | Marketing Q1  | en-US  | all_active      | 85      | 2025-01-15 | pending   |
      | TRN-003   | Help articles | en-US  | ja-JP, zh-CN    | 320     | 2025-01-20 | in_progress|
    And I should see in-progress translations with progress:
      | job_id    | translator      | progress | quality_score | eta        |
      | TRN-001   | Maria Garcia    | 65%      | 96%           | 2025-01-08 |
      | TRN-003   | Yuki Tanaka     | 45%      | 98%           | 2025-01-18 |
    And I should see translation completion rate by locale:
      | locale | completion_rate | pending_strings | avg_turnaround |
      | es-ES  | 95%             | 125             | 3 days         |
      | fr-FR  | 93%             | 175             | 4 days         |
      | de-DE  | 94%             | 150             | 3 days         |
      | ja-JP  | 90%             | 250             | 5 days         |

  Scenario: Create translation job with full workflow
    When I create translation job with the following details:
      | field              | value                              |
      | job_name           | UI Strings v3.2                    |
      | content_type       | UI strings                         |
      | source_locale      | en-US                              |
      | target_locales     | es-ES, fr-FR, de-DE, ja-JP         |
      | string_count       | 150                                |
      | context_provided   | yes (screenshots attached)         |
      | deadline           | 2025-01-15                         |
      | priority           | high                               |
      | review_required    | yes                                |
      | glossary           | v2.5                               |
      | translation_memory | enabled                            |
    Then job should be created with:
      | field              | value                    |
      | job_id             | TRN-004                  |
      | status             | pending_assignment       |
      | estimated_cost     | $2,250                   |
      | sub_jobs           | 4 (one per target)       |
    And translators should be assigned based on:
      | criteria           | weight |
      | Language expertise | 40%    |
      | Domain knowledge   | 30%    |
      | Availability       | 20%    |
      | Past performance   | 10%    |
    And translators should be notified with job details
    And a TranslationJobCreated domain event should be published

  Scenario: Review translation with side-by-side comparison
    Given translation job "TRN-001" is submitted for review for locale "es-ES"
    When I open the translation review interface
    Then I should see source and target side-by-side:
      | string_id | source (en-US)          | target (es-ES)            | status    |
      | STR-001   | Welcome back!           | ¡Bienvenido de nuevo!     | pending   |
      | STR-002   | Your score is {points}  | Tu puntuación es {points} | pending   |
      | STR-003   | Join a league           | Únete a una liga          | pending   |
    And I should see translation quality indicators:
      | indicator          | value   |
      | Glossary compliance| 98%     |
      | TM match usage     | 65%     |
      | Consistency score  | 95%     |
      | Length variance    | +12%    |
    And I should be able to approve or request changes per string
    And I should be able to add contextual comments

  Scenario: Approve translation batch with quality checks
    Given all translations for "fr-FR" v2.5 are reviewed
    When I approve the translation batch
    Then quality checks should run:
      | check                  | result  | details                    |
      | Placeholder integrity  | passed  | All {variables} preserved  |
      | Length limits          | passed  | Within UI constraints      |
      | Glossary compliance    | passed  | 100% term consistency      |
      | Spell check            | passed  | No errors detected         |
      | Grammar check          | passed  | No issues found            |
    And translations should be published:
      | step                   | status    |
      | Export to codebase     | completed |
      | Cache invalidation     | completed |
      | CDN deployment         | completed |
    And French users should see updated content
    And a TranslationPublished domain event should be published with:
      | field              | value                    |
      | locale             | fr-FR                    |
      | version            | 2.5                      |
      | strings_published  | 150                      |
      | published_by       | current_user_id          |

  Scenario: Request translation revision with detailed feedback
    Given translation for string "STR-045" has quality issues
    When I request revision with the following feedback:
      | field              | value                              |
      | string_id          | STR-045                            |
      | issue_type         | Incorrect terminology              |
      | current_translation| Selecciona tu equipo favorito      |
      | expected_term      | Use "roster" not "equipo"          |
      | glossary_reference | TERM-089                           |
      | comment            | Per glossary, "roster" = "plantilla"|
    Then translator should be notified with:
      | notification_field | value                              |
      | urgency            | high                               |
      | deadline           | original + 2 days                  |
      | context            | Screenshot attached                |
    And revision should be tracked in the job history
    And revision metrics should update:
      | metric                    | value   |
      | Revisions this job        | 5       |
      | Translator revision rate  | 3.2%    |

  Scenario: Enable and manage machine translation
    When I enable machine translation for "pt-BR" with configuration:
      | setting                | value                    |
      | mt_provider            | Google Cloud Translation |
      | confidence_threshold   | 0.85                     |
      | auto_publish           | disabled                 |
      | human_review_required  | always                   |
      | glossary_enforcement   | strict                   |
      | domain_model           | technology               |
    Then content should be auto-translated:
      | metric                 | value    |
      | Strings translated     | 2,500    |
      | Avg confidence         | 0.91     |
      | Below threshold        | 125      |
    And translations should be flagged for review:
      | flag_reason            | count    |
      | Low confidence         | 125      |
      | New terminology        | 45       |
      | Length variance > 30%  | 32       |
    And quality score should be calculated per string
    And cost savings should be tracked vs human translation

  # ============================================
  # CONTENT LOCALIZATION
  # ============================================

  Scenario: Submit content for cultural sensitivity review
    When I submit content for cultural review:
      | content_id | content_type | description              | target_locales    |
      | IMG-001    | Image        | Hero banner with family  | ar-SA, ja-JP, in-ID|
      | VID-001    | Video        | Product demo             | zh-CN, ar-SA       |
      | TXT-001    | Marketing    | Campaign headline        | all_active         |
    Then content should be queued for review:
      | content_id | queue_position | estimated_review_time |
      | IMG-001    | 3              | 2 business days       |
      | VID-001    | 5              | 3 business days       |
      | TXT-001    | 1              | 1 business day        |
    And cultural experts should be assigned:
      | content_id | expert              | region        | specialization  |
      | IMG-001    | Ahmed Hassan        | Middle East   | Islamic culture |
      | IMG-001    | Yuki Sato           | Japan         | Visual culture  |
      | VID-001    | Li Wei              | China         | Media compliance|
    And deadline should be set based on priority and complexity

  Scenario: Flag and handle culturally sensitive content
    Given image "IMG-001" is under review for "ar-SA"
    When cultural reviewer Ahmed Hassan flags the content:
      | flag_field         | value                                |
      | issue_type         | Religious sensitivity                |
      | severity           | high                                 |
      | description        | Image shows mixed-gender gathering without appropriate context |
      | affected_locales   | ar-SA, ae-AE, kw-KW                  |
      | recommendation     | Replace with gender-appropriate or family-focused image |
    Then content should be blocked for target locales:
      | locale | status  | reason                    |
      | ar-SA  | blocked | Cultural review flag      |
      | ae-AE  | blocked | Same cultural region      |
      | kw-KW  | blocked | Same cultural region      |
    And alternative content should be requested:
      | request_type       | details                    |
      | Alternative image  | Family-focused variant     |
      | Deadline           | 5 business days            |
      | Assigned to        | Creative team              |
    And a CulturalIssueFlagged domain event should be published
    And content team should be notified of the block

  Scenario: Manage locale-specific content variants
    When I configure content variants for "hero-banner":
      | variant_id | locale | content_url                    | description           |
      | HB-001-US  | en-US  | /images/hero-us-family.jpg     | American family       |
      | HB-001-JP  | ja-JP  | /images/hero-jp-cherry.jpg     | Cherry blossom theme  |
      | HB-001-SA  | ar-SA  | /images/hero-sa-geometric.jpg  | Geometric pattern     |
      | HB-001-CN  | zh-CN  | /images/hero-cn-lantern.jpg    | Lantern festival      |
      | HB-001-DE  | de-DE  | /images/hero-eu-family.jpg     | European family       |
    Then content routing should be configured:
      | user_locale | displayed_variant | fallback_if_missing |
      | en-US       | HB-001-US         | N/A                 |
      | ja-JP       | HB-001-JP         | HB-001-US           |
      | ar-SA       | HB-001-SA         | HB-001-US           |
      | es-ES       | HB-001-DE         | HB-001-US (Europe)  |
    And A/B testing should be available for variant performance
    And variant analytics should track engagement by locale

  Scenario: Configure and verify date, number, and currency formatting
    When I view content in locale "de-DE"
    Then dates should display correctly:
      | date_value           | displayed_as      |
      | 2024-12-29           | 29.12.2024        |
      | 2024-01-05 14:30     | 05.01.2024, 14:30 |
      | Relative: 2 days ago | vor 2 Tagen       |
    And numbers should display correctly:
      | number_value | displayed_as |
      | 1234.56      | 1.234,56     |
      | 1000000      | 1.000.000    |
      | 0.5          | 0,5          |
    And currency should display correctly:
      | amount    | displayed_as   |
      | 99.99     | 99,99 €        |
      | 1234.50   | 1.234,50 €     |
    And these formats should apply consistently across:
      | area           | formatted |
      | UI labels      | yes       |
      | Reports        | yes       |
      | Exports        | yes       |
      | Email content  | yes       |

  # ============================================
  # CULTURAL PREFERENCES
  # ============================================

  Scenario: Configure comprehensive regional customizations
    When I configure customizations for "ja-JP":
      | category         | setting           | value                   | rationale                    |
      | Communication    | greeting_style    | very_formal             | Japanese business culture    |
      | Communication    | honorifics        | enabled                 | san, sama suffixes           |
      | Communication    | apology_frequency | high                    | Cultural expectation         |
      | Visual           | color_scheme      | subtle_muted            | Preference for understated   |
      | Visual           | imagery_style     | illustrated             | Anime/manga influence        |
      | Visual           | whitespace        | generous                | Ma concept                   |
      | Interaction      | humor_level       | minimal                 | Context-dependent humor      |
      | Interaction      | directness        | indirect                | Tatemae/honne distinction    |
      | Content          | detail_level      | comprehensive           | Thorough information expected|
    Then preferences should apply to Japanese users
    And content should adapt according to preferences
    And A/B testing should validate preference effectiveness

  Scenario: Manage cultural color preferences with meaning mapping
    When I configure color semantics for "zh-CN":
      | color   | western_meaning  | chinese_meaning     | usage_guideline              |
      | red     | danger/stop      | luck/prosperity     | Use for success, celebration |
      | white   | purity/clean     | death/mourning      | Avoid for celebrations       |
      | yellow  | caution          | royalty/sacred      | Use with cultural respect    |
      | green   | go/success       | growth/harmony      | Safe for positive indicators |
      | black   | formal/elegant   | water element       | Neutral usage                |
    Then color usage should adapt for Chinese locale:
      | ui_element           | original_color | adapted_color |
      | Success message      | green          | red           |
      | Error message        | red            | red (context) |
      | Celebration banner   | white bg       | red bg        |
      | Achievement badge    | gold           | gold          |
    And color override rules should be documented
    And accessibility should be maintained

  Scenario: Configure and manage holiday calendars
    When I add holidays for "ja-JP" calendar:
      | date         | name              | type         | business_impact  |
      | 2025-01-01   | Shogatsu          | National     | Office closed    |
      | 2025-01-02   | Shogatsu          | National     | Office closed    |
      | 2025-01-03   | Shogatsu          | National     | Office closed    |
      | 2025-02-11   | National Foundation| National    | Office closed    |
      | 2025-05-03   | Constitution Day  | National     | Golden Week      |
      | 2025-05-04   | Greenery Day      | National     | Golden Week      |
      | 2025-05-05   | Children's Day    | National     | Golden Week      |
      | 2025-08-13   | Obon              | Observance   | Many on holiday  |
      | 2025-08-14   | Obon              | Observance   | Many on holiday  |
      | 2025-08-15   | Obon              | Observance   | Many on holiday  |
    Then marketing should respect holidays:
      | holiday_period | marketing_action                    |
      | Shogatsu       | Schedule New Year campaigns         |
      | Golden Week    | Avoid new launches                  |
      | Obon           | Reduce promotional activity         |
    And notifications should be adjusted:
      | notification_type | during_holiday         |
      | Promotional       | Delayed/suppressed     |
      | Transactional     | Normal (with awareness)|
      | Support           | Adjusted SLA           |
    And support hours should reflect holiday schedules

  # ============================================
  # CULTURAL COMPLIANCE
  # ============================================

  Scenario: View cultural compliance monitoring dashboard
    When I view cultural compliance dashboard
    Then I should see compliance score by region:
      | region          | score | trend | issues_critical | issues_high | issues_medium |
      | North America   | 98%   | +1%   | 0               | 1           | 3             |
      | Europe          | 96%   | stable| 0               | 2           | 5             |
      | Asia Pacific    | 92%   | -2%   | 1               | 5           | 15            |
      | Middle East     | 94%   | +3%   | 0               | 3           | 8             |
      | Latin America   | 95%   | +1%   | 0               | 2           | 6             |
    And I should see flagged content requiring attention:
      | content_id | type    | locale | issue              | severity | age_days |
      | IMG-089    | Image   | zh-CN  | Political symbol   | critical | 2        |
      | VID-045    | Video   | ar-SA  | Gender mixing      | high     | 5        |
      | TXT-123    | Copy    | ja-JP  | Inappropriate humor| medium   | 8        |
    And I should see remediation status:
      | status       | count | avg_resolution_time |
      | Open         | 24    | N/A                 |
      | In Progress  | 12    | 3 days (so far)     |
      | Resolved     | 156   | 5.2 days            |
      | Escalated    | 3     | 12 days             |

  Scenario: Conduct cultural risk assessment for new content
    When I submit new marketing campaign for cultural risk assessment:
      | field              | value                              |
      | campaign_id        | MKT-2025-Q1                        |
      | content_types      | Images, Videos, Copy               |
      | target_markets     | Global (all active locales)        |
      | launch_date        | 2025-02-01                         |
    Then cultural analysis should run:
      | analysis_type           | scope                    |
      | Image analysis          | 45 images                |
      | Video analysis          | 12 videos                |
      | Text analysis           | 85 copy blocks           |
      | Symbol detection        | All visual content       |
      | Color analysis          | All visual content       |
    And risk score should be calculated per locale:
      | locale | risk_score | high_risk_items | recommendation         |
      | en-US  | Low        | 0               | Proceed                |
      | zh-CN  | High       | 3               | Review required        |
      | ar-SA  | Medium     | 1               | Minor adjustments      |
      | ja-JP  | Low        | 0               | Proceed                |
    And detailed recommendations should be provided:
      | item       | locale | risk           | recommendation              |
      | IMG-023    | zh-CN  | Map issue      | Use China-approved map      |
      | VID-008    | ar-SA  | Music content  | Replace background music    |
      | IMG-034    | zh-CN  | Taiwan reference| Remove or modify           |

  Scenario: Define and enforce cultural content standards
    When I define cultural standard for region "Middle East":
      | standard_id | category       | rule                                    | enforcement |
      | ME-001      | Imagery        | No alcohol imagery or references        | Block       |
      | ME-002      | Imagery        | Modest dress code in images             | Block       |
      | ME-003      | Imagery        | No pork product imagery                 | Block       |
      | ME-004      | Content        | No religious criticism                  | Block       |
      | ME-005      | Timing         | Respect Ramadan sensitivity             | Warn        |
      | ME-006      | Gender         | Appropriate mixed-gender representation | Warn        |
    Then content should be validated against standards:
      | validation_stage | action                              |
      | Upload           | Automatic scan against rules        |
      | Pre-publish      | Manual review for flagged items     |
      | Post-publish     | Continuous monitoring               |
    And violations should be handled:
      | violation_type | action                              |
      | Block rule     | Content blocked, review required    |
      | Warn rule      | Warning to publisher, proceed allowed|
    And compliance reports should be generated monthly

  # ============================================
  # CULTURAL EXPERT MANAGEMENT
  # ============================================

  Scenario: Request cultural expert consultation
    When I request expert consultation with the following details:
      | field              | value                              |
      | region             | ar-SA                              |
      | topic              | Islamic cultural sensitivity       |
      | content            | New game character designs         |
      | content_items      | 12 character illustrations         |
      | urgency            | high                               |
      | deadline           | 2025-01-10                         |
      | context            | Fantasy game with Arabic themes    |
    Then consultation request should be created:
      | field              | value                    |
      | request_id         | CONSULT-2025-001         |
      | status             | pending_assignment       |
      | estimated_hours    | 8                        |
    And appropriate expert should be assigned:
      | expert_field       | value                              |
      | name               | Dr. Fatima Al-Hassan               |
      | specialization     | Islamic art and cultural studies   |
      | availability       | Confirmed                          |
      | rating             | 4.9/5.0                            |
    And expert should be notified with all context materials
    And consultation session should be scheduled

  Scenario: Track and implement expert recommendations
    Given cultural expert has provided recommendations:
      | rec_id   | item           | current_issue         | recommendation                |
      | REC-001  | Character A    | Inappropriate attire  | Add flowing outer garment     |
      | REC-002  | Character B    | Religious symbol misuse| Remove or redesign accessory |
      | REC-003  | Background     | Mosque depiction      | Stylize to avoid specificity  |
      | REC-004  | Color palette  | Green prominence      | Balance with other colors     |
    When I view recommendations
    Then I should see all suggestions with:
      | field              | displayed                 |
      | Original content   | Side-by-side comparison   |
      | Issue description  | Detailed explanation      |
      | Recommended change | Specific guidance         |
      | Cultural rationale | Educational context       |
    And I should be able to accept or reject each:
      | decision | workflow                            |
      | Accept   | Route to design team                |
      | Reject   | Require justification, escalate     |
      | Modify   | Request alternative from expert     |
    And implementation should be tracked:
      | rec_id   | decision | implementation_status | verified |
      | REC-001  | Accepted | Completed             | Yes      |
      | REC-002  | Accepted | In progress           | No       |
      | REC-003  | Modified | Pending design        | No       |
      | REC-004  | Accepted | Completed             | Yes      |

  # ============================================
  # INTERNATIONALIZATION TESTING
  # ============================================

  Scenario: Run comprehensive cultural adaptation test suite
    When I run cultural adaptation test suite for locale "de-DE"
    Then text expansion should be validated:
      | test_case              | source_length | target_length | overflow |
      | Button labels          | 10 chars      | 15 chars      | No       |
      | Menu items             | 15 chars      | 22 chars      | No       |
      | Error messages         | 50 chars      | 72 chars      | No       |
      | Long descriptions      | 200 chars     | 285 chars     | Yes (1)  |
    And date/number formats should be verified:
      | format_type | test_value    | expected_output | actual_output | pass |
      | Date        | 2024-12-29    | 29.12.2024      | 29.12.2024    | Yes  |
      | Number      | 1234567.89    | 1.234.567,89    | 1.234.567,89  | Yes  |
      | Currency    | 99.99         | 99,99 €         | 99,99 €       | Yes  |
      | Percentage  | 0.4523        | 45,23 %         | 45,23 %       | Yes  |
    And UI layout should be validated:
      | component        | issue_detected | severity |
      | Navigation       | None           | N/A      |
      | Forms            | None           | N/A      |
      | Tables           | Minor overflow | Low      |
      | Modals           | None           | N/A      |
    And test report should be generated with all findings

  Scenario: Test text expansion for long translations
    When I test UI with German translations specifically for expansion:
      | component      | english_text           | german_text                    | expansion | fits |
      | Submit button  | Submit                 | Absenden                       | 60%       | Yes  |
      | Cancel link    | Cancel                 | Abbrechen                      | 28%       | Yes  |
      | Page title     | League Settings        | Liga-Einstellungen             | 50%       | Yes  |
      | Error msg      | Invalid email address  | Ungültige E-Mail-Adresse       | 35%       | No   |
    Then overflow issues should be flagged:
      | component | issue                 | recommendation           |
      | Error msg | Text truncated at 280px| Increase container width|
    And responsive breakpoints should be tested
    And solutions should be suggested:
      | solution_type    | applicability |
      | Container resize | Preferred     |
      | Text abbreviation| If space limited|
      | Tooltip on hover | For labels    |

  Scenario: Test pseudo-localization for development
    When I enable pseudo-localization mode with settings:
      | setting              | value                    |
      | character_expansion  | 30%                      |
      | accent_characters    | enabled                  |
      | brackets             | [[ ]]                    |
      | detect_concatenation | enabled                  |
    Then text should be transformed:
      | original            | pseudo                              |
      | Welcome             | [[Ŵéļçöɱé]]                        |
      | Submit              | [[Šûƀɱïţ]]                         |
      | Hello, {name}!      | [[Ĥéļļö, {name}!]]                 |
    And hardcoded strings should be visible:
      | finding_type           | count | example               |
      | Untranslated strings   | 5     | "OK" button           |
      | Concatenated strings   | 3     | "Hello" + " " + name  |
      | Date format hardcoded  | 2     | MM/DD/YYYY format     |
    And localization issues should be identified for fixing

  Scenario: Validate character encoding across locales
    When I test character encoding with locale "zh-CN":
      | test_area            | test_content              | result  | issue         |
      | Database storage     | 中文测试内容               | Passed  | None          |
      | API response         | 汉字显示正确               | Passed  | None          |
      | PDF export           | 导出中文内容               | Passed  | None          |
      | Email content        | 邮件中文测试               | Passed  | None          |
      | File download names  | 报告_2024年.pdf           | Passed  | None          |
    Then Chinese characters should render correctly in all areas
    And font fallbacks should work:
      | primary_font    | fallback_font  | characters_supported |
      | System default  | Noto Sans CJK  | 100%                 |
    And no mojibake (garbled characters) should appear

  # ============================================
  # LANGUAGE FALLBACKS
  # ============================================

  Scenario: Configure global fallback behavior
    When I configure global fallback settings:
      | setting                    | value                    |
      | default_fallback_locale    | en-US                    |
      | show_fallback_indicator    | true                     |
      | indicator_style            | subtle_badge             |
      | log_fallback_usage         | true                     |
      | alert_threshold            | 5% of requests           |
      | auto_create_translation_job| true                     |
    Then settings should apply to all locales without explicit fallback
    And users should see fallback indicator when applicable
    And fallback usage should be logged for analytics

  Scenario: Analyze and prioritize translation gaps
    When I view fallback analytics
    Then I should see fallback frequency by locale:
      | locale | fallback_rate | requests_with_fallback | trend  |
      | ko-KR  | 22%           | 45,000                 | -3%    |
      | vi-VN  | 35%           | 28,000                 | -5%    |
      | th-TH  | 18%           | 32,000                 | stable |
      | id-ID  | 12%           | 52,000                 | -2%    |
    And I should see most common missing translations:
      | string_key           | missing_in_locales | requests_monthly |
      | error.network.timeout| ko-KR, vi-VN       | 12,500           |
      | feature.new.badge    | ko-KR, th-TH       | 8,200            |
      | settings.advanced    | vi-VN, id-ID       | 6,800            |
    And I should see prioritized translation backlog:
      | priority | string_key           | impact_score | estimated_effort |
      | 1        | error.network.timeout| 95           | 1 hour           |
      | 2        | feature.new.badge    | 82           | 30 min           |
      | 3        | settings.advanced    | 68           | 45 min           |

  # ============================================
  # CULTURAL ANALYTICS
  # ============================================

  Scenario: Measure cultural adaptation effectiveness
    When I view cultural adaptation metrics
    Then I should see engagement by locale:
      | locale | dau        | session_length | pages_per_session | bounce_rate |
      | en-US  | 125,000    | 12.5 min       | 8.2               | 25%         |
      | ja-JP  | 85,000     | 15.2 min       | 10.5              | 18%         |
      | de-DE  | 62,000     | 11.8 min       | 7.8               | 28%         |
      | es-ES  | 48,000     | 13.1 min       | 9.1               | 22%         |
    And I should see conversion by region:
      | region          | visitors   | conversions | rate  | vs_baseline |
      | North America   | 250,000    | 12,500      | 5.0%  | baseline    |
      | Europe          | 180,000    | 8,100       | 4.5%  | -10%        |
      | Asia Pacific    | 210,000    | 8,400       | 4.0%  | -20%        |
      | Latin America   | 85,000     | 4,250       | 5.0%  | 0%          |
    And I should see cultural satisfaction scores:
      | locale | satisfaction | cultural_relevance | language_quality |
      | en-US  | 4.5/5        | 4.6/5              | 4.8/5            |
      | ja-JP  | 4.3/5        | 4.4/5              | 4.5/5            |
      | ar-SA  | 4.1/5        | 4.0/5              | 4.3/5            |

  Scenario: Analyze regional performance and identify opportunities
    When I compare performance across regions
    Then I should see KPIs by locale:
      | kpi                  | en-US  | ja-JP  | de-DE  | ar-SA  |
      | Revenue per user     | $12.50 | $15.20 | $11.80 | $8.50  |
      | Retention (30-day)   | 45%    | 52%    | 42%    | 38%    |
      | NPS score            | 42     | 48     | 38     | 35     |
      | Support ticket rate  | 2.1%   | 1.5%   | 2.8%   | 4.2%   |
    And I should identify underperforming regions:
      | region       | underperformance_areas        | potential_causes          |
      | Middle East  | Support tickets, NPS          | Cultural adaptation gaps  |
      | Europe/DE    | NPS, Conversion               | Translation quality       |
    And I should see improvement opportunities:
      | opportunity               | region  | projected_impact | effort   |
      | Improve ar-SA localization| MENA    | +15% retention   | High     |
      | German UX improvements    | Europe  | +8% conversion   | Medium   |
      | Add Korean support        | APAC    | +$200K revenue   | High     |

  Scenario: Track localization return on investment
    When I view localization ROI dashboard
    Then I should see cost per locale:
      | locale | setup_cost | annual_maintenance | total_investment |
      | es-ES  | $25,000    | $12,000            | $37,000          |
      | de-DE  | $28,000    | $14,000            | $42,000          |
      | ja-JP  | $45,000    | $18,000            | $63,000          |
      | zh-CN  | $52,000    | $22,000            | $74,000          |
    And I should see revenue by locale:
      | locale | annual_revenue | growth_rate | attributed_to_localization |
      | es-ES  | $450,000       | 15%         | $180,000                   |
      | de-DE  | $520,000       | 12%         | $208,000                   |
      | ja-JP  | $890,000       | 25%         | $445,000                   |
      | zh-CN  | $1,200,000     | 35%         | $720,000                   |
    And I should see ROI per market:
      | locale | investment | attributed_revenue | roi    | payback_period |
      | es-ES  | $37,000    | $180,000           | 386%   | 3 months       |
      | de-DE  | $42,000    | $208,000           | 395%   | 3 months       |
      | ja-JP  | $63,000    | $445,000           | 606%   | 2 months       |
      | zh-CN  | $74,000    | $720,000           | 873%   | 1 month        |

  # ============================================
  # CULTURAL FEEDBACK INTEGRATION
  # ============================================

  Scenario: Collect and categorize cultural feedback from users
    When users report cultural issues through feedback channel
    Then feedback should be categorized:
      | feedback_id | locale | category          | severity | status    |
      | FB-001      | ja-JP  | Translation error | medium   | Open      |
      | FB-002      | ar-SA  | Cultural offense  | high     | In review |
      | FB-003      | zh-CN  | UI/UX issue       | low      | Open      |
      | FB-004      | de-DE  | Formatting error  | medium   | Resolved  |
    And priority should be assigned based on:
      | factor              | weight |
      | Severity            | 40%    |
      | User count affected | 30%    |
      | Revenue impact      | 20%    |
      | Brand risk          | 10%    |
    And I should be able to track resolution:
      | feedback_id | assigned_to      | resolution_deadline | status    |
      | FB-002      | Cultural team    | 2025-01-02          | In review |
    And resolution should trigger user notification

  Scenario: Deploy and analyze cultural satisfaction survey
    When I deploy cultural satisfaction survey:
      | field              | value                              |
      | survey_name        | Cultural Experience Survey Q4      |
      | target_locales     | ja-JP, ar-SA, zh-CN, de-DE         |
      | sample_size        | 500 per locale                     |
      | questions          | 10 (Likert scale + open-ended)     |
    Then responses should be collected by locale:
      | locale | responses | completion_rate | avg_time   |
      | ja-JP  | 485       | 97%             | 4.5 min    |
      | ar-SA  | 462       | 92%             | 5.2 min    |
      | zh-CN  | 478       | 96%             | 4.8 min    |
      | de-DE  | 455       | 91%             | 4.1 min    |
    And sentiment should be analyzed:
      | locale | positive | neutral | negative | key_themes              |
      | ja-JP  | 72%      | 20%     | 8%       | Politeness, accuracy    |
      | ar-SA  | 65%      | 22%     | 13%      | RTL issues, imagery     |
      | zh-CN  | 70%      | 18%     | 12%      | Translation quality     |
      | de-DE  | 68%      | 25%     | 7%       | Formality, precision    |
    And actionable insights should be generated

  # ============================================
  # CULTURAL TRAINING
  # ============================================

  Scenario: Assign and track cultural awareness training
    When I assign cultural training to content team:
      | module                  | required | deadline   | duration |
      | Cultural Sensitivity 101| Yes      | 2025-01-31 | 2 hours  |
      | Regional Customs        | Yes      | 2025-02-15 | 3 hours  |
      | Religious Awareness     | Yes      | 2025-02-28 | 2 hours  |
      | Color and Symbolism     | No       | 2025-03-15 | 1 hour   |
      | RTL Design Principles   | No       | 2025-03-15 | 1.5 hours|
    Then training should be assigned to team:
      | team_member      | modules_assigned | status          |
      | John Smith       | 5                | Not started     |
      | Maria Garcia     | 5                | 1 completed     |
      | Yuki Tanaka      | 3 (Japanese exempt)| 2 completed  |
    And completion should be tracked:
      | module                  | assigned | completed | completion_rate |
      | Cultural Sensitivity 101| 25       | 18        | 72%             |
      | Regional Customs        | 25       | 12        | 48%             |
      | Religious Awareness     | 25       | 8         | 32%             |
    And certificates should be issued upon completion
    And reminders should be sent for upcoming deadlines

  # ============================================
  # CROSS-CULTURAL DEVELOPMENT
  # ============================================

  Scenario: Configure cross-cultural review process
    When I set up cross-cultural review process:
      | review_stage | required_approvers                    | threshold |
      | Initial      | Source locale owner                   | 1 of 1    |
      | Cultural     | Regional cultural expert              | 1 per region|
      | Final        | Localization manager                  | 1 of 1    |
    Then content should require multi-region approval:
      | content_id | stage    | approvers_required | approvers_received |
      | CNT-001    | Cultural | 4                  | 2                  |
    And cultural reviewers should be assigned per region:
      | region          | reviewer            | specialization        |
      | North America   | Auto-approved       | N/A                   |
      | Europe          | Hans Mueller        | German/EU markets     |
      | Asia Pacific    | Li Wei, Yuki Sato   | APAC markets          |
      | Middle East     | Ahmed Hassan        | MENA markets          |
    And approval workflow should be enforced with SLAs

  Scenario: Coordinate global content release with cultural awareness
    When I schedule global content release for "Feature Update 3.0":
      | field              | value                              |
      | content            | UI updates, new features           |
      | target_date        | 2025-02-01                         |
      | target_locales     | All active (10 locales)            |
    Then timezone differences should be considered:
      | locale | local_release_time | utc_time        |
      | en-US  | 09:00 PST          | 17:00 UTC       |
      | ja-JP  | 09:00 JST          | 00:00 UTC       |
      | de-DE  | 09:00 CET          | 08:00 UTC       |
    And cultural events should be checked:
      | locale | conflict_date | event             | recommendation         |
      | zh-CN  | 2025-01-29    | Chinese New Year  | Delay to Feb 15        |
      | ar-SA  | None          | N/A               | Proceed as planned     |
    And staggered rollout should be suggested:
      | wave | locales              | timing          | percentage |
      | 1    | en-US, en-GB         | Feb 1, 09:00 PT | 25%        |
      | 2    | de-DE, fr-FR, es-ES  | Feb 3, 09:00 CET| 25%        |
      | 3    | ja-JP, ko-KR         | Feb 5, 09:00 JST| 25%        |
      | 4    | zh-CN, ar-SA, others | Feb 17          | 25%        |

  # ============================================
  # DOMAIN EVENTS
  # ============================================

  Scenario: LocaleAdded event triggers downstream setup
    When LocaleAdded event is published for "pt-BR"
    Then the following should be triggered:
      | downstream_action         | status    | assigned_to        |
      | Translation job creation  | Created   | Localization team  |
      | Content audit initiation  | Scheduled | Content team       |
      | Cultural review request   | Pending   | Brazilian expert   |
      | Legal document translation| Created   | Legal + translation|
      | Regional team notification| Sent      | LATAM team         |
    And locale setup progress should be tracked
    And estimated completion date should be calculated

  Scenario: TranslationPublished event triggers cache refresh
    When TranslationPublished event is published for "de-DE v2.6"
    Then the following should occur:
      | action                    | result                    |
      | CDN cache invalidation    | de-DE content purged      |
      | Application cache refresh | Locale bundle updated     |
      | Analytics event           | Translation deploy logged |
      | QA notification           | Smoke test requested      |
    And German users should see new translations within 5 minutes

  # ============================================
  # ERROR SCENARIOS
  # ============================================

  Scenario: Handle missing translation gracefully with user experience
    Given translation is missing for "nl-NL" for string "feature.new.premium"
    When Dutch user accesses content requiring this string
    Then fallback content should display:
      | fallback_chain | attempted | result      |
      | nl-BE          | Yes       | Not found   |
      | en-GB          | Yes       | Not found   |
      | en-US          | Yes       | Found       |
    And fallback indicator should show (if enabled)
    And missing translation should be logged:
      | log_field          | value                    |
      | string_key         | feature.new.premium      |
      | requested_locale   | nl-NL                    |
      | fallback_used      | en-US                    |
      | user_count_24h     | 245                      |
    And translation request should be auto-created if threshold exceeded

  Scenario: Handle cultural review timeout with escalation
    Given cultural review for "IMG-089" in "zh-CN" exceeds 5-day deadline
    When timeout occurs
    Then escalation should trigger:
      | escalation_level | recipient            | action                   |
      | Level 1          | Cultural team lead   | Reminder sent            |
      | Level 2          | Localization manager | Priority escalation      |
      | Level 3          | VP of Content        | Executive notification   |
    And content should remain blocked:
      | content_id | locale | status  | reason              |
      | IMG-089    | zh-CN  | Blocked | Pending review      |
    And stakeholders should be notified:
      | stakeholder      | notification                      |
      | Marketing team   | Campaign delay notification       |
      | Product team     | Feature launch impact assessment  |
    And alternative content options should be suggested

  Scenario: Handle translation provider failure
    Given translation provider "Google Cloud Translation" is unavailable
    When machine translation is requested for "vi-VN"
    Then failover should activate:
      | step | action                              |
      | 1    | Retry primary provider (3 attempts) |
      | 2    | Failover to secondary (DeepL)       |
      | 3    | Queue for human translation         |
    And degraded service notification should display
    And SLA tracking should adjust expectations
    And incident should be logged for post-mortem
