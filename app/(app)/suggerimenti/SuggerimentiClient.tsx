"use client";

import { useState } from "react";
import { useRouter } from "next/navigation";
import { formatDate } from "@/lib/format";
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
import { saveSuggerimento, setRisolto, deleteSuggerimento } from "./actions";

type Suggerimento = {
  id: string;
  sezione: string | null;
  titolo: string;
  descrizione: string | null;
  risolto: boolean;
  priorita: string;
  created_at: string;
};

const SEZIONI = [
  "Agenda",
  "Clienti",
  "Preventivi",
  "Commesse",
  "Curriculum",
  "Performance",
  "Provvigioni",
  "Ruoli",
  "Bacheca",
  "Altro",
];

const PRIORITA: Record<string, "slate" | "blue" | "amber" | "red"> = {
  bassa: "slate",
  media: "amber",
  alta: "red",
};

export default function SuggerimentiClient({
  suggerimenti,
  canManage,
}: {
  suggerimenti: Suggerimento[];
  canManage: boolean;
}) {
  const router = useRouter();
  const [open, setOpen] = useState(false);
  const [editing, setEditing] = useState<Suggerimento | null>(null);
  const [error, setError] = useState<string | null>(null);
  const [saving, setSaving] = useState(false);
  const [filtro, setFiltro] = useState<"tutti" | "aperti" | "risolti">("aperti");

  const righe = suggerimenti.filter((s) =>
    filtro === "tutti" ? true : filtro === "aperti" ? !s.risolto : s.risolto
  );

  function openNew() {
    setEditing(null);
    setError(null);
    setOpen(true);
  }
  function openEdit(s: Suggerimento) {
    if (!canManage) return;
    setEditing(s);
    setError(null);
    setOpen(true);
  }

  async function onSubmit(e: React.FormEvent<HTMLFormElement>) {
    e.preventDefault();
    setSaving(true);
    setError(null);
    const res = await saveSuggerimento(new FormData(e.currentTarget));
    setSaving(false);
    if (res?.error) {
      setError(res.error);
      return;
    }
    setOpen(false);
    router.refresh();
  }

  async function onToggle(s: Suggerimento) {
    await setRisolto(s.id, !s.risolto);
    router.refresh();
  }

  async function onDelete(id: string) {
    if (!confirm("Eliminare questo suggerimento?")) return;
    await deleteSuggerimento(id);
    router.refresh();
  }

  return (
    <>
      <PageHeader
        title="Suggerimenti"
        subtitle="Segnalazioni e proposte di miglioramento"
        action={<Button onClick={openNew}>+ Nuovo suggerimento</Button>}
      />

      <div className="flex gap-1 mb-4 text-sm">
        {(["aperti", "risolti", "tutti"] as const).map((f) => (
          <button
            key={f}
            onClick={() => setFiltro(f)}
            className={`px-3 py-1.5 rounded-lg font-medium capitalize transition ${
              filtro === f
                ? "bg-brand-600 text-white"
                : "bg-slate-100 dark:bg-slate-800 text-slate-600 dark:text-slate-300 hover:bg-slate-200 dark:hover:bg-slate-700"
            }`}
          >
            {f}
          </button>
        ))}
      </div>

      <Card>
        {righe.length === 0 ? (
          <EmptyState message="Nessun suggerimento in questa vista." />
        ) : (
          <div className="overflow-x-auto">
            <table className="w-full text-sm min-w-[720px]">
              <thead>
                <tr className="text-left text-slate-500 dark:text-slate-400 border-b border-slate-100 dark:border-slate-800">
                  <th className="px-4 py-3 font-medium">Sezione</th>
                  <th className="px-4 py-3 font-medium">Titolo</th>
                  <th className="px-4 py-3 font-medium">Descrizione</th>
                  <th className="px-4 py-3 font-medium">Creato</th>
                  <th className="px-4 py-3 font-medium">Risolto</th>
                  <th className="px-4 py-3 font-medium">Priorità</th>
                  {canManage && <th className="px-4 py-3"></th>}
                </tr>
              </thead>
              <tbody>
                {righe.map((s) => (
                  <tr
                    key={s.id}
                    className="border-b border-slate-50 dark:border-slate-800 hover:bg-slate-50 dark:hover:bg-slate-800/50"
                  >
                    <td className="px-4 py-3 text-slate-600 dark:text-slate-300">
                      {s.sezione ?? "—"}
                    </td>
                    <td
                      className={`px-4 py-3 font-medium text-slate-800 dark:text-slate-100 ${
                        canManage ? "cursor-pointer" : ""
                      }`}
                      onClick={() => openEdit(s)}
                    >
                      {s.titolo}
                    </td>
                    <td className="px-4 py-3 text-slate-500 dark:text-slate-400 max-w-[280px] truncate">
                      {s.descrizione ?? "—"}
                    </td>
                    <td className="px-4 py-3 text-slate-500 dark:text-slate-400 whitespace-nowrap">
                      {formatDate(s.created_at)}
                    </td>
                    <td className="px-4 py-3">
                      {canManage ? (
                        <button
                          onClick={() => onToggle(s)}
                          title={s.risolto ? "Segna come aperto" : "Segna come risolto"}
                          className={
                            s.risolto
                              ? "text-green-600 dark:text-green-400"
                              : "text-slate-300 dark:text-slate-600 hover:text-slate-500"
                          }
                        >
                          {s.risolto ? "✓" : "○"}
                        </button>
                      ) : s.risolto ? (
                        <span className="text-green-600 dark:text-green-400">✓</span>
                      ) : (
                        <span className="text-slate-300 dark:text-slate-600">○</span>
                      )}
                    </td>
                    <td className="px-4 py-3">
                      <Badge color={PRIORITA[s.priorita] ?? "slate"}>
                        {s.priorita}
                      </Badge>
                    </td>
                    {canManage && (
                      <td className="px-4 py-3 text-right whitespace-nowrap">
                        <button
                          onClick={() => onDelete(s.id)}
                          className="text-red-500 hover:underline"
                        >
                          Elimina
                        </button>
                      </td>
                    )}
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
        title={editing ? "Modifica suggerimento" : "Nuovo suggerimento"}
      >
        <form onSubmit={onSubmit} className="space-y-4">
          {editing && <input type="hidden" name="id" value={editing.id} />}
          <div className="grid grid-cols-2 gap-4">
            <Field label="Sezione">
              <Select name="sezione" defaultValue={editing?.sezione ?? ""}>
                <option value="">—</option>
                {SEZIONI.map((s) => (
                  <option key={s} value={s}>
                    {s}
                  </option>
                ))}
              </Select>
            </Field>
            <Field label="Priorità">
              <Select name="priorita" defaultValue={editing?.priorita ?? "bassa"}>
                <option value="bassa">bassa</option>
                <option value="media">media</option>
                <option value="alta">alta</option>
              </Select>
            </Field>
          </div>
          <Field label="Titolo *">
            <Input name="titolo" required defaultValue={editing?.titolo ?? ""} />
          </Field>
          <Field label="Descrizione">
            <Textarea
              name="descrizione"
              rows={4}
              defaultValue={editing?.descrizione ?? ""}
            />
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
