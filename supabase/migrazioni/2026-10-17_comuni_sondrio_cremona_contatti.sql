-- =====================================================================
--  CRM ENER.ING — Comuni delle province di SONDRIO (77) e CREMONA (113)
--  Un unico file: contiene due blocchi uguali, uno per provincia.
--  Esegui tutto insieme nel SQL Editor di Supabase ("Run without RLS").
-- =====================================================================

-- =====================================================================
--  CRM ENER.ING — Comuni della provincia di Sondrio con abitanti e contatti
--  Esegui nel SQL Editor di Supabase. Sicuro e ri-eseguibile (non cancella nulla):
--   * aggiunge ai clienti le colonne "abitanti" ed "email" (se mancano);
--   * inserisce i 77 Comuni della provincia di Sondrio come clienti PA;
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
  ('Comune di Albaredo per San Marco', 'Albaredo per San Marco', 'SO', 'Lombardia', 278, '00105750145', 'Via San Marco 24', '23010', 'protocollo.albaredo@cert.provincia.so.it', 'amministrazione@comune.albaredopersanmarco.so.it', '0342616288', 'https://comune.albaredopersanmarco.so.it/', 'UFP9NA'),
  ('Comune di Albosaggia', 'Albosaggia', 'SO', 'Lombardia', 3006, '00110340148', 'Piazza 5 Alpini snc', '23010', 'protocollo.albosaggia@cert.provincia.so.it', 'affarigenerali@comune.albosaggia.so.it', '0342510376', 'www.comune.albosaggia.so.it', 'UFGL4V'),
  ('Comune di Andalo Valtellino', 'Andalo Valtellino', 'SO', 'Lombardia', 601, '00104380142', 'Piazza Beato Giovanni Battista Scalabrini 1', '23014', 'protocollo.andalo@cert.provincia.so.it', 'amministrazione@comune.andalovaltellino.so.it', '0342685183', 'www.comune.andalovaltellino.so.it', 'UFV3ZR'),
  ('Comune di Aprica', 'Aprica', 'SO', 'Lombardia', 1433, '00110950144', 'P.zza Mario Negri scultore, snc', '23031', 'protocollo.aprica@cert.provincia.so.it', 'ragioneria@comune.aprica.so.it', '0342746116', 'www.comune.aprica.so.it', 'UFFUDH'),
  ('Comune di Ardenno', 'Ardenno', 'SO', 'Lombardia', 3228, '00114430143', 'Piazza Roma, 10', '23011', 'protocollo.ardenno@cert.provincia.so.it', null, '0342660370', 'www.comune.ardenno.so.it', 'UFT10U'),
  ('Comune di Bema', 'Bema', 'SO', 'Lombardia', 117, '00090830142', 'Via Roma,32', '23010', 'protocollo.bema@cert.provincia.so.it', 'amministrazione@comune.bema.so.it', '0342618000', 'www.comune.bema.so.it', 'UF0MEQ'),
  ('Comune di Berbenno di Valtellina', 'Berbenno di Valtellina', 'SO', 'Lombardia', 4066, '00109690149', 'Piazza Municipio, 1', '23010', 'comune.berbennodivaltellina@pec.regione.lombardia.it', 'affari.generali@comune.berbenno.so.it', '0342492108', 'www.comune.berbenno.so.it', 'UFM2N3'),
  ('Comune di Bianzone', 'Bianzone', 'SO', 'Lombardia', 1263, '00110960143', 'Via Teglio 1', '23030', 'protocollo.bianzone@cert.provincia.so.it', null, '0342720107', 'www.comune.bianzone.so.it', 'UFLPXP'),
  ('Comune di Bormio', 'Bormio', 'SO', 'Lombardia', 3908, '00099580144', 'Via Peccedi, 1', '23032', 'bormio@pec.cmav.so.it', 'info@comune.bormio.so.it', '0342912211', 'www.comune.bormio.so.it', 'UF3W25'),
  ('Comune di Buglio in Monte', 'Buglio in Monte', 'SO', 'Lombardia', 2057, '00115150146', 'Piazza della Liberta'', 1', '23010', 'protocollo.buglioinmonte@cert.provincia.so.it', 'ragioneria@comune.buglioinmonte.so.it', '0342620020', 'www.comune.buglioinmonte.so.it', 'UFUK5S'),
  ('Comune di Caiolo', 'Caiolo', 'SO', 'Lombardia', 1034, '00109380147', 'Via Marconi, 3', '23010', 'protocollo.caiolo@cert.provincia.so.it', 'ragioneria@comune.caiolo.so.it', '0342355004', 'www.comune.caiolo.so.it', 'UFGEXL'),
  ('Comune di Campodolcino', 'Campodolcino', 'SO', 'Lombardia', 914, '00115270142', 'Via Don Romeo Ballerini, 8', '23021', 'protocollo.campodolcino@cert.provincia.so.it', 'comune@comune.campodolcino.so.it', '034350113', 'www.comune.campodolcino.so.it', 'UF2CXT'),
  ('Comune di Caspoggio', 'Caspoggio', 'SO', 'Lombardia', 1316, '00111600144', 'Piazza Milano 14', '23020', 'comune.caspoggio@pec.regione.lombardia.it', 'info@comune.caspoggio.so.it', '0342453625', 'www.comune.caspoggio.so.it', 'UF9LVK'),
  ('Comune di Castello dell''Acqua', 'Castello dell''Acqua', 'SO', 'Lombardia', 607, '80001970146', 'Piazza Roma, 1', '23030', 'comune.castellodellacqua@pec.regione.lombardia.it', 'info@comune.castellodellacqua.so.it', '0342482206', 'www.comune.castellodellacqua.so.it', 'UFG5W3'),
  ('Comune di Castione Andevenno', 'Castione Andevenno', 'SO', 'Lombardia', 1572, '00093810141', 'Via ROMA 485', '23012', 'protocollo.castioneandevenno@cert.provincia.so.it', null, '0342358006', 'www.comune.castioneandevenno.so.it', 'UFDPQQ'),
  ('Comune di Cedrasco', 'Cedrasco', 'SO', 'Lombardia', 423, '00092630144', 'Via Vittorio Veneto', '23010', 'protocollo.cedrasco@cert.provincia.so.it', 'info@comune.cedrasco.so.it', '0342492159', 'www.comune.cedrasco.so.it', 'UFWXDX'),
  ('Comune di Cercino', 'Cercino', 'SO', 'Lombardia', 806, '82000710143', 'Via Ligari, 2', '23016', 'protocollo.cercino@cert.provincia.so.it', 'amministrazione@comune.cercino.so.it', '0342651820', 'www.comune.cercino.so.it', 'UF490O'),
  ('Comune di Chiavenna', 'Chiavenna', 'SO', 'Lombardia', 7294, '00115790149', 'Piazza Bertacchi, 2', '23022', 'protocollo.chiavenna@cert.provincia.so.it', 'info@comune.chiavenna.so.it', '0343220211', 'www.comune.chiavenna.so.it', 'UFUS7M'),
  ('Comune di Chiesa in Valmalenco', 'Chiesa in Valmalenco', 'SO', 'Lombardia', 2219, '80002090142', 'Via G. Marconi, 8', '23023', 'comune.chiesainvalmalenco@pec.regione.lombardia.it', 'info@comune.chiesainvalmalenco.so.it', '0342451114', 'www.comune.chiesainvalmalenco.so.it', 'UFLXKN'),
  ('Comune di Chiuro', 'Chiuro', 'SO', 'Lombardia', 2434, '00114250145', 'Piazza Stefano Quadrio, 1', '23030', 'protocollo.chiuro@cert.provincia.so.it', 'info@comune.chiuro.so.it', '0342482221', 'https://www.comune.chiuro.so.it/', 'UF5FHX'),
  ('Comune di Cino', 'Cino', 'SO', 'Lombardia', 338, '82000850147', 'Via Roma,1', '23010', 'protocollo.cino@cert.provincia.so.it', 'amministrazione@comune.cino.so.it', '0342617275', 'www.comune.cino.so.it', 'UFS1FY'),
  ('Comune di Civo', 'Civo', 'SO', 'Lombardia', 1139, '00115160145', 'Frazione Serone, 65', '23010', 'protocollo.civo@cert.provincia.so.it', 'info@comune.civo.so.it', null, 'www.comune.civo.so.it', 'UF5FN8'),
  ('Comune di Colorina', 'Colorina', 'SO', 'Lombardia', 1357, '00091750141', 'Via Roma, 231 C', '23010', 'protocollo.colorina@cert.provincia.so.it', 'info@comune.colorina.so.it', '0342492113', 'www.comune.colorina.so.it', 'UFWKAA'),
  ('Comune di Cosio Valtellino', 'Cosio Valtellino', 'SO', 'Lombardia', 5586, '00116340142', 'Piazza S. Ambrogio 21', '23013', 'protocollo.cosio@cert.provincia.so.it', null, '0342634111', 'www.comune.cosiovaltellino.so.it', 'UF04BV'),
  ('Comune di Dazio', 'Dazio', 'SO', 'Lombardia', 521, '00105770143', 'Via Cesare Battisti 2', '23010', 'protocollo.dazio@cert.provincia.so.it', 'amministrazione@comune.dazio.so.it', '0342650123', 'www.comune.dazio.so.it', 'UFVIZ8'),
  ('Comune di Delebio', 'Delebio', 'SO', 'Lombardia', 3353, '00097780142', 'Piazza S.Domenica,3', '23014', 'protocollo.delebio@cert.provincia.so.it', 'amministrazione@comune.delebio.so.it', '0342685110', 'www.comune.delebio.so.it', 'UFUKLV'),
  ('Comune di Dubino', 'Dubino', 'SO', 'Lombardia', 3847, '00118940147', 'Via Valeriana n. 52', '23015', 'protocollo.dubino@cert.provincia.so.it', 'ufficioprotocollo@comune.dubino.so.it', '0342680195', 'www.comune.dubino.so.it', 'UFIKCO'),
  ('Comune di Faedo Valtellino', 'Faedo Valtellino', 'SO', 'Lombardia', 508, '00092610146', 'Via Roma n.445', '23020', 'protocollo.faedo@cert.provincia.so.it', 'info@comune.faedovaltellino.so.it', '03462566090', 'https://www.comune.faedovaltellino.so.it', 'UF1X9F'),
  ('Comune di Forcola', 'Forcola', 'SO', 'Lombardia', 753, '00137850145', 'Via Roma, 29', '23010', 'protocollo.forcola@cert.provincia.so.it', 'amministrazione@comune.forcola.so.it', '0342668130', 'www.comune.forcola.so.it', 'UFAWSS'),
  ('Comune di Fusine', 'Fusine', 'SO', 'Lombardia', 545, '00092620145', 'Piazza Vittorio Emanuele N. 20', '23010', 'protocollo.fusine@cert.provincia.so.it', null, '0342492141', 'www.comune.fusine.so.it', 'UFR2WD'),
  ('Comune di Gerola Alta', 'Gerola Alta', 'SO', 'Lombardia', 158, '00105780142', 'Via Nazionale n. 37', '23010', 'protocollo.gerola@cert.provincia.so.it', 'amministrazione@comune.gerolaalta.so.it', '0342690024', 'www.comune.gerolaalta.so.it', 'UF9Z8O'),
  ('Comune di Gordona', 'Gordona', 'SO', 'Lombardia', 1956, '00115780140', 'Piazza S. Martino, 1', '23020', 'comune.gordona@pec.regione.lombardia.it', 'info@comune.gordona.so.it', '03432321', 'www.comune.gordona.so.it', 'UFBCHN'),
  ('Comune di Grosio', 'Grosio', 'SO', 'Lombardia', 4230, '00118960145', 'Via Roma , 34', '23033', 'protocollo.grosio@cert.provincia.so.it', 'protocollo@comune.grosio.so.it', '0342841220', 'www.comune.grosio.so.it', 'UFJQTS'),
  ('Comune di Grosotto', 'Grosotto', 'SO', 'Lombardia', 1641, '00090290149', 'Via Roma 2', '23034', 'protocollo.grosotto@cert.provincia.so.it', 'protocollo@comune.grosotto.so.it', '0342887107', 'www.comune.grosotto.so.it', 'UFEUZH'),
  ('Comune di Lanzada', 'Lanzada', 'SO', 'Lombardia', 1227, '00111620142', 'Via San Giovanni N. 432', '23020', 'comune.lanzada@pec.regione.lombardia.it', null, '0342453243', 'www.comune.lanzada.so.it', 'UF7LCM'),
  ('Comune di Livigno', 'Livigno', 'SO', 'Lombardia', 6663, '83000850145', 'Plaza Dal Comun, 93', '23041', 'comune.livigno@legalmail.it', 'segreteria@comune.livigno.so.it', '0342991111', 'www.comune.livigno.so.it', 'UFBVXC'),
  ('Comune di Lovero', 'Lovero', 'SO', 'Lombardia', 608, '00105070148', 'Via A.Venosta 1/A', '23030', 'protocollo.lovero@cert.provincia.so.it', 'protocollo@comune.lovero.so.it', '0342770055', 'www.comune.lovero.so.it', 'UFARFM'),
  ('Comune di Madesimo', 'Madesimo', 'SO', 'Lombardia', 505, '00133750141', 'Via Nazionale 20', '23024', 'protocollo.madesimo@cert.provincia.so.it', 'info@comune.madesimo.so.it', '034353257', 'www.comune.madesimo.so.it', 'UFUBNA'),
  ('Comune di Mantello', 'Mantello', 'SO', 'Lombardia', 747, '00099000143', 'Via Soriate 1', '23016', 'protocollo.mantello@cert.provincia.so.it', 'amministrazione@comune.mantello.so.it', '0342680156', 'www.comune.mantello.so.it', 'UFH24A'),
  ('Comune di Mazzo di Valtellina', 'Mazzo di Valtellina', 'SO', 'Lombardia', 1009, '00104450143', 'Via Mortirolo, 5', '23030', 'protocollo.mazzo@cert.provincia.so.it', 'protocollo@comune.mazzo.so.it', '0342861014', 'www.comune.mazzo.so.it', 'UFD58M'),
  ('Comune di Mello', 'Mello', 'SO', 'Lombardia', 950, '00097750145', 'Piazza S. Fedele, 1', '23010', 'protocollo.mello@cert.provincia.so.it', 'amministrazione@comune.mello.so.it', '0342654031', 'www.comune.mello.so.it', 'UFBXOY'),
  ('Comune di Mese', 'Mese', 'SO', 'Lombardia', 1889, '00099030140', 'Piazza Don Albino Del Curto,6', '23020', 'protocollo.mese@cert.provincia.so.it', 'info@comune.mese.so.it', '034341000', 'www.comune.mese.so.it', 'UFP8ZC'),
  ('Comune di Montagna in Valtellina', 'Montagna in Valtellina', 'SO', 'Lombardia', 2945, '00110940145', 'Via Piazza 296', '23020', 'protocollo.montagnainvaltellina@cert.provincia.so.it', 'info@comune.montagnainvaltellina.so.it', '0342380077', 'www.comune.montagnainvaltellina.so.it', 'UFOP50'),
  ('Comune di Morbegno', 'Morbegno', 'SO', 'Lombardia', 12421, '00098990146', 'v. San Pietro 22', '23017', 'protocollo.morbegno@cert.provincia.so.it', 'municipio@comune.morbegno.so.it', '0342606211', 'www.comune.morbegno.so.it', 'UFDOO7'),
  ('Comune di Novate Mezzola', 'Novate Mezzola', 'SO', 'Lombardia', 1923, '00104440144', 'Piazza Europa N.1', '23025', 'protocollo.novatemezzola@cert.provincia.so.it', 'info@comune.novatemezzola.so.it', '034363040', 'www.comune.novatemezzola.so.it', 'UFMM48'),
  ('Comune di Pedesina', 'Pedesina', 'SO', 'Lombardia', 40, '00098670144', 'Via San Rocco, 2', '23010', 'protocollo.pedesina@cert.provincia.so.it', 'amministrazione@comune.pedesina.so.it', '0342651767', 'www.comune.pedesina.so.it', 'UFH32Y'),
  ('Comune di Piantedo', 'Piantedo', 'SO', 'Lombardia', 1425, '00090820143', 'Via Garibaldi, 225', '23010', 'protocollo.piantedo@cert.provincia.so.it', 'amministrazione@comune.piantedo.so.it', null, 'www.comune.piantedo.so.it', 'UFZQ4F'),
  ('Comune di Piateda', 'Piateda', 'SO', 'Lombardia', 2059, '00108190141', 'Via Ragazzi Del 99 1', '23020', 'protocollo.piateda@cert.provincia.so.it', 'info@comune.piateda.so.it', '0342370221', 'www.comune.piateda.so.it', 'UF8RP3'),
  ('Comune di Piuro', 'Piuro', 'SO', 'Lombardia', 1917, '00104370143', 'Strada COMUNALE DEL PALAZZO VERTEMATE N.24', '23020', 'protocollo.piuro@cert.provincia.so.it', 'ufficio.protocollo@comune.piuro.so.it', '034332327', 'www.comune.piuro.so.it/', 'UFMR0J'),
  ('Comune di Poggiridenti', 'Poggiridenti', 'SO', 'Lombardia', 1825, '00109390146', 'Via San Fedele,52', '23020', 'protocollo.poggiridenti@cert.provincia.so.it', null, '0343380842', 'www.comune.poggiridenti.so.it', 'UFZJ1M'),
  ('Comune di Ponte in Valtellina', 'Ponte in Valtellina', 'SO', 'Lombardia', 2217, '00120490149', 'Via Roma, 12', '23026', 'protocollo.ponteinvaltellina@cert.provincia.so.it', 'info@comune.ponteinvaltellina.so.it', '0342482222', 'www.comune.ponteinvaltellina.so.it', 'UFOMJB'),
  ('Comune di Postalesio', 'Postalesio', 'SO', 'Lombardia', 647, '00094910148', 'Via Ezio Vanoni, n. 7', '23010', 'protocollo.postalesio@cert.provincia.so.it', 'info@comune.postalesio.so.it', '0342563370', 'www.comune.postalesio.so.it', 'UF1SED'),
  ('Comune di Prata Camportaccio', 'Prata Camportaccio', 'SO', 'Lombardia', 2942, '00115280141', 'Via Ezio Vanoni, 2', '23020', 'comune.pratacamportaccio@pec.regione.lombardia.it', null, '034332351', 'www.comune.pratacamportaccio.so.it', 'UFIDFK'),
  ('Comune di Rasura', 'Rasura', 'SO', 'Lombardia', 277, '00105820146', 'Via Valeriana 22', '23010', 'protocollo.rasura@cert.provincia.so.it', 'amministrazione@comune.rasura.so.it', '0342616006', 'www.comune.rasura.so.it', 'UF88KT'),
  ('Comune di Rogolo', 'Rogolo', 'SO', 'Lombardia', 575, '00104390141', 'Via Piazza 5', '23010', 'protocollo.rogolo@cert.provincia.so.it', 'amministrazione@comune.rogolo.so.it', '0342683523', 'www.comune.rogolo.so.it', 'UFZ41S'),
  ('Comune di Samolaco', 'Samolaco', 'SO', 'Lombardia', 2871, '00115260143', 'Viale Europa n. 1487', '23027', 'protocollo.samolaco@cert.provincia.so.it', 'info@comune.samolaco.so.it', '034338003', 'www.comune.samolaco.so.it', 'UF7VB3'),
  ('Comune di San Giacomo Filippo', 'San Giacomo Filippo', 'SO', 'Lombardia', 371, '00096420146', 'Via Centro, 66', '23020', 'protocollo.sangiacomofilippo@cert.provincia.so.it', 'segreteria@comune.sangiacomofilippo.so.it', '034332430', 'www.comune.sangiacomofilippo.so.it/', 'UF4CFE'),
  ('Comune di Sernio', 'Sernio', 'SO', 'Lombardia', 500, '00105180145', 'Via Roma, 11', '23030', 'protocollo.sernio@cert.provincia.so.it', 'protocollo@comune.sernio.so.it', '0342701772', 'www.comune.sernio.so.it', 'UFT385'),
  ('Comune di Sondalo', 'Sondalo', 'SO', 'Lombardia', 3859, '00109670141', 'Via Vanoni, 32', '23035', 'sondalo@pec.cmav.so.it', 'info@comune.sondalo.so.it', '0342809011', 'www.comune.sondalo.so.it', 'UFR9PM'),
  ('Comune di Sondrio', 'Sondrio', 'SO', 'Lombardia', 21495, '00095450144', 'Piazza Campello, 1', '23100', 'protocollo@cert.comune.sondrio.it', 'info@comune.sondrio.it', '0342526319', 'https://comune.sondrio.it', 'UFEMQG'),
  ('Comune di Spriana', 'Spriana', 'SO', 'Lombardia', 85, '00091740142', 'Via Centro N 1', '23020', 'comune.spriana@pec.regione.lombardia.it', 'info@comune.spriana.so.it', '0342512557', 'www.comune.spriana.so.it', 'UF2QLM'),
  ('Comune di Talamona', 'Talamona', 'SO', 'Lombardia', 4582, '00120480140', 'Via Combattenti e Reduci 70', '23018', 'comune.talamona@halleycert.it', 'info@comune.talamona.so.it', '0342670703', 'www.comune.talamona.so.it', 'UF5MKE'),
  ('Comune di Tartano', 'Tartano', 'SO', 'Lombardia', 198, '00097760144', 'Via Roma, 4', '23010', 'protocollo.tartano@cert.provincia.so.it', 'amministrazione@comune.tartano.so.it', '0342645004', 'www.comune.tartano.so.it', 'UFQCJ2'),
  ('Comune di Teglio', 'Teglio', 'SO', 'Lombardia', 4683, '83000770145', 'Piazza S. Eufemia, 7', '23036', 'protocollo.teglio@cert.provincia.so.it', null, '0342789011', 'www.comune.teglio.so.it', 'UFHOYD'),
  ('Comune di Tirano', 'Tirano', 'SO', 'Lombardia', 8849, '00114980147', 'Piazza Cavour 18', '23037', 'comune.tirano@legalmail.it', 'ufficio.protocollo@comune.tirano.so.it', '0342701256', 'www.comune.tirano.so.it', 'UF9KER'),
  ('Comune di Torre di Santa Maria', 'Torre di Santa Maria', 'SO', 'Lombardia', 712, '00092590140', 'Via Cortile Nuovo,1', '23020', 'comune.torredisantamaria@pec.regione.lombardia.it', 'info@comune.torredisantamaria.so.it', '0342558300', 'www.comune.torredisantamaria.so.it', 'UFMRFQ'),
  ('Comune di Tovo di Sant''Agata', 'Tovo di Sant''Agata', 'SO', 'Lombardia', 611, '00104650148', 'Via Retta,6', '23030', 'protocollo.tovo@cert.provincia.so.it', 'protocollo@comune.tovo.so.it', '0342770058', 'www.comune.tovo.so.it', 'UFI6AU'),
  ('Comune di Traona', 'Traona', 'SO', 'Lombardia', 2903, '00114280142', 'Via Paravicini, 10', '23019', 'protocollo.traona@cert.provincia.so.it', 'amministrazione@comune.traona.so.it', '0342652341', 'www.comune.traona.so.it', 'UFCOYK'),
  ('Comune di Tresivio', 'Tresivio', 'SO', 'Lombardia', 2038, '00109370148', 'Piazza Santi Pietro e Paolo 1', '23020', 'protocollo.tresivio@cert.provincia.so.it', null, '0342430109', 'www.comune.tresivio.so.it', 'UFHRJB'),
  ('Comune di Val Masino', 'Val Masino', 'SO', 'Lombardia', 825, '00090870148', 'Via Roma,2', '23010', 'protocollo.valmasino@cert.provincia.so.it', 'segreteria@comune.valmasino.so.it', '0342640101', 'www.comune.valmasino.so.it', 'UFTKXQ'),
  ('Comune di Valdidentro', 'Valdidentro', 'SO', 'Lombardia', 4107, '00111020145', 'Piazza IV Novembre, 5', '23038', 'valdidentro@pec.cmav.so.it', 'info@comune.valdidentro.so.it', '0342921921', 'www.comune.valdidentro.so.it', 'UFF32G'),
  ('Comune di Valdisotto', 'Valdisotto', 'SO', 'Lombardia', 3529, '83000910147', 'Via E. De Gasperi, 1', '23030', 'valdisotto@pec.cmav.so.it', 'info@comune.valdisotto.so.it', '0342952021', 'www.comune.valdisotto.so.it', 'UFA2XV'),
  ('Comune di Valfurva', 'Valfurva', 'SO', 'Lombardia', 2431, '00114700149', 'Piazza Frodaglio, 3', '23030', 'valfurva@pec.cmav.so.it', 'info@comune.valfurva.so.it', '0342945702', 'www.comune.valfurva.so.it', 'UFWS2B'),
  ('Comune di Verceia', 'Verceia', 'SO', 'Lombardia', 1091, '00104660147', 'Via NAZIONALE N.1542', '23020', 'protocollo.verceia@cert.provincia.so.it', 'ragioneria@comune.verceia.so.it', '034344137', 'www.comune.verceia.so.it', 'UF5N27'),
  ('Comune di Vervio', 'Vervio', 'SO', 'Lombardia', 204, '00104430145', 'Via Roma, 18', '23030', 'protocollo.vervio@cert.provincia.so.it', 'protocollo@comune.vervio.so.it', '0342770057', 'www.comune.vervio.so.it', 'UFIKJY'),
  ('Comune di Villa di Chiavenna', 'Villa di Chiavenna', 'SO', 'Lombardia', 992, '81002350148', 'Via Roma, 9', '23029', 'protocollo.villadichiavenna@cert.provincia.so.it', 'info@comune.villadichiavenna.so.it', '034340507', 'www.comune.villadichiavenna.so.it', 'UFUXCR'),
  ('Comune di Villa di Tirano', 'Villa di Tirano', 'SO', 'Lombardia', 3013, '00111050142', 'Piazza Torelli 3', '23030', 'comune.villaditirano@pec.regione.lombardia.it', null, '0342795001', 'www.comune.villaditirano.so.it', 'UFA0X8');

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

