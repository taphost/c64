# VIC-II Graphics Reference (6567/6569)

## Overview

The VIC-II chip controls all video output: text, bitmaps, sprites, colors, and scrolling. Memory-mapped registers at $D000-$D02E ($D3FF mirrors). This reference synthesizes the Commodore 64 Programmer's Reference Guide (Graphics chapter + Appendices B/G) and Mapping the Commodore 64 (Chapters 3 & 6) so both official sources are acknowledged.

**Capabilities:**
- 40×25 text mode (320×200 pixels)
- Hi-res bitmap: 320×200 (2 colors per 8×8 cell)
- Multicolor bitmap: 160×200 (4 colors per 4×8 cell)
- 8 hardware sprites (24×21 pixels)
- 16 colors
- Smooth scrolling
- Raster interrupts

## VIC-II Register Map ($D000-$D02E)

### Sprite Position ($D000-$D00F)

| Address | Decimal | Register | Function |
|---------|---------|----------|----------|
| $D000 | 53248 | M0X | Sprite 0 X position (low 8 bits) |
| $D001 | 53249 | M0Y | Sprite 0 Y position |
| $D002 | 53250 | M1X | Sprite 1 X position |
| $D003 | 53251 | M1Y | Sprite 1 Y position |
| $D004 | 53252 | M2X | Sprite 2 X position |
| $D005 | 53253 | M2Y | Sprite 2 Y position |
| $D006 | 53254 | M3X | Sprite 3 X position |
| $D007 | 53255 | M3Y | Sprite 3 Y position |
| $D008 | 53256 | M4X | Sprite 4 X position |
| $D009 | 53257 | M4Y | Sprite 4 Y position |
| $D00A | 53258 | M5X | Sprite 5 X position |
| $D00B | 53259 | M5Y | Sprite 5 Y position |
| $D00C | 53260 | M6X | Sprite 6 X position |
| $D00D | 53261 | M6Y | Sprite 6 Y position |
| $D00E | 53262 | M7X | Sprite 7 X position |
| $D00F | 53263 | M7Y | Sprite 7 Y position |

### Sprite Control ($D010-$D01F)

| Address | Decimal | Register | Function |
|---------|---------|----------|----------|
| $D010 | 53264 | MSBX | Sprite X MSB (bit 8 for X > 255) |
| $D011 | 53265 | SCROLY | Screen control (bitmap/rows/scroll Y) |
| $D012 | 53266 | RASTER | Raster counter (read/write) |
| $D013 | 53267 | LPX | Light pen X |
| $D014 | 53268 | LPY | Light pen Y |
| $D015 | 53269 | SPENA | Sprite enable (bits 0-7) |
| $D016 | 53270 | SCROLX | Horizontal control (scroll X/multicolor) |
| $D017 | 53271 | YXPAND | Sprite Y expansion (double height) |
| $D018 | 53272 | VMCSB | Memory pointers (screen/charset) |
| $D019 | 53273 | VICIRQ | Interrupt flags |
| $D01A | 53274 | IRQMSK | Interrupt enable |
| $D01B | 53275 | SPBGPR | Sprite-background priority |
| $D01C | 53276 | SPMC | Sprite multicolor enable |
| $D01D | 53277 | XXPAND | Sprite X expansion (double width) |
| $D01E | 53278 | SPSPCL | Sprite-sprite collision |
| $D01F | 53279 | SPBGCL | Sprite-background collision |

### Colors ($D020-$D02E)

| Address | Decimal | Register | Function |
|---------|---------|----------|----------|
| $D020 | 53280 | BORDER | Border color |
| $D021 | 53281 | BG0 | Background color 0 |
| $D022 | 53282 | BG1 | Background color 1 (multicolor) |
| $D023 | 53283 | BG2 | Background color 2 (multicolor) |
| $D024 | 53284 | BG3 | Background color 3 (ECM) |
| $D025 | 53285 | MM0 | Sprite multicolor 0 (shared) |
| $D026 | 53286 | MM1 | Sprite multicolor 1 (shared) |
| $D027 | 53287 | M0C | Sprite 0 color |
| $D028 | 53288 | M1C | Sprite 1 color |
| $D029 | 53289 | M2C | Sprite 2 color |
| $D02A | 53290 | M3C | Sprite 3 color |
| $D02B | 53291 | M4C | Sprite 4 color |
| $D02C | 53292 | M5C | Sprite 5 color |
| $D02D | 53293 | M6C | Sprite 6 color |
| $D02E | 53294 | M7C | Sprite 7 color |

