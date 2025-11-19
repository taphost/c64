# Commodore 64 BASIC V2 — LLM Constraints

Purpose: constrain code generation to C64 BASIC V2 (Microsoft BASIC 6502). Do not use keywords/syntax from other BASIC dialects.

## Overview

- Support files for the C64 Programmer's Reference Guide and the Mapping The Commodore 64 etexts (project 64) housed under `docs`.
- Key references: `docs/c64prg.txt` + `docs/TOC1.md` for the main Programmer's Reference Guide, and `docs/mapping-c64.txt` + `docs/TOC2.md` for the memory map companion.
- External references: `SID.md` (sound), `PETSCII.md` (character codes), `MEMORY.md` (memory map), `IO.md` (devices), `KERNAL.md` (OS routines), `VIC.md` (graphics), `6502.md` (CPU/ML).
- Goal: give quick guidance to keep an LLM constrained to C64 BASIC V2 only.
- Use full keywords (no keyboard abbreviations/shorthand tokens).
- Comments/text: use ASCII only (no accented or non-ASCII characters) for maximum compatibility.

## Allowed keywords (token set)

Allowlist (BASIC V2): `ABS AND ASC ATN CHR$ CLOSE CLR CMD CONT COS DATA DEF DIM END EXP FN FOR FRE GET GET# GOSUB GOTO IF INPUT INPUT# INT LEFT$ LEN LET LIST LOAD LOG MID$ NEW NEXT NOT ON OPEN OR PEEK POKE POS PRINT PRINT# READ REM RESTORE RETURN RIGHT$ RND RUN SAVE SGN SIN SPC( SQR STATUS STEP STOP STR$ SYS TAB( TAN THEN TIME TIME$ TO USR VAL VERIFY WAIT`.

## System variables (read-only in BASIC)

- **`TI`** (or `TIME`): Timer in jiffies (1/60 sec NTSC, 1/50 PAL); read with `PRINT TI`. This counter is updated by the KERNAL and cannot be assigned directly.
- **`TI$`** (or `TIME$`): Timer as string "HHMMSS"; you can both read it (`PRINT TI$`) and set it (e.g., `TI$="000000"`) to redefine the jiffy clock baseline.
- **`ST`** (or `STATUS`): I/O status byte; read immediately after I/O operations; 0=OK, nonzero=error/EOF. Subsequent I/O calls overwrite `ST`, so capture it before performing more reads/writes.
- **Disk status string**: Open channel 15 on the disk drive (`OPEN 15,8,15`) and read the status with `INPUT#15,EN,DS$,TR,SE`; `DS$` is an ordinary string variable that you populate from the error channel.
- **I/O tables**: le posizioni 601-630 contengono le LAT/FAT/SAT (logical file/device/secondary) e 631-640 la coda tastiera; 198 riporta quanti caratteri sono in attesa e, se riempi i 10 slot con PETSCII e aggiorni 198, puoi simulare sequenze di tasti prima del prossimo `GET`/`INPUT` (Mapping cap. 3).

## Operators

Arithmetic: `+`, `-`, `*`, `/`, `^` (power). Relational: `=`, `<`, `>`, `<=`, `>=`, `<>`. Logical: `AND`, `OR`, `NOT` (bitwise on integers). String: `+` (concatenation).

## Denylist (not in C64 BASIC V2)

`ELSE`, `ELSEIF`, `ENDIF`, `WHILE`, `WEND`, `DO`, `LOOP`, `REPEAT`, `UNTIL`, `SELECT`, `CASE`, `MOD`, `INSTR`, `LOCATE`, `CLS` (as a command; clear screen via `PRINT CHR$(147)`), `WINDOW`, `SCREEN`, `CIRCLE`, `LINE`, `PAINT`, `SOUND`, `PLAY`, `TIMER` (as a command), label-based `GOTO/GOSUB`, `PRINT USING`, `INPUT$(n)` (not present), integer `%` or double `#` suffixes, `INKEY$` (nonexistent).

## Syntax and flow

