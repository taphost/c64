# Commodore 64 BASIC V2 — LLM Constraints

Purpose: constrain code generation to C64 BASIC V2 (Microsoft BASIC 6502). Do not use keywords/syntax from other BASIC dialects.

Overview :
- Support files for the C64 Programmer's Reference Guide (Project 64 etext).
- Key references: `docs/c64prg.txt` (full etext), `docs/TOC.md` (contents), `SID.md` (SID note values), this `API.md` (token allowlist/constraints).
- Goal: give quick guidance to keep an LLM constrained to C64 BASIC V2 only.
- Use full keywords (no keyboard abbreviations/shorthand tokens).
- Comments/text: use ASCII only (no accented or non-ASCII characters) for maximum compatibility.

## Allowed keywords (token set)
Allowlist (BASIC V2): `ABS AND ASC ATN CHR$ CLOSE CLR CMD CONT COS DATA DEF DIM END EXP FN FOR FRE GET GET# GOSUB GOTO IF INPUT INPUT# INT LEFT$ LEN LET LIST LOAD LOG MID$ NEW NEXT NOT ON OPEN OR PEEK POKE POS PRINT PRINT# READ REM RESTORE RETURN RIGHT$ RND RUN SAVE SGN SIN SPC( SQR STATUS STEP STOP STR$ SYS TAB( TAN THEN TIME TIME$ TO USR VAL VERIFY WAIT`.

## System variables (read-only in BASIC)
- **`TI`** (or `TIME`): Timer in jiffies (1/60 sec NTSC, 1/50 PAL); read with `PRINT TI`; writable with `TI=0` to reset.
- **`TI$`** (or `TIME$`): Timer as string "HHMMSS"; read-only; set via `TI=0` then wait.
- **`ST`** (or `STATUS`): I/O status byte; read after I/O operations; 0=OK, nonzero=error/EOF.
- **`DS$`**: Disk status string (device 8); read via `INPUT#15,A,B$,C,D:DS$=B$` after opening channel 15.

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
- Tape: `OPEN 1,1,1,"NAME"` (read), `OPEN 1,1,0,"NAME"` (write).
- No high-level graphics/sound commands: use `POKE`/`SYS` against VIC-II/SID or KERNAL.

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

## Usage
- When generating code: use only allowlist tokens, respect denylist, number lines, use `:` where helpful.
- Do not introduce "modern" syntax or commands from BASIC 3.5/4.0/7.0, Amiga, QuickBASIC, VB, etc.

## Handy primitives (screen/cursor/editor)
- Clear screen: `PRINT CHR$(147)` (shift-CLR/HOME code) or `SYS 58640` (KERNAL clear routine).
- Home cursor: `PRINT CHR$(19)`.
- Position editor cursor: `POKE 781,Y:POKE 782,X:SYS 58640` (X=col 0–39, Y=row 0–24). `SYS 58640` recalculates cursor address.
- Screen memory: default text at $0400 (1024), 40×25; color RAM at $D800. Character at `1024+Y*40+X` shows PETSCII; color at `55296+Y*40+X`.
- Simple blink using editor cursor: place at center and let editor blink; or toggle a char with space using `TI` for timing.
- KERNAL CHROUT: `SYS 65490` (dec) / `$FFD2` in ML; in BASIC prefer `PRINT`/`PRINT#` unless special output is needed.

## CHR$ / PETSCII codes (essential)
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
| 129 | Orange text | `PRINT CHR$(129)` |
| 144 | Black text | `PRINT CHR$(144)` |
| 145 | Cursor up | `PRINT CHR$(145)` |
| 146 | Reverse off | `PRINT CHR$(146)` |
| 147 | Clear screen | `PRINT CHR$(147)` |
| 149 | Brown text | `PRINT CHR$(149)` |
| 150 | Lt red text | `PRINT CHR$(150)` |
| 151 | Grey 1 text | `PRINT CHR$(151)` |
| 152 | Grey 2 text | `PRINT CHR$(152)` |
| 153 | Lt green text | `PRINT CHR$(153)` |
| 154 | Lt blue text | `PRINT CHR$(154)` |
| 155 | Grey 3 text | `PRINT CHR$(155)` |
| 156 | Purple text | `PRINT CHR$(156)` |
| 157 | Cursor left | `PRINT CHR$(157)` |
| 158 | Yellow text | `PRINT CHR$(158)` |
| 159 | Cyan text | `PRINT CHR$(159)` |

