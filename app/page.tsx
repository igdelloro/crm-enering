import { redirect } from "next/navigation";

// La radice reindirizza alla dashboard. Il middleware manderà al login
// chi non è autenticato.
export default function Home() {
  redirect("/dashboard");
}
