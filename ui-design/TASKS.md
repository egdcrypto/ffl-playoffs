# UI/UX Design Tasks - FFL Playoffs

## Status: Complete (Updated for Architecture Alignment)
Last Updated: 2025-10-02 12:30

---

## Phase 1: Foundation ✅
- [x] Create ui-design/ directory structure
- [x] Create TASKS.md for work tracking
- [x] Create COMPONENTS.md for reusable UI components
- [x] Create WIREFRAMES.md for all screen layouts
- [x] Create API-INTEGRATION.md for endpoint mappings

---

## Phase 2: Core Screen Wireframes ✅
### High Priority (Core Functionality)
- [x] Player Dashboard - Most used screen, shows leagues and quick actions
- [x] Build Roster Screen - Roster building with individual NFL players and position slots
- [x] Leaderboard Screen - Rankings with PPR scoring and roster performance
- [x] League Configuration Screen - Admin power to configure all rules

### Medium Priority (Essential Flows)
- [x] Login Screen - Google OAuth flow
- [x] Admin Dashboard - Create league, configure, invite, view stats
- [x] Super Admin Dashboard - Manage admins/PATs, view all leagues
- [x] Invitation Acceptance - Player/admin accepting invites

### Bonus Screens Completed
- [x] Score Breakdown Screen - Detailed scoring for week/player
- [x] Roster Management Screen - Draft-style player selection

### Admin HTML Mockups - COMPLETED
- [x] Admin Dashboard HTML mockup
- [x] League Configuration Screen HTML mockup
- [x] Super Admin Dashboard HTML mockup

### Low Priority (Supporting) - Future Enhancement
- [ ] Profile Settings Screen
- [ ] League Details/Info Screen
- [ ] Historical Stats Screen
- [ ] Help/Documentation Screen

---

## Phase 3: Component Library ✅
- [x] Define Navigation Component (header, sidebar, mobile menu)
- [x] Define Button Variants (primary, secondary, danger, disabled)
- [x] Define Form Components (input, select, checkbox, radio, datepicker)
- [x] Define Card Component (league card, player card, stat card)
- [x] Define Table Component (leaderboard, player list, admin list)
- [x] Define Modal/Dialog Component (confirmation, forms, info)
- [x] Define Alert/Toast Component (success, error, warning, info)
- [x] Define Loading States (spinner, skeleton screens)
- [x] Define Empty States (no data, no leagues, no picks)
- [x] Define Badge Component (status indicators, notifications)
- [x] Define Avatar Component (user profiles)
- [x] Define Tabs Component (screen navigation)
- [x] Define Pagination Component (data tables)
- [x] Define Stats Display Component (metrics, scores)
- [x] Define Player Card Component (NFL player selection for roster)
- [x] Define Countdown Timer Component (roster lock tracking)

---

## Phase 4: Responsive Design Specs ✅
- [x] Mobile breakpoints (<768px) for all screens
- [x] Tablet breakpoints (768-1024px) for all screens
- [x] Desktop breakpoints (>1024px) for all screens
- [x] Touch interactions for mobile
- [x] Keyboard navigation for desktop

---

## Phase 5: API Integration Mapping ✅
- [x] Map all screens to API endpoints
- [x] Define loading states for API calls
- [x] Define error states for API failures
- [x] Define success states for API responses
- [x] Define data flow between screens
- [x] Define polling/refresh strategies
- [x] Define authentication flow with Google OAuth

---

## Phase 6: User Flow Diagrams ✅
- [x] Authentication flow (login, logout, token refresh)
- [x] League creation flow (admin)
- [x] Player invitation flow (admin → player)
- [x] Roster building flow (player)
- [x] League configuration flow (admin)
- [x] Admin management flow (super admin)
- [x] Navigation flows between screens

---

## Phase 7: Design System ✅
- [x] Color palette (primary, secondary, accent, neutrals)
- [x] Typography scale (headings, body, captions)
- [x] Spacing system (margins, padding, gaps)
- [x] Border radius and shadows
- [x] Icons and illustrations
- [x] Animation guidelines

---

## Phase 8: Accessibility ✅
- [x] ARIA labels for screen readers
- [x] Keyboard navigation support
- [x] Color contrast ratios (WCAG AA)
- [x] Focus indicators
- [x] Error message accessibility
- [x] Touch target sizing (mobile)

