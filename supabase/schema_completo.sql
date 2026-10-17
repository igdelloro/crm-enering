-- =====================================================================
--  CRM TEAM — SCHEMA COMPLETO (riallineamento unico)
--  Esegui UNA VOLTA nel SQL Editor di Supabase. È SICURA e NON cancella
--  dati: ricrea solo ciò che manca e riallinea permessi e funzioni.
--  Puoi rieseguirla quante volte vuoi senza danni.
--  Sostituisce la necessità di tenere traccia delle singole migrazioni.
-- =====================================================================

-- Le funzioni possono citare tabelle create più sotto (come fa pg_dump).
set check_function_bodies = off;

-- ------------------------- TIPI (enum) -------------------------------
do $$ begin create type deal_stage as enum
  ('lead','qualificato','proposta','negoziazione','vinta','persa');
exception when duplicate_object then null; end $$;

do $$ begin create type ticket_status as enum
  ('aperto','in_lavorazione','in_attesa','chiuso');
exception when duplicate_object then null; end $$;

do $$ begin create type ticket_priority as enum
  ('bassa','media','alta','urgente');
exception when duplicate_object then null; end $$;

do $$ begin create type tipo_cliente as enum ('pa','societa','privato');
exception when duplicate_object then null; end $$;

do $$ begin create type tipo_evento as enum
  ('contatto','whatsapp','visita','scadenza','vendita','preventivo','gara');
exception when duplicate_object then null; end $$;

-- ------------------------- FUNZIONI ----------------------------------
create or replace function set_updated_at()
returns trigger language plpgsql as $$
begin new.updated_at = now(); return new; end; $$;

create or replace function is_responsabile()
returns boolean language sql security definer set search_path = public stable as $$
  select exists (select 1 from profiles where id = auth.uid() and role in ('responsabile','amministratore'));
$$;

create or replace function handle_new_user()
returns trigger language plpgsql security definer set search_path = public as $$
begin
  insert into public.profiles (id, email, full_name)
  values (new.id, new.email, coalesce(new.raw_user_meta_data->>'full_name', new.email))
  on conflict (id) do nothing;
  return new;
end; $$;

-- ------------------------- PROFILI -----------------------------------
create table if not exists profiles (
  id uuid primary key references auth.users(id) on delete cascade,
  full_name text, email text, role text not null default 'membro',
  created_at timestamptz not null default now()
);

drop trigger if exists on_auth_user_created on auth.users;
create trigger on_auth_user_created after insert on auth.users
  for each row execute function handle_new_user();

-- ------------------------- AGENTI ------------------------------------
create table if not exists agenti (
  id uuid primary key default gen_random_uuid(),
  nome text not null, cognome text,
  ruolo text not null default 'venditore',
  ruoli text[] not null default '{}',
  email text, attivo boolean not null default true,
  profile_id uuid references profiles(id) on delete set null,
  ics_token uuid not null default gen_random_uuid(),
  created_at timestamptz not null default now()
);
alter table agenti add column if not exists ics_token uuid not null default gen_random_uuid();
alter table agenti add column if not exists sigla text;
alter table agenti add column if not exists ruoli text[] not null default '{}';
update agenti set ruoli = array[ruolo]::text[]
  where (ruoli is null or cardinality(ruoli) = 0) and ruolo is not null;

-- ------------------------- CLIENTI (companies) -----------------------
create table if not exists companies (
  id uuid primary key default gen_random_uuid(),
  name text not null,
  tipo tipo_cliente not null default 'societa',
  piva text, codice_fiscale text, codice_univoco text, codice_sdi text, pec text,
  nome text, cognome text,
  website text, industry text, phone text, address text,
  cap text, citta text, provincia text, regione text,
  referente_nome text, referente_ruolo text, referente_contatto text,
  tlmk_agente_id uuid references agenti(id) on delete set null,
  venditore_agente_id uuid references agenti(id) on delete set null,
  last_contact_at timestamptz, flag_manuale text,
  notes text,
  owner_id uuid references profiles(id) on delete set null,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);
