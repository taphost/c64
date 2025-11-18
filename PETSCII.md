# PETSCII - Complete Character Set Reference for Commodore 64

## Overview

PETSCII (PET Standard Code of Information Interchange) is the character encoding used by Commodore 8-bit computers. Unlike ASCII, PETSCII includes extensive control codes, graphic characters, and a unique uppercase/lowercase system.

**Key differences from ASCII:**
- Codes 0-31: Control characters (colors, cursor movement, screen operations)
- Codes 32-127: Letters, numbers, graphics (shifted vs unshifted behavior)
- Codes 128-255: Additional control codes and alternate character forms
- No direct ASCII compatibility (requires conversion)
- Two character sets: UPPER/GRAPHICS (default) and LOWER/UPPER

## Character Set Modes

### UPPER/GRAPHICS Mode (Power-on Default)
- Uppercase letters A-Z
- Numbers 0-9
- Graphic characters via SHIFT+key
- Access: `PRINT CHR$(14)` or SHIFT+Commodore key

### LOWER/UPPER Mode
- Lowercase letters a-z
- Uppercase letters A-Z (via SHIFT)
- Access: `PRINT CHR$(142)` or Commodore+SHIFT key

## Complete PETSCII Table (0-255)

### Control Codes (0-31)

| Dec | Hex | Key | Function | BASIC Usage |
|-----|-----|-----|----------|-------------|
| 0 | 00 | - | Null | - |
| 5 | 05 | - | White text | `PRINT CHR$(5)` |
| 8 | 08 | - | Disable SHIFT+Commodore | `PRINT CHR$(8)` |
| 9 | 09 | - | Enable SHIFT+Commodore | `PRINT CHR$(9)` |
| 13 | 0D | RETURN | Carriage return | `PRINT CHR$(13)` |
| 14 | 0E | - | Switch to lowercase mode | `PRINT CHR$(14)` |
| 17 | 11 | CRSR DOWN | Cursor down | `PRINT CHR$(17)` |
| 18 | 12 | RVS ON | Reverse video on | `PRINT CHR$(18)` |
| 19 | 13 | HOME | Home cursor | `PRINT CHR$(19)` |
| 20 | 14 | DEL | Delete | `PRINT CHR$(20)` |
| 28 | 1C | - | Red text | `PRINT CHR$(28)` |
| 29 | 1D | CRSR RIGHT | Cursor right | `PRINT CHR$(29)` |
| 30 | 1E | - | Green text | `PRINT CHR$(30)` |
| 31 | 1F | - | Blue text | `PRINT CHR$(31)` |

### Printable Characters (32-63)

| Dec | Hex | UPPER/GFX | LOWER/UPPER | Description |
|-----|-----|-----------|-------------|-------------|
| 32 | 20 | Space | Space | Space character |
| 33 | 21 | ! | ! | Exclamation mark |
| 34 | 22 | " | " | Quotation mark |
| 35 | 23 | # | # | Hash/pound |
| 36 | 24 | $ | $ | Dollar sign |
| 37 | 25 | % | % | Percent |
| 38 | 26 | & | & | Ampersand |
| 39 | 27 | ' | ' | Apostrophe |
| 40 | 28 | ( | ( | Left parenthesis |
| 41 | 29 | ) | ) | Right parenthesis |
| 42 | 2A | * | * | Asterisk |
| 43 | 2B | + | + | Plus |
| 44 | 2C | , | , | Comma |
| 45 | 2D | - | - | Minus/hyphen |
| 46 | 2E | . | . | Period |
| 47 | 2F | / | / | Slash |
| 48-57 | 30-39 | 0-9 | 0-9 | Digits |
| 58 | 3A | : | : | Colon |
| 59 | 3B | ; | ; | Semicolon |
| 60 | 3C | < | < | Less than |
| 61 | 3D | = | = | Equal |
| 62 | 3E | > | > | Greater than |
| 63 | 3F | ? | ? | Question mark |

### Letters and Graphics (64-95)