## Joystick reading (practical example)
```basic
10 J=PEEK(56320):REM Port 2 ($DC00)
20 IF J=127 THEN PRINT "FIRE"
30 IF J=126 THEN PRINT "UP"
40 IF J=125 THEN PRINT "DOWN"
50 IF J=123 THEN PRINT "LEFT"
60 IF J=119 THEN PRINT "RIGHT"
70 GOTO 10
```
Port 1 at 56321 ($DC01). Bits inverted: 0=pressed. Combine with `AND` for diagonals (e.g., `J AND 14` masks up/down/left/right).

## PEEK/POKE notes (memory/I/O anchors)
- Address range 0–65535; values 0–255. I/O area at $D000–$DFFF is register space (not RAM). Color RAM at $D800 is 4-bit wide (upper nybble ignored).
- VIC-II registers: $D000–$D02E (mirrored to $D3FF). Default screen/charset bank is bank 0 ($0000–$3FFF). Bank selection via CIA2 at $DD00 bits 0–1 (00=$0000–$3FFF, 01=$4000–$7FFF, 10=$8000–$BFFF, 11=$C000–$FFFF).
- CIA1 registers at $DC00 (keyboard/joysticks/timers), CIA2 at $DD00 (serial, VIC bank select, timers).
- SID at $D400–$D418; VIC-II and SID share I/O space—PEEK/POKE only documented registers.
- Memory map (high level): BASIC RAM from $0801 upward; screen $0400; I/O $D000–$DFFF; KERNAL ROM $E000–$FFFF; BASIC ROM $A000–$BFFF; character ROM $D000–$DFFF when banked in (not directly POKEable).
- Do not POKE $0001 (processor port) unless intentionally banking ROM/I/O; wrong values can crash or hide I/O.

## PETSCII essentials (screen control)
- Clear: `CHR$(147)`; Home: `CHR$(19)`; Cursor down/up/right/left: `CHR$(17)/CHR$(145)/CHR$(29)/CHR$(157)`; Reverse on/off: `CHR$(18)/CHR$(146)`.
- Screen is PETSCII, not ASCII; graphic characters depend on character set in use.
- Colors: see CHR$ table above for text color codes (5=white, 28=red, 30=green, 31=blue, etc.).

## Screen layout
- 40×25 text; screen RAM default $0400, color RAM $D800. Offsets: screen `1024+Y*40+X`, color `55296+Y*40+X`.
- VIC-II screen/charset base can move; if relocated, adjust addresses accordingly.

## External tables
- SID note values and control reminder: see `SID.md` (Appendix E extract, with control/gate hints).

## KERNAL routine anchors (via SYS)
- `CHRIN` $FFCF (65487), `CHROUT` $FFD2 (65490), `PLOT` $FFF0 (65520), `CLR/HOME` $E544 (58660), `OPEN` $FFC0, `CLOSE` $FFC3, `CHKIN` $FFC6, `CHKOUT` $FFC9, `CLRCHN` $FFCC, `READST` $FFB7.
- Call via `SYS <decimal address>` from BASIC; prefer BASIC I/O unless a routine is needed.

