-- =====================================================================
--  CRM ENER.ING — Comuni di MILANO (Città Metropolitana, 133) e LODI (60)
--  Un unico file: contiene due blocchi uguali, uno per provincia.
--  Esegui tutto insieme nel SQL Editor di Supabase ("Run without RLS").
-- =====================================================================

-- =====================================================================
--  CRM ENER.ING — Comuni della provincia di Milano (Città Metropolitana) con abitanti e contatti
--  Esegui nel SQL Editor di Supabase. Sicuro e ri-eseguibile (non cancella nulla):
--   * aggiunge ai clienti le colonne "abitanti" ed "email" (se mancano);
--   * inserisce i 133 Comuni della provincia di Milano (Città Metropolitana) come clienti PA;
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
  ('Comune di Abbiategrasso', 'Abbiategrasso', 'MI', 'Lombardia', 32793, '01310880156', 'Piazza Guglielmo Marconi 1', '20081', 'comune.abbiategrasso@legalpec.it', 'protocollo@comune.abbiategrasso.mi.it', '02946921', 'www.comune.abbiategrasso.mi.it', null),
  ('Comune di Albairate', 'Albairate', 'MI', 'Lombardia', 4719, '03623810151', 'Via Cesare Battisti,2', '20080', 'comune.albairate.mi@pec.it', 'ragioneria@comune.albairate.mi.it', '0294981308', 'www.comune.albairate.mi.it', 'UFW3XO'),
  ('Comune di Arconate', 'Arconate', 'MI', 'Lombardia', 6871, '01336730153', 'Via Roma n.42', '20020', 'comune.arconate@postecert.it', null, '0331460461', 'www.arconate.org', 'UFJ3OB'),
  ('Comune di Arese', 'Arese', 'MI', 'Lombardia', 19545, '03366130155', 'Via Roma, 2', '20020', 'protocollo@cert.comune.arese.mi.it', null, null, 'www.comune.arese.mi.it', 'UFNGGO'),
  ('Comune di Arluno', 'Arluno', 'MI', 'Lombardia', 12615, '02938070154', 'Piazza De Gasperi, 7', '20010', 'comune.arluno@pec.regione.lombardia.it', 'protocollo@comune.arluno.mi.it', '029039921', 'www.comune.arluno.mi.it', 'UF352D'),
  ('Comune di Assago', 'Assago', 'MI', 'Lombardia', 9348, '80101990150', 'Via Dei Caduti 7', '20090', 'sportello.cittadino@assago.legalmail.it', null, '02457821', 'www.comune.assago.mi.it', 'UFIRGE'),
  ('Comune di Baranzate', 'Baranzate', 'MI', 'Lombardia', 12129, '04669050967', 'Via Primo Maggio, 30', '20021', 'protocollo@pec.comune.baranzate.mi.it', null, '0291246918', 'www.comune.baranzate.mi.it', 'UF64BD'),
  ('Comune di Bareggio', 'Bareggio', 'MI', 'Lombardia', 17271, '82000710150', 'Piazza Cavour snc', '20010', 'comune.bareggio@pec.regione.lombardia.it', null, null, 'www.comune.bareggio.mi.it', 'UFUD47'),
  ('Comune di Basiano', 'Basiano', 'MI', 'Lombardia', 3645, '83504250156', 'Via Roma N. 11', '20060', 'basiano@pec.it', null, '029500451', 'www.unione.basianomasate.mi.it', 'UFY7WC'),
  ('Comune di Basiglio', 'Basiglio', 'MI', 'Lombardia', 8027, '80109890154', 'Piazza Leonardo Da Vinci 1', '20080', 'basiglio@postacert.comune.basiglio.mi.it', null, '02904521', 'www.comune.basiglio.mi.it', null),
  ('Comune di Bellinzago Lombardo', 'Bellinzago Lombardo', 'MI', 'Lombardia', 3728, '01554230159', 'Via Roma N. 46', '20060', 'protocollo.bellinzagolombardo@pec.it', 'segreteria.bellinzagolombardo@unioneaddamartesana.it', '0295385012', 'www.comune.bellinzagolombardo.mi.it', 'UFIK3V'),
  ('Comune di Bernate Ticino', 'Bernate Ticino', 'MI', 'Lombardia', 2919, '03365620156', 'Piazza Della Pace snc', '20010', 'bernateticino@legalmail.it', null, '029754002', 'www.comune.bernateticino.mi.it', 'UFWMA2'),
  ('Comune di Besate', 'Besate', 'MI', 'Lombardia', 2050, '04935080152', 'Via Duca Uberto, 5', '20080', 'protocollo@pec.comune.besate.mi.it', 'segreteria@comune.besate.mi.it', '029050906', 'www.comune.besate.mi.it', 'UFAD6T'),
  ('Comune di Binasco', 'Binasco', 'MI', 'Lombardia', 7068, '80121330155', 'Via Matteotti - Castello Visconteo', '20082', 'comune.binasco@legalmail.it', null, '029057811', 'www.comune.binasco.mi.it', 'UFB7NG'),
  ('Comune di Boffalora sopra Ticino', 'Boffalora sopra Ticino', 'MI', 'Lombardia', 4104, '02030870154', 'Piazza 4 Giugno, 2', '20010', 'comune.boffaloraticino@pec.it', 'protocollo@boffaloraticino.it', '029723811', 'https://comune.boffalorasopraticino.mi.it/', 'UFY4L7'),
  ('Comune di Bollate', 'Bollate', 'MI', 'Lombardia', 36754, '00801220153', 'Piazza Aldo Moro, 1', '20021', 'comune.bollate@legalmail.it', null, null, 'www.comune.bollate.mi.it', 'UFS087'),
  ('Comune di Bresso', 'Bresso', 'MI', 'Lombardia', 26672, '00935810150', 'Via Roma, 25', '20091', 'comune.bresso@legalmail.it', null, '02614551', 'www.bresso.net', 'UFRX2C'),
  ('Comune di Bubbiano', 'Bubbiano', 'MI', 'Lombardia', 2446, '80137950152', 'Piazza Vittorio Veneto, 16', '20080', 'protocollo.comune.bubbiano@pec.it', 'protocollo@comune.bubbiano.mi.it', '0290848838', 'www.comune.bubbiano.mi.it', 'UF603K'),
  ('Comune di Buccinasco', 'Buccinasco', 'MI', 'Lombardia', 26345, '03482920158', 'Via Roma 2', '20090', 'protocollo@cert.legalmail.it', null, '02457971', 'www.comune.buccinasco.mi.it', 'UFYJC9'),
  ('Comune di Buscate', 'Buscate', 'MI', 'Lombardia', 4696, '03391930157', 'Piazza San Mauro, 1', '20010', 'protocollo.buscate@legalmail.it', null, '0331800161', 'www.comune.buscate.mi.it', 'UF0QNQ'),
  ('Comune di Bussero', 'Bussero', 'MI', 'Lombardia', 8386, '03063770154', 'Piazza Diritti Dei Bambini, 1', '20060', 'protocollo.bussero@pec.it', null, '02953331', 'www.comune.bussero.mi.it', null),
  ('Comune di Busto Garolfo', 'Busto Garolfo', 'MI', 'Lombardia', 14131, '00873100150', 'P.zza Diaz, 1', '20020', 'protocollo.bustogarolfo@sicurezzapostale.it', 'protocollo@comune.bustogarolfo.mi.it', '0331562011', 'www.comune.bustogarolfo.mi.it', 'UFBAJI'),
  ('Comune di Calvignasco', 'Calvignasco', 'MI', 'Lombardia', 1201, '80105450151', 'Via Fiume, 5', '20080', 'segreteria.calvignasco@pec.it', 'segreteria@comune.calvignasco.mi.it', null, 'www.comune.calvignasco.mi.it', 'UFGXO6'),
  ('Comune di Cambiago', 'Cambiago', 'MI', 'Lombardia', 7331, '02516430150', 'Via Indipendenza, 1', '20040', 'protocollo@pec.comunecambiago.com', null, null, 'www.comune.cambiago.mi.it', 'UF8GLJ'),
  ('Comune di Canegrate', 'Canegrate', 'MI', 'Lombardia', 12889, '00835500158', 'Via Alessandro Manzoni, 1', '20010', 'comune.canegrate@pec.regione.lombardia.it', 'info@comune.canegrate.mi.it', '0331463811', 'www.comune.canegrate.mi.it/', null),
  ('Comune di Carpiano', 'Carpiano', 'MI', 'Lombardia', 4119, '84501650158', 'Via San Martino, 12', '20080', 'comune.carpiano@pec.regione.lombardia.it', 'finanziaria@comune.carpiano.mi.it', '02985094151', 'www.comune.carpiano.mi.it/', 'UFMCDQ'),
  ('Comune di Carugate', 'Carugate', 'MI', 'Lombardia', 15763, '02182060158', 'Via XX Settembre 4', '20061', 'comune.carugate@legalmail.it', null, '02921581', 'www.comune.carugate.mi.it', null),
  ('Comune di Casarile', 'Casarile', 'MI', 'Lombardia', 3929, '80100370156', 'Piazza Comunale, 2', '20080', 'protocollo@pec.comune.casarile.mi.it', null, '0290579332', 'www.comune.casarile.mi.it', 'UFP0FK'),
  ('Comune di Casorezzo', 'Casorezzo', 'MI', 'Lombardia', 5721, '01082050152', 'Largo Alcide De Gasperi n. 1', '20010', 'comune.casorezzo@postecert.it', 'protocollo@comune.casorezzo.mi.it', '029010012', 'www.comune.casorezzo.mi.it', 'UFJDUX'),
  ('Comune di Cassano d''Adda', 'Cassano d''Adda', 'MI', 'Lombardia', 19980, '03674570159', 'Piazza Matteotti, 1', '20062', 'protocollo@comune.cassanodadda.mi.legalmail.it', null, '0363366011', 'www.comune.cassanodadda.mi.it', 'UF3R24'),
  ('Comune di Cassina de'' Pecchi', 'Cassina de'' Pecchi', 'MI', 'Lombardia', 13955, '83500570151', 'Piazza DE'' GASPERI 1', '20060', 'protocollo@pec.comune.cassinadepecchi.mi.it', null, '02954401', 'www.comune.cassinadepecchi.mi.it', 'UFQMMU'),
  ('Comune di Cassinetta di Lugagnano', 'Cassinetta di Lugagnano', 'MI', 'Lombardia', 1967, '03621920150', 'Piazza G. Negri, 3', '20081', 'comune.cassinettadilugagnano@pec.regione.lombardia.it', 'segreteria@comune.cassinettadilugagnano.mi.it', '0286894035', 'www.comune.cassinettadilugagnano.mi.it', 'UFNZM4'),
  ('Comune di Castano Primo', 'Castano Primo', 'MI', 'Lombardia', 10931, '01639920154', 'Villa Rusconi Corso Roma', '20022', 'protocollo@cert.comune.castanoprimo.mi.it', null, '033188801', 'www.comune.castanoprimo.mi.it', 'UF90EV'),
  ('Comune di Cernusco sul Naviglio', 'Cernusco sul Naviglio', 'MI', 'Lombardia', 34840, '01217430154', 'Via Tizzoni, 2', '20063', 'comune.cernuscosulnaviglio@pec.regione.lombardia.it', null, '0292781', 'www.comune.cernuscosulnaviglio.mi.it', 'UFGYK9'),
  ('Comune di Cerro al Lambro', 'Cerro al Lambro', 'MI', 'Lombardia', 5211, '84503860151', 'Piazza Roma, 11', '20070', 'cerroallambro@pacertificata.it', 'protocollo@comune.cerroallambro.mi.it', '0298204038', 'www.comune.cerroallambro.mi.it', 'UFHQST'),
  ('Comune di Cerro Maggiore', 'Cerro Maggiore', 'MI', 'Lombardia', 15192, '01230310151', 'v. San Carlo, 17', '20023', 'protocollo.cerromaggiore@legalmail.it', null, '0331423654', 'www.cerromaggiore.org', 'UFV5BR'),
  ('Comune di Cesano Boscone', 'Cesano Boscone', 'MI', 'Lombardia', 23285, '80098810155', 'Via Pogliani, 3', '20090', 'protocollo@pec.comune.cesano-boscone.mi.it', 'urp@comune.cesano-boscone.mi.it', '02486941', 'www.comune.cesano-boscone.mi.it', 'UF3KKN'),
  ('Comune di Cesate', 'Cesate', 'MI', 'Lombardia', 14364, '80100990151', 'Via Don Oreste Moretti 10', '20031', 'protocollo@comune.cesate.mi.legalmail.it', 'protocollo@comune.cesate.mi.it', '02994711', 'www.comune.cesate.mi.it', 'UFX0XU'),
  ('Comune di Cinisello Balsamo', 'Cinisello Balsamo', 'MI', 'Lombardia', 75154, '01971350150', 'Via XXV Aprile, 4', '20092', 'comune.cinisellobalsamo@pec.regione.lombardia.it', null, '02660231', 'www.comune.cinisello-balsamo.mi.it', 'UFJO5M'),
  ('Comune di Cisliano', 'Cisliano', 'MI', 'Lombardia', 5200, '82003070156', 'Via Piave,9', '20080', 'protocollo@pec.comune.cisliano.mi.it', 'ufficiotecnico@comune.cisliano.mi.it', '0290387042', 'www.comune.cisliano.mi.it', 'UFFHSH'),
  ('Comune di Cologno Monzese', 'Cologno Monzese', 'MI', 'Lombardia', 47179, '03353020153', 'Via Mazzini, 9', '20093', 'protocollo.comunecolognomonzese@legalmail.it', 'urp@comune.colognomonzese.mi.it', '02253081', 'www.comune.colognomonzese.mi.it', 'UFS2DW'),
  ('Comune di Colturano', 'Colturano', 'MI', 'Lombardia', 2056, '84503720157', 'Via Municipio 1', '20060', 'comune.colturano@pec.regione.lombardia.it', 'segreteria@comune.colturano.mi.it', '0298170118', 'https://comune.colturano.mi.it/', 'UFQ4PY'),
  ('Comune di Corbetta', 'Corbetta', 'MI', 'Lombardia', 19156, '03122360153', 'Via Carlo Cattaneo 25', '20011', 'comune.corbetta@postemailcertificata.it', 'ufficioprotocollo@comune.corbetta.mi.it', '0297204211', 'www.comune.corbetta.mi.it', 'UF5JYB'),
  ('Comune di Cormano', 'Cormano', 'MI', 'Lombardia', 21036, '01086310156', 'Piazza Scurati,1', '20032', 'comune.cormano@comune.cormano.mi.legalmailpa.it', null, '02663241', 'www.comune.cormano.mi.it', 'UFW2Q9'),
  ('Comune di Cornaredo', 'Cornaredo', 'MI', 'Lombardia', 20746, '02981700152', 'Piazza Liberta'''', 24', '20010', 'protocollo@pec.comune.cornaredo.mi.it', 'segreteriagenerale@comune.cornaredo.mi.it', '0293263258', 'www.comune.cornaredo.mi.it', 'UFXSQK'),
  ('Comune di Corsico', 'Corsico', 'MI', 'Lombardia', 34811, '00880000153', 'Via Roma 18', '20094', 'ufficioprotocollo@cert.comune.corsico.mi.it', 'ufficio.protocollo@comune.corsico.mi.it', '024480210', 'www.comune.corsico.mi.it', 'UFMZ94'),
  ('Comune di Cuggiono', 'Cuggiono', 'MI', 'Lombardia', 8198, '00861770154', 'Piazza XXV Aprile, 4', '20012', 'comune.cuggiono@postecert.it', 'segreteria@comune.cuggiono.mi.it', '02972631', 'www.comune.cuggiono.mi.it', null),
  ('Comune di Cusago', 'Cusago', 'MI', 'Lombardia', 4869, '80095950152', 'Piazza Soncino', '20090', 'protocollo.cusago.pec@legalmail.it', 'protocollo@comune.cusago.mi.it', '0290166207', 'www.comune.cusago.mi.it/', 'AEGFMM'),
  ('Comune di Cusano Milanino', 'Cusano Milanino', 'MI', 'Lombardia', 18994, '83005680158', 'Piazza Martiri Di Tienanmen 1', '20095', 'comune.cusano-milanino@pec.regione.lombardia.it', null, null, 'www.comune.cusano-milanino.mi.it', 'UFJ3L9'),
  ('Comune di Dairago', 'Dairago', 'MI', 'Lombardia', 6346, '01068100153', 'Via Damiano Chiesa 14', '20020', 'comune.dairago@postecert.it', 'protocollo@comune.dairago.mi.it', '0331431517', 'www.comune.dairago.mi.it', 'UFFKL4'),
  ('Comune di Dresano', 'Dresano', 'MI', 'Lombardia', 3054, '84503760153', 'Via Roma 3', '20070', 'comune.dresano@pec.regione.lombardia.it', 'ragioneria@comune.dresano.mi.it', '0298278531', 'www.comune.dresano.mi.it', null),
  ('Comune di Gaggiano', 'Gaggiano', 'MI', 'Lombardia', 9543, '82001390150', 'Via Roma, 36', '20083', 'comune.gaggiano@pec.regione.lombardia.it', 'comune@comune.gaggiano.mi.it', '029089921', 'www.comune.gaggiano.mi.it', 'UFHDKZ'),
  ('Comune di Garbagnate Milanese', 'Garbagnate Milanese', 'MI', 'Lombardia', 27064, '00792720153', 'P.zza De Gasperi, 1', '20024', 'comune@garbagnate-milanese.legalmail.it', 'protocollo@comune.garbagnate-milanese.mi.it', '0278618200', 'www.comune.garbagnate-milanese.mi.it', 'UF09KK'),
  ('Comune di Gessate', 'Gessate', 'MI', 'Lombardia', 9137, '00973680150', 'Piazza Municipio N 1', '20060', 'comune.gessate@legalmail.it', 'protocollo@comune.gessate.mi.it', '02959299200', 'www.comune.gessate.mi.it', 'UFCGJZ'),
  ('Comune di Gorgonzola', 'Gorgonzola', 'MI', 'Lombardia', 21448, '00861930154', 'Via Italia, 62', '20064', 'comune.gorgonzola@cert.legalmail.it', null, null, 'www.comune.gorgonzola.mi.it', 'UFM5A6'),
  ('Comune di Grezzago', 'Grezzago', 'MI', 'Lombardia', 3176, '83500690157', 'Piazza Della Repubblica 1', '20056', 'comune.grezzago@pec.regione.lombardia.it', null, '029093691', 'www.comune.grezzago.mi.it', 'UF3AL4'),
  ('Comune di Gudo Visconti', 'Gudo Visconti', 'MI', 'Lombardia', 1608, '82000830156', 'Piazza Roma, 7', '20088', 'protocollo@pec.gudo.it', 'protocollo@gudo.it', '0294961764', 'https://www.comune.gudovisconti.mi.it/', 'UF00K3'),
  ('Comune di Inveruno', 'Inveruno', 'MI', 'Lombardia', 8568, '01490870159', 'Via G. Marcora, 38', '20010', 'comune.inveruno@legalmail.it', null, null, 'comune.inveruno.mi.it', 'UFV6AU'),
  ('Comune di Inzago', 'Inzago', 'MI', 'Lombardia', 11465, '83503270155', 'Piazza Quintino Di Vona 3', '20065', 'finanziario.comuneinzago@legalmail.it', null, '02954398201', 'www.comune.inzago.mi.it', 'UF854W'),
  ('Comune di Lacchiarella', 'Lacchiarella', 'MI', 'Lombardia', 9131, '80094250158', 'Piazza Risorgimento, 1', '20084', 'protocollo@pec.comune.lacchiarella.mi.it', null, '029057831', 'www.comune.lacchiarella.mi.it', 'UFTYLZ'),
  ('Comune di Lainate', 'Lainate', 'MI', 'Lombardia', 26457, '00856780150', 'Largo Vittorio Veneto, 12', '20020', 'comune.lainate@pec.regione.lombardia.it', null, '0293598306', 'www.comune.lainate.mi.it', 'UF2P75'),
  ('Comune di Legnano', 'Legnano', 'MI', 'Lombardia', 60980, '00807960158', 'Piazza San Magno 9', '20025', 'comune.legnano@cert.legalmail.it', null, null, 'https://comune.legnano.mi.it/', 'UFXQPN'),
  ('Comune di Liscate', 'Liscate', 'MI', 'Lombardia', 3931, '83503450153', 'Largo Europa, 2', '20050', 'comune.liscate@pec.regione.lombardia.it', 'segreteria.liscate@unioneaddamartesana.it', null, 'www.comune.liscate.mi.it', 'UF8ZPB'),
  ('Comune di Locate di Triulzi', 'Locate di Triulzi', 'MI', 'Lombardia', 10360, '80101630152', 'Via Roma, 9', '20085', 'comune@pec.comune.locateditriulzi.mi.it', 'comune@comune.locateditriulzi.mi.it', '02904841', 'www.comune.locateditriulzi.mi.it', null),
  ('Comune di Magenta', 'Magenta', 'MI', 'Lombardia', 25066, '01082490150', 'Piazza Formenti, 3', '20013', 'protocollo@pec.comune.magenta.mi.it', null, null, 'www.comune.magenta.mi.it', 'UF3T5N'),
  ('Comune di Magnago', 'Magnago', 'MI', 'Lombardia', 9547, '00950100156', 'Piazza Italia 1', '20020', 'info@pec.comune.magnago.mi.it', 'info@comune.magnago.mi.it', '0331658305', 'www.comune.magnago.mi.it', 'UFPRFO'),
  ('Comune di Marcallo con Casone', 'Marcallo con Casone', 'MI', 'Lombardia', 6403, '01009620152', 'Via Vitali, 18', '20010', 'comune.marcalloconcasone@pec.regione.lombardia.it', null, '029796121', 'www.marcallo.it', 'UFM9BH'),
  ('Comune di Masate', 'Masate', 'MI', 'Lombardia', 3917, '83510480151', 'Via Milano N. 69', '20060', 'masate@pec.it', null, null, 'www.unione.basianomasate.mi.it', 'UF2VT1'),
  ('Comune di Mediglia', 'Mediglia', 'MI', 'Lombardia', 12373, '84503580155', 'Via Risorgimento 5', '20060', 'comune.mediglia@pec.regione.lombardia.it', null, '0290662021', 'www.comune.mediglia.mi.it', 'UF95RL'),
  ('Comune di Melegnano', 'Melegnano', 'MI', 'Lombardia', 18169, '84507510158', 'Piazza Risorgimento, 1', '20077', 'protocollo.melegnano@legalpec.it', null, '02982081', 'www.comune.melegnano.mi.it', 'UF79H3'),
  ('Comune di Melzo', 'Melzo', 'MI', 'Lombardia', 18540, '00795710151', 'Piazza Vittorio Emenuele II numero 1', '20066', 'comunemelzo@pec.it', null, '02951201', 'www.comune.melzo.mi.it', 'UF71DH'),
  ('Comune di Mesero', 'Mesero', 'MI', 'Lombardia', 4134, '03476900158', 'Via San Bernardo, 41', '20010', 'comune.mesero@pec.regione.lombardia.it', null, '0297285013', 'www.comune.mesero.mi.it', 'UF3FAJ'),
  ('Comune di Milano', 'Milano', 'MI', 'Lombardia', 1362863, '01199250158', 'Piazza Della Scala, 2', '20121', 'protocollo@postacert.comune.milano.it', 'protocollo@comune.milano.it', null, 'www.comune.milano.it', null),
  ('Comune di Morimondo', 'Morimondo', 'MI', 'Lombardia', 1005, '82003090154', 'Piazza Municipio 1', '20081', 'comune.morimondo@pec.regione.lombardia.it', 'ufficioanagrafe@comune.morimondo.mi.it', '0294961941', 'www.comune.morimondo.mi.it', 'UFVLF3'),
  ('Comune di Motta Visconti', 'Motta Visconti', 'MI', 'Lombardia', 8253, '82000790152', 'Piazza San Rocco, 9/A', '20086', 'protocollo@pec.comune.mottavisconti.mi.it', null, '0290008101', 'https://comune.mottavisconti.mi.it/', null),
  ('Comune di Nerviano', 'Nerviano', 'MI', 'Lombardia', 17071, '00864790159', 'Piazza Manzoni, 14', '20014', 'urp@pec.comune.nerviano.mi.it', null, '0331438925', 'www.comune.nerviano.mi.it', 'UFYVT1'),
  ('Comune di Nosate', 'Nosate', 'MI', 'Lombardia', 638, '03606860157', 'Via Ponte Di Castano, 2', '20020', 'comune.nosate@pec.regione.lombardia.it', 'segreteria@comune.nosate.mi.it', '0331899530', 'www.comune.nosate.mi.it', 'UF86J2'),
  ('Comune di Novate Milanese', 'Novate Milanese', 'MI', 'Lombardia', 20415, '02032910156', 'Via Vittorio Veneto 18', '20026', 'comune.novatemilanese@legalmail.it', null, '02354731', 'www.comune.novate-milanese.mi.it', 'UFG8VA'),
  ('Comune di Noviglio', 'Noviglio', 'MI', 'Lombardia', 4534, '80121990156', 'Piazza Roma, 1', '20082', 'protocollo.noviglio@legalpec.it', null, '029006076', 'www.comune.noviglio.mi.it', 'UFCEWQ'),
  ('Comune di Opera', 'Opera', 'MI', 'Lombardia', 14463, '80104310158', 'Via Dante, 12', '20073', 'protocollo.opera@cert.legalmail.it', 'segreteriagenerale@comune.opera.mi.it', '0253007', 'www.comune.opera.mi.it', null),
  ('Comune di Ossona', 'Ossona', 'MI', 'Lombardia', 4440, '86002350154', 'Piazza Litta Modignani 9', '20010', 'posta.certificata@pec.comune.ossona.mi.it', 'municipio@comune.ossona.mi.it', '029010003', 'www.comune.ossona.mi.it', 'UFZSL4'),
  ('Comune di Ozzero', 'Ozzero', 'MI', 'Lombardia', 1349, '04935070153', 'Piazza Vittorio Veneto, 2', '20080', 'protocollo.ozzero@legalpec.it', 'info@comune.ozzero.mi.it', '029400401', 'www.comune.ozzero.mi.it', 'UFMPUH'),
  ('Comune di Paderno Dugnano', 'Paderno Dugnano', 'MI', 'Lombardia', 47938, '02866100155', 'Via Grandi, 15', '20037', 'comune.paderno-dugnano@pec.regione.lombardia.it', null, '02910041', 'www.comune.paderno-dugnano.mi.it', 'UFE99R'),
  ('Comune di Pantigliate', 'Pantigliate', 'MI', 'Lombardia', 5886, '80108750151', 'Piazza Comunale, 10', '20090', 'comune.pantigliate@legalmail.it', 'segreteria@comune.pantigliate.mi.it', '029068861', 'www.comune.pantigliate.mi.it', 'UFTV57'),
  ('Comune di Parabiago', 'Parabiago', 'MI', 'Lombardia', 28398, '01059460152', 'Piazza Della Vittoria, 7', '20015', 'comune@cert.comune.parabiago.mi.it', 'comune@comune.parabiago.mi.it', '0331406000', 'www.comune.parabiago.mi.it', 'UFCPI5'),
  ('Comune di Paullo', 'Paullo', 'MI', 'Lombardia', 11136, '84503130159', 'v. Mazzini, 28', '20067', 'protocollo@pec.comune.paullo.mi.it', null, '0290626942', 'www.comune.paullo.mi.it', 'UF839P'),
  ('Comune di Pero', 'Pero', 'MI', 'Lombardia', 11866, '86502820151', 'Piazza Marconi,2', '20016', 'protocollo@comune.pero.mi.legalmail.it', null, '0235371152', 'www.comune.pero.mi.it', 'UFS1QL'),
  ('Comune di Peschiera Borromeo', 'Peschiera Borromeo', 'MI', 'Lombardia', 24363, '80101570150', 'v. XXV Aprile, 1', '20068', 'comune.peschieraborromeo@pec.regione.lombardia.it', null, '02516901', 'www.comune.peschieraborromeo.mi.it', null),
  ('Comune di Pessano con Bornago', 'Pessano con Bornago', 'MI', 'Lombardia', 9034, '03064000155', 'Via Roma 31', '20060', 'comune.pessanoconbornago@legalmail.it', null, '029596971', 'www.comune.pessanoconbornago.mi.it', 'UF02ZK'),
  ('Comune di Pieve Emanuele', 'Pieve Emanuele', 'MI', 'Lombardia', 15846, '80104290152', 'v. Viquarterio, 1', '20090', 'protocollo@pec.comune.pieveemanuele.mi.it', null, '02907781', 'www.comune.pieveemanuele.mi.it', 'UFG7U1'),
  ('Comune di Pioltello', 'Pioltello', 'MI', 'Lombardia', 37709, '83501410159', 'v. Cattaneo, 1', '20096', 'protocollo@cert.comune.pioltello.mi.it', null, '02923661', 'www.comune.pioltello.mi.it', 'UFLGID'),
  ('Comune di Pogliano Milanese', 'Pogliano Milanese', 'MI', 'Lombardia', 8483, '86502140154', 'Piazza Volontari Avis Aido, 6', '20010', 'comune.poglianomilanese@cert.legalmail.it', 'info@poglianomilanese.org', '029396441', 'https://comune.poglianomilanese.mi.it/', 'UF6R0V'),
  ('Comune di Pozzo d''Adda', 'Pozzo d''Adda', 'MI', 'Lombardia', 6871, '83503590156', 'Via Colombo, 17', '20060', 'comune.pozzodadda@legalmail.it', 'protocollo@comune.pozzodadda.mi.it', '02909901', 'www.comune.pozzodadda.mi.it', 'UFDQLY'),
  ('Comune di Pozzuolo Martesana', 'Pozzuolo Martesana', 'MI', 'Lombardia', 8828, '83504230158', 'Via MARTIRI DELLA LIBERAZIONE 11', '20060', 'comune.pozzuolomartesana.mi@legalmail.it', 'informatica@unioneaddamartesana.it', null, 'www.comune.pozzuolomartesana.mi.it', 'UF5W8M'),
  ('Comune di Pregnana Milanese', 'Pregnana Milanese', 'MI', 'Lombardia', 7331, '86502760159', 'Piazza Liberta'', 1', '20010', 'protocollo@pec.comune.pregnana.mi.it', null, null, 'www.comune.pregnana.mi.it', 'UF0BIZ'),
  ('Comune di Rescaldina', 'Rescaldina', 'MI', 'Lombardia', 14406, '01633080153', 'Piazza Chiesa N.15', '20027', 'comune.rescaldina@pec.regione.lombardia.it', 'info@comune.rescaldina.mi.it', '0331467811', 'www.comune.rescaldina.mi.it', 'UFN2J2'),
  ('Comune di Rho', 'Rho', 'MI', 'Lombardia', 51000, '00893240150', 'Piazza Visconti 24', '20017', 'pec.protocollo.comunerho@legalmail.it', null, '02933321', 'www.comune.rho.mi.it', 'UFIXOT'),
  ('Comune di Robecchetto con Induno', 'Robecchetto con Induno', 'MI', 'Lombardia', 4797, '86002510153', 'Piazza Liberta, 12', '20020', 'comune.robecchetto@postecert.it', null, '0331875600', 'www.comune.robecchetto-con-induno.mi.it', 'UFEHJA'),
  ('Comune di Robecco sul Naviglio', 'Robecco sul Naviglio', 'MI', 'Lombardia', 6794, '82002470159', 'Via Dante 21', '20087', 'robeccosulnaviglio@halleycert.it', 'info@comune.robeccosulnaviglio.mi.it', '029497801', 'www.comune.robeccosulnaviglio.mi.it', null),
  ('Comune di Rodano', 'Rodano', 'MI', 'Lombardia', 4709, '83503550150', 'Via Filippo Turati 9', '20053', 'comune.rodano@pec.regione.lombardia.it', null, '029595951', 'https://www.comune.rodano.mi.it', 'UFS0UW'),
  ('Comune di Rosate', 'Rosate', 'MI', 'Lombardia', 5641, '82000610152', 'Via Vittorio Veneto, 2', '20088', 'comune.rosate@pec.regione.lombardia.it', 'protocollo@comune.rosate.mi.it', '02908301', 'www.comune.rosate.mi.it', 'UFBPTT'),
  ('Comune di Rozzano', 'Rozzano', 'MI', 'Lombardia', 41724, '01743420158', 'Piazza Giovanni Foglia, 1', '20089', 'protocollo@pec.comune.rozzano.mi.it', null, '0282261', 'www.comune.rozzano.mi.it', 'UFYPNP'),
  ('Comune di San Colombano al Lambro', 'San Colombano al Lambro', 'MI', 'Lombardia', 7591, '84503820155', 'Via Monti, 47', '20078', 'comune.sancolombano@cert.saga.it', null, '0371293213', 'www.comune.sancolombanoallambro.mi.it', 'UF7U27'),
  ('Comune di San Donato Milanese', 'San Donato Milanese', 'MI', 'Lombardia', 32210, '00828590158', 'Via Cesare Battisti,2', '20097', 'protocollo@cert.comune.sandonatomilanese.mi.it', null, '02527721', 'www.comune.sandonatomilanese.mi.it', 'UF9CH1'),
  ('Comune di San Giorgio su Legnano', 'San Giorgio su Legnano', 'MI', 'Lombardia', 6868, '01401970155', 'Piazza IV Novembre 7', '20010', 'comune.sangiorgiosulegnano@cert.legalmail.it', 'info@comune.sangiorgiosulegnano.mi.it', '0331401564', 'www.comune.sangiorgiosulegnano.mi.it', 'UFEOH6'),
  ('Comune di San Giuliano Milanese', 'San Giuliano Milanese', 'MI', 'Lombardia', 40227, '00798940151', 'Via De Nicola,2', '20098', 'comune.sangiulianomilanese@cert.legalmail.it', null, null, 'www.comune.sangiulianomilanese.mi.it', 'UFS7OS'),
  ('Comune di San Vittore Olona', 'San Vittore Olona', 'MI', 'Lombardia', 8450, '01175480159', 'Via Europa 23', '20028', 'comune.sanvittoreolona@pec.regione.lombardia.it', null, '0331488911', 'https://www.comune.sanvittoreolona.mi.it/', 'UFTDZI'),
  ('Comune di San Zenone al Lambro', 'San Zenone al Lambro', 'MI', 'Lombardia', 4508, '84504020151', 'Piazza Aldo Moro, 2', '20070', 'sindaco.comune.sanzenone@pec.regione.lombardia.it', 'protocollo@comune.sanzenoneallambro.mi.it', null, 'www.comune.sanzenoneallambro.mi.it', 'UF3BOH'),
  ('Comune di Santo Stefano Ticino', 'Santo Stefano Ticino', 'MI', 'Lombardia', 4983, '02941420156', 'Via Giuseppe Garibaldi 9', '20010', 'comune.santostefanoticino@pec.regione.lombardia.it', 'comune@comune.santostefanoticino.mi.it', '029723861', 'www.comune.santostefanoticino.mi.it', 'UFR089'),
  ('Comune di Sedriano', 'Sedriano', 'MI', 'Lombardia', 13088, '86003630158', 'Via Fagnani, 35', '20018', 'comune.sedriano@postemailcertificata.it', null, '02903981', 'https://www.comune.sedriano.mi.it', 'UFYNRL'),
  ('Comune di Segrate', 'Segrate', 'MI', 'Lombardia', 37194, '83503670156', 'Via Primo Maggio', '20090', 'comunesegrate@pec.it', 'urp@comune.segrate.mi.it', '0226902218', 'https://www.comune.segrate.mi.it', 'UFLPIA'),
  ('Comune di Senago', 'Senago', 'MI', 'Lombardia', 21754, '03519480150', 'Via XXIV Maggio, 1', '20030', 'postacertificata@comune.senago.legalmail.it', 'urp@comune.senago.mi.it', null, 'www.comune.senago.mi.it', 'UF4RJW'),
  ('Comune di Sesto San Giovanni', 'Sesto San Giovanni', 'MI', 'Lombardia', 78850, '02253930156', 'Piazza Della Resistenza, 20', '20099', 'comune.sestosg@legalmail.it', null, '0224961', 'www.comune.sestosangiovanni.mi.it', null),
  ('Comune di Settala', 'Settala', 'MI', 'Lombardia', 7447, '83503490159', 'Via Verdi, 8C', '20090', 'postacertificata@cert.comune.settala.mi.it', null, '02950759221', 'www.comune.settala.mi.it', 'UFCMLJ'),
  ('Comune di Settimo Milanese', 'Settimo Milanese', 'MI', 'Lombardia', 20002, '01315140150', 'Piazza Degli Eroi, 5', '20019', 'protocollo@postacert.comune.settimomilanese.mi.it', 'info@comune.settimomilanese.mi.it', '02335091', 'www.comune.settimomilanese.mi.it', 'UFFE9N'),
  ('Comune di Solaro', 'Solaro', 'MI', 'Lombardia', 14260, '01549700159', 'Via Giuseppe Mazzini, 60', '20020', 'comune.solaro@pec.regione.lombardia.it', null, null, 'www.comune.solaro.mi.it', 'UF467O'),
  ('Comune di Trezzano Rosa', 'Trezzano Rosa', 'MI', 'Lombardia', 5444, '83502090158', 'Piazza XXV Aprile n.1', '20060', 'info@pec.comune.trezzanorosa.mi.it', 'info@comune.trezzanorosa.mi.it', '029201991', 'www.comune.trezzanorosa.mi.it', 'UFTBQ4'),
  ('Comune di Trezzano sul Naviglio', 'Trezzano sul Naviglio', 'MI', 'Lombardia', 21875, '03029240151', 'v. IV Novembre, 2', '20090', 'comune.trezzanosulnaviglio@legalmail.it', null, null, 'www.comune.trezzano-sul-naviglio.mi.it', 'UF4LOR'),
  ('Comune di Trezzo sull''Adda', 'Trezzo sull''Adda', 'MI', 'Lombardia', 12442, '83502130152', 'Via Roma, 5', '20056', 'protocollo@pec.comune.trezzosulladda.mi.it', 'protocollo@comune.trezzosulladda.mi.it', null, 'www.comune.trezzosulladda.mi.it', 'UFPEED'),
  ('Comune di Tribiano', 'Tribiano', 'MI', 'Lombardia', 3931, '84503590154', 'Piazza Giovanni Paolo II', '20067', 'postacertificata@pec.comune.tribiano.mi.it', 'protocollo@comune.tribiano.mi.it', '02906290216', 'www.comune.tribiano.mi.it', null),
  ('Comune di Truccazzano', 'Truccazzano', 'MI', 'Lombardia', 5810, '83502350156', 'Via Scotti, 50', '20060', 'comune.truccazzano.mi@legalmail.it', null, null, 'www.comune.truccazzano.mi.it', 'UF6VWZ'),
  ('Comune di Turbigo', 'Turbigo', 'MI', 'Lombardia', 7276, '86004290150', 'Via Roma, 39', '20029', 'comune.turbigo@postecert.it', null, '0331899143', 'www.comune.turbigo.mi.it', 'UFL9YA'),
  ('Comune di Vanzaghello', 'Vanzaghello', 'MI', 'Lombardia', 5394, '02937320154', 'Via Donatori Volontari Del Sangue, 3', '20020', 'comune.vanzaghello@postecert.it', 'info@comune.vanzaghello.mi.it', '0331308911', 'www.comune.vanzaghello.mi.it', 'UF9DWG'),
  ('Comune di Vanzago', 'Vanzago', 'MI', 'Lombardia', 9372, '03351920156', 'Via Garibaldi, 6', '20010', 'comune.vanzago@pec.regione.lombardia.it', 'segreteria@comune.vanzago.mi.it', '02939621', 'www.comune.vanzago.mi.it', 'UFU2R0'),
  ('Comune di Vaprio d''Adda', 'Vaprio d''Adda', 'MI', 'Lombardia', 9723, '03614850158', 'Piazza Cavour, 26', '20069', 'comune.vapriodadda@legalmail.it', null, '029094004', 'www.comune.vapriodadda.mi.it', 'UF0ODE'),
  ('Comune di Vermezzo con Zelo', 'Vermezzo con Zelo', 'MI', 'Lombardia', 5987, '10708190961', 'Piazza Comunale, 4', '20080', 'vermezzoconzelo@pec.it', null, '029440301', 'www.comune.vermezzoconzelo.mi.it', 'UFTGAB'),
  ('Comune di Vernate', 'Vernate', 'MI', 'Lombardia', 3436, '80100350158', 'Piazza IV Novembre, 2', '20080', 'comune.vernate@pec.regione.lombardia.it', 'info@comune.vernate.mi.it', '0290013221', 'www.comune.vernate.mi.it', 'UFKTMM'),
  ('Comune di Vignate', 'Vignate', 'MI', 'Lombardia', 9369, '83504710159', 'Via Roma N. 19', '20060', 'protocollo@pec.comune.vignate.mi.it', null, '0295080811', 'www.comune.vignate.mi.it', 'UFIF3M'),
  ('Comune di Villa Cortese', 'Villa Cortese', 'MI', 'Lombardia', 6333, '01008750158', 'Piazza del Carroccio, 15', '20035', 'comune.villacortese@cert.legalmail.it', 'info@comune.villacortese.mi.it', '0331434411', 'https://comune.villacortese.mi.it/', 'UF76C1'),
  ('Comune di Vimodrone', 'Vimodrone', 'MI', 'Lombardia', 16933, '07430220157', 'Via Cesare Battisti 56', '20055', 'comune.vimodrone@pec.regione.lombardia.it', 'protocollo@comune.vimodrone.milano.it', '02250771', 'www.comune.vimodrone.mi.it', 'UFJFCA'),
  ('Comune di Vittuone', 'Vittuone', 'MI', 'Lombardia', 9312, '00994350155', 'Piazza Italia n. 5', '20010', 'ufficio.protocollo@pec.comune.vittuone.mi.it', null, '02903201', 'www.comune.vittuone.mi.it', 'UF9OHR'),
  ('Comune di Vizzolo Predabissi', 'Vizzolo Predabissi', 'MI', 'Lombardia', 3852, '84503700159', 'Via G.Verdi, 9', '20070', 'comune.vizzolopredabissi@pec.regione.lombardia.it', 'segreteria@comune.vizzolopredabissi.mi.it', '02982021', 'www.comune.vizzolopredabissi.mi.it', 'UFK4TP'),
  ('Comune di Zibido San Giacomo', 'Zibido San Giacomo', 'MI', 'Lombardia', 6643, '80102330158', 'Piazza Roma, 1', '20080', 'protocollo@pec.comune.zibidosangiacomo.mi.it', null, '02900201', 'www.comune.zibidosangiacomo.mi.it', 'UF45JU');

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

-- Controllo: MI = 133 comuni / 3.253.111 ab.
select provincia, count(*) as comuni, sum(abitanti) as abitanti,
       count(pec) as con_pec, count(email) as con_email, count(phone) as con_telefono
from companies
where tipo = 'pa' and name ilike 'Comune di %' and provincia = 'MI'
group by provincia;



-- =====================================================================
--  CRM ENER.ING — Comuni della provincia di Lodi con abitanti e contatti
--  Esegui nel SQL Editor di Supabase. Sicuro e ri-eseguibile (non cancella nulla):
--   * aggiunge ai clienti le colonne "abitanti" ed "email" (se mancano);
--   * inserisce i 60 Comuni della provincia di Lodi come clienti PA;
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
  ('Comune di Abbadia Cerreto', 'Abbadia Cerreto', 'LO', 'Lombardia', 280, '84503440152', 'Via Dell''Abbazia, 7', '26834', 'comune.abbadiacerreto@pec.regione.lombardia.it', null, '037172235', 'www.comune.abbadiacerreto.lo.it', 'UFGXFL'),
  ('Comune di Bertonico', 'Bertonico', 'LO', 'Lombardia', 1081, '82502570151', 'Via Matteotti 12', '26821', 'comune.bertonico@pec.regione.lombardia.it', 'ragioneria@comune.bertonico.lo.it', null, 'www.comune.bertonico.lo.it', 'UFZQON'),
  ('Comune di Boffalora d''Adda', 'Boffalora d''Adda', 'LO', 'Lombardia', 1737, '84503340154', 'Via Umberto I 30', '26811', 'comune.boffaloradadda@pec.regione.lombardia.it', 'info@comune.boffaloradadda.lo.it', '037160013', 'www.comune.boffaloradadda.lo.it', 'UFD3YZ'),
  ('Comune di Borghetto Lodigiano', 'Borghetto Lodigiano', 'LO', 'Lombardia', 4430, '84500250158', 'Via Gen. Carlo Alberto Dalla Chiesa, 1', '26812', 'borghettolodigiano@cert.elaus2002.net', 'protocollo@comuneborghetto.lo.it', null, 'www.comune.borghettolodigiano.lo.it', 'UFTNCE'),
  ('Comune di Borgo San Giovanni', 'Borgo San Giovanni', 'LO', 'Lombardia', 2444, '84503540159', 'Via Aldo Moro, 33', '26851', 'comune.borgosangiovanni@pec.regione.lombardia.it', 'protocollo@comune.borgosangiovanni.lo.it', '037197004', 'www.comune.borgosangiovanni.lo.it', 'UF4DUI'),
  ('Comune di Brembio', 'Brembio', 'LO', 'Lombardia', 2807, '03684020153', 'Piazza Matteotti, 1', '26822', 'comune.brembio@pec.regione.lombardia.it', 'protocollo@comune.brembio.lo.it', '037798901', 'www.comune.brembio.lo.it', 'UFA5LH'),
  ('Comune di Casaletto Lodigiano', 'Casaletto Lodigiano', 'LO', 'Lombardia', 3019, '84502640158', 'Via Roma, 12', '26852', 'comune.casalettolodigiano@pec.regione.lombardia.it', null, '037171542', 'www.comune.casalettolodigiano.lo.it', 'UF7XI5'),
  ('Comune di Casalmaiocco', 'Casalmaiocco', 'LO', 'Lombardia', 3218, '84503780151', 'Piazza San Valentino 1', '26831', 'comune.casalmaiocco@pec.it', 'ragioneria@comune.casalmaiocco.lo.it', null, 'www.comune.casalmaiocco.lo.it', 'UFQPOU'),
  ('Comune di Casalpusterlengo', 'Casalpusterlengo', 'LO', 'Lombardia', 16069, '01507990156', 'Piazza Del Popolo, 22', '26841', 'comune.casalpusterlengo@pec.regione.lombardia.it', null, '03779233231', 'www.comune.casalpusterlengo.lo.it', 'UF6XID'),
  ('Comune di Caselle Landi', 'Caselle Landi', 'LO', 'Lombardia', 1431, '82501130155', 'Viale Iv Novembre 20', '26842', 'info@pec.comune.casellelandi.lo.it', 'segreteria@comune.casellelandi.lo.it', '037769901', 'www.comune.casellelandi.lo.it', 'UFPICF'),
  ('Comune di Caselle Lurani', 'Caselle Lurani', 'LO', 'Lombardia', 3071, '84504860150', 'Via Roma N. 19', '26853', 'info@pec.comune.casellelurani.lo.it', 'segreteria@comune.casellelurani.lo.it', '037196019', 'https://www.comune.casellelurani.lo.it/', 'UF0WQL'),
  ('Comune di Castelgerundo', 'Castelgerundo', 'LO', 'Lombardia', 1454, '10151890968', 'Via A. De Gasperi, 9', '26844', 'castelgerundo@pec.it', null, '0377778027', 'www.comune.castelgerundo.lo.it', 'UF7YAR'),
  ('Comune di Castelnuovo Bocca d''Adda', 'Castelnuovo Bocca d''Adda', 'LO', 'Lombardia', 1544, '82501210155', 'Piazza Garibaldi, 1', '26843', 'casella@pec.comune.castelnuovoboccadadda.lo.it', 'protocollo@comune.castelnuovoboccadadda.lo.it', null, 'www.comune.castelnuovoboccadadda.lo.it', 'UF1CHC'),
  ('Comune di Castiglione d''Adda', 'Castiglione d''Adda', 'LO', 'Lombardia', 4524, '82502070152', 'Via Roma, 130', '26823', 'castiglionedadda@cert.elaus2002.net', 'protocollo@comune.castiglionedadda.lo.it', '0377900403', 'www.comune.castiglionedadda.lo.it', 'UFB82Q'),
  ('Comune di Castiraga Vidardo', 'Castiraga Vidardo', 'LO', 'Lombardia', 3048, '84503060158', 'Viale Roma, 60', '26866', 'comune.castiragavidardo@pec.regione.lombardia.it', 'ragioneria@comune.castiragavidardo.lo.it', '037190404', 'www.comune.castiragavidardo.lo.it', 'UF2EHF'),
  ('Comune di Cavenago d''Adda', 'Cavenago d''Adda', 'LO', 'Lombardia', 2128, '03593960150', 'Via E. Conti, 2', '26824', 'comune.cavenagodadda@pec.regione.lombardia.it', 'protocollo@comune.cavenagodadda.lo.it', '037170031', 'www.comune.cavenagodadda.lo.it', 'UFIRDG'),
  ('Comune di Cervignano d''Adda', 'Cervignano d''Adda', 'LO', 'Lombardia', 2247, '84503600151', 'Piazza del Municipio, 1', '26832', 'cervignanodadda@cert.elaus2002.net', 'segreteria@comune.cervignanodadda.lo.it', '029813002', 'www.comune.cervignanodadda.lo.it', 'UFYYUK'),
  ('Comune di Codogno', 'Codogno', 'LO', 'Lombardia', 15652, '02031600154', 'Via Vittorio Emanuele Ii, 4', '26845', 'protocollo@pec.comune.codogno.lo.it', 'urp@comune.codogno.lo.it', '0377314228', 'https://comune.codogno.lo.it', 'UFHWL3'),
  ('Comune di Comazzo', 'Comazzo', 'LO', 'Lombardia', 2379, '84507410151', 'Via Palazzo Pertusati, 25', '26833', 'comune.comazzo@pec.regione.lombardia.it', 'protocollo@comune.comazzo.lo.it', '029061015', 'www.comune.comazzo.lo.it', 'UFQ35D'),
  ('Comune di Cornegliano Laudense', 'Cornegliano Laudense', 'LO', 'Lombardia', 2861, '84502770153', 'Via Lodi 4', '26854', 'corneglianolaudense@cert.elaus2002.net', null, '037169079', 'www.comune.cornegliano.laudense.lo.it', 'UFXRFP'),
  ('Comune di Corno Giovine', 'Corno Giovine', 'LO', 'Lombardia', 1144, '82501960155', 'Piazza Caduti 1', '26846', 'comune.cornogiovine@pec.it', 'info@comune.cornogiovine.lo.it', '037767715', 'www.comune.cornogiovine.lo.it', 'UFOEKC'),
  ('Comune di Cornovecchio', 'Cornovecchio', 'LO', 'Lombardia', 199, '82503640151', 'Via Don Attilio Rovida, 1', '26842', 'comune.cornovecchio@pec.regione.lombardia.it', 'protocollo@comune.cornovecchio.lo.it', '0377709910', 'www.comune.cornovecchio.lo.it', 'UFRHYA'),
  ('Comune di Corte Palasio', 'Corte Palasio', 'LO', 'Lombardia', 1522, '84501510154', 'Piazza Terraverde, 2', '26834', 'comune.cortepalasio@pec.regione.lombardia.it', 'info@comune.cortepalasio.lo.it', '037172231', 'www.comune.cortepalasio.lo.it', 'UFVULW'),
  ('Comune di Crespiatica', 'Crespiatica', 'LO', 'Lombardia', 2208, '84503400156', 'Via Roma, 23', '26835', 'comune.crespiatica@pec.regione.lombardia.it', 'info@comune.crespiatica.lo.it', '0371484109', 'www.comune.crespiatica.lo.it', 'UF8C3P'),
  ('Comune di Fombio', 'Fombio', 'LO', 'Lombardia', 2266, '82500030158', 'Via Roma, 83', '26861', 'comune.fombio@pec.regione.lombardia.it', 'segreteria@comune.fombio.lo.it', '037732362', 'www.comune.fombio.lo.it', 'UF4VGI'),
  ('Comune di Galgagnano', 'Galgagnano', 'LO', 'Lombardia', 1308, '84504340153', 'Piazza Del Palazzo, 2', '26832', 'comune.galgagnano@pec.regione.lombardia.it', null, '037168261', 'www.comune.galgagnano.lo.it', 'UF6JJ0'),
  ('Comune di Graffignana', 'Graffignana', 'LO', 'Lombardia', 2602, '84504680152', 'Via Roma 1', '26813', 'comune.graffignana@pec.regione.lombardia.it', 'anagrafestatocivile@comune.graffignana.lo.it', '037188828', 'www.comune.graffignana.lo.it', 'UF1FFT'),
  ('Comune di Guardamiglio', 'Guardamiglio', 'LO', 'Lombardia', 2730, '82502970153', 'Via Cavour, 14', '26862', 'comune.guardamiglio@pec.regione.lombardia.it', null, '037751002', 'www.comune.guardamiglio.lo.it', 'UFED0E'),
  ('Comune di Livraga', 'Livraga', 'LO', 'Lombardia', 2534, '82501550154', 'Via Dante 30', '26814', 'comune.livraga@pec.it', 'ragioneria@comune.livraga.lo.it', '037787702', 'www.comune.livraga.lo.it', 'UF7TKJ'),
  ('Comune di Lodi', 'Lodi', 'LO', 'Lombardia', 45643, '84507570152', 'Piazza Broletto 1', '26900', 'comunedilodi@legalmail.it', 'urp@comune.lodi.it', '03714091', 'www.comune.lodi.it', 'UF5IE5'),
  ('Comune di Lodi Vecchio', 'Lodi Vecchio', 'LO', 'Lombardia', 7717, '84502880150', 'Piazza Vittorio Emanuele II', '26855', 'comune.lodivecchio@pec.regione.lombardia.it', null, null, 'www.comune.lodivecchio.lo.it', 'UF39W6'),
  ('Comune di Maccastorna', 'Maccastorna', 'LO', 'Lombardia', 67, '82500110158', 'Via Roma, 15', '26843', 'comune.maccastorna@pec.regione.lombardia.it', 'info@comune.maccastorna.lo.it', '037760634', 'www.comune.maccastorna.lo.it', 'UFH2LX'),
  ('Comune di Mairago', 'Mairago', 'LO', 'Lombardia', 1375, '01035470150', 'Piazza Roma 1', '26825', 'mairago@cert.elaus2002.net', 'protocollo@comune.mairago.lo.it', '0371487001', 'www.comune.mairago.lo.it', 'UFKOSZ'),
  ('Comune di Maleo', 'Maleo', 'LO', 'Lombardia', 3055, '82502910159', 'Piazza XXV Aprile, 1', '26847', 'comune.maleo@pec.regione.lombardia.it', null, '037758001', 'www.comune.maleo.lo.it', 'UFLWQX'),
  ('Comune di Marudo', 'Marudo', 'LO', 'Lombardia', 1757, '84506140155', 'Via G. Marconi, 9', '26866', 'comune.marudo@pec.regione.lombardia.it', null, null, 'www.comune.marudo.lo.it', 'UFFW8X'),
  ('Comune di Massalengo', 'Massalengo', 'LO', 'Lombardia', 4456, '84502940152', 'Piazza Della Pace 1', '26815', 'massalengo@cert.elaus2002.net', 'ragioneria@comune.massalengo.lo.it', '0371480775', 'www.comune.massalengo.lo.it', 'UFTFKK'),
  ('Comune di Meleti', 'Meleti', 'LO', 'Lombardia', 456, '82500190150', 'Via Garibaldi n.5', '26843', 'pec@comunemeleti.casellapec.info', 'info@comune.meleti.lo.it', '0377700412', 'www.comune.meleti.lo.it', 'UFR2CN'),
  ('Comune di Merlino', 'Merlino', 'LO', 'Lombardia', 1655, '84507390155', 'Piazza Liberta'' 1', '26833', 'comune.merlino@pec.regione.lombardia.it', 'protocollo@comune.merlino.lo.it', '0290658283', 'www.comune.merlino.lo.it', 'UFJJM0'),
  ('Comune di Montanaso Lombardo', 'Montanaso Lombardo', 'LO', 'Lombardia', 2256, '84507950156', 'Via Giuseppe Garibaldi 28', '26836', 'comune.montanasolombardo@pec.regione.lombardia.it', null, '03714868206', 'www.comune.montanaso.lo.it', 'UFXDNH'),
  ('Comune di Mulazzano', 'Mulazzano', 'LO', 'Lombardia', 5829, '84504300157', 'Piazza Del Comune, 1', '26837', 'mulazzanocomune@postemailcertificata.it', null, null, 'www.comune.mulazzano.lo.it', 'UFQ1S5'),
  ('Comune di Orio Litta', 'Orio Litta', 'LO', 'Lombardia', 2076, '82503970152', 'Piazza Aldo Moro, 2', '26863', 'comune.oriolitta@pec.regione.lombardia.it', 'segreteria@comune.oriolitta.lo.it', '0377944425', 'www.comune.oriolitta.lo.it', 'GNLQVH'),
  ('Comune di Ospedaletto Lodigiano', 'Ospedaletto Lodigiano', 'LO', 'Lombardia', 2008, '82501480154', 'Piazza Roma, 6', '26864', 'comune.ospedalettolodigiano@pec.regione.lombardia.it', 'anagrafe@comune.ospedalettolodigiano.lo.it', null, 'www.comune.ospedalettolodigiano.lo.it', 'UFBQYG'),
  ('Comune di Ossago Lodigiano', 'Ossago Lodigiano', 'LO', 'Lombardia', 1422, '84503520151', 'Via Roma, 1', '26816', 'comune.ossagolodigiano@pec.regione.lombardia.it', 'ragioneria@comune.ossagolodigiano.lo.it', '0371286821', 'www.comune.ossagolodigiano.lo.it', 'UFQNAN'),
  ('Comune di Pieve Fissiraga', 'Pieve Fissiraga', 'LO', 'Lombardia', 1753, '84506650153', 'Piazza Roma 5', '26854', 'pievefissiraga@cert.elaus2002.net', 'protocollo@comune.pieve-fissiraga.lo.it', '037198000', 'www.comune.pieve-fissiraga.lo.it', 'UF2EYK'),
  ('Comune di Salerano sul Lambro', 'Salerano sul Lambro', 'LO', 'Lombardia', 2690, '84503000154', 'Via Vittorio Veneto, 6', '26857', 'comune.saleranosullambro@pec.regione.lombardia.it', null, '037171391', 'www.comune.saleranosullambro.lo.it', 'UF8GLL'),
  ('Comune di San Fiorano', 'San Fiorano', 'LO', 'Lombardia', 1893, '03946020157', 'Piazza Roma, 1', '26848', 'comune.sanfiorano@pec.regione.lombardia.it', 'info@comune.sanfiorano.lo.it', '037753720', 'www.comune.sanfiorano.lo.it', 'UF7787'),
  ('Comune di San Martino in Strada', 'San Martino in Strada', 'LO', 'Lombardia', 3776, '84507970154', 'Piazza Unita'' d''Italia, 5', '26817', 'sanmartinoinstrada@cert.elaus2002.net', null, '0371449820', 'www.comune.sanmartinoinstrada.lo.it', 'UFX0P1'),
  ('Comune di San Rocco al Porto', 'San Rocco al Porto', 'LO', 'Lombardia', 3452, '03946010158', 'Piazza Della Vittoria, 3', '26865', 'comune.sanroccoalporto@pec.regione.lombardia.it', null, '03777454511', 'www.comune.sanroccoalporto.lo.it', 'UFK7HA'),
  ('Comune di Sant''Angelo Lodigiano', 'Sant''Angelo Lodigiano', 'LO', 'Lombardia', 13577, '84503930152', 'Piazza De Martino Monsignor Nicola, 10', '26866', 'comune.santangelolodigiano@pec.regione.lombardia.it', 'info@comune.santangelolodigiano.lo.it', '037125011', 'www.comune.santangelolodigiano.lo.it', 'UFIF56'),
  ('Comune di Santo Stefano Lodigiano', 'Santo Stefano Lodigiano', 'LO', 'Lombardia', 1852, '03946030156', 'Piazza Roma, 1', '26849', 'info@pec.comune.santostefanolodigiano.lo.it', 'segreteria@comune.santostefanolodigiano.lo.it', '037766001', 'www.comune.santostefanolodigiano.lo.it', 'UFMC1Y'),
  ('Comune di Secugnago', 'Secugnago', 'LO', 'Lombardia', 2001, '90508210151', 'Piazza Matteotti, 9', '26826', 'comune.secugnago@pec.regione.lombardia.it', 'info@comune.secugnago.lo.it', null, 'www.comune.secugnago.lo.it', 'UFEEAK'),
  ('Comune di Senna Lodigiana', 'Senna Lodigiana', 'LO', 'Lombardia', 1813, '82502920158', 'Via Dante, 1', '26856', 'comune.sennalodigiana@pec.regione.lombardia.it', null, '0377802900', 'www.comune.sennalodigiana.lo.it', 'UFF2PR'),
  ('Comune di Somaglia', 'Somaglia', 'LO', 'Lombardia', 3864, '00970030151', 'Via Giacomo Matteotti, 10', '26867', 'comune.somaglia@pacertificata.it', 'info@comune.somaglia.lo.it', '037757901', 'www.comune.somaglia.lo.it', 'UFDC5L'),
  ('Comune di Sordio', 'Sordio', 'LO', 'Lombardia', 3444, '09456750158', 'Piazza Della Liberazione, 2', '26858', 'comune.sordio@pec.regione.lombardia.it', null, null, 'www.comune.sordio.lo.it', 'UFGZN0'),
  ('Comune di Tavazzano con Villavesco', 'Tavazzano con Villavesco', 'LO', 'Lombardia', 6098, '84503320156', 'Piazza XXIV Novembre, 1', '26838', 'comune.tavazzano@pec.regione.lombardia.it', 'urp@comune.tavazzano.lo.it', '037140461', 'www.comune.tavazzano.lo.it', '9M4XAI'),
  ('Comune di Terranova dei Passerini', 'Terranova dei Passerini', 'LO', 'Lombardia', 952, '03541000968', 'Via Achille Grandi N.2', '26827', 'protocollo@pec.comune.terranovadeipasserini.lo.it', 'protocollo@comune.terranovadeipasserini.lo.it', '0377833587', 'www.comune.terranovadeipasserini.lo.it', 'UFDVFU'),
  ('Comune di Turano Lodigiano', 'Turano Lodigiano', 'LO', 'Lombardia', 1576, '82502410150', 'Piazza XXV Aprile, 1', '26828', 'comune.turanolodigiano@pec.regione.lombardia.it', 'anagrafe@comune.turanolodigiano.lo.it', null, 'www.comune.turanolodigiano.lo.it', 'UFIZ0K'),
  ('Comune di Valera Fratta', 'Valera Fratta', 'LO', 'Lombardia', 1698, '84503080156', 'Piazza Vittoria N.6', '26859', 'comune.valerafratta@pec.regione.lombardia.it', 'protocollo@comune.valerafratta.lo.it', '037199000', 'https://www.comune.valerafratta.lo.it/', 'UFLMKF'),
  ('Comune di Villanova del Sillaro', 'Villanova del Sillaro', 'LO', 'Lombardia', 1899, '84502960150', 'Via Della Vittoria,1', '26818', 'comune.villanovadelsillaro@pec.regione.lombardia.it', 'ragioneria@comune.villanova.lo.it', '0371230021', 'www.comune.villanova.lo.it', 'UFXOL4'),
  ('Comune di Zelo Buon Persico', 'Zelo Buon Persico', 'LO', 'Lombardia', 7434, '84507350159', 'Via Dante, 7', '26839', 'comune@pec.comune.zelo.lo.it', null, '029062671', 'www.comune.zelo.lo.it', 'UF2NCF');

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

-- Controllo: LO = 60 comuni / 231.481 ab.
select provincia, count(*) as comuni, sum(abitanti) as abitanti,
       count(pec) as con_pec, count(email) as con_email, count(phone) as con_telefono
from companies
where tipo = 'pa' and name ilike 'Comune di %' and provincia = 'LO'
group by provincia;