| Dec | Hex | UPPER/GFX | LOWER/UPPER | Description |
|-----|-----|-----------|-------------|-------------|
| 64 | 40 | @ | @ | At sign |
| 65-90 | 41-5A | A-Z | a-z | Letters (uppercase in UPPER mode, lowercase in LOWER mode) |
| 91 | 5B | [ | [ | Left bracket |
| 92 | 5C | £ | £ | Pound sterling |
| 93 | 5D | ] | ] | Right bracket |
| 94 | 5E | ↑ | ↑ | Up arrow |
| 95 | 5F | ← | ← | Left arrow |

### Graphic Characters (96-127, UPPER/GRAPHICS mode only)

| Dec | Hex | Character | Description |
|-----|-----|-----------|-------------|
| 96 | 60 | ─ | Horizontal line |
| 97-122 | 61-7A | Various | Semigraphic blocks, lines |
| 123 | 7B | ┼ | Cross/intersection |
| 124 | 7C | │ | Vertical line |
| 125 | 7D | ╮ | Upper right corner |
| 126 | 7E | ╰ | Lower left corner |
| 127 | 7F | ╲ | Diagonal line |

**Note:** In LOWER/UPPER mode, codes 96-127 display as uppercase A-Z and symbols.

### Additional Control Codes (128-159)

| Dec | Hex | Function | BASIC Usage |
|-----|-----|----------|-------------|
| 129 | 81 | Orange text | `PRINT CHR$(129)` |
| 133 | 85 | F1 key | - |
| 134 | 86 | F3 key | - |
| 135 | 87 | F5 key | - |
| 136 | 88 | F7 key | - |
| 137 | 89 | F2 key | - |
| 138 | 8A | F4 key | - |
| 139 | 8B | F6 key | - |
| 140 | 8C | F8 key | - |
| 141 | 8D | SHIFT+RETURN | Newline without scroll |
| 142 | 8E | - | Switch to uppercase mode | `PRINT CHR$(142)` |
| 144 | 90 | - | Black text | `PRINT CHR$(144)` |
| 145 | 91 | CRSR UP | Cursor up | `PRINT CHR$(145)` |
| 146 | 92 | RVS OFF | Reverse video off | `PRINT CHR$(146)` |
| 147 | 93 | CLR | Clear screen | `PRINT CHR$(147)` |
| 148 | 94 | INST | Insert | `PRINT CHR$(148)` |
| 149 | 95 | - | Brown text | `PRINT CHR$(149)` |
| 150 | 96 | - | Light red text | `PRINT CHR$(150)` |
| 151 | 97 | - | Grey 1 text | `PRINT CHR$(151)` |
| 152 | 98 | - | Grey 2 text | `PRINT CHR$(152)` |
| 153 | 99 | - | Light green text | `PRINT CHR$(153)` |
| 154 | 9A | - | Light blue text | `PRINT CHR$(154)` |
| 155 | 9B | - | Grey 3 text | `PRINT CHR$(155)` |
| 156 | 9C | - | Purple text | `PRINT CHR$(156)` |
| 157 | 9D | CRSR LEFT | Cursor left | `PRINT CHR$(157)` |
| 158 | 9E | - | Yellow text | `PRINT CHR$(158)` |
| 159 | 9F | - | Cyan text | `PRINT CHR$(159)` |

### Reverse Characters (160-223)

Codes 160-223 display the same characters as 96-159 but in **reverse video** (background and foreground colors swapped).

### Graphic Characters Shifted (224-254)

Codes 224-254 are alternate graphic characters, mostly duplicates or shifted versions of codes 96-127.

## Color Reference

### Standard Colors (Codes)

| Color | Code | Hex | BASIC Command |
|-------|------|-----|---------------|
| Black | 144 | 90 | `PRINT CHR$(144)` |
| White | 5 | 05 | `PRINT CHR$(5)` |
| Red | 28 | 1C | `PRINT CHR$(28)` |
| Cyan | 159 | 9F | `PRINT CHR$(159)` |
| Purple | 156 | 9C | `PRINT CHR$(156)` |
| Green | 30 | 1E | `PRINT CHR$(30)` |
| Blue | 31 | 1F | `PRINT CHR$(31)` |
| Yellow | 158 | 9E | `PRINT CHR$(158)` |
| Orange | 129 | 81 | `PRINT CHR$(129)` |
| Brown | 149 | 95 | `PRINT CHR$(149)` |
| Light Red | 150 | 96 | `PRINT CHR$(150)` |
| Dark Grey | 151 | 97 | `PRINT CHR$(151)` |
| Grey 2 | 152 | 98 | `PRINT CHR$(152)` |
| Light Green | 153 | 99 | `PRINT CHR$(153)` |
| Light Blue | 154 | 9A | `PRINT CHR$(154)` |
| Light Grey | 155 | 9B | `PRINT CHR$(155)` |

