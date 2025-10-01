# UI Component Library - FFL Playoffs

## Design System Foundation

### Color Palette
```
Primary Colors:
- Primary: #1a73e8 (Blue - CTAs, links, primary actions)
- Primary Dark: #1557b0
- Primary Light: #4285f4

Secondary Colors:
- Secondary: #34a853 (Green - Success, wins, positive)
- Accent: #ea4335 (Red - Danger, eliminations, errors)
- Warning: #fbbc04 (Yellow - Warnings, deadlines)

Neutral Colors:
- Gray-900: #202124 (Primary text)
- Gray-700: #5f6368 (Secondary text)
- Gray-500: #80868b (Tertiary text)
- Gray-300: #dadce0 (Borders)
- Gray-100: #f1f3f4 (Backgrounds)
- White: #ffffff

Semantic Colors:
- Success: #34a853
- Error: #ea4335
- Warning: #fbbc04
- Info: #1a73e8
```

### Typography
```
Font Family: 
- Primary: 'Inter', -apple-system, system-ui, sans-serif
- Monospace: 'Roboto Mono', monospace (for scores, stats)

Scale:
- H1: 32px/40px, weight 700 (Page titles)
- H2: 24px/32px, weight 600 (Section headers)
- H3: 20px/28px, weight 600 (Card headers)
- H4: 16px/24px, weight 600 (Subsections)
- Body: 14px/20px, weight 400 (Regular text)
- Body Large: 16px/24px, weight 400 (Important text)
- Caption: 12px/16px, weight 400 (Metadata, timestamps)
- Small: 11px/16px, weight 400 (Fine print)
```

### Spacing System
```
- xs: 4px
- sm: 8px
- md: 16px
- lg: 24px
- xl: 32px
- 2xl: 48px
- 3xl: 64px
```

### Border Radius
```
- sm: 4px (Buttons, inputs)
- md: 8px (Cards, modals)
- lg: 12px (Featured cards)
- full: 9999px (Pills, avatars)
```

### Shadows
```
- sm: 0 1px 2px rgba(0,0,0,0.05)
- md: 0 4px 6px rgba(0,0,0,0.1)
- lg: 0 10px 15px rgba(0,0,0,0.1)
- xl: 0 20px 25px rgba(0,0,0,0.15)
```

---

## Core Components

### 1. Button Component

**Variants:**
```
┌─────────────────────┐
│  Primary Button     │  - Solid background, primary color
└─────────────────────┘  - Used for main CTAs

┌─────────────────────┐
│  Secondary Button   │  - Outlined, no background
└─────────────────────┘  - Used for secondary actions

┌─────────────────────┐
│  Danger Button      │  - Red color, destructive actions
└─────────────────────┘  - Used for delete, remove

┌─────────────────────┐
│  Text Button        │  - No border, minimal style
└─────────────────────┘  - Used for tertiary actions
```

**States:**
- Default
- Hover (darker shade)
- Active (pressed effect)
- Disabled (opacity 0.5, no pointer)
- Loading (spinner + disabled)

**Sizes:**
- Small: 32px height, 12px/16px padding
- Medium: 40px height, 16px/24px padding
- Large: 48px height, 20px/32px padding

**Props:**
- variant: primary | secondary | danger | text
- size: sm | md | lg
- disabled: boolean
- loading: boolean
- icon: IconComponent (optional)
- fullWidth: boolean

---

### 2. Input Component

**Types:**
```
┌───────────────────────────────┐
│ Label                         │
│ ┌───────────────────────────┐ │
│ │ Placeholder text...       │ │
│ └───────────────────────────┘ │
│ Helper text here              │
└───────────────────────────────┘

┌───────────────────────────────┐
│ Password                      │
│ ┌───────────────────────────┐ │
│ │ ••••••••••           [👁] │ │
│ └───────────────────────────┘ │
└───────────────────────────────┘

┌───────────────────────────────┐
│ Search                        │
│ ┌───────────────────────────┐ │
│ │ 🔍 Search teams...        │ │
│ └───────────────────────────┘ │
└───────────────────────────────┘
```

**States:**
- Default
- Focused (border highlight)
- Error (red border, error message)
- Disabled (gray background)
- Success (green border, optional)

