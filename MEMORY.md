# C64 Memory Map Reference

## Overview

The Commodore 64 has 64KB of addressable memory ($0000-$FFFF) with configurable banking that allows ROM/RAM switching. The 6510 processor port at $0001 controls memory configuration.

**Key characteristics:**
- 64KB RAM total
- BASIC ROM, KERNAL ROM, I/O, Character ROM can be banked in/out
- Default power-on: BASIC ROM at $A000, KERNAL ROM at $E000, I/O at $D000
- Screen memory default: $0400 (1024 bytes)
- BASIC program start: $0801 (2049)

## Complete Memory Map ($0000-$FFFF)

| Address Range | Size | Default Content | Description |
|---------------|------|-----------------|-------------|
| $0000-$0001 | 2 | Processor Port | 6510 I/O port + data direction |
| $0002-$00FF | 254 | Zero Page | Fast-access variables, KERNAL/BASIC workspace |
| $0100-$01FF | 256 | Stack | 6502 stack (grows downward from $01FF) |
| $0200-$02FF | 256 | KERNAL/BASIC | System variables, buffer pointers |
| $0300-$03FF | 256 | Vectors/Buffer | IRQ/NMI vectors, cassette buffer |
| $0400-$07FF | 1024 | Screen RAM | Default text screen memory (40×25) |
| $0800-$9FFF | 38KB | BASIC Program | User BASIC program and variables |
| $A000-$BFFF | 8KB | BASIC ROM | BASIC interpreter (or RAM if banked out) |
| $C000-$CFFF | 4KB | RAM | Free RAM (always RAM) |
| $D000-$DFFF | 4KB | I/O + Char ROM | VIC-II, SID, CIA, Color RAM (bankable) |
| $E000-$FFFF | 8KB | KERNAL ROM | Operating system (or RAM if banked out) |

## Memory Banking ($0001 Configuration)

The processor port at $0001 controls memory configuration. Common values:

| $0001 Value | Binary | $A000-$BFFF | $D000-$DFFF | $E000-$FFFF | Use Case |
|-------------|--------|-------------|-------------|-------------|----------|
| $37 (55) | 00110111 | BASIC ROM | I/O | KERNAL ROM | Default (power-on) |
| $36 (54) | 00110110 | BASIC ROM | Char ROM | KERNAL ROM | Character ROM visible |
| $35 (53) | 00110101 | RAM | I/O | KERNAL ROM | BASIC ROM banked out |
| $34 (52) | 00110100 | RAM | Char ROM | KERNAL ROM | Read character data |
| $33 (51) | 00110011 | RAM | I/O | RAM | All RAM mode |
| $30 (48) | 00110000 | RAM | RAM | RAM | Full 64KB RAM |

**Bits in $0001:**
- Bit 0: LORAM (0=RAM at $A000-$BFFF, 1=BASIC ROM)
- Bit 1: HIRAM (0=RAM at $E000-$FFFF, 1=KERNAL ROM)
- Bit 2: CHAREN (0=Char ROM at $D000-$DFFF, 1=I/O visible)
- Bits 3-5: Cassette + data direction (usually 111)

**Usage example:**
```basic
10 POKE 1,PEEK(1) AND 254: REM Bank out BASIC ROM
20 REM Now $A000-$BFFF is RAM
30 POKE 1,PEEK(1) OR 1: REM Bank in BASIC ROM
```

## Zero Page ($0000-$00FF)

Fast-access 256-byte area. KERNAL/BASIC use most locations; user-safe areas are limited.

### KERNAL/BASIC Usage (Read-Only or Reserved)

| Address | Size | Purpose |
|---------|------|---------|
| $00-$01 | 2 | Processor port (I/O + DDR) |
| $02 | 1 | Unused (available) |
| $03-$8F | 141 | KERNAL/BASIC workspace |
| $90 (144) | 1 | STATUS byte (ST variable) |
| $91 (145) | 1 | Stop key flag |
| $93-$94 | 2 | Tape buffer pointer |
| $97-$98 | 2 | KERNAL message control |
| $9D-$9E | 2 | Tape end address |
| $A0-$A2 | 3 | Jiffy clock (TI/TIME) |
| $B2-$B3 | 2 | Start of BASIC program |
| $C5 (197) | 1 | Key buffer count |
| $C6 (198) | 1 | Keyboard buffer (next key) |
| $D0-$D2 | 3 | Cursor position (row, column, flag) |
| $D3 (211) | 1 | Current text color |

