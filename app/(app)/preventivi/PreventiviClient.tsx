"use client";

import { useCallback, useEffect, useMemo, useState } from "react";
import Link from "next/link";
import type { Agente, Preventivo, TipoPreventivo } from "@/lib/types";
import {
  SOTTOTIPI_GARA,
  CATEGORIE_PREVENTIVO,
  statiPer,
  statoMeta,
  nomeAgente,
  hasRuolo,
} from "@/lib/types";
import { createClient } from "@/lib/supabase/client";
import { formatCurrency } from "@/lib/format";
import {
  PageHeader,
  Card,
  Button,
  Modal,
  Field,
  Input,
  Textarea,
  Select,
  Badge,
  EmptyState,
} from "@/components/ui";
import { savePreventivo, deletePreventivo } from "./actions";

const PAGE = 15;

type Row = Preventivo & {
  companies: { name: string; tipo: string } | null;
  agenti: { nome: string; cognome: string | null; sigla: string | null } | null;
};

// combobox cliente che restituisce anche tipo e venditore
function ClientePicker({
  initialName,
  onPick,
}: {
  initialName: string | null;
  onPick: (c: {
    id: string;
    name: string;
    tipo: string;
    venditore: string | null;
    tlmk: string | null;
  } | null) => void;
}) {
  const supabase = useMemo(() => createClient(), []);
  const [text, setText] = useState(initialName ?? "");
  const [results, setResults] = useState<any[]>([]);
  const [open, setOpen] = useState(false);
  const [picked, setPicked] = useState(!!initialName);

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
        .select("id, name, tipo, venditore_agente_id, tlmk_agente_id")
        .ilike("name", `%${term}%`)
        .order("name")
        .limit(8);
      setResults(data ?? []);
      setOpen(true);
    }, 250);
    return () => clearTimeout(t);
  }, [text, picked, supabase]);

  return (
    <div className="relative">
      <Input
        placeholder="Cerca cliente…"
        value={text}
        onChange={(e) => {
          setText(e.target.value);
          setPicked(false);
          onPick(null);
        }}
      />
      {open && results.length > 0 && !picked && (
        <div className="absolute z-10 mt-1 w-full bg-white dark:bg-slate-900 border border-slate-200 dark:border-slate-700 rounded-lg shadow-lg max-h-56 overflow-y-auto">
          {results.map((r) => (
            <button
              key={r.id}
              type="button"
              onClick={() => {
                setText(r.name);
                setPicked(true);
                setOpen(false);
                onPick({
                  id: r.id,
                  name: r.name,
                  tipo: r.tipo,
                  venditore: r.venditore_agente_id ?? null,
                  tlmk: r.tlmk_agente_id ?? null,
                });
              }}
              className="block w-full text-left px-3 py-2 text-sm hover:bg-slate-50 dark:hover:bg-slate-800"
            >
              {r.name}
              <span className="text-[11px] text-slate-400 dark:text-slate-500">
                {" "}
                · {r.tipo === "pa" ? "PA" : r.tipo === "societa" ? "Società" : "Privato"}
              </span>
            </button>
          ))}
        </div>
      )}
    </div>
  );
}

