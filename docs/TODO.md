
# bit-habit.com Redesign Spec

## Purpose
This document is the full redesign spec for bit-habit.com.
Hand this file to Claude Code along with the current `index.html` in the static web workspace folder.
Claude Code should read the existing `index.html` for reference (keep the dark theme feel), then rebuild the page following this spec.
모든 포트폴리오와 관련된 링크는 https://github.com/bookseal?tab=repositories 여기 curl해서 보면 다 있다. README.md를 잘 만들어놓음


## Core Rules
1. **Single column layout** — no 3-column grids. Everything flows top to bottom in one stream
2. **Story flow** — Hero → Featured Projects → More Projects → Stack → Experience → Education → Footer
3. **Clear hierarchy** — 4 featured projects get big cards. Everything else is smaller
4. **Pure HTML/CSS** — no frameworks. The current site is pure HTML/CSS, keep it that way
5. **Dark theme** — keep the current dark tone (#0d1117 family)
6. **Mobile responsive** — single column makes this easy. Just adjust padding on small screens

---

## Section-by-Section Spec

### Section 1: Hero
- **Height:** compact — about 40-50% of viewport. The goal is that the first Featured Project card is already partially visible without scrolling.
- **Background:** keep the current dark gradient
- **Content (vertically centered):**
  ```
  Gichan Lee
  AI Forward Deployed Engineer

  I build AI automation that works in the real world:

  → LLM agent that searches 25 library systems with zero API — BookToss
  → Real-time voice monitor, $0 cloud cost — Sentinel (hackathon 1st place)
  → Habit platform running 2+ years with real users — Bithabit (hackathon 2nd)
  → 14 services on k3s, $0/month infra — bit-habit-infra

  [GitHub]  [LinkedIn]  [Wiki]  [Email: gichanlee@icloud.com]
  ```
- **Why this structure:** A senior dev reviewed the previous version and said: "Everything above BookToss adds zero lines to my memory about what this person can do as an FDE." The hero must answer "what did you build with AI?" in 3 seconds, before any scrolling.
- **Design notes:**
  - Name: large (2rem+), bold
  - Title: accent color (#58a6ff or similar)
  - The 4 project lines: each line is a clickable anchor that scrolls to the matching Featured Project card below
  - Use arrow (→) or bullet, monospace or slightly different style to make them feel like a quick summary, not a paragraph
  - Links row: icon + text, horizontal
  - Keep the hero tight — no wasted vertical space
  - **DELETE** the terminal simulation (Foundation/Infrastructure/Intelligence blocks)
  - **DELETE** the typing SVG animation
  - **DELETE** the long bullet-point About section
  - **DELETE** the abstract quote ("I design resilient ecosystems...")

### Section 2: Featured Projects (most important section)
- **Section title:** "Featured Projects"
- **Layout:** single column, one big card per project, full width
- **4 cards in this order:**

#### Card 1: Sentinel
```
[Screenshot image placeholder]

Sentinel — Real-time Cognitive Assistant
🏆 1st Place — Megazone Cloud AI Agent Hackathon

Real-time voice monitor that detects raised voices and alerts people
before conversations get out of hand.
Chose local NumPy over cloud APIs — $0 cost, <10ms latency.
Weekly mentoring with Infobank CTO to validate tech choices from a business perspective.

Tech: LangGraph · Gradio · NumPy · k3s · OCI · Docker

[Live App: sentinel.bit-habit.com]  [GitHub Source]
```

#### Card 2: BookToss
```
[Screenshot image placeholder]

BookToss — Autonomous Agent for API-less Libraries

Seoul's 25 district libraries have zero APIs.
Built a LangGraph + Browser-use agent that auto-searches each library website,
handles popups, and combines results into one view with availability status.
Search time: 5 min → 1 min (80% reduction).

Tech: LangGraph · Browser-use · Playwright · OpenAI · Streamlit · Kakao Map

[Live App: booktoss.bit-habit.com]  [GitHub Source]
```

#### Card 3: Bithabit
```
[Screenshot image placeholder]

Bithabit — Habit Tracking Community Platform
🏆 2nd Place — IITP Hackathon · Running for 2+ years

Time-lapse camera + real-time chat for small study groups.
Client-side GIF generation (gif.js Web Worker) — $0 server cost.
Passwordless auth (Email OTP + JWT). Users still active after 2 years.

Tech: Flutter Web · FastAPI · WebSocket · JWT · gif.js · k3s

[Live App: habit.bit-habit.com]  [GitHub Source]
```

#### Card 4: bit-habit-infra
```
[Screenshot image placeholder — Headlamp cluster map]

bit-habit-infra — GitOps Infrastructure Platform
14 services · $0/month · Zero manual kubectl

Single-node k3s cluster on OCI free tier running all projects.
ArgoCD auto-syncs from Git — no manual deploys.
Migrated from AWS EC2 to OCI, cutting infra cost to $0.

Tech: k3s · ArgoCD · Traefik · cert-manager · Terraform · Docker

[GitHub Source]
```

- **Card design notes:**
  - Each card has a subtle background (#161b22) or border (#30363d)
  - Award badges (🏆) should stand out — gold color (#ffd700)
  - Screenshots: rounded corners (8px), slight shadow
  - "Live App" button = primary style, "GitHub Source" button = secondary/outline style
  - Generous spacing between cards (40-60px)
  - Screenshot can be full-width above the text, or left-aligned 40% with text on the right — whichever looks cleaner

### Section 3: More Projects
- **Section title:** "More Projects"
- **Layout:** compact list or simple table, single column
- **Tone:** visually much smaller than Featured section
- **Items:**

```
| Project              | Description                              | Stack                     | Links      |
|----------------------|------------------------------------------|---------------------------|------------|
| Seoul APT Prediction | Interactive ML simulator for learning     | scikit-learn · Streamlit   | Live / Git |
| Viz Platform         | Linear algebra visualization for AI       | Streamlit · Manim          | Live / Git |
| Daily Seongsu        | Crowd prediction MLOps pipeline           | MLOps · Gradio · k3s      | Live / Git |
| Bithumb AI Trade     | Automated Bitcoin trading system          | Python · Bithumb API       | Git        |
| munhaepang           | AI literacy platform for students         | Next.js · TypeScript       | Git        |
| Snowball English     | AI-powered English learning               | HTML/CSS · AI              | Git        |
| careettalk           | AI career coaching app                    | Firebase · Gemini          | Git        |
| thegreatyou          | AI personal growth coach                  | Firebase · Gemini          | Git        |
```

- **Design notes:**
  - No screenshots. Text only.
  - One project per row, compact
  - The visual gap between Featured and More should be obvious
  - This is a compromise: keep them, but don't emphasize them

### Section 4: Tech Stack
- **Section title:** "Tech Stack"
- **Keep the shields.io badge style** from the current site
- **3 categories only:**

**AI & Automation**
LangGraph, LangChain, OpenAI, scikit-learn, Streamlit

**Cloud & DevOps**
OCI, AWS, Azure, Kubernetes, Docker, Terraform, Traefik, Helm

**Languages**
Python, JavaScript, TypeScript, C, C++, Shell, SQL

- **DELETE** the "Cloud & Infrastructure Engine" table — badges are enough
- **Design notes:**
  - Badges wrap naturally in a flex container
  - Category labels: small, subtle
  - This section should be compact overall

### Section 5: Experience
- **Section title:** "Experience"
- **Simple list, no cards needed:**

```
Concentrix Korea (Microsoft M365 Support) — Technical Success Advisor
Aug 2025 – Nov 2025
• #1 out of 20 engineers: SRR 92.7%, DSAT 0%
• Selected as Microsoft Global Tester for Korean service quality
• Led "Fireteam" mentorship — helped 3 peers earn MS-900 certification

Bithabit — AI Architect (Founder)
Aug 2024 – Present
• See Featured Projects above

FPT Software Korea — Embedded Support Engineer
Oct 2024 – Jul 2025
• Diagnosed and resolved security module errors for Hyundai Autoever partners
```

- **Design notes:**
  - Simple list style, not cards
  - Company name: bold. Period: subtle color (#8b949e)
  - Bithabit points to Featured Projects to avoid repeating the same content
  - Keep it brief — the resume has the full details

### Section 6: Education
- **Section title:** "Education"
- **Just 2 lines:**

```
École 42 Seoul — Computer Science (2022 – 2024)
Pukyong National University — B.S. Industrial Engineering (2007 – 2014)
```

- **Design notes:**
  - Same style as Experience, minimal
  - **DELETE** the Academic Foundations section
  - **DELETE** the Timeline section
  - **DELETE** the Learning Roadmap / Mermaid graph

### Section 7: Footer
```
© Gichan Lee. All rights reserved.
Deployed via k3s. Served by Nginx. Written in pure HTML/CSS.
```
- Keep as-is

---

## What to DELETE from the current site

1. ❌ Terminal simulation blocks (Foundation / Infrastructure / Intelligence)
2. ❌ Typing SVG animation
3. ❌ About section bullet-point list ("Designing and operating...", "Building LLM...", etc.)
4. ❌ Cloud & Infrastructure Engine table
5. ❌ Timeline section (entire thing)
6. ❌ Foundations: The Learning Roadmap (entire thing, including Mermaid graph)
7. ❌ "AI Services — Progressively Built" table → replaced by More Projects
8. ❌ Detailed Experience bullets → replaced by short version above

---

## What to ADD (not in current site)

1. ✅ **Sentinel project card** — currently missing entirely from the portfolio site!
2. ✅ Award badges (🏆 1st Place, 🏆 2nd Place, "2+ years running")
3. ✅ Clear "Featured vs More" visual hierarchy

---

## Design Guidelines

### Colors
- Background: `#0d1117`
- Card background: `#161b22`
- Card border: `#30363d`
- Text primary: `#c9d1d9`
- Text secondary: `#8b949e`
- Accent (links, title): `#58a6ff`
- Award badge: `#ffd700` (gold)
- Live badge: `#238636` (green)

### Typography
- Headings: system-ui or Inter, bold
- Body: system-ui, regular, line-height 1.6
- Tech names / code: monospace (Fira Code or similar)

### Spacing
- Between sections: 80–100px
- Between cards: 40–60px
- Card internal padding: 24–32px
- Content max-width: 800px (single column should not stretch too wide)

### Responsive
- max-width 800px centered. On mobile, just reduce horizontal padding
- Images: width 100%, scale down naturally
- Badges: flex-wrap

---

## Navigation (sticky top bar)
- **Keep** the sticky nav bar
- **Change menu items:**
  - Current: About / Stack / Portfolio / Foundations
  - New: **Projects / Stack / Experience**
  - "Projects" → scrolls to Featured Projects
  - "Stack" → scrolls to Tech Stack
  - "Experience" → scrolls to Experience

---

## Image Notes (from mentor feedback)
- BookToss images failed to load on some browsers (likely file size issue)
- **All screenshots must be optimized: WebP or compressed PNG, under 500KB each**
- Set explicit `width` and `height` attributes to prevent layout shift
- Add `loading="lazy"` to all images

---

## Build Priority
1. Hero section (new title + intro text)
2. Featured Projects — 4 big cards (especially add Sentinel!)
3. Remove all deleted sections
4. More Projects table
5. Tech Stack cleanup
6. Experience / Education (short version)
7. Navigation update
8. Image optimization