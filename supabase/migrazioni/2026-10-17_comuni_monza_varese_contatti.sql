-- =====================================================================
--  CRM ENER.ING — Comuni delle province di MONZA E BRIANZA (55) e VARESE (136)
--  Un unico file: contiene due blocchi uguali, uno per provincia.
--  Esegui tutto insieme nel SQL Editor di Supabase ("Run without RLS").
-- =====================================================================

-- =====================================================================
--  CRM ENER.ING — Comuni della provincia di Monza e della Brianza con abitanti e contatti
--  Esegui nel SQL Editor di Supabase. Sicuro e ri-eseguibile (non cancella nulla):
--   * aggiunge ai clienti le colonne "abitanti" ed "email" (se mancano);
--   * inserisce i 55 Comuni della provincia di Monza e della Brianza come clienti PA;
--   * per i Comuni già presenti aggiorna gli abitanti e COMPLETA solo i campi
--     vuoti (non sovrascrive quello che avete già scritto a mano).
--  Se Supabase mostra l'avviso "Potential issues detected", scegli
--  "Run without RLS": riguarda solo la tabella d'appoggio temporanea _comuni.
--  Fonti:
--   - abitanti: Istat, popolazione stimata al 01/01/2026 (via tuttitalia.it)
--   - contatti: IndicePA (indicepa.gov.it), open data ufficiali, letti il 17/10/2026
--     Email: solo indirizzi generici (protocollo/info/segreteria/uffici),
--     mai caselle personali. Codice univoco solo se l'ufficio di fatturazione è unico.
-- =====================================================================

alter table companies add column if not exists abitanti integer;
alter table companies add column if not exists email text;
create index if not exists companies_abitanti_idx on companies (abitanti);

drop table if exists _comuni;
create temporary table _comuni (
  name text, citta text, provincia text, regione text, abitanti integer,
  cf text, indirizzo text, cap text, pec text, email text, telefono text,
  sito text, codice_univoco text
);

