import { createClient } from "@/lib/supabase/server";
import SuggerimentiClient from "./SuggerimentiClient";

export const dynamic = "force-dynamic";

export default async function SuggerimentiPage() {
  const supabase = createClient();

  const [{ data: suggerimenti }, { data: canManage }] = await Promise.all([
    supabase
      .from("suggerimenti")
      .select("*")
      .order("created_at", { ascending: false }),
    supabase.rpc("puo_gestire"),
  ]);

  return (
    <SuggerimentiClient
      suggerimenti={(suggerimenti as any) ?? []}
      canManage={canManage === true}
    />
  );
}