export default function PreventiviClient({ agenti }: { agenti: Agente[] }) {
  const supabase = useMemo(() => createClient(), []);
  const vendList = agenti.filter((a) => hasRuolo(a, "venditore"));
  const tlmkList = agenti.filter((a) => hasRuolo(a, "telemarketing"));
  const agenteById = useMemo(
    () => Object.fromEntries(agenti.map((a) => [a.id, a])),
    [agenti]
  );

  const [rows, setRows] = useState<Row[]>([]);
  const [total, setTotal] = useState(0);
  const [loading, setLoading] = useState(false);

  // filtri
  const [q, setQ] = useState("");
  const [fTipo, setFTipo] = useState("");
  const [fStato, setFStato] = useState("");
  const [fVend, setFVend] = useState("");
  const [fCat, setFCat] = useState("");

  // form
  const [open, setOpen] = useState(false);
  const [editing, setEditing] = useState<Row | null>(null);
  const [cliId, setCliId] = useState<string | null>(null);
  const [cliName, setCliName] = useState<string | null>(null);
  const [tipoP, setTipoP] = useState<TipoPreventivo>("preventivo");
  const [sottotipo, setSottotipo] = useState<string>("aperta");
  const [categoria, setCategoria] = useState<string>("");
  const [stato, setStato] = useState<string>("bozza");
  const [vend, setVend] = useState<string>("");
  const [tlmkSel, setTlmkSel] = useState<string>("");
  const [fBase, setFBase] = useState("");
  const [fImporto, setFImporto] = useState("");
  const [fRibasso, setFRibasso] = useState("");
  const [ultimo, setUltimo] = useState<"offerta" | "ribasso" | null>(null);
  const [error, setError] = useState<string | null>(null);
  const [saving, setSaving] = useState(false);

  function toNum(s: string): number | null {
    const n = parseFloat((s ?? "").replace(",", "."));
    return isNaN(n) ? null : n;
  }
  const round2 = (n: number) => String(Math.round(n * 100) / 100);

  function onBaseChange(v: string) {
    setFBase(v);
    const base = toNum(v);
    if (base == null) return;
    if (ultimo === "ribasso") {
      const r = toNum(fRibasso);
      if (r != null) setFImporto(round2(base * (1 - r / 100)));
    } else if (ultimo === "offerta") {
      const o = toNum(fImporto);
      if (o != null && base !== 0) setFRibasso(round2((1 - o / base) * 100));
    }
  }
  function onRibassoChange(v: string) {
    setFRibasso(v);
    setUltimo("ribasso");
    const base = toNum(fBase);
    const r = toNum(v);
    if (base != null && r != null) setFImporto(round2(base * (1 - r / 100)));
  }
  function onImportoChange(v: string) {
    setFImporto(v);
    setUltimo("offerta");
    const base = toNum(fBase);
    const o = toNum(v);
    if (base != null && base !== 0 && o != null)
      setFRibasso(round2((1 - o / base) * 100));
  }

  const fetchPage = useCallback(
    async (reset: boolean, current: number) => {
      setLoading(true);
      const from = reset ? 0 : current;
      let query = supabase
        .from("preventivi")
        .select("*, companies(name, tipo)", { count: "exact" })
        .order("created_at", { ascending: false });
      if (fTipo) query = query.eq("tipo", fTipo);
      if (fStato) query = query.eq("stato", fStato);
      if (fVend) query = query.eq("venditore_agente_id", fVend);
      if (fCat) query = query.eq("categoria", fCat);
      if (q.trim()) {
        const term = q.replace(/[(),%*]/g, " ").trim();
        if (term)
          query = query.or(`numero.ilike.%${term}%,oggetto.ilike.%${term}%`);
      }
      query = query.range(from, from + PAGE - 1);
      const { data, count } = await query;
      const batch = (data as Row[]) ?? [];
      setTotal(count ?? 0);
      setRows((prev) => (reset ? batch : [...prev, ...batch]));
      setLoading(false);
    },
    [supabase, fTipo, fStato, fVend, fCat, q]
  );

  useEffect(() => {
    const t = setTimeout(() => fetchPage(true, 0), 250);
    return () => clearTimeout(t);
  }, [fetchPage]);

  function openNew() {
    setEditing(null);
    setCliId(null);
    setCliName(null);
    setTipoP("preventivo");
    setSottotipo("aperta");
    setCategoria("");
    setStato("bozza");
    setVend(vendList[0]?.id ?? "");
    setTlmkSel("");
    setFBase("");
    setFImporto("");
    setFRibasso("");
    setUltimo(null);
    setError(null);
    setOpen(true);
  }
  function openEdit(r: Row) {
    setEditing(r);
    setCliId(r.company_id);
    setCliName(r.companies?.name ?? null);
    setTipoP(r.tipo);
    setSottotipo(r.sottotipo ?? "aperta");
    setCategoria(r.categoria ?? "");
    setStato(r.stato);
    setVend(r.venditore_agente_id ?? "");
    setTlmkSel(r.tlmk_agente_id ?? "");
    setFBase(r.base_gara != null ? String(r.base_gara) : "");
    setFImporto(r.importo != null ? String(r.importo) : "");
    setFRibasso(r.ribasso != null ? String(r.ribasso) : "");
    setUltimo(null);
    setError(null);
    setOpen(true);
  }

  function onPickCliente(
    c: {
      id: string;
      name: string;
      tipo: string;
      venditore: string | null;
      tlmk: string | null;
    } | null
  ) {
    if (!c) {
      setCliId(null);
      return;
    }
    setCliId(c.id);
    setCliName(c.name);
    const nuovoTipo: TipoPreventivo = c.tipo === "pa" ? "gara" : "preventivo";
    setTipoP(nuovoTipo);
    // stato di default coerente col tipo
    setStato(statiPer(nuovoTipo, sottotipo)[0].value);
    if (c.venditore && !vend) setVend(c.venditore);
    if (c.tlmk && !tlmkSel) setTlmkSel(c.tlmk);
  }

  async function onSubmit(e: React.FormEvent<HTMLFormElement>) {
    e.preventDefault();
    if (!cliId) {
      setError("Seleziona un cliente.");
      return;
    }
    setSaving(true);
    setError(null);
    const fd = new FormData(e.currentTarget);
    fd.set("company_id", cliId);
    fd.set("tipo", tipoP);
    try {
      const res = await savePreventivo(fd);
      if (res?.error) {
        setError(res.error);
        return;
      }
      setOpen(false);
      fetchPage(true, 0);
    } catch (err: any) {
      setError("Errore: " + (err?.message ?? "imprevisto"));
    } finally {
      setSaving(false);
    }
  }

  async function onDelete(id: string) {
    if (!confirm("Eliminare questo preventivo?")) return;
    const res = await deletePreventivo(id);
    if (res?.error) alert(res.error);
    fetchPage(true, 0);
  }

  const statiForm = statiPer(tipoP, sottotipo);
  const statiFiltro = [
    { value: "bozza", label: "Bozza" },
    { value: "inviato", label: "Inviato" },
    { value: "accettato", label: "Accettato" },
    { value: "rifiutato", label: "Rifiutato" },
    { value: "in_preparazione", label: "In preparazione" },
    { value: "in_trattativa", label: "In trattativa" },
    { value: "partecipata", label: "Partecipata" },
    { value: "aggiudicata", label: "Aggiudicata" },
    { value: "non_aggiudicata", label: "Non aggiudicata" },
  ];

  return (
    <>
      <PageHeader
        title="Preventivi"
        subtitle={`${total} preventivi / gare`}
        action={<Button onClick={openNew}>+ Nuovo preventivo</Button>}
      />

      <div className="flex flex-wrap gap-3 mb-4">
        <Input
          placeholder="Cerca per numero o oggetto…"
          value={q}
          onChange={(e) => setQ(e.target.value)}
          className="max-w-xs"
        />
        <Select value={fTipo} onChange={(e) => setFTipo(e.target.value)} className="max-w-[170px]">
          <option value="">Tutti i tipi</option>
          <option value="preventivo">Preventivi (privati)</option>
          <option value="gara">Gare (PA)</option>
        </Select>
        <Select value={fStato} onChange={(e) => setFStato(e.target.value)} className="max-w-[180px]">
          <option value="">Tutti gli stati</option>
          {statiFiltro.map((s) => (
            <option key={s.value} value={s.value}>
              {s.label}
            </option>
          ))}
        </Select>
        <Select value={fVend} onChange={(e) => setFVend(e.target.value)} className="max-w-[200px]">
          <option value="">Tutti i venditori</option>
          {vendList.map((a) => (
            <option key={a.id} value={a.id}>
              {nomeAgente(a)}
            </option>
          ))}
        </Select>
        <Select value={fCat} onChange={(e) => setFCat(e.target.value)} className="max-w-[150px]">
          <option value="">Tutte le categorie</option>
          {CATEGORIE_PREVENTIVO.map((c) => (
            <option key={c} value={c}>
              {c}
            </option>
          ))}
        </Select>
        {(q || fTipo || fStato || fVend || fCat) && (
          <button
            onClick={() => {
              setQ("");
              setFTipo("");
              setFStato("");
              setFVend("");
              setFCat("");
            }}
            className="text-sm text-slate-500 dark:text-slate-400 hover:underline"
          >
            Azzera filtri
          </button>
        )}
      </div>

      <Card>
        {rows.length === 0 && !loading ? (
          <EmptyState message="Nessun preventivo. Usa «+ Nuovo preventivo» per crearne uno." />
        ) : (
          <div className="overflow-x-auto"><table className="w-full text-sm min-w-[640px]">
            <thead>
              <tr className="text-left text-slate-500 dark:text-slate-400 border-b border-slate-100 dark:border-slate-800">
                <th className="px-4 py-3 font-medium">Numero</th>
                <th className="px-4 py-3 font-medium">Cliente</th>
                <th className="px-4 py-3 font-medium">Tipo</th>
                <th className="px-4 py-3 font-medium">Importo</th>
                <th className="px-4 py-3 font-medium">Stato</th>
                <th className="px-4 py-3 font-medium">Venditore</th>
                <th className="px-4 py-3"></th>
              </tr>
            </thead>
            <tbody>
              {rows.map((r) => {
                const sm = statoMeta(r.tipo, r.sottotipo, r.stato);
                return (
                  <tr key={r.id} className="border-b border-slate-50 dark:border-slate-800 hover:bg-slate-50 dark:hover:bg-slate-800">
                    <td className="px-4 py-3">
                      <button
                        onClick={() => openEdit(r)}
                        className="font-semibold text-brand-700 dark:text-brand-300 hover:underline"
                      >
                        {r.numero ?? "—"}
                      </button>
                    </td>
                    <td className="px-4 py-3">
                      {r.company_id ? (
                        <Link href={`/clienti/${r.company_id}`} target="_blank" rel="noopener" className="text-slate-700 dark:text-slate-200 hover:underline">
                          {r.companies?.name ?? "—"}
                        </Link>
                      ) : (
                        "—"
                      )}
                      {r.oggetto && (
                        <div className="text-xs text-slate-400 dark:text-slate-500">{r.oggetto}</div>
                      )}
                    </td>
                    <td className="px-4 py-3">
                      {r.tipo === "gara" ? (
                        <Badge color="violet">
                          Gara{r.sottotipo ? ` · ${r.sottotipo}` : ""}
                        </Badge>
                      ) : (
                        <Badge color="blue">Preventivo</Badge>
                      )}
                      {r.categoria && (
                        <div className="mt-1">
                          <Badge color="slate">{r.categoria}</Badge>
                        </div>
                      )}
                    </td>
                    <td className="px-4 py-3 text-slate-700 dark:text-slate-200">
                      {r.importo != null ? formatCurrency(Number(r.importo)) : "—"}
                    </td>
                    <td className="px-4 py-3">
                      <Badge color={sm.color as any}>{sm.label}</Badge>
                    </td>
                    <td className="px-4 py-3 text-slate-600 dark:text-slate-300">
                      {r.venditore_agente_id
                        ? nomeAgente(agenteById[r.venditore_agente_id])
                        : "—"}
                      {r.tlmk_agente_id && (
                        <div className="text-xs text-slate-400 dark:text-slate-500">
                          tlmk: {nomeAgente(agenteById[r.tlmk_agente_id])}
                        </div>
                      )}
                    </td>
                    <td className="px-4 py-3 text-right whitespace-nowrap">
                      <button onClick={() => onDelete(r.id)} className="text-red-500 hover:underline">
                        Elimina
                      </button>
                    </td>
                  </tr>
                );
              })}
            </tbody>
          </table></div>
        )}
        {rows.length > 0 && rows.length < total && (
          <div className="p-4 text-center border-t border-slate-50 dark:border-slate-800">
            <Button variant="ghost" disabled={loading} onClick={() => fetchPage(false, rows.length)}>
              {loading ? "Caricamento…" : "Carica altri 15"}
            </Button>
          </div>
        )}
      </Card>

      <Modal
        open={open}
        onClose={() => setOpen(false)}
        title={editing ? `Preventivo ${editing.numero ?? ""}` : "Nuovo preventivo"}
      >
        <form onSubmit={onSubmit} className="space-y-4">
          {editing && <input type="hidden" name="id" value={editing.id} />}
          <input type="hidden" name="sottotipo" value={tipoP === "gara" ? sottotipo : ""} />
          <input type="hidden" name="stato" value={stato} />

          <Field label="Cliente *">
            <ClientePicker initialName={cliName} onPick={onPickCliente} />
            {cliId && (
              <p className="text-xs text-slate-500 dark:text-slate-400 mt-1">
                {tipoP === "gara"
                  ? "Cliente PA → questo è una GARA"
                  : "Cliente privato → questo è un PREVENTIVO"}
              </p>
            )}
          </Field>

          {editing?.numero && (
            <p className="text-sm">
              Numero: <span className="font-semibold">{editing.numero}</span>
            </p>
          )}
          {!editing && (
            <p className="text-xs text-slate-400 dark:text-slate-500">
              {tipoP === "gara" && (sottotipo === "aperta" || sottotipo === "invito")
                ? `Numero automatico: GARA${new Date().getFullYear()}.001 (gare aperte e ad invito).`
                : `Il numero (es. XX${new Date().getFullYear()}.001) viene assegnato automaticamente al salvataggio, in base al venditore.`}
            </p>
          )}

          <Field label="Venditore * (determina il numero)">
            <Select
              name="venditore_agente_id"
              value={vend}
              onChange={(e) => setVend(e.target.value)}
              required
            >
              <option value="">—</option>
              {vendList.map((a) => (
                <option key={a.id} value={a.id}>
                  {nomeAgente(a)}
                  {a.sigla ? ` (${a.sigla})` : ""}
                </option>
              ))}
            </Select>
          </Field>

          <Field label="Telemarketing (chi ha preso il cliente)">
            <Select
              name="tlmk_agente_id"
              value={tlmkSel}
              onChange={(e) => setTlmkSel(e.target.value)}
            >
              <option value="">—</option>
              {tlmkList.map((a) => (
                <option key={a.id} value={a.id}>
                  {nomeAgente(a)}
                </option>
              ))}
            </Select>
          </Field>

          {tipoP === "gara" && (
            <Field label="Tipo di gara">
              <Select
                value={sottotipo}
                onChange={(e) => {
                  setSottotipo(e.target.value);
                  setStato(statiPer("gara", e.target.value)[0].value);
                }}
              >
                {SOTTOTIPI_GARA.map((s) => (
                  <option key={s.value} value={s.value}>
                    {s.label}
                  </option>
                ))}
              </Select>
            </Field>
          )}

          <Field label="Categoria (oggetto)">
            <div className="flex flex-wrap gap-2">
              {CATEGORIE_PREVENTIVO.map((c) => {
                const on = categoria === c;
                return (
                  <button
                    type="button"
                    key={c}
                    onClick={() => setCategoria(on ? "" : c)}
                    className={`rounded-full px-3 py-1 text-xs font-medium border transition ${
                      on
                        ? "bg-brand-600 text-white border-brand-600"
                        : "bg-white dark:bg-slate-900 text-slate-600 dark:text-slate-300 border-slate-300 dark:border-slate-600 hover:bg-slate-50 dark:hover:bg-slate-800"
                    }`}
                  >
                    {c}
                  </button>
                );
              })}
            </div>
            <input type="hidden" name="categoria" value={categoria} />
          </Field>

          <Field label="Oggetto (dettaglio)">
            <Input name="oggetto" defaultValue={editing?.oggetto ?? ""} placeholder="es. Relamping scuola Portinari" />
          </Field>

          {tipoP === "gara" ? (
            <>
              <Field label="Importo a base di gara (€)">
                <Input
                  type="number"
                  name="base_gara"
                  step="0.01"
                  value={fBase}
                  onChange={(e) => onBaseChange(e.target.value)}
                />
              </Field>
              <div className="grid grid-cols-2 gap-4">
                <Field label="Vostra offerta (€)">
                  <Input
                    type="number"
                    name="importo"
                    step="0.01"
                    value={fImporto}
                    onChange={(e) => onImportoChange(e.target.value)}
                  />
                </Field>
                <Field label="Ribasso / sconto (%)">
                  <Input
                    type="number"
                    name="ribasso"
                    step="0.01"
                    value={fRibasso}
                    onChange={(e) => onRibassoChange(e.target.value)}
                  />
                </Field>
              </div>
              <p className="text-xs text-slate-400 dark:text-slate-500 -mt-2">
                Inserisci la base, poi la vostra offerta <b>oppure</b> il
                ribasso: il resto viene calcolato in automatico.
              </p>
              <div className="grid grid-cols-2 gap-4">
                <Field label="CIG">
                  <Input name="cig" defaultValue={editing?.cig ?? ""} />
                </Field>
                <Field label="CUP">
                  <Input name="cup" defaultValue={editing?.cup ?? ""} />
                </Field>
              </div>
            </>
          ) : (
            <div className="grid grid-cols-2 gap-4">
              <Field label="Importo (€)">
                <Input
                  type="number"
                  name="importo"
                  step="0.01"
                  value={fImporto}
                  onChange={(e) => setFImporto(e.target.value)}
                />
              </Field>
              <Field label="Ribasso / sconto (%)">
                <Input
                  type="number"
                  name="ribasso"
                  step="0.01"
                  value={fRibasso}
                  onChange={(e) => setFRibasso(e.target.value)}
                />
              </Field>
            </div>
          )}

          <div className="grid grid-cols-2 gap-4">
            <Field label="Stato">
              <Select value={stato} onChange={(e) => setStato(e.target.value)}>
                {statiForm.map((s) => (
                  <option key={s.value} value={s.value}>
                    {s.label}
                  </option>
                ))}
              </Select>
            </Field>
            <Field label={tipoP === "gara" ? "Scadenza presentazione" : "Validità offerta"}>
              <Input
                type="date"
                name="data_scadenza"
                defaultValue={editing?.data_scadenza ? editing.data_scadenza.slice(0, 10) : ""}
              />
            </Field>
          </div>

          <Field label="Riferimento (facoltativo)">
            <Input name="riferimento" defaultValue={editing?.riferimento ?? ""} />
          </Field>
          <Field label="Note">
            <Textarea name="note" defaultValue={editing?.note ?? ""} />
          </Field>

          {error && <p className="text-sm text-red-600">{error}</p>}

          <div className="flex justify-end gap-2 pt-2">
            <Button type="button" variant="ghost" onClick={() => setOpen(false)}>
              Annulla
            </Button>
            <Button type="submit" disabled={saving}>
              {saving ? "Salvataggio…" : "Salva"}
            </Button>
          </div>
        </form>
      </Modal>
    </>
  );
}