### Color Memory Direct Access

Colors can also be set via POKE to color RAM ($D800-$DBE7, 55296-56295):

```basic
10 REM Set color at row 10, column 5 to red (2)
20 P=55296+10*40+5
30 POKE P,2
```

**Color values (for POKE):**
- 0=Black, 1=White, 2=Red, 3=Cyan, 4=Purple, 5=Green, 6=Blue, 7=Yellow
- 8=Orange, 9=Brown, 10=Light Red, 11=Dark Grey, 12=Grey 2, 13=Light Green, 14=Light Blue, 15=Light Grey

## Screen Control Codes

### Cursor Movement

```basic
10 PRINT CHR$(19): REM Home cursor (0,0)
20 PRINT CHR$(147): REM Clear screen and home
30 PRINT CHR$(17): REM Move cursor down
40 PRINT CHR$(145): REM Move cursor up
50 PRINT CHR$(29): REM Move cursor right
60 PRINT CHR$(157): REM Move cursor left
```

### Positioning Cursor (via POKE)

```basic
10 X=10: Y=5: REM Column 10, Row 5
20 POKE 781,Y: POKE 782,X: POKE 783,0
30 SYS 65520: REM KERNAL PLOT routine
```

Or simpler positioning:

```basic
10 PRINT CHR$(19): REM Home first
20 FOR I=1 TO 5: PRINT CHR$(17): NEXT: REM Down 5
30 FOR I=1 TO 10: PRINT CHR$(29): NEXT: REM Right 10
```

### Reverse Video

```basic
10 PRINT CHR$(18): REM Reverse ON
20 PRINT "HIGHLIGHTED TEXT"
30 PRINT CHR$(146): REM Reverse OFF
40 PRINT "NORMAL TEXT"
```

## PETSCII vs Screen Codes

**Important:** PETSCII codes ≠ Screen memory codes.

### Screen Code Conversion Table

| Character | PETSCII | Screen Code |
|-----------|---------|-------------|
| @ | 64 | 0 |
| A-Z | 65-90 | 1-26 |
| [ | 91 | 27 |
| £ | 92 | 28 |
| ] | 93 | 29 |
| Space | 32 | 32 |
| 0-9 | 48-57 | 48-57 |
| Reverse @ | 192 | 128 |
| Reverse A-Z | 193-218 | 129-154 |

### Conversion Functions

```basic
10 REM PETSCII to Screen Code
20 P=65: REM Letter A (PETSCII)
30 IF P>=65 AND P<=90 THEN S=P-64: REM A-Z
40 IF P>=97 AND P<=122 THEN S=P-96: REM a-z (lowercase mode)
50 IF P>=193 AND P<=218 THEN S=P-64: REM Reverse A-Z
60 PRINT "Screen code:";S
```

```basic
100 REM Screen Code to PETSCII
110 S=1: REM Screen code for A
120 IF S>=1 AND S<=26 THEN P=S+64: REM A-Z
130 PRINT "PETSCII:";P
```

## Practical BASIC Examples

### Drawing a Box

```basic
10 PRINT CHR$(147): REM Clear screen
20 REM Top border
30 PRINT CHR$(18);CHR$(176);: REM Reverse ON + corner
40 FOR I=1 TO 38: PRINT CHR$(163);: NEXT: REM Horizontal line
50 PRINT CHR$(174);CHR$(146): REM Corner + Reverse OFF
60 REM
70 REM Side borders (22 rows)
80 FOR R=1 TO 22
90   PRINT CHR$(18);CHR$(221);CHR$(146);: REM Left border
100  PRINT SPC(38);
110  PRINT CHR$(18);CHR$(221);CHR$(146): REM Right border
120 NEXT R
130 REM
140 REM Bottom border
150 PRINT CHR$(18);CHR$(173);: REM Corner
160 FOR I=1 TO 38: PRINT CHR$(163);: NEXT
170 PRINT CHR$(189);CHR$(146): REM Corner + Reverse OFF
```

