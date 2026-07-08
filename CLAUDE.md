# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What This Is

A static portfolio site for [bit-habit.com](https://bit-habit.com), belonging to Gichan Lee (Cloud Solutions Architect). Single-page, no framework, no build step.

## Development

There is no build, lint, or test step. Edit `index.html` directly.

**Live deployment:** Local edits are NOT live. Deploy = `git push origin master` — GitHub Actions (`.github/workflows/deploy.yml`) SSHes into the server, which `git pull`s its own clone (`~/workspace/static-web`); Nginx serves that folder via hostPath mount. k3s ingress routes `bit-habit.com` → `static-web-svc` → Nginx.

## Architecture

- `index.html` — the entire site: HTML, CSS (inline `<style>`), and JS (inline `<script>`). Dark-themed, git-scm inspired layout with sticky header nav, hero section, and project cards.
- `screenshots/` — project screenshots referenced by `index.html` (PNG files).
- `archive/` — retired assets (old JSON configs, default Nginx page, old screenshots). Move unused files here rather than deleting.

## Conventions

- All styling and scripting lives inline in `index.html` — no external CSS/JS files.
- CSS uses custom properties (`:root` variables) for theming.
- Images go in `screenshots/` and are referenced with relative paths (`./screenshots/...`).
