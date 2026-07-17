# Tailwind CSS Rules

- Use utility classes directly in markup over writing custom CSS — reach for `@apply` only to group a genuinely repeated utility combination (e.g. a button variant), not as a default habit.
- Design mobile-first: unprefixed utilities are the base/smallest breakpoint, with `sm:`/`md:`/`lg:` etc. layered on for larger viewports — don't design desktop-first and retrofit mobile overrides.
- Configure dark mode via Tailwind's `theme`/`darkMode` config rather than hand-written dark-mode CSS overrides; use `dark:` variants consistently wherever a light-mode utility is set.
- Extend the theme (`theme.extend`) for custom spacing, colors, and breakpoints instead of overriding Tailwind's defaults wholesale — keeps the design system's base scale intact while adding what's actually custom.
- Use semantic color names in the theme config (`primary`, `danger`, `surface`) rather than referencing raw palette values (`blue-500`) directly in components — a rebrand or theme change should mean editing the config, not every component.
- Ensure the build's content/purge configuration actually covers every file type in use (`.svelte`, `.html`, Angular component templates) — a misconfigured content glob silently ships unused CSS or, worse, strips classes that are actually used.
- Use state variants (`hover:`, `focus:`, `focus-visible:`, `active:`, `disabled:`) systematically for interactive elements — don't skip `focus-visible` states, which matters for keyboard accessibility.
- Check color contrast for text/background utility combinations against WCAG AA at minimum — a utility class being easy to apply doesn't guarantee it's accessible.
- Keep component-level utility strings organized and consistent in ordering (e.g. layout → spacing → typography → color → state) across the codebase so diffs stay readable — follow whatever ordering convention `prettier-plugin-tailwindcss` (if configured) already enforces rather than inventing a personal order.

