// Piccoli helper di formattazione per l'interfaccia.

export function formatCurrency(value: number, currency = "EUR"): string {
  return new Intl.NumberFormat("it-IT", {
    style: "currency",
    currency,
    maximumFractionDigits: 0,
  }).format(value);
}

export function formatDate(value: string | null): string {
  if (!value) return "—";
  return new Intl.DateTimeFormat("it-IT", {
    day: "2-digit",
    month: "short",
    year: "numeric",
  }).format(new Date(value));
}

// "poco fa", "3 giorni fa", "2 mesi fa"…
export function timeAgo(value: string | null): string {
  if (!value) return "—";
  const d = new Date(value).getTime();
  const diff = Date.now() - d;
  const min = Math.floor(diff / 60000);
  if (min < 1) return "poco fa";
  if (min < 60) return `${min} ${min === 1 ? "minuto" : "minuti"} fa`;
  const ore = Math.floor(min / 60);
  if (ore < 24) return `${ore} ${ore === 1 ? "ora" : "ore"} fa`;
  const giorni = Math.floor(ore / 24);
  if (giorni < 30) return `${giorni} ${giorni === 1 ? "giorno" : "giorni"} fa`;
  const mesi = Math.floor(giorni / 30);
  if (mesi < 12) return `${mesi} ${mesi === 1 ? "mese" : "mesi"} fa`;
  const anni = Math.floor(mesi / 12);
  return `${anni} ${anni === 1 ? "anno" : "anni"} fa`;
}
