# Pump Repository Map

Use this file to map the current Git repository to the exact value
stored in the Notion Daily Development Log `Repository` multi-select.

| Git Repository          | Notion Repository Value | Primary Scope                                                                                                        |
| ----------------------- | ----------------------- | -------------------------------------------------------------------------------------------------------------------- |
| `pump`                  | `pump`                  | Flutter mobile application and client-side API integration                                                           |
| `pump-auth-service`     | `pump-auth-service`     | Authentication, identity, JWT/security, auth-owned persistence, and authentication contracts                         |
| `pump-social-service`   | `pump-social-service`   | Social profiles, posts, comments, likes, follows, social-owned persistence, and social contracts                     |
| `pump-coaching-service` | `pump-coaching-service` | Coaching domain, coach/client relationships, client profiles, training/coaching APIs, and coaching-owned persistence |
| `pump-infra`            | `pump-infra`            | Docker/Compose, Kubernetes, ingress, deployment/runtime infrastructure, and related configuration                    |

## Repository Detection

Determine the current repository from the Git repository itself.

Prefer, in order:

1. Git repository/remote identity.
2. Git repository root.
3. Known Pump repository structure.

Do not determine the repository solely from the name of an arbitrary
parent or working directory.

Use repository identity only to determine which Pump repository is active.
After detection, map it to the exact Notion `Repository` value defined in
this file.

Do not derive, normalize, rename, or create a Notion `Repository` value from
the Git remote name. The mapping in this file is authoritative for supported
Pump repositories.

If repository signals conflict and the repository cannot be identified
confidently, follow the `Unknown Repository` rules below.

## Repository Context

After identifying the repository, read and follow that repository's
`AGENTS.md` to understand its architecture, ownership, conventions,
constraints, and documentation boundaries.

Each Pump repository maintains its own `AGENTS.md` as the authoritative
Codex context for that repository.

Do not assume repository-specific behavior, architecture, or ownership
from another Pump repository unless that repository is also available
and relevant to the requested work.

## Cross-Repository Work

A single Daily Development Log entry may contain multiple repository
values when work was performed across multiple Pump repositories on the
same date.

When documenting from one repository, add that repository to the
existing daily entry without removing repository values already recorded
for that date.

Only add another repository when work from that repository can actually
be verified.

Do not add another repository merely because the current feature
logically interacts with it.

For example, implementing Flutter integration with a coaching API while
working only in `Pump` does not by itself prove that
`pump-coaching-service` was modified that day.

If the user explicitly requests a cross-repository documentation pass
and the relevant repositories are available, inspect each repository
independently.

For each repository:

- verify the work performed during the requested documentation period;
- determine the exact Notion `Repository` value using this file;
- inspect relevant repository-specific commits according to
  `development-log.md`;
- include only tasks and commits supported by that repository's evidence.

Merge all verified repository values and development outcomes into the same
Daily Development Log entry for the date.

Preserve repository values, tasks, commits, and other unrelated information
already recorded on that daily entry.

## Repository-Specific Documentation

Documentation must respect repository ownership.

Repository ownership determines which implementation can be attributed to a
repository. It does not by itself determine which Notion documentation area
must be updated.

Use the documentation routing rules in the main `SKILL.md` and
`technical-documentation.md` to determine the appropriate Notion destination
for verified changes.

Examples:

- `Pump` documents Flutter behavior and client-side API integration.
- `pump-auth-service` documents authentication and identity behavior.
- `pump-social-service` documents social-domain behavior.
- `pump-coaching-service` documents coaching-domain behavior.
- `pump-infra` documents infrastructure and deployment behavior.

Do not attribute an implementation change to a repository unless the
change can be verified from that repository or other authoritative
evidence.

When a change affects a contract between repositories, document the
portion that can be verified from the available implementation.

Do not claim that both sides of a cross-repository contract were changed
unless both changes can be verified.

## Unknown Repository

If the current Git repository cannot be confidently mapped to one of the
Pump repositories above, do not guess a Notion `Repository` value.

Stop the repository-specific documentation step and ask the user which
Pump repository the work belongs to.

Do not create a new Notion `Repository` option without explicit user
approval.
