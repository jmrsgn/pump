# Pump Flutter UI Conventions

## Purpose

This document defines UI and presentation conventions for the Pump
Flutter application.

New screens and modified UI should feel like part of the existing Pump
application rather than independently designed features.

Always inspect nearby existing screens and reusable components before
introducing a new UI pattern.

Apply these conventions to newly created UI and UI directly modified by
the current task.

Do not redesign unrelated screens merely to make older UI conform.

These conventions complement `architecture-conventions.md`,
`coding-conventions.md`, and `testing-conventions.md`.

------------------------------------------------------------------------

## 1. Existing Design System First

Reuse existing Pump UI components, constants, and visual patterns before
creating alternatives.

Prefer existing:

-   `AppColors`;
-   typography;
-   spacing conventions;
-   `CustomScaffold`;
-   `CustomTextField`;
-   `CustomButton`;
-   cards;
-   dialogs;
-   loading indicators;
-   reusable widgets.

Before creating a new reusable component:

1.  search for an existing component with the same responsibility;
2.  inspect nearby screens for the established pattern;
3.  extend or reuse the existing component when doing so remains
    semantically correct;
4.  create a new component only when the requirement is genuinely
    different.

Do not create a duplicate component merely because a slightly different
version is convenient.

Do not introduce a parallel design system for one feature.

------------------------------------------------------------------------

## 2. Visual Consistency and Source of Truth

Treat the existing Pump application and its established shared
components as the primary source of truth for implementation styling
unless an explicit design requirement says otherwise.

When implementing or modifying a screen, inspect comparable existing
screens for:

-   layout structure;
-   spacing;
-   typography;
-   surfaces;
-   fields;
-   buttons;
-   section hierarchy;
-   loading behavior;
-   empty/error presentation;
-   navigation behavior.

Do not infer a new visual language from a single isolated screen when
broader Pump patterns already exist.

If a requested design intentionally differs from existing Pump patterns,
make the difference only where required rather than redesigning
surrounding UI.

------------------------------------------------------------------------

## 3. Screen Structure

Use the established Pump screen structure.

Where applicable:

``` text
CustomScaffold
  ↓
Screen content
  ↓
Focused sections / reusable widgets
```

Do not replace `CustomScaffold` with a raw `Scaffold` when the screen
should follow the application's shared scaffold behavior.

Use a raw Flutter component only when the shared Pump component does not
support the requirement or when the screen intentionally has different
behavior.

Keep screen-level layout responsibilities clear.

Avoid deeply nesting unrelated layout concerns inside one large
`build()` method.

------------------------------------------------------------------------

## 4. Screen-Owned UI

A screen should compose its UI from focused widgets.

Extract widgets when doing so:

-   improves readability;
-   represents a meaningful reusable component;
-   represents a meaningful screen section;
-   prevents a screen `build()` method from becoming difficult to
    understand;
-   isolates UI with its own focused behavior.

Do not extract every small widget merely to reduce line count.

Avoid unnecessary abstraction.

A widget used only by one screen may remain screen-local when it does
not represent a reusable application component.

Do not promote a screen-specific widget into a global shared component
without genuine reuse or a clear shared responsibility.

------------------------------------------------------------------------

## 5. Shared Components

Shared Pump components should represent stable, reusable UI
responsibilities.

Examples include:

``` text
CustomScaffold
CustomTextField
CustomButton
```

When a shared component nearly satisfies a requirement, prefer extending
it with a clear, generally useful option rather than creating a
duplicate.

Do not add feature-specific behavior to a shared component merely to
avoid creating a local widget.

A shared component API should remain understandable for all of its
consumers.

When changing a shared component:

-   inspect existing call sites;
-   preserve existing behavior unless the change intentionally affects
    them;
-   avoid making a previously required behavior ambiguous;
-   verify affected screens when practical.

------------------------------------------------------------------------

## 6. Colors

Use `AppColors` and existing theme/design constants.

Do not scatter arbitrary colors through feature screens when an
established Pump color already represents the intended role.

Prefer semantic application colors over repeated literal values.

Avoid:

``` dart
Color(0xFF123456)
```

inside feature UI when an appropriate `AppColors` value already exists.

