-- =====================================================================
--  CRM ENER.ING — Email del referente nella scheda cliente
--  Esegui nel SQL Editor di Supabase. Sicuro e ri-eseguibile:
--  aggiunge solo una colonna vuota, non modifica né cancella dati.
-- =====================================================================
alter table companies add column if not exists referente_email text;
