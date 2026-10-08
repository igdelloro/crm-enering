import { redirect } from "next/navigation";
import { createClient } from "@/lib/supabase/server";
import AppShell from "@/components/AppShell";

export default async function AppLayout({
  children,
}: {
  children: React.ReactNode;
}) {
  const supabase = createClient();
  const {
    data: { user },
  } = await supabase.auth.getUser();

  if (!user) redirect("/login");

  const { data: profile } = await supabase
    .from("profiles")
    .select("full_name, email, role, must_change_password")
    .eq("id", user.id)
    .single();

  // Cambio password obbligatorio al primo accesso
  if (profile?.must_change_password) {
    redirect("/cambia-password");
  }

  // Controllo accesso: ammesso se amministratore o presente/attivo in Ruoli
  const { data: puoAccedere } = await supabase.rpc("puo_accedere");
  if (puoAccedere === false) {
    redirect("/accesso-negato");
  }

  const userName = profile?.full_name || user.email || "Utente";
  const userEmail = profile?.email || user.email || "";

  // Permessi di gestione: legati ai TAG Ruoli (responsabile/amministratore)
  // oltre che al ruolo di login. Un'unica fonte di verità lato DB.
  const [{ data: canManage }, { data: isVenditore }] = await Promise.all([
    supabase.rpc("puo_gestire"),
    supabase.rpc("e_venditore"),
  ]);

  return (
    <AppShell
      userName={userName}
      userEmail={userEmail}
      canManage={canManage === true}
      isVenditore={isVenditore === true}
    >
      {children}
    </AppShell>
  );
}