- Numbered lines (0–63999). Multiple statements per line via `:`.
- `IF <expr> THEN <stmt>` (single statement or multiple via `:`). No `ELSE`.
- Loops: `FOR var = start TO end [STEP s] ... NEXT var`. Limit re-evaluated each iteration.
- Branches: `GOTO`, `GOSUB/RETURN`, `ON <expr> GOTO/GOSUB`.
- Stop: `STOP`, `END`. `WAIT` to sync on I/O.
- `RESTORE` has no argument; it resets the DATA pointer to the first DATA encountered. To jump to later data, `RESTORE` then `READ` past the items you need to skip.
- `RUN` alone restarts from lowest line; `RUN <line>` starts from specified line.

## Types and values

- Numbers: 5-byte floating point; no distinct integer type; no hex literal syntax.
- Strings: `$` suffix; arrays via `DIM`. No in-place modification (e.g., `MID$(A$,2,1)="X"` invalid). `LEFT$/MID$/RIGHT$` allocate new strings.
- Booleans: true = -1 (all bits set), false = 0.
- String concatenation with `+`; no `MOD` operator (use `A-INT(A/B)*B`); `AND/OR/NOT` operate on numbers bitwise.
- Arrays: single or multi-dimensional via `DIM A(10)` or `DIM B(4,5)`. Indices start at 0.

## I/O and devices

- Standard devices: 0 (screen/keyboard), 1 (tape), 2 (RS-232), 3 (screen editor), 4 (printer), 8–15 (disk).
- Files/channels: `OPEN <file#>,<device>[,<secondary>[,<command>]]`; use `PRINT#`, `INPUT#`, `GET#`, `CLOSE`.
- Load/save: `LOAD "NAME",<device>[,1]` (,1=non-relocate); `SAVE "NAME",<device>` (append ,1 for end address); `VERIFY` with device.
- Disk commands via channel 15: `OPEN 15,8,15:PRINT#15,"I":CLOSE 15` (initialize); `INPUT#15,A,B$,C,D` reads status (A=error code, B$=message).
- Tape: `OPEN 1,1,0,"NAME"` (read), `OPEN 1,1,1,"NAME"` (write), `OPEN 1,1,2,"NAME"` (write and append end-of-tape marker).
- No high-level graphics/sound commands: use `POKE`/`SYS` against VIC-II/SID or KERNAL.
- See `IO.md` for complete device details, disk DOS commands, CIA registers, joystick/paddle reading.
- RS-232 channels (device 2) allocano automaticamente due buffer da 256 byte all’apertura, eseguono un `CLR` e liberano i loro slot all’atto del `CLOSE`; apri il canale PRIMA di definire variabili, leggi `RIBUF/ROBUF` ($F7/$F9) e ricorda che `ST` viene aggiornato a ogni operazione, quindi leggi il byte di stato subito dopo l’I/O che ti interessa (Mapping cap. 6). Per manipolare singoli flag usa la sequenza familiare di bit 1,2,4,8,16,32,64,128 via `POKE`/`PEEK`.

## Error handling

- No structured error handling in BASIC V2. Errors halt execution unless trapped via KERNAL vectors (advanced).
- Read error code: `E=PEEK(195)` (0=no error); clear with `POKE 195,0`.
- `ST` variable holds I/O status after file operations (0=OK, 64=EOF, 128=timeout, etc.).

## Limits and notes

- Clear screen with `PRINT CHR$(147)` or `SYS 58640`.
- System time: `TI` (ticks) and `TI$` (HHMMSS).
- Comments only with `REM`.
- Variables: first two characters are significant; `$` suffix for strings only; no `%`/`#` suffixes in V2; arrays require `DIM`.
- String/memory quirks: string heap separate from numeric vars; `MID$/LEFT$/RIGHT$` allocate new strings (no in-place); heavy concatenation can fragment memory; `FRE(0)` can be negative—add 65536 if needed.
- Limits: strings max 255 chars; program text starts at $0801 by default; logical line length limit ~2 KB (editor shows 80 columns).
- Keep logical lines within ~80 characters if possible; use `:` to split but beware editability on real C64 when exceeding the 80-column editor view.

