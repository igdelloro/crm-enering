// Tipi condivisi che rispecchiano le tabelle del database.

export type DealStage =
  | "lead"
  | "qualificato"
  | "proposta"
  | "negoziazione"
  | "vinta"
  | "persa";

export type TicketStatus =
  | "aperto"
  | "in_lavorazione"
  | "in_attesa"
  | "chiuso";

export type TicketPriority = "bassa" | "media" | "alta" | "urgente";

export interface Profile {
  id: string;
  full_name: string | null;
  email: string | null;
  role: string;
  created_at: string;
}

export type TipoCliente = "pa" | "societa" | "privato";

export const TIPI_CLIENTE: { value: TipoCliente; label: string }[] = [
  { value: "pa", label: "Pubblica Amministrazione" },
  { value: "societa", label: "Società privata" },
  { value: "privato", label: "Privato" },
];

export function tipoLabel(t: TipoCliente): string {
  return TIPI_CLIENTE.find((x) => x.value === t)?.label ?? t;
}

export type RuoloAgente =
  | "amministratore"
  | "responsabile"
  | "ufficio_sole"
  | "telemarketing"
  | "venditore";

export const RUOLI_AGENTE: { value: RuoloAgente; label: string }[] = [
  { value: "amministratore", label: "Amministratore" },
  { value: "responsabile", label: "Responsabile" },
  { value: "ufficio_sole", label: "Ufficio" },
  { value: "telemarketing", label: "Telemarketing" },
  { value: "venditore", label: "Venditore" },
];

export function ruoloLabel(r: RuoloAgente): string {
  return RUOLI_AGENTE.find((x) => x.value === r)?.label ?? r;
}

// Colore associato a ciascun ruolo (per evidenziare chi ha fatto cosa)
export const RUOLO_COLOR: Record<string, string> = {
  amministratore: "#c0504d", // rosso
  responsabile: "#6b4e9e", // viola
  ufficio_sole: "#d98330", // ambra
  venditore: "#3f8f6b", // verde
  telemarketing: "#3b82c4", // azzurro
};

export function ruoloColorHex(r: string): string {
  return RUOLO_COLOR[r] ?? "#64748b";
}

// Graduatoria per determinare il ruolo "principale" di una persona
// (dal più alto al più basso).
export const PRIORITA_RUOLI = [
  "amministratore",
  "responsabile",
  "venditore",
  "telemarketing",
  "ufficio_sole",
];

export function ruoloPrincipale(a: {
  ruoli?: string[] | null;
  ruolo?: string | null;
}): string {
  const miei = (a.ruoli && a.ruoli.length ? a.ruoli : a.ruolo ? [a.ruolo] : []);
  for (const r of PRIORITA_RUOLI) {
    if (miei.includes(r)) return r;
  }
  return miei[0] ?? "";
}

export interface Agente {
  id: string;
  nome: string;
  cognome: string | null;
  ruolo: RuoloAgente;
  ruoli?: string[] | null;
  email: string | null;
  attivo: boolean;
  profile_id: string | null;
  ics_token?: string | null;
  sigla?: string | null;
  created_at: string;
}

// Ruoli effettivi (lista nuova; se vuota, ricade sul vecchio singolo)
export function agenteRuoli(a: {
  ruoli?: string[] | null;
  ruolo?: string | null;
}): string[] {
  if (a.ruoli && a.ruoli.length) return a.ruoli;
  return a.ruolo ? [a.ruolo] : [];
}

export function hasRuolo(
  a: { ruoli?: string[] | null; ruolo?: string | null },
  r: RuoloAgente
): boolean {
  return agenteRuoli(a).includes(r);
}

export function nomeAgente(a: Pick<Agente, "nome" | "cognome"> | null): string {
  if (!a) return "—";
  return `${a.nome}${a.cognome ? " " + a.cognome : ""}`;
}

export interface Company {
  id: string;
  name: string;
  tipo: TipoCliente;
  // identificativi
  piva: string | null;
  codice_fiscale: string | null;
  codice_univoco: string | null; // PA
  codice_sdi: string | null; // società
  pec: string | null;
  // privato
  nome: string | null;
  cognome: string | null;
  // contatti / sede
  website: string | null;
  industry: string | null; // settore
  phone: string | null;
  address: string | null;
  cap: string | null;
  citta: string | null;
  provincia: string | null;
  regione: string | null;
  // referente principale
  referente_nome: string | null;
  referente_ruolo: string | null;
  referente_contatto: string | null;
  // assegnazione
  tlmk_agente_id: string | null;
  venditore_agente_id: string | null;
  // semaforo
  last_contact_at: string | null;
  flag_manuale: string | null; // 'azzurro' | null
  // altro
  notes: string | null;
  owner_id: string | null;
  created_at: string;
  updated_at: string;
}

