# C64LLM

C64LLM is a project designed to help an LLM generate code compatible with **Commodore 64 BASIC V2.0**, using a set of reference files optimized for context‑window limits and token usage.

## Project Structure

```
C64LLM/
 ├── README.md         ← This file
 ├── API.md            ← Guidelines for generating C64 BASIC code
 ├── SID.md            ← Note/frequency mapping for the SID chip
 └── docs/
      ├── c64prg.txt   ← Commodore 64 Programmer’s Reference Guide (full text)
      └── TOC.md       ← Quick index for consulting the PRG
```

## Purpose

The project provides the LLM with:
- **API.md** as the primary reference for rules, constraints, and coding style.
- **SID.md** as a guide to translate musical notes and frequencies into values usable by the **SID** sound chip.
- **docs/c64prg.txt** as the full technical foundation, derived from the *Commodore 64 Programmer’s Reference Guide*.
- **docs/TOC.md** as an index allowing the LLM to navigate the PRG without exceeding context‑window limits.

## Why TOC.md

LLMs have strict limits on context size and tokens. Therefore:
- The **c64prg.txt** file is not provided entirely to the LLM.
- Instead, **TOC.md** is supplied to indicate which sections to consult.
- The LLM can then request specific portions of PRG.txt as needed.

## How to Use the Files

### 1. API.md
Contains:
- Formatting rules
- BASIC V2.0 constraints
- Guidelines for instructions, memory, variables, routines
- Minimal examples and comments compatible with C64 limitations

It acts as an "output contract" for the LLM.

### 2. SID.md
Contains:
- Note → Frequency → C64 value tables
- Usage of the SID registers
- Mini‑examples for generating valid sound routines

### 3. docs/c64prg.txt
The full text of the *Commodore 64 Programmer’s Reference Guide*.
Not fed directly to the LLM, but used as the authoritative data source.

### 4. docs/TOC.md
Provides:
- A fast navigation index
- Pointers to relevant sections

The LLM may request: "Give me section XYZ of PRG.txt".

## Intended Use

This file set is designed for:
- Controlled prompting
- Stable C64 code generation
- Minimal token usage
- Straightforward translation between modern concepts and C64 constraints

## License

MIT License - See source file for details.

---
