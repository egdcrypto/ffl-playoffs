# HTML Mockups - FFL Playoffs

This directory contains interactive HTML mockups for all key screens of the FFL Playoffs application using a **roster-based fantasy football** model with **ONE-TIME DRAFT** mechanics.

## ⚠️ Important: ONE-TIME DRAFT MODEL

These mockups demonstrate a **roster-based fantasy football system** where:
- League players build rosters by drafting **individual NFL players** (QB, RB, WR, TE, K, DEF, FLEX, SUPERFLEX)
- Rosters are built **ONCE** before the season starts
- Rosters are **PERMANENTLY LOCKED** when the first game begins
- **NO waiver wire, NO trades, NO weekly lineup changes** for the entire season

## Available Mockups

### Current (Roster-Based Model)
1. **login.html** - Login screen with Google OAuth authentication
2. **player-dashboard.html** - League player's main dashboard with roster status, lock warnings, and league cards
3. **player-selection.html** - Draft individual NFL players with position filters, search, and roster builder
4. **my-roster.html** - View your complete roster organized by position with weekly scoring breakdown
5. **league-standings.html** - League player rankings with expandable roster details and total scores
6. **index.html** - Mockups index page with navigation to all screens

### All Core Mockups Complete
All primary mockups have been completed.

## Key Features

All mockups include:
- ✅ Roster-based fantasy football with individual NFL player selection
- ✅ ONE-TIME DRAFT model with permanent roster lock warnings
- ✅ Position-based roster building (QB, RB, WR, TE, K, DEF, FLEX, SUPERFLEX)
- ✅ Responsive design using Bootstrap 5 (mobile, tablet, desktop)
- ✅ Bootstrap Icons for UI elements
- ✅ Roster completion tracking and lock countdown timers
- ✅ Interactive elements (modals, collapsible rows, filters)
- ✅ Mock data demonstrating real game scenarios
- ✅ No ownership model: ALL NFL players available to ALL league members (multiple players can select the same NFL player)
- ✅ Pagination support for large player lists

## How to View

### Option 1: Local Browser
1. Open any `.html` file in your web browser
2. Resize browser to test responsive breakpoints
3. Navigate between pages using the navigation bar

### Option 2: Online (GitHub HTML Preview)
All mockups are accessible online:
- [Mockups Index](https://htmlpreview.github.io/?https://github.com/egdcrypto/ffl-playoffs/blob/main/ui-design/mockups/index.html)
- Individual mockups linked from index page

## Responsive Breakpoints

Bootstrap 5 breakpoints:
- **Mobile (xs, sm):** < 768px
- **Tablet (md):** 768px - 991px
- **Desktop (lg, xl, xxl):** ≥ 992px

## Design System

All mockups use **Bootstrap 5** with consistent styling:

### Colors
- **Primary:** #0d6efd (Blue) - main actions
- **Success:** #198754 (Green) - active/completed states
- **Danger:** #dc3545 (Red) - warnings/errors
- **Warning:** #ffc107 (Yellow) - alerts/incomplete states
- **Secondary:** #6c757d (Gray) - inactive/disabled states

### Position Badge Colors
- **QB:** Red (#dc3545)
- **RB:** Green (#198754)
- **WR:** Blue (#0d6efd)
- **TE:** Orange/Warning (#ffc107)
- **K:** Gray (#6c757d)
- **DEF:** Purple (#6f42c1)
- **FLEX:** Orange (#fd7e14)
- **SUPERFLEX:** Teal (#20c997)

### Typography
- Font: System font stack (Bootstrap 5 default)
- Headings: Bootstrap heading classes (h1-h6)
- Body: 1rem/1.5 line-height

### Spacing
Bootstrap 5 spacing scale (0-5):
- 0: 0
- 1: 0.25rem (4px)
- 2: 0.5rem (8px)
- 3: 1rem (16px)
- 4: 1.5rem (24px)
- 5: 3rem (48px)

## Technologies Used

- **HTML5** - Semantic markup
- **Bootstrap 5.3.0** - CSS framework (CDN)
- **Bootstrap Icons 1.10.0** - Icon library (CDN)
- **Vanilla JavaScript** - Interactions (via Bootstrap bundle)
- **No build process** - Static HTML files for easy viewing

## Key UI Patterns

### Roster Lock Warnings
- Prominent countdown timers showing time until permanent roster lock
- Different alert styles for incomplete vs. locked rosters
- Visual indicators (badges, progress bars) for roster completion

### Draft System
- Position filters (QB, RB, WR, TE, K, DEF, FLEX, SUPERFLEX)
- NFL team filter and player name search
- ALL NFL players available to ALL league members (no ownership model)
- Multiple league members can select the same NFL player
- Roster sidebar showing current selections

### Roster Display
- Position groupings (QB, RB, WR, TE, K, DEF, FLEX, SUPERFLEX)
- Individual player cards with weekly scoring breakdown
- Total points aggregation across entire roster
- Locked roster status indicators

### League Standings
- Ranking table with expandable roster details
- Current user row highlighted
- Week-by-week scoring columns
- Top player badges for quick overview

## Next Steps

After stakeholder approval:
1. Convert mockups to React components with TypeScript
2. Implement with modern UI library (e.g., Shadcn UI + Tailwind CSS)
3. Integrate with Spring Boot API (REST endpoints)
4. Add real-time score updates via WebSocket
5. Implement Google OAuth authentication flow
6. Add roster lock enforcement on backend
7. Implement draft system with no ownership model (all players available to all)

## Notes

- These are static mockups for design review and stakeholder feedback
- API calls are simulated (no backend integration yet)
- Real implementation will use React + modern UI framework
- See `../RESEARCH.md` for framework recommendations
- See `../API-INTEGRATION.md` for screen-to-endpoint mappings
- Bootstrap 5 used for rapid prototyping; may switch to Tailwind CSS for production

## File Status

| File | Status | Notes |
|------|--------|-------|
| login.html | ✅ Complete | Google OAuth flow |
| player-dashboard.html | ✅ Complete | Roster-based with lock warnings |
| player-selection.html | ✅ Complete | Individual NFL player draft |
| my-roster.html | ✅ Complete | Position-grouped roster view |
| league-standings.html | ✅ Complete | League player rankings |
| index.html | ✅ Complete | Navigation page |
| admin-dashboard.html | ✅ Complete | Admin league management |
| league-config.html | ✅ Complete | Roster & scoring configuration |
| super-admin-dashboard.html | ✅ Complete | Platform administration |
