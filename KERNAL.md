# C64 KERNAL Routines Reference

## Overview

The KERNAL is the C64's operating system ROM ($E000-$FFFF) providing low-level I/O, memory management, and system services. Access via `SYS <address>` from BASIC or `JSR <address>` from machine language. This reference summarizes the Commodore 64 Programmer's Reference Guide (KERNAL chapters/appendices) and Mapping the Commodore 64 (especially Chapter 7) so both canonical etexts are represented.

**Key features:**
- Device-independent I/O (tape, disk, screen, keyboard)
- File operations (OPEN, CLOSE, read, write)
- Screen/keyboard management
- Time-of-day clock
- Memory initialization
- Interrupt handling

## KERNAL Entry Points ($FF00-$FFFF)

### Primary I/O Routines

| Address | Decimal | Name | Function |
|---------|---------|------|----------|
| $FFD2 | 65490 | CHROUT | Output character to current device |
| $FFCF | 65487 | CHRIN | Input character from current device |
| $FFE4 | 65508 | GETIN | Get character (no wait) |
| $FFE1 | 65505 | STOP | Check STOP key |
| $FFED | 65517 | SCREEN | Return screen size |
| $FFF0 | 65520 | PLOT | Get/set cursor position |

### File Operations

| Address | Decimal | Name | Function |
|---------|---------|------|----------|
| $FFC0 | 65472 | OPEN | Open logical file |
| $FFC3 | 65475 | CLOSE | Close logical file |
| $FFC6 | 65478 | CHKIN | Set input channel |
| $FFC9 | 65481 | CHKOUT | Set output channel |
| $FFCC | 65484 | CLRCHN | Clear I/O channels |
| $FFB7 | 65463 | READST | Read I/O status |
| $FFBA | 65466 | SETLFS | Set logical file parameters |
| $FFBD | 65469 | SETNAM | Set filename |

### Loading and Saving

| Address | Decimal | Name | Function |
|---------|---------|------|----------|
| $FFD5 | 65493 | LOAD | Load from device |
| $FFD8 | 65496 | SAVE | Save to device |
| $FFE7 | 65511 | CLALL | Close all files |

### System Functions

| Address | Decimal | Name | Function |
|---------|---------|------|----------|
| $FF81 | 65409 | CINT | Initialize screen |
| $FF84 | 65412 | IOINIT | Initialize I/O |
| $FF87 | 65415 | RAMTAS | Initialize memory |
| $FF8A | 65418 | RESTOR | Restore default vectors |
| $FF8D | 65421 | VECTOR | Read/write vector table |
| $FF90 | 65424 | SETMSG | Control error messages |
| $FF93 | 65427 | SECOND | Send secondary address |
| $FF96 | 65430 | TKSA | Send secondary address (talk) |
| $FF99 | 65433 | MEMTOP | Read/set top of memory |
| $FF9C | 65436 | MEMBOT | Read/set bottom of memory |
| $FF9F | 65439 | SCNKEY | Scan keyboard |
| $FFA2 | 65442 | SETTMO | Set timeout |
| $FFA5 | 65445 | ACPTR | Input byte from serial |
| $FFA8 | 65448 | CIOUT | Output byte to serial |
| $FFAB | 65451 | UNTLK | Send UNTALK to serial |
| $FFAE | 65454 | UNLSN | Send UNLISTEN to serial |
| $FFB1 | 65457 | LISTEN | Command device to listen |
| $FFB4 | 65460 | TALK | Command device to talk |

### Time Functions

| Address | Decimal | Name | Function |
|---------|---------|------|----------|
| $FFDE | 65502 | RDTIM | Read system clock |
| $FFDB | 65499 | SETTIM | Set system clock |
| $FFEA | 65514 | UDTIM | Update system clock |

## Math and random support

