"use client";

import { useCallback, useEffect, useMemo, useState } from "react";
import type { Company, Agente, TipoCliente } from "@/lib/types";
import {
  TIPI_CLIENTE,
  nomeAgente,
  agenteRuoli,
  calcolaSemaforo,
  SEMAFORO_HEX,
  SEMAFORO_LABEL,
} from "@/lib/types";
import { REGIONI } from "@/lib/geo";
import { createClient } from "@/lib/supabase/client";
import Link from "next/link";
import {
  PageHeader,
  Card,
  Button,
  Modal,
  Input,
  Select,
  Badge,
  EmptyState,
} from "@/components/ui";
import { deleteClient, toggleFlag } from "./actions";
import ClientForm from "./ClientForm";

const PAGE_SIZE = 15;

const tipoColor: Record<TipoCliente, "violet" | "blue" | "slate"> = {
  pa: "violet",
  societa: "blue",
  privato: "slate",
};

function Semaforo({ company }: { company: Company }) {
  const col = calcolaSemaforo(company.last_contact_at, company.flag_manuale);
  return (
    <span
      title={SEMAFORO_LABEL[col]}
      className="inline-block w-3.5 h-3.5 rounded-full ring-1 ring-black/5"
      style={{ backgroundColor: SEMAFORO_HEX[col] }}
    />
  );
}