### User-Safe Zero Page Locations

| Address | Size | Notes |
|---------|------|-------|
| $02 | 1 | Unused by system |
| $FB-$FE | 4 | Rarely used by KERNAL; safe for ML |
| $03-$8F | varies | Usable if not using BASIC/KERNAL features that need them |

**Warning:** Many zero-page locations are actively used during BASIC execution. For ML routines, prefer $FB-$FE or disable BASIC entirely.

## Stack ($0100-$01FF)

- Hardware stack: grows downward from $01FF
- CPU operations: JSR pushes return address, RTS pops it
- Default stack pointer: $FF (points to $01FF)
- BASIC uses ~32 bytes; deep recursion can overflow

**Check stack depth:**
```basic
10 PRINT "Stack pointer:";255-PEEK(256+PEEK(9))
```

## System Work Area ($0200-$03FF)

| Address | Size | Purpose |
|---------|------|---------|
| $0200-$0258 | 89 | BASIC input buffer |
| $0259-$0262 | 10 | Logical file table |
| $0263-$026C | 10 | Device number table |
| $026D-$0276 | 10 | Secondary address table |
| $0277-$0280 | 10 | Keyboard buffer (10 keys) |
| $0281-$0282 | 2 | Start of BASIC text |
| $0283-$0284 | 2 | End of BASIC text |
| $0314-$0315 | 2 | IRQ vector (CINV) |
| $0316-$0317 | 2 | BRK vector (CBINV) |
| $0318-$0319 | 2 | NMI vector (NMINV) |
| $033C-$03FB | 192 | Tape buffer |

## Screen and Color Memory

### Screen Memory (Default $0400-$07FF)

- Size: 1000 bytes (40 columns × 25 rows)
- Stores **screen codes** (not PETSCII codes)
- Relocatable via VIC-II $D018 register
- Address calculation: `1024 + ROW*40 + COLUMN`

**Example:**
```basic
10 REM Write 'A' (screen code 1) to position (10,5)
20 POKE 1024+5*40+10,1
```

### Color Memory ($D800-$DBE7, 55296-56295)

- Size: 1000 bytes (40 × 25)
- Fixed location (not relocatable)
- Lower 4 bits: color (0-15)
- Upper 4 bits: unused (read as random)
- Directly accessible regardless of banking

**Color values:**
- 0=Black, 1=White, 2=Red, 3=Cyan, 4=Purple, 5=Green, 6=Blue, 7=Yellow
- 8=Orange, 9=Brown, 10=Lt Red, 11=Grey1, 12=Grey2, 13=Lt Green, 14=Lt Blue, 15=Grey3

**Example:**
```basic
10 REM Set color at (10,5) to red
20 POKE 55296+5*40+10,2
```

## I/O Area ($D000-$DFFF)

Visible when $0001 bit 2 = 1 (CHAREN). Contains memory-mapped hardware registers.

| Address Range | Chip | Description |
|---------------|------|-------------|
| $D000-$D02E | VIC-II | Video controller (sprites, screen, colors) |
| $D400-$D41C | SID | Sound synthesizer (3 voices, filters) |
| $D800-$DBE7 | Color RAM | Screen color memory (1000 bytes, 4-bit) |
| $DC00-$DCFF | CIA1 | Keyboard, joystick, timers |
| $DD00-$DDFF | CIA2 | Serial bus, timers, NMI, VIC bank select |
| $DE00-$DEFF | I/O1 | Expansion port I/O area 1 |
| $DF00-$DFFF | I/O2 | Expansion port I/O area 2 |

**Key registers:**
- $D000-$D00F: Sprite X/Y coordinates
- $D012: Raster line counter
- $D015: Sprite enable
- $D020: Border color
- $D021: Background color
- $D418: SID volume (bits 0-3)
- $DC00: CIA1 Port A (keyboard/joystick 2)
- $DC01: CIA1 Port B (keyboard/joystick 1)
- $DD00: CIA2 Port A (VIC bank select, serial)

See `SID.md` for complete SID register map.

## Character ROM ($D000-$DFFF)

