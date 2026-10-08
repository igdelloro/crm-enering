"use client";

import { useCallback, useEffect, useMemo, useState } from "react";
import type { Agente } from "@/lib/types";
import { nomeAgente, hasRuolo } from "@/lib/types";
import { createClient } from "@/lib/supabase/client";
import {
  PageHeader,
  Card,
  Button,
  Modal,
  Field,
  Input,
  Textarea,
  Select,
} from "@/components/ui";
import { saveAppuntamento, deleteAppuntamento } from "./actions";

type ApptRow = {
  id: string;
  agente_id: string;
  company_id: string | null;
  titolo: string;
  inizio: string;
  fine: string | null;
  luogo: string | null;
  note: string | null;
  agenti: { nome: string; cognome: string | null } | null;
  companies: { name: string } | null;
  appuntamento_agenti: { agente_id: string }[] | null;
};

const GIORNI = ["Lun", "Mar", "Mer", "Gio", "Ven"];

function startOfWeek(d: Date): Date {
  const x = new Date(d);
  const day = (x.getDay() + 6) % 7; // 0 = lunedì
  x.setHours(0, 0, 0, 0);
  x.setDate(x.getDate() - day);
  return x;
}
function addDays(d: Date, n: number): Date {
  const x = new Date(d);
  x.setDate(x.getDate() + n);
  return x;
}
// Griglia a 4 settimane (solo Lun–Ven) a partire dalla settimana di `ref`.
function quattroSettimane(ref: Date): Date[] {
  const start = startOfWeek(ref);
  const days: Date[] = [];
  for (let w = 0; w < 4; w++) {
    for (let d = 0; d < 5; d++) {
      days.push(addDays(start, w * 7 + d));
    }
  }
  return days;
}
const MESI = [
  "Gennaio", "Febbraio", "Marzo", "Aprile", "Maggio", "Giugno",
  "Luglio", "Agosto", "Settembre", "Ottobre", "Novembre", "Dicembre",
];
function sameDay(a: Date, b: Date): boolean {
  return (
    a.getFullYear() === b.getFullYear() &&
    a.getMonth() === b.getMonth() &&
    a.getDate() === b.getDate()
  );
}
function toLocalInput(d: Date): string {
  const off = d.getTimezoneOffset();
  return new Date(d.getTime() - off * 60000).toISOString().slice(0, 16);
}
function addHourLocal(localStr: string): string {
  if (!localStr) return "";
  const d = new Date(localStr);
  return toLocalInput(new Date(d.getTime() + 60 * 60000));
}
function sedeString(c: {
  address: string | null;
  cap: string | null;
  citta: string | null;
  provincia: string | null;
}): string {
  const base = [c.address, c.cap, c.citta].filter(Boolean).join(", ");
  return c.provincia ? `${base}${base ? " " : ""}(${c.provincia})` : base;
}
function oraLabel(iso: string): string {
  return new Intl.DateTimeFormat("it-IT", {
    hour: "2-digit",
    minute: "2-digit",
  }).format(new Date(iso));
}
function dataOraLabel(iso: string): string {
  return new Intl.DateTimeFormat("it-IT", {
    weekday: "short",
    day: "numeric",
    month: "short",
    year: "numeric",
    hour: "2-digit",
    minute: "2-digit",
  }).format(new Date(iso));
}

function ViewRow({ label, value }: { label: string; value: string }) {
  return (
    <div className="flex gap-3">
      <dt className="w-28 shrink-0 text-slate-400 dark:text-slate-500">{label}</dt>
      <dd className="text-slate-800 dark:text-slate-100 whitespace-pre-wrap">{value}</dd>
    </div>
  );
}