-- colonne aggiunte nel tempo (per database già esistenti)
alter table companies add column if not exists tipo tipo_cliente not null default 'societa';
alter table companies add column if not exists piva text;
alter table companies add column if not exists codice_fiscale text;
alter table companies add column if not exists codice_univoco text;
alter table companies add column if not exists codice_sdi text;
alter table companies add column if not exists pec text;
alter table companies add column if not exists nome text;
alter table companies add column if not exists cognome text;
alter table companies add column if not exists cap text;
alter table companies add column if not exists citta text;
alter table companies add column if not exists provincia text;
alter table companies add column if not exists regione text;
alter table companies add column if not exists referente_nome text;
alter table companies add column if not exists referente_ruolo text;
alter table companies add column if not exists referente_contatto text;
alter table companies add column if not exists tlmk_agente_id uuid references agenti(id) on delete set null;
alter table companies add column if not exists venditore_agente_id uuid references agenti(id) on delete set null;
alter table companies add column if not exists last_contact_at timestamptz;
alter table companies add column if not exists flag_manuale text;
-- Numero di abitanti (utile per i Comuni / clienti PA)
alter table companies add column if not exists abitanti integer;
create index if not exists companies_abitanti_idx on companies (abitanti);

drop trigger if exists trg_companies_updated on companies;
create trigger trg_companies_updated before update on companies
  for each row execute function set_updated_at();

-- ------------------------- CONTATTI (referenti) ----------------------
create table if not exists contacts (
  id uuid primary key default gen_random_uuid(),
  first_name text not null, last_name text, email text, phone text, job_title text,
  company_id uuid references companies(id) on delete set null,
  owner_id uuid references profiles(id) on delete set null,
  notes text,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);
drop trigger if exists trg_contacts_updated on contacts;
create trigger trg_contacts_updated before update on contacts
  for each row execute function set_updated_at();

-- ------------------------- TRATTATIVE (deals) ------------------------
create table if not exists deals (
  id uuid primary key default gen_random_uuid(),
  title text not null,
  company_id uuid references companies(id) on delete set null,
  contact_id uuid references contacts(id) on delete set null,
  value numeric(14,2) not null default 0, currency text not null default 'EUR',
  stage deal_stage not null default 'lead', expected_close_date date,
  owner_id uuid references profiles(id) on delete set null, notes text,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);
drop trigger if exists trg_deals_updated on deals;
create trigger trg_deals_updated before update on deals
  for each row execute function set_updated_at();

-- ------------------------- TICKET ------------------------------------
create table if not exists tickets (
  id uuid primary key default gen_random_uuid(),
  subject text not null, description text,
  company_id uuid references companies(id) on delete set null,
  contact_id uuid references contacts(id) on delete set null,
  status ticket_status not null default 'aperto',
  priority ticket_priority not null default 'media',
  assignee_id uuid references profiles(id) on delete set null,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);
drop trigger if exists trg_tickets_updated on tickets;
create trigger trg_tickets_updated before update on tickets
  for each row execute function set_updated_at();

-- ------------------------- EVENTI (cronologia) -----------------------
create table if not exists eventi (
  id uuid primary key default gen_random_uuid(),
  company_id uuid not null references companies(id) on delete cascade,
  tipo tipo_evento not null default 'contatto',
  data timestamptz not null default now(),
  causale text, dettagli text, importo numeric(14,2),
  created_by uuid references profiles(id) on delete set null,
  created_at timestamptz not null default now()
);

create or replace function evento_aggiorna_contatto()
returns trigger language plpgsql security definer set search_path = public as $$
begin
  if new.tipo in ('contatto','whatsapp','visita') then
    update companies set last_contact_at = greatest(coalesce(last_contact_at, new.data), new.data)
      where id = new.company_id;
  end if; return new;
end; $$;
drop trigger if exists trg_evento_contatto on eventi;
create trigger trg_evento_contatto after insert on eventi
  for each row execute function evento_aggiorna_contatto();

-- ------------------------- AGENDA ------------------------------------
create table if not exists appuntamenti (
  id uuid primary key default gen_random_uuid(),
  agente_id uuid not null references agenti(id) on delete cascade,
  company_id uuid references companies(id) on delete set null,
  titolo text not null, inizio timestamptz not null, fine timestamptz,
  luogo text, note text,
  created_by uuid references profiles(id) on delete set null,
  created_at timestamptz not null default now()
);

