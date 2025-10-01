# UI/UX Design Tasks - FFL Playoffs

## Status: In Progress
Last Updated: 2025-10-01

---

## Phase 1: Foundation ✅
- [x] Create ui-design/ directory structure
- [x] Create TASKS.md for work tracking
- [ ] Create COMPONENTS.md for reusable UI components
- [ ] Create WIREFRAMES.md for all screen layouts
- [ ] Create API-INTEGRATION.md for endpoint mappings

---

## Phase 2: Core Screen Wireframes
### High Priority (Core Functionality)
- [ ] Player Dashboard - Most used screen, shows leagues and quick actions
- [ ] Team Selection Screen - Weekly picks with eliminated teams and deadline
- [ ] Leaderboard Screen - Rankings, eliminations, points breakdown
- [ ] League Configuration Screen - Admin power to configure all rules

### Medium Priority (Essential Flows)
- [ ] Login Screen - Google OAuth flow
- [ ] Admin Dashboard - Create league, configure, invite, view stats
- [ ] Super Admin Dashboard - Manage admins/PATs, view all leagues
- [ ] Invitation Acceptance - Player/admin accepting invites

### Low Priority (Supporting)
- [ ] Profile Settings Screen
- [ ] League Details/Info Screen
- [ ] Historical Stats Screen
- [ ] Help/Documentation Screen

---

## Phase 3: Component Library
- [ ] Define Navigation Component (header, sidebar, mobile menu)
- [ ] Define Button Variants (primary, secondary, danger, disabled)
- [ ] Define Form Components (input, select, checkbox, radio, datepicker)
- [ ] Define Card Component (league card, player card, stat card)
- [ ] Define Table Component (leaderboard, player list, admin list)
- [ ] Define Modal/Dialog Component (confirmation, forms, info)
- [ ] Define Alert/Toast Component (success, error, warning, info)
- [ ] Define Loading States (spinner, skeleton screens)
- [ ] Define Empty States (no data, no leagues, no picks)

---

## Phase 4: Responsive Design Specs
- [ ] Mobile breakpoints (<768px) for all screens
- [ ] Tablet breakpoints (768-1024px) for all screens
- [ ] Desktop breakpoints (>1024px) for all screens
- [ ] Touch interactions for mobile
- [ ] Keyboard navigation for desktop

---

## Phase 5: API Integration Mapping
- [ ] Map all screens to API endpoints
- [ ] Define loading states for API calls
- [ ] Define error states for API failures
- [ ] Define success states for API responses
- [ ] Define data flow between screens

---

## Phase 6: User Flow Diagrams
- [ ] Authentication flow (login, logout, token refresh)
- [ ] League creation flow (admin)
- [ ] Player invitation flow (admin → player)
- [ ] Weekly picks flow (player)
- [ ] League configuration flow (admin)
- [ ] Admin management flow (super admin)

---

## Phase 7: Design System
- [ ] Color palette (primary, secondary, accent, neutrals)
- [ ] Typography scale (headings, body, captions)
- [ ] Spacing system (margins, padding, gaps)
- [ ] Border radius and shadows
- [ ] Icons and illustrations

---

## Phase 8: Accessibility
- [ ] ARIA labels for screen readers
- [ ] Keyboard navigation support
- [ ] Color contrast ratios (WCAG AA)
- [ ] Focus indicators
- [ ] Error message accessibility

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
1. **Player**: Casual user, checks in weekly to make picks
2. **Admin**: League creator, configures rules, invites players
3. **Super Admin**: Platform manager, creates admins, monitors system

---

## Notes
- Focus on Player Dashboard, Team Selection, and Leaderboard first (80% of usage)
- Admin screens can be more complex (power users)
- Super Admin can be desktop-only if needed
- Consider offline mode for viewing picks/standings
- Consider push notifications for deadlines
