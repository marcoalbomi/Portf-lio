# db452687-95b8-474d-97ea-c74aef73bc3b implementation handoff

This archive is the source of truth for turning the design into production code. Start from `index.html`, then preserve the visual system, responsive behavior, and interactions found in the exported files.

## Implementation target
- Build production UI from the exported design, not a loose reinterpretation.
- Preserve typography scale, spacing rhythm, color tokens, border radii, shadows, motion timing, and component states.
- Replace static placeholders only when the target app has real data or functional equivalents.
- Keep generated product UI free of Open Design chrome, preview labels, or design-process annotations.
- Treat this handoff as a visual contract: if implementation choices conflict, match the exported pixels and behavior first, then refactor internals.

## Source map
- Primary entry: `index.html`
- HTML screens detected: 3
- Stylesheets detected: 0
- Script/component files detected: 0
- Supporting assets detected: 103

## Responsive contract
Validate the implementation across this 2025–2026 viewport matrix:
- Mobile compact: 360×800
- Mobile standard: 390×844
- Mobile large: 430×932
- Foldable / small tablet: 600×960
- Tablet portrait: 820×1180
- Tablet landscape: 1024×768
- Laptop: 1366×768
- Desktop: 1440×900
- Wide desktop: 1920×1080

For responsive web exports, treat these as a modern breakpoint system for one adaptive web experience, not three fixed screenshots. Do not split responsive web into unrelated native app screens unless the project explicitly includes native targets. Use semantic layout thresholds, fluid `clamp()` type/spacing, and container queries where component width matters more than viewport width. Preserve any CSS media queries, container queries, fluid `clamp()` scales, and layout changes already present in the exported files.

## Design fidelity contract
- Extract reusable tokens before writing components: background, surface, foreground, muted text, border, accent, radius, shadow, spacing, type scale, and motion duration/easing.
- Map product screens, in-app modules/components, optional landing page, and optional OS widget surfaces before coding. Keep these surfaces separate in the target architecture.
- Match layout geometry: max-widths, gutters, grid columns, card proportions, sticky/fixed elements, and viewport-specific navigation.
- Preserve real copy, labels, and data shown in the export. Do not replace specific text with generic marketing filler.
- Preserve interactive affordances: hover, focus, pressed, disabled, loading, validation, copy/share, tab/accordion, modal/sheet, and keyboard states where present.
- Preserve accessibility semantics when converting: headings stay hierarchical, controls remain buttons/links/inputs, focus states stay visible.
- Do not keep prototype-only annotations, frame labels, or Open Design chrome in the production UI.

## CJX-ready UX contract
- Use `DESIGN-MANIFEST.json` as the machine-readable map for screens, app modules, OS widgets, landing pages, tokens, interactions, and viewport checks.
- Screen-file-first: when multiple user-facing surfaces exist, implement each HTML screen as its own route/file. Treat `index.html` as a launcher/overview when the manifest marks it that way, not as a combined final UI.
- If `landing.html`, app screens, platform screens, or OS widget files exist, preserve those boundaries in the target app instead of merging them into one page.
- A single self-contained `index.html` is acceptable only when the export truly contains one user-facing screen and its CSS/JS are structured enough to extract tokens, components, states, and behavior.
- If separate `css/` or `js/` files exist, treat them as source of truth for token/component/interactions before porting to React, Vue, SwiftUI, Compose, or another target stack.
- In-app modules/components are product UI blocks inside the app. OS widgets are home-screen/lock-screen/quick-access surfaces outside the app. Do not merge those concepts.

## Color and brand contract
- Use the exported design tokens and product/domain context as the color source of truth.
- Do not introduce warm beige / cream / peach / pink / orange-brown background washes unless they are already explicit brand/reference colors in the export.
- No obvious token stylesheet was detected; sample colors from the entry file and convert them into named tokens before coding.

## Implementation sequence for AI coding tools
1. Open `index.html` and `DESIGN-MANIFEST.json`; identify every screen file, launcher/overview file, app module, and interaction before coding.
2. If multiple HTML screens exist, map them to separate routes/surfaces first; do not merge `landing.html`, product app screens, platform screens, or OS widgets into one route.
3. Extract a token table from CSS/root styles and inline styles before building framework components.
4. Build product screens and domain-specific in-app modules from largest layout regions down to controls; avoid starting with isolated atoms that lose spatial intent.
5. Port responsive behavior across the modern viewport matrix and test each semantic breakpoint before cleanup.
6. Port interactions and states, then replace static placeholders only with real app data or functional equivalents.
7. Keep optional landing page and OS widget surfaces as separate surfaces if present.
8. Compare final screenshots against the export at 360×800, 390×844, 430×932, 820×1180, 1024×768, 1366×768, 1440×900, and 1920×1080 before declaring done.

## Entry points
- `admin.html`
- `index.html`
- `portfolio-marco-albornoz.html`

## Styles
- None detected

## Scripts/components
- None detected