### Memory layout reminders
- Zero page ($0000-$00FF) è la zona più veloce: la porta 6510 in $0000/$0001 controlla i bit LORAM/HIRAM/CHAREN (più cassette) per selezionare ROM o RAM, mentre $02-$8F sono occupati da BASIC e $FB-$FE rimangono liberi per routines ML rapide (Mapping cap. 1).
- Lo stack hardware ($0100-$01FF) serve a FOR/NEXT (18 byte), GOSUB (5 byte), IRQ e conversioni floating-point; i blocchi $100-$10A e $100-$13E sono riservati a conversioni e tape BAD log, quindi monitora sempre il limite 256 per evitare overflow/underflow (Mapping cap. 2).
- Screen RAM predefinita (1024-2047) contiene la matrice video e gli 8 puntatori sprite (2040-2047); il VIC bank select in $D018 decide la location effettiva, color RAM a $D800 è indipendente e non aumenta `FRE(0)` (Mapping cap. 4).

## Usage

- When generating code: use only allowlist tokens, respect denylist, number lines, use `:` where helpful.
- Do not introduce "modern" syntax or commands from BASIC 3.5/4.0/7.0, Amiga, QuickBASIC, VB, etc.

## External references

- **SID sound programming**: see `SID.md` for complete register map, note tables, ADSR envelopes, waveforms, examples.
- **PETSCII character codes**: see `PETSCII.md` for control codes, screen codes, colors, cursor movement, graphics characters.
- **Memory map and banking**: see `MEMORY.md` for complete $0000-$FFFF layout, zero page, I/O areas, VIC banks, safe RAM locations.
- **I/O devices and ports**: see `IO.md` for disk commands, tape, RS-232, CIA1/CIA2 registers, joystick/paddle reading.
- **KERNAL routines**: see `KERNAL.md` for OS entry points, file I/O, vectors, screen functions, ML integration.
- **VIC-II graphics**: see `VIC.md` for screen/sprite control, bitmap modes, scrolling, colors, collision detection.
- **6502/6510 CPU**: see `6502.md` for instruction set, addressing modes, registers, ML programming, cycle timing.

## Screen/cursor control primitives

- Clear screen: `PRINT CHR$(147)` (shift-CLR/HOME code) or `SYS 58640` (KERNAL clear routine).
- Home cursor: `PRINT CHR$(19)`.
- Position cursor: `POKE 781,Y:POKE 782,X:SYS 65520` (X=col 0–39, Y=row 0–24). `SYS 65520` is KERNAL PLOT.
- Screen memory: default text at $0400 (1024), 40×25; color RAM at $D800. Character at `1024+Y*40+X` shows screen code (not PETSCII); color at `55296+Y*40+X`.
- Simple blink using editor cursor: place at center and let editor blink; or toggle a char with space using `TI` for timing.

## Commodore shortcut table