export interface Appuntamento {
  id: string;
  agente_id: string;
  company_id: string | null;
  titolo: string;
  inizio: string;
  fine: string | null;
  luogo: string | null;
  note: string | null;
  created_by: string | null;
  created_at: string;
}

// ---- Eventi (cronologia) ---------------------------------------------
export type TipoEvento =
  | "contatto"
  | "whatsapp"
  | "visita"
  | "scadenza"
  | "vendita"
  | "preventivo"
  | "gara";

export const TIPI_EVENTO: {
  value: TipoEvento;
  label: string;
  color: "slate" | "green" | "blue" | "amber" | "red" | "violet";
  conImporto?: boolean;
}[] = [
  { value: "contatto", label: "Contatto", color: "slate" },
  { value: "whatsapp", label: "WhatsApp", color: "green" },
  { value: "visita", label: "Visita", color: "amber" },
  { value: "scadenza", label: "Scadenza", color: "red" },
  { value: "vendita", label: "Vendita", color: "green", conImporto: true },
  { value: "preventivo", label: "Preventivo", color: "blue", conImporto: true },
  { value: "gara", label: "Gara", color: "violet", conImporto: true },
];

export function eventoMeta(t: TipoEvento) {
  return TIPI_EVENTO.find((x) => x.value === t) ?? TIPI_EVENTO[0];
}

// ---- Cantieri --------------------------------------------------------
export const FASI_CANTIERE: { value: string; label: string }[] = [
  { value: "da_pianificare", label: "Da pianificare" },
  { value: "in_corso", label: "In corso" },
  { value: "collaudo", label: "Collaudo" },
  { value: "pratiche_incentivi", label: "Pratiche incentivi" },
  { value: "fatturato", label: "Fatturato" },
  { value: "chiuso", label: "Chiuso" },
];

export function faseLabel(f: string): string {
  return FASI_CANTIERE.find((x) => x.value === f)?.label ?? f;
}

export interface Cantiere {
  id: string;
  preventivo_id: string | null;
  company_id: string | null;
  titolo: string | null;
  fase: string;
  responsabile_agente_id: string | null;
  importo: number | null;
  note: string | null;
  in_cv?: boolean;
  ordine: number;
  created_at: string;
  updated_at: string;
}

export interface CantiereTask {
  id: string;
  cantiere_id: string;
  descrizione: string;
  assegnato_agente_id: string | null;
  fatto: boolean;
  scadenza: string | null;
  ordine: number;
  created_at: string;
}

export interface Provvigione {
  id: string;
  agente_id: string;
  preventivo_id: string | null;
  periodo: string | null;
  imponibile: number | null;
  percentuale: number | null;
  importo: number | null;
  stato: string;
  note: string | null;
  created_at: string;
  updated_at: string;
}

// ---- Preventivi / Gare -----------------------------------------------
export type TipoPreventivo = "preventivo" | "gara";
export type SottotipoGara = "negoziata" | "aperta" | "invito";

export const SOTTOTIPI_GARA: { value: SottotipoGara; label: string }[] = [
  { value: "negoziata", label: "Negoziata (unico invitato)" },
  { value: "aperta", label: "Aperta" },
  { value: "invito", label: "Ad invito" },
];

// Stati possibili a seconda del tipo
export const STATI_PREVENTIVO = [
  { value: "bozza", label: "Bozza", color: "slate" },
  { value: "inviato", label: "Inviato", color: "blue" },
  { value: "accettato", label: "Accettato", color: "green" },
  { value: "rifiutato", label: "Rifiutato", color: "red" },
] as const;

export const STATI_GARA = [
  { value: "in_preparazione", label: "In preparazione", color: "slate" },
  { value: "partecipata", label: "Partecipata", color: "blue" },
  { value: "aggiudicata", label: "Aggiudicata", color: "green" },
  { value: "non_aggiudicata", label: "Non aggiudicata", color: "red" },
] as const;

export const STATI_GARA_NEGOZIATA = [
  { value: "in_trattativa", label: "In trattativa", color: "amber" },
  { value: "aggiudicata", label: "Aggiudicata", color: "green" },
  { value: "non_aggiudicata", label: "Non aggiudicata", color: "red" },
] as const;

type StatoDef = { value: string; label: string; color: string };

export function statiPer(
  tipo: TipoPreventivo,
  sottotipo: string | null
): StatoDef[] {
  if (tipo === "preventivo") return STATI_PREVENTIVO as unknown as StatoDef[];
  if (sottotipo === "negoziata")
    return STATI_GARA_NEGOZIATA as unknown as StatoDef[];
  return STATI_GARA as unknown as StatoDef[];
}

export function statoMeta(
  tipo: TipoPreventivo,
  sottotipo: string | null,
  stato: string
): StatoDef {
  const found = statiPer(tipo, sottotipo).find((s) => s.value === stato);
  return found ?? { value: stato, label: stato, color: "slate" };
}

