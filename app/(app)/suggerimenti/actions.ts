"use server";

import { revalidatePath } from "next/cache";
import { createClient } from "@/lib/supabase/server";

function clean(v: FormDataEntryValue | null): string | null {
  const s = (v ?? "").toString().trim();
  return s === "" ? null : s;
}

export async function saveSuggerimento(formData: FormData) {
  const supabase = createClient();
  const id = clean(formData.get("id"));
  const titolo = (formData.get("titolo") ?? "").toString().trim();
  const sezione = clean(formData.get("sezione"));
  const descrizione = clean(formData.get("descrizione"));
  const priorita = (formData.get("priorita") ?? "bassa").toString();

  if (!titolo) return { error: "Il titolo è obbligatorio." };

  if (id) {
    const { error } = await supabase
      .from("suggerimenti")
      .update({ titolo, sezione, descrizione, priorita })
      .eq("id", id);
    if (error) return { error: error.message };
  } else {
    const {
      data: { user },
    } = await supabase.auth.getUser();
    const { error } = await supabase.from("suggerimenti").insert({
      titolo,
      sezione,
      descrizione,
      priorita,
      created_by: user?.id ?? null,
    });
    if (error) return { error: error.message };
  }

  revalidatePath("/suggerimenti");
  revalidatePath("/dashboard");
  return { ok: true };
}

export async function setRisolto(id: string, risolto: boolean) {
  const supabase = createClient();
  const { error } = await supabase
    .from("suggerimenti")
    .update({ risolto })
    .eq("id", id);
  if (error) return { error: error.message };
  revalidatePath("/suggerimenti");
  revalidatePath("/dashboard");
  return { ok: true };
}

export async function deleteSuggerimento(id: string) {
  const supabase = createClient();
  const { error } = await supabase.from("suggerimenti").delete().eq("id", id);
  if (error) return { error: error.message };
  revalidatePath("/suggerimenti");
  revalidatePath("/dashboard");
  return { ok: true };
}