insert into _comuni values
  ('Comune di Agrate Brianza', 'Agrate Brianza', 'MB', 'Lombardia', 15891, '02254070150', 'Via San Paolo 24', '20864', 'comune.agratebrianza@pec.regione.lombardia.it', null, '03960511', 'http://www.comune.agratebrianza.mb.it', 'UF7HTB'),
  ('Comune di Aicurzio', 'Aicurzio', 'MB', 'Lombardia', 2072, '02310520156', 'Via Della Croce, 1', '20886', 'comune.aicurzio@pec.regione.lombardia.it', 'comune@comune.aicurzio.mb.it', '0396900067', 'www.comune.aicurzio.mb.it/', 'UFX3IU'),
  ('Comune di Albiate', 'Albiate', 'MB', 'Lombardia', 6720, '02788420152', 'Via Salvadori 1', '20847', 'comune.albiate@legalmail.it', 'segreteria@comune.albiate.mb.it', '0362932441', 'www.comune.albiate.mb.it', null),
  ('Comune di Arcore', 'Arcore', 'MB', 'Lombardia', 17938, '87003290159', 'Largo Vincenzo Vela 1', '20862', 'comune.arcore@pec.regione.lombardia.it', 'urp@comune.arcore.mb.it', null, 'www.comune.arcore.mb.it', 'UFC5ZI'),
  ('Comune di Barlassina', 'Barlassina', 'MB', 'Lombardia', 6985, '01516690151', 'Piazza Cavour, 3', '20825', 'comune.barlassina@pec.regione.lombardia.it', null, '03625770208', 'www.comune.barlassina.mb.it', 'UFTQBD'),
  ('Comune di Bellusco', 'Bellusco', 'MB', 'Lombardia', 7487, '03352640159', 'Piazza Fratelli Kennedy, 1', '20882', 'comune.bellusco@pec.regione.lombardia.it', null, '039620831', 'www.comune.bellusco.mb.it', 'UFRZ9I'),
  ('Comune di Bernareggio', 'Bernareggio', 'MB', 'Lombardia', 11706, '87001490157', 'Via S.Pertini 46', '20881', 'protocollo@comunebernareggio.org', null, '0399452100', 'www.comune.bernareggio.mb.it', 'UFIEP6'),
  ('Comune di Besana in Brianza', 'Besana in Brianza', 'MB', 'Lombardia', 15503, '01556360152', 'Via Roma, 1', '20842', 'protocollo@pec.comune.besanainbrianza.mb.it', 'protocollo@comune.besanainbrianza.mb.it', '0362922011', 'www.comune.besanainbrianza.mb.it', null),
  ('Comune di Biassono', 'Biassono', 'MB', 'Lombardia', 12430, '02336340159', 'Via San Martino 9', '20853', 'biassono@pec.it', 'SEGRETERIA@BIASSONO.ORG', '039220101', 'www.biassono.org', 'UFX0ZN'),
  ('Comune di Bovisio-Masciago', 'Bovisio-Masciago', 'MB', 'Lombardia', 16953, '03959350152', 'Piazza Oreste Biraghi, 3', '20813', 'comunebovisiomasciago@cert.legalmail.it', 'segreteria@comune.bovisiomasciago.mb.it', null, 'www.comune.bovisiomasciago.mb.it', 'UFL9TD'),
  ('Comune di Briosco', 'Briosco', 'MB', 'Lombardia', 6131, '83000230157', 'Via Roma, 4', '20836', 'comune.briosco@halleycert.it', null, null, 'www.comune.briosco.mb.it', 'UFUGTO'),
  ('Comune di Brugherio', 'Brugherio', 'MB', 'Lombardia', 35471, '03243880154', 'Piazza Cesare Battisti, 1', '20861', 'protocollo.brugherio@legalmail.it', 'urp@comune.brugherio.mb.it', '03928931', 'www.comune.brugherio.mb.it', 'UFDB7A'),
  ('Comune di Burago di Molgora', 'Burago di Molgora', 'MB', 'Lombardia', 4370, '02906850157', 'Piazza Matteotti, 12', '20875', 'comune.buragodimolgora.mb@legalmail.it', 'protocollo@comune.buragodimolgora.mb.it', '03969903207', 'www.comune.buragodimolgora.mb.it', 'UFTUU3'),
  ('Comune di Busnago', 'Busnago', 'MB', 'Lombardia', 6882, '02843410156', 'Piazzetta Marconi 3', '20874', 'protocollo.busnago@cert.saga.it', null, '0396825028', 'www.comune.busnago.mb.it', 'UFQMNR'),
  ('Comune di Camparada', 'Camparada', 'MB', 'Lombardia', 2261, '03602230157', 'Piazza Municipio, 1', '20857', 'comune.camparada@pec.regione.lombardia.it', 'segreteria@comune.camparada.mb.it', '039698541', 'https://comune.camparada.mb.it/', 'UFFXCX'),
  ('Comune di Caponago', 'Caponago', 'MB', 'Lombardia', 5050, '87003770150', 'Via Roma, 40', '20867', 'comune.caponago@legalmail.it', null, '029596981', 'www.comune.caponago.mb.it', null),
  ('Comune di Carate Brianza', 'Carate Brianza', 'MB', 'Lombardia', 18054, '01495680157', 'Piazza Battisti, 1', '20841', 'segreteria.comune.caratebrianza@pec.regione.lombardia.it', 'segreteria@comune.caratebrianza.mb.it', null, 'www.comune.caratebrianza.mb.it', 'UF7WYL'),
  ('Comune di Carnate', 'Carnate', 'MB', 'Lombardia', 7992, '87001790150', 'P.za Banfi 1', '20866', 'carnate@legalmail.it', null, '039628821', 'www.comune.carnate.mb.it', 'UF3RBQ'),
  ('Comune di Cavenago di Brianza', 'Cavenago di Brianza', 'MB', 'Lombardia', 7590, '01477970154', 'Piazza Liberta'' 18', '20873', 'protocollo@pec.comune.cavenagobrianza.mb.it', 'protocollo@comune.cavenagobrianza.mb.it', '029524141', 'www.comune.cavenagobrianza.mb.it', 'UFOT09'),
  ('Comune di Ceriano Laghetto', 'Ceriano Laghetto', 'MB', 'Lombardia', 6675, '01617320153', 'Piazza Lombardia', '20816', 'comune.ceriano-laghetto@legalmail.it', 'segreteria@comune.ceriano-laghetto.mb.it', '0296661345', 'https://www.comune.ceriano-laghetto.mb.it/', 'UFU8PL'),
  ('Comune di Cesano Maderno', 'Cesano Maderno', 'MB', 'Lombardia', 40177, '83000130159', 'P.zza Arese 12', '20811', 'protocollo@pec.comune.cesano-maderno.mb.it', 'protocollo@comune.cesano-maderno.mb.it', null, 'www.comune.cesano-maderno.mb.it', null),
  ('Comune di Cogliate', 'Cogliate', 'MB', 'Lombardia', 8469, '01566130157', 'Via Minoretti,19', '20815', 'comune.cogliate@legalmail.it', 'protocollo@comune.cogliate.mb.it', '0296666622', 'www.comune.cogliate.mb.it', 'UFTLLB'),
  ('Comune di Concorezzo', 'Concorezzo', 'MB', 'Lombardia', 16153, '03032720157', 'DELLA PACE', '20863', 'protocollo@comune.concorezzo.mb.legalmail.it', 'segreteria@comune.concorezzo.mb.it', '0396280001', 'www.comune.concorezzo.mb.it', 'UF6BOP'),
  ('Comune di Cornate d''Adda', 'Cornate d''Adda', 'MB', 'Lombardia', 11134, '02846660153', 'Via Volta, 29', '20872', 'comune.cornatedadda@cert.legalmail.it', null, '03968741', 'www.comune.cornatedadda.mb.it', null),
  ('Comune di Correzzana', 'Correzzana', 'MB', 'Lombardia', 3289, '83008920155', 'Via De Gasperi,7', '20856', 'comune.correzzana@pec.regione.lombardia.it', 'ragioneria@comune.correzzana.mb.it', '0396065373', 'www.comune.correzzana.mb.it', 'UF5U70'),
  ('Comune di Desio', 'Desio', 'MB', 'Lombardia', 41872, '00834770158', 'Piazza Giovanni Paolo II', '20832', 'protocollo.comune.desio@legalmail.it', 'segreteria@comune.desio.mb.it', '03623921', 'www.comune.desio.mb.it', 'UFNPFW'),
  ('Comune di Giussano', 'Giussano', 'MB', 'Lombardia', 26509, '01063800153', 'Piazzale Aldo Moro, 1', '20833', 'protocollo@pec.comune.giussano.mb.it', null, '03623581', 'www.comune.giussano.mb.it', 'UFDJ6X'),
  ('Comune di Lazzate', 'Lazzate', 'MB', 'Lombardia', 7722, '03611240155', 'Piazzetta Cesarino Monti', '20824', 'segreteria.comune.lazzate@pec.regione.lombardia.it', 'info@lazzate.com', '0296720202', 'www.lazzate.com', 'UFC9XR'),
  ('Comune di Lentate sul Seveso', 'Lentate sul Seveso', 'MB', 'Lombardia', 16049, '83000890158', 'Via Matteotti, 8', '20823', 'comune.lentatesulseveso@legalmail.it', null, '03625151', 'www.comune.lentatesulseveso.mb.it', 'UF71Z8'),
  ('Comune di Lesmo', 'Lesmo', 'MB', 'Lombardia', 8376, '03340310154', 'Via Vittorio Veneto, 15', '20855', 'comune.lesmo@legalmail.it', 'segreteria.lesmo@comune.lesmo.mb.it', null, 'www.comune.lesmo.mb.it', 'UF6CJF'),
  ('Comune di Limbiate', 'Limbiate', 'MB', 'Lombardia', 35865, '83005620154', 'Via Monte Bianco, 2', '20812', 'comune.limbiate@pec.regione.lombardia.it', null, '02990971', 'www.comune.limbiate.mb.it', 'UFJRZQ'),
  ('Comune di Lissone', 'Lissone', 'MB', 'Lombardia', 46792, '02968150157', 'Via Gramsci, 21', '20851', 'pec@comunedilissone.it', null, null, 'https://www.comune.lissone.mb.it', 'UFFWW7'),
  ('Comune di Macherio', 'Macherio', 'MB', 'Lombardia', 7582, '01039700156', 'Via Visconti, 39', '20846', 'protocollo@pec.comune.macherio.mb.it', 'segreteria@comune.macherio.mb.it', '03920756201', 'www.comune.macherio.mb.it', 'UFBPV6'),
  ('Comune di Meda', 'Meda', 'MB', 'Lombardia', 23735, '01745100154', 'Piazza Municipio, 4', '20821', 'posta@cert.comune.meda.mi.it', 'posta@comune.meda.mb.it', null, 'www.comune.meda.mb.it', 'UF5HWP'),
  ('Comune di Mezzago', 'Mezzago', 'MB', 'Lombardia', 4479, '02863360158', 'Via Fratelli Brasca, 5', '20883', 'comune.mezzago@pec.regione.lombardia.it', 'segreteria@comune.mezzago.mb.it', '0396067626', 'www.comune.mezzago.mb.it', 'UFPP9Q'),
  ('Comune di Misinto', 'Misinto', 'MB', 'Lombardia', 5749, '03613110158', 'Piazza Pietro Mosca, 9', '20826', 'comune.misinto@pec.regione.lombardia.it', 'info@comune.misinto.mb.it', '0296721010', 'www.comune.misinto.mb.it', 'UFF31L'),
  ('Comune di Monza', 'Monza', 'MB', 'Lombardia', 123672, '02030880153', 'Piazza Trento E Trieste', '20900', 'monza@pec.comune.monza.it', null, null, 'www.comune.monza.it', 'UF3A7H'),
  ('Comune di Muggiò', 'Muggiò', 'MB', 'Lombardia', 23585, '02965420157', 'Piazza Matteotti, 1', '20835', 'comune.muggio@pec.regione.lombardia.it', 'ragioneria@comune.muggio.mb.it', '03927091', 'www.comune.muggio.mb.it', 'UFX02I'),
  ('Comune di Nova Milanese', 'Nova Milanese', 'MB', 'Lombardia', 23068, '01731060156', 'Via Villoresi, 34', '20834', 'comune.novamilanese@pec.regione.lombardia.it', null, null, 'www.comune.novamilanese.mb.it', 'UFR7DO'),
  ('Comune di Ornago', 'Ornago', 'MB', 'Lombardia', 5487, '05827280156', 'Via Santuario, 6', '20876', 'protocollo.comuneornago@postecert.it', null, '039628631', 'www.comune.ornago.mb.it', 'UFQ1LE'),
  ('Comune di Renate', 'Renate', 'MB', 'Lombardia', 3983, '83003560154', 'Via Dante, 2', '20838', 'comune.renate@legalmail.it', 'segreteria@comune.renate.mb.it', '0362924423', 'www.comune.renate.mb.it', 'UFWLVL'),
  ('Comune di Roncello', 'Roncello', 'MB', 'Lombardia', 4772, '02924070150', 'Piazza Don Carlo Gnocchi', '20877', 'comune.roncello@pec.regione.lombardia.it', null, '03962788210', 'www.comune.roncello.mb.it', 'UFDHJL'),
  ('Comune di Ronco Briantino', 'Ronco Briantino', 'MB', 'Lombardia', 3777, '03611890157', 'Via IV Novembre 30', '20885', 'comune.roncobriantino@legalmail.it', null, '0396079023', 'www.comune.roncobriantino.mb.it', 'UFG9BB'),
  ('Comune di Seregno', 'Seregno', 'MB', 'Lombardia', 45240, '00870790151', 'Piazza Liberta'', 1', '20831', 'seregno.protocollo@actaliscertymail.it', null, '0362263511', 'www.comune.seregno.mb.it', 'UF3MDR'),
  ('Comune di Seveso', 'Seveso', 'MB', 'Lombardia', 23982, '01650780156', 'Viale Vittorio Veneto, 3/5', '20822', 'comune.seveso@pec.it', 'protocollo@comune.seveso.mb.it', '03625171', 'www.comune.seveso.mb.it', 'UFF89X'),
  ('Comune di Sovico', 'Sovico', 'MB', 'Lombardia', 8313, '00866640154', 'Piazza Arturo Riva 10', '20845', 'comune.sovico@pec.regione.lombardia.it', null, '039207501', 'www.comune.sovico.mb.it', 'UFRVPW'),
  ('Comune di Sulbiate', 'Sulbiate', 'MB', 'Lombardia', 4532, '87003530158', 'Via Grandi, 1', '20884', 'comune.sulbiate@halleypec.it', 'ragioneria@comune.sulbiate.mb.it', '0396020975', 'www.comune.sulbiate.mb.it', 'UF06FP'),
  ('Comune di Triuggio', 'Triuggio', 'MB', 'Lombardia', 8776, '83007340157', 'Via Vittorio Veneto, 15', '20844', 'comune.triuggio@legalmail.it', null, '036297411', 'www.comune.triuggio.mb.it', 'UFTGOW'),
  ('Comune di Usmate Velate', 'Usmate Velate', 'MB', 'Lombardia', 10740, '01482570155', 'Corso Italia, 22', '20865', 'protocollo.comuneusmatevelate@postecert.it', null, '039675701', 'www.comune.usmatevelate.mb.it', 'UFAXVX'),
  ('Comune di Varedo', 'Varedo', 'MB', 'Lombardia', 14039, '00841910151', 'Via Vittorio Emanuele II, 1', '20814', 'postacertificata@comune.varedo.legalmail.it', 'protocollo@comune.varedo.mb.it', null, 'www.comune.varedo.mb.it', 'UFG1AY'),
  ('Comune di Vedano al Lambro', 'Vedano al Lambro', 'MB', 'Lombardia', 7363, '03131650156', 'Largo Repubblica, 3', '20854', 'comune.vedanoallambro@pec.regione.lombardia.it', 'protocollo@comune.vedanoallambro.mb.it', '0392486300', 'www.comune.vedanoallambro.mb.it', 'UF6F7O'),
  ('Comune di Veduggio con Colzano', 'Veduggio con Colzano', 'MB', 'Lombardia', 4182, '83003380157', 'Via Vittorio Veneto 45', '20837', 'comune.veduggio@legalmail.it', 'protocollo@comune.veduggioconcolzano.mb.it', '0362998741', 'www.comune.veduggioconcolzano.mb.it', 'UFI5RN'),
  ('Comune di Verano Brianza', 'Verano Brianza', 'MB', 'Lombardia', 9126, '83001210158', 'Via NAZARIO SAURO 24', '20843', 'comune.veranobrianza@pec.regione.lombardia.it', 'protocollo@comune.veranobrianza.mb.it', '036290851', 'www.comune.veranobrianza.mb.it', 'UFT24Z'),
  ('Comune di Villasanta', 'Villasanta', 'MB', 'Lombardia', 14305, '03245720150', 'Piazza Martiri della Liberta'' 7', '20852', 'protocollo@pec.comune.villasanta.mb.it', null, null, 'www.comune.villasanta.mb.it', 'UFZ5OG'),
  ('Comune di Vimercate', 'Vimercate', 'MB', 'Lombardia', 26341, '02026560157', 'Piazza Unita'' D''Italia, 1', '20871', 'vimercate@pec.comune.vimercate.mb.it', null, '03966591', 'www.comune.vimercate.mb.it', 'UFR69F');