- Visible when $0001 = $34 (52) or $36 (54)
- Contains two character sets (2KB each)
- $D000-$D7FF: Uppercase/graphics
- $D800-$DFFF: Lowercase/uppercase
- Read-only; copy to RAM for custom characters

**Copy to RAM example:**
```basic
10 REM Copy character ROM to $3000
20 POKE 56334,PEEK(56334) AND 254: REM Bank out I/O
30 POKE 1,PEEK(1) AND 251: REM Bank in char ROM
40 FOR I=0 TO 2047
50   POKE 12288+I,PEEK(53248+I)
60 NEXT I
70 POKE 1,PEEK(1) OR 4: REM Bank out char ROM
80 POKE 56334,PEEK(56334) OR 1: REM Bank in I/O
```

## BASIC Program Area ($0801-$9FFF)

- Start: $0801 (2049) - fixed by BASIC ROM
- End: determined by BASIC (pointer at $0283-$0284)
- Program text, variables, arrays share this space
- Maximum ~38KB for programs + data

**Memory layout:**
1. Program text (tokenized BASIC)
2. Variables (simple numeric/string)
3. Arrays
4. String heap (grows downward from top)

**Check free memory:**
```basic
10 PRINT FRE(0)
```

**Note:** `FRE(0)` can return negative values due to signed integer arithmetic. Actual free bytes = `FRE(0) + 65536` if negative.

## Free RAM Areas

### Always Available RAM

| Address Range | Size | Notes |
|---------------|------|-------|
| $C000-$CFFF | 4KB | Always RAM, never ROM |
| $CF00-$CFFF | 256 | Often used for ML routines |

### Available When ROM Banked Out

| Address Range | Size | Access Method |
|---------------|------|---------------|
| $A000-$BFFF | 8KB | POKE 1,PEEK(1) AND 254 |
| $E000-$FFFF | 8KB | POKE 1,PEEK(1) AND 253 |

### Cassette Buffer ($033C-$03FB)

- 192 bytes
- Safe to use if not using tape drive
- Common location for small ML routines

**Example ML routine in cassette buffer:**
```basic
10 FOR I=0 TO 10
20   READ B: POKE 828+I,B: REM $033C = 828
30 NEXT I
40 SYS 828: REM Execute
50 DATA 169,65,32,210,255,96: REM LDA #65, JSR $FFD2, RTS
```

## Sprite Data Area

Sprites require 64 bytes each (63 bytes data + 1 unused). Location depends on VIC bank.

**Default bank 0 ($0000-$3FFF):**
- Safe sprite area: $2000-$3FFF (8KB)
- Avoid $0000-$03FF (zero page, stack, system)
- Avoid $0400-$07FF (screen memory)
- Avoid $0800-$1FFF (BASIC program area)

**Sprite pointer calculation:**
```basic
10 REM Set sprite 0 to data at $2000
20 SP=2040: REM Sprite pointer area (screen + 1016)
30 POKE SP,128: REM $2000 / 64 = 128
```

## VIC-II Video Banks

VIC-II sees only 16KB at a time. Bank selection via CIA2 $DD00 (bits 0-1):

| $DD00 bits 0-1 | Bank | Address Range |
|----------------|------|---------------|
| 11 | 0 | $0000-$3FFF (default) |
| 10 | 1 | $4000-$7FFF |
| 01 | 2 | $8000-$BFFF |
| 00 | 3 | $C000-$FFFF |

**Within each bank:**
- Screen memory: 1KB, offset set by $D018 bits 4-7
- Character memory: 2KB, offset set by $D018 bits 1-3
- Sprite pointers: last 8 bytes of screen memory

**Example - switch to bank 2:**
```basic
10 POKE 56576,(PEEK(56576) AND 252) OR 1: REM $DD00, bank 2
```

## KERNAL ROM ($E000-$FFFF)

Contains operating system routines. Key entry points:

| Address | Decimal | Function |
|---------|---------|----------|
| $FF81 | 65409 | CINT - Initialize screen |
| $FFD2 | 65490 | CHROUT - Output character |
| $FFCF | 65487 | CHRIN - Input character |
| $FFE4 | 65508 | GETIN - Get character (no wait) |
| $FFF0 | 65520 | PLOT - Set/get cursor position |
| $E544 | 58660 | Clear screen routine |