// ------- Ricerca cliente (combobox) -------
function CompanyPicker({
  initialId,
  initialName,
  onPick,
}: {
  initialId: string | null;
  initialName: string | null;
  onPick: (
    id: string | null,
    name: string | null,
    sede?: string | null,
    referente?: string | null
  ) => void;
}) {
  const supabase = useMemo(() => createClient(), []);
  const [text, setText] = useState(initialName ?? "");
  const [results, setResults] = useState<
    { id: string; name: string; sede: string; referente: string | null }[]
  >([]);
  const [openList, setOpenList] = useState(false);
  const [picked, setPicked] = useState<boolean>(!!initialId);

  useEffect(() => {
    if (picked) return;
    const term = text.replace(/[(),%*]/g, " ").trim();
    if (term.length < 2) {
      setResults([]);
      return;
    }
    const t = setTimeout(async () => {
      const { data } = await supabase
        .from("companies")
        .select("id, name, address, cap, citta, provincia, referente_nome")
        .ilike("name", `%${term}%`)
        .order("name")
        .limit(8);
      setResults(
        ((data as any[]) ?? []).map((c) => ({
          id: c.id,
          name: c.name,
          sede: sedeString(c),
          referente: c.referente_nome ?? null,
        }))
      );
      setOpenList(true);
    }, 250);
    return () => clearTimeout(t);
  }, [text, picked, supabase]);

  return (
    <div className="relative">
      <Input
        placeholder="Cerca cliente (facoltativo)…"
        value={text}
        onChange={(e) => {
          setText(e.target.value);
          setPicked(false);
          onPick(null, null);
        }}
        onFocus={() => results.length && setOpenList(true)}
      />
      {text && (
        <button
          type="button"
          onClick={() => {
            setText("");
            setResults([]);
            setPicked(false);
            onPick(null, null);
          }}
          className="absolute right-2 top-2 text-slate-400 dark:text-slate-500 hover:text-slate-600 dark:hover:text-slate-300 text-sm"
        >
          ×
        </button>
      )}
      {openList && results.length > 0 && !picked && (
        <div className="absolute z-10 mt-1 w-full bg-white dark:bg-slate-900 border border-slate-200 dark:border-slate-700 rounded-lg shadow-lg max-h-56 overflow-y-auto">
          {results.map((r) => (
            <button
              key={r.id}
              type="button"
              onClick={() => {
                setText(r.name);
                setPicked(true);
                setOpenList(false);
                onPick(r.id, r.name, r.sede, r.referente);
              }}
              className="block w-full text-left px-3 py-2 text-sm hover:bg-slate-50 dark:hover:bg-slate-800"
            >
              {r.name}
              {r.sede && (
                <span className="block text-[11px] text-slate-400 dark:text-slate-500">
                  {r.sede}
                </span>
              )}
            </button>
          ))}
        </div>
      )}
    </div>
  );
}

