import type { Config } from "tailwindcss";

const config: Config = {
  darkMode: "class",
  content: [
    "./app/**/*.{js,ts,jsx,tsx,mdx}",
    "./components/**/*.{js,ts,jsx,tsx,mdx}",
  ],
  theme: {
    extend: {
      colors: {
        // Palette allineata al logo ENER.ING: arancio #F26700 (brand-500),
        // tono leggermente più scuro come colore principale (brand-600)
        // per avere buon contrasto con il testo bianco sui pulsanti.
        brand: {
          50: "#fff4eb",
          100: "#ffe4cc",
          200: "#ffc799",
          300: "#ffa25c",
          400: "#ff8526",
          500: "#f26700",
          600: "#d65b00",
          700: "#b24c00",
          800: "#8c3c00",
          900: "#6b2e00",
        },
        sole: {
          400: "#ffd43b",
          500: "#fac707",
          600: "#e0b000",
        },
      },
    },
  },
  plugins: [],
};

export default config;
