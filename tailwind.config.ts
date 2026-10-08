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
        // Palette allineata al logo SOLE: blu cobalto #005399 come colore
        // principale (brand-600), con giallo-sole come accento.
        brand: {
          50: "#e8f1f9",
          100: "#cfe3f3",
          200: "#a0c7e7",
          300: "#6ba7d8",
          400: "#2f82c4",
          500: "#0d67ad",
          600: "#005399",
          700: "#004a88",
          800: "#003d70",
          900: "#00305a",
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
