"use client";

import { useMemo, useState } from "react";
import { formatCurrency } from "@/lib/format";

type Row = { stato: string; importo: number | null; created_at: string };

const MESI = [
  "Gennaio","Febbraio","Marzo","Aprile","Maggio","Giugno",
  "Luglio","Agosto","Settembre","Ottobre","Novembre","Dicembre",
];

const isVinto = (s: string) => ["aggiudicata", "accettato"].includes(s);
const isPerso = (s: string) => ["non_aggiudicata", "rifiutato"].includes(s);

function Tabella({ rows }: { rows: { label: string; mese: string; anno: string; meseLabel: string; annoLabel: string }[] }) {
  return (
    <div className="bg-white dark:bg-slate-900 rounded-2xl border border-slate-200 dark:border-slate-700 shadow-sm overflow-x-auto">
      <table className="w-full text-sm min-w-[420px]">
        <thead>
          <tr className="text-left text-slate-500 dark:text-slate-400 border-b border-slate-100 dark:border-slate-800">
            <th className="px-5 py-3 font-medium">Indicatore</th>
            <th className="px-5 py-3 font-medium text-right">{rows[0]?.meseLabel}</th>
            <th className="px-5 py-3 font-medium text-right">{rows[0]?.annoLabel}</th>
          </tr>
        </thead>
        <tbody>
          {rows.map((r) => (
            <tr key={r.label} className="border-b border-slate-50 dark:border-slate-800">
              <td className="px-5 py-3 text-slate-600 dark:text-slate-300">{r.label}</td>
              <td className="px-5 py-3 text-right font-semibold text-slate-800 dark:text-slate-100">{r.mese}</td>
              <td className="px-5 py-3 text-right font-semibold text-slate-800 dark:text-slate-100">{r.anno}</td>
            </tr>
          ))}
        </tbody>
      </table>
    </div>
  );
}

export default function PerformanceClient({
  vendRows,
  tlmkRows,
  clienti,
}: {
  vendRows: Row[] | null;
  tlmkRows: Row[] | null;
  clienti: number | null;
}) {
  const now = new Date();
  const [anno, setAnno] = useState(now.getFullYear());
  const [mese, setMese] = useState(now.getMonth()); // 0-11

  // anni disponibili dai dati (più l'anno corrente)
  const anni = useMemo(() => {
    const set = new Set<number>([now.getFullYear()]);
    [...(vendRows ?? []), ...(tlmkRows ?? [])].forEach((r) =>
      set.add(new Date(r.created_at).getFullYear())
    );
    return Array.from(set).sort((a, b) => b - a);
  }, [vendRows, tlmkRows, now]);

  function filtMese(rows: Row[]) {
    return rows.filter((r) => {
      const d = new Date(r.created_at);
      return d.getFullYear() === anno && d.getMonth() === mese;
    });
  }
  function filtAnno(rows: Row[]) {
    return rows.filter((r) => new Date(r.created_at).getFullYear() === anno);
  }

  const meseLabel = `${MESI[mese]} ${anno}`;
  const annoLabel = `Anno ${anno}`;

  function statVend(rows: Row[]) {
    const vinti = rows.filter((p) => isVinto(p.stato));
    const persi = rows.filter((p) => isPerso(p.stato));
    const chiusi = vinti.length + persi.length;
    return {
      totali: rows.length,
      vinti: vinti.length,
      valore: vinti.reduce((s, p) => s + Number(p.importo ?? 0), 0),
      winRate: chiusi ? Math.round((vinti.length / chiusi) * 100) : null,
    };
  }

  return (
    <div className="mb-8">
      <div className="flex flex-wrap items-center gap-3 mb-4">
        <h2 className="text-lg font-semibold text-slate-800 dark:text-slate-100">Performance</h2>
        <div className="flex gap-2">
          <select
            value={mese}
            onChange={(e) => setMese(Number(e.target.value))}
            className="rounded-lg border border-slate-300 dark:border-slate-600 px-3 py-1.5 text-sm bg-white dark:bg-slate-900"
          >
            {MESI.map((m, i) => (
              <option key={i} value={i}>
                {m}
              </option>
            ))}
          </select>
          <select
            value={anno}
            onChange={(e) => setAnno(Number(e.target.value))}
            className="rounded-lg border border-slate-300 dark:border-slate-600 px-3 py-1.5 text-sm bg-white dark:bg-slate-900"
          >
            {anni.map((a) => (
              <option key={a} value={a}>
                {a}
              </option>
            ))}
          </select>
        </div>
      </div>

      {vendRows && (
        <div className="mb-6">
          <h3 className="text-sm font-semibold text-slate-600 dark:text-slate-300 mb-2">Venditore</h3>
          {(() => {
            const m = statVend(filtMese(vendRows));
            const a = statVend(filtAnno(vendRows));
            return (
              <Tabella
                rows={[
                  { label: "Preventivi / gare", mese: String(m.totali), anno: String(a.totali), meseLabel, annoLabel },
                  { label: "Vinti", mese: String(m.vinti), anno: String(a.vinti), meseLabel, annoLabel },
                  { label: "Tasso di successo", mese: m.winRate != null ? `${m.winRate}%` : "—", anno: a.winRate != null ? `${a.winRate}%` : "—", meseLabel, annoLabel },
                  { label: "Valore aggiudicato", mese: formatCurrency(m.valore), anno: formatCurrency(a.valore), meseLabel, annoLabel },
                ]}
              />
            );
          })()}
        </div>
      )}

      {tlmkRows && (
        <div className="mb-2">
          <h3 className="text-sm font-semibold text-slate-600 dark:text-slate-300 mb-2">Telemarketing</h3>
          <p className="text-sm text-slate-500 dark:text-slate-400 mb-2">
            Clienti assegnati:{" "}
            <span className="font-semibold text-slate-800 dark:text-slate-100">{clienti ?? 0}</span>
          </p>
          {(() => {
            const m = filtMese(tlmkRows);
            const a = filtAnno(tlmkRows);
            const val = (l: Row[]) =>
              l.filter((p) => isVinto(p.stato)).reduce((s, p) => s + Number(p.importo ?? 0), 0);
            return (
              <Tabella
                rows={[
                  { label: "Preventivi generati", mese: String(m.length), anno: String(a.length), meseLabel, annoLabel },
                  { label: "Diventati vendite", mese: String(m.filter((p) => isVinto(p.stato)).length), anno: String(a.filter((p) => isVinto(p.stato)).length), meseLabel, annoLabel },
                  { label: "Valore portato", mese: formatCurrency(val(m)), anno: formatCurrency(val(a)), meseLabel, annoLabel },
                ]}
              />
            );
          })()}
        </div>
      )}
    </div>
  );
}
