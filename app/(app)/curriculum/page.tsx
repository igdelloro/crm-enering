import { createClient } from "@/lib/supabase/server";
import CurriculumClient from "./CurriculumClient";

export const dynamic = "force-dynamic";

export default async function CurriculumPage() {
  const supabase = createClient();
  const { data } = await supabase
    .from("cantieri")
    .select("*, preventivi(numero, categoria), companies(name, citta, provincia)")
    .eq("in_cv", true)
    .order("updated_at", { ascending: false });

  return <CurriculumClient lavori={(data as any) ?? []} />;
}
