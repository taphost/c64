# C64 I/O Devices and Ports Reference

## Overview

The C64 supports multiple I/O devices through logical device numbers. Access via BASIC commands (OPEN, CLOSE, PRINT#, INPUT#, GET#) or KERNAL routines.

## Device Numbers

| Device | Description | Common Use |
|--------|-------------|------------|
| 0 | Keyboard | Input (default) |
| 1 | Cassette tape | Data storage |
| 2 | RS-232 | Serial communications |
| 3 | Screen | Output (default) |
| 4 | Printer | Text output |
| 8-11 | Disk drives | Floppy disk storage (8 = primary) |
| 12-15 | Additional devices | Expansion devices |

## Cassette Tape (Device 1)

### Save to Tape
```basic
10 SAVE "PROGRAM",1
```

### Load from Tape
```basic
10 LOAD "PROGRAM",1
```

### Verify Tape
```basic
10 VERIFY "PROGRAM",1
```

### Sequential File Access
```basic
10 OPEN 1,1,1,"FILENAME": REM Read mode
20 OPEN 1,1,0,"FILENAME": REM Write mode
30 REM Read/write with INPUT#1 or PRINT#1
40 CLOSE 1
```

**Notes:**
- Tape counter at $00B2 (178)
- Motor control: POKE 192,XX (0=off, cassette sense sets bit)
- Play/record sensing via $01 (processor port)

## Disk Drive (Device 8)

### Basic Operations
```basic
10 LOAD "FILENAME",8: REM Load program
20 LOAD "FILENAME",8,1: REM Load to absolute address
30 SAVE "FILENAME",8: REM Save program
40 VERIFY "FILENAME",8: REM Verify file
```

### Directory Listing
```basic
10 LOAD "$",8
20 LIST
```

Or without destroying program:
```basic
10 OPEN 1,8,0,"$"
20 GET#1,A$,A$: REM Skip load address
30 GET#1,A$,A$: REM Skip link address
40 IF ST<>0 THEN CLOSE 1: END
50 GET#1,B$,B$: REM Block count
60 GET#1,A$: IF A$="" THEN 60
70 PRINT A$;: IF ASC(A$) THEN 60
80 PRINT: GOTO 30
```

### DOS Commands (via Channel 15)

Open command channel:
```basic
10 OPEN 15,8,15
```

Common commands (via PRINT#15):
```basic
20 PRINT#15,"I0": REM Initialize drive
30 PRINT#15,"S0:FILENAME": REM Scratch (delete) file
40 PRINT#15,"N0:DISKNAME,ID": REM Format disk (NEW)
50 PRINT#15,"R0:NEWNAME=OLDNAME": REM Rename file
60 PRINT#15,"C0:DEST=SOURCE": REM Copy file
70 PRINT#15,"V0": REM Validate disk
```

### Read Error Channel
```basic
10 OPEN 15,8,15
20 INPUT#15,EN,EM$,ET,ES: REM Error number, message, track, sector
30 PRINT EN;EM$;ET;ES
40 CLOSE 15
```

**Common error codes:**
- 00: OK
- 01: Files scratched (after scratch command)
- 20-29: Read errors
- 30-39: Write errors
- 62: File not found
- 63: File exists
- 73: DOS mismatch

### Sequential File Operations
```basic
10 REM Write to file
20 OPEN 1,8,2,"FILENAME,S,W"
30 PRINT#1,"LINE 1"
40 PRINT#1,"LINE 2"
50 CLOSE 1
60 REM
70 REM Read from file
80 OPEN 1,8,2,"FILENAME,S,R"
90 INPUT#1,A$
100 PRINT A$
110 IF ST=0 THEN 90
120 CLOSE 1
```

### Random Access Files
```basic
10 OPEN 1,8,2,"DATAFILE,L,"+CHR$(200): REM Record length 200
20 PRINT#1,"Record data...": REM Write record
30 CLOSE 1
```

## Printer (Device 4)

### Basic Printing
```basic
10 OPEN 1,4
20 PRINT#1,"HELLO PRINTER"
30 CLOSE 1
```

### Print with Secondary Address
```basic
10 OPEN 1,4,7: REM SA=7 for uppercase mode
20 CMD 1: REM Redirect output to printer
30 PRINT "THIS GOES TO PRINTER"
40 PRINT#3: REM Close CMD channel
50 CLOSE 1
```

**Secondary addresses:**
- 0: Uppercase/graphics
- 7: Lowercase/uppercase

## RS-232 (Device 2)

### Opening RS-232 Channel

Format: `OPEN file,2,secondary,"parameters"`

Parameters: `CHR$(baud+parity) + CHR$(control)`

**Baud rates (add to base value):**
- 0: User-defined (based on zero-page settings)
- 6: 300 baud
- 7: 1200 baud
- 8: 2400 baud
- 10: 1200 baud (alternative)

**Parity (add to baud):**
- 0: No parity
- 32: Even parity
- 96: Odd parity
- 160: Mark parity
- 224: Space parity

**Control byte:**
- Bits 0-3: Stop bits (shift left by 7)
- Bits 4-7: Data bits (5-8)

**Examples:**
```basic
10 REM 1200 baud, no parity, 8 data bits, 1 stop
20 OPEN 2,2,0,CHR$(7)+CHR$(8)
30 PRINT#2,"DATA TO SEND"
40 GET#2,A$: IF A$<>"" THEN PRINT A$
50 CLOSE 2
```

```basic
10 REM 300 baud, even parity, 7 data bits, 2 stops
20 OPEN 2,2,0,CHR$(38)+CHR$(135)
```

### RS-232 Zero-Page Buffers

Transmit buffer pointer: $F7-$F8  
Receive buffer pointer: $F9-$FA  
Default buffers: $0200 (transmit), $0300 (receive)

## CIA Chips (Complex Interface Adapter)

### CIA1 ($DC00-$DCFF) - Keyboard, Joystick, Timers

| Register | Address | Decimal | Function |
|----------|---------|---------|----------|
| PRA | $DC00 | 56320 | Port A (keyboard col/joystick 2) |
| PRB | $DC01 | 56321 | Port B (keyboard row/joystick 1) |
| DDRA | $DC02 | 56322 | Data direction A |
| DDRB | $DC03 | 56323 | Data direction B |
| TALO | $DC04 | 56324 | Timer A low byte |
| TAHI | $DC05 | 56325 | Timer A high byte |
| TBLO | $DC06 | 56326 | Timer B low byte |
| TBHI | $DC07 | 56327 | Timer B high byte |
| TOD10 | $DC08 | 56328 | Time of day: 1/10 seconds |
| TODSEC | $DC09 | 56329 | Time of day: seconds |
| TODMIN | $DC0A | 56330 | Time of day: minutes |
| TODHR | $DC0B | 56331 | Time of day: hours |
| SDR | $DC0C | 56332 | Serial data register |
| ICR | $DC0D | 56333 | Interrupt control |
| CRA | $DC0E | 56334 | Control register A |
| CRB | $DC0F | 56335 | Control register B |

### CIA2 ($DD00-$DDFF) - Serial Bus, NMI, VIC Bank

| Register | Address | Decimal | Function |
|----------|---------|---------|----------|
| PRA | $DD00 | 56576 | Port A (serial bus/VIC bank) |
| PRB | $DD01 | 56577 | Port B (RS-232/user port) |
| DDRA | $DD02 | 56578 | Data direction A |
| DDRB | $DD03 | 56579 | Data direction B |
| TALO | $DD04 | 56580 | Timer A low byte |
| TAHI | $DD05 | 56581 | Timer A high byte |
| TBLO | $DD06 | 56582 | Timer B low byte |
| TBHI | $DD07 | 56583 | Timer B high byte |
| TOD10 | $DD08 | 56584 | Time of day: 1/10 seconds |
| TODSEC | $DD09 | 56585 | Time of day: seconds |
| TODMIN | $DD0A | 56586 | Time of day: minutes |
| TODHR | $DD0B | 56587 | Time of day: hours |
| SDR | $DD0C | 56588 | Serial data register |
| ICR | $DD0D | 56589 | Interrupt control |
| CRA | $DD0E | 56590 | Control register A |
| CRB | $DD0F | 56591 | Control register B |

## Joystick Reading

### Port 1 (CIA1 $DC01 / 56321)
### Port 2 (CIA1 $DC00 / 56320)

Joystick bits (active low, 0 = pressed):
- Bit 0: Up
- Bit 1: Down
- Bit 2: Left
- Bit 3: Right
- Bit 4: Fire button

**Reading example:**
```basic
10 J=PEEK(56320): REM Port 2
20 IF J AND 1=0 THEN PRINT "UP"
30 IF J AND 2=0 THEN PRINT "DOWN"
40 IF J AND 4=0 THEN PRINT "LEFT"
50 IF J AND 8=0 THEN PRINT "RIGHT"
60 IF J AND 16=0 THEN PRINT "FIRE"
70 GOTO 10
```

**Simplified (specific values):**
```basic
10 J=PEEK(56320): REM Port 2
20 IF J=126 THEN PRINT "UP"
30 IF J=125 THEN PRINT "DOWN"
40 IF J=123 THEN PRINT "LEFT"
50 IF J=119 THEN PRINT "RIGHT"
60 IF J=111 THEN PRINT "FIRE"
70 GOTO 10
```

**Multiple directions (diagonal):**
```basic
10 J=PEEK(56320) AND 15: REM Mask direction bits
20 IF J=14 THEN PRINT "UP"
30 IF J=13 THEN PRINT "DOWN"
40 IF J=11 THEN PRINT "LEFT"
50 IF J=7 THEN PRINT "RIGHT"
60 IF J=10 THEN PRINT "UP-LEFT"
70 IF J=6 THEN PRINT "UP-RIGHT"
80 IF J=9 THEN PRINT "DOWN-LEFT"
90 IF J=5 THEN PRINT "DOWN-RIGHT"
```

## Paddle Reading

Paddles (analog controllers) use SID chip's analog-to-digital converters.

**Paddle ports:**
- Port 1: POTX at $D419 (54297), POTY at $D41A (54298)
- Port 2: POTX at $D419, POTY at $D41A (shared reading)

**Reading example:**
```basic
10 PX=PEEK(54297): REM Port 1 X-axis
20 PY=PEEK(54298): REM Port 1 Y-axis
30 PRINT "X:";PX;"Y:";PY
40 GOTO 10
```

**Values:** 0-255 (0=left/up, 255=right/down)

**Paddle buttons:** Same as joystick fire (CIA1 $DC00/$DC01 bit 4)

## Light Pen

Light pen coordinates via VIC-II registers.

**Registers:**
- $D013 (53267): Light pen X coordinate
- $D014 (53268): Light pen Y coordinate

**Reading example:**
```basic
10 X=PEEK(53267): Y=PEEK(53268)
20 PRINT "X:";X;"Y:";Y
30 GOTO 10
```

**Trigger:** Light pen button via joystick port (CIA)

## Keyboard Matrix

Keyboard organized as 8×8 matrix. CIA1 scans rows/columns.

**Direct reading (advanced):**
```basic
10 POKE 56322,0: REM Set CIA1 DDRA to input
20 POKE 56323,255: REM Set CIA1 DDRB to output
30 POKE 56321,255-R: REM Select row (0-7)
40 K=PEEK(56320): REM Read columns
50 REM Check bits 0-7 for pressed keys
```

**Preferred method:** Use BASIC `GET` or KERNAL `GETIN` ($FFE4).

## User Port ($DD01 / 56577)

8-bit parallel I/O port on CIA2 Port B.

**Pinout (from C64 User Port connector):**
- Pins C,D,E,F,H,J,K,L,M: Data lines (PB0-PB7)
- Pin 2: Ground
- Pin B: /FLAG2 (handshake)
- Pin 8-12: Extras (PA2, serial, etc.)

**Basic usage:**
```basic
10 POKE 56579,255: REM Set all bits output
20 POKE 56577,170: REM Write pattern 10101010
30 X=PEEK(56577): REM Read port
```

## Serial Bus (IEC)

Commodore serial bus for disk/printer communication. Low-level control via CIA2.

**Signals (CIA2 $DD00):**
- Bit 3: ATN (Attention)
- Bit 4: CLK (Clock)
- Bit 5: DATA
- Bit 6: CLK IN
- Bit 7: DATA IN

**Use KERNAL routines instead of direct manipulation:**
- TALK, LISTEN, UNTALK, UNLISTEN via device numbers

## Expansion Port

40-pin edge connector on bottom of C64.

**Key signals:**
- /GAME, /EXROM: Cartridge control
- /ROML, /ROMH: ROM bank select
- /IO1, /IO2: I/O areas ($DE00, $DF00)
- IRQ, NMI: Interrupt lines
- Address/data bus: Full 16-bit address, 8-bit data

**Cartridge auto-start:** Pull /EXROM low, provide ROM at $8000-$9FFF

## File Status (ST Variable)

`ST` variable holds I/O status after operations. Read with `PRINT ST` or `IF ST THEN...`

**Status bits:**
- Bit 0: Timeout read
- Bit 1: Timeout write
- Bit 6: EOF (end of file)
- Bit 7: Device not present
- Bit 4: Verify error
- Bit 5: Record not present

**Common checks:**
```basic
10 IF ST AND 64 THEN PRINT "EOF"
20 IF ST AND 128 THEN PRINT "DEVICE ERROR"
30 IF ST=0 THEN PRINT "OK"
```

## Practical Examples

### Copy File from Disk to Tape
```basic
10 OPEN 1,8,0,"FILENAME,S,R"
20 OPEN 2,1,1,"FILENAME"
30 GET#1,A$: IF ST=0 THEN PRINT#2,A$: GOTO 30
40 CLOSE 1: CLOSE 2
```

### Read Joystick for Game
```basic
10 J=PEEK(56320): REM Port 2
20 X=20: Y=12: REM Center position
30 IF J AND 1=0 THEN Y=Y-1: REM Up
40 IF J AND 2=0 THEN Y=Y+1: REM Down
50 IF J AND 4=0 THEN X=X-1: REM Left
60 IF J AND 8=0 THEN X=X-1: REM Right
70 IF J AND 16=0 THEN PRINT "FIRE!"
80 REM Clamp coordinates
90 IF X<0 THEN X=0
100 IF X>39 THEN X=39
110 IF Y<0 THEN Y=0
120 IF Y>24 THEN Y=24
130 REM Update display at X,Y
```

### Simple Data Logger to Disk
```basic
10 OPEN 1,8,2,"LOG,S,W"
20 FOR I=1 TO 100
30   D=INT(RND(1)*100): REM Sample data
40   PRINT#1,I;",";D
50 NEXT I
60 CLOSE 1
```

### Printer Dump Screen
```basic
10 OPEN 1,4
20 FOR R=0 TO 24
30   FOR C=0 TO 39
40     A=1024+R*40+C
50     CH=PEEK(A) AND 127: REM Remove reverse bit
60     IF CH<32 THEN CH=32: REM Replace control chars
70     PRINT#1,CHR$(CH);
80   NEXT C
90   PRINT#1: REM Newline
100 NEXT R
110 CLOSE 1
```

## Troubleshooting

### Problem: Device not present (ST=128)
**Cause:** Device not connected or wrong device number.  
**Solution:** Check cables, power, device number. For disk: ensure drive is on and initialized.

### Problem: File not found (error 62)
**Cause:** Filename mismatch or disk not initialized.  
**Solution:** Check spelling, use directory listing, try `PRINT#15,"I0"` to initialize.

### Problem: Joystick not responding
**Cause:** Wrong port or faulty connection.  
**Solution:** Check port number (56320 vs 56321), test with different joystick.

### Problem: RS-232 garbled data
**Cause:** Baud rate mismatch or incorrect parameters.  
**Solution:** Verify baud, parity, data bits match remote device.

### Problem: Tape won't load
**Cause:** Tape head alignment, volume level, or damaged tape.  
**Solution:** Adjust tape head azimuth, set volume to ~50%, clean heads.

## Device I/O Summary

**Quick reference:**
- Keyboard: Device 0 (default input)
- Tape: Device 1 (LOAD/SAVE/OPEN)
- RS-232: Device 2 (OPEN with parameters)
- Screen: Device 3 (default output)
- Printer: Device 4 (OPEN/PRINT#)
- Disk: Device 8 (LOAD/SAVE/OPEN, channel 15 for commands)
- Joystick 1: $DC01 (56321)
- Joystick 2: $DC00 (56320)
- Paddles: $D419-$D41A (54297-54298)

---