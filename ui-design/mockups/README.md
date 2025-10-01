# HTML Mockups - FFL Playoffs

This directory contains interactive HTML mockups for all key screens of the FFL Playoffs application.

## Available Mockups

1. **login.html** - Login screen with Google OAuth
2. **player-dashboard.html** - Player's main dashboard (in progress)
3. **team-selection.html** - Weekly team selection interface (pending)
4. **leaderboard.html** - League leaderboard and standings (pending)
5. **admin-dashboard.html** - Admin league management (pending)
6. **league-config.html** - League configuration screen (pending)
7. **super-admin-dashboard.html** - Platform-wide administration (pending)

## Features

All mockups include:
- ✅ Responsive design (mobile, tablet, desktop)
- ✅ Inline CSS styling
- ✅ Dark mode support (prefers-color-scheme)
- ✅ Interactive elements (buttons, forms, etc.)
- ✅ Mock data for demonstration
- ✅ Design system from COMPONENTS.md
- ✅ Accessibility considerations

## How to View

1. Open any `.html` file in your web browser
2. Resize browser to test responsive breakpoints
3. Enable dark mode in your OS to test dark mode styles

## Responsive Breakpoints

- **Mobile:** < 768px
- **Tablet:** 768px - 1024px
- **Desktop:** > 1024px

## Design System

All mockups follow the design system documented in `../COMPONENTS.md`:

### Colors
- Primary: #1a73e8 (Blue)
- Secondary: #34a853 (Green)
- Accent: #ea4335 (Red)
- Warning: #fbbc04 (Yellow)

### Typography
- Font: -apple-system, BlinkMacSystemFont, 'Segoe UI', 'Roboto', 'Oxygen', 'Ubuntu', sans-serif
- H1: 32px/40px, weight 700
- H2: 24px/32px, weight 600
- Body: 14px/20px, weight 400

### Spacing
- xs: 4px
- sm: 8px
- md: 16px
- lg: 24px
- xl: 32px

## Technologies Used

- Pure HTML5
- Inline CSS3 (no external stylesheets for portability)
- Vanilla JavaScript for interactions
- No framework dependencies

## Next Steps

After stakeholder approval:
1. Convert mockups to React components
2. Implement with Shadcn UI + Tailwind CSS
3. Integrate with Spring Boot API
4. Add real-time updates via WebSocket
5. Implement authentication flow

## Notes

- These are static mockups for design review
- API calls are simulated with `alert()` and `console.log()`
- Real implementation will use React + Shadcn UI + Tailwind CSS
- See `../RESEARCH.md` for framework recommendations
