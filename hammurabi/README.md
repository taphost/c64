# HAMMURABI - Commodore 64 BASIC V2

## Versione Originale (DEC BASIC)

**File:** `hammurabi_DEC_eng.bas` (codice originale)

Hammurabi è un gioco storico di strategia e gestione risorse pubblicato da Creative Computing nel 1973. Il giocatore governa l'antica Sumeria per 10 anni, gestendo terra, cibo e popolazione.

**Obiettivi:**
- Comprare/vendere acri di terra
- Distribuire cibo alla popolazione
- Seminare i campi
- Evitare carestie e rivolte

**Meccaniche:**
- Prezzi della terra variabili (17-26 bushel/acro)
- Raccolti casuali (1-6 bushel/acro)
- Topi che mangiano il grano (casuali)
- Immigrazione basata su prosperità
- Peste con 15% probabilità
- Destituzione se >45% popolazione muore in un anno

## Versione Italiana (Fedele agli Errori)

**File:** `hammurabi_C64_ita.bas` (versione intermedia)

Traduzione letterale del codice originale in italiano, mantenendo i bug del DEC BASIC:

### Bug Presenti (Fedeli all'Originale)

1. **Linee 490-600**: Flusso di controllo della semina interrotto
   - Linea 540 salta a 490 invece che continuare i controlli
   - Linea 570 salta a 490 saltando il controllo popolazione
   - Controllo manodopera (linea 580) mai raggiunto correttamente

2. **Linea 780**: Usa stesso numero per input negativo e destituzione
   - Crea ambiguità nel flusso

3. **Linee 850-900**: Valutazione finale con salti duplicati
   - Multiple linee saltano a 770 (messaggio destituzione)

### Conversione DEC → C64

- Rimosso `TAB()` eccessivo (C64 ha 40 colonne)
- Aggiunto `CHR$(147)` per clear screen
- Mantenuta struttura GOSUB/RETURN
- Nessun carattere accentato (solo apostrofi)
- Testi tutto MAIUSCOLO per compatibilità PETSCII

## Versione Italiana Corretta

**File:** `hammurabi_C64_ita_fixed.bas` (versione finale)

Correzioni applicate per gameplay funzionale:

### Fix Implementati

1. **Linea 500**: `IF D=0 THEN 610`
   - Salta direttamente al ciclo produzione se nessun acro da seminare

2. **Linee 520-540**: Controllo acri posseduti
   - `IF D<=A THEN 550` (continua controlli)
   - `GOSUB 1050: GOTO 490` (richiede input se fallisce)

3. **Linee 550-570**: Controllo grano per semina
   - `IF INT(D/2)<=S THEN 580` (verifica abbastanza grano)
   - `GOSUB 1020: GOTO 490` (richiede input se fallisce)

4. **Linea 580**: Controllo popolazione
   - `IF D<10*P THEN 610` (procede se manodopera sufficiente)
   - Altrimenti stampa errore e torna a 490

5. **Linea 790**: `GOTO 1000` invece di `GOTO 940`
   - Fine gioco corretta dopo destituzione

6. **Linee 850-900**: Flusso valutazione finale corretto
   - Eliminati salti ridondanti
   - Valutazioni negative vanno a 930 (non 770)

### Differenze Funzionali

| Aspetto | Versione Fedele | Versione Corretta |
|---------|-----------------|-------------------|
| Semina | Controlli bypassabili | Tutti i controlli funzionano |
| Destituzione | Loop infinito possibile | Uscita pulita |
| Valutazione | Messaggi sovrapposti | Messaggi corretti |
| Gameplay | Può bloccarsi | Sempre giocabile |

## Come Caricare su C64

1. Copia il codice in un emulatore (VICE, CCS64)
2. Oppure salva come file `.prg`:
   ```basic
   SAVE "HAMMURABI",8
   ```
3. Carica con:
   ```basic
   LOAD "HAMMURABI",8
   RUN
   ```

## Variabili Principali

- `Z`: Anno corrente (1-10)
- `P`: Popolazione
- `A`: Acri posseduti
- `S`: Bushel in magazzino
- `Y`: Prezzo terra / Raccolto per acro
- `D`: Persone morte di fame
- `I`: Immigrati
- `E`: Bushel mangiati dai topi
- `Q`: Input temporaneo / Variabile peste
- `P1`: % media morti per anno
- `D1`: Totale morti
- `L`: Acri per persona (finale)

## Note di Compatibilità

- Testato su VICE 3.x
- Compatibile C64/C128 (modalità C64)
- Richiede ~2KB RAM libera
- Nessuna periferica richiesta

## Crediti

- Originale: David H. Ahl (Creative Computing, 1973)
- Conversione/Traduzione: 2024
- Basato su: BASIC Computer Games (1978)