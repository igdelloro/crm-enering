import { createServerClient } from "@supabase/ssr";
import { cookies } from "next/headers";

// Client Supabase da usare nei Server Component e nelle Server Action.
// Legge/scrive i cookie di sessione tramite l'API cookies() di Next.
export function createClient() {
  const cookieStore = cookies();

  return createServerClient(
    process.env.NEXT_PUBLIC_SUPABASE_URL!,
    process.env.NEXT_PUBLIC_SUPABASE_ANON_KEY!,
    {
      cookies: {
        getAll() {
          return cookieStore.getAll();
        },
        setAll(
          cookiesToSet: { name: string; value: string; options?: any }[]
        ) {
          try {
            cookiesToSet.forEach(({ name, value, options }) =>
              cookieStore.set(name, value, options)
            );
          } catch {
            // Chiamato da un Server Component: ignorabile, il refresh della
            // sessione avviene nel middleware.
          }
        },
      },
    }
  );
}
