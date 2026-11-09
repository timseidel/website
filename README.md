# Personal website

A [Quarto](https://quarto.org) website: a landing page and a blog, deployed to
GitHub Pages by GitHub Actions on every push to `main`.

## Layout

```
_quarto.yml                 site config (title, navbar, theme wiring)
index.qmd                   landing page
theme.scss                  design system: palette, typography, components
theme-dark.scss             dark-mode palette only
fonts/                      self-hosted IBM Plex (+ plex.css)
images/profile.jpg          portrait
blog/index.qmd              blog listing (generated from the posts folder)
blog/posts/_metadata.yml    defaults applied to every post
blog/posts/<slug>/index.qmd one post per folder
.github/workflows/publish.yml
```

## Writing a post

Create `blog/posts/YYYY-MM-DD-slug/index.qmd` with a header:

```yaml
---
title: "Post title"
description: "One line, shown on the listing page."
date: 2026-10-01
categories: [stats, R]
---
```

Then write Markdown. The listing page picks it up automatically. Keep images
and data files in the same folder as the post.

## Local preview

Install Quarto (`brew install --cask quarto`), then:

```bash
quarto preview
```

Posts with R or Python chunks: `freeze: auto` caches their output in
`_freeze/`, which is committed. Render locally (`quarto render`) and commit
`_freeze/` before pushing, so the GitHub build does not need your packages.

## Design notes

Type is [IBM Plex](https://www.ibm.com/plex/) throughout — Serif for the name
and headings, Sans for body text, Mono for the small uppercase labels (section
kickers, timeline dates) and code. One superfamily, so everything shares a
voice.

The fonts are **self-hosted** in `fonts/` rather than loaded from Google Fonts,
so the site makes no third-party requests — German courts have treated
embedding Google Fonts as a GDPR violation. Only the latin and latin-ext
subsets are included (about 180 KB). To swap fonts, replace the `.woff2` files
and the `@font-face` rules in `fonts/plex.css`, then update the font stacks at
the top of `theme.scss`.

The accent green is sampled from the portrait: the foliage behind you sits at
hue 88° with roughly 0.3–0.45 saturation, so links and highlights use that same
hue pushed darker (`#496629`) in light mode and lighter (`#a8c981`) in dark, and
the paper and hairlines carry a trace of it. Every pair clears WCAG AA — the
light accent is 6.3:1 on paper, the dark one 9.8:1 on background.

Colours live as CSS custom properties (`--ink`, `--muted`, `--accent`,
`--accent-hover`, `--line`, `--card`, `--sunken`) in the `:root` block of each
theme file. `theme.scss` carries all typography, layout and components;
`theme-dark.scss` overrides nothing but the palette. To shift the whole site to
a different hue, change these values and the matching Sass variables above them
— the custom components and Bootstrap's own borders both follow.

The landing page's hero heading is a `div` with `role="heading"`, not an `h1`,
because Quarto hoists the first `h1` on a page into its title block — which
would pull the name out of the hero layout.

## One-time setup

In the repo settings, under **Pages**, set **Source** to **GitHub Actions**.
Then update `site-url` in `_quarto.yml` if you use a custom domain.