create table if not exists appuntamento_agenti (
  appuntamento_id uuid not null references appuntamenti(id) on delete cascade,
  agente_id uuid not null references agenti(id) on delete cascade,
  primary key (appuntamento_id, agente_id)
);

-- ogni appuntamento ha come partecipante almeno il suo agente
insert into appuntamento_agenti (appuntamento_id, agente_id)
  select id, agente_id from appuntamenti on conflict do nothing;

create or replace function agenda_feed(p_token uuid)
returns table (id uuid, titolo text, inizio timestamptz, fine timestamptz,
               luogo text, note text, cliente text)
language sql security definer set search_path = public stable as $$
  select a.id, a.titolo, a.inizio, a.fine, a.luogo, a.note, c.name
  from appuntamenti a
  join appuntamento_agenti pa on pa.appuntamento_id = a.id
  join agenti ag on ag.id = pa.agente_id
  left join companies c on c.id = a.company_id
  where ag.ics_token = p_token
  order by a.inizio;
$$;
grant execute on function agenda_feed(uuid) to anon, authenticated;

-- ------------------------- INDICI ------------------------------------
create index if not exists idx_contacts_company on contacts(company_id);
create index if not exists idx_deals_company on deals(company_id);
create index if not exists idx_deals_stage on deals(stage);
create index if not exists idx_tickets_status on tickets(status);
create index if not exists idx_tickets_company on tickets(company_id);
create index if not exists idx_companies_tipo on companies(tipo);
create index if not exists idx_companies_regione on companies(regione);
create index if not exists idx_companies_tlmk on companies(tlmk_agente_id);
create index if not exists idx_companies_venditore on companies(venditore_agente_id);
create index if not exists idx_eventi_company on eventi(company_id);
create index if not exists idx_eventi_data on eventi(data desc);
create index if not exists idx_appuntamenti_agente on appuntamenti(agente_id);
create index if not exists idx_appuntamenti_inizio on appuntamenti(inizio);
create index if not exists idx_app_agenti_agente on appuntamento_agenti(agente_id);

-- =====================================================================
--  SICUREZZA (Row Level Security) — riallineata per tutte le tabelle
-- =====================================================================
alter table profiles enable row level security;
alter table agenti enable row level security;
alter table companies enable row level security;
alter table contacts enable row level security;
alter table deals enable row level security;
alter table tickets enable row level security;
alter table eventi enable row level security;
alter table appuntamenti enable row level security;
alter table appuntamento_agenti enable row level security;

-- profili
drop policy if exists "profili leggibili dagli autenticati" on profiles;
create policy "profili leggibili dagli autenticati" on profiles for select to authenticated using (true);
drop policy if exists "ognuno modifica il proprio profilo" on profiles;
create policy "ognuno modifica il proprio profilo" on profiles for update to authenticated using (auth.uid() = id);

-- agenti
drop policy if exists "agenti: accesso team" on agenti;
create policy "agenti: accesso team" on agenti for all to authenticated using (true) with check (true);

-- clienti
drop policy if exists "aziende: accesso team" on companies;
drop policy if exists "clienti: lettura team" on companies;
drop policy if exists "clienti: inserimento team" on companies;
drop policy if exists "clienti: modifica team" on companies;
drop policy if exists "clienti: cancellazione responsabili" on companies;
create policy "clienti: lettura team" on companies for select to authenticated using (true);
create policy "clienti: inserimento team" on companies for insert to authenticated with check (true);
create policy "clienti: modifica team" on companies for update to authenticated using (true) with check (true);
create policy "clienti: cancellazione responsabili" on companies for delete to authenticated using (is_responsabile());

-- contatti / trattative / ticket (accesso team)
drop policy if exists "contatti: accesso team" on contacts;
create policy "contatti: accesso team" on contacts for all to authenticated using (true) with check (true);
drop policy if exists "trattative: accesso team" on deals;
create policy "trattative: accesso team" on deals for all to authenticated using (true) with check (true);
drop policy if exists "ticket: accesso team" on tickets;
create policy "ticket: accesso team" on tickets for all to authenticated using (true) with check (true);