## Control Register Details

### $D011 (SCROLY) - Screen Control 1

| Bit | Value | Function |
|-----|-------|----------|
| 7 | 128 | Raster compare bit 8 |
| 6 | 64 | Extended color mode (ECM) |
| 5 | 32 | Bitmap mode enable |
| 4 | 16 | Screen on (0=blank) |
| 3 | 8 | 25 rows (1) or 24 rows (0) |
| 0-2 | 0-7 | Vertical smooth scroll |

**Common values:**
- $1B (27): Standard text mode, 25 rows
- $3B (59): Bitmap mode, 25 rows
- $5B (91): Multicolor bitmap, 25 rows

### $D016 (SCROLX) - Screen Control 2

| Bit | Value | Function |
|-----|-------|----------|
| 5 | 32 | Reset (0) |
| 4 | 16 | Multicolor mode |
| 3 | 8 | 40 columns (1) or 38 columns (0) |
| 0-2 | 0-7 | Horizontal smooth scroll |

**Common values:**
- $C8 (200): Standard text, 40 columns
- $D8 (216): Multicolor text, 40 columns

### $D018 (VMCSB) - Memory Pointers

| Bits | Function |
|------|----------|
| 7-4 | Screen memory location (offset / 64 within VIC bank) |
| 3-1 | Character memory location (offset / 2048 within VIC bank) |
| 0 | Unused |

**Formula:**
- Screen base = VIC_BANK + (bits 7-4) × 1024
- Charset base = VIC_BANK + (bits 3-1) × 2048

**Common values:**
- $14 (20): Screen at $0400, charset at $1000
- $18 (24): Screen at $0400, charset at $2000

## VIC Memory Banks

VIC-II sees only 16KB at a time. Select bank via CIA2 $DD00 bits 0-1:

| $DD00 bits 0-1 | Bank | Address Range |
|----------------|------|---------------|
| 11 (3) | 0 | $0000-$3FFF (default) |
| 10 (2) | 1 | $4000-$7FFF |
| 01 (1) | 2 | $8000-$BFFF |
| 00 (0) | 3 | $C000-$FFFF |

**Example - switch to bank 1:**
```basic
10 POKE 56576,(PEEK(56576) AND 252) OR 2
```

`POKE 56576` changes only the VIC bank select bits inside CIA2; it does not interact with the `/GAME` or `/EXROM` cartridge lines. Use this bank logic when relocating screens or character sets so that the VIC and 6510 reference the same 16KB block (Mapping Chapter 6).

## Character Mode (Text)

### Standard Character Mode

- 40×25 characters (1000 bytes screen memory)
- 8×8 pixels per character
- 2 colors per character: foreground (color RAM) + background ($D021)
- Default: screen at $0400, charset at $1000 (in ROM), color at $D800

**Display character:**
```basic
10 POKE 1024,1: REM 'A' at top-left (screen code 1)
20 POKE 55296,2: REM Red color
```

**Background selection rules:**
1. Screen codes 0-63 (standard alphanumerics) use Background Color 0 ($D021).
2. Shifted characters 64-127 use Background Color 1 ($D022).
3. Reversed characters 128-191 pick Background Color 2 ($D023).
4. Codes 192-255 draw from Background Color 3 ($D024).
5. Foreground is always the nybble stored in color RAM at $D800-$DBE7. Update color RAM after moving a character; otherwise the old color stays.

### Sprite pointers and relocation traps

The VIC screen block at $0400-$07FF contains the video matrix plus the sprite pointers in its last eight bytes ($07F8-$07FF). Each pointer is a block number; multiply it by 64 to locate the sprite shape data (value 11 points to $2C0-$31F). If you relocate the screen or change VIC banks, reinitialize these values; otherwise sprites will show data from whatever happens to sit at the new memory.

Color RAM ($D800-$DBE7) stays at the same physical location, so after moving the screen you must repopulate color RAM manually or characters keep their previous color values (Mapping cap. 4).

### Multicolor Character Mode

Enable: `POKE 53270,PEEK(53270) OR 16`

- 4×8 pixels per character (doubled width)
- 4 colors per character:
  - Color 00: Background ($D021)
  - Color 01: Background 1 ($D022)
  - Color 10: Background 2 ($D023)
  - Color 11: Foreground (color RAM, upper 4 bits must = 1 for multicolor)