-- 1) Comuni già presenti: aggiorna abitanti e completa i campi vuoti
update companies c set
  abitanti       = v.abitanti,
  citta          = coalesce(c.citta, v.citta),
  provincia      = coalesce(c.provincia, v.provincia),
  regione        = coalesce(c.regione, v.regione),
  piva           = coalesce(c.piva, v.cf),
  address        = coalesce(c.address, v.indirizzo),
  cap            = coalesce(c.cap, v.cap),
  pec            = coalesce(c.pec, v.pec),
  email          = coalesce(c.email, v.email),
  phone          = coalesce(c.phone, v.telefono),
  website        = coalesce(c.website, v.sito),
  codice_univoco = coalesce(c.codice_univoco, v.codice_univoco)
from _comuni v
where lower(c.name) = lower(v.name) and coalesce(c.provincia, v.provincia) = v.provincia;

-- 2) Comuni mancanti: li inserisce
insert into companies (name, tipo, citta, provincia, regione, abitanti, piva,
                       address, cap, pec, email, phone, website, codice_univoco)
select v.name, 'pa', v.citta, v.provincia, v.regione, v.abitanti, v.cf,
       v.indirizzo, v.cap, v.pec, v.email, v.telefono, v.sito, v.codice_univoco
from _comuni v
where not exists (select 1 from companies c where lower(c.name) = lower(v.name)
                  and coalesce(c.provincia, v.provincia) = v.provincia);

drop table if exists _comuni;

-- Controllo: MB = 55 comuni / 883.396 ab.
select provincia, count(*) as comuni, sum(abitanti) as abitanti,
       count(pec) as con_pec, count(email) as con_email, count(phone) as con_telefono
from companies
where tipo = 'pa' and name ilike 'Comune di %' and provincia = 'MB'
group by provincia;



-- =====================================================================
--  CRM ENER.ING — Comuni della provincia di Varese con abitanti e contatti
--  Esegui nel SQL Editor di Supabase. Sicuro e ri-eseguibile (non cancella nulla):
--   * aggiunge ai clienti le colonne "abitanti" ed "email" (se mancano);
--   * inserisce i 136 Comuni della provincia di Varese come clienti PA;
--   * per i Comuni già presenti aggiorna gli abitanti e COMPLETA solo i campi
--     vuoti (non sovrascrive quello che avete già scritto a mano).
--  Se Supabase mostra l'avviso "Potential issues detected", scegli
--  "Run without RLS": riguarda solo la tabella d'appoggio temporanea _comuni.
--  Fonti:
--   - abitanti: Istat, popolazione stimata al 01/01/2026 (via tuttitalia.it)
--   - contatti: IndicePA (indicepa.gov.it), open data ufficiali, letti il 17/10/2026
--     Email: solo indirizzi generici (protocollo/info/segreteria/uffici),
--     mai caselle personali. Codice univoco solo se l'ufficio di fatturazione è unico.
-- =====================================================================

alter table companies add column if not exists abitanti integer;
alter table companies add column if not exists email text;
create index if not exists companies_abitanti_idx on companies (abitanti);

drop table if exists _comuni;
create temporary table _comuni (
  name text, citta text, provincia text, regione text, abitanti integer,
  cf text, indirizzo text, cap text, pec text, email text, telefono text,
  sito text, codice_univoco text
);

