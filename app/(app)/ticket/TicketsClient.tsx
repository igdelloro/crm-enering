"use client";

import { useState } from "react";
import { useRouter } from "next/navigation";
import type {
  Ticket,
  Company,
  Contact,
  TicketStatus,
  TicketPriority,
} from "@/lib/types";
import { TICKET_STATUSES, TICKET_PRIORITIES } from "@/lib/types";
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
import { saveTicket, deleteTicket } from "./actions";

type TicketRow = Ticket & {
  companies: { name: string } | null;
  contacts: { first_name: string; last_name: string | null } | null;
};

const statusColor: Record<
  TicketStatus,
  "slate" | "blue" | "amber" | "green"
> = {
  aperto: "blue",
  in_lavorazione: "amber",
  in_attesa: "slate",
  chiuso: "green",
};

const priorityColor: Record<
  TicketPriority,
  "slate" | "blue" | "amber" | "red"
> = {
  bassa: "slate",
  media: "blue",
  alta: "amber",
  urgente: "red",
};

function statusLabel(s: TicketStatus) {
  return TICKET_STATUSES.find((x) => x.value === s)?.label ?? s;
}
function priorityLabel(p: TicketPriority) {
  return TICKET_PRIORITIES.find((x) => x.value === p)?.label ?? p;
}

export default function TicketsClient({
  tickets,
  companies,
  contacts,
}: {
  tickets: TicketRow[];
  companies: Pick<Company, "id" | "name">[];
  contacts: Pick<Contact, "id" | "first_name" | "last_name">[];
}) {
  const router = useRouter();
  const [open, setOpen] = useState(false);
  const [editing, setEditing] = useState<Ticket | null>(null);
  const [error, setError] = useState<string | null>(null);
  const [saving, setSaving] = useState(false);
  const [filter, setFilter] = useState<"tutti" | "aperti">("aperti");

  function openNew() {
    setEditing(null);
    setError(null);
    setOpen(true);
  }
  function openEdit(t: Ticket) {
    setEditing(t);
    setError(null);
    setOpen(true);
  }

  async function onSubmit(e: React.FormEvent<HTMLFormElement>) {
    e.preventDefault();
    setSaving(true);
    setError(null);
    const res = await saveTicket(new FormData(e.currentTarget));
    setSaving(false);
    if (res?.error) {
      setError(res.error);
      return;
    }
    setOpen(false);
    router.refresh();
  }

  async function onDelete(id: string) {
    if (!confirm("Eliminare questo ticket?")) return;
    await deleteTicket(id);
    router.refresh();
  }

  const shown =
    filter === "aperti"
      ? tickets.filter((t) => t.status !== "chiuso")
      : tickets;

  return (
    <>
      <PageHeader
        title="Ticket"
        subtitle={`${tickets.filter((t) => t.status !== "chiuso").length} aperti su ${tickets.length} totali`}
        action={<Button onClick={openNew}>+ Nuovo ticket</Button>}
      />

      <div className="mb-4 flex gap-2">
        <button
          onClick={() => setFilter("aperti")}
          className={`rounded-lg px-3 py-1.5 text-sm font-medium ${
            filter === "aperti"
              ? "bg-brand-600 text-white"
              : "bg-slate-100 dark:bg-slate-800 text-slate-600 dark:text-slate-300"
          }`}
        >
          Solo aperti
        </button>
        <button
          onClick={() => setFilter("tutti")}
          className={`rounded-lg px-3 py-1.5 text-sm font-medium ${
            filter === "tutti"
              ? "bg-brand-600 text-white"
              : "bg-slate-100 dark:bg-slate-800 text-slate-600 dark:text-slate-300"
          }`}
        >
          Tutti
        </button>
      </div>

      <Card>
        {shown.length === 0 ? (
          <EmptyState message="Nessun ticket." />
        ) : (
          <div className="overflow-x-auto"><table className="w-full text-sm min-w-[640px]">
            <thead>
              <tr className="text-left text-slate-500 dark:text-slate-400 border-b border-slate-100 dark:border-slate-800">
                <th className="px-5 py-3 font-medium">Oggetto</th>
                <th className="px-5 py-3 font-medium">Azienda</th>
                <th className="px-5 py-3 font-medium">Priorità</th>
                <th className="px-5 py-3 font-medium">Stato</th>
                <th className="px-5 py-3 font-medium">Aperto il</th>
                <th className="px-5 py-3"></th>
              </tr>
            </thead>
            <tbody>
              {shown.map((t) => (
                <tr
                  key={t.id}
                  className="border-b border-slate-50 dark:border-slate-800 hover:bg-slate-50 dark:hover:bg-slate-800"
                >
                  <td className="px-5 py-3 font-medium text-slate-800 dark:text-slate-100">
                    {t.subject}
                  </td>
                  <td className="px-5 py-3 text-slate-600 dark:text-slate-300">
                    {t.companies?.name ?? "—"}
                  </td>
                  <td className="px-5 py-3">
                    <Badge color={priorityColor[t.priority]}>
                      {priorityLabel(t.priority)}
                    </Badge>
                  </td>
                  <td className="px-5 py-3">
                    <Badge color={statusColor[t.status]}>
                      {statusLabel(t.status)}
                    </Badge>
                  </td>
                  <td className="px-5 py-3 text-slate-500 dark:text-slate-400">
                    {formatDate(t.created_at)}
                  </td>
                  <td className="px-5 py-3 text-right whitespace-nowrap">
                    <button
                      onClick={() => openEdit(t)}
                      className="text-brand-600 dark:text-brand-300 hover:underline mr-3"
                    >
                      Apri
                    </button>
                    <button
                      onClick={() => onDelete(t.id)}
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
        title={editing ? "Dettaglio ticket" : "Nuovo ticket"}
      >
        <form onSubmit={onSubmit} className="space-y-4">
          {editing && <input type="hidden" name="id" value={editing.id} />}
          <Field label="Oggetto *">
            <Input name="subject" required defaultValue={editing?.subject ?? ""} />
          </Field>
          <Field label="Descrizione">
            <Textarea
              name="description"
              rows={4}
              defaultValue={editing?.description ?? ""}
            />
          </Field>
          <div className="grid grid-cols-2 gap-4">
            <Field label="Stato">
              <Select name="status" defaultValue={editing?.status ?? "aperto"}>
                {TICKET_STATUSES.map((s) => (
                  <option key={s.value} value={s.value}>
                    {s.label}
                  </option>
                ))}
              </Select>
            </Field>
            <Field label="Priorità">
              <Select
                name="priority"
                defaultValue={editing?.priority ?? "media"}
              >
                {TICKET_PRIORITIES.map((p) => (
                  <option key={p.value} value={p.value}>
                    {p.label}
                  </option>
                ))}
              </Select>
            </Field>
          </div>
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
          <Field label="Contatto">
            <Select name="contact_id" defaultValue={editing?.contact_id ?? ""}>
              <option value="">— Nessuno —</option>
              {contacts.map((c) => (
                <option key={c.id} value={c.id}>
                  {c.first_name} {c.last_name ?? ""}
                </option>
              ))}
            </Select>
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
