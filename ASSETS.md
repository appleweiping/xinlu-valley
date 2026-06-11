# Agent Town Asset Manifest

Updated: 2026-05-29

## Reused Assets Copied Into Godot

| Path | Source | Type | Notes |
| --- | --- | --- | --- |
| `godot/assets/town/town-map.png` | `frontend/public/assets/town-map.png` | town map | Existing generated town background. |
| `godot/assets/characters/player-sheet.png` | `frontend/public/assets/characters/player-sheet.png` | player sprite sheet | Used for first movement slice. |
| `godot/assets/characters/*-sheet.png` | `frontend/public/assets/characters/*-sheet.png` | agent sprite sheets | Opus, PixelCat, Codex, Sonnet, Haiku, DeepSeek, ARIS. |
| `godot/assets/ui/dialogue-frame.png` | `frontend/public/assets/ui/dialogue-frame.png` | UI art | Reserved for dialogue panel styling. |

## Asset Direction

Current copied assets are transitional. The target art direction must converge on one consistent style and should avoid mixing pixel-art and painterly storybook assets in final production scenes.

## Gameplay Asset Needs

- Dedicated room backgrounds for each building.
- Quest/reward icons for local work progression.
- Consistent UI panels for quest log, agent dialogue, file browser, and workbench actions.
- A distinct icon/state for preview-only actions versus confirmed project-local writes.
