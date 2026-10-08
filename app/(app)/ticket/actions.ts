"use server";

import { revalidatePath } from "next/cache";
import { createClient } from "@/lib/supabase/server";
import type { TicketStatus, TicketPriority } from "@/lib/types";

function clean(v: FormDataEntryValue | null): string | null {
  const s = (v ?? "").toString().trim();
  return s === "" ? null : s;
}

export async function saveTicket(formData: FormData) {
  const supabase = createClient();
  const id = clean(formData.get("id"));

  const payload = {
    subject: (formData.get("subject") ?? "").toString().trim(),
    description: clean(formData.get("description")),
    company_id: clean(formData.get("company_id")),
    contact_id: clean(formData.get("contact_id")),
    status: (clean(formData.get("status")) ?? "aperto") as TicketStatus,
    priority: (clean(formData.get("priority")) ?? "media") as TicketPriority,
  };

  if (!payload.subject) return { error: "L'oggetto del ticket è obbligatorio." };

  if (id) {
    const { error } = await supabase
      .from("tickets")
      .update(payload)
      .eq("id", id);
    if (error) return { error: error.message };
  } else {
    const { error } = await supabase.from("tickets").insert(payload);
    if (error) return { error: error.message };
  }

  revalidatePath("/ticket");
  revalidatePath("/dashboard");
  return { ok: true };
}

export async function deleteTicket(id: string) {
  const supabase = createClient();
  const { error } = await supabase.from("tickets").delete().eq("id", id);
  if (error) return { error: error.message };
  revalidatePath("/ticket");
  revalidatePath("/dashboard");
  return { ok: true };
}