**Enable multicolor for character:**
```basic
10 POKE 55296,8+2: REM Bit 3 = multicolor enable, 2 = red
```

### Custom Character Set

Copy ROM charset to RAM, modify, point VIC to new location:

```basic
10 REM Copy charset ROM to $3000
20 POKE 56334,PEEK(56334) AND 254: REM Bank out I/O
30 POKE 1,PEEK(1) AND 251: REM Bank in char ROM
40 FOR I=0 TO 2047
50   POKE 12288+I,PEEK(53248+I): REM Copy $D000-$D7FF to $3000
60 NEXT I
70 POKE 1,PEEK(1) OR 4: REM Bank out char ROM
80 POKE 56334,PEEK(56334) OR 1: REM Bank in I/O
90 REM
100 REM Point VIC to $3000 (offset 6 in bank 0)
110 POKE 53272,(PEEK(53272) AND 240) OR 12
120 REM
130 REM Modify character (e.g., '@' = char 0)
140 FOR I=0 TO 7
150   POKE 12288+I,255: REM Solid 8×8 block
160 NEXT I
```

## Bitmap Mode

### Hi-Res Bitmap (320×200)

Enable: `POKE 53265,PEEK(53265) OR 32`

- 8000 bytes bitmap data
- 1000 bytes screen memory (color info)
- Each bit: 0=background color, 1=foreground color
- Colors from screen memory: upper nybble=foreground, lower=background

**Memory layout:**
- Bitmap: 8 KB (e.g., $2000-$3FFF)
- Screen: 1000 bytes (e.g., $0400-$07E7) for color info

**Setup:**
```basic
10 REM Set bitmap at $2000, screen at $0400
20 POKE 53272,(PEEK(53272) AND 15) OR 32: REM Bitmap offset 8
30 POKE 53265,PEEK(53265) OR 32: REM Enable bitmap
40 REM
50 REM Clear bitmap
60 FOR I=8192 TO 16191: POKE I,0: NEXT
70 REM Set colors (white on black)
80 FOR I=1024 TO 2023: POKE I,16: NEXT: REM $10 = white fg, black bg
```

**Plot pixel:**
```basic
100 X=100: Y=50: C=1: REM X,Y coords, C=color (0 or 1)
110 REM Calculate byte address
120 BX=INT(X/8): BY=Y: REM Character cell
130 BA=8192+BY*320+BX*8+(Y AND 7): REM Bitmap address
140 BI=7-(X AND 7): REM Bit position
150 REM
160 B=PEEK(BA)
170 IF C THEN B=B OR (2^BI): REM Set bit
180 IF C=0 THEN B=B AND (255-(2^BI)): REM Clear bit
190 POKE BA,B
```

### Multicolor Bitmap (160×200)

Enable: `POKE 53265,PEEK(53265) OR 32: POKE 53270,PEEK(53270) OR 16`

- 8000 bytes bitmap (4×8 pixels = 2 bits per pixel)
- 4 colors per 4×8 cell:
  - 00: Background ($D021)
  - 01: Screen RAM upper nybble
  - 10: Screen RAM lower nybble
  - 11: Color RAM

**Setup:**
```basic
10 REM Enable multicolor bitmap
20 POKE 53265,PEEK(53265) OR 32: REM Bitmap mode
30 POKE 53270,PEEK(53270) OR 16: REM Multicolor
40 REM Set colors
50 POKE 53281,0: REM Background black (00)
60 FOR I=1024 TO 2023: POKE I,17: NEXT: REM 01=white, 10=red
70 FOR I=55296 TO 56295: POKE I,3: NEXT: REM 11=cyan
```

## Sprites

### Sprite Structure

- 63 bytes of data (21 rows × 3 bytes) + 1 unused
- 24×21 pixels (hi-res) or 12×21 pixels (multicolor)
- Pointer stored at screen memory + 1016-1023 (last 8 bytes of screen)
- Pointer value = sprite data address / 64 (within current VIC bank)

### Basic Sprite Setup

