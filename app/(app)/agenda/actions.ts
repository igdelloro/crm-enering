"use server";

import { revalidatePath } from "next/cache";
import { createClient } from "@/lib/supabase/server";

function clean(v: FormDataEntryValue | null): string | null {
  const s = (v ?? "").toString().trim();
  return s === "" ? null : s;
}

export async function saveAppuntamento(formData: FormData) {
  const supabase = createClient();
  const {
    data: { user },
  } = await supabase.auth.getUser();

  const id = clean(formData.get("id"));
  const agenteId = clean(formData.get("agente_id"));
  const titolo = (formData.get("titolo") ?? "").toString().trim();
  const inizioRaw = clean(formData.get("inizio"));
  const fineRaw = clean(formData.get("fine"));

  if (!agenteId) return { error: "Seleziona l'agente." };
  if (!titolo) return { error: "Il titolo è obbligatorio." };
  if (!inizioRaw) return { error: "Indica data e ora di inizio." };

  const payload = {
    agente_id: agenteId,
    company_id: clean(formData.get("company_id")),
    titolo,
    inizio: new Date(inizioRaw).toISOString(),
    fine: fineRaw ? new Date(fineRaw).toISOString() : null,
    luogo: clean(formData.get("luogo")),
    note: clean(formData.get("note")),
  };

  // Elenco partecipanti: agente principale + eventuali altre persone
  let partecipanti: string[] = [agenteId];
  try {
    const extra = JSON.parse((formData.get("partecipanti") ?? "[]").toString());
    if (Array.isArray(extra)) partecipanti = partecipanti.concat(extra);
  } catch {
    // ignora
  }
  partecipanti = Array.from(new Set(partecipanti.filter(Boolean)));

  let apptId = id;
  if (id) {
    const { error } = await supabase
      .from("appuntamenti")
      .update(payload)
      .eq("id", id);
    if (error) return { error: error.message };
  } else {
    const { data, error } = await supabase
      .from("appuntamenti")
      .insert({ ...payload, created_by: user?.id ?? null })
      .select("id")
      .single();
    if (error) return { error: error.message };
    apptId = (data as any)?.id;
  }

  // Sincronizza i partecipanti
  if (apptId) {
    await supabase
      .from("appuntamento_agenti")
      .delete()
      .eq("appuntamento_id", apptId);
    await supabase
      .from("appuntamento_agenti")
      .insert(
        partecipanti.map((ag) => ({
          appuntamento_id: apptId,
          agente_id: ag,
        }))
      );
  }

  revalidatePath("/agenda");
  return { ok: true };
}

export async function deleteAppuntamento(id: string) {
  const supabase = createClient();
  const { error } = await supabase.from("appuntamenti").delete().eq("id", id);
  if (error)
    return { error: "Non è stato possibile eliminare (serve un responsabile)." };
  revalidatePath("/agenda");
  return { ok: true };
}
