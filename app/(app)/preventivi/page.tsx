import { createClient } from "@/lib/supabase/server";
import PreventiviClient from "./PreventiviClient";

export const dynamic = "force-dynamic";

export default async function PreventiviPage() {
  const supabase = createClient();
  const { data: agenti } = await supabase
    .from("agenti")
    .select("*")
    .order("nome");

  return <PreventiviClient agenti={(agenti as any) ?? []} />;
}