-- eventi
drop policy if exists "eventi: lettura team" on eventi;
drop policy if exists "eventi: inserimento team" on eventi;
drop policy if exists "eventi: modifica team" on eventi;
drop policy if exists "eventi: cancellazione responsabili" on eventi;
create policy "eventi: lettura team" on eventi for select to authenticated using (true);
create policy "eventi: inserimento team" on eventi for insert to authenticated with check (true);
create policy "eventi: modifica team" on eventi for update to authenticated using (true) with check (true);
create policy "eventi: cancellazione responsabili" on eventi for delete to authenticated using (is_responsabile());

-- appuntamenti
drop policy if exists "appuntamenti: lettura team" on appuntamenti;
drop policy if exists "appuntamenti: inserimento team" on appuntamenti;
drop policy if exists "appuntamenti: modifica team" on appuntamenti;
drop policy if exists "appuntamenti: cancellazione responsabili" on appuntamenti;
create policy "appuntamenti: lettura team" on appuntamenti for select to authenticated using (true);
create policy "appuntamenti: inserimento team" on appuntamenti for insert to authenticated with check (true);
create policy "appuntamenti: modifica team" on appuntamenti for update to authenticated using (true) with check (true);
create policy "appuntamenti: cancellazione responsabili" on appuntamenti for delete to authenticated using (is_responsabile());

-- partecipanti
drop policy if exists "partecipanti: accesso team" on appuntamento_agenti;
create policy "partecipanti: accesso team" on appuntamento_agenti for all to authenticated using (true) with check (true);

-- ------------------------- PREVENTIVI / GARE -------------------------
alter table agenti add column if not exists sigla text;

create table if not exists numeratori (
  sigla text not null, anno int not null, ultimo int not null default 0,
  primary key (sigla, anno)
);
alter table numeratori enable row level security;

create table if not exists preventivi (
  id uuid primary key default gen_random_uuid(),
  numero text unique, sigla text, anno int, progressivo int,
  company_id uuid not null references companies(id) on delete cascade,
  venditore_agente_id uuid references agenti(id) on delete set null,
  tlmk_agente_id uuid references agenti(id) on delete set null,
  tipo text not null default 'preventivo', sottotipo text,
  oggetto text, importo numeric(14,2), base_gara numeric(14,2), ribasso numeric(6,2),
  cig text, cup text, riferimento text,
  stato text not null default 'bozza', data_scadenza date, note text,
  created_by uuid references profiles(id) on delete set null,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);
alter table preventivi add column if not exists tlmk_agente_id uuid references agenti(id) on delete set null;
alter table preventivi add column if not exists categoria text;
create index if not exists idx_preventivi_company on preventivi(company_id);
create index if not exists idx_preventivi_venditore on preventivi(venditore_agente_id);
create index if not exists idx_preventivi_tlmk on preventivi(tlmk_agente_id);
create index if not exists idx_preventivi_stato on preventivi(stato);
create index if not exists idx_preventivi_tipo on preventivi(tipo);

drop trigger if exists trg_preventivi_updated on preventivi;
create trigger trg_preventivi_updated before update on preventivi
  for each row execute function set_updated_at();

create or replace function sigla_preventivo(p_tipo text, p_sottotipo text, p_venditore uuid)
returns text language sql security definer set search_path = public stable as $$
  select case
    when p_tipo = 'gara' and p_sottotipo in ('aperta','invito') then 'GARA'
    else coalesce((select upper(coalesce(nullif(a.sigla,''), left(a.nome,1)||left(coalesce(a.cognome,''),1)))
                   from agenti a where a.id = p_venditore), 'XX')
  end;
$$;

create or replace function assegna_numero_preventivo()
returns trigger language plpgsql security definer set search_path = public as $$
declare v_sigla text; v_anno int; v_prog int;
begin
  if new.numero is not null and new.numero <> '' then return new; end if;
  v_sigla := sigla_preventivo(new.tipo, new.sottotipo, new.venditore_agente_id);
  v_anno := extract(year from coalesce(new.created_at, now()))::int;
  insert into numeratori (sigla, anno, ultimo) values (v_sigla, v_anno, 1)
    on conflict (sigla, anno) do update set ultimo = numeratori.ultimo + 1
    returning ultimo into v_prog;
  new.sigla := v_sigla; new.anno := v_anno; new.progressivo := v_prog;
  new.numero := v_sigla || v_anno::text || '.' || lpad(v_prog::text, 3, '0');
  return new;
