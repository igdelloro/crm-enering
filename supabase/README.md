# Database (Supabase) — base

## File

- **schema_completo.sql** — struttura completa del database (tabelle, funzioni,
  permessi RLS). È il file da eseguire per primo su un progetto Supabase nuovo.
  Idempotente e non distruttivo: si può rieseguire senza perdere dati.
- **esempi/utenti_esempio.sql** — template per inserire le persone del team e
  gestire gli accessi. Da copiare e adattare per ogni azienda.

## Avvio di un database nuovo

1. `schema_completo.sql` nel SQL Editor di Supabase.
2. Creare i login in Authentication → Users.
3. La versione adattata di `esempi/utenti_esempio.sql` (dopo i login).

## Regola

Ogni nuova tabella o funzione aggiunta nel tempo va messa **sia** in un file di
migrazione da eseguire **sia** dentro `schema_completo.sql`, così il file di
riferimento resta sempre completo.
