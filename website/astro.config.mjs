import { defineConfig } from "astro/config";
import starlight from "@astrojs/starlight";
import tailwind from "@astrojs/tailwind";
import alpine from "@astrojs/alpinejs";
import icon from "astro-icon";
import { ExpressiveCodeTheme } from "@astrojs/starlight/expressive-code";
import fs from "node:fs";

const jsoncString = fs.readFileSync(
  new URL(`./custom-theme.jsonc`, import.meta.url),
  "utf-8"
);
const myTheme = ExpressiveCodeTheme.fromJSONString(jsoncString);

// https://astro.build/config
export default defineConfig({
  site: "https://2devs-team.github.io",
  base: "reactter",
  integrations: [
    starlight({
      title: "Reactter",
      editLink: {
        baseUrl: "https://github.com/2devs-team/reactter/blob/master/website/",
      },
      logo: {
        src: "./src/assets/reactter.svg",
      },
      customCss: ["./src/styles/custom.css"],
      defaultLocale: "root",
      expressiveCode: {
        themes: [myTheme],
      },
      components: {
        Search: "./src/components/Search.astro",
        SiteTitle: "./src/components/SiteTitle.astro",
        ThemeProvider: "./src/components/ThemeProvider.astro",
        ThemeSelect: "./src/components/ThemeSelect.astro",
      },
      locales: {
        root: {
          label: "English",
          lang: "en",
        },
        es: {
          label: "Español",
        },
      },
      social: {
        github: "https://github.com/2devs-team/reactter",
      },
      sidebar: [
        {
          label: "Start here",
          translations: {
            es: "Comienza aquí",
          },
          items: [
            {
              label: "Overview",
              link: "/overview",
              translations: {
                es: "Introducción",
              },
            },
            {
              label: "Getting Started",
              link: "/getting_started",
              translations: {
                es: "Empezando",
              },
            },
          ],
        },
        {
          label: "Core Concepts",
          translations: {
            es: "Conceptos básicos",
          },
          autogenerate: {
            directory: "core_concepts",
          },
        },
        {
          label: "Classes",
          translations: {
            es: "Clases",
          },
          autogenerate: {
            directory: "classes",
          },
        },
        {
          label: "Hooks",
          translations: {
            es: "Hooks",
          },
          autogenerate: {
            directory: "hooks",
          },
        },
        {
          label: "Methods",
          translations: {
            es: "Métodos",
          },
          autogenerate: {
            directory: "methods",
          },
        },
        {
          label: "Widgets",
          badge: "flutter",
          translations: {
            es: "Widgets",
          },
          autogenerate: {
            directory: "widgets",
          },
        },
        {
          label: "Extensions",
          badge: "flutter",
          translations: {
            es: "Extensiones",
          },
          autogenerate: {
            directory: "extensions",
          },
        },
        {
          label: "Learn More",
          translations: {
            es: "Aprende más",
          },
          autogenerate: {
            directory: "learn_more",
          },
        },
      ],
    }),
    tailwind(),
    alpine(),
    icon(),
  ],
});
