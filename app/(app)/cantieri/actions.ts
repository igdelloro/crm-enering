"use server";

import { revalidatePath } from "next/cache";
import { createClient } from "@/lib/supabase/server";

function clean(v: FormDataEntryValue | null): string | null {
  const s = (v ?? "").toString().trim();
  return s === "" ? null : s;
}

export async function moveCantiere(id: string, fase: string) {
  const supabase = createClient();
  const { error } = await supabase.from("cantieri").update({ fase }).eq("id", id);
  if (error) return { error: error.message };
  revalidatePath("/cantieri");
  return { ok: true };
}

// Chiude il cantiere e lo sposta nell'archivio Curriculum Vitae
export async function archiviaInCV(id: string) {
  const supabase = createClient();
  const { error } = await supabase
    .from("cantieri")
    .update({ fase: "chiuso", in_cv: true })
    .eq("id", id);
  if (error) return { error: error.message };
  revalidatePath("/cantieri");
  revalidatePath("/curriculum");
  return { ok: true };
}

// Riporta un lavoro dal CV alla bacheca
export async function ripristinaDaCV(id: string) {
  const supabase = createClient();
  const { error } = await supabase
    .from("cantieri")
    .update({ in_cv: false, fase: "chiuso" })
    .eq("id", id);
  if (error) return { error: error.message };
  revalidatePath("/cantieri");
  revalidatePath("/curriculum");
  return { ok: true };
}

export async function saveCantiere(formData: FormData) {
  const supabase = createClient();
  const id = clean(formData.get("id"));
  if (!id) return { error: "Cantiere mancante." };
  const fase = clean(formData.get("fase")) ?? "da_pianificare";
  const payload: Record<string, unknown> = {
    titolo: clean(formData.get("titolo")),
    fase,
    responsabile_agente_id: clean(formData.get("responsabile_agente_id")),
    note: clean(formData.get("note")),
  };
  // Se messo a "chiuso", va nel Curriculum Vitae
  if (fase === "chiuso") payload.in_cv = true;
  const { error } = await supabase.from("cantieri").update(payload).eq("id", id);
  if (error) return { error: error.message };
  revalidatePath("/cantieri");
  revalidatePath("/curriculum");
  return { ok: true };
}

export async function deleteCantiere(id: string) {
  const supabase = createClient();
  const { error } = await supabase.from("cantieri").delete().eq("id", id);
  if (error)
    return { error: "Non è stato possibile eliminare (serve un responsabile)." };
  revalidatePath("/cantieri");
  return { ok: true };
}

export async function addTask(formData: FormData) {
  const supabase = createClient();
  const cantiereId = clean(formData.get("cantiere_id"));
  const descrizione = (formData.get("descrizione") ?? "").toString().trim();
  if (!cantiereId || !descrizione)
    return { error: "Descrizione mancante." };
  const { error } = await supabase.from("cantiere_task").insert({
    cantiere_id: cantiereId,
    descrizione,
    assegnato_agente_id: clean(formData.get("assegnato_agente_id")),
    scadenza: clean(formData.get("scadenza")),
  });
  if (error) return { error: error.message };
  revalidatePath("/cantieri");
  return { ok: true };
}

export async function toggleTask(id: string, fatto: boolean) {
  const supabase = createClient();
  const { error } = await supabase
    .from("cantiere_task")
    .update({ fatto })
    .eq("id", id);
  if (error) return { error: error.message };
  revalidatePath("/cantieri");
  return { ok: true };
}

export async function deleteTask(id: string) {
  const supabase = createClient();
  const { error } = await supabase.from("cantiere_task").delete().eq("id", id);
  if (error) return { error: error.message };
  revalidatePath("/cantieri");
  return { ok: true };
}
