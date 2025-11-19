# Commodore 64 Programmer's Reference Guide (etext) – API Summary

Reference: `../docs/c64prg.txt` (Project 64 etext of the C64 Programmer's Reference Guide, ~1983 first edition).

## 1. Overview of the C64 & BASIC V2
- Hardware tour, memory layout basics, power‑up behavior, and built‑in ROMs.  
- BASIC V2 recap: program entry, editing, program storage (tape/disk), and simple programming techniques (INPUT/GET, data conversions, program “crunching”).

## 2. BASIC Language Vocabulary
- Complete BASIC keyword dictionary with abbreviations, token types, and examples.  
- Quick list + alphabetical details for statements, functions, and operators.  
- Keyboard layout, screen editor behavior, and commodity key features (commodore key, control, etc.).

## 3. Graphics Programming
- VIC‑II overview: character mode, bitmap modes (hi‑res, multicolor), sprites.  
- Video memory banks, screen/color/character memory locations, and how to relocate them.  
- Character sets and programmable characters; multicolor mode bits and use.  
- Bitmap setup and addressing; smooth scrolling registers.  
- Sprites: definition, pointers, enable/disable, colors, multicolor sprites, expansion, positioning/timing, priority, and collision detection.  
- Applied sprite programming examples and optimization (“crunching”) tips.

## 4. Sound & Music (SID 6581)
- SID register map essentials: volume, frequency generation, and voices.  
- Using multiple voices, waveform control (triangle/sawtooth/pulse/noise), envelope generator (ADSR), filters, and advanced techniques (sync/ring‑mod).  
- Practical examples of voice control and waveform shaping.

## 5. BASIC to Machine Language
- 6510/6502 primer: instruction format, sample memory map, CPU registers, hex notation, addressing modes (immediate, zero page, stack, indexed, indirect), branches, subroutines.  
- Writing/entering ML programs (with 64MON monitor); first programs and workflow.  
- Instruction set: alphabetic list, addressing modes, execution times.  
- Memory management strategies and working with BASIC/ML together (where to place routines, calling ML from BASIC).  
- KERNAL: power‑up sequence, calling conventions, key entry points, and error codes.  
- Full C64 memory map plus I/O register assignments.

## 6. Input/Output Guide
- TV/monitor output options; routing output to printer or modem.  
- Tape/disk storage usage from BASIC (open/save/load) and device commands.  
- Game port devices: joysticks, paddles, light pen.  
- RS‑232 interface: opening channels, send/receive, buffers, zero‑page usage, sample BASIC programs.  
- User port pinout and usage; serial bus and expansion port pinouts.  
- Z‑80 cartridge/CP‑M usage notes.

## Appendices (A–P)
- A: BASIC keyword abbreviations.  
- B: Screen display codes.  
- C: ASCII and `CHR$` codes.  
- D: Screen/color memory maps.  
- E: Music note values.  
- F: Bibliography.  
- G: VIC‑II register map.  
- H: Deriving math functions.  
- I: I/O device pinouts.  
- J: Converting standard BASIC to C64 BASIC.  
- K: Error messages.  
- L: 6510 chip specifications.  
- M: 6526 CIA specifications.  
- N: 6566/6567 VIC‑II specs.  
- O: 6581 SID specs.  
- P: Glossary.

## Other Material
- Index.  
- Commodore 64 quick reference card.  
- (Original book) schematic diagram reference (schematics not included in the etext).
