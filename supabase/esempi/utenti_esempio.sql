-- =====================================================================
--  TEMPLATE — Persone del team e accessi (da adattare per ogni azienda)
--  1) Inserisce le persone nella sezione Ruoli (tabella agenti)
--  2) (dopo aver creato i login) forza il cambio password e assegna l'admin
--  Sostituisci i nomi/email/ruoli di esempio con quelli reali.
--  La sigla serve solo ai venditori (iniziali di nome e cognome).
-- =====================================================================

-- 1) Persone in Ruoli (ri-eseguibile: salta chi ha già quell'email)
insert into agenti (nome, cognome, ruolo, ruoli, email, sigla, attivo)
select v.nome, v.cognome, v.ruolo, array[v.ruolo]::text[], v.email, v.sigla, true
from (values
  -- nome,      cognome,   ruolo,            email,                      sigla
  ('Mario',     'Rossi',   'amministratore', 'm.rossi@azienda.it',       null),
  ('Luca',      'Bianchi', 'responsabile',   'l.bianchi@azienda.it',     null),
  ('Anna',      'Verdi',   'venditore',      'a.verdi@azienda.it',       'AV'),
  ('Sara',      'Neri',    'telemarketing',  's.neri@azienda.it',        null),
  ('Paolo',     'Gialli',  'ufficio_sole',   'p.gialli@azienda.it',      null)
) as v(nome, cognome, ruolo, email, sigla)
where not exists (
  select 1 from agenti a where lower(a.email) = lower(v.email)
);

-- 2) DOPO aver creato i login in Authentication → Users, esegui questi:

-- 2a) Cambio password forzato al primo accesso
update profiles set must_change_password = true
where lower(email) in (
  'm.rossi@azienda.it',
  'l.bianchi@azienda.it',
  'a.verdi@azienda.it',
  's.neri@azienda.it',
  'p.gialli@azienda.it'
);

-- 2b) Amministratore (permessi pieni)
update profiles set role = 'amministratore'
where lower(email) = 'm.rossi@azienda.it';
