# SID 6581 Complete Programming Guide

## Overview
The SID (Sound Interface Device) chip provides a 3-voice polyphonic synthesizer with programmable ADSR envelope, multiple waveforms, filters, and ring modulation. All control uses POKE to the memory-mapped registers at $D400 (54272 decimal). This guide summarizes the Commodore 64 Programmer's Reference Guide ("Programming Sound & Music" chapter and Appendix O) plus Mapping the Commodore 64 (Chapter 6) for register-level details.

SID shares the I/O block with the VIC-II ($D000-$D3FF) but does not collide with color RAM: the active registers span $D400-$D41C, and $D500-$D7FF are mirrored copies. When relocating the screen or doing bulk writes into I/O space, keep clear of $D400-$D41C (Mapping Chapter 6).

## Memory Map (Base $D400 = 54272)

### Voice 1 Registers
- $D400 (54272): Frequency LO byte
- $D401 (54273): Frequency HI byte
- $D402 (54274): Pulse Width LO byte
- $D403 (54275): Pulse Width HI byte (bits 0-3 only)
- $D404 (54276): Control Register
- $D405 (54277): Attack/Decay
- $D406 (54278): Sustain/Release

### Voice 2 Registers (offset +7)
- $D407 (54279): Frequency LO
- $D408 (54280): Frequency HI
- $D409 (54281): Pulse Width LO
- $D40A (54282): Pulse Width HI (bits 0-3)
- $D40B (54283): Control Register
- $D40C (54284): Attack/Decay
- $D40D (54285): Sustain/Release

### Voice 3 Registers (offset +14)
- $D40E (54286): Frequency LO
- $D40F (54287): Frequency HI
- $D410 (54288): Pulse Width LO
- $D411 (54289): Pulse Width HI (bits 0-3)
- $D412 (54290): Control Register
- $D413 (54291): Attack/Decay
- $D414 (54292): Sustain/Release

### Filter/Global Registers
- $D415 (54293): Filter Cutoff LO (bits 0-2)
- $D416 (54294): Filter Cutoff HI (bits 0-7)
- $D417 (54295): Resonance + Filter Routing
  - Bits 7-4: Resonance (0-15)
  - Bit 3: Filter External Input
  - Bit 2: Filter Voice 3
  - Bit 1: Filter Voice 2
  - Bit 0: Filter Voice 1
- $D418 (54296): Mode/Volume
  - Bits 0-3: Volume (0-15)
  - Bit 4: Low-pass filter enable
  - Bit 5: Band-pass filter enable
  - Bit 6: High-pass filter enable
  - Bit 7: Voice 3 off (disconnect from audio)

You can enable multiple filters at once (e.g., low-pass + high-pass for a notch). Mapping Chapter 6 notes that extreme combinations can sound unpredictable, so dial in a reference tone with a single filter and then add additional filters if the effect is desirable.

### Read-Only Registers
- $D419 (54297): Paddle X (POTX)
- $D41A (54298): Paddle Y (POTY)
- $D41B (54299): Oscillator 3 output / Random
- $D41C (54300): Envelope 3 output

## Control Register Bits (e.g., $D404)

| Bit | Value | Function |
|-----|-------|----------|
| 7 | 128 | Noise waveform |
| 6 | 64 | Pulse waveform |
| 5 | 32 | Sawtooth waveform |
| 4 | 16 | Triangle waveform |
| 3 | 8 | Test (hold oscillator) |
| 2 | 4 | Ring Modulation (voice N mod by N-1) |
| 1 | 2 | Sync (sync voice N to N-1) |
| 0 | 1 | Gate (trigger envelope) |

**Common control values:**
- `0` = silence (gate off, all waveforms off)
- `1` = gate on only (no waveform = no sound)
- `17` = triangle + gate
- `33` = sawtooth + gate
- `65` = pulse + gate
- `129` = noise + gate
- `16` = triangle, no gate (release phase)
- `32` = sawtooth, no gate
- `64` = pulse, no gate
- `128` = noise, no gate

**CRITICAL:** Never combine multiple waveforms simultaneously (except noise+pulse). Invalid combinations produce unpredictable results.

