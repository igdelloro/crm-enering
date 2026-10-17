-- =====================================================================
--  CRM ENER.ING — Comuni di Verona e Mantova con abitanti e contatti
--  Esegui nel SQL Editor di Supabase. Sicuro e ri-eseguibile (non cancella nulla):
--   * aggiunge ai clienti le colonne "abitanti" ed "email" (se mancano);
--   * inserisce i Comuni mancanti (98 provincia di Verona + 64 provincia di Mantova)
--     come clienti PA;
--   * per i Comuni già presenti aggiorna gli abitanti e COMPLETA solo i campi
--     vuoti (non sovrascrive quello che avete già scritto a mano).
--  Fonti:
--   - abitanti: Istat, popolazione stimata al 01/01/2026 (via tuttitalia.it)
--   - contatti: IndicePA (indicepa.gov.it), open data ufficiali, letti il 17/10/2026
--     C.F. ente, indirizzo, CAP, PEC, email, telefono, sito, codice univoco
--     di fatturazione (solo se l'ente ne ha uno solo, o uno "Uff_eFatturaPA").
--     Email: solo indirizzi generici (protocollo/info/segreteria/uffici),
--     mai caselle personali dei dipendenti.
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
  ('Comune di Affi', 'Affi', 'VR', 'Veneto', 2504, '00683030233', 'Via Della Repubblica, 9', '37010', 'protocollo@pec.comune.affi.vr.it', 'servizi@comune.affi.vr.it', null, 'www.comune.affi.vr.it', 'UFUI2Z'),
  ('Comune di Albaredo d''Adige', 'Albaredo d''Adige', 'VR', 'Veneto', 5298, '00264700238', 'Piazza Vittorio Emanuele, 1', '37041', 'protocollo.albaredodadige@pec.it', 'urp@comune.albaredodadige.vr.it', '0456608080', 'www.comune.albaredodadige.vr.it', 'UF6DYG'),
  ('Comune di Angiari', 'Angiari', 'VR', 'Veneto', 2544, '82003290234', 'Piazza Municipio N. 441', '37050', 'protocollo.angiari@legalmail.it', 'segreteria@comune.angiari.vr.it', '044297007', 'www.comune.angiari.vr.it', 'UF10RJ'),
  ('Comune di Arcole', 'Arcole', 'VR', 'Veneto', 6419, '83002270235', 'Piazza Marconi,1', '37040', 'arcole.vr@cert.ip-veneto.net', 'segreteria@comune.arcole.vr.it', '0457639609', 'www.comunediarcole.it', 'UF7TPE'),
  ('Comune di Badia Calavena', 'Badia Calavena', 'VR', 'Veneto', 2707, '83002470231', 'Piazza Mercato 1', '37030', 'comune.badiacalavena@pec.it', 'protocollo@comune.badiacalavena.vr.it', '0457810503', 'www.comune.badiacalavena.vr.it', 'UFV5KL'),
  ('Comune di Bardolino', 'Bardolino', 'VR', 'Veneto', 6816, '00345090237', 'Piazzetta San Gervaso 1', '37011', 'comune.bardolino@legalmail.it', 'comune.urp@comune.bardolino.vr.it', '0456213210', 'www.comune.bardolino.vr.it', 'UFQQ7U'),
  ('Comune di Belfiore', 'Belfiore', 'VR', 'Veneto', 3408, '83000210233', 'Piazza Della Repubblica, 10', '37050', 'belfiore.vr@pec.wmail.it', null, '0456145011', 'comune.belfiore.vr.it', null),
  ('Comune di Bevilacqua', 'Bevilacqua', 'VR', 'Veneto', 1817, '82001750239', 'Via Roma 264', '37040', 'segreteria.bevilacqua@pec.comune.bevilacqua.vr.it', null, '0442647211', 'www.comune.bevilacqua.vr.it', 'UFLFU9'),
  ('Comune di Bonavigo', 'Bonavigo', 'VR', 'Veneto', 1990, '00663500239', 'Piazza Aquilina Lugo, 26', '37040', 'protocollo@pec.comune.bonavigo.vr.it', 'info@comune.bonavigo.vr.it', '044273010', 'www.comune.bonavigo.vr.it', 'UFNG7B'),
  ('Comune di Boschi Sant''Anna', 'Boschi Sant''Anna', 'VR', 'Veneto', 1385, '00686570235', 'Piazza Sant''Anna, 31', '37040', 'protocollo@pec.comune.boschisantanna.vr.it', 'info@comune.boschisantanna.vr.it', '044299133', 'www.comune.boschisantanna.vr.it', 'UFIF0U'),
  ('Comune di Bosco Chiesanuova', 'Bosco Chiesanuova', 'VR', 'Veneto', 3593, '00668140239', 'Piazza Chiesa, 35', '37021', 'comune.boscochiesanuova.vr@pecveneto.it', 'info@comune.boscochiesanuova.vr.it', '0456780383', 'www.comune.boscochiesanuova.vr.it', 'UFZ87C'),
  ('Comune di Bovolone', 'Bovolone', 'VR', 'Veneto', 16392, '00659880231', 'Piazza Scipioni, 1', '37051', 'protocollo@pec.comune.bovolone.vr.it', 'amministrazione@comune.bovolone.vr.it', '0456995111', 'www.comune.bovolone.vr.it', null),
  ('Comune di Brentino Belluno', 'Brentino Belluno', 'VR', 'Veneto', 1368, '00659140230', 'Piazza Zefferino Gelmetti, 1', '37020', 'comune.brentinobelluno@pec.it', 'amministrativo@comune.brentino.vr.it', '0456284062', 'www.comune.brentino.vr.it', 'UFDD9N'),
  ('Comune di Brenzone sul Garda', 'Brenzone sul Garda', 'VR', 'Veneto', 2436, '00661110239', 'Via Venti Settembre 8', '37010', 'brenzone.vr@cert.ip-veneto.net', 'protocollo@comune.brenzone.vr.it', '0456589500', 'www.comune.brenzone.vr.it', 'UFJZ0A'),
  ('Comune di Bussolengo', 'Bussolengo', 'VR', 'Veneto', 21037, '00268250230', 'Piazza Nuova, 14', '37012', 'comune.bussolengo@cert.legalmail.it', null, '0456769900', 'www.comune.bussolengo.vr.it', 'UFFZTK'),
  ('Comune di Buttapietra', 'Buttapietra', 'VR', 'Veneto', 7031, '80025180235', 'Piazza QUATTRO NOVEMBRE N.1', '37060', 'comune.buttapietra@halleycert.it', 'protocollo@comune.buttapietra.vr.it', null, 'www.comune.buttapietra.vr.it', 'UFI2Y5'),
  ('Comune di Caldiero', 'Caldiero', 'VR', 'Veneto', 8160, '00252060231', 'Piazza Marcolungo, 19', '37042', 'protocollogenerale@pec.comune.caldiero.vr.it', 'info@comune.caldiero.vr.it', '0457650023', 'www.comune.caldiero.vr.it', null),
  ('Comune di Caprino Veronese', 'Caprino Veronese', 'VR', 'Veneto', 8775, '00414200238', 'Piazza Roma, 6', '37013', 'comune.caprinoveronese.vr@pecveneto.it', null, '0456200844', 'www.comune.caprinoveronese.vr.it', null),
  ('Comune di Casaleone', 'Casaleone', 'VR', 'Veneto', 5672, '00659900237', 'Via Vittorio Veneto, N. 61', '37052', 'segreteria.comune.casaleone.vr@pecveneto.it', 'protocollo@comune.casaleone.vr.it', '0442328711', 'www.comune.casaleone.vr.it', 'UFST48'),
  ('Comune di Castagnaro', 'Castagnaro', 'VR', 'Veneto', 3497, '82005890239', 'Via Dante Alighieri 210', '37043', 'castagnaro.vr@cert.ip-veneto.net', 'protocollo@comunedicastagnaro.it', null, 'www.comunedicastagnaro.it', 'UFTH8G'),
  ('Comune di Castel d''Azzano', 'Castel d''Azzano', 'VR', 'Veneto', 12333, '00659830236', 'Via Castello 26', '37060', 'casteldazzano@legalmail.it', 'info@comune.castel-d-azzano.vr.it', '0459215911', 'www.comune.castel-d-azzano.vr.it', 'ZN37ST'),
  ('Comune di Castelnuovo del Garda', 'Castelnuovo del Garda', 'VR', 'Veneto', 13306, '00667270235', 'Piazza Degli Alpini, 4', '37014', 'castelnuovodg@legalmail.it', 'protocollo@castelnuovodg.it', '0456459920', 'www.comune.castelnuovodelgarda.vr.it', 'UF7ZH5'),
  ('Comune di Cavaion Veronese', 'Cavaion Veronese', 'VR', 'Veneto', 5995, '81000830232', 'Piazza Fracastoro, 8', '37010', 'segreteria@pec.comunecavaion.it', 'segreteria@comunecavaion.it', '0456265711', 'https://www.comune.cavaionveronese.vr.it/it', 'UF1UPT'),
  ('Comune di Cazzano di Tramigna', 'Cazzano di Tramigna', 'VR', 'Veneto', 1466, '00659190235', 'Piazza Giacomo Matteotti, 1', '37030', 'comune.cazzanoditramigna.vr@pecveneto.it', 'protocollo@comune.cazzanoditramigna.vr.it', '0457820506', 'www.comune.cazzanoditramigna.vr.it', 'UFXJ1R'),
  ('Comune di Cerea', 'Cerea', 'VR', 'Veneto', 17304, '00659890230', 'v. XXV Aprile, 52', '37053', 'comunecerea@halleypec.it', 'info@cerea.net', '044280055', 'www.cerea.net', 'UFTI8E'),
  ('Comune di Cerro Veronese', 'Cerro Veronese', 'VR', 'Veneto', 2698, '80007570239', 'Piazza Don Angelo Vinco, 4', '37020', 'comune.cerroveronese@pec.it', 'comune@comune.cerroveronese.vr.it', '0457080965', 'www.comune.cerroveronese.vr.it', 'UFR0S1'),
  ('Comune di Cologna Veneta', 'Cologna Veneta', 'VR', 'Veneto', 8543, '00234140234', 'Piazza Capitaniato, 1', '37044', 'colognaveneta.vr@cert.ip-veneto.net', null, '0442413511', 'www.comune.cologna-veneta.vr.it', 'UFNWBF'),
  ('Comune di Colognola ai Colli', 'Colognola ai Colli', 'VR', 'Veneto', 8801, '00267000230', 'Piazzale Trento, 2', '37030', 'colognolaaicolli.vr@cert.ip-veneto.net', 'protocollo@comunecolognola.it', '0456159611', 'www.comune.colognola.vr.it', null),
  ('Comune di Concamarise', 'Concamarise', 'VR', 'Veneto', 1060, '82002330239', 'Via Capitello, 1', '37050', 'comune.concamarise@pec.it', 'areacontabile@comune.concamarise.vr.it', '0442374055', 'www.comune.concamarise.vr.it/', 'UFOGAV'),
  ('Comune di Costermano sul Garda', 'Costermano sul Garda', 'VR', 'Veneto', 3996, '00650140239', 'Piazza G.B. Ferrario, 1', '37010', 'comunecostermano@cert.ip-veneto.net', null, '0456208111', 'www.comunecostermano.it', 'UFUSN8'),
  ('Comune di Dolcè', 'Dolcè', 'VR', 'Veneto', 2536, '00661130237', 'Via Trento,698', '37020', 'info@pec.comunedolce.it', 'area.contabile@comune.dolce.vr.it', '0452598771', 'www.comune.dolce.vr.it', 'UFKL72'),
  ('Comune di Erbè', 'Erbè', 'VR', 'Veneto', 1922, '80015770235', 'Via Vittorio Emanuele, 2', '37060', 'erbe.vr@cert.ip-veneto.net', 'info@comune.erbe.vr.it', '0457325005', 'www.comune.erbe.vr.it', 'UFY9LW'),
  ('Comune di Erbezzo', 'Erbezzo', 'VR', 'Veneto', 850, '00670360239', 'Via Roma N. 73', '37020', 'comune.erbezzo.vr@pecveneto.it', null, '0457075013', 'www.comune.erbezzo.vr.it', 'UF5YSK'),
  ('Comune di Ferrara di Monte Baldo', 'Ferrara di Monte Baldo', 'VR', 'Veneto', 302, '81000130237', 'Piazza General Cantore, 12', '37020', 'protocollo@comune.ferraradimontebaldo.legalmail.it', 'info@comune.ferraradimontebaldo.vr.it', null, 'www.comune.ferraradimontebaldo.vr.it', 'UFT21L'),
  ('Comune di Fumane', 'Fumane', 'VR', 'Veneto', 4193, '00658150230', 'Viale Roma, 2', '37022', 'fumane.vr@cert.ip-veneto.net', 'info@comunedifumane.it', '0456832811', 'www.comune.fumane.vr.it', 'UFQP49'),
  ('Comune di Garda', 'Garda', 'VR', 'Veneto', 4044, '00419930235', 'Lungolago Regina Adelaide, 15', '37016', 'comune.garda@pec.it', 'finanziaria@comune.garda.vr.it', '0456208444', 'www.comune.garda.vr.it', 'UFUP4C'),
  ('Comune di Gazzo Veronese', 'Gazzo Veronese', 'VR', 'Veneto', 5226, '82002770236', 'Via Roma, 89', '37060', 'segreteria@pec.comune.gazzo.vr.it', 'segreteria@comune.gazzo.vr.it', '0442579000', 'www.comune.gazzo.vr.it', 'UFMQT4'),
  ('Comune di Grezzana', 'Grezzana', 'VR', 'Veneto', 10775, '00405260233', 'Piazzetta Milite Ignoto, 1', '37023', 'protocollo.comune.grezzana.vr@pecveneto.it', 'info@comune.grezzana.vr.it', null, 'https://www.comune.grezzana.vr.it', null),
  ('Comune di Illasi', 'Illasi', 'VR', 'Veneto', 5149, '00233530237', 'Piazza Della Liberta'' N. 1', '37031', 'protocollo.comune.illasi.vr@pecveneto.it', 'info@comune.illasi.vr.it', '0457830411', 'www.comune.illasi.vr.it', null),
  ('Comune di Isola della Scala', 'Isola della Scala', 'VR', 'Veneto', 11825, '00457160232', 'Via Vittorio Veneto 4', '37063', 'comune.isoladellascala.vr@pecveneto.it', 'info@comune.isoladellascala.vr.it', '0456631911', 'www.comune.isoladellascala.vr.it', 'UFJXVF'),
  ('Comune di Isola Rizza', 'Isola Rizza', 'VR', 'Veneto', 3317, '00660940230', 'Via G. Marconi, 187', '37050', 'ragioneria.isolarizza@legalmail.it', null, '0457135022', 'www.comune.isolarizza.vr.it', 'UFJ4S8'),
  ('Comune di Lavagno', 'Lavagno', 'VR', 'Veneto', 8730, '00267720233', 'Via Piazza, 4', '37030', 'comune.lavagno.vr@pecveneto.it', 'info@comune.lavagno.vr.it', '0458989311', 'www.comune.lavagno.vr.it', 'UF6M50'),
  ('Comune di Lazise', 'Lazise', 'VR', 'Veneto', 6771, '00413860230', 'Piazza Vittorio Emanuele, 20', '37017', 'comune.lazise.urp@halleypec.it', 'info@comune.lazise.vr.it', '0456445111', 'www.comune.lazise.vr.it', 'UFA7Z5'),
  ('Comune di Legnago', 'Legnago', 'VR', 'Veneto', 26084, '00597030238', 'Via XX Settembre, 29', '37045', 'legnago.vr@cert.ip-veneto.net', null, '0442634898', 'www.comune.legnago.vr.it', 'UF8XF6'),
  ('Comune di Malcesine', 'Malcesine', 'VR', 'Veneto', 3472, '00601160237', 'Piazza Statuto, 1', '37018', 'protocollo@pec.comunemalcesine.it', 'info@comunemalcesine.it', '0456589911', 'www.comunemalcesine.it', 'UFLF99'),
  ('Comune di Marano di Valpolicella', 'Marano di Valpolicella', 'VR', 'Veneto', 3085, '80012760239', 'Via Porta, 1', '37020', 'info@pec.comunemaranovalpolicella.vr.it', 'info@comunemaranovalp.it', '0457755002', 'https://www.comune.maranodivalpolicella.vr.it/', 'UFX9B4'),
  ('Comune di Mezzane di Sotto', 'Mezzane di Sotto', 'VR', 'Veneto', 2502, '00596180232', 'Via San Giovanni di Dio, 6', '37030', 'protocollogenerale@pec.comune.mezzane.vr.it', 'segreteria@comune.mezzane.vr.it', '0458880100', 'www.comune.mezzane.vr.it', 'UFSP25'),
  ('Comune di Minerbe', 'Minerbe', 'VR', 'Veneto', 4644, '00345850234', 'Via Guglielmo Marconi, 41', '37046', 'comune.minerbe@halleypec.it', 'comune@comune.minerbe.vr.it', '0442633411', 'www.comune.minerbe.vr.it', 'UF9YHB'),
  ('Comune di Montecchia di Crosara', 'Montecchia di Crosara', 'VR', 'Veneto', 4323, '83000930236', 'Piazza Umberto I', '37030', 'protocollo.comune.montecchiadicrosara.vr@pecveneto.it', 'segreteria@comune.montecchiadicrosara.vr.it', '0457450038', 'www.comune.montecchiadicrosara.vr.it', 'UFI846'),
  ('Comune di Monteforte d''Alpone', 'Monteforte d''Alpone', 'VR', 'Veneto', 8953, '00278010236', 'Piazza Silvio Venturi, 24', '37032', 'pec@pec.comune.montefortedalpone.vr.it', 'info@comune.montefortedalpone.vr.it', '0456137311', 'www.comune.montefortedalpone.vr.it', 'UFACHH'),
  ('Comune di Mozzecane', 'Mozzecane', 'VR', 'Veneto', 8200, '00354500233', 'Via C. Bon Brenzoni, 26', '37060', 'protocollo@pec.comunemozzecane.it', null, '0456335810', 'https://www.comune.mozzecane.vr.it', 'UFUNB9'),
  ('Comune di Negrar di Valpolicella', 'Negrar di Valpolicella', 'VR', 'Veneto', 16378, '00251080230', 'Piazza Vittorio Emanuele, 37', '37024', 'protocollo@pec.comunenegrar.it', 'settorefinanziario@comunenegrar.it', '0456011611', 'www.comunenegrar.it', null),
  ('Comune di Nogara', 'Nogara', 'VR', 'Veneto', 8488, '80009120231', 'Via Falcone-Borsellino, 16', '37054', 'comune.nogara.vr@halleypec.it', null, '0442513311', 'www.comune.nogara.vr.it', 'UFI97B'),
  ('Comune di Nogarole Rocca', 'Nogarole Rocca', 'VR', 'Veneto', 3888, '00645290230', 'Via Roma, 38', '37060', 'urp.nogarolerocca@legalmail.it', 'ragioneria@comune.nogarolerocca.vr.it', '045792384', 'www.comune.nogarolerocca.vr.it', 'UFWEJA'),
  ('Comune di Oppeano', 'Oppeano', 'VR', 'Veneto', 10383, '80030260238', 'P.zza Gilberto Altichieri, 1', '37050', 'oppeano.vr@cert.ip-veneto.net', 'segreteria@comune.oppeano.vr.it', '0457139240', 'www.comune.oppeano.vr.it', null),
  ('Comune di Palù', 'Palù', 'VR', 'Veneto', 1196, '00689720233', 'Via Roma, 29', '37050', 'palu@cert.ip-veneto.net', 'contabilita-scuola@comunepalu.it', '0456070021', 'www.comune.palu.vr.it', 'UF34X2'),
  ('Comune di Pastrengo', 'Pastrengo', 'VR', 'Veneto', 3089, '00721100238', 'Piazza Carlo Alberto 1', '37010', 'protocollo.comune.pastrengo.vr@pecveneto.it', 'info@comune.pastrengo.vr.it', '0456778888', 'www.comune.pastrengo.vr.it', 'MHV3NL'),
  ('Comune di Pescantina', 'Pescantina', 'VR', 'Veneto', 17630, '00661770230', 'Via Madonna 49', '37026', 'pescantina.vr@cert.ip-veneto.net', 'protocollo@comune.pescantina.vr.it', '0456764211', 'www.comune.pescantina.vr.it', 'UF3465'),
  ('Comune di Peschiera del Garda', 'Peschiera del Garda', 'VR', 'Veneto', 10905, '00245430236', 'Piazza Betteloni 3', '37019', 'comunepeschieradelgarda@pec.it', null, '0456444717', 'www.comune.peschieradelgarda.vr.it', 'UFZPWN'),
  ('Comune di Povegliano Veronese', 'Povegliano Veronese', 'VR', 'Veneto', 7401, '00658760236', 'Piazza IV Novembre, 3', '37064', 'poveglianoveronese.vr@cert.ip-veneto.net', 'protocollo@comune.poveglianoveronese.vr.it', '0456334111', 'www.comune.poveglianoveronese.vr.it', 'UFDMZ7'),
  ('Comune di Pressana', 'Pressana', 'VR', 'Veneto', 2511, '00663220234', 'Piazza Garibaldi 1', '37040', 'protocollo@pec.comune.pressana.vr.it', 'protocollo@comune.pressana.vr.it', '044284333', 'www.comune.pressana.vr.it', 'UFLXZH'),
  ('Comune di Rivoli Veronese', 'Rivoli Veronese', 'VR', 'Veneto', 2368, '81001170232', 'Piazza Napoleone I 3', '37010', 'protocollo.comune.rivoli.vr@pecveneto.it', 'protocollo@comune.rivoli.vr.it', '0457281166', 'www.comune.rivoli.vr.it', 'UFQ6MU'),
  ('Comune di Roncà', 'Roncà', 'VR', 'Veneto', 3755, '83001150230', 'Piazza G. Marconi, 4', '37030', 'protocollo.comune.ronca.vr@pecveneto.it', 'protocollo@comune.ronca.vr.it', '0457460017', 'https://comune.ronca.vr.it/home', 'UFRIR2'),
  ('Comune di Ronco all''Adige', 'Ronco all''Adige', 'VR', 'Veneto', 6195, '80007680236', 'Piazza Roma 1', '37055', 'protocollo@pec.comune.roncoalladige.vr.it', 'protocollo@comune.roncoalladige.vr.it', null, 'www.comune.roncoalladige.vr.it', 'UFZGKY'),
  ('Comune di Roverchiara', 'Roverchiara', 'VR', 'Veneto', 2596, '82002370235', 'Via Vittorio Veneto, 7', '37050', 'protocollo.comune.roverchiara.vr@legalmail.it', null, '0442689014', 'www.comune.roverchiara.vr.it', 'UFFIB0'),
  ('Comune di Roverè Veronese', 'Roverè Veronese', 'VR', 'Veneto', 2169, '80010130237', 'Piazza Vittorio Emanuele, 12', '37028', 'comune.rovereveronese@pec.it', 'segreteria@comune.rovereveronese.vr.it', '0456518005', 'www.comune.rovereveronese.vr.it', 'UFOSLU'),
  ('Comune di Roveredo di Guà', 'Roveredo di Guà', 'VR', 'Veneto', 1657, '00392460234', 'Via Dante Alighieri, 10', '37040', 'protocollo@pec.comune.roveredodigua.vr.it', 'info@comune.roveredodigua.vr.it', '044286014', 'www.comune.roveredodigua.vr.it', 'UFTRJP'),
  ('Comune di Salizzole', 'Salizzole', 'VR', 'Veneto', 3758, '00709050231', 'Piazza Castello, 1', '37056', 'salizzole.vr@cert.ip-veneto.net', 'info@comune.salizzole.vr.it', '0457100013', 'www.comune.salizzole.vr.it', null),
  ('Comune di San Bonifacio', 'San Bonifacio', 'VR', 'Veneto', 21399, '00220240238', 'Piazza Costituzione 4', '37047', 'sanbonifacio.vr@cert.ip-veneto.net', null, '0456132611', 'www.comune.sanbonifacio.vr.it', null),
  ('Comune di San Giovanni Ilarione', 'San Giovanni Ilarione', 'VR', 'Veneto', 4848, '00540670239', 'P.zza Aldo Moro, 5', '37035', 'protocollo@cert.comune.sangiovanniilarione.vr.it', 'protocollo@comune.sangiovanniilarione.vr.it', '0456550444', 'www.comune.sangiovanniilarione.vr.it/', 'UF76HT'),
  ('Comune di San Giovanni Lupatoto', 'San Giovanni Lupatoto', 'VR', 'Veneto', 25427, '00360350235', 'Via Roma, 18', '37057', 'protocol.comune.sangiovannilupatoto.vr@pecveneto.it', null, '0458290111', 'https://www.comune.sangiovannilupatoto.vr.it', 'UFA9B2'),
  ('Comune di San Martino Buon Albergo', 'San Martino Buon Albergo', 'VR', 'Veneto', 16797, '00333790236', 'Piazza Del Popolo, 36', '37036', 'comune.sanmartinobuonalbergo.vr@pecveneto.it', 'posta@comunesanmartinobuonalbergo.it', null, 'www.comune.sanmartinobuonalbergo.vr.it', 'UFWU0R'),
  ('Comune di San Mauro di Saline', 'San Mauro di Saline', 'VR', 'Veneto', 606, '00669300238', 'Piazza G. Marconi, 1', '37030', 'comune.sanmaurodisaline.vr@pecveneto.it', 'segreteria@comune.sanmaurodisaline.vr.it', '0457840009', 'www.comune.sanmaurodisaline.vr.it', 'UFUGEG'),
  ('Comune di San Pietro di Morubio', 'San Pietro di Morubio', 'VR', 'Veneto', 3145, '82002650230', 'Via Motta, 2', '37050', 'protocollo.sanpietromorubio@legalmail.it', null, '0456969000', 'www.comune.sanpietrodimorubio.vr.it', 'UFLE7D'),
  ('Comune di San Pietro in Cariano', 'San Pietro in Cariano', 'VR', 'Veneto', 12996, '00261520233', 'Via Chopin 3', '37029', 'sanpietroincariano.vr@cert.ip-veneto.net', 'protocollo@comune.sanpietroincariano.vr.it', '0456832111', 'www.comune.sanpietroincariano.vr.it', null),
  ('Comune di San Zeno di Montagna', 'San Zeno di Montagna', 'VR', 'Veneto', 1544, '00414190231', 'Contrada Ca'' Montagna', '37010', 'sanzenodimontagna.vr@cert.ip-veneto.net', null, '0457285950', 'https://comune.sanzenodimontagna.vr.it/', 'UFD2US'),
  ('Comune di Sanguinetto', 'Sanguinetto', 'VR', 'Veneto', 4318, '00661100230', 'Via Interno Castello 2', '37058', 'comune.sanguinetto.vr@pecveneto.it', 'protocollo@comune.sanguinetto.vr.it', '044281066', 'www.comune.sanguinetto.vr.it', null),
  ('Comune di Sant''Ambrogio di Valpolicella', 'Sant''Ambrogio di Valpolicella', 'VR', 'Veneto', 11870, '00242770238', 'Via Sengio,1', '37015', 's.ambrogiovalp@postemailcertificata.it', null, '0456832611', 'www.comune.santambrogio.vr.it', 'UFXQJI'),
  ('Comune di Sant''Anna d''Alfaedo', 'Sant''Anna d''Alfaedo', 'VR', 'Veneto', 2660, '00796760239', 'Via Roma 4', '37020', 'comune.santannadalfaedo.vr@pecveneto.it', 'protocollo@comune.santannadalfaedo.verona.it', '0457532502', 'www.comune.santannadalfaedo.verona.it', 'UFASY9'),
  ('Comune di Selva di Progno', 'Selva di Progno', 'VR', 'Veneto', 921, '83001510235', 'Piazza Prof. B. G. Cappelletti, 1', '37030', 'segreteria.selva@pec.it', 'segreteria@comuneselvadiprogno.it', '3471808248', 'www.comune.selvadiprogno.vr.it', 'UFAZMG'),
  ('Comune di Soave', 'Soave', 'VR', 'Veneto', 7126, '83000070231', 'Via Giulio Camuzzoni, 8', '37038', 'soave.vr@cert.ip-veneto.net', 'info@comunesoave.it', '0454970750', 'www.comune.soave.vr.it', 'UF8S1Q'),
  ('Comune di Sommacampagna', 'Sommacampagna', 'VR', 'Veneto', 14480, '00259810232', 'Piazza Carlo Alberto 1', '37066', 'sommacampagna.vr@cert.ip-veneto.net', 'affari.generali@comune.sommacampagna.vr.it', '0458971329', 'www.comune.sommacampagna.vr.it/', 'UFD4FF'),
  ('Comune di Sona', 'Sona', 'VR', 'Veneto', 17761, '00500760236', 'Piazza Roma, 1', '37060', 'sona.vr@cert.ip-veneto.net', 'protocollo@comune.sona.vr.it', '0456091211', 'www.comune.sona.vr.it', 'UF09I2'),
  ('Comune di Sorgà', 'Sorgà', 'VR', 'Veneto', 2979, '80010830232', 'Piazza Gen. Murari Bra'' 1', '37060', 'protocollo.informatico@pec.comune.sorga.vr.it', null, '0457370000', 'https://comune.sorga.vr.it/', 'UFAPGY'),
  ('Comune di Terrazzo', 'Terrazzo', 'VR', 'Veneto', 2143, '82001090230', 'Piazzale degli Alpini, 1', '37040', 'comune.terrazzo@legalmail.it', 'segreteria@comune.terrazzo.vr.it', '044294013', 'www.comune.terrazzo.vr.it', 'UFRFDC'),
  ('Comune di Torri del Benaco', 'Torri del Benaco', 'VR', 'Veneto', 2856, '00661030239', 'Viale Fratelli Lavanda 3', '37010', 'torridelbenaco.vr@cert.ip-veneto.net', 'comune@comune.torridelbenaco.vr.it', '0456205815', 'www.comune.torridelbenaco.vr.it', 'UFERYI'),
  ('Comune di Tregnago', 'Tregnago', 'VR', 'Veneto', 5065, '00265460238', 'Piazza Abramo Massalongo, 1', '37039', 'comune.tregnago.vr@pecveneto.it', null, '045780803', 'www.comune.tregnago.vr.it', null),
  ('Comune di Trevenzuolo', 'Trevenzuolo', 'VR', 'Veneto', 2801, '80015530233', 'Via Roma, 5', '37060', 'protocollo@pec.comune.trevenzuolo.vr.it', 'segreteria@comune.trevenzuolo.vr.it', '0457350288', 'www.comune.trevenzuolo.vr.it', 'UFKDPJ'),
  ('Comune di Valeggio sul Mincio', 'Valeggio sul Mincio', 'VR', 'Veneto', 16040, '00346630239', 'p. Carlo Alberto 48', '37067', 'protocollo.comune.valeggiosulmincio.vr@pecveneto.it', 'info@comune.valeggiosulmincio.vr.it', '0456339800', 'www.comune.valeggiosulmincio.vr.it', 'UFFS9F'),
  ('Comune di Velo Veronese', 'Velo Veronese', 'VR', 'Veneto', 772, '00658400239', 'Piazza Della Vittoria, 8', '37030', 'comune.velo@pec.it', 'info@comune.veloveronese.vr.it', '0456518016', 'www.veloveronese.net', 'UF5K4S'),
  ('Comune di Verona', 'Verona', 'VR', 'Veneto', 255139, '00215150236', 'Piazza Bra, 1', '37121', 'protocollo.informatico@pec.comune.verona.it', null, null, 'www.comune.verona.it', null),
  ('Comune di Veronella', 'Veronella', 'VR', 'Veneto', 5189, '00323160234', 'Piazza Marconi, 45', '37040', 'protocollo@pec.comune.veronella.vr.it', 'info@comune.veronella.vr.it', '0442450602', 'www.comune.veronella.vr.it', 'UFFLH9'),
  ('Comune di Vestenanova', 'Vestenanova', 'VR', 'Veneto', 2499, '83001690235', 'Piazza Roma, 1', '37030', 'comune.vestenanova@pec.it', 'segreteria@comune.vestenanova.vr.it', '0456564017', 'www.comune.vestenanova.vr.it', 'UF1KLG'),
  ('Comune di Vigasio', 'Vigasio', 'VR', 'Veneto', 10342, '80014290235', 'Via Italo Montemezzi, 17', '37068', 'vigasio.segreteria@halleycert.it', 'segreteria@comune.vigasio.vr.it', '0457363700', 'www.comune.vigasio.vr.it', null),
  ('Comune di Villa Bartolomea', 'Villa Bartolomea', 'VR', 'Veneto', 5895, '82000850238', 'Corso Fraccaroli, 70', '37049', 'segreteria.comune.villa-bartolomea@halleypec.it', 'protocollo@comune.villa-bartolomea.vr.it', '04421833800', 'www.comune.villa-bartolomea.vr.it', 'UFWJEE'),
  ('Comune di Villafranca di Verona', 'Villafranca di Verona', 'VR', 'Veneto', 32785, '00232070235', 'Corso Giuseppe Garibaldi 24', '37069', 'protocollo.comune.villafranca.vr@pecveneto.it', null, '0456339111', 'www.comune.villafranca.vr.it', null),
  ('Comune di Zevio', 'Zevio', 'VR', 'Veneto', 15937, '00660750233', 'Via Ponte Perez, 2', '37059', 'zevio.vr@cert.ip-veneto.net', 'comunedizevio@comune.zevio.vr.it', null, 'www.comune.zevio.vr.it', null),
  ('Comune di Zimella', 'Zimella', 'VR', 'Veneto', 4881, '00631830239', 'Piazza Marconi, 5', '37040', 'info@pec.comune.zimella.vr.it', 'info@zimella.com', '0442490011', 'www.comune.zimella.vr.it', 'UF2N6Q'),
  ('Comune di Acquanegra sul Chiese', 'Acquanegra sul Chiese', 'MN', 'Lombardia', 2722, '00413370206', 'Piazza XXV Aprile, 1', '46011', 'acquanegrasulchiese.mn@legalmail.it', 'protocollo@comune.acquanegra.mn.it', '037679101', 'www.comune.acquanegra.mn.it', 'UFS08E'),
  ('Comune di Asola', 'Asola', 'MN', 'Lombardia', 9870, '81000370205', 'Piazza XX Settembre, 1', '46041', 'comuneasola@legalmail.it', null, '0376733011', 'www.comune.asola.mn.it', 'UFZ0WH'),
  ('Comune di Bagnolo San Vito', 'Bagnolo San Vito', 'MN', 'Lombardia', 5855, '00438900201', 'Via Roma, 29', '46031', 'bagnolosanvito.mn@legalmail.it', null, '0376253100', 'www.comunebagnolosanvito.it', 'UFQ2JT'),
  ('Comune di Borgo Mantovano', 'Borgo Mantovano', 'MN', 'Lombardia', 5379, '02540250202', 'Via Dei Poeti, 3', '46036', 'protocollo@pec.comune.borgomantovano.mn.it', 'protocollo@comune.borgomantovano.mn.it', '038646001', 'www.comune.borgomantovano.mn.it', 'UFODYD'),
  ('Comune di Borgo Virgilio', 'Borgo Virgilio', 'MN', 'Lombardia', 15052, '02423810205', 'Piazza Aldo Moro - Virgilio, 1', '46034', 'protocollo@pec.comune.borgovirgilio.mn.it', null, '0376283011', 'www.comune.borgovirgilio.mn.it', 'UFOGUJ'),
  ('Comune di Borgocarbonara', 'Borgocarbonara', 'MN', 'Lombardia', 1872, '02575310202', 'Strada Provinciale Ferrarese, 35', '46020', 'protocollo@pec.comune.borgocarbonara.mn.it', null, '038641549', 'www.comune.borgocarbonara.mn.it', 'UFVXTT'),
  ('Comune di Bozzolo', 'Bozzolo', 'MN', 'Lombardia', 4081, '00185780202', 'Piazza Europa 1', '46012', 'comune.bozzolo@pec.regione.lombardia.it', 'ufficioragioneria@comune.bozzolo.mn.it', '0376910845', 'www.comune.bozzolo.mn.it', 'UFNI4M'),
  ('Comune di Canneto sull''Oglio', 'Canneto sull''Oglio', 'MN', 'Lombardia', 4445, '81001310200', 'Piazza Matteotti, 1', '46013', 'cannetosulloglio.mn@legalmail.it', null, '037671700', 'www.comune.canneto.mn.it', 'UFQZ39'),
  ('Comune di Casalmoro', 'Casalmoro', 'MN', 'Lombardia', 2216, '81000490201', 'Via Pietro Nenni 33', '46040', 'casalmoro.mn@legalmail.it', 'protocollo@comune.casalmoro.mn.it', null, 'www.comune.casalmoro.mn.it', 'UFGYIB'),
  ('Comune di Casaloldo', 'Casaloldo', 'MN', 'Lombardia', 2624, '81000510206', 'Via Roma 8', '46040', 'comune.casaloldo@pec.regione.lombardia.it', 'info@comune.casaloldo.mn.it', '037373211', 'https://www.comune.casaloldo.mn.it/', 'UFSZB0'),
  ('Comune di Casalromano', 'Casalromano', 'MN', 'Lombardia', 1498, '81000430207', 'P.zza Cesare Battisti 9', '46040', 'casalromano.mn@legalmail.it', null, '0376714311', 'https://www.comune.casalromano.mn.it/it-it/home', 'UFAVF8'),
  ('Comune di Castel d''Ario', 'Castel d''Ario', 'MN', 'Lombardia', 4663, '00413950205', 'Corso Garibaldi, 54', '46033', 'comune.casteldario@pec.regione.lombardia.it', 'protocollo@comune.casteldario.mn.it', '0376660140', 'www.comune.casteldario.mn.it', 'UFMCQ2'),
  ('Comune di Castel Goffredo', 'Castel Goffredo', 'MN', 'Lombardia', 12732, '81001030204', 'Piazza Mazzini, 1', '46042', 'comunedicastelgoffredo.mn@legalmail.it', 'info@comune.castelgoffredo.mn.it', '03767771', 'https://www.comune.castelgoffredo.mn.it', 'UF1UQ6'),
  ('Comune di Castelbelforte', 'Castelbelforte', 'MN', 'Lombardia', 3381, '00394850200', 'Via Roma 33', '46032', 'protocollo.comune.castelbelforte@pec.regione.lombardia.it', 'info@comunecastelbelforte.it', '0376259211', 'www.comune.castelbelforte.mn.it', null),
  ('Comune di Castellucchio', 'Castellucchio', 'MN', 'Lombardia', 5161, '00436640205', 'Piazza Pasotti, 14', '46014', 'comune.castellucchio@pec.regione.lombardia.it', 'ufficio.segreteria@comune.castellucchio.mn.it', '03764343217', 'www.comune.castellucchio.mn.it', 'UFDXTF'),
  ('Comune di Castiglione delle Stiviere', 'Castiglione delle Stiviere', 'MN', 'Lombardia', 23950, '00152550208', 'Via C. Battisti, 4', '46043', 'protocollo@pec.comune.castiglione.mn.it', 'protocollo@comune.castiglione.mn.it', null, 'www.comune.castiglione.mn.it', 'UFC2VM'),
  ('Comune di Cavriana', 'Cavriana', 'MN', 'Lombardia', 3654, '00223070202', 'Via Porta Antica, 23', '46040', 'comune.cavriana@pec.it', 'comune@comune.cavriana.mn.it', '0376811411', 'www.comune.cavriana.mn.it', 'UF1AKA'),
  ('Comune di Ceresara', 'Ceresara', 'MN', 'Lombardia', 2465, '00493530208', 'Piazza Castello nr. 25', '46040', 'ceresara.mn@legalmail.it', 'segreteria@comune.ceresara.mn.it', '0376814011', 'www.comune.ceresara.mn.it', 'UFQXUW'),
  ('Comune di Commessaggio', 'Commessaggio', 'MN', 'Lombardia', 1022, '83000510202', 'Piazza Italia N. 1', '46010', 'comune.commessaggio@pec.regione.lombardia.it', 'segreteria@comune.commessaggio.mn.it', '037698121', 'www.comune.commessaggio.mn.it', 'UFN4AO'),
  ('Comune di Curtatone', 'Curtatone', 'MN', 'Lombardia', 14691, '80001910209', 'Piazza Corte Spagnola, 3', '46010', 'comune.curtatone@legalmail.it', null, '0376358112', 'www.comune.curtatone.mn.it', 'UF5N42'),
  ('Comune di Dosolo', 'Dosolo', 'MN', 'Lombardia', 3155, '83000130209', 'Piazza Garibaldi 3', '46030', 'segreteria.comune.dosolo@pec.regione.lombardia.it', 'segreteria@comune.dosolo.mn.it', '037589573', 'www.comune.dosolo.mn.it', 'UFR9WJ'),
  ('Comune di Gazoldo degli Ippoliti', 'Gazoldo degli Ippoliti', 'MN', 'Lombardia', 3046, '80025260201', 'Via Guglielmo Marconi, 126', '46040', 'comune.gazoldoippoliti@pec.regione.lombardia.it', 'protocollo@comune.gazoldo.mn.it', '0376657141', 'www.comune.gazoldo.mn.it', 'UFXLJA'),
  ('Comune di Gazzuolo', 'Gazzuolo', 'MN', 'Lombardia', 2035, '00387350200', 'Piazza G. Garibaldi, 1', '46010', 'comune.gazzuolo@pec.regione.lombardia.it', null, '0376924922', 'www.comune.gazzuolo.mn.it', '6R1JM7'),
  ('Comune di Goito', 'Goito', 'MN', 'Lombardia', 10135, '81000670208', 'Piazza Antonio Gramsci 8', '46044', 'comune.goito@pec.regione.lombardia.it', 'info@comune.goito.mn.it', '0376683311', 'www.comune.goito.mn.it', 'UFO1XI'),
  ('Comune di Gonzaga', 'Gonzaga', 'MN', 'Lombardia', 8574, '00253340202', 'Piazza Castello, 1', '46023', 'gonzaga.mn@legalmail.it', null, '0376526311', 'www.comune.gonzaga.mn.it', 'UFA90C'),
  ('Comune di Guidizzolo', 'Guidizzolo', 'MN', 'Lombardia', 6045, '81000790204', 'P.zzle Marconi 1', '46040', 'guidizzolo.mn@legalmail.it', 'protocollo@comune.guidizzolo.mn.it', '03761620401', 'www.comune.guidizzolo.mn.it', 'UFGS8M'),
  ('Comune di Magnacavallo', 'Magnacavallo', 'MN', 'Lombardia', 1399, '80004910206', 'Piazza G.Marconi, 5', '46020', 'comune.magnacavallo@pec.regione.lombardia.it', 'ufficio.segreteria@comune.magnacavallo.mn.it', '038655151', 'www.comune.magnacavallo.mn.it', 'UF7LGV'),
  ('Comune di Mantova', 'Mantova', 'MN', 'Lombardia', 50215, '00189800204', 'Via Roma, 39', '46100', 'comune.mantova.aoo@legalmail.it', null, null, 'www.comune.mantova.it', 'UF3N9D'),
  ('Comune di Marcaria', 'Marcaria', 'MN', 'Lombardia', 6338, '00416240208', 'Via Francesco Crispi n.81', '46010', 'marcaria.mn@legalmail.it', null, '0376953018', 'www.comune.marcaria.mn.it', 'UFW7EX'),
  ('Comune di Mariana Mantovana', 'Mariana Mantovana', 'MN', 'Lombardia', 794, '81001210202', 'Piazza Castello 2/3', '46010', 'comune.mariana-mantovana@pec.regione.lombardia.it', 'comunedimariana@tin.it', null, 'www.comune.mariana.mn.it', 'UFOCTL'),
  ('Comune di Marmirolo', 'Marmirolo', 'MN', 'Lombardia', 7653, '80004530202', 'Piazza Roma, 2', '46045', 'protocollo@comunemarmirolo.legalmail.it', null, '0376298523', 'www.comune.marmirolo.mn.it/', 'UFO05E'),
  ('Comune di Medole', 'Medole', 'MN', 'Lombardia', 4243, '00437020209', 'Via Roma,10', '46046', 'medole.mn@legalmail.it', 'amministrazione@comune.medole.mn.it', '0376868001', 'www.comune.medole.mn.it', 'UF56P6'),
  ('Comune di Moglia', 'Moglia', 'MN', 'Lombardia', 5394, '00261470207', 'Piazza Matteotti, 2', '46024', 'comune.moglia@pec.regione.lombardia.it', null, '0376511432', 'www.comune.moglia.mn.it', 'UFU14B'),
  ('Comune di Monzambano', 'Monzambano', 'MN', 'Lombardia', 4805, '00159460203', 'Piazza Vittorio Emanuele III N. 15', '46040', 'monzambano.mn@legalmail.it', null, '0376800502', 'www.comune.monzambano.mn.it', 'UFKYKE'),
  ('Comune di Motteggiana', 'Motteggiana', 'MN', 'Lombardia', 2408, '82000050201', 'Via Roma, 10', '46020', 'servizi.amministrativi@pec.comune.motteggiana.mn.it', null, '0376527043', 'www.comune.motteggiana.mn.it', 'UFOT6T'),
  ('Comune di Ostiglia', 'Ostiglia', 'MN', 'Lombardia', 6849, '00199290206', 'Via Gnocchi Viani, 16', '46035', 'comune.ostiglia@pec.regione.lombardia.it', 'ufficio.ragioneria@comune.ostiglia.mn.it', '0386300211', 'www.comune.ostiglia.mn.it', 'UF2FOB'),
  ('Comune di Pegognaga', 'Pegognaga', 'MN', 'Lombardia', 6972, '00217110204', 'Piazza Matteotti 1', '46020', 'pegognaga.mn@legalmail.it', 'protocollo@comune.pegognaga.mn.it', '03765546206', 'www.comune.pegognaga.mn.it', 'UFE4FQ'),
  ('Comune di Piubega', 'Piubega', 'MN', 'Lombardia', 1747, '81001230200', 'Via IV Novembre, 2', '46040', 'protocollo@pec.comune.piubega.mn.it', 'protocollo@comune.piubega.mn.it', '0376655656', 'www.comune.piubega.mn.it', 'UFM8C1'),
  ('Comune di Poggio Rusco', 'Poggio Rusco', 'MN', 'Lombardia', 6255, '00402030209', 'Piazza I Maggio, 5', '46025', 'comune.poggiorusco@pec.regione.lombardia.it', 'protocollo@comune.poggiorusco.mn.it', '038651001', 'www.comune.poggiorusco.mn.it', null),
  ('Comune di Pomponesco', 'Pomponesco', 'MN', 'Lombardia', 1757, '83000230207', 'Piazza XXIII Aprile, 11', '46030', 'comune.pomponesco@pec.regione.lombardia.it', 'segreteria@comune.pomponesco.mn.it', '037586021', 'www.comune.pomponesco.mn.it', 'UF2BLF'),
  ('Comune di Ponti sul Mincio', 'Ponti sul Mincio', 'MN', 'Lombardia', 2277, '00159450204', 'Piazza Parolini 32', '46040', 'protocollo.comune.pontisulmincio@dominiopec.it', 'info@comune.pontisulmincio.mn.it', '037688121', 'www.comune.pontisulmincio.mn.it', 'UFMLN1'),
  ('Comune di Porto Mantovano', 'Porto Mantovano', 'MN', 'Lombardia', 16715, '80002770206', 'Strada Cisa, 112', '46047', 'comuneportomantovano@legalmail.it', 'protocollo@comune.porto-mantovano.mn.it', null, 'www.comune.porto-mantovano.mn.it', 'UFVEKF'),
  ('Comune di Quingentole', 'Quingentole', 'MN', 'Lombardia', 1016, '80006430203', 'Piazza Italia 24', '46020', 'comunequingentole@pec.it', 'ragioneria@comune.quingentole.mn.it', '038642141', 'www.comune.quingentole.mn.it', 'UFFFGC'),
  ('Comune di Quistello', 'Quistello', 'MN', 'Lombardia', 5281, '00163620206', 'Piazza G. Matteotti, 1', '46026', 'comune.quistello@pec.regione.lombardia.it', 'protocollo@comune.quistello.mn.it', '376627201', 'www.comune.quistello.mn.it', 'UFXG98'),
  ('Comune di Redondesco', 'Redondesco', 'MN', 'Lombardia', 1188, '81001250208', 'P.zza Castello 8', '46010', 'redondesco@postemailcertificata.it', null, '0376954141', 'www.comune.redondesco.mn.it', 'UFM9S9'),
  ('Comune di Rivarolo Mantovano', 'Rivarolo Mantovano', 'MN', 'Lombardia', 2302, '00393230206', 'Via Gonzaga N.39', '46017', 'comune.rivarolo.mn@legalmail.it', null, '037699101', 'www.comune.rivarolo.mn.it', 'UFA5HI'),
  ('Comune di Rodigo', 'Rodigo', 'MN', 'Lombardia', 5174, '80005810207', 'Piazza Ippolito Nievo, 3', '46040', 'comune.rodigo@pec.regione.lombardia.it', null, null, 'www.comune.rodigo.mn.it', 'UFC62D'),
  ('Comune di Roncoferraro', 'Roncoferraro', 'MN', 'Lombardia', 6935, '80001670209', 'Via Roma 11', '46037', 'protocollo.comune.roncoferraro@pec.regione.lombardia.it', 'segreteria@comune.roncoferraro.mn.it', '03766629202', 'www.comune.roncoferraro.mn.it', 'UFWX5Y'),
  ('Comune di Roverbella', 'Roverbella', 'MN', 'Lombardia', 8714, '80005630209', 'Via Solferino e San Martino, 1', '46048', 'roverbella.mn@legalmail.it', 'segreteria@comune.roverbella.mn.it', null, 'www.comune.roverbella.mn.it', null),
  ('Comune di Sabbioneta', 'Sabbioneta', 'MN', 'Lombardia', 4076, '83000390209', 'Piazza Ducale N. 2', '46018', 'comune.sabbioneta@pec.regione.lombardia.it', 'protocollo@comune.sabbioneta.mn.it', '0375223001', 'www.comune.sabbioneta.mn.it', 'UFVN2C'),
  ('Comune di San Benedetto Po', 'San Benedetto Po', 'MN', 'Lombardia', 6792, '00272230202', 'Via E. Ferri, 79', '46027', 'protocollo.sanbenedetto@legalmailpa.it', null, '0376623011', 'www.comune.san-benedetto-po.mn.it', 'UFZT5D'),
  ('Comune di San Giacomo delle Segnate', 'San Giacomo delle Segnate', 'MN', 'Lombardia', 1508, '00453060204', 'Via Ugo Roncada, 68', '46020', 'comune.sangiacomodellesegnate@legalmail.it', 'protocollo@comunesangiacomodellesegnate.it', '0376616101', 'www.comune.san-giacomo-delle-segnate.mn.it', 'UFQKW8'),
  ('Comune di San Giorgio Bigarello', 'San Giorgio Bigarello', 'MN', 'Lombardia', 11958, '80004610202', 'Piazza Repubblica 8', '46030', 'comune.sangiorgio-bigarello@pec.regione.lombardia.it', null, '0376273111', 'http://www.comune.sangiorgiobigarello.mn.it/', 'UFH1ED'),
  ('Comune di San Giovanni del Dosso', 'San Giovanni del Dosso', 'MN', 'Lombardia', 1244, '80004650208', 'Via Roma, 31', '46020', 'comune.sangiovannideldosso@pec.regione.lombardia.it', null, null, 'www.comune.sangiovannideldosso.mn.it', 'UFS4I0'),
  ('Comune di San Martino dall''Argine', 'San Martino dall''Argine', 'MN', 'Lombardia', 1604, '00416220200', 'Via Garibaldi 6', '46010', 'comune.sanmartinodallargine@pec.regione.lombardia.it', 'segreteria@comune.sanmartinodallargine.mn.it', '0376922022', 'www.comune.sanmartinodallargine.mn.it', 'WGSD6O'),
  ('Comune di Schivenoglia', 'Schivenoglia', 'MN', 'Lombardia', 1135, '80001990201', 'Via G. Matteotti, 22', '46020', 'comune.schivenoglia@pec.regione.lombardia.it', 'segreteria@comune.schivenoglia.mn.it', '3311264039', 'www.comune.schivenoglia.mn.it', 'UFCS7L'),
  ('Comune di Sermide e Felonica', 'Sermide e Felonica', 'MN', 'Lombardia', 7040, '00309830206', 'Piazza Plebiscito, 1', '46028', 'segreteria@pec.comune.sermide.mn.it', 'segreteria@comune.sermideefelonica.mn.it', '0386967013', 'www.comune.sermideefelonica.mn.it', 'UFIXQ2'),
  ('Comune di Serravalle a Po', 'Serravalle a Po', 'MN', 'Lombardia', 1474, '80007050208', 'Piazza Guglielmo Marconi n. 5', '46030', 'comune.serravalleapo@pec.regione.lombardia.it', null, '0386840111', 'www.comune.serravalleapo.mn.it', 'UFIYWO'),
  ('Comune di Solferino', 'Solferino', 'MN', 'Lombardia', 2639, '00206590200', 'Piazza Luigi Torelli 1', '46040', 'protocollo.comune.solferino@pec.regione.lombardia.it', null, '03761621851', 'comune.solferino.mn.it', 'UFHY0H'),
  ('Comune di Sustinente', 'Sustinente', 'MN', 'Lombardia', 1986, '80006510202', 'Via XX Settembre 108', '46030', 'comunesustinente@pec.it', 'segreteria@comune.sustinente.mn.it', null, 'www.comune.sustinente.mn.it', 'UFVUUB'),
  ('Comune di Suzzara', 'Suzzara', 'MN', 'Lombardia', 21318, '00178480208', 'Piazza Castello, 1', '46029', 'protocollo@comune.suzzara.mn.legalmail.it', null, '0376513205', 'www.comune.suzzara.mn.it', 'UFUIMU'),
  ('Comune di Viadana', 'Viadana', 'MN', 'Lombardia', 19787, '83000670204', 'p. Matteotti, 2', '46019', 'urp@pec.comune.viadana.mn.it', null, '0375786308', 'www.comune.viadana.mn.it', 'UFC7Z8'),
  ('Comune di Villimpenta', 'Villimpenta', 'MN', 'Lombardia', 2152, '00389360207', 'Via Roma, 26', '46039', 'comune.villimpenta@pec.regione.lombardia.it', 'segreteria@comune.villimpenta.mn.it', '0376667508', 'www.comune.villimpenta.mn.it', 'UF6JQ4'),
  ('Comune di Volta Mantovana', 'Volta Mantovana', 'MN', 'Lombardia', 7248, '00228490207', 'Via Beata Paola Montaldi n. 15', '46049', 'voltamantovana.mn@legalmail.it', null, '0376839411', 'https://www.comune.volta.mn.it/', 'UFU2DZ');

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
where lower(c.name) = lower(v.name);

-- 2) Comuni mancanti: li inserisce
insert into companies (name, tipo, citta, provincia, regione, abitanti, piva,
                       address, cap, pec, email, phone, website, codice_univoco)
select v.name, 'pa', v.citta, v.provincia, v.regione, v.abitanti, v.cf,
       v.indirizzo, v.cap, v.pec, v.email, v.telefono, v.sito, v.codice_univoco
from _comuni v
where not exists (select 1 from companies c where lower(c.name) = lower(v.name));

drop table if exists _comuni;

-- Controllo: VR = 98 comuni / 930.842 ab.; MN = 64 comuni / 408.715 ab.
select provincia, count(*) as comuni, sum(abitanti) as abitanti,
       count(pec) as con_pec, count(email) as con_email, count(phone) as con_telefono
from companies
where tipo = 'pa' and name ilike 'Comune di %' and provincia in ('VR','MN')
group by provincia order by provincia;

