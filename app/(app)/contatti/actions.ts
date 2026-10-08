"use server";

import { revalidatePath } from "next/cache";
import { createClient } from "@/lib/supabase/server";

function clean(v: FormDataEntryValue | null): string | null {
  const s = (v ?? "").toString().trim();
  return s === "" ? null : s;
}

export async function saveContact(formData: FormData) {
  const supabase = createClient();
  const id = clean(formData.get("id"));

  const payload = {
    first_name: (formData.get("first_name") ?? "").toString().trim(),
    last_name: clean(formData.get("last_name")),
    email: clean(formData.get("email")),
    phone: clean(formData.get("phone")),
    job_title: clean(formData.get("job_title")),
    company_id: clean(formData.get("company_id")),
    notes: clean(formData.get("notes")),
  };

  if (!payload.first_name) return { error: "Il nome è obbligatorio." };

  if (id) {
    const { error } = await supabase
      .from("contacts")
      .update(payload)
      .eq("id", id);
    if (error) return { error: error.message };
  } else {
    const { error } = await supabase.from("contacts").insert(payload);
    if (error) return { error: error.message };
  }

  revalidatePath("/contatti");
  return { ok: true };
}

export async function deleteContact(id: string) {
  const supabase = createClient();
  const { error } = await supabase.from("contacts").delete().eq("id", id);
  if (error) return { error: error.message };
  revalidatePath("/contatti");
  return { ok: true };
}
