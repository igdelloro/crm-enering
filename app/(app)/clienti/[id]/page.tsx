import { notFound } from "next/navigation";
import { createClient } from "@/lib/supabase/server";
import ClientDetailClient from "./ClientDetailClient";

export const dynamic = "force-dynamic";

export default async function SchedaClientePage({
  params,
}: {
  params: { id: string };
}) {
  const supabase = createClient();

  const [
    { data: client },
    { data: eventi },
    { data: preventivi },
    { data: agenti },
    { data: canManage },
  ] = await Promise.all([
    supabase.from("companies").select("*").eq("id", params.id).single(),
    supabase
      .from("eventi")
      .select("*, profiles(full_name, email)")
      .eq("company_id", params.id)
      .order("data", { ascending: false })
      .order("created_at", { ascending: false }),
    supabase
      .from("preventivi")
      .select("*")
      .eq("company_id", params.id)
      .order("created_at", { ascending: false }),
    supabase.from("agenti").select("*").order("nome"),
    supabase.rpc("puo_gestire"),
  ]);

  if (!client) notFound();

  return (
    <ClientDetailClient
      client={client as any}
      eventi={(eventi as any) ?? []}
      preventivi={(preventivi as any) ?? []}
      agenti={(agenti as any) ?? []}
      canManage={canManage === true}
    />
  );
}