### Color Text Output

```basic
10 PRINT CHR$(147): REM Clear
20 PRINT CHR$(28)"RED TEXT"
30 PRINT CHR$(30)"GREEN TEXT"
40 PRINT CHR$(31)"BLUE TEXT"
50 PRINT CHR$(158)"YELLOW TEXT"
60 PRINT CHR$(5)"WHITE TEXT"
```

### Progress Bar

```basic
10 PRINT CHR$(147): REM Clear
20 PRINT "LOADING..."
30 FOR P=0 TO 100 STEP 5
40   PRINT CHR$(19): REM Home
50   PRINT CHR$(17): REM Down one row
60   PRINT "[";
70   FOR I=1 TO INT(P/5)
80     PRINT CHR$(18);CHR$(160);CHR$(146);: REM Reverse space
90   NEXT I
100  FOR I=INT(P/5)+1 TO 20
110    PRINT " ";
120  NEXT I
130  PRINT "]";P;"%"
140  FOR D=1 TO 50: NEXT D: REM Delay
150 NEXT P
```

### Animated Spinner

```basic
10 PRINT CHR$(147)
20 PRINT "WORKING ";
30 DIM S$(4)
40 S$(1)="-": S$(2)="\": S$(3)="|": S$(4)="/"
50 FOR I=1 TO 100
60   FOR J=1 TO 4
70     PRINT S$(J);
80     FOR D=1 TO 50: NEXT D: REM Delay
90     PRINT CHR$(157): REM Cursor left (erase)
100  NEXT J
110 NEXT I
```

### Menu System

```basic
10 PRINT CHR$(147)CHR$(158): REM Clear + yellow
20 PRINT "MAIN MENU"
30 PRINT CHR$(5): REM White
40 PRINT
50 PRINT CHR$(18)"1"CHR$(146)" - NEW GAME"
60 PRINT CHR$(18)"2"CHR$(146)" - LOAD GAME"
70 PRINT CHR$(18)"3"CHR$(146)" - OPTIONS"
80 PRINT CHR$(18)"4"CHR$(146)" - QUIT"
90 PRINT
100 PRINT "SELECT: ";
110 GET A$: IF A$="" THEN 110
120 IF A$>="1" AND A$<="4" THEN PRINT A$: GOTO 200
130 GOTO 110
200 REM Handle selection...
```

### Screen Saver (Random Characters)

```basic
10 PRINT CHR$(147)CHR$(144): REM Clear + black text
20 X=INT(RND(1)*40): Y=INT(RND(1)*25)
30 C=INT(RND(1)*16): REM Random color
40 CH=INT(RND(1)*64)+160: REM Random graphic char
50 REM
60 POKE 1024+Y*40+X,CH: REM Screen memory
70 POKE 55296+Y*40+X,C: REM Color memory
80 FOR D=1 TO 10: NEXT D: REM Small delay
90 GOTO 20
```

## Keyboard Input and PETSCII

### GET vs INPUT

```basic
10 REM GET returns PETSCII code
20 GET A$
30 IF A$="" THEN 20: REM Wait for keypress
40 PRINT "PETSCII:";ASC(A$)
50 PRINT "Character:";A$
```

### Detecting Control Keys

```basic
10 PRINT "PRESS A KEY (Q TO QUIT)"
20 GET K$: IF K$="" THEN 20
30 K=ASC(K$)
40 IF K=81 OR K=113 THEN END: REM Q or q
50 IF K=133 THEN PRINT "F1 PRESSED"
60 IF K=137 THEN PRINT "F2 PRESSED"
70 IF K=13 THEN PRINT "RETURN PRESSED"
80 IF K=32 THEN PRINT "SPACE PRESSED"
90 GOTO 20
```

### Arrow Key Detection

