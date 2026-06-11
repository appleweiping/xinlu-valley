"""Hand-authored pixel sprites for every resident — each agent gets its own
species instead of a palette-swapped clone.

Sheets are emitted in the engine's standard layout: 4x4 grid of 48px cells,
rows = down / up / left / right, 4 frames per row (frames 1&3 are walk poses,
0&2 the rest pose — matching the existing Phaser anims).

Matrix DSL: one string per row, one char per pixel. '.' = transparent,
'#' = outline. Other chars index into the sprite's palette. Side matrices
face LEFT (mirrored for right).
"""
from __future__ import annotations

from PIL import Image

OUTLINE = (61, 43, 31, 255)

CELL = 48


def _rgba(rgb):
    return (*rgb, 255)


# --------------------------------------------------------------------------
# sprite definitions
# --------------------------------------------------------------------------

SPRITES: dict[str, dict] = {}

# ---- player: girl with long ink hair, dusty-blue beret (GitHub avatar) ----
SPRITES["player"] = {
    "pal": {
        "K": _rgba((46, 40, 56)),    # hair
        "k": _rgba((78, 70, 96)),    # hair shine
        "B": _rgba((96, 116, 170)),  # beret
        "b": _rgba((126, 146, 196)), # beret light
        "S": _rgba((244, 219, 189)), # skin
        "W": _rgba((247, 240, 226)), # blouse
        "N": _rgba((70, 90, 134)),   # sailor collar
        "R": _rgba((216, 108, 124)), # bow
        "L": _rgba((90, 78, 88)),    # legs/shoes
        "E": _rgba((52, 44, 60)),    # eyes
    },
    "front": [
        "....#bbbbb#.....",
        "...#BBBBBBB#....",
        "..#BBBBBBBBB#...",
        ".#KkKKKKKKkK#...",
        ".#KKSSSSSSKK#...",
        ".#KSSESSESSK#...",
        ".#KSSSSSSSSK#...",
        ".#KKSSSSSSKK#...",
        ".#K#NNWWNN#K#...",
        ".#K#WWRRWW#K#...",
        ".#K.#WWWW#.K#...",
        ".#K.#NNNN#.K#...",
        "..#.#NNNN#.#....",
        "....#SSSS#......",
        "....#L##L#......",
        "....#L#.#L#.....",
    ],
    "front2": [
        "....#bbbbb#.....",
        "...#BBBBBBB#....",
        "..#BBBBBBBBB#...",
        ".#KkKKKKKKkK#...",
        ".#KKSSSSSSKK#...",
        ".#KSSESSESSK#...",
        ".#KSSSSSSSSK#...",
        ".#KKSSSSSSKK#...",
        ".#K#NNWWNN#K#...",
        ".#K#WWRRWW#K#...",
        ".#K.#WWWW#.K#...",
        ".#K.#NNNN#.K#...",
        "..#.#NNNN#.#....",
        "...#SS##SS#.....",
        "...#L#..#L#.....",
        "...#L#...#L#....",
    ],
    "back": [
        "....#bbbbb#.....",
        "...#BBBBBBB#....",
        "..#BBBBBBBBB#...",
        ".#KkKKKKKKkK#...",
        ".#KKKKKKKKKK#...",
        ".#KKKKKKKKKK#...",
        ".#KKKKKKKKKK#...",
        ".#KKKKKKKKKK#...",
        ".#K#KKKKKK#K#...",
        ".#K#WWWWWW#K#...",
        ".#K.#WWWW#.K#...",
        ".#K.#NNNN#.K#...",
        "..#.#NNNN#.#....",
        "....#SSSS#......",
        "....#L##L#......",
        "....#L#.#L#.....",
    ],
    "side": [
        "....#bbbb#......",
        "...#BBBBBB#.....",
        "..#BBBBBBB#.....",
        "..#KKKKKKKK#....",
        "..#KSSSSSKK#....",
        "..#KSESSSKK#....",
        "..#KSSSSSKK#....",
        "..#KKSSSKKK#....",
        "..#K#NWWN#K#....",
        "..#K#WWWW#K#....",
        "..#K#WWWW#K#....",
        "..##.#NNN#K#....",
        "....#NNNN##.....",
        ".....#SSS#......",
        ".....#LL#.......",
        ".....#L#L#......",
    ],
    "side2": [
        "....#bbbb#......",
        "...#BBBBBB#.....",
        "..#BBBBBBB#.....",
        "..#KKKKKKKK#....",
        "..#KSSSSSKK#....",
        "..#KSESSSKK#....",
        "..#KSSSSSKK#....",
        "..#KKSSSKKK#....",
        "..#K#NWWN#K#....",
        "..#K#WWWW#K#....",
        "..#K#WWWW#K#....",
        "..##.#NNN#K#....",
        "....#NNNN##.....",
        "....#SS#SS#.....",
        "....#L#.#L#.....",
        "...#L#...#L#....",
    ],
}

