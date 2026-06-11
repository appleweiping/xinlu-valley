# Security Policy

AI Town connects a game UI to real local files, development tools, agents, model APIs, and terminal workflows. Security issues matter even while the project is still in local-first rebuild mode.

## Supported Versions

The active supported implementation is the Godot client under `godot/` plus the FastAPI backend under `backend/`.

The legacy React/Phaser frontend remains as reference material and is not the security baseline for new work.

## Reporting a Vulnerability

For now, create a private report through the project maintainer's normal channel before publishing details publicly. Include:

- A short description of the issue.
- Steps to reproduce on a local checkout.
- Which file paths, commands, API endpoints, or agent/tool flows are affected.
- Whether secrets, user files, Git state, terminal execution, or external services are involved.
- Any logs or screenshots with secrets redacted.

## Security Boundaries

Current safe design rules:

- Reads should be allowlisted, bounded, lazy, and preview-limited.
- Writes should stay under `workspace\` unless a future explicit gate allows more.
- Raw shell execution is not exposed; Terminal Control uses command IDs from an allowlist.
- Dangerous actions such as delete, overwrite, install, commit, tag, push, release, PR creation, service shutdown, and long experiments are blocked or future confirm-required.
- Raw API keys are never returned by the backend.

## Sensitive Data

Do not commit:

- API keys, tokens, passwords, session cookies, private endpoints, or proxy credentials.
- Full local filesystem dumps.
- Private research datasets, unpublished manuscripts, or company files.
- Logs that include secrets, personal data, or proprietary material.

## Known Limitations

This is not yet a hardened multi-user app. Treat it as a local desktop tool for a trusted user. Network exposure, shared-machine access, remote agent execution, and public plugin installation need additional review before they become supported.
