# CRM — base riutilizzabile

Base pulita del CRM aziendale: una copia generica (senza dati di nessuna
azienda) da cui creare in pochi passi il CRM di una nuova azienda.

**Per attivare una nuova azienda: segui [`SETUP_NUOVA_AZIENDA.md`](SETUP_NUOVA_AZIENDA.md).**

## Cos'è

CRM web interno con login e password per utente. Dati condivisi nel team,
permessi gestiti a livello di database (RLS). Una copia separata per azienda
(non multi-tenant).

## Stack

- **Next.js 14** (App Router, Server Components, Server Actions) + **TypeScript**
- **Tailwind CSS** per la grafica (modalità chiara/scura)
- **Supabase** per database (PostgreSQL), autenticazione e sicurezza per riga (RLS)
- Deploy su **Vercel** (automatico da GitHub)

## Sezioni

Dashboard, Agenda, Clienti, Preventivi/Gare, Cantieri, Curriculum, Performance,
Provvigioni, Ruoli, Bacheca, Suggerimenti, Ticket, Notifiche (campanella).

## Punti da personalizzare per ogni azienda

- `public/logo.png` — il logo
- `tailwind.config.ts` — il colore `brand`
- `app/layout.tsx` — il titolo
- `lib/types.ts` — `CATEGORIE_PREVENTIVO`
- `supabase/esempi/utenti_esempio.sql` — le persone del team

## Struttura

```
app/
  login/              accesso
  auth/signout/       logout
  cambia-password/    cambio password al primo accesso
  (app)/              area protetta (richiede login)
    dashboard/  agenda/  clienti/  preventivi/  cantieri/
    curriculum/  me/  provvigioni/  agenti/ (Ruoli)
    bacheca/  suggerimenti/  ticket/
components/            UI riutilizzabile, Sidebar, campanella notifiche, icone
lib/
  supabase/           client browser/server + middleware sessione
  types.ts            tipi + ruoli + categorie (da personalizzare)
  format.ts           formattazione valuta/date
supabase/
  schema_completo.sql strutture + permessi (da eseguire su Supabase)
  esempi/             template utenti
SETUP_NUOVA_AZIENDA.md   guida per creare un nuovo CRM
```

## Comandi

```bash
npm install
npm run dev        # sviluppo locale
npm run build      # build di produzione (fai SEMPRE questo prima di pushare)
```

## Regole di sviluppo

- **Build prima del push** (`npm run build`), altrimenti il deploy su Vercel fallisce.
- Con due relazioni verso `agenti` usa l'hint `agenti!nome_fk(...)` negli embed Supabase.
- Ogni tabella/funzione nuova va sia in una migrazione sia in `schema_completo.sql`.
