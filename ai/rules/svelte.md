# Svelte Rules

- Target Svelte 5 runes, not Svelte 4 implicit reactivity: use `$state()`, `$derived()`, and `$effect()` for reactive state, computed values, and side effects respectively — don't write new code with `$:` reactive statements or `export let` props.
- Runes are compiler syntax, not imports — never `import { $state } from 'svelte'`; only import genuine runtime utilities (`tick`, `mount`, `unmount`) when needed.
- Use native HTML event attributes (`onclick`, `oninput`) instead of the old `on:click` directive syntax; handle modifier behavior (`preventDefault`, `stopPropagation`) explicitly inside the handler rather than relying on removed modifier syntax.
- For component props, use `$props()` destructuring with `$bindable()` for two-way bound props — not `export let`.
- Use snippets (`{#snippet}`) and render tags (`{@render}`) to eliminate markup duplication instead of duplicating template blocks or over-using slots.
- For non-trivial state that bundles data with behavior, prefer a class wrapping `$state()` fields with methods (e.g. a `Counter` class with `increment()`), giving a clean boundary between logic and UI — over scattering related reactive declarations across a component.
- Keep components small and single-purpose; extract shared logic into `.svelte.ts` modules (runes work outside `.svelte` files too) rather than duplicating logic across components.
- Use SvelteKit's built-in routing, load functions, and form actions as the foundation — don't reach for a third-party router or client-side-only data fetching when SvelteKit's server-side primitives cover it.
- Type stores and rune-based state explicitly — don't let a store's value type be inferred as `any` implicitly.
- Test components with Vitest + `@testing-library/svelte`; cover store behavior, async operations (with proper mocking), and key user interactions — not just that a component renders without throwing.

