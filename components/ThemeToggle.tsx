"use client";

import { useEffect, useState } from "react";

export default function ThemeToggle() {
  const [dark, setDark] = useState(false);
  const [mounted, setMounted] = useState(false);

  useEffect(() => {
    setMounted(true);
    setDark(document.documentElement.classList.contains("dark"));
  }, []);

  function toggle() {
    const next = !dark;
    setDark(next);
    const root = document.documentElement;
    if (next) root.classList.add("dark");
    else root.classList.remove("dark");
    // Tiene allineati gli stili inline impostati all'avvio (anti-lampo)
    root.style.colorScheme = next ? "dark" : "light";
    root.style.backgroundColor = next ? "#0f1623" : "#f4f5f7";
    try {
      localStorage.setItem("theme", next ? "dark" : "light");
    } catch (e) {}
  }

  return (
    <button
      type="button"
      onClick={toggle}
      aria-label={dark ? "Passa a tema chiaro" : "Passa a tema scuro"}
      className="w-full flex items-center gap-3 rounded-lg px-3 py-2 text-sm text-slate-500 dark:text-slate-400 hover:bg-slate-50 dark:hover:bg-slate-800 transition"
    >
      <span className="w-5 flex items-center justify-center shrink-0">
        {mounted && dark ? (
          // Sole
          <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round">
            <circle cx="12" cy="12" r="4" />
            <path d="M12 2v2M12 20v2M4.93 4.93l1.41 1.41M17.66 17.66l1.41 1.41M2 12h2M20 12h2M6.34 17.66l-1.41 1.41M19.07 4.93l-1.41 1.41" />
          </svg>
        ) : (
          // Luna
          <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round">
            <path d="M21 12.79A9 9 0 1 1 11.21 3 7 7 0 0 0 21 12.79z" />
          </svg>
        )}
      </span>
      {mounted && dark ? "Tema chiaro" : "Tema scuro"}
    </button>
  );
}
