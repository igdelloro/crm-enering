"use client";

import { useMemo, useState } from "react";
import Link from "next/link";
import { useRouter } from "next/navigation";
import type { Company, Agente, Evento, TipoEvento, Preventivo } from "@/lib/types";
import {
  TIPI_EVENTO,
  eventoMeta,
  nomeAgente,
  tipoLabel,
  statoMeta,
  ruoloPrincipale,
  ruoloColorHex,
  calcolaSemaforo,
  SEMAFORO_HEX,
  SEMAFORO_LABEL,
} from "@/lib/types";
import { formatCurrency } from "@/lib/format";
import {
  Card,
  Button,
  Modal,
  Field,
  Input,
  Textarea,
  Select,
  Badge,
} from "@/components/ui";
import ClientForm from "../ClientForm";
import { registerEvento, deleteEvento } from "./actions";

type EventoRow = Evento & {
  profiles: { full_name: string | null; email: string | null } | null;
};

function nowLocal(): string {
  const d = new Date();
  const off = d.getTimezoneOffset();
  return new Date(d.getTime() - off * 60000).toISOString().slice(0, 16);
}

function fmtDateTime(iso: string): string {
  return new Intl.DateTimeFormat("it-IT", {
    day: "2-digit",
    month: "long",
    year: "numeric",
    hour: "2-digit",
    minute: "2-digit",
  }).format(new Date(iso));
}