insert into _comuni values
  ('Comune di Agra', 'Agra', 'VA', 'Lombardia', 380, '00459980124', 'Piazza Pasquinelli, 1', '21010', 'comuneagra@legalmail.it', null, null, 'www.comune.agra.va.it', 'UFI4QB'),
  ('Comune di Albizzate', 'Albizzate', 'VA', 'Lombardia', 5200, '82006930125', 'Piazza IV Novembre, 2', '21041', 'comune.albizzate@halleypec.it', 'affarigenerali@comune.albizzate.va.it', '0331993727', 'www.comune.albizzate.va.it', 'UF6QCV'),
  ('Comune di Angera', 'Angera', 'VA', 'Lombardia', 5326, '00338310121', 'Piazza Garibaldi, 14', '21021', 'comune.angera@pec.regione.lombardia.it', 'segreteria@comune.angera.it', '0331930168', 'www.comune.angera.va.it', 'UF2BHF'),
  ('Comune di Arcisate', 'Arcisate', 'VA', 'Lombardia', 9859, '00250810124', 'Via Roma 2', '21051', 'comune.arcisate@anutelpec.it', 'segreteria@comune.arcisate.va.it', '0332470124', 'www.comune.arcisate.va.it', 'UFK7Q4'),
  ('Comune di Arsago Seprio', 'Arsago Seprio', 'VA', 'Lombardia', 4727, '00561120122', 'Piazza XXV Aprile 1', '21010', 'comunediarsagoseprio@legalmail.it', 'segreteria@comune.arsagoseprio.va.it', '0331299926', 'www.comune.arsagoseprio.va.it', 'UFJXEZ'),
  ('Comune di Azzate', 'Azzate', 'VA', 'Lombardia', 4652, '00308140128', 'Via Conti Benizzi Castellani 1', '21022', 'comunediazzate@postemailcertificata.it', 'infoazzate@comune.azzate.va.it', '0332456311', 'comune.azzate.va.it', 'UF4H79'),
  ('Comune di Azzio', 'Azzio', 'VA', 'Lombardia', 758, '00605220128', 'Viale Cadorna, 4', '21030', 'comune.azzio.va@halleycert.it', 'demografici@comune.azzio.va.it', '0332631432', 'www.comune.azzio.va.it', 'UFSIE6'),
  ('Comune di Barasso', 'Barasso', 'VA', 'Lombardia', 1681, '00459960126', 'Via Roma, 26', '21020', 'comune.barasso@pec.regione.lombardia.it', 'info@comune.barasso.va.it', '0332743386', 'www.comune.barasso.va.it', 'UFYR1G'),
  ('Comune di Bardello con Malgesso e Bregano', 'Bardello con Malgesso e Bregano', 'VA', 'Lombardia', 3629, '03929670127', 'Via PIAVE 39', '21020', 'comunebardelloconmalgessoebregano@halleypec.it', 'ragioneria@comune.bardelloconmalgessoebregano.va.it', null, null, null),
  ('Comune di Bedero Valcuvia', 'Bedero Valcuvia', 'VA', 'Lombardia', 664, '00445500127', 'Piazza Vittorio Veneto', '21039', 'protocollo@pec.comune.bederovalcuvia.va.it', 'info@comune.bederovalcuvia.va.it', '0332724587', 'www.comune.bederovalcuvia.va.it', 'UF288I'),
  ('Comune di Besano', 'Besano', 'VA', 'Lombardia', 2513, '00561660127', 'Piazza Della Chiesa, 2', '21050', 'comune.besano@pec.regione.lombardia.it', null, '0332916260', 'www.comune.besano.va.it', 'UFJHES'),
  ('Comune di Besnate', 'Besnate', 'VA', 'Lombardia', 5438, '00249600123', 'Piazza Mazzini, 16', '21010', 'protocollo@pec.comune.besnate.va.it', null, '0331275811', 'www.comune.besnate.va.it', 'UF7UV7'),
  ('Comune di Besozzo', 'Besozzo', 'VA', 'Lombardia', 8717, '00338010127', 'Via Mazzini 4', '21023', 'comune.besozzo.va@halleycert.it', null, null, 'https://www.comune.besozzo.va.it', 'UFEII7'),
  ('Comune di Biandronno', 'Biandronno', 'VA', 'Lombardia', 3190, '00308160126', 'Piazza Cavour', '21024', 'protocollo@pec.comune.biandronno.va.it', 'ufficiosegreteria@comune.biandronno.va.it', '0332766131', 'www.comune.biandronno.va.it', 'UF5HV8'),
  ('Comune di Bisuschio', 'Bisuschio', 'VA', 'Lombardia', 4253, '00269810123', 'Via Mazzini, 14', '21050', 'comune.bisuschio@pec.regione.lombardia.it', null, null, 'www.comune.bisuschio.va.it', 'UF12FC'),
  ('Comune di Bodio Lomnago', 'Bodio Lomnago', 'VA', 'Lombardia', 2255, '00250430121', 'Piazza Don Cesare Ossola 2', '21020', 'comune.bodiolomnago@pec.regione.lombardia.it', null, null, 'www.comune.bodiolomnago.va.it', 'UFVWBL'),
  ('Comune di Brebbia', 'Brebbia', 'VA', 'Lombardia', 3137, '83000650123', 'Via Della Chiesa, 2', '21020', 'comune.brebbia@legalmail.it', null, '0332770283', 'www.comune.brebbia.va.it', 'UFOE09'),
  ('Comune di Brenta', 'Brenta', 'VA', 'Lombardia', 1682, '00528310121', 'Via G. Cerini 2', '21030', 'comune.brenta.va@halleycert.it', 'affarigenerali@comune.brenta.va.it', '0332601459', 'www.comune.brenta.va.it', 'UFSO8N'),
  ('Comune di Brezzo di Bedero', 'Brezzo di Bedero', 'VA', 'Lombardia', 1214, '84000790125', 'Via Roma, 60', '21010', 'comune.brezzo-di-bedero@legalmail.it', null, '0332511707', 'www.comune.brezzo-di-bedero.va.it', 'UFVNMU'),
  ('Comune di Brinzio', 'Brinzio', 'VA', 'Lombardia', 765, '00559810122', 'Viale Indipendenza, 9', '21030', 'comune.brinzio.va@halleypec.it', 'info@comune.brinzio.va.it', '0332435714', 'www.comune.brinzio.va.it', 'UFVCCM'),
  ('Comune di Brissago-Valtravaglia', 'Brissago-Valtravaglia', 'VA', 'Lombardia', 1316, '00225510122', 'Via Bernardino Luini 6', '21030', 'comune@pec.comune.brissago-valtravaglia.va.it', null, '0332575103', 'www.comune.brissago-valtravaglia.va.it', 'UFFGGQ'),
  ('Comune di Brunello', 'Brunello', 'VA', 'Lombardia', 918, '00290400126', 'Piazza Paolo Ballerio, 2', '21020', 'protocollo.brunello@pec.it', 'protocollo@comune.brunello.va.it', '0332455270', 'www.comune.brunello.va.it', 'UFRHSB'),
  ('Comune di Brusimpiano', 'Brusimpiano', 'VA', 'Lombardia', 1174, '00559790126', 'Via Carlo Battaglia, 5', '21050', 'affarigenerali@comune.brusimpiano.legalmail.it', 'ragioneria@comune.brusimpiano.va.it', '0332934119', 'www.comune.brusimpiano.va.it/', 'UF7VZI'),
  ('Comune di Buguggiate', 'Buguggiate', 'VA', 'Lombardia', 3115, '00308120120', 'Piazza Aldo Moro 1', '21020', 'protocollo@pec.comune.buguggiate.va.it', 'protocollo@comune.buguggiate.va.it', '0332459166', 'www.comune.buguggiate.va.it', 'UFNXPH'),
  ('Comune di Busto Arsizio', 'Busto Arsizio', 'VA', 'Lombardia', 84595, '00224000125', 'Via Fratelli D''Italia, 12', '21052', 'protocollo@comune.bustoarsizio.va.legalmail.it', null, '0331390111', 'www.comune.bustoarsizio.va.it', null),
  ('Comune di Cadegliano-Viconago', 'Cadegliano-Viconago', 'VA', 'Lombardia', 2120, '00300450129', 'Via Provinciale 19', '21031', 'comune.cadeglianoviconago@pec.regione.lombardia.it', null, '0332591012', 'www.comune.cadeglianoviconago.va.it', 'UF8JC8'),
  ('Comune di Cadrezzate con Osmate', 'Cadrezzate con Osmate', 'VA', 'Lombardia', 2742, '03700710126', 'Via VITTORIO VENETO 29', '21062', 'comune.cadrezzateconosmate@halleypec.it', null, '0331953102', null, 'UFZDUQ'),
  ('Comune di Cairate', 'Cairate', 'VA', 'Lombardia', 7886, '00309270122', 'Via Monastero 10', '21050', 'segreteria.comunecairate@halleycert.it', null, '0331362201', 'www.comune.cairate.va.it', 'UF5CRS'),
  ('Comune di Cantello', 'Cantello', 'VA', 'Lombardia', 4866, '00404280125', 'Piazza Monte Grappa 1', '21050', 'comune.cantello@legalmail.it', null, null, 'www.comune.cantello.va.it', 'UFYFU4'),
  ('Comune di Caravate', 'Caravate', 'VA', 'Lombardia', 2532, '00227400124', 'Via XX Settembre 22', '21032', 'comunecaravate@legalmail.it', 'info@comune.caravate.va.it', '0332601261', 'www.comune.caravate.va.it', 'UFS8UR'),
  ('Comune di Cardano al Campo', 'Cardano al Campo', 'VA', 'Lombardia', 14771, '00221730120', 'Piazza Mazzini, 19', '21010', 'protocollo@cert.comune.cardanoalcampo.va.it', null, '0331266293', 'www.comune.cardanoalcampo.va.it', 'UFZL4Z'),
  ('Comune di Carnago', 'Carnago', 'VA', 'Lombardia', 6610, '00308180124', 'Piazza A. Gramsci, 3', '21040', 'comune.carnago@pec.it', 'segreteria@comune.carmago.va.it', '0331993593', 'www.comune.carnago.va.it', 'UFTHJ3'),
  ('Comune di Caronno Pertusella', 'Caronno Pertusella', 'VA', 'Lombardia', 18556, '00440710127', 'Piazza Aldo Moro 1', '21042', 'comune.caronnopertusella@pec.regione.lombardia.it', null, '0296512225', 'www.comune.caronnopertusella.va.it', 'UFDCJ2'),
  ('Comune di Caronno Varesino', 'Caronno Varesino', 'VA', 'Lombardia', 4800, '00309370120', 'Piazza Mazzini, 2', '21040', 'comune.caronnovaresino@pec.regione.lombardia.it', 'segreteria@comune.caronnovaresino.va.it', '0331980405', 'www.comune.caronnovaresino.va.it', 'UF8PLF'),
  ('Comune di Casale Litta', 'Casale Litta', 'VA', 'Lombardia', 2775, '00309410124', 'Via Roma', '21020', 'comune.casalelitta@pec.regione.lombardia.it', 'info@comune.casalelitta.va.it', '0332945636', 'www.comune.casalelitta.va.it', 'UFML16'),
  ('Comune di Casalzuigno', 'Casalzuigno', 'VA', 'Lombardia', 1409, '00559800123', 'Via Liberta'', 44', '21030', 'comune.casalzuigno.va@halleycert.it', 'ragioneria@comune.casalzuigno.va.it', '0332624122', 'www.comune.casalzuigno.va.it', 'UFHTB1'),
  ('Comune di Casciago', 'Casciago', 'VA', 'Lombardia', 3549, '00564180123', 'Largo De Gasperi, 1', '21020', 'comune.casciago@pec.regione.lombardia.it', null, '0332201120', 'https://comune.casciago.va.it', 'UFNO3U'),
  ('Comune di Casorate Sempione', 'Casorate Sempione', 'VA', 'Lombardia', 5631, '00341710127', 'V. De Amicis 7', '21011', 'casoratesempione@legalmail.it', null, '0331295052', 'www.comune.casoratesempione.va.it', 'UFHH57'),
  ('Comune di Cassano Magnago', 'Cassano Magnago', 'VA', 'Lombardia', 21431, '82007050121', 'Via Alessandro Volta, 4', '21012', 'protocollo.comune.cassanomagnago@pec.regione.lombardia.it', 'protocollo@cassano-magnago.it', '0331283311', 'www.cassano-magnago.it', 'UF5A6H'),
  ('Comune di Cassano Valcuvia', 'Cassano Valcuvia', 'VA', 'Lombardia', 647, '00561110123', 'Via Iv Novembre, 4', '21030', 'comune.cassanovalcuvia.va@halleycert.it', 'info@comune.cassanovalcuvia.va.it', '0332995519', 'www.comune.cassanovalcuvia.va.it', 'UFW41X'),
  ('Comune di Castellanza', 'Castellanza', 'VA', 'Lombardia', 13890, '00252280128', 'Viale Rimembranze 4', '21053', 'comune@pec.comune.castellanza.va.it', 'comune@comune.castellanza.va.it', '0331526111', 'www.comune.castellanza.va.it', 'UFIDTB'),
  ('Comune di Castello Cabiaglio', 'Castello Cabiaglio', 'VA', 'Lombardia', 550, '00441540127', 'Piazza Liberta'', 1', '21030', 'comune.castellocabiaglio.va@legalmail.it', 'info@comune.castellocabiaglio.va.it', '0332435813', 'www.comune.castellocabiaglio.va.it', 'UFMCKX'),
  ('Comune di Castelseprio', 'Castelseprio', 'VA', 'Lombardia', 1330, '00346170129', 'Via San Giuseppe, 114', '21050', 'comune.castelseprio@legalmail.it', null, '0331820501', 'www.comune.castelseprio.va.it', 'UF4TA6'),
  ('Comune di Castelveccana', 'Castelveccana', 'VA', 'Lombardia', 1855, '00289020125', 'Via Monte Grappa 16', '21010', 'comune.castelveccana@pec.regione.lombardia.it', 'affarigenerali@comune.castelveccana.va.it', '0332520494', 'www.comune.castelveccana.va.it', 'UF4BWT'),
  ('Comune di Castiglione Olona', 'Castiglione Olona', 'VA', 'Lombardia', 7454, '00309450120', 'Via Cardinal Branda N. 8', '21043', 'protocollo.comune.castiglioneolona@pec.regione.lombardia.it', 'segreteria@comune.castiglione-olona.va.it', '0331824801', 'www.comune.castiglione-olona.va.it', 'UFG3EA'),
  ('Comune di Castronno', 'Castronno', 'VA', 'Lombardia', 5035, '00248280125', 'Piazza Del Comune, 1', '21040', 'protocollo.comune.castronno@pec.regione.lombardia.it', null, null, 'www.comune.castronno.va.it', 'UFR30Y'),
  ('Comune di Cavaria con Premezzo', 'Cavaria con Premezzo', 'VA', 'Lombardia', 5769, '00309290120', 'Piazza Sandro Pertini 75', '21044', 'cavariaconpremezzo@actaliscertymail.it', 'RAGIONERIA@COMUNE.CAVARIACONPREMEZZO.VA.IT', '0331217480', 'www.comune.cavariaconpremezzo.va.it', 'UFHP4V'),
  ('Comune di Cazzago Brabbia', 'Cazzago Brabbia', 'VA', 'Lombardia', 779, '00259700128', 'Piazza Liberta, 1', '21020', 'comune.cazzagobrabbia@legalmail.it', null, '0332964400', 'www.comune.cazzagobrabbia.va.it', 'UFT3DF'),
  ('Comune di Cislago', 'Cislago', 'VA', 'Lombardia', 10572, '00308220128', 'Piazza Enrico Toti, 1', '21040', 'protocollocislago@legalmailpa.it', 'segreteria@comune.cislago.va.it', '029667101', 'https://www.comune.cislago.va.it', 'UFUTOT'),
  ('Comune di Cittiglio', 'Cittiglio', 'VA', 'Lombardia', 3805, '00254640121', 'Via Provinciale, 46', '21033', 'comunecittiglio@actaliscertymail.it', 'protocollo@comune.cittiglio.va.it', '0332601467', 'www.comune.cittiglio.va.it', 'UF5I3J'),
  ('Comune di Clivio', 'Clivio', 'VA', 'Lombardia', 1982, '00568840128', 'Via Delle Sorgenti, 7', '21050', 'comune.clivio@pec.regione.lombardia.it', 'protocollo@comune.clivio.va.it', '0332486149', 'www.comune.clivio.va.it', 'UFDEXR'),
  ('Comune di Cocquio-Trevisago', 'Cocquio-Trevisago', 'VA', 'Lombardia', 4651, '00309210128', 'Via Roma 54', '21034', 'comune.cocquiotrevisago@pec.regione.lombardia.it', 'protocollo@comune.cocquio-trevisago.va.it', '0332975151', 'www.comune.cocquio-trevisago.va.it', 'UFF0OY'),
  ('Comune di Comabbio', 'Comabbio', 'VA', 'Lombardia', 1177, '00261830129', 'Piazza Guglielmo Marconi, 1', '21020', 'comune.comabbio@legalmail.it', null, '0331968572', 'www.comune.comabbio.va.it', 'UFM58K'),
  ('Comune di Comerio', 'Comerio', 'VA', 'Lombardia', 2784, '00226700128', 'Via Stazione, 8', '21025', 'comune.comerio@legalmail.it', 'ragioneria@comune.comerio.va.it', '0332743156', 'www.comune.comerio.va.it', 'UFA4IU'),
  ('Comune di Cremenaga', 'Cremenaga', 'VA', 'Lombardia', 782, '00478360126', 'Via Cesare Battisti,1', '21030', 'protocollo.comune.cremenaga@pec.regione.lombardia.it', 'anagrafe@comune.cremenaga.va.it', '0332511912', 'www.comune.cremenaga.va.it', 'UFGSHY'),
  ('Comune di Crosio della Valle', 'Crosio della Valle', 'VA', 'Lombardia', 624, '00637630120', 'Via Iv Novembre, 30', '21020', 'comune.crosiodellavalle@legalmail.it', 'ragioneria@comune.crosiodellavalle.va.it', null, 'www.comune.crosiodellavalle.va.it', 'UF4RE3'),
  ('Comune di Cuasso al Monte', 'Cuasso al Monte', 'VA', 'Lombardia', 3545, '00341300127', 'Via Roma, 58', '21050', 'comune@pec.comune.cuassoalmonte.va.it', 'segreteria@comune.cuassoalmonte.va.it', '0332939001', 'www.comune.cuassoalmonte.va.it', 'UF46FN'),
  ('Comune di Cugliate-Fabiasco', 'Cugliate-Fabiasco', 'VA', 'Lombardia', 3119, '84003010125', 'Piazza Andreani N.1', '21030', 'comune.cugliatefabiasco@pec.regione.lombardia.it', null, '0332999711', 'www.comune.cugliatefabiasco.va.it', 'UFDYNP'),
  ('Comune di Cunardo', 'Cunardo', 'VA', 'Lombardia', 2880, '00489260125', 'Via L. Da Vinci, N. 4', '21035', 'comune.cunardo.va@halleypec.it', 'info@comune.cunardo.va.it', '0332999211', 'www.comune.cunardo.va.it', 'UFU4OJ'),
  ('Comune di Curiglia con Monteviasco', 'Curiglia con Monteviasco', 'VA', 'Lombardia', 141, '00458530128', 'Via Giuseppe Viola, 1', '21010', 'comune.curigliaconmonteviasco@halleypec.it', 'info@comune.curigliaconmonteviasco.va.it', '0332568427', 'www.comune.curigliaconmonteviasco.va.it', 'UF85WX'),
  ('Comune di Cuveglio', 'Cuveglio', 'VA', 'Lombardia', 3378, '00271230120', 'Piazza Marconi, 1', '21030', 'comune.cuveglio.va@halleycert.it', 'info@comune.cuveglio.va.it', '0332650107', 'www.comune.cuveglio.va.it', 'UFA62M'),
  ('Comune di Cuvio', 'Cuvio', 'VA', 'Lombardia', 1754, '00560000127', 'Via Vittorio Veneto N. 14', '21030', 'comune.cuvio.va@halleycert.it', 'info@comune.cuvio.va.it', '0332650143', 'www.comune.cuvio.va.it', 'UF947T'),
  ('Comune di Daverio', 'Daverio', 'VA', 'Lombardia', 3030, '00260520127', 'Via Roma 45', '21020', 'comunedaverio@legalmail.it', 'protocollo@comune.daverio.va.it', '0332947135', 'www.comune.daverio.va.it', 'UF7Q1L'),
  ('Comune di Dumenza', 'Dumenza', 'VA', 'Lombardia', 1461, '00579150129', 'Viale Delle Rimembranze n.9', '21010', 'comune.dumenza@legalmail.it', 'info@comune.dumenza.va.it', null, 'www.comune.dumenza.va.it', 'UF4MBI'),
  ('Comune di Duno', 'Duno', 'VA', 'Lombardia', 163, '00582100129', 'Via Alfredo Sonzini N. 4', '21030', 'comune.duno.va@halleycert.it', 'info@comune.duno.va.it', '0332629303', 'www.comune.duno.va.it', 'UFO47B'),
  ('Comune di Fagnano Olona', 'Fagnano Olona', 'VA', 'Lombardia', 12411, '00214240129', 'Piazza Cavour 9', '21054', 'protocollo.fagnanoolona@legalmail.it', 'protocollo@comune.fagnanoolona.va.it', '0331616511', 'www.comune.fagnanoolona.va.it', 'UFAXUJ'),
  ('Comune di Ferno', 'Ferno', 'VA', 'Lombardia', 6715, '00237790126', 'Via Aldo Moro,3', '21010', 'comune@ferno.legalmailpa.it', 'comune@comune.ferno.va.it', '0331242211', 'https://comune.ferno.va.it/it', 'UFB4NZ'),
  ('Comune di Ferrera di Varese', 'Ferrera di Varese', 'VA', 'Lombardia', 694, '00561750126', 'Via G.Garibaldi,19', '21030', 'comune.ferrera.va@halleycert.it', 'info@comune.ferreradivarese.va.it', '0332716450', 'www.comune.ferreradivarese.va.it', 'UFEOFE'),
  ('Comune di Gallarate', 'Gallarate', 'VA', 'Lombardia', 53023, '00560180127', 'Via Verdi, 2', '21013', 'protocollo@pec.comune.gallarate.va.it', null, '0331754226', 'www.comune.gallarate.va.it', 'UFK5K1'),
  ('Comune di Galliate Lombardo', 'Galliate Lombardo', 'VA', 'Lombardia', 1035, '00459940128', 'Via Carletto Ferrari 12', '21020', 'comune.galliatelombardo@legalmailpa.it', 'info@comune.galliatelombardo.va.it', '0332947265', 'www.comune.galliatelombardo.va.it', 'UFAZNC'),
  ('Comune di Gavirate', 'Gavirate', 'VA', 'Lombardia', 9145, '00259850121', 'Piazza Matteotti 8', '21026', 'info.comune.gavirate@pec.regione.lombardia.it', 'segreteriai@comune.gavirate.va.it', '0332748222', 'www.comune.gavirate.va.it', null),
  ('Comune di Gazzada Schianno', 'Gazzada Schianno', 'VA', 'Lombardia', 4635, '00232220129', 'Via Matteotti 13/A', '21045', 'comune.gazzadaschianno@secmail.it', null, '0332875120', 'www.comune.gazzada-schianno.va.it', 'UF9ZJU'),
  ('Comune di Gemonio', 'Gemonio', 'VA', 'Lombardia', 2871, '00273580126', 'Via Rocco Cellina N. 20', '21036', 'comune.gemonio.va@halleycert.it', 'ragioneria@comune.gemonio.va.it', null, 'comune.gemonio.va.it', 'UF4CFN'),
  ('Comune di Gerenzano', 'Gerenzano', 'VA', 'Lombardia', 11065, '00236840120', 'Via Duca Degli Abruzzi N. 2', '21040', 'comune.gerenzano@pec.regione.lombardia.it', 'segreteria@comune.gerenzano.va.it', '029639911', 'www.comune.gerenzano.va.it', 'UFQYM0'),
  ('Comune di Germignaga', 'Germignaga', 'VA', 'Lombardia', 3781, '00343860128', 'Via Diaz, 11', '21010', 'protocollo@cert.comune.germignaga.va.it', null, '0332531337', 'www.comune.germignaga.va.it', 'UF4L0A'),
  ('Comune di Golasecca', 'Golasecca', 'VA', 'Lombardia', 2630, '00564480127', 'Piazza Liberta 3', '21010', 'comune.golasecca@pec.regione.lombardia.it', 'protocollo@comune.golasecca.va.it', '0331959414', 'www.comune.golasecca.va.it', 'UFF7FN'),
  ('Comune di Gorla Maggiore', 'Gorla Maggiore', 'VA', 'Lombardia', 4781, '00341490126', 'Piazza Martiri Della Liberta 19', '21050', 'protocollo.gorlamaggiore@legalmail.it', null, '0331617121', 'https://www.comune.gorlamaggiore.va.it', 'UF6FUG'),
  ('Comune di Gorla Minore', 'Gorla Minore', 'VA', 'Lombardia', 8236, '00226510121', 'Via Roma, 56', '21055', 'comune.gorlaminore@postecert.it', null, null, 'www.comune.gorlaminore.va.it', null),
  ('Comune di Gornate Olona', 'Gornate Olona', 'VA', 'Lombardia', 2212, '00519350128', 'Piazza Parrocchetti, 1', '21040', 'comune.gornate-olona@pec.regione.lombardia.it', 'info@comune.gornateolona.va.it', '0331863811', 'www.comune.gornateolona.va.it', 'UFVZ7Y'),
  ('Comune di Grantola', 'Grantola', 'VA', 'Lombardia', 1225, '00559980123', 'Via Solferino, 9', '21030', 'comune.grantola@pec.regione.lombardia.it', 'info@comune.grantola.va.it', '0332575134', 'www.comune.grantola.va.it', 'UFWVUU'),
  ('Comune di Inarzo', 'Inarzo', 'VA', 'Lombardia', 1073, '00259680122', 'Via Patrioti, 26', '21020', 'comune.inarzo@pec.regione.lombardia.it', 'info@comune.inarzo.va.it', '0332947322', 'www.comune.inarzo.va.it', 'UF0907'),
  ('Comune di Induno Olona', 'Induno Olona', 'VA', 'Lombardia', 10446, '00271270126', 'Via Porro, 35', '21056', 'indunoolona@pec.it', 'info@comune.induno-olona.va.it', '0332273111', 'www.comune.induno-olona.va.it', 'UFNDA4'),
  ('Comune di Ispra', 'Ispra', 'VA', 'Lombardia', 5358, '00309310126', 'Via Milite Ignoto, 31', '21027', 'protocollo.ispra@pec.it', 'segreteria@comune.ispra.va.it', '03327833106', 'www.comune.ispra.va.it', 'UFXOTL'),
  ('Comune di Jerago con Orago', 'Jerago con Orago', 'VA', 'Lombardia', 5177, '00243880127', 'Via Indipendenza, 17', '21040', 'comune.jeragoconorago@pec.regione.lombardia.it', 'ragioneria@comune.jeragoconorago.va.it', '0331217770', 'www.comune.jeragoconorago.va.it', 'UFTPDD'),
  ('Comune di Lavena Ponte Tresa', 'Lavena Ponte Tresa', 'VA', 'Lombardia', 5649, '00405070129', 'Via Liberta'', 28', '21037', 'comune.lavenapontetresa@legalmail.it', null, null, 'www.comune.lavenapontetresa.va.it', 'UFAKK1'),
  ('Comune di Laveno-Mombello', 'Laveno-Mombello', 'VA', 'Lombardia', 8370, '00213100126', 'Via Roma 16/A', '21014', 'protocollo.lavenomombello@cert.saga.it', 'affari.generali@comune.laveno.va.it', '0332625529', 'www.comune.laveno.va.it', 'UFAAWO'),
  ('Comune di Leggiuno', 'Leggiuno', 'VA', 'Lombardia', 3621, '00256410127', 'Piazza Marconi 1', '21038', 'comune.leggiuno.va@halleycert.it', 'ragioneria@comune.leggiuno.va.it', '0332647110', 'www.comune.leggiuno.va.it', null),
  ('Comune di Lonate Ceppino', 'Lonate Ceppino', 'VA', 'Lombardia', 5177, '00317710127', 'Piazza Armando Diaz, n. 12', '21050', 'comune.lonateceppino@pec.regione.lombardia.it', 'segreteria@lonateceppino.com', '0331841288', 'https://comune.lonateceppino.va.it/', 'UFMY8R'),
  ('Comune di Lonate Pozzolo', 'Lonate Pozzolo', 'VA', 'Lombardia', 11338, '00392890125', 'Via Cavour, 20', '21015', 'comune@lonatepozzolo.legalmailpa.it', 'comune@comune.lonatepozzolo.va.it', '0331303511', 'https://www.comune.lonatepozzolo.va.it', 'UFLUV7'),
  ('Comune di Lozza', 'Lozza', 'VA', 'Lombardia', 1211, '00341780120', 'Piazza Roma', '21040', 'protocollo.comune.lozza@legalmail.it', 'segreteria@comune.lozza.va.it', '0332263028', 'www.comune.lozza.va.it', 'UFRSAS'),
  ('Comune di Luino', 'Luino', 'VA', 'Lombardia', 14003, '84000310122', 'Piazza Crivelli Serbelloni, 1', '21016', 'comune.luino@legalmail.it', 'info@comune.luino.va.it', null, 'www.comune.luino.va.it', 'UF0MIA'),
  ('Comune di Luvinate', 'Luvinate', 'VA', 'Lombardia', 1349, '00561870122', 'Via San Vito, 3', '21020', 'protocollo@pec.comune.luvinate.va.it', 'protocollo@comune.luvinate.va.it', '0332824130', 'www.comune.luvinate.va.it', 'UFVNIE'),
  ('Comune di Maccagno con Pino e Veddasca', 'Maccagno con Pino e Veddasca', 'VA', 'Lombardia', 2293, '03396710125', 'Via Mazzini, 6', '21061', 'comune.maccagnoconpinoeveddasca@pec.regione.lombardia.it', 'info@comune.maccagnoconpinoeveddasca.va.it', '0332562011', 'www.comune.maccagnoconpinoeveddasca.va.it', 'UFOOD5'),
  ('Comune di Malnate', 'Malnate', 'VA', 'Lombardia', 16650, '00243280120', 'Piazza Vittorio Veneto, 2', '21046', 'comune.malnate@legalmail.it', null, '0332275260', 'www.comune.malnate.va.it', null),
  ('Comune di Marchirolo', 'Marchirolo', 'VA', 'Lombardia', 3571, '84002650129', 'Via Dante Alighieri 14', '21030', 'protocollo.comune.marchirolo@pec.regione.lombardia.it', null, '0332997130', 'www.comune.marchirolo.varese.it', 'UF3RJO'),
  ('Comune di Marnate', 'Marnate', 'VA', 'Lombardia', 8136, '00263510125', 'Piazza Sant''Ilario, 1', '21050', 'protocollo@comunemarnate.legalmailpa.it', null, '0331368200', 'www.comune.marnate.va.it', 'UF34LP'),
  ('Comune di Marzio', 'Marzio', 'VA', 'Lombardia', 311, '00559720123', 'Via Marchese Menefoglio', '21030', 'comune.marzio@pec.regione.lombardia.it', 'info@comune.marzio.va.it', '0332727851', 'www.comunemarzio.it', 'UFYQ44'),
  ('Comune di Masciago Primo', 'Masciago Primo', 'VA', 'Lombardia', 275, '83003750128', 'Via Maurilio Gianoli', '21030', 'comune.masciagoprimo@halleypec.it', 'info@comune.masciagoprimo.va.it', '0332724597', 'www.comune.masciagoprimo.va.it', 'UF4HTK'),
  ('Comune di Mercallo', 'Mercallo', 'VA', 'Lombardia', 1782, '83003790124', 'Via Bagaglio 171', '21020', 'comune.mercallo.va@halleypec.it', 'ragioneria@comune.mercallo.va.it', '0331968104', 'www.comune.mercallo.va.it', 'UFJZIP'),
  ('Comune di Mesenzana', 'Mesenzana', 'VA', 'Lombardia', 1825, '00225520121', 'Via San Martino snc', '21030', 'comune.mesenzana.va@legalmail.it', 'info@comune.mesenzana.va.it', '0332575116', 'www.comune.mesenzana.va.it', 'UFIESH'),
  ('Comune di Montegrino Valtravaglia', 'Montegrino Valtravaglia', 'VA', 'Lombardia', 1522, '00225500123', 'Via V. Veneto 9', '21010', 'comune.montegrino@legalmail.it', 'info@comune.montegrino-valtravaglia.va.it', '0332589732', 'www.comune.montegrino-valtravaglia.va.it', 'UF1EQV'),
  ('Comune di Monvalle', 'Monvalle', 'VA', 'Lombardia', 1889, '00309230126', 'Piazza Marconi 8', '21020', 'comune.monvalle.va@legalmail.it', 'protocollo@comune.monvalle.va.it', '0332799507', 'www.comune.monvalle.va.it', 'UFUHPV'),
  ('Comune di Morazzone', 'Morazzone', 'VA', 'Lombardia', 4320, '00248270126', 'Via Mameli, 16', '21040', 'affarigenerali@comune.morazzone.legalmailpa.it', 'respaffarigeneralifinanziario@comune.morazzone.va.it', '0332872620', 'WWW.COMUNE.MORAZZONE.VA.IT', 'UFT9BP'),
  ('Comune di Mornago', 'Mornago', 'VA', 'Lombardia', 4847, '00249580127', 'Piazza Liberta'', 1', '21020', 'comune.mornago.va@halleycert.it', 'segreteria@comune.mornago.va.it', '0331901008', 'www.comune.mornago.va.it', 'UF7HP1'),
  ('Comune di Oggiona con Santo Stefano', 'Oggiona con Santo Stefano', 'VA', 'Lombardia', 4365, '00309390128', 'Via Bonacalza, 146', '21040', 'protocollo.comuneoggionasstefano@actaliscertymail.it', 'info@comune.oggionaconsantostefano.va.it', null, 'www.comune.oggionaconsantostefano.va.it', 'UF69FU'),
  ('Comune di Olgiate Olona', 'Olgiate Olona', 'VA', 'Lombardia', 12953, '00322700121', 'v. Luigia Greppi 4', '21057', 'comune.olgiateolona@pec.regione.lombardia.it', 'info@comune.olgiateolona.va.it', '0331608718', 'https://comune.olgiateolona.va.it/', null),
  ('Comune di Origgio', 'Origgio', 'VA', 'Lombardia', 8068, '00322990128', 'Via Dante 15', '21040', 'segreteria@pec.comune.origgio.va.it', 'segreteria@comune.origgio.va.it', '029695111', 'www.comune.origgio.va.it', 'UF0SI8'),
  ('Comune di Orino', 'Orino', 'VA', 'Lombardia', 848, '00560020125', 'Piazza XI Febbraio, 1', '21030', 'comune.orino.va@halleypec.it', 'ufficiotecnico@comune.orino.va.it', '0332630517', 'www.comune.orino.va.it', 'UFSS0Z'),
  ('Comune di Porto Ceresio', 'Porto Ceresio', 'VA', 'Lombardia', 2785, '00462110123', 'Via Guido Butti, n. 40', '21050', 'protocollo@pec.comune.portoceresio.va.it', 'affarigenerali@comune.portoceresio.va.it', '0332917150', 'www.comune.portoceresio.va.it', null),
  ('Comune di Porto Valtravaglia', 'Porto Valtravaglia', 'VA', 'Lombardia', 2297, '00309350122', 'Piazza Imbarcadero, 11', '21010', 'comune.portovaltravaglia@pec.regione.lombardia.it', null, '0332543817', 'www.comune.portovaltravaglia.va.it', 'UF2KQ6'),
  ('Comune di Rancio Valcuvia', 'Rancio Valcuvia', 'VA', 'Lombardia', 911, '00561740127', 'Piazza Don Luigi Malcotti 1', '21030', 'comune.ranciovalcuvia.va@halleycert.it', 'info@comune.ranciovalcuvia.va.it', '0332995806', 'www.comune.ranciovalcuvia.va.it', 'UFUVOV'),
  ('Comune di Ranco', 'Ranco', 'VA', 'Lombardia', 1208, '00280790122', 'P.zza Parrocchiale, 4', '21020', 'comune.ranco.va@halleycert.it', 'segreteria@comune.ranco.va.it', '0331976619', 'www.comune.ranco.va.it', 'UF3U5J'),
  ('Comune di Saltrio', 'Saltrio', 'VA', 'Lombardia', 3001, '00560460123', 'Via Cavour, 37', '21050', 'comune.saltrio.va@legalmail.it', null, '0332486166', 'www.comune.saltrio.va.it', 'UF3YZM'),
  ('Comune di Samarate', 'Samarate', 'VA', 'Lombardia', 16232, '00504690124', 'Via Vittorio Veneto, 40', '21017', 'comune.samarate@pec.it', null, null, 'www.comune.samarate.va.it', 'UF4S47'),
  ('Comune di Sangiano', 'Sangiano', 'VA', 'Lombardia', 1437, '00589640127', 'Via Giuseppe Besozzi', '21038', 'comune.sangiano@pec.regione.lombardia.it', null, '0332647210', 'www.comune.sangiano.va.it', 'UFRVD3'),
  ('Comune di Saronno', 'Saronno', 'VA', 'Lombardia', 38812, '00217130129', 'Piazza della Repubblica, 7', '21047', 'comunesaronno@secmail.it', null, '02967101', 'www.comune.saronno.va.it', 'UFD7HC'),
  ('Comune di Sesto Calende', 'Sesto Calende', 'VA', 'Lombardia', 10998, '00283240125', 'Piazza Cesare Da Sesto, 1', '21018', 'sestocalende@legalmail.it', null, '0331928411', 'www.comune.sesto-calende.va.it', 'UF04LO'),
  ('Comune di Solbiate Arno', 'Solbiate Arno', 'VA', 'Lombardia', 4047, '00226820124', 'Largo Repubblica, 1', '21048', 'comune.solbiate-arno@pec.regione.lombardia.it', null, '0331993043', 'www.comune.solbiate-arno.va.it', 'UFK3OX'),
  ('Comune di Solbiate Olona', 'Solbiate Olona', 'VA', 'Lombardia', 5377, '00223640129', 'Via Giacomo Matteotti, 2', '21058', 'protocollo@comune.solbiateolona.va.legalmail.it', null, '0331649516', 'www.comune.solbiateolona.va.it', 'UFCBFX'),
  ('Comune di Somma Lombardo', 'Somma Lombardo', 'VA', 'Lombardia', 17931, '00280840125', 'Piazza Vittorio Veneto 2', '21019', 'comunedisommalombardo@legalmail.it', 'segreteria@comune.sommalombardo.va.it', '0331989059', 'www.comune.sommalombardo.va.it', 'UF7Q22'),
  ('Comune di Sumirago', 'Sumirago', 'VA', 'Lombardia', 5978, '00309330124', 'Via San Lorenzo, 21', '21040', 'comune.sumirago@pec.intercom.it', 'settoreamministrativo@comune.sumirago.va.it', '0331909103', 'www.comune.sumirago.va.it', null),
  ('Comune di Taino', 'Taino', 'VA', 'Lombardia', 3554, '00283550127', 'Piazza Pajetta, 5', '21020', 'comune.taino@pec.it', 'segreteria@comune.taino.va.it', '0331956405', 'www.comune.taino.va.it', 'UF4UMG'),
  ('Comune di Ternate', 'Ternate', 'VA', 'Lombardia', 2556, '00261810121', 'Piazza Liberta'', 19', '21020', 'comune.ternate@legalmail.it', 'segreteria@comune.ternate.va.it', '0332942911', 'www.comune.ternate.va.it', 'UFI5Q2'),
  ('Comune di Tradate', 'Tradate', 'VA', 'Lombardia', 19101, '00223660127', 'P.za Mazzini 6', '21049', 'comune.tradate@pec.regione.lombardia.it', 'protocollo@comune.tradate.va.it', '0331826811', 'www.comune.tradate.va.it', 'UFC4OZ'),
  ('Comune di Travedona-Monate', 'Travedona-Monate', 'VA', 'Lombardia', 3868, '00308240126', 'PIAZZA DON MARIO GANDINI, 1', '21028', 'comune.travedonamonate.va@halleycert.it', 'segreteria@comune.travedonamonate.va.it', '0332787611', 'www.comune.travedonamonate.va.it', 'UFLKLU'),
  ('Comune di Tronzano Lago Maggiore', 'Tronzano Lago Maggiore', 'VA', 'Lombardia', 221, '84002870123', 'Via San Rocco, 2', '21010', 'comune.tronzanolagomaggiore@pec.it', 'municipio@comune.tronzanolagomaggiore.va.it', '0332566240', 'www.comune.tronzanolagomaggiore.va.it', 'UFERNP'),
  ('Comune di Uboldo', 'Uboldo', 'VA', 'Lombardia', 11139, '00263530123', 'Piazza San Giovanni Bosco 10', '21040', 'protocollo@pec.comune.uboldo.va.it', 'info@comune.uboldo.va.it', '02969921', 'www.comune.uboldo.va.it', 'UF0I54'),
  ('Comune di Valganna', 'Valganna', 'VA', 'Lombardia', 1591, '00477430128', 'Piazza Grandi, 1', '21039', 'comune.valganna@pec.regione.lombardia.it', null, '0332719755', 'www.comune.valganna.va.it', 'UFJ7XA'),
  ('Comune di Varano Borghi', 'Varano Borghi', 'VA', 'Lombardia', 2492, '00263100125', 'Via San Francesco, 1', '21020', 'protocollo@pec.comune.varano-borghi.va.it', 'info@comune.varano-borghi.va.it', '0332960119', 'www.comune.varano-borghi.va.it', 'UFREME'),
  ('Comune di Varese', 'Varese', 'VA', 'Lombardia', 79100, '00441340122', 'Via Sacco, 5', '21100', 'protocollo@comune.varese.legalmail.it', null, null, 'www.comune.varese.it', 'UFO6JZ'),
  ('Comune di Vedano Olona', 'Vedano Olona', 'VA', 'Lombardia', 7452, '00317720126', 'P.zza San Rocco 9', '21040', 'comune.vedano-olona@legalmail.it', null, '0332867711', 'www.comune.vedano-olona.va.it/', 'UF8QUJ'),
  ('Comune di Venegono Inferiore', 'Venegono Inferiore', 'VA', 'Lombardia', 5922, '00309250124', 'Via Mauceri 5', '21040', 'comune.venegonoinferiore@pec.regione.lombardia.it', 'ufficiotributi@comunevenegonoinferiore.it', '0331856027', 'www.comune.venegonoinferiore.va.it', 'UFK4PK'),
  ('Comune di Venegono Superiore', 'Venegono Superiore', 'VA', 'Lombardia', 7522, '00223680125', 'Piazza Mauceri 12', '21040', 'comune.venegonosuperiore@pec.regione.lombardia.it', 'segreteria@comune.venegonosuperiore.va.it', '0331828400', 'www.comune.venegonosuperiore.va.it', 'UF3WPA'),
  ('Comune di Vergiate', 'Vergiate', 'VA', 'Lombardia', 8646, '00309430122', 'Via Felice Cavallotti, 46', '21029', 'comunevergiate@legalmail.it', null, null, 'www.comune.vergiate.va.it', 'UF8RA4'),
  ('Comune di Viggiù', 'Viggiù', 'VA', 'Lombardia', 5150, '00560200123', 'Via Roma,10', '21059', 'protocollo@pec.comune.viggiu.va.it', 'protocollo@comune.viggiu.va.it', '0332486106', 'www.comune.viggiu.va.it', null),
  ('Comune di Vizzola Ticino', 'Vizzola Ticino', 'VA', 'Lombardia', 594, '00564460129', 'Piazza Guglielmo Marconi N.25', '21010', 'comune.vizzolaticino@halleypec.it', 'info@comune.vizzolaticino.va.it', '0331230819', 'www.comune.vizzolaticino.va.it', 'UFXK3X');