## ADSR Envelope

### Attack/Decay Register (e.g., $D405)
- Bits 7-4: Attack rate (0-15, 0=fastest ~2ms, 15=slowest ~8s)
- Bits 3-0: Decay rate (0-15, 0=fastest, 15=slowest)

### Sustain/Release Register (e.g., $D406)
- Bits 7-4: Sustain level (0-15, 0=silent, 15=max)
- Bits 3-0: Release rate (0-15, 0=fastest, 15=slowest)

**Envelope stages:**
1. **Attack**: Gate 0→1, volume rises to max at Attack rate
2. **Decay**: Falls to Sustain level at Decay rate
3. **Sustain**: Held at Sustain level while Gate=1
4. **Release**: Gate 1→0, falls to 0 at Release rate

**Timing values (approximate, PAL system):**
- Attack/Decay/Release 0: ~2-6ms
- 8: ~100-300ms
- 15: ~8-24 seconds

## Frequency Calculation

**Formula:** `FREQ = (NOTE_HZ * 16777216) / CLOCK_HZ`

Where:
- NTSC clock: 1022727 Hz
- PAL clock: 985248 Hz

**Split into LO/HI bytes:**
```basic
10 F=4976: REM example frequency value
20 FL=F AND 255: REM low byte
30 FH=INT(F/256): REM high byte
40 POKE 54272,FL: POKE 54273,FH
```

## Pulse Width (for Pulse waveform only)

**12-bit value** (0-4095) controls pulse duty cycle:
- 0: thinnest pulse (nearly silent)
- 2048: 50% square wave (loudest)
- 4095: thinnest pulse inverted

```basic
10 PW=2048: REM 50% duty cycle
20 PL=PW AND 255
30 PH=INT(PW/256) AND 15: REM only bits 0-3 used
40 POKE 54274,PL: POKE 54275,PH
```

## Basic Usage Pattern (Single Note)

```basic
100 REM === INIT SID ===
110 FOR I=54272 TO 54296: POKE I,0: NEXT: REM clear all SID
120 POKE 54296,15: REM max volume
130 REM
140 REM === SET ADSR ===
150 POKE 54277,9: REM attack=0 (fast), decay=9
160 POKE 54278,0: REM sustain=0, release=0 (organ-like)
170 REM
180 REM === PLAY NOTE ===
190 POKE 54272,45: REM freq LO (D-2)
200 POKE 54273,4: REM freq HI
210 POKE 54276,33: REM sawtooth + gate ON
220 FOR T=1 TO 500: NEXT: REM duration
230 POKE 54276,32: REM gate OFF (release)
240 FOR T=1 TO 100: NEXT: REM release time
```

## Playing Multiple Notes (Melody)

```basic
100 REM === MELODY PLAYER ===
110 FOR I=54272 TO 54296: POKE I,0: NEXT
120 POKE 54296,15: REM volume
130 POKE 54277,9: POKE 54278,0: REM ADSR
140 REM
150 FOR N=1 TO 8: REM 8 notes
160   READ FL,FH: REM read freq values
170   POKE 54272,FL: POKE 54273,FH
180   POKE 54276,33: REM gate on
190   FOR T=1 TO 300: NEXT: REM note duration
200   POKE 54276,32: REM gate off
210   FOR T=1 TO 50: NEXT: REM gap between notes
220 NEXT N
230 END
240 REM
250 REM === FREQ DATA (C-3 to C-4) ===
260 DATA 152,8,243,8,113,9,0,10
270 DATA 105,10,0,11,121,11,152,12
```

## Using Multiple Voices (Chord)

```basic
100 REM === 3-NOTE CHORD ===
110 FOR I=54272 TO 54296: POKE I,0: NEXT
120 POKE 54296,15
130 REM
140 REM Voice 1: C-4
150 POKE 54277,9: POKE 54278,0
160 POKE 54272,152: POKE 54273,12
170 REM
180 REM Voice 2: E-4
190 POKE 54284,9: POKE 54285,0
200 POKE 54279,194: POKE 54280,13
210 REM
220 REM Voice 3: G-4
230 POKE 54291,9: POKE 54292,0
240 POKE 54286,30: POKE 54287,15
250 REM
260 REM Play all together
270 POKE 54276,33: POKE 54283,33: POKE 54290,33
280 FOR T=1 TO 1000: NEXT
290 POKE 54276,32: POKE 54283,32: POKE 54290,32
300 FOR T=1 TO 200: NEXT
```

