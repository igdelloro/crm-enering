"use client";

import { useState } from "react";
import Link from "next/link";
import { usePathname } from "next/navigation";
import {
  IconDashboard,
  IconAgenda,
  IconClienti,
  IconRuoli,
  IconPreventivi,
  IconCantieri,
  IconCV,
  IconPerformance,
  IconProvvigioni,
  IconTicket,
  IconBacheca,
  IconSuggerimenti,
} from "./icons";
import ThemeToggle from "./ThemeToggle";

type Voce = {
  href: string;
  label: string;
  Icon: (p: any) => JSX.Element;
  soloResp?: boolean;
  soloVenditore?: boolean;
};
type Gruppo = { titolo: string; voci: Voce[] };

// Voci fisse in cima, sopra i gruppi a tendina
const vociTop: Voce[] = [
  { href: "/dashboard", label: "Dashboard", Icon: IconDashboard },
  { href: "/bacheca", label: "Bacheca", Icon: IconBacheca },
  { href: "/suggerimenti", label: "Suggerimenti", Icon: IconSuggerimenti },
];

const gruppi: Gruppo[] = [
  {
    titolo: "Operatività",
    voci: [
      { href: "/agenda", label: "Agenda", Icon: IconAgenda, soloVenditore: true },
      { href: "/clienti", label: "Clienti", Icon: IconClienti },
      { href: "/preventivi", label: "Preventivi", Icon: IconPreventivi },
      { href: "/cantieri", label: "Cantieri", Icon: IconCantieri },
      { href: "/curriculum", label: "Curriculum Vitae", Icon: IconCV },
    ],
  },
  {
    titolo: "Personale",
    voci: [
      { href: "/me", label: "Le mie performance", Icon: IconPerformance },
    ],
  },
  {
    titolo: "Gestione",
    voci: [
      { href: "/provvigioni", label: "Provvigioni", Icon: IconProvvigioni, soloResp: true },
      { href: "/agenti", label: "Ruoli", Icon: IconRuoli, soloResp: true },
      { href: "/ticket", label: "Ticket", Icon: IconTicket },
    ],
  },
];

function Chevron({ open }: { open: boolean }) {
  return (
    <svg
      width="14"
      height="14"
      viewBox="0 0 24 24"
      fill="none"
      stroke="currentColor"
      strokeWidth="2.5"
      strokeLinecap="round"
      strokeLinejoin="round"
      className={`transition-transform ${open ? "" : "-rotate-90"}`}
    >
      <path d="m6 9 6 6 6-6" />
    </svg>
  );
}

export default function Sidebar({
  userName,
  userEmail,
  canManage,
  isVenditore,
  onNavigate,
}: {
  userName: string;
  userEmail: string;
  canManage?: boolean;
  isVenditore?: boolean;
  onNavigate?: () => void;
}) {
  const pathname = usePathname();
  const puoVedereRuoli = canManage === true;
  const puoVedereAgenda = isVenditore === true || canManage === true;

  // tutti i gruppi aperti di default
  const [aperti, setAperti] = useState<Record<string, boolean>>({
    Operatività: true,
    Personale: true,
    Gestione: true,
  });

  function toggle(titolo: string) {
    setAperti((p) => ({ ...p, [titolo]: !p[titolo] }));
  }

  return (
    <aside className="w-60 shrink-0 bg-white dark:bg-slate-900 border-r border-slate-200 dark:border-slate-700 flex flex-col h-screen md:sticky md:top-0">
      <div className="px-4 py-4 border-b border-slate-100 dark:border-slate-800">
        <div className="bg-white rounded-lg p-2 flex items-center justify-center">
          {/* eslint-disable-next-line @next/next/no-img-element */}
          <img
            src="/logo.png"
            alt="Logo azienda"
            className="w-full h-auto max-h-16 object-contain"
          />
        </div>
      </div>

      <nav className="flex-1 p-3 overflow-y-auto">
        {/* Voci fisse in cima */}
        <div className="space-y-1 mb-3">
          {vociTop.map((item) => {
            const active =
              pathname === item.href || pathname.startsWith(item.href + "/");
            return (
              <Link
                key={item.href}
                href={item.href}
                onClick={onNavigate}
                className={`flex items-center gap-3 rounded-lg px-3 py-2 text-sm font-medium transition ${
                  active
                    ? "bg-brand-50 dark:bg-slate-800 text-brand-700 dark:text-brand-300"
                    : "text-slate-600 dark:text-slate-300 hover:bg-slate-50 dark:hover:bg-slate-800"
                }`}
              >
                <span className="w-5 flex items-center justify-center shrink-0">
                  <item.Icon
                    className={
                      active
                        ? "text-brand-700 dark:text-brand-300"
                        : "text-slate-400 dark:text-slate-500"
                    }
                  />
                </span>
                {item.label}
              </Link>
            );
          })}
        </div>

        {gruppi.map((g) => {
          const voci = g.voci.filter(
            (v) =>
              (!v.soloResp || puoVedereRuoli) &&
              (!v.soloVenditore || puoVedereAgenda)
          );
          if (voci.length === 0) return null;
          const open = aperti[g.titolo];
          return (
            <div key={g.titolo} className="mb-2">
              <button
                onClick={() => toggle(g.titolo)}
                className="w-full flex items-center justify-between px-3 py-2 text-xs font-semibold uppercase tracking-wide text-slate-400 dark:text-slate-500 hover:text-slate-600 dark:hover:text-slate-300"
              >
                {g.titolo}
                <Chevron open={open} />
              </button>
              {open && (
                <div className="space-y-1 mt-1">
                  {voci.map((item) => {
                    const active =
                      pathname === item.href ||
                      pathname.startsWith(item.href + "/");
                    return (
                      <Link
                        key={item.href}
                        href={item.href}
                        onClick={onNavigate}
                        className={`flex items-center gap-3 rounded-lg px-3 py-2 text-sm font-medium transition ${
                          active
                            ? "bg-brand-50 dark:bg-slate-800 text-brand-700 dark:text-brand-300"
                            : "text-slate-600 dark:text-slate-300 hover:bg-slate-50 dark:hover:bg-slate-800"
                        }`}
                      >
                        <span className="w-5 flex items-center justify-center shrink-0">
                          <item.Icon
                            className={active ? "text-brand-700 dark:text-brand-300" : "text-slate-400 dark:text-slate-500"}
                          />
                        </span>
                        {item.label}
                      </Link>
                    );
                  })}
                </div>
              )}
            </div>
          );
        })}
      </nav>

      <div className="p-3 border-t border-slate-100 dark:border-slate-800">
        <div className="px-3 py-2">
          <p className="text-sm font-medium text-slate-800 dark:text-slate-100 truncate">
            {userName}
          </p>
          <p className="text-xs text-slate-400 dark:text-slate-500 truncate">{userEmail}</p>
        </div>
        <ThemeToggle />
        <form action="/auth/signout" method="post">
          <button
            type="submit"
            className="w-full text-left rounded-lg px-3 py-2 text-sm text-slate-500 dark:text-slate-400 hover:bg-slate-50 dark:hover:bg-slate-800"
          >
            Esci
          </button>
        </form>
      </div>
    </aside>
  );
}