```basic
10 PRINT CHR$(147)"USE ARROW KEYS (SPACE=EXIT)"
20 GET K$: IF K$="" THEN 20
30 K=ASC(K$)
40 IF K=32 THEN END: REM Space
50 IF K=17 THEN PRINT "DOWN"
60 IF K=145 THEN PRINT "UP"
70 IF K=29 THEN PRINT "RIGHT"
80 IF K=157 THEN PRINT "LEFT"
90 GOTO 20
```

## Character Set Switching

### Switch to Lowercase Mode

```basic
10 PRINT CHR$(14): REM Enable lowercase
20 PRINT "This is lowercase text."
30 PRINT "SHIFTED KEYS = UPPERCASE"
```

### Switch to Uppercase/Graphics Mode

```basic
10 PRINT CHR$(142): REM Enable uppercase/graphics
20 PRINT "THIS IS UPPERCASE TEXT."
30 PRINT "SHIFTED KEYS = GRAPHICS"
```

### Detecting Current Mode

```basic
10 M=PEEK(53272)
20 IF M=23 THEN PRINT "LOWERCASE MODE"
30 IF M=21 THEN PRINT "UPPERCASE MODE"
```

## Custom Character Sets

### Redefining Characters

The C64 allows custom character definitions by modifying character ROM or RAM.

**Location:** Character ROM at $D000-$DFFF (banked), or copy to RAM.

```basic
10 REM Copy character ROM to RAM at $3000
20 POKE 56334,PEEK(56334) AND 254: REM Bank out I/O
30 POKE 1,PEEK(1) AND 251: REM Bank in character ROM
40 FOR I=0 TO 2047
50   POKE 12288+I,PEEK(53248+I): REM Copy $D000 to $3000
60 NEXT I
70 POKE 1,PEEK(1) OR 4: REM Bank out character ROM
80 POKE 56334,PEEK(56334) OR 1: REM Bank in I/O
90 REM
100 REM Point VIC to custom charset
110 POKE 53272,(PEEK(53272) AND 240) OR 12: REM Use $3000
120 REM
130 REM Modify a character (e.g., '@' = char 0)
140 FOR I=0 TO 7
150   READ B: POKE 12288+I,B: REM 8 bytes per character
160 NEXT I
170 DATA 60,126,255,255,255,255,126,60: REM Solid circle
```

## PETSCII Art and Graphics

### Block Graphics Characters

Common graphic blocks in UPPER/GRAPHICS mode:

| Code | Hex | Character | Description |
|------|-----|-----------|-------------|
| 160 | A0 | █ | Solid block (reverse space) |
| 224 | E0 | ▌ | Left half block |
| 225 | E1 | ▐ | Right half block |
| 226 | E2 | ▄ | Lower half block |
| 227 | E3 | ▔ | Upper half block |
| 228 | E4 | ▘ | Upper left quadrant |
| 229 | E5 | ▝ | Upper right quadrant |
| 230 | E6 | ▖ | Lower left quadrant |
| 231 | E7 | ▗ | Lower right quadrant |

### Line Drawing Characters

| Code | Hex | Character | Description |
|------|-----|-----------|-------------|
| 96 | 60 | ─ | Horizontal line |
| 125 | 7D | ╮ | Upper right corner |
| 126 | 7E | ╰ | Lower left corner |
| 176 | B0 | ╭ | Upper left corner (reverse) |
| 173 | AD | ╰ | Lower left corner (reverse) |
| 174 | AE | ╮ | Upper right corner (reverse) |
| 189 | BD | ╯ | Lower right corner (reverse) |
| 221 | DD | │ | Vertical line (reverse) |

### Simple PETSCII Art Example

```basic
10 PRINT CHR$(147): REM Clear
20 PRINT "     ";CHR$(18);CHR$(230);CHR$(227);CHR$(227);CHR$(231);CHR$(146)
30 PRINT "    ";CHR$(18);CHR$(230);CHR$(160);CHR$(160);CHR$(160);CHR$(231);CHR$(146)
40 PRINT "    ";CHR$(18);CHR$(226);CHR$(160);CHR$(160);CHR$(160);CHR$(226);CHR$(146)
50 PRINT "     ";CHR$(18);CHR$(226);CHR$(160);CHR$(226);CHR$(146)
60 PRINT "     ";CHR$(18);CHR$(226);" ";CHR$(226);CHR$(146)
70 PRINT: PRINT "  A SIMPLE ROBOT"
```

