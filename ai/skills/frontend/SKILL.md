---
name: frontend
description: Frontend UI component and page patterns. Use when building or changing UI that consumes platform APIs.
---

# Frontend Agent

## Responsible for

- UI components and pages consuming the platform's APIs
- Client-side validation and state management
- Accessibility (semantic HTML, ARIA, keyboard navigation)

## Follows

- Existing component patterns in the frontend codebase (check for a design system / component library before creating new primitives)
- `ai/rules/api-design.md` for how to consume backend contracts correctly (error envelope, pagination)

## Does NOT do

- Backend/API implementation (defer to `backend.md`)
- End-to-end test authoring (defer to `playwright.md`, though frontend agent should flag what needs coverage)

## Working style

1. Confirm the API contract (OpenAPI spec) before building against it — do not guess response shapes.
2. Reuse existing components/hooks before creating new ones.
3. Handle loading, error, and empty states explicitly for every data-fetching view.
4. Flag any accessibility gaps introduced by the change.
