import { createClient } from "@/lib/supabase/server";
import ProvvigioniClient from "./ProvvigioniClient";

export const dynamic = "force-dynamic";

export default async function ProvvigioniPage() {
  const supabase = createClient();

  // Gestione provvigioni riservata ai gestori (tag responsabile/amministratore o ruolo di login)
  const { data: canManage } = await supabase.rpc("puo_gestire");
  if (canManage !== true) {
    return (
      <div className="max-w-md mx-auto mt-20 text-center">
        <h1 className="text-xl font-semibold text-slate-800 dark:text-slate-100">Accesso riservato</h1>
        <p className="text-slate-500 dark:text-slate-400 mt-2 text-sm">
          La gestione provvigioni è riservata a responsabili e amministratori.
        </p>
      </div>
    );
  }

  const [{ data: provv }, { data: agenti }] = await Promise.all([
    supabase
      .from("provvigioni")
      .select("*, agenti(nome, cognome)")
      .order("created_at", { ascending: false }),
    supabase.from("agenti").select("id, nome, cognome").order("nome"),
  ]);

  return (
    <ProvvigioniClient
      provvigioni={(provv as any) ?? []}
      agenti={(agenti as any) ?? []}
    />
  );
}
