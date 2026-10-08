"use client";

import { useState } from "react";
import { useRouter } from "next/navigation";
import type { Contact, Company } from "@/lib/types";
import {
  PageHeader,
  Card,
  Button,
  Modal,
  Field,
  Input,
  Textarea,
  Select,
  EmptyState,
} from "@/components/ui";
import { saveContact, deleteContact } from "./actions";

type ContactWithCompany = Contact & { companies: { name: string } | null };

export default function ContactsClient({
  contacts,
  companies,
}: {
  contacts: ContactWithCompany[];
  companies: Pick<Company, "id" | "name">[];
}) {
  const router = useRouter();
  const [open, setOpen] = useState(false);
  const [editing, setEditing] = useState<Contact | null>(null);
  const [error, setError] = useState<string | null>(null);
  const [saving, setSaving] = useState(false);
  const [query, setQuery] = useState("");

  function openNew() {
    setEditing(null);
    setError(null);
    setOpen(true);
  }
  function openEdit(c: Contact) {
    setEditing(c);
    setError(null);
    setOpen(true);
  }

  async function onSubmit(e: React.FormEvent<HTMLFormElement>) {
    e.preventDefault();
    setSaving(true);
    setError(null);
    const fd = new FormData(e.currentTarget);
    const res = await saveContact(fd);
    setSaving(false);
    if (res?.error) {
      setError(res.error);
      return;
    }
    setOpen(false);
    router.refresh();
  }

  async function onDelete(id: string) {
    if (!confirm("Eliminare questo contatto?")) return;
    await deleteContact(id);
    router.refresh();
  }

  const filtered = contacts.filter((c) => {
    const s = `${c.first_name} ${c.last_name ?? ""} ${c.email ?? ""} ${
      c.companies?.name ?? ""
    }`.toLowerCase();
    return s.includes(query.toLowerCase());
  });

  return (
    <>
      <PageHeader
        title="Contatti"
        subtitle={`${contacts.length} persone in rubrica`}
        action={<Button onClick={openNew}>+ Nuovo contatto</Button>}
      />

      <div className="mb-4">
        <Input
          placeholder="Cerca per nome, email, azienda…"
          value={query}
          onChange={(e) => setQuery(e.target.value)}
          className="max-w-sm"
        />
      </div>

      <Card>
        {filtered.length === 0 ? (
          <EmptyState message="Nessun contatto trovato." />
        ) : (
          <div className="overflow-x-auto"><table className="w-full text-sm min-w-[640px]">
            <thead>
              <tr className="text-left text-slate-500 dark:text-slate-400 border-b border-slate-100 dark:border-slate-800">
                <th className="px-5 py-3 font-medium">Nome</th>
                <th className="px-5 py-3 font-medium">Ruolo</th>
                <th className="px-5 py-3 font-medium">Azienda</th>
                <th className="px-5 py-3 font-medium">Email</th>
                <th className="px-5 py-3 font-medium">Telefono</th>
                <th className="px-5 py-3"></th>
              </tr>
            </thead>
            <tbody>
              {filtered.map((c) => (
                <tr
                  key={c.id}
                  className="border-b border-slate-50 dark:border-slate-800 hover:bg-slate-50 dark:hover:bg-slate-800"
                >
                  <td className="px-5 py-3 font-medium text-slate-800 dark:text-slate-100">
                    {c.first_name} {c.last_name}
                  </td>
                  <td className="px-5 py-3 text-slate-600 dark:text-slate-300">
                    {c.job_title ?? "—"}
                  </td>
                  <td className="px-5 py-3 text-slate-600 dark:text-slate-300">
                    {c.companies?.name ?? "—"}
                  </td>
                  <td className="px-5 py-3 text-slate-600 dark:text-slate-300">{c.email ?? "—"}</td>
                  <td className="px-5 py-3 text-slate-600 dark:text-slate-300">{c.phone ?? "—"}</td>
                  <td className="px-5 py-3 text-right whitespace-nowrap">
                    <button
                      onClick={() => openEdit(c)}
                      className="text-brand-600 dark:text-brand-300 hover:underline mr-3"
                    >
                      Modifica
                    </button>
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
      </Card>

      <Modal
        open={open}
        onClose={() => setOpen(false)}
        title={editing ? "Modifica contatto" : "Nuovo contatto"}
      >
        <form onSubmit={onSubmit} className="space-y-4">
          {editing && <input type="hidden" name="id" value={editing.id} />}
          <div className="grid grid-cols-2 gap-4">
            <Field label="Nome *">
              <Input
                name="first_name"
                required
                defaultValue={editing?.first_name ?? ""}
              />
            </Field>
            <Field label="Cognome">
              <Input name="last_name" defaultValue={editing?.last_name ?? ""} />
            </Field>
          </div>
          <Field label="Ruolo / Posizione">
            <Input name="job_title" defaultValue={editing?.job_title ?? ""} />
          </Field>
          <Field label="Azienda">
            <Select name="company_id" defaultValue={editing?.company_id ?? ""}>
              <option value="">— Nessuna —</option>
              {companies.map((co) => (
                <option key={co.id} value={co.id}>
                  {co.name}
                </option>
              ))}
            </Select>
          </Field>
          <div className="grid grid-cols-2 gap-4">
            <Field label="Email">
              <Input type="email" name="email" defaultValue={editing?.email ?? ""} />
            </Field>
            <Field label="Telefono">
              <Input name="phone" defaultValue={editing?.phone ?? ""} />
            </Field>
          </div>
          <Field label="Note">
            <Textarea name="notes" defaultValue={editing?.notes ?? ""} />
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