Access via `SYS <address>` from BASIC or `JSR <address>` from ML.

## BASIC ROM ($A000-$BFFF)

Contains BASIC V2 interpreter. No user-accessible routines; use from BASIC only.

## Safe Memory Regions for User Programs

### For BASIC Programs
- $0801-$9FFF: Program + variables (managed by BASIC)
- Use `FRE(0)` to check available space

### For Machine Language
1. **Cassette buffer** ($033C-$03FB, 192 bytes): Quick ML routines
2. **Under BASIC** ($C000-$CFFF, 4KB): Largest safe area
3. **End of BASIC** (use `POKE 56,XX: CLR` to reserve top RAM)
4. **Under ROM** ($A000-$BFFF, $E000-$FFFF if banked out)

**Reserve top RAM for ML:**
```basic
10 REM Reserve $C000-$CFFF (page 192-207)
20 POKE 56,192: REM Set top of BASIC memory
30 CLR: REM Clear variables, reset pointers
40 REM Now $C000-$CFFF protected from BASIC
```

## Memory Limitations

- **String heap fragmentation:** Repeated string operations fragment memory; use `FRE(0)` to garbage-collect
- **Array space:** Arrays allocated at end of variables; DIM early to avoid fragmentation
- **Screen memory conflict:** Moving screen to BASIC area reduces program space
- **Sprite data:** Requires 64-byte aligned blocks; limits placement

## Memory Access Speed

- **Zero page:** Fastest (3 cycles vs 4 for absolute addressing)
- **RAM:** Fast read/write
- **ROM:** Read-only, same speed as RAM
- **I/O registers:** Write-only or read-only; some have side effects
- **Color RAM:** Slower (only lower 4 bits valid)

## Practical Examples

### Check BASIC Pointers
```basic
10 PRINT "Start of BASIC:";PEEK(43)+PEEK(44)*256
20 PRINT "Start of variables:";PEEK(45)+PEEK(46)*256
30 PRINT "End of variables:";PEEK(47)+PEEK(48)*256
40 PRINT "Top of BASIC:";PEEK(55)+PEEK(56)*256
```

### Safe ML Routine Storage
```basic
10 REM Place ML at $C000 (49152)
20 FOR I=0 TO 20
30   READ B: POKE 49152+I,B
40 NEXT I
50 SYS 49152: REM Execute
60 DATA 169,1,141,32,208,96: REM Example: change border color
```

### Relocate Screen Memory
```basic
10 REM Move screen to $4000 (bank 1)
20 POKE 56576,(PEEK(56576) AND 252) OR 2: REM Select bank 1
30 POKE 53272,(PEEK(53272) AND 15) OR 0: REM Screen at $4000
40 REM Clear new screen
50 FOR I=16384 TO 17383: POKE I,32: NEXT
```

### Protect ML from BASIC
```basic
10 REM Protect $8000-$9FFF for ML
20 POKE 52,128: POKE 56,128: REM Set BASIC end at $8000
30 CLR: REM Reset BASIC
40 REM BASIC now uses $0801-$7FFF only
```

## Troubleshooting

### Problem: System crash after POKE
**Cause:** POKEd to critical zero-page location or wrong banking value.  
**Solution:** Reset ($0001 = 55 default). Avoid zero-page $00-$8F.

### Problem: Garbage on screen
**Cause:** Screen memory relocated but color RAM not moved (can't move).  
**Solution:** Clear color RAM $D800-$DBE7 after screen relocation.

### Problem: BASIC program vanished
**Cause:** Changed $0283-$0284 or $0801 contents.  
**Solution:** Never POKE BASIC pointers during program execution.

### Problem: ML routine crashes
**Cause:** Overwrote ROM/system area or forgot to bank in RAM.  
**Solution:** Use safe areas ($C000-$CFFF, cassette buffer, or reserved RAM).

## Memory Map Summary

**Quick reference:**
- Zero page: $00-$FF (mostly system)
- Stack: $0100-$01FF
- Screen: $0400-$07FF (default)
- BASIC: $0801-$9FFF
- ROM: $A000-$BFFF, $D000-$DFFF, $E000-$FFFF (bankable)
- I/O: $D000-$DFFF (when banked in)
- Color RAM: $D800-$DBE7 (fixed)
- Free RAM: $C000-$CFFF (always safe)

---