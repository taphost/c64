# C64LLM

C64LLM is a comprehensive reference suite designed to help LLMs generate code compatible with **Commodore 64 BASIC V2.0** and provide complete hardware/software documentation for C64 programming.

## Project Structure

```
C64LLM/
 ├── README.md         ← This file
 ├── API.md            ← Core constraints and quick reference
 ├── SID.md            ← Complete SID sound chip programming guide
 ├── PETSCII.md        ← PETSCII character codes and screen control
 ├── MEMORY.md         ← Memory map, banking, and safe RAM locations
 ├── IO.md             ← I/O devices, disk commands, and ports
 ├── KERNAL.md         ← KERNAL OS routines and ML integration
 ├── VIC.md            ← VIC-II graphics, sprites, and bitmap modes
 ├── 6502.md           ← 6502/6510 CPU instruction set and ML programming
 └── docs/
      ├── c64prg.txt   ← Commodore 64 Programmer's Reference Guide (full text)
      ├── mapping-c64.txt ← Project 64 etext of Mapping The Commodore 64 (memory map companion)
      ├── TOC1.md      ← Quick index for c64prg.txt navigation
      └── TOC2.md      ← Quick index for mapping-c64.txt navigation
```

## Purpose

This project provides a complete, modular reference suite for C64 programming:

- **API.md**: Primary constraints, BASIC V2 syntax rules, quick anchors, and references to specialized guides
- **SID.md**: Complete sound programming (registers, ADSR, waveforms, note tables, examples)
- **PETSCII.md**: Character encoding, screen codes, colors, cursor control, graphics
- **MEMORY.md**: Full memory map, banking, zero page, I/O areas, VIC banks
- **IO.md**: Device I/O, disk DOS commands, CIA registers, joystick/paddle reading
- **KERNAL.md**: OS entry points, file operations, vectors, screen functions
- **VIC.md**: Graphics programming, sprites, bitmap modes, scrolling, collision
- **6502.md**: CPU instruction set, addressing modes, ML code patterns, cycle timing

## File Organization

### Core Reference (API.md)

The main entry point containing:
- BASIC V2 keyword allowlist/denylist
- Syntax constraints and limitations
- Quick reference anchors (CHR$ codes, PEEK/POKE locations, KERNAL routines)
- Cross-references to all specialized guides

### Specialized Guides

Each guide provides complete, self-contained documentation:

1. **SID.md** - Sound Programming
   - Register map ($D400-$D418)
   - ADSR envelopes and waveforms
   - 96-note frequency table (C-0 to B-7)
   - Filters, ring modulation, sync
   - Practical examples and troubleshooting

2. **PETSCII.md** - Character Encoding
   - Complete 256-code table
   - Control codes (colors, cursor, screen)
   - Screen codes vs PETSCII codes
   - Graphics characters for ASCII art
   - Conversion functions and examples

3. **MEMORY.md** - Memory Layout
   - Complete $0000-$FFFF map
   - Memory banking configurations
   - Zero page usage and safe locations
   - VIC banks and memory requirements
   - Screen/color/sprite memory layout

4. **IO.md** - Input/Output
   - Device numbers (tape, disk, printer, RS-232)
   - Disk DOS commands and error codes
   - CIA1/CIA2 register maps
   - Joystick/paddle/light pen reading
   - Serial bus and user port

5. **KERNAL.md** - Operating System
   - Entry points ($FF00-$FFFF)
   - File operations (OPEN, CLOSE, LOAD, SAVE)
   - Screen functions (PLOT, CHROUT)
   - Vectors and interrupt handling
   - ML integration from BASIC

6. **VIC.md** - Graphics
   - VIC-II register map ($D000-$D02E)
   - Character and bitmap modes
   - Sprite programming (8 sprites, 24×21 pixels)
   - Colors, scrolling, collision detection
   - Memory pointers and bank switching

7. **6502.md** - CPU Programming
   - Complete instruction set (56 opcodes)
   - 13 addressing modes
   - Registers and status flags
   - Common code patterns
   - Cycle timing and optimization

## Why Modular Design

LLMs have context-window limits. This modular approach:
- **Reduces token usage**: Load only needed references
- **Improves accuracy**: Specialized guides prevent confusion
- **Enables progressive learning**: Start with API.md, drill down as needed
- **Maintains completeness**: Each guide is self-contained with examples

## Usage Workflow

### For BASIC V2 Programming

1. Consult **API.md** for syntax constraints and quick reference
2. Reference specialized guides as needed:
   - Sound? → **SID.md**
   - Colors/text? → **PETSCII.md**
   - Memory layout? → **MEMORY.md**
   - Disk I/O? → **IO.md**

### For Machine Language Programming

1. Start with **6502.md** for instruction set
2. Reference **MEMORY.md** for safe code locations
3. Use **KERNAL.md** for OS integration
4. Consult **VIC.md** or **SID.md** for hardware access

### For Complete Programs

1. **API.md**: Core BASIC structure
2. **MEMORY.md**: Memory planning
3. **VIC.md**: Graphics setup
4. **SID.md**: Sound implementation
5. **IO.md**: User input/file operations
6. **KERNAL.md**: System calls
7. **6502.md**: ML routines (if needed)

## Documentation Source

All content derives from Project 64 etexts:
- **docs/c64prg.txt**: Commodore 64 Programmer's Reference Guide (complete reference text)
- **docs/TOC1.md**: Navigation index for `c64prg.txt`
- **docs/mapping-c64.txt**: Mapping The Commodore 64 (memory map companion)
- **docs/TOC2.md**: Navigation index for `mapping-c64.txt`

The modular guides extract, organize, and expand upon this foundation with:
- Complete register/memory tables
- Practical BASIC and ML examples
- Troubleshooting guides
- Quick reference summaries

## Key Features

### Complete Coverage
- Every BASIC V2 keyword documented
- Every hardware register mapped
- Every KERNAL routine explained
- Every addressing mode detailed

### Practical Examples
- Working BASIC code snippets
- ML routine templates
- Common tasks (sprites, sound, disk I/O)
- Troubleshooting solutions

### Cross-Referenced
- API.md links to all specialized guides
- Each guide references related topics
- Consistent terminology throughout
- No duplicate content

### LLM-Optimized
- Structured markdown tables
- Clear section headers
- Minimal prose, maximum data density
- Token-efficient formatting

## Use Cases

### Code Generation
LLM receives API.md + relevant specialized guide(s) to generate accurate C64 code.

### Code Review
Check generated code against allowlist/denylist in API.md and hardware limits in specialized guides.

### Learning
Progressive documentation from high-level (BASIC) to low-level (ML/hardware).

### Reference
Quick lookup tables for registers, memory locations, opcodes, character codes.

## Technical Specifications

**BASIC Version**: V2.0 (Microsoft BASIC 6502)  
**CPU**: 6510 (6502 with I/O port)  
**Clock**: NTSC 1.023 MHz, PAL 0.985 MHz  
**RAM**: 64KB (38KB available for BASIC programs)  
**Graphics**: VIC-II 6567/6569 (320×200, 16 colors, 8 sprites)  
**Sound**: SID 6581 (3 voices, filters, ADSR)  
**I/O**: CIA 6526 (2 chips: keyboard, joystick, timers, serial)

## License

MIT License - See individual files for details.

---
