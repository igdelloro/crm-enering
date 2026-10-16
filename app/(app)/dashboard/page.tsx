import Link from "next/link";
import { createClient } from "@/lib/supabase/server";
import { formatCurrency, timeAgo } from "@/lib/format";
import { Card } from "@/components/ui";
import {
  IconClienti,
  IconPA,
  IconPrivati,
  IconPreventivi,
  IconCantieri,
  IconAgenda,
  IconSuggerimenti,
  IconBacheca,
} from "@/components/icons";

export const dynamic = "force-dynamic";

function Tile({
  label,
  value,
  href,
  Icon,
}: {
  label: string;
  value: number;
  href: string;
  Icon: (p: any) => JSX.Element;
}) {
  return (
    <Link href={href}>
      <div className="relative overflow-hidden bg-white dark:bg-slate-900 rounded-2xl border border-slate-200 dark:border-slate-700 shadow-sm p-5 h-28 hover:border-brand-300 dark:hover:border-brand-500 transition">
        <p className="text-sm font-medium text-slate-500 dark:text-slate-400">
          {label}
        </p>
        <p className="absolute bottom-4 right-5 text-3xl font-bold text-slate-900 dark:text-slate-100">
          {value}
        </p>
        <Icon className="absolute bottom-3 left-4 w-10 h-10 text-brand-600/15 dark:text-brand-300/15" />
      </div>
    </Link>
  );
}

export default async function DashboardPage() {
  const supabase = createClient();

  const now = new Date();
  const meseStart = new Date(now.getFullYear(), now.getMonth(), 1).toISOString();
  const meseEnd = new Date(now.getFullYear(), now.getMonth() + 1, 1).toISOString();

  const [
    { count: clientiCount },
    { count: preventiviCount },
    { count: cantieriCount },
    { count: appuntamentiCount },
    { count: suggerimentiCount },
    { count: annunciCount },
    { data: gareVinte },
    { data: annunci },
  ] = await Promise.all([
    supabase.from("companies").select("*", { count: "exact", head: true }),
    supabase.from("preventivi").select("*", { count: "exact", head: true }),
    supabase
      .from("cantieri")
      .select("*", { count: "exact", head: true })
      .or("in_cv.is.null,in_cv.eq.false"),
    supabase
      .from("appuntamenti")
      .select("*", { count: "exact", head: true })
      .gte("inizio", meseStart)
      .lt("inizio", meseEnd),
    supabase
      .from("suggerimenti")
      .select("*", { count: "exact", head: true })
      .eq("risolto", false),
    supabase.from("annunci").select("*", { count: "exact", head: true }),
    supabase
      .from("preventivi")
      .select("importo, company_id, companies(tipo)")
      .in("stato", ["aggiudicata", "accettato"]),
    supabase
      .from("annunci")
      .select("id, titolo, created_at")
      .order("created_at", { ascending: false })
      .limit(4),
  ]);

  const valoreVinto = (gareVinte ?? []).reduce(
    (s, p) => s + Number((p as any).importo ?? 0),
    0
  );

  // "Clienti veri": aziende con almeno un lavoro chiuso (preventivo
  // aggiudicato/accettato), divise per tipo. Dedup per azienda.
  const tipoPerAzienda = new Map<string, string>();
  for (const p of (gareVinte as any[]) ?? []) {
    if (p.company_id && p.companies?.tipo) {
      tipoPerAzienda.set(p.company_id, p.companies.tipo);
    }
  }
  let clientiPA = 0;
  let clientiPrivati = 0;
  tipoPerAzienda.forEach((tipo) => {
    if (tipo === "pa") clientiPA++;
    else clientiPrivati++;
  });

  return (
    <>
      <h1 className="text-2xl font-bold text-slate-900 dark:text-slate-100 mb-6">
        Dashboard
      </h1>

      <div className="grid grid-cols-2 md:grid-cols-3 lg:grid-cols-4 gap-4 mb-6">
        <Tile label="Anagrafiche" value={clientiCount ?? 0} href="/clienti" Icon={IconClienti} />
        <Tile label="Clienti PA" value={clientiPA} href="/clienti" Icon={IconPA} />
        <Tile label="Clienti privati" value={clientiPrivati} href="/clienti" Icon={IconPrivati} />
        <Tile label="Preventivi / Gare" value={preventiviCount ?? 0} href="/preventivi" Icon={IconPreventivi} />
        <Tile label="Commesse attive" value={cantieriCount ?? 0} href="/cantieri" Icon={IconCantieri} />
        <Tile label="Appuntamenti (mese)" value={appuntamentiCount ?? 0} href="/agenda" Icon={IconAgenda} />
        <Tile label="Suggerimenti aperti" value={suggerimentiCount ?? 0} href="/suggerimenti" Icon={IconSuggerimenti} />
        <Tile label="Annunci" value={annunciCount ?? 0} href="/bacheca" Icon={IconBacheca} />
      </div>

      <div className="grid lg:grid-cols-3 gap-6">
        <Card>
          <div className="p-5">
            <p className="text-sm text-slate-500 dark:text-slate-400">
              Valore aggiudicato / accettato
            </p>
            <p className="text-3xl font-bold text-green-600 dark:text-green-400 mt-1">
              {formatCurrency(valoreVinto)}
            </p>
            <p className="text-xs text-slate-400 dark:text-slate-500 mt-1">
              Somma degli importi di gare aggiudicate e preventivi accettati
            </p>
          </div>
        </Card>

        <div className="lg:col-span-2">
          <Card>
            <div className="px-5 py-4 border-b border-slate-100 dark:border-slate-800 flex items-center justify-between">
              <h2 className="font-semibold text-slate-800 dark:text-slate-100">
                Ultimi annunci
              </h2>
              <Link
                href="/bacheca"
                className="text-sm text-brand-600 dark:text-brand-300 hover:underline"
              >
                Vai alla bacheca →
              </Link>
            </div>
            <div className="divide-y divide-slate-50 dark:divide-slate-800">
              {(annunci ?? []).length === 0 && (
                <p className="p-5 text-sm text-slate-400 dark:text-slate-500">
                  Nessun annuncio.
                </p>
              )}
              {((annunci as any[]) ?? []).map((a) => (
                <Link
                  key={a.id}
                  href="/bacheca"
                  className="block px-5 py-3 hover:bg-slate-50 dark:hover:bg-slate-800"
                >
                  <p className="text-sm font-medium text-slate-800 dark:text-slate-100">
                    {a.titolo}
                  </p>
                  <p className="text-xs text-slate-400 dark:text-slate-500">
                    {timeAgo(a.created_at)}
                  </p>
                </Link>
              ))}
            </div>
          </Card>
        </div>
      </div>
    </>
  );
}
