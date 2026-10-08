"use client";

import { useState } from "react";
import Sidebar from "./Sidebar";
import NotificationBell from "./NotificationBell";

export default function AppShell({
  userName,
  userEmail,
  canManage,
  isVenditore,
  children,
}: {
  userName: string;
  userEmail: string;
  canManage: boolean;
  isVenditore: boolean;
  children: React.ReactNode;
}) {
  const [open, setOpen] = useState(false);

  return (
    <div className="flex min-h-screen">
      {/* Menu laterale su desktop */}
      <div className="hidden md:block">
        <Sidebar
          userName={userName}
          userEmail={userEmail}
          canManage={canManage}
          isVenditore={isVenditore}
        />
      </div>

      {/* Menu a scomparsa su mobile */}
      {open && (
        <div
          className="md:hidden fixed inset-0 z-40 bg-slate-900/40"
          onClick={() => setOpen(false)}
        />
      )}
      <div
        className={`md:hidden fixed inset-y-0 left-0 z-50 transition-transform ${
          open ? "translate-x-0" : "-translate-x-full"
        }`}
      >
        <Sidebar
          userName={userName}
          userEmail={userEmail}
          canManage={canManage}
          isVenditore={isVenditore}
          onNavigate={() => setOpen(false)}
        />
      </div>

      <div className="flex-1 min-w-0 flex flex-col">
        {/* Barra superiore: hamburger+logo su mobile, campanella sempre a destra */}
        <div className="sticky top-0 z-30 flex items-center gap-3 bg-white dark:bg-slate-900 border-b border-slate-200 dark:border-slate-700 px-4 py-2.5">
          <button
            onClick={() => setOpen(true)}
            aria-label="Apri menu"
            className="md:hidden text-2xl leading-none text-slate-700 dark:text-slate-200"
          >
            ☰
          </button>
          <div className="md:hidden bg-white rounded-md px-2 py-1 flex items-center">
            {/* eslint-disable-next-line @next/next/no-img-element */}
            <img
              src="/logo.png"
              alt="Logo azienda"
              className="h-6 w-auto object-contain"
            />
          </div>
          <div className="flex-1" />
          <NotificationBell />
        </div>

        <main className="flex-1 min-w-0 p-4 md:p-8">{children}</main>
      </div>
    </div>
  );
}
