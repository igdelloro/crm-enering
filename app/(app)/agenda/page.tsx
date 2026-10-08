import { headers } from "next/headers";
import { createClient } from "@/lib/supabase/server";
import AgendaClient from "./AgendaClient";

export const dynamic = "force-dynamic";

export default async function AgendaPage() {
  const supabase = createClient();

  // Agenda riservata ai venditori (e ai gestori resp/admin)
  const [{ data: isVenditore }, { data: canManage }] = await Promise.all([
    supabase.rpc("e_venditore"),
    supabase.rpc("puo_gestire"),
  ]);
  if (isVenditore !== true && canManage !== true) {
    return (
      <div className="max-w-md mx-auto mt-20 text-center">
        <h1 className="text-xl font-semibold text-slate-800 dark:text-slate-100">
          Accesso riservato
        </h1>
        <p className="text-slate-500 dark:text-slate-400 mt-2 text-sm">
          L&apos;Agenda è disponibile per i venditori.
        </p>
      </div>
    );
  }

  const { data: agenti } = await supabase
    .from("agenti")
    .select("*")
    .eq("attivo", true)
    .order("nome");

  // Origine del sito (per comporre il link .ics di Google)
  const h = headers();
  const host = h.get("x-forwarded-host") ?? h.get("host") ?? "";
  const proto = h.get("x-forwarded-proto") ?? "https";
  const origin = host ? `${proto}://${host}` : "";

  return <AgendaClient agenti={(agenti as any) ?? []} origin={origin} />;
}