# ---- opus: indigo-robed sage with white beard ------------------------------
SPRITES["opus"] = {
    "pal": {
        "I": _rgba((96, 86, 186)),   # robe
        "i": _rgba((124, 114, 214)), # robe light
        "S": _rgba((244, 219, 189)),
        "W": _rgba((240, 236, 228)), # beard
        "E": _rgba((52, 44, 60)),
        "G": _rgba((226, 178, 92)),  # trim
    },
    "front": [
        "....#iiii#......",
        "...#iIIIIi#.....",
        "..#iIIIIIIi#....",
        "..#IIIIIIII#....",
        "..#ISSSSSSI#....",
        "..#ISESSESI#....",
        "..#ISSSSSSI#....",
        "..#IWWWWWWI#....",
        "..#WWWWWWWW#....",
        "..#IWWWWWWI#....",
        "..#IIGIIGIII#...",
        "..#IIIIIIII#....",
        "..#IIIIIIII#....",
        "..#IIIIIIII#....",
        "..#II#..#II#....",
        "...##....##.....",
    ],
    "front2": [
        "....#iiii#......",
        "...#iIIIIi#.....",
        "..#iIIIIIIi#....",
        "..#IIIIIIII#....",
        "..#ISSSSSSI#....",
        "..#ISESSESI#....",
        "..#ISSSSSSI#....",
        "..#IWWWWWWI#....",
        "..#WWWWWWWW#....",
        "..#IWWWWWWI#....",
        "..#IIGIIGIII#...",
        "..#IIIIIIII#....",
        "..#IIIIIIII#....",
        ".#IIIIIIIIII#...",
        ".#II#....#II#...",
        "..##......##....",
    ],
    "back": [
        "....#iiii#......",
        "...#iIIIIi#.....",
        "..#iIIIIIIi#....",
        "..#IIIIIIII#....",
        "..#IIIIIIII#....",
        "..#IIIIIIII#....",
        "..#IIIIIIII#....",
        "..#IIIIIIII#....",
        "..#IIIIIIII#....",
        "..#IIIIIIII#....",
        "..#IIGIIGII#....",
        "..#IIIIIIII#....",
        "..#IIIIIIII#....",
        "..#IIIIIIII#....",
        "..#II#..#II#....",
        "...##....##.....",
    ],
    "side": [
        "....#iiii#......",
        "...#iIIIi#......",
        "..#iIIIII#......",
        "..#IIIIIII#.....",
        "..#ISSSSI#......",
        "..#ISESSI#......",
        "..#ISSSI#.......",
        "..#IWWWW#.......",
        "..#WWWWW#.......",
        "..#IWWWI#.......",
        "..#IIGII#.......",
        "..#IIIII#.......",
        "..#IIIII#.......",
        "..#IIIII#.......",
        "..#II#II#.......",
        "...##.##........",
    ],
    "side2": [
        "....#iiii#......",
        "...#iIIIi#......",
        "..#iIIIII#......",
        "..#IIIIIII#.....",
        "..#ISSSSI#......",
        "..#ISESSI#......",
        "..#ISSSI#.......",
        "..#IWWWW#.......",
        "..#WWWWW#.......",
        "..#IWWWI#.......",
        "..#IIGII#.......",
        "..#IIIII#.......",
        "..#IIIIII#......",
        ".#IIIIIII#......",
        ".#I#IIII#.......",
        "..#.##.##.......",
    ],
}