Do not introduce a parallel color system.

Platform or native brand colors may be used where explicitly
appropriate, such as recognized social-platform branding, if consistent
with existing Pump design.

Do not use color alone to communicate essential state or meaning.

------------------------------------------------------------------------

## 7. Typography

Follow existing Pump typography patterns.

Maintain clear hierarchy between:

-   screen title;
-   section title;
-   primary content;
-   secondary content;
-   helper text;
-   metadata;
-   errors.

Reuse established text styles and font conventions where available.

Do not introduce a new typography system for an individual screen.

Avoid arbitrary per-widget font sizes and weights when an established
style already represents the intended hierarchy.

Use emphasis deliberately. Do not make multiple unrelated elements
compete as the strongest visual element on the same screen.

------------------------------------------------------------------------

## 8. Spacing

Follow nearby Pump screens and established spacing conventions for:

-   page padding;
-   section spacing;
-   card padding;
-   field spacing;
-   button spacing;
-   list-item spacing.

Prefer consistent spacing over arbitrary per-screen values.

When an existing spacing constant or pattern represents the required
distance, reuse it.

Do not create a new spacing scale for one feature.

Do not perform broad spacing redesigns outside the current task.

Fixed spacing values may be used when consistent with the existing
screen/component pattern and no shared constant is appropriate.

------------------------------------------------------------------------

## 9. Cards and Surfaces

Reuse established Pump surface and card styling.

Keep applicable properties consistent with nearby screens:

-   border radius;
-   surface hierarchy;
-   borders;
-   shadows;
-   internal padding;
-   separation between cards and page background.

Do not introduce visually unrelated card styles without a product
reason.

Use cards and surfaces to communicate meaningful grouping rather than
wrapping every individual value in a container.

Avoid excessive nested cards or surfaces when hierarchy can be expressed
more simply.

------------------------------------------------------------------------

## 10. Forms

Use existing Pump form/input components where they support the
requirement.

Prefer `CustomTextField` over introducing a separate feature-specific
text field when its behavior is sufficient.

Forms should clearly communicate:

-   field purpose;
-   required input where appropriate;
-   validation errors;
-   disabled state;
-   loading/submitting state.

Use appropriate:

-   keyboard types;
-   input formatters;
-   obscured input behavior;
-   multiline behavior;
-   controllers;
-   focus behavior;

according to the field requirement and existing component capabilities.

Do not duplicate authoritative backend business rules in the UI.

Client validation exists primarily for immediate user experience.

Backend validation remains authoritative.

Do not silently transform invalid or missing input into apparently valid
domain values merely to allow submission.

------------------------------------------------------------------------

## 11. Buttons and Actions

Use `CustomButton` for Pump-standard actions when it supports the
required behavior.

Do not create a new button implementation merely to achieve minor visual
differences that the existing component can represent.

Make the primary action visually clear.

Avoid multiple competing primary actions without a product reason.

Use secondary, destructive, or lower-emphasis actions according to
existing Pump patterns.

Action labels should describe what the action does.

Prefer:

``` text
Create Training Block
Add Exercises
Save Changes
```

over vague labels such as:

``` text
Continue
Submit
OK
```

when the more specific action is known.

Disable or otherwise protect an action while an operation is already
being submitted when duplicate execution would be incorrect.

Do not make a disabled action appear interactive.

------------------------------------------------------------------------

## 12. Destructive Actions

Destructive actions should be visually and behaviorally distinct
according to existing Pump patterns.

Examples include:

-   delete;
-   remove;
-   unenroll;
-   discard when data loss is meaningful.

Require confirmation when accidental execution would have meaningful
consequences and the existing product pattern supports confirmation.

Confirmation text should clearly identify the consequence.

Do not use destructive styling for ordinary secondary actions.

Do not add confirmation dialogs to harmless actions merely to create
friction.

------------------------------------------------------------------------

## 13. Loading States

Loading behavior should match the scope of the operation.

For initial loading where no useful content exists yet, use the
established Pump loading presentation.

Do not replace an entire populated screen with a full-screen loading
indicator when only one subsection is refreshing and existing content
remains valid.

Use localized loading state where appropriate.