**Props:**
- type: text | email | password | number | search
- label: string
- placeholder: string
- helperText: string
- error: string
- disabled: boolean
- icon: IconComponent (optional)
- value: string
- onChange: function

---

### 3. Card Component

**Variants:**
```
┌─────────────────────────────────────┐
│  Card Header                        │
│  Subtitle or metadata               │
├─────────────────────────────────────┤
│                                     │
│  Card Body                          │
│  Main content goes here             │
│                                     │
├─────────────────────────────────────┤
│  Card Footer                        │
│  [Action 1]  [Action 2]            │
└─────────────────────────────────────┘

League Card:
┌─────────────────────────────────────┐
│  🏈 My League Name                  │
│  Created by John Doe • 12 players   │
├─────────────────────────────────────┤
│  Week 5 • Deadline: 2 days          │
│  Your Rank: #3                      │
├─────────────────────────────────────┤
│  [View League]  [Make Picks]       │
└─────────────────────────────────────┘
```

**Props:**
- variant: default | elevated | outlined
- padding: sm | md | lg
- clickable: boolean (hover effect)
- header: ReactNode
- footer: ReactNode
- children: ReactNode

---

### 4. Navigation Component

**Desktop Header:**
```
┌────────────────────────────────────────────────────────┐
│ 🏈 FFL Playoffs    [Leagues] [Picks] [Stats]    👤 JD │
└────────────────────────────────────────────────────────┘
```

**Mobile Header:**
```
┌────────────────────────────────────┐
│ ☰  FFL Playoffs              👤 JD │
└────────────────────────────────────┘

When menu open:
┌────────────────────────────────────┐
│ ✕  Menu                            │
├────────────────────────────────────┤
│  🏈 My Leagues                     │
│  🎯 Make Picks                     │
│  📊 Leaderboards                   │
│  ⚙️  Settings                      │
│  🚪 Logout                         │
└────────────────────────────────────┘
```

**Breadcrumbs:**
```
Home > My Leagues > League Name > Make Picks
```

---

### 5. Table Component

**Desktop Table:**
```
┌──────────────────────────────────────────────────────┐
│  Rank  │  Player      │  Team      │  Points  │  ⚡  │
├──────────────────────────────────────────────────────┤
│  1st   │  John Doe    │  Patriots  │  145     │  ✓  │
│  2nd   │  Jane Smith  │  Chiefs    │  132     │  ✓  │
│  3rd   │  Bob Jones   │  Cowboys   │  128     │  ✗  │
└──────────────────────────────────────────────────────┘
```

**Mobile Table (Card View):**
```
┌────────────────────────────────┐
│  1st Place                     │
│  John Doe                      │
│  Patriots • 145 pts • Active   │
└────────────────────────────────┘
┌────────────────────────────────┐
│  2nd Place                     │
│  Jane Smith                    │
│  Chiefs • 132 pts • Active     │
└────────────────────────────────┘
```

**Props:**
- columns: Array<{key, header, render}>
- data: Array<object>
- sortable: boolean
- onRowClick: function
- responsive: boolean (converts to cards on mobile)

---

### 6. Modal/Dialog Component

```
┌─────────────────────────────────────────────┐
│  Modal Title                           [✕] │
├─────────────────────────────────────────────┤
│                                             │
│  Modal content goes here                    │
│  Can include forms, text, images, etc.      │
│                                             │
├─────────────────────────────────────────────┤
│                    [Cancel]  [Confirm]      │
└─────────────────────────────────────────────┘
       Backdrop (semi-transparent black)
```

**Variants:**
- sm: 400px width
- md: 600px width
- lg: 800px width
- fullscreen: 100vw on mobile

**Props:**
- open: boolean
- onClose: function
- title: string
- size: sm | md | lg | fullscreen
- showCloseButton: boolean
- children: ReactNode
- footer: ReactNode

---

### 7. Alert/Toast Component

**Toast Notifications:**
```
┌─────────────────────────────────────────┐
│  ✓  Success! Your picks have been saved │
└─────────────────────────────────────────┘

┌─────────────────────────────────────────┐
│  ⚠  Warning! Deadline in 1 hour          │
└─────────────────────────────────────────┘

┌─────────────────────────────────────────┐
│  ✕  Error! Failed to submit picks        │
└─────────────────────────────────────────┘
```

