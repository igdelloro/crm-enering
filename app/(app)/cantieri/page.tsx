import { createClient } from "@/lib/supabase/server";
import CantieriClient from "./CantieriClient";

export const dynamic = "force-dynamic";

export default async function CantieriPage() {
  const supabase = createClient();
  const { data: agenti } = await supabase
    .from("agenti")
    .select("*")
    .order("nome");
  return <CantieriClient agenti={(agenti as any) ?? []} />;
}