end; $$;
drop trigger if exists trg_preventivi_numero on preventivi;
create trigger trg_preventivi_numero before insert on preventivi
  for each row execute function assegna_numero_preventivo();

create or replace function rinumera_preventivo()
returns trigger language plpgsql security definer set search_path = public as $$
declare v_sigla text; v_anno int; v_prog int;
begin
  if new.venditore_agente_id is distinct from old.venditore_agente_id
     or new.tipo is distinct from old.tipo
     or new.sottotipo is distinct from old.sottotipo then
    v_sigla := sigla_preventivo(new.tipo, new.sottotipo, new.venditore_agente_id);
    v_anno := coalesce(old.anno, extract(year from old.created_at)::int);
    if v_sigla = old.sigla then return new; end if;
    insert into numeratori (sigla, anno, ultimo) values (v_sigla, v_anno, 1)
      on conflict (sigla, anno) do update set ultimo = numeratori.ultimo + 1
      returning ultimo into v_prog;
    new.sigla := v_sigla; new.anno := v_anno; new.progressivo := v_prog;
    new.numero := v_sigla || v_anno::text || '.' || lpad(v_prog::text, 3, '0');
  end if;
  return new;
end; $$;
drop trigger if exists trg_preventivi_rinumera on preventivi;
create trigger trg_preventivi_rinumera before update on preventivi
  for each row execute function rinumera_preventivo();

alter table preventivi enable row level security;
drop policy if exists "preventivi: lettura team" on preventivi;
drop policy if exists "preventivi: inserimento team" on preventivi;
drop policy if exists "preventivi: modifica team" on preventivi;
drop policy if exists "preventivi: cancellazione responsabili" on preventivi;
create policy "preventivi: lettura team" on preventivi for select to authenticated using (true);
create policy "preventivi: inserimento team" on preventivi for insert to authenticated with check (true);
create policy "preventivi: modifica team" on preventivi for update to authenticated using (true) with check (true);
create policy "preventivi: cancellazione responsabili" on preventivi for delete to authenticated using (is_responsabile());

-- ------------------------- CANTIERI ----------------------------------
create table if not exists cantieri (
  id uuid primary key default gen_random_uuid(),
  preventivo_id uuid unique references preventivi(id) on delete set null,
  company_id uuid references companies(id) on delete set null,
  titolo text, fase text not null default 'da_pianificare',
  responsabile_agente_id uuid references agenti(id) on delete set null,
  importo numeric(14,2), note text, ordine int not null default 0,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);
alter table cantieri add column if not exists in_cv boolean not null default false;
create index if not exists idx_cantieri_fase on cantieri(fase);
create index if not exists idx_cantieri_company on cantieri(company_id);
drop trigger if exists trg_cantieri_updated on cantieri;
create trigger trg_cantieri_updated before update on cantieri
  for each row execute function set_updated_at();

create table if not exists cantiere_task (
  id uuid primary key default gen_random_uuid(),
  cantiere_id uuid not null references cantieri(id) on delete cascade,
  descrizione text not null,
  assegnato_agente_id uuid references agenti(id) on delete set null,
  fatto boolean not null default false, scadenza date, ordine int not null default 0,
  created_at timestamptz not null default now()
);
create index if not exists idx_task_cantiere on cantiere_task(cantiere_id);

create or replace function crea_cantiere_da_preventivo()
returns trigger language plpgsql security definer set search_path = public as $$
begin
  if new.stato in ('aggiudicata', 'accettato') then
    insert into cantieri (preventivo_id, company_id, titolo, importo)
    select new.id, new.company_id, coalesce(nullif(new.oggetto,''), new.numero, 'Commessa'), new.importo
    where not exists (select 1 from cantieri where preventivo_id = new.id);
  end if;
  return new;
end; $$;
drop trigger if exists trg_crea_cantiere on preventivi;
create trigger trg_crea_cantiere after insert or update on preventivi
  for each row execute function crea_cantiere_da_preventivo();

