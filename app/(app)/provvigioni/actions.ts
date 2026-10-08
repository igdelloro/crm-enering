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

export async function saveProvvigione(formData: FormData) {
  const supabase = createClient();
  const {
    data: { user },
  } = await supabase.auth.getUser();

  const id = clean(formData.get("id"));
  const agenteId = clean(formData.get("agente_id"));
  if (!agenteId) return { error: "Seleziona la persona." };

  const payload = {
    agente_id: agenteId,
    periodo: clean(formData.get("periodo")),
    imponibile: num(formData.get("imponibile")),
    percentuale: num(formData.get("percentuale")),
    importo: num(formData.get("importo")),
    stato: clean(formData.get("stato")) ?? "da_liquidare",
    note: clean(formData.get("note")),
  };

  if (id) {
    const { error } = await supabase.from("provvigioni").update(payload).eq("id", id);
    if (error) return { error: error.message };
  } else {
    const { error } = await supabase
      .from("provvigioni")
      .insert({ ...payload, created_by: user?.id ?? null });
    if (error) return { error: error.message };
  }
  revalidatePath("/provvigioni");
  revalidatePath("/me");
  return { ok: true };
}

export async function deleteProvvigione(id: string) {
  const supabase = createClient();
  const { error } = await supabase.from("provvigioni").delete().eq("id", id);
  if (error) return { error: error.message };
  revalidatePath("/provvigioni");
  return { ok: true };
}