**Inline Alerts:**
```
┌─────────────────────────────────────────┐
│  ℹ  Your league starts in Week 5         │
│     Make sure to invite all players      │
│     before the first deadline.      [✕] │
└─────────────────────────────────────────┘
```

**Props:**
- variant: success | error | warning | info
- message: string
- description: string (optional)
- dismissible: boolean
- autoHideDuration: number (ms)
- position: top-right | top-center | bottom-right | bottom-center

---

### 8. Team Selection Component

**Team Picker:**
```
┌─────────────────────────────────────────┐
│  Select Your Team for Week 5            │
├─────────────────────────────────────────┤
│  ┌──────┐  ┌──────┐  ┌──────┐          │
│  │ [🏈] │  │ [🏈] │  │ [🏈] │          │
│  │  SF  │  │  KC  │  │  BUF │          │
│  │ 49ers│  │Chiefs│  │Bills │          │
│  └──────┘  └──────┘  └──────┘          │
│                                         │
│  ┌──────┐  ┌──────┐  ┌──────┐          │
│  │  ⚫  │  │  ⚫  │  │ [🏈] │          │
│  │  NE  │  │  DAL │  │  GB  │          │
│  │ Elim │  │ Elim │  │Packers│         │
│  └──────┘  └──────┘  └──────┘          │
└─────────────────────────────────────────┘

Selected: None
Deadline: Thu Sep 14, 8:00 PM ET (23:45:12)

[Confirm Selection]
```

