"use server";

import { revalidatePath } from "next/cache";
import { createClient } from "@/lib/supabase/server";

function clean(v: FormDataEntryValue | null): string | null {
  const s = (v ?? "").toString().trim();
  return s === "" ? null : s;
}
function num(v: FormDataEntryValue | null): number | null {
  const s = (v ?? "").toString().trim();
  return s === "" ? null : Number(s);
}

export async function savePreventivo(formData: FormData) {
  const supabase = createClient();
  const {
    data: { user },
  } = await supabase.auth.getUser();

  const id = clean(formData.get("id"));
  const companyId = clean(formData.get("company_id"));
  const venditore = clean(formData.get("venditore_agente_id"));
  const tipo = (clean(formData.get("tipo")) ?? "preventivo") as
    | "preventivo"
    | "gara";

  if (!companyId) return { error: "Seleziona il cliente." };
  if (!venditore)
    return { error: "Seleziona il venditore (serve per il numero)." };

  const payload = {
    company_id: companyId,
    venditore_agente_id: venditore,
    tlmk_agente_id: clean(formData.get("tlmk_agente_id")),
    tipo,
    sottotipo: tipo === "gara" ? clean(formData.get("sottotipo")) : null,
    categoria: clean(formData.get("categoria")),
    oggetto: clean(formData.get("oggetto")),
    importo: num(formData.get("importo")),
    base_gara: tipo === "gara" ? num(formData.get("base_gara")) : null,
    ribasso: num(formData.get("ribasso")),
    cig: tipo === "gara" ? clean(formData.get("cig")) : null,
    cup: tipo === "gara" ? clean(formData.get("cup")) : null,
    riferimento: clean(formData.get("riferimento")),
    stato: clean(formData.get("stato")) ?? "bozza",
    data_scadenza: clean(formData.get("data_scadenza")),
    note: clean(formData.get("note")),
  };

  if (id) {
    const { error } = await supabase
      .from("preventivi")
      .update(payload)
      .eq("id", id);
    if (error) return { error: error.message };
  } else {
    const { error } = await supabase
      .from("preventivi")
      .insert({ ...payload, created_by: user?.id ?? null });
    if (error) return { error: error.message };
  }

  revalidatePath("/preventivi");
  if (companyId) revalidatePath(`/clienti/${companyId}`);
  return { ok: true };
}

export async function deletePreventivo(id: string) {
  const supabase = createClient();
  const { error } = await supabase.from("preventivi").delete().eq("id", id);
  if (error)
    return { error: "Non è stato possibile eliminare (serve un responsabile)." };
  revalidatePath("/preventivi");
  return { ok: true };
}
