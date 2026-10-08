import { createClient } from "@/lib/supabase/server";
import AgentiClient from "./AgentiClient";

export const dynamic = "force-dynamic";

export default async function AgentiPage() {
  const supabase = createClient();

  // Possono vedere i Ruoli solo i gestori (tag responsabile/amministratore o ruolo di login)
  const { data: canManage } = await supabase.rpc("puo_gestire");
  if (canManage !== true) {
    return (
      <div className="max-w-md mx-auto mt-20 text-center">
        <h1 className="text-xl font-semibold text-slate-800 dark:text-slate-100">Accesso riservato</h1>
        <p className="text-slate-500 dark:text-slate-400 mt-2 text-sm">
          La sezione Ruoli è visibile solo ad amministratori e responsabili.
        </p>
      </div>
    );
  }

  const { data: agenti } = await supabase
    .from("agenti")
    .select("*")
    .order("nome", { ascending: true })
    .order("cognome", { ascending: true });

  return <AgentiClient agenti={(agenti as any) ?? []} />;
}
