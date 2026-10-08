"use client";

import { useMemo, useState } from "react";
import { useRouter } from "next/navigation";
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
import { saveProvvigione, deleteProvvigione } from "./actions";

type Row = {
  id: string;
  agente_id: string;
  periodo: string | null;
  imponibile: number | null;
  percentuale: number | null;
  importo: number | null;
  stato: string;
  note: string | null;
  agenti: { nome: string; cognome: string | null } | null;
};
type Agente = { id: string; nome: string; cognome: string | null };

export default function ProvvigioniClient({
  provvigioni,
  agenti,
}: {
  provvigioni: Row[];
  agenti: Agente[];
}) {
  const router = useRouter();
  const [open, setOpen] = useState(false);
  const [editing, setEditing] = useState<Row | null>(null);
  const [imponibile, setImponibile] = useState("");
  const [perc, setPerc] = useState("");
  const [importo, setImporto] = useState("");
  const [error, setError] = useState<string | null>(null);
  const [saving, setSaving] = useState(false);
  const [fAgente, setFAgente] = useState("");

  function openNew() {
    setEditing(null);
    setImponibile("");
    setPerc("");
    setImporto("");
    setError(null);
    setOpen(true);
  }
  function openEdit(r: Row) {
    setEditing(r);
    setImponibile(r.imponibile != null ? String(r.imponibile) : "");
    setPerc(r.percentuale != null ? String(r.percentuale) : "");
    setImporto(r.importo != null ? String(r.importo) : "");
    setError(null);
    setOpen(true);
  }

  // calcolo semiautomatico: imponibile × % → importo (modificabile a mano)
  function recalc(imp: string, pc: string) {
    const i = parseFloat(imp.replace(",", "."));
    const p = parseFloat(pc.replace(",", "."));
    if (!isNaN(i) && !isNaN(p)) {
      setImporto(String(Math.round(i * (p / 100) * 100) / 100));
    }
  }

  async function onSubmit(e: React.FormEvent<HTMLFormElement>) {
    e.preventDefault();
    setSaving(true);
    setError(null);
    const res = await saveProvvigione(new FormData(e.currentTarget));
    setSaving(false);
    if (res?.error) {
      setError(res.error);
      return;
    }
    setOpen(false);
    router.refresh();
  }
  async function onDelete(id: string) {
    if (!confirm("Eliminare questa provvigione?")) return;
    await deleteProvvigione(id);
    router.refresh();
  }

  const filtered = fAgente
    ? provvigioni.filter((p) => p.agente_id === fAgente)
    : provvigioni;
  const totale = filtered.reduce((s, p) => s + Number(p.importo ?? 0), 0);

  return (
    <>
      <PageHeader
        title="Provvigioni"
        subtitle={`${filtered.length} righe · totale ${formatCurrency(totale)}`}
        action={<Button onClick={openNew}>+ Nuova provvigione</Button>}
      />

      <div className="mb-4">
        <Select value={fAgente} onChange={(e) => setFAgente(e.target.value)} className="max-w-[220px]">
          <option value="">Tutte le persone</option>
          {agenti.map((a) => (
            <option key={a.id} value={a.id}>
              {a.nome} {a.cognome ?? ""}
            </option>
          ))}
        </Select>
      </div>

      <Card>
        {filtered.length === 0 ? (
          <EmptyState message="Nessuna provvigione. Usa «+ Nuova provvigione»." />
        ) : (
          <div className="overflow-x-auto">
            <table className="w-full text-sm min-w-[720px]">
              <thead>
                <tr className="text-left text-slate-500 dark:text-slate-400 border-b border-slate-100 dark:border-slate-800">
                  <th className="px-4 py-3 font-medium">Persona</th>
                  <th className="px-4 py-3 font-medium">Periodo</th>
                  <th className="px-4 py-3 font-medium">Imponibile</th>
                  <th className="px-4 py-3 font-medium">%</th>
                  <th className="px-4 py-3 font-medium">Provvigione</th>
                  <th className="px-4 py-3 font-medium">Stato</th>
                  <th className="px-4 py-3"></th>
                </tr>
              </thead>
              <tbody>
                {filtered.map((p) => (
                  <tr key={p.id} className="border-b border-slate-50 dark:border-slate-800 hover:bg-slate-50 dark:hover:bg-slate-800">
                    <td className="px-4 py-3 font-medium text-slate-800 dark:text-slate-100">
                      {p.agenti?.nome} {p.agenti?.cognome ?? ""}
                    </td>
                    <td className="px-4 py-3 text-slate-600 dark:text-slate-300">{p.periodo ?? "—"}</td>
                    <td className="px-4 py-3 text-slate-600 dark:text-slate-300">
                      {p.imponibile != null ? formatCurrency(Number(p.imponibile)) : "—"}
                    </td>
                    <td className="px-4 py-3 text-slate-600 dark:text-slate-300">
                      {p.percentuale != null ? `${p.percentuale}%` : "—"}
                    </td>
                    <td className="px-4 py-3 font-semibold text-slate-800 dark:text-slate-100">
                      {p.importo != null ? formatCurrency(Number(p.importo)) : "—"}
                    </td>
                    <td className="px-4 py-3">
                      <Badge color={p.stato === "liquidata" ? "green" : "amber"}>
                        {p.stato === "liquidata" ? "Liquidata" : "Da liquidare"}
                      </Badge>
                    </td>
                    <td className="px-4 py-3 text-right whitespace-nowrap">
                      <button onClick={() => openEdit(p)} className="text-brand-600 dark:text-brand-300 hover:underline mr-3">
                        Modifica
                      </button>
                      <button onClick={() => onDelete(p.id)} className="text-red-500 hover:underline">
                        Elimina
                      </button>
                    </td>
                  </tr>
                ))}
              </tbody>
            </table>
          </div>
        )}
      </Card>

      <Modal
        open={open}
        onClose={() => setOpen(false)}
        title={editing ? "Modifica provvigione" : "Nuova provvigione"}
      >
        <form onSubmit={onSubmit} className="space-y-4">
          {editing && <input type="hidden" name="id" value={editing.id} />}
          <Field label="Persona *">
            <Select name="agente_id" defaultValue={editing?.agente_id ?? ""} required>
              <option value="">—</option>
              {agenti.map((a) => (
                <option key={a.id} value={a.id}>
                  {a.nome} {a.cognome ?? ""}
                </option>
              ))}
            </Select>
          </Field>
          <Field label="Periodo (es. 2026 o 2026-10)">
            <Input name="periodo" defaultValue={editing?.periodo ?? ""} />
          </Field>
          <div className="grid grid-cols-3 gap-3">
            <Field label="Imponibile (€)">
              <Input
                type="number"
                name="imponibile"
                step="0.01"
                value={imponibile}
                onChange={(e) => {
                  setImponibile(e.target.value);
                  recalc(e.target.value, perc);
                }}
              />
            </Field>
            <Field label="% provvigione">
              <Input
                type="number"
                name="percentuale"
                step="0.01"
                value={perc}
                onChange={(e) => {
                  setPerc(e.target.value);
                  recalc(imponibile, e.target.value);
                }}
              />
            </Field>
            <Field label="Importo (€)">
              <Input
                type="number"
                name="importo"
                step="0.01"
                value={importo}
                onChange={(e) => setImporto(e.target.value)}
              />
            </Field>
          </div>
          <p className="text-xs text-slate-400 dark:text-slate-500 -mt-2">
            L&apos;importo si calcola da imponibile × %, ma resta sempre modificabile a mano.
          </p>
          <Field label="Stato">
            <Select name="stato" defaultValue={editing?.stato ?? "da_liquidare"}>
              <option value="da_liquidare">Da liquidare</option>
              <option value="liquidata">Liquidata</option>
            </Select>
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
