"use client";

import { useState } from "react";
import { useRouter } from "next/navigation";
import { createClient } from "@/lib/supabase/client";

export default function CambiaPasswordPage() {
  const router = useRouter();
  const supabase = createClient();
  const [pw, setPw] = useState("");
  const [pw2, setPw2] = useState("");
  const [error, setError] = useState<string | null>(null);
  const [saving, setSaving] = useState(false);

  async function onSubmit(e: React.FormEvent) {
    e.preventDefault();
    setError(null);
    if (pw.length < 8) {
      setError("La password deve avere almeno 8 caratteri.");
      return;
    }
    if (pw !== pw2) {
      setError("Le due password non coincidono.");
      return;
    }
    setSaving(true);
    // aggiorna la password
    const { error: e1 } = await supabase.auth.updateUser({ password: pw });
    if (e1) {
      setError(e1.message);
      setSaving(false);
      return;
    }
    // toglie il flag "deve cambiare password"
    const {
      data: { user },
    } = await supabase.auth.getUser();
    if (user) {
      await supabase
        .from("profiles")
        .update({ must_change_password: false })
        .eq("id", user.id);
    }
    router.push("/dashboard");
    router.refresh();
  }

  return (
    <div className="min-h-screen flex items-center justify-center bg-slate-100 dark:bg-slate-800 px-4">
      <div className="w-full max-w-md">
        <div className="text-center mb-6">
          <h1 className="text-2xl font-bold text-brand-700 dark:text-brand-300">Imposta la tua password</h1>
          <p className="text-slate-500 dark:text-slate-400 mt-1 text-sm">
            Per sicurezza, scegli una nuova password personale prima di entrare.
          </p>
        </div>
        <form
          onSubmit={onSubmit}
          className="bg-white dark:bg-slate-900 rounded-2xl shadow-sm border border-slate-200 dark:border-slate-700 p-8 space-y-4"
        >
          <div>
            <label className="block text-sm font-medium text-slate-700 dark:text-slate-200 mb-1">
              Nuova password
            </label>
            <input
              type="password"
              value={pw}
              onChange={(e) => setPw(e.target.value)}
              className="w-full rounded-lg border border-slate-300 dark:border-slate-600 px-3 py-2 focus:outline-none focus:ring-2 focus:ring-brand-400"
            />
          </div>
          <div>
            <label className="block text-sm font-medium text-slate-700 dark:text-slate-200 mb-1">
              Ripeti la password
            </label>
            <input
              type="password"
              value={pw2}
              onChange={(e) => setPw2(e.target.value)}
              className="w-full rounded-lg border border-slate-300 dark:border-slate-600 px-3 py-2 focus:outline-none focus:ring-2 focus:ring-brand-400"
            />
          </div>
          {error && (
            <p className="text-sm text-red-600 bg-red-50 rounded-lg px-3 py-2">
              {error}
            </p>
          )}
          <button
            type="submit"
            disabled={saving}
            className="w-full rounded-lg bg-brand-600 text-white font-medium py-2.5 hover:bg-brand-700 transition disabled:opacity-60"
          >
            {saving ? "Salvataggio…" : "Salva e continua"}
          </button>
        </form>
        <p className="text-center mt-4">
          <a
            href="/dashboard"
            className="text-sm text-slate-500 dark:text-slate-400 hover:underline"
          >
            Annulla e torna al CRM
          </a>
        </p>
      </div>
    </div>
  );
}
