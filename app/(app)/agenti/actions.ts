"use server";

import { revalidatePath } from "next/cache";
import { createClient } from "@/lib/supabase/server";
import type { RuoloAgente } from "@/lib/types";

function clean(v: FormDataEntryValue | null): string | null {
  const s = (v ?? "").toString().trim();
  return s === "" ? null : s;
}

export async function saveAgente(formData: FormData) {
  const supabase = createClient();
  const id = clean(formData.get("id"));

  const ruoli = formData
    .getAll("ruoli")
    .map((v) => v.toString())
    .filter(Boolean);
  const ruoliFinali = ruoli.length ? ruoli : ["venditore"];

  const nome = (formData.get("nome") ?? "").toString().trim();
  const cognome = clean(formData.get("cognome"));
  let sigla = clean(formData.get("sigla"))?.toUpperCase() ?? null;

  // Sigla solo per i venditori: se assente, iniziali di nome + cognome
  const isVenditore = ruoliFinali.includes("venditore");
  if (isVenditore && !sigla) {
    sigla = ((nome[0] ?? "") + (cognome?.[0] ?? "")).toUpperCase() || null;
  }
  if (!isVenditore) sigla = null;

  const payload = {
    nome,
    cognome,
    ruolo: ruoliFinali[0] as RuoloAgente, // compatibilità col campo singolo
    ruoli: ruoliFinali,
    email: clean(formData.get("email")),
    sigla,
    attivo: formData.get("attivo") === "on",
  };

  if (!payload.nome) return { error: "Il nome è obbligatorio." };

  if (id) {
    const { error } = await supabase.from("agenti").update(payload).eq("id", id);
    if (error) return { error: error.message };
  } else {
    const { error } = await supabase.from("agenti").insert(payload);
    if (error) return { error: error.message };
  }

  revalidatePath("/agenti");
  revalidatePath("/clienti");
  return { ok: true };
}

export async function deleteAgente(id: string) {
  const supabase = createClient();
  const { error } = await supabase.from("agenti").delete().eq("id", id);
  if (error) return { error: error.message };
  revalidatePath("/agenti");
  return { ok: true };
}
