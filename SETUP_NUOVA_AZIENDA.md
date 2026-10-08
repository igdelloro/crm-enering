# CRM — Base riutilizzabile

Questa è la **base** del CRM aziendale: una copia pulita e generica, senza dati
di nessuna azienda. Da qui si crea in pochi passi il CRM di una nuova azienda
(es. SOLE, Riva, Ener.ing).

Tecnologie: Next.js 14 (App Router, TypeScript), Tailwind CSS, Supabase
(PostgreSQL + Auth + RLS). Front-end su Vercel (deploy automatico da GitHub),
database e login su Supabase. Una copia separata per azienda (non multi-tenant).

---

## Creare il CRM di una nuova azienda

1. **Repository.** Da questo repo "Use this template" → crea il nuovo repo
   (es. `crm-<azienda>`).

2. **Vercel.** Crea un nuovo progetto Vercel collegato al repo. Lascia le
   variabili d'ambiente vuote per ora (le metti al punto 4).

3. **Supabase.** Crea un nuovo progetto Supabase. Apri **SQL Editor** ed esegui
   tutto il contenuto di `supabase/schema_completo.sql`: crea tabelle, funzioni
   e permessi. È idempotente (si può rieseguire senza danni).

4. **Collega Vercel a Supabase.** In Supabase → Project Settings → API copia
   *Project URL* e *anon public key*. In Vercel → Settings → Environment
   Variables aggiungi:
   - `NEXT_PUBLIC_SUPABASE_URL` = il Project URL
   - `NEXT_PUBLIC_SUPABASE_ANON_KEY` = la anon public key
   Poi fai un nuovo deploy.

5. **Marchio.** Personalizza:
   - `public/logo.png` → il logo dell'azienda
   - `tailwind.config.ts` → il token colore `brand` (colore principale)
   - `app/layout.tsx` → il titolo della scheda browser
   - `lib/types.ts` → `CATEGORIE_PREVENTIVO` (categorie dei preventivi)

6. **Persone e accessi.**
   - Adatta `supabase/esempi/utenti_esempio.sql` (nomi, email, ruoli, sigle dei
     venditori) ed eseguilo in Supabase.
   - Crea i login in Supabase → **Authentication → Users** (una password
     provvisoria per ciascuno).
   - Esegui l'UPDATE finale in `utenti_esempio.sql` per forzare il cambio
     password al primo accesso e per dare il ruolo amministratore a chi di
     dovere.

7. **Verifica.** Fai `npm install` e `npm run build` in locale prima di ogni
   push (così Vercel non fallisce). Poi push su `main` → Vercel fa il deploy.

---

## Cosa cambia da azienda ad azienda

Quasi tutto è riutilizzabile così com'è (permessi, agenda, clienti, cantieri,
bacheca, suggerimenti, notifiche, dashboard). Si personalizzano di solito solo:

- **Categorie preventivi** (`lib/types.ts` → `CATEGORIE_PREVENTIVO`)
- Se servono le **gare PA** (la base le include; si possono nascondere)
- Se c'è un reparto **telemarketing** e quindi il **semaforo** (inclusi nella base)
- I **nomi** di alcune sezioni (es. "Cantieri" → "Commesse")
- I **ruoli** del team

---

## Regole di lavoro (per chi sviluppa)

- **Build prima del push**: sempre `npm run build` in locale. Errore tipico:
  apostrofi non "escaped" nel JSX → usa `&apos;` o riscrivi la frase.
- **Embed Supabase ambiguo**: quando una tabella ha due relazioni verso
  `agenti` (es. preventivi: venditore + tlmk), usa l'hint
  `agenti!nome_fk(...)` oppure risolvi i nomi lato client, altrimenti le query
  falliscono in silenzio.
- Ogni nuova tabella/funzione del database va messa **sia** in un file di
  migrazione da eseguire **sia** aggiunta a `supabase/schema_completo.sql`.