## Sound Effects Examples

### Explosion
```basic
100 FOR I=54272 TO 54296: POKE I,0: NEXT
110 POKE 54296,15
120 POKE 54277,0: POKE 54278,240: REM fast attack, long release
130 FOR F=255 TO 10 STEP -5
140   POKE 54272,F: POKE 54273,0
150   POKE 54276,129: REM noise + gate
160   FOR D=1 TO 10: NEXT
170 NEXT F
180 POKE 54276,128: REM gate off
```

### Laser
```basic
100 FOR I=54272 TO 54296: POKE I,0: NEXT
110 POKE 54296,15
120 POKE 54277,0: POKE 54278,200
130 FOR F=5000 TO 200 STEP -100
140   FL=F AND 255: FH=INT(F/256)
150   POKE 54272,FL: POKE 54273,FH
160   POKE 54276,65: REM pulse + gate
170   FOR D=1 TO 5: NEXT
180 NEXT F
190 POKE 54276,64
```

### Siren
```basic
100 FOR I=54272 TO 54296: POKE I,0: NEXT
110 POKE 54296,15
120 POKE 54277,0: POKE 54278,0
130 POKE 54276,17: REM triangle + gate (continuous)
140 FOR C=1 TO 10: REM 10 cycles
150   FOR F=1000 TO 2000 STEP 50
160     FL=F AND 255: FH=INT(F/256)
170     POKE 54272,FL: POKE 54273,FH
180     FOR D=1 TO 10: NEXT
190   NEXT F
200   FOR F=2000 TO 1000 STEP -50
210     FL=F AND 255: FH=INT(F/256)
220     POKE 54272,FL: POKE 54273,FH
230     FOR D=1 TO 10: NEXT
240   NEXT F
250 NEXT C
260 POKE 54276,16: REM gate off
```

## Filter Usage

```basic
100 REM === LOWPASS FILTER EXAMPLE ===
110 FOR I=54272 TO 54296: POKE I,0: NEXT
120 POKE 54296,15: REM volume
130 REM
140 REM Enable filter on voice 1
150 POKE 54295,1: REM filter voice 1
160 POKE 54293,0: POKE 54294,128: REM cutoff mid-range
170 POKE 54296,15+16: REM volume + lowpass enable
180 REM
190 REM Play note
200 POKE 54277,9: POKE 54278,0
210 POKE 54272,152: POKE 54273,12: REM C-4
220 POKE 54276,33: REM sawtooth + gate
230 REM
240 REM Sweep filter cutoff
250 FOR FC=0 TO 255
260   POKE 54294,FC
270   FOR D=1 TO 20: NEXT
280 NEXT FC
290 POKE 54276,32: REM gate off
```

## Common Pitfalls & Solutions

### Problem: No sound
**Check:**
1. Volume is non-zero: `POKE 54296,15`
2. Gate bit is set: control register bit 0 = 1
3. Waveform bit is set: at least one of bits 4-7 = 1
4. Frequency is reasonable: 200-60000 range
5. ADSR allows sound: sustain level > 0 OR attack > 0

### Problem: Continuous tone (can't stop)
**Solution:** Set gate bit to 0 AND ensure release time in ADSR
```basic
100 POKE 54276,32: REM waveform without gate
110 FOR T=1 TO 200: NEXT: REM wait for release
```

### Problem: Click/pop between notes
**Solution:** 
1. Lower sustain level: `POKE 54278,0` (bits 7-4 = 0)
2. Add gap between notes with gate off
3. Use shorter attack/decay times

### Problem: Wrong pitch
**Solution:** Check frequency calculation and HI/LO byte split:
```basic
10 F=4976: REM frequency value
20 POKE 54272,F AND 255: REM LO byte
30 POKE 54273,INT(F/256): REM HI byte
```

## Note Frequency Table (96 notes, C-0 to B-7)