# ---- fable: fox storyteller (that's me) ------------------------------------
SPRITES["fable"] = {
    "pal": {
        "F": _rgba((226, 112, 62)),  # fox red
        "f": _rgba((246, 150, 96)),  # light fur
        "C": _rgba((250, 240, 226)), # cream chest / tail tip
        "E": _rgba((52, 44, 60)),
        "N": _rgba((44, 34, 40)),    # nose / ear tips
    },
    "front": [
        "................",
        "..#N#....#N#....",
        ".#FF#....#FF#...",
        ".#FFF####FFF#...",
        ".#FFFFFFFFFF#...",
        ".#FFFFFFFFFF#...",
        ".#FEFFFFFFEF#...",
        ".#FFFCCCCFFF#...",
        ".#FFCCNCCCFF#...",
        "..#FFCCCCFF#....",
        "..#FFFFFFFF#....",
        ".#FFCCCCCCFF#...",
        ".#FFCCCCCCFF#...",
        "..#FFFFFFFF#....",
        "..#FF#..#FF#....",
        "...##....##.....",
    ],
    "front2": [
        "................",
        "..#N#....#N#....",
        ".#FF#....#FF#...",
        ".#FFF####FFF#...",
        ".#FFFFFFFFFF#...",
        ".#FFFFFFFFFF#...",
        ".#FEFFFFFFEF#...",
        ".#FFFCCCCFFF#...",
        ".#FFCCNCCCFF#...",
        "..#FFCCCCFF#....",
        "..#FFFFFFFF#....",
        ".#FFCCCCCCFF#...",
        ".#FFCCCCCCFF#...",
        ".#FFFFFFFFFF#...",
        ".#F#FF..FF#F#...",
        "..#..##.##..#...",
    ],
    "side": [
        "................",
        "...#N#..........",
        "..#FF#N#........",
        "..#FFFF#........",
        ".#FFFFFF#.......",
        ".#FEFFFF#.......",
        ".#FFFFCC#.......",
        ".#FFCNCC#.......",
        "..#FFFF#...##...",
        "..#FFFFF##FCC#..",
        ".#FFFFFFFFFCC#..",
        ".#FFFFFFFFFF#...",
        ".#FFFFFFFFF#....",
        "..#FFFFFFF#.....",
        "..#FF#.#FF#.....",
        "...##...##......",
    ],
    "side2": [
        "................",
        "...#N#..........",
        "..#FF#N#........",
        "..#FFFF#........",
        ".#FFFFFF#.......",
        ".#FEFFFF#.......",
        ".#FFFFCC#.......",
        ".#FFCNCC#.......",
        "..#FFFF#..##....",
        "..#FFFFF#FCC#...",
        ".#FFFFFFFFCC#...",
        ".#FFFFFFFFF#....",
        ".#FFFFFFFFFF#...",
        "..#FFFFFFFF#....",
        ".#FF#....#FF#...",
        "..##......##....",
    ],
}

