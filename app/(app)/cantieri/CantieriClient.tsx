"use client";

import { useCallback, useEffect, useMemo, useRef, useState } from "react";
import Link from "next/link";
import type { Agente, Cantiere } from "@/lib/types";
import { FASI_CANTIERE, nomeAgente } from "@/lib/types";
import { createClient } from "@/lib/supabase/client";
import { formatCurrency, formatDate } from "@/lib/format";
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
} from "@/components/ui";
import {
  moveCantiere,
  archiviaInCV,
  saveCantiere,
  deleteCantiere,
  addTask,
  toggleTask,
  deleteTask,
} from "./actions";

type Task = {
  id: string;
  descrizione: string;
  assegnato_agente_id: string | null;
  fatto: boolean;
  scadenza: string | null;
};
type CRow = Cantiere & {
  preventivi: { numero: string | null } | null;
  companies: { name: string } | null;
  cantiere_task: Task[] | null;
};

export default function CantieriClient({ agenti }: { agenti: Agente[] }) {
  const supabase = useMemo(() => createClient(), []);
  const agenteById = useMemo(
    () => Object.fromEntries(agenti.map((a) => [a.id, a])),
    [agenti]
  );

  const [rows, setRows] = useState<CRow[]>([]);
  const [loading, setLoading] = useState(true);
  const dragId = useRef<string | null>(null);

  const [sel, setSel] = useState<CRow | null>(null);
  const [saving, setSaving] = useState(false);

  const fetchAll = useCallback(async () => {
    setLoading(true);
    const { data } = await supabase
      .from("cantieri")
      .select(
        "*, preventivi(numero), companies(name), cantiere_task(id, descrizione, assegnato_agente_id, fatto, scadenza)"
      )
      .or("in_cv.is.null,in_cv.eq.false")
      .order("created_at", { ascending: false });
    setRows((data as any) ?? []);
    setLoading(false);
  }, [supabase]);

  useEffect(() => {
    fetchAll();
  }, [fetchAll]);

  async function onDrop(fase: string) {
    const id = dragId.current;
    dragId.current = null;
    if (!id) return;
    const c = rows.find((r) => r.id === id);
    if (!c || c.fase === fase) return;

    // Spostamento su "Chiuso": conferma e archivia nel Curriculum Vitae
    if (fase === "chiuso") {
      const ok = confirm(
        "Segnare questa commessa come CHIUSA e spostarlo nel Curriculum Vitae?"
      );
      if (!ok) return;
      setRows((prev) => prev.filter((r) => r.id !== id));
      await archiviaInCV(id);
      return;
    }

    // aggiornamento ottimistico
    setRows((prev) => prev.map((r) => (r.id === id ? { ...r, fase } : r)));
    await moveCantiere(id, fase);
  }

  async function onSave(e: React.FormEvent<HTMLFormElement>) {
    e.preventDefault();
    setSaving(true);
    await saveCantiere(new FormData(e.currentTarget));
    setSaving(false);
    setSel(null);
    fetchAll();
  }
  async function onDeleteCantiere(id: string) {
    if (!confirm("Eliminare questa commessa?")) return;
    const res = await deleteCantiere(id);
    if (res?.error) alert(res.error);
    setSel(null);
    fetchAll();
  }

  // task
  async function onAddTask(e: React.FormEvent<HTMLFormElement>) {
    e.preventDefault();
    const form = e.currentTarget;
    const res = await addTask(new FormData(form));
    if (res?.error) {
      alert(res.error);
      return;
    }
    form.reset();
    const updated = await refetchOne(sel!.id);
    if (updated) setSel(updated);
    fetchAll();
  }
  async function onToggleTask(t: Task) {
    await toggleTask(t.id, !t.fatto);
    const updated = await refetchOne(sel!.id);
    if (updated) setSel(updated);
    fetchAll();
  }
  async function onDeleteTask(id: string) {
    await deleteTask(id);
    const updated = await refetchOne(sel!.id);
    if (updated) setSel(updated);
    fetchAll();
  }
  async function refetchOne(id: string): Promise<CRow | null> {
    const { data } = await supabase
      .from("cantieri")
      .select(
        "*, preventivi(numero), companies(name), cantiere_task(id, descrizione, assegnato_agente_id, fatto, scadenza)"
      )
      .eq("id", id)
      .single();
    return (data as any) ?? null;
  }

  function progress(c: CRow) {
    const t = c.cantiere_task ?? [];
    const done = t.filter((x) => x.fatto).length;
    return { done, tot: t.length };
  }

  return (
    <>
      <PageHeader
        title="Commesse"
        subtitle={
          loading ? "Caricamento…" : `${rows.length} commesse`
        }
      />

      <div className="flex gap-3 overflow-x-auto pb-4">
        {FASI_CANTIERE.map((f) => {
          const col = rows.filter((r) => r.fase === f.value);
          return (
            <div
              key={f.value}
              onDragOver={(e) => e.preventDefault()}
              onDrop={() => onDrop(f.value)}
              className="w-64 shrink-0"
            >
              <div className="flex items-center justify-between mb-2 px-1">
                <span className="text-sm font-semibold text-slate-700 dark:text-slate-200">
                  {f.label}
                </span>
                <span className="text-xs text-slate-400 dark:text-slate-500">{col.length}</span>
              </div>
              <div className="space-y-2 min-h-[60px]">
                {col.map((c) => {
                  const p = progress(c);
                  return (
                    <div
                      key={c.id}
                      draggable
                      onDragStart={() => (dragId.current = c.id)}
                      onClick={() => setSel(c)}
                      className="bg-white dark:bg-slate-900 rounded-xl border border-slate-200 dark:border-slate-700 p-3 shadow-sm cursor-pointer hover:border-brand-300 dark:hover:border-brand-500"
                    >
                      <div className="text-sm font-semibold text-slate-800 dark:text-slate-100">
                        {c.titolo ?? c.preventivi?.numero ?? "Commessa"}
                      </div>
                      <div className="text-xs text-slate-500 dark:text-slate-400 mt-0.5">
                        {c.companies?.name ?? "—"}
                      </div>
                      <div className="flex items-center justify-between mt-2">
                        <span className="text-xs font-medium text-slate-600 dark:text-slate-300">
                          {c.importo != null ? formatCurrency(Number(c.importo)) : ""}
                        </span>
                        {p.tot > 0 && (
                          <Badge color={p.done === p.tot ? "green" : "slate"}>
                            {p.done}/{p.tot} compiti
                          </Badge>
                        )}
                      </div>
                      {c.responsabile_agente_id && (
                        <div className="text-[11px] text-slate-400 dark:text-slate-500 mt-1">
                          Resp.: {nomeAgente(agenteById[c.responsabile_agente_id])}
                        </div>
                      )}
                    </div>
                  );
                })}
                {col.length === 0 && (
                  <div className="text-xs text-slate-300 text-center py-6 border border-dashed border-slate-200 dark:border-slate-700 rounded-xl">
                    —
                  </div>
                )}
              </div>
            </div>
          );
        })}
      </div>

      {rows.length === 0 && !loading && (
        <p className="text-sm text-slate-400 dark:text-slate-500 mt-4">
          Nessuna commessa ancora. Si creano in automatico quando un preventivo
          passa ad «Accettato» o una gara ad «Aggiudicata».
        </p>
      )}

      {/* Dettaglio commessa */}
      <Modal
        open={!!sel}
        onClose={() => setSel(null)}
        title={sel?.titolo ?? "Commessa"}
      >
        {sel && (
          <div className="space-y-5">
            <form onSubmit={onSave} className="space-y-4">
              <input type="hidden" name="id" value={sel.id} />
              <div className="flex items-center gap-2 text-sm">
                {sel.companies?.name && (
                  <span className="text-slate-500 dark:text-slate-400">{sel.companies.name}</span>
                )}
                {sel.preventivi?.numero && (
                  <Badge color="blue">{sel.preventivi.numero}</Badge>
                )}
                {sel.company_id && (
                  <Link
                    href={`/clienti/${sel.company_id}`}
                    className="text-brand-600 dark:text-brand-300 hover:underline text-xs"
                  >
                    scheda cliente
                  </Link>
                )}
              </div>
              <Field label="Titolo">
                <Input name="titolo" defaultValue={sel.titolo ?? ""} />
              </Field>
              <div className="grid grid-cols-2 gap-4">
                <Field label="Fase">
                  <Select name="fase" defaultValue={sel.fase}>
                    {FASI_CANTIERE.map((f) => (
                      <option key={f.value} value={f.value}>
                        {f.label}
                      </option>
                    ))}
                  </Select>
                </Field>
                <Field label="Responsabile">
                  <Select
                    name="responsabile_agente_id"
                    defaultValue={sel.responsabile_agente_id ?? ""}
                  >
                    <option value="">—</option>
                    {agenti.map((a) => (
                      <option key={a.id} value={a.id}>
                        {nomeAgente(a)}
                      </option>
                    ))}
                  </Select>
                </Field>
              </div>
              <Field label="Note">
                <Textarea name="note" defaultValue={sel.note ?? ""} />
              </Field>
              <div className="flex justify-between items-center">
                <button
                  type="button"
                  onClick={() => onDeleteCantiere(sel.id)}
                  className="text-sm text-red-500 hover:underline"
                >
                  Elimina commessa
                </button>
                <Button type="submit" disabled={saving}>
                  {saving ? "Salvataggio…" : "Salva"}
                </Button>
              </div>
            </form>

            {/* Compiti */}
            <div className="border-t border-slate-100 dark:border-slate-800 pt-4">
              <p className="text-sm font-semibold text-slate-700 dark:text-slate-200 mb-2">Compiti</p>
              <div className="space-y-1.5 mb-3">
                {(sel.cantiere_task ?? []).length === 0 && (
                  <p className="text-xs text-slate-400 dark:text-slate-500">Nessun compito.</p>
                )}
                {(sel.cantiere_task ?? []).map((t) => (
                  <div
                    key={t.id}
                    className="flex items-center gap-2 text-sm bg-slate-50 dark:bg-slate-800 rounded-lg px-2 py-1.5"
                  >
                    <input
                      type="checkbox"
                      checked={t.fatto}
                      onChange={() => onToggleTask(t)}
                    />
                    <span className={t.fatto ? "line-through text-slate-400 dark:text-slate-500" : ""}>
                      {t.descrizione}
                    </span>
                    <span className="ml-auto text-xs text-slate-400 dark:text-slate-500">
                      {t.assegnato_agente_id &&
                        nomeAgente(agenteById[t.assegnato_agente_id])}
                      {t.scadenza && ` · ${formatDate(t.scadenza)}`}
                    </span>
                    <button
                      onClick={() => onDeleteTask(t.id)}
                      className="text-red-400 hover:text-red-600 text-xs"
                    >
                      ×
                    </button>
                  </div>
                ))}
              </div>
              <form onSubmit={onAddTask} className="flex flex-wrap gap-2">
                <input type="hidden" name="cantiere_id" value={sel.id} />
                <Input
                  name="descrizione"
                  placeholder="Nuovo compito…"
                  className="flex-1 min-w-[160px]"
                  required
                />
                <Select name="assegnato_agente_id" className="max-w-[150px]">
                  <option value="">Assegna a…</option>
                  {agenti.map((a) => (
                    <option key={a.id} value={a.id}>
                      {nomeAgente(a)}
                    </option>
                  ))}
                </Select>
                <Input type="date" name="scadenza" className="max-w-[150px]" />
                <Button type="submit" variant="ghost">
                  + Aggiungi
                </Button>
              </form>
            </div>
          </div>
        )}
      </Modal>
    </>
  );
}
