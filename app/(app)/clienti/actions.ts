"use server";

import { revalidatePath } from "next/cache";
import { createClient } from "@/lib/supabase/server";
import type { TipoCliente } from "@/lib/types";

function clean(v: FormDataEntryValue | null): string | null {
  const s = (v ?? "").toString().trim();
  return s === "" ? null : s;
}

export async function saveClient(formData: FormData) {
  const supabase = createClient();
  const id = clean(formData.get("id"));
  const tipo = (clean(formData.get("tipo")) ?? "societa") as TipoCliente;

  // Nome "principale": per i privati è nome+cognome, altrimenti la denominazione
  const nome = clean(formData.get("nome"));
  const cognome = clean(formData.get("cognome"));
  const denominazione = clean(formData.get("name"));
  const name =
    tipo === "privato"
      ? [nome, cognome].filter(Boolean).join(" ") || "Privato senza nome"
      : denominazione || "Senza nome";

  const lastContact = clean(formData.get("last_contact_at"));

  const payload: Record<string, unknown> = {
    tipo,
    name,
    nome: tipo === "privato" ? nome : null,
    cognome: tipo === "privato" ? cognome : null,
    piva: clean(formData.get("piva")),
    codice_fiscale: clean(formData.get("codice_fiscale")),
    codice_univoco: tipo === "pa" ? clean(formData.get("codice_univoco")) : null,
    codice_sdi: tipo === "societa" ? clean(formData.get("codice_sdi")) : null,
    pec: clean(formData.get("pec")),
    industry: tipo === "societa" ? clean(formData.get("industry")) : null,
    phone: clean(formData.get("phone")),
    address: clean(formData.get("address")),
    cap: clean(formData.get("cap")),
    citta: clean(formData.get("citta")),
    provincia: clean(formData.get("provincia")),
    regione: clean(formData.get("regione")),
    abitanti: (() => {
      const raw = clean(formData.get("abitanti"));
      if (tipo !== "pa" || !raw) return null;
      const n = parseInt(raw.replace(/[^0-9]/g, ""), 10);
      return Number.isFinite(n) ? n : null;
    })(),
    referente_nome: tipo !== "privato" ? clean(formData.get("referente_nome")) : null,
    referente_ruolo: tipo !== "privato" ? clean(formData.get("referente_ruolo")) : null,
    referente_contatto:
      tipo !== "privato" ? clean(formData.get("referente_contatto")) : null,
    tlmk_agente_id: clean(formData.get("tlmk_agente_id")),
    venditore_agente_id: clean(formData.get("venditore_agente_id")),
    flag_manuale: formData.get("flag_azzurro") === "on" ? "azzurro" : null,
    last_contact_at: lastContact ? new Date(lastContact).toISOString() : null,
    notes: clean(formData.get("notes")),
  };

  if (id) {
    const { error } = await supabase.from("companies").update(payload).eq("id", id);
    if (error) return { error: error.message };
  } else {
    const { error } = await supabase.from("companies").insert(payload);
    if (error) return { error: error.message };
  }

  revalidatePath("/clienti");
  revalidatePath("/dashboard");
  return { ok: true };
}

export async function deleteClient(id: string) {
  const supabase = createClient();
  const { error } = await supabase.from("companies").delete().eq("id", id);
  if (error) {
    // Il più delle volte qui l'errore è "permesso negato": solo i
    // responsabili possono cancellare.
    return { error: "Non è stato possibile eliminare (serve un responsabile)." };
  }
  revalidatePath("/clienti");
  return { ok: true };
}

// Toggle rapido del flag "azzurro / qualcosa in ballo" dalla lista
export async function toggleFlag(id: string, attivo: boolean) {
  const supabase = createClient();
  const { error } = await supabase
    .from("companies")
    .update({ flag_manuale: attivo ? "azzurro" : null })
    .eq("id", id);
  if (error) return { error: error.message };
  revalidatePath("/clienti");
  return { ok: true };
}