export default function ClientiClient({ agenti }: { agenti: Agente[] }) {
  const supabase = useMemo(() => createClient(), []);

  const [rows, setRows] = useState<Company[]>([]);
  const [total, setTotal] = useState(0);
  const [loading, setLoading] = useState(false);
  const [loadError, setLoadError] = useState<string | null>(null);

  // filtri
  const [q, setQ] = useState("");
  const [fTipo, setFTipo] = useState<"" | TipoCliente>("");
  const [fRegione, setFRegione] = useState("");
  const [fProvincia, setFProvincia] = useState("");
  const [fVend, setFVend] = useState("");
  const [fTlmk, setFTlmk] = useState("");
  const [fSemaforo, setFSemaforo] = useState("");

  // form "nuovo cliente"
  const [open, setOpen] = useState(false);

  const agenteById = useMemo(
    () => Object.fromEntries(agenti.map((a) => [a.id, a])),
    [agenti]
  );

  // Costruisce la query filtrata e scarica un blocco di risultati.
  const fetchPage = useCallback(
    async (reset: boolean, currentCount: number) => {
      setLoading(true);
      setLoadError(null);
      const from = reset ? 0 : currentCount;

      let query = supabase
        .from("companies")
        .select("*", { count: "exact" })
        .order("name", { ascending: true });

      if (fTipo) query = query.eq("tipo", fTipo);
      if (fRegione) query = query.eq("regione", fRegione);
      if (fProvincia) query = query.ilike("provincia", fProvincia.trim());
      if (fVend) query = query.eq("venditore_agente_id", fVend);
      if (fTlmk) query = query.eq("tlmk_agente_id", fTlmk);
      if (fSemaforo) {
        if (fSemaforo === "azzurro") {
          query = query.eq("flag_manuale", "azzurro");
        } else {
          // i colori automatici valgono solo se non c'è il flag manuale
          query = query.is("flag_manuale", null);
          const now = Date.now();
          const d30 = new Date(now - 30 * 86400000).toISOString();
          const d60 = new Date(now - 60 * 86400000).toISOString();
          const d120 = new Date(now - 120 * 86400000).toISOString();
          if (fSemaforo === "verde") query = query.gte("last_contact_at", d30);
          else if (fSemaforo === "giallo")
            query = query.lt("last_contact_at", d30).gte("last_contact_at", d60);
          else if (fSemaforo === "arancione")
            query = query.lt("last_contact_at", d60).gte("last_contact_at", d120);
          else if (fSemaforo === "rosso")
            query = query.lt("last_contact_at", d120);
          else if (fSemaforo === "grigio")
            query = query.is("last_contact_at", null);
        }
      }
      if (q.trim()) {
        const term = q.replace(/[(),%*]/g, " ").trim();
        if (term) {
          query = query.or(
            `name.ilike.%${term}%,citta.ilike.%${term}%,piva.ilike.%${term}%,referente_nome.ilike.%${term}%`
          );
        }
      }

      query = query.range(from, from + PAGE_SIZE - 1);

      const { data, count, error } = await query;
      setLoading(false);
      if (error) {
        setLoadError(error.message);
        return;
      }
      const batch = (data as Company[]) ?? [];
      setTotal(count ?? 0);
      setRows((prev) => (reset ? batch : [...prev, ...batch]));
    },
    [supabase, fTipo, fRegione, fProvincia, fVend, fTlmk, fSemaforo, q]
  );

  const hasFilters = !!(
    q.trim() ||
    fTipo ||
    fRegione ||
    fProvincia.trim() ||
    fVend ||
    fTlmk ||
    fSemaforo
  );

  // All'apertura la lista è vuota: i clienti si caricano solo quando c'è una
  // ricerca o un filtro attivo (la ricerca testuale è "debounced").
  useEffect(() => {
    if (!hasFilters) {
      setRows([]);
      setTotal(0);
      return;
    }
    const t = setTimeout(() => fetchPage(true, 0), 250);
    return () => clearTimeout(t);
  }, [fetchPage, hasFilters]);

  async function onDelete(id: string) {
    if (!confirm("Eliminare questo cliente?")) return;
    const res = await deleteClient(id);
    if (res?.error) alert(res.error);
    fetchPage(true, 0);
  }

  async function onToggleFlag(c: Company) {
    await toggleFlag(c.id, c.flag_manuale !== "azzurro");
    // aggiorno solo la riga interessata, senza ricaricare tutto
    setRows((prev) =>
      prev.map((r) =>
        r.id === c.id
          ? { ...r, flag_manuale: c.flag_manuale === "azzurro" ? null : "azzurro" }
          : r
      )
    );
  }

  return (
    <>
      <PageHeader
        title="Clienti"
        subtitle={
          !hasFilters
            ? "Usa la ricerca o i filtri per mostrare i clienti"
            : loading && rows.length === 0
            ? "Caricamento…"
            : `${total} risultati`
        }
        action={<Button onClick={() => setOpen(true)}>+ Nuovo cliente</Button>}
      />

      {/* Filtri */}
      <div className="flex flex-wrap gap-3 mb-4">
        <Input
          placeholder="Cerca nome, città, P.IVA, referente…"
          value={q}
          onChange={(e) => setQ(e.target.value)}
          className="max-w-xs"
        />
        <Select
          value={fTipo}
          onChange={(e) => setFTipo(e.target.value as any)}
          className="max-w-[200px]"
        >
          <option value="">Tutti i tipi</option>
          {TIPI_CLIENTE.map((t) => (
            <option key={t.value} value={t.value}>
              {t.label}
            </option>
          ))}
        </Select>
        <Select
          value={fRegione}
          onChange={(e) => setFRegione(e.target.value)}
          className="max-w-[190px]"
        >
          <option value="">Tutte le regioni</option>
          {REGIONI.map((r) => (
            <option key={r} value={r}>
              {r}
            </option>
          ))}
        </Select>
        <Input
          placeholder="Provincia (sigla)"
          value={fProvincia}
          onChange={(e) => setFProvincia(e.target.value)}
          className="max-w-[140px]"
        />
        <Select
          value={fSemaforo}
          onChange={(e) => setFSemaforo(e.target.value)}
          className="max-w-[200px]"
        >
          <option value="">Tutti i semafori</option>
          <option value="verde">🟢 Verde (&lt; 30 gg)</option>
          <option value="giallo">🟡 Giallo (30–60)</option>
          <option value="arancione">🟠 Arancione (60–120)</option>
          <option value="rosso">🔴 Rosso (&gt; 120)</option>
          <option value="grigio">⚪ Nessun contatto</option>
          <option value="azzurro">🔵 Attenzionato</option>
        </Select>
        <Select
          value={fVend}
          onChange={(e) => setFVend(e.target.value)}
          className="max-w-[200px]"
        >
          <option value="">Tutti i venditori</option>
          {agenti
            .filter((a) => agenteRuoli(a).includes("venditore"))
            .map((a) => (
              <option key={a.id} value={a.id}>
                {nomeAgente(a)}
              </option>
            ))}
        </Select>
        <Select
          value={fTlmk}
          onChange={(e) => setFTlmk(e.target.value)}
          className="max-w-[200px]"
        >
          <option value="">Tutti i telemarketing</option>
          {agenti
            .filter((a) => agenteRuoli(a).includes("telemarketing"))
            .map((a) => (
              <option key={a.id} value={a.id}>
                {nomeAgente(a)}
              </option>
            ))}
        </Select>
        {hasFilters && (
          <button
            onClick={() => {
              setQ("");
              setFTipo("");
              setFRegione("");
              setFProvincia("");
              setFVend("");
              setFTlmk("");
              setFSemaforo("");
            }}
            className="text-sm text-slate-500 dark:text-slate-400 hover:underline"
          >
            Azzera filtri
          </button>
        )}
      </div>

      <Card>
        {loadError ? (
          <div className="p-6 text-sm text-red-600">
            Errore nel caricamento: {loadError}
          </div>
        ) : !hasFilters ? (
          <EmptyState message="Cerca un cliente per nome, città, P.IVA o referente — oppure usa i filtri (tipo, regione, provincia, agente) per mostrare l'elenco." />
        ) : rows.length === 0 && !loading ? (
          <EmptyState message="Nessun cliente trovato con questi criteri." />
        ) : (
          <div className="overflow-x-auto"><table className="w-full text-sm min-w-[640px]">
            <thead>
              <tr className="text-left text-slate-500 dark:text-slate-400 border-b border-slate-100 dark:border-slate-800">
                <th className="px-4 py-3 font-medium w-8"></th>
                <th className="px-4 py-3 font-medium">Cliente</th>
                <th className="px-4 py-3 font-medium">Tipo</th>
                <th className="px-4 py-3 font-medium">Telefono</th>
                <th className="px-4 py-3 font-medium">Referente</th>
                <th className="px-4 py-3 font-medium">Telemarketing</th>
                <th className="px-4 py-3 font-medium">Venditore</th>
                <th className="px-4 py-3"></th>
              </tr>
            </thead>
            <tbody>
              {rows.map((c) => (
                <tr
                  key={c.id}
                  className="border-b border-slate-50 dark:border-slate-800 hover:bg-slate-50 dark:hover:bg-slate-800"
                >
                  <td className="px-4 py-3">
                    <button
                      onClick={() => onToggleFlag(c)}
                      title="Clic: segna/togli «Attenzionato» (azzurro)"
                    >
                      <Semaforo company={c} />
                    </button>
                  </td>
                  <td className="px-4 py-3">
                    <Link
                      href={`/clienti/${c.id}`}
                      target="_blank"
                      rel="noopener"
                      className="font-medium text-slate-800 dark:text-slate-100 hover:text-brand-700 hover:underline"
                    >
                      {c.name}
                    </Link>
                    {c.citta && (
                      <div className="text-xs text-slate-400 dark:text-slate-500">
                        {c.citta}
                        {c.provincia ? ` (${c.provincia})` : ""}
                      </div>
                    )}
                  </td>
                  <td className="px-4 py-3">
                    <Badge color={tipoColor[c.tipo]}>
                      {c.tipo === "pa"
                        ? "PA"
                        : c.tipo === "societa"
                        ? "Società"
                        : "Privato"}
                    </Badge>
                  </td>
                  <td className="px-4 py-3 text-slate-600 dark:text-slate-300">{c.phone ?? "—"}</td>
                  <td className="px-4 py-3 text-slate-600 dark:text-slate-300">
                    {c.referente_nome ? (
                      <>
                        {c.referente_nome}
                        {c.referente_ruolo && (
                          <span className="text-xs text-slate-400 dark:text-slate-500">
                            {" "}· {c.referente_ruolo}
                          </span>
                        )}
                      </>
                    ) : (
                      "—"
                    )}
                  </td>
                  <td className="px-4 py-3 text-slate-600 dark:text-slate-300">
                    {c.tlmk_agente_id
                      ? nomeAgente(agenteById[c.tlmk_agente_id])
                      : "—"}
                  </td>
                  <td className="px-4 py-3 text-slate-600 dark:text-slate-300">
                    {c.venditore_agente_id
                      ? nomeAgente(agenteById[c.venditore_agente_id])
                      : "—"}
                  </td>
                  <td className="px-4 py-3 text-right whitespace-nowrap">
                    <button
                      onClick={() => onDelete(c.id)}
                      className="text-red-500 hover:underline"
                    >
                      Elimina
                    </button>
                  </td>
                </tr>
              ))}
            </tbody>
          </table></div>
        )}

        {/* Carica altri */}
        {rows.length > 0 && rows.length < total && (
          <div className="p-4 text-center border-t border-slate-50 dark:border-slate-800">
            <Button
              variant="ghost"
              disabled={loading}
              onClick={() => fetchPage(false, rows.length)}
            >
              {loading ? "Caricamento…" : "Carica altri 15"}
            </Button>
          </div>
        )}
      </Card>

      <Modal
        open={open}
        onClose={() => setOpen(false)}
        title="Nuovo cliente"
      >
        <ClientForm
          editing={null}
          agenti={agenti}
          onDone={() => {
            setOpen(false);
            fetchPage(true, 0);
          }}
        />
      </Modal>
    </>
  );
}
