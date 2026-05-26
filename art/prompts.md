# Pixel AI Town — Art Style Guide

## 统一风格前缀（所有 prompt 必须包含）

```
pixel art, 32x32 game sprite, top-down RPG style, warm pastel color palette,
cozy cute aesthetic, clean pixel edges, gentle shading, game asset,
transparent background, no anti-aliasing, crisp pixels
```

## Agent Sprites (32×32, 需要 idle 2帧 + walk 2帧 = 4帧横排 128×32)

| Agent | Prompt 描述 |
|-------|------------|
| Opus | wise owl character wearing purple robe with golden trim, small crown on head, calm expression |
| PixelCat | playful orange pixel cat with tiny blue scarf, alert ears, curious eyes |
| Codex | round robot with blue-purple gradient body, glowing terminal screen face showing cursor |
| Sonnet | gentle deer character with cream and soft brown colors, holding a small notebook |
| Haiku | tiny hummingbird character, iridescent teal-green feathers, fast and energetic pose |
| DeepSeek/鲸鱼 | small friendly blue whale character with a tiny backpack, gentle smile |
| OpenHands | raccoon character with tool belt, brown and grey fur, determined expression |
| ARIS | crystal golem character, translucent purple geometric body, glowing core |
| Player/主角 | cute anime girl with long flowing hair, pastel pink and lavender colors, fantasy flower crown headpiece, gentle expression, soft features |

## Building Sprites (96×96 或 128×128)

| Building | Prompt 描述 |
|----------|------------|
| Town Hall | cozy stone town hall building, warm beige walls, red tile roof, small flag on top, arched entrance |
| Memory Library | magical library building, blue crystal dome roof, floating glowing books around it, mystical aura |
| Skill Workshop | wooden workshop building, tools hanging on walls, warm orange lantern light, chimney with smoke |
| Dream Garden | enchanted garden pavilion, glowing pastel flowers, soft yellow-green grass, fairy lights |
| Devtools Lab | modern lab building, multiple small screens visible through windows, grey and blue metal exterior |
| Resource Market | open market stall building, colorful fabric awnings in green and gold, crates and barrels |
| Knowledge Tower | tall crystal tower, blue and white gradient, tiny stars orbiting the top, magical glow |
| Agent Homes | row of tiny cute houses, each a different pastel color (pink, blue, green, yellow), tiny chimneys |
| Central Plaza | stone fountain centerpiece, cobblestone ground, flower beds around edges, warm lighting |

## Tileset (512×512 → 切成 16×16 = 32 tiles)

需要的 tile 类型：
- 草地 (3 variants: plain, flowers, tall grass)
- 路面 (2 variants: cobblestone, dirt path)
- 水面 (2 variants: still, ripple)
- 花丛 (3 variants: pink, yellow, blue)
- 树木 (2 variants: round tree, pine tree)
- 栅栏 (2 variants: wooden, stone wall)
- 桥 (1: wooden bridge)
- 装饰 (3: bench, lamppost, signpost)

Tileset prompt:
```
pixel art tileset sheet, 16x16 tiles arranged in grid, top-down RPG style,
warm pastel colors, includes grass, cobblestone path, water, flowers, trees,
fences, bridge, bench, lamppost, cozy fantasy town aesthetic
```

## UI Elements

- 面板边框: pixel art UI frame, rounded corners, soft blue-grey with pink accent
- 按钮: pixel art button, pastel gradient, subtle shadow
- 图标: 各种状态图标 (thinking, working, resting, chatting) 16×16

## 色彩规范

- 主色调: 暖色 pastel (粉 #FFB7B2, 淡紫 #DCD6F7, 淡蓝 #A8D8EA, 奶油 #FFEAA7, 薄荷 #A8E6CF)
- 背景: 深蓝绿 #1A1A2E (UI), 草绿 #4A7C3F (地图)
- 强调色: 珊瑚红 #E94560
- 文字: 暖白 #F8E8D4

## 生成规则

1. 所有图片必须通过 gptimage2 生成
2. 调用方式: POST http://127.0.0.1:9800/generate-image 或 media-gen MCP
3. 尺寸: 1024×1024 (生成后裁切缩放)
4. 质量: high
5. 生成后用 process.py 裁切到目标尺寸
