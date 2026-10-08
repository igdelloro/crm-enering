import { createClient } from "@/lib/supabase/server";
import ClientiClient from "./ClientiClient";

export const dynamic = "force-dynamic";

export default async function ClientiPage() {
  const supabase = createClient();

  // Solo gli agenti (pochi) vengono caricati qui; i clienti li scarica il
  // componente a blocchi di 15, filtrando direttamente nel database.
  const { data: agenti } = await supabase
    .from("agenti")
    .select("*")
    .order("nome");

  return <ClientiClient agenti={(agenti as any) ?? []} />;
}
