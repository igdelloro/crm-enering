import { createClient } from "@/lib/supabase/server";
import { NextResponse } from "next/server";

// Logout: chiude la sessione e torna al login.
export async function POST(request: Request) {
  const supabase = createClient();
  await supabase.auth.signOut();
  return NextResponse.redirect(new URL("/login", request.url), {
    status: 302,
  });
}
