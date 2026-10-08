"use client";

import { createBrowserClient } from "@supabase/ssr";

// Client Supabase da usare nei componenti che girano nel browser
// ("use client"). Legge le variabili pubbliche NEXT_PUBLIC_*.
export function createClient() {
  return createBrowserClient(
    process.env.NEXT_PUBLIC_SUPABASE_URL!,
    process.env.NEXT_PUBLIC_SUPABASE_ANON_KEY!
  );
}