alter table cantieri enable row level security;
alter table cantiere_task enable row level security;
drop policy if exists "cantieri: lettura team" on cantieri;
drop policy if exists "cantieri: inserimento team" on cantieri;
drop policy if exists "cantieri: modifica team" on cantieri;
drop policy if exists "cantieri: cancellazione responsabili" on cantieri;
create policy "cantieri: lettura team" on cantieri for select to authenticated using (true);
create policy "cantieri: inserimento team" on cantieri for insert to authenticated with check (true);
create policy "cantieri: modifica team" on cantieri for update to authenticated using (true) with check (true);
create policy "cantieri: cancellazione responsabili" on cantieri for delete to authenticated using (is_responsabile());
drop policy if exists "task: accesso team" on cantiere_task;
create policy "task: accesso team" on cantiere_task for all to authenticated using (true) with check (true);

-- =====================================================================
--  NOTA: per nominare un responsabile (permesso di cancellare), esegui
--  con la sua email, dopo che si è registrato:
--    update profiles set role = 'responsabile' where email = 'mario@esempio.it';
-- =====================================================================
-- =====================================================================
--  CRM TEAM — Migrazione FASE 8 (Provvigioni)
--  Da eseguire UNA VOLTA nel SQL Editor di Supabase. Additiva e sicura.
--  Ogni agente vede SOLO le proprie provvigioni; solo responsabili e
--  amministratori possono inserirle/modificarle/cancellarle.
-- =====================================================================

-- Chi è responsabile o amministratore (account di login)
create or replace function is_resp_or_admin()
returns boolean language sql security definer set search_path = public stable as $$
  select exists (
    select 1 from profiles
    where id = auth.uid() and role in ('responsabile','amministratore')
  );
$$;

-- L'agente collegato all'utente loggato (match per email)
create or replace function mio_agente_id()
returns uuid language sql security definer set search_path = public stable as $$
  select a.id from agenti a
  where a.email = (select email from auth.users where id = auth.uid())
  limit 1;
$$;

create table if not exists provvigioni (
  id           uuid primary key default gen_random_uuid(),
  agente_id    uuid not null references agenti(id) on delete cascade,
  preventivo_id uuid references preventivi(id) on delete set null,
  periodo      text,                     -- es. '2026' oppure '2026-10'
  imponibile   numeric(14,2),            -- base su cui si calcola
  percentuale  numeric(6,2),
  importo      numeric(14,2),            -- importo provvigione
  stato        text not null default 'da_liquidare',  -- 'da_liquidare' | 'liquidata'
  note         text,
  created_by   uuid references profiles(id) on delete set null,
  created_at   timestamptz not null default now(),
  updated_at   timestamptz not null default now()
);
create index if not exists idx_provvigioni_agente on provvigioni(agente_id);
create index if not exists idx_provvigioni_stato on provvigioni(stato);

drop trigger if exists trg_provvigioni_updated on provvigioni;
create trigger trg_provvigioni_updated before update on provvigioni
  for each row execute function set_updated_at();

alter table provvigioni enable row level security;

drop policy if exists "provvigioni: lettura propria o resp" on provvigioni;
create policy "provvigioni: lettura propria o resp"
  on provvigioni for select to authenticated
  using (is_resp_or_admin() or agente_id = mio_agente_id());

drop policy if exists "provvigioni: scrittura resp" on provvigioni;
create policy "provvigioni: scrittura resp"
  on provvigioni for all to authenticated
  using (is_resp_or_admin()) with check (is_resp_or_admin());
-- =====================================================================
--  CRM TEAM — Migrazione FASE 10 (Controllo accessi + cambio password)
--  - "must_change_password": obbliga il cambio password al primo accesso
--  - funzione per verificare se un account può entrare:
--      ammesso se amministratore, OPPURE presente e attivo in Ruoli (agenti)
--  Da eseguire UNA VOLTA nel SQL Editor di Supabase. Additiva e sicura.
-- =====================================================================

alter table profiles add column if not exists must_change_password boolean not null default false;

