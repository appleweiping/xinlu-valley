# Desktop UI Testing With Windows-MCP

This project is configured for local Windows desktop UI testing of the Godot client.

## What Was Installed

- `windows-mcp` 0.8.1 was installed into:
  `D:\devtools\codex\home\mcp-servers\windows-mcp\.venv-py314`
- Codex direct MCP configuration was added in:
  `D:\devtools\codex\home\config.toml`
- A plugin marketplace wrapper was not needed. `codex mcp list --json` reads the direct `[mcp_servers.windows_mcp]` entry.
- No Windows scheduled task was installed.
- No credentials or tokens are stored in the config.

Windows-MCP currently requires Python 3.13+, so the local venv uses the machine's Python 3.14 while keeping the installed package under `D:\devtools`.

## Safety Boundary

The Codex MCP entry starts Windows-MCP with this allowlist only:

`Screenshot, Snapshot, Click, Move, Type, Shortcut, Wait, App`

The higher-risk Windows-MCP tools such as PowerShell, filesystem, registry, process-management, and clipboard tools are not enabled.

The project test workflow:

- launches only this Godot project,
- focuses only the Agent Town Godot window,
- refuses scripted click coordinates outside that window,
- writes screenshots and a small state marker under `screenshots/`,
- does not access browser sessions, email, private files, or unrelated apps.

## Run The Desktop Test

From the repository root:

```powershell
powershell -ExecutionPolicy Bypass -File tools\godot-desktop-ui-test.ps1
```

The test does this:

1. Launches `tools\godot\Godot_v4.6.3-stable_win64.exe --path godot` with `AGENT_TOWN_DESKTOP_TEST=1`.
2. Focuses and positions the Godot window.
3. Captures `screenshots\desktop-ui-before.png`.
4. Uses Windows-MCP `Click` to double-click the visible in-game `Click` test button.
5. Waits for `screenshots\desktop-ui-state.json` to report `desktop_click_received`.
6. Captures `screenshots\desktop-ui-after.png`.
7. Compares before/after screenshots and fails if the visual change is too small.

Optional full-screen MCP screenshot mode:

```powershell
powershell -ExecutionPolicy Bypass -File tools\godot-desktop-ui-test.ps1 -UseWindowsMcpScreenshots
```

That mode uses Windows-MCP `Screenshot` for the PNGs. It is slower on this desktop, so the default path uses fast window capture for screenshots and Windows-MCP for input.

## Agent Use

After restarting or refreshing Codex, the `windows_mcp` server exposes desktop tools to the agent. Keep interactions scoped to the Godot/editor window unless the user explicitly approves broader desktop control.

Recommended order for an agent-driven check:

1. Launch this project with `tools\godot-desktop-ui-test.ps1` or `start-godot.cmd`.
2. Use Windows-MCP `App` or a project-local launch script to focus Agent Town Godot.
3. Use Windows-MCP `Screenshot` or `Snapshot` to inspect the window.
4. Use Windows-MCP `Click`, `Type`, or `Shortcut` only inside the Godot window.
5. Take another screenshot and verify the expected visual/state change.

## Disable Or Remove

To disable without uninstalling, edit `D:\devtools\codex\home\config.toml` and set:

```toml
[mcp_servers.windows_mcp]
enabled = false
```

Then restart or refresh Codex.

To remove completely:

1. Delete or comment out the `[mcp_servers.windows_mcp]` and `[mcp_servers.windows_mcp.env]` sections in `D:\devtools\codex\home\config.toml`.
2. Delete `D:\devtools\codex\home\mcp-servers\windows-mcp`.
3. Restart Codex.

If someone later installs Windows-MCP as a scheduled task, remove that task with:

```powershell
D:\devtools\codex\home\mcp-servers\windows-mcp\.venv-py314\Scripts\windows-mcp.exe uninstall
```
