-- =====================================================================
--  CRM ENER.ING — Comuni delle province di COMO (147) e LECCO (84)
--  Un unico file: contiene due blocchi uguali, uno per provincia.
--  Esegui tutto insieme nel SQL Editor di Supabase ("Run without RLS").
-- =====================================================================

-- =====================================================================
--  CRM ENER.ING — Comuni della provincia di Como con abitanti e contatti
--  Esegui nel SQL Editor di Supabase. Sicuro e ri-eseguibile (non cancella nulla):
--   * aggiunge ai clienti le colonne "abitanti" ed "email" (se mancano);
--   * inserisce i 147 Comuni della provincia di Como come clienti PA;
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
  ('Comune di Albavilla', 'Albavilla', 'CO', 'Lombardia', 6348, '00688320134', 'Piazza Roma 1', '22031', 'comune.albavilla@pec.provincia.como.it', 'info@comune.albavilla.co.it', '0313354353', 'www.comune.albavilla.co.it', 'UFRL4W'),
  ('Comune di Albese con Cassano', 'Albese con Cassano', 'CO', 'Lombardia', 4277, '00654470137', 'Via Roma, 57', '22032', 'comune.albeseconcassano.co@halleycert.it', 'affarigenerali@comune.albeseconcassano.co.it', '031426122', 'www.comune.albeseconcassano.co.it', 'UFDCNL'),
  ('Comune di Albiolo', 'Albiolo', 'CO', 'Lombardia', 2800, '80005530136', 'Via San Francesco, 2', '22070', 'comune.albiolo@pec.regione.lombardia.it', 'info@comune.albiolo.co.it', '031806428', 'www.comune.albiolo.co.it', 'UF5SN3'),
  ('Comune di Alserio', 'Alserio', 'CO', 'Lombardia', 1417, '00600170138', 'Via Carcano N. 9', '22040', 'comune.alserio@halleypec.it', 'info@comune.alserio.co.it', '31630063', 'www.comune.alserio.co.it', 'UFAY0E'),
  ('Comune di Alta Valle Intelvi', 'Alta Valle Intelvi', 'CO', 'Lombardia', 3186, '03686280136', 'Piazza Martino Novi, 2', '22014', 'comune.altavalleintelvi@pec.it', null, '031840132', 'www.comune.altavalleintelvi.co.it', 'UF0QH4'),
  ('Comune di Alzate Brianza', 'Alzate Brianza', 'CO', 'Lombardia', 4834, '00613570134', 'Piazza Municipio, 1', '22040', 'comunealzate@legalmail.it', null, '0316349301', 'www.comune.alzate-brianza.co.it', 'UFY7FL'),
  ('Comune di Anzano del Parco', 'Anzano del Parco', 'CO', 'Lombardia', 1675, '00689510139', 'Piazza Municipio, 1', '22040', 'comune.anzanodelparco@pec.regione.lombardia.it', null, '031630030', 'www.comune.anzano.co.it', 'UF7L5B'),
  ('Comune di Appiano Gentile', 'Appiano Gentile', 'CO', 'Lombardia', 7749, '00602480139', 'Via Baradello, 4', '22070', 'info@pec.comune.appianogentile.co.it', 'protocollo@comune.appianogentile.co.it', '031972811', 'www.comune.appianogentile.co.it', 'UF5DRO'),
  ('Comune di Argegno', 'Argegno', 'CO', 'Lombardia', 676, '80010240135', 'Via Valle Intelvi 7', '22010', 'comune.argegno@pec.provincia.como.it', null, '031821120', 'www.comune.argegno.co.it', 'UFVN1I'),
  ('Comune di Arosio', 'Arosio', 'CO', 'Lombardia', 5227, '81001550136', 'Viale Grandi Invalidi, 6', '22060', 'comune.arosio@halleypec.it', 'finanziaria@comune.arosio.co.it', '0317604316', 'www.comune.arosio.co.it', 'UF15AE'),
  ('Comune di Asso', 'Asso', 'CO', 'Lombardia', 3555, '91001510139', 'Via Matteotti, 66', '22033', 'comune.asso@legalmail.it', null, '031673915', 'www.comune.asso.co.it', 'UF5CG9'),
  ('Comune di Barni', 'Barni', 'CO', 'Lombardia', 611, '00609670138', 'Via Luigi Bricchi, 3', '22030', 'comune.barni@pec.regione.lombardia.it', 'segreteria@comune.barni.co.it', '031965136', 'www.comune.barni.co.it', 'UF0JWH'),
  ('Comune di Bellagio', 'Bellagio', 'CO', 'Lombardia', 3509, '00605620137', 'Via G. Garibaldi, 1', '22021', 'comune.bellagio.co@halleycert.it', 'segreteria@comune.bellagio.co.it', '031950815', 'www.comune.bellagio.co.it', 'UF4FZC'),
  ('Comune di Bene Lario', 'Bene Lario', 'CO', 'Lombardia', 349, '00467880134', 'Via Superiore, 25', '22010', 'comune.benelario@pec.regione.lombardia.it', 'info@comune.benelario.co.it', '034431246', 'www.comune.benelario.co.it', 'UFMG1I'),
  ('Comune di Beregazzo con Figliaro', 'Beregazzo con Figliaro', 'CO', 'Lombardia', 2825, '00596540138', 'Corso Roma, 35', '22070', 'comune.beregazzoconfigliaro@pec.provincia.como.it', 'info@comune.beregazzoconfigliaro.co.it', null, 'www.comune.beregazzoconfigliaro.co.it', 'UFP7UR'),
  ('Comune di Binago', 'Binago', 'CO', 'Lombardia', 4814, '00490260130', 'P.zza V. Veneto, 5', '22070', 'comune.binago@pec.regione.lombardia.it', 'info@comune.binago.co.it', '031940142', 'www.comune.binago.co.it', 'UFWM7X'),
  ('Comune di Bizzarone', 'Bizzarone', 'CO', 'Lombardia', 1789, '00703370130', 'Viale Unita'' d''Italia 1', '22020', 'comune.bizzarone@pec.provincia.como.it', 'info@comune.bizzarone.co.it', '031948847', 'www.comune.bizzarone.co.it', 'UFFX5W'),
  ('Comune di Blessagno', 'Blessagno', 'CO', 'Lombardia', 313, '00680420130', 'Via XX Settembre 13/1', '22028', 'comune.blessagno@pec.provincia.como.it', 'protocollo@comune.blessagno.co.it', '031830444', 'www.comune.blessagno.co.it', 'UFB2TL'),
  ('Comune di Blevio', 'Blevio', 'CO', 'Lombardia', 1002, '00565430139', 'Via Caronti, 54', '22020', 'comune.blevio@pec.regione.lombardia.it', null, '031419477', 'https://www.comune.blevio.co.it/', 'UF0TTF'),
  ('Comune di Bregnano', 'Bregnano', 'CO', 'Lombardia', 6402, '00625920137', 'Piazza IV Novembre N. 9', '22070', 'comune.bregnano@pec.provincia.como.it', 'protocollo@comune.bregnano.co.it', '031771554', 'www.comune.bregnano.co.it', 'UFIBVV'),
  ('Comune di Brenna', 'Brenna', 'CO', 'Lombardia', 2194, '81000430132', 'Via Grimello, 2', '22040', 'comune.brenna@pec.provincia.como.it', 'segreteria@comune.brenna.co.it', '031797070', 'www.comune.brenna.co.it', 'UFTH37'),
  ('Comune di Brienno', 'Brienno', 'CO', 'Lombardia', 311, '80009880131', 'Via Regina 70', '22010', 'comune.brienno@pec.provincia.como.it', 'info@comune.brienno.co.it', '031814016', 'www.comune.brienno.co.it', 'UFT2FZ'),
  ('Comune di Brunate', 'Brunate', 'CO', 'Lombardia', 1572, '80010180133', 'Via alla Chiesa, 2', '22034', 'comune.brunate@pec.provincia.como.it', 'info@comune.brunate.co.it', '031220301', 'www.comune.brunate.co.it', 'UFZIHW'),
  ('Comune di Bulgarograsso', 'Bulgarograsso', 'CO', 'Lombardia', 3957, '00559420138', 'Via Guffanti, 2', '22070', 'comune.bulgarograsso@halleypec.it', null, '031930141', 'www.comune.bulgarograsso.co.it', 'UFUJA9'),
  ('Comune di Cabiate', 'Cabiate', 'CO', 'Lombardia', 7404, '00652960139', 'Via Achille Grandi N. 1', '22060', 'info@pec.comune.cabiate.co.it', 'info@comune.cabiate.co.it', '031769308', 'www.comune.cabiate.co.it', 'UFY0S6'),
  ('Comune di Cadorago', 'Cadorago', 'CO', 'Lombardia', 8051, '00696750132', 'Largo Clerici, 1', '22071', 'protocollo@pec.comune.cadorago.co.it', null, '031903100', 'www.comune.cadorago.co.it', 'UFRCGZ'),
  ('Comune di Caglio', 'Caglio', 'CO', 'Lombardia', 476, '00559560131', 'P.za Vittorio Emanuele II, 10', '22030', 'comune.caglio@pec.regione.lombardia.it', 'info@comune.caglio.co.it', '031667017', 'www.comune.caglio.co.it', 'UF02KL'),
  ('Comune di Campione d''Italia', 'Campione d''Italia', 'CO', 'Lombardia', 1848, '80009700131', 'Piazzale Maestri Campionesi, 4', '22060', 'protocollo.pec@comunecampione.it', 'protocollo@comunecampione.ch', null, 'www.comune.campione-d-italia.co.it', 'UFFVVM'),
  ('Comune di Cantù', 'Cantù', 'CO', 'Lombardia', 40451, '00233930130', 'Piazza Parini 4', '22063', 'comune.cantu@pec.regione.lombardia.it', 'urp@comune.cantu.co.it', null, 'www.comune.cantu.co.it', null),
  ('Comune di Canzo', 'Canzo', 'CO', 'Lombardia', 5223, '00499820132', 'Via Giuseppe Mazzini n. 28', '22035', 'segreteria.comune.canzo@pec.regione.lombardia.it', 'segreteria@comune.canzo.co.it', '031674109', 'www.comune.canzo.co.it', 'UF35GL'),
  ('Comune di Capiago Intimiano', 'Capiago Intimiano', 'CO', 'Lombardia', 5433, '00608850137', 'Via Serenza N.7', '22070', 'comune.capiago-intimiano@legalmail.it', null, '0314630327', 'www.comune.capiago-intimiano.co.it', 'UF8FD5'),
  ('Comune di Carate Urio', 'Carate Urio', 'CO', 'Lombardia', 1090, '80009800139', 'Via Regina N. 105', '22010', 'comune.carateurio@pec.provincia.como.it', 'protocollo@comune.carateurio.co.it', '031400132', 'www.comune.carateurio.co.it', 'UF1V4P'),
  ('Comune di Carbonate', 'Carbonate', 'CO', 'Lombardia', 2977, '80014740130', 'Via Don Zanchetta, 2', '22070', 'comune.carbonate@pec.regione.lombardia.it', 'info@comune.carbonate.co.it', '0331830302', 'www.comune.carbonate.co.it', 'UFIZC7'),
  ('Comune di Carimate', 'Carimate', 'CO', 'Lombardia', 4374, '81003630134', 'Piazza Castello, 1', '22060', 'comune.carimate@pec.regione.lombardia.it', null, '0317894111', 'www.comune.carimate.co.it', 'UFT2EM'),
  ('Comune di Carlazzo', 'Carlazzo', 'CO', 'Lombardia', 3146, '00660580135', 'Via Provinciale, 2452', '22010', 'comunecarlazzo@legalmail.it', 'comunecarlazzo@comune.carlazzo.co.it', null, 'www.comune.carlazzo.co.it', 'UFWFNA'),
  ('Comune di Carugo', 'Carugo', 'CO', 'Lombardia', 6658, '00698230133', 'Via Cadorna, 3', '22060', 'protocollo@pec.comune.carugo.co.it', null, '031758193', 'www.comune.carugo.co.it', 'UFYWFW'),
  ('Comune di Caslino d''Erba', 'Caslino d''Erba', 'CO', 'Lombardia', 1670, '00673790135', 'Piazza Della Vittoria, 1', '22030', 'comune.caslinoderba@pec.como.it', 'segreteria@comune.caslinoderba.co.it', '031621033', 'www.comune.caslinoderba.co.it', 'UF8FMZ'),
  ('Comune di Casnate con Bernate', 'Casnate con Bernate', 'CO', 'Lombardia', 5033, '81001910132', 'Piazza San Carlo', '22070', 'comune.casnateconbernate@pec.provincia.como.it', 'segreteria@comune.casnateconbernate.co.it', '031457200', 'www.comune.casnateconbernate.co.it', 'ZCFBSQ'),
  ('Comune di Cassina Rizzardi', 'Cassina Rizzardi', 'CO', 'Lombardia', 3263, '00544790132', 'Via VITTORIO EMANUELE SECONDO 121', '22070', 'comune.cassinarizzardi@pec.regione.lombardia.it', 'protocollo@comune.cassinarizzardi.co.it', '0318829311', 'www.comune.cassinarizzardi.co.it', 'UFW1FU'),
  ('Comune di Castelmarte', 'Castelmarte', 'CO', 'Lombardia', 1267, '00690170139', 'Via Roma, 16', '22030', 'comunecastelmarte@legalmail.it', 'comune@comune.castelmarte.co.it', '031620600', 'www.comune.castelmarte.co.it', 'UFDXW1'),
  ('Comune di Castelnuovo Bozzente', 'Castelnuovo Bozzente', 'CO', 'Lombardia', 916, '00596040139', 'Via San Martino, 10', '22070', 'comune.castelnuovobozzente@pec.it', 'comune@comune.castelnuovobozzente.co.it', '031988203', 'www.comune.castelnuovobozzente.co.it', 'UFV7KS'),
  ('Comune di Cavargna', 'Cavargna', 'CO', 'Lombardia', 171, '00709660138', 'Piazza XXV Aprile 5', '22010', 'comune.cavargna@pec.regione.lombardia.it', 'info@comune.cavargna.co.it', '034463164', 'www.comune.cavargna.co.it', 'UFJVT0'),
  ('Comune di Centro Valle Intelvi', 'Centro Valle Intelvi', 'CO', 'Lombardia', 3778, '03747990137', 'Largo IV Novembre, 8', '22028', 'centrovalleintelvi@pec.it', 'protocollo@comune.centrovalleintelvi.co.it', '031830141', 'www.comune.centrovalleintelvi.co.it', 'UF4LCJ'),
  ('Comune di Cerano d''Intelvi', 'Cerano d''Intelvi', 'CO', 'Lombardia', 593, '80015600135', 'Via roma 39', '22020', 'comune.ceranodintelvi@pec.regione.lombardia.it', 'info@comune.ceranodintelvi.co.it', '031817110', 'www.comune.ceranodintelvi.co.it', 'UF72WM'),
  ('Comune di Cermenate', 'Cermenate', 'CO', 'Lombardia', 9457, '00550440135', 'Via PADRE GIOVANNI BATTISTA SCALABRINI, 153', '22072', 'cermenate@pec.provincia.como.it', null, '0317776111', 'www.comune.cermenate.co.it', 'UFG9LQ'),
  ('Comune di Cernobbio', 'Cernobbio', 'CO', 'Lombardia', 6152, '00432060135', 'Via Regina, 23', '22012', 'comune.cernobbio.co@halleycert.it', 'info@comune.cernobbio.co.it', '031343211', 'www.comune.cernobbio.co.it', 'UFQV8P'),
  ('Comune di Cirimido', 'Cirimido', 'CO', 'Lombardia', 2198, '00495300139', 'Viale Vittorio Veneto, 53', '22070', 'comune.cirimido@pec.regione.lombardia.it', 'info@comune.cirimido.co.it', null, 'www.comune.cirimido.co.it', 'UF5WFB'),
  ('Comune di Claino con Osteno', 'Claino con Osteno', 'CO', 'Lombardia', 543, '84002230138', 'Via A. Giobbi, 4', '22010', 'comune.clainoconosteno@pec.regione.lombardia.it', 'info@comune.clainoconosteno.co.it', '034465111', 'www.comune.clainoconosteno.co.it', 'UFEP5U'),
  ('Comune di Colonno', 'Colonno', 'CO', 'Lombardia', 432, '00467840138', 'Via Natale Cazzaniga 3', '22010', 'colonno@pec.comune.colonno.co.it', 'info@comune.colonno.co.it', '031821280', 'www.comune.colonno.co.it', 'UFSMVR'),
  ('Comune di Colverde', 'Colverde', 'CO', 'Lombardia', 5553, '03507580136', 'Piazza Della Chiesa, 1', '22041', 'comune.colverde@legalmail.it', 'segreteria@comune.colverde.co.it', '031440191', 'www.comune.colverde.co.it', 'UFU8ZI'),
  ('Comune di Como', 'Como', 'CO', 'Lombardia', 83035, '80005370137', 'Via Vittorio Emanuele II, 97', '22100', 'protocollo@comune.pec.como.it', null, null, 'www.comune.como.it', null),
  ('Comune di Corrido', 'Corrido', 'CO', 'Lombardia', 845, '00665240131', 'Via Val Rezzo 5', '22010', 'protocollo@pec.comune.corrido.co.it', 'anagrafe@comune.corrido.co.it', '034461058', 'www.comune.corrido.co.it', 'UFDZ65'),
  ('Comune di Cremia', 'Cremia', 'CO', 'Lombardia', 674, '00700500135', 'Piazza DELLA GLORIA snc', '22010', 'comune.cremia.co@halleycert.it', 'ragioneria@comune.cremia.co.it', '034487131', 'www.comune.cremia.co.it', 'UFTBAR'),
  ('Comune di Cucciago', 'Cucciago', 'CO', 'Lombardia', 3365, '81001230135', 'Via S. Arialdo N.2', '22060', 'comune.cucciago.co@halleycert.it', 'ufficio.info@comune.cucciago.co.it', '031787302', 'www.comune.cucciago.co.it', 'UF51NC'),
  ('Comune di Cusino', 'Cusino', 'CO', 'Lombardia', 250, '00665280137', 'Piazza San Giovanni 1', '22010', 'comunecusino@legalmail.it', 'info@comune.cusino.co.it', '034466134', 'www.comune.cusino.co.it', 'UFEEFK'),
  ('Comune di Dizzasco', 'Dizzasco', 'CO', 'Lombardia', 642, '00637090135', 'Via Roma, 31', '22020', 'comune.dizzasco@pec.provincia.como.it', 'anagrafe@comune.dizzasco.co.it', '031821202', 'www.comune.dizzasco.co.it', 'UF2C3N'),
  ('Comune di Domaso', 'Domaso', 'CO', 'Lombardia', 1392, '00688470137', 'Via Garibaldi N. 69', '22013', 'protocollo.comune.domaso@pec.regione.lombardia.it', 'ragioneria@comune.domaso.co.it', '034495073', 'www.comune.domaso.co.it', 'UFWXYO'),
  ('Comune di Dongo', 'Dongo', 'CO', 'Lombardia', 3158, '00657120135', 'Piazza Paracchini, 6', '22014', 'comune.dongo@pec.provincia.como.it', null, '034481333', 'www.comune.dongo.co.it', 'UF44U0'),
  ('Comune di Dosso del Liro', 'Dosso del Liro', 'CO', 'Lombardia', 235, '00689050136', 'Piazza Della Chiesa -', '22010', 'comune.dossodelliro@pec.regione.lombardia.it', 'info@comune.dossodelliro.co.it', '034489941', 'www.comune.dossodelliro.co.it', 'UFLAXN'),
  ('Comune di Erba', 'Erba', 'CO', 'Lombardia', 16266, '00430660134', 'Piazza Prepositurale - 1', '22036', 'comune.erba@pec.provincia.como.it', null, null, 'www.comune.erba.co.it', 'UF0P9W'),
  ('Comune di Eupilio', 'Eupilio', 'CO', 'Lombardia', 2526, '00571510130', 'Via G.Strambio N. 9', '22030', 'comuneeupilio@pec.como.it', 'info@comune.eupilio.co.it', '031655623', 'www.comune.eupilio.co.it', 'UFDBLG'),
  ('Comune di Faggeto Lario', 'Faggeto Lario', 'CO', 'Lombardia', 1063, '00678440132', 'Piazza SAN GIORGIO 4', '22020', 'comune.faggetolario@pec.regione.lombardia.it', null, '031378222', 'www.comune.faggetolario.co.it', 'UF5LGY'),
  ('Comune di Faloppio', 'Faloppio', 'CO', 'Lombardia', 4882, '00457290138', 'Via Manzoni 1', '22020', 'comune.faloppio@pec.provincia.como.it', null, '031986100', 'www.comune.faloppio.co.it', 'UFJINY'),
  ('Comune di Fenegrò', 'Fenegrò', 'CO', 'Lombardia', 3326, '00602440133', 'Via Colombo, 19', '22070', 'comune.fenegro@pec.regione.lombardia.it', 'info@comune.fenegro.co.it', '031935722', 'www.comune.fenegro.co.it', 'UF0AR5'),
  ('Comune di Figino Serenza', 'Figino Serenza', 'CO', 'Lombardia', 4972, '00415540137', 'Via XXV Aprile, 16', '22060', 'comune.figinoserenza@pec.provincia.como.it', 'comune@comune.figinoserenza.co.it', '031780160', 'www.comune.figinoserenza.co.it', 'UFOJ7L'),
  ('Comune di Fino Mornasco', 'Fino Mornasco', 'CO', 'Lombardia', 10139, '00308110139', 'Via Garibaldi 78', '22073', 'comune.finomornasco.co@halleycert.it', 'info@comune.finomornasco.co.it', '031883811', 'www.comune.finomornasco.co.it', 'UFJBO3'),
  ('Comune di Garzeno', 'Garzeno', 'CO', 'Lombardia', 656, '93002100134', 'Piazza Della Chiesa, 2', '22010', 'comune.garzeno@pec.regione.lombardia.it', 'info@comune.garzeno.co.it', '034488081', 'www.comune.garzeno.co.it', 'UF7MG6'),
  ('Comune di Gera Lario', 'Gera Lario', 'CO', 'Lombardia', 1065, '00532060134', 'Piazza Risorgimento, 1', '22010', 'comune.geralario@pec.regione.lombardia.it', null, '034484156', 'www.comune.geralario.co.it', 'UFLIM7'),
  ('Comune di Grandate', 'Grandate', 'CO', 'Lombardia', 2803, '00772840138', 'Via Como 12', '22070', 'comune.grandate@halleycert.it', 'info@comune.grandate.co.it', '031457811', 'www.comune.grandate.co.it', 'UFGLDN'),
  ('Comune di Grandola ed Uniti', 'Grandola ed Uniti', 'CO', 'Lombardia', 1289, '00467860136', 'Piazza Camozzi, 2', '22010', 'comune.grandolaeduniti@pec.regione.lombardia.it', null, '034432115', 'www.comune.grandolaeduniti.co.it', 'UFMUVR'),
  ('Comune di Gravedona ed Uniti', 'Gravedona ed Uniti', 'CO', 'Lombardia', 4032, '03322340138', 'Piazza San Rocco, 1', '22015', 'comune.gravedonaeduniti@halleypec.it', 'info@comune.gravedonaeduniti.co.it', '034485291', 'www.comune.gravedonaeduniti.co.it', 'UFG80W'),
  ('Comune di Griante', 'Griante', 'CO', 'Lombardia', 553, '00486580137', 'Via Brentano, 6', '22011', 'griante@pec.comune.griante.co.it', 'info@comune.griante.co.it', '034440416', 'www.comune.griante.co.it', 'UFK4J8'),
  ('Comune di Guanzate', 'Guanzate', 'CO', 'Lombardia', 5810, '00559400130', 'Piazza Salvo D''Acquisto, 1', '22070', 'comune.guanzate@pec.regione.lombardia.it', null, null, 'www.comune.guanzate.co.it', null),
  ('Comune di Inverigo', 'Inverigo', 'CO', 'Lombardia', 9149, '00424960136', 'Via E. Fermi 1', '22044', 'comune.inverigo@pec.provincia.como.it', 'affari.generali@comune.inverigo.co.it', null, 'www.comune.inverigo.co.it', 'UF91KG'),
  ('Comune di Laglio', 'Laglio', 'CO', 'Lombardia', 813, '80009960131', 'Via Regina, 57', '22010', 'laglio.segreteria@legalmail.it', 'segreteria@comune.laglio.co.it', '031400148', 'www.comune.laglio.co.it', 'UFP0YZ'),
  ('Comune di Laino', 'Laino', 'CO', 'Lombardia', 566, '00527740138', 'Via XX Settembre 5', '22020', 'comune.laino@pec.provincia.como.it', 'info@comune.laino.co.it', '031830251', 'www.comune.laino.co.it', 'UFIZ3X'),
  ('Comune di Lambrugo', 'Lambrugo', 'CO', 'Lombardia', 2544, '00627760135', 'Piazza Papa Giovanni Paolo Ii N. 10', '22045', 'comune.lambrugo@pec.provincia.como.it', 'ufficio.segreteria@comune.lambrugo.co.it', '031607212', 'www.comune.lambrugo.co.it', 'UFB4B6'),
  ('Comune di Lasnigo', 'Lasnigo', 'CO', 'Lombardia', 444, '82003460134', 'Via Giuseppe Fioroni n. 7', '22030', 'comune.lasnigo@halleypec.it', 'segreteria@comune.lasnigo.co.it', '031681725', 'www.comune.lasnigo.co.it', 'UFJ3NU'),
  ('Comune di Lezzeno', 'Lezzeno', 'CO', 'Lombardia', 1856, '00595780131', 'Localita'' Chiesa 11', '22025', 'comune.lezzeno@pec.provincia.como.it', 'ragioneria@comune.lezzeno.co.it', '031915413', 'www.comune.lezzeno.co.it', 'UF5UD2'),
  ('Comune di Limido Comasco', 'Limido Comasco', 'CO', 'Lombardia', 3925, '00434590139', 'Via Roma, 13', '22070', 'info@pec.comune.limidocomasco.co.it', null, '031935705', 'www.comune.limidocomasco.co.it', 'UFYTVA'),
  ('Comune di Lipomo', 'Lipomo', 'CO', 'Lombardia', 5869, '00533010138', 'Via Cantaluppi 294', '22030', 'comune.lipomo@pec.provincia.como.it', null, '031558220', 'www.comune.lipomo.co.it', 'UFTFCB'),
  ('Comune di Livo', 'Livo', 'CO', 'Lombardia', 158, '00689060135', 'Via Mazzini', '22010', 'comune.livo@pec.provincia.como.it', 'info@comune.livo.co.it', '34489761', 'www.comune.livo.co.it', 'UFY7TI'),
  ('Comune di Locate Varesino', 'Locate Varesino', 'CO', 'Lombardia', 4303, '00663490134', 'Via Giuseppe Parini, 1', '22070', 'locatevaresino@actaliscertymail.it', null, '0331830148', 'www.comune.locatevaresino.co.it', 'UFLHVA'),
  ('Comune di Lomazzo', 'Lomazzo', 'CO', 'Lombardia', 10046, '00566590139', 'Piazza IV Novembre, 4', '22074', 'comune.lomazzo@pec.provincia.como.it', null, '029694121', 'www.comune.lomazzo.co.it', 'UFWP6H'),
  ('Comune di Longone al Segrino', 'Longone al Segrino', 'CO', 'Lombardia', 1984, '00549780138', 'Via Diaz, 27', '22030', 'comune.longonealsegrino@pec.como.it', 'info@comune.longonealsegrino.co.it', '031641650', 'www.comune.longonealsegrino.co.it', 'UFSDVI'),
  ('Comune di Luisago', 'Luisago', 'CO', 'Lombardia', 2834, '00688600139', 'Piazza Liberta''', '22070', 'comune.luisago@legalmail.it', 'segreteria@comune.luisago.co.it', '031880601', 'www.comune.luisago.co.it', 'UFBZZ5'),
  ('Comune di Lurago d''Erba', 'Lurago d''Erba', 'CO', 'Lombardia', 5587, '82001750130', 'Via Roma, 56', '22040', 'comune.luragoderba@legalmail.it', 'segreteria@comune.luragoderba.co.it', '0313599512', 'www.comune.luragoderba.co.it', 'UFRJXS'),
  ('Comune di Lurago Marinone', 'Lurago Marinone', 'CO', 'Lombardia', 2598, '00602460131', 'Via Castello, 2', '22070', 'comune.luragomarinone@pec.regione.lombardia.it', null, '031895565', 'www.comune.luragomarinone.co.it', 'UFPYFC'),
  ('Comune di Lurate Caccivio', 'Lurate Caccivio', 'CO', 'Lombardia', 9692, '00415790138', 'Via Venti Settembre 16', '22075', 'protocollo@pec.comune.luratecaccivio.co.it', 'protocollo@comune.luratecaccivio.co.it', '031494311', 'www.comune.luratecaccivio.co.it', 'UFT672'),
  ('Comune di Magreglio', 'Magreglio', 'CO', 'Lombardia', 673, '82001830130', 'Piazza Municipio, 2', '22030', 'comune.magreglio@legalmail.it', 'protocollo@comune.magreglio.co.it', '031965119', 'www.comune.magreglio.co.it', 'UFAB07'),
  ('Comune di Mariano Comense', 'Mariano Comense', 'CO', 'Lombardia', 25531, '81001190131', 'Piazzale Console Teodoro Manlio, 6/8', '22066', 'comune.marianocomense@pec.regione.lombardia.it', null, '031757211', 'www.comune.mariano-comense.co.it', 'UFA1Q6'),
  ('Comune di Maslianico', 'Maslianico', 'CO', 'Lombardia', 3162, '00644530131', 'Via XX Settembre, 43', '22026', 'maslianico.protocollo@legalmailpa.it', 'protocollo@comune.maslianico.co.it', '031511374', 'www.comune.maslianico.co.it', 'UFJ4RG'),
  ('Comune di Menaggio', 'Menaggio', 'CO', 'Lombardia', 2946, '00562850131', 'Via Lusardi 26', '22017', 'comune.menaggio@pec.provincia.como.it', 'ufficio.segreteria@comune.menaggio.co.it', '034436411', 'www.comune.menaggio.co.it', 'UFTF1L'),
  ('Comune di Merone', 'Merone', 'CO', 'Lombardia', 4003, '00549420131', 'Via Appiani 22', '22046', 'comune.merone.co@halleycert.it', 'affarigenerali@comune.merone.co.it', '031650000', 'www.comune.merone.co.it', 'UF07NA'),
  ('Comune di Moltrasio', 'Moltrasio', 'CO', 'Lombardia', 1485, '00601410137', 'Via Besana, 67', '22010', 'comune.moltrasio@pec.provincia.como.it', null, '031290402', 'www.comune.moltrasio.co.it', 'UFSA95'),
  ('Comune di Monguzzo', 'Monguzzo', 'CO', 'Lombardia', 2381, '00564160133', 'Via Santuario 11', '22040', 'comune.monguzzo.co@halleycert.it', 'info@comune.monguzzo.co.it', '031650211', 'www.comune.monguzzo.co.it', 'UFFIPQ'),
  ('Comune di Montano Lucino', 'Montano Lucino', 'CO', 'Lombardia', 5479, '00616910139', 'Via Liveria 7', '22070', 'comune.montanolucino@pec.provincia.como.it', 'protocollo@comune.montanolucino.co.it', '031478011', 'www.comune.montanolucino.co.it', 'UFP9FY'),
  ('Comune di Montemezzo', 'Montemezzo', 'CO', 'Lombardia', 203, '00711160135', 'Via Chiesa', '22010', 'comunemontemezzo@pec.provincia.como.it', 'info@comune.montemezzo.co.it', '034484374', 'comune.montemezzo.co.it', 'UF3FI2'),
  ('Comune di Montorfano', 'Montorfano', 'CO', 'Lombardia', 2494, '00526050133', 'Piazza Roma 18', '22030', 'comune.montorfano@pec.provincia.como.it', 'info@comune.montorfano.co.it', '031553315', 'www.comune.montorfano.co.it', 'UF88F3'),
  ('Comune di Mozzate', 'Mozzate', 'CO', 'Lombardia', 8684, '80009080138', 'Piazza Cornaggia, 2', '22076', 'comune.mozzate@pec.provincia.como.it', 'protocollo@comune.mozzate.co.it', null, 'www.comune.mozzate.co.it', 'UFLFID'),
  ('Comune di Musso', 'Musso', 'CO', 'Lombardia', 935, '00700510134', 'Piazza Della Vittoria, 1', '22010', 'comune.musso@halleypec.it', 'segreteria@comune.musso.co.it', '034481154', 'www.comune.musso.co.it', 'UFS9Y5'),
  ('Comune di Nesso', 'Nesso', 'CO', 'Lombardia', 1074, '00529210130', 'Via Pietro Binda 9', '22020', 'comune.nesso@pec.regione.lombardia.it', 'info@comune.nesso.co.it', null, 'www.comune.nesso.co.it', 'UFUBXE'),
  ('Comune di Novedrate', 'Novedrate', 'CO', 'Lombardia', 2871, '81003670130', 'Via Taverna 3', '22060', 'comune.novedrate@pec.provincia.como.it', null, '0317897711', 'www.comune.novedrate.co.it', 'UF849T'),
  ('Comune di Olgiate Comasco', 'Olgiate Comasco', 'CO', 'Lombardia', 12184, '00417080132', 'Piazza Alessandro Volta 1', '22077', 'comune.olgiate-comasco@legalmail.it', null, '031994611', 'www.comune.olgiate-comasco.co.it', 'UFHEJZ'),
  ('Comune di Oltrona di San Mamette', 'Oltrona di San Mamette', 'CO', 'Lombardia', 2356, '00686080136', 'Via Don F.Conti 3', '22070', 'comune.oltronadisanmamette@pec.it', 'SEGRETERIA@COMUNE.OLTRONADISANMAMETTE.CO.IT', '031930267', 'www.comune.oltronadisanmamette.co.it', 'UFGK0U'),
  ('Comune di Orsenigo', 'Orsenigo', 'CO', 'Lombardia', 2638, '00711250134', 'Via Per Erba, 1', '22030', 'comune.orsenigo@pec.provincia.como.it', 'info@comune.orsenigo.co.it', '031630225', 'www.comune.orsenigo.co.it', 'UFES4M'),
  ('Comune di Peglio', 'Peglio', 'CO', 'Lombardia', 193, '00689040137', 'Via Costanzo Antegnati,29', '22010', 'comune.peglio@pec.regione.lombardia.it', 'info@comune.peglio.co.it', '034489710', 'https://www.comune.peglio.co.it', 'UFD7X5'),
  ('Comune di Pianello del Lario', 'Pianello del Lario', 'CO', 'Lombardia', 1074, '00700520133', 'Piazza DEL COMUNE, 1', '22010', 'comune.pianellodellario@pec.provincia.como.it', 'info@comune.pianellodellario.co.it', '034487121', 'www.comune.pianellodellario.co.it', 'UFK16I'),
  ('Comune di Pigra', 'Pigra', 'CO', 'Lombardia', 229, '00680400132', 'Via Garibaldi, 14', '22020', 'comune.pigra@pec.provincia.como.it', 'protocollo@comune.pigra.co.it', null, 'www.comune.pigra.co.it', 'UFSLUV'),
  ('Comune di Plesio', 'Plesio', 'CO', 'Lombardia', 807, '00500500137', 'Via Alla Grona, 85', '22010', 'comune.plesio@pec.regione.lombardia.it', 'ragioneria@comune.plesio.co.it', '034437065', 'https://www.comune.plesio.co.it', 'UFDN13'),
  ('Comune di Pognana Lario', 'Pognana Lario', 'CO', 'Lombardia', 657, '00678420134', 'Via Don Paolo Bernasconi, 2', '22020', 'comune.pognanalario@pec.regione.lombardia.it', 'info@comune.pognanalario.co.it', '031377888', 'www.comune.pognanalario.co.it', 'UF93VW'),
  ('Comune di Ponna', 'Ponna', 'CO', 'Lombardia', 223, '00527720130', 'Via Trento 2', '22020', 'comune.ponna.co@halleycert.it', 'info@comune.ponna.co.it', '031844937', 'www.comune.ponna.co.it', 'UFOEZF'),
  ('Comune di Ponte Lambro', 'Ponte Lambro', 'CO', 'Lombardia', 4266, '00601450133', 'Via Roma 23', '22037', 'comune.pontelambro@pec.provincia.como.it', 'protocollo@comune.pontelambro.co.it', '031623240', 'www.comune.pontelambro.co.it', null),
  ('Comune di Porlezza', 'Porlezza', 'CO', 'Lombardia', 4901, '00542250139', 'Via G. Garibaldi, 66', '22018', 'porlezza@pec.it', 'protocollo@comune.porlezza.co.it', '034461105', 'www.comune.porlezza.co.it', '5M9264'),
  ('Comune di Proserpio', 'Proserpio', 'CO', 'Lombardia', 951, '00528510134', 'Piazza Enrico Brenna 3', '22030', 'comune.proserpio.co@halleypec.it', 'info@comune.proserpio.co.it', '031621660', 'www.comune.proserpio.co.it', 'UFAJ62'),
  ('Comune di Pusiano', 'Pusiano', 'CO', 'Lombardia', 1301, '00512860131', 'Via Mazzini, 39', '22030', 'comune.pusiano@pec.regione.lombardia.it', 'info@comune.pusiano.co.it', null, 'www.comune.pusiano.co.it', 'UFLD48'),
  ('Comune di Rezzago', 'Rezzago', 'CO', 'Lombardia', 311, '00562720136', 'Via Santa Valeria, 43', '22030', 'comune.rezzago@pec.regione.lombardia.it', 'info@comune.rezzago.co.it', '031667012', 'www.comune.rezzago.co.it', 'UF1NHL'),
  ('Comune di Rodero', 'Rodero', 'CO', 'Lombardia', 1282, '80010680132', 'Via Italo Buzzi, 3', '22070', 'comune.rodero@pec.regione.lombardia.it', 'ragioneria@comune.rodero.co.it', '031806344', 'www.comune.rodero.co.it', null),
  ('Comune di Rovellasca', 'Rovellasca', 'CO', 'Lombardia', 8028, '00227550134', 'Piazza Dr. G. Vincenzi', '22069', 'comune.rovellasca@pec.provincia.como.it', 'segreteria@comune.rovellasca.co.it', '0296961846', 'www.comune.rovellasca.co.it', 'UFM84P'),
  ('Comune di Rovello Porro', 'Rovello Porro', 'CO', 'Lombardia', 6387, '00227560133', 'Piazza Risorgimento, 3', '22070', 'comune.rovelloporro@pec.provincia.como.it', null, '0296751464', 'www.comune.rovelloporro.co.it', 'UFC6FP'),
  ('Comune di Sala Comacina', 'Sala Comacina', 'CO', 'Lombardia', 456, '00532640133', 'Piazza L. Puricelli, 3', '22010', 'comune.salacomacina@pec.provincia.como.it', 'info@comune.salacomacina.co.it', '034455102', 'www.comune.salacomacina.co.it', 'UFQ4PC'),
  ('Comune di San Bartolomeo Val Cavargna', 'San Bartolomeo Val Cavargna', 'CO', 'Lombardia', 926, '00709670137', 'Via Trieste, 11', '22010', 'comune.sanbartolomeovc@pec.regione.lombardia.it', 'protocollo@comune.sanbartolomeovalcavargna.co.it', null, 'https://www.comune.sanbartolomeovalcavargna.co.it', 'UFPJIX'),
  ('Comune di San Fermo della Battaglia', 'San Fermo della Battaglia', 'CO', 'Lombardia', 7770, '00354000135', 'Piazza XXVII Maggio, 1', '22020', 'comune.sanfermodellabattaglia@pec.provincia.como.it', null, '0315440011', 'www.comune.sanfermodellabattaglia.co.it', 'UFD2FN'),
  ('Comune di San Nazzaro Val Cavargna', 'San Nazzaro Val Cavargna', 'CO', 'Lombardia', 256, '00709680136', 'Via Don Luigi Gabbani 168 C', '22010', 'comune.snazzarovc@pec.regione.lombardia.it', 'info@comune.sannazzarovalcavargna.co.it', '034466113', 'www.comune.sannazzarovalcavargna.co.it', 'UFZRAG'),
  ('Comune di San Siro', 'San Siro', 'CO', 'Lombardia', 1672, '02708300138', 'Via Don Giacomo Galli, 4', '22010', 'comune.sansiro@halleycert.it', 'info@comune.sansiro.co.it', '034450015', 'https://comune.sansiro.co.it', 'UFE9WS'),
  ('Comune di Schignano', 'Schignano', 'CO', 'Lombardia', 868, '80015680137', 'Via Domenico Giobbi, 42', '22020', 'comune.schignano@pec.provincia.como.it', 'ragioneria@comune.schignano.co.it', '031819603', 'www.comune.schignano.co.it', 'UF1XHN'),
  ('Comune di Senna Comasco', 'Senna Comasco', 'CO', 'Lombardia', 3174, '00616060133', 'Via Roma, 3', '22070', 'sennacomasco1@halleycert.it', 'info@comune.sennacomasco.co.it', '031460150', 'www.comune.sennacomasco.co.it', 'UF1B09'),
  ('Comune di Solbiate con Cagno', 'Solbiate con Cagno', 'CO', 'Lombardia', 4638, '03807550136', 'Piazza IV Novembre 5', '22070', 'comune.solbiateconcagno@pec.provincia.como.it', null, '031940249', 'www.comune.solbiateconcagno.co.it', 'UF0DFX'),
  ('Comune di Sorico', 'Sorico', 'CO', 'Lombardia', 1243, '00707670139', 'Piazza C. Battisti, 2', '22010', 'comune.sorico@halleycert.it', 'info@comune.sorico.co.it', '034484121', 'www.comune.sorico.co.it', 'UF2730'),
  ('Comune di Sormano', 'Sormano', 'CO', 'Lombardia', 692, '82003520135', 'Via Trento Trieste, 14', '22030', 'comune.sormano@pec.regione.lombardia.it', 'ragioneria@comune.sormano.co.it', '031667069', 'www.comune.sormano.co.it', 'UF5SGL'),
  ('Comune di Stazzona', 'Stazzona', 'CO', 'Lombardia', 593, '00657140133', 'Via Alla Chiesa 231/A', '22010', 'comune.stazzona@halleypec.it', 'info@comune.stazzona.co.it', null, 'www.comune.stazzona.co.it', 'UFOX2H'),
  ('Comune di Tavernerio', 'Tavernerio', 'CO', 'Lombardia', 5586, '00630080133', 'Via Provinciale Per Lecco, 45', '22038', 'comune.tavernerio@halleycert.it', null, null, 'www.comune.tavernerio.co.it', 'UF17XJ'),
  ('Comune di Torno', 'Torno', 'CO', 'Lombardia', 1030, '00565380136', 'Via Plinio, 4', '22020', 'comune.torno@halleypec.it', 'info@comune.torno.co.it', '031419555', 'https://www.comune.torno.co.it/', 'UFLWZQ'),
  ('Comune di Tremezzina', 'Tremezzina', 'CO', 'Lombardia', 4942, '03504700133', 'Via S. Stefano 7', '22016', 'protocollo@pec.comune.tremezzina.co.it', 'info@comune.tremezzina.co.it', '03445583900', 'www.comune.tremezzina.co.it', 'UF52GH'),
  ('Comune di Trezzone', 'Trezzone', 'CO', 'Lombardia', 231, '00711150136', 'Via Regina, 35', '22010', 'comune.trezzone@pec.provincia.como.it', 'info@comune.trezzone.co.it', '034484478', 'www.comune.trezzone.co.it', 'UFLVDM'),
  ('Comune di Turate', 'Turate', 'CO', 'Lombardia', 9911, '00520110131', 'Via Vittorio Emanuele 2', '22078', 'comune.turate@pec.provincia.como.it', 'urpturate@comune.turate.co.it', null, 'www.comune.turate.co.it', 'UFXU12'),
  ('Comune di Uggiate con Ronago', 'Uggiate con Ronago', 'CO', 'Lombardia', 6825, '04137960136', 'Piazza Della Pieve 1', '22029', 'protocollo@pec.comune.uggiateconronago.co.it', 'protocollo@comune.uggiateconronago.co.it', null, 'http://www.comune.uggiateconronago.co.it/', null),
  ('Comune di Val Rezzo', 'Val Rezzo', 'CO', 'Lombardia', 172, '84000950133', 'Via Provinciale, 4', '22010', 'comune.valrezzo@pec.regione.lombardia.it', null, '034463151', 'www.comune.valrezzo.co.it', 'UFREHV'),
  ('Comune di Valbrona', 'Valbrona', 'CO', 'Lombardia', 2622, '82002310132', 'Via Vittorio Veneto, 8', '22039', 'comunevalbrona@halleycert.it', null, '031661176', 'www.comune.valbrona.co.it', 'UFPHL7'),
  ('Comune di Valmorea', 'Valmorea', 'CO', 'Lombardia', 2595, '00651150138', 'Via Roma, 85', '22070', 'comune.valmorea@pec.regione.lombardia.it', 'protocollo@comune.valmorea.co.it', '031806155', 'www.comune.valmorea.co.it', 'UFNXD3'),
  ('Comune di Valsolda', 'Valsolda', 'CO', 'Lombardia', 1434, '00598360139', 'Via M.Bellotti, 21', '22010', 'comune.valsolda@halleycert.it', 'info@comune.valsolda.co.it', '034468121', 'www.comune.valsolda.co.it', 'UFE90B'),
  ('Comune di Veleso', 'Veleso', 'CO', 'Lombardia', 195, '00642650139', 'Piazza Mons. E. Zerboni, 1', '22020', 'comune.veleso@pec.provincia.como.it', 'info@comune.veleso.co.it', null, 'www.comune.veleso.co.it', 'UFVFM2'),
  ('Comune di Veniano', 'Veniano', 'CO', 'Lombardia', 3157, '00434660130', 'Via Nazione Italiana, 2', '22070', 'comune.veniano@pec.provincia.como.it', 'anagrafe@comunediveniano.it', '031890841', 'www.comune.veniano.co.it', 'UF8YZD'),
  ('Comune di Vercana', 'Vercana', 'CO', 'Lombardia', 732, '00688460138', 'Via Per Vico, 3', '22013', 'protocollo.comune.vercana@pec.regione.lombardia.it', 'info@comune.vercana.co.it', '034496296', 'www.comune.vercana.co.it/', 'UFPWY7'),
  ('Comune di Vertemate con Minoprio', 'Vertemate con Minoprio', 'CO', 'Lombardia', 4189, '00549440139', 'Piazza Italia, 1', '22070', 'comune.vertemateconminoprio@pec.provincia.como.it', null, '031888811', 'www.comune.vertemateconminoprio.co.it', 'UFSK6E'),
  ('Comune di Villa Guardia', 'Villa Guardia', 'CO', 'Lombardia', 7867, '00602060139', 'Via Varesina, 72', '22079', 'comune.villaguardia@pec.provincia.como.it', null, '031485211', 'www.comune.villaguardia.co.it', 'UFQ777'),
  ('Comune di Zelbio', 'Zelbio', 'CO', 'Lombardia', 182, '00642670137', 'Piazza Roma, 1', '22020', 'comune.zelbio.co@halleycert.it', 'info@comune.zelbio.co.it', null, 'http://www.comune.zelbio.co.it/hh/index.php', 'UFPMWK');

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

