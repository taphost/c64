# C64LLM

C64LLM è un progetto pensato per permettere a una LLM di generare codice compatibile con **Commodore 64 BASIC V2.0**, guidandola tramite un set di file di riferimento ottimizzati per i limiti delle context window e dell’uso dei token.

## Struttura del progetto

```
C64LLM/
 ├── README.md         ← Questo file
 ├── API.md            ← Linee guida per generare codice C64 BASIC
 ├── SID.md            ← Mappatura note/frequenze per il chip SID
 └── docs/
      ├── c64prg.txt   ← Commodore 64 Programmer’s Reference Guide (testo integrale)
      └── TOC.md       ← Indice rapido per la consultazione del PRG
```

## Obiettivo

Il progetto fornisce alla LLM:
- **API.md** come riferimento primario per le regole, i limiti e lo stile di programmazione richiesti.
- **SID.md** come guida per tradurre note e frequenze musicali in valori utilizzabili dal chip **SID**.
- **docs/c64prg.txt** come base tecnica completa, derivata dal *Commodore 64 Programmer’s Reference Guide*.
- **docs/TOC.md** come indice per permettere alla LLM di navigare il PRG senza saturare la context window.

## Perché TOC.md

Le LLM hanno limiti di token e contesto. Per questo:
- Il file **c64prg.txt** non viene fornito per intero alla LLM.
- Si fornisce invece **TOC.md**, che indica quali sezioni leggere.
- La LLM può così richiedere parti specifiche di PRG.txt in base alle necessità.

## Come usare i file

### 1. API.md
Contiene:
- Regole di formattazione
- Vincoli del BASIC V2.0
- Linee guida per istruzioni, memoria, variabili, routine
- Esempi minimi e commenti compatibili con i limiti del C64

Serve come "contratto di output" per la LLM.

### 2. SID.md
Contiene:
- Tabella note → Frequenze → Valori C64
- Modalità d’uso dei registri SID
- Mini-esempi per generare suoni validi

### 3. docs/c64prg.txt
È il contenuto integrale (testuale) del *Commodore 64 Programmer’s Reference Guide*.
Non viene passato direttamente alla LLM, ma funge da sorgente dati.

### 4. docs/TOC.md
Fornisce:
- Un indice molto rapido
- Puntatori a sezioni rilevanti

La LLM può chiedere: "Dammi la sezione XYZ del PRG.txt".

## Destinazione d’uso

Il set di file è progettato per:
- Prompting controllato
- Generazione di codice C64 stabile
- Minimizzazione del token usage
- Traduzione semplice tra concetti moderni e limitazioni del C64

---