## BASIC error messages (BASIC V2 set)
`BAD DATA`, `BAD SUBSCRIPT`, `BREAK`, `CAN'T CONTINUE`, `DEVICE NOT PRESENT`, `DIVISION BY ZERO`, `EXTRA IGNORED`, `FILE NOT FOUND`, `FILE NOT OPEN`, `FILE OPEN`, `FORMULA TOO COMPLEX`, `ILLEGAL DIRECT`, `ILLEGAL QUANTITY`, `LOAD`, `NEXT WITHOUT FOR`, `NOT INPUT FILE`, `NOT OUTPUT FILE`, `OUT OF DATA`, `OUT OF MEMORY`, `OVERFLOW`, `REDIM'D ARRAY`, `REDO FROM START`, `RETURN WITHOUT GOSUB`, `STRING TOO LONG`, `?SYNTAX ERROR`, `TYPE MISMATCH`, `UNDEF'D FUNCTION`, `UNDEF'D STATEMENT`, `VERIFY`.

## 6510/6502 basics (for SYS/ML interop)
- Registers: A (accumulator), X/Y (index), SP stack pointer ($0100–$01FF stack), PC program counter, P status flags (NV-BDIZC).
- Addressing modes: immediate `#$nn`, zero page `$nn`, absolute `$nnnn`, indexed X/Y, indirect `(addr)`, indexed indirect `(zp,X)`, indirect indexed `(zp),Y`, relative branches, accumulator.
- Stack: grows down from $01FF; `JSR` pushes return-1; `RTS` adds 1 then returns.
- Reset/IRQ/NMI vectors at $FFFC/$FFFE/$FFFA. BASIC start at $0801; KERNAL ROM $E000+, BASIC ROM $A000+, character ROM banked at $D000.
- `SYS <addr>` jumps with A/X/Y preserved from BASIC (X=lo, Y=hi of next BASIC text address). Save/restore registers appropriately.

## KERNAL entry points (common)
- I/O: `OPEN` $FFC0, `CLOSE` $FFC3, `CHKIN` $FFC6, `CHKOUT` $FFC9, `CLRCHN` $FFCC, `CHRIN` $FFCF, `CHROUT` $FFD2, `GETIN` $FFE4, `READST` $FFB7.
- Keyboard: `SCNKEY` $FF9F, `GETIN` $FFE4.
- Screen: `PLOT` $FFF0 (get/set cursor), `SCREEN` $FFED (read screen mode), `SETMSG` $FF90 (toggle error messages).
- System: `RESTOR` $FF8A (restore vectors), `SETLFS` $FFBA, `SETNAM` $FFBD, `LOAD` $FFD5, `SAVE` $FFD8.
- Vectors: editable at $0300 (IRQ), $0314 (CINV), $0316 (CBINV/BREAK), etc.
- Call via `SYS <decimal address>` from BASIC; set filename/LFS with `SETNAM/SETLFS` before `LOAD/SAVE` if used.

## Device I/O specifics
- Devices: 0 screen/keyboard, 1 tape, 2 RS-232, 3 screen editor, 4 printer, 8–15 disk.
- Secondary address (SA): 0 data, 1 command channel (15) for disk; RS-232 uses SA for baud/parity.
- Tape: `OPEN 1,1,1,"FILENAME"` (read), `OPEN 1,1,0,"FILENAME"` (write); `PRINT#1` to write, `INPUT#1` to read; `LOAD "NAME",1`, `SAVE "NAME",1`.
- Disk: `OPEN 8,8,sa,"NAME"`; command channel: `OPEN 15,8,15` then `PRINT#15,"I"` etc.; `LOAD "NAME",8`, `SAVE "NAME",8`; `VERIFY "NAME",8`.
- RS-232: set via `OPEN f,2,sa,"baud,parity,stop,width"`; use `PRINT#/INPUT#/GET#`; buffers at zero/nonzero pages per PRG.
- Joysticks: CIA1 port A/B at $DC00/$DC01; paddles POTX/POTY via SID $D419/$D41A; light pen via VIC $D013/$D014.
- User/expansion/serial ports: pinouts in PRG Appendix I; use per-hardware specs.

## Math and constants
- Built-in math functions only (see allowlist). `PI` is not a constant; use approximation (e.g., 3.14159265).
- `RND(1)` seeded from TI; `RND(0)` repeats last; `RND(-n)` reseeds with n.
- No `MOD`; use `A-INT(A/B)*B` for modulo.

