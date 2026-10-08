import { createClient } from "@/lib/supabase/server";
import TicketsClient from "./TicketsClient";

export const dynamic = "force-dynamic";

export default async function TicketPage() {
  const supabase = createClient();

  const [{ data: tickets }, { data: companies }, { data: contacts }] =
    await Promise.all([
      supabase
        .from("tickets")
        .select("*, companies(name), contacts(first_name, last_name)")
        .order("created_at", { ascending: false }),
      supabase.from("companies").select("id, name").order("name"),
      supabase
        .from("contacts")
        .select("id, first_name, last_name")
        .order("first_name"),
    ]);

  return (
    <TicketsClient
      tickets={(tickets as any) ?? []}
      companies={companies ?? []}
      contacts={(contacts as any) ?? []}
    />
  );
}