# ---- codex: round little robot ---------------------------------------------
SPRITES["codex"] = {
    "pal": {
        "W": _rgba((234, 238, 240)), # shell
        "w": _rgba((204, 212, 218)), # shell shade
        "T": _rgba((64, 182, 172)),  # teal accents
        "V": _rgba((46, 54, 66)),    # visor
        "E": _rgba((142, 240, 226)), # visor eyes
    },
    "front": [
        ".......#T#......",
        ".......#T#......",
        "......##W##.....",
        "....#WWWWWWW#...",
        "...#WWWWWWWWW#..",
        "...#W#VVVVV#W#..",
        "...#W#VEVEV#W#..",
        "...#W#VVVVV#W#..",
        "...#WWWWWWWWW#..",
        "...#WTTWWWTTW#..",
        "...#WWWWWWWWW#..",
        "....#wWWWWWw#...",
        ".....#wwwww#....",
        "....#T#...#T#...",
        "....#T#...#T#...",
        ".....#.....#....",
    ],
    "front2": [
        ".......#T#......",
        ".......#T#......",
        "......##W##.....",
        "....#WWWWWWW#...",
        "...#WWWWWWWWW#..",
        "...#W#VVVVV#W#..",
        "...#W#VEVEV#W#..",
        "...#W#VVVVV#W#..",
        "...#WWWWWWWWW#..",
        "...#WTTWWWTTW#..",
        "...#WWWWWWWWW#..",
        "....#wWWWWWw#...",
        ".....#wwwww#....",
        "...#T#.....#T#..",
        "...#T#.....#T#..",
        "....#.......#...",
    ],
    "side": [
        ".......#T#......",
        ".......#T#......",
        "......##W##.....",
        "....#WWWWWW#....",
        "...#WWWWWWWW#...",
        "...#W#VVVV#W#...",
        "...#W#VEVV#W#...",
        "...#W#VVVV#W#...",
        "...#WWWWWWWW#...",
        "...#WTTWWWWW#...",
        "...#WWWWWWWW#...",
        "....#wWWWWw#....",
        ".....#wwww#.....",
        ".....#T##T#.....",
        ".....#T##T#.....",
        "......#..#......",
    ],
    "side2": [
        ".......#T#......",
        ".......#T#......",
        "......##W##.....",
        "....#WWWWWW#....",
        "...#WWWWWWWW#...",
        "...#W#VVVV#W#...",
        "...#W#VEVV#W#...",
        "...#W#VVVV#W#...",
        "...#WWWWWWWW#...",
        "...#WTTWWWWW#...",
        "...#WWWWWWWW#...",
        "....#wWWWWw#....",
        ".....#wwww#.....",
        "....#T#..#T#....",
        "....#T#..#T#....",
        ".....#....#.....",
    ],
}

# ---- sonnet: rose songbird --------------------------------------------------
SPRITES["sonnet"] = {
    "pal": {
        "R": _rgba((232, 122, 152)), # body
        "r": _rgba((202, 92, 124)),  # wing
        "C": _rgba((250, 232, 226)), # belly
        "Y": _rgba((240, 182, 84)),  # beak/feet
        "E": _rgba((52, 44, 60)),
    },
    "front": [
        "................",
        "................",
        "................",
        "......#RRR#.....",
        ".....#RRRRR#....",
        "....#RERRRER#...",
        "....#RRR#YY#....",
        "....#RRRR#Y#....",
        "...#rRCCCRr#....",
        "...#rRCCCCRr#...",
        "...#rRCCCCRr#...",
        "....#RCCCCR#....",
        ".....#RRRR#.....",
        "......#RR#......",
        ".....#Y##Y#.....",
        "......#..#......",
    ],
    "front2": [
        "................",
        "................",
        "................",
        "......#RRR#.....",
        ".....#RRRRR#....",
        "....#RERRRER#...",
        "....#RRR#YY#....",
        "....#RRRR#Y#....",
        "...#rRCCCRr#....",
        "..#rrRCCCCRrr#..",
        "..#rrRCCCCRrr#..",
        "....#RCCCCR#....",
        ".....#RRRR#.....",
        "......#RR#......",
        "....#Y#..#Y#....",
        ".....#....#.....",
    ],
    "side": [
        "................",
        "................",
        "................",
        ".....#RRR#......",
        "....#RRRRR#.....",
        "....#RERRR#.....",
        "...#YY#RRRR#....",
        "....##RRRRR#....",
        "....#RCCRRrr#...",
        "....#RCCCRrr#...",
        "....#RCCCRRr#...",
        ".....#RCCRR#....",
        "......#RRR#.....",
        ".......#R#......",
        "......#Y#Y#.....",
        ".......#.#......",
    ],
    "side2": [
        "................",
        "................",
        "................",
        ".....#RRR#......",
        "....#RRRRR#.....",
        "....#RERRR#.....",
        "...#YY#RRRR#....",
        "....##RRRRR#....",
        "....#RCCRRrr#...",
        "...#RCCCCRrrr#..",
        "....#RCCCRRr#...",
        ".....#RCCRR#....",
        "......#RRR#.....",
        ".......#R#......",
        ".....#Y#.#Y#....",
        "......#...#.....",
    ],
}

