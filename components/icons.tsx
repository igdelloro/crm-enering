// Icone SVG lineari (stile Lucide) usate nel menu. Niente dipendenze:
// sono disegnate inline così restano leggere e nitide ovunque.
import type { SVGProps } from "react";

type P = SVGProps<SVGSVGElement>;

const base = {
  width: 20,
  height: 20,
  viewBox: "0 0 24 24",
  fill: "none",
  stroke: "currentColor",
  strokeWidth: 2,
  strokeLinecap: "round" as const,
  strokeLinejoin: "round" as const,
};

export function IconDashboard(p: P) {
  return (
    <svg {...base} {...p}>
      <rect x="3" y="3" width="7" height="9" rx="1" />
      <rect x="14" y="3" width="7" height="5" rx="1" />
      <rect x="14" y="12" width="7" height="9" rx="1" />
      <rect x="3" y="16" width="7" height="5" rx="1" />
    </svg>
  );
}

export function IconAgenda(p: P) {
  return (
    <svg {...base} {...p}>
      <rect x="3" y="4" width="18" height="18" rx="2" />
      <path d="M16 2v4M8 2v4M3 10h18" />
    </svg>
  );
}

export function IconClienti(p: P) {
  return (
    <svg {...base} {...p}>
      <path d="M3 21h18" />
      <path d="M5 21V7l8-4v18" />
      <path d="M19 21V11l-6-4" />
      <path d="M9 9v.01M9 12v.01M9 15v.01M9 18v.01" />
    </svg>
  );
}

export function IconRuoli(p: P) {
  return (
    <svg {...base} {...p}>
      <path d="M16 21v-2a4 4 0 0 0-4-4H6a4 4 0 0 0-4 4v2" />
      <circle cx="9" cy="7" r="4" />
      <path d="M22 21v-2a4 4 0 0 0-3-3.87M16 3.13a4 4 0 0 1 0 7.75" />
    </svg>
  );
}

export function IconPreventivi(p: P) {
  return (
    <svg {...base} {...p}>
      <path d="M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8z" />
      <path d="M14 2v6h6" />
      <path d="M8 13h8M8 17h8M8 9h2" />
    </svg>
  );
}

export function IconCantieri(p: P) {
  return (
    <svg {...base} {...p}>
      <path d="M2 20h20" />
      <path d="M4 20V8l8-5 8 5v12" />
      <rect x="9" y="12" width="6" height="8" />
      <path d="M9 8h.01M15 8h.01" />
    </svg>
  );
}

export function IconTicket(p: P) {
  return (
    <svg {...base} {...p}>
      <path d="M21 8V6a2 2 0 0 0-2-2H5a2 2 0 0 0-2 2v2a2 2 0 0 1 0 4v2a2 2 0 0 0 2 2h14a2 2 0 0 0 2-2v-2a2 2 0 0 1 0-4z" />
      <path d="M13 5v2M13 11v2M13 17v2" />
    </svg>
  );
}

export function IconCV(p: P) {
  return (
    <svg {...base} {...p}>
      <path d="M8 2a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h8a2 2 0 0 0 2-2V8l-6-6z" />
      <path d="M12 2v6h6" />
      <path d="m9 15 2 2 4-4" />
    </svg>
  );
}

export function IconPerformance(p: P) {
  return (
    <svg {...base} {...p}>
      <path d="M3 3v18h18" />
      <path d="m19 9-5 5-4-4-3 3" />
    </svg>
  );
}

export function IconProvvigioni(p: P) {
  return (
    <svg {...base} {...p}>
      <circle cx="12" cy="12" r="9" />
      <path d="M14.5 9a2.5 2 0 0 0-2.5-1.5c-1.4 0-2.5.7-2.5 2s1.1 1.7 2.5 2 2.5.7 2.5 2-1.1 2-2.5 2A2.5 2 0 0 1 9.5 15" />
      <path d="M12 6v1.5M12 16.5V18" />
    </svg>
  );
}

export function IconPA(p: P) {
  return (
    <svg {...base} {...p}>
      <path d="m12 3 9 4H3l9-4z" />
      <path d="M4 10h16" />
      <path d="M6 10v8M10 10v8M14 10v8M18 10v8" />
      <path d="M3 21h18" />
    </svg>
  );
}

export function IconPrivati(p: P) {
  return (
    <svg {...base} {...p}>
      <rect x="4" y="3" width="16" height="18" rx="1" />
      <path d="M9 21v-5h6v5" />
      <path d="M8 7h.01M12 7h.01M16 7h.01M8 11h.01M12 11h.01M16 11h.01" />
    </svg>
  );
}

export function IconBacheca(p: P) {
  return (
    <svg {...base} {...p}>
      <path d="m3 11 18-5v12L3 14v-3z" />
      <path d="M11.6 16.8a3 3 0 1 1-5.8-1.6" />
    </svg>
  );
}

export function IconSuggerimenti(p: P) {
  return (
    <svg {...base} {...p}>
      <path d="M9 18h6" />
      <path d="M10 22h4" />
      <path d="M15.09 14c.18-.98.65-1.74 1.41-2.5A4.65 4.65 0 0 0 18 8 6 6 0 0 0 6 8c0 1 .23 2.23 1.5 3.5A4.61 4.61 0 0 1 8.91 14" />
    </svg>
  );
}