| Key | SHIFT shortcut | Commodore logo shortcut |
|-----|----------------|--------------------------|
| A | PRINT | PRINT# |
| B | AND | OR |
| C | CHR$ | ASC |
| D | READ | DATA |
| E | GET | END |
| F | FOR | NEXT |
| G | GOSUB | RETURN |
| H | TO | STEP |
| I | INPUT | INPUT# |
| J | GOTO | ON |
| K | DIM | RESTORE |
| L | LOAD | SAVE |
| M | MID$ | LEN |
| N | INT | RND |
| O | OPEN | CLOSE |
| P | POKE | PEEK |
| Q | TAB( | SPC( |
| R | RIGHT$ | LEFT$ |
| S | STR$ | VAL |
| T | IF | THEN |
| U | TAN | SQR |
| V | VERIFY | CMD |
| W | DEF | FN |
| X | LIST | FRE |
| Y | SIN | COS |
| Z | RUN | SYS |

Consult Mapping Appendix A/B if you need to reproduce these shortcut key sequences as part of a macro or tutorial.

## Essential CHR$ codes (PETSCII)

| Code | Function | Usage |
|------|----------|-------|
| 5 | White text | `PRINT CHR$(5)` |
| 13 | Return/newline | `PRINT CHR$(13)` |
| 17 | Cursor down | `PRINT CHR$(17)` |
| 18 | Reverse on | `PRINT CHR$(18)` |
| 19 | Home cursor | `PRINT CHR$(19)` |
| 28 | Red text | `PRINT CHR$(28)` |
| 29 | Cursor right | `PRINT CHR$(29)` |
| 30 | Green text | `PRINT CHR$(30)` |
| 31 | Blue text | `PRINT CHR$(31)` |
| 144 | Black text | `PRINT CHR$(144)` |
| 145 | Cursor up | `PRINT CHR$(145)` |
| 146 | Reverse off | `PRINT CHR$(146)` |
| 147 | Clear screen | `PRINT CHR$(147)` |
| 157 | Cursor left | `PRINT CHR$(157)` |
| 158 | Yellow text | `PRINT CHR$(158)` |
| 159 | Cyan text | `PRINT CHR$(159)` |

See `PETSCII.md` for complete 256-code table and graphics characters.

## Joystick reading (practical example)

```basic
10 J=PEEK(56320):REM Port 2 ($DC00)
20 IF J AND 16=0 THEN PRINT "FIRE"
30 IF J AND 1=0 THEN PRINT "UP"
40 IF J AND 2=0 THEN PRINT "DOWN"
50 IF J AND 4=0 THEN PRINT "LEFT"
60 IF J AND 8=0 THEN PRINT "RIGHT"
70 GOTO 10
```

Port 1 at 56321 ($DC01). Bits inverted: 0=pressed. Combine with `AND` for diagonals. See `IO.md` for complete details.

## PEEK/POKE memory anchors

Complete memory map in `MEMORY.md`. Key locations:

- Address range 0–65535; values 0–255. I/O area at $D000–$DFFF is register space (not RAM). Color RAM at $D800 is 4-bit wide (upper nybble ignored).
- VIC-II registers: $D000–$D02E (sprite/screen control). See `VIC.md`.
- SID registers: $D400–$D418 (sound). See `SID.md`.
- CIA1 at $DC00 (keyboard/joysticks/timers), CIA2 at $DD00 (serial, VIC bank select). See `IO.md`.
- Memory banking via $0001 (processor port): bit 0=LORAM (BASIC ROM), bit 1=HIRAM (Kernal ROM), bit 2=CHAREN (I/O vs char ROM), bits 3-5 handle cassette/direction. Use `POKE 1,PEEK(1) AND ...` to swap banks without losing workspace (Mapping cap. 1, `MEMORY.md`).
- Screen: $0400–$07FF (default, 1000 bytes). Color RAM: $D800–$DBE7 (1000 bytes, fixed location).
- Zero page: $00–$FF (fast access, mostly system reserved). See `MEMORY.md` for safe locations.
- Safe RAM for ML: $C000–$CFFF (4KB generalmente libero ma spesso usato da wedge/cartridge—verifica prima di sovrascrivere) e il buffer cassetta $033C–$03FB (192 byte) se la Datassette non è in uso.

## KERNAL routine anchors (via SYS)

Key entry points (see `KERNAL.md` for complete list):

- `CHROUT` $FFD2 (65490): Output character
- `CHRIN` $FFCF (65487): Input character  
- `GETIN` $FFE4 (65508): Get character (no wait)
- `PLOT` $FFF0 (65520): Set/get cursor position
- `OPEN` $FFC0 (65472): Open file
- `CLOSE` $FFC3 (65475): Close file
- `LOAD` $FFD5 (65493): Load file
- `SAVE` $FFD8 (65496): Save file
- `CINT` $FF81 (65409): Initialize screen
- `CLRCHN` $FFCC (65484): Clear I/O channels

Call via `SYS <decimal address>` from BASIC; prefer BASIC I/O unless a routine is needed. See `KERNAL.md` for register conventions and ML integration.

## Graphics and sprites (VIC-II)

No high-level commands in BASIC V2. Use POKE to VIC-II registers at $D000–$D02E.

**Key registers:**
- $D000–$D00F: Sprite X/Y positions (8 sprites)
- $D015: Sprite enable (bits 0-7)
- $D020: Border color
- $D021: Background color
- $D027–$D02E: Sprite colors

**Screen modes:**
- Character mode (default): 40×25 text
- Bitmap mode: enable via $D011 bit 5
- Multicolor: enable via $D016 bit 4

See `VIC.md` for complete register details, sprite setup, bitmap programming, scrolling.

## Sound programming (SID)

No SOUND/PLAY commands in BASIC V2. Use POKE to SID registers at $D400–$D418.

**Basic sound:**
```basic
10 POKE 54296,15: REM Volume
20 POKE 54277,9: POKE 54278,0: REM ADSR
30 POKE 54272,152: POKE 54273,12: REM Frequency
40 POKE 54276,33: REM Sawtooth + gate
50 FOR T=1 TO 500: NEXT
60 POKE 54276,32: REM Gate off
```

See `SID.md` for complete register map, note tables, waveforms, filters, examples.

## Machine language integration

6502/6510 CPU. Call ML via `SYS <address>`.

**Simple ML routine:**
```basic
10 REM ML at $C000 (49152)
20 FOR I=0 TO 5
30   READ B: POKE 49152+I,B
40 NEXT
50 SYS 49152
60 DATA 169,5,141,33,208,96: REM LDA #5, STA $D021, RTS
```

See `6502.md` for instruction set, addressing modes, registers, code patterns, cycle timing.

## Math and constants

- Built-in math functions only (see allowlist). `PI` is not a constant; use approximation (e.g., 3.14159265).
- `RND(1)` seeded from TI; `RND(0)` repeats last; `RND(-n)` reseeds with n.
- No `MOD`; use `A-INT(A/B)*B` for modulo.

## BASIC error messages (BASIC V2 set)

`BAD DATA`, `BAD SUBSCRIPT`, `BREAK`, `CAN'T CONTINUE`, `DEVICE NOT PRESENT`, `DIVISION BY ZERO`, `EXTRA IGNORED`, `FILE NOT FOUND`, `FILE NOT OPEN`, `FILE OPEN`, `FORMULA TOO COMPLEX`, `ILLEGAL DIRECT`, `ILLEGAL QUANTITY`, `LOAD`, `NEXT WITHOUT FOR`, `NOT INPUT FILE`, `NOT OUTPUT FILE`, `OUT OF DATA`, `OUT OF MEMORY`, `OVERFLOW`, `REDIM'D ARRAY`, `REDO FROM START`, `RETURN WITHOUT GOSUB`, `STRING TOO LONG`, `?SYNTAX ERROR`, `TYPE MISMATCH`, `UNDEF'D FUNCTION`, `UNDEF'D STATEMENT`, `VERIFY`.

## Quick reference summary

**Constraints:** Use only BASIC V2 keywords from allowlist; no modern syntax.  
**External docs:** SID.md, PETSCII.md, MEMORY.md, IO.md, KERNAL.md, VIC.md, 6502.md provide complete hardware/software details.  
**Graphics/Sound:** No high-level commands; use POKE to VIC-II ($D000) and SID ($D400).  
**Screen:** Clear with `PRINT CHR$(147)`; cursor control via `CHR$(19/17/145/29/157)`.  
**I/O:** Device 0=keyboard, 1=tape, 4=printer, 8=disk; use OPEN/CLOSE/PRINT#/INPUT#.  
**ML:** Call via SYS; see KERNAL.md and 6502.md for integration.

---

**Complete C64 BASIC V2 reference suite:**  
`API.md` (this file) + `SID.md` + `PETSCII.md` + `MEMORY.md` + `IO.md` + `KERNAL.md` + `VIC.md` + `6502.md`