-- Controllo: CO = 147 comuni / 598.562 ab.
select provincia, count(*) as comuni, sum(abitanti) as abitanti,
       count(pec) as con_pec, count(email) as con_email, count(phone) as con_telefono
from companies
where tipo = 'pa' and name ilike 'Comune di %' and provincia = 'CO'
group by provincia;



-- =====================================================================
--  CRM ENER.ING — Comuni della provincia di Lecco con abitanti e contatti
--  Esegui nel SQL Editor di Supabase. Sicuro e ri-eseguibile (non cancella nulla):
--   * aggiunge ai clienti le colonne "abitanti" ed "email" (se mancano);
--   * inserisce i 84 Comuni della provincia di Lecco come clienti PA;
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
  ('Comune di Abbadia Lariana', 'Abbadia Lariana', 'LC', 'Lombardia', 3138, '83007090133', 'Via Nazionale, 120', '23821', 'comune.abbadialariana@legalmail.it', 'info@comune.abbadia-lariana.lc.it', null, 'www.comune.abbadia-lariana.lc.it/', 'UF91PG'),
  ('Comune di Airuno', 'Airuno', 'LC', 'Lombardia', 2928, '85001580134', 'Via Pizzagalli Magno 4', '23881', 'airuno@cert.legalmail.it', null, '0399943222', 'www.comune.airuno.lc.it', 'UFFMIJ'),
  ('Comune di Annone di Brianza', 'Annone di Brianza', 'LC', 'Lombardia', 2283, '00721860138', 'Via S. Antonio 4', '23841', 'comune.annonedibrianza@pec.regione.lombardia.it', 'info@comune.annone-di-brianza.lc.it', '0341576063', 'https://www.comune.annone-di-brianza.lc.it', 'UFQGUF'),
  ('Comune di Ballabio', 'Ballabio', 'LC', 'Lombardia', 4181, '00548170133', 'Via MAZZINI,2', '23811', 'comune.ballabio@legalmail.it', 'info@comune.ballabio.lc.it', '0341530111', 'www.comune.ballabio.lc.it', 'UFMA9F'),
  ('Comune di Barzago', 'Barzago', 'LC', 'Lombardia', 2407, '00624020137', 'Via Roma n. 2', '23890', 'barzago@cert.legalmail.it', null, '031860227', 'www.comune.barzago.lc.it', 'UFUI1T'),
  ('Comune di Barzanò', 'Barzanò', 'LC', 'Lombardia', 5047, '85001610139', 'Viale Luciano Manara, 13', '23891', 'protocollo@cert.comune.barzano.lc.it', null, '039921301', 'www.comune.barzano.lc.it', 'UFMYZV'),
  ('Comune di Barzio', 'Barzio', 'LC', 'Lombardia', 1269, '00444270136', 'Via Manzoni Alessandro, 12', '23816', 'comune.barzio.lc@halleycert.it', 'segreteria@comune.barzio.lc.it', '0341996125', 'www.comune.barzio.lc.it', 'UFBDVW'),
  ('Comune di Bellano', 'Bellano', 'LC', 'Lombardia', 3357, '00563380138', 'Via Vittorio Veneto, 23', '23822', 'comune-bellano@legalmail.it', null, '0341821124', 'www.comune.bellano.lc.it', 'UFLDG9'),
  ('Comune di Bosisio Parini', 'Bosisio Parini', 'LC', 'Lombardia', 3199, '91002210135', 'Piazza G. Parini, 1', '23842', 'protocollo_bosisioparini@halleypec.it', 'info@comune.bosisioparini.lc.it', '0313580511', 'www.comune.bosisioparini.lc.it', 'UFQ05E'),
  ('Comune di Brivio', 'Brivio', 'LC', 'Lombardia', 4351, '85001590133', 'Via Vittorio Emanuele II 22/A', '23883', 'comune.brivio.lc@legalmail.it', null, '0395320114', 'www.comune.brivio.lc.it', 'UF3TTQ'),
  ('Comune di Bulciago', 'Bulciago', 'LC', 'Lombardia', 2925, '00666090139', 'Via Dante N. 2', '23892', 'comune.bulciago@legalmail.it', null, '031860121', 'www.comune.bulciago.lc.it', 'UFG15A'),
  ('Comune di Calco', 'Calco', 'LC', 'Lombardia', 5476, '85001510131', 'Via C. Cantu'' 1', '23885', 'calco@legalmail.it', null, null, 'www.comune.calco.lc.it', 'UF8HX4'),
  ('Comune di Calolziocorte', 'Calolziocorte', 'LC', 'Lombardia', 13593, '82001550167', 'Piazza Vittorio Veneto, 13', '23801', 'calolziocorte@legalmail.it', null, '0341639111', 'www.comune.calolziocorte.lc.it', 'UF15SW'),
  ('Comune di Carenno', 'Carenno', 'LC', 'Lombardia', 1390, '00330080169', 'Via Roma, 36', '23802', 'comune.carenno@pec.regione.lombardia.it', 'segreteria@comune.carenno.lc.it', '0341610220', 'www.comune.carenno.lc.it', 'UFGOXC'),
  ('Comune di Casargo', 'Casargo', 'LC', 'Lombardia', 833, '00561530130', 'Via Roma 1A', '23831', 'comune.casargo@pec.regione.lombardia.it', null, '0341840123', 'www.comune.casargo.lc.it', 'UFC1CQ'),
  ('Comune di Casatenovo', 'Casatenovo', 'LC', 'Lombardia', 13234, '00631280138', 'Piazza Della Repubblica 7', '23880', 'protocollo.casatenovo@legalmail.it', 'ufficio.protocollo@comune.casatenovo.lc.it', '0399235204', 'https://comune.casatenovo.lc.it/', 'UFRAYV'),
  ('Comune di Cassago Brianza', 'Cassago Brianza', 'LC', 'Lombardia', 4395, '85001370130', 'Piazza Italia Libera, 2', '23893', 'comune.cassagobrianza@pec.regione.lombardia.it', 'info@comune.cassago.lc.it', '039921321', 'www.comune.cassago.lc.it', 'UFB84E'),
  ('Comune di Cassina Valsassina', 'Cassina Valsassina', 'LC', 'Lombardia', 549, '83001130133', 'Piazza Comunale, 2', '23817', 'comune.cassinavalsassina@pec.regione.lombardia.it', 'info@comune.cassinavalsassina.lc.it', '0341996181', 'www.comune.cassinavalsassina.lc.it', 'UFRKE0'),
  ('Comune di Castello di Brianza', 'Castello di Brianza', 'LC', 'Lombardia', 2633, '83007650134', 'Via Dante, 1', '23884', 'ufficioprotocollo@comune.castellodibrianza.legalmail.it', null, '0395310312', 'www.comune.castellobrianza.lc.it', 'UFUIOW'),
  ('Comune di Cernusco Lombardone', 'Cernusco Lombardone', 'LC', 'Lombardia', 3837, '85001410134', 'Piazza Enrico Da Cernusco N. 1', '23870', 'comune.cernuscolombardone@legalmail.it', 'amministrazione@comune.cernuscolombardone.lc.it', '0399902314', 'www.comune.cernuscolombardone.lc.it', 'UFO9U3'),
  ('Comune di Cesana Brianza', 'Cesana Brianza', 'LC', 'Lombardia', 2327, '00721850139', 'Via Papa Giovanni XXIII, 4', '23861', 'comune.cesanabrianza@pec.regione.lombardia.it', 'segreteria@comune.cesana-brianza.lc.it', '031655673', 'www.comune.cesana-brianza.lc.it', 'UF5YJW'),
  ('Comune di Civate', 'Civate', 'LC', 'Lombardia', 3709, '00505190132', 'Via A. Manzoni, 5', '23862', 'comune.civate.lc@halleycert.it', 'info@comune.civate.lc.it', '0341213111', 'www.comune.civate.lc.it', 'UFC184'),
  ('Comune di Colico', 'Colico', 'LC', 'Lombardia', 8188, '83006690131', 'Piazza V Alpini', '23823', 'comune.colico@cert.legalmail.it', 'info@comune.colico.lc.it', '0341934711', 'www.comune.colico.lc.it', 'UFVA8P'),
  ('Comune di Colle Brianza', 'Colle Brianza', 'LC', 'Lombardia', 1860, '83007970136', 'Piazza Roma, 4', '23886', 'protocollo@comune.collebrianza.legalmail.it', 'protocollo@comune.collebrianza.lc.it', '0399260014', 'www.comune.collebrianza.lc.it', 'UF5GQI'),
  ('Comune di Cortenova', 'Cortenova', 'LC', 'Lombardia', 1173, '00617350137', 'Piazza Umberto I 5', '23813', 'comune.cortenova@legalmail.it', 'info@comune.cortenova.lc.it', '0341901110', 'www.comune.cortenova.lc.it', 'UF6A1W'),
  ('Comune di Costa Masnaga', 'Costa Masnaga', 'LC', 'Lombardia', 4738, '82002850137', 'Via XXV Aprile 70', '23845', 'comune.costamasnaga@pec.regione.lombardia.it', null, '031358981', 'www.comune.costamasnaga.lc.it', 'UFU5MA'),
  ('Comune di Crandola Valsassina', 'Crandola Valsassina', 'LC', 'Lombardia', 261, '00559700133', 'Piazza IV Novembre 1', '23832', 'comune.crandolavalsassina@pec.regione.lombardia.it', null, '0341840119', 'www.comune.crandola.lc.it', 'UFSC2Q'),
  ('Comune di Cremella', 'Cremella', 'LC', 'Lombardia', 1689, '85001730135', 'Piazza Don S. Colombo, 1', '23894', 'comune.cremella.lc@halleycert.it', 'info@comune.cremella.lc.it', '0399211049', 'www.comune.cremella.lc.it', 'UFMGF6'),
  ('Comune di Cremeno', 'Cremeno', 'LC', 'Lombardia', 1839, '00565360138', 'Via XXV Aprile N. 14', '23814', 'comune.cremeno@legalmail.it', 'info@comune.cremeno.lc.it', '0341996113', 'www.comune.cremeno.lc.it', 'UFTK7I'),
  ('Comune di Dervio', 'Dervio', 'LC', 'Lombardia', 2518, '00570640136', 'Piazza Quattro Novembre 3', '23824', 'comune.dervio@pec.regione.lombardia.it', 'info@comune.dervio.lc.it', '0341806412', 'www.comune.dervio.lc.it', 'UFEXPG'),
  ('Comune di Dolzago', 'Dolzago', 'LC', 'Lombardia', 2544, '00624600136', 'Piazza Della Repubblica 7/8', '23843', 'dolzago@legalmail.it', null, null, 'www.comune.dolzago.lc.it', 'UF51YC'),
  ('Comune di Dorio', 'Dorio', 'LC', 'Lombardia', 325, '00651610131', 'Via Piave, 10', '23824', 'comune.dorio@pec.regione.lombardia.it', 'info@comune.dorio.lc.it', '0341807780', 'www.comune.dorio.lc.it', 'UFBGGZ'),
  ('Comune di Ello', 'Ello', 'LC', 'Lombardia', 1187, '00624040135', 'Via m. de vecchi 17', '23848', 'ello@postemailcertificata.it', 'info@comune.ello.lc.it', '0341576164', 'www.comune.ello.lc.it', 'UFKOH8'),
  ('Comune di Erve', 'Erve', 'LC', 'Lombardia', 644, '00326840162', 'Via Roma 11', '23805', 'comune.erve@pec.regione.lombardia.it', null, '0341607777', 'www.comune.erve.lc.it', 'UFYT3B'),
  ('Comune di Esino Lario', 'Esino Lario', 'LC', 'Lombardia', 751, '00432770139', 'Piazza Ing. Pietro Pensa, 4', '23825', 'comune.esinolario@pec.regione.lombardia.it', 'ragioneria@comune.esinolario.lc.it', '0341860111', 'www.comune.esinolario.lc.it', 'UF9LOF'),
  ('Comune di Galbiate', 'Galbiate', 'LC', 'Lombardia', 8426, '00426650131', 'Piazza Martiri Liberazione 6', '23851', 'galbiate@cert.legalmail.it', null, '0341241411', 'www.comune.galbiate.lc.it', 'UFZ7NB'),
  ('Comune di Garbagnate Monastero', 'Garbagnate Monastero', 'LC', 'Lombardia', 2503, '83002960132', 'Viale Brianza N. 08', '23846', 'comune.garbagnatemonastero.lc@halleypec.it', null, '031850032', 'www.comune.garbagnate-monastero.lc.it', 'UFLTM9'),
  ('Comune di Garlate', 'Garlate', 'LC', 'Lombardia', 2661, '83003020134', 'Via Statale 497', '23852', 'comune.garlate@halleypec.it', 'info@comune.garlate.lc.it', '0341681306', 'www.comune.garlate.lc.it', 'UF8SLB'),
  ('Comune di Imbersago', 'Imbersago', 'LC', 'Lombardia', 2565, '85002420132', 'Via Castelbarco 1', '23898', 'comune.imbersago.lc@halleypec.it', 'protocollo@comune.imbersago.lc.it', '0399920198', 'www.comune.imbersago.lc.it', 'UFGR1R'),
  ('Comune di Introbio', 'Introbio', 'LC', 'Lombardia', 1948, '83006970137', 'Via Vittorio Emanuele II, 14', '23815', 'introbio@postemailcertificata.it', 'info@comune.introbio.lc.it', '0341980218', 'www.comune.introbio.lc.it', 'UFGXGW'),
  ('Comune di La Valletta Brianza', 'La Valletta Brianza', 'LC', 'Lombardia', 4637, '94035580136', 'Via Madre Maria Candida Casero n. 2', '23888', 'comune.lavallettabrianza@pec.regione.lombardia.it', null, '0395311174', 'www.comune.lavallettabrianza.lc.it', 'UFC568'),
  ('Comune di Lecco', 'Lecco', 'LC', 'Lombardia', 47326, '00623530136', 'Piazza Diaz, 1', '23900', 'comune@pec.comunedilecco.it', null, null, 'www.comune.lecco.it', 'UF1GKZ'),
  ('Comune di Lierna', 'Lierna', 'LC', 'Lombardia', 2111, '83007030139', 'Via E.V. Parodi 33', '23827', 'comune.lierna@pec.comune.lierna.lc.it', 'segreteria@comune.lierna.lc.it', '0341740108', 'www.comune.lierna.lc.it', 'UF4ZQ7'),
  ('Comune di Lomagna', 'Lomagna', 'LC', 'Lombardia', 5118, '00504810136', 'Via Fratelli Kennedy, 20', '23871', 'comune.lomagna.lc@halleycert.it', 'protocollo@comune.lomagna.lc.it', '039922510', 'www.comune.lomagna.lc.it', 'UFTE8H'),
  ('Comune di Malgrate', 'Malgrate', 'LC', 'Lombardia', 4146, '00556750131', 'Via Agudio, 10', '23864', 'comune.malgrate@pec.regione.lombardia.it', 'protocollo@comune.malgrate.lc.it', null, 'www.comune.malgrate.lc.it', 'UFJ1LM'),
  ('Comune di Mandello del Lario', 'Mandello del Lario', 'LC', 'Lombardia', 9856, '00629950130', 'Piazza Leonardo Da Vinci, 6', '23826', 'comune.mandellolario@pec.regione.lombardia.it', 'info@mandellolario.it', null, 'https://www.comune.mandello.lc.it/', 'UFGEP8'),
  ('Comune di Margno', 'Margno', 'LC', 'Lombardia', 421, '00559900139', 'Via Al Tennis, 2', '23832', 'comune.margno@pec.regione.lombardia.it', 'anagrafe@comune.margno.lc.it', '0341840049', 'www.comune.margno.lc.it', 'UFS3OL'),
  ('Comune di Merate', 'Merate', 'LC', 'Lombardia', 15031, '00703920132', 'Piazza Degli Eroi, 3', '23807', 'comune.merate@halleypec.it', 'protocollo@comune.merate.lc.it', null, 'www.comune.merate.lc.it', 'UFXKLN'),
  ('Comune di Missaglia', 'Missaglia', 'LC', 'Lombardia', 9010, '00612960138', 'Via Merlini, 2', '23873', 'comune.missaglia@pec.regione.lombardia.it', 'comune@comune.missaglia.lc.it', '0399241232', 'www.comune.missaglia.lc.it', 'UFF3ZK'),
  ('Comune di Moggio', 'Moggio', 'LC', 'Lombardia', 492, '00621050137', 'Piazza Fontana, 2', '23817', 'comune.moggio.lc@halleycert.it', 'info@comune.moggio.lc.it', '0341996114', 'www.comune.moggio.lc.it', 'UF05N9'),
  ('Comune di Molteno', 'Molteno', 'LC', 'Lombardia', 3528, '00506390137', 'Via San Giorgio 1', '23847', 'comunemolteno@halleypec.it', 'PROTOCOLLO@COMUNE.MOLTENO.LC.IT', '0313573811', 'www.comune.molteno.lc.it', 'UFNEU9'),
  ('Comune di Monte Marenzo', 'Monte Marenzo', 'LC', 'Lombardia', 1775, '82003070164', 'Piazza Municipale, 5', '23804', 'comune.montemarenzo@pec.regione.lombardia.it', 'uff_ragioneria@comune.monte-marenzo.lc.it', '0341602211', 'www.comune.monte-marenzo.lc.it', 'UFSPI2'),
  ('Comune di Montevecchia', 'Montevecchia', 'LC', 'Lombardia', 2680, '85001450130', 'Via Donzelli, 9', '23874', 'comune.montevecchia.lc@legalmail.it', 'protocollo@comune.montevecchia.lc.it', '0399930060', 'www.comune.montevecchia.lc.it', null),
  ('Comune di Monticello Brianza', 'Monticello Brianza', 'LC', 'Lombardia', 4184, '85001990135', 'Via G. Sirtori, 14', '23876', 'comune.monticellobrianza@pec.regione.lombardia.it', 'protocollo@comune.monticellobrianza.lc.it', '0399231625', 'www.comune.monticellobrianza.lc.it', 'UFFHXW'),
  ('Comune di Morterone', 'Morterone', 'LC', 'Lombardia', 30, '00548190131', 'Piazza Chiesa, 1', '23811', 'comune.morterone@pec.regione.lombardia.it', 'comunedimorterone@comune.morterone.lc.it', '0341531191', 'www.comune.morterone.lc.it', 'UF1SEM'),
  ('Comune di Nibionno', 'Nibionno', 'LC', 'Lombardia', 3588, '82002070132', 'Piazza Caduti, 2', '23895', 'anagrafe@pec.comune.nibionno.lc.it', null, '031690626', 'www.comune.nibionno.lc.it', 'UFN2PJ'),
  ('Comune di Oggiono', 'Oggiono', 'LC', 'Lombardia', 9218, '00566690137', 'Piazza Garibaldi 14', '23848', 'protocollo@pec.comune.oggiono.lc.it', null, '0341266411', 'www.comune.oggiono.lc.it', 'UFWGXT'),
  ('Comune di Olgiate Molgora', 'Olgiate Molgora', 'LC', 'Lombardia', 6414, '85001390138', 'Via Stazione, 20', '23887', 'comune.olgiatemolgora@pec.regione.lombardia.it', 'protocollo@comune.olgiatemolgora.lc.it', null, 'www.comune.olgiatemolgora.lc.it', 'UFSF31'),
  ('Comune di Olginate', 'Olginate', 'LC', 'Lombardia', 6925, '00634350136', 'Piazza Volontari del Sangue n. 1', '23854', 'comune.olginate@pec.regione.lombardia.it', null, '0341655600', 'www.comune.olginate.lc.it', 'UFETOT'),
  ('Comune di Oliveto Lario', 'Oliveto Lario', 'LC', 'Lombardia', 1148, '83006990135', 'Via Paolo Carcano, 4', '23865', 'comune.olivetolario@pec.regione.lombardia.it', null, '031969778', 'www.comune.olivetolario.lc.it', 'UFM7XR'),
  ('Comune di Osnago', 'Osnago', 'LC', 'Lombardia', 4831, '00556800134', 'Viale delle Rimembranze, 3', '23875', 'comune.osnago@legalmail.it', 'comune@comune.osnago.lc.it', '039952991', 'https://www.comune.osnago.lc.it/it', 'UF2I7G'),
  ('Comune di Paderno d''Adda', 'Paderno d''Adda', 'LC', 'Lombardia', 3891, '85000710138', 'Piazza Vittoria, 8', '23877', 'paderno.dadda@legalmail.it', 'tecnico@comune.padernodadda.lc.it', '039513615', 'www.comune.padernodadda.lc.it', 'UF00PQ'),
  ('Comune di Pagnona', 'Pagnona', 'LC', 'Lombardia', 309, '00657520136', 'Via Nuova 2', '23833', 'comunepagnona@halleypec.it', 'info@comune.pagnona.lc.it', '0341890420', 'www.comune.pagnona.lc.it', 'UF94UC'),
  ('Comune di Parlasco', 'Parlasco', 'LC', 'Lombardia', 135, '00598500130', 'Via Vittorio Emanuele II, 12', '23837', 'pec.comune.parlasco@pec.regione.lombardia.it', 'info@comune.parlasco.lc.it', '0341880202', 'www.comune.parlasco.lc.it', 'UFMMDU'),
  ('Comune di Pasturo', 'Pasturo', 'LC', 'Lombardia', 1959, '83006950139', 'Piazza Vittorio Veneto, 13', '23818', 'comune.pasturo@pec.regione.lombardia.it', 'info@comune.pasturo.lc.it', '0341919705', 'www.comune.pasturo.lc.it', 'UFV3N1'),
  ('Comune di Perledo', 'Perledo', 'LC', 'Lombardia', 830, '83005870130', 'Via Della Pace,10', '23828', 'comune.perledo@pec.regione.lombardia.it', 'info@comune.perledo.lc.it', '0341815187', 'www.comune.perledo.lc.it', 'UFAT0Z'),
  ('Comune di Pescate', 'Pescate', 'LC', 'Lombardia', 2134, '00689500130', 'Via Giovanni XXIII, 8', '23855', 'comunedipescate@pec.it', 'info@comune.pescate.lc.it', '0341365169', 'www.comune.pescate.lc.it', 'UF7EN2'),
  ('Comune di Premana', 'Premana', 'LC', 'Lombardia', 2150, '00622450138', 'Via Vittorio Emanuele, 15', '23834', 'comune.premana@halleypec.it', 'info@comune.premana.lc.it', '0341890127', 'www.comune.premana.lc.it', 'UF0AH7'),
  ('Comune di Primaluna', 'Primaluna', 'LC', 'Lombardia', 2274, '00617330139', 'Via Roma, 2', '23819', 'comune.primaluna@pec.regione.lombardia.it', null, '0341980253', 'www.comune.primaluna.lc.it', 'UFKEAE'),
  ('Comune di Robbiate', 'Robbiate', 'LC', 'Lombardia', 6441, '85001650135', 'Piazza Della Repubblica,2', '23899', 'protocollo@pec.comune.robbiate.lc.it', 'finanziario@comune.robbiate.lc.it', '0395168621', 'www.comune.robbiate.lc.it', null),
  ('Comune di Rogeno', 'Rogeno', 'LC', 'Lombardia', 3050, '00706280138', 'Piazza Martiri Della Liberta 3', '23849', 'comune.rogeno@pec.regione.lombardia.it', 'info@comune.rogeno.lc.it', null, 'www.comune.rogeno.lc.it', 'UF4QJ4'),
  ('Comune di Santa Maria Hoè', 'Santa Maria Hoè', 'LC', 'Lombardia', 2079, '85001330134', 'Piazza Padre Fausto Tentorio n.2', '23889', 'comunesantamariahoe@legalmail.it', 'protocollo@comune.santamariahoe.lc.it', '039578612', 'www.comune.santamariahoe.lc.it/', 'UFS2RF'),
  ('Comune di Sirone', 'Sirone', 'LC', 'Lombardia', 2333, '83003420136', 'Via Molteni, 35', '23844', 'sirone@legalmail.it', 'info@comune.sirone.lc.it', '031850174', 'www.comune.sirone.lc.it', 'UFSYM9'),
  ('Comune di Sirtori', 'Sirtori', 'LC', 'Lombardia', 2790, '00570830133', 'Piazza Don Arnoldo Brioschi, 14', '23896', 'comune.sirtori@pec.regione.lombardia.it', 'segreteria@comune.sirtori.lc.it', '0399215011', 'www.comune.sirtori.lc.it', 'UF4T1U'),
  ('Comune di Sueglio', 'Sueglio', 'LC', 'Lombardia', 157, '83003580137', 'Via Ai Monti, 2', '23835', 'comune.sueglio@pec.regione.lombardia.it', null, '0341808025', 'www.comune.sueglio.lc.it', 'UFDEK8'),
  ('Comune di Suello', 'Suello', 'LC', 'Lombardia', 1704, '83003460132', 'Via Roma N. 14', '23867', 'comune.suello@pec.regione.lombardia.it', null, '031655715', 'www.comune.suello.lc.it', 'UFG8RJ'),
  ('Comune di Taceno', 'Taceno', 'LC', 'Lombardia', 595, '00568130132', 'Via Roma 4', '23837', 'comune.taceno@pec.regione.lombardia.it', 'ragioneria@comune.taceno.lc.it', '0341880112', 'http://www.comune.taceno.lc.it/', 'UF8T3S'),
  ('Comune di Valgreghentino', 'Valgreghentino', 'LC', 'Lombardia', 3357, '83004340135', 'Piazza Roma, 2', '23857', 'comune.valgreghentino@pec.regione.lombardia.it', 'ragioneria@comune.valgreghentino.lc.it', null, 'www.comune.valgreghentino.lc.it', 'UFG7II'),
  ('Comune di Valmadrera', 'Valmadrera', 'LC', 'Lombardia', 11233, '00609660139', 'Via Roma, 31', '23868', 'info@pec.comune.valmadrera.lc.it', 'protocollo@comune.valmadrera.lc.it', '0341205111', 'www.comune.valmadrera.lc.it', 'UFONI7'),
  ('Comune di Valvarrone', 'Valvarrone', 'LC', 'Lombardia', 499, '03748850132', 'Via Roma 6 Localita'' Introzzo', '23836', 'comune.valvarrone@pec.regione.lombardia.it', null, '0341875040', 'www.comune.valvarrone.lc.it', null),
  ('Comune di Varenna', 'Varenna', 'LC', 'Lombardia', 646, '83003560139', 'Piazza Venini 2', '23829', 'varenna@comune.varenna.legalmailpa.it', null, '0341830119', 'www.comune.varenna.lc.it', 'UFGOVG'),
  ('Comune di Vercurago', 'Vercurago', 'LC', 'Lombardia', 2671, '00291340164', 'Via Roma 61', '23808', 'comune.vercurago@legalmail.it', null, '0341420525', 'www.comune.vercurago.lc.it', 'UF8I4W'),
  ('Comune di Verderio', 'Verderio', 'LC', 'Lombardia', 5516, '03504880133', 'Viale Dei Municipi N. 2', '23879', 'infoverderio@halleypec.it', 'info@comune.verderio.lc.it', '039590591', 'www.comune.verderio.lc.it', null),
  ('Comune di Viganò', 'Viganò', 'LC', 'Lombardia', 2108, '00685790131', 'Via Risorgimento, 24', '23897', 'comune.vigano@pec.regione.lombardia.it', 'segreteria@comune.vigano.lc.it', '039921391', 'www.comune.vigano.lc.it', 'UF0344');

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

-- Controllo: LC = 84 comuni / 334.211 ab.
select provincia, count(*) as comuni, sum(abitanti) as abitanti,
       count(pec) as con_pec, count(email) as con_email, count(phone) as con_telefono
from companies
where tipo = 'pa' and name ilike 'Comune di %' and provincia = 'LC'
group by provincia;

