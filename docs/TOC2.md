# Mapping The Commodore 64 — Table of Contents

Reference: `docs/mapping-c64.txt` (Project 64 etext of *Mapping The Commodore 64*, May 1998, hand-typed by David Holz); the book is a deep dive into the 64’s memory and hardware layout, with expanded explanations of ROM/RAM banking, device registers, and BASIC/KERNAL working storage.

## Foreword, acknowledgments, introduction
- Foreword frames the text as the definitive memory map reference, useful for BASIC or machine-language programmers and heavily rooted in the Commodore 64 Programmer’s Reference Guide and other PET/CBM sources.
- Acknowledgments and introduction restate the reference intent, explain the Project 64 effort, and position the mapping as a guide to the system’s PEEK/POKE hooks.

## Chapter 1 — Zero page overview (Page 0)
- Catalogues the first 256 bytes, highlights the 6510 I/O port at $0000/$0001 (memory-bank selection + cassette control), and explains the reserved BASIC working-storage subranges, flag bits, and useful zero-page pointers for machine language.

## Chapter 2 — Stack area (Page 1)
- Describes locations $100-$1FF: the 6510 hardware stack, subregions for floating-point conversions, tape-error logs, and the upper portion dedicated to return addresses, making the chapter an essential reference for FOR/NEXT, GOSUB, and interrupt usage.

## Chapter 3 — BASIC and KERNAL working storage (Pages 2–3)
- Details the RAM area that holds input buffers, I/O tables (logical file/device/secondary-address lists), the keyboard queue, tape buffers, file buffers, and various KERNAL pointers needed for serial/DOS routines, along with tips such as dynamic keyboard injection.

## Chapter 4 — 1K–40K (screen memory, sprite pointers, BASIC text)
- Documents the video matrix (default $0400–$07FF), relocatable screen banks, sprite pointer bytes, character codes on the screen, and the BASIC program text heap, highlighting how the VIC bank select bits and POKE loops interact with those ranges.

## Chapter 5 — 8K BASIC ROM and 4K free RAM
- Surveys the $A000–$BFFF block used by BASIC V2, summarizes the ROM routines (cold/warm start vectors, token parsing, interpreter structure), and notes the free 4K underneath the ROM that may be banked into RAM for graphics or machine-language helpers.

## Chapter 6 — VIC-II, SID, I/O devices, color RAM, character ROM
- Covers the $D000–$DFFF I/O block: VIC-II registers, sprite controls, color/background registers, SID registers, CIAs, character ROM banking, and bit-level tricks for color/multicolor modes and custom character sets. Includes advice on setting/clearing bits via BASIC POKE patterns.

## Chapter 7 — 8K Operating System Kernal ROM
- Reviews the ROM that lives at $E000–$FFFF, outlines the I/O/KERNAL entry points (e.g., RND, SYS, SAVE, VERIFY, CHROUT/CHRIN), discusses the effects of Kernal patches, and points to underlying RAM and patch tables for future updates.

## Appendices A–H and Index
- Appendix A/B teach newcomers how to type in programs, handle special characters, and avoid typos when entering DATA statements.
- Appendix C–E provide screen location/color tables plus color codes for reference (Appendices F/G note that ASCII and screen-code tables are omitted because they are widely available elsewhere but are referenced in the body when relevant).
- Appendix H lists keyboard scan codes to map PETSCII/shifted keystrokes to memory locations.
- The final index organizes entries by memory address so you can jump straight to any vector, pointer, or hardware register.