// ⚙️ PERSONALIZZARE PER AZIENDA: categorie dei preventivi/offerte.
// Esempi: SOLE → LED, FOTOVOLTAICO, LED+FOTOVOLTAICO, ALTRO
//         Riva → SERRAMENTI, PORTE, FALEGNAMERIA SU MISURA, POSA, ALTRO
//         Ener.ing → PROGETTAZIONE, DIREZIONE LAVORI, PRATICHE/INCENTIVI, CONSULENZA, ALTRO
export const CATEGORIE_PREVENTIVO = [
  "PROGETTAZIONE",
  "DIREZIONE LAVORI",
  "PRATICHE/INCENTIVI",
  "CONSULENZA",
  "ALTRO",
] as const;

export interface Preventivo {
  id: string;
  numero: string | null;
  company_id: string;
  venditore_agente_id: string | null;
  tlmk_agente_id: string | null;
  tipo: TipoPreventivo;
  sottotipo: SottotipoGara | null;
  categoria: string | null;
  oggetto: string | null;
  importo: number | null;
  base_gara: number | null;
  ribasso: number | null;
  cig: string | null;
  cup: string | null;
  riferimento: string | null;
  stato: string;
  data_scadenza: string | null;
  note: string | null;
  created_by: string | null;
  created_at: string;
  updated_at: string;
}

export interface Evento {
  id: string;
  company_id: string;
  tipo: TipoEvento;
  data: string;
  causale: string | null;
  dettagli: string | null;
  importo: number | null;
  created_by: string | null;
  created_at: string;
}

// ---- Semaforo ---------------------------------------------------------
export type SemaforoColor =
  | "verde"
  | "giallo"
  | "arancione"
  | "rosso"
  | "azzurro"
  | "grigio";

export const SEMAFORO_HEX: Record<SemaforoColor, string> = {
  verde: "#3f8f6b",
  giallo: "#d9b23a",
  arancione: "#d98330",
  rosso: "#c0504d",
  azzurro: "#3b82c4",
  grigio: "#b9c0cc",
};

export const SEMAFORO_LABEL: Record<SemaforoColor, string> = {
  verde: "Contattato di recente (< 30 gg)",
  giallo: "30–60 giorni dall'ultimo contatto",
  arancione: "60–120 giorni dall'ultimo contatto",
  rosso: "Oltre 120 giorni senza contatto",
  azzurro: "Attenzionato",
  grigio: "Nessun contatto registrato",
};

// Colore automatico da giorni trascorsi; il flag manuale ha la precedenza.
export function calcolaSemaforo(
  lastContactAt: string | null,
  flagManuale: string | null
): SemaforoColor {
  if (flagManuale === "azzurro") return "azzurro";
  if (!lastContactAt) return "grigio";
  const giorni = Math.floor(
    (Date.now() - new Date(lastContactAt).getTime()) / 86400000
  );
  if (giorni < 30) return "verde";
  if (giorni < 60) return "giallo";
  if (giorni < 120) return "arancione";
  return "rosso";
}

export interface Contact {
  id: string;
  first_name: string;
  last_name: string | null;
  email: string | null;
  phone: string | null;
  job_title: string | null;
  company_id: string | null;
  owner_id: string | null;
  notes: string | null;
  created_at: string;
  updated_at: string;
}

export interface Deal {
  id: string;
  title: string;
  company_id: string | null;
  contact_id: string | null;
  value: number;
  currency: string;
  stage: DealStage;
  expected_close_date: string | null;
  owner_id: string | null;
  notes: string | null;
  created_at: string;
  updated_at: string;
}

export interface Ticket {
  id: string;
  subject: string;
  description: string | null;
  company_id: string | null;
  contact_id: string | null;
  status: TicketStatus;
  priority: TicketPriority;
  assignee_id: string | null;
  created_at: string;
  updated_at: string;
}

// Etichette leggibili per gli enum (usate nell'interfaccia)
export const DEAL_STAGES: { value: DealStage; label: string }[] = [
  { value: "lead", label: "Lead" },
  { value: "qualificato", label: "Qualificato" },
  { value: "proposta", label: "Proposta" },
  { value: "negoziazione", label: "Negoziazione" },
  { value: "vinta", label: "Vinta" },
  { value: "persa", label: "Persa" },
];

export const TICKET_STATUSES: { value: TicketStatus; label: string }[] = [
  { value: "aperto", label: "Aperto" },
  { value: "in_lavorazione", label: "In lavorazione" },
  { value: "in_attesa", label: "In attesa" },
  { value: "chiuso", label: "Chiuso" },
];

export const TICKET_PRIORITIES: { value: TicketPriority; label: string }[] = [
  { value: "bassa", label: "Bassa" },
  { value: "media", label: "Media" },
  { value: "alta", label: "Alta" },
  { value: "urgente", label: "Urgente" },
];
