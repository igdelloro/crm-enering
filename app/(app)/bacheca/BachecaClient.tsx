"use client";

import { useState } from "react";
import { useRouter } from "next/navigation";
import { timeAgo } from "@/lib/format";
import {
  PageHeader,
  Card,
  Button,
  Modal,
  Field,
  Input,
  Textarea,
  EmptyState,
} from "@/components/ui";
import { saveAnnuncio, deleteAnnuncio } from "./actions";

type Annuncio = {
  id: string;
  titolo: string;
  corpo: string | null;
  created_at: string;
};

export default function BachecaClient({
  annunci,
  canManage,
}: {
  annunci: Annuncio[];
  canManage: boolean;
}) {
  const router = useRouter();
  const [open, setOpen] = useState(false);
  const [editing, setEditing] = useState<Annuncio | null>(null);
  const [error, setError] = useState<string | null>(null);
  const [saving, setSaving] = useState(false);

  function openNew() {
    setEditing(null);
    setError(null);
    setOpen(true);
  }
  function openEdit(a: Annuncio) {
    setEditing(a);
    setError(null);
    setOpen(true);
  }

  async function onSubmit(e: React.FormEvent<HTMLFormElement>) {
    e.preventDefault();
    setSaving(true);
    setError(null);
    const res = await saveAnnuncio(new FormData(e.currentTarget));
    setSaving(false);
    if (res?.error) {
      setError(res.error);
      return;
    }
    setOpen(false);
    router.refresh();
  }

  async function onDelete(id: string) {
    if (!confirm("Eliminare questo annuncio?")) return;
    await deleteAnnuncio(id);
    router.refresh();
  }

  return (
    <>
      <PageHeader
        title="Bacheca"
        subtitle="Annunci e comunicazioni per il team"
        action={
          canManage ? (
            <Button onClick={openNew}>+ Nuovo annuncio</Button>
          ) : undefined
        }
      />

      {annunci.length === 0 ? (
        <Card>
          <EmptyState message="Nessun annuncio al momento." />
        </Card>
      ) : (
        <div className="space-y-4">
          {annunci.map((a) => (
            <Card key={a.id}>
              <div className="p-5">
                <div className="flex items-start justify-between gap-3">
                  <div>
                    <h3 className="font-semibold text-slate-900 dark:text-slate-100">
                      {a.titolo}
                    </h3>
                    <p className="text-xs text-slate-400 dark:text-slate-500 mt-0.5">
                      {timeAgo(a.created_at)}
                    </p>
                  </div>
                  {canManage && (
                    <div className="flex gap-3 shrink-0 text-sm">
                      <button
                        onClick={() => openEdit(a)}
                        className="text-brand-600 dark:text-brand-300 hover:underline"
                      >
                        Modifica
                      </button>
                      <button
                        onClick={() => onDelete(a.id)}
                        className="text-red-500 hover:underline"
                      >
                        Elimina
                      </button>
                    </div>
                  )}
                </div>
                {a.corpo && (
                  <p className="mt-3 text-sm text-slate-700 dark:text-slate-200 whitespace-pre-wrap">
                    {a.corpo}
                  </p>
                )}
              </div>
            </Card>
          ))}
        </div>
      )}

      <Modal
        open={open}
        onClose={() => setOpen(false)}
        title={editing ? "Modifica annuncio" : "Nuovo annuncio"}
      >
        <form onSubmit={onSubmit} className="space-y-4">
          {editing && <input type="hidden" name="id" value={editing.id} />}
          <Field label="Titolo *">
            <Input name="titolo" required defaultValue={editing?.titolo ?? ""} />
          </Field>
          <Field label="Testo">
            <Textarea name="corpo" rows={5} defaultValue={editing?.corpo ?? ""} />
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
