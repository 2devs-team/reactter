import starlightPlugin from "@astrojs/starlight-tailwind";

const accent = {
  50: "#f0f9ff",
  100: "#e0f2fe",
  200: "#bae5fd",
  300: "#7ed2fb",
  400: "#2bb6f6",
  500: "#10a2e7",
  600: "#0382c6",
  700: "#0468a0",
  800: "#085884",
  900: "#0d496d",
  950: "#082e49",
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