-- Vero se l'utente loggato può accedere al CRM:
--  - è amministratore (sempre ammesso), oppure
--  - esiste una persona ATTIVA in Ruoli con la sua stessa email
create or replace function puo_accedere()
returns boolean
language sql security definer set search_path = public stable
as $$
  select
    exists (select 1 from profiles where id = auth.uid() and role = 'amministratore')
    or exists (
      select 1 from agenti a
      where a.attivo = true
        and lower(a.email) = lower((select email from auth.users where id = auth.uid()))
    );
$$;

grant execute on function puo_accedere() to authenticated;

-- =====================================================================
--  CRM TEAM — FASE 11 (Permessi di gestione legati ai TAG Ruoli)
--  "Gestore" = puo vedere tutto e gestire (Ruoli, Provvigioni, cancellazioni).
--  E gestore chi ha ruolo di login amministratore/responsabile OPPURE
--  e presente e ATTIVO in Ruoli con tag 'responsabile'/'amministratore'.
--  Ridefinisce is_responsabile e is_resp_or_admin su questo criterio unico.
-- =====================================================================

create or replace function puo_gestire()
returns boolean
language sql security definer set search_path = public stable
as $$
  select
    exists (
      select 1 from profiles
      where id = auth.uid() and role in ('amministratore','responsabile')
    )
    or exists (
      select 1 from agenti a
      where a.attivo = true
        and lower(a.email) = lower((select email from auth.users where id = auth.uid()))
        and a.ruoli && array['responsabile','amministratore']::text[]
    );
$$;
grant execute on function puo_gestire() to authenticated;

create or replace function is_responsabile()
returns boolean language sql security definer set search_path = public stable
as $$ select puo_gestire(); $$;

create or replace function is_resp_or_admin()
returns boolean language sql security definer set search_path = public stable
as $$ select puo_gestire(); $$;

-- Vero se l'utente loggato ha la tag "venditore" in Ruoli (attivo)
create or replace function e_venditore()
returns boolean
language sql security definer set search_path = public stable
as $$
  select exists (
    select 1 from agenti a
    where a.attivo = true
      and lower(a.email) = lower((select email from auth.users where id = auth.uid()))
      and 'venditore' = any(a.ruoli)
  );
$$;
grant execute on function e_venditore() to authenticated;

