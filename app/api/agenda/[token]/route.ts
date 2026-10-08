import { createClient } from "@supabase/supabase-js";

export const dynamic = "force-dynamic";

function fmt(d: Date): string {
  return d.toISOString().replace(/[-:]/g, "").replace(/\.\d{3}/, "");
}
function esc(s: string | null): string {
  if (!s) return "";
  return s
    .replace(/\\/g, "\\\\")
    .replace(/;/g, "\\;")
    .replace(/,/g, "\\,")
    .replace(/\r?\n/g, "\\n");
}

export async function GET(
  _req: Request,
  { params }: { params: { token: string } }
) {
  const supabase = createClient(
    process.env.NEXT_PUBLIC_SUPABASE_URL!,
    process.env.NEXT_PUBLIC_SUPABASE_ANON_KEY!
  );

  const { data, error } = await supabase.rpc("agenda_feed", {
    p_token: params.token,
  });

  if (error) {
    return new Response("Errore", { status: 500 });
  }

  const now = fmt(new Date());
  const lines: string[] = [
    "BEGIN:VCALENDAR",
    "VERSION:2.0",
    "PRODID:-//CRM Team//Agenda//IT",
    "CALSCALE:GREGORIAN",
    "METHOD:PUBLISH",
    "X-WR-CALNAME:Agenda CRM",
  ];

  for (const r of (data as any[]) ?? []) {
    const inizio = new Date(r.inizio);
    const fine = r.fine
      ? new Date(r.fine)
      : new Date(inizio.getTime() + 60 * 60000);
    const titolo = r.cliente ? `${r.titolo} — ${r.cliente}` : r.titolo;
    lines.push(
      "BEGIN:VEVENT",
      `UID:${r.id}@crm-team`,
      `DTSTAMP:${now}`,
      `DTSTART:${fmt(inizio)}`,
      `DTEND:${fmt(fine)}`,
      `SUMMARY:${esc(titolo)}`,
      `LOCATION:${esc(r.luogo)}`,
      `DESCRIPTION:${esc(r.note)}`,
      "END:VEVENT"
    );
  }

  lines.push("END:VCALENDAR");
  const body = lines.join("\r\n");

  return new Response(body, {
    status: 200,
    headers: {
      "Content-Type": "text/calendar; charset=utf-8",
      "Content-Disposition": 'inline; filename="agenda.ics"',
      "Cache-Control": "public, max-age=300",
    },
  });
}