```basic
10 REM Define sprite at $2000 (block 128 in bank 0)
20 FOR I=0 TO 62
30   READ B: POKE 8192+I,B
40 NEXT I
50 REM
60 REM Set sprite pointer (screen at $0400 = 1024)
70 POKE 2040,128: REM Sprite 0 pointer = $2000/64
80 REM
90 REM Enable sprite 0
100 POKE 53269,1: REM Bit 0 = sprite 0
110 REM
120 REM Position sprite
130 POKE 53248,100: REM X position
140 POKE 53249,100: REM Y position
150 REM
160 REM Set color
170 POKE 53287,2: REM Red
180 REM
190 DATA 0,126,0,1,255,128,3,255,192: REM Sprite data (sample)
200 DATA 3,231,192,7,217,224,7,223,224
210 DATA 7,217,224,3,231,192,3,255,192
220 DATA 1,255,128,0,126,0,0,0,0
```

### Sprite Position (X > 255)

For X coordinates > 255, set corresponding bit in $D010:

```basic
10 X=300: REM X position
20 POKE 53248,X AND 255: REM Low byte
30 IF X>255 THEN POKE 53264,PEEK(53264) OR 1: REM Set MSB
40 IF X<256 THEN POKE 53264,PEEK(53264) AND 254: REM Clear MSB
```

### Multicolor Sprites

Enable: `POKE 53276,PEEK(53276) OR <sprite_bit>`

- 12×21 pixels (doubled width)
- 4 colors:
  - 00: Transparent
  - 01: Sprite multicolor 0 ($D025)
  - 10: Sprite color ($D027-$D02E)
  - 11: Sprite multicolor 1 ($D026)

```basic
10 POKE 53276,1: REM Enable multicolor for sprite 0
20 POKE 53285,1: REM Multicolor 0 = white
30 POKE 53286,2: REM Multicolor 1 = red
40 POKE 53287,3: REM Sprite 0 color = cyan
```

### Sprite Expansion

**Double width:** `POKE 53277,<bit_mask>`  
**Double height:** `POKE 53271,<bit_mask>`

```basic
10 POKE 53277,1: REM Expand sprite 0 horizontally
20 POKE 53271,1: REM Expand sprite 0 vertically
```

### Sprite Priority

`POKE 53275,<bit_mask>`: 0=sprite in front of screen, 1=sprite behind screen

```basic
10 POKE 53275,1: REM Sprite 0 behind background
```

### Collision Detection

**Sprite-sprite:** Read $D01E (53278), clears on read  
**Sprite-background:** Read $D01F (53279), clears on read

```basic
10 C=PEEK(53278): REM Sprite-sprite collision
20 IF C AND 1 THEN PRINT "SPRITE 0 COLLISION"
```

## Scrolling

### Hardware Smooth Scrolling

**Vertical:** Bits 0-2 of $D011 (0-7 pixels)  
**Horizontal:** Bits 0-2 of $D016 (0-7 pixels)

```basic
10 REM Scroll screen down
20 FOR I=0 TO 7
30   POKE 53265,(PEEK(53265) AND 248) OR I
40   FOR D=1 TO 50: NEXT D: REM Delay
50 NEXT I
```

**Full scrolling:** Combine hardware scroll with screen memory copying for seamless scrolling.

## Raster Interrupts

### Raster Register ($D012)

Read current raster line or set interrupt trigger:

```basic
10 PRINT PEEK(53266): REM Current raster line
```

### Setting Raster Interrupt

```basic
10 REM Setup raster IRQ at line 100
20 POKE 53265,PEEK(53265) AND 127: REM Clear bit 8 of raster
30 POKE 53266,100: REM Raster line (low 8 bits)
40 POKE 53274,1: REM Enable raster interrupt
50 REM Install ML IRQ handler via $0314/$0315
```

**ML handler required** - BASIC cannot handle IRQ directly.

## Color Values (0-15)

| Value | Color | Value | Color |
|-------|-------|-------|-------|
| 0 | Black | 8 | Orange |
| 1 | White | 9 | Brown |
| 2 | Red | 10 | Light Red |
| 3 | Cyan | 11 | Dark Grey |
| 4 | Purple | 12 | Grey |
| 5 | Green | 13 | Light Green |
| 6 | Blue | 14 | Light Blue |
| 7 | Yellow | 15 | Light Grey |

## Practical Examples

### Clear Screen to Color

```basic
10 C=6: REM Blue
20 POKE 53280,C: REM Border
30 POKE 53281,C: REM Background
40 FOR I=1024 TO 2023: POKE I,32: NEXT: REM Clear with spaces
50 FOR I=55296 TO 56295: POKE I,C: NEXT: REM Color RAM
```

### Flashing Border

