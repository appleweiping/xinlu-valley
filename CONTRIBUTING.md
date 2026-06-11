# Contributing to AI Town

AI Town is a Godot-first, local-first game shell for real work: files, research, coding, agents, memory, model profiles, terminal jobs, and release workflows. Contributions should improve the game and the safety model together.

## Current Direction

- Godot owns rendering, interaction, UI, local save state, and room presentation.
- FastAPI owns filesystem adapters, model/agent integration, background jobs, permission gates, and logs.
- Runtime data should come from registries and bounded local adapters, not hard-coded UI-only mocks.
- Slow or risky work belongs behind backend jobs, queues, and explicit confirmation gates.

## Local Setup

1. Use the repository on the D drive.
2. Start the local bridge and Godot client with `start.cmd`.
3. Run the smoke suite before submitting changes:

```powershell
powershell -ExecutionPolicy Bypass -File tools\verify-smoke.ps1
powershell -ExecutionPolicy Bypass -File tools\capture-visual-smoke.ps1
```

## Safety Rules

- Do not delete, overwrite, move, or mutate user files outside project-local `workspace\` flows unless a future confirm-required workflow explicitly permits it.
- Do not stop services, terminals, experiments, API proxies, or unrelated processes.
- Do not expose raw API keys or secrets in UI, logs, docs, or test output.
- Keep file scans bounded, allowlisted, paginated, cached, or lazy-loaded.
- Keep GitHub writes, tags, releases, PR creation, installs, destructive file operations, and long-running experiments behind explicit future gates.

## Development Guidelines

- Prefer small, verifiable slices that add one real workflow end to end.
- Update `PLAN.md`, `STRUCTURE.md`, `MEMORY.md`, and relevant docs when adding a workflow.
- Keep Godot responsive; move slow work to the backend job system.
- Add registries/config for new buildings, agents, model profiles, and workspaces.
- Use the warm storybook/magic-tech visual baseline in `docs\VISUAL_BASELINE.md`.

## Pull Request Checklist

- The change maps to a real local workflow or improves the game shell.
- The backend and Godot client degrade honestly when a source is unavailable.
- Smoke checks pass.
- New write paths are project-local or confirm-required.
- Docs and memory are updated.
- No unrelated user changes were reverted.