Examples:

``` text
Initial screen load
→ screen-level loading

Refreshing one section
→ localized loading

Submitting a form
→ submitting state on the relevant action
```

Prevent accidental duplicate submissions.

Do not display stale interactive controls as if an operation is idle
when they could trigger an invalid duplicate action.

------------------------------------------------------------------------

## 14. Empty States

Empty states should explain the meaningful absence and, when
appropriate, provide the next available action.

Example:

``` text
Training Block exists
→ no programmed exercises
→ show Training Block summary
→ show Add Exercises action
```

rather than rendering meaningless workout-performance controls.

Do not represent valid empty state as an error.

Do not use generic:

``` text
No data
```

when a more meaningful Pump-specific explanation is available.

An empty-state action should only be shown when the user can actually
perform that next action.

------------------------------------------------------------------------

## 15. Error States

Present user-facing errors intentionally.

Prefer established Pump error presentation patterns.

Do not expose:

-   stack traces;
-   exception class names;
-   SQL/database details;
-   internal service implementation details;
-   raw transport errors;
-   sensitive information.

When existing content remains valid, avoid unnecessarily replacing the
entire screen because a secondary operation failed.

Match the error presentation to the scope of the failure.

Examples:

``` text
Initial screen load fails
→ screen-level error may be appropriate

Secondary refresh fails
→ preserve valid content and show localized feedback

Form submission fails
→ keep entered values when appropriate and show actionable feedback
```

Do not present a backend failure as a successful empty state.

------------------------------------------------------------------------

## 16. Feedback and One-Time Effects

Use established Pump presentation patterns for one-time user feedback.

Examples include:

-   SnackBars;
-   dialogs;
-   navigation after success;
-   inline validation feedback.

Do not trigger one-time effects repeatedly because a widget rebuilt.

Coordinate one-time effects through the established
screen/ViewModel/Riverpod pattern, such as `ref.listen(...)`, when
appropriate.

Feedback should be relevant and actionable.

Avoid displaying both inline and global error feedback for the same
failure unless each serves a distinct purpose.

Architectural ownership of presentation effects is defined by
`architecture-conventions.md`.

------------------------------------------------------------------------

## 17. Navigation

Follow existing navigation patterns.

Buttons and actions should navigate according to established Pump
behavior.

Avoid hidden or surprising navigation side effects.

After successful create or update operations, deliberately determine
whether to:

-   navigate back;
-   navigate to another screen;
-   remain and refresh;
-   update local state;
-   return a result to the previous screen.

Choose behavior based on the feature flow rather than applying one
navigation pattern universally.

Do not introduce another navigation framework for a feature.

Keep navigation actions discoverable from the UI when the user is
expected to initiate them.

------------------------------------------------------------------------

## 18. Data Passing

Pass existing valid data to another screen when sufficient.

Do not perform another API call solely because a new screen was opened
if the caller already owns all required authoritative data.

Fetch when the target screen requires:

-   additional information;
-   refreshed information;
-   authoritative current state.

Keep route/screen arguments explicit and type-safe.

Do not pass large unrelated state objects merely because they are
available.

Architectural state ownership and refresh decisions are defined by
`architecture-conventions.md`.

------------------------------------------------------------------------

## 19. Lists

Use appropriate lazy list widgets for collections that may grow.

Examples include:

``` dart
ListView.builder
ListView.separated
```

when appropriate to the existing UI.

Preserve stable ordering when ordering has domain meaning.

Avoid expensive work directly inside repeated item builders.

Keep list-item widgets focused and readable.

Follow established pagination behavior for backend-paginated
collections.

When loading another page fails, preserve already valid items when the
architecture defines them as still usable.

Provide meaningful empty behavior rather than rendering an unexplained
blank collection area.

------------------------------------------------------------------------

## 20. Responsive Layout

Do not assume one exact device dimension.

Use Flutter layout primitives and existing responsive patterns.

Prefer layouts that adapt to available constraints.

Avoid unnecessary hard-coded widths or heights that break on different
supported screen sizes.

Hard-coded dimensions may still be appropriate for intentionally fixed
UI elements.

Consider:

-   narrow device widths;
-   longer text;
-   keyboard visibility;
-   safe areas;
-   dynamic content length.

Do not add a new responsive framework merely for one screen.

------------------------------------------------------------------------

## 21. Safe Areas, Insets, and Keyboard

Respect device safe areas and the behavior provided by established Pump
scaffolding.

Do not place essential controls where system UI can obscure them.

Forms should remain usable when the keyboard is visible.

When appropriate, ensure users can reach fields and actions through
scrolling rather than relying on one fixed screen height.

Do not add redundant `SafeArea` widgets when `CustomScaffold` or another
established parent already handles the required inset behavior.

Inspect the existing component behavior before layering additional inset
handling.

------------------------------------------------------------------------

## 22. Scroll Behavior

Use scrolling when content may exceed the available viewport.

Do not force a fixed-height screen for content whose size varies with:

-   validation errors;
-   device size;
-   keyboard visibility;
-   dynamic backend content;
-   localization or text length.

Avoid unnecessary nested scroll views.

When nested scrolling is genuinely required, use an established
Flutter/Pump pattern and keep scroll ownership clear.

Lists that can grow should normally use an appropriate lazy scrolling
widget rather than placing a large generated collection inside a
general-purpose scroll view.

------------------------------------------------------------------------

## 23. Dialogs, Sheets, and Overlays

Use existing Pump patterns for dialogs, bottom sheets, and overlays.

Choose the presentation based on the interaction's purpose.

Use a dialog when focused confirmation or a short blocking decision is
appropriate.

Use another established surface when the interaction requires richer or
longer content.

Do not place complex full-screen workflows into a small dialog merely to
avoid navigation.

Dialogs and overlays should provide clear actions and dismissal
behavior.

Avoid stacking multiple modal surfaces unless the product flow genuinely
requires it.

------------------------------------------------------------------------

## 24. Icons and Visual Symbols

Use icons that match existing Pump and Flutter conventions.

Prefer established icon usage over introducing a new icon package for
one feature.

Icons should support comprehension rather than act as unexplained
decoration.

When an icon represents an action that may not be obvious, pair it with
text or an accessible semantic label where appropriate.

Use recognized native/platform branding only where explicitly relevant
and consistent with the application.

Do not use different icons for the same action across nearby screens
without a reason.

------------------------------------------------------------------------

## 25. Images and Media

Display images/media using existing Pump patterns where available.

Handle applicable states such as:

-   loading;
-   missing media;
-   failed media loading;
-   placeholder/fallback presentation.

Do not allow a media failure to break the entire surrounding screen when
the rest of the content remains usable.

Use sizing and fit behavior intentionally.

Avoid stretching media in ways that distort its intended aspect ratio
unless the design explicitly requires it.

Do not introduce a new media-loading/caching dependency incidentally.

------------------------------------------------------------------------

## 26. User Actions

Make interactive elements visually and behaviorally clear.

Do not rely on visual appearance alone when a semantic control already
exists.

Protect actions while an operation is in progress when duplicate
execution would be incorrect.

Do not attach unrelated side effects to an action.

A tap target should perform the action the UI communicates.

Avoid making an entire large surface tappable when only a clearly
identified action is intended, unless that interaction pattern is
already established.

------------------------------------------------------------------------

## 27. Optimistic UI

Use optimistic UI only where the existing feature pattern supports it
and failure can be reconciled safely.

The backend remains the source of truth.

On failure:

-   roll back or reconcile local state;
-   communicate failure appropriately.

Do not leave the UI permanently inconsistent with backend state.

Optimistic state should not make irreversible or security-sensitive
behavior appear confirmed before the backend has actually accepted it.

------------------------------------------------------------------------

## 28. Accessibility and Interaction

Use appropriate semantic controls and interaction targets.

Do not make essential actions dependent solely on color.

Preserve readable contrast according to the established Pump design.

Use appropriate keyboard/input types for forms.

Use semantic labels or tooltips when an icon-only control is not
self-explanatory.

Do not intentionally remove semantics from essential controls.

Support standard Flutter interaction behavior rather than implementing
visually clickable containers when an appropriate button/control exists.

------------------------------------------------------------------------