## Character sets
- Default uppercase/graphics; lowercase/uppercase toggled via character ROM switch (`POKE 53272,23` for lower/upper if using bank 0 layout) and keyboard toggle keys.
- Custom charset: place 2 KB font in RAM aligned to 2048-byte boundary within current VIC bank; set pointer via $D018; ensure KERNAL screen editor (`POKE 648`) points to new screen if moved.

## Memory map (summary)
- $0000–$00FF zero page; $0100–$01FF stack; $0200–$02FF BASIC/KERNAL work; $0300–$03FF vectors; $0400–$07FF screen/bitmap if default bank; $0801–$9FFF BASIC program/vars; $A000–$BFFF BASIC ROM (banked out when not used); $C000–$CFFF RAM; $D000–$DFFF I/O/char ROM; $E000–$FFFF KERNAL ROM.
- VIC bank 16 KB selectable via CIA2 $DD00 bits 0–1; screen/charset/bitmap addresses are within the active bank.

## Music note values / tuning
- SID frequency: Freq = (clock * value) / 16777216. PAL clock ~0.985 MHz, NTSC ~1.023 MHz. Use note tables or compute accordingly (PRG Appendix E provides note values).
- SID gate/ADSR usage: set ADSR before raising Gate; use correct waveform bits (e.g., pulse=bit6, so Gate+Pulse=65, off=64 or 0). Clear control register between notes to let envelope release; leave Gate low long enough for release or you'll get continuous tone.

===============================================================================
HARDWARE REFERENCE (consult when needed)
===============================================================================

## 6502 instruction set (mnemonics & modes)
- Mnemonics: ADC, AND, ASL, BCC, BCS, BEQ, BIT, BMI, BNE, BPL, BRK, BVC, BVS, CLC, CLD, CLI, CLV, CMP, CPX, CPY, DEC, DEX, DEY, EOR, INC, INX, INY, JMP, JSR, LDA, LDX, LDY, LSR, NOP, ORA, PHA, PHP, PLA, PLP, ROL, ROR, RTI, RTS, SBC, SEC, SED, SEI, STA, STX, STY, TAX, TAY, TSX, TXA, TXS, TYA.
- Addressing: immediate (`#`), zero page, zero page,X/Y, absolute, absolute,X/Y, indirect (`(addr)`), indexed-indirect (`(zp,X)`), indirect-indexed (`(zp),Y`), accumulator (ASL/LSR/ROL/ROR), relative branches. Cycle counts depend on mode/branch (see PRG tables).

## Graphics anchors (VIC-II)
- Registers $D000–$D02E (mirrored to $D3FF). Key: sprite X/Y ($D000–$D00F), sprite enable $D015, sprite expand X $D01D / Y $D017, sprite priority $D01B, sprite multicolor $D01C, collision $D01E/$D01F, control $D011/$D016 (bitmap/char mode, scroll, multicolor enable), screen/charset pointers $D018, raster $D012 (+ bit7 of $D011).
- Video bank select via CIA2 $DD00 bits 0–1 (00=$0000–$3FFF, 01=$4000–$7FFF, 10=$8000–$BFFF, 11=$C000–$FFFF).
- Character mode: screen = 1000 bytes; charset = 2048 bytes. Pointers from $D018 within the current 16K bank.
- Bitmap modes: bitmap = 8000 bytes; enable via $D011 bit 5; multicolor via $D016 bit 4; bitmap base from $D018 within bank; colors from $D021–$D023 and color RAM.
- Colors: border $D020; background $D021; multicolor 1/2 $D022/$D023; color RAM $D800 (4-bit). Multicolor char mode uses shared colors + low 2 bits from color RAM per cell.
- Sprites: pointers in screen RAM (value*64 within bank); per-sprite color $D027–$D02E; shared multicolor $D025/$D026. No high-level sprite commands—define data (63 bytes) and set pointers/registers via POKE.
- Pixels: no high-level plot. High-res bitmap: 8×8 cells, 1 bit per pixel; multicolor bitmap: 2 bits per pixel, double-wide pixels. Use POKE into bitmap memory and set colors appropriately.

