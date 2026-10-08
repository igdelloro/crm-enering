"use client";

import { useCallback, useEffect, useRef, useState } from "react";
import { useRouter } from "next/navigation";
import { createClient } from "@/lib/supabase/client";
import { timeAgo } from "@/lib/format";

type Notifica = {
  id: string;
  titolo: string;
  corpo: string | null;
  link: string | null;
  letta: boolean;
  created_at: string;
};

export default function NotificationBell() {
  const supabase = createClient();
  const router = useRouter();
  const [items, setItems] = useState<Notifica[]>([]);
  const [open, setOpen] = useState(false);
  const boxRef = useRef<HTMLDivElement>(null);

  const nonLette = items.filter((n) => !n.letta).length;

  const load = useCallback(async () => {
    const { data } = await supabase
      .from("notifiche")
      .select("*")
      .order("created_at", { ascending: false })
      .limit(50);
    setItems((data as any) ?? []);
  }, [supabase]);

  useEffect(() => {
    load();
    const t = setInterval(load, 60000);
    return () => clearInterval(t);
  }, [load]);

  // chiude il popup cliccando fuori
  useEffect(() => {
    function onClick(e: MouseEvent) {
      if (boxRef.current && !boxRef.current.contains(e.target as Node)) {
        setOpen(false);
      }
    }
    if (open) document.addEventListener("mousedown", onClick);
    return () => document.removeEventListener("mousedown", onClick);
  }, [open]);

  async function apri(n: Notifica) {
    setOpen(false);
    if (!n.letta) {
      await supabase.from("notifiche").update({ letta: true }).eq("id", n.id);
      setItems((prev) =>
        prev.map((x) => (x.id === n.id ? { ...x, letta: true } : x))
      );
    }
    if (n.link) router.push(n.link);
  }

  async function elimina(id: string, e: React.MouseEvent) {
    e.stopPropagation();
    await supabase.from("notifiche").delete().eq("id", id);
    setItems((prev) => prev.filter((x) => x.id !== id));
  }

  async function pulisciTutto() {
    const ids = items.map((x) => x.id);
    if (ids.length === 0) return;
    await supabase.from("notifiche").delete().in("id", ids);
    setItems([]);
  }

  return (
    <div className="relative" ref={boxRef}>
      <button
        onClick={() => setOpen((o) => !o)}
        aria-label="Notifiche"
        className="relative rounded-lg p-2 text-slate-500 dark:text-slate-300 hover:bg-slate-100 dark:hover:bg-slate-800 transition"
      >
        <svg
          width="20"
          height="20"
          viewBox="0 0 24 24"
          fill="none"
          stroke="currentColor"
          strokeWidth="2"
          strokeLinecap="round"
          strokeLinejoin="round"
        >
          <path d="M18 8A6 6 0 0 0 6 8c0 7-3 9-3 9h18s-3-2-3-9" />
          <path d="M13.73 21a2 2 0 0 1-3.46 0" />
        </svg>
        {nonLette > 0 && (
          <span className="absolute top-1 right-1 min-w-[16px] h-4 px-1 rounded-full bg-red-500 text-white text-[10px] font-bold flex items-center justify-center">
            {nonLette > 9 ? "9+" : nonLette}
          </span>
        )}
      </button>

      {open && (
        <div className="absolute right-0 mt-2 w-80 max-w-[90vw] bg-white dark:bg-slate-900 border border-slate-200 dark:border-slate-700 rounded-xl shadow-xl z-50 overflow-hidden">
          <div className="flex items-center justify-between px-4 py-3 border-b border-slate-100 dark:border-slate-800">
            <span className="text-sm font-semibold text-slate-800 dark:text-slate-100">
              Notifiche
            </span>
            {items.length > 0 && (
              <button
                onClick={pulisciTutto}
                className="text-xs text-slate-400 dark:text-slate-500 hover:text-red-500"
              >
                Pulisci tutto
              </button>
            )}
          </div>

          <div className="max-h-96 overflow-y-auto divide-y divide-slate-50 dark:divide-slate-800">
            {items.length === 0 ? (
              <p className="px-4 py-8 text-center text-sm text-slate-400 dark:text-slate-500">
                Nessuna notifica
              </p>
            ) : (
              items.map((n) => (
                <div
                  key={n.id}
                  onClick={() => apri(n)}
                  className={`flex items-start gap-2 px-4 py-3 cursor-pointer hover:bg-slate-50 dark:hover:bg-slate-800 ${
                    n.letta ? "" : "bg-brand-50/60 dark:bg-slate-800/50"
                  }`}
                >
                  {!n.letta && (
                    <span className="mt-1.5 w-2 h-2 rounded-full bg-brand-600 dark:bg-brand-300 shrink-0" />
                  )}
                  <div className="flex-1 min-w-0">
                    <p className="text-sm text-slate-800 dark:text-slate-100">
                      {n.titolo}
                    </p>
                    <p className="text-xs text-slate-400 dark:text-slate-500 mt-0.5">
                      {timeAgo(n.created_at)}
                    </p>
                  </div>
                  <button
                    onClick={(e) => elimina(n.id, e)}
                    aria-label="Elimina notifica"
                    className="shrink-0 text-slate-300 dark:text-slate-600 hover:text-red-500 text-lg leading-none"
                  >
                    ×
                  </button>
                </div>
              ))
            )}
          </div>
        </div>
      )}
    </div>
  );
}