## 29. Text and Content Resilience

Design layouts so ordinary text variation does not break them.

Allow appropriate text wrapping.

Do not assume all labels, names, descriptions, or backend-provided
strings have a fixed short length.

Use truncation only when the design intentionally limits visible
content.

When truncating meaningful content, ensure the interaction still
provides enough information for the user to understand the item or
access the full value when required by the feature.

Avoid hard-coded line counts merely to make one mock/example fit.

------------------------------------------------------------------------

## 30. Conditional UI

Render sections and actions according to meaningful application state.

Do not show controls that cannot perform a valid action.

Examples may include:

``` text
No Training Block
→ hide Training Block-dependent sections

Training Block exists but has no exercises
→ show applicable Training Block information
→ show Add Exercises action
→ hide exercise-performance controls that have no meaningful data
```

Keep conditions based on explicit state/domain meaning rather than
incidental display values.

Do not infer authorization from UI visibility. Backend authorization
remains authoritative.

------------------------------------------------------------------------

## 31. UI State Preservation

Preserve user-entered or already valid UI state when a recoverable
secondary operation fails.

Examples include:

-   form values after submission failure;
-   existing list items after next-page failure;
-   loaded screen content after a localized refresh failure.

Do not reset an entire screen to its initial state unless the feature
flow actually requires it.

When navigation returns from a child screen, deliberately determine
whether existing UI state remains valid or requires refresh.

------------------------------------------------------------------------

## 32. Performance Awareness

Keep normal Flutter rendering efficient without premature optimization.

Avoid:

-   expensive transformations repeatedly inside `build()`;
-   unnecessary network calls caused by rebuilds;
-   rebuilding very large collections when a focused update is
    available;
-   non-lazy rendering of collections that may grow;
-   unnecessary image/media work in repeated builders.

Prefer correctness and clear ownership first.

Do not introduce complex caching, memoization, or performance
infrastructure without evidence that it is required.

------------------------------------------------------------------------

## 33. UI Testing Awareness

Design UI so meaningful behavior can be verified without depending on
brittle implementation details.

Prefer semantic, observable states such as:

``` text
loading
empty
error
content
submitting
disabled
```

over UI logic that can only be inferred from internal widget structure.

Do not add test-only production behavior merely to satisfy a brittle
test.

Testing requirements are defined by `testing-conventions.md`.

------------------------------------------------------------------------

## 34. UI Scope Control

Do not redesign unrelated UI while implementing a feature.

When modifying a screen:

-   preserve existing visual language;
-   change only what the requirement needs;
-   reuse existing components;
-   keep directly affected UI consistent;
-   identify larger redesign opportunities separately.

Do not change unrelated:

-   colors;
-   typography;
-   spacing;
-   component styles;
-   navigation behavior;
-   screen structure;

merely because another design might be preferred.

Feature development is not permission for an unsolicited application
redesign.

------------------------------------------------------------------------

## 35. UI Verification Checklist

Before completing a meaningful UI change, verify that:

-   nearby Pump screens and existing components were inspected;
-   `CustomScaffold`, `CustomTextField`, `CustomButton`, and other
    shared components were reused when appropriate;
-   no duplicate component or parallel design system was introduced
    unnecessarily;
-   colors and typography follow existing Pump patterns;
-   spacing and surfaces are consistent with nearby UI;
-   forms communicate validation and submitting state correctly;
-   primary and destructive actions are clear;
-   loading state matches the scope of the operation;
-   valid empty state is distinct from failure;
-   existing content is preserved during recoverable secondary failures
    where appropriate;
-   navigation behavior matches the intended feature flow;
-   lists use appropriate lazy/paginated behavior;
-   layout does not depend unnecessarily on one device size;
-   safe areas, keyboard behavior, and scrolling were considered where
    relevant;
-   essential actions are not communicated solely through color;
-   conditional sections reflect meaningful application state;
-   no sensitive or technical backend information is exposed;
-   no unrelated UI was redesigned.

Architecture and state ownership are governed by
`architecture-conventions.md`.

Coding structure and implementation style are governed by
`coding-conventions.md`.

Testing and command-level verification are governed by
`testing-conventions.md`.