export default function AgendaClient({
  agenti,
  origin,
}: {
  agenti: Agente[];
  origin: string;
}) {
  const supabase = useMemo(() => createClient(), []);

  const [agenteId, setAgenteId] = useState<string>("");
  // Vista a 4 settimane: ancorata alla settimana corrente
  const [weekRef, setWeekRef] = useState<Date>(() => startOfWeek(new Date()));
  const [rows, setRows] = useState<ApptRow[]>([]);
  const [loading, setLoading] = useState(false);

  // Contatore appuntamenti per mese/anno selezionabili (default: mese corrente)
  const [meseSel, setMeseSel] = useState<number>(new Date().getMonth());
  const [annoSel, setAnnoSel] = useState<number>(new Date().getFullYear());
  const [countSel, setCountSel] = useState<number>(0);

  // modale appuntamento
  const [open, setOpen] = useState(false);
  const [mode, setMode] = useState<"view" | "edit">("view");
  const [editing, setEditing] = useState<ApptRow | null>(null);
  const [formAgente, setFormAgente] = useState<string>("");
  const [formInizio, setFormInizio] = useState<string>("");
  const [formFine, setFormFine] = useState<string>("");
  const [fineTouched, setFineTouched] = useState(false);
  const [formLuogo, setFormLuogo] = useState<string>("");
  const [formTitolo, setFormTitolo] = useState<string>("");
  const [companyId, setCompanyId] = useState<string | null>(null);
  const [partecipanti, setPartecipanti] = useState<string[]>([]);
  const [error, setError] = useState<string | null>(null);
  const [saving, setSaving] = useState(false);

  const giorni = useMemo(() => quattroSettimane(weekRef), [weekRef]);

  // Filtro in alto: solo i venditori (sono loro ad avere un'agenda)
  const venditori = useMemo(
    () => agenti.filter((a) => hasRuolo(a, "venditore")),
    [agenti]
  );
  // Nel form (agente + partecipanti): venditori e amministratori
  const agentiForm = useMemo(
    () =>
      agenti.filter(
        (a) => hasRuolo(a, "venditore") || hasRuolo(a, "amministratore")
      ),
    [agenti]
  );

  const agenteSel = agenti.find((a) => a.id === agenteId) || null;
  const visibleRows = agenteId
    ? rows.filter((r) =>
        (r.appuntamento_agenti ?? []).some((p) => p.agente_id === agenteId)
      )
    : rows;

  // Conteggio appuntamenti del mese/anno selezionati (query dedicata,
  // così conta tutto il mese e rispetta il filtro per venditore).
  useEffect(() => {
    let annullato = false;
    (async () => {
      const from = new Date(annoSel, meseSel, 1).toISOString();
      const to = new Date(annoSel, meseSel + 1, 1).toISOString();
      if (agenteId) {
        // Conta gli appuntamenti in cui l'agente è coinvolto (anche come partecipante)
        const res = await supabase
          .from("appuntamento_agenti")
          .select("appuntamenti!inner(inizio)", { count: "exact", head: true })
          .eq("agente_id", agenteId)
          .gte("appuntamenti.inizio", from)
          .lt("appuntamenti.inizio", to);
        if (!res.error) {
          if (!annullato) setCountSel(res.count ?? 0);
          return;
        }
        // Ripiego: conta per titolare appuntamento
        const fb = await supabase
          .from("appuntamenti")
          .select("id", { count: "exact", head: true })
          .eq("agente_id", agenteId)
          .gte("inizio", from)
          .lt("inizio", to);
        if (!annullato) setCountSel(fb.count ?? 0);
      } else {
        const res = await supabase
          .from("appuntamenti")
          .select("id", { count: "exact", head: true })
          .gte("inizio", from)
          .lt("inizio", to);
        if (!annullato) setCountSel(res.count ?? 0);
      }
    })();
    return () => {
      annullato = true;
    };
  }, [supabase, agenteId, meseSel, annoSel, rows]);

  const fetchWeek = useCallback(async () => {
    setLoading(true);
    const from = giorni[0].toISOString();
    const to = addDays(giorni[giorni.length - 1], 1).toISOString();

    // Query con i partecipanti; se la tabella non esiste ancora (migrazione
    // non eseguita), ripiega su una lettura semplice così gli appuntamenti
    // restano visibili lo stesso.
    const res = await supabase
      .from("appuntamenti")
      .select(
        "*, agenti!appuntamenti_agente_id_fkey(nome, cognome), companies(name), appuntamento_agenti(agente_id)"
      )
      .gte("inizio", from)
      .lt("inizio", to)
      .order("inizio");

    if (res.error) {
      // Ripiego senza alcun collegamento: legge gli appuntamenti "nudi",
      // così si vedono comunque anche se un collegamento dà problemi.
      const fallback = await supabase
        .from("appuntamenti")
        .select("*")
        .gte("inizio", from)
        .lt("inizio", to)
        .order("inizio");
      setRows(
        ((fallback.data as any[]) ?? []).map((a) => ({
          ...a,
          agenti: null,
          companies: null,
          appuntamento_agenti: [{ agente_id: a.agente_id }],
        }))
      );
    } else {
      setRows((res.data as any) ?? []);
    }
    setLoading(false);
  }, [supabase, giorni]);

  useEffect(() => {
    fetchWeek();
  }, [fetchWeek]);

  function openNew(giorno?: Date) {
    setEditing(null);
    setMode("edit");
    setFormAgente(agenteId || agentiForm[0]?.id || "");
    const base = giorno ? new Date(giorno) : new Date();
    if (giorno) base.setHours(9, 0, 0, 0);
    const inizioStr = toLocalInput(base);
    setFormInizio(inizioStr);
    setFormFine(addHourLocal(inizioStr));
    setFineTouched(false);
    setFormLuogo("");
    setFormTitolo("");
    setCompanyId(null);
    setPartecipanti([]);
    setError(null);
    setOpen(true);
  }
  // Apre l'appuntamento in sola lettura (la penna passa in modifica)
  function openView(a: ApptRow) {
    setEditing(a);
    setMode("view");
    setFormAgente(a.agente_id);
    setFormTitolo(a.titolo ?? "");
    const inizioStr = toLocalInput(new Date(a.inizio));
    setFormInizio(inizioStr);
    setFormFine(a.fine ? toLocalInput(new Date(a.fine)) : addHourLocal(inizioStr));
    setFineTouched(!!a.fine);
    setFormLuogo(a.luogo ?? "");
    setCompanyId(a.company_id);
    setPartecipanti(
      (a.appuntamento_agenti ?? [])
        .map((p) => p.agente_id)
        .filter((idp) => idp !== a.agente_id)
    );
    setError(null);
    setOpen(true);
  }

  async function onSubmit(e: React.FormEvent<HTMLFormElement>) {
    e.preventDefault();
    setSaving(true);
    setError(null);
    const fd = new FormData(e.currentTarget);
    if (companyId) fd.set("company_id", companyId);
    fd.set(
      "partecipanti",
      JSON.stringify(partecipanti.filter((idp) => idp !== formAgente))
    );
    try {
      const res = await saveAppuntamento(fd);
      if (res?.error) {
        setError(res.error);
        return;
      }
      setOpen(false);
      fetchWeek();
    } catch (err: any) {
      setError("Errore nel salvataggio: " + (err?.message ?? "imprevisto"));
    } finally {
      setSaving(false);
    }
  }

  async function onDelete(id: string) {
    if (!confirm("Eliminare questo appuntamento?")) return;
    const res = await deleteAppuntamento(id);
    if (res?.error) alert(res.error);
    fetchWeek();
  }

  const icsUrl =
    agenteSel && agenteSel.ics_token && origin
      ? `${origin}/api/agenda/${agenteSel.ics_token}`
      : "";

  const fmtGiorno = (d: Date) =>
    d.toLocaleDateString("it-IT", { day: "numeric", month: "short" });
  const rangeLabel = `${fmtGiorno(giorni[0])} – ${giorni[
    giorni.length - 1
  ].toLocaleDateString("it-IT", {
    day: "numeric",
    month: "short",
    year: "numeric",
  })}`;

  const anni = [];
  for (let y = new Date().getFullYear() - 2; y <= new Date().getFullYear() + 2; y++) {
    anni.push(y);
  }

  return (
    <>
      <PageHeader
        title="Agenda"
        subtitle={`4 settimane · ${rangeLabel}`}
        action={<Button onClick={() => openNew()}>+ Nuovo appuntamento</Button>}
      />

      {/* Barra controlli */}
      <div className="flex flex-wrap items-center gap-3 mb-4">
        <Select
          value={agenteId}
          onChange={(e) => setAgenteId(e.target.value)}
          className="max-w-[240px]"
        >
          <option value="">Tutti i venditori</option>
          {venditori.map((a) => (
            <option key={a.id} value={a.id}>
              {nomeAgente(a)}
            </option>
          ))}
        </Select>
        <div className="flex items-center gap-1">
          <button
            onClick={() => setWeekRef((w) => addDays(w, -7))}
            className="px-3 py-2 rounded-lg bg-slate-100 dark:bg-slate-800 text-slate-600 dark:text-slate-300 hover:bg-slate-200 dark:hover:bg-slate-700 text-sm"
          >
            ‹
          </button>
          <button
            onClick={() => setWeekRef(startOfWeek(new Date()))}
            className="px-3 py-2 rounded-lg bg-slate-100 dark:bg-slate-800 text-slate-600 dark:text-slate-300 hover:bg-slate-200 dark:hover:bg-slate-700 text-sm font-medium"
          >
            Oggi
          </button>
          <button
            onClick={() => setWeekRef((w) => addDays(w, 7))}
            className="px-3 py-2 rounded-lg bg-slate-100 dark:bg-slate-800 text-slate-600 dark:text-slate-300 hover:bg-slate-200 dark:hover:bg-slate-700 text-sm"
          >
            ›
          </button>
        </div>
        {loading && <span className="text-sm text-slate-400 dark:text-slate-500">Caricamento…</span>}

        {/* Contatore mese/anno selezionabili */}
        <div className="flex items-center gap-2 sm:ml-auto bg-slate-50 dark:bg-slate-800 rounded-lg px-3 py-1.5">
          <span className="text-sm text-slate-500 dark:text-slate-400">Totale</span>
          <Select
            value={meseSel}
            onChange={(e) => setMeseSel(Number(e.target.value))}
            className="!w-auto !py-1 text-sm"
          >
            {MESI.map((m, i) => (
              <option key={m} value={i}>
                {m}
              </option>
            ))}
          </Select>
          <Select
            value={annoSel}
            onChange={(e) => setAnnoSel(Number(e.target.value))}
            className="!w-auto !py-1 text-sm"
          >
            {anni.map((y) => (
              <option key={y} value={y}>
                {y}
              </option>
            ))}
          </Select>
          <span className="text-sm font-semibold text-brand-700 dark:text-brand-300">
            {countSel}
          </span>
        </div>
      </div>

      {/* Calendario 4 settimane (Lun–Ven) */}
      <div className="overflow-x-auto">
        <div className="min-w-[520px]">
          <div className="grid grid-cols-5 gap-px bg-slate-200 dark:bg-slate-700 rounded-t-lg overflow-hidden">
            {GIORNI.map((g) => (
              <div
                key={g}
                className="bg-slate-50 dark:bg-slate-800 text-center text-sm font-semibold text-slate-600 dark:text-slate-300 py-2"
              >
                {g}
              </div>
            ))}
          </div>
          <div className="grid grid-cols-5 gap-px bg-slate-200 dark:bg-slate-700 rounded-b-lg overflow-hidden">
            {giorni.map((g, i) => {
              const dayAppts = visibleRows.filter((a) =>
                sameDay(new Date(a.inizio), g)
              );
              const oggi = sameDay(g, new Date());
              const primoDelMese = g.getDate() === 1;
              return (
                <div
                  key={i}
                  className="aspect-square min-h-[132px] p-1.5 flex flex-col overflow-hidden bg-white dark:bg-slate-900"
                >
                  <div className="flex items-center justify-between">
                    <span
                      className={`text-sm font-medium flex items-center gap-1 ${
                        oggi
                          ? ""
                          : "text-slate-700 dark:text-slate-100"
                      }`}
                    >
                      <span
                        className={
                          oggi
                            ? "bg-brand-600 text-white rounded-full w-6 h-6 flex items-center justify-center"
                            : ""
                        }
                      >
                        {g.getDate()}
                      </span>
                      {primoDelMese && (
                        <span className="text-[11px] text-slate-400 dark:text-slate-500">
                          {g.toLocaleDateString("it-IT", { month: "short" })}
                        </span>
                      )}
                    </span>
                    <button
                      onClick={() => openNew(g)}
                      title="Nuovo appuntamento"
                      className="text-brand-400 hover:text-brand-600 dark:text-brand-300 dark:hover:text-brand-200 text-base leading-none"
                    >
                      +
                    </button>
                  </div>
                  <div className="mt-1 space-y-1 flex-1">
                    {dayAppts.slice(0, 10).map((a) => (
                      <button
                        key={a.id}
                        onClick={() => openView(a)}
                        className="block w-full text-left truncate rounded bg-brand-50 dark:bg-brand-500/25 border border-brand-100 dark:border-brand-400/40 px-1.5 py-1 text-xs font-medium text-brand-800 dark:text-brand-100 hover:bg-brand-100 dark:hover:bg-brand-500/40"
                      >
                        {oraLabel(a.inizio)} {a.titolo}
                        {(a.appuntamento_agenti?.length ?? 1) > 1 ? " 👥" : ""}
                      </button>
                    ))}
                    {dayAppts.length > 10 && (
                      <div className="text-[11px] text-slate-500 dark:text-slate-400 pl-1">
                        +{dayAppts.length - 10} altri
                      </div>
                    )}
                  </div>
                </div>
              );
            })}
          </div>
        </div>
      </div>

      {/* Collegamento Google Calendar */}
      {agenteSel && (
        <div className="mt-6">
          <Card>
            <div className="p-4">
              <h3 className="text-sm font-semibold text-slate-800 dark:text-slate-100">
                Vedi questa agenda su Google Calendar / telefono
              </h3>
              <p className="text-xs text-slate-500 dark:text-slate-400 mt-1">
                Copia il link qui sotto e, in Google Calendar, scegli “Altri
                calendari → Da URL” e incollalo. Gli appuntamenti di{" "}
                <b>{nomeAgente(agenteSel)}</b> compariranno automaticamente (in
                sola lettura).
              </p>
              <div className="mt-2 flex gap-2">
                <input
                  readOnly
                  value={icsUrl}
                  onFocus={(e) => e.currentTarget.select()}
                  className="flex-1 text-xs rounded-lg border border-slate-300 dark:border-slate-600 px-3 py-2 bg-slate-50 dark:bg-slate-800"
                />
                <Button
                  variant="ghost"
                  onClick={() => {
                    navigator.clipboard?.writeText(icsUrl);
                  }}
                >
                  Copia
                </Button>
              </div>
            </div>
          </Card>
        </div>
      )}

      {/* Modale appuntamento */}
      <Modal
        open={open}
        onClose={() => setOpen(false)}
        title={
          mode === "view"
            ? "Appuntamento"
            : editing
            ? "Modifica appuntamento"
            : "Nuovo appuntamento"
        }
      >
        {mode === "view" && editing
          ? (() => {
              const partNames = (editing.appuntamento_agenti ?? [])
                .map((p) => p.agente_id)
                .filter((idp) => idp !== editing.agente_id)
                .map((idp) => nomeAgente(agenti.find((a) => a.id === idp) ?? null))
                .filter(Boolean);
              const quando =
                dataOraLabel(editing.inizio) +
                (editing.fine ? ` – ${oraLabel(editing.fine)}` : "");
              return (
                <div className="space-y-4">
                  <div className="flex items-start justify-between gap-3">
                    <h3 className="text-lg font-semibold text-slate-900 dark:text-slate-100">
                      {editing.titolo}
                    </h3>
                    <button
                      type="button"
                      onClick={() => setMode("edit")}
                      title="Modifica"
                      aria-label="Modifica"
                      className="shrink-0 rounded-lg p-2 text-slate-500 dark:text-slate-400 hover:bg-slate-100 dark:hover:bg-slate-800 hover:text-brand-600 dark:hover:text-brand-300"
                    >
                      <svg
                        width="18"
                        height="18"
                        viewBox="0 0 24 24"
                        fill="none"
                        stroke="currentColor"
                        strokeWidth="2"
                        strokeLinecap="round"
                        strokeLinejoin="round"
                      >
                        <path d="M12 20h9" />
                        <path d="M16.5 3.5a2.121 2.121 0 0 1 3 3L7 19l-4 1 1-4Z" />
                      </svg>
                    </button>
                  </div>
                  <dl className="space-y-3 text-sm">
                    <ViewRow label="Quando" value={quando} />
                    <ViewRow
                      label="Agente"
                      value={nomeAgente(
                        agenti.find((a) => a.id === editing.agente_id) ?? null
                      )}
                    />
                    {partNames.length > 0 && (
                      <ViewRow label="Altre persone" value={partNames.join(", ")} />
                    )}
                    {editing.companies?.name && (
                      <ViewRow label="Cliente" value={editing.companies.name} />
                    )}
                    {editing.luogo && <ViewRow label="Luogo" value={editing.luogo} />}
                    {editing.note && <ViewRow label="Note" value={editing.note} />}
                  </dl>
                  <div className="flex justify-between items-center pt-2">
                    <button
                      type="button"
                      onClick={() => {
                        setOpen(false);
                        onDelete(editing.id);
                      }}
                      className="text-sm text-red-500 hover:underline"
                    >
                      Elimina
                    </button>
                    <Button
                      type="button"
                      variant="ghost"
                      onClick={() => setOpen(false)}
                    >
                      Chiudi
                    </Button>
                  </div>
                </div>
              );
            })()
          : (
        <form onSubmit={onSubmit} className="space-y-4">
          {editing && <input type="hidden" name="id" value={editing.id} />}
          <Field label="Titolo *">
            <Input
              name="titolo"
              required
              value={formTitolo}
              onChange={(e) => setFormTitolo(e.target.value)}
            />
          </Field>
          <Field label="Agente *">
            <Select
              name="agente_id"
              value={formAgente}
              onChange={(e) => {
                const v = e.target.value;
                setFormAgente(v);
                setPartecipanti((prev) => prev.filter((idp) => idp !== v));
              }}
            >
              {agentiForm.map((a) => (
                <option key={a.id} value={a.id}>
                  {nomeAgente(a)}
                </option>
              ))}
            </Select>
          </Field>
          <Field label="Altre persone (facoltative)">
            <div className="flex flex-wrap gap-2">
              {agentiForm
                .filter((a) => a.id !== formAgente)
                .map((a) => {
                  const on = partecipanti.includes(a.id);
                  return (
                    <button
                      type="button"
                      key={a.id}
                      onClick={() =>
                        setPartecipanti((prev) =>
                          on ? prev.filter((x) => x !== a.id) : [...prev, a.id]
                        )
                      }
                      className={`rounded-full px-3 py-1 text-xs font-medium border transition ${
                        on
                          ? "bg-brand-600 text-white border-brand-600"
                          : "bg-white dark:bg-slate-900 text-slate-600 dark:text-slate-300 border-slate-300 dark:border-slate-600 hover:bg-slate-50 dark:hover:bg-slate-800"
                      }`}
                    >
                      {nomeAgente(a)}
                    </button>
                  );
                })}
            </div>
          </Field>
          <div className="grid grid-cols-2 gap-4">
            <Field label="Inizio *">
              <Input
                type="datetime-local"
                name="inizio"
                required
                value={formInizio}
                onChange={(e) => {
                  setFormInizio(e.target.value);
                  if (!fineTouched) setFormFine(addHourLocal(e.target.value));
                }}
              />
            </Field>
            <Field label="Fine (facoltativa)">
              <Input
                type="datetime-local"
                name="fine"
                value={formFine}
                onChange={(e) => {
                  setFormFine(e.target.value);
                  setFineTouched(true);
                }}
              />
            </Field>
          </div>
          <Field label="Cliente (facoltativo)">
            <CompanyPicker
              initialId={editing?.company_id ?? null}
              initialName={editing?.companies?.name ?? null}
              onPick={(id, name, sede, referente) => {
                setCompanyId(id);
                if (sede) setFormLuogo(sede);
                // Titolo automatico: nome cliente (+ referente se presente)
                if (name) {
                  setFormTitolo(referente ? `${name} – ${referente}` : name);
                }
              }}
            />
          </Field>
          <Field label="Luogo">
            <Input
              name="luogo"
              value={formLuogo}
              onChange={(e) => setFormLuogo(e.target.value)}
            />
          </Field>
          <Field label="Note">
            <Textarea name="note" defaultValue={editing?.note ?? ""} />
          </Field>

          {error && <p className="text-sm text-red-600">{error}</p>}

          <div className="flex justify-between items-center pt-2">
            <div>
              {editing && (
                <button
                  type="button"
                  onClick={() => {
                    setOpen(false);
                    onDelete(editing.id);
                  }}
                  className="text-sm text-red-500 hover:underline"
                >
                  Elimina
                </button>
              )}
            </div>
            <div className="flex gap-2">
              <Button type="button" variant="ghost" onClick={() => setOpen(false)}>
                Annulla
              </Button>
              <Button type="submit" disabled={saving}>
                {saving ? "Salvataggio…" : "Salva"}
              </Button>
            </div>
          </div>
        </form>
          )}
      </Modal>
    </>
  );
}
