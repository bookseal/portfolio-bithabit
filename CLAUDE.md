# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What This Is

A static portfolio site for [bit-habit.com](https://bit-habit.com), belonging to Gichan Lee (Cloud Solutions Architect). Single-page, no framework, no build step.

## Development

There is no build, lint, or test step. Edit `index.html` directly.

**Live deployment:** Local edits are NOT live. Deploy = `git push origin master` — GitHub Actions (`.github/workflows/deploy.yml`) SSHes into the server, which `git pull`s its own clone (`~/workspace/static-web`); Nginx serves that folder via hostPath mount. k3s ingress routes `bit-habit.com` → `static-web-svc` → Nginx.

**Manual deploy — when Actions is down: `./deploy.sh`.** The deploy is really just "the server fast-forwards its clone"; Actions is a wrapper around that one command, not the deploy itself. `deploy.sh` runs the same thing directly (it refuses to run if you have unpushed commits, since the server pulls from GitHub).

Diagnosing a stuck deploy, in order:

1. **`queued` vs `failed` splits the problem in half.** Secrets, SSH keys and YAML errors all surface *after* a runner starts. A run stuck at `queued` never got a runner, so that whole family is already ruled out — only billing/limits, a `concurrency` lock, or a platform outage remain.
2. **GitHub fails in parts.** Check the component, not the marquee:
   ```sh
   curl -s https://www.githubstatus.com/api/v2/components.json \
     | grep -o '"name":"\(Actions\|API Requests\|Git Operations\)"[^}]*"status":"[a-z_]*"'
   ```
3. **Correlate timestamps.** Compare the run's `createdAt` against `https://www.githubstatus.com/api/v2/incidents.json`. On 2026-07-19 a `critical` Actions incident opened at 23:34 UTC and this repo's run was created at 23:43 — nine minutes in. Actions and the REST API were in `partial_outage` (hence `gh` returning HTTP 503) while **Git Operations stayed operational**, which is why `git push` still worked and `./deploy.sh` shipped the site by hand.

**Gotcha — use the `bit-habit` ssh alias, never the raw IP.** `~/.ssh/config` maps that alias to the server with `IdentitiesOnly yes` and the right key. Connecting to the IP directly never matches the Host block, so ssh offers the default key and fails with `Permission denied (publickey)`. A queued Actions run left over from an outage is harmless afterwards: it only runs `git pull --ff-only`, which is idempotent once the server is already up to date.

## Architecture

- `index.html` — the entire site: HTML, CSS (inline `<style>`), and JS (inline `<script>`). Dark-themed, git-scm inspired layout with sticky header nav, hero section, and project cards.
- `screenshots/` — project screenshots referenced by `index.html` (PNG files).
- `archive/` — retired assets (old JSON configs, default Nginx page, old screenshots). Move unused files here rather than deleting.

## URL Parameters — audience targeting

The same page is re-aimed at different audiences via query params. Nothing is duplicated;
one `index.html` serves every job application. Independent params: `?lang`, `?title`, `?role`, `?focus`.

### `?title=` — free-text hero job title (preferred for applications)

`?title=DevOps%20%2F%20SRE%20Engineer` → the hero reads exactly **DevOps / SRE Engineer**.

Overrides `?role=` completely. **This is the normal way to aim a link at a specific job posting** —
paste the posting's own job title and the page introduces you as exactly that. No code change,
no whitelist entry, works for any role that will ever exist.

Two rules, both non-negotiable:

- **`textContent`, never `innerHTML`.** `?title=<img src=x onerror=…>` is a live XSS vector otherwise;
  anyone opening the link would run script on this domain.
- **Filled by an inline `<script>` placed immediately after the hero `<div class="title">`**, so it
  lands during parse and never flashes. The `<head>` script sets `html.role-custom`, which hides all
  the fixed labels and reveals the empty `#hero-title-custom` span for this script to fill.

Input is normalized (whitespace collapsed, trimmed, capped at 60 chars). Clicking any footer
role-switch link deletes `?title=` — an explicit choice by the viewer beats the URL.

### `?role=` — swaps between four fixed titles (CSS only)

Kept for the footer's "view this profile as another role" toggle, which is itself a selling point.
For a specific application, prefer `?title=`.

`product` (default) · `solutions` · `infra` · `pm`

Runs in the **`<head>` inline script, before first paint** — this is deliberate. It only adds a
class to `<html>`:

```js
document.documentElement.classList.add('role-' + (allowed ? role : 'product'));
```

All four titles are already in the DOM (`<span class="roleopt …">`); CSS reveals exactly one:

```css
.roleopt { display: none; }
html.role-infra .roleopt.infra { display: inline; }
```

**Do not move this to a post-paint script** — the default title would flash before switching (FOUC).
Content is otherwise identical across roles; only the label changes. The footer's role-switch links
call `setRole()`, which swaps the class and calls `history.replaceState` (no reload, URL stays shareable).

### `?focus=` — reorders sections and cards (DOM manipulation)

`default` · `fde` · `edu` · `solutions` · `infra`

Runs at the **end of `<body>`**, after the DOM exists (`applySectionOrder()`). Two stages:

1. **Sections** — `ORDERS[focus]` drives `reorderable.appendChild(el)`. Re-appending an existing
   node *moves* it; that's the whole trick.
2. **Featured cards inside `#build`** — `CARD_ORDERS[focus]` drives
   `build.insertBefore(card, moreGridAnchor)`.
   **Must be `insertBefore`, not `appendChild`** — `appendChild` would push cards *behind* the
   `.more-grid` block of minor projects. The anchor keeps them in front.

There is intentionally **no UI toggle for `focus`** — it's a private handle used when tailoring a link
for a specific application. `role`, by contrast, *is* exposed in the footer (a recruiter clicking
"view as another role" is itself a selling point).

### Aiming the page at a new job posting

**Do not add a new `role` value.** Use `?title=` — it needs no code change. Add a `focus` value only
if the section/card order genuinely needs to differ; otherwise reuse an existing one.

Adding a `focus` value: `ORDERS` (required) and `CARD_ORDERS` (optional). Two lines.

Adding a `role` value still costs **6 scattered edits** (head whitelist, CSS reveal rule, hero span,
`setRole()` guard + `classList.remove`, the `role-(…)` regex, footer link). That cost is exactly why
`?title=` exists. If a fifth role ever becomes necessary anyway, collapse the whitelist into a single
`const ROLES = { product: 'AI Product Engineer', … }` first and derive the rest from it.

**Silent fallback is the main gotcha.** A typo (`?focus=infrastructure`) throws no error — it just
renders the default order. Always open the finished URL and confirm the intended card is on top
before pasting it into an application.

### Links currently in use

| Application | URL |
|---|---|
| Default / general | `https://bit-habit.com` |
| AI Solutions Engineer (Upstage) | `?focus=solutions&role=solutions` |
| DevOps / SRE (LG U+ DAX) | `?focus=infra&title=DevOps%20%2F%20SRE%20Engineer` |
| Education / DevRel | `?focus=edu` |

Encode the title: space → `%20`, `/` → `%2F`.

## Conventions

- All styling and scripting lives inline in `index.html` — no external CSS/JS files.
- CSS uses custom properties (`:root` variables) for theming.
- Images go in `screenshots/` and are referenced with relative paths (`./screenshots/...`).