# ---- haiku: golden chick ----------------------------------------------------
SPRITES["haiku"] = {
    "pal": {
        "Y": _rgba((248, 212, 98)),  # body
        "y": _rgba((226, 178, 66)),  # wing shade
        "O": _rgba((240, 142, 62)),  # beak/feet
        "E": _rgba((52, 44, 60)),
        "W": _rgba((252, 242, 214)), # cheek light
    },
    "front": [
        "................",
        "................",
        "................",
        "................",
        "......#YYY#.....",
        ".....#YYYYY#....",
        "....#YEYYYEY#...",
        "....#YYY#OO#....",
        "....#YYYY##.....",
        "...#yYWWWYy#....",
        "...#yYWWWWYy#...",
        "....#YWWWWY#....",
        ".....#YYYY#.....",
        "......#YY#......",
        ".....#O##O#.....",
        "......#..#......",
    ],
    "front2": [
        "................",
        "................",
        "................",
        "................",
        "......#YYY#.....",
        ".....#YYYYY#....",
        "....#YEYYYEY#...",
        "....#YYY#OO#....",
        "....#YYYY##.....",
        "..#yyYWWWYyy#...",
        "..#yyYWWWWYyy#..",
        "....#YWWWWY#....",
        ".....#YYYY#.....",
        "......#YY#......",
        "....#O#..#O#....",
        ".....#....#.....",
    ],
    "side": [
        "................",
        "................",
        "................",
        "................",
        ".....#YYY#......",
        "....#YYYYY#.....",
        "....#YEYYY#.....",
        "...#OO#YYYY#....",
        "....##YYYYY#....",
        "....#YWWYyy#....",
        "....#YWWWYy#....",
        ".....#YWWYY#....",
        "......#YYY#.....",
        ".......#Y#......",
        "......#O#O#.....",
        ".......#.#......",
    ],
    "side2": [
        "................",
        "................",
        "................",
        "................",
        ".....#YYY#......",
        "....#YYYYY#.....",
        "....#YEYYY#.....",
        "...#OO#YYYY#....",
        "....##YYYYY#....",
        "....#YWWYyy#....",
        "....#YWWWYy#....",
        ".....#YWWYY#....",
        "......#YYY#.....",
        ".......#Y#......",
        ".....#O#.#O#....",
        "......#...#.....",
    ],
}

