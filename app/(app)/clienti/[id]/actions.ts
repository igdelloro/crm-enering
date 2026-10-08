"use server";

import { revalidatePath } from "next/cache";
import { createClient } from "@/lib/supabase/server";
import type { TipoEvento } from "@/lib/types";

function clean(v: FormDataEntryValue | null): string | null {
  const s = (v ?? "").toString().trim();
  return s === "" ? null : s;
}

export async function registerEvento(formData: FormData) {
  const supabase = createClient();
  const {
    data: { user },
  } = await supabase.auth.getUser();

  const companyId = clean(formData.get("company_id"));
  if (!companyId) return { error: "Cliente mancante." };

  const tipo = (clean(formData.get("tipo")) ?? "contatto") as TipoEvento;
  const dataRaw = clean(formData.get("data"));
  const importoRaw = clean(formData.get("importo"));

  const payload = {
    company_id: companyId,
    tipo,
    data: dataRaw ? new Date(dataRaw).toISOString() : new Date().toISOString(),
    causale: clean(formData.get("causale")),
    dettagli: clean(formData.get("dettagli")),
    importo: importoRaw ? Number(importoRaw) : null,
    created_by: user?.id ?? null,
  };

  const { error } = await supabase.from("eventi").insert(payload);
  if (error) return { error: error.message };

  revalidatePath(`/clienti/${companyId}`);
  revalidatePath("/clienti");
  return { ok: true };
}

export async function deleteEvento(id: string, companyId: string) {
  const supabase = createClient();
  const { error } = await supabase.from("eventi").delete().eq("id", id);
  if (error)
    return { error: "Non è stato possibile eliminare (serve un responsabile)." };
  revalidatePath(`/clienti/${companyId}`);
  return { ok: true };
}