```basic
10 FOR I=0 TO 15
20   POKE 53280,I
30   FOR D=1 TO 100: NEXT D
40 NEXT I
50 GOTO 10
```

### Simple Sprite Animation

```basic
10 REM Move sprite 0 across screen
20 POKE 53269,1: REM Enable sprite 0
30 POKE 2040,128: REM Sprite pointer
40 POKE 53287,2: REM Red
50 POKE 53249,100: REM Y position
60 REM
70 FOR X=0 TO 320
80   IF X<256 THEN POKE 53248,X: POKE 53264,PEEK(53264) AND 254
90   IF X>255 THEN POKE 53248,X AND 255: POKE 53264,PEEK(53264) OR 1
100  FOR D=1 TO 10: NEXT D: REM Delay
110 NEXT X
120 GOTO 70
```

### Detect Sprite Collision

```basic
10 REM Enable sprites 0 and 1
20 POKE 53269,3: REM Bits 0-1
30 POKE 2040,128: POKE 2041,129: REM Pointers
40 POKE 53287,2: POKE 53288,3: REM Colors
50 REM
60 REM Position sprites
70 POKE 53248,100: POKE 53249,100: REM Sprite 0
80 POKE 53250,120: POKE 53251,100: REM Sprite 1
90 REM
100 IF PEEK(53278) AND 3 THEN PRINT "COLLISION!": GOTO 100
110 GOTO 100
```

### Screen Memory Relocation

```basic
10 REM Move screen to $4000 (bank 1)
20 POKE 56576,(PEEK(56576) AND 252) OR 2: REM Select bank 1
30 POKE 53272,0: REM Screen at bank start
40 REM Clear new screen
50 FOR I=16384 TO 17383: POKE I,32: NEXT
60 FOR I=55296 TO 56295: POKE I,1: NEXT: REM White color
```

### Bitmap Graphics Mode

```basic
10 REM Setup bitmap at $2000
20 POKE 53272,8: REM Screen $0400, bitmap $2000
30 POKE 53265,PEEK(53265) OR 32: REM Enable bitmap
40 REM Clear bitmap
50 FOR I=8192 TO 16191: POKE I,0: NEXT
60 FOR I=1024 TO 2023: POKE I,16: NEXT: REM White on black
70 REM
80 REM Draw diagonal line
90 FOR I=0 TO 199
100  X=I: Y=I: REM Diagonal
110  BX=INT(X/8): BY=Y
120  BA=8192+BY*320+BX*8+(Y AND 7)
130  BI=7-(X AND 7)
140  POKE BA,PEEK(BA) OR (2^BI)
150 NEXT I
```

## Memory Requirements

**Character mode:**
- Screen: 1000 bytes
- Charset: 2048 bytes (if custom)
- Color RAM: 1000 bytes (fixed at $D800)

**Bitmap mode:**
- Bitmap: 8000 bytes
- Screen (color): 1000 bytes
- Color RAM: 1000 bytes

**Sprites:**
- Data: 64 bytes each (8 sprites = 512 bytes)
- Pointers: 8 bytes (in screen memory)

## Troubleshooting

### Problem: Nothing displayed

**Check:**
1. Screen enabled: `POKE 53265,PEEK(53265) OR 16`
2. Correct memory pointers: $D018
3. VIC bank selection: $DD00
4. Colors not matching background

### Problem: Sprite not visible

**Check:**
1. Enabled: `POKE 53269,<bit>`
2. Position on screen (0-255/340 X, 0-255 Y)
3. Color ≠ background
4. Valid sprite data
5. Pointer correct: screen+1016-1023

### Problem: Bitmap garbled

**Check:**
1. Bitmap address aligned to 8 KB boundary ($0000, $2000, $4000, etc.)
2. $D018 pointing to correct bitmap/screen
3. VIC bank correct
4. Screen memory colors set

### Problem: Character set not showing

**Check:**
1. Charset copied to RAM (not ROM)
2. $D018 bits 1-3 pointing to charset location
3. Charset address aligned to 2 KB boundary
4. VIC bank includes charset

## VIC-II Summary

**Registers:** $D000-$D02E  
**Banks:** 4×16KB selectable via $DD00  
**Modes:** Character, bitmap (hi-res/multicolor)  
**Sprites:** 8, 24×21 pixels, expandable, multicolor  
**Colors:** 16 colors, border/background/foreground  
**Resolution:** 320×200 pixels  
**Screen:** 40×25 characters (1000 bytes)

---