export default function ClientDetailClient({
  client,
  eventi,
  preventivi,
  agenti,
  canManage,
}: {
  client: Company;
  eventi: EventoRow[];
  preventivi: Preventivo[];
  agenti: Agente[];
  canManage?: boolean;
}) {
  const router = useRouter();
  const [editOpen, setEditOpen] = useState(false);
  const [evOpen, setEvOpen] = useState(false);
  const [evTipo, setEvTipo] = useState<TipoEvento>("contatto");
  const [evError, setEvError] = useState<string | null>(null);
  const [evSaving, setEvSaving] = useState(false);

  const agenteById = useMemo(
    () => Object.fromEntries(agenti.map((a) => [a.id, a])),
    [agenti]
  );
  // Collego chi inserisce (email account) alla persona in Ruoli
  const agenteByEmail = useMemo(
    () =>
      Object.fromEntries(
        agenti
          .filter((a) => a.email)
          .map((a) => [a.email!.toLowerCase(), a])
      ),
    [agenti]
  );

  // "Inserito da": mostra il nome della persona, colorato per ruolo principale
  function InseritoDa({
    prof,
  }: {
    prof: { full_name: string | null; email: string | null } | null;
  }) {
    if (!prof) return null;
    const ag = prof.email ? agenteByEmail[prof.email.toLowerCase()] : null;
    if (ag) {
      const ruoloPrinc = ruoloPrincipale(ag as any);
      return (
        <span>
          Inserito da{" "}
          <span
            className="font-semibold"
            style={{ color: ruoloColorHex(ruoloPrinc) }}
          >
            {nomeAgente(ag)}
          </span>
        </span>
      );
    }
    return <span>Inserito da {prof.full_name ?? "—"}</span>;
  }

  const sem = calcolaSemaforo(client.last_contact_at, client.flag_manuale);

  // Filtro per tipo nella cronologia
  const [filtro, setFiltro] = useState<string>("");

  // Cronologia unificata: eventi + preventivi, ordinati per data
  const timeline = useMemo(() => {
    const items: Array<
      | { kind: "ev"; date: string; ev: EventoRow }
      | { kind: "pr"; date: string; pr: Preventivo }
    > = [
      ...eventi.map((ev) => ({ kind: "ev" as const, date: ev.data, ev })),
      ...preventivi.map((pr) => ({ kind: "pr" as const, date: pr.created_at, pr })),
    ];
    items.sort(
      (a, b) => new Date(b.date).getTime() - new Date(a.date).getTime()
    );
    return items;
  }, [eventi, preventivi]);

  // Applica il filtro: "pr" = preventivi/gare, altrimenti tipo evento
  const timelineFiltrata = useMemo(() => {
    if (!filtro) return timeline;
    if (filtro === "preventivo_gara")
      return timeline.filter((it) => it.kind === "pr");
    return timeline.filter((it) => it.kind === "ev" && it.ev.tipo === filtro);
  }, [timeline, filtro]);

  async function onRegister(e: React.FormEvent<HTMLFormElement>) {
    e.preventDefault();
    setEvSaving(true);
    setEvError(null);
    const res = await registerEvento(new FormData(e.currentTarget));
    setEvSaving(false);
    if (res?.error) {
      setEvError(res.error);
      return;
    }
    setEvOpen(false);
    router.refresh();
  }

  async function onDeleteEvento(id: string) {
    if (!confirm("Eliminare questo evento?")) return;
    const res = await deleteEvento(id, client.id);
    if (res?.error) alert(res.error);
    router.refresh();
  }

  const conImporto = eventoMeta(evTipo).conImporto;

  const Info = ({ label, value }: { label: string; value?: string | null }) =>
    value ? (
      <div>
        <dt className="text-xs text-slate-400 dark:text-slate-500">{label}</dt>
        <dd className="text-sm text-slate-800 dark:text-slate-100">{value}</dd>
      </div>
    ) : null;

  return (
    <>
      <Link
        href="/clienti"
        className="text-sm text-brand-600 dark:text-brand-300 hover:underline"
      >
        ← Torna ai clienti
      </Link>

      {/* Intestazione cliente */}
      <Card>
        <div className="p-5">
          <div className="flex items-start justify-between gap-4">
            <div className="flex items-start gap-3">
              <span
                title={SEMAFORO_LABEL[sem]}
                className="mt-1 inline-block w-4 h-4 rounded-full ring-1 ring-black/5 shrink-0"
                style={{ backgroundColor: SEMAFORO_HEX[sem] }}
              />
              <div>
                <h1 className="text-xl font-bold text-slate-900 dark:text-slate-100">
                  {client.name}
                </h1>
                <div className="mt-1 flex items-center gap-2">
                  <Badge
                    color={
                      client.tipo === "pa"
                        ? "violet"
                        : client.tipo === "societa"
                        ? "blue"
                        : "slate"
                    }
                  >
                    {tipoLabel(client.tipo)}
                  </Badge>
                  {client.citta && (
                    <span className="text-sm text-slate-500 dark:text-slate-400">
                      {client.citta}
                      {client.provincia ? ` (${client.provincia})` : ""}
                    </span>
                  )}
                </div>
              </div>
            </div>
            <div className="flex gap-2 shrink-0">
              <Button variant="ghost" onClick={() => setEditOpen(true)}>
                Modifica scheda
              </Button>
              <Button onClick={() => setEvOpen(true)}>+ Registra evento</Button>
            </div>
          </div>

          <dl className="mt-5 grid grid-cols-2 md:grid-cols-4 gap-4">
            <Info label="Telefono" value={client.phone} />
            <Info label="Email" value={client.email} />
            <Info label="PEC" value={client.pec} />
            <Info label="Sito web" value={client.website} />
            <Info
              label={client.tipo === "pa" ? "Cod. Univoco" : "P.IVA"}
              value={client.tipo === "pa" ? client.codice_univoco : client.piva}
            />
            <Info label="Cod. Fiscale" value={client.codice_fiscale} />
            <Info
              label="Indirizzo"
              value={
                [client.address, client.cap, client.citta]
                  .filter(Boolean)
                  .join(", ") || null
              }
            />
            <Info label="Regione" value={client.regione} />
            <Info
              label="Abitanti"
              value={
                client.abitanti != null
                  ? client.abitanti.toLocaleString("it-IT")
                  : null
              }
            />
            <Info
              label="Referente"
              value={
                client.referente_nome
                  ? `${client.referente_nome}${
                      client.referente_ruolo ? " · " + client.referente_ruolo : ""
                    }`
                  : null
              }
            />
            <Info label="Contatto referente" value={client.referente_contatto} />
            <Info label="Email referente" value={client.referente_email} />
            <Info
              label="Telemarketing"
              value={
                client.tlmk_agente_id
                  ? nomeAgente(agenteById[client.tlmk_agente_id])
                  : null
              }
            />
            <Info
              label="Venditore"
              value={
                client.venditore_agente_id
                  ? nomeAgente(agenteById[client.venditore_agente_id])
                  : null
              }
            />
          </dl>
          {client.notes && (
            <p className="mt-4 text-sm text-slate-600 dark:text-slate-300 bg-slate-50 dark:bg-slate-800 rounded-lg p-3">
              {client.notes}
            </p>
          )}
        </div>
      </Card>

      {/* Cronologia eventi */}
      <div className="mt-6">
        <div className="flex flex-wrap items-center justify-between gap-3 mb-3">
          <h2 className="text-lg font-semibold text-slate-800 dark:text-slate-100">Cronologia</h2>
          <Select
            value={filtro}
            onChange={(e) => setFiltro(e.target.value)}
            className="max-w-[200px]"
          >
            <option value="">Tutti i tipi</option>
            {TIPI_EVENTO.map((t) => (
              <option key={t.value} value={t.value}>
                {t.label}
              </option>
            ))}
            <option value="preventivo_gara">Preventivi / Gare</option>
          </Select>
        </div>
        {timelineFiltrata.length === 0 ? (
          <Card>
            <div className="p-10 text-center text-sm text-slate-400 dark:text-slate-500">
              {filtro
                ? "Nessun elemento di questo tipo."
                : "Nessun evento registrato. Usa «+ Registra evento» per iniziare lo storico di questo cliente."}
            </div>
          </Card>
        ) : (
          <div className="space-y-3">
            {timelineFiltrata.map((it) => {
              if (it.kind === "pr") {
                const pr = it.pr;
                const sm = statoMeta(pr.tipo, pr.sottotipo, pr.stato);
                return (
                  <Card key={"pr-" + pr.id}>
                    <div className="p-4 border-l-4 border-violet-300">
                      <div className="flex items-center gap-2 flex-wrap">
                        <Badge color={pr.tipo === "gara" ? "violet" : "blue"}>
                          {pr.tipo === "gara"
                            ? `Gara${pr.sottotipo ? " · " + pr.sottotipo : ""}`
                            : "Preventivo"}
                        </Badge>
                        <span className="text-sm font-semibold text-slate-800 dark:text-slate-100">
                          {pr.numero ?? "—"}
                        </span>
                        <span className="text-sm text-slate-500 dark:text-slate-400">
                          {fmtDateTime(pr.created_at)}
                        </span>
                        <Badge color={sm.color as any}>{sm.label}</Badge>
                      </div>
                      {pr.oggetto && (
                        <p className="mt-2 text-sm text-slate-700 dark:text-slate-200">{pr.oggetto}</p>
                      )}
                      <div className="mt-2 text-xs text-slate-500 dark:text-slate-400 flex gap-4 flex-wrap">
                        {pr.importo != null && (
                          <span className="font-semibold text-slate-700 dark:text-slate-200">
                            {formatCurrency(Number(pr.importo))}
                          </span>
                        )}
                        {pr.ribasso != null && <span>Ribasso {pr.ribasso}%</span>}
                        {pr.cig && <span>CIG {pr.cig}</span>}
                        <Link
                          href="/preventivi"
                          className="text-brand-600 dark:text-brand-300 hover:underline"
                        >
                          apri nei preventivi
                        </Link>
                      </div>
                    </div>
                  </Card>
                );
              }
              const ev = it.ev;
              const meta = eventoMeta(ev.tipo);
              return (
                <Card key={"ev-" + ev.id}>
                  <div className="p-4">
                    <div className="flex items-start justify-between gap-3">
                      <div className="flex items-center gap-2">
                        <Badge color={meta.color}>{meta.label}</Badge>
                        <span className="text-sm text-slate-500 dark:text-slate-400">
                          {fmtDateTime(ev.data)}
                        </span>
                        {ev.causale && (
                          <span className="text-xs text-slate-400 dark:text-slate-500">
                            · {ev.causale}
                          </span>
                        )}
                      </div>
                      {canManage && (
                        <button
                          onClick={() => onDeleteEvento(ev.id)}
                          className="text-xs text-red-400 hover:text-red-600"
                        >
                          elimina
                        </button>
                      )}
                    </div>
                    {ev.dettagli && (
                      <p className="mt-2 text-sm text-slate-700 dark:text-slate-200 whitespace-pre-wrap">
                        {ev.dettagli}
                      </p>
                    )}
                    <div className="mt-2 flex items-center gap-4 text-xs text-slate-400 dark:text-slate-500">
                      {ev.importo != null && (
                        <span className="font-semibold text-slate-600 dark:text-slate-300">
                          {formatCurrency(Number(ev.importo))}
                        </span>
                      )}
                      {ev.profiles && <InseritoDa prof={ev.profiles} />}
                    </div>
                  </div>
                </Card>
              );
            })}
          </div>
        )}
      </div>

      {/* Modale modifica scheda */}
      <Modal
        open={editOpen}
        onClose={() => setEditOpen(false)}
        title="Modifica scheda cliente"
      >
        <ClientForm
          editing={client}
          agenti={agenti}
          onDone={() => {
            setEditOpen(false);
            router.refresh();
          }}
        />
      </Modal>

      {/* Modale registra evento */}
      <Modal
        open={evOpen}
        onClose={() => setEvOpen(false)}
        title="Registra evento"
      >
        <form onSubmit={onRegister} className="space-y-4">
          <input type="hidden" name="company_id" value={client.id} />
          <div className="grid grid-cols-2 gap-4">
            <Field label="Tipo evento">
              <Select
                name="tipo"
                value={evTipo}
                onChange={(e) => setEvTipo(e.target.value as TipoEvento)}
              >
                {TIPI_EVENTO.map((t) => (
                  <option key={t.value} value={t.value}>
                    {t.label}
                  </option>
                ))}
              </Select>
            </Field>
            <Field label="Data e ora">
              <Input type="datetime-local" name="data" defaultValue={nowLocal()} />
            </Field>
          </div>
          <Field label="Causale (facoltativa)">
            <Input name="causale" placeholder="es. Nota Generica, Telemarketing" />
          </Field>
          {conImporto && (
            <Field label="Importo (€)">
              <Input type="number" name="importo" min="0" step="0.01" />
            </Field>
          )}
          <Field label="Dettagli">
            <Textarea name="dettagli" rows={4} />
          </Field>

          {evError && <p className="text-sm text-red-600">{evError}</p>}

          <div className="flex justify-end gap-2 pt-2">
            <Button type="button" variant="ghost" onClick={() => setEvOpen(false)}>
              Annulla
            </Button>
            <Button type="submit" disabled={evSaving}>
              {evSaving ? "Salvataggio…" : "Registra"}
            </Button>
          </div>
        </form>
      </Modal>
    </>
  );
}