-- Controllo: SO = 77 comuni / 179.268 ab.
select provincia, count(*) as comuni, sum(abitanti) as abitanti,
       count(pec) as con_pec, count(email) as con_email, count(phone) as con_telefono
from companies
where tipo = 'pa' and name ilike 'Comune di %' and provincia = 'SO'
group by provincia;



-- =====================================================================
--  CRM ENER.ING — Comuni della provincia di Cremona con abitanti e contatti
--  Esegui nel SQL Editor di Supabase. Sicuro e ri-eseguibile (non cancella nulla):
--   * aggiunge ai clienti le colonne "abitanti" ed "email" (se mancano);
--   * inserisce i 113 Comuni della provincia di Cremona come clienti PA;
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
  ('Comune di Acquanegra Cremonese', 'Acquanegra Cremonese', 'CR', 'Lombardia', 1167, '00304070196', 'Via Stazione 128', '26020', 'comune.acquanegracremonese@pec.regione.lombardia.it', 'ragioneria@comune.acquanegra.cr.it', '037270003', 'www.comune.acquanegra.cr.it', 'UFYR67'),
  ('Comune di Agnadello', 'Agnadello', 'CR', 'Lombardia', 3963, '00304920192', 'Via Dante, 57', '26020', 'anagrafe.comune.agnadello@pec.regione.lombardia.it', 'info@comune.agnadello.cr.it', '0373976192', 'www.comune.agnadello.cr.it', 'UFX4JB'),
  ('Comune di Annicco', 'Annicco', 'CR', 'Lombardia', 1980, '00304860190', 'Piazza Garibaldi, 6', '26021', 'comune.annicco@pec.regione.lombardia.it', 'info@comuneannicco.it', '037479064', 'www.comune.annicco.cr.it', 'UFV2WR'),
  ('Comune di Azzanello', 'Azzanello', 'CR', 'Lombardia', 631, '00310040191', 'Via Valcarenghi N. 5', '26010', 'comune.azzanello@pec.regione.lombardia.it', 'info@comune.azzanello.cr.it', '037466624', 'www.comune.azzanello.cr.it', 'UFIXCV'),
  ('Comune di Bagnolo Cremasco', 'Bagnolo Cremasco', 'CR', 'Lombardia', 5115, '00116170192', 'Via Geroldi, 1', '26010', 'comune.bagnolocremasco@mailcert.cremasconline.it', 'protocollo@comune.bagnolocremasco.cr.it', '0373237870', 'www.comune.bagnolocremasco.cr.it', 'UF8GUF'),
  ('Comune di Bonemerse', 'Bonemerse', 'CR', 'Lombardia', 1434, '00308090190', 'Via Roma, 25', '26040', 'comune.bonemerse@pec.regione.lombardia.it', 'info@unionecenturiati.cr.it', '0372496020', 'http://www.comune.bonemerse.cr.it/', 'UFNLSE'),
  ('Comune di Bordolano', 'Bordolano', 'CR', 'Lombardia', 602, '00305100190', 'Via Maggiore, 16', '26020', 'bordolano@postemailcertificata.it', null, '037295926', 'www.comune.bordolano.cr.it', 'UFAHUW'),
  ('Comune di Calvatone', 'Calvatone', 'CR', 'Lombardia', 1130, '81000570192', 'Via Umberto, 134', '26030', 'comune.calvatone@pec.regione.lombardia.it', 'anagrafe@comune.calvatone.cr.it', '037597031', 'www.comune.calvatone.cr.it', 'UF6M6M'),
  ('Comune di Camisano', 'Camisano', 'CR', 'Lombardia', 1253, '00307000190', 'Piazza Maggiore, 1', '26010', 'comune.camisano@pec.regione.lombardia.it', 'protocollo@comune.camisano.cr.it', '037377212', 'comune.camisano.cr.it', 'UFWZH7'),
  ('Comune di Campagnola Cremasca', 'Campagnola Cremasca', 'CR', 'Lombardia', 649, '00308170190', 'Via Ponte Rino, 9', '26010', 'pec@pec.comune.campagnolacremasca.cr.it', 'info@comune.campagnolacremasca.cr.it', '037374325', 'www.comune.campagnolacremasca.cr.it', 'UFRAQ4'),
  ('Comune di Capergnanica', 'Capergnanica', 'CR', 'Lombardia', 2150, '00330930199', 'Piazza IV Novembre, 2', '26010', 'comune.capergnanica@pec.regione.lombardia.it', 'info@comune.capergnanica.cr.it', '037376021', 'www.comune.capergnanica.cr.it', 'UFPDQ4'),
  ('Comune di Cappella Cantone', 'Cappella Cantone', 'CR', 'Lombardia', 538, '00305680191', 'Piazza Del Municipio N. 11', '26020', 'contratti.comune.cappellacantone@pec.regione.lombardia.it', 'info@comune.cappellacantone.cr.it', null, 'www.comune.cappellacantone.cr.it/', 'UF09NK'),
  ('Comune di Cappella de'' Picenardi', 'Cappella de'' Picenardi', 'CR', 'Lombardia', 422, '00312100191', 'Piazza Roma 2', '26030', 'comune.cappelladepicenardi@pec.regione.lombardia.it', 'ragioneria@comune.cappelladepicenardi.cr.it', '0372835455', 'www.comune.cappelladepicenardi.cr.it/', 'UFWEGL'),
  ('Comune di Capralba', 'Capralba', 'CR', 'Lombardia', 2293, '00323260190', 'Via Piave, 2', '26010', 'pec@pec.comune.capralba.cr.it', 'segreteria@comune.capralba.cr.it', '03734521', 'www.comune.capralba.cr.it', 'UFYTU9'),
  ('Comune di Casalbuttano ed Uniti', 'Casalbuttano ed Uniti', 'CR', 'Lombardia', 3796, '00305070195', 'Via Municipio 4', '26011', 'egov.casalbuttano@cert.poliscomuneamico.net', 'segreteria@comune.casalbuttanoeduniti.cr.it', '0374364412', 'www.comune.casalbuttanoeduniti.cr.it', 'UFXPA6'),
  ('Comune di Casale Cremasco-Vidolasco', 'Casale Cremasco-Vidolasco', 'CR', 'Lombardia', 1815, '00301440194', 'Via Roma,56', '26010', 'comune.casalecrvidolasco@pec.regione.lombardia.it', 'ragioneria@comune.casalecremascovidolasco.cr.it', '0373456720', 'www.comune.casalecremascovidolasco.cr.it', 'UFOUAO'),
  ('Comune di Casaletto Ceredano', 'Casaletto Ceredano', 'CR', 'Lombardia', 1171, '00330940198', 'Via Marconi, 12', '26010', 'comune.casalettoceredano@pec.regione.lombardia.it', 'ragioneria@comune.casalettoceredano.cr.it', '0373262305', 'www.comune.casalettoceredano.cr.it', 'UF9E0P'),
  ('Comune di Casaletto di Sopra', 'Casaletto di Sopra', 'CR', 'Lombardia', 527, '00325800191', 'Piazza Roma, 1', '26014', 'comune.casalettodisopra@pec.regione.lombardia.it', 'info@comune.casalettodisopra.cr.it', '037372277', 'www.comune.casalettodisopra.cr.it', 'UFK4X5'),
  ('Comune di Casaletto Vaprio', 'Casaletto Vaprio', 'CR', 'Lombardia', 1778, '00332120195', 'Piazza Maggiore, 7', '26010', 'comune.casalettovaprio@mailcert.cremasconline.it', 'info@comune.casalettovaprio.cr.it', '0373273100', 'www.comune.casalettovaprio.cr.it/', 'UFV546'),
  ('Comune di Casalmaggiore', 'Casalmaggiore', 'CR', 'Lombardia', 15114, '00304940190', 'p. Garibaldi 26', '26041', 'protocollo.comune.casalmaggiore@pec.regione.lombardia.it', null, null, 'www.comune.casalmaggiore.cr.it', null),
  ('Comune di Casalmorano', 'Casalmorano', 'CR', 'Lombardia', 1727, '00314350190', 'Via Roma,13', '26020', 'comune.casalmorano@pec.regione.lombardia.it', null, null, 'https://www.comune.casalmorano.cr.it/', 'UFQT5T'),
  ('Comune di Castel Gabbiano', 'Castel Gabbiano', 'CR', 'Lombardia', 542, '00307010199', 'Via Alfonso Vimercati Sanseverino n. 1', '26010', 'comune.castelgabbiano@pec.regione.lombardia.it', 'info@comune.castelgabbiano.cr.it', null, 'www.comune.castelgabbiano.cr.it', 'UF8W9J'),
  ('Comune di Casteldidone', 'Casteldidone', 'CR', 'Lombardia', 542, '00327520193', 'Via XXV Aprile, 20', '26030', 'comune.casteldidone@pec.regione.lombardia.it', 'demografici@comune.casteldidone.cr.it', '037591102', 'www.comune.casteldidone.cr.it', 'UFWOUV'),
  ('Comune di Castelleone', 'Castelleone', 'CR', 'Lombardia', 9340, '83001230198', 'Piazza Comune, 3', '26012', 'comune.castelleone@pec.regione.lombardia.it', 'info@comune.castelleone.cr.it', '0374356311', 'www.comune.castelleone.cr.it', 'UFHGU8'),
  ('Comune di Castelverde', 'Castelverde', 'CR', 'Lombardia', 5699, '00299440198', 'Piazza Municipio 23', '26022', 'comune.castelverde@pec.regione.lombardia.it', 'info@comune.castelverde.cr.it', null, 'www.comune.castelverde.cr.it', 'UFNKYD'),
  ('Comune di Castelvisconti', 'Castelvisconti', 'CR', 'Lombardia', 306, '00310070198', 'Via Roma 1', '26010', 'castelvisconti@pec.eleusi.at', 'info@comune.castelvisconti.cr.it', '037466643', 'www.comune.castelvisconti.cr.it', 'UFTO95'),
  ('Comune di Cella Dati', 'Cella Dati', 'CR', 'Lombardia', 514, '00304320195', 'Via Roma, 16', '26040', 'comune.celladati@pec.regione.lombardia.it', 'ragioneria@comune.celladati.cr.it', '037267821', 'www.comune.celladati.cr.it', 'UFE7S8'),
  ('Comune di Chieve', 'Chieve', 'CR', 'Lombardia', 2270, '00174760199', 'Via San Giorgio, 28', '26010', 'comune.chieve@mailcert.cremasconline.it', 'info@comune.chieve.cr.it', null, 'www.comune.chieve.cr.it', 'UFBXBJ'),
  ('Comune di Cicognolo', 'Cicognolo', 'CR', 'Lombardia', 977, '00312110190', 'Via Guglielmo Marconi. 25', '26030', 'protocollo.comune.cicognolo@pec.regione.lombardia.it', 'segreteria@comune.cicognolo.cr.it', '0372835923', 'www.comune.cicognolo.cr.it', 'UF7J65'),
  ('Comune di Cingia de'' Botti', 'Cingia de'' Botti', 'CR', 'Lombardia', 1171, '00304660194', 'Via Giuseppina, 79', '26042', 'anagrafe.comune.cingiadebotti@pec.regione.lombardia.it', 'anagrafe@comune.cingiadebotti.cr.it', '097596141', 'www.comune.cingiadebotti.cr.it', 'UFGIK1'),
  ('Comune di Corte de'' Cortesi con Cignone', 'Corte de'' Cortesi con Cignone', 'CR', 'Lombardia', 1070, '00316550193', 'Piazza V. Veneto, 1', '26020', 'comune.cortedecortesiconcignone@pec.regione.lombardia.it', 'ragioneria@comune.cortedecortesiconcignone.cr.it', null, 'WWW.COMUNE.CORTEDECORTESICONCIGNONE.CR.IT', 'UF297E'),
  ('Comune di Corte de'' Frati', 'Corte de'' Frati', 'CR', 'Lombardia', 1318, '00323930198', 'Piazza Roma 1', '26010', 'comune.cortedefrati.cr@pec.it', 'info@comune.cortedefrati.cr.it', '037293121', 'www.comune.cortedefrati.cr.it', 'UF4VX6'),
  ('Comune di Credera Rubbiano', 'Credera Rubbiano', 'CR', 'Lombardia', 1476, '82007130196', 'Via Roma, 28', '26010', 'comune.crederarubbiano@pec.regione.lombardia.it', 'info@comune.crederarubbiano.cr.it', '037361913', 'www.comune.crederarubbiano.cr.it', 'UFROSQ'),
  ('Comune di Crema', 'Crema', 'CR', 'Lombardia', 34147, '91035680197', 'Piazza Duomo, 25', '26013', 'protocollo@comunecrema.telecompost.it', null, null, 'www.comune.crema.cr.it', 'UFPV04'),
  ('Comune di Cremona', 'Cremona', 'CR', 'Lombardia', 71093, '00297960197', 'Piazza Del Comune, 8', '26100', 'protocollo@comunedicremona.legalmail.it', null, null, 'www.comune.cremona.it', 'UFH9AS'),
  ('Comune di Cremosano', 'Cremosano', 'CR', 'Lombardia', 1730, '82001930195', 'Piazza Garibaldi, 3', '26010', 'comune.cremosano@mailcert.cremasconline.it', 'ragioneria@comune.cremosano.cr.it', '0373273053', 'www.comune.cremosano.cr.it', 'UFDCR7'),
  ('Comune di Crotta d''Adda', 'Crotta d''Adda', 'CR', 'Lombardia', 613, '80003550193', 'Via Roma, 47', '26020', 'comune.crottadadda@pec.regione.lombardia.it', 'protocollo@comune.crottadadda.cr.it', '0372722880', 'www.comune.crottadadda.cr.it', 'UFHDGH'),
  ('Comune di Cumignano sul Naviglio', 'Cumignano sul Naviglio', 'CR', 'Lombardia', 406, '00310050190', 'Via Roma, 5', '26020', 'pec@pec.comune.cumignano.cr.it', 'info@comune.cumignano.cr.it', '037471133', 'www.comune.cumignano.cr.it', 'UFWUZZ'),
  ('Comune di Derovere', 'Derovere', 'CR', 'Lombardia', 284, '00304350192', 'Piazza San Giorgio', '26040', 'comune.derovere@pec.regione.lombardia.it', 'ragioneria@comunederovere.it', '0372624883', 'www.comune.derovere.cr.it', 'UFP4W9'),
  ('Comune di Dovera', 'Dovera', 'CR', 'Lombardia', 3734, '00330920190', 'Piazza XXV Aprile', '26010', 'dovera@postemailcertificata.it', null, '0373978282', 'www.comune.dovera.cr.it', 'UFMO3L'),
  ('Comune di Fiesco', 'Fiesco', 'CR', 'Lombardia', 1217, '00304300197', 'Via Roma 30', '26010', 'comune.fiesco@pec.regione.lombardia.it', null, '0374370014', 'www.comune.fiesco.cr.it', 'UF6M4F'),
  ('Comune di Formigara', 'Formigara', 'CR', 'Lombardia', 1038, '00333310191', 'Piazza Europa 11', '26020', 'comune.formigara@pec.regione.lombardia.it', null, '037478022', 'www.comune.formigara.cr.it', 'UFPDST'),
  ('Comune di Gabbioneta-Binanuova', 'Gabbioneta-Binanuova', 'CR', 'Lombardia', 859, '00325740199', 'Via DEL PATRIOTA 28', '26030', 'comune.gabbioneta-binanuova@pec.regione.lombardia.it', 'info@comune.gabbionetabinanuova.cr.it', '372844314', 'www.comune.gabbionetabinanuova.cr.it', 'UF86SA'),
  ('Comune di Gadesco-Pieve Delmona', 'Gadesco-Pieve Delmona', 'CR', 'Lombardia', 1882, '00304890197', 'Via Roma, 1', '26030', 'comune.gadescopd@legalmail.it', 'ragioneria@unionedelmona.cr.it', null, 'https://www.unionedelmona.cr.it/', 'UFXK72'),
  ('Comune di Genivolta', 'Genivolta', 'CR', 'Lombardia', 1082, '00310060199', 'Via Castello, 14', '26020', 'comune.genivolta@pec.regione.lombardia.it', 'info@comune.genivolta.cr.it', null, 'https://www.comune.genivolta.cr.it/', 'UFSKVL'),
  ('Comune di Gerre de'' Caprioli', 'Gerre de'' Caprioli', 'CR', 'Lombardia', 1310, '00304840192', 'Piazza Del Comune, 4', '26040', 'comune.gerredecaprioli@pec.regione.lombardia.it', null, '0372452322', 'www.comune.gerredecaprioli.cr.it', 'UFBKNX'),
  ('Comune di Gombito', 'Gombito', 'CR', 'Lombardia', 611, '00336550199', 'Via Civardi 15/A', '26020', 'comune.gombito@pec.regione.lombardia.it', 'ragioneria@comune.gombito.cr.it', '0374350535', 'www.comune.gombito.cr.it', 'UF4NKE'),
  ('Comune di Grontardo', 'Grontardo', 'CR', 'Lombardia', 1498, '00302910195', 'Piazza Roma N. 16', '26044', 'comune.grontardo@pec.regione.lombardia.it', null, '037289123', 'www.unionedeicomuni.cr.it', 'UFWXL4'),
  ('Comune di Grumello Cremonese ed Uniti', 'Grumello Cremonese ed Uniti', 'CR', 'Lombardia', 1725, '00302630199', 'Via Garibaldi, 14', '26023', 'comunegrumello@pec.it', 'protocollo@comune.grumellocremoneseeduniti.cr.it', '037270171', 'www.grumellocremonese.it', 'UFWXT3'),
  ('Comune di Gussola', 'Gussola', 'CR', 'Lombardia', 2687, '00298700196', 'Piazza Comaschi Carlo, 1', '26040', 'comune.gussola@pec.regione.lombardia.it', 'protocollo@comune.gussola.cr.it', '0375263311', 'www.comune.gussola.cr.it', 'UF3VBJ'),
  ('Comune di Isola Dovarese', 'Isola Dovarese', 'CR', 'Lombardia', 1065, '00309210193', 'Piazza Matteotti, 1', '26031', 'comune.isoladovarese@pec.regione.lombardia.it', 'info@comune.isoladovarese.cr.it', null, 'www.comune.isoladovarese.cr.it', 'UFCEW7'),
  ('Comune di Izano', 'Izano', 'CR', 'Lombardia', 1951, '00323090191', 'Via Gerardo Da Izano 2', '26010', 'comune.izano@pec.regione.lombardia.it', 'info@comune.izano.cr.it', '0373244100', 'www.comune.izano.cr.it', 'UFLAMS'),
  ('Comune di Madignano', 'Madignano', 'CR', 'Lombardia', 2764, '00302860192', 'Via Liberta'', 22', '26020', 'pec@pec.comune.madignano.cr.it', 'info@comune.madignano.cr.it', '037365139', 'https://www.comune.madignano.cr.it', 'UF1PW8'),
  ('Comune di Malagnino', 'Malagnino', 'CR', 'Lombardia', 1703, '00307050195', 'Via S.Ambrogio,24', '26030', 'comune.malagnino@pec.regione.lombardia.it', 'segreteria.malagnino@unionecenturiati.cr.it', '037258047', 'www.comune.malagnino.cr.it', 'UFM4EQ'),
  ('Comune di Martignana di Po', 'Martignana di Po', 'CR', 'Lombardia', 2024, '81000870196', 'Via Della Liberta'' 64', '26040', 'comune.martignanadipo@pec.regione.lombardia.it', 'segreteria@comune.martignanadipo.cr.it', '0375260062', 'www.comune.martignanadipo.cr.it', 'UFBMPD'),
  ('Comune di Monte Cremasco', 'Monte Cremasco', 'CR', 'Lombardia', 2217, '00122220197', 'Via Roma n. 12', '26010', 'segreteria.comune.montecremasco@pec.regione.lombardia.it', null, '0373791121', 'www.comune.montecremasco.cr.it', 'UF1LT2'),
  ('Comune di Montodine', 'Montodine', 'CR', 'Lombardia', 2394, '00304960198', 'Piazza XXV Aprile 10', '26010', 'comune.montodine@pec.regione.lombardia.it', 'segreteria@comune.montodine.cr.it', '037366104', 'www.comune.montodine.cr.it', 'UFSB2S'),
  ('Comune di Moscazzano', 'Moscazzano', 'CR', 'Lombardia', 697, '00304220197', 'Via Roma, 29', '26010', 'comune.moscazzano@pec.regione.lombardia.it', 'info@comune.moscazzano.cr.it', '037366121', 'www.comune.moscazzano.cr.it', 'UF1DIT'),
  ('Comune di Motta Baluffi', 'Motta Baluffi', 'CR', 'Lombardia', 769, '00326780194', 'Piazza Gaboardi 1', '26045', 'comune.mottabaluffi@pec.regione.lombardia.it', null, '0375969021', 'https://comune.mottabaluffi.cr.it/', 'G1EMYW'),
  ('Comune di Offanengo', 'Offanengo', 'CR', 'Lombardia', 5945, '00299140194', 'Piazza Sen Patrini 13', '26010', 'comune.offanengo@cert.legalmail.it', 'ragioneria@comune.offanengo.cr.it', '0373247301', 'www.comune.offanengo.cr.it', 'UFM0XV'),
  ('Comune di Olmeneta', 'Olmeneta', 'CR', 'Lombardia', 934, '00269750196', 'Via Dante 3', '26010', 'comune.olmeneta.cr@pec.it', 'info@comune.olmeneta.cr.it', '0372924121', 'www.comune.olmeneta.cr.it', 'UF14X6'),
  ('Comune di Ostiano', 'Ostiano', 'CR', 'Lombardia', 2825, '00322970195', 'Piazza Marconi 5', '26032', 'comune.ostiano@pec.regione.lombardia.it', 'segreteria@comune.ostiano.cr.it', '0372856911', 'www.comune.ostiano.cr.it', 'UFSDGC'),
  ('Comune di Paderno Ponchielli', 'Paderno Ponchielli', 'CR', 'Lombardia', 1292, '00314360199', 'Piazza Revellino, 3', '26024', 'comune.padernoponchielli@pec.regione.lombardia.it', 'info@comunedipadernoponchielli.cr.it', '0374367200', 'www.comunedipadernoponchielli.cr.it', 'UFSY6U'),
  ('Comune di Palazzo Pignano', 'Palazzo Pignano', 'CR', 'Lombardia', 3793, '00305120198', 'Via Crema, 3', '26020', 'comune.palazzopignano@mailcert.cremasconline.it', 'info@comune.palazzopignano.cr.it', '0373975511', 'www.comune.palazzopignano.cr.it', 'UF7B9J'),
  ('Comune di Pandino', 'Pandino', 'CR', 'Lombardia', 8988, '00135350197', 'Via Castello, 15', '26025', 'protocollo.comune.pandino@pec.it', null, '0373973300', 'www.comune.pandino.cr.it', 'UFPQ7J'),
  ('Comune di Persico Dosimo', 'Persico Dosimo', 'CR', 'Lombardia', 3250, '00323920199', 'Piazza Roma 4', '26043', 'comune.persicodosimo@pec.regione.lombardia.it', null, '037253921', 'https://www.unionedelmona.cr.it/', 'UFQCH1'),
  ('Comune di Pescarolo ed Uniti', 'Pescarolo ed Uniti', 'CR', 'Lombardia', 1547, '00304900194', 'Piazza Garibaldi 16', '26033', 'comune.pescaroloeduniti@pec.regione.lombardia.it', 'protocollo@comune.pescaroloeduniti.cr.it', '0372836012', 'www.comune.pescaroloeduniti.cr.it', 'UF15IF'),
  ('Comune di Pessina Cremonese', 'Pessina Cremonese', 'CR', 'Lombardia', 574, '00324120195', 'Via Della Repubblica, 1', '26030', 'comune.pessinacremonese@pec.regione.lombardia.it', 'info@comune.pessinacremonese.cr.it', '037287922', 'www.comune.pessinacremonese.cr.it', 'UFQHW0'),
  ('Comune di Piadena Drizzona', 'Piadena Drizzona', 'CR', 'Lombardia', 4063, '01695750198', 'Piazza Garibaldi, 3', '26034', 'comunepiadenadrizzona@pec.it', null, null, 'www.comunepiadenadrizzona.cr.it', 'UFSVD8'),
  ('Comune di Pianengo', 'Pianengo', 'CR', 'Lombardia', 2570, '00314650193', 'Via Roma, 59', '26010', 'comune.pianengo@mailcert.cremasconline.it', null, '0373752211', 'www.comune.pianengo.cr.it', 'UF264V'),
  ('Comune di Pieranica', 'Pieranica', 'CR', 'Lombardia', 1107, '00305000192', 'Via Marconi, 6', '26017', 'anagrafe.comune.pieranica@pec.regione.lombardia.it', null, '037371016', 'www.comune.pieranica.cr.it', 'UFMQZJ'),
  ('Comune di Pieve d''Olmi', 'Pieve d''Olmi', 'CR', 'Lombardia', 1238, '80003290196', 'Piazza XXV Aprile 8', '26040', 'comune.pievedolmi@pec.regione.lombardia.it', 'ufficio.ragioneria@comune.pievedolmi.cr.it', '0372626131', 'www.comune.pievedolmi.cr.it', 'UF3X9F'),
  ('Comune di Pieve San Giacomo', 'Pieve San Giacomo', 'CR', 'Lombardia', 1571, '00307040196', 'Piazza Liberta'', 3', '26035', 'comune.pievesangiacomo@pec.regione.lombardia.it', null, '037264331', 'www.comune.pievesangiacomo.cr.it', 'UFX207'),
  ('Comune di Pizzighettone', 'Pizzighettone', 'CR', 'Lombardia', 6242, '80003610195', 'Via Municipio 10', '26026', 'anagrafe.comune.pizzighettone@pec.regione.lombardia.it', 'ragioneria@comune.pizzighettone.cr.it', null, 'www.comune.pizzighettone.cr.it', 'UFENU2'),
  ('Comune di Pozzaglio ed Uniti', 'Pozzaglio ed Uniti', 'CR', 'Lombardia', 1416, '00330950197', 'Via Roma, 37', '26010', 'comune.pozzaglio@pec.regione.lombardia.it', 'info@comune.pozzaglio.cr.it', '037255125', 'www.comune.pozzaglio.cr.it', 'UFWU6Z'),
  ('Comune di Quintano', 'Quintano', 'CR', 'Lombardia', 932, '00305020190', 'Via IV Novembre 32', '26017', 'comune.quintano@pec.it', null, '037371013', 'www.comune.quintano.cr.it', 'UFXKLH'),
  ('Comune di Ricengo', 'Ricengo', 'CR', 'Lombardia', 1724, '00301430195', 'Via Roma 8', '26010', 'comune.ricengo@pec.regione.lombardia.it', 'info@comune.ricengo.cr.it', '0373267708', 'www.comune.ricengo.cr.it', 'UF4DPK'),
  ('Comune di Ripalta Arpina', 'Ripalta Arpina', 'CR', 'Lombardia', 1088, '00304970197', 'Piazza Marconi 1', '26010', 'comune.ripaltaarpina@pec.regione.lombardia.it', 'info@comune.ripaltaarpina.cr.it', '0373242544', 'www.comune.ripaltaarpina.cr.it', 'UF85J4'),
  ('Comune di Ripalta Cremasca', 'Ripalta Cremasca', 'CR', 'Lombardia', 3454, '00301970190', 'Via Roma, 5', '26010', 'comune.ripaltacremasca@pec.it', null, '037368131', 'www.comune.ripaltacremasca.cr.it', 'UFWW8T'),
  ('Comune di Ripalta Guerina', 'Ripalta Guerina', 'CR', 'Lombardia', 538, '00301980199', 'Piazza Trento, 9', '26010', 'anagrafe.comune.ripaltaguerina@pec.regione.lombardia.it', 'segreteria@comune.ripaltaguerina.cr.it', '037366138', 'www.comune.ripaltaguerina.cr.it', 'UFWT1U'),
  ('Comune di Rivarolo del Re ed Uniti', 'Rivarolo del Re ed Uniti', 'CR', 'Lombardia', 1848, '00334230190', 'Piazza Roma', '26036', 'comune.rivarolodelre@pec.regione.lombardia.it', null, '0375534032', 'www.comune.rivarolodelreeduniti.cr.it', 'UF3B4Z'),
  ('Comune di Rivolta d''Adda', 'Rivolta d''Adda', 'CR', 'Lombardia', 8358, '00125130195', 'Piazza V. Emanuele II N.1', '26027', 'comune.rivoltadadda@mailcert.cremasconline.it', 'comune@comune.rivoltadadda.cr.it', '0363377029', 'www.comune.rivoltadadda.cr.it', 'UFD49P'),
  ('Comune di Robecco d''Oglio', 'Robecco d''Oglio', 'CR', 'Lombardia', 2250, '00316540194', 'Via Martiri Della Liberta'', 60', '26010', 'comune.robeccodoglio@pec.regione.lombardia.it', null, '0372981015', 'www.comune.robeccodoglio.cr.it', 'UFGCLY'),
  ('Comune di Romanengo', 'Romanengo', 'CR', 'Lombardia', 3257, '00325790194', 'Piazza Matteotti,3', '26014', 'comune.romanengo@pec.regione.lombardia.it', null, null, 'www.comune.romanengo.cr.it', 'UF2DIO'),
  ('Comune di Salvirola', 'Salvirola', 'CR', 'Lombardia', 1143, '00323960195', 'Piazza MARCORA 1', '26010', 'segreteria.comune.salvirola@pec.it', 'segreteria@comune.salvirola.cr.it', '037372146', 'www.comune.salvirola.cr.it', 'UFUJ1V'),
  ('Comune di San Bassano', 'San Bassano', 'CR', 'Lombardia', 2057, '00298350190', 'Piazza Comune, 5', '26020', 'info@pec.comune.sanbassano.cr.it', 'segreteria@comune.sanbassano.cr.it', '0374373566', 'www.comune.sanbassano.gov.it', 'UF3RY9'),
  ('Comune di San Daniele Po', 'San Daniele Po', 'CR', 'Lombardia', 1297, '00303600191', 'Piazza Fratelli Leoni, 1', '26046', 'comune.sandanielepo@pec.regione.lombardia.it', 'comune@comune.sandanielepo.cr.it', '037265536', 'www.comune.sandanielepo.cr.it', 'UFJQ4W'),
  ('Comune di San Giovanni in Croce', 'San Giovanni in Croce', 'CR', 'Lombardia', 1915, '00304470198', 'Piazza del Comune', '26037', 'comune.sangiovannincroce@pec.regione.lombardia.it', 'protocollo@comune.sangiovanniincroce.cr.it', '037591001', 'http://www.comune.sangiovanniincroce.cr.it/', 'UFF2US'),
  ('Comune di San Martino del Lago', 'San Martino del Lago', 'CR', 'Lombardia', 384, '00305440190', 'Via Roma, 36', '26040', 'comune.sanmartinodellago@pec.regione.lombardia.it', 'anagrafe@comune.sanmartinodellago.cr.it', null, 'www.comune.sanmartinodellago.cr.it', 'UFHEPH'),
  ('Comune di Scandolara Ravara', 'Scandolara Ravara', 'CR', 'Lombardia', 1237, '00327580197', 'Piazza Italia, 11', '26040', 'comune.scandolara-ravara@pec.regione.lombardia.it', null, '037595101', 'https://comune.scandolararavara.cr.it/', 'UF2KHH'),
  ('Comune di Scandolara Ripa d''Oglio', 'Scandolara Ripa d''Oglio', 'CR', 'Lombardia', 505, '00302890199', 'Via Umberto I N.85', '26047', 'comune.scandolararipadoglio@pec.regione.lombardia.it', 'info@comune.scandolararipadoglio.cr.it', '037289142', 'www.comune.scandolararipadoglio.cr.it', 'UF4MWJ'),
  ('Comune di Sergnano', 'Sergnano', 'CR', 'Lombardia', 3460, '00172790198', 'P.za IV Novembre, 8', '26010', 'comune.sergnano@pec.regione.lombardia.it', 'segreteria@comune.sergnano.cr.it', '0373456605', 'https://comune.sergnano.cr.it/', 'UF7UAV'),
  ('Comune di Sesto ed Uniti', 'Sesto ed Uniti', 'CR', 'Lombardia', 3286, '00302640198', 'Via Roma 8', '26028', 'comune.sestoeduniti@pec.regione.lombardia.it', null, '037276076', 'www.comune.sestoeduniti.cr.it', 'UFKUS9'),
  ('Comune di Solarolo Rainerio', 'Solarolo Rainerio', 'CR', 'Lombardia', 921, '00304460199', 'Via Giuseppina, 83', '26030', 'comune.solarolorainerio@pec.regione.lombardia.it', null, '037591017', 'www.comune.solarolorainerio.cr.it', 'UFJ9JX'),
  ('Comune di Soncino', 'Soncino', 'CR', 'Lombardia', 7554, '00177340197', 'Piazza Garibaldi 1', '26029', 'soncino@postemailcertificata.it', null, '0374837840', 'www.comune.soncino.cr.it', 'UFQYC6'),
  ('Comune di Soresina', 'Soresina', 'CR', 'Lombardia', 9306, '00318000197', 'Piazza Marconi, 7', '26015', 'comune.soresina@pec.regione.lombardia.it', 'protocollo@comune.soresina.cr.it', '0374349426', 'www.comune.soresina.cr.it', 'UFYVRL'),
  ('Comune di Sospiro', 'Sospiro', 'CR', 'Lombardia', 3041, '00304310196', 'Piazza Liberta 12', '26048', 'comune.sospiro@pec.regione.lombardia.it', 'ragioneria@comune.sospiro.cr.it', '0372623101', 'www.comune.sospiro.cr.it', 'UF96JC'),
  ('Comune di Spinadesco', 'Spinadesco', 'CR', 'Lombardia', 1485, '80003390194', 'Via Giuseppe Mazzini N. 2', '26020', 'ragioneria.comune.spinadesco@pec.regione.lombardia.it', 'ragioneria@comune.spinadesco.cr.it', '0372491925', 'www.comune.spinadesco.cr.it', 'UF25WB'),
  ('Comune di Spineda', 'Spineda', 'CR', 'Lombardia', 608, '00327510194', 'Piazza Liberta'', 1', '26030', 'comune.spineda@pec.regione.lombardia.it', null, '037693071', 'www.comune.spineda.cr.it', 'UF4WHB'),
  ('Comune di Spino d''Adda', 'Spino d''Adda', 'CR', 'Lombardia', 7013, '82003090196', 'Piazza XXV Aprile, 2', '26016', 'comune.spinodadda@pec.regione.lombardia.it', null, '0373988151', 'www.comune.spinodadda.cr.it', 'UFROQW'),
  ('Comune di Stagno Lombardo', 'Stagno Lombardo', 'CR', 'Lombardia', 1402, '00304830193', 'Piazza Roma, 16', '26049', 'comune.stagnolombardo@pec.regione.lombardia.it', 'protocollo@comune.stagnolombardo.cr.it', '037257032', 'www.comune.stagnolombardo.cr.it/', 'UFBLJ0'),
  ('Comune di Ticengo', 'Ticengo', 'CR', 'Lombardia', 455, '00299150193', 'Piazza Caduti Di Tutte Le Guerre N. 1', '26020', 'segreteria.comune.ticengo@pec.regione.lombardia.it', 'segreteria@comune.ticengo.cr.it', '037471118', 'www.comune.ticengo.cr.it', 'UFOA24'),
  ('Comune di Torlino Vimercati', 'Torlino Vimercati', 'CR', 'Lombardia', 451, '00305110199', 'Via Ottaviano Vimercati, 1/B', '26017', 'pec@pec.comune.torlinovimercati.cr.it', null, '0373288886', 'www.comune.torlinovimercati.cr.it', 'UF9XQ2'),
  ('Comune di Tornata', 'Tornata', 'CR', 'Lombardia', 400, '00316690197', 'Via Fabbri, 10', '26030', 'comune.tornata@pec.regione.lombardia.it', 'ragioneria@comune.tornata.cr.it', '037597051', 'www.comune.tornata.cr.it', 'UFQPY4'),
  ('Comune di Torre de'' Picenardi', 'Torre de'' Picenardi', 'CR', 'Lombardia', 2183, '00310260195', 'Piazza Roma, 1', '26038', 'comune.torredepicenardi@pec.regione.lombardia.it', 'info@comune.torredepicenardi.cr.it', '037287922', 'www.comune.torredepicenardi.cr.it', 'UFG20L'),
  ('Comune di Torricella del Pizzo', 'Torricella del Pizzo', 'CR', 'Lombardia', 585, '00323870196', 'Via Roma, 4', '26040', 'comune.torricelladelpizzo@pec.regione.lombardia.it', null, '037599821', 'www.comune.torricelladelpizzo.cr.it', 'UFYC2I'),
  ('Comune di Trescore Cremasco', 'Trescore Cremasco', 'CR', 'Lombardia', 2916, '00265370197', 'Via Carioni, 13', '26017', 'protocollo@pec.comune.trescorecremasco.cr.it', null, '0373272231', 'www.comune.trescorecremasco.cr.it', 'UFUWQU'),
  ('Comune di Trigolo', 'Trigolo', 'CR', 'Lombardia', 1648, '00304290190', 'P.zza Europa,2', '26018', 'comune.trigolo@pec.regione.lombardia.it', 'protocollo@comune.trigolo.cr.it', null, 'www.comune.trigolo.cr.it', 'UF7U6T'),
  ('Comune di Vaiano Cremasco', 'Vaiano Cremasco', 'CR', 'Lombardia', 3592, '00122230196', 'Piazza Gloriosi Caduti, 5', '26010', 'comune.vaianocremasco@pec.regione.lombardia.it', 'protocollo@comune.vaianocremasco.cr.it', '0373278015', 'www.comune.vaianocremasco.cr.it', 'UFR1PK'),
  ('Comune di Vailate', 'Vailate', 'CR', 'Lombardia', 4723, '00304990195', 'Via Costantino Gorini n. 4', '26019', 'anagrafe.comune.vailate@pec.regione.lombardia.it', null, null, 'www.comune.vailate.cr.it', 'UFF4Z4'),
  ('Comune di Vescovato', 'Vescovato', 'CR', 'Lombardia', 3994, '00324130194', 'Piazza Roma, 45', '26039', 'comune.vescovato@pec.regione.lombardia.it', 'protocollo@comune.vescovato.cr.it', '0372830492', 'www.comune.vescovato.cr.it', 'UFT5DS'),
  ('Comune di Volongo', 'Volongo', 'CR', 'Lombardia', 455, '80003570191', 'Via Cavour, 8', '26030', 'volongo@postemailcertificata.it', 'anagrafe@comune.volongo.cr.it', '0372845914', 'www.comune.volongo.cr.it', 'UF5Q2Y'),
  ('Comune di Voltido', 'Voltido', 'CR', 'Lombardia', 334, '00304380199', 'Via Liberta'' 2', '26030', 'comune.voltido@pec.regione.lombardia.it', 'ragioneria@comune.voltido.cr.it', '0375389762', 'www.comune.voltido.cr.it', 'UF6GD5');

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

-- Controllo: CR = 113 comuni / 355.134 ab.
select provincia, count(*) as comuni, sum(abitanti) as abitanti,
       count(pec) as con_pec, count(email) as con_email, count(phone) as con_telefono
from companies
where tipo = 'pa' and name ilike 'Comune di %' and provincia = 'CR'
group by provincia;

