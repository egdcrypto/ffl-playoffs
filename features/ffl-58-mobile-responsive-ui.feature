@mobile @responsive @ui @frontend
Feature: FFL-58: Mobile Responsive UI
  As a mobile user
  I want the FFL Playoffs application to work seamlessly on my device
  So that I can manage my fantasy football team from anywhere

  Background:
    Given the FFL Playoffs application is loaded
    And responsive CSS is enabled
    And viewport meta tag is configured correctly

  # ==========================================
  # VIEWPORT AND BREAKPOINTS
  # ==========================================

  @viewport @breakpoints
  Scenario Outline: Application responds to different viewport sizes
    Given I am viewing the application
    When the viewport width is "<width>" pixels
    Then the layout should use "<layout_type>" configuration
    And the navigation should be "<nav_style>"
    And the content width should be appropriate for the viewport

    Examples:
      | width | layout_type | nav_style           |
      | 320   | mobile      | hamburger menu      |
      | 375   | mobile      | hamburger menu      |
      | 414   | mobile      | hamburger menu      |
      | 768   | tablet      | collapsible sidebar |
      | 1024  | tablet      | expanded sidebar    |
      | 1280  | desktop     | full navigation     |
      | 1920  | desktop     | full navigation     |

  @viewport @orientation
  Scenario: Application handles orientation changes
    Given I am viewing the application on a mobile device
    When I rotate the device from portrait to landscape
    Then the layout should smoothly transition
    And no content should be cut off
    And scroll position should be preserved
    And no horizontal scrollbar should appear

  @viewport @meta
  Scenario: Viewport meta tag is correctly configured
    Given the application HTML is loaded
    Then the viewport meta tag should include:
      | attribute          | value                    |
      | width              | device-width             |
      | initial-scale      | 1                        |
      | maximum-scale      | 5                        |
      | user-scalable      | yes                      |
    And zoom should be allowed for accessibility

  # ==========================================
  # NAVIGATION - MOBILE
  # ==========================================

  @navigation @mobile @hamburger
  Scenario: Mobile hamburger menu works correctly
    Given I am viewing the application on a mobile device
    And the viewport width is less than 768 pixels
    Then I should see a hamburger menu icon
    When I tap the hamburger menu icon
    Then a slide-out navigation drawer should appear
    And the drawer should contain all main navigation items:
      | nav_item      |
      | Dashboard     |
      | My Roster     |
      | Scores        |
      | Leaderboard   |
      | League        |
      | Settings      |

  @navigation @mobile @drawer
  Scenario: Navigation drawer behavior
    Given the navigation drawer is open
    When I tap outside the drawer
    Then the drawer should close
    When I open the drawer again
    And I swipe left on the drawer
    Then the drawer should close with a swipe animation

  @navigation @mobile @close
  Scenario: Navigation drawer closes after selection
    Given the navigation drawer is open
    When I tap on "My Roster"
    Then the drawer should close
    And I should be navigated to the roster page
    And the page transition should be smooth

  @navigation @tablet
  Scenario: Tablet navigation adapts to screen size
    Given I am viewing the application on a tablet
    When the viewport is in portrait mode (768px)
    Then I should see a collapsible sidebar
    And the sidebar should show icons only by default
    When I tap the expand button
    Then the sidebar should expand to show labels
    When the viewport is in landscape mode (1024px)
    Then the sidebar should be expanded by default

  @navigation @bottom-nav
  Scenario: Bottom navigation on mobile
    Given I am viewing the application on a mobile device
    Then I should see a bottom navigation bar
    And the bottom navigation should contain quick access items:
      | item        | icon           |
      | Home        | home icon      |
      | Roster      | roster icon    |
      | Scores      | scores icon    |
      | More        | menu icon      |
    And the active item should be highlighted

  # ==========================================
  # DASHBOARD - RESPONSIVE
  # ==========================================

  @dashboard @mobile
  Scenario: Dashboard layout on mobile
    Given I am on the dashboard page
    And the viewport width is 375 pixels
    Then dashboard cards should stack vertically
    And each card should take full width
    And the order should be:
      | position | card                |
      | 1        | Current Matchup     |
      | 2        | My Team Score       |
      | 3        | League Standings    |
      | 4        | Recent Activity     |

  @dashboard @tablet
  Scenario: Dashboard layout on tablet
    Given I am on the dashboard page
    And the viewport width is 768 pixels
    Then dashboard cards should be in a 2-column grid
    And cards should have equal heights in each row

  @dashboard @desktop
  Scenario: Dashboard layout on desktop
    Given I am on the dashboard page
    And the viewport width is 1280 pixels
    Then dashboard cards should be in a 3-column grid
    And the layout should have appropriate spacing

  @dashboard @widgets
  Scenario: Dashboard widgets are touch-friendly
    Given I am on the dashboard on a mobile device
    When I interact with dashboard widgets
    Then all interactive elements should be at least 44x44 pixels
    And there should be adequate spacing between tap targets
    And swipe gestures should work on scrollable widgets

  # ==========================================
  # ROSTER BUILDER - RESPONSIVE
  # ==========================================

  @roster @mobile @layout
  Scenario: Roster builder layout on mobile
    Given I am on the roster builder page
    And the viewport width is 375 pixels
    Then the layout should show:
      | section              | behavior                    |
      | Current Roster       | Collapsible accordion       |
      | Player Search        | Full-width search bar       |
      | Search Results       | Scrollable list             |
    And I should be able to switch between roster and search views

  @roster @mobile @tabs
  Scenario: Mobile roster uses tabbed interface
    Given I am on the roster builder on a mobile device
    Then I should see tabs for:
      | tab              |
      | My Roster        |
      | Available Players|
    When I tap "Available Players" tab
    Then the player search interface should be shown
    And my roster should be hidden

  @roster @mobile @player-card
  Scenario: Player cards are optimized for mobile
    Given I am viewing player search results on mobile
    Then each player card should show:
      | element           | visibility |
      | Player name       | Visible    |
      | Position          | Visible    |
      | Team              | Visible    |
      | Projected points  | Visible    |
      | Detailed stats    | Hidden     |
    When I tap on a player card
    Then an expanded view should show full details

  @roster @mobile @add-player
  Scenario: Adding player on mobile
    Given I am on the roster builder on mobile
    And I have found "Patrick Mahomes" in search
    When I tap on the player card
    Then I should see an action sheet with options:
      | option              |
      | Add to Roster       |
      | View Full Stats     |
      | Cancel              |
    When I tap "Add to Roster"
    Then the player should be added
    And I should see a success toast notification

  @roster @mobile @drag-drop-alternative
  Scenario: Mobile alternative to drag and drop
    Given I am on the roster builder on a touch device
    When I long-press on a player in my roster
    Then I should see a context menu with:
      | option           |
      | Move to position |
      | Remove           |
      | View stats       |
    When I tap "Move to position"
    Then I should see available position slots
    And I can tap to move the player

  @roster @tablet @split-view
  Scenario: Roster builder split view on tablet
    Given I am on the roster builder page
    And the viewport width is 1024 pixels
    Then I should see a split view layout:
      | left_panel        | right_panel       |
      | Current Roster    | Player Search     |
    And both panels should be visible simultaneously
    And drag and drop should work between panels

  # ==========================================
  # SCORES PAGE - RESPONSIVE
  # ==========================================

  @scores @mobile @layout
  Scenario: Scores page layout on mobile
    Given I am on the scores page
    And the viewport width is 375 pixels
    Then I should see:
      | section              | layout                      |
      | Matchup Header       | Stacked (me vs opponent)    |
      | Score Display        | Large, centered             |
      | Player Scores        | Scrollable list             |

  @scores @mobile @swipe
  Scenario: Swipe between my roster and opponent
    Given I am viewing the scores page on mobile
    Then I should see my roster by default
    When I swipe left
    Then I should see my opponent's roster
    When I swipe right
    Then I should see my roster again
    And swipe indicators should be visible

  @scores @mobile @live-updates
  Scenario: Live score updates on mobile
    Given I am viewing live scores on mobile
    When a player scores
    Then the score should update with animation
    And a brief notification should appear
    And the screen should not jump or refresh

  @scores @tablet
  Scenario: Scores page side-by-side on tablet
    Given I am on the scores page
    And the viewport width is 768 pixels or greater
    Then I should see my roster and opponent side by side
    And scores should be easy to compare

  # ==========================================
  # LEADERBOARD - RESPONSIVE
  # ==========================================

  @leaderboard @mobile
  Scenario: Leaderboard adapts to mobile
    Given I am on the leaderboard page
    And the viewport width is 375 pixels
    Then the table should show condensed columns:
      | visible_column    | hidden_column     |
      | Rank              | Points Against    |
      | Team              | Streak            |
      | Record            | Last 5            |
      | Points For        |                   |
    And I should be able to scroll horizontally for more data
    Or tap a row to see full details

  @leaderboard @mobile @expandable
  Scenario: Expandable leaderboard rows on mobile
    Given I am viewing the leaderboard on mobile
    When I tap on a team row
    Then the row should expand to show:
      | detail             |
      | Full record        |
      | Points for/against |
      | Streak             |
      | Playoff odds       |
    When I tap again
    Then the row should collapse

  @leaderboard @tablet
  Scenario: Leaderboard shows more columns on tablet
    Given I am on the leaderboard page
    And the viewport width is 768 pixels
    Then all relevant columns should be visible
    And the table should not require horizontal scrolling

  # ==========================================
  # FORMS - RESPONSIVE
  # ==========================================

  @forms @mobile
  Scenario: Forms are mobile-friendly
    Given I am on a page with a form on mobile
    Then form inputs should:
      | requirement                           |
      | Be full width                         |
      | Have minimum height of 44px           |
      | Have appropriate input types          |
      | Show mobile keyboard when focused     |
    And labels should be above inputs
    And submit buttons should be full width

  @forms @mobile @keyboard
  Scenario: Mobile keyboard behavior
    Given I am filling out a form on mobile
    When I tap on an email input
    Then the email keyboard should appear
    When I tap on a number input
    Then the numeric keyboard should appear
    When I tap on a date input
    Then a date picker should appear
    And the form should scroll to keep input visible

  @forms @mobile @validation
  Scenario: Form validation on mobile
    Given I submit a form with invalid data on mobile
    Then error messages should appear inline
    And the first error field should be scrolled into view
    And error messages should be clearly visible
    And tap targets for correction should be accessible

  # ==========================================
  # TOUCH INTERACTIONS
  # ==========================================

  @touch @gestures
  Scenario: Standard touch gestures are supported
    Given I am using a touch device
    Then the following gestures should work:
      | gesture         | action                          |
      | Tap             | Select/activate                 |
      | Long press      | Context menu                    |
      | Swipe           | Navigate/scroll                 |
      | Pinch           | Zoom (where applicable)         |
      | Pull down       | Refresh                         |

  @touch @pull-to-refresh
  Scenario: Pull to refresh works on key pages
    Given I am on a refreshable page on mobile:
      | page           |
      | Dashboard      |
      | Scores         |
      | Leaderboard    |
    When I pull down from the top of the content
    Then a refresh indicator should appear
    And the content should refresh
    And the indicator should disappear when complete

  @touch @haptic
  Scenario: Haptic feedback for touch interactions
    Given I am using a device with haptic feedback
    When I perform significant touch actions:
      | action                    |
      | Submit roster             |
      | Add player                |
      | Remove player             |
      | Pull to refresh complete  |
    Then appropriate haptic feedback should be provided

  @touch @tap-targets
  Scenario: Tap targets meet accessibility requirements
    Given I am viewing any page on mobile
    Then all interactive elements should:
      | requirement                              |
      | Be at least 44x44 pixels                 |
      | Have at least 8px spacing between them   |
      | Have visible focus states                |
      | Have adequate contrast                   |

  @touch @scroll
  Scenario: Scrolling is smooth and natural
    Given I am on a page with scrollable content
    When I scroll the content
    Then scrolling should use native momentum
    And scroll should be smooth at 60fps
    And overscroll should have bounce effect (iOS)
    And scroll position should be remembered

  # ==========================================
  # PERFORMANCE - MOBILE
  # ==========================================

  @performance @mobile @loading
  Scenario: Pages load quickly on mobile networks
    Given I am on a 3G mobile connection
    When I navigate to any page
    Then the page should be interactive within 3 seconds
    And first contentful paint should be under 1.5 seconds
    And the loading skeleton should appear immediately

  @performance @mobile @images
  Scenario: Images are optimized for mobile
    Given images are loaded on mobile
    Then images should:
      | optimization                           |
      | Use responsive srcset                  |
      | Load appropriate size for viewport     |
      | Use lazy loading                       |
      | Use modern formats (WebP)              |
      | Have proper compression                |

  @performance @mobile @bundle
  Scenario: JavaScript bundle is optimized for mobile
    Given the application loads on mobile
    Then the JavaScript bundle should:
      | requirement                            |
      | Be code-split by route                 |
      | Load critical JS first                 |
      | Defer non-critical JS                  |
      | Be less than 200KB gzipped (initial)   |

  @performance @mobile @offline
  Scenario: Basic offline support
    Given I have previously visited the application
    When I lose network connectivity
    Then cached pages should still be viewable
    And an offline indicator should be shown
    And actions should be queued for when online

  @performance @battery
  Scenario: Application is battery efficient
    Given I am using the application on mobile
    Then the application should:
      | efficiency_measure                     |
      | Minimize background activity           |
      | Reduce animation when battery low      |
      | Use efficient polling intervals        |
      | Not prevent device sleep unnecessarily |

  # ==========================================
  # RESPONSIVE COMPONENTS
  # ==========================================

  @components @modal
  Scenario: Modals adapt to screen size
    Given a modal is opened
    When viewed on mobile
    Then the modal should be full-screen
    And have a close button in the header
    And content should be scrollable
    When viewed on desktop
    Then the modal should be centered
    And have appropriate max-width

  @components @dropdown
  Scenario: Dropdowns are touch-friendly
    Given a dropdown is used on mobile
    When I tap the dropdown trigger
    Then a native select should be used on iOS/Android
    Or a bottom sheet picker should appear
    And options should be easily tappable

  @components @table
  Scenario: Tables are responsive
    Given a data table is displayed
    When the viewport is mobile
    Then the table should either:
      | approach                              |
      | Show priority columns with scroll     |
      | Transform to card layout              |
      | Allow horizontal scroll               |
    And data should remain readable

  @components @tabs
  Scenario: Tabs are scrollable on mobile
    Given a page has multiple tabs
    And the viewport is narrow
    Then tabs should be horizontally scrollable
    And an indicator should show more tabs exist
    And the active tab should scroll into view

  @components @cards
  Scenario: Cards reflow on different screen sizes
    Given a page displays multiple cards
    When the viewport is mobile
    Then cards should stack vertically
    And each card should be full width
    When the viewport is tablet
    Then cards should be in a 2-column grid
    When the viewport is desktop
    Then cards should be in a 3 or 4-column grid

  # ==========================================
  # DEVICE-SPECIFIC TESTING
  # ==========================================

  @device @iphone
  Scenario Outline: Application works on iPhone devices
    Given I am using an "<device>"
    When I use the application
    Then all features should work correctly
    And the safe area should be respected
    And the notch/Dynamic Island should not obscure content

    Examples:
      | device          |
      | iPhone SE       |
      | iPhone 13       |
      | iPhone 14 Pro   |
      | iPhone 15 Pro Max|

  @device @android
  Scenario Outline: Application works on Android devices
    Given I am using an "<device>"
    When I use the application
    Then all features should work correctly
    And the navigation bar should be handled
    And different screen densities should be supported

    Examples:
      | device              |
      | Samsung Galaxy S21  |
      | Google Pixel 7      |
      | Samsung Galaxy Fold |
      | OnePlus 11          |

  @device @tablet
  Scenario Outline: Application works on tablets
    Given I am using a "<device>"
    When I use the application
    Then the tablet-optimized layout should be used
    And split-view should work if supported
    And landscape mode should work well

    Examples:
      | device            |
      | iPad              |
      | iPad Pro 12.9"    |
      | Samsung Galaxy Tab|
      | Amazon Fire       |

  # ==========================================
  # ACCESSIBILITY - MOBILE
  # ==========================================

  @accessibility @mobile @voiceover
  Scenario: Application works with VoiceOver (iOS)
    Given I am using VoiceOver on iOS
    When I navigate the application
    Then all interactive elements should be announced
    And gestures should be adapted for VoiceOver
    And focus order should be logical
    And custom actions should be available

  @accessibility @mobile @talkback
  Scenario: Application works with TalkBack (Android)
    Given I am using TalkBack on Android
    When I navigate the application
    Then all interactive elements should be announced
    And touch exploration should work
    And focus should be manageable
    And actions should be accessible

  @accessibility @mobile @text-size
  Scenario: Application respects system text size
    Given I have increased system text size
    When I view the application
    Then text should scale appropriately
    And layout should adapt without breaking
    And content should remain readable
    And no text should be cut off

  @accessibility @mobile @reduce-motion
  Scenario: Application respects reduce motion setting
    Given I have enabled "Reduce Motion" in system settings
    When I use the application
    Then animations should be minimized or removed
    And transitions should be instant or very simple
    And parallax effects should be disabled

  @accessibility @mobile @dark-mode
  Scenario: Application supports dark mode
    Given my device is in dark mode
    When I view the application
    Then the UI should use dark theme colors
    And contrast should remain accessible
    And images should adapt appropriately
    And the theme should follow system preference

  # ==========================================
  # PWA FEATURES
  # ==========================================

  @pwa @install
  Scenario: Application can be installed as PWA
    Given I am using a supported mobile browser
    When I visit the application
    Then I should see an install prompt (or option)
    When I install the application
    Then it should appear on my home screen
    And it should launch in standalone mode

  @pwa @manifest
  Scenario: PWA manifest is correctly configured
    Given the application manifest is loaded
    Then it should include:
      | property           | value                    |
      | name               | FFL Playoffs             |
      | short_name         | FFL                      |
      | display            | standalone               |
      | orientation        | any                      |
      | theme_color        | Appropriate color        |
      | background_color   | Appropriate color        |
      | icons              | Multiple sizes           |

  @pwa @splash
  Scenario: PWA splash screen is configured
    Given I launch the installed PWA
    Then a splash screen should appear briefly
    And the splash screen should match the app branding
    And the transition to app should be smooth

  @pwa @status-bar
  Scenario: PWA integrates with system status bar
    Given I am using the installed PWA
    Then the status bar should be styled appropriately
    And the app should respect safe areas
    And the theme color should be applied

  # ==========================================
  # CROSS-BROWSER MOBILE TESTING
  # ==========================================

  @browser @mobile-safari
  Scenario: Application works in Mobile Safari
    Given I am using Mobile Safari on iOS
    When I use the application
    Then all features should work correctly
    And bounce scrolling should work
    And the address bar behavior should be handled
    And viewport issues should not occur

  @browser @chrome-android
  Scenario: Application works in Chrome for Android
    Given I am using Chrome on Android
    When I use the application
    Then all features should work correctly
    And the app should handle the navigation bar
    And pull-to-refresh should work
    And add to home screen should work

  @browser @samsung-internet
  Scenario: Application works in Samsung Internet
    Given I am using Samsung Internet browser
    When I use the application
    Then all features should work correctly
    And Samsung-specific features should not break

  # ==========================================
  # ERROR STATES - MOBILE
  # ==========================================

  @error @mobile @network
  Scenario: Network error handling on mobile
    Given I am using the application on mobile
    When the network connection is lost
    Then I should see a clear offline message
    And cached content should still be accessible
    And a retry option should be available
    When the connection is restored
    Then the app should recover automatically

  @error @mobile @timeout
  Scenario: Timeout handling on mobile
    Given I am on a slow connection
    When a request times out
    Then a user-friendly message should be shown
    And a retry button should be available
    And partial content should not be shown broken

  # ==========================================
  # MOBILE-SPECIFIC FEATURES
  # ==========================================

  @mobile @share
  Scenario: Native share functionality
    Given I am viewing shareable content on mobile
    When I tap the share button
    Then the native share sheet should appear
    And I should be able to share via:
      | method           |
      | Messages         |
      | Email            |
      | Social apps      |
      | Copy link        |

  @mobile @notifications
  Scenario: Push notification permission
    Given I am using the mobile application
    When I enable notifications
    Then I should be prompted for push permission
    And if granted, I should receive:
      | notification_type        |
      | Score updates            |
      | Roster lock reminders    |
      | League activity          |

  @mobile @biometric
  Scenario: Biometric authentication option
    Given my device supports biometrics
    When I enable biometric login
    Then I should be able to use:
      | biometric_type    |
      | Face ID (iOS)     |
      | Touch ID (iOS)    |
      | Fingerprint (Android)|
    And login should be fast and seamless
