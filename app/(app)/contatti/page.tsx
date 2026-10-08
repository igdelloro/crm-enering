import { createClient } from "@/lib/supabase/server";
import ContactsClient from "./ContactsClient";

export const dynamic = "force-dynamic";

export default async function ContattiPage() {
  const supabase = createClient();

  const [{ data: contacts }, { data: companies }] = await Promise.all([
    supabase
      .from("contacts")
      .select("*, companies(name)")
      .order("created_at", { ascending: false }),
    supabase.from("companies").select("id, name").order("name"),
  ]);

  return (
    <ContactsClient
      contacts={(contacts as any) ?? []}
      companies={companies ?? []}
    />
  );
}
