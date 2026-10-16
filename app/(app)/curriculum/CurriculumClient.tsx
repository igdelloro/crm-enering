"use client";

import { useMemo, useState } from "react";
import Link from "next/link";
import { useRouter } from "next/navigation";
import { CATEGORIE_PREVENTIVO } from "@/lib/types";
import { formatCurrency, formatDate } from "@/lib/format";
import {
  PageHeader,
  Card,
  Button,
  Input,
  Select,
  Badge,
  EmptyState,
} from "@/components/ui";
import { ripristinaDaCV } from "../cantieri/actions";

type Lavoro = {
  id: string;
  titolo: string | null;
  importo: number | null;
  company_id: string | null;
  updated_at: string;
  preventivi: { numero: string | null; categoria: string | null } | null;
  companies: { name: string; citta: string | null; provincia: string | null } | null;
};

export default function CurriculumClient({ lavori }: { lavori: Lavoro[] }) {
  const router = useRouter();
  const [q, setQ] = useState("");
  const [cat, setCat] = useState("");

  const filtered = useMemo(
    () =>
      lavori.filter((l) => {
        if (cat && l.preventivi?.categoria !== cat) return false;
        if (q) {
          const s = `${l.titolo ?? ""} ${l.companies?.name ?? ""} ${
            l.companies?.citta ?? ""
          } ${l.preventivi?.numero ?? ""}`.toLowerCase();
          if (!s.includes(q.toLowerCase())) return false;
        }
        return true;
      }),
    [lavori, q, cat]
  );

  const totale = filtered.reduce((s, l) => s + Number(l.importo ?? 0), 0);

  async function onRipristina(id: string) {
    if (!confirm("Riportare questo lavoro nella bacheca Commesse?")) return;
    await ripristinaDaCV(id);
    router.refresh();
  }

  return (
    <>
      <PageHeader
        title="Curriculum Vitae"
        subtitle={`${filtered.length} lavori completati · ${formatCurrency(totale)}`}
      />

      <div className="flex flex-wrap gap-3 mb-4">
        <Input
          placeholder="Cerca per cliente, città, numero…"
          value={q}
          onChange={(e) => setQ(e.target.value)}
          className="max-w-xs"
        />
        <Select value={cat} onChange={(e) => setCat(e.target.value)} className="max-w-[160px]">
          <option value="">Tutte le categorie</option>
          {CATEGORIE_PREVENTIVO.map((c) => (
            <option key={c} value={c}>
              {c}
            </option>
          ))}
        </Select>
      </div>

      <Card>
        {filtered.length === 0 ? (
          <EmptyState message="Nessun lavoro nel curriculum. I lavori arrivano qui quando una commessa viene chiusa." />
        ) : (
          <div className="overflow-x-auto">
            <table className="w-full text-sm min-w-[640px]">
              <thead>
                <tr className="text-left text-slate-500 dark:text-slate-400 border-b border-slate-100 dark:border-slate-800">
                  <th className="px-4 py-3 font-medium">Lavoro</th>
                  <th className="px-4 py-3 font-medium">Cliente</th>
                  <th className="px-4 py-3 font-medium">Categoria</th>
                  <th className="px-4 py-3 font-medium">Importo</th>
                  <th className="px-4 py-3 font-medium">Numero</th>
                  <th className="px-4 py-3"></th>
                </tr>
              </thead>
              <tbody>
                {filtered.map((l) => (
                  <tr key={l.id} className="border-b border-slate-50 dark:border-slate-800 hover:bg-slate-50 dark:hover:bg-slate-800">
                    <td className="px-4 py-3 font-medium text-slate-800 dark:text-slate-100">
                      {l.titolo ?? "—"}
                    </td>
                    <td className="px-4 py-3">
                      {l.company_id ? (
                        <Link href={`/clienti/${l.company_id}`} target="_blank" rel="noopener" className="text-slate-700 dark:text-slate-200 hover:underline">
                          {l.companies?.name ?? "—"}
                        </Link>
                      ) : (
                        l.companies?.name ?? "—"
                      )}
                      {l.companies?.citta && (
                        <div className="text-xs text-slate-400 dark:text-slate-500">
                          {l.companies.citta}
                          {l.companies.provincia ? ` (${l.companies.provincia})` : ""}
                        </div>
                      )}
                    </td>
                    <td className="px-4 py-3">
                      {l.preventivi?.categoria ? (
                        <Badge color="slate">{l.preventivi.categoria}</Badge>
                      ) : (
                        "—"
                      )}
                    </td>
                    <td className="px-4 py-3 text-slate-700 dark:text-slate-200">
                      {l.importo != null ? formatCurrency(Number(l.importo)) : "—"}
                    </td>
                    <td className="px-4 py-3 text-slate-500 dark:text-slate-400">
                      {l.preventivi?.numero ?? "—"}
                    </td>
                    <td className="px-4 py-3 text-right whitespace-nowrap">
                      <button
                        onClick={() => onRipristina(l.id)}
                        className="text-brand-600 dark:text-brand-300 hover:underline text-xs"
                      >
                        Riporta in commesse
                      </button>
                    </td>
                  </tr>
                ))}
              </tbody>
            </table>
          </div>
        )}
      </Card>
    </>
  );
}