## Assets and supporting files
- `${APPDATA}/npm/vc`
- `${APPDATA}/npm/vc.cmd`
- `${APPDATA}/npm/vc.ps1`
- `${APPDATA}/npm/vercel`
- `${APPDATA}/npm/vercel.cmd`
- `${APPDATA}/npm/vercel.ps1`
- `critique.json`
- `drowner-font/Drowner - Free Version/OpenType-PS/Drowner-Free.otf`
- `drowner.otf`
- `mqjvt35e-image.png`
- `mqjw0l65-image.png`
- `mqjw0tsw-image.png`
- `mqjxdtjd-image.png`
- `mqjxtjkx-image.png`
- `mqjy6don-image.png`
- `mqjyd1o9-image.png`
- `mqjyj6a7-image.png`
- `mqjziyqs-image.png`
- `mqk00nkq-image.png`
- `mqk09hq5-image.png`
- `mqk0g004-image.png`
- `mqk0lz7d-image.png`
- `mqk11fyo-image.png`
- `mqk1910p-image.png`
- `mqkw73fd-image.png`
- `mqkwceid-image.png`
- `mqkwdyy8-image.png`
- `mqkwffj8-image.png`
- `mqkwhl24-image.png`
- `mqkwk1yi-image.png`
- `mqkwoc2x-image.png`
- `mqkwrupt-image.png`
- `mqkxr1md-image.png`
- `mqkxuoc7-image.png`
- `mqky1q99-image.png`
- `mqky7ctv-image.png`
- `mqkye9nd-image.png`
- `mqkyi4eb-image.png`
- `mqkym9ui-image.png`
- `mqkyqnrz-image.png`
- `mqkz1nqb-image.png`
- `mqkzok4w-image.png`
- `mqkzumi6-image.png`
- `mql0k7eh-image.png`
- `mql0ot5q-image.png`
- `mql0xx3g-image.png`
- `mql167c7-sobre-mim.jpg`
- `mql1ezm9-image.png`
- `mql1hqtq-image.png`
- `mql1lp8u-image.png`
- `mql1o7ib-image.png`
- `mql2cxcj-image.png`
- `mql2n9b7-image.png`
- `mql2zucm-image.png`
- `mql4p3sp-image.png`
- `mql4qrof-image.png`
- `mql8nmzk-image.png`
- `mql97c9t-mql8nmzk-image.png`
- `mql9wfdj-contato.jpg`
- `mqpn93un-image.png`
- `mqpn9y2r-image.png`
- `mqpnhhz6-image.png`
- `mqpni6dz-Drowner---Free-Version-by-Hainz-Studio.zip`
- `mqpnzpj2-Drowner---Free-Version-by-Hainz-Studio.zip`
- `mqpo0w1h-Drowner---Free-Version-by-Hainz-Studio.zip`
- `mqpo7mqj-image.png`
- `mqpo9ra0-image.png`
- `mqpocvvy-image.png`
- `mqpodoep-image.png`
- `mqpoibr7-image.png`
- `mqponk3r-image.png`
- `mqpotina-image.png`
- `mqpp4xk8-image.png`
- `mqqnwfn8-image.png`
- `mqqnxkqi-image.png`
- `mqqnybdk-image.png`
- `mqqnyxof-image.png`
- `mqqo48yr-image.png`
- `mqqoejqo-image.png`
- `mqqof87i-image.png`
- `mqqond2c-image.png`
- `mqqoswnp-image.png`
- `mqqoznef-image.png`
- `mqqpgxw4-image.png`
- `mqqpqy01-image.png`
- `mqqptbjp-image.png`
- `mqqpz6st-image.png`
- `mqqq2mqa-image.png`
- `mqqq6eeg-image.png`
- `mqqqcbhg-image.png`
- `mqs3wnsw-image.png`
- `mqs3zzq2-image.png`
- `mqs40j6h-image.png`
- `mqs462l8-image.png`
- `mqs49tlm-image.png`
- `mqs4c1mo-image.png`
- `mqs4fjij-image.png`
- `mqs4i9vm-image.png`
- `mqs4wn1l-image.png`
- `mqs4zo4n-image.png`
- `package-lock.json`
- `package.json`
- `README.md`

## Coding checklist for AI tools
1. Inspect `index.html` and `DESIGN-MANIFEST.json` first and identify reusable components before coding.
2. Implement each user-facing screen file as its own route/surface; keep launcher, landing, app, platform, and OS widget files separate.
3. Extract design tokens into the target stack: colors, type scale, spacing, radius, shadows, and motion.
4. Implement layout with real 2025–2026 responsive breakpoints, fluid type/spacing, and container-query-aware component behavior; test with no horizontal overflow.
5. Preserve interactive controls, hover/focus/pressed states, form behavior, validation, and copy actions where present.
6. Implement domain-specific in-app modules with real states; do not flatten them into generic cards.
7. Keep landing page, product screens, and OS widget/quick-access surfaces separate when present.
8. Confirm the production result visually matches the exported design before refactoring internals.
9. Reject implementation shortcuts that flatten the design into generic cards, generic gradients, placeholder stats, or framework-default typography.
10. If a detail is ambiguous, keep the exported HTML/CSS/JS behavior rather than inventing a new pattern.
