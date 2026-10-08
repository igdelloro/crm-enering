import { createClient } from "@/lib/supabase/server";
import BachecaClient from "./BachecaClient";

export const dynamic = "force-dynamic";

export default async function BachecaPage() {
  const supabase = createClient();

  const [{ data: annunci }, { data: canManage }] = await Promise.all([
    supabase
      .from("annunci")
      .select("*")
      .order("created_at", { ascending: false }),
    supabase.rpc("puo_gestire"),
  ]);

  return (
    <BachecaClient
      annunci={(annunci as any) ?? []}
      canManage={canManage === true}
    />
  );
}
