# Pump Flutter UI Conventions

## Purpose

This document defines UI and presentation conventions for the Pump Flutter
application.

New screens and modified UI should feel like part of the existing Pump
application rather than independently designed features.

Always inspect nearby existing screens before introducing new UI patterns.

---

# 1. Existing Design System First

Reuse existing Pump UI components and constants before creating alternatives.

Prefer existing:

- AppColors
- typography
- spacing conventions
- CustomScaffold
- CustomTextField
- buttons
- cards
- dialogs
- loading indicators
- reusable widgets

Do not create a duplicate component merely because a slightly different
version is convenient.

---

# 2. Screen Structure

Use the established Pump screen structure.

Where applicable:

CustomScaffold
↓
Screen content
↓
Reusable sections/widgets

Do not replace `CustomScaffold` with a raw `Scaffold` when the existing screen
should follow the application's shared scaffold behavior.

Inspect nearby screens first.

---

# 3. Screen-Owned UI

A screen should compose its UI from focused widgets.

Extract widgets when doing so:

- improves readability
- represents a meaningful reusable component
- prevents a screen build method from becoming difficult to understand

Do not extract every small widget merely to reduce line count.

Avoid unnecessary abstraction.

---

# 4. Colors

Use `AppColors` and existing theme/design constants.

Do not scatter arbitrary colors through feature screens when an established
Pump color already represents the intended role.

Do not introduce a parallel color system.

Platform/native brand colors may be used where explicitly appropriate, such
as recognized social-platform branding, if consistent with existing design.

---

# 5. Typography

Follow existing Pump typography patterns.

Maintain clear hierarchy between:

- screen title
- section title
- primary content
- secondary content
- helper text
- metadata
- errors

Do not introduce a new typography system for an individual screen.

---

# 6. Spacing

Follow nearby Pump screens for:

- page padding
- section spacing
- card padding
- field spacing
- button spacing

Prefer consistent spacing over arbitrary per-screen values.

Do not perform broad spacing redesigns outside the current task.

---

# 7. Cards and Surfaces

Reuse established Pump surface/card styling.

Keep:

- border radius
- surface hierarchy
- borders
- shadows
- internal padding

consistent with nearby screens.

Do not introduce visually unrelated card styles without a product reason.

---

# 8. Forms

Use existing Pump form/input components where they support the requirement.

Forms should clearly communicate:

- field purpose
- required input where appropriate
- validation errors
- disabled/loading states

Do not duplicate authoritative backend business rules in the UI.

Client validation exists primarily for immediate user experience.

Backend validation remains authoritative.

---

# 9. Loading States

Loading behavior should match the scope of the operation.

Do not replace an entire populated screen with a full-screen loading indicator
when only one subsection is refreshing and existing content remains valid.

Use localized loading state where appropriate.

Prevent accidental duplicate submissions.

---

# 10. Empty States

Empty states should explain the meaningful absence and, when appropriate,
provide the next available action.

Example:

A Training Block without programmed exercises may show:

- Training Block summary
- Add Exercises action

rather than rendering meaningless empty workout-performance controls.

Do not represent valid empty state as an error.

---

# 11. Error States

Present user-facing errors intentionally.

Prefer established Pump error presentation patterns.

Do not expose:

- stack traces
- exception class names
- SQL/database details
- internal service implementation details

When existing content remains valid, avoid unnecessarily replacing the entire
screen because a secondary operation failed.

---

# 12. Navigation

Follow existing navigation patterns.

Buttons and actions should navigate according to established Pump behavior.

Avoid hidden or surprising navigation side effects.

After successful create/update operations, deliberately determine whether to:

- navigate back
- navigate to another screen
- remain and refresh
- update local state

based on the feature flow.

---

# 13. Data Passing

Pass existing valid data to another screen when sufficient.

Do not perform another API call solely because a new screen was opened if the
caller already owns all required authoritative data.

Fetch when the target screen requires:

- additional information
- refreshed information
- authoritative current state

---

# 14. Responsive Layout

Do not assume one exact device dimension.

Use Flutter layout primitives and existing responsive patterns.

Avoid unnecessary hard-coded widths/heights that break on different supported
screen sizes.

Hard-coded dimensions may still be appropriate for intentionally fixed UI
elements.

---

# 15. Lists

Use appropriate lazy list widgets for collections that may grow.

Preserve stable ordering when ordering has domain meaning.

Avoid expensive work directly inside repeated item builders.

Follow established pagination behavior for backend-paginated collections.

---

# 16. User Actions

Make primary actions visually clear.

Do not introduce multiple competing primary actions without a reason.

Disable or protect actions while an operation is already being submitted when
duplicate execution would be incorrect.

---

# 17. Optimistic UI

Use optimistic UI only where the existing feature pattern supports it and
failure can be reconciled safely.

The backend remains the source of truth.

On failure:

- rollback/reconcile local state
- communicate failure appropriately

Do not leave the UI permanently inconsistent with backend state.

---

# 18. Accessibility and Interaction

Use appropriate semantic controls and interaction targets.

Do not make essential actions dependent solely on color.

Preserve readable contrast according to the established Pump design.

Use appropriate keyboard/input types for forms.

---

# 19. UI Scope Control

Do not redesign unrelated UI while implementing a feature.

When modifying a screen:

- preserve existing visual language
- change only what the requirement needs
- reuse existing components
- identify larger redesign opportunities separately

Feature development is not permission for an unsolicited application redesign.
