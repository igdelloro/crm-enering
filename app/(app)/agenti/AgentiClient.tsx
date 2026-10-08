"use client";

import { useState } from "react";
import { useRouter } from "next/navigation";
import type { Agente, RuoloAgente } from "@/lib/types";
import { RUOLI_AGENTE, ruoloLabel, agenteRuoli } from "@/lib/types";
import {
  PageHeader,
  Card,
  Button,
  Modal,
  Field,
  Input,
  Badge,
  EmptyState,
} from "@/components/ui";
import { saveAgente, deleteAgente } from "./actions";

const ruoloColor: Record<
  RuoloAgente,
  "violet" | "blue" | "green" | "amber" | "red"
> = {
  amministratore: "red",
  responsabile: "violet",
  ufficio_sole: "amber",
  telemarketing: "blue",
  venditore: "green",
};

export default function AgentiClient({ agenti }: { agenti: Agente[] }) {
  const router = useRouter();
  const [open, setOpen] = useState(false);
  const [editing, setEditing] = useState<Agente | null>(null);
  const [error, setError] = useState<string | null>(null);
  const [saving, setSaving] = useState(false);
  const [ruoliSel, setRuoliSel] = useState<string[]>([]);

  function openNew() {
    setEditing(null);
    setRuoliSel(["venditore"]);
    setError(null);
    setOpen(true);
  }
  function openEdit(a: Agente) {
    setEditing(a);
    setRuoliSel(agenteRuoli(a));
    setError(null);
    setOpen(true);
  }

  async function onSubmit(e: React.FormEvent<HTMLFormElement>) {
    e.preventDefault();
    setSaving(true);
    setError(null);
    const fd = new FormData(e.currentTarget);
    fd.delete("ruoli");
    ruoliSel.forEach((r) => fd.append("ruoli", r));
    const res = await saveAgente(fd);
    setSaving(false);
    if (res?.error) {
      setError(res.error);
      return;
    }
    setOpen(false);
    router.refresh();
  }

  async function onDelete(id: string) {
    if (!confirm("Eliminare questa persona? Resterà nei clienti già assegnati finché non li riassegni."))
      return;
    await deleteAgente(id);
    router.refresh();
  }

  return (
    <>
      <PageHeader
        title="Ruoli"
        subtitle={`${agenti.length} persone nel team`}
        action={<Button onClick={openNew}>+ Aggiungi persona</Button>}
      />

      <Card>
        {agenti.length === 0 ? (
          <EmptyState message="Nessuna persona. Aggiungi qui i membri del team con il loro ruolo." />
        ) : (
          <div className="overflow-x-auto"><table className="w-full text-sm min-w-[640px]">
            <thead>
              <tr className="text-left text-slate-500 dark:text-slate-400 border-b border-slate-100 dark:border-slate-800">
                <th className="px-5 py-3 font-medium">Nome</th>
                <th className="px-5 py-3 font-medium">Ruolo</th>
                <th className="px-5 py-3 font-medium">Email</th>
                <th className="px-5 py-3 font-medium">Stato</th>
                <th className="px-5 py-3"></th>
              </tr>
            </thead>
            <tbody>
              {agenti.map((a) => (
                <tr
                  key={a.id}
                  className="border-b border-slate-50 dark:border-slate-800 hover:bg-slate-50 dark:hover:bg-slate-800"
                >
                  <td className="px-5 py-3 font-medium text-slate-800 dark:text-slate-100">
                    {a.nome} {a.cognome}
                  </td>
                  <td className="px-5 py-3">
                    <div className="flex flex-wrap gap-1">
                      {agenteRuoli(a).map((r) => (
                        <Badge key={r} color={ruoloColor[r as RuoloAgente] ?? "slate"}>
                          {ruoloLabel(r as RuoloAgente)}
                        </Badge>
                      ))}
                    </div>
                  </td>
                  <td className="px-5 py-3 text-slate-600 dark:text-slate-300">{a.email ?? "—"}</td>
                  <td className="px-5 py-3 text-slate-600 dark:text-slate-300">
                    {a.attivo ? "Attivo" : "Non attivo"}
                  </td>
                  <td className="px-5 py-3 text-right whitespace-nowrap">
                    <button
                      onClick={() => openEdit(a)}
                      className="text-brand-600 dark:text-brand-300 hover:underline mr-3"
                    >
                      Modifica
                    </button>
                    <button
                      onClick={() => onDelete(a.id)}
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
      </Card>

      <Modal
        open={open}
        onClose={() => setOpen(false)}
        title={editing ? "Modifica persona" : "Nuova persona"}
      >
        <form onSubmit={onSubmit} className="space-y-4">
          {editing && <input type="hidden" name="id" value={editing.id} />}
          <div className="grid grid-cols-2 gap-4">
            <Field label="Nome *">
              <Input name="nome" required defaultValue={editing?.nome ?? ""} />
            </Field>
            <Field label="Cognome">
              <Input name="cognome" defaultValue={editing?.cognome ?? ""} />
            </Field>
          </div>
          <Field label="Ruoli (una persona può averne più di uno)">
            <div className="flex flex-wrap gap-2">
              {RUOLI_AGENTE.map((r) => {
                const on = ruoliSel.includes(r.value);
                return (
                  <button
                    type="button"
                    key={r.value}
                    onClick={() =>
                      setRuoliSel((prev) =>
                        on
                          ? prev.filter((x) => x !== r.value)
                          : [...prev, r.value]
                      )
                    }
                    className={`rounded-full px-3 py-1 text-xs font-medium border transition ${
                      on
                        ? "bg-brand-600 text-white border-brand-600"
                        : "bg-white dark:bg-slate-900 text-slate-600 dark:text-slate-300 border-slate-300 dark:border-slate-600 hover:bg-slate-50 dark:hover:bg-slate-800"
                    }`}
                  >
                    {r.label}
                  </button>
                );
              })}
            </div>
          </Field>
          {ruoliSel.includes("venditore") && (
            <Field label="Sigla preventivi (automatica, modificabile)">
              <Input
                name="sigla"
                maxLength={4}
                placeholder="auto da iniziali"
                defaultValue={editing?.sigla ?? ""}
                style={{ textTransform: "uppercase" }}
              />
              <p className="text-xs text-slate-400 dark:text-slate-500 mt-1">
                Se la lasci vuota, viene assegnata da sola con le iniziali di
                nome e cognome.
              </p>
            </Field>
          )}
          <Field label="Email">
            <Input type="email" name="email" defaultValue={editing?.email ?? ""} />
          </Field>
          <label className="flex items-center gap-2 text-sm text-slate-700 dark:text-slate-200">
            <input
              type="checkbox"
              name="attivo"
              defaultChecked={editing ? editing.attivo : true}
            />
            Attivo
          </label>

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