## SID quick anchors (sound)
- Base address: $D400 (54272). Per voice (1–3): FREQ LO/HI (+0/+1), PULSE LO/HI (+2/+3, 12-bit), CONTROL (+4), ADSR (+5/+6). Voice 2 offset +7, voice 3 offset +14.
- CONTROL bits (bit7..0): Noise, Pulse, Saw, Triangle, Test, Ring, Sync, Gate.
- Filter/volume: $D415 FC LO, $D416 FC HI (bits 0–2), $D417 resonance (bits 7–4) + filter routing (bits 3–0: ext/voice3/voice2/voice1), $D418 mode/volume (bits 0–3 volume 0–15; bit4 LP; bit5 BP; bit6 HP; bit7 voice3 off).
- Reads: $D419 POTX, $D41A POTY, $D41B OSC3 random/oscillator output, $D41C ENV3 envelope output.
- No high-level SOUND/PLAY commands: everything via `POKE` into SID registers.

## VIC-II register reference (summary)
- $D000–$D00F sprite X/Y; $D010 high X bits; $D011 control (bitmap/rows/scroll); $D012 raster; $D013/$D014 light pen; $D015 sprite enable; $D016 horiz control (scroll/multicolor/wide text).
- $D017 sprite Y expand; $D018 screen/charset pointers; $D019 IRQ flags; $D01A IRQ enable; $D01B sprite priority; $D01C sprite multicolor enable; $D01D sprite X expand; $D01E/$D01F collision; $D020 border; $D021 background; $D022/$D023 multicolors; $D024 extra bg for ECM; $D025/$D026 sprite shared multicolors; $D027–$D02E per-sprite colors.

## CIA register anchors (summary)
- CIA1 $DC00/$DC01 keyboard/joystick matrix; $DC02/$DC03 data direction; timers A/B $DC04–$DC0B; TOD $DC08–$DC0B; control $DC0E/$DC0F; interrupt $DC0D.
- CIA2 $DD00/$DD01 serial/user port; bits 0–1 select VIC bank; timers/TOD/control at $DD04–$DD0F; interrupt $DD0D.

## Device/port pinouts & RS-232 notes
- RS-232 buffers and pointers defined in PRG I/O appendix; use documented OPEN string for baud/parity/stop/width. Buffer base ptrs at zero/nonzero page as per appendix.
- Serial bus, user port, expansion port, game ports pinouts: see PRG Appendix I. Use care driving lines; respect hardware specs.

## Screen/CHR$/PETSCII codes (compressed ranges)
- Control: 0–31 (bell 7, backspace 20, return 13, home 19, clear 147 via CHR$). Space 32. Cursor/reverse codes listed above.
- Digits: '0'–'9' = 48–57. Uppercase 'A'–'Z' = 65–90 (default charset). Graphics/punctuation: 33–47,58–64,91–96,123–126; reverse/graphic glyphs 128–255 depend on charset/bank. Use PETSCII tables if exact glyph needed.

## Appendix anchors
- 6502 instruction list and addressing modes above; for cycle-precise timings see PRG tables.
- Math derivations (Appendix H) for trig/log approximations.
- Chip specs: Appendices L (6510), M (CIA), N (VIC-II), O (SID) for electrical/bit-level details.
- Note tables (Appendix E), screen/color/CHR$ tables (Appendices B/C/D), pinouts (Appendix I), quick reference/glossary in PRG. Use as needed.
- Instruction timing table (per addressing mode) lives in the PRG 6502 appendix—consult for cycle-accurate ML.
- RS-232 buffer layout and zero-page/nonzero-page pointers, plus serial/user/expansion port pinouts, are in Appendix I; refer there when driving hardware lines.
- Z-80/CP/M cartridge: supported via expansion port; see CP/M notes in the I/O chapter/appendix if targeting that environment.