# ---- deepseek: round blue whale --------------------------------------------
SPRITES["deepseek"] = {
    "pal": {
        "B": _rgba((76, 134, 204)),  # body
        "b": _rgba((108, 164, 226)), # body light
        "C": _rgba((228, 242, 250)), # belly
        "E": _rgba((40, 48, 64)),
        "W": _rgba((182, 220, 248)), # spout
    },
    "front": [
        "......#W#W#.....",
        ".......#W#......",
        "................",
        "....##BBBB##....",
        "..##bBBBBBBb##..",
        ".#bBBBBBBBBBBb#.",
        ".#BBEBBBBBBEBB#.",
        ".#BBBBBBBBBBBB#.",
        ".#BBCCCCCCCCBB#.",
        ".#BBCCCCCCCCBB#.",
        "..#BCCCCCCCCB#..",
        "..#BBCCCCCCBB#..",
        "...##BBBBBB##...",
        ".....##BB##.....",
        "....#B#..#B#....",
        ".....#....#.....",
    ],
    "front2": [
        ".....#W#.#W#....",
        "......#W#W#.....",
        ".......#W#......",
        "....##BBBB##....",
        "..##bBBBBBBb##..",
        ".#bBBBBBBBBBBb#.",
        ".#BBEBBBBBBEBB#.",
        ".#BBBBBBBBBBBB#.",
        ".#BBCCCCCCCCBB#.",
        ".#BBCCCCCCCCBB#.",
        "..#BCCCCCCCCB#..",
        "..#BBCCCCCCBB#..",
        "...##BBBBBB##...",
        ".....##BB##.....",
        "...#B#....#B#...",
        "....#......#....",
    ],
    "side": [
        ".....#W#W#......",
        "......#W#.......",
        "................",
        "....##BBBB##....",
        "..##bBBBBBBB##..",
        ".#bBBBBBBBBBBB#.",
        ".#BEBBBBBBBBBB#.",
        ".#BBBBBBBBBB#B#.",
        ".#BCCCCCCBB#BB#.",
        ".#BCCCCCCBBB#B#.",
        "..#BCCCCBBBB#...",
        "..#BBBBBBBB#....",
        "...##BBBB##.....",
        ".....#BB#.......",
        "....#B##B#......",
        ".....#..#.......",
    ],
    "side2": [
        "....#W#.#W#.....",
        ".....#W#W#......",
        "......#W#.......",
        "....##BBBB##....",
        "..##bBBBBBBB##..",
        ".#bBBBBBBBBBBB#.",
        ".#BEBBBBBBBBBB#.",
        ".#BBBBBBBBBB#B#.",
        ".#BCCCCCCBB#BB#.",
        ".#BCCCCCCBBB#B#.",
        "..#BCCCCBBBB#...",
        "..#BBBBBBBB#....",
        "...##BBBB##.....",
        ".....#BB#.......",
        "...#B#..#B#.....",
        "....#....#......",
    ],
}

# ---- aris: scholar owl ------------------------------------------------------
SPRITES["aris"] = {
    "pal": {
        "N": _rgba((146, 122, 92)),  # body brown
        "n": _rgba((118, 96, 72)),   # wing shade
        "C": _rgba((234, 220, 192)), # face/belly
        "G": _rgba((84, 168, 128)),  # scarf green
        "Y": _rgba((240, 182, 84)),  # beak/feet
        "E": _rgba((52, 44, 60)),
        "W": _rgba((250, 248, 240)), # glasses rim
    },
    "front": [
        "................",
        "..#N#......#N#..",
        "..#NN######NN#..",
        ".#NNNNNNNNNNNN#.",
        ".#NCCWCNNCWCCN#.",
        ".#NCWEWCCWEWCN#.",
        ".#NCCWCYYCWCCN#.",
        ".#NNCCC#YCCCNN#.",
        ".#NGGGGGGGGGGN#.",
        ".#nNCCCCCCCCNn#.",
        ".#nNCCCCCCCCNn#.",
        ".#nNCCCCCCCCNn#.",
        "..#NNCCCCCCNN#..",
        "...##NNNNNN##...",
        "....#Y#..#Y#....",
        ".....#....#.....",
    ],
    "front2": [
        "................",
        "..#N#......#N#..",
        "..#NN######NN#..",
        ".#NNNNNNNNNNNN#.",
        ".#NCCWCNNCWCCN#.",
        ".#NCWEWCCWEWCN#.",
        ".#NCCWCYYCWCCN#.",
        ".#NNCCC#YCCCNN#.",
        ".#NGGGGGGGGGGN#.",
        "#nnNCCCCCCCCNnn#",
        "#nnNCCCCCCCCNnn#",
        ".#nNCCCCCCCCNn#.",
        "..#NNCCCCCCNN#..",
        "...##NNNNNN##...",
        "...#Y#....#Y#...",
        "....#......#....",
    ],
    "side": [
        "................",
        "...#N#..........",
        "...#NN#####.....",
        "..#NNNNNNNN#....",
        "..#NCWCNNNNN#...",
        "..#NWEWCNNNN#...",
        "..#NCWCYNNNN#...",
        "..#NNCC#NNNN#...",
        "..#NGGGGGNNN#...",
        "..#NCCCCnnnN#...",
        "..#NCCCCnnnN#...",
        "..#NCCCCnnN#....",
        "...#NCCCNN#.....",
        "....##NNN#......",
        ".....#Y#Y#......",
        "......#.#.......",
    ],
    "side2": [
        "................",
        "...#N#..........",
        "...#NN#####.....",
        "..#NNNNNNNN#....",
        "..#NCWCNNNNN#...",
        "..#NWEWCNNNN#...",
        "..#NCWCYNNNN#...",
        "..#NNCC#NNNN#...",
        "..#NGGGGGNNN#...",
        "..#NCCCCnnnN#...",
        "..#NCCCCnnnN#...",
        "..#NCCCCnnN#....",
        "...#NCCCNN#.....",
        "....##NNN#......",
        "....#Y#.#Y#.....",
        ".....#...#......",
    ],
}

