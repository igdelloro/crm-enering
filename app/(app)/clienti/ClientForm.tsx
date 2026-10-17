"use client";

import { useState } from "react";
import type { Company, Agente, TipoCliente } from "@/lib/types";
import { TIPI_CLIENTE, hasRuolo } from "@/lib/types";
import { REGIONI } from "@/lib/geo";
import { Button, Field, Input, Textarea, Select } from "@/components/ui";
import { saveClient } from "./actions";

// Form condizionale per creare/modificare un cliente, riusato sia nella
// lista sia nella scheda cliente.
export default function ClientForm({
  editing,
  agenti,
  onDone,
}: {
  editing: Company | null;
  agenti: Agente[];
  onDone: () => void;
}) {
  const [formTipo, setFormTipo] = useState<TipoCliente>(
    editing?.tipo ?? "societa"
  );
  const [error, setError] = useState<string | null>(null);
  const [saving, setSaving] = useState(false);

  const tlmkList = agenti.filter((a) => hasRuolo(a, "telemarketing"));
  const vendList = agenti.filter((a) => hasRuolo(a, "venditore"));

  async function onSubmit(e: React.FormEvent<HTMLFormElement>) {
    e.preventDefault();
    setSaving(true);
    setError(null);
    const res = await saveClient(new FormData(e.currentTarget));
    setSaving(false);
    if (res?.error) {
      setError(res.error);
      return;
    }
    onDone();
  }

  return (
    <form onSubmit={onSubmit} className="space-y-4">
      {editing && <input type="hidden" name="id" value={editing.id} />}

      <Field label="Tipo cliente *">
        <Select
          name="tipo"
          value={formTipo}
          onChange={(e) => setFormTipo(e.target.value as TipoCliente)}
        >
          {TIPI_CLIENTE.map((t) => (
            <option key={t.value} value={t.value}>
              {t.label}
            </option>
          ))}
        </Select>
      </Field>

      {formTipo === "privato" ? (
        <div className="grid grid-cols-2 gap-4">
          <Field label="Nome *">
            <Input name="nome" required defaultValue={editing?.nome ?? ""} />
          </Field>
          <Field label="Cognome">
            <Input name="cognome" defaultValue={editing?.cognome ?? ""} />
          </Field>
        </div>
      ) : (
        <Field
          label={formTipo === "pa" ? "Denominazione ente *" : "Ragione sociale *"}
        >
          <Input name="name" required defaultValue={editing?.name ?? ""} />
        </Field>
      )}

      {formTipo === "pa" && (
        <div className="grid grid-cols-2 gap-4">
          <Field label="Codice Univoco Ufficio">
            <Input
              name="codice_univoco"
              placeholder="es. UF1234"
              defaultValue={editing?.codice_univoco ?? ""}
            />
          </Field>
          <Field label="C.F. / P.IVA ente">
            <Input name="piva" defaultValue={editing?.piva ?? ""} />
          </Field>
        </div>
      )}
      {formTipo === "societa" && (
        <div className="grid grid-cols-2 gap-4">
          <Field label="Partita IVA">
            <Input name="piva" defaultValue={editing?.piva ?? ""} />
          </Field>
          <Field label="Codice SDI">
            <Input name="codice_sdi" defaultValue={editing?.codice_sdi ?? ""} />
          </Field>
        </div>
      )}
      {formTipo === "privato" && (
        <Field label="Codice Fiscale">
          <Input
            name="codice_fiscale"
            defaultValue={editing?.codice_fiscale ?? ""}
          />
        </Field>
      )}

      {formTipo === "societa" && (
        <Field label="Settore">
          <Input name="industry" defaultValue={editing?.industry ?? ""} />
        </Field>
      )}

      <div className="grid grid-cols-2 gap-4">
        <Field label="Telefono">
          <Input name="phone" defaultValue={editing?.phone ?? ""} />
        </Field>
        <Field label="Email">
          <Input name="email" type="email" defaultValue={editing?.email ?? ""} />
        </Field>
        <Field label="PEC">
          <Input name="pec" defaultValue={editing?.pec ?? ""} />
        </Field>
        <Field label="Sito web">
          <Input name="website" defaultValue={editing?.website ?? ""} />
        </Field>
      </div>

      <Field label="Indirizzo">
        <Input name="address" defaultValue={editing?.address ?? ""} />
      </Field>
      <div className="grid grid-cols-4 gap-3">
        <Field label="CAP">
          <Input name="cap" defaultValue={editing?.cap ?? ""} />
        </Field>
        <div className="col-span-2">
          <Field label="Città">
            <Input name="citta" defaultValue={editing?.citta ?? ""} />
          </Field>
        </div>
        <Field label="Prov.">
          <Input name="provincia" maxLength={2} defaultValue={editing?.provincia ?? ""} />
        </Field>
      </div>
      <div className={formTipo === "pa" ? "grid grid-cols-2 gap-3" : ""}>
        <Field label="Regione">
          <Select name="regione" defaultValue={editing?.regione ?? ""}>
            <option value="">—</option>
            {REGIONI.map((r) => (
              <option key={r} value={r}>
                {r}
              </option>
            ))}
          </Select>
        </Field>
        {formTipo === "pa" && (
          <Field label="Abitanti">
            <Input
              name="abitanti"
              type="number"
              min={0}
              defaultValue={editing?.abitanti ?? ""}
            />
          </Field>
        )}
      </div>

      {formTipo !== "privato" && (
        <div className="rounded-lg bg-slate-50 dark:bg-slate-800 p-3 space-y-3">
          <p className="text-xs font-semibold text-slate-500 dark:text-slate-400 uppercase">
            Referente
          </p>
          <div className="grid grid-cols-2 gap-4">
            <Field label="Nome referente">
              <Input
                name="referente_nome"
                defaultValue={editing?.referente_nome ?? ""}
              />
            </Field>
            <Field label="Ruolo (es. RUP, geometra)">
              <Input
                name="referente_ruolo"
                defaultValue={editing?.referente_ruolo ?? ""}
              />
            </Field>
          </div>
          <Field label="Contatto referente (tel./email)">
            <Input
              name="referente_contatto"
              defaultValue={editing?.referente_contatto ?? ""}
            />
          </Field>
        </div>
      )}

      <div className="grid grid-cols-2 gap-4">
        <Field label="Telemarketing">
          <Select name="tlmk_agente_id" defaultValue={editing?.tlmk_agente_id ?? ""}>
            <option value="">—</option>
            {tlmkList.map((a) => (
              <option key={a.id} value={a.id}>
                {a.nome} {a.cognome ?? ""}
              </option>
            ))}
          </Select>
        </Field>
        <Field label="Venditore">
          <Select
            name="venditore_agente_id"
            defaultValue={editing?.venditore_agente_id ?? ""}
          >
            <option value="">—</option>
            {vendList.map((a) => (
              <option key={a.id} value={a.id}>
                {a.nome} {a.cognome ?? ""}
              </option>
            ))}
          </Select>
        </Field>
      </div>

      <div className="grid grid-cols-2 gap-4 items-end">
        <Field label="Data ultimo contatto">
          <Input
            type="date"
            name="last_contact_at"
            defaultValue={
              editing?.last_contact_at ? editing.last_contact_at.slice(0, 10) : ""
            }
          />
        </Field>
        <label className="flex items-center gap-2 text-sm text-slate-700 dark:text-slate-200 pb-2">
          <input
            type="checkbox"
            name="flag_azzurro"
            defaultChecked={editing?.flag_manuale === "azzurro"}
          />
          🔵 Attenzionato
        </label>
      </div>

      <Field label="Note">
        <Textarea name="notes" defaultValue={editing?.notes ?? ""} />
      </Field>

      {error && <p className="text-sm text-red-600">{error}</p>}

      <div className="flex justify-end gap-2 pt-2">
        <Button type="button" variant="ghost" onClick={onDone}>
          Annulla
        </Button>
        <Button type="submit" disabled={saving}>
          {saving ? "Salvataggio…" : "Salva"}
        </Button>
      </div>
    </form>
  );
}
