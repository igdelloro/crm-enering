"use server";

import { revalidatePath } from "next/cache";
import { createClient } from "@/lib/supabase/server";

function clean(v: FormDataEntryValue | null): string | null {
  const s = (v ?? "").toString().trim();
  return s === "" ? null : s;
}

export async function saveAnnuncio(formData: FormData) {
  const supabase = createClient();
  const id = clean(formData.get("id"));
  const titolo = (formData.get("titolo") ?? "").toString().trim();
  const corpo = clean(formData.get("corpo"));

  if (!titolo) return { error: "Il titolo è obbligatorio." };

  if (id) {
    const { error } = await supabase
      .from("annunci")
      .update({ titolo, corpo })
      .eq("id", id);
    if (error) return { error: error.message };
  } else {
    const {
      data: { user },
    } = await supabase.auth.getUser();
    const { error } = await supabase
      .from("annunci")
      .insert({ titolo, corpo, created_by: user?.id ?? null });
    if (error) return { error: error.message };
  }

  revalidatePath("/bacheca");
  revalidatePath("/dashboard");
  return { ok: true };
}

export async function deleteAnnuncio(id: string) {
  const supabase = createClient();
  const { error } = await supabase.from("annunci").delete().eq("id", id);
  if (error) return { error: error.message };
  revalidatePath("/bacheca");
  revalidatePath("/dashboard");
  return { ok: true };
}
