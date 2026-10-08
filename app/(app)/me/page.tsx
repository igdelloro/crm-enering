import { createClient } from "@/lib/supabase/server";
import { formatCurrency } from "@/lib/format";
import { agenteRuoli } from "@/lib/types";
import { Card, Badge } from "@/components/ui";
import Link from "next/link";
import PerformanceClient from "./PerformanceClient";

export const dynamic = "force-dynamic";

function Stat({ label, value, sub }: { label: string; value: string; sub?: string }) {
  return (
    <div className="bg-white dark:bg-slate-900 rounded-2xl border border-slate-200 dark:border-slate-700 shadow-sm p-5">
      <p className="text-sm text-slate-500 dark:text-slate-400">{label}</p>
      <p className="text-2xl font-bold text-slate-900 dark:text-slate-100 mt-1">{value}</p>
      {sub && <p className="text-xs text-slate-400 dark:text-slate-500 mt-1">{sub}</p>}
    </div>
  );
}

export default async function MePage() {
  const supabase = createClient();
  const {
    data: { user },
  } = await supabase.auth.getUser();

  const email = user?.email ?? "";
  const { data: agente } = await supabase
    .from("agenti")
    .select("*")
    .eq("email", email)
    .maybeSingle();

  if (!agente) {
    return (
      <div className="max-w-lg mx-auto mt-16 text-center">
        <h1 className="text-xl font-semibold text-slate-800 dark:text-slate-100">Le mie performance</h1>
        <p className="text-slate-500 dark:text-slate-400 mt-2 text-sm">
          Il tuo account di accesso ({email}) non è ancora collegato a una
          persona in «Ruoli». Chiedi a un responsabile di inserirti in Ruoli con
          questa stessa email, così qui vedrai le tue statistiche.
        </p>
      </div>
    );
  }

  const ruoli = agenteRuoli(agente as any);
  const isVend = ruoli.includes("venditore");
  const isTlmk = ruoli.includes("telemarketing");

  // Dati grezzi per le performance (il filtro mese/anno è lato client)
  let vendRows: any[] | null = null;
  if (isVend) {
    const { data } = await supabase
      .from("preventivi")
      .select("stato, importo, created_at")
      .eq("venditore_agente_id", agente.id);
    vendRows = data ?? [];
  }

  let tlmkRows: any[] | null = null;
  let clientiCount = 0;
  if (isTlmk) {
    const { count } = await supabase
      .from("companies")
      .select("*", { count: "exact", head: true })
      .eq("tlmk_agente_id", agente.id);
    clientiCount = count ?? 0;
    const { data } = await supabase
      .from("preventivi")
      .select("stato, importo, created_at")
      .eq("tlmk_agente_id", agente.id);
    tlmkRows = data ?? [];
  }

  // Appuntamenti futuri (per tutti)
  const { data: appFut } = await supabase
    .from("appuntamenti")
    .select("id, titolo, inizio, companies(name)")
    .eq("agente_id", agente.id)
    .gte("inizio", new Date().toISOString())
    .order("inizio")
    .limit(5);

  // Le mie provvigioni
  const { data: provv } = await supabase
    .from("provvigioni")
    .select("*")
    .eq("agente_id", agente.id)
    .order("created_at", { ascending: false });
  const provvList = provv ?? [];
  const daLiquidare = provvList
    .filter((p) => p.stato !== "liquidata")
    .reduce((s, p) => s + Number(p.importo ?? 0), 0);
  const liquidate = provvList
    .filter((p) => p.stato === "liquidata")
    .reduce((s, p) => s + Number(p.importo ?? 0), 0);

  return (
    <>
      <div className="mb-6">
        <h1 className="text-2xl font-bold text-slate-900 dark:text-slate-100">
          Ciao {agente.nome}
        </h1>
        <div className="flex gap-2 mt-2">
          {ruoli.map((r) => (
            <Badge key={r} color="blue">
              {r}
            </Badge>
          ))}
        </div>
      </div>

      {(isVend || isTlmk) ? (
        <PerformanceClient
          vendRows={vendRows}
          tlmkRows={tlmkRows}
          clienti={clientiCount}
        />
      ) : (
        <p className="text-sm text-slate-500 dark:text-slate-400 mb-8">
          Per il tuo ruolo non ci sono ancora statistiche di vendita. Qui sotto
          trovi comunque i tuoi prossimi appuntamenti.
        </p>
      )}

      {/* Le mie provvigioni */}
      <div className="mb-6">
        <h2 className="text-lg font-semibold text-slate-800 dark:text-slate-100 mb-3">
          Le mie provvigioni
        </h2>
        <div className="grid grid-cols-2 gap-4 mb-3">
          <Stat label="Da liquidare" value={formatCurrency(daLiquidare)} />
          <Stat label="Già liquidate" value={formatCurrency(liquidate)} />
        </div>
        <Card>
          {provvList.length === 0 ? (
            <p className="p-5 text-sm text-slate-400 dark:text-slate-500">
              Nessuna provvigione registrata. Le inserisce un responsabile.
            </p>
          ) : (
            <div className="overflow-x-auto">
              <table className="w-full text-sm min-w-[520px]">
                <thead>
                  <tr className="text-left text-slate-500 dark:text-slate-400 border-b border-slate-100 dark:border-slate-800">
                    <th className="px-4 py-3 font-medium">Periodo</th>
                    <th className="px-4 py-3 font-medium">Imponibile</th>
                    <th className="px-4 py-3 font-medium">%</th>
                    <th className="px-4 py-3 font-medium">Provvigione</th>
                    <th className="px-4 py-3 font-medium">Stato</th>
                  </tr>
                </thead>
                <tbody>
                  {provvList.map((p) => (
                    <tr key={p.id} className="border-b border-slate-50 dark:border-slate-800">
                      <td className="px-4 py-3 text-slate-700 dark:text-slate-200">{p.periodo ?? "—"}</td>
                      <td className="px-4 py-3 text-slate-600 dark:text-slate-300">
                        {p.imponibile != null ? formatCurrency(Number(p.imponibile)) : "—"}
                      </td>
                      <td className="px-4 py-3 text-slate-600 dark:text-slate-300">
                        {p.percentuale != null ? `${p.percentuale}%` : "—"}
                      </td>
                      <td className="px-4 py-3 font-semibold text-slate-800 dark:text-slate-100">
                        {p.importo != null ? formatCurrency(Number(p.importo)) : "—"}
                      </td>
                      <td className="px-4 py-3">
                        <Badge color={p.stato === "liquidata" ? "green" : "amber"}>
                          {p.stato === "liquidata" ? "Liquidata" : "Da liquidare"}
                        </Badge>
                      </td>
                    </tr>
                  ))}
                </tbody>
              </table>
            </div>
          )}
        </Card>
      </div>

      <Card>
        <div className="px-5 py-4 border-b border-slate-100 dark:border-slate-800">
          <h2 className="font-semibold text-slate-800 dark:text-slate-100">I miei prossimi appuntamenti</h2>
        </div>
        <div className="divide-y divide-slate-50 dark:divide-slate-800">
          {(appFut ?? []).length === 0 && (
            <p className="p-5 text-sm text-slate-400 dark:text-slate-500">Nessun appuntamento in programma.</p>
          )}
          {((appFut as any[]) ?? []).map((a) => (
            <div key={a.id} className="px-5 py-3 flex items-center justify-between">
              <div>
                <p className="text-sm font-medium text-slate-800 dark:text-slate-100">{a.titolo}</p>
                <p className="text-xs text-slate-400 dark:text-slate-500">{a.companies?.name ?? ""}</p>
              </div>
              <span className="text-sm text-slate-500 dark:text-slate-400">
                {new Intl.DateTimeFormat("it-IT", {
                  day: "2-digit",
                  month: "short",
                  hour: "2-digit",
                  minute: "2-digit",
                }).format(new Date(a.inizio))}
              </span>
            </div>
          ))}
        </div>
        <div className="px-5 py-3 border-t border-slate-50 dark:border-slate-800">
          <Link href="/agenda" className="text-sm text-brand-600 dark:text-brand-300 hover:underline">
            Vai all&apos;agenda →
          </Link>
        </div>
      </Card>
    </>
  );
}
