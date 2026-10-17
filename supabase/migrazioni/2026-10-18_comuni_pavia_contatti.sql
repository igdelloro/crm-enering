-- =====================================================================
--  CRM ENER.ING — Comuni della provincia di Pavia con abitanti e contatti
--  Esegui nel SQL Editor di Supabase. Sicuro e ri-eseguibile (non cancella nulla):
--   * aggiunge ai clienti le colonne "abitanti" ed "email" (se mancano);
--   * inserisce i 184 Comuni della provincia di Pavia come clienti PA;
--   * per i Comuni già presenti aggiorna gli abitanti e COMPLETA solo i campi
--     vuoti (non sovrascrive quello che avete già scritto a mano).
--  Se Supabase mostra l'avviso "Potential issues detected", scegli
--  "Run without RLS": riguarda solo la tabella d'appoggio temporanea _comuni.
--  Nota: la somma degli abitanti dei 184 comuni (545.901) differisce di 122
--  dal totale provinciale indicato da tuttitalia (546.023); i valori dei
--  singoli comuni sono stati letti due volte da pagine diverse e coincidono.
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
  ('Comune di Alagna', 'Alagna', 'PV', 'Lombardia', 810, '00473750180', 'Via Piave, 12', '27020', 'info@pec.comune.alagna.pv.it', 'protocollo@comune.alagna.pv.it', '0382818105', 'www.comune.alagna.pv.it', 'UFRV3V'),
  ('Comune di Albonese', 'Albonese', 'PV', 'Lombardia', 561, '83000470183', 'Via Negrone Manara, 21', '27020', 'comune.albonese@legalmail.it', 'info@comune.albonese.pv.it', '038452012', 'www.comune.albonese.pv.it', 'UFRFUJ'),
  ('Comune di Albuzzano', 'Albuzzano', 'PV', 'Lombardia', 3667, '00467340188', 'Piazza Venco N. 1', '27010', 'comune.albuzzano@pec.regione.lombardia.it', null, '0382584026', 'www.comune.albuzzano.pv.it', 'UFJXD8'),
  ('Comune di Arena Po', 'Arena Po', 'PV', 'Lombardia', 1530, '84000500185', 'Piazza Vittorio Emanuele N.14', '27040', 'arenapo@postemailcertificata.it', 'segreteria@comunearenapo.it', '0385270005', 'www.comune.arenapo.pv.it', 'UF8R57'),
  ('Comune di Badia Pavese', 'Badia Pavese', 'PV', 'Lombardia', 408, '81001830181', 'Via Roma, N.24', '27010', 'protocollo.comune.badiapavese@pec.regione.lombardia.it', 'protocollo@comune.badiapavese.pv.it', '038278091', 'www.comune.badiapavese.pv.it', 'UF6DEC'),
  ('Comune di Bagnaria', 'Bagnaria', 'PV', 'Lombardia', 622, '86003510186', 'Via IV Novembre 6', '27050', 'comune.bagnaria@legalpec.it', 'info@comune.bagnaria.pv.it', '0383572001', 'www.comune.bagnaria.pv.it', 'UFHML9'),
  ('Comune di Barbianello', 'Barbianello', 'PV', 'Lombardia', 888, '84000410187', 'Via Roma, 5', '27041', 'comune@pec.comune.barbianello.pv.it', 'protocollo@comune.barbianello.pv.it', '038557510', 'www.comune.barbianello.pv.it', 'UFO7HM'),
  ('Comune di Bascapè', 'Bascapè', 'PV', 'Lombardia', 1825, '00414580183', 'Piazza Della Repubblica 2', '27010', 'comune.bascape@pec.regione.lombardia.it', 'info@comune.bascape.pv.it', null, 'www.comune.bascape.pv.it', 'UFI377'),
  ('Comune di Bastida Pancarana', 'Bastida Pancarana', 'PV', 'Lombardia', 921, '86001910180', 'Piazza Del Municipio 1', '27050', 'protocollo.bastidapancarana@legalpec.it', 'info@comune.bastidapancarana.pv.it', '038385002', 'www.comune.bastidapancarana.pv.it', 'UF4EX0'),
  ('Comune di Battuda', 'Battuda', 'PV', 'Lombardia', 635, '00520510181', 'Via Marcignago, 5', '27020', 'battuda@pec.comune.battuda.pv.it', null, null, 'www.comune.battuda.pv.it', 'UFOEU3'),
  ('Comune di Belgioioso', 'Belgioioso', 'PV', 'Lombardia', 6439, '00397220187', 'Via Garibaldi, 64', '27011', 'comune.belgioioso@pec.regione.lombardia.it', 'info@comune.belgioioso.pv.it', null, 'www.comune.belgioioso.pv.it', 'UFVUFW'),
  ('Comune di Bereguardo', 'Bereguardo', 'PV', 'Lombardia', 2856, '00471320184', 'Via Castello, 2', '27021', 'comune.bereguardo@pec.regione.lombardia.it', 'protocollo@comune.bereguardo.pv.it', null, 'www.comune.bereguardo.pv.it', 'UF15XM'),
  ('Comune di Borgarello', 'Borgarello', 'PV', 'Lombardia', 2829, '00460880180', 'Via Principale 2', '27010', 'comune.borgarello@pec.regione.lombardia.it', null, null, 'www.comune.borgarello.pv.it', 'UFZEW7'),
  ('Comune di Borgo Priolo', 'Borgo Priolo', 'PV', 'Lombardia', 1213, '00468890181', 'Piazza F. Cribellati, 2', '27040', 'comune.borgopriolo@legalpec.it', null, '0383872214', 'www.comune.borgopriolo.pv.it', 'UFW6Z3'),
  ('Comune di Borgo San Siro', 'Borgo San Siro', 'PV', 'Lombardia', 961, '85001770180', 'Via Roma 30', '27020', 'protocollo@pec.comune.borgosansiro.pv.it', 'info@comune.borgosansiro.pv.it', '0382874091', 'www.comune.borgosansiro.pv.it', 'UFLCRZ'),
  ('Comune di Borgoratto Mormorolo', 'Borgoratto Mormorolo', 'PV', 'Lombardia', 387, '86003230181', 'Piazza Liberta'' 8', '27040', 'comune.borgorattomormorolo@pec.regione.lombardia.it', 'ragioneria@comune.borgoratto-mormorolo.pv.it', '0383875221', 'www.comune.borgoratto-mormorolo.pv.it', 'UF1IJL'),
  ('Comune di Bornasco', 'Bornasco', 'PV', 'Lombardia', 2656, '00520620188', 'Via Trento N. 4', '27010', 'comune.bornasco@legalpec.it', 'urp@comune.bornasco.pv.it', '0382955013', 'www.comune.bornasco.pv.it', 'UFUHZE'),
  ('Comune di Bosnasco', 'Bosnasco', 'PV', 'Lombardia', 624, '84000700181', 'Via Groppallo N. 19', '27040', 'comune.bosnasco@pec.regione.lombardia.it', 'info@comune.bosnasco.pv.it', '0385272075', 'www.comune.bosnasco.pv.it', 'UFDME1'),
  ('Comune di Brallo di Pregola', 'Brallo di Pregola', 'PV', 'Lombardia', 473, '86003490181', 'Piazza Municipio 4', '27050', 'comune.brallodipregola@legalpec.it', 'info@comune.brallodipregola.pv.it', null, 'www.comune.brallodipregola.pv.it', 'UFNZXD'),
  ('Comune di Breme', 'Breme', 'PV', 'Lombardia', 725, '00473260180', 'Via Abazia San Pietro 17', '27020', 'comune.breme@pec.regione.lombardia.it', null, '038477001', 'www.comunebreme.it', 'UFMK93'),
  ('Comune di Bressana Bottarone', 'Bressana Bottarone', 'PV', 'Lombardia', 3482, '00447770181', 'Piazza Marconi N. 18', '27042', 'comune.bressanabottarone@legalpec.it', 'info@comune.bressanabottarone.pv.it', null, 'www.comune.bressanabottarone.pv.it', 'UFGJOP'),
  ('Comune di Broni', 'Broni', 'PV', 'Lombardia', 10164, '84000230189', 'P.za Garibaldi 12', '27043', 'comunebroni@pec.it', 'info@comune.broni.pv.it', '0385257011', 'www.comune.broni.pv.it', 'UF4ZVW'),
  ('Comune di Calvignano', 'Calvignano', 'PV', 'Lombardia', 112, '01863030183', 'Via Roma, 1', '27040', 'comune.calvignano@legalpec.it', null, '0383871120', 'www.comune.calvignano.pv.it', 'UFZ1SE'),
  ('Comune di Campospinoso Albaredo', 'Campospinoso Albaredo', 'PV', 'Lombardia', 1333, '84000470181', 'Via GIOVANNI FALCONE 10', '27040', 'comune.campospinoso@pec.regione.lombardia.it', 'info@comune.campospinoso.pv.it', '0385277978', 'www.comune.campospinoso.pv.it', 'UFHJSO'),
  ('Comune di Candia Lomellina', 'Candia Lomellina', 'PV', 'Lombardia', 1562, '83000530184', 'Piazza San Carlo, 13', '27031', 'comune.candialomellina@pec.regione.lombardia.it', 'info@comune.candialomellina.pv.it', '038474003', 'www.comune.candialomellina.pv.it', 'UF32QK'),
  ('Comune di Canneto Pavese', 'Canneto Pavese', 'PV', 'Lombardia', 1285, '84000510184', 'Via Casabassa 7', '27044', 'comune.cannetopavese@legalpec.it', 'ragioneria@comune.cannetopavese.pv.it', '038588021', 'WWW.COMUNE.CANNETOPAVESE.PV.IT', 'UFXBA7'),
  ('Comune di Carbonara al Ticino', 'Carbonara al Ticino', 'PV', 'Lombardia', 1418, '00523930188', 'Via Roma 16', '27020', 'comune.carbonara-alticino@pec.regione.lombardia.it', 'info@comune.carbonaraalticino.pv.it', '0382400037', 'www.comune.carbonaraalticino.pv.it', 'UFTZQP'),
  ('Comune di Casanova Lonati', 'Casanova Lonati', 'PV', 'Lombardia', 452, '84000550180', 'Piazza Ten. Edoardo Alberti, 1', '27041', 'comune.casanovalonati@pec.regione.lombardia.it', 'info@comune.casanovalonati.pv.it', '038557108', 'www.comune.casanovalonati.pv.it', 'UFQXFD'),
  ('Comune di Casatisma', 'Casatisma', 'PV', 'Lombardia', 855, '00473900181', 'Viale Liberta, 10', '27040', 'servizio.segreteria@comunecasatisma.legalmail.it', 'info@comune.casatisma.pv.it', '038384218', 'www.comune.casatisma.pv.it', 'UF0WNH'),
  ('Comune di Casei Gerola', 'Casei Gerola', 'PV', 'Lombardia', 2307, '00483730180', 'Piazza Meardi, 3', '27050', 'comune.caseigerola@legalmail.it', null, '038361301', 'www.comune.caseigerola.pv.it', 'UF66F8'),
  ('Comune di Casorate Primo', 'Casorate Primo', 'PV', 'Lombardia', 9190, '00468580188', 'Via Dall''Orto 15', '27022', 'casorateprimo@postemailcertificata.it', null, '0290519511', 'www.comune.casorateprimo.pv.it', 'UFNL0B'),
  ('Comune di Cassolnovo', 'Cassolnovo', 'PV', 'Lombardia', 6747, '85001790188', 'Piazza Vittorio Veneto 1', '27023', 'comune.cassolnovo@pec.regione.lombardia.it', null, '0381928769', 'www.comune.cassolnovo.pv.it', 'UFVGG9'),
  ('Comune di Castana', 'Castana', 'PV', 'Lombardia', 707, '00483000188', 'Via Roma 42', '27040', 'comune.castana@legalpec.it', 'amministrativo@comune.castana.pv.it', '038582006', 'www.comune.castana.pv.it', 'UFNTLQ'),
  ('Comune di Casteggio', 'Casteggio', 'PV', 'Lombardia', 6363, '00451040182', 'Via Castello, 24', '27045', 'protocollo@pec.comune.casteggio.pv.it', 'info@comune.casteggio.pv.it', '038380781', 'www.comune.casteggio.pv.it', 'UF9E2K'),
  ('Comune di Castelletto di Branduzzo', 'Castelletto di Branduzzo', 'PV', 'Lombardia', 1056, '00485410187', 'Piazza Del Municipio, 5', '27040', 'info@pec.comune.castellettodibranduzzo.pv.it', 'info@comune.castellettodibranduzzo.pv.it', '0383895627', 'www.comune.castellettodibranduzzo.pv.it', 'UFD6AC'),
  ('Comune di Castello d''Agogna', 'Castello d''Agogna', 'PV', 'Lombardia', 1079, '83000570180', 'Piazza Vittorio Emanuele II N. 22', '27030', 'comune.castellodagogna@pec.regione.lombardia.it', null, null, 'www.comune.castellodagogna.pv.it', 'UFMT7Q'),
  ('Comune di Castelnovetto', 'Castelnovetto', 'PV', 'Lombardia', 546, '83000590188', 'Via Roma n.14', '27030', 'comune.castelnovetto@pec.regione.lombardia.it', 'info@comune.castelnovetto.pv.it', '0384673404', 'www.comune.castelnovetto.pv.it', 'UFCYGQ'),
  ('Comune di Cava Manara', 'Cava Manara', 'PV', 'Lombardia', 6684, '00467120184', 'Via Luciano Manara 7', '27051', 'protocollo@cert.comune.cavamanara.pv.it', 'info@comune.cavamanara.pv.it', '0382557511', 'www.comune.cavamanara.pv.it', '9HHI1H'),
  ('Comune di Cecima', 'Cecima', 'PV', 'Lombardia', 254, '86003530184', 'Via Ca'' D''Anna, 2', '27050', 'comune.cecima@legalpec.it', 'info@comune.cecima.pv.it', '038359144', 'www.comune.cecima.pv.it/', 'UF5HXV'),
  ('Comune di Ceranova', 'Ceranova', 'PV', 'Lombardia', 2363, '00487250185', 'Piazza Del Municipio,1', '27010', 'info@pec.comune.ceranova.pv.it', 'info@comune.ceranova.pv.it', '0382954710', 'www.comune.ceranova.pv.it', 'UFHNJ6'),
  ('Comune di Ceretto Lomellina', 'Ceretto Lomellina', 'PV', 'Lombardia', 188, '83000610184', 'Via Dell''Agogna, 1', '27030', 'cerettolomellina@pcert.it', 'info@comune.cerettolomellina.pv.it', '038456029', 'www.comune.cerettolomellina.pv.it', 'UFOELU'),
  ('Comune di Cergnago', 'Cergnago', 'PV', 'Lombardia', 648, '83000690186', 'Via Roma, 8', '27020', 'comune.cergnago@pec.regione.lombardia.it', null, '038443429', 'www.comune.cergnago.pv.it', 'UFR95J'),
  ('Comune di Certosa di Pavia', 'Certosa di Pavia', 'PV', 'Lombardia', 5623, '80000850182', 'Via Togliatti 12', '27012', 'comune.certosadipavia@pec.it', 'segreteria@comunecertosadipavia.it', '0382936924', 'www.comunecertosadipavia.it', 'B5SQJM'),
  ('Comune di Cervesina', 'Cervesina', 'PV', 'Lombardia', 1103, '00333900181', 'Piazza Caduti Per La Patria 1', '27050', 'ragioneria.cervesina@pec.it', 'protocollo@comune.cervesina.pv.it', '0383375156', 'www.comune.cervesina.pv.it', 'UFLZEX'),
  ('Comune di Chignolo Po', 'Chignolo Po', 'PV', 'Lombardia', 4048, '00439130188', 'Via Marconi, 8', '27013', 'comune.chignolopo@pec.regione.lombardia.it', 'ragioneria@comune.chignolopo.pv.it', '038276001', 'www.comune.chignolopo.pv.it', 'UF4Q77'),
  ('Comune di Cigognola', 'Cigognola', 'PV', 'Lombardia', 1308, '84000590186', 'P.zza Castello 7', '27040', 'ragioneria.cigognola@anutelpec.it', 'servizifinanziari@comune.cigognola.pv.it', '0385780218', 'www.comune.cigognola.pv.it', 'UFJS7M'),
  ('Comune di Cilavegna', 'Cilavegna', 'PV', 'Lombardia', 5438, '00470780180', 'Largo Guglielmo Marconi, 3 -', '27024', 'comune.cilavegna.pv@legalmail.it', 'info@comune.cilavegna.pv.it', '0381668011', 'www.comune.cilavegna.pv.it', 'UF6T33'),
  ('Comune di Codevilla', 'Codevilla', 'PV', 'Lombardia', 915, '00409680188', 'Via Umberto, 15', '27050', 'comune.codevilla@legalpec.it', 'info@comune.codevilla.pv.it', '0383373017', 'www.comune.codevilla.pv.it', 'UF787S'),
  ('Comune di Colli Verdi', 'Colli Verdi', 'PV', 'Lombardia', 968, '02738210182', 'Localita'' Pometo, Piazza Municipio, Frazione Ruino N. 1', '27061', 'comune.colliverdi@legalpec.it', null, '0385955898', 'www.comune.colliverdi.pv.it', 'UFB5IC'),
  ('Comune di Confienza', 'Confienza', 'PV', 'Lombardia', 1546, '83000950184', 'Corso V. Emanuele, 24', '27030', 'confienza@postemailcertificata.it', 'municipio@comune.confienza.pv.it', '038464032', 'www.comune.confienza.pv.it', 'UFXJMM'),
  ('Comune di Copiano', 'Copiano', 'PV', 'Lombardia', 1784, '00475470183', 'Piazza Municipio, 1', '27010', 'comune.copiano@pec.regione.lombardia.it', 'ufficioragioneria@comune.copiano.pv.it', null, 'www.comune.copiano.pv.it', 'UFNIKK'),
  ('Comune di Corana', 'Corana', 'PV', 'Lombardia', 745, '86003410189', 'Piazza Vittorio Emanuele II, 3', '27050', 'comune.corana@legalpec.it', 'info@comune.corana.pv.it', '038378100', 'www.comune.corana.pv.it', 'UFLM47'),
  ('Comune di Cornale e Bastida', 'Cornale e Bastida', 'PV', 'Lombardia', 785, '02532270184', 'Via Roma, 23', '27056', 'info@pec.comune.cornalebastida.pv.it', 'info@comune.cornalebastida.pv.it', '038360103', 'www.comune.cornalebastida.pv.it', 'UF2QJ5'),
  ('Comune di Corteolona e Genzone', 'Corteolona e Genzone', 'PV', 'Lombardia', 2572, '02616370181', 'Via Garibaldi, 8', '27014', 'amministrazione@pec.comune.corteolonaegenzone.pv.it', null, null, 'www.comune.corteolonaegenzone.pv.it', 'UFTFA3'),
  ('Comune di Corvino San Quirico', 'Corvino San Quirico', 'PV', 'Lombardia', 960, '00460370182', 'Via Roma 1', '27050', 'comune.corvinosanquirico@pec.regione.lombardia.it', 'segreteria@comune.corvino-san-quirico.pv.it', '0383876121', 'www.comune.corvino-san-quirico.pv.it', 'UFK1OH'),
  ('Comune di Costa de'' Nobili', 'Costa de'' Nobili', 'PV', 'Lombardia', 358, '00475640181', 'Via Castello, 16', '27010', 'comune.costadenobili@pec.regione.lombardia.it', 'segreteria@comune.costadenobili.pv.it', '038270732', 'www.comune.costadenobili.pv.it', 'UFAT17'),
  ('Comune di Cozzo', 'Cozzo', 'PV', 'Lombardia', 358, '83000990180', 'Via Roma, 65', '27030', 'comune.cozzo@pec.regione.lombardia.it', 'comunedicozzo@libero.it', '038474102', 'www.comune.cozzo.pv.it', 'UFR1X8'),
  ('Comune di Cura Carpignano', 'Cura Carpignano', 'PV', 'Lombardia', 5080, '00489010181', 'Via Roma, 42', '27010', 'comune@pec.comune.curacarpignano.pv.it', 'info@comune.curacarpignano.pv.it', '0382488021', 'www.comune.curacarpignano.pv.it', 'UFG66L'),
  ('Comune di Dorno', 'Dorno', 'PV', 'Lombardia', 4608, '00473740181', 'Piazza Giuseppe Bonacossa, 3', '27020', 'comune.dorno@pec.regione.lombardia.it', 'info@comune.dorno.pv.it', '038284003', 'www.comune.dorno.pv.it', 'UF4RDA'),
  ('Comune di Ferrera Erbognone', 'Ferrera Erbognone', 'PV', 'Lombardia', 1112, '00244220182', 'Piazza Bartellini 18', '27032', 'comune.ferrera@pec.regione.lombardia.it', 'ragioneria@comune.ferreraerbognone.pv.it', '0382998012', 'www.comune.ferreraerbognone.pv.it', 'UFEEML'),
  ('Comune di Filighera', 'Filighera', 'PV', 'Lombardia', 812, '00339070187', 'Via Marconi, 29A', '27010', 'comune.filighera@pec.regione.lombardia.it', 'ragioneria@comune.filighera.pv.it', null, 'www.comune.filighera.pv.it', 'UFN1LQ'),
  ('Comune di Fortunago', 'Fortunago', 'PV', 'Lombardia', 367, '86003270187', 'P.zza Aldo Moro N.1', '27040', 'comune.fortunago@legalpec.it', null, '0383875213', 'www.comune.fortunago.pv.it', 'UF2F4T'),
  ('Comune di Frascarolo', 'Frascarolo', 'PV', 'Lombardia', 1075, '82001030186', 'Piazza Grande, 1', '27030', 'anagrafe@pec.comune.frascarolo.pv.it', 'demografici@comune.frascarolo.pv.it', '0384849053', 'www.comune.frascarolo.pv.it', 'UF5I2M'),
  ('Comune di Galliavola', 'Galliavola', 'PV', 'Lombardia', 171, '00485480180', 'Piazza Vittoria, 1', '27034', 'comune.galliavola@pec.it', 'info@comune.galliavola.pv.it', '038485083', 'www.comune.galliavola.pv.it', 'UFFL8E'),
  ('Comune di Gambarana', 'Gambarana', 'PV', 'Lombardia', 174, '00490860186', 'Via Marchese Alfonso Corti 2', '27030', 'comune.gambarana@legalpec.it', 'info@comune.gambarana.pv.it', '038489023', 'www.comune.gambarana.pv.it', 'UF0USQ'),
  ('Comune di Gambolò', 'Gambolò', 'PV', 'Lombardia', 9813, '85001890186', 'Piazza Cavour, 3', '27025', 'comune.gambolo@pec.regione.lombardia.it', null, '0381937211', 'www.comune.gambolo.pv.it', 'UF5IHB'),
  ('Comune di Garlasco', 'Garlasco', 'PV', 'Lombardia', 9665, '85001810184', 'Piazza Repubblica, 11', '27026', 'protocollo@pec.comune.garlasco.pv.it', 'protocollo@comune.garlasco.pv.it', null, 'www.comune.garlasco.pv.it', 'UF8WCA'),
  ('Comune di Gerenzago', 'Gerenzago', 'PV', 'Lombardia', 1503, '00493730188', 'Via XXV Aprile, 17', '27010', 'comune.gerenzago@pec.regione.lombardia.it', null, '0382967051', 'www.comunegerenzago.it', 'UFU6JN'),
  ('Comune di Giussago', 'Giussago', 'PV', 'Lombardia', 5385, '00460900186', 'Via Roma, 70', '27010', 'comune.giussago@pec.regione.lombardia.it', 'segreteria@comune.giussago.pv.it', '0382939611', 'www.comune.giussago.pv.it', 'UFCZAX'),
  ('Comune di Godiasco Salice Terme', 'Godiasco Salice Terme', 'PV', 'Lombardia', 3294, '00485780183', 'Piazza Alesina N.2', '27052', 'protocollo.godiasco@pec.it', 'info@comune.godiascosaliceterme.pv.it', '0383941420', 'www.comune.godiascosaliceterme.pv.it', 'UFVU3F'),
  ('Comune di Golferenzo', 'Golferenzo', 'PV', 'Lombardia', 162, '84000630180', 'Via Roma 2', '27047', 'protocollo@pec.comune.golferenzo.pv.it', 'protocollo@comune.golferenzo.pv.it', '038599904', 'www.comune.golferenzo.pv.it', 'UFYT3R'),
  ('Comune di Gravellona Lomellina', 'Gravellona Lomellina', 'PV', 'Lombardia', 2696, '85001830182', 'Piazza Delucca, 49', '27020', 'comunegravellonalomellina@pec.it', 'protocollo@comune.gravellonalomellina.pv.it', null, 'www.comune.gravellonalomellina.pv.it', 'UFT0BT'),
  ('Comune di Gropello Cairoli', 'Gropello Cairoli', 'PV', 'Lombardia', 4362, '00464180181', 'Via Liberta'', 47', '27027', 'gropellocairoli@pec.comune.gropellocairoli.pv.it', 'info@comune.gropellocairoli.pv.it', null, 'www.comune.gropellocairoli.pv.it', 'UFEORR'),
  ('Comune di Inverno e Monteleone', 'Inverno e Monteleone', 'PV', 'Lombardia', 1493, '00484170188', 'Piazzale Cavalieri Di Malta 5', '27010', 'info@pec.comune.invernoemonteleone.pv.it', 'info@comune.invernoemonteleone.pv.it', '038273023', 'www.comune.invernoemonteleone.pv.it', 'UFFE3C'),
  ('Comune di Landriano', 'Landriano', 'PV', 'Lombardia', 6551, '00414560185', 'Piazza Garibaldi, 14', '27015', 'info@pec.comune.landriano.pv.it', 'ufficio.tecnico@comune.landriano.pv.it', '038264001', 'www.comune.landriano.pv.it', 'UFQ58A'),
  ('Comune di Langosco', 'Langosco', 'PV', 'Lombardia', 365, '00470400185', 'Via G. Mazzini N.61', '27030', 'comune.langosco@pec.regione.lombardia.it', 'ragioneria.langosco@libero.it', '038478021', 'www.comune.langosco.pv.it', 'UFNR8W'),
  ('Comune di Lardirago', 'Lardirago', 'PV', 'Lombardia', 1163, '00493570188', 'Via V. Emanuele II, 5', '27016', 'info@pec.comune.lardirago.pv.it', 'ragioneria@comune.lardirago.pv.it', '3516943086', 'www.comune.lardirago.pv.it', 'UFWRGR'),
  ('Comune di Linarolo', 'Linarolo', 'PV', 'Lombardia', 2797, '00270350184', 'Piazza Dante,4', '27010', 'comune.linarolo@pec.regione.lombardia.it', 'ufficio.ragioneria@comune.linarolo.pv.it', '0382569110', 'www.comune.linarolo.pv.it', 'UF59AN'),
  ('Comune di Lomello', 'Lomello', 'PV', 'Lombardia', 2010, '00485840185', 'Piazza Castello, 1', '27034', 'ragioneria.comune.lomello@pec.regione.lombardia.it', null, '3318098428', 'www.comune.lomello.pv.it', 'UFGHLQ'),
  ('Comune di Lungavilla', 'Lungavilla', 'PV', 'Lombardia', 2407, '00485240188', 'Piazza Cap. Albini, 3', '27053', 'comune.lungavilla@legalpec.it', null, '038376130', 'www.comune.lungavilla.pv.it', 'UFU561'),
  ('Comune di Magherno', 'Magherno', 'PV', 'Lombardia', 1798, '00476130182', 'Piazza Aldo Marenzi 7', '27010', 'comune.magherno@pec.regione.lombardia.it', 'info@comune.magherno.pv.it', '0382699613', 'www.comune.magherno.pv.it', 'UFZ1TE'),
  ('Comune di Marcignago', 'Marcignago', 'PV', 'Lombardia', 2455, '00520490186', 'Via Umberto I, 213', '27020', 'comune.marcignago@pec.regione.lombardia.it', 'ragioneria.tributi@comune.marcignago.pv.it', '0382929021', 'www.comune.marcignago.pv.it', 'UF8DMZ'),
  ('Comune di Marzano', 'Marzano', 'PV', 'Lombardia', 1804, '00474790185', 'Via Al Dosso 2', '27010', 'comune.marzano@pec.regione.lombardia.it', 'info@comune.marzano.pv.it', '0382947021', 'www.comune.marzano.pv.it', 'UFF8L9'),
  ('Comune di Mede', 'Mede', 'PV', 'Lombardia', 6102, '00453550188', 'P.za Della Repubblica, 37', '27035', 'comunedimede@pec.it', null, '0384822274', 'www.comune.mede.pv.it', 'UF0T0G'),
  ('Comune di Menconico', 'Menconico', 'PV', 'Lombardia', 326, '86002720182', 'Via Capoluogo, 21', '27050', 'anagrafe.comune.menconico@pec.regione.lombardia.it', 'protocollo@comune.menconico.pv.it', '0383574001', 'www.comune.menconico.pv.it', 'UFS2T4'),
  ('Comune di Mezzana Bigli', 'Mezzana Bigli', 'PV', 'Lombardia', 1061, '82001810181', 'Piazza Gramsci 1', '27030', 'mezzanabigli@pec.it', null, '038488016', 'www.comune.mezzanabigli.pv.it', 'UFWPHA'),
  ('Comune di Mezzana Rabattone', 'Mezzana Rabattone', 'PV', 'Lombardia', 457, '00482310182', 'Via Marconi, 21', '27030', 'info@pec.comune.mezzanarabattone.pv.it', null, '0382918862', 'www.comune.mezzanarabattone.pv.it', 'UFEYK1'),
  ('Comune di Mezzanino', 'Mezzanino', 'PV', 'Lombardia', 1405, '00471410183', 'Piazza Grignani, 2', '27040', 'comune.mezzanino@pec.regione.lombardia.it', null, '038571013', 'www.comune.mezzanino.pv.it', 'UFM5DT'),
  ('Comune di Miradolo Terme', 'Miradolo Terme', 'PV', 'Lombardia', 3909, '00390570182', 'Piazza Del Comune 2/c', '27010', 'protocollo@pec.comune.miradoloterme.pv.it', null, null, 'www.comune.miradoloterme.pv.it', 'UFZHWG'),
  ('Comune di Montalto Pavese', 'Montalto Pavese', 'PV', 'Lombardia', 804, '86003290185', 'Via G. Musetti, 6', '27040', 'comune.montaltopavese@legalpec.it', 'anagrafe@comune.montaltopavese.pv.it', '0383870230', 'www.comune.montaltopavese.pv.it', 'UFG1K3'),
  ('Comune di Montebello della Battaglia', 'Montebello della Battaglia', 'PV', 'Lombardia', 1437, '00273900183', 'Via Roma, 51', '27054', 'comune.montebellodellabattaglia@legalpec.it', 'info@comune.montebellodellabattaglia.pv.it', '038382648', 'www.comune.montebellodellabattaglia.pv.it', 'UF43RS'),
  ('Comune di Montecalvo Versiggia', 'Montecalvo Versiggia', 'PV', 'Lombardia', 478, '84000720189', 'Frazione Crocetta, 18', '27047', 'protocollo@pec.comune.montecalvo.pv.it', 'protocollo@comune.montecalvo.pv.it', null, 'www.comune.montecalvo.pv.it', 'UFP7AS'),
  ('Comune di Montescano', 'Montescano', 'PV', 'Lombardia', 439, '84000670186', 'Via Roncole 1', '27040', 'comune.montescano@legalpec.it', 'anagrafe@comune.montescano.pv.it', null, 'WWW.COMUNE.MONTESCANO.PV.IT', 'UFQGJ2'),
  ('Comune di Montesegale', 'Montesegale', 'PV', 'Lombardia', 239, '00485460182', 'Piazza Del Municipio Eroi Di Nassiriya, 1', '27052', 'comune.montesegale@pec.regione.lombardia.it', 'info@comune.montesegale.pv.it', '038399030', 'www.comune.montesegale.pv.it', 'UFJVDT'),
  ('Comune di Monticelli Pavese', 'Monticelli Pavese', 'PV', 'Lombardia', 662, '00470500182', 'Via Roma 11A', '27010', 'finanziario.comune.monticelli@pec.regione.lombardia.it', 'ANAGRAFE@COMUNE.MONTICELLIPAVESE.PV.IT', '0382722220', 'https://www.comune.monticellipavese.pv.it/', 'UF3ZZG'),
  ('Comune di Montù Beccaria', 'Montù Beccaria', 'PV', 'Lombardia', 1642, '84000690184', 'Piazza Umberto I, 10', '27040', 'protocollo.comune.montubeccaria@pec.regione.lombardia.it', 'protocollo@comune.montubeccaria.pv.it', '0385277160', 'www.comune.montubeccaria.pv.it', 'UFMMO2'),
  ('Comune di Mornico Losana', 'Mornico Losana', 'PV', 'Lombardia', 605, '00475070181', 'Piazza Liberta, 1', '27040', 'mornicolosana@postemailcertificata.it', 'ragioneria@comunemornicolosana.pv.it', '0383892523', 'www.comunemornicolosana.pv.it', 'UF3OF1'),
  ('Comune di Mortara', 'Mortara', 'PV', 'Lombardia', 15934, '00324770189', 'Piazza Martiri Della Liberta'', 21', '27036', 'comune.mortara@pec.regione.lombardia.it', 'protocollo@comune.mortara.pv.it', '0384256411', 'www.comune.mortara.pv.it', 'UF9LCL'),
  ('Comune di Nicorvo', 'Nicorvo', 'PV', 'Lombardia', 288, '83001190186', 'Via Roma N.2', '27020', 'comune.nicorvo@pec.regione.lombardia.it', 'info@comune.nicorvo.pv.it', '038452044', 'www.comune.nicorvo.pv.it', 'UFZT5K'),
  ('Comune di Olevano di Lomellina', 'Olevano di Lomellina', 'PV', 'Lombardia', 723, '83001090188', 'Piazza Della Liberta'', 7', '27020', 'comune.olevanolomellina@pec.it', null, '038451015', 'www.olevanolomellina.it', 'UFZLRW'),
  ('Comune di Oliva Gessi', 'Oliva Gessi', 'PV', 'Lombardia', 163, '00468570189', 'Via Chiesa N. 3', '27050', 'comune.olivagessi@pec.regione.lombardia.it', 'protocollo@comune.olivagessi.pv.it', '0383876325', 'www.comune.olivagessi.pv.it', 'UFGX6Z'),
  ('Comune di Ottobiano', 'Ottobiano', 'PV', 'Lombardia', 1083, '83002010185', 'Piazza Italia, 33', '27030', 'comune.ottobiano@pec.it', 'amministrazione@comune.ottobiano.pv.it', '038449581', 'www.comune.ottobiano.pv.it/', 'UF7FXF'),
  ('Comune di Palestro', 'Palestro', 'PV', 'Lombardia', 1895, '83001210182', 'P.zza Marconi, 1', '27030', 'protocollo@pec.comune.palestro.pv.it', 'protocollo@comune.palestro.pv.it', null, 'www.comune.palestro.pv.it/', 'UFUDPA'),
  ('Comune di Pancarana', 'Pancarana', 'PV', 'Lombardia', 331, '00470710187', 'Piazza Della Vittoria 11', '27050', 'protocollo.pancarana@pec.it', 'info@comune.pancarana.pv.it', '0383375222', 'www.comune.pancarana.pv.it', 'UF9BT1'),
  ('Comune di Parona', 'Parona', 'PV', 'Lombardia', 1858, '83001230180', 'Piazza Signorelli, 1', '27020', 'parona.comune.pv@pec.it', null, '0384253015', 'www.comune.parona.pv.it', 'UF8GQH'),
  ('Comune di Pavia', 'Pavia', 'PV', 'Lombardia', 71811, '00296180185', 'Piazza Municipio, 2', '27100', 'protocollo@pec.comune.pavia.it', null, '0382399277', 'www.comune.pavia.it', null),
  ('Comune di Pietra de'' Giorgi', 'Pietra de'' Giorgi', 'PV', 'Lombardia', 777, '84000710180', 'Piazza Don V. Arpesella, 2', '27040', 'comune.pietradegiorgi@pec.it', 'info@comune.pietradegiorgi.pv.it', '038585110', 'www.comune.pietradegiorgi.pv.it', 'UFRXQ3'),
  ('Comune di Pieve Albignola', 'Pieve Albignola', 'PV', 'Lombardia', 792, '00482160181', 'Via Stazione Snc', '27030', 'comune.pievealbignola@legalpec.it', 'comunepievealbignola@libero.it', '0382999037', 'www.comune.pievealbignola.pv.it', 'UFGWZ1'),
  ('Comune di Pieve del Cairo', 'Pieve del Cairo', 'PV', 'Lombardia', 1802, '00482780186', 'Piazza Paltineri, 9', '27037', 'comunepievedelcairo@pec.it', 'segreteria@comune.pievedelcairo.pv.it', '038487129', 'www.comune.pievedelcairo.pv.it', 'OAOBWN'),
  ('Comune di Pieve Porto Morone', 'Pieve Porto Morone', 'PV', 'Lombardia', 2730, '00466880184', 'Viale Caduti, 9', '27017', 'comune.pieveportomorone@pec.regione.lombardia.it', null, '038278024', 'www.comune.pieveportomorone.pv.it', 'UFOZLX'),
  ('Comune di Pinarolo Po', 'Pinarolo Po', 'PV', 'Lombardia', 1654, '84000770184', 'Piazza Martiri della Liberazione 2', '27040', 'mail@pec.comune.pinarolopo.pv.it', 'urp@comune.pinarolopo.pv.it', '0383878127', 'www.comune.pinarolopo.pv.it', 'UFAPTC'),
  ('Comune di Pizzale', 'Pizzale', 'PV', 'Lombardia', 670, '00485360184', 'Via Franco Ferraris, 8', '27050', 'comune.pizzale@pec.it', 'info@comune.pizzale.pv.it', '0383364774', 'https://www.comune.pizzale.pv.it', null),
  ('Comune di Ponte Nizza', 'Ponte Nizza', 'PV', 'Lombardia', 740, '00341500189', 'Via Roma, 45', '27050', 'comune.pontenizza@legalpec.it', 'info@comune.pontenizza.pv.it', '038359131', 'www.comune.pontenizza.pv.it', 'UFO3FZ'),
  ('Comune di Portalbera', 'Portalbera', 'PV', 'Lombardia', 1480, '84000830186', 'Via G. Mazzini N. 1', '27040', 'comune.portalbera@legalpec.it', 'info@comune.portalbera.pv.it', '0385266258', 'www.comune.portalbera.pv.it', 'UFV2WG'),
  ('Comune di Rea', 'Rea', 'PV', 'Lombardia', 395, '84000900187', 'Piazza C. Busoni 4', '27040', 'comune.rea@pec.regione.lombardia.it', 'municipio@comune.rea.pv.it', '038596123', 'www.comune.rea.pv.it', 'UFN17I'),
  ('Comune di Redavalle', 'Redavalle', 'PV', 'Lombardia', 1050, '00459830188', 'Via Garibaldi, 14', '27050', 'redavalle@legalpec.it', 'info@comune.redavalle.pv.it', null, 'www.comune.redavalle.pv.it', 'UFI284'),
  ('Comune di Retorbido', 'Retorbido', 'PV', 'Lombardia', 1511, '00431410182', 'Piazza Roma, 30', '27050', 'comune.retorbido@pec.regione.lombardia.it', 'segreteria@comune.retorbido.pv.it', '0383374502', 'www.comune.retorbido.pv.it', 'UFEDKW'),
  ('Comune di Rivanazzano Terme', 'Rivanazzano Terme', 'PV', 'Lombardia', 5150, '00485130181', 'Piazza CORNAGGIA 71', '27055', 'comune.rivanazzanoterme@pec.regione.lombardia.it', 'informazioni@comune.rivanazzanoterme.pv.it', '038394511', 'www.comune.rivanazzanoterme.pv.it', 'UFADZ9'),
  ('Comune di Robbio', 'Robbio', 'PV', 'Lombardia', 6016, '83001450184', 'Piazza Liberta'', 2', '27038', 'comune.robbio@pec.it', 'ragioneria@comune.robbio.pv.it', '03846751', 'www.comune.robbio.pv.it', '6V3K8M'),
  ('Comune di Robecco Pavese', 'Robecco Pavese', 'PV', 'Lombardia', 510, '00471900183', 'Via San Nazzaro, 18', '27042', 'comune.robeccopavese@legalpec.it', null, '038384225', 'www.comune.robeccopavese.pv.it/', 'UFS1NW'),
  ('Comune di Rocca de'' Giorgi', 'Rocca de'' Giorgi', 'PV', 'Lombardia', 37, '00495840183', 'Frazione Villa Fornace, 3', '27040', 'comune.roccadegiorgi@pec.regione.lombardia.it', 'info@comune.roccadegiorgi.pv.it', null, 'www.comune.roccadegiorgi.pv.it/', 'UFOPV0'),
  ('Comune di Rocca Susella', 'Rocca Susella', 'PV', 'Lombardia', 239, '00487150187', 'Frazione Susella,1', '27052', 'comune.roccasusella@pec.regione.lombardia.it', 'municipio@comune.roccasusella.pv.it', '038399004', 'www.comune.roccasusella.pv.it', 'UFRH16'),
  ('Comune di Rognano', 'Rognano', 'PV', 'Lombardia', 708, '00484680186', 'Via Roma, 16', '27010', 'postacertificata@pec.comune.rognano.pv.it', 'info@comune.rognano.pv.it', '0382926172', 'www.comune.rognano.pv.it', 'UFYGT9'),
  ('Comune di Romagnese', 'Romagnese', 'PV', 'Lombardia', 528, '00475450185', 'Romagnese Via Castello 1', '27050', 'comune.romagnese@pec.regione.lombardia.it', null, '0383580001', 'www.comune.romagnese.pv.it', 'UF5B04'),
  ('Comune di Roncaro', 'Roncaro', 'PV', 'Lombardia', 1533, '81001310184', 'Piazza Del Comune 15', '27010', 'comune.roncaro@halleycert.it', 'anagrafe@comune.roncaro.pv.it', '038294293', 'www.comune.roncaro.pv.it', 'UFGFPB'),
  ('Comune di Rosasco', 'Rosasco', 'PV', 'Lombardia', 560, '83001570189', 'Via Marconi n. 18', '27030', 'comune.rosasco@pec.regione.lombardia.it', 'protocollo@comune.rosasco.pv.it', '0384673833', 'www.comune-rosasco.it', 'UFDGIW'),
  ('Comune di Rovescala', 'Rovescala', 'PV', 'Lombardia', 810, '84000910186', 'Via Roma, 5', '27040', 'protocollo@pec.comune.rovescala.pv.it', null, '0385277281', 'www.comune.rovescala.pv.it', 'UFI858'),
  ('Comune di San Cipriano Po', 'San Cipriano Po', 'PV', 'Lombardia', 455, '84001010184', 'Piazza Giacomo Matteotti 7', '27043', 'sanciprianopo@postemailcertificata.it', 'info@comune.sanciprianopo.pv.it', '0385241708', 'www.comune.sanciprianopo.pv.it', 'UFVOGI'),
  ('Comune di San Damiano al Colle', 'San Damiano al Colle', 'PV', 'Lombardia', 600, '01756890180', 'Via Roma N. 4', '27040', 'comune.sandamianoalcolle@pec.regione.lombardia.it', 'protocollo@comune.sandamianoalcolle.pv.it', '0385756187', 'www.comune.sandamianoalcolle.pv.it', 'UFP70C'),
  ('Comune di San Genesio ed Uniti', 'San Genesio ed Uniti', 'PV', 'Lombardia', 4053, '00468360185', 'Via Riviera, 23', '27010', 'comune.sangenesio@pec.regione.lombardia.it', 'segreteria@comune.sangenesio.pv.it', '0382586023', 'https://www.comune.sangenesio.pv.it', 'UFRI6Q'),
  ('Comune di San Giorgio di Lomellina', 'San Giorgio di Lomellina', 'PV', 'Lombardia', 986, '83001710181', 'Piazza Pietro Corti, 12', '27020', 'comune.sangiorgiodilomellina@pec.regione.lombardia.it', null, null, 'www.comune.sangiorgiodilomellina.pv.it', 'UFV5KQ'),
  ('Comune di San Martino Siccomario', 'San Martino Siccomario', 'PV', 'Lombardia', 6666, '00466390184', 'Via Roma, 1', '27028', 'protocollo@pec.comune.sanmartino.pv.it', 'info@comune.sanmartino.pv.it', '0382496111', 'www.comune.sanmartino.pv.it', 'UFW97B'),
  ('Comune di San Zenone al Po', 'San Zenone al Po', 'PV', 'Lombardia', 576, '00475630182', 'Via Marconi 9', '27010', 'comune.sanzenonealpo@pec.regione.lombardia.it', 'protocollo@comune.sanzenonealpo.pv.it', '038279015', 'www.comune.sanzenonealpo.pv.it/', 'UF7D7C'),
  ('Comune di Sannazzaro de'' Burgondi', 'Sannazzaro de'' Burgondi', 'PV', 'Lombardia', 5230, '00409830189', 'Via Cavour, 18', '27039', 'protocollo.comunesannazzarodeburgondi@pec.it', null, '0382995611', 'www.comune.sannazzarodeburgondi.pv.it', null),
  ('Comune di Sant''Alessio con Vialone', 'Sant''Alessio con Vialone', 'PV', 'Lombardia', 1058, '00493580187', 'Via Vittoria, 18', '27016', 'protocollo@pec.comune.santalessioconvialone.pv.it', 'protocollo@comune.santalessioconvialone.pv.it', '038294029', 'www.comune.santalessioconvialone.pv.it', 'UFD0T2'),
  ('Comune di Sant''Angelo Lomellina', 'Sant''Angelo Lomellina', 'PV', 'Lombardia', 803, '83001630181', 'Via Roma, 35', '27030', 'comune.santangelolomellina@pec.regione.lombardia.it', 'municipio@comune.santangelolomellina.pv.it', '038455012', 'www.comune.santangelolomellina.pv.it', 'UFXT7B'),
  ('Comune di Santa Cristina e Bissone', 'Santa Cristina e Bissone', 'PV', 'Lombardia', 1848, '00414310185', 'Via Vittorio Veneto, 5', '27010', 'comune.santacristinaebissone@pec.regione.lombardia.it', 'protocollo@comune.santacristinaebissone.pv.it', '038270121', 'www.comune.santacristinaebissone.pv.it', 'UFVVUY'),
  ('Comune di Santa Giuletta', 'Santa Giuletta', 'PV', 'Lombardia', 1585, '00240820183', 'Via Martiri Della Liberta'', 7', '27046', 'comune.santagiuletta@pec.regione.lombardia.it', null, null, 'www.comune.santagiuletta.pv.it', 'UFWRQZ'),
  ('Comune di Santa Margherita di Staffora', 'Santa Margherita di Staffora', 'PV', 'Lombardia', 424, '86002820180', 'Frazione Casanova Destra 1', '27050', 'comune.santamargheritadistaffora@pec.regione.lombardia.it', null, '0383551100', 'www.comune.santamargheritadistaffora.pv.it', 'UFM0J5'),
  ('Comune di Santa Maria della Versa', 'Santa Maria della Versa', 'PV', 'Lombardia', 2275, '01484840184', 'Piazza Amm. Faravelli, 1', '27047', 'comune.santamariadellaversa@pec.regione.lombardia.it', 'info@comune.santa-maria-della-versa.pv.it', '0385278011', 'www.comune.santa-maria-della-versa.pv.it', 'UFUMLK'),
  ('Comune di Sartirana Lomellina', 'Sartirana Lomellina', 'PV', 'Lombardia', 1491, '00464360189', 'Piazza XXVI Aprile, 5', '27020', 'comune.sartiranalomellina@pec.it', 'amministrazione@comune.sartiranalomellina.pv.it', '0384800810', 'www.comune.sartiranalomellina.pv.it', 'UFD8K7'),
  ('Comune di Scaldasole', 'Scaldasole', 'PV', 'Lombardia', 853, '00482750189', 'Via undici febbraio, 7', '27020', 'comune.scaldasole@pec.regione.lombardia.it', 'comune@scaldasole.lombardia.it', '0382997454', 'https://www.comune.scaldasole.pv.it', 'UFB1NF'),
  ('Comune di Semiana', 'Semiana', 'PV', 'Lombardia', 192, '00471430181', 'Via Vittorio Veneto, 20', '27020', 'semiana@postemailcertificata.it', 'info@comunesemiana.pv.it', '0384804615', 'www.comunesemiana.pv.it', 'UF33P8'),
  ('Comune di Silvano Pietra', 'Silvano Pietra', 'PV', 'Lombardia', 622, '86003430187', 'Via Umberto I, 31', '27050', 'comune.silvanopietra@legalpec.it', 'info@comune.silvanopietra.pv.it', null, 'www.comune.silvanopietra.pv.it', 'UFVCQT'),
  ('Comune di Siziano', 'Siziano', 'PV', 'Lombardia', 6921, '00478370182', 'Piazza Giacomo Negri, 1', '27010', 'info@pec.comune.siziano.pv.it', 'info@comune.siziano.pv.it', '038267801', 'www.comune.siziano.pv.it', 'UFTMN0'),
  ('Comune di Sommo', 'Sommo', 'PV', 'Lombardia', 1117, '00467130183', 'Via Roma, N. 84', '27048', 'comune.sommo@pec.regione.lombardia.it', 'info@comune.sommo.pv.it', '0382402019', 'www.comune.sommo.pv.it', 'UFMZIH'),
  ('Comune di Spessa', 'Spessa', 'PV', 'Lombardia', 567, '00475620183', 'Via Roma, 9', '27010', 'comune.spessa@pec.regione.lombardia.it', 'info@comune.spessa.pv.it', '038279032', 'www.comune.spessa.pv.it', 'UFM8GC'),
  ('Comune di Stradella', 'Stradella', 'PV', 'Lombardia', 11729, '00467720181', 'Via Marconi, 35', '27049', 'comune.stradella@pec.regione.lombardia.it', 'info@comune.stradella.pv.it', null, 'www.comune.stradella.pv.it', 'UF0R7I'),
  ('Comune di Suardi', 'Suardi', 'PV', 'Lombardia', 573, '00466350188', 'Via G. Marconi, 9', '27030', 'comunesuardi@pec.it', 'info@comunesuardi.it', '038489031', 'www.comune.suardi.pv.it', 'UF799L'),
  ('Comune di Torrazza Coste', 'Torrazza Coste', 'PV', 'Lombardia', 1602, '00485150189', 'Piazza Vittorio Emanuele Ii, 11', '27050', 'amministrativo.torrazzacoste@legalpec.it', 'segreteria@comune.torrazzacoste.pv.it', '038377001', 'www.comune.torrazzacoste.pv.it', 'UFM7GH'),
  ('Comune di Torre Beretti e Castellaro', 'Torre Beretti e Castellaro', 'PV', 'Lombardia', 489, '91000280189', 'Via Frascarolo, 4', '27030', 'comune.torreberetti@pec.it', null, null, 'https://comune.torreberettiecastellaro.pv.it', 'UFMN03'),
  ('Comune di Torre d''Arese', 'Torre d''Arese', 'PV', 'Lombardia', 942, '00475460184', 'P.zza Roma, 3', '27010', 'comune.torredarese@pec.regione.lombardia.it', 'info@comune.torredarese.pv.it', '0382947033', 'www.comune.torredarese.pv.it', 'UF03II'),
  ('Comune di Torre d''Isola', 'Torre d''Isola', 'PV', 'Lombardia', 2497, '80000930182', 'Piazza Liberta'', 15', '27020', 'comune@pec.comune.torredisola.pv.it', 'info@comune.torredisola.pv.it', '0382407021', 'www.comune.torredisola.pv.it', 'UFD83Z'),
  ('Comune di Torre de'' Negri', 'Torre de'' Negri', 'PV', 'Lombardia', 332, '00408380186', 'Viale Fratelli Cervi, 18', '27011', 'comune.torredenegri@pec.regione.lombardia.it', 'info@comune.torredenegri.pv.it', null, 'www.comune.torredenegri.pv.it', 'UF4FFW'),
  ('Comune di Torrevecchia Pia', 'Torrevecchia Pia', 'PV', 'Lombardia', 3539, '00414570184', 'Via roma,1', '27010', 'comune.torrevecchiapia@pec.regione.lombardia.it', 'finanziario@comune.torrevecchiapia.pv.it', null, 'www.comune.torrevecchiapia.pv.it', 'UFY0M8'),
  ('Comune di Torricella Verzate', 'Torricella Verzate', 'PV', 'Lombardia', 796, '00473910180', 'Piazza Italia, 1', '27050', 'protocollo@pec.comune.torricellaverzate.pv.it', 'info@comune.torricellaverzate.pv.it', '0383896030', 'www.comune.torricellaverzate.pv.it', 'UFRI0F'),
  ('Comune di Travacò Siccomario', 'Travacò Siccomario', 'PV', 'Lombardia', 4427, '00468090188', 'Via Marconi, 37', '27020', 'protocollo@pec.comune.travacosiccomario.pv.it', 'info@comune.travacosiccomario.pv.it', '0382482003', 'www.comune.travacosiccomario.pv.it', null),
  ('Comune di Trivolzio', 'Trivolzio', 'PV', 'Lombardia', 2494, '80000970188', 'Via Casorate Primo, 4', '27020', 'comune.trivolzio@pec.regione.lombardia.it', 'segreteria@comune.trivolzio.pv.it', '0382928041', 'www.comune.trivolzio.pv.it', 'UFX9IG'),
  ('Comune di Tromello', 'Tromello', 'PV', 'Lombardia', 3772, '85001850180', 'Piazza V.Veneto, 1', '27020', 'comune.tromello@legalmail.it', null, '038286021', 'www.comune.tromello.pv.it', 'UFTGK9'),
  ('Comune di Trovo', 'Trovo', 'PV', 'Lombardia', 1000, '00473040186', 'Via Roma, 13', '27020', 'comune.trovo@pec.regione.lombardia.it', 'segreteria@comune.trovo.pv.it', '0382928051', 'www.comune.trovo.pv.it', 'UFY4XG'),
  ('Comune di Val di Nizza', 'Val di Nizza', 'PV', 'Lombardia', 571, '00341480184', 'Via Casa Ponte, 7', '27050', 'comune.valdinizza@legalpec.it', 'info@comune.valdinizza.pv.it', '0383578018', 'www.comune.valdinizza.pv.it', 'UFEVX3'),
  ('Comune di Valeggio', 'Valeggio', 'PV', 'Lombardia', 192, '83001990189', 'Via Vittorio Veneto, 12', '27020', 'comune.valeggio@pec.regione.lombardia.it', null, '038449052', 'www.comune.valeggio.pv.it', 'UFJX9N'),
  ('Comune di Valle Lomellina', 'Valle Lomellina', 'PV', 'Lombardia', 2229, '00471450189', 'Piazza Municipio, 2', '27020', 'sindaco.comune.vallelomellina@pec.it', null, '038479001', 'www.comune.vallelomellina.pv.it', 'UF0ZB5'),
  ('Comune di Valle Salimbene', 'Valle Salimbene', 'PV', 'Lombardia', 1425, '00466530185', 'Via Valle 4', '27010', 'staff@pec.vallesalimbene.org', 'protocollo@comune.vallesalimbene.pv.it', null, 'https://www.comune.vallesalimbene.pv.it/it-it/home', 'UFTWAF'),
  ('Comune di Varzi', 'Varzi', 'PV', 'Lombardia', 3073, '86003550182', 'Piazza Umberto, 1', '27057', 'protocollo@pec.comune.varzi.pv.it', 'ragioneria@comune.varzi.pv.it', '038353288', 'www.comune.varzi.pv.it', 'UF6SSP'),
  ('Comune di Velezzo Lomellina', 'Velezzo Lomellina', 'PV', 'Lombardia', 82, '82001050184', 'Via Roma, 14', '27020', 'protocollo@pec.comune.velezzolomellina.pv.it', 'finanziaria@comune.velezzolomellina.pv.it', '038443072', 'www.comune.velezzolomellina.pv.it', 'UFWGJR'),
  ('Comune di Vellezzo Bellini', 'Vellezzo Bellini', 'PV', 'Lombardia', 3528, '00484670187', 'Via Municipio, 1', '27010', 'comune@pec.comune.vellezzobellini.pv.it', 'comune@comune.vellezzobellini.pv.it', '0382926014', 'www.comune.vellezzobellini.pv.it', 'UFWYUM'),
  ('Comune di Verretto', 'Verretto', 'PV', 'Lombardia', 380, '00481940187', 'Via Mazzini,30', '27053', 'comune.verretto@legalpec.it', null, '038384570', 'www.comune.verretto.pv.it', 'UFJMFL'),
  ('Comune di Verrua Po', 'Verrua Po', 'PV', 'Lombardia', 1213, '00471420182', 'Via Vittorio Veneto N.1', '27040', 'comune.verruapo@pec.regione.lombardia.it', 'protocollo@comune.verruapo.pv.it', '038596121', 'www.comune.verruapo.pv.it', 'UF8994'),
  ('Comune di Vidigulfo', 'Vidigulfo', 'PV', 'Lombardia', 6821, '00385320189', 'Piazza 1 maggio n. 4', '27018', 'info@pec.comune.vidigulfo.pv.it', null, '038269003', 'www.comune.vidigulfo.pv.it', 'UFXS8O'),
  ('Comune di Vigevano', 'Vigevano', 'PV', 'Lombardia', 63480, '85001870188', 'Corso Vittorio Emanuele II 25', '27029', 'protocollovigevano@pec.it', null, '0381299247', 'www.comune.vigevano.pv.it', 'UFE9AU'),
  ('Comune di Villa Biscossi', 'Villa Biscossi', 'PV', 'Lombardia', 68, '00522180181', 'Via Roma, 3', '27035', 'comune.villabiscossi@pec.it', null, '0384820584', 'www.comune.villabiscossi.pv.it', 'UF5512'),
  ('Comune di Villanova d''Ardenghi', 'Villanova d''Ardenghi', 'PV', 'Lombardia', 762, '00514190180', 'Via Roma, 22', '27030', 'comune.villanovadardenghi@pec.it', null, '0382400022', 'www.comune.villanovadardenghi.pv.it', 'UFEB44'),
  ('Comune di Villanterio', 'Villanterio', 'PV', 'Lombardia', 3441, '00426210183', 'Piazza Castello, 11', '27019', 'ragioneria.comune.villanterio@pec.regione.lombardia.it', 'segreteria@comune.villanterio.pv.it', '0382967122', 'www.comune.villanterio.pv.it', 'UFO5GR'),
  ('Comune di Vistarino', 'Vistarino', 'PV', 'Lombardia', 1595, '00476120183', 'Via Vivente, 29', '27010', 'comune.vistarino@pec.regione.lombardia.it', 'anagrafe@comune.vistarino.pv.it', '0382968144', 'www.comune.vistarino.pv.it', 'UFZM5P'),
  ('Comune di Voghera', 'Voghera', 'PV', 'Lombardia', 40220, '00186490181', 'Piazza Duomo, 1', '27058', 'protocollo@cert.comune.voghera.pv.it', null, null, 'www.comune.voghera.pv.it', 'UFHIC1'),
  ('Comune di Volpara', 'Volpara', 'PV', 'Lombardia', 131, '01898150188', 'Via Roma, 8', '27047', 'protocollo@pec.comune.volpara.pv.it', 'protocollo@comune.volpara.pv.it', '038599729', 'www.comune.volpara.pv.it', 'UFSEGK'),
  ('Comune di Zavattarello', 'Zavattarello', 'PV', 'Lombardia', 881, '95002830180', 'Via Vittorio Emanuele, 41', '27059', 'comune.zavattarello@pec.regione.lombardia.it', null, null, 'www.comune.zavattarello.pv.it', null),
  ('Comune di Zeccone', 'Zeccone', 'PV', 'Lombardia', 1717, '00468340187', 'Via Monte Grappa, 52', '27010', 'comune.zeccone@pec.regione.lombardia.it', 'info@comune.zeccone.pv.it', '0382955021', 'https://www.comune.zeccone.pv.it', 'UFP15K'),
  ('Comune di Zeme', 'Zeme', 'PV', 'Lombardia', 983, '83001790183', 'Piazza Matteotti 1', '27030', 'comunezeme@pec.it', 'comunezeme@libero.it', '038454021', 'www.comune.zeme.pv.it', 'UFHTHY'),
  ('Comune di Zenevredo', 'Zenevredo', 'PV', 'Lombardia', 481, '84001370182', 'Via Roma 23', '27049', 'protocollo.comune.zenevredo@pec.regione.lombardia.it', 'protocollo@comune.zenevredo.pv.it', '0385241993', 'www.comune.zenevredo.pv.it', 'UFW9GP'),
  ('Comune di Zerbo', 'Zerbo', 'PV', 'Lombardia', 407, '00475610184', 'Via Roma 13', '27017', 'comune.zerbo@pec.regione.lombardia.it', 'protocollo@comune.zerbo.pv.it', '038279017', 'www.comune.zerbo.pv.it', 'UFCAFM'),
  ('Comune di Zerbolò', 'Zerbolò', 'PV', 'Lombardia', 1714, '00460320187', 'Via Roma, 116', '27020', 'protocollo@pec.comune.zerbolo.pv.it', 'PROTOCOLLO@COMUNE.ZERBOLO.PV.IT', '0382818672', 'www.comune.zerbolo.pv.it', 'UF3CPL'),
  ('Comune di Zinasco', 'Zinasco', 'PV', 'Lombardia', 3191, '00487690182', 'P.zza Vittoria, 11', '27030', 'protocollo@pec.comune.zinasco.pv.it', 'info@comune.zinasco.pv.it', '038291016', 'www.comune.zinasco.pv.it', 'UF3C8Y');

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

-- Controllo: PV = 184 comuni / 545.901 ab.
select provincia, count(*) as comuni, sum(abitanti) as abitanti,
       count(pec) as con_pec, count(email) as con_email, count(phone) as con_telefono
from companies
where tipo = 'pa' and name ilike 'Comune di %' and provincia = 'PV'
group by provincia;