**Usage:** Index matches across all three arrays. Example: Note 49 = C-4 → FreqDec=4508, FreqHI=17, FreqLO=156

### Note Names (0-95)
```
C-0, C#-0, D-0, D#-0, E-0, F-0, F#-0, G-0, G#-0, A-0, A#-0, B-0,
C-1, C#-1, D-1, D#-1, E-1, F-1, F#-1, G-1, G#-1, A-1, A#-1, B-1,
C-2, C#-2, D-2, D#-2, E-2, F-2, F#-2, G-2, G#-2, A-2, A#-2, B-2,
C-3, C#-3, D-3, D#-3, E-3, F-3, F#-3, G-3, G#-3, A-3, A#-3, B-3,
C-4, C#-4, D-4, D#-4, E-4, F-4, F#-4, G-4, G#-4, A-4, A#-4, B-4,
C-5, C#-5, D-5, D#-5, E-5, F-5, F#-5, G-5, G#-5, A-5, A#-5, B-5,
C-6, C#-6, D-6, D#-6, E-6, F-6, F#-6, G-6, G#-6, A-6, A#-6, B-6,
C-7, C#-7, D-7, D#-7, E-7, F-7, F#-7, G-7, G#-7, A-7, A#-7, B-7
```

### Frequency Decimal Values (0-95)
```
268, 284, 301, 318, 337, 357, 379, 401, 425, 451, 477, 506,
536, 568, 602, 637, 675, 715, 758, 802, 849, 900, 954, 1011,
1072, 1136, 1206, 1280, 1359, 1443, 1534, 1630, 1732, 1841, 1957, 2079,
2209, 2347, 2493, 2648, 2812, 2985, 3168, 3362, 3567, 3784, 4012, 4253,
4508, 4776, 5059, 5357, 5669, 5998, 6343, 6706, 7087, 7487, 7906, 8346,
8806, 9289, 9794, 10323, 10877, 11456, 12061, 12694, 13355, 14046, 14768, 15523,
16311, 17135, 17995, 18894, 19832, 20812, 21836, 22905, 24022, 25188, 26406, 27678,
29007, 30394, 31842, 33354, 34932, 36580, 38300, 40095
```

### High Byte (HI) for POKE (0-95)
```
1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,
2, 2, 2, 2, 2, 2, 2, 3, 3, 3, 3, 3,
4, 4, 4, 5, 5, 5, 5, 6, 6, 7, 7, 8,
8, 9, 9, 10, 10, 11, 12, 13, 13, 14, 15, 16,
17, 18, 19, 20, 22, 23, 24, 26, 27, 29, 30, 32,
34, 36, 38, 40, 42, 44, 47, 49, 52, 54, 57, 60,
63, 66, 70, 73, 77, 81, 85, 89, 93, 98, 103, 108,
113, 118, 124, 130, 136, 142, 149, 156
```

### Low Byte (LO) for POKE (0-95)
```
12, 28, 45, 62, 81, 101, 123, 145, 169, 195, 221, 250,
24, 56, 90, 125, 163, 203, 246, 34, 81, 132, 186, 243,
48, 112, 182, 0, 87, 179, 22, 102, 204, 33, 133, 47,
177, 59, 213, 120, 252, 169, 112, 82, 239, 168, 124, 109,
124, 168, 242, 237, 21, 94, 199, 82, 239, 159, 98, 58,
38, 41, 66, 115, 189, 64, 197, 86, 243, 158, 240, 3,
55, 143, 11, 110, 8, 124, 204, 25, 102, 180, 6, 94,
191, 42, 162, 42, 196, 116, 60, 31
```

### Using the Table in BASIC
```basic
1000 REM === NOTE TABLE DATA ===
1010 REM Store as DATA statements for READ
1020 DATA 12,1,28,1,45,1,62,1: REM C-0 to D#-0 (LO,HI pairs)
1030 REM ... (continue for all 96 notes)
1040 REM
1050 REM === PLAY NOTE BY INDEX ===
1060 N=49: REM C-4 (index 49)
1070 RESTORE 1020: REM reset data pointer
1080 FOR I=0 TO N-1: READ DL,DH: NEXT: REM skip to note N
1090 READ FL,FH: REM read frequency for note N
1100 POKE 54272,FL: POKE 54273,FH
1110 POKE 54276,33: REM play
```