-- 1) Comuni già presenti: aggiorna abitanti e completa i campi vuoti
update companies c set
  abitanti       = v.abitanti,
  citta          = coalesce(c.citta, v.citta),
  provincia      = coalesce(c.provincia, v.provincia),
  regione        = coalesce(c.regione, v.regione),
  piva           = coalesce(c.piva, v.cf),
  address        = coalesce(c.address, v.indirizzo),
  cap            = coalesce(c.cap, v.cap),
  pec            = coalesce(c.pec, v.pec),
  email          = coalesce(c.email, v.email),
  phone          = coalesce(c.phone, v.telefono),
  website        = coalesce(c.website, v.sito),
  codice_univoco = coalesce(c.codice_univoco, v.codice_univoco)
from _comuni v
where lower(c.name) = lower(v.name) and coalesce(c.provincia, v.provincia) = v.provincia;

-- 2) Comuni mancanti: li inserisce
insert into companies (name, tipo, citta, provincia, regione, abitanti, piva,
                       address, cap, pec, email, phone, website, codice_univoco)
select v.name, 'pa', v.citta, v.provincia, v.regione, v.abitanti, v.cf,
       v.indirizzo, v.cap, v.pec, v.email, v.telefono, v.sito, v.codice_univoco
from _comuni v
where not exists (select 1 from companies c where lower(c.name) = lower(v.name)
                  and coalesce(c.provincia, v.provincia) = v.provincia);

drop table if exists _comuni;

-- Controllo: VA = 136 comuni / 884.801 ab.
select provincia, count(*) as comuni, sum(abitanti) as abitanti,
       count(pec) as con_pec, count(email) as con_email, count(phone) as con_telefono
from companies
where tipo = 'pa' and name ilike 'Comune di %' and provincia = 'VA'
group by provincia;

