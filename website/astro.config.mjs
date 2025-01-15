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
        src: "./public/logo.svg",
      },
      customCss: ["./src/styles/custom.css"],
      expressiveCode: {
        themes: [myTheme],
      },
      components: {
        Head: "./src/components/Head.astro",
        Footer: "./src/components/Footer.astro",
        SocialIcons: "./src/components/SocialIcons.astro",
        Search: "./src/components/Search.astro",
        SiteTitle: "./src/components/SiteTitle.astro",
        ThemeProvider: "./src/components/ThemeProvider.astro",
        ThemeSelect: "./src/components/ThemeSelect.astro",
      },
      defaultLocale: "root",
      locales: {
        root: {
          label: "English",
          lang: "en",
        },
        es: {
          label: "Español",
          lang: "es",
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
          label: "Hooks",
          translations: {
            es: "Hooks",
          },
          autogenerate: {
            directory: "hooks",
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
          label: "Widgets",
          badge: "Flutter",
          translations: {
            es: "Widgets",
          },
          autogenerate: {
            directory: "widgets",
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
          label: "Extensions",
          badge: "Flutter",
          translations: {
            es: "Extensiones",
          },
          autogenerate: {
            directory: "extensions",
          },
        },
        {
          label: "Extra topics",
          translations: {
            es: "Temas adicionales",
          },
          autogenerate: {
            directory: "extra_topics",
          },
        },
      ],
    }),
    tailwind(),
    alpine(),
    icon(),
  ],
});
