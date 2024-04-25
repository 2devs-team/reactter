import starlightPlugin from "@astrojs/starlight-tailwind";
import colors from "tailwindcss/colors";

const accent = {
  50: "#f0f9ff",
  100: "#d0e7ff",
  200: "#92d1fe",
  300: "#6abfff",
  400: "#4ea3e0",
  500: "#0073aa",
  600: "#0073aa",
  700: "#005a84",
  800: "#004366",
  900: "#003653",
  950: "#00273d",
};
const gray = {
  100: "#f4f7fa",
  200: "#e9eef4",
  300: "#bcc3ca",
  400: "#808d9a",
  500: "#4d5a66",
  700: "#2e3a45",
  800: "#1d2833",
  900: "#14191e",
};

/** @type {import('tailwindcss').Config} */
export default {
  content: ["./src/**/*.{astro,html,js,jsx,md,mdx,svelte,ts,tsx,vue}"],
  theme: {
    extend: {
      colors: {
        accent,
        gray,
      },
      fontFamily: {
        sans: ['"Atkinson Hyperlegible"'],
        mono: ['"IBM Plex Mono"'],
      },
    },
  },
  plugins: [starlightPlugin()],
};