### Quick Reference (Common Notes)
- **Middle C (C-4)**: 4508 → LO=124, HI=17
- **A-4 (440Hz)**: 7906 → LO=226, HI=30
- **C-3**: 2209 → LO=161, HI=8
- **C-5**: 9016 → LO=56, HI=35

## Advanced: Ring Modulation
Modulates voice N by voice N-1's oscillator:
```basic
100 REM Voice 1: modulator (low freq)
110 POKE 54272,50: POKE 54273,0
120 POKE 54276,16: REM triangle, no gate
130 REM
140 REM Voice 2: carrier (modulated)
150 POKE 54279,152: POKE 54280,12: REM C-4
160 POKE 54283,33+4: REM sawtooth + gate + ring mod (bit 2)
```

## Advanced: Sync
Resets voice N's oscillator when voice N-1 crosses zero:
```basic
100 REM Voice 1: sync source
110 POKE 54272,100: POKE 54273,0
120 POKE 54276,16: REM triangle
130 REM
140 REM Voice 2: synced
150 POKE 54279,200: POKE 54280,5
160 POKE 54283,33+2: REM sawtooth + gate + sync (bit 1)
```

## Random Number Generation
Use Voice 3's noise waveform + read OSC3:
```basic
100 POKE 54290,128: REM voice 3 noise, no gate
110 POKE 54296,15+128: REM volume + voice 3 off
120 REM
130 REM Read random byte
140 R=PEEK(54299): REM OSC3 output
150 PRINT R: REM random 0-255
```

## Complete Music Player Template

```basic
100 REM === SID MUSIC PLAYER ===
110 REM Init
120 FOR I=54272 TO 54296: POKE I,0: NEXT
130 POKE 54296,15: REM volume
140 POKE 54277,9: POKE 54278,128: REM ADSR: fast attack, med sustain
150 REM
160 REM Read song data
170 READ NS: REM number of notes
180 FOR N=1 TO NS
190   READ FL,FH,DUR: REM freq LO, HI, duration
200   POKE 54272,FL: POKE 54273,FH
210   POKE 54276,33: REM gate on
220   FOR T=1 TO DUR: NEXT
230   POKE 54276,32: REM gate off
240   FOR T=1 TO 20: NEXT: REM note gap
250 NEXT N
260 END
270 REM
280 REM === SONG DATA ===
290 DATA 8: REM 8 notes
300 DATA 152,8,200: REM C-3, duration 200
310 DATA 243,8,200: REM C#-3
320 DATA 113,9,200: REM D-3
330 DATA 0,10,200: REM D#-3
340 DATA 105,10,200: REM E-3
350 DATA 0,11,200: REM F-3
360 DATA 121,11,200: REM F#-3
370 DATA 152,12,200: REM C-4
```

## Troubleshooting Checklist

Before debugging, run this initialization:
```basic
10 FOR I=54272 TO 54296: POKE I,0: NEXT: REM clear SID
20 POKE 54296,15: REM set volume
30 POKE 54277,0: POKE 54278,240: REM fast envelope
40 POKE 54272,152: POKE 54273,12: REM C-4 frequency
50 POKE 54276,17: REM triangle + gate
60 REM Should hear continuous tone
```

If no sound:
1. Check TV/monitor volume
2. Verify SID is working: `POKE 54296,15: POKE 54276,129` (should hear noise)
3. Try different waveforms: 17, 33, 65, 129
4. Check frequency not 0: `POKE 54272,100: POKE 54273,10`

## Summary: Minimum Working Code

```basic
10 POKE 54296,15: REM volume
20 POKE 54277,0: POKE 54278,240: REM envelope
30 POKE 54272,152: POKE 54273,12: REM frequency
40 POKE 54276,33: REM sawtooth + gate
50 FOR I=1 TO 500: NEXT: REM wait
60 POKE 54276,32: REM gate off
```

This is the absolute minimum to produce a single note. All other features build on this foundation.
