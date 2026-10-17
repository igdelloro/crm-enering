-- =====================================================================
--  CRM ENER.ING — Abitanti dei clienti + Comuni della provincia di Verona
--  Esegui nel SQL Editor di Supabase. Sicuro e ri-eseguibile:
--   * aggiunge la colonna "abitanti" ai clienti (se manca);
--   * inserisce i 98 Comuni della provincia di Verona come clienti PA,
--     saltando quelli già presenti con lo stesso nome;
--   * aggiorna il numero di abitanti dei Comuni già presenti.
--  Fonte abitanti: Istat, popolazione stimata al 01/01/2026 (via tuttitalia.it).
-- =====================================================================

alter table companies add column if not exists abitanti integer;
create index if not exists companies_abitanti_idx on companies (abitanti);

with comuni(comune, abitanti) as (values
  ('Affi', 2504),
  ('Albaredo d''Adige', 5298),
  ('Angiari', 2544),
  ('Arcole', 6419),
  ('Badia Calavena', 2707),
  ('Bardolino', 6816),
  ('Belfiore', 3408),
  ('Bevilacqua', 1817),
  ('Bonavigo', 1990),
  ('Boschi Sant''Anna', 1385),
  ('Bosco Chiesanuova', 3593),
  ('Bovolone', 16392),
  ('Brentino Belluno', 1368),
  ('Brenzone sul Garda', 2436),
  ('Bussolengo', 21037),
  ('Buttapietra', 7031),
  ('Caldiero', 8160),
  ('Caprino Veronese', 8775),
  ('Casaleone', 5672),
  ('Castagnaro', 3497),
  ('Castel d''Azzano', 12333),
  ('Castelnuovo del Garda', 13306),
  ('Cavaion Veronese', 5995),
  ('Cazzano di Tramigna', 1466),
  ('Cerea', 17304),
  ('Cerro Veronese', 2698),
  ('Cologna Veneta', 8543),
  ('Colognola ai Colli', 8801),
  ('Concamarise', 1060),
  ('Costermano sul Garda', 3996),
  ('Dolcè', 2536),
  ('Erbè', 1922),
  ('Erbezzo', 850),
  ('Ferrara di Monte Baldo', 302),
  ('Fumane', 4193),
  ('Garda', 4044),
  ('Gazzo Veronese', 5226),
  ('Grezzana', 10775),
  ('Illasi', 5149),
  ('Isola della Scala', 11825),
  ('Isola Rizza', 3317),
  ('Lavagno', 8730),
  ('Lazise', 6771),
  ('Legnago', 26084),
  ('Malcesine', 3472),
  ('Marano di Valpolicella', 3085),
  ('Mezzane di Sotto', 2502),
  ('Minerbe', 4644),
  ('Montecchia di Crosara', 4323),
  ('Monteforte d''Alpone', 8953),
  ('Mozzecane', 8200),
  ('Negrar di Valpolicella', 16378),
  ('Nogara', 8488),
  ('Nogarole Rocca', 3888),
  ('Oppeano', 10383),
  ('Palù', 1196),
  ('Pastrengo', 3089),
  ('Pescantina', 17630),
  ('Peschiera del Garda', 10905),
  ('Povegliano Veronese', 7401),
  ('Pressana', 2511),
  ('Rivoli Veronese', 2368),
  ('Roncà', 3755),
  ('Ronco all''Adige', 6195),
  ('Roverchiara', 2596),
  ('Roverè Veronese', 2169),
  ('Roveredo di Guà', 1657),
  ('Salizzole', 3758),
  ('San Bonifacio', 21399),
  ('San Giovanni Ilarione', 4848),
  ('San Giovanni Lupatoto', 25427),
  ('San Martino Buon Albergo', 16797),
  ('San Mauro di Saline', 606),
  ('San Pietro di Morubio', 3145),
  ('San Pietro in Cariano', 12996),
  ('San Zeno di Montagna', 1544),
  ('Sanguinetto', 4318),
  ('Sant''Ambrogio di Valpolicella', 11870),
  ('Sant''Anna d''Alfaedo', 2660),
  ('Selva di Progno', 921),
  ('Soave', 7126),
  ('Sommacampagna', 14480),
  ('Sona', 17761),
  ('Sorgà', 2979),
  ('Terrazzo', 2143),
  ('Torri del Benaco', 2856),
  ('Tregnago', 5065),
  ('Trevenzuolo', 2801),
  ('Valeggio sul Mincio', 16040),
  ('Velo Veronese', 772),
  ('Verona', 255139),
  ('Veronella', 5189),
  ('Vestenanova', 2499),
  ('Vigasio', 10342),
  ('Villa Bartolomea', 5895),
  ('Villafranca di Verona', 32785),
  ('Zevio', 15937),
  ('Zimella', 4881)
),
aggiornati as (
  update companies c
  set abitanti = v.abitanti
  from comuni v
  where lower(c.name) = lower('Comune di ' || v.comune)
  returning c.id
)
insert into companies (name, tipo, citta, provincia, regione, abitanti)
select 'Comune di ' || v.comune, 'pa', v.comune, 'VR', 'Veneto', v.abitanti
from comuni v
where not exists (
  select 1 from companies c where lower(c.name) = lower('Comune di ' || v.comune)
);

-- Controllo: deve risultare 98 comuni e circa 930.842 abitanti
select count(*) as comuni_vr, sum(abitanti) as abitanti_totali
from companies
where provincia = 'VR' and tipo = 'pa' and name ilike 'Comune di %';