-- ------------------------- BACHECA (annunci) ------------------------
create table if not exists annunci (
  id uuid primary key default gen_random_uuid(),
  titolo text not null,
  corpo text,
  created_by uuid references profiles(id) on delete set null,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

drop trigger if exists trg_annunci_updated on annunci;
create trigger trg_annunci_updated before update on annunci
  for each row execute function set_updated_at();

alter table annunci enable row level security;

drop policy if exists "annunci: lettura tutti" on annunci;
create policy "annunci: lettura tutti"
  on annunci for select to authenticated using (true);

drop policy if exists "annunci: scrittura gestori" on annunci;
create policy "annunci: scrittura gestori"
  on annunci for all to authenticated
  using (puo_gestire()) with check (puo_gestire());

-- ---------------------------- SUGGERIMENTI ---------------------------
create table if not exists suggerimenti (
  id uuid primary key default gen_random_uuid(),
  sezione text,
  titolo text not null,
  descrizione text,
  risolto boolean not null default false,
  priorita text not null default 'bassa',      -- 'bassa' | 'media' | 'alta'
  created_by uuid references profiles(id) on delete set null,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);
create index if not exists idx_suggerimenti_risolto on suggerimenti(risolto);

drop trigger if exists trg_suggerimenti_updated on suggerimenti;
create trigger trg_suggerimenti_updated before update on suggerimenti
  for each row execute function set_updated_at();

alter table suggerimenti enable row level security;

-- Tutti i loggati leggono e creano un suggerimento
drop policy if exists "suggerimenti: lettura tutti" on suggerimenti;
create policy "suggerimenti: lettura tutti"
  on suggerimenti for select to authenticated using (true);

drop policy if exists "suggerimenti: inserimento tutti" on suggerimenti;
create policy "suggerimenti: inserimento tutti"
  on suggerimenti for insert to authenticated with check (true);

-- Modifica / elimina (triage: risolto, priorita...) solo gestori
drop policy if exists "suggerimenti: modifica gestori" on suggerimenti;
create policy "suggerimenti: modifica gestori"
  on suggerimenti for update to authenticated
  using (puo_gestire()) with check (puo_gestire());

drop policy if exists "suggerimenti: elimina gestori" on suggerimenti;
create policy "suggerimenti: elimina gestori"
  on suggerimenti for delete to authenticated using (puo_gestire());

create table if not exists notifiche (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references profiles(id) on delete cascade,
  tipo text,
  titolo text not null,
  corpo text,
  link text,
  letta boolean not null default false,
  created_at timestamptz not null default now()
);
create index if not exists idx_notifiche_user on notifiche(user_id, letta);

alter table notifiche enable row level security;

drop policy if exists "notifiche: lettura propria" on notifiche;
create policy "notifiche: lettura propria"
  on notifiche for select to authenticated using (user_id = auth.uid());

drop policy if exists "notifiche: aggiorna propria" on notifiche;
create policy "notifiche: aggiorna propria"
  on notifiche for update to authenticated
  using (user_id = auth.uid()) with check (user_id = auth.uid());

drop policy if exists "notifiche: elimina propria" on notifiche;
create policy "notifiche: elimina propria"
  on notifiche for delete to authenticated using (user_id = auth.uid());

-- Profilo (account di login) collegato a un agente, tramite email
create or replace function profilo_da_agente(p_agente uuid)
returns uuid language sql security definer set search_path = public stable
as $$
  select p.id from profiles p
  join agenti a on lower(a.email) = lower(p.email)
  where a.id = p_agente
  limit 1;
$$;

-- -------- Notifiche sui preventivi (venditore e TLMK) --------
create or replace function notifica_preventivo()
returns trigger language plpgsql security definer set search_path = public
as $$
declare
  uid uuid := auth.uid();
  pv uuid;
  pt uuid;
  dest text := '/clienti/' || coalesce(new.company_id::text, '');
begin
  -- Venditore a cui è intestato il preventivo
  if (tg_op = 'INSERT'
        or new.venditore_agente_id is distinct from old.venditore_agente_id)
     and new.venditore_agente_id is not null then
    pv := profilo_da_agente(new.venditore_agente_id);
    if pv is not null and pv <> coalesce(uid, '00000000-0000-0000-0000-000000000000'::uuid) then
      insert into notifiche(user_id, tipo, titolo, link)
      values (pv, 'preventivo',
        'Nuovo preventivo a tuo nome: ' || coalesce(new.numero, '(senza numero)'),
        dest);
    end if;
  end if;

  -- TLMK indicato nel preventivo
  if (tg_op = 'INSERT'
        or new.tlmk_agente_id is distinct from old.tlmk_agente_id)
     and new.tlmk_agente_id is not null then
    pt := profilo_da_agente(new.tlmk_agente_id);
    if pt is not null and pt <> coalesce(uid, '00000000-0000-0000-0000-000000000000'::uuid) then
      insert into notifiche(user_id, tipo, titolo, link)
      values (pt, 'preventivo_tlmk',
        'Sei indicato come TLMK nel preventivo ' || coalesce(new.numero, ''),
        dest);
    end if;
  end if;

  return new;
end;
$$;

drop trigger if exists trg_notifica_preventivo on preventivi;
create trigger trg_notifica_preventivo
  after insert or update on preventivi
  for each row execute function notifica_preventivo();

-- -------- Notifiche sugli appuntamenti (partecipanti) --------
create or replace function notifica_appuntamento()
returns trigger language plpgsql security definer set search_path = public
as $$
declare
  uid uuid := auth.uid();
  p uuid;
  t text;
begin
  p := profilo_da_agente(new.agente_id);
  if p is not null and p <> coalesce(uid, '00000000-0000-0000-0000-000000000000'::uuid) then
    select titolo into t from appuntamenti where id = new.appuntamento_id;
    insert into notifiche(user_id, tipo, titolo, link)
    values (p, 'appuntamento',
      'Sei stato aggiunto a un appuntamento: ' || coalesce(t, ''),
      '/agenda');
  end if;
  return new;
end;
$$;

drop trigger if exists trg_notifica_appuntamento on appuntamento_agenti;
create trigger trg_notifica_appuntamento
  after insert on appuntamento_agenti
  for each row execute function notifica_appuntamento();