Some of the KERNAL routines used by BASIC math functions reside in the ROM banks: `POLY1` ($E043) and `POLY2` ($E059) evaluate expression series, while the `RND` sequence relies on constants at `RMULC` ($E08D) and `RADDC` ($E092) before calling `RND` ($E097). `RND(1)` always continues the same pseudo-random stream; `RND(0)` samples the free-running jiffy clock (per the Programmer's Reference Guide), so calling `RND(0)` injects fresh entropy without touching CIA timers. Mapping (cap. 7) recommends `RND(-RND(0))` if you need an additional re-seed guard, but no extra writes to Timer A are required. The `SYS` entry at $E12A saves A/X/Y/P via 780-783 ($030C-$030F) before running the target routine, so always restore the registers afterward.

## I/O helper routines in ROM

BASIC builds on higher-level wrappers when it needs to call the KERNAL. `CALL KERNAL I/O ROUTINES` ($E0F9) handles CIN/OUT errors plus the 512-byte RS-232 buffer allocation/CLR; `SAVE` ($E156) uses pointers at 43/45 to define save range, `VERIFY` ($E165) sets the verify flag at 10 ($0A). These routines make it possible to reuse the ROM services mentioned in the tables without reimplementing pointer adjustments manually.

## Kernal patch awareness

The later ROM revisions patch sections in the Kernal (see addresses $E4AD-$E4FF and $FF5B-$FF7F) to fix color-initialization and regional differences. When you rely on a specific routine, be mindful that a patched machine may redirect it; consult the patch tables if you need to set new vectors rather than calling the default entry.

## Register Conventions

**Input registers:**
- A: Accumulator (data byte, flags, return values)
- X: X register (low byte addresses, indices)
- Y: Y register (high byte addresses, indices)

**Output registers:**
- A: Return value or status
- X, Y: Return values or preserved
- C: Carry flag (0=success, 1=error)

**Preserved:** Some routines preserve X/Y; check specific routine documentation.

## KERNAL Vectors ($0314-$033B)

Editable vectors in RAM for customizing system behavior:

| Address | Vector | Default | Function |
|---------|--------|---------|----------|
| $0314-$0315 | CINV | $EA31 | IRQ interrupt handler |
| $0316-$0317 | CBINV | $FE66 | BRK instruction handler |
| $0318-$0319 | NMINV | $FE47 | NMI interrupt handler |
| $031A-$031B | IOPEN | $F34A | OPEN routine |
| $031C-$031D | ICLOSE | $F291 | CLOSE routine |
| $031E-$031F | ICHKIN | $F20E | CHKIN routine |
| $0320-$0321 | ICKOUT | $F250 | CHKOUT routine |
| $0322-$0323 | ICLRCH | $F333 | CLRCHN routine |
| $0324-$0325 | IBASIN | $F157 | CHRIN routine |
| $0326-$0327 | IBSOUT | $F1CA | CHROUT routine |
| $0328-$0329 | ISTOP | $F6ED | STOP key check |
| $032A-$032B | IGETIN | $F13E | GETIN routine |
| $032C-$032D | ICLALL | $F32F | CLALL routine |
| $032E-$032F | - | $FE66 | User vector (BRK) |
| $0330-$0331 | ILOAD | $F4A5 | LOAD routine |
| $0332-$0333 | ISAVE | $F5DD | SAVE routine |

**Restore defaults:**
```basic
10 SYS 65418: REM RESTOR
```

## Character I/O

### CHROUT ($FFD2) - Output Character

**Input:** A = character to output  
**Output:** -  
**Affected:** A

```basic
10 A=65: REM 'A'
20 SYS 65490: REM Output via CHROUT
```

**ML example:**
```
LDA #$41    ; 'A'
JSR $FFD2   ; CHROUT
```

### CHRIN ($FFCF) - Input Character

**Input:** -  
**Output:** A = character read  
**Affected:** A

Waits for input from current device.

```basic
10 SYS 65487: REM CHRIN
20 A=PEEK(781): REM Get result from A register location
```

**ML example:**
```
JSR $FFCF   ; CHRIN
STA $0400   ; Store at screen
```

### GETIN ($FFE4) - Get Character (No Wait)

**Input:** -  
**Output:** A = character (0 if none)  
**Affected:** A

Non-blocking keyboard read.

```basic
10 SYS 65508: REM GETIN
20 A=PEEK(781): REM Check A register
30 IF A=0 THEN 10: REM No key pressed
```

**ML example:**
```
LOOP:
JSR $FFE4   ; GETIN
BEQ LOOP    ; Wait if no key
```

## File Operations

### SETLFS ($FFBA) - Set Logical File

**Input:**
- A = Logical file number (0-255)
- X = Device number (0-15)
- Y = Secondary address (0-255)

**Output:** -

Sets up file parameters for OPEN.

**ML example:**
```
LDA #$01    ; Logical file 1
LDX #$08    ; Device 8 (disk)
LDY #$02    ; Secondary 2
JSR $FFBA   ; SETLFS
```

### SETNAM ($FFBD) - Set Filename

**Input:**
- A = Filename length
- X = Low byte of filename address
- Y = High byte of filename address

**Output:** -

Sets filename for OPEN/LOAD/SAVE.

**ML example:**
```
LDA #$09       ; Length 9
LDX #<FNAME    ; Low byte
LDY #>FNAME    ; High byte
JSR $FFBD      ; SETNAM

FNAME: .TEXT "FILENAME"
```

### OPEN ($FFC0) - Open File

**Input:** Parameters from SETLFS/SETNAM  
**Output:** C = 0 (success) or 1 (error)  
**Affected:** A, X, Y

Opens logical file.

**From BASIC:**
```basic
10 OPEN 1,8,2,"FILENAME"
```

**ML sequence:**
```
LDA #$01
LDX #$08
LDY #$02
JSR $FFBA      ; SETLFS

LDA #$08
LDX #<NAME
LDY #>NAME
JSR $FFBD      ; SETNAM

JSR $FFC0      ; OPEN
BCS ERROR      ; Check carry
```

### CLOSE ($FFC3) - Close File

**Input:** A = Logical file number  
**Output:** -  
**Affected:** A, X, Y

Closes logical file.

```basic
10 CLOSE 1
```

**ML example:**
```
LDA #$01    ; Logical file 1
JSR $FFC3   ; CLOSE
```

### CHKIN ($FFC6) - Set Input Channel

**Input:** X = Logical file number  
**Output:** C = error flag  
**Affected:** A, X

Redirects input from file.

**ML example:**
```
LDX #$01    ; Logical file 1
JSR $FFC6   ; CHKIN
BCS ERROR
```

### CHKOUT ($FFC9) - Set Output Channel

**Input:** X = Logical file number  
**Output:** C = error flag  
**Affected:** A

Redirects output to file.

**ML example:**
```
LDX #$01    ; Logical file 1
JSR $FFC9   ; CHKOUT
BCS ERROR
```

### CLRCHN ($FFCC) - Clear I/O Channels

**Input:** -  
**Output:** -  
**Affected:** A, X

Resets I/O to keyboard/screen.

**ML example:**
```
JSR $FFCC   ; CLRCHN
```

### READST ($FFB7) - Read I/O Status

**Input:** -  
**Output:** A = Status byte  
**Affected:** A

Returns current I/O status (same as ST variable).

**Status bits:**
- Bit 0: Timeout read
- Bit 1: Timeout write
- Bit 6: EOF
- Bit 7: Device not present

**ML example:**
```
JSR $FFB7   ; READST
AND #$40    ; Check EOF
BNE DONE
```

## Loading and Saving

### LOAD ($FFD5) - Load File

**Input:**
- A = 0 (load), 1 (verify)
- X = Low byte load address
- Y = High byte load address
- Filename via SETNAM
- Device via SETLFS

**Output:** C = error flag  
**Affected:** A, X, Y

**ML example:**
```
LDA #$08
LDX #<NAME
LDY #>NAME
JSR $FFBD      ; SETNAM

LDA #$01
LDX #$08
LDY #$01
JSR $FFBA      ; SETLFS

LDA #$00       ; Load
LDX #$00
LDY #$C0       ; Load to $C000
JSR $FFD5      ; LOAD
BCS ERROR
```

### SAVE ($FFD8) - Save File

**Input:**
- A = Zero page pointer to start address
- X = Low byte end address
- Y = High byte end address
- Filename via SETNAM
- Device via SETLFS

**Output:** C = error flag  
**Affected:** A, X, Y

**ML example:**
```
LDA #$08
LDX #<NAME
LDY #>NAME
JSR $FFBD      ; SETNAM

LDA #$01
LDX #$08
LDY #$00
JSR $FFBA      ; SETLFS

LDA #$FB       ; ZP pointer to start
LDA #$00
STA $FB
LDA #$C0
STA $FC        ; $FB/$FC = $C000

LDX #$00
LDY #$D0       ; End at $D000
JSR $FFD8      ; SAVE
BCS ERROR
```

## Screen Functions

### PLOT ($FFF0) - Cursor Position

**Input (set cursor):**
- C = 0
- X = Row (0-24)
- Y = Column (0-39)

**Input (get cursor):**
- C = 1

**Output (get):**
- X = Current row
- Y = Current column

**Affected:** A, X, Y

**ML example (set):**
```
CLC
LDX #$0A    ; Row 10
LDY #$05    ; Column 5
JSR $FFF0   ; PLOT
```

**ML example (get):**
```
SEC
JSR $FFF0   ; PLOT
; X = row, Y = column
```

### SCREEN ($FFED) - Get Screen Size

**Input:** -  
**Output:**
- X = Columns (40)
- Y = Rows (25)

**Affected:** X, Y

```
JSR $FFED   ; SCREEN
; X=40, Y=25
```

### CINT ($FF81) - Initialize Screen

**Input:** -  
**Output:** -  
**Affected:** A, X, Y

Clears screen, resets colors, cursor.

```
JSR $FF81   ; CINT
```

## System Functions

### IOINIT ($FF84) - Initialize I/O

**Input:** -  
**Output:** -  
**Affected:** A, X

Initializes CIA chips, screen, keyboard.

### RAMTAS ($FF87) - Initialize Memory

**Input:** -  
**Output:** -  
**Affected:** A, X, Y

Tests and clears RAM, sets pointers.

### RESTOR ($FF8A) - Restore Vectors

**Input:** -  
**Output:** -  
**Affected:** -

Restores KERNAL vectors to defaults.

```basic
10 SYS 65418: REM RESTOR
```

### VECTOR ($FF8D) - Read/Write Vectors

**Input:**
- C = 0 (read), 1 (write)
- X = Low byte of vector table address
- Y = High byte of vector table address

**Output:** Vectors copied to/from specified address  
**Affected:** A, X, Y

Vector table format: 16 vectors × 2 bytes = 32 bytes

## Time Functions

### RDTIM ($FFDE) - Read System Clock

**Input:** -  
**Output:**
- A = Low byte (jiffies)
- X = Middle byte
- Y = High byte

**Affected:** A, X, Y

Reads 24-bit jiffy clock (1/60 sec NTSC, 1/50 PAL).

**ML example:**
```
JSR $FFDE   ; RDTIM
STA $FB     ; Store low byte
STX $FC     ; Middle
STY $FD     ; High
```

**BASIC access:** `TI` variable

### SETTIM ($FFDB) - Set System Clock

**Input:**
- A = Low byte
- X = Middle byte
- Y = High byte

**Output:** -  
**Affected:** -

**ML example:**
```
LDA #$00
LDX #$00
LDY #$00
JSR $FFDB   ; SETTIM (reset to 0)
```

**BASIC:** `TI=0`

### UDTIM ($FFEA) - Update Clock

**Input:** -  
**Output:** -  
**Affected:** A, X

Increments jiffy clock. Called by IRQ handler.

## Keyboard Scanning

### SCNKEY ($FF9F) - Scan Keyboard

**Input:** -  
**Output:** -  
**Affected:** A, X, Y

Scans keyboard matrix, updates buffer. Called by IRQ.

### STOP ($FFE1) - Check STOP Key

**Input:** -  
**Output:** Z flag (1 if pressed)  
**Affected:** A, X

**ML example:**
```
JSR $FFE1   ; STOP
BEQ STOPPED ; Branch if STOP pressed
```

## Error Handling

**Error codes (after READST):**
- 0: OK
- 1: Timeout read
- 2: Timeout write
- 64: EOF
- 128: Device not present

**Carry flag:** Many routines set C=1 on error.

**ML error check:**
```
JSR $FFC0   ; OPEN
BCS ERROR   ; Branch on error
```

## Practical Examples

### Print String via KERNAL

**ML routine:**
```
; String at $C000
PRINT:
    LDY #$00
LOOP:
    LDA $C000,Y
    BEQ DONE
    JSR $FFD2      ; CHROUT
    INY
    BNE LOOP
DONE:
    RTS

STRING: .TEXT "HELLO WORLD"
        .BYTE $00
```

### Load File to Specific Address

**ML routine:**
```
LOADFILE:
    LDA #$09
    LDX #<FNAME
    LDY #>FNAME
    JSR $FFBD      ; SETNAM
    
    LDA #$01
    LDX #$08
    LDY #$01
    JSR $FFBA      ; SETLFS
    
    LDA #$00       ; Load mode
    LDX #$00
    LDY #$C0       ; Load to $C000
    JSR $FFD5      ; LOAD
    BCS ERROR
    RTS

FNAME: .TEXT "DATA.PRG"
ERROR:
    ; Handle error
    RTS
```

### Read Sequential File

**ML routine:**
```
READFILE:
    ; Open file
    LDA #$01
    LDX #$08
    LDY #$02
    JSR $FFBA      ; SETLFS
    
    LDA #$08
    LDX #<FNAME
    LDY #>FNAME
    JSR $FFBD      ; SETNAM
    
    JSR $FFC0      ; OPEN
    BCS ERROR
    
    ; Set input
    LDX #$01
    JSR $FFC6      ; CHKIN
    
READ_LOOP:
    JSR $FFCF      ; CHRIN
    STA $0400,X    ; Store to screen
    INX
    
    JSR $FFB7      ; READST
    AND #$40       ; Check EOF
    BEQ READ_LOOP
    
    JSR $FFCC      ; CLRCHN
    LDA #$01
    JSR $FFC3      ; CLOSE
    RTS

ERROR:
    RTS

FNAME: .TEXT "DATA.SEQ"
```

### Custom IRQ Handler

**ML routine:**
```
SETUP_IRQ:
    SEI            ; Disable interrupts
    
    ; Save old vector
    LDA $0314
    STA OLD_IRQ
    LDA $0315
    STA OLD_IRQ+1
    
    ; Install new vector
    LDA #<NEW_IRQ
    STA $0314
    LDA #>NEW_IRQ
    STA $0315
    
    CLI            ; Enable interrupts
    RTS

NEW_IRQ:
    ; Custom code here
    INC $D020      ; Flash border
    
    ; Jump to old handler
    JMP (OLD_IRQ)

OLD_IRQ: .WORD $0000
```

### Get Cursor Position

**ML routine:**
```
GET_CURSOR:
    SEC
    JSR $FFF0      ; PLOT
    ; X = row, Y = column
    STX ROW
    STY COL
    RTS

ROW: .BYTE $00
COL: .BYTE $00
```

## BASIC to KERNAL Integration

### Calling KERNAL from BASIC

**Using SYS:**
```basic
10 REM Call CHROUT to print 'A'
20 POKE 781,65: REM Store A in location
30 SYS 65490: REM CHROUT
```

**Note:** Register passing from BASIC is limited. For complex operations, write ML wrapper.

### ML Wrapper Example

```basic
10 REM ML wrapper at $C000
20 FOR I=0 TO 10
30   READ B: POKE 49152+I,B
40 NEXT
50 SYS 49152: REM Call wrapper
60 DATA 169,65,32,210,255,96
70 REM LDA #$41, JSR $FFD2, RTS
```

## Memory Map Summary

**KERNAL ROM:** $E000-$FFFF (8KB)  
**Vectors:** $0314-$033B (RAM)  
**Entry points:** $FF00-$FFFF

**Important addresses:**
- $FFD2: CHROUT (most used)
- $FFE4: GETIN (keyboard)
- $FFF0: PLOT (cursor)
- $FFC0: OPEN (files)
- $FFBA/$FFBD: SETLFS/SETNAM

## KERNAL Routine Quick Reference

**I/O:** CHROUT, CHRIN, GETIN  
**Files:** OPEN, CLOSE, CHKIN, CHKOUT, CLRCHN  
**Load/Save:** LOAD, SAVE  
**Screen:** PLOT, SCREEN, CINT  
**System:** IOINIT, RAMTAS, RESTOR  
**Time:** RDTIM, SETTIM  
**Keyboard:** SCNKEY, STOP

---