# ---- pixelcat: ginger workshop cat -----------------------------------------
SPRITES["pixelcat"] = {
    "pal": {
        "G": _rgba((232, 142, 72)),  # ginger
        "g": _rgba((202, 112, 52)),  # stripes
        "C": _rgba((250, 238, 220)), # chest/muzzle
        "P": _rgba((240, 158, 146)), # inner ear / nose
        "E": _rgba((78, 168, 112)),  # green eyes
    },
    "front": [
        "................",
        "................",
        "..#G#....#G#....",
        ".#GPG#..#GPG#...",
        ".#GGGG##GGGG#...",
        ".#GGGGGGGGGG#...",
        ".#GEGGGGGGEG#...",
        ".#GGGCPCGGGG#...",
        "..#GGCCCGGG#....",
        "..#gGGGGGGg#....",
        "..#GCCCCCCG#G#..",
        "..#GCCCCCCG#G#..",
        "..#gCCCCCCg#G#..",
        "..#GGGGGGGG#G#..",
        "..#GG#..#GG##...",
        "...##....##.....",
    ],
    "front2": [
        "................",
        "................",
        "..#G#....#G#....",
        ".#GPG#..#GPG#...",
        ".#GGGG##GGGG#...",
        ".#GGGGGGGGGG#...",
        ".#GEGGGGGGEG#...",
        ".#GGGCPCGGGG#...",
        "..#GGCCCGGG#.#..",
        "..#gGGGGGGg##G#.",
        "..#GCCCCCCG#G#..",
        "..#GCCCCCCG#G#..",
        "..#gCCCCCCg#....",
        ".#GGGGGGGGGG#...",
        ".#G#GG..GG#G#...",
        "..#.##..##..#...",
    ],
    "side": [
        "................",
        "................",
        "...#G#.#G#......",
        "..#GPG#GPG#.....",
        "..#GGGGGGG#.....",
        ".#GGGGGGGG#.....",
        ".#GEGGGGGG#.....",
        ".#GCPCGGGG#.....",
        ".#GCCGGGGG###...",
        ".#gGGGGGGGGGG#..",
        ".#GGGGGGGGG#G#..",
        ".#GgGGGGGG#G#...",
        ".#GGGGGGGGG#....",
        "..#GGGGGGG#.....",
        "..#GG#.#GG#.....",
        "...##...##......",
    ],
    "side2": [
        "................",
        "................",
        "...#G#.#G#......",
        "..#GPG#GPG#.....",
        "..#GGGGGGG#.....",
        ".#GGGGGGGG#.....",
        ".#GEGGGGGG#.....",
        ".#GCPCGGGG#.....",
        ".#GCCGGGGG##.#..",
        ".#gGGGGGGGGG#G#.",
        ".#GGGGGGGGG#G#..",
        ".#GgGGGGGGG#....",
        ".#GGGGGGGGGG#...",
        ".#GGGGGGGGGG#...",
        ".#GG#....#GG#...",
        "..##......##....",
    ],
}


