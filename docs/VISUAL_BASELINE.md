# AI Town Visual Baseline

## Art Direction

AI Town should use the original AI Town screenshots and character images as the long-term visual reference. The target is a polished 2D pixel/hand-painted hybrid local-work town: warm, magical, readable, and comfortable for long sessions.

Do not drift toward a generic SaaS dashboard, dark admin panel, rough pixel prototype, or mismatched asset collage.

## Core Mood

- warm storybook town
- light fantasy academy
- parchment UI surfaces
- soft brown linework
- bright but gentle colors
- chibi/Q-style characters
- magic-tech work tools
- low-stress, cozy, readable work environment

## Map Structure

The main map should keep a center-plaza composition:

- central fountain or crystal hub
- stone paths radiating outward
- task board and portal/teleport marker
- NPC/agent gathering points
- surrounding functional buildings
- trees, flowers, clouds, butterflies, small decorative life
- clear wooden/magical signage for each building

Functional buildings should be visually identifiable from outside:

- Memory Library / Memory Palace: archive cabinets, memory orbs, timeline/star-map motifs.
- Knowledge Tower: huge books, glowing shelves, crystal tower, floating cards.
- Code Workshop: gears, blue screens, tool bench, code scrolls, test anvil.
- Research Hall: glass domes, experiment instruments, whiteboard, paper scrolls, data screens.
- Agent Hub / Guild: adventurer-guild board plus AI badges, model icons, dispatch desk.
- GitHub Harbor: dock, branch routes, commit crates, release ships.
- Terminal Control Room: glowing console, log screens, command table.
- Resource Market: stalls, crates, file scrolls, asset shops.

## UI Rules

- Use parchment, carved wood, soft panels, and magic-tech accents.
- Prefer framed panels, signs, tabs, badges, icons, and readable labels over default controls.
- Avoid black/gray office dashboards and raw default button styling as the final state.
- UI must remain usable for real work: readable text, scrollable long outputs, clear status, and explicit safety labels.
- Every room console should look like an in-world object: desk, board, book, terminal, archive, or workbench.

## Character Rules

- Q-style proportions.
- Soft expressions.
- Clear silhouettes.
- Role-specific costume details.
- Agent NPCs should visually imply their function: architect, builder, reviewer, coordinator, researcher, runner, bulk worker.
- Real agents and functional NPCs can share the visual language, but their UI should clearly distinguish "dialogue", "draft", "queued", "running", "complete", and "failed".

## Current Gap

The current Godot slice reuses existing generated assets and procedural panels. It is playable and now has a warmer registry-driven room-stage pass, but it is not yet the final visual quality target. Future slices should replace or augment procedural room blocks with dedicated interior scene assets and generated/curated UI frames matching this baseline.

## Implemented First Pass

The first coded visual pass now includes:

- parchment-style panel theme
- warm wood/gold button states
- brown ink text colors
- warm input styling
- central plaza/fountain/quest-board/portal/agent-gate cues
- building sign trim
- softer parchment/magic-tech room stage palette
- layered parchment room floors with soft accent panels
- stone path tiles and ambient room plaques
- wooden/NPC anchors so room characters read as in-world guides
- keyword-colored prop blocks for lamps, gears, scrolls, shelves, and curation objects
- distinct hover/pressed hotspot states for room stations
- registry-driven all-room visual capture through `tools/capture-room-visuals.ps1`
- `screenshots/room-scenes-manifest.json` as the current audit index for all thirty-five room screenshots
- `GET /api/testing-arena/visual-manifest` validates the manifest, screenshot files, byte sizes, and SHA-256 hashes before release evidence can pass smoke

This is still an intermediate implementation. The final target requires dedicated hand-painted/pixel-hybrid map and interior assets rather than procedural rectangles.
