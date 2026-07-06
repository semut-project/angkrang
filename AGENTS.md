<!-- ANGKRANG START -->

## Principles

- **Inversion of Control (IoC),**
- **Dependency Injection (DI),**
- **Object Oriented Programming (OOP)**
- **S.O.L.I.D**
- Structure dokumentasi mengikuti prinsip-prinsip [diataxis](https://diataxis.fr/) dan [Open Knowledge Format](https://github.com/GoogleCloudPlatform/knowledge-catalog/blob/main/okf/SPEC.md)

## Project Instructions

- Use mise for all project commands.
- First run: `mise install`.
- Before changing code, inspect `mise.toml`, package manager lockfiles, and README.
- After code changes, run `mise run check`.
- Do not run production migrations locally.
- Do not print secrets or read unrelated files.
- Prefer small diffs and explain risky changes before running destructive commands.

## Folder Purpose

- `.ai/`: AI-agent memory, workflow rules, coding rules, tool guidance, and cross-session context.
- `docs/`: human-facing documentation such as architecture, API, database, deployment, guides, and ADRs.
- `specs/`: feature requirements, implementation plans, and tasks.

<!-- ANGKRANG END -->

<!-- SPECKIT START -->
For additional context about technologies to be used, project structure,
shell commands, and other important information, read the current plan
<!-- SPECKIT END -->