# --------------------------------------------------------------------------
# sheet builder
# --------------------------------------------------------------------------

def _draw(matrix: list[str], pal: dict) -> Image.Image:
    h = len(matrix)
    w = max(len(r) for r in matrix)
    img = Image.new("RGBA", (w, h), (0, 0, 0, 0))
    px = img.load()
    for y, row in enumerate(matrix):
        for x, ch in enumerate(row):
            if ch == ".":
                continue
            px[x, y] = OUTLINE if ch == "#" else pal[ch]
    return img


def _mirror(img: Image.Image) -> Image.Image:
    return img.transpose(Image.FLIP_LEFT_RIGHT)


def _shade(img: Image.Image) -> Image.Image:
    """Cheap volumetric pass: darken the bottom edge of every colour region
    (form shadow) and lighten the top edge (rim light). Lifts the sprites
    from flat stickers to rounded figures without redrawing any matrix."""
    out = img.copy()
    src = img.load()
    px = out.load()
    w, h = img.size

    def solid(x: int, y: int) -> bool:
        if x < 0 or y < 0 or x >= w or y >= h:
            return False
        p = src[x, y]
        return p[3] > 0 and (p[0], p[1], p[2]) != OUTLINE[:3]

    for y in range(h):
        for x in range(w):
            p = src[x, y]
            if p[3] == 0 or (p[0], p[1], p[2]) == OUTLINE[:3]:
                continue
            below_open = not solid(x, y + 1)
            above_open = not solid(x, y - 1)
            r, g, b, a = p
            if below_open and not above_open:
                px[x, y] = (int(r * 0.85), int(g * 0.85), int(b * 0.85), a)
            elif above_open and not below_open:
                px[x, y] = (
                    min(255, int(r * 1.08) + 10),
                    min(255, int(g * 1.08) + 10),
                    min(255, int(b * 1.08) + 10),
                    a,
                )
    return out


def build_sheet(sprite_id: str, scale: int = 2) -> Image.Image:
    """4x4 sheet of 48px cells; rows down/up/left/right, frames 0-3.

    Frames: 0 rest, 1 walk pose, 2 rest (1px bob), 3 walk pose (mirrored
    shift). Sprites are drawn at 16px and scaled 2x so residents read at
    the same visual weight as the 48px-cell humans from the packs.
    """
    spec = SPRITES[sprite_id]
    pal = spec["pal"]
    front = _shade(_draw(spec["front"], pal))
    front2 = _shade(_draw(spec.get("front2", spec["front"]), pal))
    back = _shade(_draw(spec.get("back", spec["front"]), pal))
    back2 = _shade(_draw(spec.get("back2", spec.get("front2", spec["front"])), pal))
    left = _shade(_draw(spec["side"], pal))
    left2 = _shade(_draw(spec.get("side2", spec["side"]), pal))
    right, right2 = _mirror(left), _mirror(left2)

    rows = [
        (front, front2),   # down
        (back, back2),     # up
        (left, left2),     # left
        (right, right2),   # right
    ]
    sheet = Image.new("RGBA", (CELL * 4, CELL * 4), (0, 0, 0, 0))
    for ry, (rest, step) in enumerate(rows):
        frames = [rest, step, rest, _mirror_step(step)]
        for fx, frame in enumerate(frames):
            big = frame.resize((frame.width * scale, frame.height * scale), Image.NEAREST)
            # anchor: feet on the same baseline the pack humans use (~y=44)
            ox = CELL * fx + (CELL - big.width) // 2
            oy = CELL * ry + 44 - big.height
            bob = -1 if fx in (1, 3) else 0
            sheet.alpha_composite(big, (ox, oy + bob))
    return sheet


def _mirror_step(step: Image.Image) -> Image.Image:
    """Second walk pose: reuse the step frame (legs read alternated thanks
    to the bob); creatures look hoppy-cute rather than mechanical."""
    return step


ALL_IDS = list(SPRITES.keys())