---

## Design Principles
1. **Mobile-First**: Design for smallest screen first, then scale up
2. **Progressive Enhancement**: Core functionality works everywhere
3. **Clear Hierarchy**: Important actions are obvious
4. **Feedback**: Loading, success, and error states are clear
5. **Consistency**: Reuse components and patterns
6. **Performance**: Minimize API calls, optimize images
7. **Accessibility**: Keyboard navigation, screen readers, high contrast

---

## Technical Constraints
- Headless API backend (REST/GraphQL endpoints)
- Google OAuth for authentication
- JWT tokens for authorization
- Real-time updates needed for leaderboards
- Deadline countdowns need accurate time sync
- Mobile-responsive (not native apps)

---

## Key User Personas
1. **Player**: Casual user, builds roster once, tracks weekly PPR scores
2. **Admin**: League creator, configures rules, invites players
3. **Super Admin**: Platform manager, creates admins, monitors system

---

## Phase 9: Architecture Alignment (2025-10-02) ✅
### Critical Update: Roster-Based PPR Fantasy Football Model

**Issue Identified**: Original UI/UX documentation described a team elimination survivor pool model (select NFL teams weekly, elimination logic). The actual architecture specifies a roster-based PPR fantasy football system with ONE-TIME DRAFT.

**Corrections Made**:
- [x] Updated Build Roster Screen (formerly Team Selection Screen)
  - Changed from selecting NFL teams to selecting individual NFL players
  - Added position slots: QB, RB, WR, TE, K, DEF, FLEX, Superflex
  - Added ONE-TIME DRAFT / Roster Lock concept
  - Removed "teams used" tracking, replaced with roster completion status

- [x] Updated Leaderboard Screen
  - Removed "Team: Chiefs" references, replaced with roster-based display
  - Removed "Eliminated W4" status - NO elimination logic
  - Updated to show PPR scoring (individual player fantasy points)
  - Added "Top Performer" column showing best roster player
  - Changed stats from "Active: 7 | Eliminated: 2" to "Total Players: 9"

- [x] Updated Player Dashboard
  - Changed "Make Picks" buttons to "Build Roster"
  - Updated navigation terminology throughout

- [x] Updated League Configuration Screen
  - Removed "Set elimination rules"
  - Added roster configuration (position slots and counts)
  - Added PPR scoring rules configuration
  - Added field goal and defensive scoring rules

- [x] Updated COMPONENTS.md
  - Renamed "Team Selection Component" to "Player Card Component"
  - Removed "Eliminated" badge states
  - Added position badges (QB, RB, WR, TE, K, DEF)
  - Updated color palette to remove "eliminations" reference

- [x] Updated API-INTEGRATION.md
  - Replaced team selection endpoints with roster management endpoints
  - Updated from `/api/v1/player/leagues/{id}/selections` to `/api/v1/player/leagues/{id}/roster`
  - Added individual player search endpoint: `/api/v1/nfl/players?position={pos}&search={query}`
  - Updated error states (removed team-based errors, added roster-specific errors)

- [x] Updated User Flow Diagrams
  - Changed "Player Making Picks Flow" to "Player Building Roster Flow"
  - Updated steps from "Select Team → Confirm" to "Search Players → Add to Position → Roster Locks"

**Game Model Summary**:
- **Type**: Roster-based PPR fantasy football (NOT team elimination survivor pool)
- **Draft**: ONE-TIME DRAFT - rosters built once and PERMANENTLY LOCKED when first NFL game starts
- **Scoring**: PPR scoring from individual NFL player stats (passing, rushing, receiving, kicking, defense)
- **Elimination**: NONE - all league players compete for all configured weeks
- **Roster Positions**: QB, RB, WR, TE, K, DEF, FLEX (RB/WR/TE), Superflex (QB/RB/WR/TE)
- **Ownership**: Unlimited - multiple league players can select same NFL player

---

## Notes
- Focus on Player Dashboard, Build Roster, and Leaderboard first (80% of usage)
- Admin screens can be more complex (power users)
- Super Admin can be desktop-only if needed
- Consider offline mode for viewing roster/standings
- Consider push notifications for roster lock deadline