## Troubleshooting and Common Issues

### Problem: Wrong characters displayed

**Cause:** Character set mode mismatch (UPPER vs LOWER).

**Solution:** Use `PRINT CHR$(142)` for UPPER/GRAPHICS or `PRINT CHR$(14)` for LOWER/UPPER mode.

### Problem: Colors not changing

**Cause:** Color codes must come before the text in PRINT statement.

**Wrong:** `PRINT "TEXT";CHR$(28)`

**Correct:** `PRINT CHR$(28)"TEXT"`

### Problem: Screen garbled after POKE

**Cause:** POKEing PETSCII codes directly to screen memory ($0400) displays wrong characters.

**Solution:** Use screen codes, not PETSCII codes. Convert first or use PRINT instead.

### Problem: Cursor positioning fails

**Cause:** Too many cursor movement codes or wrong calculation.

**Solution:** Use `PRINT CHR$(19)` to home cursor first, then move relative, or use direct POKE to screen memory.

### Problem: Custom characters not showing

**Cause:** VIC-II still pointing to ROM character set.

**Solution:** Ensure VIC register $D018 (53272) is set to point to RAM charset location.

## Memory Map Reference

### Screen Memory
- Default: $0400-$07E7 (1024-2023)
- 1000 bytes (40 columns × 25 rows)
- Stores screen codes (not PETSCII codes)

### Color Memory
- Fixed: $D800-$DBE7 (55296-56295)
- 1000 bytes (40 × 25)
- Lower 4 bits = color value (0-15)

### Character ROM
- $D000-$DFFF (53248-57343) when banked in
- 2 KB per character set
- Copy to RAM for custom characters

## PETSCII to ASCII Conversion

**Note:** No direct 1:1 mapping exists. Manual conversion required for specific characters.

### Common Conversions

| Character | PETSCII | ASCII |
|-----------|---------|-------|
| A-Z | 65-90 | 65-90 |
| a-z | 97-122 | 97-122 |
| 0-9 | 48-57 | 48-57 |
| Space | 32 | 32 |
| Return | 13 | 13 |
| £ | 92 | 163 |
| ↑ | 94 | 94 (caret in ASCII) |
| ← | 95 | 95 (underscore in ASCII) |

**Graphics characters** (codes 96-127, 160-223, 224-255) have no ASCII equivalents.

## Summary Quick Reference

### Essential Control Codes
- `CHR$(147)` - Clear screen
- `CHR$(19)` - Home cursor
- `CHR$(18)` - Reverse video ON
- `CHR$(146)` - Reverse video OFF
- `CHR$(14)` - Lowercase mode
- `CHR$(142)` - Uppercase mode

### Essential Colors
- `CHR$(144)` - Black
- `CHR$(5)` - White
- `CHR$(28)` - Red
- `CHR$(30)` - Green
- `CHR$(31)` - Blue
- `CHR$(158)` - Yellow

### Cursor Movement
- `CHR$(17)` - Down
- `CHR$(145)` - Up
- `CHR$(29)` - Right
- `CHR$(157)` - Left

### Function Keys (GET/ASC)
- F1=133, F2=137, F3=134, F4=138
- F5=135, F6=139, F7=136, F8=140

## Additional Resources

- Full character ROM dumps available in `c64prg.txt` Appendix C
- Screen code tables in Appendix B
- Complete VIC-II register documentation in Appendix G
- Keyboard matrix scanning details in I/O chapter

## Usage Notes

1. **Always clear screen before complex graphics:** `PRINT CHR$(147)`
2. **Set colors before printing text:** `PRINT CHR$(28)"RED"`
3. **Use reverse video for solid blocks:** `CHR$(18);CHR$(160);CHR$(146)`
4. **Test on real hardware or accurate emulator:** Some emulators may display PETSCII incorrectly
5. **Mind the 80-column editor limit:** Long PRINT statements may wrap awkwardly
6. **Screen memory is screen codes, not PETSCII:** Convert before POKEing directly

---