**States:**
- Available (normal, clickable)
- Selected (highlighted border, checkmark)
- Eliminated (grayed out, locked icon)
- Locked (deadline passed, can't change)

---

### 9. Countdown Timer Component

```
┌──────────────────────────┐
│  Deadline in:            │
│  ┌────┬────┬────┬────┐  │
│  │ 01 │ 23 │ 45 │ 12 │  │
│  │Days│Hrs │Min │Sec │  │
│  └────┴────┴────┴────┘  │
└──────────────────────────┘

Warning state (<24h):
┌──────────────────────────┐
│  ⚠  Deadline soon!        │
│  ┌────┬────┬────┐        │
│  │ 05 │ 30 │ 15 │        │
│  │Hrs │Min │Sec │        │
│  └────┴────┴────┘        │
└──────────────────────────┘

Expired:
┌──────────────────────────┐
│  🔒 Deadline passed       │
└──────────────────────────┘
```

---

### 10. Loading States

**Spinner:**
```
┌──────────────────┐
│                  │
│       ⟳         │
│   Loading...     │
│                  │
└──────────────────┘
```

**Skeleton Screen (Card):**
```
┌─────────────────────────────────────┐
│  ████████████                       │
│  ██████████                         │
├─────────────────────────────────────┤
│  ██████████████████                 │
│  ████████                           │
└─────────────────────────────────────┘
```

**Progress Bar:**
```
┌──────────────────────────────────────┐
│  Loading your picks...               │
│  ████████████████░░░░░░░░░  60%     │
└──────────────────────────────────────┘
```

---

### 11. Empty States

**No Leagues:**
```
┌─────────────────────────────────────┐
│                                     │
│           🏈                        │
│                                     │
│     No leagues yet                  │
│     Get started by creating or      │
│     joining a league                │
│                                     │
│     [Create League]  [Join League]  │
│                                     │
└─────────────────────────────────────┘
```

**No Picks Made:**
```
┌─────────────────────────────────────┐
│           🎯                        │
│                                     │
│     No picks for this week          │
│     Make your selection before      │
│     the deadline!                   │
│                                     │
│     [Make Picks]                    │
└─────────────────────────────────────┘
```

---

### 12. Badge Component

```
Active    Eliminated    Pending    Admin
┌─────┐   ┌─────────┐  ┌───────┐  ┌─────┐
│  ✓  │   │    ⚫   │  │   ⏱   │  │  👑 │
└─────┘   └─────────┘  └───────┘  └─────┘

Numerical Badges:
Notifications (3)    Rank #1    Week 5
```

**Props:**
- variant: success | error | warning | info | neutral
- label: string
- icon: IconComponent (optional)
- size: sm | md | lg

---

### 13. Avatar Component

```
Small     Medium     Large
┌────┐   ┌──────┐   ┌────────┐
│ JD │   │  JD  │   │   JD   │
└────┘   └──────┘   └────────┘
24px      32px       48px

With Image:
┌────┐   ┌──────┐   ┌────────┐
│[📷]│   │ [📷] │   │  [📷]  │
└────┘   └──────┘   └────────┘

With Status:
┌────┐
│ JD │🟢
└────┘
```

---

### 14. Dropdown/Select Component

```
Closed:
┌───────────────────────────┐
│ Select team...         ▼ │
└───────────────────────────┘

Open:
┌───────────────────────────┐
│ Select team...         ▲ │
├───────────────────────────┤
│ 🏈 San Francisco 49ers   │
│ 🏈 Kansas City Chiefs    │
│ 🏈 Buffalo Bills         │
│ ⚫ New England Patriots  │
└───────────────────────────┘
```

**Props:**
- options: Array<{value, label, disabled}>
- value: string
- onChange: function
- placeholder: string
- searchable: boolean
- multiple: boolean

---

### 15. Tabs Component

```
Desktop:
┌────────────────────────────────────┐
│  Overview   Leaderboard   Settings │
│  ═════════                         │
├────────────────────────────────────┤
│                                    │
│  Tab content here                  │
│                                    │
└────────────────────────────────────┘

Mobile (Scrollable):
┌────────────────────────────────────┐
│  Overview  │ Leaderboard │ Settings│
│  ═════════                         │
├────────────────────────────────────┤
│  Tab content here                  │
└────────────────────────────────────┘
```

---

### 16. Checkbox & Radio Components

**Checkbox:**
```
☐ Unchecked option
☑ Checked option
☐ Another option
```

**Radio:**
```
○ Option A
◉ Option B (selected)
○ Option C
```

**Toggle Switch:**
```
OFF: ◯─────   ON: ─────●
```

---

### 17. Pagination Component

```
Desktop:
┌──────────────────────────────────────┐
│  [← Prev]  1  2  [3]  4  5  [Next →]│
└──────────────────────────────────────┘

Mobile:
┌────────────────────────┐
│  [←]  Page 3 of 10 [→]│
└────────────────────────┘
```

---

### 18. Stats Display Component

```
┌─────────────────────────────────────┐
│  Total Points        Wins    Rank   │
│      145            8/12      #3    │
└─────────────────────────────────────┘

Detailed Stats Card:
┌─────────────────────────────────────┐
│  📊 Your Season Stats               │
├─────────────────────────────────────┤
│  Total Points:    145               │
│  Wins:            8 / 12            │
│  Losses:          4 / 12            │
│  Current Rank:    #3                │
│  Teams Used:      12 / 32           │
│  Avg Points/Wk:   12.1              │
└─────────────────────────────────────┘
```

---

## Component Usage Guidelines

1. **Consistency**: Always use the same component for the same purpose
2. **Composition**: Combine simple components to build complex UIs
3. **Accessibility**: All components must support keyboard navigation
4. **Responsive**: Components adapt to screen size automatically
5. **Theming**: Support light/dark mode (future enhancement)
6. **Performance**: Lazy load heavy components, memoize when needed
7. **Testing**: Each component should have unit tests

---

## Icon System

**Primary Icons:**
- 🏈 Football (leagues, teams)
- 🎯 Target (picks, selections)
- 📊 Chart (stats, leaderboards)
- ⚙️ Gear (settings, config)
- 👤 User (profile, player)
- 👑 Crown (admin, winner)
- ⚡ Bolt (active, live)
- 🔒 Lock (deadline passed, secured)
- ✓ Check (success, confirmed)
- ✕ X (error, eliminated)
- ⚠ Warning (alerts, deadline soon)
- ℹ Info (help, information)
- 🔍 Search
- ➕ Add/Create
- ✏️ Edit
- 🗑️ Delete
- 🚪 Logout

**Use icon library**: Heroicons, Lucide, or similar for consistency

---

## Animation Guidelines

**Transitions:**
- Fade: 150ms ease-in-out
- Slide: 200ms ease-out
- Scale: 200ms ease-in-out

**Hover Effects:**
- Buttons: Scale 1.02, shadow increase
- Cards: Slight elevation, shadow increase
- Links: Underline, color change

**Loading:**
- Spinner: Continuous rotation
- Progress bar: Smooth animation
- Skeleton: Shimmer effect

**No animations for:**
- Users with reduced motion preference (respect prefers-reduced-motion)

